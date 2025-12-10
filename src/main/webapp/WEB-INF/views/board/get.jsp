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
    /* 첨부파일 영역 스타일 */
    .uploadResult { margin-top: 20px; background-color: #f8f9fa; border-radius: 5px; padding: 15px; }
    .uploadResult ul { display: flex; flex-wrap: wrap; list-style: none; padding: 0; margin: 0; }
    .uploadResult li { margin: 10px; text-align: center; }
    .uploadResult li img { width: 100px; height: 100px; object-fit: cover; border-radius: 5px; cursor: pointer; }
    .uploadResult li span { display: block; margin-top: 5px; font-size: 12px; color: #555; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; max-width: 100px; }
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

            <c:if test="${not empty board.attachList}">
                <div class="mb-3">
                    <label class="form-label fw-bold">첨부파일</label>
                    <div class="uploadResult border p-3">
                        <ul>
                            <c:forEach items="${board.attachList}" var="file">
                                <c:set var="fileCallPath" value="/upload/${file.uploadPath}/${file.uuid}_${file.fileName}" />
                                <c:set var="thumbCallPath" value="/upload/${file.uploadPath}/s_${file.uuid}_${file.fileName}" />
                                
                                <li>
                                    <c:if test="${file.fileType}">
                                        <a href="${fileCallPath}" target="_blank">
                                            <img src="${thumbCallPath}" alt="${file.fileName}">
                                        </a>
                                    </c:if>
                                    
                                    <c:if test="${!file.fileType}">
                                        <a href="${fileCallPath}" target="_blank">
                                            <div style="width: 100px; height: 100px; background: #e9ecef; display: flex; align-items: center; justify-content: center; border-radius: 5px;">
                                                <i class="fa-regular fa-file-lines fa-2x text-secondary"></i>
                                            </div>
                                        </a>
                                    </c:if>
                                    
                                    <span>${file.fileName}</span>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
            </c:if>
            <div class="mt-4">
                <button data-oper='modify' class="btn btn-primary">수정</button>
                <button data-oper='list' class="btn btn-secondary">목록</button>
            </div>
            
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
        operForm.attr("action", "/board/modify").submit();
    });

    $("button[data-oper='list']").on("click", function(e){
        operForm.find("#bno").remove();
        operForm.attr("action", "/board/list");
        operForm.submit();
    });
    
    // 2. 댓글(Reply) 관련 기능 (Ajax)
    var bnoValue = '<c:out value="${board.bno}"/>';
    var replyUL = $("#replyList");

    showList();

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
                str += '    <div class="fw-bold mb-1">' + data[i].replyer + ' <small class="text-muted fw-normal ms-2">' + displayTime(data[i].replyDate) + '</small></div>';
                str += '    <span>' + data[i].reply + '</span>';
                str += '  </div>';
                str += '  <button class="btn btn-sm btn-outline-danger removeBtn" data-rno="' + data[i].rno + '">삭제</button>';
                str += '</li>';
            }
            replyUL.html(str);
        });
    }
    
    function displayTime(timeValue) {
        var today = new Date();
        var gap = today.getTime() - timeValue;
        var dateObj = new Date(timeValue);
        var str = "";

        if (gap < (1000 * 60 * 60 * 24)) { 
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
                    $("#reply").val(""); 
                    showList(); 
                }
            },
            error: function(xhr, status, er) {
                alert("등록 에러");
            }
        });
    });

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