package com.tx.dyAdmin.homepage.layout.service.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tx.common.config.SettingData;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.file.FileManageTools;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.publish.CommonPublishService;
import com.tx.dyAdmin.homepage.layout.service.LayoutService;
import com.tx.dyAdmin.homepage.resource.dto.ResourcesDTO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("LayoutService")
public class LayoutServiceImpl extends EgovAbstractServiceImpl implements LayoutService {
	
	
	
	/** 공통 컴포넌트 */
	@Autowired
	ComponentService Component;
	@Autowired
	CommonService CommonService;
	@Autowired
	FileManageTools FileManageTools;
	
	@Autowired
	private CommonPublishService CommonPublishService;
	
	/**
	 * 레이아웃 기본 파일 생성
	 * 
	 * @param file_list
	 * @throws Exception
	 */
	@Override
	public boolean createLayoutFile(String path, HttpServletRequest req, String homeKey) throws Exception {

		boolean state = true;
		String[] file_arr = { "prc_main", "css", "script", "header", "footer", "leftmenu", "rightTop", "subTop", "layout" };
		String filePath = "";
		String data = SettingData.JSPDATA;
		
		for (String name : file_arr) {
			String fileName = name + ".jsp";
		
			if (name.equals("prc_main")) {
				filePath = SiteProperties.getString("JSP_PATH") + "/publish/" + path + "/";
			}else if(name.equals("layout")){
				filePath = SiteProperties.getString("JSP_PATH") + "/layout/user/defaultlayout/" + path + "/";
//				fileName = tiles + "_" + name + ".jsp";
				//레이아웃은 기본레이아웃jsp에서 데이터를 읽어온다.
				data = FileManageTools.read_file(SiteProperties.getString("JSP_PATH") + "/layout/user/", "basiclayout.jsp");
			}else {
				filePath = SiteProperties.getString("JSP_PATH") + "/publish/" + path + "/include/";
			}
			
			File file = new File(filePath + fileName);

			if (!file.isFile()) {
				state = FileManageTools.create_File(filePath, fileName, data, false);
			}
			
			//리소스 DB 저장
			createResourceByLayout(name, req, homeKey, data, true);

			if (!state) {
				break;
			}
		}

		return state;
	}
	
	/**
	 * 리소스 데이터 저장(layout)
	 * @param name
	 * @param req
	 * @param Menu
	 * @param data
	 */
	private void createResourceByLayout(String name, HttpServletRequest req, String homeKey, String data, boolean newCK){
		Map<String,Object> user = CommonService.getUserInfo(req);
		String regName = ((String) user.get("UI_KEYNO"));
		
		ResourcesDTO resourcesDTO = new ResourcesDTO();
		resourcesDTO.setRM_KEYNO(CommonService.getTableKey("RM"));
		resourcesDTO.setRM_MN_HOMEDIV_C(homeKey);
		resourcesDTO.setRM_REGNM(regName);
		resourcesDTO.setRM_DATA(data);
		resourcesDTO.setRM_SCOPE(name);
		resourcesDTO.setRM_FILE_NAME(name);
		resourcesDTO.setRM_TYPE("layout");
		
		Component.createData("Resources.RM_insert", resourcesDTO);

		createHistoryResource(resourcesDTO,regName, newCK);
		
	}
	
	/**
	 * 리소스 데이터 저장(css,js)
	 * @param name
	 * @param req
	 * @param Menu
	 * @param data
	 */
	private void createResourceByResource(ResourcesDTO resourcesDTO, HttpServletRequest req, String homeKey){
		Map<String,Object> user = CommonService.getUserInfo(req);
		String regName = ((String) user.get("UI_KEYNO"));
		
		ResourcesDTO newResources = new ResourcesDTO();
		newResources.setRM_KEYNO(CommonService.getTableKey("RM"));
		newResources.setRM_MN_HOMEDIV_C(homeKey);
		newResources.setRM_REGNM(regName);
		newResources.setRM_DATA(resourcesDTO.getRM_DATA());
		newResources.setRM_SCOPE(resourcesDTO.getRM_SCOPE());
		newResources.setRM_TITLE(resourcesDTO.getRM_TITLE());
		newResources.setRM_FILE_NAME(resourcesDTO.getRM_FILE_NAME());
		newResources.setRM_TYPE(resourcesDTO.getRM_TYPE());
		newResources.setRM_ORDER(resourcesDTO.getRM_ORDER());
		
		Component.createData("Resources.RM_insert", newResources);
		
		createHistoryResource(newResources,regName,false);
		
	}
	
