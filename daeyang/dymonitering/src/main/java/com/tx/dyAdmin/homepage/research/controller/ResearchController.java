package com.tx.dyAdmin.homepage.research.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
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
import com.tx.dyAdmin.homepage.research.dto.ResearchSkinDTO;
import com.tx.dyAdmin.operation.satisfaction.dto.SatisfactionDTO;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;


/**
 * 
 * @FileName: ResearchController.java
 * @Project : Research
 * @Date    : 2018. 05. 14. 
 * @Author  : 이혜주	
 * @Version : 1.0
 */
@Controller
public class ResearchController {
	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 페이지 처리 출 */
	@Autowired private PageAccess PageAccess;
	
	@Autowired private CommonPublishService CommonPublishService;
	
	
	/**
	 * 페이지 평가 관리
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/research/pageResearch.do")
	@CheckActivityHistory(desc="페이지 평가 페이지 방문")
	public ModelAndView pageResearch(HttpServletRequest req) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/research/pra_research_listView.adm");
		
		mv.addObject("MN_HOMEDIV_C", CommonService.getDefaultSiteKey(req));
		mv.addObject("homeDivList", CommonService.getHomeDivCode(false));
		
		return mv;
	}
	
	/**
	 * 페이지 평가 관리 - 페이징 ajax
	 * @param req
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/operation/pageResearch/pagingAjax.do")
	public ModelAndView pageResearchPagingAjax(HttpServletRequest req,
			Common search
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/research/pra_research_listView_data");

		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		//권한별 메뉴 조회
		Map<String,Object> user = CommonService.getUserInfo(req);
		String userKeyno = ((String) user.get("UI_KEYNO"));
		String UIA_KEYNO = Component.getData("Authority.UIA_getDataByUIKEYNO", userKeyno);
		map.put("UIA_KEYNO", UIA_KEYNO);
		map.put("HOMEDIV_C", req.getParameter("MN_HOMEDIV_C"));
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"Satisfaction.TPS_getListCnt",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		mv.addObject("resultList", Component.getList("Satisfaction.TPS_getList", map));
		mv.addObject("search", search);
		mv.addObject("homeDivList", CommonService.getHomeDivCode(true));
		
		return mv;
		
		
	}
	
	
	/**
	 * 페이지 평가 관리 - excel ajax
	 * @param req
	 * @param res
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/operation/pageResearch/excelAjax.do")
	public ModelAndView pageResearchExcelAjax(HttpServletRequest req
			, HttpServletResponse res
			, Common search
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/research/pra_research_listView_excel");
		
		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		//권한별 메뉴 조회
		Map<String,Object> user = CommonService.getUserInfo(req);
		String userKeyno = ((String) user.get("UI_KEYNO"));
		String UIA_KEYNO = Component.getData("Authority.UIA_getDataByUIKEYNO", userKeyno);
		map.put("UIA_KEYNO", UIA_KEYNO);
		
		map.put("HOMEDIV_C", req.getParameter("MN_HOMEDIV_C"));
		
		mv.addObject("resultList", Component.getList("Satisfaction.TPS_getList", map));
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
	
	
	@ResponseBody
	@RequestMapping(value="/dyAdmin/operation/pageDetail.do")
	public Map<String, Object> pageDetail(
								  SatisfactionDTO SatisfactionDTO
								, @RequestParam(value="key", required=true) String key
								) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		SatisfactionDTO.setTPS_MN_KEYNO(CommonService.getKeyno(key, "MN"));
		map.put("resultList", Component.getList("Satisfaction.TPS_PageDataList", SatisfactionDTO));
		map.put("MenuName", Component.getList("Satisfaction.TPS_MenuName", SatisfactionDTO));
		return map;
	}
	
	
	/**
	 * 페이지 평가 관리 - 메뉴별 코멘트
	 * @param SatisfactionDTO
	 * @param key
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/research/pageComment.do")
	@CheckActivityHistory(desc="코멘트 페이지")
	public ModelAndView pageComment(HttpServletRequest req) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/research/pra_comment_detail.adm");
		
		mv.addObject("MN_HOMEDIV_C", CommonService.getDefaultSiteKey(req));
		mv.addObject("homeDivList", CommonService.getHomeDivCode(false));
		return mv;
	}
	

	/**
	 * 페이지 평가 관리 - 메뉴별 코멘트 - 페이징 ajax
	 * @param req
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/operation/pageResearch/commentDetail/pagingAjax.do")
	public ModelAndView commentDetailPagingAjax(HttpServletRequest req,
			Common search
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/research/pra_comment_detail_data");

		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		//권한별 메뉴 조회
		Map<String,Object> user = CommonService.getUserInfo(req);
		String userKeyno = ((String) user.get("UI_KEYNO"));
		String UIA_KEYNO = Component.getData("Authority.UIA_getDataByUIKEYNO", userKeyno);
		map.put("UIA_KEYNO", UIA_KEYNO);

		map.put("HOMEDIV_C", req.getParameter("MN_HOMEDIV_C"));
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"Satisfaction.TPS_getCommentDetailListCnt",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		mv.addObject("resultList", Component.getList("Satisfaction.TPS_getCommentDetailList", map));
		mv.addObject("search", search);
		return mv;
		
		
	}
	
	/**
	 * 페이지 평가 관리 - 메뉴별 코멘트 - excel ajax
	 * @param req
	 * @param res
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/operation/pageResearch/commentDetail/excelAjax.do")
	public ModelAndView commentDetailExcelAjax(HttpServletRequest req
			, HttpServletResponse res
			, Common search
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/research/pra_comment_detail_excel");
		
		
		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		//권한별 메뉴 조회
		Map<String,Object> user = CommonService.getUserInfo(req);
		String userKeyno = ((String) user.get("UI_KEYNO"));
		String UIA_KEYNO = Component.getData("Authority.UIA_getDataByUIKEYNO", userKeyno);
		map.put("UIA_KEYNO", UIA_KEYNO);
		map.put("HOMEDIV_C", req.getParameter("MN_HOMEDIV_C"));
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"Satisfaction.TPS_getCommentDetailListCnt",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		
		mv.addObject("resultList", Component.getList("Satisfaction.TPS_getCommentDetailList", map));
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
	 * 페이지평가 스킨관리
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/research/researchSkin.do")
	@CheckActivityHistory(desc="페이지평가 스킨관리 페이지 방문")
	public ModelAndView ResearchSkinView(HttpServletRequest req
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/research/skin/pra_research_skin_listView.adm");
		return mv;
	}
	
	/**
	 * 페이지평가 관리 - 페이징 ajax
	 * @param req
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/research/pagingAjax.do")
	public ModelAndView ResearchSkinViewPagingAjax(HttpServletRequest req,
			Common search
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/research/skin/pra_research_skin_listView_data");

		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"Satisfaction.PRS_getListCnt",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		mv.addObject("resultList", Component.getList("Satisfaction.PRS_getList", map));
		mv.addObject("homeDivList", CommonService.getHomeDivCode(true));
		mv.addObject("search", search);
		return mv;
	}
	
	@RequestMapping(value="/dyAdmin/homepage/research/updateView.do")
	@CheckActivityHistory(desc="페이지평가 스킨 수정/상세 페이지 방문")
	public ModelAndView ResearchSkinUpdateView(HttpServletRequest req
			, ResearchSkinDTO ResearchSkinDTO) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/research/skin/pra_research_skin_insertView.adm");
		
		mv.addObject("homeDivList", CommonService.getHomeDivCode(true));
		//데이터 가져오기
		HashMap<String, Object> map = Component.getData("Satisfaction.PRS_getData", ResearchSkinDTO);
		mv.addObject("PRS_DATA", map);
		
		map = Component.getData("Satisfaction.PRS_getSkinUsingHP", ResearchSkinDTO);
		mv.addObject("PRS_HP", map);
		
		mv.addObject("formDataList", Component.getListNoParam("Satisfaction.PRS_getFormList"));
		mv.addObject("mirrorPage","/dyAdmin/homepage/research/researchSkin.do");
		mv.addObject("type","update");
		return mv;
	}
	
	@RequestMapping(value="/dyAdmin/homepage/research/insertView.do")
	@CheckActivityHistory(desc="페이지평가 스킨 등록 페이지 방문")
	public ModelAndView ResearchSkinInsertView(HttpServletRequest req
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/research/skin/pra_research_skin_insertView.adm");
		
		mv.addObject("homeDivList", CommonService.getHomeDivCode(true));
		mv.addObject("formDataList", Component.getListNoParam("Satisfaction.PRS_getFormList"));
		mv.addObject("type","insert");
		mv.addObject("mirrorPage","/dyAdmin/homepage/research/researchSkin.do");
		return mv;
	}
	
	@RequestMapping(value = "/dyAdmin/homepage/research/insert.do")
	@CheckActivityHistory(desc="페이지평가 스킨 등록 처리", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView ResearchSkinInsert(ResearchSkinDTO ResearchSkinDTO,  HttpServletRequest req)
			throws Exception {
		ModelAndView mv = new ModelAndView("redirect:/dyAdmin/homepage/research/researchSkin.do");
		
		ResearchSkinDTO.setPRS_KEYNO(CommonService.getTableKey("PRS"));
		Component.createData("Satisfaction.PRS_insert", ResearchSkinDTO);
		
		CommonPublishService.researchSkin(ResearchSkinDTO);
		
		setHistory(ResearchSkinDTO, req);
		
		return mv;
	}
	
	@RequestMapping(value = "/dyAdmin/homepage/research/update.do")
	@CheckActivityHistory(desc="페이지평가 스킨 수정 처리", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView ResearchSkinUpdate(ResearchSkinDTO ResearchSkinDTO,  HttpServletRequest req)
			throws Exception {
		ModelAndView mv = new ModelAndView("redirect:/dyAdmin/homepage/research/researchSkin.do");
		
		ResearchSkinDTO = setHistory(ResearchSkinDTO, req);
	
		Component.updateData("Satisfaction.PRS_update", ResearchSkinDTO);
		
		CommonPublishService.researchSkin(ResearchSkinDTO);

		return mv;
	}
	
	public ResearchSkinDTO setHistory(ResearchSkinDTO ResearchSkinDTO, HttpServletRequest req){
		/* 히스토리 저장 시작 */
		String REGDT = Component.getData("Satisfaction.get_historyDate", ResearchSkinDTO);
		Map<String, Object> user = CommonService.getUserInfo(req);
		String regName = ((String) user.get("UI_ID"));
		
