package com.tx.common.service.weakness;

import javax.servlet.http.HttpServletRequest;

public interface WeaknessService {

	/**
	 * 정규식 검증
	 * */
	public boolean regexCheck(String regex, String parameter);
	
	/**
	 * 게시판 검증
	 * */
	public boolean selfBoardCheck(HttpServletRequest req, String key);
	
}
