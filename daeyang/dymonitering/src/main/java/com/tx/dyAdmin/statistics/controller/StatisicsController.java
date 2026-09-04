package com.tx.dyAdmin.statistics.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.dto.Common;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.admin.board.service.BoardCommonService;
import com.tx.dyAdmin.statistics.dto.StatisticsDTO;

/**
 * 
 * @FileName: StatisicsController.java
 * @Project : kcf
 * @Date    : 2019. 07. 26. 
 * @Author  : 이혜주	
 * @Version : 1.0
 */
@Controller
public class StatisicsController {

	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
    @Autowired private BoardCommonService BoardCommonService;
    
	/**
	 * 파일다운로드 카운터
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/statistics/board.do")
	@CheckActivityHistory(desc="게시물 조회 카운터 페이지 방문")
	public ModelAndView AttachmentsView(
			HttpServletRequest req
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/statistics/board/pra_board_view.adm");
		String siteKey = (String)req.getSession().getAttribute("SITE_KEYNO");
        mv.addObject("boardMN", BoardCommonService.getAuthBoardMenuList(req, CommonService.createMap("MN_HOMEDIV_C", siteKey))); 
		
		return mv;
	}
	
	/**
	 * 메뉴 가져오기
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/statistics/getmenuAjax.do")
	@ResponseBody
	public List<HashMap<String, Object>> GetmenuAjax(
			HttpServletRequest req
			,@RequestParam(value="KEY") String KEY
			,@RequestParam(value="type") String type
			) throws Exception {
		
	
		List<HashMap<String, Object>> boardMainMN = Component.getList("Statistics.get_boardListName",CommonService.createMap("KEY", KEY)); 
		
		return boardMainMN;
	}
	
	/**
	 * 첨부파일 리스트 - paging ajax
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/statistics/{tiles}/pagingAjax.do")
	public ModelAndView AjaxAttachPagingAjax(
			  HttpServletRequest req
			, HttpServletResponse res
			, @ModelAttribute StatisticsDTO StatisticsDTO
			, @PathVariable String tiles
			, Common search
			, @RequestParam(value="excel", required=false) String excel
			) throws Exception {
		ModelAndView mv = new ModelAndView("/dyAdmin/statistics/"+tiles+"/pra_"+tiles+"_view_data");

		
			List<HashMap<String,Object>> searchList = Component.getSearchList(req);

			Map<String,Object> map = CommonService.ConverObjectToMap(search);
			if(searchList != null){
				map.put("searchList", searchList);
			}
			
			String siteKey = (String)req.getSession().getAttribute("SITE_KEYNO");
			StatisticsDTO.setHOMEKEY(siteKey);
			List<HashMap<String,Object>> list = getStatisticsData(StatisticsDTO);
			
			int total =0;
			if(list !=null && list.size()>0){
				
				for(int i=0; i<list.size(); i++){
					String str = String.valueOf(list.get(i).get("COUNT"));
					total += (long)Integer.parseInt(str);
				}
				for(int i=0; i<list.size(); i++){ //평균
					list.get(i).put("no", i+1);
					String str = String.valueOf(list.get(i).get("COUNT"));
					long COUNT = (long)Integer.parseInt(str);
					float a = COUNT / (float)total * 100;
					a *= 100;
					int ii =   (int) a;
					a = (float) (ii* 0.01);
					list.get(i).put("persent", a);
				}
			}
			
	
			
			mv.addObject("visitorCase",StatisticsDTO.getSTM_CASE());
			mv.addObject("total", total);
			mv.addObject("html", list);
			mv.addObject("search", StatisticsDTO);
		
		
		if(excel != null && excel.equals("excel")){
			mv.setViewName("/dyAdmin/statistics/"+tiles+"/pra_"+tiles+"_list_excel");
			try {
				Cookie cookie = new Cookie("fileDownload", "true");
		        cookie.setPath("/");
		        res.addCookie(cookie);
	            
	        } catch (Exception e) {
	            System.out.println("쿠키 에러");
	        }
		}
		
		return mv;
	}
	
	private List<HashMap<String, Object>> getStatisticsData(StatisticsDTO search) {
		List<HashMap<String,Object>> list = null;
		String visitorCase = search.getSTM_CASE();
		switch (visitorCase) {
		case "시간":
			list =  Component.getList("Statistics.STM_getVisitTime", search);
			break;
		case "요일":
			list =  Component.getList("Statistics.STM_getVisitWeekOfDay", search);
			break;
		case "일자":
			list =  Component.getList("Statistics.STM_getVisitDay", search);
			break;
		case "월":
			list =  Component.getList("Statistics.STM_getVisitMonth", search);
			break;
		case "년":
			list =  Component.getList("Statistics.STM_getVisitYear", search);
			break;
		}
		return list;
	}


	
}
