package com.tx.dyAdmin.admin.board.dto;

import lombok.Data;

/**
 * @BoardMainMini
 * 메인미니게시판의 컬럼정보관리를 담당한다.
 * 
 * @author chul
 * @version 1.0
 * @since 2019-05-16
 */ 

@Data
public class BoardMainMini {
    
	private String    BMM_KEYNO
					, KEYNO
					, BMM_MN_KEYNO
					, BMM_SIZE
					, BMM_FORM
					, BMM_REGDT
					, BMM_REGNM
					, BMM_DELYN
					, BMM_MN_HOMEDIV_C
					, BMM_SUBJECT
					, BMM_SORT_COLUMN
					, BMM_SORT_DIRECTION = "";
	
	private String	  BMM_MNNAME
					, BMM_MN_HOMEDIVNM
					, BMM_MN_HOMEDIV_URL
					, BMM_MN_HOMEDIV_TILES = "";
	
}
