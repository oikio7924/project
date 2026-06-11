package com.tx.dyAdmin.pressure;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;

@Controller
public class PressureController {

	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 문서작성할때 사용 */
	@RequestMapping(value="/dyAdmin/pressure.do")
	public ModelAndView test(
			@RequestParam(required=false, value="contents") String contents){
		ModelAndView mv  = new ModelAndView("/dyAdmin/pressure/pressure.adm");
		
		mv.addObject("contents", contents);
		return mv;
	}
	
	@RequestMapping(value="/dyAdmin/pressure/check.do")
	public ModelAndView check(@RequestParam(value="contents", required=false) String contents){
		String testContent = null;
		testContent = contents.replaceAll("[\\-\\+\\.\\^:,]","");
//		testContent = contents.replaceAll("\r\n", ""); 
		testContent= testContent.replace(System.getProperty("line.separator"), ""); 
		testContent = testContent.replaceAll("\t", ""); 
		ModelAndView mv  = new ModelAndView("/dyAdmin/pressure/pressure.adm");
		
		mv.addObject("mirrorPage", "/dyAdmin/pressure.do");
		mv.addObject("contents", testContent);
		return mv;
	}
	
	
	
}
