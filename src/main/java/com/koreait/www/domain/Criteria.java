package com.koreait.www.domain;

import lombok.Data;

@Data
public class Criteria {
    
    private String type;    // 검색 타입 (T:제목, C:내용, W:작성자)
    private String keyword; // 검색어

    // MyBatis 동적 쿼리에서 사용하기 위해 문자열을 배열로 변환
    // 예: type이 "TC"이면 ["T", "C"] 배열로 반환
    public String[] getTypeArr() {
        return type == null ? new String[] {} : type.split("");
    }
}