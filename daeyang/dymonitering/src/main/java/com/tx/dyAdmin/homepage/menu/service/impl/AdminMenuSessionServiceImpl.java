package com.tx.dyAdmin.homepage.menu.service.impl;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.access.DefaultWebInvocationPrivilegeEvaluator;
import org.springframework.stereotype.Service;

import com.tx.common.config.SettingData;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.admin.domain.dto.HomeManager;
import com.tx.dyAdmin.homepage.menu.dto.Menu;
import com.tx.dyAdmin.homepage.menu.service.AdminMenuSessionService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * AdminMenuSessionServiceImpl
 * 
 * @author 이혜주
 * @version 1.0
 * @since 2019-06-14
 */
@Service("AdminMenuSessionService")
public class AdminMenuSessionServiceImpl extends EgovAbstractServiceImpl implements AdminMenuSessionService {

	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	
	@Autowired
	private DefaultWebInvocationPrivilegeEvaluator webInvocationPrivilegeEvaluator;
	
	private HashMap<String,Calendar> lastUpdateMenu = new HashMap<String,Calendar>();
	
	private HashMap<String,HashMap<String, Object>> menuListMap = new HashMap<>();
	
	
	@PostConstruct
	public void init() throws Exception{
		updateTime();
	}
	
	//시간저장
	public void updateTime(String homeDiv) throws Exception {
		lastUpdateMenu.put(homeDiv,Calendar.getInstance());
	}
	
	public void updateTime() throws Exception {
		List<HomeManager> homelist = Component.getListNoParam("HomeManager.HM_getList");
		for (HomeManager homeManager : homelist) {
			lastUpdateMenu.put(homeManager.getHM_MN_HOMEDIV_C(),Calendar.getInstance());
		}
	}
	
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Menu> getMenuList(String tilesUrl, Map<String, Object> user, String homeDiv) throws Exception {
		
		
		String UIA_KEYNO = (user == null) ? SettingData.AUTHORITY_ANONYMOUS : (String) user.get("UIA_KEYNO") ;
		
		String menuMapKey = UIA_KEYNO + tilesUrl;
		
		HashMap<String, Object> menuMap = menuListMap.get(menuMapKey);
		
		if(menuMap == null) {
			menuMap = setMenuList(tilesUrl, UIA_KEYNO);
		} else {
			Calendar saveTime = (Calendar)menuMap.get("saveTime");
			Calendar updateTime = lastUpdateMenu.get(homeDiv);
			if(saveTime.compareTo(updateTime) < 0 ) {
				menuMap = setMenuList(tilesUrl, UIA_KEYNO);
			}
		}
		
		
		return (List<Menu>) menuMap.get("menuList");
	}

	private HashMap<String, Object> setMenuList(String tilesUrl, String UIA_KEYNO) {
		
		HashMap<String, String> map = new HashMap<>();
		map.put("MN_URL", tilesUrl);
		map.put("UIA_KEYNO",UIA_KEYNO);
		
		List<Menu> menuList = Component.getList("Menu.AMN_getUserMenuListByHOMEDIV2", map);
		
		//권한 체크해서 권한 없는 메뉴는 삭제
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		
		for(Iterator<Menu> it = menuList.iterator() ; it.hasNext() ; ) {
			Menu m = it.next();
			
			if(!webInvocationPrivilegeEvaluator.isAllowed(m.getMN_URL(), authentication)) {
				if(SettingData.AUTHORITY_ANONYMOUS.equals(UIA_KEYNO)){
					m.setAuthStatus("noLogin");
				}else{
					m.setAuthStatus("noAuth");
				}
			}
		}
		
		for(Menu menu : menuList) {
			String type = null, url = null, authStatus = null;
			if(SettingData.MENU_TYPE_SUBMENU.equals(menu.getMN_PAGEDIV_C())) {
				HashMap<String,Object> menuAction = getFirstChild(menu,menuList);
				type = (String)menuAction.get("type");
				url = (String)menuAction.get("url");
				authStatus  = (String)menuAction.get("authStatus");
			}else {
				String linkType = menu.getMN_NEWLINK(); // 현재창 새창 여부 가져오기
				String pageDiv = menu.getMN_PAGEDIV_C(); // 페이지의 형태
				
				if(pageDiv.equals(SettingData.MENU_TYPE_LINK)){ // 페이지의 형태 : 링크형일때 
					type = "Y".equals(linkType) ? "window" : "default";
					url = menu.getMN_FORWARD_URL();
				}else if(pageDiv.equals(SettingData.MENU_TYPE_PREPARING)){ // 페이지의 형태 : 준비중일때
					type = "preparing";
				}else {
					type = "Y".equals(linkType) ? "window" : "default";
					url = menu.getMN_URL();
				}
				
				authStatus = menu.getAuthStatus();
			}
			
			if("noAuth".equals(authStatus)) {
				menu.setHref("javascript:alert('접근권한이 없습니다.');");
				menu.setTarget("_self");
			}else if("noLogin".equals(authStatus)) {
				menu.setHref("javascript:cf_confirmLogin();");
				menu.setTarget("_self");
			}else {
				switch (type) {
				case "default":
					menu.setHref(url);
					menu.setTarget("_self");
					break;
				case "window":
					menu.setHref(url);
					menu.setTarget("_blank");
					break;
				case "preparing":
					menu.setHref("javascript:alert('준비중입니다.');");
					menu.setTarget("_self");
					break;
				default:
					menu.setHref("javascript:alert('이동 가능한 하위메뉴가 없습니다.');");
					menu.setTarget("_self");
					break;
				}
			}
		}
		
		HashMap<String, Object> menuMap = new HashMap<String,Object>();
		menuMap.put("menuList", menuList);
		menuMap.put("saveTime", Calendar.getInstance());
		
		menuListMap.put(UIA_KEYNO + tilesUrl, menuMap);
		
		return menuMap;
	}
	