	/**
	 * 리소스 히스토리 저장
	 * @param resourcesDTO
	 * @param regName
	 */
	private void createHistoryResource(ResourcesDTO resourcesDTO, String regName, boolean newCK){

		/* 히스토리 저장 시작*/
		String REGDT = Component.getData("Resources.get_historyDate",resourcesDTO);
		double VersionNum = Component.getData("Resources.get_historyVersion",resourcesDTO);
		VersionNum += 0.01;
		resourcesDTO.setRMH_KEYNO(CommonService.getTableKey("RMH"));
		resourcesDTO.setRMH_RM_KEYNO(resourcesDTO.getRM_KEYNO());
		resourcesDTO.setRMH_STDT(REGDT);
		resourcesDTO.setRMH_MODNM(regName);
		resourcesDTO.setRMH_DATA(resourcesDTO.getRM_DATA());
		resourcesDTO.setRMH_VERSION(VersionNum);
		
		String massage = "no message";
		if(!newCK){
			massage = "템플릿 복사";
		}
		resourcesDTO.setRMH_COMMENT(massage);
		Component.createData("Resources.RMH_insert", resourcesDTO);
		/* 히스토리 저장 끝*/
		
	}
	
	/**
	 * db에 저장되어있는 데이터 리스트 조회
	 * @param sitePath
	 * @param resourceType
	 * @return
	 */
	public List<ResourcesDTO> getResourceList(String sitePath, String resourceType){
		HashMap<String, Object> resourceMap = new HashMap<>();
		resourceMap.put("SITE_PATH", sitePath);
		resourceMap.put("TYPE", resourceType);
		
		return Component.getList("Resources.get_resourceDataListBysitePath",resourceMap);
	}

	/**
	 * 레이아웃 템플릿 파일 복사(layout)
	 * 
	 * @param oriPath
	 * @param newPath
	 * @throws Exception
	 */
	@Override
	public boolean copyLayoutFile(String oriPath, String newPath, HttpServletRequest req, String homeKey) throws Exception {

		List<ResourcesDTO> resourceList = getResourceList(oriPath,"layout");
		
		boolean state = true;

		String[] file_arr = { "prc_main", "css", "script", "header", "footer", "leftmenu", "rightTop", "subTop", "layout"};
		String data = "";

		ArrayList<HashMap<String, Object>> includeData = new ArrayList<HashMap<String, Object>>();
		for (String name : file_arr) {
			for (ResourcesDTO resourceDTO : resourceList) {
				if(name.equals(resourceDTO.getRM_SCOPE())) {
					HashMap<String, Object> saveDataMap = new HashMap<String,Object>();
					saveDataMap.put("resourceScope", resourceDTO.getRM_SCOPE());
					saveDataMap.put("resourceData", resourceDTO.getRM_DATA());
					includeData.add(saveDataMap);
				}
			}
		}

		String JSP_PATH = SiteProperties.getString("JSP_PATH");
		
		for (String name : file_arr) {
			
			boolean mapCheck = false;	
			
			if(includeData != null && includeData.size() > 0 ){
				for (HashMap<String, Object> dataMap : includeData) {
					if(name.equals(dataMap.get("resourceScope"))){
						mapCheck = true;
						//리소스 DB 저장
						createResourceByLayout(name, req, homeKey, (String)dataMap.get("resourceData"), false);	//prc_main, req, 홈페이지 키값, 내용, 템플릿사용여부
						break;
					}
				}
			}
			
			if(!mapCheck){	//includeData를 거치지 않았을 경우(db에 데이터가 저장안되어있을 경우)
				if (name.equals("layout")) {
					//레이아웃은 기본레이아웃jsp에서 데이터를 읽어온다.
					data = FileManageTools.read_file(JSP_PATH + "/layout/user/", "basiclayout.jsp");
				} else {
					data = SettingData.JSPDATA;
				}
				//리소스 DB 저장
				createResourceByLayout(name, req, homeKey, data, false);	//prc_main, req, 홈페이지 키값, 내용, 템플릿사용여부
			}
			
		}
		
		state = CommonPublishService.layout(newPath, homeKey, null, true);

		if(state){
			
			File fromDirectory = new File(JSP_PATH + "user" + File.separator + oriPath);
			File toDirectory = new File(JSP_PATH + "user" + File.separator + newPath);
			
			FileManageTools.directoryCopy(fromDirectory, toDirectory);
			
		}

		return state;
	}
	
	/**
	 * 리소스 템플릿 파일 복사(css,js)
	 * 
	 * @param oriTiles
	 * @param newTiles
	 * @throws Exception
	 */
	@Override
	public boolean copyResourceFile(String type, String oriPath, String newPath, HttpServletRequest req, String homeKey) throws Exception {
		
		List<ResourcesDTO> resourceList = getResourceList(oriPath,type);
		
		boolean state = true;
		
		if(resourceList != null && resourceList.size() > 0){
			for (ResourcesDTO resourceData : resourceList) {
				//리소스 DB 저장
				createResourceByResource(resourceData, req, homeKey);
			}
		}
		
		state = CommonPublishService.resource(newPath,homeKey, null, type);	

		return state;
	}
	
