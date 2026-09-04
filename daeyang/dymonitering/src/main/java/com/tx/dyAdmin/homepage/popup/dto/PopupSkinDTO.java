package com.tx.dyAdmin.homepage.popup.dto;

import lombok.Data;

/**
 * @ResearchSkinDTO 팝업 스킨관리를 담당한다.
 * 
 * @author 김승영
 * @version 1.0
 * @since 2020-02-03
 */

@Data
public class PopupSkinDTO {
	
	private String PIS_KEYNO,
	   PIS_FORM,
	   PIS_REGDT,
	   PIS_REGNM,
	   PIS_SUBJECT,
	   PIS_DEL_YN,
	   PIS_DIVISION,
	   PIS_MODDT,
	   PIS_MODNM;
	
	/* 팝업 스킨 히스토리 */
	private String	PISH_KEYNO
					,PISH_PIS_KEYNO
					,PISH_DATA
					,PISH_STDT
					,PISH_ENDT
					,PISH_MODNM
					,PISH_DEL_YN
					,PISH_COMMENT;
	

	private Double PISH_VERSION;
}
