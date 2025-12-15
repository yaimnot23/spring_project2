package com.koreait.www.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreait.www.repository.LikeMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class LikeServiceImpl implements LikeService {

    private final LikeMapper mapper;

    @Transactional
    @Override
    public int toggleLike(Long bno, String liker) {
        int count = mapper.checkLike(bno, liker);
        
        if (count > 0) {
            // 이미 좋아요 누름 -> 취소
            mapper.delete(bno, liker);
            mapper.decreaseLikeCount(bno);
            return 0; // 취소됨
        } else {
            // 좋아요 안 누름 -> 추가
            mapper.insert(bno, liker);
            mapper.increaseLikeCount(bno);
            return 1; // 추가됨
        }
    }

    @Override
    public boolean checkLike(Long bno, String liker) {
        return mapper.checkLike(bno, liker) > 0;
    }
}
