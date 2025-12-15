package com.koreait.www.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class LoginFailureHandler implements AuthenticationFailureHandler {

    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
            AuthenticationException exception) throws IOException, ServletException {
        
        log.warn("Login Failure caught: " + exception.getClass().getName());
        log.warn("Login Failure message: " + exception.getMessage());
        
        // POST 요청을 그대로 forward 하면 컨트롤러 @GetMapping("/login")에서 405 발생 가능
        // 따라서 Redirect 방식으로 변경
        response.sendRedirect("/member/login?error=" + java.net.URLEncoder.encode(exception.getMessage(), "UTF-8"));
    }
}
