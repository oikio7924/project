package com.tx.dyAdmin.homepage.layout.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
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
import com.tx.common.service.publish.CommonPublishService;
import com.tx.dyAdmin.homepage.layout.service.LayoutService;
import com.tx.dyAdmin.homepage.resource.dto.ResourcesDTO;

@Controller
public class LayoutCommonController {
	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	@Autowired FileManageTools FileManageTools;
	
	@Autowired
	private LayoutService LayoutService;
	/** 활동기록 서비스 */

	@Autowired
	private ActivityHistoryService ActivityHistoryService;
	
	@Autowired
	private CommonPublishService CommonPublishService;
	
	
	/**
	 * 데이터 Ajax
	 * @param ResourcesDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/common/{resourceType:css|js|index|layout}/dataAjax.do")
	@ResponseBody
	public HashMap<String,Object> layoutDataAjax(
			ResourcesDTO ResourcesDTO
			,@PathVariable String resourceType
			) throws Exception{
		
		String query = "Resources.RM_getData";
		
		if("layout".equals(resourceType)){
			ResourcesDTO.setRM_TYPE(resourceType);
			query = "Resources.RM_getLayoutData";
		}

		return Component.getData(query, ResourcesDTO);
	}
	
	/**
	 * 히스토리 데이터 Ajax
	 * @param ResourcesDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/common/{resourceType:css|js|index|layout}/dataHistoryAjax.do")
	@ResponseBody
	public List<HashMap<String, Object>> layoutDataHistoryAjax(
			ResourcesDTO ResourcesDTO
			) throws Exception{
		
		return Component.getList("Resources.RMH_getList", ResourcesDTO);
	}
	
	
	/**
	 * 데이터 복원처리  
	 * @param req
	 * @param ResourcesDTO
	 * @param resourceType
	 * @param HomeName
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/common/recovery/dataReturnAjax.do")
	@ResponseBody
	public HashMap<String, Object> CreateCSS_DetailViewReturnPage(
			HttpServletRequest req
			, ResourcesDTO ResourcesDTO
			) throws Exception{
		
		return LayoutService.dataReturnPage(ResourcesDTO);
	}
	
	
	/**
	 *  최신데이터와 비교, 변경사항
	 * 
	 * @param ResourcesDTO
	 * @return
	 * @throws Exception
	 */  
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/dyAdmin/homepage/common/compare/dataCompareAjax.do")
	@ResponseBody
	public List layoutCompareAjax(HttpServletRequest req, ResourcesDTO ResourcesDTO
			) throws Exception{
		
		return Component.getList("Resources.RMH_compareData", ResourcesDTO);
	}
	

