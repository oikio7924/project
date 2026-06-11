package com.tx.user.function.controller;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.codehaus.plexus.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.admin.site.service.SiteService;
import com.tx.dyAdmin.operation.survey.dto.SmDTO;
import com.tx.dyAdmin.operation.survey.dto.SqDTO;
import com.tx.dyAdmin.operation.survey.dto.SrmDTO;

@Controller
public class SurveyUserController {

	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	@Autowired SiteService SiteService;
	/**
	 * 유저 설문 목록 페이지
	 * @param SM_KEYNO
	 * @return
	 * @throws Exception  
	 */
	@RequestMapping(value="/{tiles}/function/survey.do")
	@CheckActivityHistory(desc="유저 설문 목록 페이지 방문")
	public ModelAndView userSurveyListView(HttpServletRequest req
			,@PathVariable String tiles
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/user/"+SiteService.getSitePath(tiles)+"/function/prc_survey_listView");
		
		mv.addObject("SmDTOList", Component.getListNoParam("survey.SM_selectUser"));
		return mv;
	}
	
	/**
	 * 유저 설문 상세 페이지
	 * @param SM_KEYNO
	 * @return
	 * @throws Exception  
	 */
	@RequestMapping(value="/{tiles}/function/survey/detailView.do")
	@CheckActivityHistory(desc="유저 설문 상세 페이지 방문")
	public ModelAndView userSurveyDetailView(HttpServletRequest req
			,@PathVariable String tiles
			,@ModelAttribute SmDTO SmDTO
			,@ModelAttribute SqDTO SqDTO
			) throws Exception {
		ModelAndView mv = CommonService.setCommonJspPath(tiles, "/user/_common/_Survey/pra_survey_detailView");
		
		// 설문 스킨 목록 불러오기
		HashMap<String, Object> Ssdata = new HashMap<>();
		mv.addObject("surveySkinList", Component.getList("survey.SS_getSkinData", Ssdata));				
		
		// 설문지 정보 불러오기
		HashMap<String, Object> SmMap = Component.getData("survey.SM_selectBySmkey", SmDTO.getSM_KEYNO());
		mv.addObject("SmDTO", SmMap);
		
		// 설문지 문항 목록 불러오기
		List<SqDTO> sqList = Component.getList("survey.SQ_getListBySmkey", SmDTO);
		mv.addObject("sq_list", sqList);
		
		// 설문지 보기 목록 불러오기
		List<SqDTO> sqoList = Component.getList("survey.SQO_getListBySqkey", SmDTO);
		mv.addObject("sqo_list", sqoList);
		mv.addObject("mirrorPage", "/dy/function/survey.do"); 
		return mv;
	}
	

