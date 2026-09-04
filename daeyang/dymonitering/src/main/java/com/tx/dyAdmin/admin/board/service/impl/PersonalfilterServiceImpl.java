package com.tx.dyAdmin.admin.board.service.impl;

import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tx.common.config.SettingData;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.admin.board.dto.BoardPersonal;
import com.tx.dyAdmin.admin.board.service.PersonalfilterService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 개인정보필터 서비스
 */

@Service("PersonalfilterService")
public class PersonalfilterServiceImpl extends EgovAbstractServiceImpl implements PersonalfilterService{
	
	@Autowired ComponentService Component;
	
	public BoardPersonal PersonalfilterCheck(String BN_CONTENTS, String BT_PERSONAL) {
		
		boolean result = true;
		ArrayList<String> resultArray = new ArrayList<String>();
		if(StringUtils.isNotEmpty(BN_CONTENTS)) {
		for(String personal : BT_PERSONAL.split(",")) {
			boolean currentResult = checkFilter(personal.replaceAll("(^\\p{Z}+|\\p{Z}+$)", ""),resultArray,BN_CONTENTS);
			if(!currentResult) result = false;	//필터링된값이 있으면 false 리턴후 result 에 저장
		}}
		BoardPersonal BoardPersonal = new BoardPersonal();
		BoardPersonal.setResultBoolean(result);
		BoardPersonal.setResultArray(resultArray);
		
		return BoardPersonal;
		
	}

	private boolean checkFilter(String personal, ArrayList<String> resultArray,String BN_CONTENTS) {
		boolean result = true;
		String reg = "";
		switch (personal) {
		case SettingData.PERSONAL_SECURITY_JUMIN:
			reg = "(?:[0-9]{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[1,2][0-9]|3[0,1]))[.*|+|%|-|.\\s|.-]([1-4][0-9]{6})";
			break;
		case SettingData.PERSONAL_SECURITY_PHONE:
			reg = "01(?:0|1|[6-9])[.-|.*|.\\s|+|%|-]?(\\d{3}|\\d{4})[.-|.*|.\\s|+|%|-]?(\\d{4})";
			break;
		default:
			return true;
		}
		
		Pattern pattern = Pattern.compile(reg);
		Matcher matcher = pattern.matcher(BN_CONTENTS);
			while(matcher.find()) {			
				resultArray.add(matcher.group()+"\t");
				 result = false;
			
		}
		return result;
		
	} 
	
	

}
