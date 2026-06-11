package com.tx.common.config.session;

import java.io.Serializable;
import java.util.Date;

import javax.servlet.http.HttpSession;

import org.springframework.security.core.SpringSecurityCoreVersion;

public class CustomSessionInfomation implements Serializable {

    private static final long serialVersionUID = SpringSecurityCoreVersion.SERIAL_VERSION_UID;

    //~ Instance fields ================================================================================================

    private final Object principal;
    private final HttpSession session;

    //~ Constructors ===================================================================================================

    public CustomSessionInfomation(Object principal, HttpSession session) {
        this.principal = principal;
        this.session = session;
    }

    //~ Methods ========================================================================================================

    public Date getLastRequest() {
        return new Date(session.getLastAccessedTime());
    }

    public Object getPrincipal() {
        return principal;
    }

    public String getSessionId() {
        return session.getId();
    }

    public boolean isExpired() {
        return session == null;
    }

	public HttpSession getSession() {
		return session;
	}
    
}