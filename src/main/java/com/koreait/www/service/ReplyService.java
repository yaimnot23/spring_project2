package com.koreait.www.service;

import java.util.List;
import com.koreait.www.domain.ReplyVO;

public interface ReplyService {
    public int register(ReplyVO vo);
    public ReplyVO get(Long rno);
    public int modify(ReplyVO vo);
    public int remove(Long rno);
    public List<ReplyVO> getList(Long bno);
}