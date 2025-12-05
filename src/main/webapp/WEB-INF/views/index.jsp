<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>메인 페이지</title>
    
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    
    <style>
        .jumbotron { 
            text-align: center; 
            margin-top: 50px; 
            background-color: #eeeeee;
        }
        .btn-lg { margin: 10px; }
    </style>
</head>
<body>

<div class="container">
    <div class="jumbotron">
        <h1>spring project</h1>
        <p>스프링 MVC 게시판 프로젝트 메인 화면</p>
        <p>현재 서버 시간: <strong>${serverTime}</strong></p>
        
        <hr>
        
        <a href="/board/list" class="btn btn-primary btn-lg">게시판 목록 보러가기 &raquo;</a>
        
        <button class="btn btn-default btn-lg" disabled>회원 관리 (준비중)</button>
    </div>
</div>

</body>
</html>