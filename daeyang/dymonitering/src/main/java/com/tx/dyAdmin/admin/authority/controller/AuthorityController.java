package com.tx.dyAdmin.admin.authority.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.security.handler.ReloadableFilterInvocationSecurityMetadataSource;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.admin.authority.service.AdminAuthorityService;
import com.tx.dyAdmin.admin.domain.dto.HomeManager;
import com.tx.dyAdmin.homepage.menu.dto.Menu;
import com.tx.dyAdmin.homepage.menu.service.AdminMenuService;

/**
 * 
 * @FileName: AuthorityController.java
 * @Project : CT CMS
 * @Date    : 2017. 02. 28. 
 * @Author  : 트로닉스 이재령	
 * @Version : 1.0
 * @meno	:
 * 	슈퍼관리자는  항상 어디든 접근가능하다.
 * 	메뉴별 권한 처리할때 슈퍼관리자는 항상 추가해준다. (SettingData.AUTHORITY_ADMIN)
 */
@Controller
public class AuthorityController {

	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 권한관리 서비스 */
	@Autowired private AdminAuthorityService AdminAuthorityService;
	
	/** 리로드 권한설정 */
	@Autowired ReloadableFilterInvocationSecurityMetadataSource reloadableFilterInvocationSecurityMetadataSource;
	
	/**
	 * 권한 관리
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/admin/authority.do")
	@CheckActivityHistory(desc="권한 관리 페이지 방문")
	public ModelAndView adminAuthorityView(HttpServletRequest req
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/admin/authority/pra_authority_view.adm");
		
		
		return mv;
	}
	
	/**
	 * 권한 관리 - 권한 / 회원 목록 가져오기
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/admin/authority/listAjax.do")
	public ModelAndView adminAuthorityListAjax(HttpServletRequest req
			, @RequestParam String type
			, @RequestParam(value="pageIndex",defaultValue="1") Integer pageIndex
			, @RequestParam(value="searchKeyword",required=false) String searchKeyword
			) throws Exception {
		
		
		return AdminAuthorityService.getListAjax("/dyAdmin/admin/authority/list/pra_authority_list_"+type,type,pageIndex,searchKeyword);
	}
	
	
	@RequestMapping(value="/dyAdmin/admin/authority/dataAjax.do")
	@ResponseBody
	public List<HashMap<String,Object>> adminAuthorityDataAjax(HttpServletRequest req
			) throws Exception {
		
		List<HashMap<String,Object>> list = Component.getListNoParam("Authority.UIA_GetList3");
		
		return list;
	}
	
	@RequestMapping(value="/dyAdmin/admin/authority/saveAjax.do")
	@ResponseBody
	@Transactional
	@CheckActivityHistory(desc="권한 관리 권한 구조 추가/변경 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	public void adminAuthoritySaveAjax(HttpServletRequest req
			) throws Exception {
		
		
		AdminAuthorityService.save(req);
		
	}
	
	@RequestMapping(value="/dyAdmin/admin/authority/menuListAjax.do")
	public ModelAndView adminAuthorityMenuListAjax(HttpServletRequest req
			,@RequestParam String type
			,@RequestParam String key
			) throws Exception {
		
		
		return AdminAuthorityService.getMenuList("/dyAdmin/admin/authority/list/pra_authority_menuList",type,key);
	}
	
	@RequestMapping(value="/dyAdmin/admin/authority/saveMenuListAjax.do")
	@ResponseBody
	@Transactional
	@CheckActivityHistory(desc="권한 관리 - 권한별 메뉴 접근 권한 변경 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	public String adminAuthoritySaveMenuListAjax(HttpServletRequest req
			) throws Exception {
		
		return AdminAuthorityService.saveMenuListByAuthority(req);
		
	}
	

	@RequestMapping(value="/dyAdmin/admin/authority/applyAuthorityAjax.do")
	@ResponseBody
	@Transactional
	@CheckActivityHistory(desc="권한 관리 - 서버 권한 재설정 작업", homeDiv = SettingData.HOMEDIV_ADMIN)
	public void adminAuthorityApplyAuthorityAjax(HttpServletRequest req
			) throws Exception {
		
		
		AdminAuthorityService.applyAuhotiry();
		
		
	}
}
