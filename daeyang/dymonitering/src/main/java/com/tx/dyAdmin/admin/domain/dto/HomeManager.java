package com.tx.dyAdmin.admin.domain.dto;

import java.io.Serializable;
import java.util.List;

import com.tx.dyAdmin.homepage.menu.dto.Menu;

import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;

/* 홈페이지 관리 - Menu의 MN_HOMEDIV_C 연관 */
@Data
@EqualsAndHashCode(callSuper=false)
public class HomeManager extends Menu implements Serializable{

	private static final long serialVersionUID = -1966682431378308377L;
	
	private String HM_KEYNO;
	private String HM_TILES;
	private String HM_MENU_DEPTH;
	private String HM_USE_YN;
	private String HM_MN_HOMEDIV_C;
	private String HM_FAVICON;
	private String FS_PATH;
	private String FS_FILENAME;
	private String FS_ORINM;
	private String HM_MN_MAINKEY;
	private String HM_LOGIN;
	private String HM_SITE_PATH;
	private String tilesBefore;
	private String HM_GROUP;
	private String HM_GROUP_NAME;
	
	private String    HM_LANG
					, HM_TITLE
					, HM_RESEARCH_SKIN
					, HM_POPUP_SKIN_W
					, HM_POPUP_SKIN_B;
	
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	private List<String> pageDivList = null;
	
	private String UIA_KEYNO;
	private String UIA_MAINKEY;

	private String HM_META_DESC, HM_META_KEYWORD, HM_SESSION;
	
}