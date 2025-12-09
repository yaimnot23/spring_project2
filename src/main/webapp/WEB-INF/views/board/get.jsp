<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board Read</title>

<link href="/resources/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<script src="/resources/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<style>
    .container { margin-top: 30px; }
</style>
</head>
<body>

<jsp:include page="../layout/header.jsp" />

<div class="container pb-5">
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
            
            <hr class="my-4">
            
            <div class="mb-4">
                <h5><i class="fa-regular fa-comments"></i> 댓글</h5>
                <div class="d-flex gap-2">
                    <input type="text" class="form-control" id="reply" placeholder="댓글 내용">
                    <input type="text" class="form-control" id="replyer" placeholder="작성자" style="width: 150px;" value="${member.id}" readonly>
                    <button id="addReplyBtn" class="btn btn-dark">등록</button>
                </div>
            </div>

            <ul class="list-group" id="replyList">
                </ul>
            
        </div>
    </div>
</div>

<jsp:include page="../layout/footer.jsp" />

<script type="text/javascript">
$(document).ready(function(){
    
    // ==========================================
    // 1. 게시글 관련 버튼 이벤트 (수정, 목록)
    // ==========================================
    var operForm = $("#operForm");

    $("button[data-oper='modify']").on("click", function(e){
        // 수정 버튼 클릭 시 폼 전송
        operForm.attr("action", "/board/modify").submit();
    });

    $("button[data-oper='list']").on("click", function(e){
        // 목록 버튼 클릭 시 bno 태그를 제거하고 목록으로 이동
        operForm.find("#bno").remove();
        operForm.attr("action", "/board/list");
        operForm.submit();
    });
    
    // 2. 댓글(Reply) 관련 기능 (Ajax)
    
    var bnoValue = '<c:out value="${board.bno}"/>';
    var replyUL = $("#replyList");

    // 페이지 로드 시 댓글 목록 가져오기
    showList();

    // [함수] 댓글 목록 출력
    function showList() {
        $.getJSON("/replies/pages/" + bnoValue, function(data) {
            var str = "";
            
            if(data == null || data.length == 0) {
                replyUL.html('<li class="list-group-item text-center text-muted">등록된 댓글이 없습니다.</li>');
                return;
            }

            for (var i = 0, len = data.length || 0; i < len; i++) {
                str += '<li class="list-group-item d-flex justify-content-between align-items-center">';
                str += '  <div>';
                // 작성자와 작성시간 표시 (displayTime 함수 사용)
                str += '    <div class="fw-bold mb-1">' + data[i].replyer + ' <small class="text-muted fw-normal ms-2">' + displayTime(data[i].replyDate) + '</small></div>';
                str += '    <span>' + data[i].reply + '</span>';
                str += '  </div>';
                // 삭제 버튼 (data-rno 속성에 댓글 번호 저장)
                str += '  <button class="btn btn-sm btn-outline-danger removeBtn" data-rno="' + data[i].rno + '">삭제</button>';
                str += '</li>';
            }
            replyUL.html(str);
        });
    }
    
    // [함수] 날짜 포맷팅 (오늘이면 시간, 아니면 날짜)
    function displayTime(timeValue) {
        var today = new Date();
        var gap = today.getTime() - timeValue;
        var dateObj = new Date(timeValue);
        var str = "";

        if (gap < (1000 * 60 * 60 * 24)) { // 24시간 이내
            var hh = dateObj.getHours();
            var mi = dateObj.getMinutes();
            var ss = dateObj.getSeconds();
            return [ (hh > 9 ? '' : '0') + hh, ':', (mi > 9 ? '' : '0') + mi, ':', (ss > 9 ? '' : '0') + ss ].join('');
        } else {
            var yy = dateObj.getFullYear();
            var mm = dateObj.getMonth() + 1; 
            var dd = dateObj.getDate();
            return [ yy, '/', (mm > 9 ? '' : '0') + mm, '/', (dd > 9 ? '' : '0') + dd ].join('');
        }
    }

    // [이벤트] 댓글 등록 버튼 클릭
    $("#addReplyBtn").on("click", function(e){
        var reply = {
            reply: $("#reply").val(),
            replyer: $("#replyer").val(),
            bno: bnoValue
        };
        
        if(!reply.reply) { alert("댓글 내용을 입력하세요"); return; }
        if(!reply.replyer) { alert("로그인이 필요합니다"); return; }

        $.ajax({
            type: 'post',
            url: '/replies/new',
            data: JSON.stringify(reply),
            contentType: "application/json; charset=utf-8",
            success: function(result, status, xhr) {
                if (result === "success") {
                    alert("댓글이 등록되었습니다.");
                    $("#reply").val(""); // 입력창 비우기
                    showList(); // 목록 갱신
                }
            },
            error: function(xhr, status, er) {
                alert("등록 에러");
            }
        });
    });

    // [이벤트] 댓글 삭제 버튼 클릭 (이벤트 위임)
    replyUL.on("click", ".removeBtn", function(e){
        var rno = $(this).data("rno");
        
        if(!confirm("삭제하시겠습니까?")) return;

        $.ajax({
            type: 'delete',
            url: '/replies/' + rno,
            success: function(deleteResult, status, xhr) {
                if (deleteResult === "success") {
                    alert("삭제되었습니다.");
                    showList();
                }
            },
            error: function(xhr, status, er) {
                alert("삭제 실패");
            }
        });
    });

});
</script>

</body>
</html>