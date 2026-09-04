package com.tx.dyAdmin.statistics.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.statistics.dto.StatisticsDTO;
import com.tx.dyAdmin.statistics.service.AdminStatisticsService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * AdminStatisticsServiceImpl
 * 
 * @author 이혜주
 * @version 1.0
 * @since 2019-07-26
 */
@Service("AdminStatisticsService")
public class AdminStatisticsServiceImpl extends EgovAbstractServiceImpl implements AdminStatisticsService {

	/** 공통 컴포넌트 */
	@Autowired
	ComponentService Component;
	@Autowired
	CommonService CommonService;

	private List<HashMap<String, Object>> totalVisit = null;
	private List<HashMap<String, Object>> todayVisit = null;
			
	@PostConstruct
	public void init(){
		setSiteVisitorCount();
	}
	
	@Override
	public void addStatistics(HttpServletRequest req, String STM_TYPE, String STM_CONNECT_KEY, String STM_MAINKEY) throws Exception {
		
		StatisticsDTO StatisticsDTO = new StatisticsDTO();
		StatisticsDTO.setSTM_TYPE(STM_TYPE);
		StatisticsDTO.setSTM_IP(CommonService.getClientIP(req));
		StatisticsDTO.setSTM_CONNECT_KEY(STM_CONNECT_KEY);
		StatisticsDTO.setSTM_MAINKEY(STM_MAINKEY);
		Component.createData("Statistics.STM_insert", StatisticsDTO);
	}
	
	/**
	 * 방문자 수 저장
	 */
	private void setSiteVisitorCount(){
		
		totalVisit = Component.getListNoParam("Log.get_VisiterCount");
		todayVisit = Component.getListNoParam("Log.get_VisiterCountToday");
		
	}
	
	public Object getSiteVisitorTotalCount(String tiles){
		for (HashMap<String, Object> map : totalVisit) {
			if(map.get("HM_TILES").equals(tiles)) return map.get("CNT");
		}
		return 0;
	}
	
	public Object getSiteVisitorTodayCount(String tiles){
		for (HashMap<String, Object> map : todayVisit) {
			if(map.get("HM_TILES").equals(tiles)) return map.get("CNT");
		}
		return 0;
	}
	
//	@Scheduled(cron="0 0/5 * * * ?")
//	@Scheduled(cron="0/30 * * * * ?")
	/*private void schedule() throws Exception{
		setSiteVisitorCount();
	}*/

}
