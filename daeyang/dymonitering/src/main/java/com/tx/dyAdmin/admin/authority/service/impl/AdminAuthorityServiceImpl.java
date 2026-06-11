package com.tx.dyAdmin.admin.authority.service.impl;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.SettingData;
import com.tx.common.security.handler.ReloadableFilterInvocationSecurityMetadataSource;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.page.PageAccess;
import com.tx.dyAdmin.admin.authority.dto.SecuredResource;
import com.tx.dyAdmin.admin.authority.service.AdminAuthorityService;
import com.tx.dyAdmin.admin.domain.dto.HomeManager;
import com.tx.dyAdmin.homepage.menu.dto.Menu;
import com.tx.dyAdmin.homepage.menu.service.AdminMenuService;
import com.tx.dyAdmin.homepage.menu.service.AdminMenuSessionService;
import com.tx.dyAdmin.member.dto.UserDTO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * 권한 관리 서비스
 * @author 이재령
 * @date 2019-06-01
 *
 */
@Service("AdminAuthorityService")
public class AdminAuthorityServiceImpl  extends EgovAbstractServiceImpl implements AdminAuthorityService{
	
	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 리로드 권한설정 */
	@Autowired ReloadableFilterInvocationSecurityMetadataSource reloadableFilterInvocationSecurityMetadataSource;
	
	/** 페이지 처리 출 */
	@Autowired private PageAccess PageAccess;
	
	/** 메뉴리스트 서비스 */
	@Autowired private AdminMenuService AdminMenuService;
	
	/** 메뉴관리 서비스2 */
	@Autowired private AdminMenuSessionService AdminMenuSessionService;
	
	/**
	 * 하위 그룹 및 권한 가져오기
	 * @param UIA_KEYNO
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<HashMap<String,Object>> getChildAuthority(String UIA_KEYNO) throws Exception{
		
		List<HashMap<String,Object>> resultList = new ArrayList<HashMap<String,Object>>();
		
		List<HashMap<String,Object>> authorityList = Component.getListNoParam("Authority.UIA_GetList3");
		
		getChild(UIA_KEYNO,resultList,authorityList);
		
		return resultList;
	}
	
	private void getChild(String mainKey, List<HashMap<String,Object>> resultList, List<HashMap<String,Object>> authorityList) {
		
		for(HashMap<String,Object> authority : authorityList){
			String UIA_MAINKEY = (String)authority.get("UIA_MAINKEY");
			
			if(mainKey.equals(UIA_MAINKEY)){
				resultList.add(authority);
				int depth = Integer.parseInt(authority.get("UIA_DEPTH").toString());
				String division = authority.get("UIA_DIVISION").toString();
				if(division.equals("G") && depth != 5){
					String UIA_KEYNO = authority.get("UIA_KEYNO").toString();
					getChild(UIA_KEYNO,resultList,authorityList);
				}
			}
		}
		
	}
	
	@Override
	public List<HashMap<String,Object>> getBoardList(String UIA_KEYNO) throws Exception {
		
		List<HashMap<String,Object>> boardList = Component.getList("Authority.UIA_boardList", UIA_KEYNO);
		
		List<HashMap<String,Object>> resultList = new ArrayList<HashMap<String,Object>>();
		
		resultList.add(getBoardMap("","게시판","",1));
		
		String beforeHomeDiv = "";
		
		for(HashMap<String,Object> board : boardList){
			String homeDiv = board.get("MN_HOMEDIV_NAME").toString();
			if(!beforeHomeDiv.equals(homeDiv)){
				resultList.add(getBoardMap("",homeDiv,"",2));
				beforeHomeDiv = homeDiv;
			}
			String key = board.get("MN_KEYNO").toString();
			String name = board.get("MN_NAME").toString();
			String uirKey = (String)board.get("UIR_KEYNO");
			resultList.add(getBoardMap(key,name,uirKey,3));
			
		}
		
		return resultList;
		
	}
	
	private HashMap<String, Object> getBoardMap(String key, String name, String uirKey, int depth) {
		HashMap<String,Object> temp = new HashMap<String,Object>();
		temp.put("MN_KEYNO", key);
		temp.put("MN_NAME", name);
		temp.put("UIR_KEYNO", uirKey);
		temp.put("MN_DEPTH", depth);
		return temp;
	}

	/**
	 * 시스템 권한 재설정
	 * @throws Exception
	 */
	@Override
	public void applyAuhotiry() throws Exception {
		
		//기존값 초기화
		CommonService.deleteData("U_USERINFO_SECURED_RESOURCE",null);
		CommonService.deleteData("U_USERINFO_RESOURCE_AUTHORITY",null);
		Component.deleteData("Authority.clean_authority_roll");
		
		List<String> authorityList = Component.getListNoParam("Authority.UIA_GetAllList");
		
		List<HashMap<String,Object>> menuList = Component.getList("Authority.USR_getMenuListWidthAuthority", SettingData.AUTHORITY_ROLE_ACCESS);
		
		
		List<SecuredResource> securedResourceList = new ArrayList<SecuredResource>();
		
		List<SecuredResource> resourceAuthorityList = new ArrayList<SecuredResource>();
		
		Integer dataCount = 1;
		
		String USR_KEYNO = CommonService.getKeyno((dataCount++)+"", "USR");
		securedResourceList.add(new SecuredResource(USR_KEYNO,"/dyAdmin/user/**",1,SettingData.AUTHORITY_ROLE_ACCESS,""));
		addResourceAuthority(USR_KEYNO,authorityList,resourceAuthorityList);
		
		for(HashMap<String,Object> menu : menuList){
			
			String UIA_KEYNO[] = ((String)menu.get("UIA_KEYNO")).split(",");
			if(authorityList.size() == UIA_KEYNO.length + 1){
				//메뉴에 대해 모두 권한을 가지고 있으면 넘긴다 (설정값이 없으면 모두 접근 가능하다.), 개발자 권한을 더해줘야 모든 권한이 된다.
				continue;
			}
			
			USR_KEYNO = CommonService.getKeyno((dataCount++)+"", "USR");
			int USR_ORDER = Integer.parseInt(menu.get("USR_ORDER")+"");
			String MN_KEYNO = (String)menu.get("MN_KEYNO");
			securedResourceList.add(new SecuredResource(USR_KEYNO,"",USR_ORDER,SettingData.AUTHORITY_ROLE_ACCESS,MN_KEYNO));
			addResourceAuthority(USR_KEYNO,(String)menu.get("UIA_KEYNO"),resourceAuthorityList);
		}
		
		USR_KEYNO = CommonService.getKeyno((dataCount++)+"", "USR");
		securedResourceList.add(new SecuredResource(USR_KEYNO,"/**",100,SettingData.AUTHORITY_ROLE_ACCESS,""));
		addResourceAuthority(USR_KEYNO,authorityList,resourceAuthorityList);
		
		
		Component.createDataWithSplitList(null,securedResourceList,"Authority.securedResourceInsertAllData","securedResourceList",200);
		Component.createDataWithSplitList(null,resourceAuthorityList,"Authority.resourceAuthorityInsertAllData","resourceAuthorityList",200);
		
		
		reloadableFilterInvocationSecurityMetadataSource.reload();
		
		//저장할때 해당키 수정시간저장
		AdminMenuSessionService.updateTime();
		
	}

