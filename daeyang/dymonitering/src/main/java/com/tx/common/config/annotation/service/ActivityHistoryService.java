package com.tx.common.config.annotation.service;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.servlet.ModelAndView;

import com.tx.dyAdmin.homepage.menu.dto.Menu;

/**
 * 활동기록 서비스
 * @author 이재령
 * @date 2018-08-30
 *
 */
public interface ActivityHistoryService {
	
	/**
	 * 활동기록 
	 * @param keyword
	 * @param req
	 */
	public void setDesc(String desc, ModelAndView mv) throws Exception;
	
	/**
	 * 활동기록 
	 * @param keyword
	 * @param req
	 */
	public void setDesc(HashMap<String,Object> activityHistory,ModelAndView mv) throws Exception;
	

	/**
	 * 활동기록 - 게시판 액션
	 * @param menu
	 * @param boardNotice
	 * @param type
	 * @param mv
	 */
	public void setDescBoardAction(Menu menu, String boardTitle, String type, HttpServletRequest request) throws Exception;
	
	
	/**
	 * 활동기록 - 게시판 타입 액션
	 * @param menu
	 * @param boardNotice
	 * @param type
	 * @param mv
	 */
	public void setDescBoardTypeAction(String type, HttpServletRequest request) throws Exception;
	
	
	/**
	 * 활동기록 - 리소스 액션
	 * @param menu
	 * @param boardNotice
	 * @param type
	 * @param mv
	 */
	public void setDescResourceAction(String HOME_NAME, String resourcesName, String type, HttpServletRequest request) throws Exception;
	
	/**
	 * 활동기록 - 설문관리 액션
	 * @param menu
	 * @param boardNotice
	 * @param type
	 * @param mv
	 */
	public void setDescSurveyAction(String typeName, String type, HttpServletRequest request) throws Exception;
	
	
	
	/**
	 * 활동기록 - 메뉴스킨 액션
	 * @param menu
	 * @param type
	 * @param mv
	 */
	
	public void setDescMenuSkinAction(String HOME_NAME, String type, HttpServletRequest request) throws Exception;
	
	/**
	 * 활동기록 - 페이지관리 액션
	 * @param HOME_NAME
	 * @param type
	 * @param request
	 * @throws Exception
	 */
	public void setDescPageAction(String HOME_NAME, String type, HttpServletRequest request) throws Exception;
	
	/**
	 * 활동기록 - 게시판 스킨 액션
	 * @param name
	 * @param type
	 * @param request
	 * @throws Exception
	 */
	public void setDescBoardSkinAction(String name, String type, HttpServletRequest request) throws Exception;
	
}
