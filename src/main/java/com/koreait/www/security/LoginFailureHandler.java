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
        
        request.setAttribute("msg", "Login Failed: " + exception.getMessage());
        request.getRequestDispatcher("/member/login").forward(request, response);
    }
}
