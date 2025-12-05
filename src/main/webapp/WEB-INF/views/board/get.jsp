<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board Read</title>

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
    <h2 class="mb-4">게시글 상세</h2>

    <div class="card">
        <div class="card-header">Board Read Page</div>
        <div class="card-body">
            <div class="mb-3">
                <label class="form-label">번호</label>
                <input class="form-control" name="bno" value="${board.bno}" readonly>
            </div>
            
            <div class="mb-3">
                <label class="form-label">제목</label>
                <input class="form-control" name="title" value="${board.title}" readonly>
            </div>
            
            <div class="mb-3">
                <label class="form-label">내용</label>
                <textarea class="form-control" rows="5" name="content" readonly>${board.content}</textarea>
            </div>
            
            <div class="mb-3">
                <label class="form-label">작성자</label>
                <input class="form-control" name="writer" value="${board.writer}" readonly>
            </div>
            
            <button data-oper='modify' class="btn btn-primary">수정</button>
            <button data-oper='list' class="btn btn-secondary">목록</button>
            
            <form id="operForm" action="/board/modify" method="get">
                <input type="hidden" id="bno" name="bno" value="${board.bno}">
            </form>
        </div>
    </div>
</div>

<jsp:include page="../layout/footer.jsp" />

<script type="text/javascript">
$(document).ready(function(){
    
    var operForm = $("#operForm");
    
    // 버튼 클릭 이벤트 처리
    $("button[data-oper='modify']").on("click", function(e){
        // 수정 버튼 클릭 시 폼 전송 (action="/board/modify")
        operForm.attr("action", "/board/modify").submit();
    });
    
    $("button[data-oper='list']").on("click", function(e){
        // 목록 버튼 클릭 시 bno 태그를 제거하고 목록으로 이동
        operForm.find("#bno").remove();
        operForm.attr("action", "/board/list");
        operForm.submit();
    });
});
</script>

</body>
</html>