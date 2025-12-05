package com.koreait.www.config;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
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
		
		// Log4jdbc를 사용하므로 드라이버와 URL이 log4jdbc 전용으로 설정됨 (정상)
		hikariConfig.setDriverClassName("net.sf.log4jdbc.sql.jdbcapi.DriverSpy");
		
		hikariConfig.setJdbcUrl("jdbc:log4jdbc:mysql://localhost:3306/springdb");
		
		hikariConfig.setUsername("springuser");
		hikariConfig.setPassword("mysql");
		
		// HikariCP 성능 최적화 설정 (선택사항, 필요시 추가)
		// hikariConfig.setMaximumPoolSize(10);
		
		return new HikariDataSource(hikariConfig);
	}
	
	// [추가됨] MyBatis가 DB에 접속하고 SQL을 실행할 수 있게 해주는 공장 객체
	@Bean
	public SqlSessionFactory sqlSessionFactory() throws Exception {
		SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();
		sessionFactory.setDataSource(dataSource()); // 위에서 만든 dataSource 주입
		return sessionFactory.getObject();
	}
	
	// [추가됨] @EnableTransactionManagement를 위해 필요한 트랜잭션 관리자
	@Bean
	public PlatformTransactionManager transactionManager() {
		DataSourceTransactionManager tm = new DataSourceTransactionManager();
		tm.setDataSource(dataSource());
		return tm;
	}

}