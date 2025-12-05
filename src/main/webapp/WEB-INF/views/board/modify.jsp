<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board Modify</title>

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
    <h2 class="mb-4">게시글 수정/삭제</h2>

    <div class="card">
        <div class="card-header">Board Modify Page</div>
        <div class="card-body">
            
            <form role="form" action="/board/modify" method="post">
                <div class="mb-3">
                    <label class="form-label">번호</label>
                    <input class="form-control" name="bno" value="${board.bno}" readonly>
                </div>
                
                <div class="mb-3">
                    <label class="form-label">제목</label>
                    <input class="form-control" name="title" value="${board.title}">
                </div>
                
                <div class="mb-3">
                    <label class="form-label">내용</label>
                    <textarea class="form-control" rows="5" name="content">${board.content}</textarea>
                </div>
                
                <div class="mb-3">
                    <label class="form-label">작성자</label>
                    <input class="form-control" name="writer" value="${board.writer}" readonly>
                </div>
                
                <div class="mb-3">
                    <label class="form-label">작성일</label>
                    <input class="form-control" name="regDate" 
                        value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.regDate}"/>' readonly>
                </div>
                
                <button type="submit" data-oper='modify' class="btn btn-primary">수정</button>
                <button type="submit" data-oper='remove' class="btn btn-danger">삭제</button>
                <button type="submit" data-oper='list' class="btn btn-secondary">목록</button>
            </form>
            
        </div>
    </div>
</div>

<jsp:include page="../layout/footer.jsp" />

<script type="text/javascript">
$(document).ready(function() {
    
    var formObj = $("form");
    
    $('button').on("click", function(e){
        // 기본 submit 동작 막기
        e.preventDefault();
        
        var operation = $(this).data("oper");
        
        console.log(operation);
        
        if(operation === 'remove'){
            // 삭제 버튼: action을 remove로 변경 후 전송
            formObj.attr("action", "/board/remove");
            
        } else if(operation === 'list'){
            // 목록 버튼: action을 list로 변경, method는 get으로 변경
            // 목록 이동 시에는 입력 데이터가 필요 없으므로 내부 내용을 비우거나, 
            // self.location을 사용하는 방법도 있습니다. 여기선 location 이동 사용.
            self.location = "/board/list";
            return;
            
        } 
        // 수정 버튼(modify)은 기본 action="/board/modify" 유지
        
        formObj.submit();
    });
});
</script>

</body>
</html>