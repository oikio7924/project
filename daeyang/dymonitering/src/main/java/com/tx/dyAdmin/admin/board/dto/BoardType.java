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
public class BoardType {
    
	//고유키 
	private String BT_KEYNO;
	
	//게시판 타입 명칭
	private String BT_TYPE_NAME;
	
	//게시판 유형코드
	private String BT_CODEKEY;
	
	
	//답글 기능 사용여부
	private String BT_REPLY_YN;
	
	//댓글 기능 사용여부
	private String BT_COMMENT_YN;
	
	//비밀글 기능 사용여부
	private String BT_SECRET_YN;
	
	//업로드 기능 사용여부
	private String BT_UPLOAD_YN;
	
	//업로드 파일 수 제한
	private Integer BT_FILE_CNT_LIMIT;
	
	//업로드 파일 크기 제한(MB)
	private Integer BT_FILE_SIZE_LIMIT;
	
	//작성자
	private String BT_REGNM;

	//작성일자
	private String BT_REGDT;
	
	//최근 변경자
	private String BT_MODNM;
	
	//최근 변경일자
	private String BT_MODDT;
	
	//사용여부
	private String BT_USE_YN;
	
	//예약 프로그램 사용여부
	private String BT_EDU_PR_YN;
	
	//티켓예매 프로그램 사용여부
	private String BT_TICKET_PR_YN;
	
	//SNS공유 사용여부
	private String BT_SNS_YN;
	
	//RSS 사용여부
	private String BT_RSS_YN;
	
	//소개HTML사용여부
	private String BT_HTML_YN;
		
	//썸네일 사용여부
	private String BT_THUMBNAIL_YN;
	
	//썸네일 리사이즈 WEIGHT값
	private int BT_THUMBNAIL_WIDTH = 0;
	
	//썸네일 리사이즈 HEIGHT값
	private int BT_THUMBNAIL_HEIGHT = 0;
		
	
	//파일 이미지 WEIGHT값
	private int BT_FILE_IMAGE_WIDTH = 0;
	
	//파일 이미지 HEIGHT값
	private int BT_FILE_IMAGE_HEIGHT = 0;

	//한 페이지당 게시되는 게시물 건 수
	private int BT_PAGEUNIT = 0;
		
	//페이지 리스트에 게시되는 페이지 건수
	private int BT_PAGESIZE = 0;
	
	//삭제된 게시물 리스트에 보여질지 여부
	private String BT_DEL_LISTVIEW_YN;
	
	//삭제된 게시물 리스트에 보여질지 여부
	private String BT_EMAIL_YN;
	
	//삭제된 게시물 리스트에 보여질지 여부
	private String BT_EMAIL_ADDRESS;
	
	//xss 필터 사용여부
	private String BT_XSS_YN;
	
	//Web 에디터 추가여부
	private String BT_HTMLMAKER_PLUS_YN;
	
	//코드네임
	private String SC_CODENM ;
	
	//파일 확장자
	private String BT_FILE_EXT ;
	
	//게시판 넘버링 종류
	private String BT_NUMBERING_TYPE ;
	
	//자기가 쓴글만 보이기 여부
	private String BT_SHOW_MINE_YN ;
	
	//게시물 삭제 정책
	private String BT_DEL_POLICY ;
	
	//개인정보보안 여부
	private String BT_PERSONAL_YN ;
	
	//개인정보보안 여부 종류  
	private String BT_PERSONAL;
	
	//개인정보보안 여부 종류  
	private String[] BT_PERSONAL_ARRAY;

	//파일 압축 여부
	private String BT_ZIP_YN;
	
	//동영상 썸네일 생성 여부
	private String BT_MOVIE_THUMBNAIL_YN;
	
	//카테고리 설정 여부
	private String BT_CATEGORY_YN;
	
	//카테고리 INPUT 내용
	private String BT_CATEGORY_INPUT;

	//비밀댓글사용여부
	private String BT_SECRET_COMMENT_YN;

	//썸네일 등록 방법
	private String BT_THUMBNAIL_INSERT;
	
	//삭제된 댓글 보여질지 여부
	private String BT_DEL_COMMENT_YN ;
	
	//리스트 스킨 키값
	private String BT_LIST_KEYNO;
	//상세페이지 스킨 키값
	private String BT_DETAIL_KEYNO;
	//등록 페이지 스킨 키값
	private String BT_INSERT_KEYNO;

	//캘린더 유무 
	private String BT_CALENDAR_YN;

	//첨부파일 미리보기 여부
	private String BT_PREVIEW_YN;
	
	//한 페이지당 게시되는 댓글 건 수
	private int BT_PAGEUNIT_C = 0;
		
	//댓글 리스트에 게시되는 페이지 건수
	private int BT_PAGESIZE_C = 0;
	
	//게시물 관리대장 삭제사유 수집 여부
	private String BT_DEL_MANAGE_YN;
	
	//게시물 제목 글자 수 제한
	private int BT_SUBJECT_NUM = 0;
	
	//게시물 내용 금지어 설정
	private String BT_FORBIDDEN;
	
	//게시물 금지어 설정 여부
	private String BT_FORBIDDEN_YN;
	
	
	public String getCategoryName(Integer index) {
		// TODO Auto-generated method stub
		if(index == null) return null;
		
		try{
			return BT_CATEGORY_INPUT.split(",")[index - 1];
		}catch (NullPointerException | IndexOutOfBoundsException e) {
			return null;
		}
	}
}
