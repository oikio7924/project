package com.tx.dyAdmin.admin.site.service;

import javax.servlet.http.HttpServletRequest;

public interface SiteService {
	
	public void setSitePath();
	
	public String getSitePath(String tiles);
	
	public void setSessionVal(HttpServletRequest req, String SITE_KEYNO, String SITE_NAME);
	
}
