package com.tx.dyAdmin.admin.authority.service;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.servlet.ModelAndView;

import com.tx.dyAdmin.admin.domain.dto.HomeManager;

/**
 * 권한 관리 서비스
 * @author 이재령
 * @date 2019-06-01
 *
 */
public interface AdminAuthorityService {

	/**
	 * 하위 그룹 및 권한 가져오기
	 * @param UIA_KEYNO
	 * @return
	 * @throws Exception
	 */
	public List<HashMap<String,Object>> getChildAuthority(String UIA_KEYNO) throws Exception;
	
	/**
	 * 게시판 리스트 트리구조로 가져오기
	 * @param UIA_KEYNO
	 * @return
	 * @throws Exception
	 */
	public List<HashMap<String,Object>> getBoardList(String UIA_KEYNO) throws Exception;
	
	/**
	 * 시스템 권한 재설정
	 * @throws Exception
	 */
	public void applyAuhotiry() throws Exception;

	/**
	 * 유저 리스트 가져오기
	 * @param MN_KEYNO
	 * @return
	 * @throws Exception
	 * */
	public List<HashMap<String,Object>> getUserList(String MN_KEYNO) throws Exception;

	public ModelAndView getListAjax(String returnPage, String type, Integer pageIndex, String searchKeyword) throws Exception;

	public void save(HttpServletRequest req) throws Exception;

	public ModelAndView getMenuList(String returnPage, String type, String key) throws Exception;

	public String saveMenuListByAuthority(HttpServletRequest req) throws Exception;

	public void createDefaultAuthority(HomeManager homeManager) throws Exception;

	public void deleteDefaultAuthority(String HM_KEYNO) throws Exception;
}
