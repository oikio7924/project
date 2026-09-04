package com.tx.common.service.component.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.SettingData;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.admin.domain.dto.HomeManager;
import com.tx.dyAdmin.admin.site.service.SiteService;
import com.tx.dyAdmin.homepage.menu.dto.Menu;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


/**
 * @CommonDataAccessObject
 * 공통 인터 페이스의 처리 내용을 관리한다.
 * @author 신희원
 * @version 1.0
 * @since 2014-11-14
 */
@Service("CommonService")
public class CommonServiceImpl extends EgovAbstractServiceImpl implements CommonService {
	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;	
	
	@Autowired SiteService SiteService;
	
	@Value("#{config['mysql.url']}") 
	private String databaseURL;
	
	/**
	 * 코드관리에서 고유 코드 번호를 취득한다.
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getCodeNumber(String query)throws Exception{
		String Code = Component.getData(query);
		if(Code == null || Code.equals("")){
			Code = "1";
    	}else{
    		Code = ""+(Integer.parseInt(Code.substring(4))+1);
    	} 
    	while(Code.length() < 4){
    		Code = "0"+Code;
    	}
        String getCodeNumber = "Code"+ Code;
        return getCodeNumber;
	}
	
	
	
	
	/**
	 * 테이블 키 정보 조회 후 새키 번호 발급
	 */
	@Override
    public synchronized String getTableKey(String TableCode) throws DataAccessException{
		
		//테이블 명 필터 및 갱신 처리
		String tableName = getTableName(TableCode);
		//테이블 코드가 없는 경우
		if(tableName == null){
			return null; // 잘못된 파라미터를 받을 경우 null로 Return
		}
		Map<String,String> KEY = new HashMap<String, String>();
		KEY.put("TableName", tableName);
		KEY.put("TableCode", TableCode + "_KEYNO");
		
		//테이블 현재 카운팅 숫자 조회
		Integer getKeyNum = Component.getData("Common.getTableKey", tableName);
		if(getKeyNum == null){
			Component.createData("Common.createTableKey", KEY);
			getKeyNum = 0;
		}
		String CodeColumn = "";
		
		
		//랜덤
		if(getKeyNum == -1){
			do {
				CodeColumn = "";	
				for(int i=0;i<5;i++){
					/* A-Z 까지 랜덤으로 5번 뽑음*/
					CodeColumn += (char)(new Random().nextInt(26)+65);
				}
				KEY.put("CodeColumn", TableCode + "_" + CodeColumn);
				int count = Component.getCount("Common.checkTableKey", KEY);
				if(count == 0){
					break;
				}
			}while(true);
			
		}
		//일반 카운팅
		else{
			getKeyNum = getKeyNum + 1;
			
			//카운터 갱신 처리
			Component.updateData("Common.CountTableKey", tableName);
			CodeColumn = Integer.toString(getKeyNum);
			//코드 발급
			while(CodeColumn.length() < 10){
				CodeColumn = "0" +  CodeColumn;
			}
		}
		return TableCode + "_" + CodeColumn;
		
		
	}
	
	/**
	 * 테이블 키 정보 조회 후 새키 번호 발급
	 */
	@Override
	public Integer getTableAutoKey(String TableName, String sequenceName) throws DataAccessException{
		HashMap<String, Object> map = new HashMap<>();
		map.put("TABLE_SCHEMA", databaseURL.substring(databaseURL.lastIndexOf("/")+1));
		map.put("TABLE_NAME", TableName);
		map.put("SEQUENCE_NAME", sequenceName);	//oracle에서 쓰임
		Component.updateData("Common.set_AutoIncremeantVal", map);
		return (Integer) map.get("incrementVal");
	}
	
