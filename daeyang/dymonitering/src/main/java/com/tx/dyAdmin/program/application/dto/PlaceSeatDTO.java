package com.tx.dyAdmin.program.application.dto;

import com.tx.common.dto.Common;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class PlaceSeatDTO extends Common {

	private static final long serialVersionUID = -7592042390730815233L;

	private String
			  PSM_KEYNO
			, PSM_PM_KEYNO
			, PSM_NAME
			
			, PSS_KEYNO
			, PSS_PSM_KEYNO
			, PSS_CODE;
	
	private int 
			  PSM_ROW
			, PSM_COL
			, PSM_TOP
			, PSM_LEFT
			
			, PSS_ROW
			, PSS_COL;
	
}
