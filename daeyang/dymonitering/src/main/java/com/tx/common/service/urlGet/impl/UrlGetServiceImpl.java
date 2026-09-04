package com.tx.common.service.urlGet.impl;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tx.common.service.component.ComponentService;
import com.tx.common.service.urlGet.UrlGetService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

;

/**
 * URL 정보 가져오기  서비스
 */

@Service("UrlGetService")
public class UrlGetServiceImpl extends EgovAbstractServiceImpl implements UrlGetService{
	
	@Autowired ComponentService Component;
	
	public boolean UrlGetNaver(String URL) throws IOException, ParseException {
		
		boolean result = false;
		

        URL url = new URL(URL);



        // 문자열로 URL 표현
        System.out.println("URL :" + url.toExternalForm());
        
        // HTTP Connection 구하기 
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        
        // 요청 방식 설정 ( GET or POST or .. 별도로 설정하지않으면 GET 방식 )
        conn.setRequestMethod("GET"); 
        
        
        // 연결 타임아웃 설정 
        conn.setConnectTimeout(3000); // 3초 
        // 읽기 타임아웃 설정 
        conn.setReadTimeout(3000); // 3초 
        
        // 요청 방식 구하기
        System.out.println("getRequestMethod():" + conn.getRequestMethod());
        // 응답 콘텐츠 유형 구하기
        System.out.println("getContentType():" + conn.getContentType());
        // 응답 코드 구하기
        System.out.println("getResponseCode():"    + conn.getResponseCode());
        // 응답 메시지 구하기
        System.out.println("getResponseMessage():" + conn.getResponseMessage());
        
        String resultType = "";
        // 응답 헤더의 정보를 모두 출력
       /* for (Map.Entry<String, List<String>> header : conn.getHeaderFields().entrySet()) {
        	
            for (String value : header.getValue()) {
                System.out.println(header.getKey() + " : " + value);
                if(header.getKey().equals("Content-Type")){
                	resultType = value;
                }
            }
        }*/
        
        
        
        // 응답 내용(BODY) 구하기        
        try (InputStream in = conn.getInputStream();
                ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            
            byte[] buf = new byte[1024 * 8];
            int length = 0;
            while ((length = in.read(buf)) != -1) {
                out.write(buf, 0, length);
            }
            String value = new String(out.toByteArray(), "UTF-8");
            System.out.println(new String(out.toByteArray(), "UTF-8"));            
            JSONParser parser = new JSONParser();
            Object obj = parser.parse(value);
            JSONObject jsonObj = (JSONObject)obj;
             resultType = (String)jsonObj.get("result");
            System.out.println(resultType);
        }
        
        // 접속 해제
        conn.disconnect();
    

        if(resultType.equals("success")) {
        	result = true;
        }
        		
        
		return result;
	}

	
	//카카오 
	@Override
	public boolean UrlGetKaKao(String URL, String Auth) throws IOException, ParseException {
		boolean result = false;
		

        URL url = new URL(URL);



        // 문자열로 URL 표현
        System.out.println("URL :" + url.toExternalForm());
        
        // HTTP Connection 구하기 
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        
        // 요청 방식 설정 ( GET or POST or .. 별도로 설정하지않으면 GET 방식 )
        conn.setRequestMethod("GET"); 
        
       /* conn.setRequestProperty("Authorization","");*/

   
        // 연결 타임아웃 설정 
        conn.setConnectTimeout(3000); // 3초 
        // 읽기 타임아웃 설정 
        conn.setReadTimeout(3000); // 3초 
        
        // 요청 방식 구하기
        System.out.println("getRequestMethod():" + conn.getRequestMethod());
        // 응답 콘텐츠 유형 구하기
        System.out.println("getContentType():" + conn.getContentType());
        // 응답 코드 구하기
        System.out.println("getResponseCode():"    + conn.getResponseCode());
        // 응답 메시지 구하기
        System.out.println("getResponseMessage():" + conn.getResponseMessage());
        
        String resultType = "";
        // 응답 헤더의 정보를 모두 출력
       /* for (Map.Entry<String, List<String>> header : conn.getHeaderFields().entrySet()) {
        	
            for (String value : header.getValue()) {
                System.out.println(header.getKey() + " : " + value);
                if(header.getKey().equals("Content-Type")){
                	resultType = value;
                }
            }
        }*/
        
        
        
        // 응답 내용(BODY) 구하기        
        try (InputStream in = conn.getInputStream();
                ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            
            byte[] buf = new byte[1024 * 8];
            int length = 0;
            while ((length = in.read(buf)) != -1) {
                out.write(buf, 0, length);
            }
            String value = new String(out.toByteArray(), "UTF-8");
            System.out.println(new String(out.toByteArray(), "UTF-8"));            
            JSONParser parser = new JSONParser();
            Object obj = parser.parse(value);
            JSONObject jsonObj = (JSONObject)obj;
             resultType = (String)jsonObj.get("result");
            System.out.println(resultType);
        }
        
        // 접속 해제
        conn.disconnect();
    

        if(resultType.equals("success")) {
        	result = true;
        }
		return result;
	}

	@Override
	public boolean UrlGetFaceBook(String URL) throws IOException, ParseException {
		// TODO Auto-generated method stub
		return false;
	}


	
	

}
