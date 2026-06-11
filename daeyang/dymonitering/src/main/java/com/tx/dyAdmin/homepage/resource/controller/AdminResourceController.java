package com.tx.dyAdmin.homepage.resource.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.config.annotation.service.ActivityHistoryService;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.file.FileManageTools;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.admin.domain.dto.HomeManager;
import com.tx.dyAdmin.homepage.layout.service.LayoutService;
import com.tx.dyAdmin.homepage.menu.dto.Menu;
import com.tx.dyAdmin.homepage.menu.service.AdminMenuService;
import com.tx.dyAdmin.homepage.resource.dto.ResourcesDTO;

@Controller
public class AdminResourceController {
	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	@Autowired FileManageTools FileManageTools;

	/** 메뉴리스트 서비스 */
	@Autowired private AdminMenuService AdminMenuService;
	
	/** 활동기록 서비스 */
	@Autowired
	private ActivityHistoryService ActivityHistoryService;
	
	@Autowired
	private LayoutService LayoutService;
	
	/**
	 * CSS/js설정 리스트 페이지 - admin 
	 * @param model
	 * @param Menu
	 * @param resourceType
	 * @param RM_KEYNO
	 * @param MN_HOMEDIV_C
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/resource/{resourceType:css|js}.do")
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	public ModelAndView resourceSettingView( 
			 Model model
			,Menu Menu
			,@PathVariable String resourceType
			,@RequestParam(value="RM_KEYNO",required=false) String RM_KEYNO
			, HttpServletRequest req) throws Exception{
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/resource/pra_resources_list.adm");
		
		Menu.setMN_KEYNO(CommonService.getDefaultSiteKey(req));
		
		Menu = Component.getData("Menu.AMN_getDataByKey", Menu);
		mv.addObject("menu", Menu);
		
		HashMap<String, Object> map = new HashMap<>();
		//디비에 저장안했을 때 디폴트로 뿌려준다.
		HashMap<String, String> scopeMap = new HashMap<>();
		scopeMap.put("common", "공통");
		scopeMap.put("main", "메인");
		scopeMap.put("sub", "서브");
		scopeMap.put("board", "게시판");
		String[] scope = {"common","main","sub","board"};
		
		List<String> list = new ArrayList<>(Arrays.asList(scope));
		
		map.put("MN_KEYNO", Menu.getMN_KEYNO());
		map.put("RM_TYPE", resourceType);
		List<HashMap<String, Object>> resultList = Component.getList("Resources.RM_getList", map);
		List<String> scopeList = Component.getList("Resources.RM_getScope", map);
		
		for (String scopeName : scopeList) {
			list.remove(scopeName);
		}
		
		// 활동기록
		ActivityHistoryService.setDescResourceAction(Menu.getMN_NAME(), resourceType, "insertView", req);
		
		mv.addObject("scopeList", list);
		mv.addObject("scopeMap", scopeMap);
		mv.addObject("ResourcesList", resultList);
		mv.addObject("resourcesType",resourceType);
		mv.addObject("SELECT_KEYNO",RM_KEYNO);
		return mv;
	}
	
	/**
	 * 메뉴 리스트 조회하기
	 * @param Menu
	 * @param resourceType
	 * @param KEYNO
	 * @param ResourcesDTO
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/resource/{resourceType:css|js}/MenuListAjax.do")
	public ModelAndView resourceMenuListAjax(
			 Menu Menu
			,@PathVariable String resourceType
			,@RequestParam(value="KEYNO", required=false) String KEYNO
			,ResourcesDTO ResourcesDTO
			,HttpServletRequest req
			) throws Exception{
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/resource/pra_resources_list_data");
		if(KEYNO != null && !KEYNO.equals("")){
			Integer RMCNT = Component.getCount("Resources.RMS_selectCount", KEYNO);
			if(RMCNT > 0){
				mv.addObject("MenuKeys", Component.getData("Resources.RMS_selectMenuKey", KEYNO));
			}
		}
		
		Menu.setMN_DEL_YN("N");
		HomeManager homeManager = Component.getData("Menu.AMN_getMenuList",Menu);
		mv.addObject("homeManager", homeManager);
		//권한별 메뉴 조회
		Map<String,Object> user = CommonService.getUserInfo(req);
		String userKeyno = ((String) user.get("UI_KEYNO"));
		String UIA_KEYNO = Component.getData("Authority.UIA_getDataByUIKEYNO", userKeyno);
		homeManager.setUIA_KEYNO(UIA_KEYNO);
		mv.addObject("menuList", AdminMenuService.getMenuList(homeManager,null,true));
		return mv;
	}
		
	/**
	 * 리소스 저장,수정 처리
	 * @param ResourcesDTO
	 * @param resourceType
	 * @param MN_HOMEDIV_C
	 * @param actiontype
	 * @param ApplyMenu
	 * @param currentVersion
	 * @param req
	 * @param redirectAttributes
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/resource/{resourceType:css|js}/insert.do")
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView resourceDataInsert(
			  @ModelAttribute ResourcesDTO ResourcesDTO
		    , @PathVariable String resourceType
			, @RequestParam(value="MN_HOMEDIV_C", required=false) String MN_HOMEDIV_C
			, @RequestParam(value="actionType", required=false) String actiontype
			, @RequestParam(value="ApplyMenu", required=false) String ApplyMenu
			, @RequestParam(value="currentVersion", required=false) Double currentVersion
			, @RequestParam(value="beforeFileNm", required=false) String beforeFileNm
			, HttpServletRequest req
			, RedirectAttributes redirectAttributes)
			throws Exception {
		ModelAndView mv  = new ModelAndView();
		//파일명 변경시 기존 파일 삭제 처리
		if(StringUtils.isNotEmpty(beforeFileNm) && !beforeFileNm.equals(ResourcesDTO.getRM_FILE_NAME())){		
            String path = Component.getData("HomeManager.get_sitePath", ResourcesDTO.getRM_MN_HOMEDIV_C());
			FileManageTools.deleteFolder(
					SiteProperties.getString("RESOURCE_PATH") + "publish/" + path + "/" + resourceType + "/" + beforeFileNm + "." + resourceType);
		}
		//데이터 저장 또는 수정 처리
		LayoutService.dataActionProcess(req, actiontype, ResourcesDTO, MN_HOMEDIV_C, currentVersion);
		
		/* 리소스가 적용될 메뉴 키들을 등록한다. */
		HashMap<String, Object> subMap = new HashMap<>();
		Component.deleteData("Resources.RMS_delete", ResourcesDTO.getRM_KEYNO());
		subMap.put("RMS_RM_KEYNO", ResourcesDTO.getRM_KEYNO());
		subMap.put("RMS_MN_TYPE", ResourcesDTO.getRMS_MN_TYPE());
		if(ResourcesDTO.getRMS_MN_TYPE().equals("N")){
			if(ApplyMenu != null && !ApplyMenu.equals("")){
				String[] ResourcesMenu = ApplyMenu.split(",");
				for (String string : ResourcesMenu) {
					subMap.put("RMS_MN_KEYNO",string);
					Component.createData("Resources.RMS_insert", subMap);
				}
			}
		}else{
			subMap.put("RMS_MN_KEYNO",ResourcesDTO.getRM_MN_HOMEDIV_C());
			Component.createData("Resources.RMS_insert", subMap);
		}
		
		
		String msg = "저장되었습니다.";
		if(actiontype.equals("update")){
			msg = "수정되었습니다.";
		}
		
