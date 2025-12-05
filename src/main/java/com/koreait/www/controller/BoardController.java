package com.koreait.www.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.koreait.www.domain.BoardVO;
import com.koreait.www.service.BoardService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/board/*") // 1. 기본 URL 설정 (/board/list, /board/register 등)
@RequiredArgsConstructor     // 2. final이 붙은 필드만 생성자 주입 (Service 주입용)
public class BoardController {

	// Service 의존성 주입 (아직 안 만들어서 빨간 줄 뜰 수 있음)
	private final BoardService service;
	
	// 1. 목록 조회 (GET)
	// URL: /board/list
	@GetMapping("/list")
	public void list(Model model) {
		log.info("list 요청");
		// 서비스를 통해 게시글 목록을 가져와서 "list"라는 이름으로 화면(JSP)에 전달
		model.addAttribute("list", service.getList());
	}
	
	// 2. 글쓰기 페이지 이동 (GET)
	// URL: /board/register
	@GetMapping("/register")
	public void register() {
		// 단순히 입력 화면(/board/register.jsp)만 보여줌
		log.info("register 페이지 이동");
	}
	
	// 3. 글 등록 처리 (POST)
	// URL: /board/register
	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info("register 등록 처리: " + board);
		
		// DB에 저장
		service.register(board);
		
		// 리다이렉트 시 게시글 번호를 잠깐 가져감 (모달창 띄우기 용도)
		rttr.addFlashAttribute("result", board.getBno());
		
		// 처리가 끝나면 목록 페이지로 이동
		return "redirect:/board/list";
	}
	
	// 4. 상세 조회 및 수정 페이지 이동 (GET)
	// URL: /board/get?bno=1 또는 /board/modify?bno=1
	// @GetMapping에 배열로 경로를 2개 넣어서 메서드 하나로 처리
	@GetMapping({"/get", "/modify"})
	public void get(@RequestParam("bno") Long bno, Model model) {
		log.info("/get or /modify 요청... 번호: " + bno);
		// 번호(bno)에 해당하는 글을 읽어와서 "board"라는 이름으로 화면에 전달
		model.addAttribute("board", service.get(bno));
	}
	
	// 5. 글 수정 처리 (POST)
	// URL: /board/modify
	@PostMapping("/modify")
	public String modify(BoardVO board, RedirectAttributes rttr) {
		log.info("modify 수정 처리: " + board);
		
		// 수정 성공 시 result에 success 담아서 목록으로 이동
		if (service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}
		
		return "redirect:/board/list";
	}
	
	// 6. 글 삭제 처리 (POST)
	// URL: /board/remove
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, RedirectAttributes rttr) {
		log.info("remove 삭제 처리 번호: " + bno);
		
		// 삭제 성공 시 result에 success 담아서 목록으로 이동
		if (service.remove(bno)) {
			rttr.addFlashAttribute("result", "success");
		}
		
		return "redirect:/board/list";
	}

}