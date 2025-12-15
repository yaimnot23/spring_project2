# 프로젝트 개발 작업 목록 (Project Task Checklist)

## 1. 프로젝트 설정 (Project Setup)

- [x] 현재 프로젝트 구조 및 파일 분석
- [x] 프로젝트 히스토리 로그 생성 (`development_log.md`)
- [x] 구현 계획서(Implementation Plan) 한글 번역

## 2. 서버 구성 (Server Configuration)

- [x] VS Code에서 Tomcat 서버 설정
- [x] 프로젝트 배포 및 기본 실행 확인

## 3. 데이터베이스 계층 구현 (Database Layer)

- [x] 수동 로그인 제거를 위한 SQL 스크립트 생성/업데이트
- [x] MemberMapper 인터페이스 구현 (`register`, `login`, `read` 메서드)
- [x] MemberMapper XML 업데이트 (`insert`, `select`, `auth` 쿼리)
- [x] `auth` 테이블 구조 및 권한 관리 검증

## 4. 서비스 계층 구현 (Service Layer - Member)

- [x] MemberService 인터페이스 구현
- [x] MemberServiceImpl 클래스 구현
  - [x] 비밀번호 암호화 (BCrypt)
  - [x] 권한 부여 로직 (기본값 `ROLE_USER`)
  - [x] 트랜잭션 관리

## 5. 보안 구성 (Security Configuration)

- [x] `SecurityConfig` 클래스 생성
- [x] `PasswordEncoder` 설정 (BCrypt)
- [x] `CustomAuthUserService` 구현 (`UserDetailsService`)
- [x] `CustomUser` 생성 (UserDetails 구현체)
- [x] `formLogin` 설정 (성공/실패 핸들러)
  - [x] LoginSuccessHandler
  - [x] LoginFailureHandler
- [x] URL 기반 권한 설정 (`/board/*` 체크)
- [x] **[디버깅] 빈(Bean) 생성 오류 수정 (PasswordEncoder)**
  - [x] `passwordEncoder`를 `RootConfig`로 이동
  - [x] `MemberServiceImpl`에 `passwordEncoder` 주입 (인터페이스 사용)
- [x] **[디버깅] CSRF 오류 수정 (403 Forbidden)**
  - [x] `signup.jsp`에 CSRF 토큰 추가
  - [x] `login.jsp`에 CSRF 토큰 추가
- [x] **[디버깅] 로그인 실패 수정 (BadCredentials)**
  - [x] `LoginFailureHandler`에 상세 로깅 추가
  - [x] `SecurityConfig`에 `.passwordParameter("pwd")` 설정 추가
- [x] **[디버깅] 로그인 유지 및 기능 연동**
  - [x] `header.jsp` 업데이트 (`<sec:authorize>` 사용)
  - [x] `BoardController` 업데이트 (`Principal` 사용, HttpSession 제거)
  - [x] `ReplyController` 업데이트 (`Principal` 사용)
  - [x] `get.jsp` 업데이트 (AJAX용 CSRF 설정, 사용자 정보 표시)
  - [x] `register.jsp` 업데이트 (CSRF, 사용자 정보 표시)
  - [x] `modify.jsp` 업데이트 (CSRF)

## 6. 컨트롤러 및 뷰 구현 (Controller & View)

- [x] MemberController 업데이트
  - [x] 수동 로그인 로직 제거
  - [x] 회원가입 (GET/POST) 엔드포인트 추가
  - [x] 로그인 (GET) 엔드포인트 추가
- [x] JSP 생성/업데이트
  - [x] `signup.jsp` (신규 가입 폼)
  - [x] `login.jsp` (보안 태그 적용, 가입 링크)
  - [x] `header.jsp` (조건부 로그인/로그아웃 버튼)

## 7. 검증 (Verification)

- [x] 회원가입 검증 (DB 저장, 비밀번호 해시 확인)
- [x] 로그인 검증 (성공/실패 흐름)
- [x] 로그아웃 검증
- [x] 권한 기반 접근 제어 검증 (게시글 작성/수정 - 백엔드 로직 적용 완료)
- [x] 댓글 작성/삭제 검증 (백엔드 로직 적용 완료)

## 8. 권한 기반 인가 (Role-Based Authorization)

- [x] **권한 이름 통일**
  - [x] `LoginSuccessHandler`에서 `ROLE_MEMBER` 대신 `ROLE_USER` 확인하도록 수정
- [x] **샘플 페이지 생성**
  - [x] `SampleController` 생성 (`/sample/all`, `/sample/member`, `/sample/admin`)
  - [x] `sample/all.jsp` (전체 공개)
  - [x] `sample/member.jsp` (회원 전용)
  - [x] `sample/admin.jsp` (관리자 전용)
- [x] **보안 설정 업데이트**
  - [x] `SecurityConfig`에 `/sample/**`에 대한 `antMatchers` 추가
- [x] **관리자 유저 생성**
  - [x] 'admin99' 유저 생성을 위한 SQL 스크립트 작성
  - [x] 'admin99'에게 'ROLE_ADMIN' 권한 부여 (사용자 실행 필요 - 'admin100'으로 수행함)

## 9. 관리자 기능 (Admin Features)

- [x] **회원 목록 기능**
  - [x] `MemberMapper`에 `getList()` 추가 (모든 회원 + 권한)
  - [x] `MemberService`에 `getList()` 추가
  - [x] `MemberController`에 `/member/list` 추가 (Admin Only)
  - [x] `member/list.jsp` 생성 (카드 UI)
  - [x] `header.jsp`에 '회원 목록' 링크 추가 (Admin Only)
  - [x] `SecurityConfig`에 `/member/list` 접근 제어 추가

## 10. 예외 처리 (Exception Handling)

- [x] **사용자 지정 404 페이지**
  - [x] `WebConfig`에 `throwExceptionIfNoHandlerFound` 설정
  - [x] `CommonExceptionAdvice` 생성 및 404 핸들러 구현
  - [x] `error/404.jsp` 생성 (GitHub 스타일 커스텀 디자인)
