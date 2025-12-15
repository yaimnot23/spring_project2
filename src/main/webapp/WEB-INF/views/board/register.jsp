<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Board Register</title>
    <link href="/resources/css/bootstrap.min.css" rel="stylesheet" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <script src="/resources/js/bootstrap.bundle.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <style>
      .container {
        margin-top: 30px;
      }
      /* 클립 아이콘과 숫자 스타일 */
      .file-count-wrapper {
        font-size: 1.1rem;
        color: #555;
        margin-bottom: 5px;
        display: inline-block;
      }
      .file-count {
        color: #0d6efd; /* 파란색 강조 */
        font-weight: bold;
        margin-left: 5px;
      }
    </style>
  </head>
  <body>
    <jsp:include page="../layout/header.jsp" />

    <div class="container pb-5">
      <h2 class="mb-4">게시글 등록</h2>

      <div class="card">
        <div class="card-header">Board Register Page</div>
        <div class="card-body">
          <form
            role="form"
            action="/board/register"
            method="post"
            enctype="multipart/form-data"
          >
            <div class="mb-3">
              <label class="form-label">제목</label>
              <input class="form-control" name="title" required />
            </div>

            <div class="mb-3">
              <label class="form-label">내용</label>
              <textarea
                class="form-control"
                rows="10"
                name="content"
                required
              ></textarea>
            </div>

            <div class="mb-3">
              <label class="form-label">작성자</label>
              <!-- Spring Security Principal에서 닉네임 가져오기 -->
              <%@ taglib uri="http://www.springframework.org/security/tags"
              prefix="sec" %>
              <input
                class="form-control"
                name="writer"
                value='<sec:authentication property="principal.member.nickName"/>'
                readonly
              />
              <!-- 실제 DB 저장이 닉네임이 아니라 ID(Email)라면 hidden으로 email 전송 필요할 수 있음.
                         BoardController에서 principal.getName()으로 덮어쓰고 있으므로 이 input은 보여주기용. -->
            </div>

            <div class="mb-4">
              <div class="d-flex align-items-center mb-2">
                <label class="form-label fw-bold me-2 mb-0">파일 첨부</label>

                <div class="file-count-wrapper">
                  <i class="fa-solid fa-paperclip"></i>
                  <span class="file-count" id="fileCount">0</span>
                </div>
              </div>

              <input
                type="file"
                class="form-control"
                name="uploadFiles"
                id="fileInput"
                multiple
              />
              <div class="form-text">파일을 선택하면 위 숫자가 변경됩니다.</div>
            </div>

            <div class="d-flex justify-content-end">
              <button type="submit" class="btn btn-primary me-2">등록</button>
              <button type="reset" class="btn btn-warning me-2">초기화</button>
              <button
                type="button"
                class="btn btn-secondary"
                onclick="location.href='/board/list'"
              >
                목록
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <jsp:include page="../layout/footer.jsp" />

    <script>
      $(document).ready(function () {
        // 파일 선택 시 개수 업데이트 로직
        $("#fileInput").on("change", function () {
          var fileCount = 0;
          if (this.files) {
            fileCount = this.files.length;
          }
          $("#fileCount").text(fileCount);
        });

        // 초기화 버튼 누르면 0으로 리셋
        $("button[type='reset']").on("click", function () {
          $("#fileCount").text("0");
        });
      });
    </script>
  </body>
</html>
