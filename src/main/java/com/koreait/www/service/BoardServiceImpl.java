package com.koreait.www.service;

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

    @Transactional // 게시글과 파일 정보는 같이 저장되어야 하므로 트랜잭션 처리
    @Override
    public void register(BoardVO board) {
        log.info("register......" + board);
        
        // 1. 게시글 DB 등록 (여기서 bno가 생성됨)
        mapper.insertSelectKey(board);
        
        // 2. 첨부파일이 없으면 여기서 종료
        if (board.getAttachList() == null || board.getAttachList().isEmpty()) {
            return;
        }
        
        // 3. 첨부파일 DB 등록
        for (FileVO attach : board.getAttachList()) {
            attach.setBno(board.getBno()); // 생성된 게시글 번호를 파일 VO에 주입
            fileMapper.insert(attach);     // 파일 테이블에 저장
        }
    }

    @Override
    public BoardVO get(Long bno, String readerId) {
        log.info("get....." + bno);
        
        // 1. 게시글 가져오기
        BoardVO board = mapper.read(bno);
        
        // 2. 게시글에 해당하는 파일 목록 가져오기
        List<FileVO> fileList = fileMapper.findByBno(bno);
        board.setAttachList(fileList);
        
        // 3. 조회수 로직 (기존 유지)
        if (readerId != null && !readerId.isEmpty()) {
             // ... 기존 조회수 로직 ...
        }
        
        return board;
    }

    @Override
    public boolean modify(BoardVO board) {
        log.info("modify......" + board);
        return mapper.update(board) == 1;
    }

    @Override
    public boolean remove(Long bno) {
        log.info("remove......" + bno);
        // DB에 ON DELETE CASCADE가 걸려있다면 파일 정보는 자동 삭제됨
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