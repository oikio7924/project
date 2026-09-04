package com.tx.test;

import java.io.BufferedReader;

import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;

import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;

import java.util.LinkedHashMap;

import java.util.List;


import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;


public class RestApiSample_getpkey {

	public static String Api(String strUrl, String jsonMessage) { // strUrl = 전송할 restapi 서버 url , jsonMessage = 전송할 데이터
																	// json형식을 String으로 형변환
		try {
			URL url = new URL(strUrl);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setConnectTimeout(10000); // 서버에 연결되는 Timeout 시간 설정
			con.setReadTimeout(10000); // InputStream 읽어 오는 Timeout 시간 설정

			con.setRequestProperty("Connection", "keep-alive");

			con.setRequestMethod("POST");

			// json으로 message를 전달하고자 할 때
			con.setRequestProperty("Content-Type", "application/json");
			con.setDoInput(true);
			con.setDoOutput(true); // POST 데이터를 OutputStream으로 넘겨 주겠다는 설정
			con.setUseCaches(false);
			con.setDefaultUseCaches(false);

			OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream(), "utf-8"); // 전송할때 한글깨짐현상으로 인한 utf-8
																							// 인코딩
			wr.write(jsonMessage); // json 형식의 message 전달
			wr.flush();
			// -----------전송 끝

			// 리턴받는 부분 시작
			StringBuilder sb = new StringBuilder();

			if (con.getResponseCode() == HttpURLConnection.HTTP_OK) {
				// Stream을 처리해줘야 하는 귀찮음이 있음.
				BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8")); // 리턴받을때
																												// 한글깨짐현상으로
																												// 인한
																												// utf-8
																												// 인코딩
				String line;
				while ((line = br.readLine()) != null) {
					sb.append(line).append("\n");
				}
				br.close();
				// System.out.println(sb);
				return sb.toString();
			} else {
				System.out.println(con.getResponseMessage());
				return "fail";
			}
		} catch (Exception e) {
			System.err.println(e.toString());
			return "fail";
		}
	}

	@SuppressWarnings("unchecked")
	public static void main(String[] args) throws Exception {

		// 입력할 세금계산서 정보를 배열에 추가(JSONObject객체와 순서가 일치해야함.)
		List<List<String>> taxinfo = new ArrayList<>();
		taxinfo.add(Arrays.asList("daeyang0715","hyungki933","daeyang0715NCoizZb5","dddd10002"));
		
		// JSONObject객체 생성
		JSONObject data = new JSONObject();
		
		// JSONObject객체에 세금계산서 정보를 추가
		data.put("hometaxbill_id", taxinfo.get(0).get(0));			// 회사코드
		data.put("spass", taxinfo.get(0).get(1));					// 패스워드
		data.put("apikey", taxinfo.get(0).get(2));					// 인증키
		data.put("homemunseo_id", taxinfo.get(0).get(3));			// 고유번호

		// 전자세금계산서 발행 후 리턴
		String restapi = Api("http://115.68.1.5:8084/homtax/getpkey", data.toString());

		if(restapi.equals("fail")) {
			System.out.println("http://115.68.1.5:8084/homtax/getpkey 서버에 문제가 발생했습니다.");
			return;
		}
		
		// Api에서 리턴받은 값으로 예외처리 및 출력
		JSONParser parser = new JSONParser();
		Object obj = parser.parse(restapi);
		JSONObject jsonObj = (JSONObject) obj;

		HashMap<String,String> Hlist = new LinkedHashMap<>();
		
		Hlist.put("code",(String) jsonObj.get("code"));
		Hlist.put("msg",(String) jsonObj.get("msg"));
		Hlist.put("msg2",(String) jsonObj.get("msg2"));
		Hlist.put("hometaxbill_id",(String) jsonObj.get("hometaxbill_id"));
		Hlist.put("homemunseo_id",(String) jsonObj.get("homemunseo_id"));
		Hlist.put("issueid",(String) jsonObj.get("issueid"));
		Hlist.put("declarestatus",(String) jsonObj.get("declarestatus"));
		
		
		if (!restapi.equals("fail")) {
			if (Hlist.get("issueid") != null) {
				for( String key : Hlist.keySet() ){
				    String value = Hlist.get(key);
				    System.out.println( String.format(key+" : "+value));
				}
			} else {
				System.out.println(
						"code : " + (String) jsonObj.get("code") + "\n" + "msg : " + (String) jsonObj.get("msg"));
			}
		}else {
			System.out.println(
					"code : -1" + "\n" + "msg : 서버호출에 실패했습니다.");			
		}
		

	}
	
}
