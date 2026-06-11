package com.tx.dyAdmin.program.group.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.dto.Common;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.page.PageAccess;
import com.tx.dyAdmin.program.application.dto.ApplicationDTO;
import com.tx.dyAdmin.program.application.dto.PlaceDTO;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * 
 * @FileName: AdminGroupController.java
 * @Date    : 2018. 01. 23. 
 * @Author  : 이재령	
 * @Version : 1.0
 */
@Controller
public class AdminGroupController {

	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 페이지 처리 출 */
	@Autowired private PageAccess PageAccess;
	
	/**
	 * 단체예약 관리 - 프로그램관리
	 * @param req
	 * @param commandMap
	 * @param ResearchSkinDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/program/group/program.do")
	@CheckActivityHistory(desc="단체예약관리 페이지 방문")
	public ModelAndView programApplication(
			HttpServletRequest req
			,@RequestParam(value="MN_HOMEDIV_C",required=false) String MN_HOMEDIV_C
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/program/group/pra_group.adm");
		
		String homeKey = null;
		if(StringUtils.isNotBlank(MN_HOMEDIV_C)){
			homeKey = MN_HOMEDIV_C;
		}else{
			String siteKey = (String)req.getSession().getAttribute("SITE_KEYNO");
			if(StringUtils.isNotBlank(siteKey)){
				homeKey = siteKey;
			}else{
				homeKey = SiteProperties.getString("HOMEPAGE_REP");
			}
		}
		
		mv.addObject("MN_HOMEDIV_C", homeKey);
		mv.addObject("homeDivList", CommonService.getHomeDivCode(false));
		
		return mv;
	}

	
	/**
	 * 단체예약 관리 - 프로그램관리Ajax
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="/dyAdmin/program/group/program/pagingAjax.do")
	public ModelAndView groupAjax(
				HttpServletRequest req
				, Common search
				, ApplicationDTO ApplicationDTO
			) throws Exception {
	
        ModelAndView mv  = new ModelAndView("/dyAdmin/program/group/pra_group_data");
       
        List<HashMap<String,Object>> searchList = Component.getSearchList(req);
        Map<String,Object> map = CommonService.ConverObjectToMap(search);
       
        if(searchList != null){
            map.put("searchList", searchList);
        }
        
		map.put("GM_MN_HOMEDIV_C", req.getParameter("MN_HOMEDIV_C"));
        
        PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"Group.GM_AllListCnt",map, search.getPageUnit(), 10);
        map.put("firstIndex", pageInfo.getFirstRecordIndex());
        map.put("lastIndex", pageInfo.getLastRecordIndex());
        map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
        mv.addObject("paginationInfo", pageInfo);
        //가저올데이터
        mv.addObject("resultList", Component.getList("Group.GM_AllList", map));
        mv.addObject("search", search);
        return mv;
	}
	
	// 단체예약 관리 - 프로그램관리 엑셀
	@RequestMapping(value="/dyAdmin/program/group/program/excelAjax.do")
	public Object groupExcel(HttpServletRequest req
			, HttpServletResponse res
			, Common search
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/program/group/pra_group_excel");
		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		if(searchList != null){
			map.put("searchList", searchList);
		}
		map.put("GM_MN_HOMEDIV_C", req.getParameter("MN_HOMEDIV_C"));
		mv.addObject("resultList", Component.getList("Group.GM_AllList", map));
		mv.addObject("search", search);
		try {
			Cookie cookie = new Cookie("fileDownload", "true");
	        cookie.setPath("/");
	        res.addCookie(cookie);
        } catch (Exception e) {
            System.out.println("쿠키 에러 :: "+e.getMessage());
        }
		return mv;
		
	}
	
	
	@RequestMapping(value="/dyAdmin/program/group/actionView.do")
	@CheckActivityHistory(desc="단체예약관리 - 등록/수정 페이지 방문")
	public ModelAndView programGroupInsertView(
				  HttpServletRequest req
				, ApplicationDTO ApplicationDTO
				, PlaceDTO place
					) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/program/group/pra_group_insert.adm");
		
		
		if(StringUtils.isNotEmpty(ApplicationDTO.getGM_KEYNO())){
			  mv.addObject("GroupCnt", Component.getData("Group.GroupCnt", ApplicationDTO));
			  mv.addObject("ScheduleMain", Component.getList("Group.ScheduleMain", ApplicationDTO));
			  mv.addObject("ScheduleSub", Component.getList("Group.ScheduleSub", ApplicationDTO));
			  mv.addObject("DetailData", Component.getData("Group.GM_programData", ApplicationDTO));
			  mv.addObject("action", "update");
		}else{
		mv.addObject("action", "insert");
		}
		mv.addObject("mirrorPage", "/dyAdmin/program/group/program.do");
		mv.addObject("GM_MN_HOMEDIV_C", ApplicationDTO.getGM_MN_HOMEDIV_C());
		mv.addObject("placeList", Component.getList("Place.PM_getList",place));

		return mv;
	}
	

	@RequestMapping(value="/dyAdmin/program/group/action.do")
	@CheckActivityHistory(desc="단체예약관리 - 등록/수정/삭제 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	public ModelAndView programGroupAction(
	      HttpServletRequest req
	    , Map<String,Object> commandMap
	    , @RequestParam(value="schduleGroupData", required = false ) String schduleGroupData
	    , ApplicationDTO ApplicationDTO
	    , @RequestParam(value="action", required = false ) String action
	    ) throws Exception {
	  ModelAndView mv  = new ModelAndView("redirect:/dyAdmin/program/group/program.do");
	  
	    Map<String, Object> user = CommonService.getUserInfo(req);
	  //스케줄 셋팅
		 String GM_KEYNO= ApplicationDTO.getGM_KEYNO();
		if("insert".equals(action)){
			//등록 작업
		  ApplicationDTO.setGM_REGNM((String) user.get("UI_KEYNO"));
		  Component.createData("Group.GM_Insert", ApplicationDTO);
		  GM_KEYNO = ApplicationDTO.getGM_KEYNO();
		}else if("update".equals(action)){
			//수정 작업
		  ApplicationDTO.setGM_MODNM((String)user.get("UI_KEYNO"));
		  Component.updateData("Group.GM_Update", ApplicationDTO);
		  Component.deleteData("Group.GSS_Delete", ApplicationDTO);
		  Component.deleteData("Group.GSM_Delete", ApplicationDTO);
		}else{
			//삭제 작업
			Component.updateData("Group.GM_Delete", ApplicationDTO);
		}
			
		if(!"delete".equals(action)) setSchedule(GM_KEYNO,schduleGroupData);
	  mv.addObject("mirrorPage", "/dyAdmin/program/group/program.do");
	  return mv;
	}

	
	private void setSchedule(String GM_KEYNO, String schduleGroupData) {
		//다시 배열로 만들기
		schduleGroupData = schduleGroupData.replaceAll("&quot;", "\"");

		JsonParser parser = new JsonParser();	
		JsonElement element = parser.parse(schduleGroupData);
		JsonArray schduleGrouplist =  element.getAsJsonArray();

		for(JsonElement schduleGroup : schduleGrouplist){
		  
		  if(!schduleGroup.isJsonNull()){
			ApplicationDTO mainGroup = new ApplicationDTO();
			
		    String st_date = schduleGroup.getAsJsonObject().get("st_date").getAsString();
		    String en_date = schduleGroup.getAsJsonObject().get("en_date").getAsString();
		    
		    if(schduleGroup.getAsJsonObject().get("day") != null) {
		        JsonArray days = schduleGroup.getAsJsonObject().get("day").getAsJsonArray();
		        
		        if(!days.isJsonNull()) {
		          String GSM_DAY = "";
		          for (int i=0;i<days.size();i++) {
		            if(i != 0) {
		              GSM_DAY += ",";
		            }
		            GSM_DAY += days.get(i).getAsString();
		          }
		          mainGroup.setGSM_DAY(GSM_DAY);
		        }
		    }
		    
		    JsonArray times =  schduleGroup.getAsJsonObject().get("times").getAsJsonArray();
		    
		    if(!times.isJsonNull()){
		    	
//		    	String GSM_KEYNO = CommonService.getTableKey("GSM");
	        	  String GSM_KEYNO = Integer.toString(CommonService.getTableAutoKey("T_GROUP_SCHEDULE_MAIN", "GSM_SEQ"));
			      mainGroup.setGSM_KEYNO(GSM_KEYNO);
			      mainGroup.setGSM_GM_KEYNO(GM_KEYNO);
			      
		      for(JsonElement timeData : times){
		    	  ApplicationDTO subGroup = new ApplicationDTO();
		    	  subGroup.setGSS_GSM_KEYNO(GSM_KEYNO);
		        
		        String st_h = timeData.getAsJsonObject().get("st_h").getAsString();
		        String en_h = timeData.getAsJsonObject().get("en_h").getAsString();
		        String cnt = timeData.getAsJsonObject().get("cnt").getAsString();
		        String title = timeData.getAsJsonObject().get("title").getAsString();
		        String start_time = st_h;
		        String end_time = en_h;
		        
		        subGroup.setGSS_ST_TIME(start_time);
		        if(en_h != null && !en_h.equals("")) {
		        	subGroup.setGSS_EN_TIME(end_time);		           	    	
		        }
		        subGroup.setGSS_MAXIMUM(cnt);
		        subGroup.setGSS_SUBTITLE(title);
		        
		        Component.createData("Group.GSS_Insert", subGroup);
		        
		      }
			    //스케줄 메인 등록
			    mainGroup.setGSM_STDT(st_date);
			    mainGroup.setGSM_ENDT(en_date);
			    
			    Component.createData("Group.GSM_Insert", mainGroup);   
		    }
		    
		  }
		}
	}

	/**
	 * 단체예약 관리 - 프로그램관리 - 스케줄 추가
	 * @param req
	 * @param commandMap
	 * @param ResearchSkinDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/program/group/subProgramInsert.do")
	@CheckActivityHistory(desc="단체예약관리 - 프로그램 스케줄 추가", homeDiv= SettingData.HOMEDIV_ADMIN)
	public ApplicationDTO subProgramInsert(
			  HttpServletRequest req
			, Map<String,Object> commandMap
			, ApplicationDTO ApplicationDTO
			) throws Exception {
		
		ApplicationDTO.setGM_KEYNO(CommonService.getTableKey("GM"));
		ApplicationDTO.setGSM_KEYNO(CommonService.getTableKey("GSM"));
		
		return ApplicationDTO;
	}
	
	
	/**
	 * 단체예약 관리 - 신청자 관리
	 * @param req
	 * @param commandMap
	 * @param ResearchSkinDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/program/group/apply.do")
	@CheckActivityHistory(desc="단체예약관리 페이지 방문")
	public ModelAndView programApply(
			HttpServletRequest req
			,@RequestParam(value="MN_HOMEDIV_C",required=false) String MN_HOMEDIV_C			
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/program/group/pra_applyList.adm");
		
		String homeKey = null;
		if(StringUtils.isNotBlank(MN_HOMEDIV_C)){
			homeKey = MN_HOMEDIV_C;
		}else{
			String siteKey = (String)req.getSession().getAttribute("SITE_KEYNO");
			if(StringUtils.isNotBlank(siteKey)){
				homeKey = siteKey;
			}else{
				homeKey = SiteProperties.getString("HOMEPAGE_REP");
			}
		}
		
		mv.addObject("MN_HOMEDIV_C", homeKey);
		mv.addObject("homeDivList", CommonService.getHomeDivCode(false));
		
		return mv;
	}

	/**
	 * 단체예약 관리 - 신청자 관리Ajax
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="/dyAdmin/program/group/apply/pagingAjax.do")
	public ModelAndView applyAjax(
				HttpServletRequest req
				, Common search
				, ApplicationDTO ApplicationDTO
			) throws Exception {
        ModelAndView mv  = new ModelAndView("/dyAdmin/program/group/pra_applyList_data");
       
        List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
       
        if(searchList != null){
            map.put("searchList", searchList);
        }
		map.put("GM_MN_HOMEDIV_C", req.getParameter("MN_HOMEDIV_C"));
		
        PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"Group.GP_SelectCnt",map, search.getPageUnit(), 10);
        map.put("firstIndex", pageInfo.getFirstRecordIndex());
        map.put("lastIndex", pageInfo.getLastRecordIndex());
        map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
        mv.addObject("paginationInfo", pageInfo);
        //가저올데이터
        mv.addObject("resultList", Component.getList("Group.GP_Select", map));
        mv.addObject("search", search);
        return mv;
	}
	
	// 단체예약 관리 - 신청자 관리 엑셀
	@RequestMapping(value="/dyAdmin/program/group/apply/excelAjax.do")
	public Object applyExcel(HttpServletRequest req
			, HttpServletResponse res
			, Common search
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/program/group/pra_applyList_excel");
		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		if(searchList != null){
			map.put("searchList", searchList);
		}
		map.put("GM_MN_HOMEDIV_C", req.getParameter("MN_HOMEDIV_C"));
		mv.addObject("resultList", Component.getList("Group.GP_Select", map));
		mv.addObject("search", search);
		try {
			Cookie cookie = new Cookie("fileDownload", "true");
	        cookie.setPath("/");
	        res.addCookie(cookie);
        } catch (Exception e) {
            System.out.println("쿠키 에러 :: "+e.getMessage());
        }
		return mv;
		
	}
	
	/**
	 * 단체예약 관리 - 신청자 상세정보
	 * @param req
	 * @param commandMap
	 * @param ResearchSkinDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/program/group/applyDetail.do")
	@CheckActivityHistory(desc="단체예약관리 페이지 방문")
	public ModelAndView programApplyDetail(
			 HttpServletRequest req
			, @RequestParam("key") String key
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/program/group/pra_applyDetail.adm");
		mv.addObject("applyData", Component.getData("mypage.tour_apply_detail", key));
		mv.addObject("mirrorPage", "/dyAdmin/program/group/apply.do");
		return mv;
	}
	
}
