package com.koreait.www.controller;

import java.io.File;
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
						   RedirectAttributes rttr) {
		
		log.info("register 등록 요청");
		List<FileVO> fileList = processUpload(uploadFiles);
		board.setAttachList(fileList);
		service.register(board);
		
		rttr.addFlashAttribute("result", board.getBno());
		return "redirect:/board/list";
	}
	
	@GetMapping({"/get", "/modify"})
    public void get(@RequestParam("bno") Long bno, Model model, HttpSession session) {
        MemberVO member = (MemberVO) session.getAttribute("member");
        String readerId = null;
        if(member != null) {
            readerId = member.getId();
        }
        model.addAttribute("board", service.get(bno, readerId));
    }
	
	// [수정] 파일 업로드와 삭제 요청을 동시에 처리
	@PostMapping("/modify")
	public String modify(BoardVO board, 
						 @RequestParam("uploadFiles") MultipartFile[] uploadFiles,
						 @RequestParam(value = "removeFiles", required = false) List<String> removeFiles,
						 RedirectAttributes rttr) {
		
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