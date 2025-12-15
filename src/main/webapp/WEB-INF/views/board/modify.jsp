<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> <!DOCTYPE html>
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
    
    .uploadResult li { margin: 10px; text-align: center; position: relative; }
    .uploadResult li img { width: 100px; height: 100px; object-fit: cover; border-radius: 5px; }
    .uploadResult li span { display: block; margin-top: 5px; font-size: 12px; color: #555; }
    
    .btn-delete {
        position: absolute; top: -10px; right: -10px;
        width: 25px; height: 25px;
        border-radius: 50%; background-color: #dc3545; color: white;
        border: 2px solid white; font-weight: bold; font-size: 14px;
        line-height: 21px; text-align: center; cursor: pointer;
        z-index: 100; box-shadow: 0 2px 5px rgba(0,0,0,0.3);
    }
    .btn-delete:hover { background-color: #bb2d3b; }

    /* 클립 아이콘 스타일 */
     .file-count-wrapper {
        font-size: 1.1rem;
        margin-left: 10px;
    }
    .file-count {
        color: #0d6efd;
        font-weight: bold;
        margin-left: 5px;
    }
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
            	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                
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

                <div class="mb-3 d-flex align-items-center">
                    <label class="form-label fw-bold mb-0">첨부파일 관리</label>
                    <div class="file-count-wrapper">
                        <i class="fa-solid fa-paperclip"></i>
                        <span class="file-count" id="totalFileCount">0</span>
                    </div>
                </div>

                <div class="mb-3">
                    <div class="uploadResult border">
                        <ul id="existingFileList">
                            <c:forEach items="${board.attachList}" var="file">
                                <c:set var="thumbCallPath" value="/upload/${file.uploadPath}/s_${file.uuid}_${file.fileName}" />
                                
                                <li data-uuid="${file.uuid}" class="existing-file">
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
                                <li class="w-100 text-center text-muted no-file-msg" style="border:none; padding:20px;">기존 첨부파일이 없습니다.</li>
                            </c:if>
                        </ul>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-bold">새 파일 추가</label>
                    <input type="file" class="form-control" name="uploadFiles" id="newFileInput" multiple>
                    <div class="form-text">추가할 파일을 선택하세요.</div>
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
    
    // [초기화 로직] 페이지 로딩 시 현재 파일 개수 세팅
    updateTotalCount();

    // 1. 기존 파일 삭제 버튼 (X) 클릭 시
    $(".uploadResult").on("click", ".btn-delete", function(e){
        e.stopPropagation();
        e.preventDefault();
        
        if(confirm("이 파일을 삭제 목록에 추가하시겠습니까?")) {
            var targetLi = $(this).closest("li");
            var uuid = targetLi.data("uuid");
            
            // 화면에서 숨김 (클래스 추가하여 카운팅에서 제외)
            targetLi.hide().addClass("deleted-file");
            
            // hidden input 추가
            var hiddenInput = $("<input>").attr("type", "hidden")
                                          .attr("name", "removeFiles")
                                          .attr("value", uuid);
            formObj.append(hiddenInput);
            
            // [업데이트] 개수 갱신
            updateTotalCount();
        }
    });
    
    // 2. 새 파일 선택(Input) 변경 시
    $("#newFileInput").on("change", function() {
        // [업데이트] 개수 갱신
        updateTotalCount();
    });

    // [함수] 전체 파일 개수 계산 및 업데이트
    function updateTotalCount() {
        // 1. 기존 파일 중 삭제되지 않은(.deleted-file 없는) 개수
        var existingCount = $(".existing-file").not(".deleted-file").length;
        
        // 2. 새로 추가된 파일 개수
        var newCount = 0;
        var input = document.getElementById("newFileInput");
        if(input.files) {
            newCount = input.files.length;
        }
        
        // 3. 합계 표시
        $("#totalFileCount").text(existingCount + newCount);
    }

    // 하단 버튼 동작 처리
    $('button[type="submit"]').on("click", function(e){
        e.preventDefault();
        var operation = $(this).data("oper");
        
        if(operation === 'remove'){
            if(confirm("정말로 게시글을 삭제하시겠습니까?")) {
                formObj.attr("action", "/board/remove");
                formObj.submit();
            }
        } else if(operation === 'list'){
            self.location = "/board/list?pageNum=${cri.pageNum}&amount=${cri.amount}&type=${cri.type}&keyword=${cri.keyword}";
        } else if(operation === 'modify'){
            formObj.attr("action", "/board/modify");
            formObj.submit();
        }
    });
});
</script>

</body>
</html>