<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Member List</title>
    <link href="/resources/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<jsp:include page="../layout/header.jsp" />

<div class="container mt-5">
    <h2 class="mb-4 text-center">회원 목록 (ADMIN)</h2>

    <div class="row row-cols-1 row-cols-md-3 g-4">
        <c:forEach items="${list}" var="member">
            <div class="col">
                <div class="card h-100 shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h5 class="card-title mb-0"><c:out value="${member.nickName}" /></h5>
                    </div>
                    <div class="card-body">
                        <p class="card-text"><strong>Email:</strong> <c:out value="${member.email}" /></p>
                        <p class="card-text">
                            <strong>가입일:</strong> 
                            <fmt:formatDate value="${member.regDate}" pattern="yyyy-MM-dd HH:mm"/>
                        </p>
                        <p class="card-text">
                            <strong>마지막 로그인:</strong>
                            <c:choose>
                                <c:when test="${not empty member.lastLogin}">
                                    <fmt:formatDate value="${member.lastLogin}" pattern="yyyy-MM-dd HH:mm"/>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">기록 없음</span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <hr>
                        <p class="card-text">
                            <strong>권한:</strong><br>
                            <c:forEach items="${member.authList}" var="authVO">
                                <span class="badge bg-secondary me-1"><c:out value="${authVO.auth}" /></span>
                            </c:forEach>
                        </p>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<jsp:include page="../layout/footer.jsp" />

<script src="/resources/js/bootstrap.bundle.min.js"></script>
</body>
</html>