		double VersionNum = Component.getData("Satisfaction.get_historyVersion", ResearchSkinDTO);
		VersionNum += 0.01;
		ResearchSkinDTO.setPRSH_KEYNO(CommonService.getTableKey("PRSH"));
		ResearchSkinDTO.setPRSH_PRS_KEYNO(ResearchSkinDTO.getPRS_KEYNO());
		ResearchSkinDTO.setPRSH_STDT(REGDT);
		ResearchSkinDTO.setPRSH_MODNM(regName);
		ResearchSkinDTO.setPRS_MODNM(regName);
		ResearchSkinDTO.setPRSH_DATA(ResearchSkinDTO.getPRS_FORM());
		ResearchSkinDTO.setPRSH_VERSION(VersionNum);

		String message = ResearchSkinDTO.getPRSH_COMMENT();
		if(StringUtils.isEmpty(ResearchSkinDTO.getPRSH_COMMENT())) {
			message = "no message";
		}
		ResearchSkinDTO.setPRSH_COMMENT(message);
		Component.createData("Satisfaction.PRSH_insert", ResearchSkinDTO);
		/* 히스토리 저장 끝 */
		return ResearchSkinDTO;

	}
	
	@RequestMapping(value = "/dyAdmin/homepage/research/delete.do")
	@CheckActivityHistory(desc="페이지평가 스킨 삭제 처리", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView ResearchSkinDelete(ResearchSkinDTO ResearchSkinDTO,  HttpServletRequest req)
			throws Exception {
		ModelAndView mv = new ModelAndView("redirect:/dyAdmin/homepage/research/researchSkin.do");
		
		Component.updateData("Satisfaction.PRS_delete", ResearchSkinDTO);

		return mv;
	}
	
	@RequestMapping(value = "/dyAdmin/homepage/research/publishAjax.do")
	@ResponseBody
	@CheckActivityHistory(desc="페이지평가 스킨 파일 배포 처리", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public boolean publishFile(ResearchSkinDTO ResearchSkinDTO, HttpServletRequest req)
			throws Exception {
		
		
		return CommonPublishService.researchSkin(ResearchSkinDTO);
		
	}
	
	/**
	 * 페이지평가 스킨 관리 - 데이터 Ajax
	 * 
	 * @param ResearchSkinDTO
	 * @return
	 * @throws Exception
	 * 
	 */
	@RequestMapping(value = "/dyAdmin/homepage/research/skindataAjax.do")
	@ResponseBody
	public HashMap<String, Object> researchSkinDataAjax(ResearchSkinDTO ResearchSkinDTO) throws Exception {
		HashMap<String, Object> map = new HashMap<>();

		// 오라클 data 충돌 오류 방지용
		String PRS_KEYNO = ResearchSkinDTO.getPRS_KEYNO();

		// 데이터 정보 불러오기
		map.put("SkinData", Component.getData("Satisfaction.PRS_getData", ResearchSkinDTO));
		map.put("SkinDataHistory", Component.getList("Satisfaction.PRSH_getList", PRS_KEYNO));

		return map;
	}
	
	/**
	 * 스킨 관리 - 스킨 복원처리
	 * 
	 * @param req
	 * @param ResearchSkinDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/research/returnPageAjax.do")
	@ResponseBody
	public String researchSkinReturnPageAjax(HttpServletRequest req
			,ResearchSkinDTO ResearchSkinDTO
			) throws Exception {
		ResearchSkinDTO = Component.getData("Satisfaction.PRSH_getData", ResearchSkinDTO);		
		return ResearchSkinDTO.getPRSH_DATA();
	}
	
	/**
	 * 스킨 관리 - 최신데이터와 비교, 변경사항
	 * 
	 * @param req
	 * @param ResearchSkinDTO
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/dyAdmin/homepage/research/compareAjax.do")
	@ResponseBody
	public List researchSkinCompareAjax(HttpServletRequest req
			,ResearchSkinDTO ResearchSkinDTO
			) throws Exception {
		return Component.getList("Satisfaction.PRSH_compareData", ResearchSkinDTO);
	}	

	/**
	 * 스킨 사용 여부 판단
	 * 
	 * @param PRS_KEYNO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/research/useSkinAjax.do")
	@ResponseBody
	public Integer researchUseSkinAjax(@RequestParam(value = "PRS_KEYNO", required = false) String PRS_KEYNO
			) throws Exception {		
		return Component.getCount("Satisfaction.PRS_getSkinUsing", PRS_KEYNO);
	}
	
}
