package com.tx.common.config.annotation.service.impl;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.annotation.service.ActivityHistoryService;
import com.tx.dyAdmin.homepage.menu.dto.Menu;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 활동기록 서비스
 * @author 이재령
 * @date 2018-08-30
 *
 */
@Service("ActivityHistoryService")
public class ActivityHistoryServiceImpl  extends EgovAbstractServiceImpl implements ActivityHistoryService {
	
	
	
	@Override
	public void setDesc(String desc, ModelAndView mv) throws Exception {
		
		HashMap<String,Object> activityHistory = new HashMap<String,Object>();
		activityHistory.put("desc", desc);
		
		mv.addObject("activityHistory",activityHistory);
	}
	
	@Override
	public void setDesc(HashMap<String,Object> activityHistory, ModelAndView mv) throws Exception {

	}

	/**
	 * 활동기록 - 게시판 액션
	 * @param menu
	 * @param boardNotice
	 * @param type
	 * @param mv
	 */
	public void setDescBoardAction(Menu menu, String boardTitle, String type, HttpServletRequest request)  throws Exception{
		String action = "";
		if("insert".equals(type)){
			action = "등록 작업";
		}else if("insertView".equals(type)){
			action  = "등록화면 방문";
		}else if("update".equals(type)){
			action = "수정 작업";
		}else if("updateView".equals(type)){
			action  = "수정화면 방문";
		}else if("move".equals(type)){
			action = "이동 작업";
		}else if("moveView".equals(type)){
			action  = "이동화면 방문";
		}else if("detail".equals(type)){
			action  = "상세화면 방문";
		}else if("delete".equals(type)){
			action  = "삭제 작업";
		}else if("recovery".equals(type)){
			action  = "복원 작업";
		}else if("show".equals(type)){
			action  = "보이기 처리 작업";
		}else if("hide".equals(type)){
			action  = "숨김 처리 작업";
		}
		
		String desc = "";
		if(type.endsWith("insertView")){
			desc = menu.getMN_NAME() + " 게시물 " + action;
		}else{
			desc = menu.getMN_NAME() + " '" + boardTitle + "' 게시물 " + action;
		}
		request.setAttribute("desc", desc);
		request.setAttribute("homeDiv", menu.getMN_HOMEDIV_C());
	}
	
	/**
	 * 활동기록 - 게시판 타입 액션
	 * @param menu
	 * @param boardNotice
	 * @param type
	 * @param mv
	 */
	public void setDescBoardTypeAction(String type, HttpServletRequest request)  throws Exception{
		
		String action = "";
		if("insert".equals(type)){
			action = "등록 작업";
		}else if("insertView".equals(type)){
			action  = "등록화면 방문";
		}else if("update".equals(type)){
			action = "수정 작업";
		}else if("updateView".equals(type)){
			action  = "수정화면 방문";
		}
		
		String desc = "게시판 타입관리 " + action;
		
		request.setAttribute("desc", desc);
	}
	
	
	/**
	 * 활동기록 - 리소스 액션
	 * @param menu
	 * @param boardNotice
	 * @param type
	 * @param mv
	 */
	public void setDescResourceAction(String HOME_NAME, String resourcesName, String type, HttpServletRequest request)  throws Exception{
		
		String action = "";
		if("insert".equals(type)){
			action = "등록 작업";
		}else if("insertView".equals(type)){
			action  = "페이지 방문";
		}else if("update".equals(type)){
			action = "수정 작업";
		}else if("delete".equals(type)){
			action  = "삭제 작업";
		}else if("distribute".equals(type)){
			action  = "배포 작업";			
		}
		
		String desc = "";
		if(StringUtils.isNotEmpty(HOME_NAME)){
			desc = HOME_NAME + " "+ resourcesName + " 관리 " + action;
			request.setAttribute("homeDiv", HOME_NAME);
		}else{
			desc ="공통 관리 ("+ resourcesName + ") " + action;
		}
		
		request.setAttribute("desc", desc);
	}
	
	
	/**
	 * 활동기록 - 설문관리 액션
	 * @param menu
	 * @param boardNotice
	 * @param type
	 * @param mv
	 */
	public void setDescSurveyAction(String typeName, String type, HttpServletRequest request)  throws Exception{
		
		String action = "";
		if(typeName.equals("page")){
			if("Insert".equals(type)){
				action = "등록 페이지 방문";
			}else if("Update".equals(type)){
				action  = "수정 페이지 방문";
			}
		}else if(typeName.equals("process")){
			if("Insert".equals(type)){
				action = "등록 작업";
			}else if("Update".equals(type)){
				action  = "수정 작업";
			}
		}
		
		String desc = "";
		desc = " 설문관리 " + action;
		
		request.setAttribute("desc", desc);
	}
	
	/**
	 * 활동기록 - 리소스 액션
	 * @param menu
	 * @param boardNotice
	 * @param type
	 * @param mv
	 */
	public void setDescMenuSkinAction(String HOME_NAME, String type, HttpServletRequest request)  throws Exception{
		
		String action = "";
		if("insert".equals(type)){
			action = "등록 작업";
		}else if("insertView".equals(type)){
			action  = "페이지 방문";
		}else if("update".equals(type)){
			action = "수정 작업";
		}else if("delete".equals(type)){
			action  = "삭제 작업";
		}else if("recovery".equals(type)){
			action  = "복원 작업";
		}else if("distribute".equals(type)){
			action  = "배포 작업";			
		}
		
		String desc = "";
		desc = HOME_NAME +" " + action;
		
		request.setAttribute("desc", desc);
		request.setAttribute("homeDiv", HOME_NAME);
	}

	@Override
	public void setDescPageAction(String HOME_NAME, String type, HttpServletRequest request) throws Exception {
		String action = "";
		if("insert".equals(type)){
			action = "등록 및 수정 작업";
		}else if("delete".equals(type)){
			action  = "삭제 작업";
		}else if("recovery".equals(type)){
			action  = "복원 작업";
		}else if("distribute".equals(type)){
			action  = "배포 작업";			
		}
		
		String desc = "페이지 관리 " + HOME_NAME + " "+ action;
		
		request.setAttribute("desc", desc);
		request.setAttribute("homeDiv", HOME_NAME);
	}
	
	@Override
	public void setDescBoardSkinAction(String name, String type, HttpServletRequest request) throws Exception {
		String action = "";
		if("insert".equals(type)){
			action = "등록 작업";
		}else if("update".equals(type)){
			action  = "수정 작업";
		}else if("delete".equals(type)){
			action  = "삭제 작업";
		}
		
		String desc = name + " "+ action;
		
		request.setAttribute("desc", desc);
	}
	
	

}
