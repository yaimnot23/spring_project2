# 관리자 기능 및 보안 구현 상세 보고서 (Admin & Security Implementation Details)

**작성일**: 2025-12-15
**작성자**: Antigravity AI

이 문서는 프로젝트에 적용된 **권한 기반 보안 로직**, **관리자 전용 회원 목록 기능**, 그리고 **트러블슈팅(오류 수정)** 내역을 상세히 기록한 문서입니다. 향후 유지보수 및 학습 시 참고하시기 바랍니다.

---

## 1. 로그인 리다이렉션 로직 개선 (Login Redirection)

### **기존 문제점**

- 로그인 성공 시 역할(Role)에 따라 `/sample/admin` 또는 `/sample/member` 페이지로 이동했습니다.
- 실제 서비스에서는 로그인 후 메인 페이지나 원래 보던 페이지로 가는 것이 자연스럽습니다.

### **수정 내용**

- **파일**: `src/main/java/com/koreait/www/security/LoginSuccessHandler.java`
- **변경 사항**: 역할별 리다이렉션 로직을 제거하고, 모든 로그인 성공 사용자를 메인 페이지(`/`)로 이동시키도록 변경했습니다.

```java
// 변경 전
if (roleNames.contains("ROLE_ADMIN")) { response.sendRedirect("/sample/admin"); return; }
if (roleNames.contains("ROLE_USER")) { response.sendRedirect("/sample/member"); return; }

// 변경 후
response.sendRedirect("/");
```

---

## 2. 게시판 비즈니스 로직 보안 강화 (Business Logic Security)

### **목표**

- 클라이언트(JSP)에서 버튼을 숨기는 것만으로는 부족합니다. URL 조작이나 API 툴을 통한 접근을 막아야 합니다.
- **작성자 본인** 또는 **관리자**만 게시글/댓글을 수정하거나 삭제할 수 있어야 합니다.

### **구현 상세**

#### **A. 게시글(Board) 보안**

- **파일**: `src/main/java/com/koreait/www/controller/BoardController.java`
- **메서드**: `modify` (POST), `remove` (POST)
- **로직**:
  1. `Principal` 객체가 없으면(비로그인) 로그인 페이지로 리다이렉트.
  2. DB에서 해당 게시글(`Service.get`)을 조회하여 **작성자(Writer)** 정보를 가져옴.
  3. `Principal.getName()`(로그인 유저)과 `BoardVO.getWriter()`(작성자)가 일치하는지 확인.
  4. `request.isUserInRole("ROLE_ADMIN")`으로 관리자 여부 확인.
  5. 둘 다 아니면 `/board/list`로 강제 이동시킴 (권한 없음).

#### **B. 댓글(Reply) 보안**

- **파일**: `src/main/java/com/koreait/www/controller/ReplyController.java`
- **메서드**: `modify` (PUT/PATCH), `remove` (DELETE)
- **로직**:
  - REST API 방식이므로 `ResponseEntity`를 통해 **401 Unauthorized** (비로그인) 또는 **403 Forbidden** (권한 없음) 상태 코드를 반환.
  - 게시글과 마찬가지로 DB 조회 후 작성자/관리자 여부를 엄격히 체크.

---

## 3. 관리자 전용 '회원 목록' 기능 구현 (Admin Member List)

### **목표**

- 관리자 권한(`ROLE_ADMIN`)을 가진 사용자만 전체 회원 목록을 조회할 수 있어야 합니다.
- 회원 정보(이메일, 닉네임, 가입일, 권한 등)를 카드 UI로 시각화합니다.

### **구현 단계 (Full Stack)**

1.  **데이터베이스 계층 (`MemberMapper`)**
    - **Interface**: `List<MemberVO> getList()` 메서드 추가.
    - **XML**: `Member` 테이블과 `Auth` 테이블을 `LEFT OUTER JOIN`하여 회원 정보와 권한을 한 번에 가져오는 쿼리 작성 (`resultMap` 활용).
2.  **서비스 계층 (`MemberService`)**

    - `getList()` 메서드를 통해 Mapper의 데이터를 Controller로 전달.

3.  **컨트롤러 계층 (`MemberController`)**

    - **Endpoint**: `/member/list` (GET)
    - **보안 어노테이션**: `@PreAuthorize("hasRole('ROLE_ADMIN')")`을 사용하여 메서드 레벨에서 관리자 외 접근 원천 차단.
    - 모델(Model)에 `list` 속성으로 회원 목록 담아서 뷰로 전달.

4.  **뷰 계층 (`member/list.jsp`)**

    - 부트스트랩(Bootstrap) 카드 컴포넌트를 사용하여 반복문(`c:forEach`)으로 회원 정보를 출력.
    - **파일 경로**: `WEB-INF/views/member/list.jsp`

5.  **접근 제어 (`SecurityConfig.java`)**

    - URL 보안 설정 추가: `.antMatchers("/member/list").access("hasRole('ROLE_ADMIN')")`
    - 이중 보안 장치 (URL 필터 + 컨트롤러 메서드 보안)

6.  **네비게이션바 (`header.jsp`)**
    - 관리자에게만 보이도록 `<sec:authorize access="hasRole('ROLE_ADMIN')">` 태그로 '회원목록' 링크를 감쌈.

---

## 4. 트러블슈팅: 헤더(Header) JSP 문법 오류 수정

### **발생한 문제**

- **에러 메시지**: `org.apache.jasper.JasperException ... /WEB-INF/views/layout/header.jsp`
- **원인**: `header.jsp` 수정 중 `<sec:authorize>` 태그가 닫히지 않고 중복으로 포함되는 문법 오류 발생.

### **해결 방법**

- 중복되고 닫히지 않은 `<sec:authorize access="isAuthenticated()">` 태그 라인을 찾아 제거하고, 계층 구조를 올바르게 정리하였습니다.

---

## 5. 향후 관리 가이드

### **새로운 관리자 추가 방법**

SQL을 통해 직접 권한을 부여해야 가장 안전하고 확실합니다.

```sql
-- 1. 먼저 웹사이트에서 회원가입 진행
-- 2. SQL 실행
INSERT INTO auth (email, auth) VALUES ('가입한이메일', 'ROLE_ADMIN');
```

### **기능 확장 제안**

- **회원 강제 탈퇴**: 회원 목록 카드에 '삭제' 버튼을 만들고, 관리자만 호출 가능한 API(`MemberController`에 `delete` 메서드 추가)를 연결.
- **권한 수정**: 회원의 권한을 UI에서 `USER` <-> `ADMIN` 변경하는 기능.

---

## 6. 사용자 지정 404 에러 페이지 (Custom 404 Error Page)

### **목표**

- 존재하지 않는 페이지(404) 접근 시, 딱딱한 기본 톰캣 오류 화면 대신 **GitHub 스타일의 커스텀 디자인**을 보여줍니다.

### **구현 상세**

1.  **설정 (`WebConfig.java`)**

    - `DispatcherServlet`이 404 발생 시 예외를 던지도록 설정.
    - `registration.setInitParameter("throwExceptionIfNoHandlerFound", "true");`

2.  **전역 예외 처리 (`CommonExceptionAdvice.java`)**

    - `@ControllerAdvice`를 사용하여 모든 컨트롤러에서 발생하는 예외를 감지.
    - `NoHandlerFoundException`을 잡아 `error/404` 뷰를 리턴.

3.  **화면 디자인 (`error/404.jsp`)**
    - GitHub의 다크 모드 테마를 참고하여 우주 배경과 떠다니는 우주인 애니메이션 적용.
    - 홈으로 돌아가는 버튼 제공.
