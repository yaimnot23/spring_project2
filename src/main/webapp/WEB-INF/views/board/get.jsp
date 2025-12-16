<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!-- test -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board Read</title>

<link href="/resources/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<script src="/resources/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<!-- CSRF Token -->
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>

<!-- PDF Export Libs -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

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
            
    <!-- [Ghost Mode] Locked UI -->
    <c:if test="${locked}">
        <div class="alert alert-warning text-center p-5">
            <i class="fa-solid fa-lock fa-3x mb-3 text-secondary"></i>
            <h4>비밀글입니다.</h4>
            <p class="mb-4">작성자와 비밀번호를 아는 사람만 확인할 수 있습니다.</p>
            <div class="d-flex justify-content-center">
                <div class="input-group" style="max-width: 300px;">
                    <input type="password" class="form-control" id="unlockPw" placeholder="비밀번호 입력">
                    <button class="btn btn-dark" id="unlockBtn">확인</button>
                </div>
            </div>
        </div>
        <script>
        $("#unlockBtn").click(function(){
            var pw = $("#unlockPw").val();
            $.ajax({
                url: "/board/unlock",
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify({bno: '${board.bno}', password: pw}),
                success: function(res){
                    if(res.success) {
                        location.reload();
                    } else {
                        alert("비밀번호가 일치하지 않습니다.");
                    }
                }
            });
        });
        </script>
    </c:if>
    
    <c:if test="${!locked}">
    
    <div class="mb-3">
        <label class="form-label">내용</label>
                <!-- Hashtag 지원을 위해 textarea 대신 div 사용 -->
                <div class="form-control" style="min-height: 150px; background-color: #e9ecef; white-space: pre-wrap;" id="boardContent">${board.content}</div>
                <!-- <textarea class="form-control" rows="5" name="content" readonly>${board.content}</textarea> -->
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
                                <c:set var="fileCallPath" value="/display?fileName=${file.uploadPath}/${file.uuid}_${file.fileName}" />
                                <c:set var="thumbCallPath" value="/display?fileName=${file.uploadPath}/s_${file.uuid}_${file.fileName}" />
                                
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
            <div class="mt-4 d-flex justify-content-between">
                <div>
                   <c:if test="${canModify}">
                       <button data-oper='modify' class="btn btn-primary">수정</button>
                   </c:if>
                   <button data-oper='list' class="btn btn-secondary">목록</button>
                   <button id="pdfBtn" class="btn btn-outline-danger"><i class="fa-regular fa-file-pdf"></i> PDF 저장</button>
                   <button id="likeBtn" class="btn btn-outline-secondary ms-2">
                        <i class="fa-regular fa-heart text-danger"></i> 
                        <span id="likeCount">${board.likeCount}</span>
                   </button>
                </div>
            </div>
            
            <!-- [Prev/Next Navigation] -->
            <div class="mt-4">
                <ul class="list-group list-group-flush">
                    <c:if test="${not empty prevBoard}">
                        <li class="list-group-item">
                            <i class="fa-solid fa-chevron-up me-2 text-muted"></i> 
                            <span class="text-muted me-2">이전글</span>
                            <a href="/board/get?bno=${prevBoard.bno}" class="text-decoration-none text-dark">${prevBoard.title}</a>
                        </li>
                    </c:if>
                    <c:if test="${not empty nextBoard}">
                        <li class="list-group-item">
                            <i class="fa-solid fa-chevron-down me-2 text-muted"></i> 
                            <span class="text-muted me-2">다음글</span>
                            <a href="/board/get?bno=${nextBoard.bno}" class="text-decoration-none text-dark">${nextBoard.title}</a>
                        </li>
                    </c:if>
                </ul>
            </div>
            
            <form id="operForm" action="/board/modify" method="get">
                <input type="hidden" id="bno" name="bno" value="${board.bno}">
            </form>
            
            <hr class="my-4">
            
            <div class="mb-4">
                <h5><i class="fa-regular fa-comments"></i> 댓글</h5>
                <div class="d-flex gap-2">
                    <input type="text" class="form-control" id="reply" placeholder="댓글 내용">
                    
                    <sec:authorize access="isAnonymous()">
                   		<input type="text" class="form-control" id="replyer" placeholder="로그인 필요" style="width: 150px;" readonly>
                    </sec:authorize>
                    
                    <sec:authorize access="isAuthenticated()">
                    	<input type="text" class="form-control" id="replyer" value="${pageContext.request.userPrincipal.name}" readonly style="width: 150px;">
                    	<!-- <input type="text" class="form-control" id="replyer" value='<sec:authentication property="principal.member.nickName"/>' readonly style="width: 150px;"> -->
                    	<!-- 실제 서버로 보낼 email (필요하다면 숨겨서 전송 or Controller에서 Principal로 처리) -->
                    	<!-- <input type="hidden" id="replyerEmail" value='<sec:authentication property="principal.member.email"/>'> -->
                    </sec:authorize>
                    
                    <button id="addReplyBtn" class="btn btn-dark">등록</button>
                </div>
            </div>

            <ul class="list-group" id="replyList">
            </ul>
            
            </c:if> <!-- End locked check -->
            
        </div>
    </div>
