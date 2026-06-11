package com.tx.dyAdmin.homepage.organization.dto;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import lombok.Data;

@Data
public class OrganTree implements Serializable {
	private static final long serialVersionUID = 6587463436380309327L;

	private String  DN_KEYNO
				  , DN_NAME
				  , DN_MAINKEY
				  , DN_HOMEDIV_C
				  ="";
				  
	private List<OrganTree> children = new ArrayList<OrganTree>();
}
