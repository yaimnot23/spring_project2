package com.koreait.www.service;

import org.springframework.stereotype.Service;
import com.koreait.www.domain.AuthVO;
import com.koreait.www.domain.MemberVO;
import com.koreait.www.repository.MemberMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;

@Slf4j
@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService {

    private final MemberMapper mapper;
    private final PasswordEncoder passwordEncoder;

    @Override
    public int register(MemberVO mvo) {
        log.info("register service... " + mvo);
        // 1. 암호화
        String encodedPwd = passwordEncoder.encode(mvo.getPwd());
        mvo.setPwd(encodedPwd);
        
        // 2. 회원 등록
        int isUp = mapper.insert(mvo);
        
        // 3. 권한 부여 (기본 ROLE_USER)
        if (isUp > 0) {
            AuthVO avo = new AuthVO();
            avo.setEmail(mvo.getEmail());
            avo.setAuth("ROLE_USER");
            mapper.insertAuth(avo);
        }
        return isUp;
    }

    @Override
    public MemberVO login(MemberVO member) {
        log.info("login service... " + member);
        return mapper.login(member);
    }
}