package com.koreait.www.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.regex.Pattern;

import javax.servlet.http.HttpSession;

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
import com.koreait.www.domain.MemberVO;
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
	
	// [설정] 실제 저장될 물리 경로 (D드라이브)
	private final String UPLOAD_ROOT = "D:\\.Spotlight-V100\\some_nec_downloads\\spring\\spring2_saveuploadfiles";

	// [설정] 업로드 금지 확장자 (정규표현식)
	// exe, sh, zip, js 등을 막음
	private static final String RESTRICT_REGEX = ".*\\.(exe|sh|bat|cmd|msi|jar|js|jsp|php|zip|alz)$";
	
	// [설정] 최대 허용 파일 크기 (20MB)
	private static final long MAX_FILE_SIZE = 20L * 1024 * 1024; // 20,971,520 Byte

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
						   RedirectAttributes rttr) {
		
		log.info("register 등록 요청 발생");
		
		List<FileVO> fileList = new ArrayList<>();
		Tika tika = new Tika(); // 파일 분석용 객체
		
		for(MultipartFile multipartFile : uploadFiles) {
			
			// 1. 빈 파일이거나, 검증(크기, 확장자)에 실패하면 건너뜀
			if(multipartFile.isEmpty() || !isValidFile(multipartFile)) {
				continue; 
			}
			
			FileVO fileVO = new FileVO();
			
			// 파일명 추출 및 보정
			String originalFileName = multipartFile.getOriginalFilename();
			originalFileName = originalFileName.substring(originalFileName.lastIndexOf("\\") + 1);
			
			fileVO.setFileName(originalFileName);
			fileVO.setFileSize(multipartFile.getSize());
			
			// UUID 생성
			UUID uuid = UUID.randomUUID();
			fileVO.setUuid(uuid.toString());
			
			try {
				// 2. Tika를 이용한 실제 데이터 분석 (확장자 위조 방지)
				String mimeType = tika.detect(multipartFile.getInputStream());
				log.info("Detected MIME Type: " + mimeType);
				
				// [보안] 실행 파일류(MIME Type)가 감지되면 저장하지 않고 건너뜀
				if(mimeType != null && (
				   mimeType.contains("application/x-msdownload") || 
				   mimeType.contains("application/x-sh") ||
				   mimeType.contains("application/java-archive"))) {
					
					log.warn("실행 파일(MIME) 감지되어 업로드 차단: " + originalFileName);
					continue;
				}
				
				// 3. 폴더 분류 (image, video, others)
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
				
				// 4. 저장 폴더 생성 및 파일 저장
				File uploadPath = new File(UPLOAD_ROOT, folderName);
				if (!uploadPath.exists()) {
					uploadPath.mkdirs();
				}
				
				String saveFileName = uuid.toString() + "_" + originalFileName;
				File saveFile = new File(uploadPath, saveFileName);
				multipartFile.transferTo(saveFile);
				
				// 5. 이미지라면 썸네일 생성
				if (isImage) {
					File thumbnailFile = new File(uploadPath, "s_" + saveFileName);
					Thumbnails.of(saveFile)
							  .size(100, 100)
							  .toFile(thumbnailFile);
				}
				
				// 리스트에 추가
				fileList.add(fileVO);
				
			} catch (Exception e) {
				log.error("파일 업로드 중 에러: " + e.getMessage());
			}
		}
		
		// BoardVO에 파일 정보 담고 서비스 호출
		board.setAttachList(fileList);
		service.register(board);
		
		rttr.addFlashAttribute("result", board.getBno());
		return "redirect:/board/list";
	}
	
	// [검증 메서드] 파일 크기 및 확장자 체크
	private boolean isValidFile(MultipartFile file) {
		
		// 1. 용량 체크 (20MB 초과 시 차단)
		if (file.getSize() > MAX_FILE_SIZE) {
			log.warn("파일 크기 초과 (20MB 제한): " + file.getOriginalFilename());
			return false;
		}
		
		// 2. 확장자 체크 (정규표현식)
		String fileName = file.getOriginalFilename();
		if (Pattern.matches(RESTRICT_REGEX, fileName.toLowerCase())) {
			log.warn("업로드 금지된 확장자: " + fileName);
			return false;
		}
		
		return true;
	}
	
	// 상세 조회 및 수정 페이지
	@GetMapping({"/get", "/modify"})
    public void get(@RequestParam("bno") Long bno, Model model, HttpSession session) {
        MemberVO member = (MemberVO) session.getAttribute("member");
        String readerId = null;
        if(member != null) {
            readerId = member.getId();
        }
        model.addAttribute("board", service.get(bno, readerId));
    }
	
	// 수정 처리
	@PostMapping("/modify")
	public String modify(BoardVO board, RedirectAttributes rttr) {
		if (service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}
		return "redirect:/board/list";
	}
	
	// 삭제 처리
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, RedirectAttributes rttr) {
		if (service.remove(bno)) {
			rttr.addFlashAttribute("result", "success");
		}
		return "redirect:/board/list";
	}

}