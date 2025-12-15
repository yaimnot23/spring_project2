-- 1. admin99 사용자 생성 (비밀번호: 1234 -> BCrypt 암호화)
-- 비번은 $2a$10$ 로 시작하는 암호화된 문자열이어야 합니다.
-- 여기서는 예시로 '1234'의 BCrypt 해시값을 넣습니다.
INSERT INTO member (email, pwd, nick_name) 
VALUES ('admin99', '$2a$10$k0WlbPHBvIoicTXGA5SLyOeRZD2cRBBXDHKQCjhebJCTGatAGSP72', '관리자');

-- 2. 권한 부여 (ROLE_ADMIN, ROLE_USER 둘 다 부여 가능)
INSERT INTO auth (email, auth) VALUES ('admin99', 'ROLE_ADMIN');
INSERT INTO auth (email, auth) VALUES ('admin99', 'ROLE_USER');

-- admin100 사용자에게 관리자 권한 추가
INSERT INTO auth (email, auth) VALUES ('admin100', 'ROLE_ADMIN');