	/**
	 * 리소스 배포 - admin
	 * @param resourceType
	 * @param ResourcesDTO
	 * @param req
	 * @param redirectAttributes
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/common/{resourceType:css|js|index|sitemap}/distributeAjax.do")
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	public ModelAndView cssDistributeAjax(
			  @PathVariable String resourceType
			, ResourcesDTO ResourcesDTO
			, HttpServletRequest req
			, RedirectAttributes redirectAttributes
			) throws Exception{
		ModelAndView mv = new ModelAndView();
		
		String key = "";
		
		if(!ResourcesDTO.getDISTRIBUTE_TYPE()) key = ResourcesDTO.getRM_KEYNO();
		
		String returnUrl = "";
		
		if("index".equals(resourceType)){			
			CommonPublishService.index(key, resourceType, ResourcesDTO.getRM_SCOPE(), ResourcesDTO.getDISTRIBUTE_TYPE());								
			returnUrl = "redirect:/dyAdmin/homepage/layout/indexlayout.do?RM_KEYNO="+ResourcesDTO.getRM_KEYNO();				
		} else if("sitemap".equals(resourceType)){			
			CommonPublishService.sitemap(ResourcesDTO.getRM_FILE_NAME(), ResourcesDTO.getRM_DATA());			
			returnUrl = "redirect:/dyAdmin/homepage/layout/sitemap.do?MN_HOMEDIV_C="+ResourcesDTO.getRM_MN_HOMEDIV_C();			
		} else {
			String path = Component.getData("HomeManager.get_sitePath", ResourcesDTO.getRM_MN_HOMEDIV_C());			
			String homeDiv = ResourcesDTO.getRM_MN_HOMEDIV_C();
			
			CommonPublishService.resource(path,homeDiv, key, resourceType);	
			returnUrl = "redirect:/dyAdmin/homepage/resource/"+resourceType+".do?RM_KEYNO="+ResourcesDTO.getRM_KEYNO()+"&MN_HOMEDIV_C="+ResourcesDTO.getRM_MN_HOMEDIV_C();
		}
		
		ActivityHistoryService.setDescResourceAction(ResourcesDTO.getHomeName(), resourceType, "distribute", req);

		redirectAttributes.addFlashAttribute("msg","배포되었습니다.");		
		mv.setViewName(returnUrl);
		

		return mv;
	}
	
	/**
	 * 버전 체크
	 * @param ResourcesDTO
	 * @param currentVersion
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/resource/{resourceType:css|js|index}/versionCheckAjax.do")
	@Transactional
	@ResponseBody
	public HashMap<String, Object> resourceDataVersionCheck(
			  @ModelAttribute ResourcesDTO ResourcesDTO
			, @RequestParam(value="currentVersion", required=false) Double currentVersion)
			throws Exception {
		
		HashMap<String, Object> resultMap = new HashMap<>();
		
		//버전 체크 후, boolean값과 버전값을 map에 저장
		LayoutService.dataVersionCheck(resultMap, ResourcesDTO, currentVersion);
		
		resultMap.put("scope", ResourcesDTO.getRM_SCOPE());
		resultMap.put("historyMainKey", ResourcesDTO.getRM_KEYNO());
		
		return resultMap;
	}
	
	/**
	 * 리소스 삭제
	 * @param ResourcesDTO
	 * @param req
	 * @param resourceType
	 * @param HomeName
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/common/{resourceType:css|js|index}/DeleteAjax.do")
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	@ResponseBody
	public void resourcesDeleteAjax(
			     ResourcesDTO ResourcesDTO
			   , HttpServletRequest req
			   , @PathVariable String resourceType
			) throws Exception{
		
		ResourcesDTO.setRM_TYPE(resourceType);
		
		//파일 삭제 처리
		String path = Component.getData("HomeManager.get_sitePath", ResourcesDTO.getRM_MN_HOMEDIV_C());
		String file = CommonService.pathSubString(SiteProperties.getString("JSP_PATH"), 12) + "/" + ResourcesDTO.getRM_FILE_NAME();
		//삭제할 데이터를 제외하고 순서 다시 세팅 css,js에 적용
		if(!"index".equals(resourceType)){
			Component.updateData("Resources.RM_setOrderSetting", ResourcesDTO);
			file = SiteProperties.getString("RESOURCE_PATH") + "publish/" + path + "/" + resourceType + "/" + ResourcesDTO.getRM_FILE_NAME() + "." + resourceType;
		}
		
		FileManageTools.deleteFolder(file);
		
		if(StringUtils.isNotEmpty(ResourcesDTO.getRM_KEYNO())){
			Component.deleteData("Resources.RM_delete", ResourcesDTO.getRM_KEYNO());  //삭제할 데이터는 순서 0으로 초기화
		}
		
		
		// 활동기록
		ActivityHistoryService.setDescResourceAction(ResourcesDTO.getHomeName(), resourceType, "delete", req);
	}
	
	/**
	 * 사이트맵 xml 파일 삭제
	 * 
	 * @param MN_HOMEDIV_C
	 * @param RM_FILE_NAME
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/common/sitemap/fileDelete.do")
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	public ModelAndView siteMapFileDelete(@RequestParam(value = "MN_HOMEDIV_C", required = false) String MN_HOMEDIV_C
			,@RequestParam(value = "RM_FILE_NAME", required = false) String RM_FILE_NAME
			,@RequestParam(value = "homeName", required = false) String homeName
			, HttpServletRequest req) throws Exception {
		ModelAndView mv = new ModelAndView();

		FileManageTools.deleteFolder(CommonService.pathSubString(SiteProperties.getString("JSP_PATH"), 12) + "/" + RM_FILE_NAME + ".xml");
				
		ActivityHistoryService.setDescResourceAction(homeName, "sitemap", "delete", req);

		String returnUrl = "redirect:/dyAdmin/homepage/layout/sitemap.do?MN_HOMEDIV_C="+MN_HOMEDIV_C;			
		mv.setViewName(returnUrl);
		
		return mv;
	}
	
	
	
}