package com.tx.dyAdmin.program.group.dto;

import com.tx.common.dto.Common;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 단체예약 신청 DTO
 * @author admin
 *
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class GroupDTO extends Common {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -1045520538316635667L;
	
	private String  
		/* T_GROUP_MANAGER */
		  GM_KEYNO
		, GM_NAME
		, GM_SUMMARY
		, GM_PLACE
		, GM_DATE
		, GM_DELYN
		, GM_REGDT
		, GM_MODDT
		, GM_REGNM
		, GM_MODNM
		, GM_DIVISION
		, GM_MINIMUM
		, GM_MAXIMUM
		, GM_INTRODUCE
		, GM_HOLIDAY
		, GM_USE
		, GM_MN_HOMEDIV_C
		
		/* T_GROUP_PARTICIPATE */
		, GP_YUMOCAR
		, GP_WHEELCHAIR
		, GP_GROUPNAME
		, GP_GSM_KEYNO
		, GP_DATE
		, GP_TIME
		, GP_TRAFFIC_EXP
		, GP_KEYNO
		, GP_GM_KEYNO
		, GP_GSS_KEYNO
		, GP_UI_KEYNO
		, GP_NAME
		, GP_PHONE
		, GP_HEADCOUNT
		, GP_TRAFFIC
		, GP_DELYN
		, GP_REGDT
		
		/* T_GROUP_SCHEDULE_MAIN */
		, GSM_KEYNO
		, GSM_GM_KEYNO
		, GSM_STDT
		, GSM_DELYN
		, GSM_ENDT
		 
		
		/* T_GROUP_SCHEDULE_SUB */
		, GSS_KEYNO
		, GSS_GSM_KEYNO
		, GSS_ST_TIME
		, GSS_EN_TIME
		, GSS_MAXIMUM
		, GSS_SUBTITLE
		;

	String GSM_DAY;

	

	public String getGM_KEYNO() {
		return GM_KEYNO;
	}

	public String setGM_KEYNO(String gM_KEYNO) {
		return GM_KEYNO = gM_KEYNO;
	}


	public String getGSM_KEYNO() {
		return GSM_KEYNO;
	}

	public String setGSM_KEYNO(String gSM_KEYNO) {
		return GSM_KEYNO = gSM_KEYNO;
	}
	
	private String gmTiles;
	
}
