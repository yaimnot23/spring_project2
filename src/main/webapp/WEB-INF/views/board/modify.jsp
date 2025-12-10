<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board Modify</title>

<link href="/resources/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"> 
<script src="/resources/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<style>
    .container { margin-top: 30px; }
    .uploadResult { margin-top: 10px; background-color: #f8f9fa; border-radius: 5px; padding: 15px; }
    .uploadResult ul { display: flex; flex-wrap: wrap; list-style: none; padding: 0; margin: 0; }
    
    /* [중요] li에 position: relative가 있어야 X버튼이 이미지 위에 붙습니다 */
    .uploadResult li { 
        margin: 10px; 
        text-align: center; 
        position: relative; /* 기준점 설정 */
    }
    
    .uploadResult li img { width: 100px; height: 100px; object-fit: cover; border-radius: 5px; }
    .uploadResult li span { display: block; margin-top: 5px; font-size: 12px; color: #555; }
    
    /* [수정] 삭제(X) 버튼 스타일 (글자로 변경하여 확실히 보이게 함) */
    .btn-delete {
        position: absolute;
        top: -10px;      /* 위치 조정 */
        right: -10px;    /* 위치 조정 */
        width: 25px;
        height: 25px;
        border-radius: 50%;
        background-color: #dc3545; /* 빨간색 */
        color: white;
        border: 2px solid white;
        font-weight: bold;
        font-size: 14px;
        line-height: 21px; /* 글자 수직 정렬 */
        text-align: center;
        cursor: pointer;
        z-index: 100;    /* 다른 요소보다 무조건 위에 뜨게 설정 */
        box-shadow: 0 2px 5px rgba(0,0,0,0.3); /* 그림자 추가 */
    }
    .btn-delete:hover { background-color: #bb2d3b; }
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
                                
                                <li data-uuid="${file.uuid}">
                                    
                                    <button type="button" class="btn-delete" title="삭제">X</button>
                                    
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
                                <li class="w-100 text-center text-muted" style="border:none; padding:20px;">기존 첨부파일이 없습니다.</li>
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

    // [삭제 이벤트] X 버튼 클릭 시 동작
    $(".uploadResult").on("click", ".btn-delete", function(e){
        e.stopPropagation(); // 부모 태그 클릭 방지
        e.preventDefault();  // 버튼 기본 동작 방지
        
        if(confirm("이 파일을 삭제 목록에 추가하시겠습니까?\n(최종 '수정 완료'를 눌러야 실제 삭제됩니다)")) {
            var targetLi = $(this).closest("li");
            var uuid = targetLi.data("uuid");
            
            // 1. 화면에서 숨김 처리 (삭제된 것처럼 보이게)
            targetLi.hide();
            
            // 2. 삭제할 파일의 uuid를 hidden input으로 폼에 추가
            // 나중에 form submit 될 때 removeFiles라는 이름으로 서버에 전송됨
            var hiddenInput = $("<input>").attr("type", "hidden")
                                          .attr("name", "removeFiles")
                                          .attr("value", uuid);
            formObj.append(hiddenInput);
        }
    });

    // 하단 버튼(수정/삭제/목록) 동작 처리
    $('button[type="submit"]').on("click", function(e){
        e.preventDefault();
        
        var operation = $(this).data("oper");
        
        console.log("Operation: " + operation);
        
        if(operation === 'remove'){
            if(confirm("정말로 게시글을 삭제하시겠습니까?")) {
                formObj.attr("action", "/board/remove");
                formObj.submit();
            }
        } else if(operation === 'list'){
            self.location = "/board/list?pageNum=${cri.pageNum}&amount=${cri.amount}&type=${cri.type}&keyword=${cri.keyword}";
        } else if(operation === 'modify'){
            // 수정 완료 버튼 클릭 시
            formObj.attr("action", "/board/modify");
            formObj.submit();
        }
    });
});
</script>

</body>
</html>