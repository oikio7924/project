package com.tx.businessDev.dto;

import lombok.Data;

@Data
public class busDevDTO {

	// 발전소 관련(개발팀 요청으로 발전소 및 인허가 관련 DB합침)
	
	private String bd_plant_keyno,
	bd_plant_name, 
	bd_plant_owner,
	bd_plant_phone,
	bd_plant_add,
	bd_plant_volum,
	bd_plant_installtype,
	bd_Conndate,
	bd_plant_BusDueDate,
	bd_plant_BusStart,
	bd_plant_BusEndDate,
	bd_plant_DevStartDate,
	bd_plant_DevEndDate,
	bd_plant_DevCompletionDate,
	bd_plant_OperationStartDate,
	bd_plant_PPADate,
	bd_plant_PPAVolum,
	bd_plant_memo,
	
	
	// 인허가 관련(사용 x)
	
	bd_license_Keyno,
	bd_license_plantKey,
	bd_license_plantName,
	bd_license_BusStartDate,
	bd_license_BusEndDate,
	bd_license_DevStartDate,
	bd_license_DevEndDate,
	bd_license_PPADate,
	bd_license_PPAVolum,
	bd_license_Conndate
	= "";

}
