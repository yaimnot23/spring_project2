package com.koreait.www.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class FileController {

	// [설정] 실제 저장 경로 (BoardController와 동일하게 설정)
	private final String UPLOAD_ROOT = "D:\\.Spotlight-V100\\some_nec_downloads\\spring\\spring2_saveuploadfiles";

	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName) {
		
		log.info("fileName: " + fileName);
		
		File file = new File(UPLOAD_ROOT, fileName);
		
		log.info("file: " + file);
		
		ResponseEntity<byte[]> result = null;
		
		try {
			HttpHeaders header = new HttpHeaders();
			
			String contentType = Files.probeContentType(file.toPath());
			if(contentType == null) {
				contentType = "application/octet-stream";
			} // 타입을 못 찾으면 기본값 설정 (다운로드)
			
			header.add("Content-Type", contentType);
			
			if(!file.exists()) {
				log.error("File NOT found: " + file.getAbsolutePath());
				// [Debug] 폴더 내 실제 파일 목록 출력
				if(file.getParentFile().exists()) {
					log.info("Listing files in: " + file.getParentFile().getAbsolutePath());
					for(File f : file.getParentFile().listFiles()) {
						log.info(" - " + f.getName() + " (len: " + f.getName().length() + ")");
					}
				} else {
					log.error("Parent directory does not exist.");
				}
				return new ResponseEntity<>(HttpStatus.NOT_FOUND);
			}
			
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
			
		} catch (IOException e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		
		return result;
	}
}