	private void addResourceAuthority(String USR_KEYNO, List<String> authorityList,
			List<SecuredResource> resourceAuthorityList) {
		
		for(String authority : authorityList){
			resourceAuthorityList.add(new SecuredResource(USR_KEYNO,authority));
		}
	}
	
	private void addResourceAuthority(String USR_KEYNO, String authority,
			List<SecuredResource> resourceAuthorityList) {
		authority += "," + SettingData.AUTHORITY_ADMIN;
		List<String> authorityList = Arrays.asList(authority.split(","));
		addResourceAuthority(USR_KEYNO,authorityList,resourceAuthorityList);
		
	}
	
	/**
	 * 유저 리스트 가져오기
	 * @param MN_KEYNO
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<HashMap<String,Object>> getUserList(String MN_KEYNO) throws Exception{
		
		List<HashMap<String,Object>> resultList = new ArrayList<HashMap<String,Object>>();
		
		List<HashMap<String,Object>> authorityList = Component.getList("Authority.UIA_GetUserList",MN_KEYNO);
		
		getChild2("UIA_00000",resultList,authorityList);
		
		return resultList;
	}
	
	private void getChild2(String mainKey, List<HashMap<String,Object>> resultList, List<HashMap<String,Object>> authorityList) {
		
		for(HashMap<String,Object> authority : authorityList){
			String UIA_MAINKEY = (String)authority.get("UIA_MAINKEY");
			
			if(mainKey.equals(UIA_MAINKEY)){
				
				resultList.add(authority);
				
				int CHILD_CNT = Integer.parseInt(authority.get("CHILD_CNT").toString());
				if(CHILD_CNT > 0){
					String UIA_KEYNO = authority.get("UIA_KEYNO").toString();
					getChild2(UIA_KEYNO,resultList,authorityList);
				}
			}
		}
	}

	@Override
	public ModelAndView getListAjax(String returnPage,String type, Integer pageIndex, String searchKeyword) throws Exception {
		ModelAndView mv  = new ModelAndView(returnPage);
		if("A".equals(type)){
			mv.addObject("systemAuthorityList",Component.getListNoParam("UIA_GetSystemList"));
		}else if("B".equals(type)){
			List<HashMap<String,Object>> searchList = new ArrayList<HashMap<String,Object>>();
			HashMap<String,Object> searchMap = new HashMap<String,Object>();
			searchMap.put("searchIndex", "authority");
			searchMap.put("searchKeyword", searchKeyword);
			searchList.add(searchMap);
			
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("searchList", searchList);
			map.put("authority", "authority");
			
			PaginationInfo pageInfo = PageAccess.getPagInfo(pageIndex,"member.UI_getListCnt",map, 10, 5);
			
			map.put("firstIndex", pageInfo.getFirstRecordIndex());
			map.put("lastIndex", pageInfo.getLastRecordIndex());
			map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
			
			mv.addObject("paginationInfo", pageInfo);
			
			List<HashMap<String,Object>> resultList = Component.getList("member.UI_getList", map); 
			mv.addObject("resultList", resultList);
			mv.addObject("searchKeyword", searchKeyword);
		}
		return mv;
	}

	@Override
	public void save(HttpServletRequest req) throws Exception {
		String UIA_KEYNO[] = req.getParameterValues("UIA_KEYNO");
		String UIA_NAME[] = req.getParameterValues("UIA_NAME");
		String UIA_SYSTEM[] = req.getParameterValues("UIA_SYSTEM");
		String UIA_MAINKEY[] = req.getParameterValues("UIA_MAINKEY");
		String UIA_DEPTH[] = req.getParameterValues("UIA_DEPTH");
		String UIA_ORDER[] = req.getParameterValues("UIA_ORDER");
		String UIA_DIVISION[] = req.getParameterValues("UIA_DIVISION");
		
		List<HashMap<String,Object>> list = new ArrayList<HashMap<String,Object>>();
		
		HashMap<String,Object> keyList = new HashMap<String,Object>();
		
		List<String> notDeleteKeyList = new ArrayList<String>();
		notDeleteKeyList.add(SettingData.AUTHORITY_ANONYMOUS);
		
		List<HashMap<String,Object>> addOrModifiedKeyList = new ArrayList<HashMap<String,Object>>();
		
		HashMap<String,Object> temp = null;
		for(int i=0;i<UIA_KEYNO.length;i++){
			if(!UIA_SYSTEM[i].equals("Y")){
				temp = new HashMap<String,Object>();
				
				boolean changeCheck = false;
				
				String key = UIA_KEYNO[i];
				if(key.startsWith("UIA")){
					changeCheck = true;
				}else{
					key = CommonService.getTableKey("UIA");
					keyList.put( UIA_KEYNO[i], key);
				}
				
				temp.put("UIA_KEYNO", key);
				temp.put("UIA_NAME", UIA_NAME[i]);
				temp.put("UIA_SYSTEM", UIA_SYSTEM[i]);
				
				String mainkey = UIA_MAINKEY[i];
				if(!mainkey.equals("") &&!mainkey.startsWith("UIA")){
					mainkey = (String)keyList.get(UIA_MAINKEY[i]);
				}
				temp.put("UIA_MAINKEY", mainkey);
				temp.put("UIA_DEPTH", UIA_DEPTH[i]);
				temp.put("UIA_ORDER", UIA_ORDER[i]);
				temp.put("UIA_DIVISION", UIA_DIVISION[i]);
				list.add(temp);
				
				if(changeCheck){	//기존에 등록되어있던 키라면 
					// 변경되면 0 기존 그대로이면 1
					int isChange = Component.getCount("Authority.UIA_isChange", temp);
					
					if(isChange == 1){
						notDeleteKeyList.add(key);
					}
				}
				
				//변경되거나 추가된 키 이고   메인키가 있다면.
				if(!notDeleteKeyList.contains(key) && StringUtils.isNotEmpty(mainkey)) {
					addOrModifiedKeyList.add(temp);
				}
				
				
			}
			
			
		}
		
		
		HashMap<String,Object> deleteMap = new HashMap<String,Object>();
		deleteMap.put("notDeleteKeyList", notDeleteKeyList);
		Component.deleteData("Authority.UAR_deleteData2", deleteMap);
		
		List<HashMap<String,Object>> columns = new ArrayList<HashMap<String,Object>>();
		HashMap<String,Object> column = new HashMap<String,Object>();
		column.put("name", "UIA_SYSTEM");
		column.put("operator", "!=");
		column.put("value", "Y");
		columns.add(column);
		
		column = new HashMap<String,Object>();
		column.put("name", "UIA_DIVISION");
		column.put("operator", "!=");
		column.put("value", "U");
		columns.add(column);
		CommonService.deleteData("U_USERINFO_AUTHORITY",columns);
		
		HashMap<String,Object> insertMap = new HashMap<String,Object>();
		insertMap.put("list", list);
		
		Component.createData("Authority.UIA_insertAll", insertMap);
		
		
		//추가되거나 수정된 권한 부모 권한이랑 똑같이 설정
		for(HashMap<String,Object> addOrModifiedKeyMap : addOrModifiedKeyList) {
			Component.createData("Authority.UAR_insertByMainKey", addOrModifiedKeyMap);
		}
		
		
		
		//유저 커스텀 권한 중 상위 권한 삭제된거 같이 삭제
		Component.deleteData("UIA_deleteCustomAuthorityData");
		
		Component.deleteData("UIA_deleteCustomAuthorityData2",CommonService.createMap("tableName","U_USERINFO_AUTHORITY_ROLL"));
		Component.deleteData("UIA_deleteCustomAuthorityData2",CommonService.createMap("tableName","U_USERINFO_MEMBER_AUTHORITY"));
		Component.deleteData("UIA_deleteCustomAuthorityData2",CommonService.createMap("tableName","U_USERINFO_RESOURCE_AUTHORITY"));
		
	}

	@Override
	public ModelAndView getMenuList(String returnPage, String type, String key) throws Exception {
		
		ModelAndView mv  = new ModelAndView(returnPage);
		String UIA_KEYNO = null;
		String UIA_MAINKEY = null;
		mv.addObject("type",type);
		if("A".equals(type)){
			HashMap<String,Object> resultMap = Component.getData("Authority.UIA_getData",key);
			mv.addObject("resultData", resultMap);
			UIA_KEYNO = key;
			UIA_MAINKEY = (String)resultMap.get("UIA_MAINKEY");
		}else if("B".equals(type)){
			HashMap<String,Object> user = Component.getData("member.UI_getData",key);
			UIA_KEYNO = (String)user.get("UIA_KEYNO");
			UIA_MAINKEY = (String)user.get("UIA_MAINKEY");
			mv.addObject("resultData", user);
		}
		
		//홈페이지 구분 리스트
		List<HomeManager> homeManagerList = CommonService.getHomeDivCode(true);
		
		List<HashMap<String,Object>> resultList = new ArrayList<HashMap<String,Object>>();
		
		HashMap<String,Object> temp = null;
		for(HomeManager homeManager : homeManagerList){
			
			temp = new HashMap<String,Object>();
			homeManager.setUIA_KEYNO(UIA_KEYNO);
			homeManager.setUIA_MAINKEY(UIA_MAINKEY);
			temp.put("homeManager", homeManager);
			temp.put("menuList", AdminMenuService.getMenuList(homeManager,null,true,false,false));
			
			if(SettingData.HOMEDIV_ADMIN.equals(homeManager.getHM_MN_HOMEDIV_C())) {
				
				List<HashMap<String,Object>> uaaList = Component.getList("Authority.UAA_getList", UIA_KEYNO);
				HashMap<String,Object> adminAuthList = new HashMap<String,Object>();
				
				String beforeMenu = null;
				String hmList = "";
				for(HashMap<String,Object> uaa : uaaList) {
					String MN_KEYNO = (String)uaa.get("MN_KEYNO");
					if(beforeMenu == null || !beforeMenu.equals(MN_KEYNO)) {
						
						if(beforeMenu != null) adminAuthList.put(beforeMenu, hmList);
						
						beforeMenu = MN_KEYNO;
						hmList = "";
					}
					hmList += uaa.get("HM_KEYNO") + ",";
				}
				
				if(beforeMenu != null) adminAuthList.put(beforeMenu, hmList);
				
				temp.put("adminAuthList", adminAuthList);
			}
			
			resultList.add(temp);
		}
		
		mv.addObject("resultList", resultList);
		
		mv.addObject("boardList", getBoardList(UIA_KEYNO));
		
		UserDTO subType = new UserDTO();
		subType.setUIR_TYPE(SettingData.AUTHORITY_SUB_BOARD);
		mv.addObject("boardAuthorityList", Component.getList("Authority.UIR_GetList", subType));
		
		
		return mv;
	}

	@Override
	public String saveMenuListByAuthority(HttpServletRequest req) throws Exception {
		
		String type = req.getParameter("type");
		String UIA_KEYNO = req.getParameter("UIA_KEYNO");
		String UIA_DIVISION = req.getParameter("UIA_DIVISION");
		String UI_ID = req.getParameter("UI_ID");
		String UI_KEYNO = req.getParameter("UI_KEYNO");
		
		String accessRole[] = req.getParameterValues("accessRole");
		String viewRole[] = req.getParameterValues("viewRole");
		String actionRole[] = req.getParameterValues("actionRole");
		String adminPageRoll[] = req.getParameterValues("adminPageRoll");
		
		String subPermission = req.getParameter("subPermission");
		
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		//권한에서 들어올경우
		if("A".equals(type)){
			map.put("UIA_KEYNO", UIA_KEYNO);
			Component.deleteData("Authority.UAR_deleteData", map);
			Component.deleteData("Authority.UAA_deleteData", map);
		//회원에서 들어올경우	
		}else if("B".equals(type)){
			UserDTO user = Component.getData("member.selectUserInfo",UI_ID);
			
			//회원만의 권한이 없을경우 권한을 새로 만듬
			if("A".equals(UIA_DIVISION)){
				String newKey = CommonService.getTableKey("UIA");
				map.put("UIA_KEYNO", newKey);
				map.put("UIA_NAME", user.getUIA_NAME()+"("+UI_ID+")");
				map.put("UIA_SYSTEM", "N");
				map.put("UIA_MAINKEY", UIA_KEYNO);
				map.put("UIA_DEPTH", 6);
				map.put("UIA_ORDER", 0);
				map.put("UIA_DIVISION", "U");
				Component.createData("Authority.UIA_insertData", map);
				
				map.put("UI_KEYNO", UI_KEYNO);
				map.put("UIA_KEYNO", newKey.split(","));
				Component.deleteData("member.UI_deleteAuthority", map);
				Component.createData("member.UI_setAuthority", map);
				
				map = new HashMap<String,Object>();
				UIA_KEYNO = newKey;
				map.put("UIA_KEYNO", UIA_KEYNO);
			
			//회원만의 권한이 있을경우 기존 매핑 데이터만 삭제
			}else if("U".equals(UIA_DIVISION)){
				
				UIA_KEYNO = user.getUIA_KEYNO();
				map.put("UIA_KEYNO", UIA_KEYNO);
				Component.deleteData("Authority.UAR_deleteData", map);
				Component.deleteData("Authority.UAA_deleteData", map);
			}else{
				return "F";
			}
		}else{
			return "F";
		}
		
		
		List<HashMap<String,Object>> roleList = new ArrayList<HashMap<String,Object>>();
		HashMap<String,Object> role = null;
		if(accessRole != null){
			for(String access : accessRole){
				role = new HashMap<String,Object>();
				role.put("MN_KEYNO", access);
				role.put("UIR_KEYNO", SettingData.AUTHORITY_ROLE_ACCESS);
				roleList.add(role);
			}
		}
		if(viewRole != null){
			for(String view : viewRole){
				role = new HashMap<String,Object>();
				role.put("MN_KEYNO", view);
				role.put("UIR_KEYNO", SettingData.AUTHORITY_ROLE_VIEW);
				roleList.add(role);
			}
		}
		if(actionRole != null){
			for(String action : actionRole){
				role = new HashMap<String,Object>();
				role.put("MN_KEYNO", action);
				role.put("UIR_KEYNO", SettingData.AUTHORITY_ROLE_ACTION);
				roleList.add(role);
			}
		}
		
		UserDTO subType = new UserDTO();
		subType.setUIR_TYPE(SettingData.AUTHORITY_SUB_BOARD);
		List<UserDTO> subTypeList = Component.getList("Authority.UIR_GetList", subType);
		
		for(UserDTO sub : subTypeList){
			String name = sub.getUIR_NAME();
			String key = sub.getUIR_KEYNO();
			
			String boardAuthList[] = req.getParameterValues(name+"Role");
			if(boardAuthList != null){
				for(String boardAuth : boardAuthList){
					role = new HashMap<String,Object>();
					role.put("MN_KEYNO", boardAuth);
					role.put("UIR_KEYNO", key);
					roleList.add(role);
				}
			}
			
			
		}
		
		
		if(roleList.size() > 0){
			map.put("roleList", roleList);
			Component.createData("Authority.UAR_insertAll", map);
		}
		
		//관리자페이지 권한 추가
		List<HashMap<String,Object>> adminPageRoleList = new ArrayList<HashMap<String,Object>>();
		if(adminPageRoll != null){
			for(String adminPage : adminPageRoll){
				
				String data[] = adminPage.split("/");
				role = new HashMap<String,Object>();
				role.put("MN_KEYNO", data[0]);
				role.put("HM_KEYNO", data[1]);
				adminPageRoleList.add(role);
			}
			if(adminPageRoleList.size() > 0){
				map.put("adminPageRoleList", adminPageRoleList);
				Component.createData("Authority.UAA_insertAll", map);
			}
		}
		
		
		
		
		//그룹일 경우
		if(UIA_DIVISION != null && "G".equals(UIA_DIVISION)){
			List<HashMap<String,Object>> childAuthoirtyList = getChildAuthority(UIA_KEYNO);
			if(childAuthoirtyList.size() > 0){
				//하위권한 일괄 적용일 경우 
				if("Y".equals(subPermission)) {
					for(HashMap<String,Object> childAuthority : childAuthoirtyList) {
						
						map.put("UIA_KEYNO", childAuthority.get("UIA_KEYNO"));
						Component.deleteData("Authority.UAR_deleteData", map);
						if(roleList.size() > 0){
							Component.createData("Authority.UAR_insertAll", map);
						}
						
						Component.deleteData("Authority.UAA_deleteData", map);
						if(adminPageRoleList.size() > 0){
							Component.createData("Authority.UAA_insertAll", map);
						}
					}
					
				//하위 권한 및 그룹의 권한들을 체크해서 같이 수정해준다.	
				}else { 
					HashMap<String,Object> childAUthorityMap = new HashMap<String,Object>();
					childAUthorityMap.put("UIA_KEYNO", UIA_KEYNO);
					childAUthorityMap.put("childAuthoirtyList", childAuthoirtyList);
					childAUthorityMap.put("UIR_KEYNO", SettingData.AUTHORITY_ROLE_ACCESS);
					
					//권한있는 유저의 해당 메뉴 권한 삭제
					List<HashMap<String, Object>> usergroup = Component.getList("Authority.UIA_selectChildAuthorityMappingMenu", childAUthorityMap);
					for (HashMap<String, Object> user : usergroup) {
						HashMap<String, Object> data = new HashMap<>();
						data.put("UIA_MAINKEY", user.get("UIA_KEYNO"));
						data.put("MN_KEYNO", user.get("MN_KEYNO"));
						Component.deleteData("Authority.UIA_deleteSubChildAuthorityMappingMenu",data);
					}
					
					Component.deleteData("Authority.UIA_deleteChildAuthorityMappingMenu", childAUthorityMap);
				}
			}
			
			
			
		}else if(UIA_DIVISION != null && "A".equals(UIA_DIVISION)){ //유저 게시판일 경우
			List<HashMap<String, Object>> childAuthoirtyList = Component.getList("Authority.UIA_selectChildAuthorityMappingKeyno", UIA_KEYNO);
			if(childAuthoirtyList.size() > 0){
				HashMap<String,Object> childAUthorityBoardMap = new HashMap<String,Object>();
				childAUthorityBoardMap.put("UIA_KEYNO", UIA_KEYNO);
				childAUthorityBoardMap.put("childAuthoirtyList", childAuthoirtyList);
				childAUthorityBoardMap.put("UIR_KEYNO", SettingData.AUTHORITY_ROLE_ACCESS);
				
				//권한있는 유저의 해당 메뉴 권한 삭제
				List<HashMap<String, Object>> usergroup = Component.getList("Authority.UIA_selectChildAuthorityMappingMenu", childAUthorityBoardMap);
				for (HashMap<String, Object> user : usergroup) {
					HashMap<String, Object> data = new HashMap<>();
					data.put("UIA_KEYNO", user.get("UIA_KEYNO"));
					data.put("MN_KEYNO", user.get("MN_KEYNO"));
					Component.deleteData("Authority.UIA_deleteSubChildAuthorityMappingBoard",data);
				}
			}
		}
		
		return "S";
	}

	@Override
	public void createDefaultAuthority(HomeManager homeManager) throws Exception {
		
		
		List<String> authKeyList = new ArrayList<String>();
		
		String groupKey = null;
		int depth = 0;
		String UIA_MAINKEY = null;
		//그룹이 있을경우 
		if(StringUtils.isNotEmpty(homeManager.getHM_GROUP())) {
			UserDTO groupAuth = Component.getData("Authority.UIA_getGroupAuthCnt",homeManager.getHM_GROUP());
			
			//이미 db에 존재하면 값만 저장해둠
			if(groupAuth != null) {
				groupKey = groupAuth.getUIA_KEYNO();
			}else {
				HashMap<String,Object> map = new HashMap<String,Object>();
				
				//서브도메인 기본 그룹 생성
				groupKey = CommonService.getTableKey("UIA");
				map.put("UIA_KEYNO", groupKey);
				map.put("UIA_NAME",getAuthName(homeManager.getHM_GROUP_NAME()));
				map.put("UIA_SYSTEM", "P");
				map.put("UIA_MAINKEY", SettingData.AUTHORITY_ADMIN_GROUP);
				map.put("UIA_DEPTH", 2);
				map.put("UIA_ORDER", -1);
				map.put("UIA_DIVISION", "G");
				map.put("UIA_HOMEKEY", homeManager.getHM_GROUP());
				Component.createData("Authority.UIA_insertData", map);
			}
			
			authKeyList.add(groupKey);
			depth = 3;
			UIA_MAINKEY = groupKey;
		}else {
			depth = 2;
			UIA_MAINKEY = SettingData.AUTHORITY_ADMIN_GROUP;
		}
		
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		//서브도메인 기본 그룹 생성
		String mainGroupKey = CommonService.getTableKey("UIA");
		authKeyList.add(mainGroupKey);
		
		
		String name = getAuthName(homeManager.getHM_TITLE());
		
		map.put("UIA_KEYNO", mainGroupKey);
		map.put("UIA_NAME", name);
		map.put("UIA_SYSTEM", "P");
		map.put("UIA_MAINKEY", UIA_MAINKEY);
		map.put("UIA_DEPTH", depth);
		map.put("UIA_ORDER", -1);
		map.put("UIA_DIVISION", "G");
		map.put("UIA_HOMEKEY", homeManager.getHM_KEYNO());
		Component.createData("Authority.UIA_insertData", map);
		
		//서브도메인 기본 권한 생성
		map = new HashMap<String,Object>();
		String authKey = CommonService.getTableKey("UIA");
		authKeyList.add(authKey);
		
		map.put("UIA_KEYNO", authKey);
		map.put("UIA_NAME", name + " 관리자");
		map.put("UIA_SYSTEM", "P");
		map.put("UIA_MAINKEY", mainGroupKey);
		map.put("UIA_DEPTH", depth + 1);
		map.put("UIA_ORDER", 1);
		map.put("UIA_DIVISION", "A");
		map.put("UIA_HOMEKEY", homeManager.getHM_KEYNO());
		Component.createData("Authority.UIA_insertData", map);
		
		
		/**
		 * 1. 생성된 그룹/권한에 관리자페이지 관리자 설정쪽 빼고 모든 권한 추가
		 * 2. 생성된 서브도메인 관련 모든 권한들 관리자그룹,홈페이지 관리자, 생성된 그룹/권한에 부여
		 * 3. 서버권한 재설정.
		 */
		
