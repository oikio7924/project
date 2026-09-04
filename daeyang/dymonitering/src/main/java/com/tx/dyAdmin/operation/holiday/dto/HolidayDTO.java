package com.tx.dyAdmin.operation.holiday.dto;

import lombok.Data;

@Data
public class HolidayDTO {
	
	private String  THM_KEYNO,
					THM_NAME,
					THM_LUNAR,
					THM_DATE,
					THM_DEL_YN,
					THM_NATIONAL,
					THM_TYPE,
					holidayType= "";
}
