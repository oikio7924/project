package com.tx.dyAdmin.admin.domain.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.dto.Common;
import com.tx.dyAdmin.admin.domain.dto.HomeManager;
import com.tx.dyAdmin.admin.domain.service.AdmDomainService;
import com.tx.dyAdmin.homepage.menu.dto.Menu;

@Controller
public class AdmDomainController {

	
	@Autowired private AdmDomainService AdmDomainService;
	
	/**
	 * 서브 도메인 관리
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/admin/domain.do")
	@CheckActivityHistory(desc = "서브도메인 관리 방문")
	public ModelAndView domain(
			HttpServletRequest req
			) throws Exception{
		ModelAndView mv = new ModelAndView("/dyAdmin/admin/domain/pra_domain_list.adm");
		
		return mv;
	}
	
	
	/**
	 * 서브 도메인 관리 - 페이징 ajax
	 * @param req
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/admin/domain/pagingAjax.do")
	public ModelAndView domainPagingAjax(HttpServletRequest req,HttpServletResponse res,
			Common search
			) throws Exception {
		
		return AdmDomainService.paging("/dyAdmin/admin/domain/pra_domain_list_data",req,search);
		
		
	}
	/**
	 * 서브 도메인 관리 - excel ajax
	 * @param req
	 * @param res
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/admin/domain/excelAjax.do")
	public ModelAndView domainExcelAjax(HttpServletRequest req
			, HttpServletResponse res
			, Common search
			) throws Exception {
		
		
		return AdmDomainService.excel("/dyAdmin/admin/domain/pra_domain_list_excel",req,res,search);
		
	}
	
	@RequestMapping(value = "/dyAdmin/admin/domain/dataAajx.do")
	public ModelAndView domainDataAjax(
			HttpServletRequest req
			, @RequestParam(value="HM_KEYNO", defaultValue="") String HM_KEYNO
			) throws Exception{
		
		return AdmDomainService.data("/dyAdmin/admin/domain/pra_domain_insertView",HM_KEYNO);
		
		
	}
	
	@RequestMapping(value = "/dyAdmin/admin/domain/checkTilesNameAjax.do")
	@ResponseBody
	public String MenuManagerHomeCheckTilesName(Model model
			,@RequestParam("value") String value
			,@RequestParam("type") String type
			) throws Exception{ 
		
		return AdmDomainService.checkTilesName(value,type);
	}
	
	/**
	 * 홈페이지 신규 등록 - admin
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 * 
	 */   					 
	@RequestMapping(value = "/dyAdmin/admin/domain/insertAjax.do")
	@CheckActivityHistory(desc = "홈페이지 신규 등록 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	@ResponseBody
	public String MenuManagerHomeResist(HttpServletRequest req,
			HomeManager hm,
			Menu Menu,
			@RequestParam(value="homeimg", required = false ) MultipartFile thumbnail,
			@RequestParam(value="template", required = false ) String template,
			@RequestParam(value="UIA_KEYNO", required = false ) String[] UIA_KEYNO,
			@RequestParam(value="HAM_DEFAULT_URL", required = false ) String[] HAM_DEFAULT_URL
			) throws Exception{ 
		
		HashMap<String,Object> paramMap = new HashMap<String,Object>();
		paramMap.put("hm", hm);
		paramMap.put("Menu", Menu);
		paramMap.put("thumbnail", thumbnail);
		paramMap.put("template", template);
		paramMap.put("UIA_KEYNO", UIA_KEYNO);
		paramMap.put("HAM_DEFAULT_URL", HAM_DEFAULT_URL);
		
		return AdmDomainService.insert(paramMap,req);
		
	}
	
	
	
	/**
	 * 홈페이지 수정 - admin
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 * 
	 */   					 
	@RequestMapping(value = "/dyAdmin/admin/domain/updateAjax.do")
	@CheckActivityHistory(desc = "홈페이지 수정 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	@ResponseBody
	public String MenuManagerHomeUpdate(HttpServletRequest req,
			HomeManager hm,
			Menu Menu ,
			@RequestParam(value="homeimg", required = false ) MultipartFile thumbnail,
			@RequestParam(value="UIA_KEYNO", required = false ) String[] UIA_KEYNO,
			@RequestParam(value="HAM_DEFAULT_URL", required = false ) String[] HAM_DEFAULT_URL
			) throws Exception{ 
		
		HashMap<String,Object> paramMap = new HashMap<String,Object>();
		paramMap.put("hm", hm);
		paramMap.put("Menu", Menu);
		paramMap.put("thumbnail", thumbnail);
		paramMap.put("UIA_KEYNO", UIA_KEYNO);
		paramMap.put("HAM_DEFAULT_URL", HAM_DEFAULT_URL);
		
		return AdmDomainService.update(paramMap,req);
		
	}
	

	/**
	 * 홈페이지 삭제 - admin
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 * 
	 */   					 
	@RequestMapping(value = "/dyAdmin/admin/domain/deleteAjax.do")
	@CheckActivityHistory(desc = "홈페이지 삭제 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	@ResponseBody
	public void MenuManagerHomeDelete(HttpServletRequest req
			, @RequestParam("HM_KEYNO") String HM_KEYNO) throws Exception{ 
		
		AdmDomainService.delete(HM_KEYNO, req);
		
	}
	
}
