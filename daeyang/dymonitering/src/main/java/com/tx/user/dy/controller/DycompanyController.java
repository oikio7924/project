package com.tx.user.dy.controller;

import java.net.URLDecoder;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.dto.TilesDTO;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.publish.CommonPublishService;
import com.tx.dyAdmin.admin.site.service.SiteService;

public class DycompanyController {

	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired SiteService SiteService;
	@Autowired CommonPublishService CommonPublishService;
	
	/**
	 * 모니터링 메인 부분
	 * 
	 */
	@RequestMapping(value="/{tiles}/dy/index.do")
	public ModelAndView DyMain(HttpServletRequest req
			, @PathVariable String tiles
			, @RequestParam(value = "msg", defaultValue = "") String msg
			, @RequestParam(value="inverter", defaultValue="all")String inverter
			) throws Exception {
		ModelAndView mv = new ModelAndView();
		HashMap<String, Object> map = new HashMap<String, Object>();

		if("user".equals(tiles)){
			tiles = new TilesDTO().checkNull(null, req);
			mv.setViewName("redirect:/"+tiles+"/index.do");
			return mv;
		}
		
		String sitePath = SiteService.getSitePath(tiles);
		if(StringUtils.isEmpty(sitePath)){
			mv.setViewName("");
			return mv;
		}
		mv.setViewName("/publish/"+sitePath+"/prc_main");
		
		if(!"".equals(msg)) {
			mv.addObject("msg", URLDecoder.decode(msg, "UTF-8")); // 현재 회원인증후 메세지
		}
		return mv;
	}
	
	
	
	
	
	
}
