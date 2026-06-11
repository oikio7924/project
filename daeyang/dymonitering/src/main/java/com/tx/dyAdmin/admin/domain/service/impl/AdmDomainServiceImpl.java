package com.tx.dyAdmin.admin.domain.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.SettingData;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.dto.Common;
import com.tx.common.file.FileUploadTools;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.page.PageAccess;
import com.tx.dyAdmin.admin.authority.service.AdminAuthorityService;
import com.tx.dyAdmin.admin.domain.dto.HomeManager;
import com.tx.dyAdmin.admin.domain.service.AdmDomainService;
import com.tx.dyAdmin.admin.site.service.SiteService;
import com.tx.dyAdmin.homepage.layout.service.LayoutService;
import com.tx.dyAdmin.homepage.menu.dto.Menu;
import com.tx.dyAdmin.homepage.menu.service.AdminMenuSessionService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Service("AdmDomainService")
public class AdmDomainServiceImpl extends EgovAbstractServiceImpl implements AdmDomainService {

	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 페이지 처리 출 */
	@Autowired private PageAccess PageAccess;
	
	/** 메뉴관리 서비스2 */
	@Autowired private AdminMenuSessionService AdminMenuSessionService;
	
	/** 파일업로드 툴*/
	@Autowired private FileUploadTools FileUploadTools;
	
	@Autowired private SiteService SiteService;
	
	/** 레이아웃 서비스 */
	@Autowired private LayoutService LayoutService;
	
	@Autowired private AdminAuthorityService AdminAuthorityService;
	
	
	@Override
	public ModelAndView paging(String returnUrl, HttpServletRequest req, Common search) throws Exception {
		
		ModelAndView mv  = new ModelAndView(returnUrl);
		
		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		map.put("HOMEPAGE_REP", SiteProperties.getString("HOMEPAGE_REP"));
		map.put("HOMEPAGE_ADMIN", SettingData.HOMEDIV_ADMIN);
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"HomeManager.HM_getAdminListCnt",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		
		mv.addObject("resultList", Component.getList("HomeManager.HM_getAdminList", map));
		mv.addObject("search", search);
		
		return mv;
	}


