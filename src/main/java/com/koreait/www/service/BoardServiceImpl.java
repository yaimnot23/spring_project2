package com.koreait.www.service;

import java.util.List;
import org.springframework.stereotype.Service;
import com.koreait.www.domain.BoardVO;
import com.koreait.www.domain.Criteria; // import 필수!
import com.koreait.www.repository.BoardMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class BoardServiceImpl implements BoardService {

    private final BoardMapper mapper;

    @Override
    public void register(BoardVO board) {
        log.info("register" + board);
        mapper.insertSelectKey(board);
    }

    @Override
    public BoardVO get(Long bno, String readerId) {
        log.info("get....." + bno + " reader: " + readerId);
        
        // readerId가 있을 때만 (로그인 했을 때만) 조회수 로직 수행
        if (readerId != null && !readerId.isEmpty()) {
            // 1. 이 사람이 이 글을 본 적이 있는지 확인
            int count = mapper.checkReadLog(bno, readerId);
            
            // 2. 본 적이 없다면 (count == 0)
            if (count == 0) {
                // 기록을 남기고
                mapper.insertReadLog(bno, readerId);
                // 조회수를 올린다
                mapper.updateReadCount(bno);
            }
        }
        
        return mapper.read(bno);
    }

    @Override
    public boolean modify(BoardVO board) {
        log.info("modify" + board);
        return mapper.update(board) == 1;
    }

    @Override
    public boolean remove(Long bno) {
        log.info("remove" + bno);
        return mapper.delete(bno) == 1;
    }

    // Criteria를 받아서 mapper.getList(cri) 호출
    @Override
    public List<BoardVO> getList(Criteria cri) {
        log.info("getList with criteria: " + cri);
        return mapper.getList(cri);
    }
    
    @Override
    public int getTotal(Criteria cri) {
        return mapper.getTotalCount(cri);
    }
    

}