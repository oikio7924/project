package com.tx.dyAdmin.member.dto;

import java.io.Serializable;
import java.util.regex.Matcher;

import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.validator.constraints.Email;
import org.hibernate.validator.constraints.NotEmpty;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;

import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.IdDupleChk;

import lombok.Data;

@Data
@Component
public class JoinReqUserDTO implements Serializable {
	
	private static final long serialVersionUID = -3793808669767332434L;
	
	// U_USERINFO 테이블
	private String  UI_KEYNO;
	@NotEmpty
	@Size(min=4, max=16)
	@IdDupleChk
	@Pattern(regexp=SettingData.ID_REGEX)
	private String	UI_ID;
	@NotEmpty
	private String	UI_PASSWORD;

	@NotEmpty
	@Size(min=2, max=20)
	private String	UI_NAME;

	
	/**
	 * 커맨드 객체 검증(validate)
	 * @param 에러 바인딩 객체, 타일즈, 정규식 규칙 
	 **/
	public void checkEtcValid(Errors bindingResult, UserSettingDTO setting, String regex) {
		
		if(chkProhibitValue(setting, this.UI_ID)) {
			bindingResult.rejectValue("UI_ID", "id.prohibit", "사용할 수 없는 아이디 입니다.");
		}
		
		if(!chkPatternValue(regex, this.UI_PASSWORD)) {
			bindingResult.rejectValue("UI_PASSWORD", "password.mismatch", "비밀번호 형식이 잘못되었습니다.");
		}
		
		if(chkProhibitValue(setting, this.UI_NAME)) {
			bindingResult.rejectValue("UI_NAME", "name.prohibit", "사용할 수 없는 이름 입니다.");
		}
		
		
	}
	
	/**
	 * 입력받은 값 금지단어 체크
	 * @param 타일즈, 검증값
	 * @return 금지단어 true, 사용가능 false 
	 **/
	private boolean chkProhibitValue(UserSettingDTO setting, String value) {
		
		//금지단어 체크
		if( setting !=null && StringUtils.isNotEmpty(setting.getUS_ID_FILTER()) ) {
			if( StringUtils.isNotEmpty(value) ){
				String val = value;
				for(String f : setting.getUS_ID_FILTER().split(",")){
					if(val.contains(f)){
						return true;
					}
				}
			}
		}
		return false;
	}
	
	/**
	 * 입력받은 값 패턴 체크
	 * @param 정규식 규칙, 검증값
	 * @return 패턴일치 true, 패턴불일치 false 
	 **/
	private boolean chkPatternValue(String regex, String value) {
		return regexCheck(regex, value);
	}
	
	/**
	 * 정규식 검증
	 * */
	private boolean regexCheck(String regex, String parameter) {
		java.util.regex.Pattern pattern = java.util.regex.Pattern.compile(regex);
		Matcher matcher = pattern.matcher(parameter);
		return matcher.matches();
	}
	
}