	/**
	 * 레이아웃 관련 데이터 삭제
	 * @param homeDiv
	 */
	public void deleteLayout(String homeDiv) throws Exception{
		
		//레이아웃 디렉토리 삭제
		/*String path = SiteProperties.getString("JSP_PATH") + "publish/" + homeManager.getHM_TILES() + "/"; 
		FileManageTools.delete_Folder(path);*/
				
		//레이아웃 리소스 삭제
		List<HashMap<String,Object>> resouces_list = Component.getList("Resources.RM_getList", CommonService.createMap("MN_KEYNO",homeDiv));
		for(HashMap<String,Object> dto : resouces_list){
			Component.updateData("Resources.RM_deleteByMNKey", dto);
			Component.updateData("Resources.RMH_deleteByMNKey", dto);
		}
		
		//미니게시판 삭제
		List<HashMap<String,Object>> mainmini_list = Component.getList("BoardMainMini.BMM_getData", CommonService.createMap("BMM_MN_HOMEDIV_C",homeDiv));
		for(HashMap<String,Object> dto : mainmini_list){
			Component.updateData("BoardMainMini.BMM_delete", dto);
		}
		
		//팝업존 삭제
		List<HashMap<String,Object>> category_List = Component.getList("PopupZone.TCGM_getData", CommonService.createMap("TCGM_MN_HOMEDIV_C",homeDiv));
		for(HashMap<String,Object> dto : category_List){
			Component.updateData("PopupZone.TCGM_delete", dto);
			Component.updateData("PopupZone.TLM_deleteByKey", dto);
		}
		
		//페이지 삭제
		List<HashMap<String,Object>> page_List = Component.getList("HTMLViewData.get_PageViewInfoDistribute", CommonService.createMap("MVD_MN_HOMEDIV_C",homeDiv));
		for(HashMap<String,Object> dto : page_List){
			Component.updateData("HTMLViewData.delete_pageByKey", dto);
		}
	}


	@Override
	public HashMap<String, Object> dataVersionCheck(HashMap<String, Object> resultMap, ResourcesDTO ResourcesDTO, Double currentVersion) throws Exception {
		
		boolean updateCheck = true;
		double VersionNum = Component.getData("Resources.get_historyVersion",ResourcesDTO);
		
		if(currentVersion != null && VersionNum > currentVersion){	// 저장된 버전이 현재버전 보다 크면 데이터 저장 안하고 리턴 시켜야 함.
			updateCheck = false;
		}
		
		resultMap.put("historyVersion", VersionNum);
		resultMap.put("updateCheck", updateCheck);
		
		return resultMap;
	}

	
	@Override
	public HashMap<String, Object> dataReturnPage(ResourcesDTO ResourcesDTO)
			throws Exception {
		
		HashMap<String, Object> resultData = new HashMap<>();
		ResourcesDTO BeforeHistory = Component.getData("Resources.RMH_getData",ResourcesDTO);
		String DATA = BeforeHistory.getRMH_DATA();
		Double version = BeforeHistory.getRMH_VERSION();
		
		resultData.put("DATA", DATA);
		resultData.put("viewVersion", version);
		
		return resultData;
	}

	@Override
	public void dataActionProcess(HttpServletRequest req, String actiontype, ResourcesDTO ResourcesDTO, String MN_HOMEDIV_C, Double currentVersion) throws Exception {
		
		Map<String,Object> user = CommonService.getUserInfo(req);
		String regName = ((String) user.get("UI_KEYNO"));
		String REGDT = Component.getData("Resources.get_historyDate",ResourcesDTO);
		
		if(actiontype.equals("insert")){
			ResourcesDTO.setRM_KEYNO(CommonService.getTableKey("RM"));
			ResourcesDTO.setRM_MN_HOMEDIV_C(MN_HOMEDIV_C);
			ResourcesDTO.setRM_REGNM(regName);
			Component.createData("Resources.RM_insert", ResourcesDTO);
			REGDT = Component.getData("Resources.get_historyDate",ResourcesDTO);
		}else if(actiontype.equals("update")){
			ResourcesDTO.setRM_MODNM(regName);
			Component.createData("Resources.RM_update", ResourcesDTO);
		}
		
		if(currentVersion != null){
			/* 히스토리 저장 시작*/
			double VersionNum = currentVersion;
			VersionNum += 0.01;
			ResourcesDTO.setRMH_KEYNO(CommonService.getTableKey("RMH"));
			ResourcesDTO.setRMH_RM_KEYNO(ResourcesDTO.getRM_KEYNO());
			ResourcesDTO.setRMH_STDT(REGDT);
			ResourcesDTO.setRMH_MODNM(regName);
			ResourcesDTO.setRMH_DATA(ResourcesDTO.getRM_DATA());
			ResourcesDTO.setRMH_VERSION(VersionNum);
			
			String message = ResourcesDTO.getRMH_COMMENT();
			if(ResourcesDTO.getRMH_COMMENT() == null || ResourcesDTO.getRMH_COMMENT().equals("")){
				message = "no message";
			}
			ResourcesDTO.setRMH_COMMENT(message);
			Component.createData("Resources.RMH_insert", ResourcesDTO);
			/* 히스토리 저장 끝*/
		}
	}
	
}
