package com.koreait.www.service;

import java.io.File;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreait.www.domain.BoardVO;
import com.koreait.www.domain.Criteria;
import com.koreait.www.domain.FileVO;
import com.koreait.www.repository.BoardMapper;
import com.koreait.www.repository.FileMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class BoardServiceImpl implements BoardService {

    private final BoardMapper mapper;
    private final FileMapper fileMapper;
    
    // [설정] 파일 저장 경로 (Controller와 동일하게 맞춰주세요)
    private final String UPLOAD_ROOT = "D:\\.Spotlight-V100\\some_nec_downloads\\spring\\spring2_saveuploadfiles";

    @Transactional
    @Override
    public void register(BoardVO board) {
        log.info("register......" + board);
        mapper.insertSelectKey(board);
        
        if (board.getAttachList() == null || board.getAttachList().isEmpty()) {
            return;
        }
        
        for (FileVO attach : board.getAttachList()) {
            attach.setBno(board.getBno());
            fileMapper.insert(attach);
        }
    }

    @Override
    public BoardVO get(Long bno, String readerId) {
        log.info("get....." + bno);
        BoardVO board = mapper.read(bno);
        List<FileVO> fileList = fileMapper.findByBno(bno);
        board.setAttachList(fileList);
        return board;
    }

    @Transactional // [수정] 파일 삭제 및 등록 처리를 위한 트랜잭션
    @Override
    public boolean modify(BoardVO board, List<String> removeFiles) {
        log.info("modify......" + board);
        
        // 1. 사용자가 삭제 요청한 파일들 처리
        if (removeFiles != null && !removeFiles.isEmpty()) {
            for (String uuid : removeFiles) {
                // 실제 파일 삭제를 위해 정보 조회
                FileVO vo = fileMapper.findByUuid(uuid);
                if (vo != null) {
                    deleteFileFromDisk(vo); // HDD에서 삭제
                    fileMapper.delete(uuid); // DB에서 삭제
                }
            }
        }

        // 2. 게시글 내용 수정
        boolean modifyResult = mapper.update(board) == 1;
        
        // 3. 새로 업로드된 파일 등록
        if (modifyResult && board.getAttachList() != null && !board.getAttachList().isEmpty()) {
            for (FileVO attach : board.getAttachList()) {
                attach.setBno(board.getBno());
                fileMapper.insert(attach);
            }
        }
        
        return modifyResult;
    }
    
    // [헬퍼 메서드] 하드디스크의 실제 파일 삭제
    private void deleteFileFromDisk(FileVO vo) {
        try {
            String path = UPLOAD_ROOT + File.separator + vo.getUploadPath() + File.separator + vo.getUuid() + "_" + vo.getFileName();
            File file = new File(path);
            
            if (file.exists()) {
                file.delete();
            }
            
            if (vo.isFileType()) { // 이미지라면 썸네일도 삭제
                String thumbPath = UPLOAD_ROOT + File.separator + vo.getUploadPath() + File.separator + "s_" + vo.getUuid() + "_" + vo.getFileName();
                File thumb = new File(thumbPath);
                if (thumb.exists()) {
                    thumb.delete();
                }
            }
        } catch (Exception e) {
            log.error("파일 삭제 중 오류: " + e.getMessage());
        }
    }

    @Override
    public boolean remove(Long bno) {
        log.info("remove......" + bno);
        return mapper.delete(bno) == 1;
    }

    @Override
    public List<BoardVO> getList(Criteria cri) {
        log.info("getList......" + cri);
        return mapper.getList(cri);
    }
    
    @Override
    public int getTotal(Criteria cri) {
        return mapper.getTotalCount(cri);
    }
}