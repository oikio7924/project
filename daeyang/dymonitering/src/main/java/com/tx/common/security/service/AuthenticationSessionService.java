package com.tx.common.security.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.core.Authentication;

public interface AuthenticationSessionService {
	
	
	/**
	 * 회원정보 새로고침
	 * @param currentAuth
	 * @param username
	 * @param req
	 * @return
	 */
	public Authentication updateAuthentication(Authentication currentAuth, String username, HttpServletRequest req) throws Exception;
	
	/**
	 * 유저정보 세션에 저장 및 활동기록,마지막 로그인 일자 저장
	 * @param map
	 * @param request
	 * @param isLogin
	 */
	public void createSession(Map<String, Object> map, HttpServletRequest request,boolean isLogin);
}
