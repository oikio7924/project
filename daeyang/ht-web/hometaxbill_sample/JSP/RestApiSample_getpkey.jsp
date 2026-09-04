<%@ page contentType="text/html;charset=UTF-8" language="java"
	import="com.sinit.hometaxbill.RestApiSample_getpkey"
	import="org.json.simple.parser.JSONParser" import="java.util.ArrayList"
	import="java.util.Arrays" import="java.util.List"
	import="org.json.simple.JSONObject" import="java.util.HashMap"
	import="java.util.LinkedHashMap" import="java.io.BufferedReader"
	import="java.io.InputStreamReader" import="java.io.OutputStreamWriter"
	import="java.net.HttpURLConnection" import="java.net.URL"%>

<%!public static String Api(String strUrl, String jsonMessage) { // strUrl = 전송할 restapi 서버 url , jsonMessage = 전송할 데이터
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
			
			//api서버 통신체크 200 = 정상
			if (con.getResponseCode() == 200) {
				// Stream을 처리해줘야 하는 귀찮음이 있음.
				BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));  // 리턴받을때 한글깨짐현상으로 인한 utf-8 인코딩
				String line;
				while ((line = br.readLine()) != null) {
					sb.append(line).append("\n");
				}
				br.close();
				// System.out.println(sb);
				return sb.toString();
			} else {
				return "fail";
			}
		} catch (Exception e) {
			return "fail";
		}
	}%>

<%
// 입력할 세금계산서 정보를 배열에 추가(JSONObject객체와 순서가 일치해야함.)
List<List<String>> taxinfo = new ArrayList<List<String>>();
taxinfo.add(Arrays.asList("cmj0633", "Mem12345", "SSADFVSDFSDE", "ccal20223655660040"));

// JSONObject객체 생성
JSONObject data = new JSONObject();

// JSONObject객체에 세금계산서 정보를 추가
data.put("hometaxbill_id", taxinfo.get(0).get(0)); 		// 회사코드
data.put("spass", taxinfo.get(0).get(1)); 				// 패스워드
data.put("apikey", taxinfo.get(0).get(2)); 				// 인증키
data.put("homemunseo_id", taxinfo.get(0).get(3)); 		// 고유번호

String restapi = Api("http://115.68.1.5:8084/homtax/getpkey", data.toString());
//String restapi = Api("http://115.68.1.5:8084/homtax/getpkeyAll", data.toString()); //세금계산서 전체항목 RETURN시 사용

if (restapi.equals("fail")) {
%>
http://115.68.1.5:8084/homtax/getpkey 서버에 문제가 발생했습니다.
<%
return;
}

//Api에서 리턴받은 값으로 예외처리 및 출력
JSONParser parser = new JSONParser();
Object obj =   parser.parse(restapi);
JSONObject jsonObj = (JSONObject) obj;

%> 

<!-- 전체항목 RETURN --> 
<%=jsonObj%><br><br>

<%="code : " + jsonObj.get("code") %><br>							<!--결과코드-->	                    
<%="msg : " + jsonObj.get("msg") %><br>								<!--결과메세지-->
<%="hometaxbill_id : " + jsonObj.get("hometaxbill_id") %><br>		<!--회사코드-->
<%="homemunseo_id : " + jsonObj.get("homemunseo_id") %><br>			<!--업체고유번호-->
<%="issueid : " + jsonObj.get("issueid") %><br>						<!--승인번호-->
<%="declarestatus : " + jsonObj.get("declarestatus") %><br>			<!--세금계산서 발행상태-->
<%="msg2 : " + jsonObj.get("msg2") %><br>							<!--세금계산서 발행상태 내용-->


<%
/*
결과 리턴값($ret)

code			:	결과코드
msg				:	결과메세지
hometaxbill_id	:	회사코드
homemunseo_id	:	업체고유번호
homemunseo_id	:	승인번호
declarestatus	:	세금계산서 발행상태 
msg2			:	세금계산서 발행상태 내용 

declarestatus = 세금계산서 발행상태 및 진행상황을  판단 하십시오 (API문서의 상태값입니다).
 01 =	(수기작성)                  사용회사정보 수동일 경우 전송하기 전 상태(전송 미처리시 국세청 전송불가)
 10 =	(전송대기) 	              국세청 전송 대기 상태(10분 이내 자동전송 처리 예정)
 03 =	(국세청 전송처리중)	          국세청으로 세금계산서 데이터 전송처리 진행중인 상태
 04 =	(국세청 전송완료.결과수신대기)   국세청으로 세금계산서 데이터를 전송하고 결과 수신 대기인 상태
 05 =	(홈택스빌 처리중 Error)       국세청 전송하기 전 작업처리중에 에러가 발생한 상태(재전송 처리예정)
 06 =	(국세청 전송중 Error)  	  		국세청 데이터 전송중 에러가 발생한 상태(재전송 처리예정)
 08 =	(발급완료)          	      국세청으로부터 정상적으로 승인처리된 상태
 09 =	(발급실패)  	              국세청으로부터 전자세금계산서 발급 승인이 나지 않는 상태
 99 =	(인증서 검증 Error)          인증서 유효기간이 지나거나 폐기 처리된 인증서로 인증서에 문제가 발생한 상태

 EX1)  declarestatus = '08' 라면 code 에는 성공한 CODE가 return되고 msg 에는 정상처리 return
 EX2)  declarestatus = '09' 라면 code 에는 실패이유 CODE가retrun되고 msg 에는 실패 사유를 RETURN합니다.

 */
 %>