	/**
	 * 유저 설문결과 입력
	 * @param SqDTO
	 * @return
	 * @throws Exception  
	 */
	@RequestMapping(value="/{tiles}/function/survey/insert.do")
	@CheckActivityHistory(type="homeTiles", desc="유저 설문결과 등록 작업")
	@Transactional
	public ModelAndView userSurveyResultInsert(HttpServletRequest req
			,@PathVariable String tiles
			,@ModelAttribute SmDTO SmDTO
			,@ModelAttribute SrmDTO SrmDTO
			,@RequestParam (value="SQ_KEYNO", required=false)	  String [] SQ_KEYNO
			,@RequestParam (value="SQ_ST_TYPE", required=false)	  String [] SQ_ST_TYPE
			,@RequestParam (value="SQ_OPTION_DATA", required=false)	  String [] SQ_OPTION_DATA
			,@RequestParam (value="SQ_OPTION_DATA2", required=false)	  String [] SQ_OPTION_DATA2
			,@RequestParam (value="SQ_OPTION_DATA3", required=false)	  String [] SQ_OPTION_DATA3
			) throws Exception {
		
				ModelAndView mv  = new ModelAndView("redirect:/"+tiles+"/function/survey.do");
		
				String [] SQ_OPTION_RADIO_DATA = req.getParameterValues("SQ_OPTION_RADIO_DATA");
		
				SrmDTO.setSRM_SM_KEYNO(SmDTO.getSM_KEYNO());
				if("Y".equals(SmDTO.getSM_IDYN())){
					Map<String,Object> user = CommonService.getUserInfo(req);
					if(user != null){
						SrmDTO.setSRM_REGNM((String)user.get("UI_KEYNO"));
					}
				}
				
				SrmDTO.setSRM_IP(CommonService.getClientIP(req));
				
				Component.updateData("surveyRe.SRM_insert", SrmDTO);
				Component.updateData("survey.SM_countPenel", SmDTO);
				
				for(int i=0; i<SQ_KEYNO.length; i++){
					if(StringUtils.isNotEmpty(SQ_ST_TYPE[i])){
						// T : 주관식, R : 객관식(라디오), C : 객관식(체크박스)
						if("C".equals(SQ_ST_TYPE[i])){
							HashMap<String, Object> map = new HashMap<>();
							List<HashMap<String, Object>> list = new ArrayList<>();
							map.put("SRD_SM_KEYNO", SmDTO.getSM_KEYNO());
							map.put("SRD_SRM_KEYNO", SrmDTO.getSRM_KEYNO());
							map.put("SRD_SQ_KEYNO", SQ_KEYNO[i]);
							HashMap<String, Object> map2 = new HashMap<>();
														
							if(StringUtils.isEmpty(SQ_OPTION_DATA[i])){ // 체크박스 입력값이 없을때
								map2.put("SRD_SQO_KEYNO", "");
								map2.put("SRD_SQO_VALUE", "");	
								list.add(map2);
								map.put("SQO_LIST", list);
							} else { // 공백이 아닐 경우
								String[] data = SQ_OPTION_DATA[i].split("/");	
								for (int j = 0; j < data.length; j++) {
									String[] Sub_data = data[j].split(":");
									HashMap<String, Object> map3 = new HashMap<>();
									map3.put("SRD_SQO_KEYNO", Sub_data[0]);
									map3.put("SRD_SQO_VALUE", Sub_data[1]);
									list.add(map3);
									map.put("SQO_LIST", list);
								}
							}
							Component.updateData("surveyRe.SRD_insert", map);
						}else{
							SrmDTO.setSRD_SM_KEYNO(SmDTO.getSM_KEYNO());
							SrmDTO.setSRD_SRM_KEYNO(SrmDTO.getSRM_KEYNO());
							SrmDTO.setSRD_SQ_KEYNO(SQ_KEYNO[i]);							
							if("T".equals(SQ_ST_TYPE[i])){
								SrmDTO.setSRD_DATA(SQ_OPTION_DATA[i]);
							}else if("R".equals(SQ_ST_TYPE[i])){
								SrmDTO.setSRD_DATA(SQ_OPTION_RADIO_DATA[i]); //								
								String[] data = SQ_OPTION_DATA2[i].split(":");
								SrmDTO.setSRD_SQO_KEYNO(data[0]);
								SrmDTO.setSRD_SQO_VALUE(data[1]);
							}else if("O".equals(SQ_ST_TYPE[i])){
								SrmDTO.setSRD_DATA(SQ_OPTION_RADIO_DATA[i]); //								
								String[] data = SQ_OPTION_DATA2[i].split(":");
								SrmDTO.setSRD_SQO_KEYNO(data[0]);
								SrmDTO.setSRD_SQO_VALUE(data[1]);									
								SrmDTO.setSRD_IN_DATA(SQ_OPTION_DATA3[i]);
							}
							Component.updateData("surveyRe.SRD_insert2", SrmDTO);
							SrmDTO.setSRD_DATA(null);
							SrmDTO.setSRD_SQO_KEYNO(null);
							SrmDTO.setSRD_SQO_VALUE(null);
						}
					}
			}
		req.setAttribute("homeTiles", tiles);
		return mv;
	}	
	
	

}
