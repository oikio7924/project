package com.tx.common.config;

/**
 * 상수값들 정리
 * @author 이재령
 *
 */
public class SettingData {
	
	
	
	public final static String PROGRAMER_KEY = "UI_SFMHO"; //개발자 계정
	
	public final static String HOMEPAGE_LANGUAGE = "ko"; //홈페이지 언어
//	public final static String HOMEPAGE_LANGUAGE = "en"; //홈페이지 언어
	
	public final static int SESSION_DURATION = 17000+30; 	//세션 유지 시간 (초단위) 오차범위 수정을 위해 30초 추가로 셋팅해둠
	
	
	public final static String HOMEDIV_DY = "MN_0000000207"; //홈페이지 코드  - CF
	public final static String HOMEDIV_ADMIN = "MN_0000000999"; //홈페이지 코드  - ADMIN
	public final static String HOMEDIV_JCIA = "MN_0000001158"; //홈페이지 코드  - JCIA
	
	
	public final static String ADMINPAGE_HOMEPAGE_MANAGER_URL = "/dyAdmin/homepage"; //관리자페이지 - 홈페이지 관리 메뉴 url
	

	public final static int DEFAULT_IMG_RESIZE_WIDTH = 460;
	public final static int DEFAULT_IMG_RESIZE_HEIGHT = 0;
	public final static int DEFAULT_IMG_THUMBNAIL_RESIZE_WIDTH = 200;
	public final static int DEFAULT_IMG_THUMBNAIL_RESIZE_HEIGHT = 0;
	public final static int DEFAULT_IMG_POPUP_WIDTH = 1920;
	public final static int DEFAULT_IMG_POPUP_HEIGHT = 193;
	public final static int DEFAULT_VIDEO_IMG_WIDTH = 320;
	public final static int DEFAULT_VIDEO_IMG_HEIGHT = 180;
	public final static String DEFAULT_VIDEO_IMG_EXT = "png";
	
