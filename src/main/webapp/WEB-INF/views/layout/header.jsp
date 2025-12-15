<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
  <div class="container-fluid">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/"
      >Spring Project</a
    >

    <button
      class="navbar-toggler"
      type="button"
      data-bs-toggle="collapse"
      data-bs-target="#navbarCollapse"
    >
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarCollapse">
      <ul class="navbar-nav me-auto mb-2 mb-md-0">
        <li class="nav-item">
          <a class="nav-link active" href="${pageContext.request.contextPath}/"
            >Home</a
          >
        </li>
        <li class="nav-item">
          <a
            class="nav-link"
            href="${pageContext.request.contextPath}/board/list"
            >게시판</a
          >
        </li>
      </ul>

      <ul class="navbar-nav ms-auto">
        <!-- 스프링 시큐리티 태그 라이브러리 사용 -->
        <%@ taglib uri="http://www.springframework.org/security/tags"
        prefix="sec" %>

        <!-- 비로그인 사용자 -->
        <sec:authorize access="isAnonymous()">
          <li class="nav-item">
            <a
              class="nav-link"
              href="${pageContext.request.contextPath}/member/login"
            >
              <i class="fa-solid fa-right-to-bracket"></i> 로그인
            </a>
          </li>
          <li class="nav-item">
            <a
              class="nav-link"
              href="${pageContext.request.contextPath}/member/signup"
              >회원가입</a
            >
          </li>
        </sec:authorize>

        <!-- 로그인 사용자 -->
        <sec:authorize access="isAuthenticated()">
          <li class="nav-item me-3">
            <span class="nav-link text-white">
              <!-- Principal에서 커스텀 필드 접근: principal.member.nickName -->
              <i class="fa-solid fa-user"></i>
              <strong
                ><sec:authentication
                  property="principal.member.nickName" /></strong
              >님 (<sec:authentication property="principal.member.email" />)
            </span>
          </li>
          <li class="nav-item">
            <!-- 로그아웃은 POST로 보내야 함. 링크 대신 폼이나 JS 사용 필요하지만, SecurityConfig에서 GET 로그아웃 허용 여부/CSRF 확인 필요. 
            	     일단 기존 링크 유지하되, SecurityConfig가 로그아웃을 어떻게 처리하는지 확인 후 수정.
            	     SecurityConfig에 .logoutRequestMatcher(new AntPathRequestMatcher("/member/logout")) 설정 없으면 POST만 가능할 수 있음.
            	     여기서는 간단히 링크 클릭 시 JS로 POST 전송하거나, SecurityConfig에서 GET 허용해야 함.
            	     -> SecurityConfig 확인 결과 logoutUrl("/member/logout")만 있음. 기본적으로 POST만 허용됨 (CSRF 켜져있어서).
            	-->
            <a
              class="nav-link"
              href="#"
              onclick="document.getElementById('logout-form').submit();"
            >
              <i class="fa-solid fa-right-from-bracket"></i> 로그아웃
            </a>
            <form
              id="logout-form"
              action="${pageContext.request.contextPath}/member/logout"
              method="post"
              style="display: none"
            >
              <input
                type="hidden"
                name="${_csrf.parameterName}"
                value="${_csrf.token}"
              />
            </form>
          </li>
        </sec:authorize>
      </ul>
    </div>
  </div>
</nav>
