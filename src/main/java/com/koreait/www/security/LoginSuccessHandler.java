package com.koreait.www.security;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class LoginSuccessHandler implements AuthenticationSuccessHandler {

	private com.koreait.www.service.MemberService service;
	
	public LoginSuccessHandler() {}
	
	public LoginSuccessHandler(com.koreait.www.service.MemberService service) {
		this.service = service;
	}

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {
        
        log.warn("Login Success");
        
        // [Last Login Update]
        String email = authentication.getName();
        if(service != null) {
        	service.updateLastLogin(email);
        }
        
        List<String> roleNames = new ArrayList<>();
        
        authentication.getAuthorities().forEach(authority -> {
            roleNames.add(authority.getAuthority());
        });
        
        log.warn("ROLE NAMES: " + roleNames);
        
        if (roleNames.contains("ROLE_ADMIN")) {
            // response.sendRedirect("/sample/admin");
        	response.sendRedirect("/");
            return;
        }
        
        if (roleNames.contains("ROLE_USER")) {
            // response.sendRedirect("/sample/member");
        	response.sendRedirect("/");
            return;
        }
        
        response.sendRedirect("/");
    }
}
