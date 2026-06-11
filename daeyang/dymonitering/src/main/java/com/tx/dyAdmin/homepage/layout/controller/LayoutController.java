package com.tx.dyAdmin.homepage.layout.controller;

import java.io.FileReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilderFactory;

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
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import com.google.common.collect.ImmutableMap;
import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.config.annotation.service.ActivityHistoryService;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.file.FileManageTools;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.publish.CommonPublishService;
import com.tx.dyAdmin.admin.domain.dto.HomeManager;
import com.tx.dyAdmin.homepage.layout.service.LayoutService;
import com.tx.dyAdmin.homepage.menu.dto.Menu;
import com.tx.dyAdmin.homepage.resource.dto.ResourcesDTO;

@Controller
public class LayoutController {
	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	@Autowired FileManageTools FileManageTools;
	
	@Autowired
	private CommonPublishService CommonPublishService;
	
	@Autowired
	private LayoutService LayoutService;
	/** 활동기록 서비스 */
	@Autowired
	private ActivityHistoryService ActivityHistoryService;
	
	/**
	 * 레이아웃 관리
	 * @param req
	 * @param Menu
	 * @return
	 * @throws Exception
	 */   
	@RequestMapping(value = "/dyAdmin/homepage/layout/layout.do")
	@CheckActivityHistory(desc = "레이아웃 관리 방문")
	public ModelAndView layoutView(
			HttpServletRequest req
			, Menu Menu
			,@RequestParam(value="SCOPE",required=false) String SCOPE
			) throws Exception{
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/layout/pra_layout_view.adm");
		
		mv.addObject("MN_HOMEDIV_C", CommonService.getDefaultSiteKey(req));
		mv.addObject("SCOPE", SCOPE);
		
		return mv;
	}
	
