# 수정 구현 보고서 (Modified Implementation Log)

이 문서는 Spring Security 도입 후 발생한 주요 문제점(로그인 실패, 화면 연동, 기능 오류)을 해결하기 위해 수행한 수정 사항을 정리한 것입니다.

## 1. 로그인 실패 해결 (BadCredentialsException)

**문제 상황**

- 데이터베이스에 회원 정보가 존재하고 비밀번호가 일치함에도 불구하고 "Login Failure" 발생.
- `LoginFailureHandler` 로그 분석 결과 `BadCredentialsException` 확인.

**원인**

- 로그인 폼(`login.jsp`)의 비밀번호 입력 필드 `name` 속성은 `pwd`였으나, Spring Security의 기본 처리 필드명은 `password`임. 이로 인해 비밀번호가 서버로 전달되지 않음.

**수정 내역**

- **[SecurityConfig.java](file:///d:/projects/spring_workspace2/spring_project/src/main/java/com/koreait/www/config/SecurityConfig.java)**
  - `.passwordParameter("pwd")` 설정을 추가하여 `pwd` 파라미터를 비밀번호로 인식하도록 변경.

---

## 2. 로그인 상태 화면 표시 (UI Synchronization)

**문제 상황**

- 로그인 성공 로그가 출력되었음에도, 웹 브라우저 상단 메뉴바(Header)에는 여전히 "로그인" 버튼이 표시됨.

**원인**

- 기존 `header.jsp`는 `HttpSession`에 직접 저장된 `member` 객체의 존재 여부로 로그인 상태를 판단.
- Spring Security는 인증 정보를 `SecurityContext` 내부의 `Principal`로 관리하므로, 세션 속성(`sessionScope.member`)은 비어 있음.

**수정 내역**

- **[header.jsp](file:///d:/projects/spring_workspace2/spring_project/src/main/webapp/WEB-INF/views/layout/header.jsp)**
  - JSTL(`c:choose`) 기반 세션 체크 로직을 Spring Security Tag Library(`<sec:authorize>`, `<sec:authentication>`)로 전면 교체.
  - `isAuthenticated()`로 로그인 여부 확인 및 `principal.member.nickName`으로 사용자 이름 표시.
  - **로그아웃 처리**: CSRF 보안 정책에 따라 단순 링크(GET)를 `<form method="post">` 전송 방식으로 변경.

---

## 3. 게시판 및 댓글 기능 정상화 (Security Integration)

**문제 상황**

- 게시글 등록, 수정 시 403 Forbidden 오류 발생.
- 댓글 작성 시 "로그인이 필요합니다" 메시지가 뜨거나 등록되지 않음.

**원인**

1. **사용자 식별 불가**: 컨트롤러(`BoardController`, `ReplyController`)가 여전히 `HttpSession`을 통해 사용자 정보를 조회하고 있어, 로그인된 사용자 정보를 가져오지 못함(Null).
2. **CSRF 토큰 누락**: POST 방식의 데이터 변경 요청(글쓰기, 수정, 댓글) 시 Spring Security가 요구하는 CSRF 토큰이 누락됨.

**수정 내역**

### 3.1 컨트롤러 (Backend)

- **[BoardController.java](file:///d:/projects/spring_workspace2/spring_project/src/main/java/com/koreait/www/controller/BoardController.java)**

  - `HttpSession` 파라미터 제거.
  - `java.security.Principal`을 주입받아 인증된 사용자의 ID(Email)를 확보하도록 로직 변경.
  - `register`, `modify`, `get` 메서드에서 `principal.getName()` 사용.

- **[ReplyController.java](file:///d:/projects/spring_workspace2/spring_project/src/main/java/com/koreait/www/controller/ReplyController.java)**
  - 댓글 등록(`create`) 시 `Principal` 객체를 통해 요청자를 식별하도록 변경.

### 3.2 뷰 (Frontend)

- **[register.jsp](file:///d:/projects/spring_workspace2/spring_project/src/main/webapp/WEB-INF/views/board/register.jsp) & [modify.jsp](file:///d:/projects/spring_workspace2/spring_project/src/main/webapp/WEB-INF/views/board/modify.jsp)**

  - `<form>` 태그 내부에 CSRF 히든 필드 추가: `<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />`
  - 작성자(`writer`) 입력란에 `<sec:authentication ...>`을 사용하여 로그인한 사용자 닉네임이 자동 입력되도록 수정.

- **[get.jsp](file:///d:/projects/spring_workspace2/spring_project/src/main/webapp/WEB-INF/views/board/get.jsp)**
  - **Meta Tag 추가**: CSRF 토큰과 헤더 이름을 `<meta>` 태그로 렌더링.
  - **AJAX 설정**: 모든 AJAX 요청 전송 시(`ajaxSend`), 헤더에 CSRF 토큰을 포함하도록 JavaScript 설정 추가.
  - 댓글 작성자 필드에 인증된 사용자 정보 바인딩.

---

## 4. 최종 결과

- Spring Security의 인증 체계(SecurityContext)와 애플리케이션의 비즈니스 로직(게시판/댓글)이 정상적으로 연동됨.
- 보안 토큰(CSRF) 전송이 보장되어 403 오류 없이 데이터 등록/수정이 가능해짐.
