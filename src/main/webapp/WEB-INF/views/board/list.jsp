<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board List</title>

<link href="/resources/css/bootstrap.min.css" rel="stylesheet">

<script src="/resources/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<style>
    .container { margin-top: 30px; }
    table { text-align: center; }
    th { text-align: center; }
    a { text-decoration: none; color: black; } 
    a:hover { color: blue; }
</style>
</head>
<body>

<jsp:include page="../layout/header.jsp" />

<div class="container">
    <h2 class="mb-4">자유 게시판</h2>
    
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <span>Board List Page</span>
            <button id="regBtn" type="button" class="btn btn-sm btn-primary">글쓰기</button>
        </div>
        
        <div class="card-body">
            <table class="table table-striped table-bordered table-hover">
                <thead class="table-light">
                    <tr>
                        <th style="width: 10%;">번호</th>
                        <th style="width: 40%;">제목</th>
                        <th style="width: 15%;">작성자</th>
                        <th style="width: 20%;">작성일</th>
                        <th style="width: 10%;">조회수</th>
                    </tr>
                </thead>
                
                <tbody>
                    <c:forEach items="${list}" var="board">
                        <tr>
                            <td>${board.bno}</td>
                            <td style="text-align: left;">
                                <a href="/board/get?bno=${board.bno}">${board.title}</a>
                            </td>
                            <td>${board.writer}</td>
                            <td>
                                <fmt:formatDate pattern="yyyy-MM-dd" value="${board.regDate}"/>
                            </td>
                            <td>${board.readCount}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <c:if test="${empty list}">
                <div class="alert alert-info text-center">
                    등록된 게시글이 없습니다.
                </div>
            </c:if>
            
        </div>
    </div>
</div>

<div class="modal fade" id="myModal" tabindex="-1" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="myModalLabel">알림</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                처리가 완료되었습니다.
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
$(document).ready(function() {
    
    var result = '<c:out value="${result}"/>';
    
    checkModal(result);
    
    history.replaceState({}, null, null);

    function checkModal(result) {
        if (result === '' || history.state) {
            return;
        }
        
        if (parseInt(result) > 0) {
            $(".modal-body").html("게시글 " + parseInt(result) + "번이 등록되었습니다.");
        }
        
        var myModal = new bootstrap.Modal(document.getElementById('myModal'));
        myModal.show();
    }
    
    $("#regBtn").on("click", function() {
        self.location = "/board/register";
    });
    
});
<jsp:include page="./layout/footer.jsp" />
</script>

</body>
</html>