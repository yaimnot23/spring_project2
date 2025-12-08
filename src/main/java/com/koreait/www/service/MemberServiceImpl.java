package com.koreait.www.service;

import org.springframework.stereotype.Service;
import com.koreait.www.domain.MemberVO;
import com.koreait.www.repository.MemberMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService {

    private final MemberMapper mapper;

    @Override
    public MemberVO login(MemberVO member) {
        log.info("login service... " + member);
        return mapper.login(member);
    }
}