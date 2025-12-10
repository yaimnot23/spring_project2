package com.koreait.www.domain;

import lombok.Data;

@Data
public class FileVO {
    private String uuid;        // UUID
    private String uploadPath;  // 저장된 폴더명 (image/video/others)
    private String fileName;    // 원본 파일명
    private boolean fileType;   // 이미지 여부
    private Long bno;           // 게시글 번호
    private long fileSize;      // 파일 크기
}