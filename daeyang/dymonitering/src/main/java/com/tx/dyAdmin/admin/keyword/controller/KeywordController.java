package com.tx.dyAdmin.admin.keyword.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
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
import com.tx.dyAdmin.admin.keyword.dto.KeywordDTO;
import com.tx.dyAdmin.admin.keyword.service.KeywordService;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;


/**
 * 
 * @FileName: SearchController.java
 * @Project : 검색 키워드
 * @Date    : 2017. 05. 10. 
 * @Author  : 이재령	
 * @Version : 1.0
 */
@Controller
public class KeywordController {
	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 검색 키워드 */
	@Autowired private KeywordService KeywordService;
	
	/** 페이지 처리 출 */
	@Autowired private PageAccess PageAccess;
	
	/**
	 * 키워드 리스트 
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value="/{tiles}/keyword/listAjax.do")
	@ResponseBody
	public List keywordListAjax(
			@RequestParam(value="KeywordSize",defaultValue="0") int KeywordSize
			,@RequestParam(value="minCount",defaultValue="0") int minCount
			) throws Exception {
				
		

		return KeywordService.getKeywordList(KeywordSize,minCount);
	}
	
	/**
	 * 키워드관리
	 * @param KeywordDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/admin/keyword.do")
	@CheckActivityHistory(desc="키워드 관리 페이지 방문")
	public ModelAndView adminFuncKeyword(KeywordDTO KeywordDTO) throws Exception {
				
		ModelAndView mv = new ModelAndView("/dyAdmin/admin/keyword/pra_keyword_listView.adm");
		
		return mv;
	}
	
	/**
	 * 키워드관리 - 페이징 ajax
	 * @param req
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/admin/keyword/pagingAjax.do")
	public ModelAndView adminFuncKeywordPagingAjax(HttpServletRequest req,
			Common search
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/admin/keyword/pra_keyword_listView_data");

		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"keyword.SK_getDataListCnt",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		mv.addObject("resultList", Component.getList("keyword.SK_getDataList", map));
		mv.addObject("search", search);
		return mv;
		
		
	}
	
	
	/**
	 * 키워드관리 - excel ajax
	 * @param req
	 * @param res
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/admin/keyword/excelAjax.do")
	public ModelAndView adminFuncKeywordExcelAjax(HttpServletRequest req
			, HttpServletResponse res
			, Common search
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/admin/keyword/pra_keyword_listView_excel");
		
		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		mv.addObject("resultList", Component.getList("keyword.SK_getDataList", map));
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
	 * 키워드 조작
	 * @param KeywordDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/admin/keyword/update.do")
	@CheckActivityHistory(desc="키워드 조작 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	public ModelAndView adminFuncKeywordUpdate(
			HttpServletRequest req
			,@RequestParam(value="SK_KEYWORD") String KEYWORD
			,@RequestParam(value="SK_COUNT") int COUNT) throws Exception {
				
		ModelAndView mv = new ModelAndView("redirect:/dyAdmin/admin/keyword.do");
		
		KeywordService.updateKeyword(KEYWORD, req, COUNT);
		
		return mv;
	}
	
	/**
	 * 상세목록
	 * @param KeywordDTO
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value="/dyAdmin/admin/keyword/detailListAjax.do")
	@ResponseBody
	public List adminKeywordDetailListAjax(KeywordDTO KeywordDTO) throws Exception {
				
		return KeywordService.getDetailList(KeywordDTO);
	}
	
	/**
	 * 삭제
	 * @param KeywordDTO
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/admin/keyword/deleteAjax.do")
	@CheckActivityHistory(desc="검색 회원 삭제 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@ResponseBody
	public void adminKeywordDeleteAjax(KeywordDTO KeywordDTO) throws Exception {
		KeywordService.deleteData(KeywordDTO);		
		
	}
	
	/**
	 * 삭제 - 키워드
	 * @param KeywordDTO
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/admin/keyword/deleteKeywordAjax.do")
	@CheckActivityHistory(desc="키워드 삭제 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@ResponseBody
	public void adminKeywordDeleteKeywordAjax(KeywordDTO KeywordDTO) throws Exception {
		
		System.out.println("keyword :: " + KeywordDTO.getSK_KEYWORD());
		
		KeywordService.deleteDataWithKeyword(KeywordDTO);	
		
	}
}
