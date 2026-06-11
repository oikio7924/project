package com.tx.common.service.member.validator;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

import org.springframework.beans.factory.annotation.Autowired;

import com.tx.common.config.annotation.IdDupleChk;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.member.dto.UserDTO;

public class IdDupleChkValidator implements ConstraintValidator<IdDupleChk, String> {

	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	
	@Override
	public void initialize(IdDupleChk constraintAnnotation) {
		// TODO Auto-generated method stub
	}
	
	@Override
	public boolean isValid(String value, ConstraintValidatorContext context) {
		// TODO Auto-generated method stub
		return !isIdDupleChk(value);
	}
	
	private boolean isIdDupleChk(String value) {
		UserDTO UserDTO = new UserDTO();
		UserDTO.setUI_ID(value);
		int result = Component.getCount("member.UI_checkId", UserDTO);
		
		return (result == 1) ? true : false;
	}
	
}
