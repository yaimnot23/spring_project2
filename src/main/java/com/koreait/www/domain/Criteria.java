package com.koreait.www.domain;

import lombok.Data;

@Data
public class Criteria {
    
    private int pageNum;  // 현재 페이지 번호
    private int amount;   // 한 페이지당 보여줄 게시글 수
    
    private String type;    // 검색 조건
    private String keyword; // 검색어

    // 기본 생성자: 1페이지, 6개씩 보여주기 설정
    public Criteria() {
        this(1, 6); 
    }

    public Criteria(int pageNum, int amount) {
        this.pageNum = pageNum;
        this.amount = amount;
    }

    public String[] getTypeArr() {
        return type == null ? new String[] {} : type.split("");
    }
    
    // MyBatis에서 #{skip}으로 사용할 메서드 (LIMIT 시작 위치 계산)
    public int getSkip() {
        return (pageNum - 1) * amount;
    }
}