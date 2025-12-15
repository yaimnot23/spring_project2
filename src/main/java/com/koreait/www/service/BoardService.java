package com.koreait.www.service;

import java.util.List;
import com.koreait.www.domain.BoardVO;
import com.koreait.www.domain.Criteria;

public interface BoardService {
    
    // 글 등록
    void register(BoardVO board);
    
    // 글 상세 조회 (조회수 로직 포함)
    BoardVO get(Long bno, String readerId);
    
    // 글 수정 (삭제할 파일 목록 파라미터 추가)
    boolean modify(BoardVO board, List<String> removeFiles);
    
    // 글 삭제
    boolean remove(Long bno);
    
    // 전체 목록 조회
    List<BoardVO> getList(Criteria cri);
    
    int getTotal(Criteria cri);
    
    BoardVO getPrev(Long bno);
    BoardVO getNext(Long bno);
}