		List<HashMap<String,Object>> authRollList = new ArrayList<HashMap<String,Object>>();
		
		//1. 생성된 그룹/권한에 관리자페이지 관리자 설정쪽 빼고 모든 권한 추가
		List<String> menuList =  Component.getList("Menu.MN_getDefaultMenuList",homeManager.getHM_MN_HOMEDIV_C());
		
		for(String menu : menuList) {
			for(String key : authKeyList) {
				authRollList.add(createAuthRollMap(key,menu,SettingData.AUTHORITY_ROLE_ACCESS));
				authRollList.add(createAuthRollMap(key,menu,SettingData.AUTHORITY_ROLE_VIEW));
				authRollList.add(createAuthRollMap(key,menu,SettingData.AUTHORITY_ROLE_ACTION));
			}
		}
		
		
		//2. 생성된 서브도메인 관련 모든 권한들 관리자그룹,홈페이지 관리자, 생성된 그룹/권한에 부여
		List<String> authList = Component.getListNoParam("Authority.UIA_GetList4");
		HashMap<String,Object> sqlMap = new HashMap<String,Object>();
		sqlMap.put("MN_HOMEDIV_C", homeManager.getHM_MN_HOMEDIV_C());
		menuList =  Component.getList("Menu.MN_getMenuListByHomeDiv",sqlMap);
		
