<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>DevLog Home</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f8f9fa;
        }
        .hero-section {
            background: white;
            padding: 120px 0;
            border-bottom: 1px solid #eee;
            margin-bottom: 2rem;
        }
        .btn-custom-primary {
            background-color: #0d6efd;
            border-color: #0d6efd;
            color: white;
            transition: all 0.3s;
        }
        .btn-custom-primary:hover {
            background-color: #0b5ed7;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(13, 110, 253, 0.3);
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm sticky-top">
        <div class="container">
            <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/"><i class="fa-solid fa-code text-primary"></i> My DevLog</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/board/list">게시판</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">로그인</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <section class="hero-section text-center">
        <div class="container">
            <h1 class="display-4 fw-bold mb-3">Welcome to Spring World</h1>
            <p class="lead text-muted mb-4">
                스프링 프레임워크 학습 기록과 개발 일지를 남기는 공간입니다.<br>
                깔끔하고 직관적인 카드형 게시판을 확인해보세요.
            </p>
            <div class="d-flex justify-content-center gap-3">
                <a href="${pageContext.request.contextPath}/board/list" class="btn btn-custom-primary btn-lg px-5 rounded-pill fw-bold">
                    <i class="fa-solid fa-list"></i> 게시글 보러가기
                </a>
                <a href="#" class="btn btn-outline-dark btn-lg px-5 rounded-pill">
                    <i class="fa-brands fa-github"></i> GitHub
                </a>
            </div>
            
            <div class="mt-5 p-3 d-inline-block bg-light rounded text-muted small border">
                <i class="fa-regular fa-clock"></i> Server Time: <strong>${serverTime}</strong>
            </div>
        </div>
    </section>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>