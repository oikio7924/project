<%@ page contentType="text/html;charset=UTF-8" language="java"
	import="com.sinit.hometaxbill.RestApiSample_getpkey"
	import="org.json.simple.parser.JSONParser" import="java.util.ArrayList"
	import="java.util.Arrays" import="java.util.List"
	import="org.json.simple.JSONObject" import="java.util.HashMap"
	import="java.util.LinkedHashMap" import="java.io.BufferedReader"
	import="java.io.InputStreamReader" import="java.io.OutputStreamWriter"
	import="java.net.HttpURLConnection" import="java.net.URL"
	import="org.json.JSONArray"%>

<%!public static String Api(String strUrl, String jsonMessage) { // strUrl = 전송할 restapi 서버 url , jsonMessage = 전송할 데이터
		// json형식을 String으로 형변환
		try {
			URL url = new URL(strUrl);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			// 서버에 연결되는 Timeout 시간 설정
			con.setConnectTimeout(10000);
			// InputStream 읽어 오는 Timeout 시간 설정
			con.setReadTimeout(10000); 

			con.setRequestProperty("Connection", "keep-alive");

			con.setRequestMethod("POST");

			// json으로 message를 전달하고자 할 때
			con.setRequestProperty("Content-Type", "application/json");
			con.setDoInput(true);
			// POST 데이터를 OutputStream으로 넘겨 주겠다는 설정
			con.setDoOutput(true); 
			con.setUseCaches(false);
			con.setDefaultUseCaches(false);

			// 전송할때 한글깨짐현상으로 인한 utf-8 인코딩
			OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream(), "utf-8"); 
			// json 형식의 message 전달
			wr.write(jsonMessage); 
			wr.flush();
			// -----------전송 끝

			// 리턴받는 부분 시작
			StringBuilder sb = new StringBuilder();

			if (con.getResponseCode() == HttpURLConnection.HTTP_OK) {
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
taxinfo.add(Arrays.asList("cmj0633", "Mem12345", "SSADFVSDFSDE", "ccal20214831550010031", "", "", "01", "01", "",
		"20210819", "", "02", "", "", "0", "", "", "1358187511", "서비스업", "홈택스빌", "소프트웨어개발", "홍길동", "", "업체담당자",
		"01033334444", "irabc@sinit.co.kr", "경기도 수원시 영통구", "44455666666", "판매업", "오케이뱅크", "서비스업", "", "01", "이나영", "",
		"공급담당자", "01011112222", "ieabc@sinit.co.kr", "", "", "", "", "서울시 금천구 가산디지털로", "", "", "", "", "", "", "", "",
		"", "", "", "2200", "0", "0", "0", "2000", "200", "2200"));

// JSONObject객체 생성
JSONObject data = new JSONObject();

// JSONObject객체에 세금계산서 정보를 추가
// JSONObject객체에 세금계산서 정보를 추가
data.put("hometaxbill_id", taxinfo.get(0).get(0)); 			// 회사코드
data.put("spass", taxinfo.get(0).get(1)); 					// 패스워드
data.put("apikey", taxinfo.get(0).get(2)); 					// 인증키
data.put("homemunseo_id", taxinfo.get(0).get(3)); 			// 고유번호
data.put("signature", taxinfo.get(0).get(4)); 				// 전자서명
data.put("issueid", taxinfo.get(0).get(5)); 				// 승인번호(자동생성)
data.put("typecode1", taxinfo.get(0).get(6)); 				// (세금)계산서 종류1
data.put("typecode2", taxinfo.get(0).get(7)); 				// (세금)계산서 종류2
data.put("description", taxinfo.get(0).get(8)); 			// 비고
data.put("issuedate", taxinfo.get(0).get(9)); 				// 작성일자
data.put("modifytype", taxinfo.get(0).get(10)); 			// 수정사유
data.put("purposetype", taxinfo.get(0).get(11)); 			// 영수/청구 구분
data.put("originalissueid", taxinfo.get(0).get(12)); 		// 당초전자(세금)계산서 승인번호
data.put("si_id", taxinfo.get(0).get(13)); 					// 수입신고번호
data.put("si_hcnt", taxinfo.get(0).get(14)); 				// 수입총건
data.put("si_startdt", taxinfo.get(0).get(15)); 			// 일괄발급시작일
data.put("si_enddt", taxinfo.get(0).get(16)); 				// 일괄발급종료일
data.put("ir_companynumber", taxinfo.get(0).get(17)); 		// 공급자 사업자등록번호
data.put("ir_biztype", taxinfo.get(0).get(18)); 			// 공급자 업태
data.put("ir_companyname", taxinfo.get(0).get(19)); 		// 공급자 상호
data.put("ir_bizclassification", taxinfo.get(0).get(20)); 	// 공급자 업종
data.put("ir_ceoname", taxinfo.get(0).get(21)); 			// 공급자 대표자성명
data.put("ir_busename", taxinfo.get(0).get(22)); 			// 공급자 담당부서명
data.put("ir_name", taxinfo.get(0).get(23)); 				// 공급자 담당자명
data.put("ir_cell", taxinfo.get(0).get(24)); 				// 공급자 담당자전화번호
data.put("ir_email", taxinfo.get(0).get(25)); 				// 공급자 담당자이메일
data.put("ir_companyaddress", taxinfo.get(0).get(26)); 		// 공급자 주소
data.put("ie_companynumber", taxinfo.get(0).get(27)); 		// 공급받는자 사업자등록번호
data.put("ie_biztype", taxinfo.get(0).get(28)); 			// 공급받는자 업태
data.put("ie_companyname", taxinfo.get(0).get(29)); 		// 공급받는자 사업체명
data.put("ie_bizclassification", taxinfo.get(0).get(30)); 	// 공급받는자 업종
data.put("ie_taxnumber", taxinfo.get(0).get(31)); 			// 공급받는자 종사업장번호
data.put("partytypecode", taxinfo.get(0).get(32)); 			// 공급받는자 구분 01=사업자등록번호 02=주민등록번호 03=외국인
data.put("ie_ceoname", taxinfo.get(0).get(33)); 			// 공급받는자 대표자명
data.put("ie_busename1", taxinfo.get(0).get(34)); 			// 공급받는자 담당부서1
data.put("ie_name1", taxinfo.get(0).get(35)); 				// 공급받는자 담당자명1
data.put("ie_cell1", taxinfo.get(0).get(36)); 				// 공급받는자 담당자연락처1
data.put("ie_email1", taxinfo.get(0).get(37)); 				// 공급받는자 담당자이메일1
data.put("ie_busename2", taxinfo.get(0).get(38)); 			// 공급받는자 담당부서2
data.put("ie_name2", taxinfo.get(0).get(39)); 				// 공급받는자 담당자명2
data.put("ie_cell2", taxinfo.get(0).get(40)); 				// 공급받는자 담당자연락처2
data.put("ie_email2", taxinfo.get(0).get(41)); 				// 공급받는자 담당자이메일2
data.put("ie_companyaddress", taxinfo.get(0).get(42)); 		// 공급받는자 회사주소
data.put("su_companynumber", taxinfo.get(0).get(43)); 		// 수탁사업자 사업자등록번호
data.put("su_biztype", taxinfo.get(0).get(44)); 			// 수탁사업자 업태
data.put("su_companyname", taxinfo.get(0).get(45)); 		// 수탁사업자 상호명
data.put("su_bizclassification", taxinfo.get(0).get(46)); 	// 수탁사업자 업종
data.put("su_taxnumber", taxinfo.get(0).get(47)); 			// 수탁사업자 종사업장번호
data.put("su_ceoname", taxinfo.get(0).get(48)); 			// 수탁사업자 대표자명
data.put("su_busename", taxinfo.get(0).get(49)); 			// 수탁사업자 담당부서명
data.put("su_name", taxinfo.get(0).get(50)); 				// 수탁사업자 담당자명
data.put("su_cell", taxinfo.get(0).get(51)); 				// 수탁사업자 담당자전화번호
data.put("su_email", taxinfo.get(0).get(52)); 				// 수탁사업자 담당자이메일
data.put("su_companyaddress", taxinfo.get(0).get(53)); 		// 수탁사업자 회사주소
data.put("cash", taxinfo.get(0).get(54)); 					// 현금
data.put("scheck", taxinfo.get(0).get(55)); 				// 수표
data.put("draft", taxinfo.get(0).get(56)); 					// 어음
data.put("uncollected", taxinfo.get(0).get(57)); 			// 외상 미수금
data.put("chargetotal", taxinfo.get(0).get(58)); 			// 총 공급가액
data.put("taxtotal", taxinfo.get(0).get(59)); 				// 총 세액 
data.put("grandtotal", taxinfo.get(0).get(60)); 			// 총 금액

// 세금계산서 detail정보 생성.(입력할 detail정보개수만큼 for문 활성화)
JSONArray jArray = new JSONArray();
List<List<String>> detail = new ArrayList<List<String>>();
for (int i = 0; i < 4; i++) {
	detail.add(Arrays.asList("품목별비고입력", "500", "1", "", "품목", "20010501", "50", "0"));
	JSONObject sObject = new JSONObject();
	sObject.put("description", detail.get(i).get(0)); 		// 품목별 비고입력
	sObject.put("supplyprice", detail.get(i).get(1)); 		// 품목별 공급가액
	sObject.put("quantity", detail.get(i).get(2)); 			// 품목수량
	sObject.put("unit", detail.get(i).get(3)); 				// 품목규격
	sObject.put("subject", detail.get(i).get(4)); 			// 품목명
	sObject.put("gyymmdd", detail.get(i).get(5)); 			// 공급연원일
	sObject.put("tax", detail.get(i).get(6)); 				// 세액
	sObject.put("unitprice", detail.get(i).get(7)); 		// 단가
	jArray.put(sObject);
}

// 세금계산서 detail정보를 JSONObject객체에 추가
data.put("taxdetailList", jArray);// 배열을 넣음

//해당 주소로 data전송
String restapi = Api("http://115.68.1.5:8084/homtax/postAll", data.toString());
//String restapi = Api("http://115.68.1.5:8084/homtax/postAll", data.toString()); //post 값 전체를 return받을시 사용.

if (restapi.equals("fail")) {
	%>
	http://115.68.1.5:8084/homtax/post 서버에 문제가 발생했습니다.
	<%
	return;
}
//Api에서 리턴받은 값으로 예외처리 및 출력
JSONParser parser = new JSONParser();
Object obj = obj = parser.parse(restapi);
JSONObject jsonObj = (JSONObject) obj;

%>

<!-- 전체항목 RETURN --> 
<%=jsonObj%><br><br>

<%if (jsonObj.get("code").equals("0")) { %>
	<%="code : " + jsonObj.get("code") %><br>	             		<!--결과코드-->       
	<%="msg : " + jsonObj.get("msg") %>	<br>						<!--결과메세지-->
	<%="jsnumber : " + jsonObj.get("jsnumber") %><br>				<!--접수번호-->
	<%="hometaxbill_id : " + jsonObj.get("hometaxbill_id") %><br>	<!--회사코드-->
	<%="homemunseo_id : " + jsonObj.get("homemunseo_id") %><br>		<!--업체고유번호-->
<%}else{ %>
	<%="code : " + jsonObj.get("code") %><br>	                    <!--결과코드--> 
	<%="msg : " + jsonObj.get("msg") %>	<br>						<!--결과메세지-->
<%} %>

