package com.tx.dyAdmin.admin.site.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.admin.domain.dto.HomeManager;
import com.tx.dyAdmin.admin.site.service.SiteService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("SiteService")
public class SiteServiceImpl extends EgovAbstractServiceImpl implements SiteService{
	
	@Autowired ComponentService Component;
	private HashMap<String, String> sitePathMap = null;
	
	@PostConstruct
	public void init(){
		setSitePath();
	}
	
	
	@Override
	public void setSitePath(){
		List<HomeManager> pathList = Component.getListNoParam("HomeManager.get_siteTilesPathList");
		HashMap<String, String> dummyList = new HashMap<>();
		if(pathList != null && pathList.size()>0){
			for (HomeManager homeManager : pathList) {
				dummyList.put(homeManager.getHM_TILES(), homeManager.getHM_SITE_PATH());
			}
		}
		sitePathMap = dummyList;
	}
	
	@Override
	public String getSitePath(String tiles){
		return sitePathMap.get(tiles);
	}
	
	@Override
	public void setSessionVal(HttpServletRequest req, String SITE_KEYNO, String SITE_NAME){
		req.getSession().setAttribute("SITE_KEYNO", SITE_KEYNO);
		req.getSession().setAttribute("SITE_NAME", SITE_NAME);
	}

}