	/**
	 * 테이블 코드 번호를 테이블 정보로 리턴
	 */
	@Override
	public String getTableName(String TableCode){
		String TableName = "";
		switch (TableCode) {
			 
			 //홈페이지관리 관련
			 case "MN" 	 	: TableName = "S_MENU_MANAGER"; break;				 	// 메뉴 관리
			 case "HM" 	 	: TableName = "S_HOME_MANAGER"; break;				 	// 홈페이지 관리
			 case "HAM" 	: TableName = "S_HOME_AUTHORITY_MANAGER"; break;	 	// 홈페이지 권한별 설정 
			 case "MVD" 	: TableName = "S_MENU_VIEW_DATA"; break;			 	// 메뉴관리 - 뷰형 데이터 저장
			 case "MVH" 	: TableName = "S_MENU_VIEW_DATA_HISTORY"; break;	 	// 메뉴관리 - 뷰형 데이터 히스토리
			 case "RM" 		: TableName = "S_RESOURCES_MANAGER"; break;				// 리소스 테이블
			 case "RMS" 	: TableName = "S_RESOURCES_MANAGER_SUB"; break;			// 리소스 서브 테이블
			 case "RMH" 	: TableName = "S_RESOURCES_MANAGER_HISTORY"; break;		// 리소스 히스토리 테이블
			 case "TSM" 	: TableName = "S_SITE_MANAGER"; break;					// 사이트 관리 테이블
			 case "USR"		: TableName = "U_USERINFO_SECURED_RESOURCE"; break;	 	// 리소스 관리
			 
			 //회원 관리 관련
			 case "UI" 		: TableName = "U_USERINFO"; break;					 	// 회원 관리
			 case "UIA"		: TableName = "U_USERINFO_AUTHORITY"; break;		 	// 회원 - 권한 관리
			 case "UIR"		: TableName = "U_USERINFO_ROLL"; break;				 	// 회원 - 서브 권한 관리
			 case "UW"      : TableName = "U_USERINFO_WITHDRAW"; break;             // 회원탈퇴 관리 테이블
			 
			 //기능 관리 관련
			 case "MC" 	 	: TableName = "S_COMMON_CODE_MAIN"; break;			 	// 코드 관리 메인
			 case "SC" 	 	: TableName = "S_COMMON_CODE_SUB"; break;			 	// 코드 관리 서브
		     case "IPM" 	: TableName = "T_IPFILTER_MAIN"; break;				 	// IP 필터 관리 테이블 메인
			 case "IPS" 	: TableName = "T_IPFILTER_SUB"; break;				 	// IP 필터 관리 테이블 서브
			 
			 //운영 관리 관련
			 case "BT" 	 	: TableName = "B_BOARD_TYPE"; break;				 	// 게시판 타입관리
			 case "XH" 	 	: TableName = "T_XML_HISTORY"; break;			 		// xml 히스토리 테이블
			 case "PI" 	 	: TableName = "T_POPUPINFO"; break;					 	// 팝업 관리
			 case "CQ" 	 	: TableName = "T_COMMON_QRCODE"; break;				 	// QR 코드
			 case "TPS"	 	: TableName = "T_PAGE_RESEARCH_MANAGER"; break;			// 페이지 평가 관리 테이블
			 case "BMM" 	: TableName = "B_BOARD_MAINMINI"; break;				// 미니게시판 테이블
			 case "TCGM" 	: TableName = "T_POPUPZONE_CATEGORY"; break;			// 카테고리 관리 테이블
			 case "TLM" 	: TableName = "T_POPUPZONE_LIST"; break;				// 리스트 관리 테이블
			 case "DN" 	 	: TableName = "T_DEPARTMENT_MANAGER"; break;		 	// 부서 관리 테이블
			 case "DU" 	 	: TableName = "T_DEPARTMENT_USER_MANAGER"; break;	 	// 부서원 관리 테이블
			 
			 //예약 관리 관련
			 case "AD" 		: TableName = "T_APPLICATION_DISCOUNT"; break;	 	 	// 신청 프로그램 할인정책 관리 서브 테이블
			 case "PM" 		: TableName = "T_PLACE_MANAGER"; break;				 	// 장소 관리 테이블
			 case "PSM" 	: TableName = "T_PLACE_SEATGROUP_MAIN"; break;		 	// 장소 좌석배치도 관리 메인 테이블
			 case "PSS" 	: TableName = "T_PLACE_SEATGROUP_SUB"; break;		 	// 장소 좌석배치도 관리 서브 테이블
			 case "APS"     : TableName = "T_APPLICATION_PARTICIPATE_SEAT"; break;  // 프로그램 좌석 관리 테이블 
			 
			 //스킨 관리 관련
			 case "PRS"     : TableName = "T_PAGE_RESEARCH_SKIN"; break;            // 페이지 평가 스킨 관리 테이블
			 case "PRSH"    : TableName = "T_PAGE_RESEARCH_SKIN_HISTORY"; break;    // 페이지 평가 스킨 관리 히스토리 테이블
			 case "PIS" 	: TableName = "T_POPUPINFO_SKIN"; break;				// 팝업 스킨관리 테이블
			 case "PISH" 	: TableName = "T_POPUPINFO_SKIN_HISTORY"; break;		// 팝업 스킨관리 히스토리 테이블
			 case "SS" 		: TableName = "T_SURVEY_SKIN"; break;					// 설문 스킨 관리 테이블
             case "SSH"     : TableName = "T_SURVEY_SKIN_HISTORY"; break;           // 설문 스킨 히스토리 관리 테이블
             case "SMT"     : TableName = "S_MENU_TEMPLATE"; break;                 // 메뉴 헤더 템플렛 관리 테이블
             
		     default     : System.out.println("등록 되지 않은 테이블입니다."); return null; 	// 잘못됫 입력 정보  null 리턴
	    }
		return TableName;
	}
	
