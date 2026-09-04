package com.tx.common.dto;

import java.io.Serializable;

import lombok.Data;

@Data
public class Common implements Serializable {

	private static final long serialVersionUID = 5100802984234952222L;

	/** 검색관련 */
	private String searchCondition = "";	//검색조건 ex) 이름, 성별, 나이 등
	private String[] searchConditionArr;	//검색조건 배열
	private String searchKeyword = "";		//검색 Keyword
	private String[] searchKeywordArr;		//검색 Keyword 배열
	private String searchBeginDate = "";	//날짜 검색 시작 일자
	private String searchEndDate = "";		//날짜 검색 종료 일자
	private String orderCondition = "";		//정렬조건 ex) 최신,조회수
	private String orderBy = "";			//테이블 sort
	private String sortDirect = "";			//ASC, DESC
	private String userAuth = "";			//유저권한키 (유저별 접근권한 관련)
	
	/** 추가 전달 메세지
	 * ex) "입력이 완료되었습니다."	*/
	private String resultMsg = "";
	
	
	/** Pagination 관련 공용 변수 */
	private int pageUnit = 25;		//페이지 리스트 갯수
	private int pageUnit2 = 10;		//ems로그관리
	private int pageIndex = 1;	//현재페이지
	private int firstIndex;	//첫번째 인덱스
	private int lastIndex;	//마지막 인덱스
	private int recordCountPerPage;	//페이지 카운트 수
	
}

