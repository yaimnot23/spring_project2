package com.koreait.www.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.koreait.www.service.LikeService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/likes")
@RequiredArgsConstructor
@Slf4j
public class LikeController {

    private final LikeService service;
    
    @PostMapping(value = "/toggle", consumes = "application/json", produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, Object> toggle(@RequestBody Map<String, String> params, java.security.Principal principal) {
        Map<String, Object> result = new HashMap<>();
        
        Long bno = Long.parseLong(params.get("bno"));
        String liker = null;
        
        if (principal != null) {
            liker = principal.getName();
        } else {
            // 비회원 좋아요? (정책에 따라 막거나, 쿠키/IP 등으로 제한 가능)
            // 여기서는 일단 로그인 필요 메시지 리턴
            result.put("status", "anonymous");
            return result;
        }
        
        int status = service.toggleLike(bno, liker);
        result.put("status", "success");
        result.put("liked", status == 1); // true: 좋아요, false: 취소
        
        return result;
    }
    
    @GetMapping(value = "/check/{bno}/{liker:.+}", produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, Boolean> check(@PathVariable("bno") Long bno, @PathVariable("liker") String liker) {
        Map<String, Boolean> result = new HashMap<>();
        result.put("liked", service.checkLike(bno, liker));
        return result;
    }
}
