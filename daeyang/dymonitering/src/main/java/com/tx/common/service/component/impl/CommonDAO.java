package com.tx.common.service.component.impl;

import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;


@Repository("CommonDAO")
public class CommonDAO extends EgovAbstractMapper {

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public <E> List getList(String query, Object search) throws DataAccessException {
		return (List<E>) selectList(query, search);
	}
	@SuppressWarnings("unchecked")
    public <E> List<E> getListNoParam(String query) throws DataAccessException{
		return (List<E>) selectList(query, null);
	}
	
	@SuppressWarnings("unchecked")
	public <E> List<E> getPageList(String query, Object search) throws DataAccessException {
		return (List<E>) selectList(query, search);
	}

	@SuppressWarnings("unchecked")
	public <E> E getData(String query, Object search) throws DataAccessException { 
		return (E) selectOne(query, search);
	}
	
	@SuppressWarnings("unchecked")
	public <E> E getData(String query) throws DataAccessException { 
		return (E) selectOne(query, null);
	}

	public void createData(String query, Object model) throws DataAccessException {
		insert(query, model);
	}

	public void updateData(String query, Object model) throws DataAccessException {
		update(query, model);
	}

	public void deleteData(String query, Object search) throws DataAccessException {
		delete(query, search);
	}
	
	
}
