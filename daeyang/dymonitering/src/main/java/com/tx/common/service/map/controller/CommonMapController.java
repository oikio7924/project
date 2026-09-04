package com.tx.common.service.map.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

/**
 * 
 * @FileName: CommonMapController.java
 * @Date    : 2018. 01. 15. 
 * @Author  : 이재령	
 * @Version : 1.0
 */
@Controller
public class CommonMapController {

	
	@RequestMapping(value="/common/include/map.do")
	public ModelAndView commonIncludeMap(HttpServletRequest req, Map<String,Object> commandMap
			, @RequestParam("type") String type
			, @RequestParam("pageName") String pageName
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/include/map/" + type + pageName + "_" + type);
		
		return mv;
	}
	
	
	
	
}