</div>

<jsp:include page="../layout/footer.jsp" />

<script type="text/javascript">
$(document).ready(function(){
    
    // [Hashtag System] #해시태그 링크 변환
    var contentDiv = $("#boardContent");
    if(contentDiv.length > 0) {
        var contentHtml = contentDiv.html();
        if(contentHtml) {
            var linkedContent = contentHtml.replace(/#(\S+)/g, '<a href="/board/list?type=TC&keyword=$1" class="text-decoration-none">#$1</a>');
            contentDiv.html(linkedContent);
            
            // [Reading Time] 읽기 시간 계산
            var textLength = contentDiv.text().trim().length;
            var wpm = 500; // 한국어 기준 대략적인 분당 글자수
            var time = Math.ceil(textLength / wpm);
            $(".card-header").append(' <small class="text-muted ms-2"><i class="fa-regular fa-clock"></i> 예상 읽기: ' + time + '분</small>');
        }
    }

    // [PDF Export] PDF 저장 Logic
    $("#pdfBtn").on("click", function(){
        html2canvas(document.querySelector(".card-body")).then(canvas => {
            var imgData = canvas.toDataURL('image/png');
            const { jsPDF } = window.jspdf;
            var doc = new jsPDF('p', 'mm', 'a4');
            var imgWidth = 210; 
            var imgHeight = canvas.height * imgWidth / canvas.width;
            
            doc.addImage(imgData, 'PNG', 0, 0, imgWidth, imgHeight);
            doc.save('board_${board.bno}.pdf');
        });
    });
    
    // [Like System] 좋아요 로직
    var bno = "${board.bno}";
    var liker = $("#replyer").val(); // 로그인 유저 ID (또는 닉네임)
    var likeBtn = $("#likeBtn");
    var likeIcon = likeBtn.find("i");
    var likeCountSpan = $("#likeCount");
    
    // 1. 초기 상태 확인
    if(liker) {
        $.getJSON("/likes/check/" + bno + "/" + liker, function(data){
            if(data.liked) {
                likeIcon.removeClass("fa-regular").addClass("fa-solid");
            }
        });
    }
    
    // 2. 클릭 이벤트
    likeBtn.on("click", function(){
        if(!liker) {
            alert("로그인이 필요합니다.");
            return;
        }
        
        $.ajax({
            type: 'post',
            url: '/likes/toggle',
            data: JSON.stringify({bno: bno}),
            contentType: "application/json; charset=utf-8",
            success: function(result, status, xhr) {
                if(result.status === "anonymous") {
                    alert("로그인이 필요합니다.");
                } else if (result.status === "success") {
                    var currentCount = parseInt(likeCountSpan.text());
                    if(result.liked) { // 좋아요 성공
                        likeIcon.removeClass("fa-regular").addClass("fa-solid");
                        likeCountSpan.text(currentCount + 1);
                    } else { // 취소 성공
                        likeIcon.removeClass("fa-solid").addClass("fa-regular");
                        likeCountSpan.text(currentCount - 1);
                    }
                }
            },
            error: function(xhr, status, er) {
                alert("좋아요 처리 에러");
            }
        });
    });

    // ==========================================
    // 1. 게시글 관련 버튼 이벤트 (수정, 목록, PDF)
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
    
    // CSRF 토큰 설정
    var csrfToken = $("meta[name='_csrf']").attr("content");
    var csrfHeader = $("meta[name='_csrf_header']").attr("content");
    
    $(document).ajaxSend(function(e, xhr, options) {
        xhr.setRequestHeader(csrfHeader, csrfToken);
    });
    
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
                str += '<li class="list-group-item" data-rno="' + data[i].rno + '">';
                str += '  <div class="d-flex justify-content-between align-items-center mb-1">';
                str += '    <div class="fw-bold">' + data[i].replyer + ' <small class="text-muted fw-normal ms-2">' + displayTime(data[i].replyDate) + '</small></div>';
                
                // 로그인한 유저와 댓글 작성자가 같으면 수정/삭제 버튼 표시
                // (주의: 화면상 닉네임 비교이므로 동명이인 문제 가능성 있음. 안전하게는 replyerEmail 비교 필요하나, 현재 구조상 닉네임으로 처리)
                if (replyerVal && replyerVal === data[i].replyer) {
                    str += '    <div>';
                    str += '        <button class="btn btn-sm btn-outline-primary modifyBtn me-1" data-rno="' + data[i].rno + '">수정</button>';
                    str += '        <button class="btn btn-sm btn-outline-danger removeBtn" data-rno="' + data[i].rno + '">삭제</button>';
                    str += '    </div>';
                }
                str += '  </div>';
                str += '  <p class="mb-0 reply-content">' + data[i].reply + '</p>';
                str += '</li>';
            }
            replyUL.html(str);
        });
    }
    
    // ... displayTime 함수 제외 ...
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
    
    // 전역 변수 설정 (로그인한 유저 닉네임)
    var replyerVal = $("#replyer").val();

    $("#addReplyBtn").on("click", function(e){
        var replyVal = $("#reply").val();
        var replyerCurrent = $("#replyer").val(); // 재확인
        
        var reply = {
            reply: replyVal,
            replyer: replyerCurrent,
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

    // 댓글 수정 버튼 클릭
    replyUL.on("click", ".modifyBtn", function(e){
        var li = $(this).closest("li");
        var p = li.find(".reply-content");
        var text = p.text();
        
        var str = '<div class="input-group mt-2">';
        str += '<input type="text" class="form-control edit-input" value="' + text + '">';
        str += '<button class="btn btn-primary saveBtn">저장</button>';
        str += '<button class="btn btn-secondary cancelBtn">취소</button>';
        str += '</div>';
        
        p.hide();
        li.append(str);
        $(this).hide(); // 수정 버튼 숨김
    });
    
    // 댓글 수정 저장
    replyUL.on("click", ".saveBtn", function(e){
        var li = $(this).closest("li");
        var rno = li.data("rno");
        var replyContent = li.find(".edit-input").val();
        var replyerCurrent = $("#replyer").val();
        
        var reply = { 
            rno: rno, 
            reply: replyContent,
            replyer: replyerCurrent
        };
        
        $.ajax({
            type: 'put',
            url: '/replies/' + rno,
            data: JSON.stringify(reply),
            contentType: "application/json; charset=utf-8",
            success: function(result, status, xhr) {
                if (result === "success") {
                    alert("수정되었습니다.");
                    showList();
                }
            },
            error: function(xhr, status, er) {
                alert("수정 실패");
            }
        });
    });
    
    // 댓글 수정 취소
    replyUL.on("click", ".cancelBtn", function(e){
        var li = $(this).closest("li");
        li.find(".input-group").remove();
        li.find(".reply-content").show();
        li.find(".modifyBtn").show();
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