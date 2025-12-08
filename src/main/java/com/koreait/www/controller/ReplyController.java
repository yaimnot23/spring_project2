package com.koreait.www.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.koreait.www.domain.ReplyVO;
import com.koreait.www.service.ReplyService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/replies/")
@RestController // @Controller + @ResponseBody (데이터만 리턴)
@Slf4j
@RequiredArgsConstructor
public class ReplyController {

    private final ReplyService service;

    // 1. 댓글 등록 (POST)
    // 소비(consumes): JSON 데이터 / 생산(produces): 문자열(성공 메시지)
    @PostMapping(value = "/new", consumes = "application/json", produces = { MediaType.TEXT_PLAIN_VALUE })
    public ResponseEntity<String> create(@RequestBody ReplyVO vo) {
        log.info("ReplyVO: " + vo);
        int insertCount = service.register(vo);
        
        return insertCount == 1 
            ? new ResponseEntity<>("success", HttpStatus.OK)
            : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    // 2. 특정 게시글의 댓글 목록 확인 (GET)
    @GetMapping(value = "/pages/{bno}", produces = { MediaType.APPLICATION_JSON_VALUE })
    public ResponseEntity<List<ReplyVO>> getList(@PathVariable("bno") Long bno) {
        log.info("getList..........." + bno);
        // Jackson이 List<ReplyVO>를 JSON 배열로 자동 변환해줌
        return new ResponseEntity<>(service.getList(bno), HttpStatus.OK);
    }

    // 3. 댓글 삭제 (DELETE)
    @DeleteMapping(value = "/{rno}", produces = { MediaType.TEXT_PLAIN_VALUE })
    public ResponseEntity<String> remove(@PathVariable("rno") Long rno) {
        log.info("remove: " + rno);
        return service.remove(rno) == 1 
            ? new ResponseEntity<>("success", HttpStatus.OK)
            : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
    
    // 4. 댓글 수정 (PUT/PATCH)
    @RequestMapping(method = { RequestMethod.PUT, RequestMethod.PATCH }, 
            value = "/{rno}", 
            consumes = "application/json", 
            produces = { MediaType.TEXT_PLAIN_VALUE })
    public ResponseEntity<String> modify(
            @RequestBody ReplyVO vo, 
            @PathVariable("rno") Long rno) {
        
        vo.setRno(rno);
        log.info("rno: " + rno);
        log.info("modify: " + vo);

        return service.modify(vo) == 1 
            ? new ResponseEntity<>("success", HttpStatus.OK)
            : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
}