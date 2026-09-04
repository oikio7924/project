package com.tx.common.config.validate;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class CommonValidate{

	public boolean isEmptyOrWhitespace(String value){
		if(value==null || value.trim().length() == 0){
			return true;
		}else{
			return false;
		}
	}
	
	public boolean checkEmail(String email){
		String regex = "^[_a-zA-Z0-9-\\.]+@[\\.a-zA-Z0-9-]+\\.[a-zA-Z]+$";
		return checkRegex(email,regex);
	}

	public boolean checkBirth(String value){
		String regex = "^(19[3-9][0-9]|20\\d{2})-(0[0-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$";
		return checkRegex(value,regex);
	}
	
	private boolean checkRegex(String value, String reg){
		String regex = reg;
		Pattern p = Pattern.compile(regex);
		Matcher m = p.matcher(value);
		boolean isNormal = true;
		if(value==null || value.trim().length() == 0){
			isNormal = false;		  		  
		}else{
		    isNormal = m.matches();		  		  
		}
		return isNormal;
	}

}
