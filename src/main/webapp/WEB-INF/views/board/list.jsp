<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Board List</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f8f9fa;
        }
        /* 카드 스타일 */
        .card {
            border: none;
            border-radius: 12px;
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
            transition: all 0.3s ease;
            cursor: pointer;
            height: 100%;
        }
        /* 마우스 올렸을 때 효과 */
        .card:hover {
            transform: translateY(-7px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
        }
        .card-body {
            padding: 1.5rem;
        }
        .card-title {
            font-weight: 700;
            font-size: 1.15rem;
            color: #333;
            margin-bottom: 0.8rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .card-text {
            color: #666;
            font-size: 0.95rem;
            line-height: 1.5;
            min-height: 3rem;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .writer-badge {
            background-color: #eef1f6;
            color: #555;
            padding: 4px 10px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.8rem;
        }
        .card-footer {
            background-color: transparent;
            border-top: 1px solid #f0f0f0;
            padding: 1rem 1.5rem;
        }
        .meta-text {
            font-size: 0.85rem;
            color: #aaa;
        }
        /* 페이징 스타일 커스텀 */
        .page-link {
            color: #333;
            border: none;
            margin: 0 3px;
            border-radius: 5px !important;
        }
        .page-item.active .page-link {
            background-color: #0d6efd;
            border-color: #0d6efd;
            color: white;
            font-weight: bold;
        }
        .page-link:hover {
            background-color: #e9ecef;
            color: #0d6efd;
        }
    </style>
</head>
<body>

    <jsp:include page="../layout/header.jsp" />

    <div class="container pb-5" style="margin-top: 50px;">
        
        <div class="d-flex justify-content-between align-items-end mb-4 px-2">
            <div>
                <h2 class="fw-bold m-0"><i class="fa-solid fa-layer-group text-primary"></i> 최신 글 목록</h2>
                <small class="text-muted">개발 지식과 경험을 공유하는 공간입니다.</small>
            </div>
            
            <div class="d-flex gap-2 align-items-center">
            	
            	<!-- [무한 스크롤 스위치] -->
                <div class="form-check form-switch me-3">
                    <input class="form-check-input" type="checkbox" id="infiniteSwitch">
                    <label class="form-check-label" for="infiniteSwitch" style="white-space: nowrap;">∞ 무한 스크롤</label>
                </div>
            
                <form id="searchForm" action="/board/list" method="get" class="d-flex">
                    <input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
                    <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
                    
                    <select name="sort" class="form-select me-2" style="width: 110px;">
                        <option value="" ${empty pageMaker.cri.sort ? 'selected' : ''}>최신순</option>
                        <option value="V" ${pageMaker.cri.sort == 'V' ? 'selected' : ''}>조회순</option>
                        <option value="O" ${pageMaker.cri.sort == 'O' ? 'selected' : ''}>오래된순</option>
                    </select>

                    <select name="type" class="form-select me-2" style="width: 100px;">
                        <option value="" ${empty pageMaker.cri.type ? 'selected' : ''}>--</option>
                        <option value="T" ${pageMaker.cri.type == 'T' ? 'selected' : ''}>제목</option>
                        <option value="C" ${pageMaker.cri.type == 'C' ? 'selected' : ''}>내용</option>
                        <option value="W" ${pageMaker.cri.type == 'W' ? 'selected' : ''}>작성자</option>
                        <option value="TC" ${pageMaker.cri.type == 'TC' ? 'selected' : ''}>제목+내용</option>
                    </select>
                    
                    <input type="text" name="keyword" class="form-control me-2" placeholder="검색어 입력" value="${pageMaker.cri.keyword}">
                    
                    <button class="btn btn-outline-secondary">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </button>
                </form>

                <a href="${pageContext.request.contextPath}/board/register" class="btn btn-primary rounded-pill px-4 shadow-sm fw-bold d-flex align-items-center">
                    <i class="fa-solid fa-pen me-1"></i> 글쓰기
                </a>
            </div>
        </div>

        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
            
            <c:forEach items="${list}" var="board">
                <div class="col">
                    <div class="card h-100" onclick="location.href='${pageContext.request.contextPath}/board/get?bno=${board.bno}&pageNum=${pageMaker.cri.pageNum}&amount=${pageMaker.cri.amount}&type=${pageMaker.cri.type}&keyword=${pageMaker.cri.keyword}&sort=${pageMaker.cri.sort}'">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <span class="writer-badge">
                                    <i class="fa-regular fa-user me-1"></i> ${board.writer}
                                </span>
                                <small class="text-muted">
                                    <i class="fa-regular fa-eye me-1"></i> ${board.readCount}
                                </small>
                            </div>
                            
                            <h5 class="card-title">
                                ${board.title}
                                <c:if test="${board.readCount >= 10}">
                                    <span class="badge bg-danger ms-2" style="font-size: 0.7rem;"><i class="fa-solid fa-fire"></i> HOT</span>
                                </c:if>
                            </h5>
                            <p class="card-text">${board.content}</p>
                        </div>
                        
                        <div class="card-footer">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="meta-text">
                                     <i class="fa-regular fa-clock me-1"></i> 
                                     <fmt:formatDate value="${board.regDate}" pattern="yyyy-MM-dd"/>
                                </span>
                                <span class="text-primary fw-bold" style="font-size: 0.9rem;">
                                    Read More <i class="fa-solid fa-arrow-right ms-1"></i>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div> 
        
        <c:if test="${empty list}">
            <div class="text-center py-5 my-5 bg-white rounded shadow-sm">
                <i class="fa-regular fa-folder-open fa-3x text-secondary mb-3"></i>
                <h5 class="text-muted">등록된 게시글이 없거나 검색 결과가 없습니다.</h5>
                <p class="text-muted small">새로운 게시글을 등록해보세요!</p>
            </div>
        </c:if>

        <nav aria-label="Page navigation" class="mt-5">
            <ul class="pagination justify-content-center">
                
                <c:if test="${pageMaker.prev}">
                    <li class="page-item">
                        <a class="page-link" href="${pageMaker.startPage - 1}" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                </c:if>

                <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                    <li class="page-item ${pageMaker.cri.pageNum == num ? 'active' : ''}">
                        <a class="page-link" href="${num}">${num}</a>
                    </li>
                </c:forEach>

                <c:if test="${pageMaker.next}">
                    <li class="page-item">
                        <a class="page-link" href="${pageMaker.endPage + 1}" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </c:if>
            </ul>
        </nav>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script type="text/javascript">
    $(document).ready(function(){
        
        var searchForm = $("#searchForm");

        // 1. 페이지 번호 클릭 이벤트
        $(".page-link").on("click", function(e){
            e.preventDefault(); // a 태그의 기본 이동 동작을 막음
            var targetPage = $(this).attr("href"); // 클릭한 번호 가져오기
            
            // 폼 안에 있는 pageNum 값을 클릭한 번호로 변경
            searchForm.find("input[name='pageNum']").val(targetPage);
            // 폼 제출 (기존 검색 조건도 같이 전송됨)
            searchForm.submit();
        });

        // 3. 정렬 기준 변경 이벤트
        $("select[name='sort']").on("change", function(e){
            searchForm.find("input[name='pageNum']").val("1");
            searchForm.submit();
        });
        
        // [Live Search] 실시간 검색
        var timer;
        $("input[name='keyword']").on("keyup", function(){
            var keyword = $(this).val();
            var type = $("select[name='type']").val();
            
            if(keyword.length < 2 || type == "") return;
            
            if(timer) clearTimeout(timer);
            timer = setTimeout(function(){
                $.getJSON("/board/list_ajax", {
                    pageNum: 1, 
                    amount: 6, 
                    type: type, 
                    keyword: keyword,
                    sort: $("select[name='sort']").val()
                }, function(data){
                    renderList(data.list);
                });
            }, 500);
        });
        
        function renderList(list) {
            var container = $(".row.row-cols-1"); 
            var str = "";
            
            if(!list || list.length == 0) {
                 str += '<div class="col-12 text-center py-5 my-5 bg-white rounded shadow-sm">';
                 str += '  <i class="fa-regular fa-folder-open fa-3x text-secondary mb-3"></i>';
                 str += '  <h5 class="text-muted">검색 결과가 없습니다.</h5>';
                 str += '</div>';
            } else {
                $(list).each(function(i, board){
                    var date = new Date(board.regDate);
                    var dateStr = date.getFullYear() + "-" + 
                                  ((date.getMonth()+1) < 10 ? '0' : '') + (date.getMonth()+1) + "-" + 
                                  (date.getDate() < 10 ? '0' : '') + date.getDate();

                    // Hot Badge Logic
                    var hotBadge = board.readCount >= 10 ? '<span class="badge bg-danger ms-2"><i class="fa-solid fa-fire"></i> HOT</span>' : '';

                    str += '<div class="col">';
                    str += '    <div class="card h-100" onclick="location.href=\'/board/get?bno=' + board.bno + '\'">';
                    str += '        <div class="card-body">';
                    str += '            <div class="d-flex justify-content-between align-items-center mb-3">';
                    str += '                <span class="writer-badge"><i class="fa-regular fa-user me-1"></i> ' + board.writer + '</span>';
                    str += '                <small class="text-muted"><i class="fa-regular fa-eye me-1"></i> ' + board.readCount + '</small>';
                    str += '            </div>';
                    str += '            <h5 class="card-title">' + board.title + hotBadge + '</h5>';
                    str += '            <p class="card-text">' + board.content + '</p>';
                    str += '        </div>';
                    str += '        <div class="card-footer">';
                    str += '            <div class="d-flex justify-content-between align-items-center">';
                    str += '                <span class="meta-text"><i class="fa-regular fa-clock me-1"></i> ' + dateStr + '</span>';
                    str += '                <span class="text-primary fw-bold" style="font-size: 0.9rem;">Read More <i class="fa-solid fa-arrow-right ms-1"></i></span>';
                    str += '            </div>';
                    str += '        </div>';
                    str += '    </div>';
                    str += '</div>';
                });
            }
            container.html(str);
        }

        // [Infinite Scroll] 무한 스크롤
        var isInfinite = false;
        var currentPage = 1;
        var isLoading = false;
        
        // [Infinite Scroll] 무한 스크롤
        var isInfinite = false;
        var currentPage = 1;
        var isLoading = false;
        
        // 무한 스크롤 토글 버튼 추가 (HTML에 직접 추가함)
        
        $("#infiniteSwitch").change(function(){
            isInfinite = $(this).is(":checked");
            if(isInfinite) {
                $(".page-navigation").hide();
                // 관찰 대상 추가
                if($("#sentinel").length == 0) {
                     $(".container.pb-5").append('<div id="sentinel" style="height: 20px;"></div>');
                     observer.observe(document.getElementById('sentinel'));
                }
            } else {
                $(".page-navigation").show();
                if($("#sentinel").length > 0) {
                    observer.unobserve(document.getElementById('sentinel'));
                    $("#sentinel").remove();
                }
            }
        });
        
        var observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if(entry.isIntersecting && !isLoading && isInfinite) {
                    loadMore();
                }
            });
        }, { threshold: 1.0 });
        
        function loadMore() {
            isLoading = true;
            currentPage++;
            
            var type = $("select[name='type']").val();
            var keyword = $("input[name='keyword']").val();
            var sort = $("select[name='sort']").val();
            
            $.getJSON("/board/list_ajax", {
                pageNum: currentPage, 
                amount: 6, 
                type: type, 
                keyword: keyword,
                sort: sort
            }, function(data){
                if(data.list && data.list.length > 0) {
                    appendList(data.list);
                    isLoading = false;
                } else {
                    // 더 이상 데이터 없음
                    observer.unobserve(document.getElementById('sentinel'));
                    $("#sentinel").html('<p class="text-center text-muted mt-3">마지막 게시글입니다.</p>');
                }
            });
        }
        
        function appendList(list) {
            var container = $(".row.row-cols-1");
            var str = "";
            $(list).each(function(i, board){
                var date = new Date(board.regDate);
                var dateStr = date.getFullYear() + "-" + 
                              ((date.getMonth()+1) < 10 ? '0' : '') + (date.getMonth()+1) + "-" + 
                              (date.getDate() < 10 ? '0' : '') + date.getDate();
                              
                var hotBadge = board.readCount >= 10 ? '<span class="badge bg-danger ms-2"><i class="fa-solid fa-fire"></i> HOT</span>' : '';

                str += '<div class="col">';
                str += '    <div class="card h-100" onclick="location.href=\'/board/get?bno=' + board.bno + '\'">';
                str += '        <div class="card-body">';
                str += '            <div class="d-flex justify-content-between align-items-center mb-3">';
                str += '                <span class="writer-badge"><i class="fa-regular fa-user me-1"></i> ' + board.writer + '</span>';
                str += '                <small class="text-muted"><i class="fa-regular fa-eye me-1"></i> ' + board.readCount + '</small>';
                str += '            </div>';
                str += '            <h5 class="card-title">' + board.title + hotBadge + '</h5>';
                str += '            <p class="card-text">' + board.content + '</p>';
                str += '        </div>';
                str += '        <div class="card-footer">';
                str += '            <div class="d-flex justify-content-between align-items-center">';
                str += '                <span class="meta-text"><i class="fa-regular fa-clock me-1"></i> ' + dateStr + '</span>';
                str += '                <span class="text-primary fw-bold" style="font-size: 0.9rem;">Read More <i class="fa-solid fa-arrow-right ms-1"></i></span>';
                str += '            </div>';
                str += '        </div>';
                str += '    </div>';
                str += '</div>';
            });
            container.append(str);
        }

    });
    </script>
</body>
</html>