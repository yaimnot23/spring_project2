<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board List</title>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<style>
    .container { margin-top: 30px; }
    table { text-align: center; }
    th { text-align: center; }
</style>
</head>
<body>

<div class="container">
    <h2>자유 게시판</h2>
    <div class="panel panel-default">
        <div class="panel-heading">
            Board List Page
            <button id="regBtn" type="button" class="btn btn-xs pull-right btn-primary">글쓰기</button>
        </div>
        
        <div class="panel-body">
            <table class="table table-striped table-bordered table-hover">
                <thead>
                    <tr>
                        <th style="width: 10%;">번호</th>
                        <th style="width: 30%;">제목</th>
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
                <div class="alert alert-info" style="text-align: center;">
                    등록된 게시글이 없습니다.
                </div>
            </c:if>
            
        </div> </div> </div> <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">알림</h4>
            </div>
            <div class="modal-body">
                처리가 완료되었습니다.
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
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
        
        $("#myModal").modal("show");
    }
    
    $("#regBtn").on("click", function() {
        self.location = "/board/register";
    });
    
});
</script>

</body>
</html>