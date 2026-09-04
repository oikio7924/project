package com.tx.dyAdmin.admin.site.controller;

import javax.servlet.http.HttpServletRequest;
import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.file.FileManageTools;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.publish.CommonPublishService;
import com.tx.dyAdmin.admin.code.service.CodeService;
import com.tx.dyAdmin.admin.site.dto.SiteManagerDTO;
/**
 * 사이트 관리 
 * @date 2019. 6. 26.
 * @author 이재령
 */
@Controller
public class SiteManagerController {

	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	@Autowired FileManageTools FileManageTools;
	@Autowired private CommonPublishService CommonPublishService;
	@Autowired CodeService CodeService;
	
	@RequestMapping(value = "/dyAdmin/admin/site.do")
	@CheckActivityHistory(desc = "사이트 관리 방문")
	public ModelAndView siteManagerView(
			HttpServletRequest req
			) throws Exception{
		ModelAndView mv = new ModelAndView("/dyAdmin/admin/site/pra_site_view.adm");
		
		//홈페이지 구분 리스트 (관리자페이지 제외)
		mv.addObject("homeDivList", CommonService.getHomeDivCode(false));
		mv.addObject("PasswordRegex", CodeService.getCodeListisUse("CR", true));
		mv.addObject("siteManager",Component.getData("SiteManager.getData",SiteProperties.getCmsUser()));
		
		return mv;
	}
	
	@RequestMapping(value = "/dyAdmin/admin/site/updateAjax.do")
	@CheckActivityHistory(desc = "사이트 관리 수정 작업", homeDiv=SettingData.HOMEDIV_ADMIN)
	@Transactional
	@ResponseBody
	public void siteManagerUpdate(
			HttpServletRequest req
			, SiteManagerDTO siteManager
			) throws Exception{
		
		Component.updateData("SiteManager.updateData", siteManager);
		
		SiteProperties.refresh();
		
	}
	
	/**
	 * 모두 배포
	 * @param 
	 * @return
	 * @throws Exception
	 */ 
	@RequestMapping(value = "/dyAdmin/admin/site/distributeAjax.do")
	@CheckActivityHistory(desc = "사이트관리 모두 배포작업", homeDiv=SettingData.HOMEDIV_ADMIN)
	@ResponseBody
	public Boolean siteDistributeAjax(HttpServletRequest req
			) throws Exception{
		
		
		return CommonPublishService.all();
	}
	
}
