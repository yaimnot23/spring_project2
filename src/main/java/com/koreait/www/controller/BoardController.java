package com.koreait.www.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.regex.Pattern;



import org.apache.tika.Tika;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
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
    public void get(@RequestParam("bno") Long bno, Model model, java.security.Principal principal) {
        String readerId = null;
        if(principal != null) {
            readerId = principal.getName(); // email
        }
        model.addAttribute("board", service.get(bno, readerId));
    }
	
	// 파일 업로드와 삭제 요청을 동시에 처리
	@PostMapping("/modify")
	public String modify(BoardVO board, 
						 @RequestParam("uploadFiles") MultipartFile[] uploadFiles,
						 @RequestParam(value = "removeFiles", required = false) List<String> removeFiles,
						 java.security.Principal principal,
						 RedirectAttributes rttr) {
		
		if(principal != null) {
			// 수정 권한 체크 로직이 Service나 여기서 필요할 수 있음. 
			// 일단 작성자를 현재 유저로 덮어쓰거나 체크하는 로직이 있으면 좋지만, 기존 로직 유지하며 Principal 주입.
			// board.setWriter(principal.getName()); // 보통 수정 시 작성자를 바꾸진 않으므로 생략하거나 검증용.
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
	public String remove(@RequestParam("bno") Long bno, RedirectAttributes rttr) {
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