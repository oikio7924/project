package com.tx.dyAdmin.operation.satisfaction.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.operation.satisfaction.dto.SatisfactionDTO;

/**
 * 
 * @FileName: SatisfactionController.java
 * @Date    : 2018. 05. 11. 
 * @Version : 1.0
 */
@Controller
public class SatisfactionController {

	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/**
	 * 페이지 평가 등록
	 * @param req
	 * @param commandMap
	 * @param SatisfactionDTO
	 * @return
	 * @throws Exception
	 */
	@Transactional
	@ResponseBody
	@RequestMapping(value="/common/page/satisfaction/satisfactionInsert.do")
	public Integer satisfactionInsert(
			HttpServletRequest req
			, SatisfactionDTO SatisfactionDTO
			) throws Exception {
		SatisfactionDTO.setTPS_MN_KEYNO(CommonService.getKeyno(SatisfactionDTO.getTPS_MN_KEYNO(), "MN"));
		SatisfactionDTO.setTPS_KEYNO(CommonService.getTableKey("TPS"));
		SatisfactionDTO.setTPS_IP(CommonService.getClientIP(req));	//ip가져오기
		
		Integer result;
		Integer researchCount = Component.getData("Satisfaction.TPS_Select", SatisfactionDTO);
		if(researchCount == 0) {
			Component.createData("Satisfaction.TPS_Insert", SatisfactionDTO);	
			result = 1;
		}else {
			result = 0;
		}
		
		return result;
	}
	
	/**
	 * 페이지 평가 결과
	 * @param req
	 * @param commandMap
	 * @param SatisfactionDTO
	 * @return
	 * @throws Exception
	 */
	@Transactional
	@ResponseBody
	@RequestMapping(value="/common/page/satisfaction/satisfactionResult.do")
	public Map<String, Object> satisfactionResult(
			HttpServletRequest req
			, SatisfactionDTO SatisfactionDTO
			, @RequestParam(value="TPS_MN_KEYNO", required=false) String TPS_MN_KEYNO
			) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		SatisfactionDTO.setTPS_MN_KEYNO(CommonService.getKeyno(TPS_MN_KEYNO, "MN"));
		map.put("resultData", Component.getList("Satisfaction.ResultList", SatisfactionDTO));
		
		return map;
	}
}
