package com.koreait.www.domain;

import java.util.Date;

import lombok.Data;

@Data
public class BoardVO {
	
	private Long bno;          // 게시글 번호 (PK)
	private String title;      // 제목
	private String content;    // 내용
	private String writer;     // 작성자
	private int readCount;     // 조회수 (DB: read_count)
	private String isDel;      // 삭제 여부 (DB: is_del)
	private Date regDate;      // 작성일 (DB: reg_date)

}