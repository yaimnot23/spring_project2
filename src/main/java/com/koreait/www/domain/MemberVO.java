package com.koreait.www.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class MemberVO {
    private String email;
    private String pwd;
    private String nickName;
    private Date regDate;
    private Date lastLogin;
    private List<AuthVO> authList;
}