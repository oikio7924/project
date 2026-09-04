package com.tx.dyAdmin.admin.board.dto;

import lombok.Data;

/**
 * @BoardType
 * 게시판 타입관리를 담당한다.
 * 
 * @author 박혜성
 * @version 1.0
 * @since 2017-02-06
 */ 

@Data
public class BoardSkin {
    
	private String BST_KEYNO;
	private String BST_FORM;
	private String BST_REGDT;
	private String BST_REGNM;
	private String BST_DELETE;
	private String BST_TITLE;
	private String BST_TYPE;
	
	
	//패키지 관리 
	private String BSP_KEYNO;
	private String BSP_TITLE;
	private String BSP_LIST_KEYNO;
	private String BSP_DETAIL_KEYNO;
	private String BSP_INSERT_KEYNO;
	private String BSP_REGDT;
	private String BSP_REGNM;
	private String BSP_DELETE;
	private String LIST_TITLE;
	private String DETAIL_TITLE;
	private String INSERT_TITLE;
	
	//FORM 유형 객체
	private String BSP_LIST_FORM;
	private String BSP_DETAIL_FORM;
	private String BSP_INSERT_FORM;
}
