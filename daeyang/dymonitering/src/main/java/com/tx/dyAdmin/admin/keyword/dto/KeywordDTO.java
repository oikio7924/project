package com.tx.dyAdmin.admin.keyword.dto;

import java.io.Serializable;

import lombok.Data;

@Data
public class KeywordDTO implements Serializable {
	
	private static final long serialVersionUID = 2437118979080772052L;

	private String SK_KEYWORD,SK_REGDT,SK_IP,SK_USERID,UI_ID = "";
	
	private int SK_SIZE,KeywordSize,minCount = 0;
	private String STDT = null;
	private String ENDT = null;
	private int COUNT = 0;
	private int no=0;
}
