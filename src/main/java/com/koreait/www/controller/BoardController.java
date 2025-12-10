package com.koreait.www.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

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
    
    // [중요] 사용자가 지정한 물리적 저장 경로
    private final String UPLOAD_ROOT = "D:\\.Spotlight-V100\\some_nec_downloads\\spring\\spring2_saveuploadfiles";

    // 목록 조회
    @GetMapping("/list")
    public void list(Criteria cri, Model model) {
        log.info("list: " + cri);
        model.addAttribute("list", service.getList(cri));
        int total = service.getTotal(cri);
        model.addAttribute("pageMaker", new PageDTO(cri, total));
    }
    
    // 글쓰기 페이지 이동
    @GetMapping("/register")
    public void register() {
        log.info("register page");
    }
    
    // 글 등록 처리 (파일 업로드 포함)
    @PostMapping("/register")
    public String register(BoardVO board, 
                           @RequestParam("uploadFiles") MultipartFile[] uploadFiles, 
                           RedirectAttributes rttr) {
        
        log.info("register processing...");
        
        List<FileVO> fileList = new ArrayList<>();
        Tika tika = new Tika(); // 파일 분석용 객체 생성
        
        for(MultipartFile multipartFile : uploadFiles) {
            // 파일이 비어있으면 건너뜀
            if(multipartFile.isEmpty()) {
                continue;
            }
            
            FileVO fileVO = new FileVO();
            
            // 1. 원본 파일명 추출 및 보정
            String originalFileName = multipartFile.getOriginalFilename();
            // IE 등의 브라우저에서 경로가 포함되어 들어올 경우 파일명만 추출
            originalFileName = originalFileName.substring(originalFileName.lastIndexOf("\\") + 1);
            
            fileVO.setFileName(originalFileName);
            fileVO.setFileSize(multipartFile.getSize());
            
            // 2. UUID 생성
            UUID uuid = UUID.randomUUID();
            fileVO.setUuid(uuid.toString());
            
            try {
                // 3. Tika 라이브러리를 이용한 MIME 타입 감지
                // (확장자가 아닌 실제 파일 내용을 분석)
                String mimeType = tika.detect(multipartFile.getInputStream());
                log.info("Detected Type: " + mimeType);
                
                // 4. 저장할 폴더 분류 (image / video / others)
                String folderName = "others"; // 기본값
                boolean isImage = false;
                
                if (mimeType.startsWith("image")) {
                    folderName = "image";
                    isImage = true;
                } else if (mimeType.startsWith("video")) {
                    folderName = "video";
                }
                
                // DB 저장을 위해 VO에 분류 정보 세팅
                fileVO.setUploadPath(folderName);
                fileVO.setFileType(isImage);
                
                // 5. 실제 저장 경로 생성 (ROOT + 분류폴더)
                File uploadPath = new File(UPLOAD_ROOT, folderName);
                
                // 해당 폴더가 없으면 생성
                if (!uploadPath.exists()) {
                    uploadPath.mkdirs();
                }
                
                // 6. 파일 저장 (UUID_원본명)
                String saveFileName = uuid.toString() + "_" + originalFileName;
                File saveFile = new File(uploadPath, saveFileName);
                multipartFile.transferTo(saveFile);
                
                // 7. 이미지인 경우 썸네일 생성 (s_UUID_원본명)
                if (isImage) {
                    File thumbnailFile = new File(uploadPath, "s_" + saveFileName);
                    Thumbnails.of(saveFile)
                              .size(100, 100)
                              .toFile(thumbnailFile);
                }
                
                // 리스트에 추가
                fileList.add(fileVO);
                
            } catch (Exception e) {
                log.error("File Upload Error: " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        // BoardVO에 파일 리스트 담기
        board.setAttachList(fileList);
        
        // Service 호출 (DB 저장)
        service.register(board);
        
        rttr.addFlashAttribute("result", board.getBno());
        
        return "redirect:/board/list";
    }
    
    // 상세 조회 및 수정 페이지 이동
    @GetMapping({"/get", "/modify"})
    public void get(@RequestParam("bno") Long bno, Model model, HttpSession session) {
        log.info("/get or /modify");
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
        log.info("modify: " + board);
        if (service.modify(board)) {
            rttr.addFlashAttribute("result", "success");
        }
        return "redirect:/board/list";
    }

    // 삭제 처리
    @PostMapping("/remove")
    public String remove(@RequestParam("bno") Long bno, RedirectAttributes rttr) {
        log.info("remove: " + bno);
        if (service.remove(bno)) {
            rttr.addFlashAttribute("result", "success");
        }
        return "redirect:/board/list";
    }
}