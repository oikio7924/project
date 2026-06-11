package com.tx.dyAdmin.homepage.menu.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tx.common.config.SettingData;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.admin.domain.dto.HomeManager;
import com.tx.dyAdmin.homepage.menu.dto.Menu;
import com.tx.dyAdmin.homepage.menu.service.AdminMenuService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * AdminMenuService
 * 
 * @author 이재령
 * @version 1.0
 * @since 2019-05-15
 */
@Service("AdminMenuService")
public class AdminMenuServiceImpl extends EgovAbstractServiceImpl implements AdminMenuService {

	/** 공통 컴포넌트 */
	@Autowired
	ComponentService Component;
	@Autowired
	CommonService CommonService;
	
	/**
	 * isIncludeHomeDiv : 리스트에 홈 이름을 포함할지 여부
	 * isSubMenuSearch  : 해당 키의 서브 메뉴만 가져올지 여부
	 * authCheck		: 권한별로 메뉴를 보여줄지 여부 
	 * */
	@Override
	public List<Menu> getMenuList(HomeManager homeManager, List<String> pageDivList, boolean isIncludeHomeDiv, boolean isSubMenuSearch, boolean authCheck)
			throws Exception {

		homeManager.setPageDivList(pageDivList);
		List<Menu> menuList = null;
		if(authCheck){
			menuList = Component.getList("Menu.AMN_getMenuAllList2", homeManager);
		}else{
    	    menuList = Component.getList("Menu.AMN_getMenuAllList", homeManager);
       	}
		
		if(menuList == null) return null;
		
		
		List<Menu> resultList = new ArrayList<Menu>();
		
		int depth = 5;
		if(homeManager.getHM_MENU_DEPTH() != null) {
			depth = Integer.parseInt(homeManager.getHM_MENU_DEPTH());
		}
		
		
		String mainKey = getMainKey(homeManager,menuList);
		if(mainKey == null) return null;
		
		
		
		
		if(isSubMenuSearch){
			if (isIncludeHomeDiv) {
				for (Menu menu : menuList) {
					if(mainKey.equals(menu.getMN_KEYNO())){
						resultList.add(menu);
						break;
					}
				}
			}
			getChild(mainKey, resultList, menuList, depth);
		}else{
			if (isIncludeHomeDiv) {
				getChild("", resultList, menuList, depth);
			} else {
				getChild(homeManager.getHM_MN_HOMEDIV_C(), resultList, menuList, depth);
			}
		}

		return resultList;
	}

	/*
	 * getHM_MN_MAINKEY, getMN_MAINKEY 둘다 없으면 url 체크해서 key값 가져옴
	 * key값 없으면 return null;
	 */
	private String getMainKey(HomeManager homeManager, List<Menu> menuList) {
		
		String main1 = homeManager.getHM_MN_MAINKEY();
		String main2 = homeManager.getMN_MAINKEY();
		
		String mainKey = null;
		if(StringUtils.isNotEmpty(main1)) mainKey = main1;
		else if(StringUtils.isNotEmpty(main2)) mainKey = main2;
		else {
			String url = homeManager.getMN_URL();
			if(StringUtils.isNotEmpty(url)) {
				for(Menu menu : menuList) {
					if(url.equals(menu.getMN_URL())) {
						mainKey = menu.getMN_KEYNO();
						break;
					}
				}
			}
		}
		return mainKey;
	}

	@Override
	public List<Menu> getMenuList(HomeManager homeManager, List<String> pageDivList, boolean authCheck)
			throws Exception {

		

		return getMenuList(homeManager, pageDivList, false, false, authCheck);
	}

	@Override
	public List<Menu> getMenuList(HomeManager homeManager, List<String> pageDivList) throws Exception {
		return getMenuList(homeManager, pageDivList, false, false, false);

	}

	@Override
	public List<Menu> getMenuList(HomeManager homeManager) throws Exception {
		return getMenuList(homeManager, null);
	}
	
	@Override
	public List<Menu> getMenuList(String MN_URL,String MN_HOMEDIV_C, boolean isIncludeHomeDiv)
			throws Exception {
		HomeManager homeManager = new HomeManager();
		homeManager.setMN_URL(MN_URL);
		homeManager.setHM_MN_HOMEDIV_C(MN_HOMEDIV_C);
		return getMenuList(homeManager, null, isIncludeHomeDiv, true, false);
	}
	
	private void getChild(String mainKey, List<Menu> resultList, List<Menu> menuList, int depth) {

		for (Menu menu : menuList) {
			if(mainKey.equals(StringUtils.defaultIfBlank(menu.getMN_MAINKEY(), ""))){
				resultList.add(menu);
				if (menu.getMN_PAGEDIV_C().equals(SettingData.MENU_TYPE_SUBMENU) && menu.getMN_LEV() < depth) {
					getChild(menu.getMN_KEYNO(), resultList, menuList, depth);
				}
			}
		}

	}

	

	
	
}
