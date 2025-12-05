package com.koreait.www.config;

import javax.sql.DataSource;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

@Configuration
@EnableTransactionManagement
@MapperScan(basePackages = "com.koreait.www.repository")
public class RootConfig {

	@Bean
	public DataSource dataSource() {
		HikariConfig hikariConfig = new HikariConfig();
		
		// 드라이버 클래스 이름 (Log4jdbc 용)
		hikariConfig.setDriverClassName("net.sf.log4jdbc.sql.jdbcapi.DriverSpy");
		
		// URL (log4jdbc 포함)
		// 주의: "schema_name" 부분을 본인이 만든 DB 이름(예: test_db)으로 꼭 바꾸세요!
		hikariConfig.setJdbcUrl("jdbc:log4jdbc:mysql://localhost:3306/schema_name?serverTimezone=Asia/Seoul");
		
		hikariConfig.setUsername("root");
		hikariConfig.setPassword("1234");
		
		HikariDataSource dataSource = new HikariDataSource(hikariConfig);
		return dataSource;
	}

}