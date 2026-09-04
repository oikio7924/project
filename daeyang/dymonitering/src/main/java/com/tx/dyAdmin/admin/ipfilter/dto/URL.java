package com.tx.dyAdmin.admin.ipfilter.dto;

import com.tx.dyAdmin.admin.ipfilter.service.IpTree;

import lombok.Data;

@Data
public class URL {
	private String  keyno
				    , url[]
		    		, type;
	private IpTree ipTree;

}
