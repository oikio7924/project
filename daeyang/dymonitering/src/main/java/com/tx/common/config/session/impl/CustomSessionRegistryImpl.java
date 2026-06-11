package com.tx.common.config.session.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.CopyOnWriteArraySet;

import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.security.core.session.SessionRegistryImpl;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import com.tx.common.config.session.CustomSessionInfomation;
import com.tx.common.config.session.CustomSessionRegistry;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("sessionRegistry")
public class CustomSessionRegistryImpl extends EgovAbstractServiceImpl implements CustomSessionRegistry {

	//~ Instance fields ================================================================================================

    protected final Log logger = LogFactory.getLog(SessionRegistryImpl.class);

    /** <principal:Object,SessionIdSet> */
    private final ConcurrentMap<Object,Set<String>> principals = new ConcurrentHashMap<Object,Set<String>>();
    /** <sessionId:Object,SessionInformation> */
    private final Map<String, CustomSessionInfomation> sessionIds = new ConcurrentHashMap<String, CustomSessionInfomation>();

    //~ Methods ========================================================================================================

    @Override
    public List<Object> getAllPrincipals() {
        return new ArrayList<Object>(principals.keySet());
    }

    @Override
    public List<CustomSessionInfomation> getAllSessions(Object principal) {
        final Set<String> sessionsUsedByPrincipal = principals.get(principal);

        if (sessionsUsedByPrincipal == null) {
            return Collections.emptyList();
        }

        List<CustomSessionInfomation> list = new ArrayList<CustomSessionInfomation>(sessionsUsedByPrincipal.size());

        for (String sessionId : sessionsUsedByPrincipal) {
        	CustomSessionInfomation sessionInformation = getSessionInformation(sessionId);

            if (sessionInformation == null) {
                continue;
            }

            if (!sessionInformation.isExpired()) {
                list.add(sessionInformation);
            }
        }

        return list;
    }
    
    @Override
    public HttpSession getSession(Object principal){
    	final Set<String> sessionsUsedByPrincipal = principals.get(principal);
    	if (sessionsUsedByPrincipal == null) {
            return null;
        }
    	
        for (String sessionId : sessionsUsedByPrincipal) {
        	CustomSessionInfomation sessionInformation = getSessionInformation(sessionId);

            if (sessionInformation != null) {
            	return sessionInformation.getSession();
            }

        }

        return null;
    }

    @Override
    public CustomSessionInfomation getSessionInformation(String sessionId) {
        Assert.hasText(sessionId, "SessionId required as per interface contract");

        return sessionIds.get(sessionId);
    }

   
    @Override
    public void registerNewSession(HttpSession session, Object principal) {
        
    	String sessionId = session.getId();
    	
        if (logger.isDebugEnabled()) {
            logger.debug("Registering session " + sessionId +", for principal " + principal);
        }

        if (getSessionInformation(sessionId) != null) {
            removeSessionInformation(sessionId);
        }

        sessionIds.put(sessionId, new CustomSessionInfomation(principal, session));

        Set<String> sessionsUsedByPrincipal = principals.get(principal);

        if (sessionsUsedByPrincipal == null) {
            sessionsUsedByPrincipal = new CopyOnWriteArraySet<String>();
            Set<String> prevSessionsUsedByPrincipal = principals.putIfAbsent(principal,
                    sessionsUsedByPrincipal);
            if (prevSessionsUsedByPrincipal != null) {
                sessionsUsedByPrincipal = prevSessionsUsedByPrincipal;
            }
        }

        sessionsUsedByPrincipal.add(sessionId);

        if (logger.isTraceEnabled()) {
            logger.trace("Sessions used by '" + principal + "' : " + sessionsUsedByPrincipal);
        }
    }

    @Override
    public void removeSessionInformation(String sessionId) {
        Assert.hasText(sessionId, "SessionId required as per interface contract");

        CustomSessionInfomation info = getSessionInformation(sessionId);

        if (info == null) {
            return;
        }

        if (logger.isTraceEnabled()) {
            logger.debug("Removing session " + sessionId + " from set of registered sessions");
        }

        sessionIds.remove(sessionId);

        Set<String> sessionsUsedByPrincipal = principals.get(info.getPrincipal());

        if (sessionsUsedByPrincipal == null) {
            return;
        }

        if (logger.isDebugEnabled()) {
            logger.debug("Removing session " + sessionId + " from principal's set of registered sessions");
        }

        sessionsUsedByPrincipal.remove(sessionId);

        if (sessionsUsedByPrincipal.isEmpty()) {
            // No need to keep object in principals Map anymore
            if (logger.isDebugEnabled()) {
                logger.debug("Removing principal " + info.getPrincipal() + " from registry");
            }
            principals.remove(info.getPrincipal());
        }

        if (logger.isTraceEnabled()) {
            logger.trace("Sessions used by '" + info.getPrincipal() + "' : " + sessionsUsedByPrincipal);
        }
    }

	
	
}
