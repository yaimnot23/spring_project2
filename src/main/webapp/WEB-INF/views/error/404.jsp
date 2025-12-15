<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>404 - Page Not Found</title>
    <link href="/resources/css/bootstrap.min.css" rel="stylesheet" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <style>
      body {
        background-color: #0d1117; /* GitHub Dark Mode Background */
        color: #c9d1d9;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica,
          Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji";
        text-align: center;
        padding-top: 100px;
        overflow: hidden;
      }
      .error-code {
        font-size: 120px;
        font-weight: bold;
        color: #8b949e;
        text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.5);
      }
      .message {
        font-size: 24px;
        margin-bottom: 30px;
      }
      .astronaut {
        width: 150px;
        animation: float 6s ease-in-out infinite;
        margin-bottom: 40px;
      }
      @keyframes float {
        0% {
          transform: translateY(0px) rotate(0deg);
        }
        50% {
          transform: translateY(-20px) rotate(5deg);
        }
        100% {
          transform: translateY(0px) rotate(0deg);
        }
      }
      .btn-home {
        background-color: #238636;
        color: white;
        padding: 10px 20px;
        border-radius: 6px;
        text-decoration: none;
        font-weight: bold;
        transition: background-color 0.2s;
      }
      .btn-home:hover {
        background-color: #2ea043;
        color: white;
      }
      .stars {
        position: absolute;
        width: 100%;
        height: 100%;
        top: 0;
        left: 0;
        z-index: -1;
        background-image: radial-gradient(
            2px 2px at 20px 30px,
            #eee,
            rgba(0, 0, 0, 0)
          ),
          radial-gradient(2px 2px at 40px 70px, #fff, rgba(0, 0, 0, 0)),
          radial-gradient(2px 2px at 50px 160px, #ddd, rgba(0, 0, 0, 0)),
          radial-gradient(2px 2px at 90px 40px, #fff, rgba(0, 0, 0, 0)),
          radial-gradient(2px 2px at 130px 80px, #fff, rgba(0, 0, 0, 0));
        background-repeat: repeat;
        background-size: 200px 200px;
        opacity: 0.3;
      }
    </style>
  </head>
  <body>
    <div class="stars"></div>

    <div class="container">
      <!-- 우주인 아이콘 (FontAwesome) -->
      <div class="astronaut">
        <i class="fa-solid fa-user-astronaut fa-6x" style="color: #e0e0e0"></i>
      </div>

      <div class="error-code">404</div>
      <div class="message">
        Oops! 찾으시는 페이지가 우주 미아가 된 것 같아요.
      </div>

      <p class="mb-5 text-muted">
        주소를 다시 확인하시거나 홈으로 돌아가주세요.
      </p>

      <a href="/" class="btn-home">
        <i class="fa-solid fa-house"></i> Go Home
      </a>
    </div>
  </body>
</html>
