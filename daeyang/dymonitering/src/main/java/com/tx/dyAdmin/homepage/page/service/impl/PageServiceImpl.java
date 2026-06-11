package com.tx.dyAdmin.homepage.page.service.impl;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tx.common.file.FileCommonTools;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.storage.service.StorageSelectorService;
import com.tx.dyAdmin.homepage.page.dto.HTMLViewData;
import com.tx.dyAdmin.homepage.page.service.PageService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("PageService")
public class PageServiceImpl extends EgovAbstractServiceImpl implements PageService {
	
	
	
	/** 공통 컴포넌트 */
	@Autowired
	ComponentService Component;
	@Autowired
	CommonService CommonService;
	
	@Autowired StorageSelectorService StorageSelector;
	
	@Autowired FileCommonTools FileCommonTools;
	
	
//	private final String CHECK_STRORAGE_STR = "do?file=";
	
	@Override
	public HashMap<String, Object> dataVersionCheck(HashMap<String, Object> resultMap, HTMLViewData hTMLViewData,
			Double currentVersion) throws Exception {
		boolean updateCheck = true;
		double VersionNum = Component.getData("HTMLViewData.get_historyVersion",hTMLViewData);
		
		if(currentVersion != null && VersionNum > currentVersion){	// 저장된 버전이 현재버전 보다 크면 데이터 저장 안하고 리턴 시켜야 함.
			updateCheck = false;
		}
		
		resultMap.put("historyVersion", VersionNum);
		resultMap.put("updateCheck", updateCheck);
		
		return resultMap;
	}
	
	@Override
	public HashMap<String, Object> dataReturnPage(HTMLViewData hTMLViewData) throws Exception {
		HashMap<String, Object> resultData = new HashMap<>();
		HTMLViewData BeforeHistory = Component.getData("HTMLViewData.MVH_getData",hTMLViewData);
		String DATA = BeforeHistory.getMVH_DATA();
		Double version = BeforeHistory.getMVH_VERSION();
		
		resultData.put("DATA", DATA);
		resultData.put("viewVersion", version);
		
		return resultData;
	}
}
