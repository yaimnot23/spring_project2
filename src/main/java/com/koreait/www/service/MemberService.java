package com.koreait.www.service;

import com.koreait.www.domain.MemberVO;

public interface MemberService {
    int register(MemberVO mvo);
    MemberVO login(MemberVO member);
}