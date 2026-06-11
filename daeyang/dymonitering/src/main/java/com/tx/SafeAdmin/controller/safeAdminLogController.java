package com.tx.SafeAdmin.controller;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
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
import com.tx.common.service.reqapi.requestAPIservice;
import com.tx.dyAdmin.statistics.dto.LogDTO;
import com.tx.SafeAdmin.dto.safebillDTO;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;


@Controller
public class safeAdminLogController {

	
	@Autowired
	ComponentService Component;
	
	@Autowired
	CommonService CommonService;
	
	@Autowired
	requestAPIservice requestAPI;
	
	@Autowired
	private PageAccess PageAccess;
	
	
	/**
	 * 활동 기록
	 * @param req
	 * @return
	 * @throws Exception
	 */
	 @RequestMapping("/sfa/sfaAdmin/logstatus.do")
	   public ModelAndView BillLog(HttpServletRequest req
			  , LogDTO search
			  , Common search2
			  , @RequestParam(value="id",required=false) String id
			  , @RequestParam(value="AH_HOMEDIV_C",required=false) String AH_HOMEDIV_C) throws Exception {
		   ModelAndView mv = new ModelAndView("/sfa/Admin/prc_admin_log");
		    
		  
		   
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
	 @RequestMapping(value="/sfa/sfaAdmin/pagingAjaxAdmin.do")
		public ModelAndView BillLogPaging(HttpServletRequest req,
				Common search
				, @RequestParam(value="UI_ID",required=false) String UI_ID
				, @RequestParam(value="AH_HOMEDIV_C",required=false) String AH_HOMEDIV_C
				) throws Exception {
			
			ModelAndView mv  = new ModelAndView("/user/_SFA/safe/prc_admin_logpaging_pb");

			List<HashMap<String,Object>> searchList = Component.getSearchList(req);
			
			Map<String,Object> map = CommonService.ConverObjectToMap(search);
			
			Map<String, Object> user = CommonService.getUserInfo(req);
			String UI_KEYNO = user.get("UI_KEYNO").toString();
			
			if(searchList != null){
				map.put("searchList", searchList);
			}
			
			
			
			map.put("AH_HOMEDIV_C", AH_HOMEDIV_C);
			map.put("UI_ID", UI_ID);
			map.put("SU_UI_KEYNO", UI_KEYNO);
			
			
			PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"sfa.Safe_getListCnt",map, search.getPageUnit(), 10);
			
			map.put("firstIndex", pageInfo.getFirstRecordIndex());
			map.put("lastIndex", pageInfo.getLastRecordIndex());
			map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
			
			mv.addObject("paginationInfo", pageInfo);
			
			List<HashMap<String,Object>> resultList = Component.getList("sfa.Safe_getList", map); 
			mv.addObject("resultList4", resultList);
			mv.addObject("search", search);
			mv.addObject("SU_UI_KEYNO", UI_KEYNO);
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
	@RequestMapping(value="/sfa/sfaAdmin/Adminexcelajax.do")
	public ModelAndView BillLogExcel(HttpServletRequest req
			, HttpServletResponse res
			, Common search
			, @RequestParam(value="AH_HOMEDIV_C", required = false) String AH_HOMEDIV_C
			, @RequestParam(value="UI_ID", required = false) String UI_ID
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/user/_SFA/safe/prc_admin_log_excel");
		
		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		map.put("AH_HOMEDIV_C", AH_HOMEDIV_C);
		map.put("UI_ID", UI_ID);
		
		mv.addObject("resultList4", Component.getList("sfa.Safe_getList", map));
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
	 * 활동 기록 - 페이징 ajax
	 * @param req
	 * @param search
	 * @return
	 * @throws Exception
	 */
	 @RequestMapping(value="/sfa/sfaAdmin/checkingAjaxAdmin.do")
		public ModelAndView checkingAjaxAdmin(HttpServletRequest req,
				Common search
				, @RequestParam(value="UI_ID",required=false) String UI_ID
				, @RequestParam(value="AH_HOMEDIV_C",required=false) String AH_HOMEDIV_C
				, @RequestParam(value="areaSelect",required=false) String areaSelect
				) throws Exception {
			
			ModelAndView mv  = new ModelAndView("/user/_SFA/safe/prc_admin_checking_pb");

			List<HashMap<String,Object>> searchList = Component.getSearchList(req);
			
			Map<String,Object> map = CommonService.ConverObjectToMap(search);
			
			Map<String, Object> user = CommonService.getUserInfo(req);
			String UI_KEYNO = user.get("UI_KEYNO").toString();
			
			if(searchList != null){
				map.put("searchList", searchList);
			}
			
			map.put("AH_HOMEDIV_C", AH_HOMEDIV_C);
			map.put("UI_ID", UI_ID);
			map.put("SU_UI_KEYNO", UI_KEYNO);
			map.put("areaSelect", areaSelect);
			
			
			PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"sfa.Month_Checking_Cnt",map, search.getPageUnit(), 10);
			
			map.put("firstIndex", pageInfo.getFirstRecordIndex());
			map.put("lastIndex", pageInfo.getLastRecordIndex());
			map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
			
			mv.addObject("paginationInfo", pageInfo);
			
			List<HashMap<String,Object>> resultList = Component.getList("sfa.Month_Checking", map); 
			mv.addObject("resultList4", resultList);
			mv.addObject("search", search);
			mv.addObject("SU_UI_KEYNO", UI_KEYNO);
			mv.addObject("areaSelect", areaSelect);
			return mv;
		}
	
	/**
	 * 활동 기록 - 데이터 가져오기
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/sfa/sfaAdmin/log/billdataAjax.do")
	@ResponseBody
	public Object BillLogData(HttpServletRequest req
			, LogDTO search
			) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
        map.put("data", Component.getList("bills.Safe_getList",search));// 데이터 가져옴
        Object result = map;
		
		return result;
	}
	
	
	//로그 페이지 팝업 
	@RequestMapping(value="/sfa/sfaAdmin/log/controller.do")
	@ResponseBody
	public Object PopUpController(HttpServletRequest req
			, @RequestParam(value="listtable", required = false) String listtable
			, @RequestParam(value="num") String num
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/user/_SFA/safe/Popup/prc_admin_popup3_pb");
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		map = Component.getData("sfa.safepaperselect2_one", listtable);  //object로 보냄 getList는 배열, getData는 object 
		
		
		mv.addObject("list",map); //object로 보냄
		mv.addObject("num", num);
		
		
		return mv;
	}
	
	
	//이전 양식 바로 조회
	@RequestMapping(value="/sfa/sfaAdmin/log/RecentViewController.do")
	@ResponseBody
	public Object RecentViewController(HttpServletRequest req
			, @RequestParam(value="SUKEYNO", required = false) String SU_KEYNO
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/user/_SFA/safe/Popup/prc_admin_popup2_pb");
		
		Map<String, Object> user = CommonService.getUserInfo(req);
		String UI_KEYNO = user.get("UI_KEYNO").toString();
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		HashMap<String, Object> map2 = new HashMap<String, Object>();
		
		map.put("UI_KEYNO", UI_KEYNO);
		map.put("SU_KEYNO", SU_KEYNO);
		
		//바로 전회차 양식 뽑기
		map2 = Component.getData("sfa.SafeRecentPre", map);  //object로 보냄 getList는 배열, getData는 object 
		
		if(map2 == null) {
			
			return "<script>alert('이전에 작성한 양식이 없습니다'); window.close();</script>";
			
		}else {
			
			//인버터 갯수 뽑기
			String num = Component.getData("sfa.inverterNum_Recent", SU_KEYNO);
			
			mv.addObject("list",map2); //object로 보냄
			mv.addObject("num", num);
			
			
			return mv;
		}
	}
	
	//수정페이지
		@RequestMapping(value="/sfa/safeAdmin/safeAdminUpdate.do")
		public Object UpdatePage(HttpServletRequest req
				, @RequestParam(value="listtable", required = false) String listtable
				, @RequestParam(value="num", required = false) String num
				, @RequestParam(value="SU_KEYNO", required = false) String SU_KEYNO
				) throws Exception {
			ModelAndView mv  = new ModelAndView("/user/_SFA/safe/Popup/prc_admin_updateview2_pb");
			
			Map<String, Object> user = CommonService.getUserInfo(req);
			String UI_KEYNO = user.get("UI_KEYNO").toString();
			
			HashMap<String, Object> map = new HashMap<String, Object>();
			HashMap<String, Object> map2 = new HashMap<String, Object>();
			HashMap<String, Object> Update_Predata = new HashMap<String, Object>();
			
			
			
			map2.put("SU_KEYNO", SU_KEYNO);
			map2.put("UI_KEYNO", UI_KEYNO);
			
			map = Component.getData("sfa.safepaperselect2_one", listtable);  //object로 보냄 getList는 배열, getData는 object
			Update_Predata = Component.getData("sfa.safe_TwoPreData", map2);
			Timestamp timestamp = (Timestamp) map.get("Conn_date");

			// Timestamp 객체를 문자열로 변환
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String Conn_date = dateFormat.format(timestamp);
			String perioddata = (String) map.get("sa2_meter2period");
			
			int idx = perioddata.indexOf("~");
			
			String perioddata2 = perioddata.substring(0,idx);
			String sa2_date = (String) map.get("sa2_date");
			String year = Conn_date.substring(0,4);
			String mon = Conn_date.substring(5,7);
			String day = Conn_date.substring(8,10);
			String time = Conn_date.substring(11,13);
			String min = Conn_date.substring(14,16);
			String sec = Conn_date.substring(17);
			String dayOfWeek = sa2_date.substring(18,19);
			
					
			mv.addObject("list",map); 
			mv.addObject("list2",Update_Predata); 
			mv.addObject("num",num); 
			mv.addObject("year",year); 
			mv.addObject("mon",mon); 
			mv.addObject("day",day); 
			mv.addObject("time",time); 
			mv.addObject("min",min); 
			mv.addObject("sec",sec); 
			mv.addObject("dayOfWeek",dayOfWeek); 
			mv.addObject("Conn_date",Conn_date); 
			mv.addObject("perioddata",perioddata2); 
			mv.addObject("safeuserlist", Component.getListNoParam("sfa.safeuserselect"));
			
			
			return mv;
		}
		
		@RequestMapping(value="/sfa/safeAdmin/log/inverterNum.do")
		@ResponseBody
		public String inverterNum(HttpServletRequest req
				, @RequestParam(value="keyno", required = false) String keyno
				, @RequestParam(value="UIKEYNO", required = false) String SU_UI_KEYNO
				) throws Exception {
			
			HashMap<String, Object> map = new HashMap<String, Object>();
			
			String num  = "";
			
			map.put("keyno", keyno);
			map.put("SU_UI_KEYNO", SU_UI_KEYNO);
			
			num = Component.getData("sfa.inverterNumSelect", map);  //object로 보냄 getList는 배열, getData는 object
				
			
			return num;
		}
		
		@RequestMapping(value="/sfa/safeAdmin/log/Deletepaper.do")
		@ResponseBody
		public String DeletePaper(HttpServletRequest req
				, @RequestParam(value="chkvalue", required = false) String keyno
				) throws Exception {
			
			HashMap<String, Object> map = new HashMap<String, Object>();

			String [] keynolist = keyno.split(",");

			map.put("keynolist", keynolist);

			Component.deleteData("sfa.sapaperdelete2", keynolist);
			
			String msg  = "양식 삭제 완료";
			
			return msg;
		}
	
}
