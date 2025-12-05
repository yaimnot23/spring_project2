<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Board List</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f8f9fa;
        }
        /* 카드 스타일 */
        .card {
            border: none;
            border-radius: 12px;
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
            transition: all 0.3s ease;
            cursor: pointer;
            height: 100%; /* 카드 높이 통일 */
        }
        /* 마우스 올렸을 때 효과 */
        .card:hover {
            transform: translateY(-7px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
        }
        .card-body {
            padding: 1.5rem;
        }
        .card-title {
            font-weight: 700;
            font-size: 1.15rem;
            color: #333;
            margin-bottom: 0.8rem;
            
            /* 제목 한 줄 말줄임 */
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .card-text {
            color: #666;
            font-size: 0.95rem;
            line-height: 1.5;
            min-height: 3rem;
            
            /* 내용 두 줄 말줄임 */
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .writer-badge {
            background-color: #eef1f6;
            color: #555;
            padding: 4px 10px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.8rem;
        }
        .card-footer {
            background-color: transparent;
            border-top: 1px solid #f0f0f0;
            padding: 1rem 1.5rem;
        }
        .meta-text {
            font-size: 0.85rem;
            color: #aaa;
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm mb-5 sticky-top">
        <div class="container">
            <a class="navbar-brand fw-bold" href="/www/"><i class="fa-solid fa-code text-primary"></i> My DevLog</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link active fw-bold" href="/www/board/list">게시판</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">로그인</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container pb-5">
        <div class="d-flex justify-content-between align-items-end mb-4 px-2">
            <div>
                <h2 class="fw-bold m-0"><i class="fa-solid fa-layer-group text-primary"></i> 최신 글 목록</h2>
                <small class="text-muted">개발 지식과 경험을 공유하는 공간입니다.</small>
            </div>
            <a href="/www/board/register" class="btn btn-primary rounded-pill px-4 py-2 shadow-sm fw-bold">
                <i class="fa-solid fa-pen me-1"></i> 글쓰기
            </a>
        </div>

        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
            
            <c:forEach items="${list}" var="board">
                <div class="col">
                    <div class="card h-100" onclick="location.href='/www/board/get?bno=${board.bno}'">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <span class="writer-badge">
                                    <i class="fa-regular fa-user me-1"></i> ${board.writer}
                                </span>
                                <small class="text-muted">
                                    <i class="fa-regular fa-eye me-1"></i> ${board.read_count}
                                </small>
                            </div>
                            
                            <h5 class="card-title">${board.title}</h5>
                            
                            <p class="card-text">${board.content}</p>
                        </div>
                        
                        <div class="card-footer">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="meta-text">
                                    <i class="fa-regular fa-clock me-1"></i> 
                                    <fmt:formatDate value="${board.reg_date}" pattern="yyyy-MM-dd"/>
                                </span>
                                <span class="text-primary fw-bold" style="font-size: 0.9rem;">
                                    Read More <i class="fa-solid fa-arrow-right ms-1"></i>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
            </div> <c:if test="${empty list}">
            <div class="text-center py-5 my-5 bg-white rounded shadow-sm">
                <i class="fa-regular fa-folder-open fa-3x text-secondary mb-3"></i>
                <h5 class="text-muted">등록된 게시글이 없습니다.</h5>
                <p class="text-muted small">첫 번째 게시글의 주인공이 되어보세요!</p>
            </div>
        </c:if>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>