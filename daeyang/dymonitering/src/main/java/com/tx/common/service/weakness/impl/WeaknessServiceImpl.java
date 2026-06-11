package com.tx.common.service.weakness.impl;

import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.weakness.WeaknessService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("WeaknessService")
public class WeaknessServiceImpl extends EgovAbstractServiceImpl implements WeaknessService {

	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/**
	 * 정규식 검증
	 * */
	@Override
	public boolean regexCheck(String regex, String parameter) {
		Pattern pattern = Pattern.compile(regex);
		Matcher matcher = pattern.matcher(parameter);
		return matcher.matches();
	}

	/**
	 * 게시판 검증
	 * */
	@Override
	public boolean selfBoardCheck(HttpServletRequest req, String key) {
		boolean ckBoolean = false;
		
		Map<String, Object> user = CommonService.getUserInfo(req);
		String selfBoard = Component.getData("BoardNotice.get_selfBoard", key);
		
		if(user != null && selfBoard != null){
			String isAdmin = (String) user.get("isAdmin");
			if(user.containsKey("UI_KEYNO") && (user.get("UI_KEYNO").toString().equals(selfBoard) || "Y".equals(isAdmin))){
				ckBoolean = true;
			}
		}
		
		return ckBoolean;
	}
}
