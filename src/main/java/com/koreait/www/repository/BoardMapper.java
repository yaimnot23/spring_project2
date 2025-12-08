package com.koreait.www.repository;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.koreait.www.domain.BoardVO;
import com.koreait.www.domain.Criteria;

public interface BoardMapper {

	List<BoardVO> getList(Criteria cri);
	
	int getTotalCount(Criteria cri);
	
	// 2. 게시글 등록
	void insertSelectKey(BoardVO board);
	
	// 3. 게시글 상세 조회
	BoardVO read(Long bno);
	
	// 4. 게시글 삭제
	int delete(Long bno);
	
	// 5. 게시글 수정
	int update(BoardVO board);
	
	// 1. 조회수 증가
    void updateReadCount(Long bno);

    // 2. 조회 기록 남기기 (성공 시 1, 이미 본 글이면 에러 발생 -> 0 처리 예정)
    int insertReadLog(@Param("bno") Long bno, @Param("readerId") String readerId);
    
    // 3. 조회 기록 확인 (이미 봤는지 체크)
    int checkReadLog(@Param("bno") Long bno, @Param("readerId") String readerId);
}