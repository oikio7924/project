package com.tx.dyAdmin.admin.site.dto;

import lombok.Data;

@Data
public class SiteManagerDTO  {

	private String  USERID
					,FILE_PATH
					,RESOURCE_PATH
					,JSP_PATH
					,FILE_EXT
					,DAUM_APPKEY
					,GOOGLE_APPKEY
					,NAVER_APPKEY
					,EMAIL_SENDER
					,EMAIL_SENDER_NAME
					,PAGE_UNIT
					,PAGE_SIZE 
					,HOMEPAGE_REP 
					,HOMEPAGE_NAME 
					,SNS_DESCRIPTION 
					,SNS_IMAGE 
					,SNS_IMAGE_WIDTH 
					,SNS_IMAGE_HEIGHT 
					,TOUR_START_LNG
					,TOUR_START_LAT
					,TOUR_START_TEXT
					,USER_DEL_POLICY
					,PASSWORD_CYCLE
					,PASSWORD_REGEX
					,SALT
					,SNSLOGIN_NAVER_CLIENT_ID
					,SNSLOGIN_NAVER_CALLBACK
					,SNSLOGIN_NAVER_CLIENT_SECRET
					,SNSLOGIN_KAKAO_JSKEY
					,SNSLOGIN_FACEBOOK_APPID
					,WEBFILE_PATH
					, tiles
					= null;
	
}