		//2-1 메뉴 접근권한 부여
		for(String menu : menuList) {
			for(String auth : authList) {
				authRollList.add(createAuthRollMap(auth,menu,SettingData.AUTHORITY_ROLE_ACCESS));
				authRollList.add(createAuthRollMap(auth,menu,SettingData.AUTHORITY_ROLE_VIEW));
				authRollList.add(createAuthRollMap(auth,menu,SettingData.AUTHORITY_ROLE_ACTION));
			}
		}
		
		
		//2-2. 게시판 권한 부여
		
		//2-2-1 기존 게시판 권한 - 부모권한 그대로 설정
		sqlMap = new HashMap<String,Object>();
		sqlMap.put("UIR_TYPE", SettingData.AUTHORITY_SUB_BOARD);
		sqlMap.put("UIA_KEYNO", SettingData.AUTHORITY_ADMIN_GROUP);
		List<HashMap<String,Object>> mainkeysBoardAuthList = Component.getList("Authority.UAR_getMainKeysBoardAuthList", sqlMap);
		for(HashMap<String,Object> mainkeysBoardAuth : mainkeysBoardAuthList) {
			
			String menuKey = (String)mainkeysBoardAuth.get("MN_KEYNO");
			String uirKey = (String)mainkeysBoardAuth.get("UIR_KEYNO");
			
			for(String key : authKeyList) {
				authRollList.add(createAuthRollMap(key,menuKey,uirKey));
			}
		}
		
		
		//2-2-2 신규 도메인 게시판 권한
		List<UserDTO> rollList = Component.getList("Authority.UIR_GetList",CommonService.createMap("UIR_TYPE", SettingData.AUTHORITY_SUB_BOARD) );
		sqlMap = new HashMap<String,Object>();
		sqlMap.put("MN_HOMEDIV_C", homeManager.getHM_MN_HOMEDIV_C());
		sqlMap.put("MN_PAGEDIV_C", SettingData.MENU_TYPE_BOARD);
		menuList =  Component.getList("Menu.MN_getMenuListByHomeDiv",sqlMap);
		
		
		List<String> adminAuthList = new ArrayList<String>();
		
