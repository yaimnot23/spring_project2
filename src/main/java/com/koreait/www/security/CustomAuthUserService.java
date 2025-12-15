package com.koreait.www.security;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.koreait.www.domain.CustomUser;
import com.koreait.www.domain.MemberVO;
import com.koreait.www.repository.MemberMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class CustomAuthUserService implements UserDetailsService {

    private final MemberMapper memberMapper;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        log.warn("Load User By UserName: " + username);
        
        MemberVO member = memberMapper.read(username);
        
        log.warn("Queried by Member mapper: " + member);
        
        return member == null ? null : new CustomUser(member);
    }
}
