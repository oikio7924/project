package com.tx.common.service.reqapi;

import org.json.simple.JSONObject;

public interface requestAPIservice {
	
	//토큰 생성
	public String TockenRecive(String apikey, String userid) throws Exception;
	
	//알림톡 리스트
	public JSONObject KakaoAllimTalkList(String apikey, String userid,  String sendkey ,String token ) throws Exception;
	
	//알림톡 전송
	public void KakaoAllimTalkSend(String apikey, String userid,  String sendkey ,String token, JSONObject jsonObj, String contents,String phone,String Sendurl ) throws Exception;
	
	//문자 전송
	public void sendMessage(String userid, String api, String destination, String receiver ,String msg, String image) throws Exception;
}
