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
    public BoardVO get(Long bno) {
        log.info("get" + bno);
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

}