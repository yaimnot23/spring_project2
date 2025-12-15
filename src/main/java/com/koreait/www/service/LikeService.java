package com.koreait.www.service;

public interface LikeService {
    // 좋아요 토글 (없으면 추가, 있으면 삭제) -> 결과: 1(용), 0(취소)
    int toggleLike(Long bno, String liker);
    
    // 좋아요 여부 확인
    boolean checkLike(Long bno, String liker);
}
