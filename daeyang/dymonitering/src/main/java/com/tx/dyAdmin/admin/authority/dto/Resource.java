package com.tx.dyAdmin.admin.authority.dto;

import lombok.Data;

@Data
public class Resource {
	
	private String UIA_KEYNO,
				   USR_KEYNO,
				   USR_NAME,
				   USR_PATTERN,
				   USR_TYPE,
				   USR_UIR_KEYNO,
				   USR_ORDER_CLASS,
				   MN_KEYNO= "";
	private int    USR_ORDER;
	
	private String[] urlResources;
	
	public Resource(){
	}
	
	public Resource(String USR_KEYNO, String USR_NAME, String USR_PATTERN, int USR_ORDER, String USR_ORDER_CLASS ){
		this.USR_KEYNO = USR_KEYNO;
		this.USR_NAME = USR_NAME;
		this.USR_PATTERN = USR_PATTERN;
		this.USR_ORDER = USR_ORDER;
		this.USR_TYPE = "url";
		this.USR_ORDER_CLASS = USR_ORDER_CLASS;
	}
	
	
	public String[] getUrlResources() {
		String[] temp = new String[urlResources.length];
	    System.arraycopy(urlResources, 0, temp, 0, urlResources.length);
	    return temp;
	}

	public void setUrlResources(String[] urlResources) {
		
		String[] temp = new String[urlResources.length];
	    System.arraycopy(urlResources, 0, temp, 0, urlResources.length);
	    this.urlResources = temp;
	}

}
