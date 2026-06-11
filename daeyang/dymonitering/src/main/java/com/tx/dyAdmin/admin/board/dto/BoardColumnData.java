package com.tx.dyAdmin.admin.board.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * @BoardColumnData
 * 게시판 컬럼데이터 관리를 담당한다.
 * 
 * @author 박혜성
 * @version 1.0
 * @since 2017-02-06
 */ 

@Data
@EqualsAndHashCode(callSuper=false)
public class BoardColumnData extends BoardColumn {
    
	//고유키 
	private String BD_KEYNO;
	
	//게시판타입키 
	private String BD_BT_KEYNO;
	
	//게시물키 
	private String BD_BN_KEYNO;
	
	//게시판컬럼키 
	private String BD_BL_KEYNO;
	
	//컬럼타입 
	private String BD_BL_TYPE;
	
	//해당컬럼데이터 
	private String BD_DATA;
	//컬럼데이터 원본
	private String BD_DATA_ORI;
	
	//데이터가 어디메뉴의 데이터인지 바로알기위해 추가 
	private String BD_MN_KEYNO;
	
	//상세페이지 데이터 셀렉트하려고 선언
	private String COLUMN_NAME;
	
	private String BDH_KEYNO;
	private String BDH_BD_KEYNO;
	private String BDH_BD_BT_KEYNO;
	private String BDH_BD_BN_KEYNO;
	private String BDH_BD_BL_KEYNO;
	private String BDH_BD_MN_KEYNO;
	private String BDH_BD_BL_TYPE;
	private String BDH_BD_DATA;
	
	private Integer BDH_BNH_KEYNO;
	
	private String BD_COMPARE;
	
	
}
