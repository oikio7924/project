package com.tx.dyAdmin.statistics.dto;

import com.tx.common.dto.Common;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class LogDTO extends Common {
	
	private static final long serialVersionUID = 621937432376974413L;

	private String AH_KEYNO
				 , AH_UI_KEYNO
				 , AH_IP
				 , AH_DATE
				 , AH_URL
				 , AH_DESC
				 , AH_MENU
				 , AH_REFERER
				 , AH_DEVICE = ""
				 , AH_AGENT
				 , AH_SESSION
				 , AH_HOMEDIV_C
				 , AH_BROWSER
				 , AH_OS
				 ;
	
	
	
	
	private String UI_ID = null;
	
	
	private String BROWSER = null;
	private String OS = null;
	private String DAYTIME = null;
	private String CASE = null;

	//새로운 방문자 카운트
	private String DOMAIN = null;
	private String count = null;
	private String DAYOFWEEK = null;
	private String MONTH = null;
	private String YEAR = null;
	private String TIME = null;
	
	
	private String order = "A";
	private String searchbot = null;
	
	private float persent = 0;
	private int no=0;

	
	// SELECT 용
	private int selectCount = 0;
	private String STDT = null;
	private String ENDT = null;
	private String OPTION = null;
	private String MN_NAME = null;// 메뉴페이지카운터에서 메뉴이름
	private String MN_KEYNO = null;
	private String MN_HOMEDIV_NAME = null;
	private String MN_LEV = null;
	private String HOME_DIV = null;
	private String Is_MOBILE = null;
	private String DEV = null;
	
	//메인 방문자카운터 유형
	private String lastYear = null;
	private String thisYear = null;
	private int lastCount = 0;
	private int thisCount = 0;
	private String visitorType = null;

}
