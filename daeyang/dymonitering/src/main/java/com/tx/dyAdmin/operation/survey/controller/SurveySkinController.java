package com.tx.dyAdmin.operation.survey.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.dto.Common;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.page.PageAccess;
import com.tx.common.service.publish.CommonPublishService;
import com.tx.dyAdmin.homepage.menu.dto.Menu;
import com.tx.dyAdmin.operation.survey.dto.SsDTO;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * 
 * @FileName: SurveySkinController.java
 * @Project : 설문 스킨 관리
 * @Date : 2020. 02. 04.
 * @Author : 김지웅
 * @Version : 1.0
 */

@Controller
public class SurveySkinController {

	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;

	@Autowired private CommonPublishService CommonPublishService;
	
	/** 페이지 처리 출 */
	@Autowired private PageAccess PageAccess;
	
	/**
	 * 설문 스킨 관리
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/operation/survey/surveyskin.do")
	@CheckActivityHistory(desc="설문 스킨 관리 페이지 방문")
	public ModelAndView surveySkinView(HttpServletRequest req
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/operation/survey/skin/pra_survey_skin_listView.adm");
		return mv;
	}	

	/**
	 * 설문스킨 관리 - 페이징 ajax
	 * @param req
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/operation/survey/skinPagingAjax.do")
	public ModelAndView surveySkinPagingAjax(HttpServletRequest req
			,Common search
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/operation/survey/skin/pra_survey_skin_listview_data");

		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"survey.SS_getListCnt",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		mv.addObject("resultList", Component.getList("survey.SS_getList", map));
		mv.addObject("search", search);
		return mv;
	}

	/**
	 * 설문 스킨 관리 - 배포
	 * 
	 * @param model
	 * @param SS_KEYNO
	 * @param allck
	 * @return
	 * @throws Exception
	 */

	@RequestMapping(value = "/dyAdmin/operation/survey/distributeAjax.do")
	@ResponseBody
	@CheckActivityHistory(desc = "설문 스킨 배포 처리", homeDiv = SettingData.HOMEDIV_ADMIN)
	public Boolean surveyDistributeAjax(Model model
			,String SS_KEYNO
			,boolean allck
			) throws Exception {							
		boolean state = CommonPublishService.survey(allck, SS_KEYNO);			
		return state;
	}

	/**
	 * 설문 스킨 등록/수정
	 * 
	 * @param req
	 * @param Menu
	 * @param SsDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/operation/survey/skinUpdate.do")
	@CheckActivityHistory(desc = "설문 스킨 등록/수정 방문")
	public ModelAndView surveySkinUpdateView(HttpServletRequest req 
			,Menu Menu 
			,SsDTO SsDTO
			) throws Exception {
		ModelAndView mv = new ModelAndView("/dyAdmin/operation/survey/skin/pra_survey_skin_insertView.adm");

		mv.addObject("surveySkinResultData", Component.getData("survey.SS_getSkinData", SsDTO));		
		mv.addObject("SS_KEYNO", SsDTO.getSS_KEYNO());
		
		if(StringUtils.isEmpty(SsDTO.getSS_KEYNO())) { 
			mv.addObject("action", "insert");			
		} else {
			mv.addObject("action", "update");
			mv.addObject("SkinDataHistory", Component.getList("survey.SSH_getList", SsDTO));
		}
		
		mv.addObject("mirrorPage","/dyAdmin/operation/survey/surveyskin.do");

		return mv;
	}	
	
	/**
	 * 설문 스킨 삭제
	 * 
	 * @param SsDTO
	 * @param req
	 * @return
	 * @throws Exception
	 */

	@RequestMapping(value = "/dyAdmin/operation/surveyskin/delete.do")
	@CheckActivityHistory(desc = "설문 스킨 삭제 처리", homeDiv = SettingData.HOMEDIV_ADMIN)
	@ResponseBody
	@Transactional
	public ModelAndView surveySkinDeleteView(SsDTO SsDTO
			,HttpServletRequest req
			) throws Exception {
		ModelAndView mv = new ModelAndView("redirect:/dyAdmin/operation/survey/surveyskin.do");
		Component.deleteData("survey.SS_delete", SsDTO.getSS_KEYNO());	
		
		return mv;
	}

