package com.koreait.www.config;

import javax.servlet.Filter;
import javax.servlet.MultipartConfigElement;
import javax.servlet.ServletRegistration.Dynamic;

import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

public class WebConfig extends AbstractAnnotationConfigDispatcherServletInitializer {

	@Override
	protected Class<?>[] getRootConfigClasses() {
		return new Class[] { RootConfig.class };
	}

	@Override
	protected Class<?>[] getServletConfigClasses() {
		return new Class[] { ServletConfigration.class };
	}

	@Override
	protected String[] getServletMappings() {
		return new String[] { "/" };
	}

	@Override
	protected Filter[] getServletFilters() {
		CharacterEncodingFilter encoding = new CharacterEncodingFilter("UTF-8", true);
		encoding.setEncoding("UTF-8");
		encoding.setForceEncoding(true);
		return new Filter[] { encoding };
	}

	// [파일 업로드 설정]
	@Override
	protected void customizeRegistration(Dynamic registration) {
		// 컨트롤러에서 20MB를 정교하게 거르기 위해, 서버 제한은 50MB로 넉넉히 설정함.
		MultipartConfigElement multipartConfig = 
				new MultipartConfigElement("C:\\upload\\temp", 
						52428800,   // Max File Size: 50MB
						104857600,  // Max Request Size: 100MB
						20971520);  // File Size Threshold: 20MB
		
		registration.setMultipartConfig(multipartConfig);
	}

}