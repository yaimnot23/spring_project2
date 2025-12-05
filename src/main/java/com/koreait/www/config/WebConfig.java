package com.koreait.www.config;

import javax.servlet.Filter;
import javax.servlet.ServletRegistration.Dynamic;

import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

public class WebConfig extends AbstractAnnotationConfigDispatcherServletInitializer{

	@Override
	protected Class<?>[] getRootConfigClasses() {
		// TODO Auto-generated method stub
		return new Class [] {RootConfig.class};
	}

	@Override
	protected Class<?>[] getServletConfigClasses() {
		// TODO Auto-generated method stub
		return new Class [] { ServletConfigration.class};
	}

	@Override
	protected String[] getServletMappings() {
		// TODO Auto-generated method stub
		return new String[] {"/"};
	}
	
	// filter 추가
	@Override
	protected Filter[] getServletFilters() {
		// filter encoding 추가
		CharacterEncodingFilter encoding = new CharacterEncodingFilter("UTF-8",true);
		
		// 둘어오는 객체 encoding
		encoding.setEncoding("UTF-8");
		encoding.setForceEncoding(true);
		
		return new Filter[] {encoding};
	}
	
	// 기타 사용자 설정 => customerRegistration
	@Override
	protected void customizeRegistration(Dynamic registration) {
		// 파일업로드 경로 설정, 익셉션 처리 설정
		
	}
	
	
	
	

	

}
