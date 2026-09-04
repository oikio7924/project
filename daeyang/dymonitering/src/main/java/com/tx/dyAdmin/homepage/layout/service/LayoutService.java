package com.tx.dyAdmin.homepage.layout.service;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import com.tx.dyAdmin.homepage.resource.dto.ResourcesDTO;

public interface LayoutService {
	/**
	 * 레이아웃 기본 파일 생성
	 * @throws Exception
	 */
	public boolean createLayoutFile(String tiles, HttpServletRequest req, String homeKey) throws Exception;
	
	/**
	 * 레이아웃 템플릿 파일 복사
	 * @throws Exception
	 */
	public boolean copyLayoutFile(String oriTiles, String newTiles, HttpServletRequest req, String homeKey) throws Exception;
	
	/**
	 * 리소스 템플릿 파일 복사
	 * @throws Exception
	 */
	public boolean copyResourceFile(String type, String oriTiles, String newTiles, HttpServletRequest req, String homeKey) throws Exception;
	
	/**
	 * 레이아웃 관련 데이터 삭제
	 * @param homeDiv
	 */
	public void deleteLayout(String homeDiv) throws Exception;
	
	/**
	 * 데이터 버전 체크
	 * @param ResourcesDTO
	 * @param currentVersion
	 * @throws Exception
	 */
	public HashMap<String, Object> dataVersionCheck(HashMap<String, Object> resultMap, ResourcesDTO ResourcesDTO, Double currentVersion) throws Exception;
	
	/**
	 * 데이터 복원
	 * @param ResourcesDTO
	 * @param currentVersion
	 * @throws Exception
	 */
	public HashMap<String, Object> dataReturnPage(ResourcesDTO ResourcesDTO) throws Exception;
	
	/**
	 * 데이터와 히스토리 저장
	 * @param ResourcesDTO
	 * @param currentVersion
	 * @throws Exception
	 */
	public void dataActionProcess(HttpServletRequest req, String actiontype, ResourcesDTO ResourcesDTO, String MN_HOMEDIV_C, Double currentVersion) throws Exception;
}
