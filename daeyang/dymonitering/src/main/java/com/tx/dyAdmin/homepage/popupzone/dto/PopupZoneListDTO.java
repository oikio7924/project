package com.tx.dyAdmin.homepage.popupzone.dto;

import lombok.Data;

@Data
public class PopupZoneListDTO {
	
	private String TLM_KEYNO;			// 기본키
	private String TLM_ALT;				// 부연설명(ALT)
	private String TLM_COMMENT;			// 코멘트
	private String TLM_URL;				// 링크URL
	private String TLM_FS_KEYNO;		// 이미지 기본키(FS)
	private String TLM_REGNM;			// 작성자
	private String TLM_REGDT;			// 작성일
	private String TLM_USE_YN;			// 사용 여부
	private String TLM_DEL_YN;			// 삭제 여부
	private String TLM_TCGM_KEYNO;		// 카테고리 기본키
	private String TLM_DATE_YN;			// 날짜 선택 유무
	private String TLM_STARTDT;			// 시작날짜
	private String TLM_ENDT;			// 종료날짜
	private Integer TLM_ORDER = null;	// 정렬순서
	
	/*
	 * 기능성 변수들(T_POPUPZONE_LIST 테이블에 없음)
	 * */
	
	private String TLM_UI_NAME;			// 작성자명
	private String TLM_TCGM_TITLE;		// 카테고리명
	private int WIDTH;				// 리사이즈 width
	private int HEIGHT;				// 리사이즈 height
	private Integer TLM_ORDER_BEFORE = null;	// 정렬순서
}