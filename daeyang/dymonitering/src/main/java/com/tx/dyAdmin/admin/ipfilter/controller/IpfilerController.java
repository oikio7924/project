package com.tx.dyAdmin.admin.ipfilter.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.admin.code.service.CodeService;
import com.tx.dyAdmin.admin.ipfilter.dto.IP;
import com.tx.dyAdmin.admin.ipfilter.service.IpFilterService;
/**
 * 
 * @FileName: MainController.java
 * @Project : IP 체크
 * @Date    : 2017. 01. 31. 
 * @Author  : 이재령	
 * @Version : 1.0
 */
@Controller
public class IpfilerController {

	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	@Autowired CodeService CodeService;
	/** IP FILTER */
	@Autowired IpFilterService ipFilter;
	

	
	@RequestMapping(value="/dyAdmin/admin/ipfilter.do")
	@CheckActivityHistory(desc="IP화이트/블랙리스트 페이지 방문")
	public ModelAndView ipFilter(HttpServletRequest req
			) throws Exception {
		
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/admin/ipfilter/pra_ipfilter.adm");
		
		
		mv.addObject("codeList", CodeService.getCodeListisUse("AD", true));
		
		mv.addObject("urlList", Component.getListNoParam("ipfilter.IPM_select"));
		return mv;
	}
	
	
	/**
	 * 에러 페이지
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/admin/ipfilter/error.do")
	public ModelAndView ipFilterError(HttpServletRequest request) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/admin/ipfilter/error");
		mv.addObject("IP",CommonService.getClientIP(request));
		return mv;
	}
	
	/**
	 * URL 추가
	 * @param IP
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/admin/ipfilter/main/insert.do")
	@CheckActivityHistory(desc="URL 추가 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView ipFilterMainAdd(@ModelAttribute IP IP
			,HttpServletRequest req
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("redirect:/dyAdmin/admin/ipfilter.do");
		
		IP.setIPM_KEYNO(CommonService.getTableKey("IPM"));
		Component.createData("ipfilter.IPM_insert", IP);
		
		if(IP.getIPM_USEYN().equals("Y")){
			ipFilter.addURL(IP);
		}
		
		return mv;
	}
	
	@RequestMapping(value="/dyAdmin/admin/ipfilter/main/updateAjax.do")
	@CheckActivityHistory(desc="URL 수정 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	@ResponseBody
	public void ipFilterMainUpdate(@ModelAttribute IP IP
			,@RequestParam(value="IPS_IPADDRESS_BEFORE") String IPS_IPADDRESS_BEFORE
			,HttpServletRequest req
			) throws Exception {
		
		
		Component.updateData("ipfilter.IPM_update", IP);
		
		ipFilter.updateURL(IP);
		
	}
	
	/**
	 * URL 삭제
	 * @param IP
	 * @param req
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/admin/ipfilter/main/deleteAjax.do")
	@CheckActivityHistory(desc="URL 삭제 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@ResponseBody
	public void ipFilterMainRemove(@ModelAttribute IP IP
			,HttpServletRequest req
			) throws Exception {
		
		Component.deleteData("ipfilter.IPM_remove", IP);
		
		ipFilter.removeURL(IP);
		
	}
	
	/**
	 * IP 리스트
	 * @param KEYNO
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value="/dyAdmin/admin/ipfilter/subList/listAjax.do")
	@ResponseBody
	public List ipFilterSubList(@RequestParam(value="KEYNO") String KEYNO
			,@RequestParam(value="TYPE") String TYPE
			,HttpServletRequest req
			) throws Exception {
		
		IP IP = new IP();
		IP.setIPS_IPM_KEYNO(KEYNO);
		IP.setIPS_TYPE(TYPE);
		
		
		return Component.getList("ipfilter.IPS_select2", IP);
		
	}
	
	/**
	 * IP 추가
	 * @param IP
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/admin/ipfilter/sub/insert.do")
	@CheckActivityHistory(desc="IP 추가 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView ipFilterAdd(@ModelAttribute IP IP
			,HttpServletRequest req
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("redirect:/dyAdmin/admin/ipfilter.do");
		
		IP.setIPS_KEYNO(CommonService.getTableKey("IPS"));
		
		Component.createData("ipfilter.IPS_insert", IP);
		
		ipFilter.addIP(IP.getIPS_IPM_KEYNO(), IP.getIPS_IPADDRESS());
		
		return mv;
	}
	
	/**
	 * IP 수정
	 * @param IP
	 * @param IPS_IPADDRESS_BEFORE
	 * @param req
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/admin/ipfilter/sub/updateAjax.do")
	@CheckActivityHistory(desc="IP 수정 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	@ResponseBody
	public void ipFilterUpdate(@ModelAttribute IP IP
			,@RequestParam(value="IPS_IPADDRESS_BEFORE") String IPS_IPADDRESS_BEFORE
			,HttpServletRequest req
			) throws Exception {
		
		
		Component.updateData("ipfilter.IPS_update", IP);
		
		ipFilter.updateIP(IP.getIPS_IPM_KEYNO(), IPS_IPADDRESS_BEFORE,IP.getIPS_IPADDRESS());
		/*if(IP.getIPS_TYPE().equals("W")){
			ipFilter.updateArrow(IPS_IPADDRESS_BEFORE,IP.getIPS_IPADDRESS());
		}else{
			ipFilter.updateDeny(IPS_IPADDRESS_BEFORE,IP.getIPS_IPADDRESS());
		}*/
		
	}
	
	/**
	 * IP 삭제
	 * @param IP
	 * @param req
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/admin/ipfilter/sub/deleteAjax.do")
	@CheckActivityHistory(desc="IP 삭제 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@ResponseBody
	public void ipFilterRemove(@ModelAttribute IP IP
			,HttpServletRequest req
			) throws Exception {
		
		Component.deleteData("ipfilter.IPS_remove", IP);
		ipFilter.removeIP(IP.getIPS_IPM_KEYNO(), IP.getIPS_IPADDRESS());
		
	}
	

}
