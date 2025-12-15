package com.koreait.www.repository;

import com.koreait.www.domain.MemberVO;

public interface MemberMapper {
    // 로그인 체크 (id와 pw가 일치하는 회원 정보 조회)
    MemberVO login(MemberVO member);
    
    // Spring Security용 회원 조회 (권한 포함)
    MemberVO read(String email);
}