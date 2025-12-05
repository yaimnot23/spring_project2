package com.koreait.www.repository;

import java.util.List;
import com.koreait.www.domain.BoardVO;

public interface BoardMapper {

	// 1. 게시글 목록 조회
	List<BoardVO> getList();
	
	// 2. 게시글 등록 (등록된 글 번호를 알 필요가 있을 때 사용)
	void insertSelectKey(BoardVO board);
	
	// 3. 게시글 상세 조회
	BoardVO read(Long bno);
	
	// 4. 게시글 삭제
	int delete(Long bno);
	
	// 5. 게시글 수정
	int update(BoardVO board);
}