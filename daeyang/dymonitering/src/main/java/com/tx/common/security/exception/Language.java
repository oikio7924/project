package com.tx.common.security.exception;

import com.tx.common.config.SettingData;

public class Language {
	
	public static String getExceptionMessage(int type){
    	String message = "";
    	switch (SettingData.HOMEPAGE_LANGUAGE) {
    	case "en":
			if(type == 0) {
				message = "The ID is locked for a period of time due to a password accumulation error.";
			}else if(type == 1){
				message = "ID does not exist or password does not match. If the password does not match more than 5 times, the ID will be locked for 30 minutes.";
			}else if(type == 2){
				message = "ID does not exist or password does not match.  If the password does not match more than 5 times, the ID will be locked for 30 minutes.";
			}else if(type == 3){
				message = "Incomplete certification";
			}else if(type == 4){
				message = "You do not have permission. Please contact your administrator.";
			}else if(type == 5){
				message = "The ID you left.";
	    	}else if(type == 6){
	    		message = "My ID will be plated for 30 minutes because I have misplaced my password five times in a row.";
	    	}else if(type == 7){
	    		message = "The number of concurrent users of the ID has been exceeded. Please terminate your existing connection.";
	    	}else if(type == 8){
	    		message = "Y";
	    	}else if(type == 9){
	    		message = "DORMANCY";
	    	}
			
			break;

		default:
			if(type == 0) {
				message = "해당 아이디는 비밀번호 누적 오류로 일정시간 잠겨있습니다.";
			}else if(type == 1){
				message = "아이디가 존재하지 않거나 비밀번호가 맞지 않습니다.";
			}else if(type == 2){
				message = "아이디가 존재하지 않거나 비밀번호가 맞지 않습니다.";
			}else if(type == 3){
				message = "인증 미완료";
			}else if(type == 4){
				message = "권한이 없습니다. 관리자한테 문의하세요.";
			}else if(type == 5){
				message = "탈퇴한 아이디입니다.";
			}else if(type == 6){
	    		message = "비밀번호를 5회 연속 틀리셔서 30분동안 아이디가 잠금처리 됩니다.";
	    	}else if(type == 7){
	    		message = "해당 아이디의 동시접속자수가 초과되었습니다. 기존 접속을 종료하여주세요.";
	    	}else if(type == 8){
	    		message = "Y";
	    	}else if(type == 9){
	    		message = "DORMANCY";
	    	}
			
			
			break;
		}
    	
    	
    	return message;
    }
	
}
