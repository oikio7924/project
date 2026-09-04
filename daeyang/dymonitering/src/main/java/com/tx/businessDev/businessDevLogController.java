package com.tx.businessDev;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.tld.SiteProperties;
import com.tx.common.dto.Common;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.excel.ExcelService;
import com.tx.common.service.page.PageAccess;
import com.tx.dyAdmin.statistics.dto.LogDTO;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class businessDevLogController {

	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	@Autowired private PageAccess PageAccess;
	@Autowired ExcelService Excel;	
	
	
	/**  
	 * 인허가 진행 현황
	 * **/
	@RequestMapping("/bd/license/situation.do")
	public ModelAndView License_Situation(HttpServletRequest req
			, LogDTO search
			  , Common search2
			  , @RequestParam(value="id",required=false) String id
			  , @RequestParam(value="AH_HOMEDIV_C",required=false) String AH_HOMEDIV_C) throws Exception {
		  
		ModelAndView mv = new ModelAndView("/user/_BD/license/bd_license_check");
			  
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
	 * 인허가 진행 현황 페이징 Ajax
	 * **/
	@RequestMapping(value="/bd/license/situationPagingAjax.do")
	public ModelAndView SituationLogPaging(HttpServletRequest req,
			Common search
			, @RequestParam(value="UI_ID",required=false) String UI_ID
			, @RequestParam(value="AH_HOMEDIV_C",required=false) String AH_HOMEDIV_C
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/user/_BD/license/bd_license_check_paging");

		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		
		
		map.put("AH_HOMEDIV_C", AH_HOMEDIV_C);
		map.put("UI_ID", UI_ID);
		
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"busDev.Bd_getListCnt",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		
		List<HashMap<String,Object>> resultList = Component.getList("busDev.Bd_getList", map);
		mv.addObject("resultList4", resultList);
		mv.addObject("search", search);			
		
		return mv;
	}
	
	 
	@RequestMapping(value="/bd/license/situationExcelAjax.do")
	public ModelAndView SituationLogExcelDownLoad(HttpServletRequest req
			, HttpServletResponse res
			, Common search
			, @RequestParam(value="AH_HOMEDIV_C_Excel", required = false) String AH_HOMEDIV_C_Excel
			, @RequestParam(value="searchBeginDate_Excel", required = false) String searchBeginDate_Excel
			, @RequestParam(value="searchEndDate_Excel", required = false) String searchEndDate_Excel
			, @RequestParam(value="UI_ID", required = false) String UI_ID
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/user/_BD/license/bd_license_excel");
		
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    	Date d = new Date();
    	String now = format.format(d);
		
		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		//조회 버튼  클릭 후의 리스트만 엑셀다운로드하기위한 엑셀데이터(map에 강제로 파라미터 주입. 페이징 컨트롤러랑 같은 sql이므로)
		map.put("AH_HOMEDIV_C", AH_HOMEDIV_C_Excel);
		map.put("searchBeginDate", searchBeginDate_Excel);
		map.put("searchEndDate", searchEndDate_Excel);
		map.put("UI_ID", UI_ID);
		
		mv.addObject("resultList4", Component.getList("busDev.Bd_getList", map));
		mv.addObject("search", search);
		mv.addObject("now", now);
		
		
		try {
			Cookie cookie = new Cookie("fileDownload", "true");
	        cookie.setPath("/");
	        res.addCookie(cookie);
            
        } catch (Exception e) {
            System.out.println("쿠키 에러 :: "+e.getMessage());
        }
		return mv;
		
	}
	 
	 
	@RequestMapping(value = "/bd/license/insertExcel.do")
	public String SituationLogExcelInsert(HttpServletRequest req,
			@RequestPart(value = "excelFile", required=false) MultipartFile file) throws Exception {
		
		ArrayList<ArrayList<String>> result = Excel.readFilter_And_Insert(file);
		
		if(result.size() > 0) {
			for(ArrayList<String> r : result) {
				HashMap<String , Object> m = new HashMap<String, Object>();
				
			m.put("bd_plant_name",r.get(0));				
			m.put("bd_plant_add",r.get(1));				
			m.put("bd_plant_owner",r.get(2));
			m.put("bd_plant_phone",r.get(3));
			m.put("bd_plant_volum",r.get(4));
			m.put("bd_plant_installtype",r.get(5));
			m.put("bd_plant_BusDueDate",r.get(6));
			m.put("bd_plant_BusStart",r.get(7));
			m.put("bd_plant_BusEndDate",r.get(8));
			m.put("bd_plant_DevStartDate",r.get(9));
			m.put("bd_plant_DevEndDate",r.get(10));
			m.put("bd_plant_DevCompletionDate",r.get(11));
			m.put("bd_plant_OperationStartDate",r.get(12));
			m.put("bd_plant_PPADate",r.get(13));
			m.put("bd_plant_PPAVolum",r.get(14));
				
				Component.createData("busDev.PlantInsert", m);
			}
		}
		
		return "redirect:/bd/license/registration.do";	
 	}
	
	
	@RequestMapping(value="/bd/license/deletePlant.do")
	@ResponseBody
	public String DeletePaper(HttpServletRequest req
			, @RequestParam(value="chkvalue", required = false) String keyno
			) throws Exception {
		
		HashMap<String, Object> map = new HashMap<String, Object>();

		String [] keynolist = keyno.split(",");

		map.put("keynolist", keynolist);

		Component.deleteData("busDev.PlantDeleteArray", keynolist);
		
		String msg  = "양식 삭제 완료";
		
		return msg;
	}
	
}
