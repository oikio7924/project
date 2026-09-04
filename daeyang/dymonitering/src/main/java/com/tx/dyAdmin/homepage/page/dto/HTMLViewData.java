package com.tx.dyAdmin.homepage.page.dto;

import java.io.Serializable;

import lombok.Data;

@Data
public class HTMLViewData implements Serializable{

	private static final long serialVersionUID = -293584105642402352L;
	
	private String MVD_KEYNO = "";	//키
	private String MVD_MN_KEYNO = "";	//Menu - 조인 키
	private String MVD_MN_HOMEDIV_C = "";	//Menu - 홈페이지구분 코드
	private String MVD_URL   = "";	//해당 URL
	private String MVD_DATA  = "";	//JSP소스
	private String MVD_REGDT = "";	//작성일
	private String MVD_MODDT = "";	//수정일
	private String MVD_REGNM = "";	//작성자
	private String MVD_MODNM = "";	//수정자
	private String MVD_DEL_YN = "";	//삭제여부
	private String MVD_EDITOR_TYPE = "";	//에디터 타입
    private String MVD_DATA_SEARCH = "";    //에디터 타입
	
	private String MVD_TILES = "";	//관련 타일즈
	
	
	/* 히스토리 테이블 */
	private String MVH_KEYNO = "";		//고유키
	private String MVH_MVD_KEYNO = "";	//메인키
	private String MVH_DATA = "";		// 데이터
	private String MVH_STDT = "";		// 게시기간 - 시작일
	private String MVH_ENDT = "";		// 게시기간 - 종료일
	private String MVH_MODNM = "";		//수정자
	private String MVH_DEL_YN = "";		//삭제여부
    private String MN_NAME = "";    	//컨텐트 제목
    private String MVH_COMMENT = "";    //코멘트
    private double MVH_VERSION;    		//버전
}
