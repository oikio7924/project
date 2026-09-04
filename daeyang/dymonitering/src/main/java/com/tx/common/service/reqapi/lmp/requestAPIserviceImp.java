package com.tx.common.service.reqapi.lmp;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.impl.client.HttpClients;
import org.codehaus.jackson.map.ObjectMapper;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.springframework.stereotype.Service;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.tx.common.service.reqapi.requestAPIservice;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("requestAPIservice")
public class requestAPIserviceImp extends EgovAbstractServiceImpl implements requestAPIservice{
	
	//URL연결 
	public HttpURLConnection ConnenctURL(String urlString) throws Exception{
		
			URL url = new URL(urlString);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			
			return conn;
	}
	
	
	//토큰 받기
	public String TockenRecive(String apikey, String userid) throws Exception{
		
		String url = "https://kakaoapi.aligo.in/akv10/token/create/10/i/";
		
		HttpURLConnection con = ConnenctURL(url);
		
		con.setConnectTimeout(5000); //서버에 연결되는 Timeout 시간 설정
		con.setReadTimeout(5000); // InputStream 읽어 오는 Timeout 시간 설정
		
		con.setRequestMethod("POST");
		
		StringBuffer sb = new StringBuffer();
        sb.append("apikey").append("=").append(apikey).append("&");
        sb.append("userid").append("=").append(userid);
		
		con.setDoOutput(true); //POST 데이터를 OutputStream으로 넘겨 주겠다는 설정 

		OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
		wr.write(sb.toString()); 
		wr.flush();

		//응답
	    BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
	    JSONObject jsonObj = (JSONObject)JSONValue.parse(in.readLine());

	    System.out.println(jsonObj);
	    
	    String tocken = (String) jsonObj.get("token");
	    
	    wr.close();
	    in.close();
	    con.disconnect();
	    
		return tocken;
	}
	
	//템플릿 리스트
	public JSONObject KakaoAllimTalkList(String apikey, String userid,  String sendkey ,String token ) throws Exception{
		
		String url = "https://kakaoapi.aligo.in/akv10/template/list/";
		
		HttpURLConnection con = ConnenctURL(url);
		con.setDoOutput(true); 
		con.setRequestMethod("POST"); 
		con.setConnectTimeout(5000); //서버에 연결되는 Timeout 시간 설정
		con.setReadTimeout(5000); // InputStream 읽어 오는 Timeout 시간 설정
		
		StringBuffer sb = new StringBuffer();
        sb.append("apikey").append("=").append(apikey).append("&");
        sb.append("userid").append("=").append(userid).append("&");
        sb.append("token").append("=").append(token).append("&");
        sb.append("senderkey").append("=").append(sendkey);
		
        OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
        
		wr.write(sb.toString()); 
		wr.flush();

		//응답
	    BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
	    JSONObject jsonObj = (JSONObject)JSONValue.parse(in.readLine());

	    System.out.println(jsonObj);
	    
	    
	    wr.close();
	    in.close();
	    con.disconnect();
	    
		return jsonObj;
	}
	
