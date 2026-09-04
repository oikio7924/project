package com.tx.common.config.session;

import java.util.List;

import javax.servlet.http.HttpSession;

public interface CustomSessionRegistry  {


    public List<Object> getAllPrincipals();

    public List<CustomSessionInfomation> getAllSessions(Object principal);
    
    public HttpSession getSession(Object principal);
    
    public CustomSessionInfomation getSessionInformation(String sessionId);
   
    public void registerNewSession(HttpSession session, Object principal);

    public void removeSessionInformation(String sessionId);
	
	
}
