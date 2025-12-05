<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>메인 페이지</title>
    
    <link href="/resources/css/bootstrap.min.css" rel="stylesheet">
    
    <script src="/resources/js/bootstrap.bundle.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    
    <style>
        .main-box { text-align: center; margin-top: 50px; }
    </style>
</head>
<body>

<jsp:include page="./layout/header.jsp" />

<div class="container">
    <div class="p-5 mb-4 bg-light rounded-3 main-box">
        <div class="container-fluid py-5">
            <h1 class="display-5 fw-bold">Welcome Spring Project!</h1>
            <p class="col-md-8 fs-4" style="margin: 0 auto;">스프링 MVC 게시판 프로젝트 메인 화면입니다.</p>
            <p>현재 서버 시간: <strong>${serverTime}</strong></p>
            
            <hr class="my-4">
            
            <a href="/board/list" class="btn btn-primary btn-lg" type="button">게시판 목록 보러가기 &raquo;</a>
            <button class="btn btn-secondary btn-lg" disabled>회원 관리 (준비중)</button>
        </div>
    </div>
</div>
<jsp:include page="./layout/footer.jsp" />
</body>
</html>