<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>회원가입</title>
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
        <h3 class="text-center mb-4">회원가입</h3>

        <form action="/member/signup" method="post">
          <input
            type="hidden"
            name="${_csrf.parameterName}"
            value="${_csrf.token}"
          />
          <div class="mb-3">
            <label class="form-label">이메일</label>
            <input
              type="email"
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
          <div class="mb-3">
            <label class="form-label">닉네임</label>
            <input
              type="text"
              name="nickName"
              class="form-control"
              placeholder="닉네임 입력"
              required
            />
          </div>
          <div class="d-grid gap-2">
            <button type="submit" class="btn btn-primary">가입하기</button>
            <a href="/member/login" class="btn btn-secondary">취소</a>
          </div>
        </form>
      </div>
    </div>

    <jsp:include page="../layout/footer.jsp" />
  </body>
</html>
