package com.koreait.www.service;

import java.util.List;
import org.springframework.stereotype.Service;
import com.koreait.www.domain.ReplyVO;
import com.koreait.www.repository.ReplyMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class ReplyServiceImpl implements ReplyService {

    private final ReplyMapper mapper;

    @Override
    public int register(ReplyVO vo) {
        log.info("register......" + vo);
        return mapper.insert(vo);
    }

    @Override
    public ReplyVO get(Long rno) {
        log.info("get......" + rno);
        return mapper.read(rno);
    }

    @Override
    public int modify(ReplyVO vo) {
        log.info("modify......" + vo);
        return mapper.update(vo);
    }

    @Override
    public int remove(Long rno) {
        log.info("remove......" + rno);
        return mapper.delete(rno);
    }

    @Override
    public List<ReplyVO> getList(Long bno) {
        log.info("get Reply List of a Board " + bno);
        return mapper.getList(bno);
    }
}