package com.koreait.www.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class BoardVO {
	
	private Long bno;          // 게시글 번호 (PK)
	private String title;      // 제목
	private String content;    // 내용
	private String writer;     // 작성자
	private int readCount;     // 조회수 (DB: read_count)
	private int likeCount;     // 좋아요 수
	
	private boolean isSecret;  // 비밀글 여부
	private String password;   // 비밀글 비번
	
	private String isDel;      // 삭제 여부 (DB: is_del)
	private Date regDate;      // 작성일 (DB: reg_date)
	private List<FileVO> attachList;

}