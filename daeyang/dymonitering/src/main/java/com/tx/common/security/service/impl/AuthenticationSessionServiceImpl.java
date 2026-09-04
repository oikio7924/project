package com.tx.common.security.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mobile.device.Device;
import org.springframework.mobile.device.DeviceUtils;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import com.tx.common.config.tld.SiteProperties;
import com.tx.common.security.service.AuthenticationSessionService;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.homepage.menu.dto.Menu;
import com.tx.dyAdmin.member.dto.UserDTO;
import com.tx.dyAdmin.statistics.dto.CheckAgent;
import com.tx.dyAdmin.statistics.dto.LogDTO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("AuthenticationSessionService")
public class AuthenticationSessionServiceImpl extends EgovAbstractServiceImpl implements AuthenticationSessionService {
	
	/** 공통 컴포넌트 */
	@Autowired
	ComponentService Component;
	@Autowired CommonService CommonService;
	
	
	/**
	 * 회원정보 새로고침
	 * @param currentAuth
	 * @param username
	 * @param req
	 * @return
	 * @throws Exception 
	 */
	@Override
	public Authentication updateAuthentication(Authentication currentAuth, String username, HttpServletRequest req) throws Exception {
       
		UserDTO user = Component.getData("member.selectUserInfo", username);
		user.decode();
        UserDetails newPrincipal = user;
        UsernamePasswordAuthenticationToken newAuth = 
            new UsernamePasswordAuthenticationToken(newPrincipal,currentAuth.getCredentials(),currentAuth.getAuthorities());
        newAuth.setDetails(currentAuth.getDetails());
        UserDTO principal =(UserDTO)newAuth.getPrincipal();
        principal.decode();
		Map<String, Object> map = CommonService.ConverObjectToMap(principal);
		createSession(map,req,false);
        return newAuth;
    }
	
	/**
	 * 유저정보 세션에 저장 및 활동기록,마지막 로그인 일자 저장
	 * @param map
	 * @param request
	 * @param isLogin
	 */
	@Override
	public void createSession(Map<String, Object> map, HttpServletRequest request,boolean isLogin){
		
		map.put("sessionId", request.getSession().getId());
		
		String UIA_NAME = (String)map.get("UIA_NAME");
		Map<String, Object> authority = new HashMap<String,Object>();
		authority.put("authList", UIA_NAME.split(","));
		map.put("isAdmin", Component.getData("Authority.UIA_isAdmin", authority)); //관리자 여부
		String ip = CommonService.getClientIP(request);
		map.put("ip", ip);
		
    	request.getSession().setAttribute("userInfo", map);
    	
    	//로그인 일때만 마지막 로그인 일자와 활동기록을 남긴다. 정보수정일때는 패스
    	if(isLogin){
    		//마지막 로그인 일자 저장
        	Component.updateData("member.UI_updateLastLogin", map);
        	saveLog(request,ip,map);
    	}
	}
	
	/**
	 * 로그인 로그 남기기
	 * @param request
	 * @param ip 
	 * @param map 
	 */
	private void saveLog(HttpServletRequest request, String ip, Map<String, Object> map) {
		LogDTO log = new LogDTO();
		log.setAH_UI_KEYNO((String)map.get("UI_KEYNO"));
    	log.setAH_URL(request.getServletPath());
    	
    	Device device = DeviceUtils.getCurrentDevice(request);
		String DEVICE = "P";
		if(device.isMobile()) {
			DEVICE = getDeviceAorI(request);
		}
		map.put("AH_DEVICE", DEVICE);
    	log.setAH_DEVICE(DEVICE);
    	
    	String URL = request.getServletPath(); 
    	String homeKey = null;
    	try{
    		URL = URL.substring(0,URL.indexOf("/",1));
    	}catch (Exception e) {
			// 처음 / 로 접속시 자동로그인되면 url이 없어서 에러남 siteManager 에서 타일즈 가져오기
    		homeKey = SiteProperties.getString("HOMEPAGE_REP");
    		URL = null;
		}
    	
    	if("/user".equals(URL)) {
			String tiles = (String) request.getSession().getAttribute("currentTiles");				
			if(tiles == null) tiles = "dy";
			URL = "/" + tiles;
		}
    	
    	Menu menu = Menu.builder().MN_URL(URL)
    								.MN_HOMEDIV_C(homeKey)
    								.build();
		//HOMEDIV_C 값 가져오기
		Menu visiterMenu = Component.getData("Menu.AMD_getDataWithUrl", menu);
		
		if(visiterMenu != null){
			String HOMEDIV_C = visiterMenu.getMN_KEYNO();
			log.setAH_HOMEDIV_C(HOMEDIV_C);
			map.put("AH_HOMEDIV_C", HOMEDIV_C);
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
    	log.setAH_DESC("로그인");
    	log.setAH_IP(ip);
    	log.setAH_SESSION(request.getSession().getId());
    	//Component.createData("Log.AH_creatData", log);
	}


	/**
	 * 모바일 기기 값 가져오기
	 * 
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

}