	/**
	 * 레이아웃 관리 - 레이아웃 저장처리
	 * @param ResourcesDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/layout/insert.do")
	@ResponseBody
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public HashMap<String, Object> layoutInsert(
			ResourcesDTO ResourcesDTO
			, @RequestParam(value="MN_HOMEDIV_C", required=false) String MN_HOMEDIV_C
			, @RequestParam(value="actionType", required=false) String actiontype
			, @RequestParam(value="currentVersion", required=false) Double currentVersion
			, HttpServletRequest req
			)throws Exception {
		
		HashMap<String, Object> resultMap = new HashMap<>();
		
		//버전 체크 후, boolean값과 버전값을 map에 저장
		LayoutService.dataVersionCheck(resultMap, ResourcesDTO, currentVersion);
		
		
		if((Boolean)resultMap.get("updateCheck")){	
			//데이터 저장 또는 수정 처리
			LayoutService.dataActionProcess(req, actiontype, ResourcesDTO, MN_HOMEDIV_C, (double)resultMap.get("historyVersion"));
		}
		
		resultMap.put("scope", ResourcesDTO.getRM_SCOPE());
		resultMap.put("historyMainKey", ResourcesDTO.getRM_KEYNO());
	
		ActivityHistoryService.setDescResourceAction(ResourcesDTO.getHomeName(), "layout", "insert", req);
		
		return resultMap;
		

	}
	
	/**
	 * 레이아웃 관리 - 배포  
	 * @param model
	 * @param ResourcesDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/layout/distributeAjax.do")
	@ResponseBody
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	public Boolean layoutDistributeAjax(
			Model model
			,ResourcesDTO ResourcesDTO
			, HttpServletRequest req
			) throws Exception{
		
		String path = Component.getData("HomeManager.get_sitePath", ResourcesDTO.getRM_MN_HOMEDIV_C());
		
		boolean state = CommonPublishService.layout(path,  ResourcesDTO.getRM_MN_HOMEDIV_C(), ResourcesDTO.getRM_SCOPE(), ResourcesDTO.getDISTRIBUTE_TYPE());
		
		ActivityHistoryService.setDescResourceAction(ResourcesDTO.getHomeName(), "layout", "distribute", req);
		
		return state;
	}
	
	/**
	 * 스킨 리스트 가져오기
	 * 
	 * @param ResourcesDTO
	 * @return
	 * @throws Exception
	 */  
	@RequestMapping(value = "/dyAdmin/homepage/layout/importListAjax.do")
	@ResponseBody
	public List<HashMap<String, Object>> importListAjax(
			) throws Exception{
		List<HashMap<String, Object>> list = Component.getListNoParam("Common.get_importList");
		
		return list;
	}
	
	
	/**
	 * index 및 기타파일 리스트 페이지 - admin  
	 * @param model
	 * @param Menu
	 * @param RM_KEYNO
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/admin/indexlayout.do")
	@CheckActivityHistory(desc = "인덱스 관리 페이지 방문")
	public ModelAndView IndexSettingView(
			 Model model
			,Menu Menu
			,@RequestParam(value="RM_KEYNO",required=false) String RM_KEYNO
			, HttpServletRequest req) throws Exception{
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/layout/pra_index_list.adm");
		
		HashMap<String, Object> map = new HashMap<>();
		//디비에 저장안했을 때 디폴트로 뿌려준다.
		HashMap<String, String> scopeMap = new HashMap<>();
		scopeMap.put("index", "index");
		scopeMap.put("robots", "robots");
		String[] scope = {"index", "robots"};
		
		List<String> list = new ArrayList<>(Arrays.asList(scope));
		
		map.put("MN_KEYNO", Menu.getMN_KEYNO());
		map.put("RM_TYPE", "index");
		List<HashMap<String, Object>> resultList = Component.getList("Resources.RM_getList", map);
		List<String> scopeList = Component.getList("Resources.RM_getScope", map);
		
		for (String scopeName : scopeList) {
			list.remove(scopeName);
		}
		
		mv.addObject("scopeList", list);
		mv.addObject("scopeMap", scopeMap);
		mv.addObject("ResourcesList", resultList);
		mv.addObject("SELECT_KEYNO",RM_KEYNO);
		return mv;
		
	}
	
	/**
	 * 인덱스 및 기타 파일 저장하기 - admin
	 * 
	 * @param TCS_KEYNO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/layout/{resourceType}/insert.do")
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView orderDataInsert(
			  @ModelAttribute ResourcesDTO ResourcesDTO
			, @RequestParam(value="MN_HOMEDIV_C", required=false) String MN_HOMEDIV_C
			, @RequestParam(value="actionType", required=false) String actiontype
			, @RequestParam(value="currentVersion", required=false) Double currentVersion
			, @RequestParam(value="beforeFileNm", required=false) String beforeFileNm
			, @PathVariable String resourceType
			, HttpServletRequest req
			, RedirectAttributes redirectAttributes)
			throws Exception {
		ModelAndView mv  = new ModelAndView();
		
		//파일명 변경시 기존 파일 삭제 처리
		if(StringUtils.isNotEmpty(beforeFileNm) && !beforeFileNm.equals(ResourcesDTO.getRM_FILE_NAME())){
			FileManageTools.deleteFolder(CommonService.pathSubString(SiteProperties.getString("JSP_PATH"), 12) + "/" + beforeFileNm);
		}
		
		//데이터 저장 또는 수정 처리
		LayoutService.dataActionProcess(req, actiontype, ResourcesDTO, MN_HOMEDIV_C, currentVersion);
		
		String msg = "저장되었습니다.";
		if(actiontype.equals("update")){
			msg = "수정되었습니다.";
		}
		
		String returnUrl = "redirect:/dyAdmin/admin/indexlayout.do?RM_KEYNO="+ResourcesDTO.getRM_KEYNO();
		if("sitemap".equals(resourceType)){
			returnUrl = "redirect:/dyAdmin/homepage/layout/sitemap.do?MN_HOMEDIV_C="+ResourcesDTO.getRM_MN_HOMEDIV_C();
		}
		
		redirectAttributes.addFlashAttribute("msg",msg);
		mv.setViewName(returnUrl);
		
		ActivityHistoryService.setDescResourceAction(ResourcesDTO.getHomeName(), resourceType, actiontype, req);
		return mv;

	}

	/**
	 * 사이트맵 관리 페이지 방문
	 * 
	 * @param MN_HOMEDIV_C
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/layout/sitemap.do")
	@CheckActivityHistory(desc = "사이트맵 관리 방문")
	public ModelAndView siteMapView(HttpServletRequest req) throws Exception {
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/layout/pra_sitemap_list.adm");

		String actionType = "insert";
		String filePath = CommonService.pathSubString(SiteProperties.getString("JSP_PATH"), 12);
		String fileName = "sitemap";
		
		String MN_HOMEDIV_C = CommonService.getDefaultSiteKey(req);
		
		// 파일 유무 체크
		HomeManager hm = Component.getData("HomeManager.HM_getDataByHOMEDIV_C", MN_HOMEDIV_C);
		
		if(hm != null) fileName = "sitemap-" + hm.getHM_TILES();		
		
		if (!FileManageTools.fileExistsCheck(filePath + "/"+ fileName + ".xml")) {			
			ImmutableMap<String, Object> map = ImmutableMap.<String, Object>builder()
					.put("MN_HOMEDIV_C",MN_HOMEDIV_C)
					.put("DOMAIN", CommonService.checkUrl(req))
					.build();			
			
			mv.addObject("MenuInfoList", Component.getList("Menu.XML_getMenuInfoAll", map));	
		} else {			
			actionType = "update";

			List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
			
			try {								
				NodeList list = DocumentBuilderFactory.newInstance()
						.newDocumentBuilder()
						.parse(new InputSource(new FileReader(filePath + "/"+ fileName + ".xml")))
						.getDocumentElement()
						.getChildNodes();

				if (list.getLength() > 0) {
					for (int i = 0; i < list.getLength(); i++) {
						Map<String, Object> map = new HashMap<String, Object>();
						NodeList childList = list.item(i).getChildNodes();
						if (childList.getLength() > 0) {
							for (int j = 0; j < childList.getLength(); j++) {
								// 텍스트가 있는거만 put
								if (childList.item(j).getNodeName().equals("#text") == false) {
									map.put(childList.item(j).getNodeName(), childList.item(j).getTextContent());
								}
							}
							listMap.add(map);
						}
					}
				}
				
			} catch (Exception e) {
				System.out.println("사이트맵 xml 파일 데이터 호출 에러");
			}
			
			mv.addObject("MenuInfoList", listMap);
			
		}
		
		mv.addObject("fileName", fileName);
		mv.addObject("actionType", actionType);
		mv.addObject("MN_HOMEDIV_C", MN_HOMEDIV_C);

		return mv;
	}
	


}