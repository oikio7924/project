package com.tx.common.service.component;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.dao.DataAccessException;


/**
 * @CommonInterface
 * 공통 인터 페이스를 관리한다.
 * @author 신희원
 * @version 1.0
 * @since 2014-11-14
 */
public interface ComponentService {
	
	/**
	 * 데이터 개수 조회
	 * @param query
	 * @param model
	 * @return
	 * @throws DataAccessException
	 */
    public Integer getCount(String query, Object model) throws DataAccessException;
	
    /**
	 * 데이터 개수 조회
	 * @param query
	 * @return
	 * @throws DataAccessException
	 */
    public Integer getCount(String query) throws DataAccessException;
    
    /**
     * 목록 조회
     * @param <E>
     * @param query
     * @param model
     * @return
     * @throws DataAccessException
   */
    public <E> List<E> getList(String query, Object model) throws DataAccessException;
   
    /**
     * 파라미터 값 없는 목록 조회
     * @param <E>
     * @param query
     * @param model
     * @return
     * @throws DataAccessException
     */
    public <E> List<E> getListNoParam(String query) throws DataAccessException;
    
    /**
     * 페이지 구분 목록 조회
     * @param query
     * @param model
     * @return
     * @throws DataAccessException
     */
    public <E> List<E> getPageList(String query, Object model) throws DataAccessException;

    /**
     * 데이터 조회 (Object)
     * @param query
     * @param model
     * @return
     * @throws DataAccessException
     */
    public <E> E getData(String query, Object model) throws DataAccessException;
    
    /**
     * 데이터 조회 (Object)
     * @param query
     * @param model
     * @return
     * @throws DataAccessException
     */
    public <E> E getData(String query) throws DataAccessException;
    
    
    
    /**
     * 데이터 삽입 
     * @param query
     * @param model
     * @return Obj
     * @throws DataAccessException
     */
    public void createData(String query, Object model) throws DataAccessException;   
    
    /**
     * 데이터 삽입 - list의 갯수가 클경우 list를 splitSize 크기로 잘라서 여러번 insert
     * @param insertMap
     * @param list
     * @param query
     * @param listName
     * @param splitSize
     * @throws Exception
     */
    public void createDataWithSplitList(HashMap<String,Object> insertMap , List<?> list, String query,
			String listName,int splitSize) throws Exception;
    
    /**
     * 데이터 수정 (Yes Obj)
     * @param query
     * @param Object
     * @return
     * @throws DataAccessException
     */
    public void updateData(String query, Object model) throws DataAccessException;

    /**
     * 데이터 삭제
     * @param query
     * @param model
     * @throws DataAccessException
     */
    public void deleteData(String query, Object model) throws DataAccessException;
    
    /**
     * 데이터 삭제
     * @param query
     * @param model
     * @throws DataAccessException
     */
    public void deleteData(String query) throws DataAccessException;
    
    /**
	 * 검색 조건 셋팅
	 * @param req
	 * @return
	 */
	public List<HashMap<String, Object>> getSearchList(HttpServletRequest req) throws Exception;

	

} 
