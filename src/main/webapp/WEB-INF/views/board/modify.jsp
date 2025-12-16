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
                                <c:set var="thumbCallPath" value="/display?fileName=${file.uploadPath}/s_${file.uuid}_${file.fileName}" />
                                
                                <li data-uuid="${file.uuid}" class="existing-file">
                                    <button type="button" class="btn-delete btn-delete-existing" title="삭제">X</button>
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
    var fileInput = document.getElementById("newFileInput");
    var dataTransfer = new DataTransfer(); // [New] 파일 관리용 객체
    
    // [초기화 로직] 페이지 로딩 시 현재 파일 개수 세팅
    updateTotalCount();

    // 1. 기존 파일 삭제 버튼 (X) 클릭 시
    $(".uploadResult").on("click", ".btn-delete-existing", function(e){
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
    
    // 2. [New] 새 파일 선택(Input) 변경 시 (Preview 및 누적)
    $("#newFileInput").on("change", function(e) {
        var files = e.target.files;
        
        if(files != null && files.length > 0){
        	for(var i=0; i<files.length; i++){
        		dataTransfer.items.add(files[i]);
        	}
        	// Input 파일 갱신
        	fileInput.files = dataTransfer.files;
        	
        	// Preview 렌더링
        	renderNewFiles();
        }
        
        // [업데이트] 개수 갱신
        updateTotalCount();
    });
    
    // 3. [New] 새 파일 삭제 버튼 클릭 (Preview 상에서)
    $(".uploadResult").on("click", ".btn-delete-new", function(e){
    	e.stopPropagation();
        e.preventDefault();
        
        var targetLi = $(this).closest("li");
        var targetFileIndex = targetLi.data("idx");
        
        // DataTransfer에서 해당 인덱스의 파일 제거
        // DataTransfer.items는 remove가 인덱스 기반이 아니거나 까다로우므로
        // 새로운 DataTransfer를 만들어 옮겨담는 식(혹은 filter)으로 처리
        var files = dataTransfer.files;
        var newDataTransfer = new DataTransfer();
        
        for(var i=0; i<files.length; i++){
        	// file의 lastModified 등으로 식별하거나, 단순 index 매핑
        	// 여기서는 data-idx와 배열 인덱스를 일치시키기 위해 
        	// 렌더링 시 부여한 idx와 비교 (주의: 중간 삭제 시 인덱스 밀림 문제)
        	// -> 더 안전한 방법: file 객체 자체를 비교불가하므로, 
        	// 매번 렌더링 후 삭제 시 해당 순번(li의 순서)을 기준으로 삭제
        }
        
        // [수정 전략]: button 클릭 시점의 li index를 구한다.
        // .new-file 클래스를 가진 li들 중에서 몇 번째인지 확인
        var index = $(".new-file").index(targetLi);
        
        if(index > -1) {
        	dataTransfer.items.remove(index);
        	fileInput.files = dataTransfer.files;
        	renderNewFiles(); // 재렌더링
        	updateTotalCount();
        }
    });
    
    // [함수] 새 파일 렌더링
    function renderNewFiles() {
    	// 기존에 그려진 '새 파일' 프리뷰들을 모두 제거
    	$(".new-file").remove();
    	
    	var files = dataTransfer.files;
    	var ul = $("#existingFileList");
    	
    	for(var i=0; i<files.length; i++) {
    		var file = files[i];
    		var reader = new FileReader();
    		
    		// 클로저나 let 사용 필요
    		(function(idx, f){
    			reader.onload = function(e) {
    				var li = $("<li>").addClass("new-file");
    				
    				var btn = $("<button>").attr("type", "button")
    				                       .addClass("btn-delete btn-delete-new") // 스타일 공유, 식별자 분리
    				                       .attr("title", "삭제")
    				                       .text("X");
    				
    				var content = "";
    				// 이미지 판별
    				if(f.type.startsWith("image")) {
    					content = $("<img>").attr("src", e.target.result).attr("alt", f.name);
    				} else {
    					content = $("<div>").css({
    						"width": "100px", "height": "100px", 
    						"background": "#e9ecef", "display": "flex", 
    						"align-items": "center", "justify-content": "center", 
    						"border-radius": "5px", "margin": "0 auto"
    					}).html('<i class="fa-regular fa-file-lines fa-2x text-secondary"></i>');
    				}
    				
    				var span = $("<span>").text(f.name);
    				
    				li.append(btn).append(content).append(span);
    				ul.append(li);
    			};
    			reader.readAsDataURL(f);
    		})(i, file);
    	}
    }

    // [함수] 전체 파일 개수 계산 및 업데이트
    function updateTotalCount() {
        // 1. 기존 파일 중 삭제되지 않은(.deleted-file 없는) 개수
        var existingCount = $(".existing-file").not(".deleted-file").length;
        
        // 2. 새로 추가된 파일 개수
        var newCount = 0;
        if(fileInput.files) {
            newCount = fileInput.files.length;
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