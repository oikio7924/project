package com.tx.common.service.page;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * @PageAccess
 * 페이징 처리를 담당한다.
 * PaginationInfo 클래스에 갱신하기위해
 * 페이지 처리를 원하는 페이지의 현재 페이지 번호와 전체 데이터 개수를 조회하는 쿼리문을 파라미터 값으로 받는다.
 * @author 신희원
 * @version 1.0
 * @since 2014-11-14
 */
public interface PageAccess{
	

	/**
	 * 페이지 계산 처리
	 * @throws Exception
	 */
	public PaginationInfo getPagInfo(Integer pageIndex, String query) throws Exception;
	
	/**
	 * 페이지 계산 처리 (파라미터 사용)
	 * @throws Exception
	 */
	public PaginationInfo getPagInfo(Integer pageIndex, String query, Object obj) throws Exception;
	
	/**
	 * 페이지 계산 처리 (파라미터 사용 및 page unit 처리)
	 * @throws Exception
	 */
	public PaginationInfo getPagInfo(Integer pageIndex, String query, Object obj,Integer PageUnit) throws Exception;
	
	/**
	 * 페이지 계산 처리 (파라미터 사용 및 pageunit,pagesize 처리)
	 * @throws Exception
	 */
	public PaginationInfo getPagInfo(Integer pageIndex, String query, Object obj,Integer PageUnit,Integer PageSize) throws Exception;
	
	
	
	
}