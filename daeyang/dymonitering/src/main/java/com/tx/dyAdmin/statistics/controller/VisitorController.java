package com.tx.dyAdmin.statistics.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.dto.Common;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.page.PageAccess;
import com.tx.dyAdmin.statistics.dto.LogDTO;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class VisitorController {

	/** 공통 컴포넌트 */
	@Autowired
	ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 페이지 처리 출 */
	@Autowired private PageAccess PageAccess;
	
	/**
	 * 방문자 카운터
	 * 
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/statistics/visitor.do")
	@CheckActivityHistory(desc="방문자 카운터 페이지 방문")
	public ModelAndView serch(HttpServletRequest req
			,@RequestParam(value="searchbot" , defaultValue="N") String searchbot
			,@RequestParam(value="MN_KEYNO" , required=false) String MN_KEYNO
			) throws Exception {
		ModelAndView mv = new ModelAndView("/dyAdmin/statistics/visitor/pra_visitor_listView.adm");
	
		String homeKey = null;
		if(StringUtils.isNotBlank(MN_KEYNO)){
			homeKey = MN_KEYNO;
		}else{
			String siteKey = (String)req.getSession().getAttribute("SITE_KEYNO");
			if(StringUtils.isNotBlank(siteKey)){
				homeKey = siteKey;
			}else{
				homeKey = SiteProperties.getString("HOMEPAGE_REP");
			}
		}
		
		mv.addObject("MN_HOMEDIV_C", homeKey);
		// 홈페이지 구분 리스트
		mv.addObject("homeDivList", CommonService.getHomeDivCode(true));
		mv.addObject("searchbot", searchbot);
		return mv;
	}
	
	
	/**
	 * 방문자 카운터 - 페이징 ajax
	 * @param req
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/statistics/visitor/pagingAjax.do")
	public ModelAndView boardTypeViewPagingAjax(HttpServletRequest req,
			Common search
			, @RequestParam(value="AH_HOMEDIV_C", required=false) String AH_HOMEDIV_C
			, @RequestParam(value="AH_DEVICE", required=false) String AH_DEVICE
			, @RequestParam(value="searchbot", required=false) String searchbot
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/statistics/visitor/pra_visitor_listView_data");

		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		map.put("AH_HOMEDIV_C", AH_HOMEDIV_C);
		map.put("AH_DEVICE", AH_DEVICE);
		map.put("searchbot", searchbot);
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"Log.AH_getVisitListCnt",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		mv.addObject("resultList", Component.getList("Log.AH_getVisitList", map));
		mv.addObject("search", search);
		return mv;
		
		
	}
	
	
	


	/**
	 * 방문자 카운터 - excel ajax
	 * @param req
	 * @param res
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/statistics/visitor/excelAjax.do")
	public ModelAndView boardTypeViewExcelAjax(HttpServletRequest req
			, HttpServletResponse res
			, Common search
			, @RequestParam(value="AH_HOMEDIV_C", required=false) String AH_HOMEDIV_C
			, @RequestParam(value="AH_DEVICE", required=false) String AH_DEVICE
			, @RequestParam(value="searchbot", required=false) String searchbot
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/statistics/visitor/pra_visitor_listView_excel");
		
		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		map.put("AH_HOMEDIV_C", AH_HOMEDIV_C);
		map.put("AH_DEVICE", AH_DEVICE);
		map.put("searchbot", searchbot);
		
		mv.addObject("resultList", Component.getList("Log.AH_getVisitList", map));
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
	 *  방문자 카운터 - data ajax
	 * @param req
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/dyAdmin/statistics/visitor/dataAjax.do")
	public ModelAndView ajaxvisitordomain(
			HttpServletRequest req
			, HttpServletResponse res
			, LogDTO search
			, @RequestParam(value="excel", required=false) String excel
			) throws Exception {
		
		ModelAndView mv = new ModelAndView("/dyAdmin/statistics/visitor/pra_visitor_listView_ajax");
		
		List<HashMap<String,Object>> list = getVisitorData(search);
		
		int total =0;
		if(list !=null && list.size()>0){
			
			for(int i=0; i<list.size(); i++){
				
//				total += (long)list.get(i).get("COUNT");
				String str = String.valueOf(list.get(i).get("COUNT"));
				total += (long)Integer.parseInt(str);
//				total += (long)list.get(i).get("COUNT");
			}
			for(int i=0; i<list.size(); i++){ //평균
				list.get(i).put("no", i+1);
//				long COUNT = (long)list.get(i).get("COUNT");
				String str = String.valueOf(list.get(i).get("COUNT"));
				long COUNT = (long)Integer.parseInt(str);
				if(total > 0) {
				float a = COUNT / (float)total * 100;
				a *= 100;
				int ii =   (int) a;
				a = (float) (ii* 0.01);
				list.get(i).put("persent", a);
				}
			}
		}
		
		mv.addObject("visitorCase",search.getCASE());
		mv.addObject("total", total);
		mv.addObject("html", list);
		mv.addObject("search", search);
		
		if(excel != null){
			mv.setViewName("/dyAdmin/statistics/visitor/pra_visitor_listView_excel2");
			try {
	            
				Cookie cookie = new Cookie("fileDownload", "true");
		        cookie.setPath("/");
		        res.addCookie(cookie);
	            
	        } catch (Exception e) {
	            System.out.println("쿠키 에러 :: "+e.getMessage());
	        }
		}
		
		return mv;
	}
	
	private List<HashMap<String,Object>> getVisitorData(LogDTO search) throws Exception {
		List<HashMap<String,Object>> list = null;
		String visitorCase = search.getCASE();
		switch (visitorCase) {
		case "도메인":
			 list =  Component.getList("Log.AH_getVisitDomain", search);
			
			break;
		case "브라우저":
			 list =  Component.getList("Log.AH_getVisitBrower", search);
			
			break;
		case "운영체제":
			 list =  Component.getList("Log.AH_getVisitOs", search);
			
			break;
		case "시간":
			
			list =  Component.getList("Log.AH_getVisitTime", search);
			break;
		case "요일":
			list =  Component.getList("Log.AH_getVisitWeekOfDay", search);
			
			break;
		case "일":
			
			list =  Component.getList("Log.AH_getVisitDay", search);
			break;
		case "월":
			
			list =  Component.getList("Log.AH_getVisitMonth", search);
			break;
		case "년":
			
			list =  Component.getList("Log.AH_getVisitYear", search);
			break;

		}
		return list;
	}

	/**
	 * 메뉴카운트 페이지
	 * 
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/statistics/menucount.do")
	@CheckActivityHistory(desc="메뉴카운터 페이지 방문")
	public ModelAndView serchV(HttpServletRequest req
			, @RequestParam(value="searchbot" , defaultValue="N") String searchbot
			, @RequestParam(value="MN_KEYNO" , required=false) String MN_KEYNO
			) throws Exception {
		ModelAndView mv = new ModelAndView("/dyAdmin/statistics/visitor/pra_visitor_page_count.adm");
		
		String homeKey = null;
		if(StringUtils.isNotBlank(MN_KEYNO)){
			homeKey = MN_KEYNO;
		}else{
			String siteKey = (String)req.getSession().getAttribute("SITE_KEYNO");
			if(StringUtils.isNotBlank(siteKey)){
				homeKey = siteKey;
			}else{
				homeKey = SiteProperties.getString("HOMEPAGE_REP");
			}
		}
		
		mv.addObject("MN_HOMEDIV_C", homeKey);
		
		// 홈페이지 구분 리스트
		mv.addObject("homeDivList", CommonService.getHomeDivCode(true));
		
		mv.addObject("searchbot", searchbot);

		return mv;
	}
	
	/**
	 * 메뉴카운트 페이지 - data Ajax
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("/dyAdmin/statistics/menucount/pagingAjax.do")
	public Object ajaxsearchV(
			HttpServletRequest req
			, LogDTO log
			) throws Exception {
		
		if (StringUtils.isEmpty(log.getHOME_DIV())) {// 처음 들어갈때 값없을경우
			log.setHOME_DIV("0");
		}
		
		List<LogDTO> list = Component.getList("Log.AH_selectPageCount", log);
		
		int total = 0;
		if(list !=null && list.size()>0){
			
			for(int i=0; i<list.size(); i++){
				total += list.get(i).getSelectCount();
			}
			
			for(int i=0; i<list.size(); i++){ //평균
				list.get(i).setNo(i+1);
				if(total > 0) {
				float a = list.get(i).getSelectCount() / (float)total * 100;
				a *= 100;
				int ii =   (int) a;
				a = (float) (ii* 0.01);
				list.get(i).setPersent(a);
				}
			}
		}
		
		StringBuilder bulder = new StringBuilder();
		
		log = null;
		int totalCnt = 0;
		float totalPercent = 0;
		 if(list !=null && list.size()>0){
			 for(int i=0; i< list.size();  i++){
				 log = list.get(i);
				 bulder.append("<tr><td>")
				 		.append(log.getNo())
				 		.append("</td><td>")
				 		.append(log.getMN_HOMEDIV_NAME())
				 		.append("</td>")
				 		.append("<td>" + log.getMN_NAME()) 
				 		.append("</td><td><div class='visitor_bar chart'><span class='bar' data-number='")
				 		.append(log.getPersent())
				 		.append("'></span></div>")
				 		.append("</td><td>")
				 		.append(log.getSelectCount())
				 		.append("</td><td>")
				 		.append(log.getPersent())
				 		.append("</td></tr>");
				 totalCnt += log.getSelectCount();
				 totalPercent += log.getPersent();
			 } 
		 }
		 bulder.append("<tr class='footTr'><td colspan='4' class='footTd'>")
			.append("총합</td><td>")
		 	.append(totalCnt)
	 		.append("<td>")
	 		.append(Math.round(totalPercent*100)/100.0)
	 		.append("</td></tr>");
		
		return bulder.toString();
	}
	
	@RequestMapping(value = "/dyAdmin/statistics/menucount/excelAjax.do")
	public ModelAndView serchVExcelAjax(
			HttpServletRequest req
			, LogDTO log
			) throws Exception {
		ModelAndView mv = new ModelAndView("/dyAdmin/statistics/visitor/pra_visitor_page_count_excel");
		
		if (StringUtils.isEmpty(log.getHOME_DIV())) {// 처음 들어갈때 값없을경우
			log.setHOME_DIV("0");
		}
		
		List<LogDTO> list = Component.getList("Log.AH_selectPageCount", log);
		
		int total = 0;
		if(list !=null && list.size()>0){
			
			for(int i=0; i<list.size(); i++){
				total += list.get(i).getSelectCount();
			}
			
			for(int i=0; i<list.size(); i++){ //평균
				list.get(i).setNo(i+1);
				if(total > 0) {
				float a = list.get(i).getSelectCount() / (float)total * 100;
				a *= 100;
				int ii =   (int) a;
				a = (float) (ii* 0.01);
				list.get(i).setPersent(a);
				}
			}
		}
		
		 mv.addObject("resultList",list);
		 mv.addObject("log",log);
		

		return mv;
	}
		
}
