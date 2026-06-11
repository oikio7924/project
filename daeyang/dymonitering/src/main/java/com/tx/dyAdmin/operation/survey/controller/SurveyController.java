package com.tx.dyAdmin.operation.survey.controller;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.transaction.Transactional;

import org.codehaus.plexus.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.config.annotation.service.ActivityHistoryService;
import com.tx.common.dto.Common;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.page.PageAccess;
import com.tx.dyAdmin.operation.survey.dto.SmDTO;
import com.tx.dyAdmin.operation.survey.dto.SqDTO;
import com.tx.dyAdmin.operation.survey.dto.SrmDTO;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class SurveyController {
	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 활동기록 서비스 */
	@Autowired private ActivityHistoryService ActivityHistoryService;
	
	/** 페이지 처리 출 */
	@Autowired private PageAccess PageAccess;
	
	/**
	 * 관리자 설문관리 목록 페이지
	 * @param req
	 * @return
	 * @throws Exception  
	 */
	@RequestMapping(value="/dyAdmin/operation/survey/survey.do")
	@CheckActivityHistory(desc = "설문관리 페이지 방문", homeDiv = SettingData.HOMEDIV_ADMIN)
	public ModelAndView surveyListView(HttpServletRequest req
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/operation/survey/pra_survey_listView.adm");
		
		return mv;
	}
	
	/**
	 * 관리자 설문관리 목록 페이지 - 페이징 ajax
	 * @param req
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/operation/survey/pagingAjax.do")
	public ModelAndView surveyListViewPagingAjax(HttpServletRequest req
			,Common search
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/operation/survey/pra_survey_listView_data");

		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"survey.SM_getListCnt",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		mv.addObject("resultList", Component.getList("survey.SM_getList", map));
		mv.addObject("search", search);
		mv.addObject("homeDivList", CommonService.getHomeDivCode(false));
		
		return mv;		
	}
	
	
	/**
	 * 관리자 설문관리 목록 페이지 - excel ajax
	 * @param req
	 * @param res
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/operation/survey/excelAjax.do")
	public ModelAndView surveyListViewExcelAjax(HttpServletRequest req
			,HttpServletResponse res
			,Common search
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/operation/survey/pra_survey_listView_excel");
		
		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		mv.addObject("resultList", Component.getList("survey.SM_getList", map));
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
	 * 관리자 설문지 상세보기
	 * @param req
	 * @param SmDTO
	 * @param action
	 * @return
	 * @throws Exception  
	 */
	@RequestMapping(value="/dyAdmin/operation/survey/actionView.do")
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	public ModelAndView surveyActionView(HttpServletRequest req
			,@ModelAttribute SmDTO SmDTO
			,@RequestParam(value="action", required=false) String action
			) throws Exception{
		ModelAndView mv  = new ModelAndView("/dyAdmin/operation/survey/pra_survey_insertView.adm");
		
		// 설문지 정보 불러오기		
		mv.addObject("SmDTO", Component.getData("survey.SM_selectBySmkey", SmDTO.getSM_KEYNO()));
				
		// 설문 스킨 목록 불러오기
		HashMap<String, Object> data = new HashMap<>();
		mv.addObject("surveySkinList", Component.getList("survey.SS_getSkinData", data));
		
		mv.addObject("homeDivList", CommonService.getHomeDivCode(false));
		mv.addObject("action", action);
		mv.addObject("mirrorPage","/dyAdmin/operation/survey/survey.do");
		
		// 활동기록
		ActivityHistoryService.setDescSurveyAction("page", action, req);
		
		return mv;
	}
	
	/**
	 * 관리자 설문지 등록
	 * @param req
	 * @param SmDTO
	 * @param action
	 * @return
	 * @throws Exception  
	 */
	@RequestMapping(value="/dyAdmin/operation/survey/insert.do")
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView surveyInsert(HttpServletRequest req
			,@ModelAttribute SmDTO SmDTO			
			,@RequestParam(value="action",required = false) String action
			) throws Exception{
		ModelAndView mv  = new ModelAndView("redirect:/dyAdmin/operation/survey/survey.do");
		
		if("Insert".equals(action)){
			Component.createData("survey.SM_insert", SmDTO);
		}else{			
			Component.updateData("survey.SM_update", SmDTO);
		}
		// 활동기록
		ActivityHistoryService.setDescSurveyAction("process", action, req);
		return mv;
	}
	
	
	/**
	 * 관리자 설문지 삭제하기
	 * @param  req
	 * @param  SmDTO
 	 * @return
	 * @throws Exception  
	 */
	@RequestMapping(value="/dyAdmin/operation/survey/sm/delete.do")
	@CheckActivityHistory(desc = "설문관리 삭제 작업", homeDiv = SettingData.HOMEDIV_ADMIN)
	public ModelAndView surveySmDelete(HttpServletRequest req
			,@ModelAttribute SmDTO SmDTO
			) throws Exception{
		ModelAndView mv  = new ModelAndView("redirect:/dyAdmin/operation/survey/survey.do");
		
		Component.updateData("survey.SM_delete", SmDTO);
		
		return mv;
	}
	
	/**
	 * 관리자 설문결과 상세 페이지
	 * @param req
	 * @param SmDTO
	 * @param SqDTO
	 * @param SrmDTO
	 * @return
	 * @throws Exception  
	 */
	@RequestMapping(value="/dyAdmin/operation/survey/result/detailView.do")
	@CheckActivityHistory(desc = "설문관리 결과 페이지 방문", homeDiv = SettingData.HOMEDIV_ADMIN)
	public ModelAndView surveyResultDetailView(HttpServletRequest req
			,@ModelAttribute SmDTO SmDTO
			,@ModelAttribute SqDTO SqDTO
			,@ModelAttribute SrmDTO SrmDTO
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/operation/survey/result/pra_survey_result_detailView.adm");
						
		// 기존 키값이 있으면 post로 가져온 값을 넣는다.
		Map<String, ?> inputFlashMap = RequestContextUtils.getInputFlashMap(req);
		if(null != inputFlashMap) {
			SmDTO.setSM_KEYNO((String) inputFlashMap.get("SM_KEYNO"));
		}
				
		// 설문지 정보 불러오기
		mv.addObject("SmDTO", Component.getData("survey.SM_selectBySmkey", SmDTO.getSM_KEYNO()));
		
		// 설문지 문항 목록 불러오기
		mv.addObject("sq_list", Component.getList("survey.SQ_getListBySmkey", SmDTO));
		
		// 주관식 설문 결과
		mv.addObject("srmList_an", Component.getList("surveyRe.SRD_selectResultBySmkey_an", SmDTO));

		// 객관식(내부 기타의견) 설문 결과
		mv.addObject("srmList_an2", Component.getList("surveyRe.SRD_selectResultBySmkey_an2", SmDTO));
		
		// 객관식 설문 보기,결과
		mv.addObject("srmList_op", Component.getList("surveyRe.SRD_selectResultBySmkey_op", SmDTO));
		
		mv.addObject("mirrorPage","/dyAdmin/operation/survey/survey.do");
		return mv;
	}
	
	
	/**
	 * 관리자 설문결과 상세 페이지 - 페이징 ajax
	 * @param req
	 * @param search
	 * @param SM_KEYNO
	 * @param SM_IDYN
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/operation/survey/result/detailView/pagingAjax.do")
	public ModelAndView surveyResultDetailViewPagingAjax(HttpServletRequest req
			,Common search
			,@RequestParam String SM_KEYNO
			,@RequestParam String SM_IDYN
			) throws Exception {
		
		ModelAndView mv = new ModelAndView("/dyAdmin/operation/survey/result/pra_survey_result_detailView_data");
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(Component.getSearchList(req) != null){
			map.put("searchList", Component.getSearchList(req));
		}
		map.put("SM_KEYNO", SM_KEYNO);
		map.put("SM_IDYN", SM_IDYN);
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"surveyRe.SRM_getListCnt",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		mv.addObject("resultList", Component.getList("surveyRe.SRM_getList", map));
		mv.addObject("search", search);
		mv.addObject("SM_IDYN", SM_IDYN);
		return mv;		
	}
	
	
	/**
	 * 관리자 설문결과 상세 페이지 - excel ajax
	 * @param req
	 * @param res
	 * @param search
	 * @param SM_KEYNO
	 * @param SM_IDYN
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/operation/survey/result/detailView/excelAjax.do")
	public ModelAndView surveyResultDetailViewExcelAjax(HttpServletRequest req
			,HttpServletResponse res
			,Common search
			,@RequestParam String SM_KEYNO
			,@RequestParam String SM_IDYN
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/operation/survey/result/pra_survey_result_detailView_excel");
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(Component.getSearchList(req) != null){
			map.put("searchList", Component.getSearchList(req));
		}
		map.put("SM_KEYNO", SM_KEYNO);
		map.put("SM_IDYN", SM_IDYN);
		
		mv.addObject("resultList", Component.getList("surveyRe.SRM_getList", map));
		mv.addObject("search", search);
		mv.addObject("SM_IDYN", SM_IDYN);
		
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
	 * 관리자 설문결과 엑셀 다운
	 * @param req
	 * @param SmDTO
	 * @param SqDTO
	 * @param SrmDTO
	 * @return
	 * @throws Exception  
	 */
	@RequestMapping(value="/dyAdmin/operation/survey/result/detailExcel.do")
	public ModelAndView surveyResultDetailExcel(HttpServletRequest req
			,@ModelAttribute SmDTO SmDTO
			,@ModelAttribute SqDTO SqDTO
			,@ModelAttribute SrmDTO SrmDTO
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/operation/survey/result/pra_survey_result_excel");
		
		// 설문지 정보 불러오기
		HashMap<String, Object> SmMap = Component.getData("survey.SM_selectBySmkey", SmDTO.getSM_KEYNO());
		mv.addObject("SmDTO", SmMap);
		
		// 설문지 문항 목록 불러오기
		mv.addObject("sq_list", Component.getList("survey.SQ_getListBySmkey", SmDTO));

		// 설문 리스트
		List<HashMap<String, Object>> srm_List = Component.getList("surveyRe.SRM_selectBySmkey", SmDTO);
				
		List<HashMap<String, Object>> srmList = new ArrayList<HashMap<String, Object>>();

		StringBuilder bulder = new StringBuilder();
		
		// 응답자 리스트
		if(srm_List != null && srm_List.size()>0){
			for(int i=0; i< srm_List.size();  i++){
                SrmDTO.setSRM_SM_KEYNO(String.valueOf(srm_List.get(i).get("SRM_SM_KEYNO")));
				SrmDTO.setSRM_KEYNO(String.valueOf(srm_List.get(i).get("SRM_KEYNO")));
				srmList = Component.getList("surveyRe.GET_RESULTDATA", SrmDTO);
				bulder.append("<tr class='dataTr'><td>"+(String)srm_List.get(i).get("SRM_IP")+"</td>"); 
				bulder.append("<td>"+srm_List.get(i).get("SRM_REGDT").toString().substring(0, 19)+"</td>"); 
				if(srmList != null && srmList.size()>0){
					for (int j = 0; j < srmList.size(); j++) {
						bulder.append("<td>"+(String)srmList.get(j).get("RESULTDATA")+"</td>"); 
					}
				}
				bulder.append("</tr>");
			}
		}
		bulder.toString();
		
		mv.addObject("title", SmMap.get("SM_TITLE"));
		mv.addObject("resultData", bulder.toString());
		return mv;
	}
		
	/**
	 * 설문답변 상세보기 모달창 오픈 
	 * @param req
	 * @param SrmDTO
	 * @return
	 * @throws Exception  
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value="/dyAdmin/operation/survey/result/dataAjax.do")
	@ResponseBody
	public List surveyResultDataAjax(HttpServletRequest req
			,@ModelAttribute SrmDTO SrmDTO
			) throws Exception{
		return Component.getList("surveyRe.SRD_getList", SrmDTO);
	}
	
	/**
	 * 설문답변 삭제하기 
	 * @param req
	 * @param SrmDTO
	 * @param SmDTO
	 * @return
	 * @throws Exception  
	 */
	@RequestMapping(value="/dyAdmin/operation/survey/deleteResultData.do")
	@CheckActivityHistory(desc = "설문답변 삭제 작업", homeDiv = SettingData.HOMEDIV_ADMIN)
	@ResponseBody
	public ModelAndView deleteSurveyResultData(HttpServletRequest req
			,@ModelAttribute SrmDTO SrmDTO
			,@ModelAttribute SmDTO SmDTO			
			,RedirectAttributes redirectAttributes
			) throws Exception{

		ModelAndView mv  = new ModelAndView("redirect:/dyAdmin/operation/survey/result/detailView.do");
		
		Component.updateData("survey.SM_paneUpdate", SmDTO.getSM_KEYNO());		
		Component.deleteData("surveyRe.SRM_delete", SrmDTO.getSRM_KEYNO());
		Component.deleteData("surveyRe.SRD_delete", SrmDTO.getSRM_KEYNO());			

		redirectAttributes.addFlashAttribute("SM_KEYNO", SmDTO.getSM_KEYNO());

		return mv;
	}	

	/**
	 * 설문 문항 리스트
	 * @param req
	 * @param SM_KEYNO
	 * @return
	 * @throws Exception  
	 */
	@RequestMapping(value = "/dyAdmin/operation/survey/questionListView.do")
	public ModelAndView surveyQuestionDetailView(HttpServletRequest req
			,@RequestParam(value="SM_KEYNO", defaultValue="") String SM_KEYNO
			) throws Exception{
		ModelAndView mv = new ModelAndView("/dyAdmin/operation/survey/question/pra_survey_question_insertView_list.adm");

		// 설문지 정보 불러오기		
		mv.addObject("SmDTO", Component.getData("survey.SM_selectBySmkey", SM_KEYNO));

		// 설문지 문항 목록 불러오기
		mv.addObject("sq", Component.getList("survey.SQ_getListBySmkey", SM_KEYNO));
		
		// 기존 키값이 있으면 post로 가져온 값을 넣는다.
		Map<String, ?> inputFlashMap = RequestContextUtils.getInputFlashMap(req);
		if(null != inputFlashMap) {
			SM_KEYNO = (String) inputFlashMap.get("SM_KEYNO");
		}
		
		mv.addObject("SM_KEYNO", SM_KEYNO);		
				
		mv.addObject("mirrorPage","/dyAdmin/operation/survey/survey.do");	
		return mv;
	}
	
	
	/**
	 * 설문 문항 등록/수정 리스트
	 * @param req
	 * @param SqDTO
	 * @param COUNT
	 * @return
	 * @throws Exception  
	 */
	@RequestMapping(value = "/dyAdmin/operation/survey/questionlListDetailView.do")
	public ModelAndView surveyQuestionDetailView(HttpServletRequest req
			,SqDTO SqDTO
			,@RequestParam(value="COUNT", defaultValue="") String COUNT			
			) throws Exception{
		ModelAndView mv = new ModelAndView("/dyAdmin/operation/survey/question/pra_survey_question_listView_detail");
						
		// 기존 키값이 있으면 post로 가져온 값을 넣는다.
		Map<String, ?> inputFlashMap = RequestContextUtils.getInputFlashMap(req);
		if(null != inputFlashMap) {
			String SM_KEYNO = (String) inputFlashMap.get("SM_KEYNO");
			String SQ_KEYNO = (String) inputFlashMap.get("SQ_KEYNO");
			
			SqDTO.setSQ_SM_KEYNO(SM_KEYNO);
			SqDTO.setSQ_KEYNO(SQ_KEYNO);
		}
		
		// 설문지 정보 불러오기		
		mv.addObject("SmDTO", Component.getData("survey.SM_selectBySmkey", SqDTO.getSQ_SM_KEYNO()));

		// 설문지 문항 목록 불러오기
		mv.addObject("sq", Component.getData("survey.SQ_getListBySqkey", SqDTO.getSQ_KEYNO()));		
		
		// 설문지 보기 목록 불러오기
		mv.addObject("SQO", Component.getList("survey.SQO_getListBySqkey", SqDTO.getSQ_SM_KEYNO()));
				
		// 설문 문항 수 설정
		mv.addObject("count", COUNT);
		if(StringUtils.isEmpty(SqDTO.getSQ_KEYNO())) { 
			mv.addObject("action", "insert");			
		} else {
			mv.addObject("action", "update");
		}
		return mv;
	}

	/**
	 * 관리자 설문관리 문항목록 페이지 - 페이징 ajax
	 * @param req
	 * @param search
	 * @param SQ_SM_KEYNO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/operation/survey/pagingQuestAjax.do")
	public ModelAndView surveyQuestionListViewPagingAjax(HttpServletRequest req
			,Common search
			,@RequestParam(value="SQ_SM_KEYNO") String SQ_SM_KEYNO
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/operation/survey/question/pra_survey_question_listView_data");

		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		map.put("SQ_SM_KEYNO", SQ_SM_KEYNO);
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"survey.SQ_getListCnt",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("SQ_SM_KEYNO", SQ_SM_KEYNO);		
		mv.addObject("paginationInfo", pageInfo);				
		mv.addObject("SQ", Component.getList("survey.SQ_getList", map));		
		mv.addObject("search", search);
		
		return mv;				
	}
	

	/**
	 * 관리자 설문 문항 목록 페이지 - excel ajax
	 * @param req
	 * @param res
	 * @param search
	 * @param SQ_SM_KEYNO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/operation/survey/QuestExcelAjax.do")
	public ModelAndView surveyListViewQuestionExcelAjax(HttpServletRequest req
			,HttpServletResponse res
			,Common search
			,@RequestParam(value="SQ_SM_KEYNO") String SQ_SM_KEYNO
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/operation/survey/question/pra_survey_question_listView_excel");
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(Component.getSearchList(req) != null){
			map.put("searchList", Component.getSearchList(req));
		}

		map.put("SQ_SM_KEYNO", SQ_SM_KEYNO);	
		mv.addObject("SQ", Component.getList("survey.SQ_getList", map));
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
	 * 관리자 문항관리 등록/수정
	 * @param req
	 * @param SqDTO
	 * @param SM_CNT_TYPE
	 * @param SQ_OPTION_DATA
	 * @param action
	 * @param redirectAttributes
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/operation/survey/questionUpdateAjax.do")
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView surveyQuestionUpdate(HttpServletRequest req
		,SqDTO SqDTO
		,@RequestParam(value="SM_CNT_TYPE",required = false) String SM_CNT_TYPE
		,@RequestParam(value="SQ_OPTION_DATA",required = false) String SQ_OPTION_DATA
		,@RequestParam(value="action",required = false) String action
		,RedirectAttributes redirectAttributes
			) throws Exception{
		
		ModelAndView mv = new ModelAndView("redirect:/dyAdmin/operation/survey/questionlListDetailView.do");
		
		// 보기배점방식만 변경
		SmDTO SmDTO = new SmDTO();
		SmDTO.setSM_KEYNO(SqDTO.getSQ_SM_KEYNO());
		SmDTO.setSM_CNT_TYPE(SM_CNT_TYPE);
				
		if("update".equals(action)) {
			Component.updateData("survey.SM_cnt_update", SmDTO);
			Component.updateData("survey.SQ_update", SqDTO);
			Component.deleteData("survey.SQO_delete", SqDTO.getSQ_KEYNO());
		} else if("insert".equals(action)) {
			Component.createData("survey.SQ_insert", SqDTO);
		}			

		// 설문 옵션 등록
		// T : 주관식, H : 객관식(라디오), S : 객관식(체크박스)
		if(!"T".equals(SqDTO.getSQ_ST_TYPE())){ 
			String data[] = SQ_OPTION_DATA.split("/");
			for(int j = 0; j<data.length; j++){
				String option[] = data[j].split("_");
				SqDTO.setSQO_SQ_KEYNO(SqDTO.getSQ_KEYNO());
				SqDTO.setSQO_NUM(option[0]);
				SqDTO.setSQO_OPTION(option[1]);
				if("S".equals(SM_CNT_TYPE)){ 
					SqDTO.setSQO_VALUE(option[2]);
				}else if("H".equals(SM_CNT_TYPE)){ 
					SqDTO.setSQO_VALUE("1");
				} 
				SqDTO.setSQO_ORDER_TYPE(option[3]);
				Component.createData("survey.SQO_insert", SqDTO);
			} 
		}

		redirectAttributes.addFlashAttribute("SM_KEYNO",SqDTO.getSQ_SM_KEYNO());
		redirectAttributes.addFlashAttribute("SQ_KEYNO",SqDTO.getSQ_KEYNO());
		
		// 활동기록
		ActivityHistoryService.setDescSurveyAction("process", action, req);	
		return mv;
	}
	
	
	/**
	 * 관리자 문항관리 - 삭제
	 * 
	 * @param model
	 * @param SqDTO
	 * @param req
	 * @param redirectAttributes
	 * @return
	 * @throws Exception
	 * 
	 */   					 
	@RequestMapping(value = "/dyAdmin/operation/survey/quest_delete.do")
	@CheckActivityHistory(desc = "문항관리 삭제 작업", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView programPlaceListDelete(Model model
		,SqDTO SqDTO
		,HttpServletRequest req
		,RedirectAttributes redirectAttributes
			) throws Exception{ 	
		
		ModelAndView mv = new ModelAndView("redirect:/dyAdmin/operation/survey/questionListView.do");

		Component.deleteData("survey.SQ_quest_delete", SqDTO.getSQ_KEYNO()); 						
		redirectAttributes.addFlashAttribute("SM_KEYNO",SqDTO.getSQ_SM_KEYNO());

		return mv;	
	}

	/**
	 * 문항 번호 중복검사
	 * 
	 * @param SqDTO
	 * @return
	 * @throws Exception
	 * 
	 */   	
	@RequestMapping(value = "/dyAdmin/operation/survey/RedundancyNumAjax.do")
	@ResponseBody
	public Integer sqNumRedundancyAjax(
			SqDTO SqDTO
			) throws Exception{			
		return Component.getCount("survey.SQ_getSQnumList", SqDTO);
	}	
}
