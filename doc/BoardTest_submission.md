```java
package com.koreait.www.repository;

import java.util.List;

import com.koreait.www.repository.BoardMapper;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.koreait.www.config.RootConfig;
import com.koreait.www.domain.BoardVO;
import com.koreait.www.domain.Criteria;

import lombok.extern.slf4j.Slf4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {RootConfig.class})
@Slf4j
public class BoardTest {

    @Autowired
    private BoardMapper mapper;

    @Test
    public void testInsertDummies() {
        for (int i = 1; i <= 10; i++) {
            BoardVO board = new BoardVO();
            board.setTitle("테스트 제목 " + i);
            board.setContent("테스트 내용 " + i);
            board.setWriter("user" + (i % 5));

            mapper.insertSelectKey(board);
            log.info("DUMMY INSERTED: " + board);
        }
    }

    // 1. 제목(T) 검색 테스트
    @Test
    public void testSearch() {
        log.info("=== 검색 테스트 시작 (제목) ===");

        Criteria cri = new Criteria();
        cri.setKeyword("테스트"); // '테스트'라는 단어가 포함된 글 검색
        cri.setType("T");        // 검색 조건: 제목(T)

        List<BoardVO> list = mapper.getList(cri);

        list.forEach(board -> log.info(board.toString()));
    }

    // 2. 제목(T) 또는 내용(C) 검색 테스트
    @Test
    public void testSearchTC() {
        log.info("=== 검색 테스트 시작 (제목 or 내용) ===");

        Criteria cri = new Criteria();
        cri.setKeyword("Java"); // 'Java'가 포함된 글 검색
        cri.setType("TC");      // 검색 조건: 제목(T) OR 내용(C)

        List<BoardVO> list = mapper.getList(cri);

        list.forEach(board -> log.info(board.toString()));
    }
}
```
