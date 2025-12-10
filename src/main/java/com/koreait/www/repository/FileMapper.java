package com.koreait.www.repository;

import java.util.List;
import com.koreait.www.domain.FileVO;

public interface FileMapper {
    public void insert(FileVO vo);
    public List<FileVO> findByBno(Long bno);
    public void deleteAll(Long bno);
}