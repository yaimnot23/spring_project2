<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board Register</title>

<link href="/resources/css/bootstrap.min.css" rel="stylesheet">
<script src="/resources/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<style>
    .container { margin-top: 30px; }
</style>
</head>
<body>

<jsp:include page="../layout/header.jsp" />

<div class="container">
    <h2 class="mb-4">게시글 등록</h2>

    <div class="card">
        <div class="card-header">Board Register</div>
        <div class="card-body">
            <form role="form" action="/board/register" method="post">
                <div class="mb-3">
                    <label class="form-label">제목</label>
                    <input class="form-control" name="title" placeholder="제목을 입력하세요">
                </div>
                
                <div class="mb-3">
                    <label class="form-label">내용</label>
                    <textarea class="form-control" rows="5" name="content" placeholder="내용을 입력하세요"></textarea>
                </div>
                
                <div class="mb-3">
                    <label class="form-label">작성자</label>
                    <input class="form-control" name="writer" placeholder="작성자를 입력하세요">
                </div>
                
                <button type="submit" class="btn btn-primary">등록</button>
                <button type="reset" class="btn btn-warning">초기화</button>
                <a href="/board/list" class="btn btn-secondary">목록</a>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../layout/footer.jsp" />

</body>
</html>