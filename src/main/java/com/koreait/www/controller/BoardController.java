package com.koreait.www.controller;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Pattern;



import org.apache.tika.Tika;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.koreait.www.domain.BoardVO;
import com.koreait.www.domain.Criteria;
import com.koreait.www.domain.FileVO;
import com.koreait.www.domain.PageDTO;
import com.koreait.www.service.BoardService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.coobird.thumbnailator.Thumbnails;

@Controller
@Slf4j
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardController {

	private final BoardService service;
	
	// [설정] 실제 저장 경로
	private final String UPLOAD_ROOT = "D:\\.Spotlight-V100\\some_nec_downloads\\spring\\spring2_saveuploadfiles";

	private static final String RESTRICT_REGEX = ".*\\.(exe|sh|bat|cmd|msi|jar|js|jsp|php|zip|alz)$";
	private static final long MAX_FILE_SIZE = 20L * 1024 * 1024; 

	@GetMapping("/list")
    public void list(Criteria cri, Model model) {
        model.addAttribute("list", service.getList(cri));
        int total = service.getTotal(cri);
        model.addAttribute("pageMaker", new PageDTO(cri, total));
    }
    
    @GetMapping(value = "/list_ajax", produces = org.springframework.http.MediaType.APPLICATION_JSON_VALUE)
    @org.springframework.web.bind.annotation.ResponseBody
    public java.util.Map<String, Object> listAjax(Criteria cri) {
        java.util.Map<String, Object> map = new java.util.HashMap<>();
        map.put("list", service.getList(cri));
        map.put("pageMaker", new PageDTO(cri, service.getTotal(cri)));
        return map;
    }
	
	@GetMapping("/register")
	public void register() {
		log.info("register 페이지 이동");
	}
	
	@PostMapping("/register")
	public String register(BoardVO board, 
						   @RequestParam("uploadFiles") MultipartFile[] uploadFiles, 
						   java.security.Principal principal,
						   RedirectAttributes rttr) {
		
		if (principal != null) {
			board.setWriter(principal.getName()); // 안전하게 서버 측에서 작성자 설정
		}
		
		log.info("register 등록 요청");
		List<FileVO> fileList = processUpload(uploadFiles);
		board.setAttachList(fileList);
		service.register(board);
		
		rttr.addFlashAttribute("result", board.getBno());
		return "redirect:/board/list";
	}
	
	@GetMapping({"/get", "/modify"})
    public String get(@RequestParam("bno") Long bno, Model model, java.security.Principal principal, 
                    javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) {
        
        String readerId = null;
        
        if(principal != null) {
            readerId = principal.getName(); // email
        } else {
            // 비회원: 쿠키 확인
            javax.servlet.http.Cookie[] cookies = request.getCookies();
            if(cookies != null) {
                for(javax.servlet.http.Cookie c : cookies) {
                    if(c.getName().equals("view_cookie")) {
                        readerId = c.getValue();
                        break;
                    }
                }
            }
            // 쿠키가 없으면 새로 생성 (24시간 유지)
            if(readerId == null) {
                readerId = UUID.randomUUID().toString();
                javax.servlet.http.Cookie newCookie = new javax.servlet.http.Cookie("view_cookie", readerId);
                newCookie.setPath("/");
                newCookie.setMaxAge(60 * 60 * 24); 
                response.addCookie(newCookie);
            }
        }
        
        model.addAttribute("board", service.get(bno, readerId));
        // [Prev/Next Navigation] 이전글/다음글 추가
        model.addAttribute("prevBoard", service.getPrev(bno));
        model.addAttribute("nextBoard", service.getNext(bno));
        
        // [Ghost Mode] 비밀글 체크
        BoardVO vo = (BoardVO) model.getAttribute("board");
        if(vo != null && vo.isSecret()) {
            boolean isAuthorized = false;
            // 1. 작성자 본인 확인
            if(readerId != null && readerId.equals(vo.getWriter())) { // writer가 email/id라고 가정
               isAuthorized = true;
            }
            // 2. 관리자 확인
            if(request.isUserInRole("ROLE_ADMIN")) {
               isAuthorized = true;
            }
            // 3. 세션(비밀번호 인증) 확인
            Boolean unlocked = (Boolean) request.getSession().getAttribute("unlocked_" + bno);
            if(unlocked != null && unlocked) {
               isAuthorized = true;
            }
            
            if(!isAuthorized) {
                vo.setContent(null); // 내용 숨김
                model.addAttribute("locked", true);
            }
        }
        
        return "/board/get";
    }
    
    // [Ghost Mode] 비밀번호 확인
    @PostMapping(value = "/unlock", produces = "application/json")
    @org.springframework.web.bind.annotation.ResponseBody
    public java.util.Map<String, Boolean> unlock(@RequestBody java.util.Map<String, String> params, javax.servlet.http.HttpSession session) {
        Long bno = Long.parseLong(params.get("bno"));
        String password = params.get("password");
        
        BoardVO vo = service.get(bno, null);
        boolean success = vo != null && vo.getPassword() != null && vo.getPassword().equals(password);
        
        if(vo == null) {
        	System.out.println("DEBUG: Service returned NULL for bno: " + bno);
        }
        
        java.util.Map<String, Boolean> result = new java.util.HashMap<>();
        result.put("success", success);
        return result;
    }
	
	// 파일 업로드와 삭제 요청을 동시에 처리
	@PostMapping("/modify")
	public String modify(BoardVO board, 
						 @RequestParam("uploadFiles") MultipartFile[] uploadFiles,
						 @RequestParam(value = "removeFiles", required = false) List<String> removeFiles,
						 java.security.Principal principal,
						 javax.servlet.http.HttpServletRequest request,
						 RedirectAttributes rttr) {
		
		// 1. 유효성 검사 (로그인 여부)
		if (principal == null) {
			return "redirect:/member/login";
		}
		
		// 2. 권한 검사 (작성자 또는 관리자만 수정 가능)
		// DB에서 기존 게시글 정보 가져오기 (조회수 증가 없이)
		BoardVO original = service.get(board.getBno(), null);
		
		if (original == null) {
			return "redirect:/board/list";
		}
		
		String username = principal.getName();
		boolean isWriter = original.getWriter().equals(username);
		boolean isAdmin = request.isUserInRole("ROLE_ADMIN");
		
		if (!isWriter && !isAdmin) {
			rttr.addFlashAttribute("result", "unauthorized");
			return "redirect:/board/list";
		}
		
		log.info("modify 요청: " + board);
		
		// 1. 신규 파일 업로드
		List<FileVO> fileList = processUpload(uploadFiles);
		if(!fileList.isEmpty()) {
			board.setAttachList(fileList);
		}

		// 2. 서비스 호출 (삭제할 파일 목록도 함께 전달)
		if (service.modify(board, removeFiles)) {
			rttr.addFlashAttribute("result", "success");
		}
		return "redirect:/board/list";
	}
	
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, 
						 java.security.Principal principal,
						 javax.servlet.http.HttpServletRequest request,
						 RedirectAttributes rttr) {
		
		// 1. 유효성 검사 (로그인 여부)
		if (principal == null) {
			return "redirect:/member/login";
		}
		
		// 2. 권한 검사 (작성자 또는 관리자만 삭제 가능)
		BoardVO original = service.get(bno, null);
		
		if (original == null) {
			return "redirect:/board/list";
		}
		
		String username = principal.getName();
		boolean isWriter = original.getWriter().equals(username);
		boolean isAdmin = request.isUserInRole("ROLE_ADMIN");
		
		if (!isWriter && !isAdmin) {
			rttr.addFlashAttribute("result", "unauthorized");
			return "redirect:/board/list";
		}
		
		if (service.remove(bno)) {
			rttr.addFlashAttribute("result", "success");
		}
		return "redirect:/board/list";
	}

	// [공통 메서드] 파일 업로드 처리
	private List<FileVO> processUpload(MultipartFile[] uploadFiles) {
		List<FileVO> fileList = new ArrayList<>();
		Tika tika = new Tika();
		
		for(MultipartFile multipartFile : uploadFiles) {
			if(multipartFile.isEmpty() || !isValidFile(multipartFile)) {
				continue; 
			}
			
			FileVO fileVO = new FileVO();
			String originalFileName = multipartFile.getOriginalFilename();
			originalFileName = originalFileName.substring(originalFileName.lastIndexOf("\\") + 1);
			
			fileVO.setFileName(originalFileName);
			fileVO.setFileSize(multipartFile.getSize());
			
			UUID uuid = UUID.randomUUID();
			fileVO.setUuid(uuid.toString());
			
			try {
				String mimeType = tika.detect(multipartFile.getInputStream());
				
				if(mimeType != null && (
				   mimeType.contains("application/x-msdownload") || 
				   mimeType.contains("application/x-sh") ||
				   mimeType.contains("application/java-archive"))) {
					log.warn("실행 파일 감지됨: " + originalFileName);
					continue;
				}
				
				String folderName = "others";
				boolean isImage = false;
				
				if (mimeType.startsWith("image")) {
					folderName = "image";
					isImage = true;
				} else if (mimeType.startsWith("video")) {
					folderName = "video";
				}
				
				fileVO.setUploadPath(folderName);
				fileVO.setFileType(isImage);
				
				File uploadPath = new File(UPLOAD_ROOT, folderName);
				if (!uploadPath.exists()) {
					uploadPath.mkdirs();
				}
				
				String saveFileName = uuid.toString() + "_" + originalFileName;
				File saveFile = new File(uploadPath, saveFileName);
				multipartFile.transferTo(saveFile);
				
				if (isImage) {
					File thumbnailFile = new File(uploadPath, "s_" + saveFileName);
					Thumbnails.of(saveFile)
							  .size(100, 100)
							  .toFile(thumbnailFile);
				}
				
				fileList.add(fileVO);
				
			} catch (Exception e) {
				log.error("파일 업로드 에러: " + e.getMessage());
			}
		}
		return fileList;
	}
	
	private boolean isValidFile(MultipartFile file) {
		if (file.getSize() > MAX_FILE_SIZE) return false;
		String fileName = file.getOriginalFilename();
		return !Pattern.matches(RESTRICT_REGEX, fileName.toLowerCase());
	}
}