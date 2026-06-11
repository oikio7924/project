package com.tx.dyAdmin.operation.survey.dto;

import lombok.Data;

@Data
public class SsDTO {
	/* T_SURVEY_SKIN */
	private String SS_KEYNO
					,SS_MN_HOMEDIV_C
					,SS_SCOPE
					,SS_TITLE
					,SS_DATA
					,SS_SKIN_NAME
					,SS_REGDT
					,SS_REGNM
					,SS_MODNM
					,SS_MODDT
					,SS_DEL_YN
					,SS_FILE_NAME
					,SS_TYPE
					,SS_ORDER;
	
	/* T_SURVEY_SKIN_HISTORY */
	private String SSH_KEYNO
					,SSH_SS_KEYNO
					,SSH_DATA
					,SSH_STDT
					,SSH_ENDT
					,SSH_MODNM
					,SSH_DEL_YN
					,SSH_COMMENT;
	
	private Double SSH_VERSION;

	/*배포 유형*/
	private Boolean DISTRIBUTE_TYPE;
}
