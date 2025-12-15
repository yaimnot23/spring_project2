package com.koreait.www.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import com.koreait.www.security.CustomAuthUserService;
import com.koreait.www.security.LoginFailureHandler;
import com.koreait.www.security.LoginSuccessHandler;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    private final CustomAuthUserService customAuthUserService;
    private final PasswordEncoder passwordEncoder;

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(customAuthUserService)
            .passwordEncoder(passwordEncoder);
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        log.info("Security Configured...");
        
        http.authorizeRequests()
            .antMatchers("/board/register", "/board/modify", "/board/remove").authenticated()
            .anyRequest().permitAll();
            
        http.formLogin()
            .usernameParameter("email")
            .passwordParameter("pwd")
            .loginPage("/member/login")
            .loginProcessingUrl("/member/login")
            .successHandler(loginSuccessHandler())
            .failureHandler(loginFailureHandler()); // 실패 핸들러 추가
            
        http.logout()
            .logoutUrl("/member/logout")
            .invalidateHttpSession(true)
            .deleteCookies("JSESSIONID");
    }

    @Bean
    public AuthenticationSuccessHandler loginSuccessHandler() {
        return new LoginSuccessHandler();
    }
    
    @Bean
    public AuthenticationFailureHandler loginFailureHandler() {
        return new LoginFailureHandler();
    }

    /* RootConfig로 이동
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
    */
}