		adminAuthList.addAll(authKeyList);
		adminAuthList.add(SettingData.AUTHORITY_ADMIN_GROUP);
		adminAuthList.add(SettingData.AUTHORITY_ADMIN_MANAGER);
		
		
		for(String menu : menuList) {
			for(UserDTO roll : rollList) {
				String key = roll.getUIR_KEYNO();
				if(SettingData.AUTHORITY_ROLE_READ.equals(key)|| SettingData.AUTHORITY_ROLE_DOWN.equals(key)) {
					for(String auth : authList) {
						authRollList.add(createAuthRollMap(auth,menu,key));
					}
				}else {
					for(String auth : adminAuthList) {
						authRollList.add(createAuthRollMap(auth,menu,key));
					}
				}
			}
		}
		Component.createDataWithSplitList(null, authRollList, "Authority.UAR_insertAll2", "roleList", 200);
		
		
		//3 관리자그룹, 홈페이지관리자, 생성된 그룹/권한에  관리자페이지 권한 부여  
		
		
		HashMap<String,Object> adminAuthMap = new HashMap <String,Object>();
		
		adminAuthMap.put("adminAuthList", adminAuthList);
		adminAuthMap.put("HM_KEYNO", homeManager.getHM_MN_HOMEDIV_C());
		adminAuthMap.put("menuList", Component.getListNoParam("Menu.MN_getAdminAuthMenuList"));
		
