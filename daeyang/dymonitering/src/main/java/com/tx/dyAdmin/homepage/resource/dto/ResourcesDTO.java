package com.tx.dyAdmin.homepage.resource.dto;

import lombok.Data;

@Data
public class ResourcesDTO {
	
	/* S_RESOURCES_MANAGER */
	private String  RM_KEYNO
					,RM_MN_HOMEDIV_C
					,RM_SCOPE
					,RM_TITLE
					,RM_DATA
					,RM_REGDT
					,RM_REGNM
					,RM_MODNM
					,RM_MODDT
					,RM_DEL_YN
					,RM_FILE_NAME
					,RM_TYPE
					,RM_ORDER;
	
	/*S_RESOURCES_MANAGER_SUB*/
	private String   RMS_RM_KEYNO
					,RMS_MN_KEYNO;
	private String 	RMS_MN_TYPE = "N";
	
	/* S_RESOURCES_MANAGER_HISTORY */
	private String RMH_KEYNO
					,RMH_RM_KEYNO
					,RMH_DATA
					,RMH_STDT
					,RMH_ENDT
					,RMH_MODNM
					,RMH_DEL_YN
					,RMH_COMMENT;
	
	private Double RMH_VERSION;
	private Double viewVersion;
	
	/*배포 유형*/
	private Boolean DISTRIBUTE_TYPE;
	
	private String homeName;
}