	@SuppressWarnings("unchecked")
	private HashMap<String,Object> getFirstChild(Menu menu, List<Menu> menuList) { 
		
		HashMap<String,Object> reserveList = new HashMap<String,Object>();
		
		if(menuList != null && menuList.size() > 0){
	
			if(StringUtils.isNotEmpty(menu.getMN_FORWARD_URL())){
				return getResultMap("default",menu.getMN_FORWARD_URL(),menu.getAuthStatus());
			}
			HashMap<String,Object> resultMap = getFirstChildUrl(menu,menuList,reserveList); // resultMap에 대메뉴 클릭 했을시 나올 우선순위 메뉴를 선정한다. 
			if("none".equals(resultMap.get("type"))) {
				if(reserveList.get("second") != null) return (HashMap<String, Object>) reserveList.get("second"); 
				if(reserveList.get("third") != null) return (HashMap<String, Object>) reserveList.get("third"); 
			}
			return resultMap;
		}else{
			return getResultMap("none",null,null);
		}
	}
	
	private HashMap<String,Object> getFirstChildUrl(Menu menu, List<Menu> menuList, HashMap<String,Object> reserveList) {
		for(Menu m : menuList ){
			if(menu.getMN_KEYNO().equals(m.getMN_MAINKEY())){
				
				
				String linkType = m.getMN_NEWLINK(); // 현재창 새창 여부 가져오기
				String pageDiv = m.getMN_PAGEDIV_C(); // 페이지의 형태
				
				if(pageDiv.equals(SettingData.MENU_TYPE_SUBMENU)){  // 페이지의 형태 : 소메뉴일 때
					if(StringUtils.isNotEmpty(m.getMN_FORWARD_URL())){
						return getResultMap("default",m.getMN_FORWARD_URL(),m.getAuthStatus());
					}
					return getFirstChildUrl(m,menuList,reserveList);
				}else if(pageDiv.equals(SettingData.MENU_TYPE_LINK)){ // 페이지의 형태 : 링크형일때 
					setMap(reserveList,"second",m.getMN_FORWARD_URL(), "Y".equals(linkType) ? "window" : "default",m.getAuthStatus()); //resurveList 에 우선순위를 담아준다.
					continue;
				}else if(pageDiv.equals(SettingData.MENU_TYPE_PREPARING)){ // 페이지의 형태 : 준비중일때
					setMap(reserveList,"third","", "preparing",m.getAuthStatus());
					continue;
				}else if("Y".equals(linkType)) {
					setMap(reserveList,"second",m.getMN_URL(), "window",m.getAuthStatus());
					continue;
				}else {
					return getResultMap("default",m.getMN_URL(),m.getAuthStatus());
				}
			}
		}
		return getResultMap("none",null,null);
		
	}
	
	private void setMap(HashMap<String, Object> reserveList, String order, String url, String type,String authStatus) {
		// TODO Auto-generated method stub
		
		if(reserveList.get(order) == null) { //처음 reseveList, 우선순위 없을때 맨 처음 걸로  고정한다. (ex 메뉴 우선순위 정할때 소메뉴에서 메뉴리스트가 전부 링크형이면, 처음 오는 링크형으로 우선순위를 고정한다.) 
			reserveList.put(order, getResultMap(type,url,authStatus));
		}
	}
	
	private HashMap<String,Object> getResultMap(String type, String url, String authStatus){
		HashMap<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("type", type);
		resultMap.put("url",url);
		resultMap.put("authStatus",authStatus);
		
		return resultMap;
	}

}
