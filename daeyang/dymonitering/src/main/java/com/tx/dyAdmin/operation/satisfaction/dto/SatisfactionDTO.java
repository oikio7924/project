package com.tx.dyAdmin.operation.satisfaction.dto;

import com.tx.common.dto.Common;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 페이지 만족도 DTO
 * @author admin
 *
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class SatisfactionDTO extends Common {

	private static final long serialVersionUID = 9179373720866683626L;
	private String  
		/* T_PAGE_RESEARCH_MANAGER */
		  TPS_KEYNO
		, TPS_MN_KEYNO
		, TPS_HOME_KEYNO
		, TPS_SCORE
		, TPS_COMMENT
		, TPS_REGDT
		, TPS_IP
		, TPS_SCORE_NAME
		;
		
}
