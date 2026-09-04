package com.tx.dyAdmin.admin.board.dto;

import com.tx.common.dto.Common;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * @BoardNotice
 * 게시물관리를 담당한다.
 * 
 * @author 박혜성
 * @version 1.0
 * @since 2017-02-06
 */ 

@Data
@EqualsAndHashCode(callSuper=false)
public class BoardNotice extends Common{
    
	private static final long serialVersionUID = -8112511555121078311L;

	//고유키 
	private String BN_KEYNO;
	
	//메뉴키 
	private String BN_MN_KEYNO;
	
	//파일키 
	private String BN_FM_KEYNO;
	
	//제목 
	private String BN_TITLE;
	
	//내용 
	private String BN_CONTENTS;
	
    //내용 검색
    private String BN_CONTENTS_SEARCH;
	
	//작성자 
	private String BN_REGNM;
	
	//작성일 
	private String BN_REGDT;
	
	//수정자 
	private String BN_MODNM;
	
	//수정일 
	private String BN_MODDT;
	
	//사용여부 
	private String BN_USE_YN;
	
	//비밀글여부 
	private String BN_SECRET_YN;
	
	//섬네일 
	private String BN_THUMBNAIL;
	
	//조회수 
	private int BN_HITS;
	
	//카테고리이름 
	private String BN_CATEGORY_NAME;

	//알림톡 이후 처리 
	private char BN_SEND_CHECK;
	
	

	//썸네일 경로
	private String THUMBNAIL_PATH;
	
	//썸네일 경로
	private String THUMBNAIL_ORINM;
	
	//썸네일 경로
	private String THUMBNAIL_PUBLIC_PATH;
		
	//공지여부
	private String BN_IMPORTANT;
	
	//공지종료일
	private String BN_IMPORTANT_DATE;
	
	private String BN_MAINKEY;
	private String BN_PARENTKEY;
	private int BN_SEQ = 0;
	private int BN_DEPTH =0;
	
	//새글 여부
	private String BN_NEW = "";
	
	//댓글 수
	private int BN_BC_COUNT = 0;
	
	//답글 여부
	private String BT_REPLY_YN = "";
	
	//삭제된 게시물 리스트에 보여질지 여부
	private String BT_DEL_LISTVIEW_YN = "";
	
	//링크 존재 여부 
	private int BN_LINK = 0;
	
	
	//공지
	private String BOARD_TYPE;
	
	//고유키
	private Integer BNH_KEYNO;
	
	//고유키 
	private String BNH_BN_KEYNO;
	
	//메뉴키 
	private String BNH_BN_MN_KEYNO;
	
	//파일키 
	private String BNH_BN_FM_KEYNO;
	
	//제목 
	private String BNH_BN_TITLE;
	
	//내용 
	private String BNH_BN_CONTENTS;
	
	//작성자 
	private String BNH_BN_REGNM;
	
	//작성일 
	private String BNH_BN_REGDT;
	
	//비회원 비밀번호
	private String BN_PWD;
	
	//수정자 
	private String BNH_BN_MODNM;
	
	//수정일 
	private String BNH_BN_MODDT;
	
	//사용여부 
	private String BNH_BN_USE_YN;
	
	//비밀글여부 
	private String BNH_BN_SECRET_YN;
	
	//섬네일 
	private String BNH_BN_THUMBNAIL;
	
	//조회수 
	private int BNH_BN_HITS;
	
	//공지여부
	private String BNH_BN_IMPORTANT;
	
	//공지종료일
	private String BNH_BN_IMPORTANT_DATE;
	
	private String BN_COMPARE;
	
	private String BN_UI_NAME;
	
	private String BN_MOD_UI_NAME;
	
	private int BOARD_NUMBER;
	
	//삭제여부
	//사용여부(BN_USE_YN)과는 다른개념 사용여부는 콘텐츠 요청관리에서 최종승인이 떨어지면 Y, 사용자 리스트에서 쿼리 검색시에는 사용여부Y, 삭제여부N
	private String BN_DEL_YN;
	
	private String BN_GONGNULI_TYPE;
	
	//재단발간물 이미지 경로
	private String IMG_PATH;
	

    //답글에서 사용할 게시글 작성자
    private String WRITE_ID;

	//게시판 이동 사유
	private String BN_MOVE_MEMO;
	
	//첨부파일 수정 여부
	private String fileUpdateCheck = "N";
	
	//게시물 삭제 사유
	private String BN_DEL_MEMO;
	
	//게시물 삭제 일자
	private String BN_DELdt;
	
	//게시물 삭제자
	private String BN_DELNM;
	
	//게시물 등록자 IP
	private String BN_INSERT_IP;
	
	//게시물 수정자 IP
	private String BN_UPDATE_IP;
	
	//게시물 삭제자 IP
	private String BN_DELETE_IP;
	
	//게시물 에디터 타입
	private String BN_HTMLMAKER_PLUS_TYPE;

	//게시물 발전소 타입 
	private String BN_PLANT_NAME;
    
}