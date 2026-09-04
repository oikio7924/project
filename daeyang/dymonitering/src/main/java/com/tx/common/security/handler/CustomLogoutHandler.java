package com.tx.common.security.handler;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;

import com.tx.common.config.session.CustomSessionRegistry;
import com.tx.common.security.rememberMe.CustomTokenBasedRememberMeServices;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.member.dto.UserDTO;
import com.tx.dyAdmin.statistics.dto.CheckAgent;
import com.tx.dyAdmin.statistics.dto.LogDTO;

public class CustomLogoutHandler extends SecurityContextLogoutHandler {
	
	protected final Log logger = LogFactory.getLog(CustomLogoutHandler.class);
	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	@Autowired
    private CustomSessionRegistry sessionRegistry;
	
	@Autowired
	private CustomTokenBasedRememberMeServices rememberMeServices;
	
	public void logout(HttpServletRequest request, HttpServletResponse response, Authentication authentication) {
		
		//로그아웃 커스텀 
		if(authentication != null){
			
			sessionRegistry.removeSessionInformation(request.getSession().getId());
			
			rememberMeServices.cancelCookie(request,response);
			UserDTO principal = (UserDTO) authentication.getPrincipal();
			Map<String, Object> user = CommonService.getUserInfo(request);
			
			if(user != null){
				String url = request.getServletPath();
				
				LogDTO log = new LogDTO();
				log.setAH_UI_KEYNO(principal.getUI_KEYNO());
				log.setAH_URL(url);
				
				String agent = request.getHeader("User-Agent");
				String Referer = request.getHeader("referer");
				if(Referer == null){
					Referer = "";
				}
				log.setAH_AGENT(agent);
				log.setAH_BROWSER(CheckAgent.getBrowser(agent));
				log.setAH_OS(CheckAgent.getOS(agent));
				log.setAH_REFERER(Referer);
				
				log.setAH_DESC("로그아웃");
				log.setAH_IP((String)user.get("ip"));
				log.setAH_SESSION(request.getSession().getId());
				log.setAH_DEVICE((String) user.get("DEVICE"));
				
				String HOMEDIV_C = (String) request.getSession().getAttribute("AH_HOMEDIV_C");
				log.setAH_HOMEDIV_C(HOMEDIV_C);
				Component.createData("Log.AH_creatData", log);
				request.getSession().setAttribute("checkLogout", "Y");
				if(logger.isDebugEnabled()){
        			logger.debug("로그아웃  :: " + request.getSession().getId());
        		}
			}
			
			
			
		}
		
		
		super.logout(request, response, authentication);
		
		
	}

	public void logoutTimeout(Map<String, Object> user, String sessionId) {
		LogDTO log = new LogDTO();
		log.setAH_UI_KEYNO(user.get("UI_KEYNO").toString());
		log.setAH_URL("/logout");
		log.setAH_DESC("로그아웃 - timeout");
		log.setAH_IP((String)user.get("ip"));
		log.setAH_SESSION(sessionId);
		log.setAH_DEVICE((String) user.get("DEVICE"));
		log.setAH_HOMEDIV_C((String)user.get("AH_HOMEDIV_C"));
		Component.createData("Log.AH_creatData", log);
		if(logger.isDebugEnabled()){
			logger.debug("로그아웃 - timeout :: " + sessionId);
		}
	}
	
}
