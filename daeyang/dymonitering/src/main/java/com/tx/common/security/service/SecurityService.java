package com.tx.common.security.service;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.core.Authentication;

public interface SecurityService {

	/**
	 * 스프링 시큐리티 권한 생성
	 * @param currentAuth
	 * @param username
	 * @param req
	 * @return
	 */
	public Authentication createNewAuthentication(Authentication currentAuth, String username, HttpServletRequest req);
}
