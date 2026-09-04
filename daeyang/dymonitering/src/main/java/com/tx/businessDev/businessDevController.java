package com.tx.businessDev;

import java.util.HashMap;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.tx.businessDev.dto.busDevDTO;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;


@Controller
public class businessDevController {
	
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	

	/**  
	* 메인페이지
	* **/
	@RequestMapping("/bd/main.do")
	public ModelAndView Canlender_Main(HttpServletRequest req) throws Exception {
		  
		ModelAndView mv = new ModelAndView("/user/_BD/bd_Main");
			  
			  
		return mv;
	}
	  
	  	
	/**  
	 * 발전소 정보 및 인허가 일정 등록
	 * **/
	@RequestMapping("/bd/license/registration.do")
	public ModelAndView License_Reistration(HttpServletRequest req) throws Exception {
		  
		ModelAndView mv = new ModelAndView("/user/_BD/license/bd_license_register");
			
		
		 mv.addObject("plantList",Component.getListNoParam("busDev.AllPlantSelect"));
			  
			  
		return mv;
	}
	
	/**  
	 * 발전소 정보 등록 및 수정 AJAX
	 * **/
	@RequestMapping("/bd/license/PlantInsertAjax.do")
	@ResponseBody
	public String License_PlantInsertAjax(HttpServletRequest req,busDevDTO Dev, 
			@RequestParam(value="buttionType", defaultValue="insert")String type) throws Exception {
		
		// 디버깅 로그
		System.out.println("========== 발전소 정보 저장/수정 ==========");
		System.out.println("Type: " + type);
		System.out.println("발전소 Keyno: " + Dev.getBd_plant_keyno());
		System.out.println("개발행위준공일: " + Dev.getBd_plant_DevCompletionDate());
		System.out.println("사업개시일: " + Dev.getBd_plant_OperationStartDate());
		System.out.println("=========================================");
		
		String msg = "";
		
		if(type.equals("update")) {
			Component.updateData("busDev.PlantUpdate", Dev);
			msg = "수정이 완료 되었습니다.";
		}else {
			Component.createData("busDev.PlantInsert", Dev);
			msg = "등록이 완료 되었습니다.";
			}
		
		return msg;
	}
	
	
	/**  
	 * 발전소 정보 삭제 AJAX
	 * **/
	@RequestMapping("/bd/license/PlantDeleteAjax.do")
	@ResponseBody
	public String License_PlantDeleteAjax(HttpServletRequest req,
			@RequestParam(value="bd_plant_keyno")String PlantKeyno) throws Exception {
		
		Component.deleteData("busDev.PlantDelete", PlantKeyno);
		
		String msg = "발전소 삭제 완료";
	
		return msg;
	
	}
	
	
	/**  
	 * 발전소 정보 선택 AJAX
	 * **/
	@RequestMapping("/bd/license/PlantSelectAjax.do")
	@ResponseBody
	public HashMap<String, Object> License_PlantSelectAjax(HttpServletRequest req,
			@RequestParam(value="bd_plant_keyno")String PlantKeyno
			) throws Exception {
		
		HashMap<String,Object> map = Component.getData("busDev.PlantSelect",PlantKeyno);
		
		// DATE 타입 필드를 YYYY-MM-DD 형식 문자열로 변환
		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
		
		if(map.get("bd_plant_DevCompletionDate") != null) {
			Object dateObj = map.get("bd_plant_DevCompletionDate");
			if(dateObj instanceof java.util.Date) {
				map.put("bd_plant_DevCompletionDate", sdf.format((java.util.Date)dateObj));
			}
		}
		
		if(map.get("bd_plant_OperationStartDate") != null) {
			Object dateObj = map.get("bd_plant_OperationStartDate");
			if(dateObj instanceof java.util.Date) {
				map.put("bd_plant_OperationStartDate", sdf.format((java.util.Date)dateObj));
			}
		}
		
		return map;
	}
}
