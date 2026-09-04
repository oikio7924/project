package com.tx.dyAdmin.admin.board.dto;

import lombok.Data;

/**
 * @BoardColumn
 * 게시판타입의 컬럼정보관리를 담당한다.
 * 
 * @author 박혜성
 * @version 1.0
 * @since 2017-02-06
 */ 
@Data
public class BoardColumn {
    
	//고유키 
	private String BL_KEYNO;
	
	//게시판 타입관리 키
	private String BL_BT_KEYNO;
	
	//컬럼명
	private String BL_COLUMN_NAME;
	
	//컬럼 가로크기
	private String BL_COLUMN_SIZE;
	
	//정렬순서
	private String BL_COLUMN_LEVEL;
	
	//컬럼정보 리스트에 노출여부
	private String BL_LISTVIEW_YN;

	//컬럼타입
	private String BL_TYPE;
	
	//컬럼 옵션데이터(SELECT, RADIO)옵션
	private String BL_OPTION_DATA;
	
	//사용여부
	private String BL_USE_YN;

	//등록일
	private String BL_REGDT;
	
	//폼 필수입력값
	private String BL_VALIDATE;
	
	//고유키 
	private String KEYNO;
	
	//MC_IN_C
	private String MC_IN_C;
	
		
	
}
