package com.tx.common.interceptor;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mobile.device.Device;
import org.springframework.mobile.device.DeviceUtils;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.dto.SNS.SNSInfo;
import com.tx.common.security.aes.AES256Cipher;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.storage.service.StorageSelectorService;
import com.tx.dyAdmin.admin.domain.dto.HomeManager;
import com.tx.dyAdmin.admin.keyword.service.KeywordService;
import com.tx.dyAdmin.admin.site.service.SiteService;
import com.tx.dyAdmin.homepage.menu.dto.Menu;
import com.tx.dyAdmin.homepage.menu.service.AdminMenuService;
import com.tx.dyAdmin.homepage.menu.service.AdminMenuSessionService;
import com.tx.dyAdmin.statistics.dto.CheckAgent;
import com.tx.dyAdmin.statistics.dto.LogDTO;
import com.tx.dyAdmin.statistics.service.AdminStatisticsService;

public class UserInterceptor extends HandlerInterceptorAdapter {

	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	@Autowired SiteService SiteService;
	@Autowired AdminStatisticsService AdminStatisticsService;
	@Autowired AdminMenuService AdminMenuService;
	
	/** 메뉴관리 서비스2 */
	@Autowired private AdminMenuSessionService AdminMenuSessionService;
	
	/** 검색 키워드 */
	@Autowired private KeywordService KeywordService;
	
	@Autowired private StorageSelectorService StorageSelector;
	protected final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		checkSessionVal(request);
		if(!checkIpVal(request)){return false;}
		
		return super.preHandle(request, response, handler);
	}
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		
		String URL = request.getRequestURI();
		Menu visiterMenu = null;
		boolean checkMirrorPage = false;
		
		Menu menu = new Menu();
		String menuId = (String)request.getParameter("menuId");
		if(menuId != null){
			menu.setMN_KEYNO(CommonService.getKeyno(menuId, "MN"));
		}
		menu.setMN_URL(URL);
		if(modelAndView != null){
			String viewName = modelAndView.getViewName();
			if(!viewName.startsWith("redirect") && !viewName.startsWith("forward")){ //리다이렉트/포워드 제외
				if(checkUrlFilter(URL,"normal")){
					if(modelAndView.getModel().get("mirrorPage") != null){	// mirrorPage 가 있을경우 현재 url이 아닌 mirrorPage에서 메뉴정보를 가져옴
						
						String mirrorPage = (String)modelAndView.getModel().get("mirrorPage");
						menu.setMN_URL(mirrorPage);
						checkMirrorPage = true;
					}
					
					/**
					 * 현재 메뉴
					 * 1.menuId가 있으면 menuId로 메뉴 조회
					 * 2.mirrorPage가 있으면 mirrorPage 로 메뉴 조회
					 * 3.둘다 없으면 현재 url으로 조회
					 */
					visiterMenu = Component.getData("Menu.AMN_getMenuByURL", menu);
					//현재메뉴 세션에 저장
					setMenuSession(request, visiterMenu);
					
					if(visiterMenu != null){
						//세션 종료시간 세팅
						request.getSession().setMaxInactiveInterval(Integer.parseInt(visiterMenu.getSessionTime())*10000000);
						//QR이미지 있으면 암호화
						if(visiterMenu.getIMG_PATH() != null){
							visiterMenu.setIMG_PATH(AES256Cipher.encode(visiterMenu.getIMG_PATH()));
						}
						if(URL.startsWith("/dyAdmin")){
							adminSetting(request,response,handler,modelAndView,URL,visiterMenu);
						}else{
							userSetting(request,response,handler,modelAndView,URL,visiterMenu);
						}
						
						modelAndView.addObject("domain",CommonService.checkUrl(request));
						
						//팝업 체크
//						checkPopup(request,modelAndView,visiterMenu);
						
					}
				}
				
				
			}
			
		}
		
