package com.koreait.www.controller;

import javax.servlet.http.HttpServletRequest;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;


import com.koreait.www.domain.MemberVO;
import com.koreait.www.service.MemberService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService service;

    // 1. 로그인 페이지 이동 (GET)
    @GetMapping("/login")
    public void loginPage() {
        log.info("로그인 페이지 이동");
    }

    // 2. 회원가입 페이지 이동 (GET)
    @GetMapping("/signup")
    public void signup() {
        log.info("회원가입 페이지 이동");
    }

    // 3. 회원가입 처리 (POST)
    @PostMapping("/signup")
    public String signup(MemberVO mvo) {
        log.info("회원가입 요청: " + mvo);
        int isOk = service.register(mvo);
        return isOk > 0 ? "redirect:/member/login" : "redirect:/member/signup";
    }

    // 4. 로그아웃 처리 (GET) - Spring Security에서는 /logout POST로 처리하지만, 
    // 커스텀 로그아웃 페이지나 추가 처리를 위해 남겨둘 수 있음. 
    // 다만 SecurityConfig에서 logoutUrl("/member/logout")을 설정했으므로 
    // 시큐리티가 가로챌 가능성이 높음. 
    // 우선 기존 코드 유지하되, SecurityConfig 설정을 따름.
    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        log.info("로그아웃 요청");
        // Spring Security 로그아웃은 SecurityConfig에서 처리됨.
        // 이 컨트롤러 메서드는 Security가 처리하지 않는 경우(예: GET 요청)에만 호출됨.
        return "redirect:/";
    }
}