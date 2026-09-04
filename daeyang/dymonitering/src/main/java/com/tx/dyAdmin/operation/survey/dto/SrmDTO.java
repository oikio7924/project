package com.tx.dyAdmin.operation.survey.dto;

import com.tx.common.dto.Common;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class SrmDTO extends Common {
	
	private static final long serialVersionUID = -8716753312865665515L;

	//설문결과 기본키
	private String SRM_KEYNO;
	
	//설문지키
	private String SRM_SM_KEYNO;
	
	//설문작성자
	private String SRM_REGNM;
	
	//설문작성일
	private String SRM_REGDT;

	//아이피
	private String SRM_IP;
	
	//설문결과 데이터 기본키
	private String SRD_KEYNO;
	
	//설문지 키
	private String SRD_SM_KEYNO;
	
	//설문결과 관리키
	private String SRD_SRM_KEYNO;
	
	//설문 문항
	private String SRD_SQ_KEYNO;
	
	//주관식 결과
	private String SRD_DATA;
	
	//객관식 결과
	private String SRD_SQO_KEYNO;
	
	//객관식 결과 배점
	private String SRD_SQO_VALUE;
	
	//보기 선택 결과
	private String CNT_CHOICE;

	//보기 종합 점수
	private String SUM_VAL;

	// 기타의견 주관식 내용
	private String SRD_IN_DATA;

}
