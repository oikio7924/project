package com.tx.dyAdmin.operation.holiday.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.dto.Common;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.page.PageAccess;
import com.tx.dyAdmin.operation.holiday.dto.HolidayDTO;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * 
 * @FileName: HolidayController.java
 * @Date    : 2017. 03. 28. 
 * @Author  : 이재령	
 * @Version : 1.0
 */
@Controller
public class HolidayController {

	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 페이지 처리 출 */
	@Autowired private PageAccess PageAccess;
	
	/**
	 * 휴일 리스트
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/operation/holiday.do")
	@CheckActivityHistory(desc="휴일 관리 페이지 방문")
	public ModelAndView adminOperationHoliday(HttpServletRequest req) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/operation/holiday/pra_holiday_listView.adm");
		
		mv.addObject("holidayList", Component.getListNoParam("Holiday.THM_selectAll"));
		
		return mv;
	}
	
	/**
	 * 휴일 리스트 - 페이징 ajax
	 * @param req
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/operation/holiday/pagingAjax.do")
	public ModelAndView adminOperationHolidayPagingAjax(HttpServletRequest req,
			Common search
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/operation/holiday/pra_holiday_listView_data");

		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"Holiday.THM_getListCnt",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		mv.addObject("resultList", Component.getList("Holiday.THM_getList", map));
		mv.addObject("search", search);
		return mv;
		
		
	}
	
	
	/**
	 * 휴일 리스트 - excel ajax
	 * @param req
	 * @param res
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/operation/holiday/excelAjax.do")
	public ModelAndView adminOperationHolidayExcelAjax(HttpServletRequest req
			, HttpServletResponse res
			, Common search
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/operation/holiday/pra_holiday_listView_excel");
		
		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		mv.addObject("resultList", Component.getList("Holiday.THM_getList", map));
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
	 * 휴일 데이터 가져오기
	 * @param req
	 * @param HolidayDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/operation/holiday/dataAjax.do")
	@Transactional
	@ResponseBody
	public HolidayDTO adminOperationHolidayDataAjax(HttpServletRequest req
			, HolidayDTO HolidayDTO
			) throws Exception {
		
		return Component.getData("Holiday.THM_getData", HolidayDTO);	
	}
	
	/**
	 * 휴일 추가
	 * @param req
	 * @param HolidayDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/operation/holiday/insertAjax.do")
	@CheckActivityHistory(desc="휴일 추가 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	@ResponseBody
	public HolidayDTO adminOperationHolidayInsertAjax(HttpServletRequest req, HolidayDTO HolidayDTO
			) throws Exception {
		
		Component.createData("Holiday.THM_insert", HolidayDTO);
		return HolidayDTO;	
	}
	
	/**
	 * 휴일 수정
	 * @param req
	 * @param HolidayDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/operation/holiday/updateAjax.do")
	@CheckActivityHistory(desc="휴일 수정 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	@ResponseBody
	public HolidayDTO adminOperationHolidayUpdateAjax(HttpServletRequest req, HolidayDTO HolidayDTO
			) throws Exception {
		
		Component.updateData("Holiday.THM_update", HolidayDTO);
		return HolidayDTO;	
	}
	
	@RequestMapping(value="/dyAdmin/operation/holiday/deleteAjax.do")
	@CheckActivityHistory(desc="휴일 삭제 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	@ResponseBody
	public HolidayDTO adminOperationHolidayDeleteAjax(HttpServletRequest req, HolidayDTO HolidayDTO
			) throws Exception {
		
		Component.updateData("Holiday.THM_delete", HolidayDTO);
		return HolidayDTO;	
	}
	
}
