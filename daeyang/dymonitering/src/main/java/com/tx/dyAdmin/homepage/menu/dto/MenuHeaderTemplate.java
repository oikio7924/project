package com.tx.dyAdmin.homepage.menu.dto;

import lombok.Data;

/**
 * @menu_manager
 * 메뉴 헤더 템플렛 관리를  담당한다.

 * @author 이충기
 * @version 1.0
 * @since 2020-01-22
 */

@Data
public class MenuHeaderTemplate {

	private String SMT_KEYNO;
	private String SMT_FORM; //양식
	private String SMT_REGDT; //등록날짜
	private String SMT_REGNM; //등록자
	private String SMT_DELYN; // 삭제여부
	private String SMT_FILE_NAME; // jsp파일이름
	private String SMT_FILE_PATH; // jsp 파일 경로
	private String SMT_SUBJECT; // 제목
}
