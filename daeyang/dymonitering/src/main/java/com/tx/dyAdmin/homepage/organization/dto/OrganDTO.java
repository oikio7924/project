package com.tx.dyAdmin.homepage.organization.dto;

import com.tx.common.dto.Common;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 조직도 DTO
 * @author 이재령
 *
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OrganDTO extends Common{
	
	private static final long serialVersionUID = -1551175321744444629L;


					/** T_DEPARTMENT_MANAGER  */
	private String  DN_KEYNO
				  , DN_NAME
				  , DN_MAINKEY
				  , DN_MAINKEY_BEFORE
				  , DN_CONTENTS
				  , DN_DEL_YN
				  , DN_TEMP
				  , DN_HOMEDIV_C
	
					/** T_DEPARTMENT_USER_MANAGER  */
				  , DU_KEYNO
				  , DU_NAME
				  , DU_DN_KEYNO
				  , DU_ROLE
				  , DU_CONTENTS
				  , CONTENTS_BR
				  , DU_TEL
				  , TEL_BR
				  , DU_DEL_YN 
				  , DU_HOMEDIV_C = ""
	
				  , DIV_KEY;
	
	
	private Integer	DU_LEV = 0;
	private Integer	DN_LEV = 0;
	private Integer	DU_LEV_AFTER = 0;
	private Integer	DN_LEV_AFTER = 0;
	
	private int     DN_COUNT = 0; // 부서원 수
	private int     DN_COUNT_DEPARTMENT = 0; // 하위부서 수
	
	private String  DN_MAINNAME = ""; // 상위부서명
}