	@Override
	public ModelAndView excel(String returnUrl, HttpServletRequest req, HttpServletResponse res, Common search) throws Exception {

		ModelAndView mv  = new ModelAndView(returnUrl);
		
		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		map.put("HOMEPAGE_REP", SiteProperties.getString("HOMEPAGE_REP"));
		map.put("HOMEPAGE_ADMIN", SettingData.HOMEDIV_ADMIN);
		mv.addObject("resultList", Component.getList("HomeManager.HM_getAdminList", map));
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


	@Override
	public ModelAndView data(String returnUrl, String HM_KEYNO) throws Exception {
		ModelAndView mv = new ModelAndView(returnUrl);
		HashMap<String, Object> resultData =  new HashMap<>();
		if(StringUtils.isNotEmpty(HM_KEYNO)){
			resultData = Component.getData("HomeManager.HM_getData", HM_KEYNO);
			mv.addObject("resultData", resultData);
			mv.addObject("formActionType", "update");
		}else{
			mv.addObject("formActionType", "insert");
			
		}
		mv.addObject("formDataList_R", Component.getListNoParam("Satisfaction.PRS_getFormList"));
		
		HashMap<String,Object> map = new HashMap<String,Object>();
		map.put("PIS_DIVISION", "W");
		mv.addObject("formDataList_W", Component.getList("Popup.PIS_getFormList", map));
		map.put("PIS_DIVISION", "B");
		mv.addObject("formDataList_B", Component.getList("Popup.PIS_getFormList", map));
		
		String tiles = (String)resultData.get("HM_TILES");
		if("adm".equals(resultData.get("HM_TILES"))) tiles = "dyAdmin";
		map.put("HM_TILES", "/"+tiles);
		map.put("HM_KEYNO", HM_KEYNO);
		
		mv.addObject("authorityList",Component.getList("Authority.UIA_GetListForDomain",map));
		mv.addObject("homeDivList", CommonService.getHomeDivCode(false));
		
		return mv;
	}


	@Override
	public String checkTilesName(String value, String type) throws Exception {
		// TODO Auto-generated method stub
		String resultMsg = "OK";
		String limitNames[] = {"notiles","default","normal","common","async","data","dyAdmin"};
		String query = "Menu.HM_getTilesCount";
		for(String limitName : limitNames){
			if(limitName.equals(value)) return "F";
		}
		if("P".equals(type)){
			query = "Menu.HM_getPathCount";
		}
		int count = Component.getCount(query, value);
		if(count > 0) resultMsg = "F";
		
		return resultMsg;
	}


	@Override
	public String insert(HashMap<String, Object> paramMap, HttpServletRequest req) throws Exception {
		
		HomeManager hm = (HomeManager) paramMap.get("hm");
		Menu Menu = (Menu) paramMap.get("Menu");
		MultipartFile thumbnail = (MultipartFile) paramMap.get("thumbnail"); 
		String template = (String) paramMap.get("template"); 
		String[] UIA_KEYNO = (String[]) paramMap.get("UIA_KEYNO"); 
		String[] HAM_DEFAULT_URL = (String[]) paramMap.get("HAM_DEFAULT_URL"); 
		
		Menu.setMN_KEYNO(CommonService.getTableKey("MN"));
	
		
		/* 홈페이지가 갖는 메뉴특성 세팅 */
		Menu.setMN_HOMEDIV_C(Menu.getMN_KEYNO());
		Menu.setMN_MAINKEY("");
		Menu.setMN_PAGEDIV_C(SettingData.MENU_TYPE_SUBMENU); //소메뉴형태
		Menu.setMN_URL("/" + hm.getHM_TILES());
		Menu.setMN_FORWARD_URL("/" + hm.getHM_TILES() + "/index.do");
		Menu.setMN_LEV(0);
		Menu.setMN_USE_YN("Y");
		Menu.setMN_SHOW_YN("Y");
		
		Map<String,Object> user = CommonService.getUserInfo(req);
		Menu.setMN_REGNM((String)user.get("UI_KEYNO"));
		
		Component.createData("Menu.AMN_regist",Menu);
		
		hm.setHM_KEYNO(CommonService.getTableKey("HM"));
		hm.setHM_MN_HOMEDIV_C(Menu.getMN_KEYNO());
		
		if(thumbnail != null && !thumbnail.isEmpty()) {
			String favicon = FileUploadTools.FaviconUpload(thumbnail, hm.getHM_TILES(),null);
			hm.setHM_FAVICON(favicon);
		}
		
		//홈페이지 정보 관리 DB insert
		Component.createData("HomeManager.HM_insertData", hm);
		
		//템플릿 설정되어있으면 관련 데이타 셋팅
		if(StringUtils.isNotEmpty(template)) {
			HomeManager templateHm = new HomeManager();
			templateHm.setHM_KEYNO(template);
			templateHm = Component.getData("HomeManager.HM_getDataByKey",templateHm);
			
			layoutDefault(hm, Menu.getMN_HOMEDIV_C(), templateHm.getHM_SITE_PATH(), req);
			
			
			copyMenu(templateHm,Menu);
			
			
			
			
		}else {
			layoutDefault(hm, Menu.getMN_HOMEDIV_C(), null, req);
		}
		
		
		//기본적인 권한 생성 (해당 서브도메인 관리자 그룹 과 관리자 권한)
		AdminAuthorityService.createDefaultAuthority(hm);
		
		//권한별 시작 페이지 설정
		saveStartUrlByAuthority(UIA_KEYNO,HAM_DEFAULT_URL,hm,false);
		
		//저장할때 해당키 수정시간저장
		AdminMenuSessionService.updateTime(Menu.getMN_HOMEDIV_C());
		SiteService.setSitePath();
		
		
		
		
		
		return hm.getHM_KEYNO();
	}
	
	/**
	 * 메뉴 구조 그대로 복사
	 * @param templateHm
	 * @param menu
	 * @throws Exception 
	 */
	private void copyMenu(HomeManager templateHm, Menu m) throws Exception {
		
		String oriUrl = templateHm.getMN_URL();
		String copyUrl = m.getMN_URL();
		
		
		List<Menu> list = Component.getList("Menu.MN_getListForCopy", templateHm);
		
		int keyCount = Component.getCount("Common.getTableKey","S_MENU_MANAGER");
		
		HashMap<String,String> mainKeyMap = new HashMap<String,String>();
		
		mainKeyMap.put(templateHm.getMN_KEYNO(), m.getMN_KEYNO());
		
		for(Menu menu : list) {
			String MN_KEYNO = CommonService.getKeyno(++keyCount, "MN"); 
			mainKeyMap.put(menu.getMN_KEYNO(), MN_KEYNO);
			menu.setMN_KEYNO(MN_KEYNO);
			menu.setMN_MAINKEY(mainKeyMap.get(menu.getMN_MAINKEY()));
			menu.setMN_HOMEDIV_C(m.getMN_KEYNO());
			menu.setMN_URL(changeUrl(menu.getMN_URL(),copyUrl));
			String forwardUrl = menu.getMN_FORWARD_URL();
			if(StringUtils.isNotEmpty(forwardUrl) && forwardUrl.startsWith(oriUrl)) {
				menu.setMN_FORWARD_URL(changeUrl(forwardUrl,copyUrl));
			}
			menu.setMN_REGNM(m.getMN_REGNM());
		}
		
		Component.createDataWithSplitList(null, list, "Menu.AMN_insertList", "list", 50);
		
		HashMap<String,Object> sqlMap = new HashMap<String,Object>();
		sqlMap.put("TableName", "S_MENU_MANAGER");
		sqlMap.put("cnt", ++keyCount);
		Component.updateData("Common.updateTableKey", sqlMap);
		
		
		
	}
	
	private String changeUrl(String url, String tiles) {
		return tiles + url.substring(url.indexOf("/", 1));
	}

	@Override
	public String update(HashMap<String, Object> paramMap, HttpServletRequest req) throws Exception {
		
		HomeManager hm = (HomeManager) paramMap.get("hm");
		Menu Menu = (Menu) paramMap.get("Menu");
		MultipartFile thumbnail = (MultipartFile) paramMap.get("thumbnail"); 
		String[] UIA_KEYNO = (String[]) paramMap.get("UIA_KEYNO"); 
		String[] HAM_DEFAULT_URL = (String[]) paramMap.get("HAM_DEFAULT_URL"); 
		
		
		//메뉴 정보 업데이트
		Component.updateData("HomeManager.MN_updateData", hm);

		if(!hm.getHM_TILES().equals(hm.getTilesBefore())){
			//tiles변경됨에 따라 url 변경
			Component.updateData("HomeManager.MN_updateUrlData", hm);
			Component.updateData("HomeManager.MN_updateForwadUrlData", hm);
		}
		
		if(thumbnail != null && !thumbnail.isEmpty()) {
			String favicon = FileUploadTools.FaviconUpload(thumbnail, hm.getHM_TILES(), hm.getHM_FAVICON());
			hm.setHM_FAVICON(favicon);
		}
		Component.updateData("HomeManager.HM_updateData", hm);
		
		
		//권한별 시작 페이지 설정
		saveStartUrlByAuthority(UIA_KEYNO,HAM_DEFAULT_URL,hm,true);
		
		//저장할때 해당키 수정시간저장
		AdminMenuSessionService.updateTime(Menu.getMN_KEYNO());
		SiteService.setSitePath();
		
		return hm.getHM_KEYNO();
	}
	
	@Override
	public void delete(String HM_KEYNO, HttpServletRequest req) throws Exception {
		HomeManager hm = new HomeManager();
		hm.setHM_KEYNO(HM_KEYNO);
		HomeManager homeManager = Component.getData("HomeManager.HM_getDataByKey",hm);
		
		Component.updateData("HomeManager.HM_deleteData", hm); //homeManager 데이터 삭제
		
		Map<String,Object> user = CommonService.getUserInfo(req);
		hm.setMN_MODNM((String)user.get("UI_KEYNO"));
		
		Component.updateData("HomeManager.MN_deleteDataWithHomeDiv", homeManager); // 해당 모든 하위메뉴들 삭제
		
		
		//관련 권한 삭제
		AdminAuthorityService.deleteDefaultAuthority(HM_KEYNO);
		
		LayoutService.deleteLayout(homeManager.getHM_MN_HOMEDIV_C());
	}

	
	/** 레이아웃 기본 빵틀 만들기
	 * @param hm
	 * @param Menu
	 * @param template
	 * @param req
	 * @throws Exception
	 */
	private void layoutDefault(HomeManager hm, String homeKey, String template, HttpServletRequest req) throws Exception {
		if(StringUtils.isNotEmpty(template)){
			if(!LayoutService.copyLayoutFile(template, hm.getHM_SITE_PATH(), req, homeKey)){
				throw new RuntimeException();
			}
			if(!LayoutService.copyResourceFile("css",template, hm.getHM_SITE_PATH(), req, homeKey)){
				throw new RuntimeException();
			}
			if(!LayoutService.copyResourceFile("js",template, hm.getHM_SITE_PATH(), req, homeKey)){
				throw new RuntimeException();
			}
		}else{
			if(!LayoutService.createLayoutFile(hm.getHM_SITE_PATH(), req, homeKey)){
				throw new RuntimeException();
			}
		}
	}
	
	/**
	 * 권한별 시작 url 설정
	 * @param UIA_KEYNO
	 * @param HAM_DEFAULT_URL
	 * @param hm
	 * @param isUpadte 
	 */
	private void saveStartUrlByAuthority(String[] UIA_KEYNO, String[] HAM_DEFAULT_URL, HomeManager hm, boolean isUpdate) {
		
		if(isUpdate){
			Component.deleteData("HomeManager.HAM_deleteData",hm);
		}
		
		if(UIA_KEYNO != null){
			List<HashMap<String,Object>> list = new ArrayList<HashMap<String,Object>>();
			HashMap<String,Object> map = null;
			for(int i=0;i<UIA_KEYNO.length;i++){
				String hamDefaultUrl = HAM_DEFAULT_URL[i];
				map = new HashMap<String,Object>();
				String tiles = hm.getHM_TILES();
				if("adm".equals(tiles)) tiles = "dyAdmin";
				if(StringUtils.isNotBlank(HAM_DEFAULT_URL[i])) hamDefaultUrl = "/"+tiles+hamDefaultUrl;
				map.put("HAM_DEFAULT_URL", hamDefaultUrl);
				map.put("UIA_KEYNO", UIA_KEYNO[i]);
				list.add(map);
			}
			map = new HashMap<String,Object>();
			map.put("list", list);
			map.put("HM_KEYNO", hm.getHM_KEYNO());
			Component.updateData("HomeManager.HAM_insertData", map);
		}
	}


	


	
	
}