	/**
	 * 받아온 keyno값을 테이블 규칙에 맞게 변경
	 * ex) 123 -> SC_0000000123
	 */
	public String getKeyno(String keyno,String tableName){
		//숫자타입 key가 아닐 경우 그대로 반환
		if( !StringUtils.isNumeric(keyno) ){
			return keyno;
		}
		int length=keyno.length();
		for(int i=length;i<10;i++){
			keyno="0"+keyno;
		}
		return tableName+"_"+keyno;
		
	}
	
	public String getKeyno(int key,String tableName){
		return getKeyno(String.valueOf(key),tableName);
	}
	
	
	
	/**
	 * 받아온 keyno값을 숫자만 추출
	 * ex) SC_0000000123 - > 123
	 */
	public String setKeyno(String keyno){
		
		return Integer.parseInt(keyno.split("\\_")[1])+"";
		
	}
	
	
	 /**
	  * 접속 IP 확인
	  * @param request
	  * @return
	  */
	 public String getClientIP(HttpServletRequest request) {

	     String ip = request.getHeader("X-FORWARDED-FOR"); 
	     if(ip == null || ip.length() == 0) {
	         ip = request.getHeader("Proxy-Client-IP");
	     }
	     if(ip == null || ip.length() == 0) {
	         ip = request.getHeader("WL-Proxy-Client-IP");  // 웹로직
	     }
	     if(ip == null || ip.length() == 0) {
	         ip = request.getRemoteAddr() ;
	     }
	     return ip;
	 }
	
	 /**
	  * 홈페이지 코드 return
	  * 최상위 Menu Key들의 List를 반환한다.
	 */
	 public List<HomeManager> getHomeDivCode(boolean includeAdmin){
		//홈페이지 구분 리스트
		 Menu MenuForHomeDivList = new Menu();
			MenuForHomeDivList.setMN_DEL_YN("N");
			MenuForHomeDivList.setMN_HOMEDIV_C(null);
			MenuForHomeDivList.setMN_MAINKEY("");
			MenuForHomeDivList.setMN_KEYNO(SettingData.HOMEDIV_ADMIN);
			MenuForHomeDivList.setMN_HOMEPAGE_REP(SiteProperties.getString("HOMEPAGE_REP"));
			if(!includeAdmin){
				MenuForHomeDivList.setMN_KEYNO(SettingData.HOMEDIV_ADMIN);
				MenuForHomeDivList.setSearchKeyword("incldueAdmin");
			}
			return Component.getList("Menu.AMN_getMenuList",MenuForHomeDivList);
	 }
	 
	 /**
		 * request를 통한 URL값 얻기 
		 * @throws Exception 
		 *   */
	public String checkUrl(HttpServletRequest req) throws Exception{
		String URL = "";
		/*
		URL : req.getRequestURL();
		URI :req.getRequestURI()
		Path :req.getServletPath()
		Scheme :req.getScheme()
		ServerName :req.getServerName()
		ServerPort :req.getServerPort()
		Context :req.getContextPath()
		*/
		String port = req.getServerPort()+"";
		if(port.equals("80")){ // 서비스시 80포트는 숨김
			port = "";
		}else{
			port = ":"+port;
		}
		URL = req.getScheme() + "://" + req.getServerName() + port + req.getContextPath();
		return URL;
	}
	
	/**
	 * 타일즈에 따른 JSP 경로 리턴
	 * @param tiles
	 * @param path
	 * @return
	 * @throws Exception
	 */
	public String getJspName(String tiles, String path) throws Exception{
		
		String HM_TILES = Component.getData("HomeManager.HM_getTiles", tiles);
		
		if(StringUtils.isEmpty(HM_TILES)){
			return null;
		}
		
		HM_TILES = "/user/" + HM_TILES + path;
		
		return HM_TILES;
		
		
	}

	@Override
	public String getSessionUserKey(HttpServletRequest req) throws Exception {
		@SuppressWarnings("unchecked")
		HashMap<String, Object> userInfo = (HashMap<String, Object>) req.getSession().getAttribute("userInfo");
		if( userInfo == null || userInfo.get("UI_KEYNO") == null ){
			return "";
		}
		return userInfo.get("UI_KEYNO").toString();
	}

	
	/**
	 * 넘어온 배열들의 길이가 같은지 확인한다.
	 * @param array
	 * @return
	 */
	@Override
	public boolean checkArrayLength(String[]... arrays) throws Exception {
		
		
		for(String[] array : arrays){
			if(array == null) return false;
		}
		
		Integer length = null;
		
		for(String[] array : arrays){
			if(length == null){
				length = array.length;
			}else{
				if(length != array.length){
					throw new RuntimeException("넘어온 배열들의 길이가 다름.");
				}
			}
		}
		return true;
	}
	
