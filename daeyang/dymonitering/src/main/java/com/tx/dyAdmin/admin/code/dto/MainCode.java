package com.tx.dyAdmin.admin.code.dto;

import java.io.Serializable;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * @MainCode
 * 공통기능의 메인코드 기능을 담당하는 빈즈
 * @author 신희원
 * @version 1.0
 * @since 2014-11-12
 */

@Data
@EqualsAndHashCode(callSuper=false)
public class MainCode extends SubCode implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 6333542920612844790L;

	//상위 코드 고유 키
	private String MC_KEYNO = null;
	
	//상위 코드 코드 명칭
	private String MC_CODENM = null;

	//상위 코드 생성일자
	private String MC_REGDT = null;
	
	//상위 코드 최근 수정 일자
	private String MC_MODDT = null;
	
	//내부 코드 값
	private String MC_IN_C = null;

	//상위 코드 시스템전용 코드 사용 여부 (Y일 경우 수정/변경/삭제가 불가)
	private String MC_SYS_YN = null;
	
	//상위 코드 사용 여부
	private String MC_USE_YN = null;

}
