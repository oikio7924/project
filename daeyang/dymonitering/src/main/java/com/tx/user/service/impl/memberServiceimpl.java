package com.tx.user.service.impl;

import java.util.HashMap;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.tx.common.service.component.ComponentService;
import com.tx.user.service.memberService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("memberService")
public class memberServiceimpl extends EgovAbstractServiceImpl implements memberService {
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	
	@Override
	@Scheduled(cron="0 0 2 * * ?")  // 매일 오전 2시 주기
	@Transactional
	public void DormancySchedule() throws Exception {		
		HashMap<String,Object> map = new HashMap<String,Object>();						
		map.put("UI_DORMANCY", "Y");
		Component.updateData("member.UI_updateDormancyYN", map);
	}
	

}
