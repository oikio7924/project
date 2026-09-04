package com.tx.dyAdmin.homepage.menu.dto;

import com.tx.common.dto.Common;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;


/**
 * @menu_manager
 * 페이징 처리를 담당한다.
 * PaginationInfo 클래스에 갱신하기위해
 * 페이지 처리를 원하는 페이지의 현재 페이지 번호와 전체 데이터 개수를 조회하는 쿼리문을 파라미터 값으로 받는다.
 * @author 신희원
 * @version 1.0
 * @since 2014-11-14
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(callSuper=false)
public class Menu extends Common {
	private static final long serialVersionUID = -5033459715510358235L;
	
	//메뉴관리 고유키
	private String  MN_KEYNO;
	
	//메뉴명
	private String  MN_NAME;
	
	//메뉴 홈페이지 구분
	private String  MN_HOMEDIV_C;
	
	//메뉴 페이지 형태
	private String  MN_PAGEDIV_C;
	
	//메뉴 페이지 형태
	private String  MN_PAGEDIV_NAME;
	
	//메뉴 URL
	private String  MN_beforeURL;
		
	//메뉴 URL
	private String  MN_URL;
	
	//메뉴 URL
	private String  MN_FORWARD_URL;
	
	//대메뉴 키
	@Builder.Default private String  MN_MAINKEY = "";
	
	//상위 모든 키
	private String  MN_MAINKEYS;
	
	//상위 모든 키의 이름
	private String  MN_MAINNAMES;
		
	//대메뉴명
	private String  HIGH_MN_NAME;
		
	//메뉴 정렬 순서 (메뉴 구분으로 정렬순서를 갱신한다 대메뉴는 대메뉴 끼리의 순서, 소메뉴는 대메뉴 안에서의 소메뉴 끼리의 순서 적용 이는 홈페이지별 다름)
	private Integer MN_ORDER;
	private Integer MN_ORDER_BEFORE;
	//메뉴 레벨
	private Integer MN_LEV;
	
	//메뉴 활성화여부
	private String  MN_USE_YN;
	
	//메뉴 등록일
	private String  MN_REGDATE;
	
	//메뉴 등록일
	private String  MN_REGDT;
	
	//메뉴 최근수정일
	private String  MN_MODDATE;
	
	//메뉴 최근수정일
	private String  MN_MODDT;
	
	//메뉴 등록자
	private String  MN_REGNM;
	
	//메뉴 최근 변경자
	private String  MN_MODNM;
	
	//메뉴 보이기/감추기
	private String MN_SHOW_YN;	
	
	//메뉴 삭제 일자
	private String MN_DELDT;
	
	//메뉴 삭제 여부
	private String MN_DEL_YN;
	
	//게시판타입키
	private String MN_BT_KEYNO;
	
	//권한 적용
	private String MN_AUTHORITY;

	//권한 적용 관련 key
	private String MN_AUTHORITY_KEY;
		
	//CSS 아이콘 정보 - font-awesome
	private String MN_ICON_CSS;

	//아이콘 이미지 정보 - 마우스 오버/아웃 등에 사용할 이미지
	private String MN_ICON_URL1;
	private String MN_ICON_URL2;
	
	private String BTCODEKEY;
	private String MVD_KEYNO;
	
	private String MVD_DEL_YN;
	//영어이름
	private String MN_ENG_NAME;
	//담당부서
	private String MN_DEP;
	
	//메뉴 컬러
	private String MN_COLOR;
	
	//메뉴 기타 컬럼 1
	private String MN_DATA1;
	
	//메뉴 기타 컬럼 2
	private String MN_DATA2;
	
	//메뉴 기타 컬럼 3
	private String MN_DATA3;
	
	//공공누리
	private String MN_GONGNULI_TYPE;
	private String MN_GONGNULI_YN;
	
	//관광 고유키
	private String MN_TOURKEY;
	
	//관광 고유키
	private String MN_TOUR_CATEGORY;
	
	private String MN_ROLES;
	
	private String MN_ROLES_MAIN;
	
	@Builder.Default private String MN_HOMEPAGE_REP = "";
	
	private String MN_REAL_URL;
	
	private String MN_EMAIL;
	
	private String    dethOriORDER
					, dethOriMAIN
					, dethSubMenuKey
					, dethChUrl;
	private Integer dethInterval;
	
	private String MN_NEWLINK;

	private String authStatus;
	
	@Builder.Default private Boolean dethCHANGEYN = false;

	//페이지 평가 사용여부
	private String MN_RESEARCH;
	
	//페이지평가 - 큐알코드 사용여부
	private String MN_QRCODE;
	
	//페이지 평가 - 콘텐츠 담당자
	private String MN_MANAGER;
	
	private String MN_MANAGER_DEP;
	
	private String MN_MANAGER_TEL;
	
	//페이지 평가 - 큐알코드 이미지
	private String MN_QR_KEYNO;
	
	//페이지 평가 - 큐알코드 이미지 경로
	private String IMG_PATH;
	
	private String MN_MAIN_DATA1;
	
	@Builder.Default private Integer MN_SIBLING_CNT = 0;
	
	@Builder.Default private Integer MN_CHILD_CNT = 0;
	
	//단일페이지 갯수
	@Builder.Default private Integer MN_PAGEVIEW_CNT = 0;
	
	private String POPUP_DIV;
	
	private String MN_DU_KEYNO;
	
	private String PAGE_HOMEDIV_C, PAGE_KEYNO, PAGE_NAME, PAGE_TEL, PAGE_DEPARTMENT;
	//xml 히스톨
	private String 	 XH_KEYNO
					,XH_MN_KEYNO
					,XH_FS_KEYNO
					,XH_REGDT
					,XH_DELYN;
	
	
	private String MN_META_DESC, MN_META_KEYWORD;

	private String MN_CHANGE_FREQ;
	
	private float MN_PRIORITY;
	
	
	private String href;
	
	private String target;
	
	private String sessionTime;
	
	private String adminAuth;
	
}
