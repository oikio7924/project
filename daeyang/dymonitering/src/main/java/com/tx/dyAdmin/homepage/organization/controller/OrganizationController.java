package com.tx.dyAdmin.homepage.organization.controller;

import java.io.PrintWriter;
import java.util.ArrayList;
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
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.dto.Common;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.excel.ExcelService;
import com.tx.common.service.page.PageAccess;
import com.tx.dyAdmin.homepage.menu.dto.Menu;
import com.tx.dyAdmin.homepage.organization.dto.OrganDTO;
import com.tx.dyAdmin.homepage.organization.service.OrganizationService;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * @author admin
 *
 */
@Controller
public class OrganizationController {

	/** 공통 컴포넌트 */
	@Autowired
	ComponentService Component;
	@Autowired
	CommonService CommonService;

	@Autowired
	private OrganizationService OrganizationService;
	@Autowired
	private ExcelService ExcelService;

	/** 페이지 처리 출 */
	@Autowired
	private PageAccess PageAccess;

	/**
	 * 조직도 보기
	 * 
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/org/org.do")
	@CheckActivityHistory(desc = "조직도 관리 페이지 방문")
	public ModelAndView organizationView(HttpServletRequest req, OrganDTO OrganDto, Menu Menu,
			@RequestParam(value = "key", required = false) String key) throws Exception {
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/organ/pra_organ_listView.adm");

		Menu.setMN_KEYNO(CommonService.getDefaultSiteKey(req));
		
		Menu = Component.getData("Menu.AMN_getDataByKey", Menu);
		mv.addObject("menu", Menu);
		mv.addObject("orgData", OrganizationService.doStartTagInternal(Menu.getMN_HOMEDIV_C()));

		OrganDto.setDN_HOMEDIV_C(Menu.getMN_HOMEDIV_C());
		mv.addObject("orgList", Component.getList("Organization.DN_getList", OrganDto));
		
		mv.addObject("click", key);

		return mv;
	}

	@RequestMapping(value = "/dyAdmin/homepage/org/empl.do")
	@CheckActivityHistory(desc = "사원 관리 페이지 방문")
	public ModelAndView employeeView(HttpServletRequest req, OrganDTO OrganDto, Menu menu) throws Exception {
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/organ/pra_organ_member_list.adm");
		HashMap<String, Object> map = new HashMap<>();
		map.put("USERID", SiteProperties.getCmsUser());
		map.put("HM_TILES", "web");
		mv.addObject("userInfoSetting", Component.getData("member.US_getData2", map));
		mv.addObject("authoritylist", Component.getListNoParam("Authority.UIA_GetList2"));
		
		String HOMEDIV_C = CommonService.getDefaultSiteKey(req);

		OrganDto.setDN_HOMEDIV_C(HOMEDIV_C);
		mv.addObject("HOMEDIV_C", HOMEDIV_C);
		mv.addObject("orgList", Component.getList("Organization.DN_getList", OrganDto));
		
		mv.addObject("homeDivList", CommonService.getHomeDivCode(false));
		return mv;
	}

	@RequestMapping(value = "/dyAdmin/person/view/organPagingAjax.do")
	public ModelAndView adminMemberViewPaging(HttpServletRequest req, Common search
	) throws Exception {

		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/organ/pra_organ_member_list_data");
		
		List<HashMap<String, Object>> searchList = Component.getSearchList(req);

		Map<String, Object> map = CommonService.ConverObjectToMap(search);

		if (searchList != null) {
			map.put("searchList", searchList);
		}

		map.put("DN_HOMEDIV_C", req.getParameter("MN_HOMEDIV_C"));
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(), "Organization.DU_selectListCnt", map,
				search.getPageUnit(), 10);

		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());

		OrganDTO OrganDto = new OrganDTO();
		OrganDto.setDN_HOMEDIV_C(req.getParameter("MN_HOMEDIV_C"));
		mv.addObject("orgList", Component.getList("Organization.DN_getList", OrganDto));
		
		mv.addObject("paginationInfo", pageInfo);

		List<HashMap<String, Object>> resultList = Component.getList("Organization.DU_selectList", map);
		mv.addObject("resultList", resultList);
		mv.addObject("HOMEDIV_C", req.getParameter("MN_HOMEDIV_C"));
		mv.addObject("search", search);
		return mv;

	}

	/**
	 * 조직 정보 ajax
	 * 
	 * @param req
	 * @param key
	 * @param OrganDto
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/org/dataAjax.do")
	@ResponseBody
	public Map<String, Object> adminOperationOrgDataAjax(HttpServletRequest req,
			@RequestParam(value = "key") String key, OrganDTO OrganDto) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();

		OrganDto.setDN_KEYNO(CommonService.getKeyno(key, "DN"));
		String DN_MAINKEY = Component.getData("Organization.DN_MainKey", OrganDto); // 조직
																					// 메인키
		OrganDto.setDN_MAINKEY(DN_MAINKEY);
		result.put("LevelCnt", Component.getList("Organization.DN_MainList", OrganDto));

		result.put("data", Component.getData("Organization.DN_getList", OrganDto)); // 조직
																					// 정보
		result.put("list", Component.getList("Organization.DU_getList", OrganDto)); // 조직원
																					// 정보

		return result;
	}

	/**
	 * 조직 정보2 ajax
	 * 
	 * @param req
	 * @param key
	 * @param OrganDto
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/org/data2Ajax.do")
	@ResponseBody
	public Map<String, Object> adminOperationOrgData2Ajax(HttpServletRequest req, OrganDTO OrganDto) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();

		result.put("list", Component.getList("Organization.DU_getList2", OrganDto)); // 조직원
																						// 정보

		return result;
	}

	@RequestMapping(value = "/dy/temp.do")
	public ModelAndView adminOp111erationOrgDataAjax(HttpServletRequest req) throws Exception {
		ModelAndView mv = new ModelAndView("/dy/temp/temp");
		return mv;
	}

	/**
	 * 조직 추가
	 * 
	 * @param req
	 * @param OrganDto
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/org/insert.do")
	@CheckActivityHistory(desc = "조직 추가 작업", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView adminOperationOrgInsert(HttpServletRequest req, HttpServletResponse res,
			@ModelAttribute OrganDTO OrganDto) throws Exception {

		OrganDto.setDN_KEYNO(CommonService.getTableKey("DN"));

		Integer mainCnt = 0;
		if (OrganDto.getDN_MAINKEY() == "") {
			mainCnt = Component.getData("Organization.DN_MainCNT", OrganDto);
			if (mainCnt > 0) {
				PrintWriter out = res.getWriter();
				res.setContentType("text/html; charset=UTF-8");
				res.setCharacterEncoding("UTF-8");
				out.println("<script language='javascript'>");
				out.println("alert('최상위 조직은 하나만 등록가능합니다.'); location.href='/dyAdmin/homepage/org/org.do'");
				out.println("</script>");
				out.flush();
				return null;
			}else{
				int cnt = Component.getData("Organization.DN_Temp_select", OrganDto);
				if( cnt == 0 ){
				TEMP_INSERT(OrganDto.getDN_HOMEDIV_C());
				}
			}
		}

		Component.createData("Organization.DN_insert", OrganDto);

		String key = CommonService.setKeyno(OrganDto.getDN_KEYNO());

		ModelAndView mv = new ModelAndView(
				"redirect:/dyAdmin/homepage/org/org.do?key=" + key + "&MN_HOMEDIV_C=" + OrganDto.getDN_HOMEDIV_C()+"&DIV_KEY=111");
		return mv;
	}

	private void TEMP_INSERT(String homekey) {
		OrganDTO OrganDto = new OrganDTO();
		OrganDto.setDN_KEYNO(CommonService.getTableKey("DN"));
		OrganDto.setDN_HOMEDIV_C(homekey);
		
		Component.createData("Organization.DN_Temp_insert", OrganDto);
		
	}

	/**
	 * 조직 정보 수정
	 * 
	 * @param req
	 * @param OrganDto
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/org/update.do")
	@CheckActivityHistory(desc = "조직 정보 수정 작업", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView adminOperationOrgUpdate(HttpServletRequest req, @ModelAttribute OrganDTO OrganDto)
			throws Exception {

		String key = CommonService.setKeyno(OrganDto.getDN_KEYNO());

		ModelAndView mv = new ModelAndView(
				"redirect:/dyAdmin/homepage/org/org.do?key=" + key + "&MN_HOMEDIV_C=" + OrganDto.getDN_HOMEDIV_C()+"&DIV_KEY=111");

		if (!OrganDto.getDN_MAINKEY_BEFORE().equals(OrganDto.getDN_MAINKEY())) {
			Integer mainCnt = 0;
			mainCnt = Component.getData("Organization.DN_MainCNT", OrganDto);
			OrganDto.setDN_LEV(mainCnt + 1);
			Component.updateData("Organization.DN_updateLEV", OrganDto);
		}

		Component.updateData("Organization.DN_update", OrganDto);

		return mv;
	}

	/**
	 * 조직 삭제
	 * 
	 * @param req
	 * @param OrganDto
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/org/delete.do")
	@CheckActivityHistory(desc = "조직 정보 삭제 작업", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView adminOperationOrgDelete(HttpServletRequest req, OrganDTO OrganDto) throws Exception {

		ModelAndView mv = new ModelAndView(
				"redirect:/dyAdmin/homepage/org/org.do?" + "MN_HOMEDIV_C=" + OrganDto.getDN_HOMEDIV_C()+"&DIV_KEY=111");

		if (OrganDto.getDN_MAINKEY() != null){
		Component.updateData("Organization.DN_deleteLEV", OrganDto);
		}
		Component.updateData("Organization.DN_delete", OrganDto);
		Component.updateData("Organization.DN_Sub_delete", OrganDto);

		return mv;
	}

	/**
	 * 조직원 추가
	 * 
	 * @param req
	 * @param OrganDto
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/org/person/insert.do")
	@CheckActivityHistory(desc = "조직원 추가 작업", homeDiv = "MN_0000000999")
	@Transactional
	public ModelAndView adminOperationOrgPersonInsert(HttpServletRequest req, OrganDTO OrganDto) throws Exception {

		OrganDto.setDU_KEYNO(CommonService.getTableKey("DU"));
		Component.createData("Organization.DU_insert", OrganDto);
		
		
		
		String key = "";
		if(StringUtils.isNotEmpty(OrganDto.getDU_DN_KEYNO())) {
			key = CommonService.setKeyno(OrganDto.getDU_DN_KEYNO());
		}
		
		if(req.getParameter("PAGE_DIV_C") != null){
			ModelAndView mv = new ModelAndView(
				"redirect:/dyAdmin/homepage/org/empl.do?key=" + key + "&MN_HOMEDIV_C=" + OrganDto.getDU_HOMEDIV_C());
			return mv;
		}else{
			ModelAndView mv = new ModelAndView(
					"redirect:/dyAdmin/homepage/org/org.do?key=" + key + "&MN_HOMEDIV_C=" + OrganDto.getDU_HOMEDIV_C()+"&DIV_KEY=111");

			return mv;
		}

	}

	/**
	 * 조직원 수정
	 * 
	 * @param req
	 * @param OrganDto
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/org/person/update.do")
	@CheckActivityHistory(desc = "조직원 수정 작업", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView adminOperationOrgPersonUpdate(HttpServletRequest req, OrganDTO OrganDto) throws Exception {

		Component.updateData("Organization.DU_update", OrganDto);

		
		if(req.getParameter("PAGE_DIV_C") != null){
			ModelAndView mv = new ModelAndView(
					"redirect:/dyAdmin/homepage/org/empl.do?MN_HOMEDIV_C=" + OrganDto.getDU_HOMEDIV_C());
				return mv;
			}else{
				String key = CommonService.setKeyno(OrganDto.getDU_DN_KEYNO());
				ModelAndView mv = new ModelAndView(
						"redirect:/dyAdmin/homepage/org/org.do?key=" + key + "&MN_HOMEDIV_C=" + OrganDto.getDU_HOMEDIV_C()+"&DIV_KEY=111");

				return mv;
			}
	}

	/**
	 * 조직원 삭제
	 * 
	 * @param req
	 * @param OrganDto
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/org/person/delete.do")
	@CheckActivityHistory(desc = "조직원 삭제 작업", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView adminOperationOrgPersonDelete(HttpServletRequest req, OrganDTO OrganDto) throws Exception {
		String key = CommonService.setKeyno(OrganDto.getDU_DN_KEYNO());
		Component.updateData("Organization.DU_deleteLEV", OrganDto);
		Component.updateData("Organization.DU_delete", OrganDto);

		if(req.getParameter("PAGE_DIV_C") != null){
		ModelAndView mv = new ModelAndView(
				"redirect:/dyAdmin/homepage/org/empl.do?key=" + key + "&MN_HOMEDIV_C=" + OrganDto.getDU_HOMEDIV_C());
			return mv;
		}else{
			ModelAndView mv = new ModelAndView(
					"redirect:/dyAdmin/homepage/org/org.do?key=" + key + "&MN_HOMEDIV_C=" + OrganDto.getDU_HOMEDIV_C()+"&DIV_KEY=111");
			return mv;
		}


	}

	/**
	 * 조직원 순서 변경
	 * 
	 * @param req
	 * @param OrganDto
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/org/person/chageLev.do")
	@CheckActivityHistory(desc = "조직원 순서 변경 작업", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	@ResponseBody
	public void adminOperationOrgPersonLevel(HttpServletRequest req,
			@RequestParam(value = "DU_KEYNO") String[] DU_KEYNO, @RequestParam(value = "DU_LEV_AFTER") String[] DU_LEV)
			throws Exception {
		List<OrganDTO> list = new ArrayList<OrganDTO>();
		OrganDTO OrganDTO = null;
		for (int i = 0; i < DU_KEYNO.length; i++) {
			OrganDTO = new OrganDTO();
			OrganDTO.setDU_KEYNO(DU_KEYNO[i]);
			OrganDTO.setDU_LEV(Integer.parseInt(DU_LEV[i]));
			list.add(OrganDTO);
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", list);
		Component.updateData("Organization.DU_updateLev", map);

	}

	/**
	 * 조직원 순서 변경2
	 * 
	 * @param req
	 * @param OrganDto
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/org/person/chageLev2.do")
	@CheckActivityHistory(desc = "조직원 순서 변경 작업", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	@ResponseBody
	public void adminOperationOrgPersonLevel2(HttpServletRequest req, @ModelAttribute OrganDTO OrganDTO,
			@RequestParam(value = "type", required = true) String type) throws Exception {

		if ("U".equals(type)) {
			OrganDTO.setDU_DN_KEYNO(CommonService.getKeyno(OrganDTO.getDU_DN_KEYNO(), "DN"));
			Component.updateData("Organization.DU_updateLev2", OrganDTO);
		} else if ("N".equals(type)) {
			Component.updateData("Organization.DN_updateLev2", OrganDTO);
		}

	}

	/**
	 * 조직도 페이지 엑셀 - excel ajax
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 * 
	 */
	@RequestMapping(value = "/dyAdmin/homepage/org/excelAjax.do")
	public ModelAndView adminOperationExcelAjax(HttpServletResponse res, Model model,
			@RequestParam(value = "MN_HOMEDIV_C", required = false) String MN_HOMEDIV_C, OrganDTO OrganDto)
			throws Exception {

		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/organ/pra_organ_list_excel");

		String WebName = Component.getData("Menu.excel_getWebName", MN_HOMEDIV_C);
		List<HashMap<String, Object>> list = OrganizationService.getOrganList(MN_HOMEDIV_C);

		int maxDepth = 0;
		for (HashMap<String, Object> hashMap : list) {
			int depth = Integer.parseInt(hashMap.get("DN_DEPTH").toString());
			if (maxDepth < depth) {
				maxDepth = depth;
			}
		}

		List<HashMap<String, Object>> organList = Component.getList("Organization.DN_getOrganAllList", MN_HOMEDIV_C);

		List<HashMap<String, Object>> memberList = new ArrayList<HashMap<String, Object>>();
		for (HashMap<String, Object> emp : organList) {
			HashMap<String, Object> memberMap = new HashMap<String, Object>();
			OrganDto.setDN_KEYNO(emp.get("DN_KEYNO").toString());
			memberMap.put("DepartmentName", Component.getData("Organization.DN_getDepartmentName", OrganDto));
			memberMap.put("Members", Component.getList("Organization.DU_getList", OrganDto));
			memberList.add(memberMap);
		}

		try {
			Cookie cookie = new Cookie("fileDownload", "true");
			cookie.setPath("/");
			res.addCookie(cookie);
		} catch (Exception e) {
			System.out.println("쿠키 에러 :: " + e.getMessage());
		}

		mv.addObject("memberResult", memberList);
		mv.addObject("WEBNAME", WebName);
		mv.addObject("depth", maxDepth);
		mv.addObject("resultList", list);

		return mv;
	}
	
	
	/**
	 * 사원 리스트 - excel ajax
	 * @param req
	 * @param res
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/operation/empl/excelAjax.do")
	public ModelAndView adminMemberViewExcelAjax(HttpServletRequest req
			, HttpServletResponse res
			, Common search,
			@RequestParam(value = "MN_HOMEDIV_C", required = false) String MN_HOMEDIV_C
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/organ/pra_organ_member_list_excel");
		
		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		map.put("DN_HOMEDIV_C", MN_HOMEDIV_C);
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(), "Organization.DU_selectListCnt", map,
				search.getPageUnit(), 10);

		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());

		OrganDTO OrganDto = new OrganDTO();
		OrganDto.setDN_HOMEDIV_C(MN_HOMEDIV_C);
		mv.addObject("orgList", Component.getList("Organization.DN_getList", OrganDto));

		mv.addObject("paginationInfo", pageInfo);

		List<HashMap<String, Object>> resultList = Component.getList("Organization.DU_selectList", map);
		mv.addObject("resultList", resultList);
		
		
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
	 * 조직도 일괄 등록
	 * @param file
	 * @param organHomeKey
	 * @param req
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/org/excelInsertAjax.do")
	@ResponseBody
	@Transactional
	public void excelInsert(
			@RequestParam(value="ExcelFile",required=false) MultipartFile file
			,@RequestParam(value="organHomeKey",required=false) String organHomeKey
			,HttpServletRequest req
			)throws Exception {
		
		//조직원 삭제 후 조직 삭제
		Component.deleteData("Organization.delete_NotTempMemeberList",organHomeKey);	//조직원 삭제
		Component.deleteData("Organization.delete_NotTempList",organHomeKey);			//조직 삭제
		
		ExcelService.ExcelInsert(file, organHomeKey);
		
	}
	
	/**
	 * 조직도 샘플 파일 다운
	 * @param res
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/org/excelDownload.do")
	public void excelSampleDown(HttpServletResponse res)throws Exception {
		
		ExcelService.createExcelWorkBook(res);
		
	}
	
}
