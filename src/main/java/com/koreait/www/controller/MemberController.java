package com.koreait.www.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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

    // 2. 로그인 처리 (POST)
    @PostMapping("/login")
    public String login(MemberVO member, HttpServletRequest request, RedirectAttributes rttr) {
        log.info("로그인 시도: " + member);

        HttpSession session = request.getSession();
        MemberVO loginUser = service.login(member);

        if (loginUser != null) {
            // 로그인 성공: 세션에 사용자 정보 저장
            session.setAttribute("member", loginUser);
            log.info("로그인 성공");
            return "redirect:/"; // 메인 페이지로 이동
        } else {
            // 로그인 실패: 다시 로그인 페이지로
            rttr.addFlashAttribute("msg", "아이디 또는 비밀번호가 일치하지 않습니다.");
            return "redirect:/member/login";
        }
    }

    // 3. 로그아웃 처리 (GET)
    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        log.info("로그아웃 요청");
        
        HttpSession session = request.getSession();
        session.invalidate(); // 세션 전체삭제
        
        return "redirect:/";
    }
}