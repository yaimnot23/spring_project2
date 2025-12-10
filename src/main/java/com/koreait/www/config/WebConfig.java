package com.koreait.www.config;

import javax.servlet.Filter;
import javax.servlet.MultipartConfigElement;
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
	
	// [파일 업로드 설정]
    @Override
    protected void customizeRegistration(Dynamic registration) {
        // 임시 저장 경로, 최대 파일 크기, 요청 최대 크기, 파일 임계값
        // D드라이브의 temp 폴더를 사용하도록 설정
        MultipartConfigElement multipartConfig = 
            new MultipartConfigElement("D:\\.Spotlight-V100\\some_nec_downloads\\spring\\temp", 
                                       20971520, 41943040, 20971520);
        registration.setMultipartConfig(multipartConfig);
    }
	
	
	
	

	

}
