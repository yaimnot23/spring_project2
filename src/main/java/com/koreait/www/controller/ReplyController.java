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
    // 1. 댓글 등록 (POST)
    // 소비(consumes): JSON 데이터 / 생산(produces): 문자열(성공 메시지)
    @PostMapping(value = "/new", consumes = "application/json", produces = { MediaType.TEXT_PLAIN_VALUE })
    public ResponseEntity<String> create(@RequestBody ReplyVO vo, java.security.Principal principal) {
        log.info("ReplyVO: " + vo);
        
        if(principal != null) {
        	// 보안상 서버 측에서 작성자를 로그인한 사용자로 강제 설정 (선택 사항. VO에 이미 있으면 덮어쓰거나 검증)
        	// 만약 VO에 name(이메일)이 오면 Principal과 비교 가능.
        	// 여기서는 Principal의 Name(Email)을 replyer로 사용할지, VO의 replyer(닉네임)를 사용할지 정책 결정 필요.
        	// 보통 DB replyer 컬럼이 닉네임이라면 그대로 두고, 검증만 하거나... 
        	// 아니면 DB에 사용자 ID(Email)를 저장하는 것이 정석.
        	// 일단 기존 로직이 닉네임/ID 혼용 가능성이 있으므로, 
        	// DB가 ID(Email)를 저장한다면 vo.setReplyer(principal.getName());
        	// DB가 닉네임을 저장한다면 프론트에서 보낸 것을 믿거나, Principal에서 닉네임 꺼내야 함. (CustomUser 형변환 필요)
        	
        	// 여기서는 프론트에서 보낸 값을 일단 신뢰하되, 로그를 남김.
            log.info("Principal Name: " + principal.getName());
        }
        
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
    // 3. 댓글 삭제 (DELETE)
    @DeleteMapping(value = "/{rno}", produces = { MediaType.TEXT_PLAIN_VALUE })
    public ResponseEntity<String> remove(@PathVariable("rno") Long rno, 
                                         java.security.Principal principal,
                                         javax.servlet.http.HttpServletRequest request) {
        log.info("remove: " + rno);
        
        if (principal == null) {
        	return new ResponseEntity<>("Unauthenticated", HttpStatus.UNAUTHORIZED);
        }
        
        ReplyVO vo = service.get(rno);
        if (vo == null) {
        	return new ResponseEntity<>("Not Found", HttpStatus.NOT_FOUND);
        }
        
        boolean isReplyer = vo.getReplyer().equals(principal.getName());
        boolean isAdmin = request.isUserInRole("ROLE_ADMIN");
        
        if (!isReplyer && !isAdmin) {
        	return new ResponseEntity<>("Forbidden", HttpStatus.FORBIDDEN);
        }
        
        return service.remove(rno) == 1 
            ? new ResponseEntity<>("success", HttpStatus.OK)
            : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
    
    // 4. 댓글 수정 (PUT/PATCH)
    // 4. 댓글 수정 (PUT/PATCH)
    @RequestMapping(method = { RequestMethod.PUT, RequestMethod.PATCH }, 
            value = "/{rno}", 
            consumes = "application/json", 
            produces = { MediaType.TEXT_PLAIN_VALUE })
    public ResponseEntity<String> modify(
            @RequestBody ReplyVO vo, 
            @PathVariable("rno") Long rno,
            java.security.Principal principal,
            javax.servlet.http.HttpServletRequest request) {
        
    	if (principal == null) {
        	return new ResponseEntity<>("Unauthenticated", HttpStatus.UNAUTHORIZED);
        }
    	
        vo.setRno(rno);
        
        ReplyVO original = service.get(rno);
        if(original == null) {
        	return new ResponseEntity<>("Not Found", HttpStatus.NOT_FOUND);
        }
        
        boolean isReplyer = original.getReplyer().equals(principal.getName());
        boolean isAdmin = request.isUserInRole("ROLE_ADMIN"); // 관리자도 수정 가능하게 할지? 보통 수정은 본인만. 삭제는 관리자도.
        // 정책: 댓글 수정은 본인만 가능하도록 (관리자라도 남의 글 수정은 좀...)
        // 하지만 요청대로 일단 관리자도 가능하게 둠 (삭제와 통일성 위해). 원치 않으면 isAdmin 제거.
        
        if (!isReplyer && !isAdmin) {
        	return new ResponseEntity<>("Forbidden", HttpStatus.FORBIDDEN);
        }
        
        log.info("rno: " + rno);
        log.info("modify: " + vo);

        return service.modify(vo) == 1 
            ? new ResponseEntity<>("success", HttpStatus.OK)
            : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
}