package com.tx.businessDev;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.tx.businessDev.dto.calenderDTO;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;

@RestController
@RequestMapping("/bd/calender")
public class calenderController {
	
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	
	/**  
	* 캘린더에 뿌릴 데이터 추출
	* **/
	@GetMapping("/Calender_Data.do")
	public ArrayList<HashMap<String,Object>> Calender_Data(HttpServletRequest req
			) throws Exception {
		
		List<HashMap<String, Object>> DataList = Component.getListNoParam("busDev.CalenderDateSelect");
		
		ArrayList<HashMap<String, Object>> mapList = new ArrayList<>();
		
		for (int i = 0; i < DataList.size(); i++) {
			
			HashMap<String, Object> busDate = new HashMap<>();
			HashMap<String, Object> devDate = new HashMap<>();
			
			busDate.put("id", DataList.get(i).get("bd_plant_keyno").toString());
			busDate.put("title", DataList.get(i).get("bd_plant_name").toString()+" 사업허가만료일");
			busDate.put("start", DataList.get(i).get("bd_plant_BusEndDate").toString());
			busDate.put("end", DataList.get(i).get("bd_plant_BusEndDate").toString());
			mapList.add(busDate);
			
			devDate.put("id", DataList.get(i).get("bd_plant_keyno").toString());
			devDate.put("title", DataList.get(i).get("bd_plant_name").toString()+" 개발행위만료일");
			devDate.put("start", DataList.get(i).get("bd_plant_DevEndDate").toString());
			devDate.put("end", DataList.get(i).get("bd_plant_DevEndDate").toString());
			mapList.add(devDate);
        }
		
		return mapList;
	}
	
	
	/**  
	* 캘린더 일정 Edit
	* **/
	@PostMapping("/Calender_Edit.do")
	public String Calender_Edit(HttpServletRequest req,
			@RequestBody calenderDTO cal
			)throws Exception {
		
		
		Component.updateData("busDev.CalnederUpdate", cal);
		
		return "성공";
	}
	
	@GetMapping("/Calender_pushAlim.do")
	public ArrayList<HashMap<String,Object>> Calender_pushAlim(HttpServletRequest req
			)throws Exception {
		
		List<HashMap<String, Object>> DataList = Component.getListNoParam("busDev.ALimDataSelect");
		
		ArrayList<HashMap<String, Object>> mapList = new ArrayList<>();
		
		if (DataList.size() > 0) {
			for (int i = 0; i < DataList.size(); i++) {
				
				HashMap<String, Object> busDate = new HashMap<>();
				
				Integer caldateD = null;
	            Integer caldateB = null;

	            Object caldateDObj = DataList.get(i).get("caldateD");
	            if (caldateDObj != null) {
	                try {
	                    caldateD = Integer.parseInt(caldateDObj.toString());
	                } catch (NumberFormatException e) {
	                    continue; // caldateD가 유효하지 않으면 이 항목 건너뛰기
	                }
	            }

	            Object caldateBObj = DataList.get(i).get("caldateB");
	            if (caldateBObj != null) {
	                try {
	                    caldateB = Integer.parseInt(caldateBObj.toString());
	                } catch (NumberFormatException e) {
	                    continue; // caldateB가 유효하지 않으면 이 항목 건너뛰기
	                }
	            }
				
				
				String bdPlantName = DataList.get(i).get("bd_plant_name").toString();
				String text = bdPlantName + "의 ";
				
				boolean isCaldateD = caldateD != null && caldateD <= 30;
	            boolean isCaldateB = caldateB != null && caldateB <= 30;
				
				if (isCaldateD && isCaldateB) {
					if(caldateD < 0 && caldateB < 0) {
						text += "개발헹위만료일이과 발전사업허가일이 모두 지났습니다. 갱신해주세요.";
					}else if(caldateD < 0 || caldateB > 0){
						text += "개발행위만료일이 지났습니다. 발전사업허가일이"+caldateB+"일 남았습니다. ";
					}else if(caldateB < 0 || caldateD > 0){
						text += "개발행위만료일이" + caldateD + "남았습니다. 발전사업허가일이 지났습니다.";
					}else {
						text += "개발행위만료일이 " + caldateD + "일, 발전사업허가일이 " + caldateB + "일 남았습니다.";	
					}
				} else if (isCaldateD) {
					if(caldateD < 0) {
						text += "개발행위만료일이 지났습니다. 갱신해주세요.";
					}else {
						text += "개발행위만료일이 " + caldateD + "일 남았습니다.";
					}
				} else if (isCaldateB) {
					if(caldateB < 0) {
						text += "발전사업허가일이 지났습니다. 갱신해주세요.";
					}else {
						text += "발전사업허가일이 " + caldateB + "일 남았습니다.";
					}
				} else {
					text = "";
				}
				
				
				busDate.put("text", text);
				mapList.add(busDate);
			}
		}
		
		
		return mapList;
	}
	
	

}