	/**
	 * Object to Map
	 * 
	 * oMapper.convertValue(obj, Map.class) 이게 AA_BBBB 이런 필드는 aa_BBBB 이런식으로 변환시킴
	 * ABCD -> abcd 로 변환
	 * 그래서  _ 를 포함한 필드는 대문자로 변경 처리함
	 * 혹시나 aaa_bbb 이런필드를 쓰고있으면 AAA_BBB이런식으로 변경처리되니 주의
	 * ABCD 이런 컬럼도 쓰지말것
 	 * 
	 * @param obj
	 * @return
	 * @throws IllegalAccessException 
	 * @throws Exception 
	 */
	@Override
	public Map<String, Object> ConverObjectToMap(Object obj) throws Exception{
			
		ObjectMapper oMapper = new ObjectMapper();
        // object -> Map
		@SuppressWarnings("unchecked")
		Map<String, Object> map = oMapper.convertValue(obj, Map.class);
        
        // aa_BBBB to AA_BBBB
        Map<String, Object> newMap = map.entrySet().stream()
        		.collect(Collectors.toMap(
        				  entry -> checkUpperString(entry.getKey())
						, entry -> entry.getValue() == null ? "":entry.getValue()));
		return newMap;
	}

	private String checkUpperString(String key) {
		
		if(key.indexOf("_") > -1){
			return key.substring(0, key.indexOf("_")).toUpperCase() + key.substring(key.indexOf("_"));
		}else{
			return key;
		}
	}




	@Override
	public List<Map<String, Object>> ConverObjectListToMapList(List<?> objList) throws Exception {
		List<Map<String,Object>> mapList = new ArrayList<Map<String,Object>>();
		
		for(Object obj : objList) mapList.add(ConverObjectToMap(obj));
			
		return mapList;
	}
	
	/**
	 * 테이블 데이터 삭제
	 * @param tableName
	 * @param column
	 */
	@Override
	public void deleteData(String tableName, List<HashMap<String,Object>> columns) throws Exception {
		HashMap<String,Object> deleteMap = new HashMap<String,Object>();
		deleteMap.put("tableName",tableName);
		deleteMap.put("columns", columns);
		Component.deleteData("Common.deleteTableData",deleteMap);
	}
	
	/**
	 * 해쉬맵 만들어서 리턴 
	 * @param string
	 * @param object
	 * @return
	 * @throws Exception
	 */
	@Override
	public HashMap<String,Object> createMap(String name, Object object) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		map.put(name, object);
		return map;
	}
	
	/**
	 * 해쉬맵 만들어서 리턴2 
	 * @param req
	 * @return
	 */
	@Override
	public HashMap<String,Object> getSiteMap(String tiles){
		
		if(StringUtils.isBlank(tiles)){
			tiles = "dy";
		}
		
		HashMap<String, Object> map = new HashMap<>();
		map.put("USERID", SiteProperties.getCmsUser());
		map.put("HM_TILES", tiles);
		
		return map;
	}
	
	/**
	 * 유저 정보 가져오기
	 * @param req
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String,Object> getUserInfo(HttpServletRequest req){
		
		return (Map<String, Object>) req.getSession().getAttribute("userInfo");
	}
	
	/**
	 * path 경로 줄이기
	 * @param path
	 * @param length
	 * @return
	 */
	@Override
	public String pathSubString(String path, int length) {
		return path.substring(0, path.length()-length);
	}
	

	/**
	 * common tiles layout 과 body 셋팅
	 */
	@Override
	public ModelAndView setCommonJspPath(String tiles, String path) {
		
		ModelAndView mv = new ModelAndView(path+".common");
		mv.addObject("commonLayout",  getCommonLayout(tiles));
		return mv;
	}

	

	/**
	 * tiles layout 경로 셋팅
	 * @param tiles
	 * @return
	 */
	private String getCommonLayout(String tiles) {
		StringBuilder sb = new StringBuilder("/WEB-INF/jsp/layout/user/defaultlayout/")
								.append(SiteService.getSitePath(tiles))
								.append("/layout.jsp");
		
		return sb.toString();
	}
	
	/**
	 * return MN_HOMEDIV_C 값 
	 * 
	 * 세션에 SITE_KEYNO 있으면 세션값 리턴
	 * 없으면 대표홈페이지 값 리턴
	 */
	@Override
	public String getDefaultSiteKey(HttpServletRequest req) throws Exception {
		String siteKey = (String)req.getSession().getAttribute("SITE_KEYNO");
		if(StringUtils.isNotBlank(siteKey)){
			return siteKey;
		}else{
			throw new RuntimeException("사이트 키가 설정되지 않았습니다.");
		}
	}
    
}
