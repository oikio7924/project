package com.tx.SafeAdmin;

import java.io.BufferedReader;

import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;

import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.json.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;


public class RestApiSample_post {

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
				// 한글깨짐현상으로인한 utf-8 인코딩
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

	/**
	 * @param args
	 * @throws ParseException
	 */
	@SuppressWarnings("unchecked")
	public static void main(String[] args) throws ParseException {
        // 인증서를 업로드 >> api 데이터로 넘기고 인증서 통해서 
		// 입력할 세금계산서 정보를 배열에 추가(JSONObject객체와 순서가 일치해야함.)
		List<List<String>> taxinfo = new ArrayList<>();

		taxinfo.add(Arrays.asList("daeesco0715", "qwer4321", "daeesco0715hP3zeUiI", "dae3", "", "", "01", "01",
				"", "20220418", "", "02", "", "", "0", "", "", "1858701989", "서비스업", "대양에스코 주식회사", "전기안전관리대행", "김형기", "",
				"이시연", "01093338988", "dy3246@dycompany.co.kr", "전라남도 나주시 봉황면 운곡용곡길 16", "5102016079", "전기업", "한성수산태양광발전소", "태양광발전업", "",
				"01", "신아령", "", "신아령", "01089887516", "hansung@han.com", "", "", "", "", "충청남도 서천군 장항읍 장마로 257-9", "", "",
				"", "", "", "", "", "", "", "", "", "0", "0", "0", "0", "50000", "5000", "55000"));

		// JSONObject객체 생성
		JSONObject data = new JSONObject();

		// JSONObject객체에 세금계산서 정보를 추가
		data.put("hometaxbill_id", taxinfo.get(0).get(0));			// 회사코드 (아이디) (사용자코드 1001 *
		data.put("spass", taxinfo.get(0).get(1));					// 패스워드 *
		data.put("apikey", taxinfo.get(0).get(2));					// 인증키*
		data.put("homemunseo_id", taxinfo.get(0).get(3));			// 고유번호*
		data.put("signature", taxinfo.get(0).get(4));				// 전자서명
		
		data.put("issueid", taxinfo.get(0).get(5));					// 승인번호(자동생성)
		data.put("typecode1", taxinfo.get(0).get(6));				// (세금)계산서 종류1*
		data.put("typecode2", taxinfo.get(0).get(7));				// (세금)계산서 종류2*
		data.put("description", taxinfo.get(0).get(8));				// 비고
		data.put("issuedate", taxinfo.get(0).get(9));				// 작성일자*
		
		data.put("modifytype", taxinfo.get(0).get(10));				// 수정사유
		data.put("purposetype", taxinfo.get(0).get(11));			// 영수/청구 구분*
		data.put("originalissueid", taxinfo.get(0).get(12));		// 당초전자(세금)계산서 승인번호
		data.put("si_id", taxinfo.get(0).get(13));					// 수입신고번호
		data.put("si_hcnt", taxinfo.get(0).get(14));				// 수입총건 *
		
		data.put("si_startdt", taxinfo.get(0).get(15));				// 일괄발급시작일
		data.put("si_enddt", taxinfo.get(0).get(16));				// 일괄발급종료일
		data.put("ir_companynumber", taxinfo.get(0).get(17));		// 공급자 사업자등록번호*
		data.put("ir_biztype", taxinfo.get(0).get(18));				// 공급자 업태*
		data.put("ir_companyname", taxinfo.get(0).get(19));			// 공급자 상호*
		
		data.put("ir_bizclassification", taxinfo.get(0).get(20));	// 공급자 업종*
		data.put("ir_ceoname", taxinfo.get(0).get(21));				// 공급자 대표자성명*
		data.put("ir_busename", taxinfo.get(0).get(22));			// 공급자 담당부서명
		data.put("ir_name", taxinfo.get(0).get(23));				// 공급자 담당자명*
		data.put("ir_cell", taxinfo.get(0).get(24));				// 공급자 담당자전화번호*
		
		data.put("ir_email", taxinfo.get(0).get(25));				// 공급자 담당자이메일*
		data.put("ir_companyaddress", taxinfo.get(0).get(26));		// 공급자 주소*
		data.put("ie_companynumber", taxinfo.get(0).get(27));		// 공급받는자 사업자등록번호*
		data.put("ie_biztype", taxinfo.get(0).get(28));				// 공급받는자 업태*
		data.put("ie_companyname", taxinfo.get(0).get(29));			// 공급받는자 사업체명*
		
		data.put("ie_bizclassification", taxinfo.get(0).get(30));	// 공급받는자 업종*
		data.put("ie_taxnumber", taxinfo.get(0).get(31));			// 공급받는자 종사업장번호
		data.put("partytypecode", taxinfo.get(0).get(32));			// 공급받는자 구분 01=사업자등록번호 02=주민등록번호 03=외국인*
		data.put("ie_ceoname", taxinfo.get(0).get(33));				// 공급받는자 대표자명*
		data.put("ie_busename1", taxinfo.get(0).get(34));			// 공급받는자 담당부서1
		
		data.put("ie_name1", taxinfo.get(0).get(35));				// 공급받는자 담당자명1*
		data.put("ie_cell1", taxinfo.get(0).get(36));				// 공급받는자 담당자연락처1*
		data.put("ie_email1", taxinfo.get(0).get(37));				// 공급받는자 담당자이메일1*
		data.put("ie_busename2", taxinfo.get(0).get(38));			// 공급받는자 담당부서2
		data.put("ie_name2", taxinfo.get(0).get(39));				// 공급받는자 담당자명2
		
		data.put("ie_cell2", taxinfo.get(0).get(40));				// 공급받는자 담당자연락처2
		data.put("ie_email2", taxinfo.get(0).get(41));				// 공급받는자 담당자이메일2
		data.put("ie_companyaddress", taxinfo.get(0).get(42));		// 공급받는자 회사주소*
		data.put("su_companynumber", taxinfo.get(0).get(43));		// 수탁사업자 사업자등록번호
		data.put("su_biztype", taxinfo.get(0).get(44));				// 수탁사업자 업태
		
		data.put("su_companyname", taxinfo.get(0).get(45));			// 수탁사업자 상호명
		data.put("su_bizclassification", taxinfo.get(0).get(46));	// 수탁사업자 업종
		data.put("su_taxnumber", taxinfo.get(0).get(47));			// 수탁사업자 종사업장번호
		data.put("su_ceoname", taxinfo.get(0).get(48));				// 수탁사업자 대표자명
		data.put("su_busename", taxinfo.get(0).get(49));			// 수탁사업자 담당부서명
		
		data.put("su_name", taxinfo.get(0).get(50));				// 수탁사업자 담당자명
		data.put("su_cell", taxinfo.get(0).get(51));				// 수탁사업자 담당자전화번호
		data.put("su_email", taxinfo.get(0).get(52));				// 수탁사업자 담당자이메일
		data.put("su_companyaddress", taxinfo.get(0).get(53));		// 수탁사업자 회사주소
		
		data.put("cash", taxinfo.get(0).get(54));					// 현금*
		data.put("scheck", taxinfo.get(0).get(55));					// 수표*
		data.put("draft", taxinfo.get(0).get(56));					// 어음*
		data.put("uncollected", taxinfo.get(0).get(57));			// 외상 미수금*
		data.put("chargetotal", taxinfo.get(0).get(58));			// 총 공급가액*
		data.put("taxtotal", taxinfo.get(0).get(59));				// 총 세액 *
		data.put("grandtotal", taxinfo.get(0).get(60));				// 총 금액*

		// 세금계산서 detail정보 생성.(입력할 detail정보개수만큼 for문 활성화)
		JSONArray jArray = new JSONArray();
		List<List<String>> detail = new ArrayList<>();
		for (int i = 0; i < 1; i++) {
			detail.add(Arrays.asList("", "50000", "", "", "2022년 04월분 전기안전관리비", "20220418", "5000", "55000"));
			JSONObject sObject = new JSONObject();
			sObject.put("description", detail.get(i).get(0));		// 품목별 비고입력
			sObject.put("supplyprice", detail.get(i).get(1));		// 품목별 공급가액
			sObject.put("quantity", detail.get(i).get(2));			// 품목수량
			sObject.put("unit", detail.get(i).get(3));				// 품목규격
			sObject.put("subject", detail.get(i).get(4));			// 품목명
			sObject.put("gyymmdd", detail.get(i).get(5));			// 공급연원일
			sObject.put("tax", detail.get(i).get(6));				// 세액
			sObject.put("unitprice", detail.get(i).get(7));			// 단가
			jArray.put(sObject);
		}

		// 세금계산서 detail정보를 JSONObject객체에 추가
		data.put("taxdetailList", jArray);// 배열을 넣음

		// 전자세금계산서 발행 후 리턴
		String restapi = Api("http://115.68.1.5:8084/homtax/post", data.toString());
		
		if(restapi.equals("fail")) {
			System.out.println("http://115.68.1.5:8084/homtax/post 서버에 문제가 발생했습니다.");
			return;
		}
		
		// Api에서 리턴받은 값으로 예외처리 및 출력
		JSONParser parser = new JSONParser();
		Object obj = parser.parse(restapi);
		JSONObject jsonObj = (JSONObject) obj;

		if (!restapi.equals("fail")) {
			if (jsonObj.get("code").equals("0")) {
				System.out.println("code : " + (String) jsonObj.get("code") + "\n" + "msg : "
						+ (String) jsonObj.get("msg") + "\n" + "jsnumber : " + (String) jsonObj.get("jsnumber") + "\n"
						+ "hometaxbill_id : " + (String) jsonObj.get("hometaxbill_id") + "\n" + "homemunseo_id : "
						+ (String) jsonObj.get("homemunseo_id"));
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
