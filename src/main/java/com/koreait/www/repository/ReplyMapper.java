package com.koreait.www.repository;

import java.util.List;
import com.koreait.www.domain.ReplyVO;

public interface ReplyMapper {
    public int insert(ReplyVO vo);
    public ReplyVO read(Long rno);
    public int delete(Long rno);
    public int update(ReplyVO reply);
    public List<ReplyVO> getList(Long bno);
}