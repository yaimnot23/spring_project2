package com.koreait.www.domain;

import lombok.Data;

@Data
public class PageDTO {
    private int startPage; // 시작 페이지 번호 (예: 1, 11, 21...)
    private int endPage;   // 끝 페이지 번호 (예: 10, 20, 30...)
    private boolean prev, next; // 이전, 다음 버튼 표시 여부
    
    private int total;     // 전체 게시글 수
    private Criteria cri;  // 현재 페이지 정보
    
    public PageDTO(Criteria cri, int total) {
        this.cri = cri;
        this.total = total;
        
        // 1. 끝 페이지 계산 (10개씩 페이징 바를 보여준다고 가정)
        // Math.ceil(현재페이지 / 10.0) * 10
        this.endPage = (int) (Math.ceil(cri.getPageNum() / 10.0)) * 10;
        
        // 2. 시작 페이지 계산
        this.startPage = this.endPage - 9;
        
        // 3. 실제 끝 페이지 계산 (전체 데이터 개수 기반)
        int realEnd = (int) (Math.ceil((total * 1.0) / cri.getAmount()));
        
        // 4. 만약 실제 끝 페이지가 계산된 끝 페이지보다 작다면 교체
        if (realEnd < this.endPage) {
            this.endPage = realEnd;
        }
        
        // 5. 이전, 다음 버튼 표시 여부
        this.prev = this.startPage > 1;
        this.next = this.endPage < realEnd;
    }
}