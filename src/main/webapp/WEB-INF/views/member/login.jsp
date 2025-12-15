<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %>

<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>로그인</title>
    <link href="/resources/css/bootstrap.min.css" rel="stylesheet" />
    <style>
      .login-container {
        max-width: 400px;
        margin-top: 100px;
      }
    </style>
  </head>
  <body class="bg-light">
    <jsp:include page="../layout/header.jsp" />

    <div class="container login-container">
      <div class="card-body p-4">
        <h3 class="text-center mb-4">로그인</h3>

        <c:if test="${not empty msg}">
          <div class="alert alert-danger text-center small py-2">${msg}</div>
        </c:if>

        <form action="/member/login" method="post">
          <div class="mb-3">
            <label class="form-label">이메일</label>
            <input
              type="text"
              name="email"
              class="form-control"
              placeholder="이메일 입력"
              required
            />
          </div>
          <div class="mb-3">
            <label class="form-label">비밀번호</label>
            <input
              type="password"
              name="pwd"
              class="form-control"
              placeholder="비밀번호 입력"
              required
            />
          </div>
          <div class="d-grid gap-2">
            <button type="submit" class="btn btn-primary">로그인</button>
            <a href="/" class="btn btn-secondary">취소</a>
          </div>
        </form>
      </div>
    </div>

    <jsp:include page="../layout/footer.jsp" />
  </body>
</html>