//		if(checkUrlFilter(URL,"activityHistory")){	//활동기록 
//			//@CheckActivityHistory 어노테이션이 컨트롤러에 사용되었는지 체크함
//			CheckActivityHistory history = ((HandlerMethod) handler).getMethodAnnotation(CheckActivityHistory.class);
//			//CheckActivityHistory 어노테이션이 없음으로 활동기록 남김
//			if(history != null) {
//				if(!checkMirrorPage && visiterMenu == null){
//					visiterMenu = Component.getData("Menu.AMN_getMenuByURL", menu);
//				}
//				
//				setActivityHistoryInfo(visiterMenu,history,request,modelAndView);
//			}
//		}
		
		 super.postHandle(request, response, handler, modelAndView);
	}
	
	/**
	 * 팝업 체크
	 * @param request
	 * @param modelAndView
	 * @param visiterMenu
	 * @throws Exception
	 */
	private void checkPopup(HttpServletRequest request, ModelAndView modelAndView, Menu visiterMenu) throws Exception {
		 //팝업체크 - 쿠키 확인
		Cookie[] cookies = request.getCookies();
		List<String> key_w = new ArrayList<String>();
		List<String> key_b = new ArrayList<String>();
		if (cookies != null) {
		    for (Cookie cookie : cookies) {
		    	if("popup_w".equals(cookie.getName())){
		        	String keys[] = URLDecoder.decode(cookie.getValue(), "UTF-8").split(",");
		        	for(String k : keys){
		        		if(!k.equals("")){
		        			key_w.add(CommonService.getKeyno(k, "PI"));
		        		}
		        	}
		        	modelAndView.addObject("CookieKeys", URLDecoder.decode(cookie.getValue(), "UTF-8"));
		        }
		        if("popup_b".equals(cookie.getName())){
		        	String keys[] = URLDecoder.decode(cookie.getValue(), "UTF-8").split(",");
		        	for(String k : keys){
		        		if(!k.equals("")){
		        			key_b.add(k);
		        		}
		        	}
		        }
		    }
		}
		Map<String,Object> popup = new HashMap<String,Object>();
		popup.put("MN_URL", visiterMenu.getMN_URL());
		if(key_w.size() > 0){
			popup.put("key", key_w);
		}
		//배너가 존재할때
		if(key_b.size() <= 0){
			popup.put("key_b","Y");
		}else {
			popup.put("key_b","N");
		}
		//쿼리문 조회
		List<HashMap<String,Object>> popupList =  Component.getList("Popup.PI_getListWidthURL", popup);
		StorageSelector.getImgPath(popupList);
		//레이아웃, 배너 담을 리스트
		List<HashMap<String,Object>> popupList_W = new ArrayList<HashMap<String,Object>>();
		List<HashMap<String,Object>> popupList_B = new ArrayList<HashMap<String,Object>>();
		
		//팝업 리스트 따로 나눠 담는 작업
		for(HashMap<String,Object> popupData : popupList) {
			String division = (String)popupData.get("PI_DIVISION");
			if("W".equals(division)) {
				popupList_W.add(popupData);
			}else {
				popupList_B.add(popupData);
			}
		}
		if(popupList_W.size() > 0) {
			modelAndView.addObject("popupList_W",popupList_W);
			modelAndView.addObject("popupLayoutPath","/WEB-INF/jsp/user/_common/_Popup/popup_view_W.jsp");
		}
		if(popupList_B.size() > 0) {
			modelAndView.addObject("popupList_B",popupList_B);
			modelAndView.addObject("popupBannerPath","/WEB-INF/jsp/user/_common/_Popup/popup_view_B.jsp");
		}
		
	}
	
	
	/**
	 * 활동기록 
	 * @param visiterMenu
	 * @param history 
	 * @param request 
	 * @param modelAndView 
	 */
	@Transactional
	private void setActivityHistoryInfo(Menu visiterMenu, CheckActivityHistory history, HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		LogDTO log = new LogDTO();
		Map<String, Object> user = CommonService.getUserInfo(request);
    	if(user != null){
    		log.setAH_UI_KEYNO((String)user.get("UI_KEYNO"));
    	}else{
    		log.setAH_UI_KEYNO("비회원");
    	}
    	log.setAH_URL(request.getServletPath());
    	Menu menu = new Menu();
    	menu.setMN_URL(log.getAH_URL());
    	
    	//홈페이지 키 셋팅
		if(visiterMenu != null){
			log.setAH_MENU(visiterMenu.getMN_KEYNO());
			log.setAH_HOMEDIV_C(visiterMenu.getMN_HOMEDIV_C());
		}else{
			String homeDiv = history.homeDiv();
			if(StringUtils.isNotEmpty(homeDiv)){
				log.setAH_HOMEDIV_C(homeDiv);
			}else{
				if(history.type().equals("hashmap")){
					log.setAH_HOMEDIV_C((String)request.getAttribute("homeDiv"));
				}else if(history.type().equals("homeTiles")){
					String AH_HOMEDIV_C = Component.getData("HomeManager.get_HomeKey",(String)request.getAttribute("homeTiles"));
					log.setAH_HOMEDIV_C(AH_HOMEDIV_C);
				}
			}
		}
		
		Device device = DeviceUtils.getCurrentDevice(request);
		if(device.isMobile()) {
			log.setAH_DEVICE(getDeviceAorI(request));
		}else{
			log.setAH_DEVICE("P");
		}
		
		
		
		String agent = request.getHeader("User-Agent");
		
		String Referer = request.getHeader("referer");
		if(Referer == null){
			Referer = "";
		}
		log.setAH_AGENT(agent);
		log.setAH_BROWSER(CheckAgent.getBrowser(agent));
		log.setAH_OS(CheckAgent.getOS(agent));
		log.setAH_REFERER(Referer);
		
		String desc = "";
		
		if(history.type().equals("hashmap")){
			desc = (String)request.getAttribute("desc");
		}else{
			desc = history.desc();
			if(StringUtils.isBlank(desc) && visiterMenu != null) {
				desc = visiterMenu.getMN_NAME() + " 페이지 방문";
    		}
		}
		
		if(StringUtils.isNotEmpty(desc)){
			log.setAH_DESC(desc);
			log.setAH_IP(CommonService.getClientIP(request));
			log.setAH_SESSION(request.getSession().getId());
			Component.createData("Log.AH_creatData", log);
		}
	}
	
	/**
	 * 예외처리할 url 필터 
	 * @param uRL
	 * @param string
	 * @return
	 */
	private boolean checkUrlFilter(String url, String type) {
		if("normal".equals(type)){	//기본 체크
			
            if(	!url.endsWith(".do") 	|| 	
            	url.endsWith("/ajax.do") 			|| 	
            	url.endsWith("Ajax.do")				||
            	url.startsWith("/async/")			||		
            	url.startsWith("/common/") 			||	
            	url.endsWith("/select.do")			||
            	url.endsWith("/insert.do")			||
            	url.endsWith("/update.do") 			||	
            	url.endsWith("/delete.do")		){
            	return false;
            }
		}else if("activityHistory".equals(type)){	//활동기록 체크
			
		}else{
			return false;
		}
		return true;
	}
	
	
	/**
	 * USER쪽 셋팅
	 * @param request
	 * @param response
	 * @param handler
	 * @param modelAndView
	 * @param URL
	 * @param visiterMenu2 
	 */
	private void userSetting(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView, String URL, Menu visiterMenu) throws Exception {
		
		String tiles = URL.split("/")[1];
		if("user".equals(tiles)){
			tiles = (String)modelAndView.getModel().get("tiles");
			if(tiles == null){
				modelAndView.setViewName("/error/error");
				return;
			}
		}
		String tilesUrl = "/"+tiles;
		
		HomeManager homeManager = Component.getData("Menu.AMN_getLayoutTypeByURL", tilesUrl);
		
		//HomeManager 값이 없을경우 에러 처리 
		if(homeManager == null)  {
			modelAndView.setViewName("/error/error");
			return;
		}
		
		// 접속자 수 카운팅
		modelAndView.addObject("VisiterCount", AdminStatisticsService.getSiteVisitorTotalCount(tiles));
		modelAndView.addObject("VisiterCountToday", AdminStatisticsService.getSiteVisitorTodayCount(tiles));
				
		modelAndView.addObject("homeData",homeManager);
		modelAndView.addObject("tilesNm",homeManager.getHM_TILES());
		modelAndView.addObject("currentPath",homeManager.getHM_SITE_PATH());
		modelAndView.addObject("tilesUrl",tilesUrl);
		
		request.getSession().setAttribute("currentTiles", tiles);
		
		setMainMenuList(visiterMenu);
		modelAndView.addObject("currentMenu", visiterMenu );
		
		//menuList 설정
		setMenuList(request,tilesUrl,visiterMenu);
		
		// 타일즈 구분자 부착 (DB 에서 구분 코드 읽어옴 HM_TILES)
		setTiles(modelAndView);
		
		if("Y".equals(visiterMenu.getMN_RESEARCH())){
			modelAndView.addObject("researchPath","/WEB-INF/jsp/user/_common/_Research/prc_page_research.jsp"); 
		}
		
		//게시판 권한 처리
		if(visiterMenu.getMN_PAGEDIV_C().equals(SettingData.MENU_TYPE_BOARD)){
			modelAndView.addObject("boardAuthList",getBoardAuthList(request,visiterMenu.getMN_URL())); 
		}
		
		//키워드 셋팅
		if(request.getSession().getAttribute("keywordList") == null){
			request.getSession().setAttribute("keywordList", KeywordService.getKeywordList());
		}
		
		//css,js 조회
		getResource(modelAndView,homeManager.getHM_SITE_PATH(),visiterMenu);
		
		//SNSInfo 설정
//		setSNSInfo(modelAndView,visiterMenu,homeManager,request);
		
		
	}
	
	private void setMainMenuList(Menu visiterMenu) {
		// TODO Auto-generated method stub
		HashMap<String,Object> mainMenuList = Component.getData("Menu.AMN_getMainMenuNames",visiterMenu.getMN_KEYNO()); 
		visiterMenu.setMN_MAINKEYS((String)mainMenuList.get("MN_MAINKEYS"));
		visiterMenu.setMN_MAINNAMES((String)mainMenuList.get("MN_MAINNAMES"));
	}
	/**
	 * menuList 설정
	 * 세션에 저장해두고 갱신이 필요할때만 다시 불러온다.
	 * @param request
	 * @param tilesUrl
	 * @param visiterMenu
	 * @throws Exception
	 */
	private void setMenuList(HttpServletRequest request, String tilesUrl, Menu visiterMenu) throws Exception {
		
		Map<String,Object> user = CommonService.getUserInfo(request);
		
		request.setAttribute("menuList", AdminMenuSessionService.getMenuList(tilesUrl,user, visiterMenu.getMN_HOMEDIV_C()));
		
	}
	
	/**
	 * 타일즈 설정
	 * @param modelAndView
	 */
	private void setTiles(ModelAndView modelAndView) {
		String viewName = modelAndView.getViewName();
		if(viewName.indexOf(".") == -1){
			viewName = viewName + ".user";
		}else{
			String tiles = viewName.split("\\.")[1];
			if("none".equals(tiles)){	// none 은 아무것도 적용 안할 시 
				viewName = viewName.split("\\.")[0];
			} else if("notiles".equals(tiles)){	// notiles는 css,script 적용 시 
				viewName = viewName.split("\\.")[0] + ".notiles";
			} else if("en".equals(tiles)){	//
				viewName = viewName.split("\\.")[0] + ".en";
			} 
		}
		modelAndView.setViewName(viewName);
	}
	/**
	 * css,js 파일 가져오기
	 * @param modelAndView
	 * @param visiterMenu 
	 * @param tiles 
	 */
	private void getResource(ModelAndView modelAndView, String path, Menu visiterMenu) {
		Map<String,Object> RMmap = new HashMap<String,Object>();
		List<Object> scopeList = new ArrayList<Object>();
		
		if(visiterMenu.getMN_LEV() == 0){
			scopeList.add("main");
			RMmap.put("scopeList", scopeList);
		}else if(visiterMenu.getMN_PAGEDIV_C().equals(SettingData.MENU_TYPE_BOARD)){
			scopeList.add("board");
			scopeList.add("sub");				
		}else{
			scopeList.add("sub");				
		}
		scopeList.add("common");
		RMmap.put("path", path);
		RMmap.put("MN_KEYNO", visiterMenu.getMN_KEYNO());
		RMmap.put("scopeList", scopeList);
		
		modelAndView.addObject("ResourcesList", Component.getList("Resources.getTilesList", RMmap));
				
	}
	/**
	 * SNS 메타태그 값 셋팅 + title도 SNSInfo의 TITLE 값을 사용한다.
	 * @param modelAndView
	 * @param hm 
	 * @param visiterMenu 
	 */
	private void setSNSInfo(ModelAndView modelAndView, Menu visiterMenu, HomeManager homeManager, HttpServletRequest request) {
		//SNSInfo 체크 layout.jsp에서 메타 태그 및 title 태그에 쓰임
		SNSInfo SNSInfo =  (com.tx.common.dto.SNS.SNSInfo) modelAndView.getModel().get("SNSInfo");
		
		if(SNSInfo == null) SNSInfo = new SNSInfo();
		
		Integer lev = visiterMenu.getMN_LEV();
		
		if(SNSInfo.getTITLE() == null){
			if(lev == 0){
				SNSInfo.setTITLE(homeManager.getHM_TITLE());
			}else{
				SNSInfo.setTITLE(visiterMenu.getMN_NAME());
			}
		}
		
		if(lev == 0){
			if(!StringUtils.isEmpty(homeManager.getHM_META_DESC())){
				SNSInfo.setDescription(homeManager.getHM_META_DESC());
			}
			if(!StringUtils.isEmpty(homeManager.getHM_META_KEYWORD())){
				SNSInfo.setKeywords(homeManager.getHM_META_KEYWORD());
			}
		}else{
			if(SettingData.MENU_TYPE_BOARD.equals(visiterMenu.getMN_PAGEDIV_C())){
				
				if(!StringUtils.isEmpty(visiterMenu.getMN_META_KEYWORD())){
					SNSInfo.setKeywords(visiterMenu.getMN_META_KEYWORD());
				}
				
				if(request.getServletPath().endsWith("view.do")){
					if(!StringUtils.isEmpty(visiterMenu.getMN_META_DESC())){
						SNSInfo.setDescription(visiterMenu.getMN_META_DESC());
					}
				}
				
			}else {
				if(!SettingData.MENU_TYPE_SUBMENU.equals(visiterMenu.getMN_PAGEDIV_C()) ||
						(SettingData.MENU_TYPE_SUBMENU.equals(visiterMenu.getMN_PAGEDIV_C()) && StringUtils.isNotEmpty(visiterMenu.getMN_FORWARD_URL()))){
					if(!StringUtils.isEmpty(visiterMenu.getMN_META_DESC())){
						SNSInfo.setDescription(visiterMenu.getMN_META_DESC());
					}
					
					if(!StringUtils.isEmpty(visiterMenu.getMN_META_KEYWORD())){
						SNSInfo.setKeywords(visiterMenu.getMN_META_KEYWORD());
					}
				}
			}
		}
		
		if(StringUtils.isEmpty(SNSInfo.getIMG())){
			SNSInfo.setIMG(SiteProperties.getString("SNS_IMAGE"));
		}
		
		modelAndView.addObject("SNSInfo", SNSInfo);
	}
	/**
	 * 게시판 서브 권한 리스트 겟
	 * @param req 
	 * @param mn_URL
	 * @return
	 */
	@SuppressWarnings("unchecked")
	private Map<String,Boolean> getBoardAuthList(HttpServletRequest req, String URL) throws Exception {
		
		List<Map<String,String>> authList = Component.getList("Authority.UIA_GetListwidthUrl",URL);
		Map<String,String> map = null;
		Map<String,Boolean> boardAuthList = new HashMap<String,Boolean>();
		Map<String,Object> user = CommonService.getUserInfo(req);
		String userAuth[] = null;
		if(user != null && user.get("UIA_NAME") != null){
			userAuth =((String)user.get("UIA_NAME")).split(","); 
		}else{
			userAuth =new String[]{"ANONYMOUS"}; // 정보가 없으면 비회원 권한 셋팅
		}
		
		for(Object a : authList){
			boolean state = false;
			map = (Map<String,String>)a;
			
			//개발자 권한은 무조건 true
			for(String auth1 : userAuth){
				if("개발자".equals(auth1)){
					state = true;
					break;
				}
			}
			
			//개발자 권한이 아닐때
			if(!state){
				String list = map.get("AUTHORITY_LIST");
				if(list != null){
					
					//유저의 권한과 해당 게시판의 권한을 비교
					for(String auth1 : userAuth){
						for(String auth2 : list.split(",")){
							if(auth1.equals(auth2)){
								state = true;
								break;
							}
						}
						if(state) break;
					}
				}
			}
			boardAuthList.put(map.get("UIR_NAME"), state);
		}
		
		return boardAuthList;
	}
	
	/**
	 * ADMIN 쪽 셋팅
	 * @param request
	 * @param response
	 * @param handler
	 * @param modelAndView
	 * @param URL
	 * @param adminMenuByURL 
	 * @throws Exception 
	 */
	private void adminSetting(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView, String URL, Menu adminMenuByURL) throws Exception {
		
			Map<String,Object> user = CommonService.getUserInfo(request);
		
			Menu menu = Menu.builder()
					.MN_HOMEDIV_C(SettingData.HOMEDIV_ADMIN)
					.MN_URL(URL)
					.MN_FORWARD_URL(URL)
					.MN_SHOW_YN("Y")
					.build();
			
			
			setMainMenuList(adminMenuByURL);
			modelAndView.addObject("currentMenu", adminMenuByURL);
				
			/* 메뉴 전체정보 저장 - 메뉴UI 구현 */
			List<Menu> adminMenuList = Component.getList("Menu.AMN_getUserMenuListByHOMEDIV", menu);
			
			//홈페이지관리 메뉴 권한 체크
			checkAdminAuth(adminMenuList,user,request);
			
			modelAndView.addObject("adminMenuList", adminMenuList);
			
            //홈페이지 구분 리스트
			getHeaderHomeDivList(modelAndView,user);
            

	}
	
	private void checkAdminAuth(List<Menu> adminMenuList, Map<String, Object> user, HttpServletRequest request) {
		String SITE_KEYNO = (String)request.getSession().getAttribute("SITE_KEYNO");
		String UIA_KEYNO = (String)user.get("UIA_KEYNO");
		
		HashMap<String,Object> sqlMap = new HashMap<String,Object>();
		sqlMap.put("UIA_KEYNO", UIA_KEYNO);
		sqlMap.put("HM_KEYNO", SITE_KEYNO);
		
		List<HashMap<String,Object>> list = Component.getList("Authority.UAA_getAdminAuthMenuList",sqlMap);
		
		
		if(StringUtils.isEmpty(SITE_KEYNO)) {
			for(HashMap<String,Object> data : list) data.put("adminAuth", "N");
		}else if(SettingData.AUTHORITY_ADMIN.equals(UIA_KEYNO)) {
			for(HashMap<String,Object> data : list) data.put("adminAuth", "Y");
		}
		
		for(Menu adminMenu	: adminMenuList) {
			boolean checkAdminAuth = false;
			for(HashMap<String,Object> data : list) {
				String key = data.get("MN_KEYNO").toString();
				if(key.equals(adminMenu.getMN_KEYNO())) {
					adminMenu.setAdminAuth(data.get("adminAuth").toString());
					checkAdminAuth = true;
					break;
				}
			}
			if(!checkAdminAuth) adminMenu.setAdminAuth("Y");
		}
		
		
	}
	
	private void getHeaderHomeDivList(ModelAndView modelAndView, Map<String, Object> user) {
		// TODO Auto-generated method stub
		
		String UIA_KEYNO = (String)user.get("UIA_KEYNO");
		
		if(SettingData.AUTHORITY_ADMIN.equals(UIA_KEYNO)) {
			modelAndView.addObject("headerHomeDivList",CommonService.getHomeDivCode(false));
		}else {
			HashMap<String,Object> sqlMap = new HashMap<String,Object>();
			sqlMap.put("UIA_KEYNO", user.get("UIA_KEYNO"));
			sqlMap.put("MN_URL", SettingData.ADMINPAGE_HOMEPAGE_MANAGER_URL);
			
			modelAndView.addObject("headerHomeDivList", Component.getList("Authority.getManageableDomain", sqlMap));
		}
		
		
		
	}
	/**
	 * 모바일 기기 값 가져오기
	 * @param req
	 * @return I or A
	 */
	private String getDeviceAorI(HttpServletRequest req) {
		String header = req.getHeader("User-Agent");

		if (header != null) {
			if (header.indexOf("iPhone") > -1) {
				header = "I";

			} else if (header.indexOf("Android") > -1) {
				header = "A";

			}
		}
		return header;
	}
	
	/**
	 * ip를 체크한다
	 * */
	private boolean checkIpVal(HttpServletRequest request) {
		Map<String, Object> user = CommonService.getUserInfo(request);
		if(user != null){
			String ip = CommonService.getClientIP(request);
			String userIp = (String)user.get("ip");

			//모바일은 브라우저에 따라 ip가 달라진다?
			String userAgent = request.getHeader("user-agent");
			boolean mobile1 = userAgent.matches( ".*(Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson).*");
			boolean mobile2 = userAgent.matches(".*(LG|SAMSUNG|Samsung).*"); 
			boolean kakao = userAgent.matches( ".*(iPhone|iPod|Kakao).*");
			
			if(!kakao && !mobile1 && !mobile2) {
				if(!ip.equals(userIp)){	//ip를 비교해서 ip가 다르다면 팅겨낸다.
					return false;
				}
			}

		}
		return true;
	}

	/**
	 * 세션/쿠키를 체크한다
	 * */
	private void checkSessionVal(HttpServletRequest request) throws UnsupportedEncodingException {
		
		
		//세션에 값이 있나 체크
		String SITE_KEYNO = (String)request.getSession().getAttribute("SITE_KEYNO");
		String SITE_NAME = (String)request.getSession().getAttribute("SITE_NAME");
		if(StringUtils.isAnyEmpty(SITE_KEYNO,SITE_NAME)){
			Cookie[] cookies = request.getCookies();  // 쿠키 조회하기
			if(cookies != null){
				for(Cookie cookie1:cookies){
					if("siteVal".equals(cookie1.getName())){
						String cookieVal = URLDecoder.decode(cookie1.getValue(), "UTF-8");
						if(StringUtils.isNotBlank(cookieVal)){
							SITE_KEYNO = CommonService.getKeyno(cookieVal.split("\\|")[0],"MN");
							SITE_NAME = cookieVal.split("\\|")[1];
						}else{
							SITE_KEYNO = "";	
							SITE_NAME = "";						
						}
						SiteService.setSessionVal(request, SITE_KEYNO, SITE_NAME);
						break;
					}
				}
			}
		}
	}


	
	public void setMenuSession(HttpServletRequest req, Menu menu) {
		req.getSession().setAttribute("Menu", menu);
	}
	
}
