package com.tx.dyAdmin.admin.ipfilter.dto;

import lombok.Data;

@Data
public class IP {
	
	
	private String  IPM_KEYNO,
			IPM_URL,
			IPM_TYPE,
			IPM_TYPE_NAME,
			IPM_USEYN,
			
			
			IPS_KEYNO,
			IPS_IPM_KEYNO,
			IPS_IPADDRESS,
			IPS_TYPE;

}
