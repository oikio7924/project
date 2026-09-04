package com.tx.dyAdmin.member.dto;

import lombok.Data;

/**
 * 회원관리 설정 DTO
 * @author 이재령
 *
 */
@Data
public class UserSettingDTO  {
	
	private String US_TYPE
				   , US_UIA_KEYNO
				   , US_AUTH
				   , US_ID_FILTER
				   , US_INFO1
				   , US_INFO2
				   , US_APPLY
				   , US_REGEX = "";
}
