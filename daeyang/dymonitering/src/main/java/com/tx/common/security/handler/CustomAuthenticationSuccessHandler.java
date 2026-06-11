package com.tx.common.security.handler;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.WebAttributes;
import org.springframework.security.web.access.DefaultWebInvocationPrivilegeEvaluator;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.util.StringUtils;

import com.tx.common.config.SettingData;
import com.tx.common.config.session.CustomSessionRegistry;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.security.rememberMe.CustomTokenBasedRememberMeServices;
import com.tx.common.security.service.AuthenticationSessionService;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.admin.site.dto.SiteManagerDTO;
import com.tx.dyAdmin.member.dto.UserDTO;

import lombok.Data;

@Data
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

	/** 공통 컴포넌트 */
	@Autowired
	ComponentService Component;
	@Autowired CommonService CommonService;
	
	@Autowired
    private CustomSessionRegistry sessionRegistry;
	
	@Autowired
	private AuthenticationSessionService AuthenticationSessionService;
	
	@Autowired
	private DefaultWebInvocationPrivilegeEvaluator webInvocationPrivilegeEvaluator;
	
	@Autowired
	private CustomTokenBasedRememberMeServices rememberMeServices;

	private String defaultUrl;
	
	private RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();

	public CustomAuthenticationSuccessHandler() {
		defaultUrl = "/";
	}

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		
        //세션 시간 설정
        request.getSession().setMaxInactiveInterval(SettingData.SESSION_DURATION);

		// 세션에 userInfo map으로 저장
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		Object principal = auth.getPrincipal();
		UserDTO user = (UserDTO)principal;
		
		user.decode();
		Map<String, Object> map = null;
		try {
			map = CommonService.ConverObjectToMap(principal);
		} catch (Exception e) {
			System.out.println("map 변환 에러");
		}
		if (principal != null && principal instanceof UserDTO) {
			AuthenticationSessionService.createSession(map,request,true);
		}

		clearAuthenticationAttributes(request);
		// 다음 이동할 페이지
		String returnUrl = decideRedirectUrl(request, response,map,authentication);
		
		
		sessionRegistry.registerNewSession(request.getSession(), principal);
		
		rememberMeServices.loginSuccess(request, response, authentication);
		
		
		redirectStrategy.sendRedirect(request, response, returnUrl);
		
	}
	

	private void clearAuthenticationAttributes(HttpServletRequest request) {
		HttpSession session = request.getSession(false);

		if (session == null) {
			return;
		}

		session.removeAttribute(WebAttributes.AUTHENTICATION_EXCEPTION);
	}


	/**
	 * 인증 성공후 어떤 URL로 redirect 할지를 결정한다 
	 * @param authentication 
	 */
	private String decideRedirectUrl(HttpServletRequest request, HttpServletResponse response, Map<String, Object> map, Authentication authentication) {

		String URL = request.getServletPath(); 
		URL = "/"+URL.split("/")[1];
		
		if("/user".equals(URL)) {
			String tiles = (String) request.getSession().getAttribute("currentTiles");
			if(tiles == null) tiles = "dy";
			URL = "/" + tiles;
		}
		
		// 1. 최초 제품 설치시 비밀번호 초기화
		//if(checkPwdInit(map,URL)) return "/dyAdmin/login/init.do";
		
		// 2. 비밀번호 변경주기 체크
		//if(vertifyPasswordCycle((String)map.get("UI_KEYNO"),URL)) return URL + "/member/pwdchange2.do"; 
		
		// 3. returPage 체크
		String returnPage = getReturnPage(request,URL,authentication); 
		if(returnPage != null) return returnPage;
		
		// 4. 권한별 시작 url 체크
		String returnUrlByAuth = checkUrlByAuth((String)map.get("UIA_KEYNO"),URL,authentication);
		if(returnUrlByAuth != null) {
			return returnUrlByAuth;
		}
		
		// 5. referrer 체크
		//String referrerPage =  checkReferrer(request); 
		//if(referrerPage != null) return referrerPage;
			
		
		
		//위쪽 필터에서 걸리지 않고 여기까지 오면 각 홈페이지 기본 url 인 /index.do 를 붙여서 리턴한다.
		return URL + "/index.do";
	}
	
	private String checkReferrer(HttpServletRequest request) {
		
		String referrerPage = (String)request.getSession().getAttribute("referrerPage");
		if(referrerPage != null) {
			request.getSession().removeAttribute("referrerPage");
			URL netUrl;
			try {
				netUrl = new URL(referrerPage);
				if(request.getServerName().equals(netUrl.getHost())) {
					return referrerPage;
				}
			} catch (MalformedURLException e) {
			}
		}
		return null;
	}

	
	/**
	 * @param request
	 * @param URL
	 * @param authentication 
	 * @return
	 */
	private String getReturnPage(HttpServletRequest request, String URL, Authentication authentication) {
		// TODO Auto-generated method stub
		String returnPage = null;
		String page = (String)request.getSession().getAttribute("returnPage");
		if(page == null) return null;
		
		request.getSession().removeAttribute("returnPage");
		if("main".equals(page)) {
			returnPage =  URL + "/index.do";
		}
		
		if(returnPage != null && webInvocationPrivilegeEvaluator.isAllowed(returnPage, authentication)) return returnPage;
		
		return null;
	}
	
	/**
	 * 권한별 시작 url 체크
	 * @param UIA_KEYNO
	 * @param uRL
	 * @param authentication
	 * @return
	 */
	private String checkUrlByAuth(String UIA_KEYNO, String URL, Authentication authentication) {
		// TODO Auto-generated method stub
		String returnUrl = null;
		
		try{
			if(StringUtils.hasText(UIA_KEYNO)){
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("URL", URL);
				map.put("UIA_KEYNO", UIA_KEYNO.split(",")[0]);
				
				returnUrl = Component.getData("HomeManager.HAM_getTargetUrl",map);
				if(StringUtils.hasText(returnUrl) && webInvocationPrivilegeEvaluator.isAllowed(returnUrl, authentication)){
					return returnUrl;
				}
			}
		}catch (Exception e) {
			System.out.println(getClass().getName() + " :: " + "권한 설정 에러");
		}
		
		return null;
	}

	/**
	 * 제품설치후 최초 로그인 여부.
	 * @param map
	 * @param URL 
	 * @return
	 */
	private boolean checkPwdInit(Map<String, Object> map, String URL) {
		// TODO Auto-generated method stub
		
		String UI_PWD_INIT = (String)map.get("UI_PWD_INIT");
		
		return "Y".equals(UI_PWD_INIT) && "/dyAdmin".equals(URL);
	}

	/**
	 * 비밀번호 변경주기 체크
	 * @param UI_KEYNO
	 * @param URL
	 * @return
	 */
	private boolean vertifyPasswordCycle(String UI_KEYNO, String URL) {
		
		if("/dyAdmin".equals(URL)) return false;
		
		
		SiteManagerDTO SiteManagerDTO =  Component.getData("SiteManager.getData",SiteProperties.getCmsUser());
		if(StringUtils.isEmpty(SiteManagerDTO.getPASSWORD_CYCLE())) {
			return false;
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("UI_KEYNO", UI_KEYNO);
		map.put("PASSWORD_CYCLE", SiteManagerDTO.getPASSWORD_CYCLE());
		
		HashMap<String, Object> checkInfo = Component.getData("member.vertifyPWCycle", map);
		String CK = checkInfo.get("CK").toString();
		// 변경주기 지남: 1, 안지남: 0
		return CK.equals("1") ? true : false;
	}

}