	/**
	 * 설문 스킨 관리 - 설문 스킨 저장처리
	 * 
	 * @param SsDTO
	 * @param action
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/operation/surveyskin/insert.do")
	@ResponseBody
	@CheckActivityHistory(desc = "설문 스킨 저장 처리", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView suverySkinInsert(SsDTO SsDTO
			,@RequestParam(value = "action", required = false) String action
			,HttpServletRequest req
			) throws Exception {

		ModelAndView mv  = new ModelAndView("redirect:/dyAdmin/operation/survey/surveyskin.do");
		
		Map<String, Object> user = CommonService.getUserInfo(req);
		String regName = ((String) user.get("UI_KEYNO"));
		String REGDT = Component.getData("survey.get_historyDate", SsDTO);

		if ("insert".equals(action)) {
			SsDTO.setSS_KEYNO(CommonService.getTableKey("SS"));
			SsDTO.setSS_REGNM(regName);
			Component.createData("survey.SS_insert", SsDTO);
			REGDT = Component.getData("survey.get_historyDate", SsDTO);
		} else if ("update".equals(action)) {
			SsDTO.setSS_MODNM(regName);
			Component.createData("survey.SS_update", SsDTO);
		}

		/* 히스토리 저장 시작 */
		double VersionNum = Component.getData("survey.get_historyVersion", SsDTO);
		VersionNum += 0.01;
		SsDTO.setSSH_KEYNO(CommonService.getTableKey("SSH"));
		SsDTO.setSSH_SS_KEYNO(SsDTO.getSS_KEYNO());
		SsDTO.setSSH_STDT(REGDT);
		SsDTO.setSSH_MODNM(regName);
		SsDTO.setSSH_DATA(SsDTO.getSS_DATA());
		SsDTO.setSSH_VERSION(VersionNum);

		String message = SsDTO.getSSH_COMMENT();
		if(StringUtils.isEmpty(SsDTO.getSSH_COMMENT())) {
			message = "no message";
		}
		SsDTO.setSSH_COMMENT(message);
		Component.createData("survey.SSH_insert", SsDTO);
		/* 히스토리 저장 끝 */

		return mv;

	}

	/**
	 * 설문 스킨 관리 - 설문 스킨 복원처리
	 * 
	 * @param req
	 * @param SsDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/operation/survey/returnPageAjax.do")
	@ResponseBody
	@CheckActivityHistory(desc = "설문 스킨 복원 처리", homeDiv = SettingData.HOMEDIV_ADMIN)
	public String suverySkinReturnPageAjax(HttpServletRequest req
			,SsDTO SsDTO
			) throws Exception {
		SsDTO = Component.getData("survey.SSH_getData", SsDTO);		
		return SsDTO.getSSH_DATA();
	}

	/**
	 * 설문 스킨 관리 - 최신데이터와 비교, 변경사항
	 * 
	 * @param req
	 * @param SsDTO
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/dyAdmin/operation/survey/compareAjax.do")
	@ResponseBody
	public List suverySkinCompareAjax(HttpServletRequest req
			,SsDTO SsDTO
			) throws Exception {
		return Component.getList("survey.SSH_compareData", SsDTO);
	}	

	/**
	 * 스킨 이름 중복 검사
	 * 
	 * @param SS_SKIN_NAME
	 * @param SS_KEYNO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/operation/survey/RedundancyAjax.do")
	@ResponseBody
	public Integer suverySkinNameRedundancyAjax(@RequestParam(value = "SS_SKIN_NAME") String SS_SKIN_NAME
			,@RequestParam(value = "SS_KEYNO", required = false) String SS_KEYNO
			) throws Exception {
		SsDTO SsDTO = new SsDTO();
		SsDTO.setSS_SKIN_NAME(SS_SKIN_NAME);
		SsDTO.setSS_KEYNO(SS_KEYNO);
		
		return Component.getCount("survey.SS_getSkinRDList", SsDTO);
	}
	
	/**
	 * 스킨 사용 여부 판단
	 * 
	 * @param SS_KEYNO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/operation/survey/useSkinAjax.do")
	@ResponseBody
	public Integer suveryUseSkinAjax(@RequestParam(value = "SS_KEYNO", required = false) String SS_KEYNO
			) throws Exception {		
		return Component.getCount("survey.SS_getSkinUsing", SS_KEYNO);
	}
}
