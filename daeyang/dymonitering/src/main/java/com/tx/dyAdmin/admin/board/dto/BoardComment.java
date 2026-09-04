package com.tx.dyAdmin.admin.board.dto;

import com.tx.common.dto.Common;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * @BoardComment
 * 게시판 댓글관리를 담당한다.
 * 
 * @author 박혜성
 * @version 1.0
 * @since 2017-02-06
 */ 

@Data
@EqualsAndHashCode(callSuper=false)
public class BoardComment extends Common {
    
	private static final long serialVersionUID = -6636554681942407357L;

	//기본키 
	private String BC_KEYNO = "";
	
	//메인키
	private String BC_MAINKEY = "";
	
	//루트키
	private String BC_ROOTKEY = "";
	
	//게시물키 
	private String BC_BN_KEYNO = "";
	
	//내용 
	private String BC_CONTENTS = "";
	
	//작성자 코드 
	private String BC_REGNM = "";
	
	//작성일 
	private String BC_REGDT = "";
	
	//사용여부 
	private String BC_DEL_YN = "";
	
	//삭제일
	private String BC_DELDT = "";
	
	//수정일
	private String BC_MODDT = "";
	
	//좋아요
	private Integer BC_UP_CNT;
	
	//싫어요
	private Integer BC_DOWN_CNT;
	
	//작성자 
	private String UI_NAME = "";
	
	//메인 작성자 
	private String UI_MAIN_NAME = "";
	
	
	private String   BCS_UI_KEYNO  
					,BCS_BC_KEYNO 
					,BCS_REGDT    
					,BCS_TYPE;
	
	//비밀댓글 사용여부
	private String BC_SECRET_YN;

	
}