	public final static String MENU_TYPE_PAGE = "SC_EANHU";  // 메뉴타입 코드 - 단일 페이지
	public final static String MENU_TYPE_BOARD = "SC_TFOVO";  // 메뉴타입 코드 - 게시판
	public final static String MENU_TYPE_LINK = "SC_HFAIU";  // 메뉴타입 코드 - 링크
	public final static String MENU_TYPE_SUBMENU = "SC_QXCFB";  // 메뉴타입 코드 - 소메뉴
	public final static String MENU_TYPE_PAGE2 = "SC_VUWAQ";  // 메뉴타입 코드 - 개발자페이지
	public final static String MENU_TYPE_PREPARING = "SC_0000000419";  // 메뉴타입 코드 - 준비중
	
	
	public final static String BOARD_TYPE_LIST = "SC_0000000005";  // 게시판 코드 - 리스트형
	public final static String BOARD_TYPE_LIST_NO_DETAIL = "SC_FVMHW";  // 게시판 코드 - 리스트형(상세화면X)
	public final static String BOARD_TYPE_GALLERY = "SC_0000000006";  // 게시판 코드 - 갤러리형
	public final static String BOARD_TYPE_CALENDAR = "SC_VYIPX";  // 게시판 코드 - 캘린더형
	
	
	public final static String BOARD_COLUMN_TYPE_TITLE = "SC_HBHNH";  // 게시판 컬럼 타입 코드 - 제목
	public final static String BOARD_COLUMN_TYPE_TEXT = "SC_VEBHI";  // 게시판 컬럼 타입 코드 - 텍스트
	public final static String BOARD_COLUMN_TYPE_CHECK = "SC_JJQBU";  // 게시판 컬럼 타입 코드 - 체크
	public final static String BOARD_COLUMN_TYPE_CHECK_CODE = "SC_GCONA";  // 게시판 컬럼 타입 코드 - 체크(코드)
	public final static String BOARD_COLUMN_TYPE_RADIO = "SC_ZUZQU";  // 게시판 컬럼 타입 코드 - 라디오
	public final static String BOARD_COLUMN_TYPE_RADIO_CODE = "SC_OMILB";  // 게시판 컬럼 타입 코드 - 라디오(코드)
	public final static String BOARD_COLUMN_TYPE_SELECT = "SC_SACUX";  // 게시판 컬럼 타입 코드 - 셀렉트
	public final static String BOARD_COLUMN_TYPE_SELECT_CODE = "SC_DESUO";  // 게시판 컬럼 타입 코드 - 셀렉트(코드)
	public final static String BOARD_COLUMN_TYPE_CALENDAR = "SC_NYMMH";  // 게시판 컬럼 타입 코드 - 달력
	public final static String BOARD_COLUMN_TYPE_PWD = "SC_ZERST";  // 게시판 컬럼 타입 코드 - 패스워드
	public final static String BOARD_COLUMN_TYPE_EMAIL = "SC_ZYDQB";  // 게시판 컬럼 타입 코드 - 이메일
	public final static String BOARD_COLUMN_TYPE_NUMBER = "SC_BEIDD";  // 게시판 컬럼 타입 코드 - 숫자
	public final static String BOARD_COLUMN_TYPE_LINK = "SC_PJDGH";  // 게시판 컬럼 타입 코드 - 링크
	public final static String BOARD_COLUMN_TYPE_CALENDAR_START = "SC_0000000356";  // 게시판 컬럼 타입 코드 - 달력(시작날짜)
	public final static String BOARD_COLUMN_TYPE_CALENDAR_END = "SC_0000000357";  // 게시판 컬럼 타입 코드 - 달력(종료날짜)
	public final static String PERSONAL_SECURITY_JUMIN = "SC_0000000412"; //게시판 CONTENTS 필터 코드- 주민번호
	public final static String PERSONAL_SECURITY_PHONE = "SC_0000000413"; //게시판 CONTENTS 필터 코드- 전화
	
	
	
	
	public final static String AUTHORITY_ADMIN = "UIA_ASDFG";  				// 권한 유형  - 관리자(개발자 계정)
	public final static String AUTHORITY_ANONYMOUS = "UIA_EAFDS";  			// 권한 유형  - 비회원
	public final static String AUTHORITY_ADMIN_GROUP = "UIA_AGKGE";  		// 권한 유형  - 관리자 그룹
	public final static String AUTHORITY_ADMIN_MANAGER = "UIA_MFBJH";  		// 권한 유형  - 홈페이지 관리자
	
	
	public final static String AUTHORITY_ROLE_ACCESS = "UIR_0000000019";  	// 권한 roll  - 접근 권한
	public final static String AUTHORITY_ROLE_READ = "UIR_0000000014";  	// 권한 roll  - 읽기 권한
	public final static String AUTHORITY_ROLE_WRITE = "UIR_0000000015";  	// 권한 roll  - 쓰기 권한
	public final static String AUTHORITY_ROLE_UPDATE = "UIR_0000000020";  	// 권한 roll  - 수정 권한
	public final static String AUTHORITY_ROLE_DELETE = "UIR_0000000021";  	// 권한 roll  - 삭제 권한
	public final static String AUTHORITY_ROLE_REPLY = "UIR_0000000016";  	// 권한 roll  - 답글 권한
	public final static String AUTHORITY_ROLE_COMMENT = "UIR_0000000017";  	// 권한 roll  - 댓글 권한
	public final static String AUTHORITY_ROLE_VIEW = "UIR_0000000013";  	// 권한 roll  - 메뉴보이기 권한
	public final static String AUTHORITY_ROLE_DOWN = "UIR_0000000022";  	// 권한 roll  - 파일다운 권한
	public final static String AUTHORITY_ROLE_ACTION = "UIR_0000000023";  	// 권한 roll  - 메뉴 액션 권한
	
	public final static String AUTHORITY_SUB_ALL = "SC_WGSYT";  			// 서브 권한 타입  - 모두
	public final static String AUTHORITY_SUB_BOARD = "SC_MYKFE";  			// 서브 권한 타입  - 게시판
	public final static String AUTHORITY_SUB_ETC = "SC_TZGGA";  			// 서브 권한 타입  - 기타
	
	
	public final static String JSPDATA = "<%@ page language=\"java\" contentType=\"text/html; charset=UTF-8\" pageEncoding=\"UTF-8\"%>\n" + 
										 "<%@ include file=\"/WEB-INF/jsp/taglib/taglib.jspf\"%>\n";

	public final static String PASSWORD_REGEX = "^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,16}$";  									// 디폴트 비밀번호 정규식
	public final static String ID_REGEX = "^[A-Za-z0-9_-]{4,16}$";  																			// 아이디 정규식
	public final static String EMAIL_REGEX = "^[_0-9a-zA-Z-]+@[0-9a-zA-Z-]+(.[_0-9a-zA-Z-]{2,3}+)*$";  											// 이메일 정규식
//	public final static String EMAIL_REGEX = "^[0-9a-zA-Z]([-_\\\\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\\\\.]?[0-9a-zA-Z])*\\\\.[a-zA-Z]{2,3}$/i";  	// 이메일 정규식
	public final static String TILES = "dy";  	// Validation 타일즈
	public final static String defaultX_Location = "35.12438600722675";
	public final static String defaultY_Location = "126.76849308672915";
			
	
	//RequestAPI Setting값
	public final static String Apikey = "qcp255q389pcsb3ddunfcb7ys93kbnli";
	public final static String Userid = "daeyang";
	public final static String Senderkey = "150329633d7b950290bfb0e577375705c0678a7f";
	
	
	//개별 관리자 그룹
	public final static String samwhan = "UIA_PXIMI";
	
}
