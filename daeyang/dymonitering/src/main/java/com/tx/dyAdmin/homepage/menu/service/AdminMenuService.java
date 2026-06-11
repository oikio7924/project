package com.tx.dyAdmin.homepage.menu.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.tx.dyAdmin.admin.domain.dto.HomeManager;
import com.tx.dyAdmin.homepage.menu.dto.Menu;


/**
 * AdminMenuService
 * @author 이재령
 * @version 1.0
 * @since 2019-05-15
 */
public interface AdminMenuService {

	
	/**
	 * 메뉴 리스트 가져오기
	 * @param pageDivList 
	 * @param _depth 
	 * @param req
	 * @param tour
	 * @param REGNM
	 * @throws Exception
	 */
	public List<Menu> getMenuList(HomeManager homeManager, List<String> pageDivList, boolean isIncludeHomeDiv, boolean isSubMenuSearch, boolean authCheck) throws Exception;
	
	public List<Menu> getMenuList(HomeManager homeManager, List<String> pageDivList) throws Exception;
	
	public List<Menu> getMenuList(HomeManager homeManager) throws Exception;
	
	public List<Menu> getMenuList(HomeManager homeManager, List<String> pageDivList, boolean authCheck) throws Exception;
	
	public List<Menu> getMenuList(String MN_URL,String MN_HOMEDIV_C, boolean isIncludeHomeDiv) throws Exception;
	
	

	
} 
