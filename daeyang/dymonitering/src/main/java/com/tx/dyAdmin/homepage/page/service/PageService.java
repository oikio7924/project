package com.tx.dyAdmin.homepage.page.service;

import java.util.HashMap;

import com.tx.dyAdmin.homepage.page.dto.HTMLViewData;

public interface PageService {
	/**
	 * 데이터 버전 체크
	 * @param ResourcesDTO
	 * @param currentVersion
	 * @throws Exception
	 */
	public HashMap<String, Object> dataVersionCheck(HashMap<String, Object> resultMap, HTMLViewData hTMLViewData, Double currentVersion) throws Exception;
	
	/**
	 * 데이터 복원
	 * @param ResourcesDTO
	 * @param currentVersion
	 * @throws Exception
	 */
	public HashMap<String, Object> dataReturnPage(HTMLViewData hTMLViewData) throws Exception;
	
}
