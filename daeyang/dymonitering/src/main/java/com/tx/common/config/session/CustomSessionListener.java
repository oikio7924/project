package com.tx.common.config.session;

import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.tx.common.security.handler.CustomLogoutHandler;

public class CustomSessionListener implements HttpSessionListener {
	
	protected final Log logger = LogFactory.getLog(CustomSessionListener.class);
	
	
	private CustomSessionRegistry sessionRegistry;
	
	private CustomLogoutHandler CustomLogoutHandler;
	
    public void sessionCreated(HttpSessionEvent sessionEvent) {

//         생성된 세션을 받습니다.
//        HttpSession session = sessionEvent.getSession();
    	
    	
    }

    public void sessionDestroyed(HttpSessionEvent sessionEvent) {
    	
    	if(sessionRegistry == null){
    		getSessionRegistry(sessionEvent);
    		if(logger.isDebugEnabled()){
    			logger.debug("sessionRegistry 주입  :: " + sessionRegistry);
    		}
    	}
    	
    	// 사라질 세션을 받습니다.
        HttpSession session = sessionEvent.getSession();
    	
    	sessionRegistry.removeSessionInformation(session.getId());
        
        String checkLogout = (String) session.getAttribute("checkLogout");
        if(!"Y".equals(checkLogout)){
        	@SuppressWarnings("unchecked")
			Map<String, Object> user = (Map<String, Object>) session.getAttribute("userInfo");
        	if(user != null){
        		connectDB(user,session.getId(),sessionEvent);
        	}
        }
        
        
    }
    
    private void getSessionRegistry(HttpSessionEvent event) {
		HttpSession session = event.getSession();
		WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
		sessionRegistry = (CustomSessionRegistry) ctx.getBean("sessionRegistry");
	}
    
    private void getCustomLogoutHandler(HttpSessionEvent event) {
    	HttpSession session = event.getSession();
    	WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
    	CustomLogoutHandler = (CustomLogoutHandler) ctx.getBean("CustomLogoutHandler");
    }
    
    
    private void connectDB(Map<String, Object> user, String sessionId, HttpSessionEvent sessionEvent) {
    	
    	if(CustomLogoutHandler == null){
    		getCustomLogoutHandler(sessionEvent);
    		if(logger.isDebugEnabled()){
    			logger.debug("sessionRegistry 주입  :: " + CustomLogoutHandler);
    		}
    	}
    	
    	CustomLogoutHandler.logoutTimeout(user,sessionId);
		
    	
	}
    
}