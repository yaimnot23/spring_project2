package com.koreait.www.service;

import java.util.List;
import com.koreait.www.domain.BoardVO;

public interface BoardService {
	
	// 글 등록
	void register(BoardVO board);
	
	// 글 상세 조회
	BoardVO get(Long bno);
	
	// 글 수정
	boolean modify(BoardVO board);
	
	// 글 삭제
	boolean remove(Long bno);
	
	// 전체 목록 조회
	List<BoardVO> getList();
}