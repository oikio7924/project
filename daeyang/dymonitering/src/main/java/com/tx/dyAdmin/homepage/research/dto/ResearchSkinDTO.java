package com.tx.dyAdmin.homepage.research.dto;

import lombok.Data;

/**
 * @ResearchSkinDTO 페이지평가 스킨관리를 담당한다.
 * 
 * @author 김승영
 * @version 1.0
 * @since 2020-01-30
 */

@Data
public class ResearchSkinDTO {
	
	private String PRS_KEYNO,
	   PRS_FORM,
	   PRS_REGDT,
	   PRS_REGNM,
	   PRS_SUBJECT,
	   PRS_DEL_YN,
	   PRS_MODDT,
	   PRS_MODNM;
	
	/* 페이지평가 스킨 히스토리 */
	private String	PRSH_KEYNO
					,PRSH_PRS_KEYNO
					,PRSH_DATA
					,PRSH_STDT
					,PRSH_ENDT
					,PRSH_MODNM
					,PRSH_DEL_YN
					,PRSH_COMMENT;
	

	private Double PRSH_VERSION;

}
