package com.tx.common.service.component.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import com.tx.common.config.logger.QueryName;
import com.tx.common.service.component.ComponentService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


/**
 * @CommonDataAccessObject
 * 공통 인터 페이스의 처리 내용을 관리한다.
 * @author 신희원
 * @version 1.0
 * @since 2014-11-14
 */
@Service("ComponentService")
public class ComponentServiceImpl extends EgovAbstractServiceImpl implements ComponentService {
	
	@Resource(name = "CommonDAO")
	private CommonDAO CommonDAO;
	
	@Override
	public Integer getCount(String query, Object search) throws DataAccessException {
		printQueryId(query);
		Integer cnt = (Integer) CommonDAO.getData(query, search);
		if(cnt == null){
			cnt=0;
		}
		return cnt;
	}
	
	@Override
    public Integer getCount(String query) throws DataAccessException {
		printQueryId(query);
		Integer cnt = (Integer) CommonDAO.getData(query);
		if(cnt == null){
			cnt=0;
		}
		return cnt;
		
	}
    
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public <E> List getList(String query, Object search) throws DataAccessException {
		printQueryId(query);
		return (List<E>) CommonDAO.getList(query, search);
	}
	@SuppressWarnings("unchecked")
	@Override
	public <E> List<E> getListNoParam(String query) throws DataAccessException{
		printQueryId(query);
		return (List<E>) CommonDAO.getListNoParam(query);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public <E> List<E> getPageList(String query, Object search) throws DataAccessException {
		printQueryId(query);
		return (List<E>) CommonDAO.getPageList(query, search);
	}

	@SuppressWarnings("unchecked")
	@Override
	public <E> E getData(String query, Object search) throws DataAccessException { 
		printQueryId(query);
		return (E) CommonDAO.getData(query, search);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public <E> E getData(String query) throws DataAccessException { 
		printQueryId(query);
		return (E) CommonDAO.getData(query);
	}

	@Override
	public void createData(String query, Object model) throws DataAccessException {
		printQueryId(query);
		CommonDAO.createData(query, model);
	}
	
	@Override
    public void createDataWithSplitList(HashMap<String,Object> insertMap , List<?> list, String query,
			String listName,int splitSize) throws Exception{
		
		if(insertMap == null){
			insertMap = new HashMap<String,Object>();
		}
		
		for(int i=0;i<list.size() / splitSize;i++){
			List<?> tempList = list.subList(i*splitSize, (i+1)*splitSize);
			insertMap.put(listName, tempList);
			createData(query,insertMap);
        	
        }
        if(list.size() % splitSize != 0){
        	List<?> tempList = list.subList((list.size() / splitSize)*splitSize, list.size());
        	insertMap.put(listName, tempList);
			createData(query,insertMap);
        }
	}
	
	@Override
	public void updateData(String query, Object model) throws DataAccessException {
		printQueryId(query);
		CommonDAO.updateData(query, model);
	}

	@Override
	public void deleteData(String query, Object search) throws DataAccessException {
		printQueryId(query);
		CommonDAO.deleteData(query, search);
	}
	
	@Override
	public void deleteData(String query) throws DataAccessException {
		printQueryId(query);
		CommonDAO.deleteData(query, null);
	}
	
	private void printQueryId(String query) {
		QueryName.query = query;
	}

	
	
	/**
	 * 검색 조건 셋팅
	 * @param req
	 * @return
	 */
	@Override
	public List<HashMap<String, Object>> getSearchList(HttpServletRequest req) throws Exception {
		String [] searchKeyword = req.getParameterValues("searchKeyword");
		String [] searchIndex = req.getParameterValues("searchIndex");
		
		List<HashMap<String,Object>> searchList = null;
		HashMap<String,Object> searchMap = null;
		//2개의 값이 같은지 비교
		
		if(searchKeyword == null && searchIndex == null ){
//			System.out.println("검색조건 없음 ");
		}else if( 	searchKeyword != null && 
				searchIndex != null && 
				searchKeyword.length == searchIndex.length
		){
			searchList = new ArrayList<HashMap<String,Object>>();
			
			for(int i=0;i<searchKeyword.length;i++){
				searchMap = new HashMap<String,Object>();
				searchMap.put("searchKeyword", searchKeyword[i]);
				searchMap.put("searchIndex", searchIndex[i]);
				
				searchList.add(searchMap);
			}
			
		}else{
			System.out.println("검색조건 갯수가 다름 ");
		}
		
		return searchList;
	}

}
