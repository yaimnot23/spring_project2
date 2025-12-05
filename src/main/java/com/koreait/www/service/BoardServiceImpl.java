package com.koreait.www.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.koreait.www.domain.BoardVO;
import com.koreait.www.repository.BoardMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service // 이거 없으면 컨트롤러에서 에러 납니다!
@RequiredArgsConstructor // Mapper 자동 주입
public class BoardServiceImpl implements BoardService {

	// Mapper 주입
	private final BoardMapper mapper;

	@Override
	public void register(BoardVO board) {
		log.info("register......" + board);
		// insertSelectKey를 호출하면 글 번호가 board 객체에 담김
		mapper.insertSelectKey(board);
	}

	@Override
	public BoardVO get(Long bno) {
		log.info("get......" + bno);
		return mapper.read(bno);
	}

	@Override
	public boolean modify(BoardVO board) {
		log.info("modify......" + board);
		// 성공하면 1, 실패하면 0이므로 1일 때만 true 반환
		return mapper.update(board) == 1;
	}

	@Override
	public boolean remove(Long bno) {
		log.info("remove......" + bno);
		return mapper.delete(bno) == 1;
	}

	@Override
	public List<BoardVO> getList() {
		log.info("getList......");
		return mapper.getList();
	}

}