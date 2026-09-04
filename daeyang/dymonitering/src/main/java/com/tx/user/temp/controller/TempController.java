package com.tx.user.temp.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.tld.SiteProperties;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.homepage.menu.dto.Menu;
import com.tx.dyAdmin.homepage.menu.service.AdminMenuService;

@Controller
public class TempController {

	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	
	@Autowired AdminMenuService AdminMenuService;
	
	@RequestMapping(value="/common/test.do")
	public ModelAndView main2(HttpServletRequest req, Map<String,Object> commandMap
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/user/dy/sub/temp/temp");
		
		SiteProperties.refresh();
		System.out.println(SiteProperties.getString("HOMEPAGE_NAME"));
		System.out.println(SiteProperties.getString("EMAIL_SENDER_NAME"));
		System.out.println("3");
		System.out.println(SiteProperties.getCmsUser());
		return mv;
	}
	
	
/*	@RequestMapping(value="/dy/temp.do")
	public ModelAndView main(HttpServletRequest req, Map<String,Object> commandMap
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/user/dy/sub/temp/temp");
		
		return mv;
	}
	

	@RequestMapping(value="/dy/temp/ajax.do")
	@ResponseBody
	public ModelAndView mainajax(HttpServletRequest req, Map<String,Object> commandMap
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/user/dy/sub/temp/temp2");
		
		
		return mv;
	}*/
	
	
	
	
		
}
