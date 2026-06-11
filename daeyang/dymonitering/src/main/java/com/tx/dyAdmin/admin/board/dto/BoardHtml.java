package com.tx.dyAdmin.admin.board.dto;

import lombok.Data;

/**
 * @BoardHtml
 * 게시판HTML필요페이지
 * 테이블은 없음
 * 
 * @author 박혜성
 * @version 1.0
 * @since 2017-02-06
 */ 
@Data
public class BoardHtml {
    
	//기본키 
	private String BIH_KEYNO;
	
	//메뉴키 
	private String BIH_MN_KEYNO;
	
	//게시판타입키 
	private String BIH_BT_KEYNO;
	
	//HTML내용 
	private String BIH_CONTENTS;
	
	//작성자 
	private String BIH_REGNM;
	
	//작성일 
	private String BIH_REGDT;
	
	//수정일 
	private String BIH_MODDT;
	
	//사용여부 
	private String BIH_USE_YN;
	
	//DIV위치 
	private String BIH_DIV_LOCATION;
	
}
