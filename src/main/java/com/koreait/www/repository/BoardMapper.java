package com.koreait.www.repository;

import java.util.List;
import com.koreait.www.domain.BoardVO;
import com.koreait.www.domain.Criteria;

public interface BoardMapper {

	List<BoardVO> getList(Criteria cri);
	
	// 2. 게시글 등록
	void insertSelectKey(BoardVO board);
	
	// 3. 게시글 상세 조회
	BoardVO read(Long bno);
	
	// 4. 게시글 삭제
	int delete(Long bno);
	
	// 5. 게시글 수정
	int update(BoardVO board);
}