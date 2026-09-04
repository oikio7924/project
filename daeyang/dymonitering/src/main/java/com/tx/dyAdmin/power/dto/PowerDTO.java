package com.tx.dyAdmin.power.dto;

import java.io.Serializable;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class PowerDTO implements Serializable  {
	
	private static final long serialVersionUID = -3793808669767332434L;
	
	private String  
					DPP_KEYNO,
					DPP_NAME,
					DPP_STATUS,
					DPP_USER,
					DPP_VOLUM,
					DPP_IMG,
					DPP_X_LOCATION,
					DPP_Y_LOCATION,
					DPP_DATE,
					DPP_DEL_YN,
					DPP_INVER,
					DPP_INVER_COUNT,
					DPP_AREA,
					DPP_LOCATION,
					DPP_SN,
					DPP_SN_NUM,
					DPP_OTHER_VOLUM
					;
}
