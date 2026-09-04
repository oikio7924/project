package com.tx.dyAdmin.homepage.menu.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.tx.dyAdmin.homepage.menu.dto.Menu;


/**
 * AdminMenuSessionService
 * @author 이혜주
 * @version 1.0
 * @since 2019-06-14
 */
public interface AdminMenuSessionService {

	
	/**
	 * 메뉴 최종 수정시간 저장
	 * @param req
	 * @param REGNM
	 * @throws Exception
	 */
	public void updateTime(String homeDiv) throws Exception;
	
	public void updateTime() throws Exception;
	
	public List<Menu> getMenuList(String tilesUrl, Map<String, Object> user, String homeDiv) throws Exception;
	

    	
} 
