package com.koreait.www.config;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

@Configuration
@EnableTransactionManagement
@MapperScan(basePackages = "com.koreait.www.repository")
@ComponentScan(basePackages = {"com.koreait.www.service", "com.koreait.www.security", "com.koreait.www.config"})
@PropertySource("classpath:database.properties")
public class RootConfig {

	@Autowired
	ApplicationContext applicationContext;

	@Value("${db.driver}")
	private String driver;

	@Value("${db.url}")
	private String url;

	@Value("${db.username}")
	private String username;

	@Value("${db.password}")
	private String password;

	@Bean
	public DataSource dataSource() {
		HikariConfig hikariConfig = new HikariConfig();

		// 1. 필수 설정
		hikariConfig.setDriverClassName(driver);
		hikariConfig.setJdbcUrl(url);
		hikariConfig.setUsername(username);
		hikariConfig.setPassword(password);

		// 2. 커넥션 풀 설정
		hikariConfig.setMaximumPoolSize(5);
		hikariConfig.setMinimumIdle(5);
		hikariConfig.setConnectionTestQuery("SELECT now()");

		// 3. 성능 최적화 설정 (MySQL)
		hikariConfig.addDataSourceProperty("dataSource.cachePrepStmts", "true");
		hikariConfig.addDataSourceProperty("dataSource.prepStmtsCacheSize", "250");
		hikariConfig.addDataSourceProperty("dataSource.prepStmtsCacheSqlLimit", "2048");
		hikariConfig.addDataSourceProperty("dataSource.useServerPrepStmts", "true");

		return new HikariDataSource(hikariConfig);
	}

	// static 메서드 (프로퍼티 해석기)
	@Bean
	public static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer() {
		return new PropertySourcesPlaceholderConfigurer();
	}

	@Bean
	public SqlSessionFactory sqlSessionFactory() throws Exception {
		SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();
		sessionFactory.setDataSource(dataSource());

		// 1. MyBatis 메인 설정 파일 (s가 빠진 getResource -> 파일 1개)
		// 역할: 카멜케이스 자동 변환, 별칭(Alias) 설정 등을 모아둔 파일
		sessionFactory.setConfigLocation(applicationContext.getResource("classpath:mybatis-config.xml"));

		// 2. Mapper XML 파일 위치 (s가 붙은 getResources -> 파일 여러 개)
		// 역할: SQL 쿼리가 들어있는 XML 파일들을 모두 찾아서 로딩
		sessionFactory.setMapperLocations(applicationContext.getResources("classpath:mappers/**/*.xml"));

		return sessionFactory.getObject();
	}
	
	@Bean
	public DataSourceTransactionManager transctionManager() {
		return new DataSourceTransactionManager(dataSource());
	}
	 
}