	//알림톡 전송
	public void KakaoAllimTalkSend(String apikey, String userid,  String sendkey ,String token, JSONObject jsonObj, String contents,String phone,String Sendurl ) throws Exception{
		
		String json = "";
		JSONArray button = (JSONArray) jsonObj.get("buttons");
		if (button.size() > 0 ) {
			button = (JSONArray) jsonObj.get("buttons");
			
			JSONObject jsonObj_s = (JSONObject) button.get(0);
			
			HashMap<String,Object> buttonMain = new HashMap<String,Object>();
			
			JSONObject buttonInfo = new JSONObject();
			
			buttonInfo.put("name", jsonObj_s.get("name").toString());
			buttonInfo.put("linkType", jsonObj_s.get("linkType").toString());
			buttonInfo.put("linkTypeName", jsonObj_s.get("linkTypeName").toString());
			buttonInfo.put("linkM", Sendurl);
			buttonInfo.put("linkP", Sendurl);
			
			JSONArray buttonar = new JSONArray();
			buttonar.add(buttonInfo);
			
			buttonMain.put("button",buttonar);
			ObjectMapper mapper = new ObjectMapper(); 
			json = mapper.writeValueAsString(buttonMain);
		}
		
		
		
		String url = "https://kakaoapi.aligo.in/akv10/alimtalk/send/";
		
		HttpURLConnection con = ConnenctURL(url);
		con.setDoOutput(true); 
		con.setRequestMethod("POST"); 
		con.setConnectTimeout(5000); //서버에 연결되는 Timeout 시간 설정
		con.setReadTimeout(5000); // InputStream 읽어 오는 Timeout 시간 설정
		
		StringBuffer sb = new StringBuffer();
        sb.append("apikey").append("=").append(apikey).append("&");
        sb.append("userid").append("=").append(userid).append("&");
        sb.append("token").append("=").append(token).append("&");
        sb.append("senderkey").append("=").append(sendkey).append("&");
        sb.append("tpl_code").append("=").append(jsonObj.get("templtCode")).append("&");
        sb.append("sender").append("=").append("01098601540").append("&"); //발신자 내번호 고정
        sb.append("receiver_1").append("=").append(phone).append("&"); //수신자		
        sb.append("subject_1").append("=").append("알림").append("&"); //제목		
        sb.append("message_1").append("=").append(URLEncoder.encode(contents, "UTF-8")).append("&"); //내용		
        sb.append("button_1").append("=").append(json.toString()); //버튼	
        
        OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
		wr.write(sb.toString()); 
		wr.flush();

		//응답
	    BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
	    JSONObject jsonObjResult = (JSONObject)JSONValue.parse(in.readLine());

	    System.out.println(jsonObjResult);
	    
	    
	    wr.close();
	    in.close();
	    con.disconnect();
	    
	}
	
	public void sendMessage(String userid, String api, String destination, String receiver ,String msg, String image) throws Exception{
		try 
		{
			String sms_url = "https://apis.aligo.in/send/";
			Map<String, String> sms = new HashMap<String, String>();			
			
			sms.put("user_id", userid); // SMS 아이디
			sms.put("key", api); //인증키
			
			/******************** 전송정보 ********************/
			sms.put("msg", msg); // 메세지 내용
			sms.put("receiver", receiver); // 수신번호
			sms.put("destination", destination); // 수신인 %고객명% 치환
			sms.put("sender", ""); // 발신번호
			sms.put("rdate", ""); // 예약일자 - 20161004 : 2016-10-04일기준
			sms.put("rtime", ""); // 예약시간 - 1930 : 오후 7시30분
			sms.put("testmode_yn", "N"); // Y 인경우 실제문자 전송X , 자동취소(환불) 처리
			sms.put("title", ""); //  LMS, MMS 제목 (미입력시 본문중 44Byte 또는 엔터 구분자 첫라인)
			
			//image = "/tmp/pic_57f358af08cf7_sms_.jpg"; // MMS 이미지 파일 위치
			
			/******************** 전송정보 ********************/
	
			
			MultipartEntityBuilder builder = MultipartEntityBuilder.create();
			
			builder.setBoundary("____boundary____");
			builder.setMode(HttpMultipartMode.BROWSER_COMPATIBLE);
			builder.setCharset(Charset.forName("utf-8"));
			
			for(Iterator<String> i = sms.keySet().iterator(); i.hasNext();){
				String key = i.next();
				builder.addTextBody(key, sms.get(key)
						, ContentType.create("Multipart/related", "utf-8"));
			}
			
			File imageFile = new File(image);
			if(image!=null && image.length()>0 && imageFile.exists()){
		
				builder.addPart("image",
						new FileBody(imageFile, ContentType.create("application/octet-stream"),
								URLEncoder.encode(imageFile.getName(), "utf-8")));
			}
			
			HttpEntity entity = builder.build();
			
			HttpClient client = HttpClients.createDefault();
			HttpPost post = new HttpPost(sms_url);
			post.setEntity(entity);
			
			HttpResponse res = client.execute(post);
			
			String result = "";
			if(res != null){
				BufferedReader in = new BufferedReader(new InputStreamReader(res.getEntity().getContent(), "utf-8"));
				String buffer = null;
				while((buffer = in.readLine())!=null){
					result += buffer;
				}
				in.close();
			}
			
			System.out.println(result);
		
		}catch(Exception e){
			System.out.println(e.getMessage());
		}
	}
	
}
