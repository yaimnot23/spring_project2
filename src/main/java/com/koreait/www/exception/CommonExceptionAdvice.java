package com.koreait.www.exception;

import org.springframework.http.HttpStatus;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.NoHandlerFoundException;

import lombok.extern.slf4j.Slf4j;

@ControllerAdvice
@Slf4j
public class CommonExceptionAdvice {

    // 404 에러 처리 (WebConfig에서 throwExceptionIfNoHandlerFound=true 설정 필요)
    @ExceptionHandler(NoHandlerFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public String handle404(NoHandlerFoundException ex) {
        log.error("404 Error: " + ex.getRequestURL());
        return "error/404";
    }

    // 기타 500 에러 등 처리 가능
    @ExceptionHandler(Exception.class)
    public String handleException(Exception ex, Model model) {
        log.error("Exception....." + ex.getMessage());
        model.addAttribute("exception", ex);
        // return "error/500"; // 필요 시 500 페이지 생성
        return "error/404"; // 일단 데모용으로 404로 보낼 수도 있고, 별도 페이지로 보낼 수도 있음.
    }
}
