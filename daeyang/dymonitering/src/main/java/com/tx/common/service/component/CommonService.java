package com.tx.common.service.component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.dao.DataAccessException;
import org.springframework.web.servlet.ModelAndView;

import com.tx.dyAdmin.admin.domain.dto.HomeManager;


/**
 * CommonService
 * 공통 인터 페이스를 관리한다.
 * @author 이재령
 * @version 1.0
 * @since 2018-09-21
 */
public interface CommonService {
	
    /**
	 * 코드관리에서 고유 코드 번호를 취득한다.
	 * @return
	 * @throws Exception
	 */
	public String getCodeNumber(String query) throws Exception;
    
		
    /**
	 * 테이블 키 정보 조회 후 새키 번호 발급
	 */
    public String getTableKey(String TableCode) throws DataAccessException;
    
    /**
     * 테이블 키 정보 조회 후 새키 번호 발급
     */
    public Integer getTableAutoKey(String TableName, String sequenceName) throws DataAccessException;
	
	/**
	 * 테이블 코드 번호를 테이블 정보로 리턴
	 */
	public String getTableName(String TableCode);
	
	/**
	 * 받아온 keyno값을 테이블 규칙에 맞게 변경
	 * ex) 123 -> SC_0000000123
	 */
	public String getKeyno(String keyno,String tableName);
	
	public String getKeyno(int keyno,String tableName);
	
	/**
	 * 받아온 keyno값을 숫자만 추출
	 * ex) SC_0000000123 - > 123
	 */
	public String setKeyno(String keyno);
	
	/**
	  * 접속 IP 확인
	  * @param request
	  * @return
	  */
	 public String getClientIP(HttpServletRequest request);

	 /**
	  * 홈페이지 코드 return
	  * 최상위 Menu Key들의 List를 반환한다.
	 * @return 
	 */
	 public List<HomeManager> getHomeDivCode(boolean includeAdmin);
	 
	 /**
	  * request를 통해 URL정보를 return
	  * ex) http://tronix.kr:8080/ko/
	  * scheme부터 contextPath까지 조립
	  * @param object
	 * @throws Exception 
	  */
	public String checkUrl(HttpServletRequest req) throws Exception;
	
	/**
	 * 세션 내 회원 정보의 PK를 리턴
	 * @param request
	 * @return UI_KEYNO, 없을 경우 ""
	 * @throws Exception
	 * @comment 우리를 괴롭혔던 사용자 키 구하기
	 */
	public String getSessionUserKey(HttpServletRequest request) throws Exception;

	
	/**
	 * 넘어온 배열들의 길이가 같은지 확인한다.
	 * @param array
	 * @return
	 */
	public boolean checkArrayLength(String[]... arrays) throws Exception;
	

	
	/**
	 * Object to Map
	 * @param obj
	 * @return
	 */
	public Map<String, Object> ConverObjectToMap(Object obj) throws Exception;
	
	
	public List<Map<String,Object>> ConverObjectListToMapList(List<?> objList) throws Exception;

	/**
	 * 테이블 데이터 삭제
	 * @param tableName
	 * @param column
	 */
	public void deleteData(String tableName, List<HashMap<String,Object>> columns) throws Exception;

	/**
	 * 해쉬맵 만들어서 리턴 
	 * @param name
	 * @param object
	 * @return
	 * @throws Exception
	 */
	public HashMap<String,Object> createMap(String name, Object object) throws Exception;
	
	/**
	 * 해쉬맵 만들어서 리턴2 
	 * @param name
	 * @param object
	 * @return
	 * @throws Exception
	 */
	public HashMap<String,Object> getSiteMap(String tiles) throws Exception;
	
	/**
	 * 유저 정보 가져오기
	 * @param req
	 * @return
	 */
	public Map<String,Object> getUserInfo(HttpServletRequest req);
	
	
	/**
	 * path 경로 줄이기
	 * @param path
	 * @param length
	 * @return
	 */
	public String pathSubString(String path, int length);
	
	public ModelAndView setCommonJspPath(String tiles, String path);
	
	public String getDefaultSiteKey(HttpServletRequest req) throws Exception;
	
} 
