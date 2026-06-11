package com.tx.dyAdmin.operation.survey.dto;

import com.tx.common.dto.Common;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class SqDTO extends Common {
	
	private static final long serialVersionUID = 3633419050609616095L;

	// 설문 문항 기본키
	private String SQ_KEYNO;
	
	// 설문지 키
	private String SQ_SM_KEYNO;
	
	// 정렬순서
	private String SQ_NUM;
	
	// 설문타입
	private String SQ_ST_TYPE;
	
	// 설문 질문
	private String SQ_QUESTION;
	
    // 설문 문항 코멘트
    private String SQ_COMMENT;
    
	// 설문문항 보기 기본키
	private String SQO_KEYNO;
	
	// 설문문항 키
	private String SQO_SQ_KEYNO;
	
	// 보기번호
	private String SQO_NUM;
	
	// 보기내용
	private String SQO_OPTION;
	
	// 보기배점
	private String SQO_VALUE;
	
	
	//보기 선택 결과
	private String CNT_CHOICE;

	//보기 종합 점수
	private String SUM_VAL;

	// 설문 객관식(체크박스) 체크가능 최소값
	private int SQ_CK_MIN;

	// 설문 객관식(체크박스) 체크가능 최소값
	private int SQ_CK_MAX;

	// 설문 객관식(라디오) 기타의견 입력 여부 체크
	private String SQ_ORDER_TYPE;

	// 설문 문항 카테고리 텍스트
	private String SQ_KG_TEXT;
	
	// 설문 객관식(체크박스) 필수 / 선택 확인값
	private String SQ_REQYN;
	
	// 설문 객관식(라디오) 내부 기타의견 사용 유무
	private String SQ_IN_ORDER_TYPE;
	
	// 설문 객관식(라디오) 설문 기타의견 유무
	private String SQO_ORDER_TYPE;

}