		// 활동기록
		ActivityHistoryService.setDescResourceAction(ResourcesDTO.getHomeName(), resourceType, actiontype, req);
		
		redirectAttributes.addFlashAttribute("msg",msg);
		mv.setViewName("redirect:/dyAdmin/homepage/resource/"+resourceType+".do?RM_KEYNO="+ResourcesDTO.getRM_KEYNO()+"&MN_HOMEDIV_C="+MN_HOMEDIV_C);
		
		return mv;

	}
	
	/**
	 * 리소스 순서 변경작업
	 * @param resourceType
	 * @param arrKeyno
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/resource/{resourceType:css|js}/OrderSettingAjax.do")
	@ResponseBody
	public void resourcesOrderSettingAjax(
			  @PathVariable String resourceType
			 ,@RequestParam(value="arrKeyno[]") List<String> arrKeyno
			) throws Exception{
		HashMap<String, Object> map = new HashMap<>();
		if(arrKeyno != null && arrKeyno.size() != 0){
			for (int i = 0; i < arrKeyno.size(); i++) {
				if(StringUtils.isNoneEmpty(arrKeyno.get(i))){
					map.put("RM_KEYNO", arrKeyno.get(i));
					map.put("RM_ORDER", i+1);
					Component.updateData("Resources.RM_setOrder", map);
				}
			}
		}
	}
	
}