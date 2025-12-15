# Development Log & Project Overview

이 문서는 프로젝트의 진행 상황, 주요 기능, 기술 스택 및 구현 이력을 종합적으로 정리한 문서입니다. 프록젝트의 전체적인 구조와 흐름을 파악하는 데 사용됩니다.

---

## 1. 프로젝트 개요 (Project Overview)

**Spring Framework (Legacy)** 기반의 웹 애플리케이션으로, 게시판 기능을 중심으로 회원가입, 로그인, 댓글, 파일 첨부 기능을 포함하고 있습니다. 현재 Spring Security를 도입하여 보안성을 강화하는 단계에 있습니다.

## 2. 기술 스택 (Tech Stack)

### Backend

- **Framework**: Spring Framework 5.3.10
- **Language**: Java 11
- **Database**: MySQL 8.0.33
- **ORM / Mapper**: MyBatis 3.5.10, MyBatis-Spring 2.0.6
- **Connection Pool**: HikariCP 5.0.1
- **Security**: Spring Security 5.5.3 (BCrypt 암호화)
- **Utilities**: Lombok, Jackson (JSON 처리)

### Frontend

- **View Engine**: JSP (JavaServer Pages), JSTL
- **Styling**: Bootstrap (CSS)
- **Library**: jQuery (AJAX 요청 및 DOM 조작 예상)

### File Handling

- **Library**: Commons FileUpload, Commons IO
- **Check**: Apache Tika (MIME Type 감지)
- **Image**: Thumbnailator (썸네일 생성)

---

## 3. 주요 기능 (Key Features)

### 3.1 회원 관리 (Member Management)

- **회원가입**: 이메일, 비밀번호, 닉네임 입력. 비밀번호는 BCrypt로 해시(암호화) 저장. 기본 권한 `ROLE_USER` 부여.
- **로그인/로그아웃**: Spring Security `formLogin` 사용. 이메일(ID) 기반 인증.
- **권한 관리**: 사용자별 권한(`ROLE_USER`, `ROLE_ADMIN`) 부여 가능 구조 (DB `auth` 테이블 연동).

### 3.2 게시판 (Board)

- **CRUD**: 게시글 작성, 조회, 수정, 삭제.
- **페이징/검색**: `Criteria`, `PageDTO`를 활용한 페이징 처리 및 검색 기능.
- **조회수**: 게시글 조회 시 조회수 증가.

### 3.3 댓글 (Reply)

- **REST API**: 댓글 등록, 수정, 삭제, 조회를 비동기(AJAX)로 처리 (`ReplyController`).

### 3.4 파일 첨부 (File Attachment)

- **업로드**: 게시글 작성/수정 시 다중 파일 업로드 지원.
- **유효성 검사**: 파일 크기 제한 및 특정 확장자(exe 등) 업로드 차단 (`Apache Tika` 활용).
- **이미지 처리**: 이미지 파일 업로드 시 썸네일 자동 생성.

---

## 4. 구현 이력 (Implementation History)

### 2025-12-15: Spring Security 로그인 및 회원가입 고도화

**목표**: 기존 수동 세션 로그인 방식을 제거하고, Spring Security 표준 보안 모델 적용.

#### 주요 변경 사항

1.  **SecurityConfig 재구성**:
    - `formLogin` 설정 최적화 (`usernameParameter("email")`).
    - URL별 접근 권한 설정 (게시글 작성/수정/삭제는 인증된 사용자만).
2.  **회원가입 프로세스 구현**:
    - `MemberController`에 가입 요청 처리 로직 추가 (`/member/signup`).
    - `MemberServiceImpl`에서 비밀번호 암호화 및 트랜잭션 처리(회원정보+권한).
3.  **데이터베이스 계층 업데이트**:
    - `MemberMapper` XML에 회원(`member`) 및 권한(`auth`) Insert 쿼리 추가.
4.  **UI 개선**:
    - `signup.jsp` (회원가입 폼) 신규 제작.
    - `login.jsp`에 회원가입 진입 버튼 추가.

#### 관련 문서 링크

- [세부 구현 계획 (Plan)](./.gemini/antigravity/brain/4d343cd8-8f24-4808-8c9a-21312b3d59c5/implementation_plan.md)
- [검증 보고서 (Walkthrough)](./.gemini/antigravity/brain/4d343cd8-8f24-4808-8c9a-21312b3d59c5/walkthrough.md)

---

## 5. 향후 계획 및 유지보수 포인트

- **관리자 기능**: `ROLE_ADMIN` 권한을 가진 사용자를 위한 관리 페이지(회원 관리, 게시글 통합 관리) 도입 고려.
- **API 보안**: 댓글 처리 등 REST API 요청에 대한 CSRF 토큰 처리 검토.
- **테스트**: 주요 비즈니스 로직(Service)에 대한 JUnit 테스트 케이스 확충.
