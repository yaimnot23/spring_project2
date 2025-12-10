package com.koreait.www.repository;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.koreait.www.domain.BoardVO;
import com.koreait.www.domain.Criteria;

public interface BoardMapper {

    List<BoardVO> getList(Criteria cri);
    
    int getTotalCount(Criteria cri);
    
    // 게시글 등록
    void insertSelectKey(BoardVO board);
    
    // 게시글 상세 조회
    BoardVO read(Long bno);
    
    // 게시글 삭제
    int delete(Long bno);
    
    // 게시글 수정
    int update(BoardVO board);
    
    // [조회수 관련]
    void updateReadCount(Long bno);
    
    // 읽은 기록 남기기
    int insertReadLog(@Param("bno") Long bno, @Param("readerId") String readerId);
    
    // 읽은 기록 확인
    int checkReadLog(@Param("bno") Long bno, @Param("readerId") String readerId);
}