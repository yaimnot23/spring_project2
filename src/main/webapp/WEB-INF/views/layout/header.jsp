<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
  <div class="container-fluid">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/">Spring Project</a>
    
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
      <span class="navbar-toggler-icon"></span>
    </button>
    
    <div class="collapse navbar-collapse" id="navbarCollapse">
      <ul class="navbar-nav me-auto mb-2 mb-md-0">
        <li class="nav-item">
          <a class="nav-link active" href="${pageContext.request.contextPath}/">Home</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/board/list">게시판</a>
        </li>
      </ul>
      
      <ul class="navbar-nav ms-auto">
        <c:choose>
            <%-- 세션에 'member'가 비어있으면 (비로그인) --%>
            <c:when test="${empty sessionScope.member}">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/member/login">
                        <i class="fa-solid fa-right-to-bracket"></i> 로그인
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">회원가입</a>
                </li>
            </c:when>
            
            <%-- 세션에 'member'가 있으면 (로그인 성공) --%>
            <c:otherwise>
                <li class="nav-item me-3">
                    <span class="nav-link text-white">
                        <i class="fa-solid fa-user"></i> <strong>${sessionScope.member.name}</strong>님
                    </span>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/member/logout">
                        <i class="fa-solid fa-right-from-bracket"></i> 로그아웃
                    </a>
                </li>
            </c:otherwise>
        </c:choose>
      </ul>
      
    </div>
  </div>
</nav>