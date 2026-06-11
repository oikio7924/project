package com.tx.test.controller;

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

import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.dto.Common;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.page.PageAccess;
import com.tx.dyAdmin.statistics.dto.LogDTO;
import com.tx.test.dto.billDTO;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * 
 * @Version : 1.0
 */
@Controller
public class BillsLogController {

	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 페이지 처리 출 */
	@Autowired private PageAccess PageAccess;
	
	
	/**
	 * 활동 기록
	 * @param req
	 * @return
	 * @throws Exception
	 */
	 @RequestMapping("/dyAdmin/bills/logstatus.do")
	   public ModelAndView BillLog(HttpServletRequest req
			  , LogDTO search
			  , Common search2
			  , @RequestParam(value="id",required=false) String id
			  , @RequestParam(value="AH_HOMEDIV_C",required=false) String AH_HOMEDIV_C) throws Exception {
		   ModelAndView mv = new ModelAndView("/dyAdmin/bill/pra_bills_log.adm");
		    
		  
		   
		   String homeKey = null;
			if(StringUtils.isNotBlank(AH_HOMEDIV_C)){
				homeKey = AH_HOMEDIV_C;
			}else{
				String siteKey = (String)req.getSession().getAttribute("SITE_KEYNO");
				if(StringUtils.isNotBlank(siteKey)){
					homeKey = siteKey;
				}else{
					homeKey = SiteProperties.getString("HOMEPAGE_REP");
				}
			}
			
			
			
			mv.addObject("AH_HOMEDIV_C", homeKey);
			// 홈페이지 구분 리스트
			mv.addObject("homeDivList", CommonService.getHomeDivCode(true));
			
			if(id != null){
				search.setUI_ID(id);
			} 
			
			mv.addObject("search", search);
			
	      return mv;
	  }
	
	
	/**
	 * 활동 기록 - 페이징 ajax
	 * @param req
	 * @param search
	 * @return
	 * @throws Exception
	 */
	 @RequestMapping(value="/dyAdmin/bills/pagingAjax4.do")
		public ModelAndView BillLogPaging(HttpServletRequest req,
				Common search
				, @RequestParam(value="UI_ID",required=false) String UI_ID
				, @RequestParam(value="AH_HOMEDIV_C",required=false) String AH_HOMEDIV_C
				) throws Exception {
			
			ModelAndView mv  = new ModelAndView("/dyAdmin/bill/pra_bills_logpaging");

			List<HashMap<String,Object>> searchList = Component.getSearchList(req);
			
			Map<String,Object> map = CommonService.ConverObjectToMap(search);
			
			if(searchList != null){
				map.put("searchList", searchList);
			}
			
			
			
			map.put("AH_HOMEDIV_C", AH_HOMEDIV_C);
			map.put("UI_ID", UI_ID);
			
			PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"bills.Log_getListCnt4",map, search.getPageUnit(), 10);
			
			map.put("firstIndex", pageInfo.getFirstRecordIndex());
			map.put("lastIndex", pageInfo.getLastRecordIndex());
			map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
			
			mv.addObject("paginationInfo", pageInfo);
			
			List<HashMap<String,Object>> resultList = Component.getList("bills.Log_getList4", map); 
			mv.addObject("resultList4", resultList);
			mv.addObject("search", search);
			return mv;
		}
	
	
	/**
	 * 활동 기록 - excel ajax
	 * @param req
	 * @param res
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/bills/billexcelajax.do")
	public ModelAndView BillLogExcel(HttpServletRequest req
			, HttpServletResponse res
			, Common search
			, @RequestParam(value="AH_HOMEDIV_C", required = false) String AH_HOMEDIV_C
			, @RequestParam(value="UI_ID", required = false) String UI_ID
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/bill/pra_bills_log_excel");
		
		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		map.put("AH_HOMEDIV_C", AH_HOMEDIV_C);
		map.put("UI_ID", UI_ID);
		
		mv.addObject("resultList4", Component.getList("bills.Log_getList4", map));
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
	 * 활동 기록 - 데이터 가져오기
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/bills/log/billdataAjax.do")
	@ResponseBody
	public Object BillLogData(HttpServletRequest req
			, LogDTO search
			) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
        map.put("data", Component.getList("bills.Log_getList4",search));// 데이터 가져옴
        Object result = map;
		
		return result;
	}
	
	
	//팝업 컨트롤러
	@RequestMapping(value="/dyAdmin/bills/log/controller.do")
	@ResponseBody
	public Object PopUpController(HttpServletRequest req
			, @RequestParam(value="listtable", required = false) String listtable
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/bill/pra_bills_popup");
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		map = Component.getData("bills.LogSelect", listtable);  //object로 보냄 getList는 배열, getData는 object 
		String month = map.get("dbl_issuedate").toString().substring(4,6);
		String date = map.get("dbl_issuedate").toString().substring(6,8);
		
		
		
		mv.addObject("list",map); //object로 보냄
		mv.addObject("month", month);
		mv.addObject("date", date);
		
		
		return mv;
	}
	
}
