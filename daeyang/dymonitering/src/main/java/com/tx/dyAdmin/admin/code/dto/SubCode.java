package com.tx.dyAdmin.admin.code.dto;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import lombok.Data;

/**
 * @MainCode
 * 공통기능의 상위 서브코드 기능을 담당하는 빈즈
 * @author 신희원
 * @version 1.0
 * @since 2014-11-12
 */
@Data
public class SubCode implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1579355038899944705L;

	
	
	private String MC_CODENM = null;
	
	//서브코드 고유키
	private String SC_KEYNO = null;
	
	//상위코드 
	private String SC_MC_IN_C = null;
	
	//서브코드 명칭
	private String SC_CODENM = null;
	
	//서브코드 값 1
	private String SC_CODEVAL01 = null;
	
	//서브코드 값 2
	private String SC_CODEVAL02 = null;
	
	//서브코드 정렬순서 ex) 1,2,3,4...순번으로 정렬
	private Integer SC_CODELV = null;
	
	//서브코드 사용  여부 
	private String SC_USE_YN = null;
	
	//코드 정보 내역
	private List<String> In_Code_Array = new ArrayList<String>();	
	
}
