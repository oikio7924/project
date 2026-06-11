package com.tx.dyAdmin.statistics.service;

import javax.servlet.http.HttpServletRequest;


/**
 * AdminStatisticsService
 * @author 이혜주
 * @version 1.0
 * @since 2019-07-26
 */
public interface AdminStatisticsService {

	
	/**
	 * 통계 등록하기
	 * @param pageDivList 
	 * @param _depth 
	 * @param req
	 * @param tour
	 * @param REGNM
	 * @throws Exception
	 */
	public void addStatistics(HttpServletRequest req, String STM_TYPE, String STM_CONNECT_KEY, String STM_MAINKEY) throws Exception;
	
	/**
	 * 총 방문자 수
	 * @param tiles
	 * @return
	 */
	public Object getSiteVisitorTotalCount(String tiles);
	
	/**
	 * 오늘 방문자 수
	 * @param tiles
	 * @return
	 */
	public Object getSiteVisitorTodayCount(String tiles);
} 
