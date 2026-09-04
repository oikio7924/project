package com.tx.common.service.skin.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.skin.service.impl.CommonSkinServiceImpl;

/**
 * 
 * @FileName: CommonSampleSkinController.java
 * @Date    : 2020. 07. 01. 
 * @Author  : 이재령	
 * @Version : 1.0
 */
@Controller
public class CommonSampleSkinController {

	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	@Autowired CommonSkinServiceImpl CommonSkinServiceImpl;
	
	
	@RequestMapping(value="/common/sample/skin/getDataAjax.do")
	@ResponseBody
	public String getCommonSkinAjax(HttpServletRequest req
			,@RequestParam(value="type") String type
			,@RequestParam(value="value") String value
			) throws Exception{
		
		return CommonSkinServiceImpl.getSkin(type, value);
	}

	@RequestMapping(value="/dyAdmin/homepage/board/skin/boardSkin/getSkinAjax.do")
	@ResponseBody
	public String getBoardSkinAjax(HttpServletRequest req
			,@RequestParam(value="type") String type
			,@RequestParam(value="value") String value
			) throws Exception{
		
		
		return CommonSkinServiceImpl.getBoardSkin(type, value);
	}
}