		Component.createData("Authority.UAA_insertAll2", adminAuthMap);
		
		//서버 권한 재설정
		applyAuhotiry();
		
	}
	
	/**
	 * 권한 이름 중복 체크 100번 돌려도 중복이면 그냥 에러나겠지...
	 * @param name
	 * @return
	 */
	private String getAuthName(String name) {
		
		String temp = name;
		
		for(int i=0;i<100;i++) {
			int count = Component.getCount("Authority.UIA_checkDuplName",temp);
			if(count > 0) {
				temp = name + "("+(i+1)+")";
			}else {
				break;
			}
		}
		return temp;
	}
	

	private HashMap<String, Object> createAuthRollMap(String auth, String menu, String key) {
		HashMap<String,Object> authRollMap = new HashMap<String,Object>();
		authRollMap.put("UIA_KEYNO", auth);
		authRollMap.put("MN_KEYNO", menu);
		authRollMap.put("UIR_KEYNO", key);
		return authRollMap;
	}

	@Override
	public void deleteDefaultAuthority(String HM_KEYNO) throws Exception {
		// TODO Auto-generated method stub
		
		
		//U_USERINFO_AUTHORITY_ADMIN
		Component.deleteData("Authority.UAA_deleteByHomeManager", HM_KEYNO);
		
		//U_USERINFO_AUTHORITY_ROLL
		Component.deleteData("Authority.UAR_deleteByHomeManager", HM_KEYNO);
		
		//U_USERINFO_MEMBER_AUTHORITY
		Component.deleteData("Authority.UMA_deleteByHomeManager", HM_KEYNO);
		
		//U_USERINFO_AUTHORITY
		Component.deleteData("Authority.UIA_deleteByHomeManager", HM_KEYNO);
		
		//서버 권한 재설정
		applyAuhotiry();
		
	}
}
