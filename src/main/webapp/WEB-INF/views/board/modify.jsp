<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board Modify</title>

<link href="/resources/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"> <script src="/resources/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<style>
    .container { margin-top: 30px; }
    /* 첨부파일 영역 스타일 */
    .uploadResult { margin-top: 10px; background-color: #f8f9fa; border-radius: 5px; padding: 15px; }
    .uploadResult ul { display: flex; flex-wrap: wrap; list-style: none; padding: 0; margin: 0; }
    .uploadResult li { margin: 10px; text-align: center; }
    .uploadResult li img { width: 100px; height: 100px; object-fit: cover; border-radius: 5px; }
    .uploadResult li span { display: block; margin-top: 5px; font-size: 12px; color: #555; }
</style>
</head>
<body>

<jsp:include page="../layout/header.jsp" />

<div class="container pb-5">
    <h2 class="mb-4">게시글 수정</h2>

    <div class="card">
        <div class="card-header">Board Modify Page</div>
        <div class="card-body">
            
            <form role="form" action="/board/modify" method="post" enctype="multipart/form-data">
                
                <input type="hidden" name="pageNum" value="${cri.pageNum }">
                <input type="hidden" name="amount" value="${cri.amount }">
                <input type="hidden" name="type" value="${cri.type }">
                <input type="hidden" name="keyword" value="${cri.keyword }">
            
                <div class="mb-3">
                    <label class="form-label">번호</label>
                    <input class="form-control" name="bno" value="${board.bno}" readonly>
                </div>
                
                <div class="mb-3">
                    <label class="form-label">제목</label>
                    <input class="form-control" name="title" value="${board.title}" required>
                </div>
                
                <div class="mb-3">
                    <label class="form-label">내용</label>
                    <textarea class="form-control" rows="10" name="content" required>${board.content}</textarea>
                </div>
                
                <div class="mb-3">
                    <label class="form-label">작성자</label>
                    <input class="form-control" name="writer" value="${board.writer}" readonly>
                </div>
                
                <div class="mb-3">
                    <label class="form-label">작성일</label>
                    <input class="form-control" value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.regDate}"/>' readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">기존 첨부파일</label>
                    <div class="uploadResult border">
                        <ul>
                            <c:forEach items="${board.attachList}" var="file">
                                <c:set var="thumbCallPath" value="/upload/${file.uploadPath}/s_${file.uuid}_${file.fileName}" />
                                
                                <li>
                                    <c:choose>
                                        <c:when test="${file.fileType}">
                                            <img src="${thumbCallPath}" alt="${file.fileName}">
                                        </c:when>
                                        <c:otherwise>
                                            <div style="width: 100px; height: 100px; background: #e9ecef; display: flex; align-items: center; justify-content: center; border-radius: 5px; margin: 0 auto;">
                                                <i class="fa-regular fa-file-lines fa-2x text-secondary"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <span>${file.fileName}</span>
                                </li>
                            </c:forEach>
                            <c:if test="${empty board.attachList}">
                                <li class="w-100 text-center text-muted">기존 첨부파일이 없습니다.</li>
                            </c:if>
                        </ul>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-bold">새 파일 추가</label>
                    <input type="file" class="form-control" name="uploadFiles" multiple>
                    <div class="form-text">새로운 파일을 추가하려면 선택하세요.</div>
                </div>
                
                <div class="d-flex justify-content-end">
                    <button type="submit" data-oper='modify' class="btn btn-primary me-2">수정 완료</button>
                    <button type="submit" data-oper='remove' class="btn btn-danger me-2">삭제</button>
                    <button type="submit" data-oper='list' class="btn btn-secondary">목록</button>
                </div>
            </form>
            
        </div>
    </div>
</div>

<jsp:include page="../layout/footer.jsp" />

<script type="text/javascript">
$(document).ready(function() {
    
    var formObj = $("form");

    $('button').on("click", function(e){
        e.preventDefault();
        
        var operation = $(this).data("oper");
        
        console.log(operation);
        
        if(operation === 'remove'){
            // 삭제 시 confirm 창 추가
            if(confirm("정말로 삭제하시겠습니까?")) {
                formObj.attr("action", "/board/remove");
                formObj.submit();
            }
        } else if(operation === 'list'){
            // 목록으로 이동
            self.location = "/board/list?pageNum=${cri.pageNum}&amount=${cri.amount}&type=${cri.type}&keyword=${cri.keyword}";
        } else if(operation === 'modify'){
            // 수정 처리
            formObj.attr("action", "/board/modify");
            formObj.submit();
        }
    });
});
</script>

</body>
</html>