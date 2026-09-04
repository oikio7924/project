package com.tx.common.service.AsyncService.Impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.tx.common.config.SettingData;
import com.tx.common.service.AsyncService.AsyncService;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.reqapi.requestAPIservice;
import com.tx.common.service.tax.taxService;
import com.tx.test.controller.AsyncConfig;
import com.tx.test.dto.billDTO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("AsyncService")
public class AsyncServiceImpl extends EgovAbstractServiceImpl implements AsyncService {
	
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	@Autowired requestAPIservice requestAPI;
	@Autowired taxService taxService;
	
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
	
	@Override
	@SuppressWarnings("unchecked")
	@Async("threadPoolTaskExecutor")
	public String sendApi(billDTO bill , String tocken) throws Exception {
		
//		String[] list = {"첫번째","두번째","세번째"};
//		for(String l : list) {
//			System.out.println(l);
//			Thread.sleep(10000);
//		}
				
			 	String now = new SimpleDateFormat("yyyyMMdd").format(Calendar.getInstance().getTime());
			 	String nowdate = now.replace("-", "");
			 	String nowdate2 = nowdate.trim();
				
			
				// JSONObject객체 생성
				JSONObject data = new JSONObject();

				// JSONObject객체에 세금계산서 정보를 추가
				data.put("hometaxbill_id", bill.getDbp_id());				// 회사코드 (아이디) (사용자코드 1001 *
				data.put("spass", bill.getDbp_pass());									// 패스워드 *
				data.put("apikey", bill.getDbp_apikey() );								// 인증키*
				data.put("homemunseo_id",bill.getDbl_homeid());					// 고유번호*
				data.put("signature",bill.getSignature() );							// 전자서명
				
				data.put("issueid",bill.getDbl_issueid() );								// 승인번호(자동생성)
				data.put("typecode1",bill.getDbl_typecode1());							// (세금)계산서 종류1*
				data.put("typecode2",bill.getDbl_typecode2());							// (세금)계산서 종류2*
				data.put("description",bill.getDescription());						// 비고
				data.put("issuedate",nowdate2);										// 작성일자*
				
				data.put("modifytype",bill.getModifytype() );						// 수정사유-
				data.put("purposetype",bill.getDbl_purposetype());						// 영수/청구 구분*
				data.put("originalissueid",bill.getOriginalissueid());				// 당초전자(세금)계산서 승인번호-
				data.put("si_id",bill.getSi_id() );									// 수입신고번호-
				data.put("si_hcnt",bill.getDbl_si_hcnt());								// 수입총건 *
				
				data.put("si_startdt",bill.getSi_startdt() );						// 일괄발급시작일-
				data.put("si_enddt",bill.getSi_enddt() );							// 일괄발급종료일-
				data.put("ir_companynumber",bill.getDbp_co_num() );					// 공급자 사업자등록번호*
				data.put("ir_biztype",bill.getDbp_biztype());						// 공급자 업태*
				data.put("ir_companyname",bill.getDbp_name());						// 공급자 상호*
				
				data.put("ir_bizclassification",bill.getDbp_bizclassification() );	// 공급자 업종*
				data.put("ir_ceoname",bill.getDbp_ceoname());						// 공급자 대표자성명*
				data.put("ir_busename",bill.getDbp_busename());						// 공급자 담당부서명
				data.put("ir_name", bill.getDbp_ir_name());								// 공급자 담당자명*
				data.put("ir_cell", bill.getDbp_ir_cell());								// 공급자 담당자전화번호*
				
				data.put("ir_email",bill.getDbp_email());							// 공급자 담당자이메일*
				data.put("ir_companyaddress",bill.getDbp_address() );			// 공급자 주소*
				data.put("ie_companynumber", bill.getDbs_co_num());				// 공급받는자 사업자등록번호*
				data.put("ie_biztype",bill.getDbs_biztype());					// 공급받는자 업태*
				data.put("ie_companyname",bill.getDbs_name() );				// 공급받는자 사업체명*
					
				data.put("ie_bizclassification",bill.getDbs_bizclassification() );	// 공급받는자 업종*
				data.put("ie_taxnumber",bill.getDbs_taxnum() );					// 공급받는자 종사업장번호
				data.put("partytypecode",bill.getDbl_partytypecode() );					// 공급받는자 구분 01=사업자등록번호 02=주민등록번호 03=외국인*
				data.put("ie_ceoname",bill.getDbs_ceoname() );						// 공급받는자 대표자명*
				data.put("ie_busename1",bill.getDbs_busename1() );					// 공급받는자 담당부서1
				
				data.put("ie_name1",bill.getDbs_name1() );							// 공급받는자 담당자명1*
				data.put("ie_cell1",bill.getDbs_cell1() );							// 공급받는자 담당자연락처1*
				data.put("ie_email1",bill.getDbs_email1() );							// 공급받는자 담당자이메일1*
				data.put("ie_busename2",bill.getDbs_name2() );					// 공급받는자 담당부서2
				data.put("ie_name2",bill.getDbs_name2() );							// 공급받는자 담당자명2
				
				data.put("ie_cell2",bill.getDbs_cell2());							// 공급받는자 담당자연락처2
				data.put("ie_email2",bill.getDbs_email2() );							// 공급받는자 담당자이메일2
				data.put("ie_companyaddress",bill.getDbs_address() );			// 공급받는자 회사주소*
				data.put("su_companynumber","1858701989" );			// 수탁사업자 사업자등록번호- **
				data.put("su_biztype",bill.getSu_biztype() );						// 수탁사업자 업태-
				
				data.put("su_companyname","대양에스코 주식회사" );				// 수탁사업자 상호명- **
				data.put("su_bizclassification",bill.getSu_bizclassification() );	// 수탁사업자 업종-
				data.put("su_taxnumber",bill.getSu_taxnumber() );					// 수탁사업자 종사업장번호-
				data.put("su_ceoname","김형기" );						// 수탁사업자 대표자명- **
				data.put("su_busename",bill.getSu_busename() );						// 수탁사업자 담당부서명-
				
				data.put("su_name",bill.getSu_name() );								// 수탁사업자 담당자명-
				data.put("su_cell",bill.getSu_cell() );								// 수탁사업자 담당자전화번호-
				data.put("su_email",bill.getSu_email() );							// 수탁사업자 담당자이메일-
				data.put("su_companyaddress",bill.getSu_companyaddress() );			// 수탁사업자 회사주소-
				
				data.put("cash",bill.getDbl_cash().replace(",", ""));									// 현금*
				data.put("scheck",bill.getDbl_scheck().replace(",", ""));								// 수표*
				data.put("draft",bill.getDbl_draft().replace(",", ""));									// 어음*
				data.put("uncollected",bill.getDbl_uncollected().replace(",", ""));						// 외상 미수금*
				data.put("chargetotal",bill.getDbl_chargetotal().replace(",","")) ;						// 총 공급가액*
				data.put("taxtotal",bill.getDbl_taxtotal().replace(",", ""));							// 총 세액 *
				data.put("grandtotal",bill.getDbl_grandtotal().replace(",", ""));						// 총 금액*
				
				JSONArray jArray = new JSONArray();
				
					
				JSONObject sObject = new JSONObject();
				sObject.put("description", bill.getDescription() );							// 품목별 비고입력
				sObject.put("supplyprice",bill.getDbl_supplyprice().replace(",", ""));				// 품목별 공급가액
				sObject.put("quantity",bill.getDbl_quantity() );									// 품목수량
				sObject.put("unit",bill.getDbl_unit() );											// 품목규격
				sObject.put("subject",bill.getDbl_subject() );										// 품목명
				sObject.put("gyymmdd",nowdate2 );													// 공급연원일
				sObject.put("tax",bill.getDbl_tax().replace(",", ""));								// 세액
				sObject.put("unitprice",bill.getDbl_unitprice().replace(",", ""));					// 단가
				jArray.put(sObject);

				// 세금계산서 detail정보를 JSONObject객체에 추가
				data.put("taxdetailList", jArray);// 배열을 넣음
				
				// 전자세금계산서 발행 후 리턴
				String restapi = Api("https://www.hometaxbill.com:8084/homtax/post", data.toString());
//				String restapi = Api("http://115.68.1.5:8084/homtax/post", data.toString());
				
				if(restapi.equals("fail")) {
					System.out.println("https://www.hometaxbill.com:8084/homtax/post 서버에 문제가 발생했습니다.");
//					System.out.println("http://115.68.1.5:8084/homtax/post 서버에 문제가 발생했습니다.");
					return "서버문제장애";
				}
				
				// Api에서 리턴받은 값으로 예외처리 및 출력
				JSONParser parser = new JSONParser();
				Object obj = parser.parse(restapi);
				JSONObject jsonObj = (JSONObject) obj;
				String msg = "";
				if (!restapi.equals("fail")) {
					if (jsonObj.get("code").equals("0")) {
						System.out.println("code : " + (String) jsonObj.get("code") + "\n" + "msg : "
								+ (String) jsonObj.get("msg") + "\n" + "jsnumber : " + (String) jsonObj.get("jsnumber") + "\n"
								+ "hometaxbill_id : " + (String) jsonObj.get("hometaxbill_id") + "\n" + "homemunseo_id : "
								+ (String) jsonObj.get("homemunseo_id"));
							   msg = (String) jsonObj.get("msg");
					} else {
						System.out.println(
								"code : " + (String) jsonObj.get("code") + "\n" + "msg : " + (String) jsonObj.get("msg"));
								msg = (String) jsonObj.get("msg");
					}
				}else {
					System.out.println("code : -1" + "\n" + "msg : 서버호출에 실패했습니다.");
					msg = "서버호출에 실패했습니다.";
				}
				
				
				String  code = (String) jsonObj.get("code");
				bill.setDbl_status(code);
				bill.setDbl_errormsg(msg);
				bill.setDbl_issuedate(nowdate2);
				bill.setDbl_sub_issuedate(nowdate2);

				Component.updateData("bills.codemsgUpdate", bill);
				
				
				
				//카카오톡 전송 & 전송실패시 체크 풀기
				if(code.equals("0")) {
			    	String subkey = bill.getDbl_sub_keyno();
			    	if(subkey.equals("1")||subkey.equals("2")) {
			    		
			    			String pname = bill.getDbl_p_name();
			    			String sname = bill.getDbl_s_name();
			    			String subject = bill.getDbl_subject();
			    			String grandtotal = bill.getDbl_grandtotal();
			    			String issuedate = bill.getDbl_issuedate();
			    			String admin = "대양기업 이시연";
			    			String adminphone = "061-332-8086";

		
//			    			String contents = name+"(이)가 \n발전소 : "+map.get("DPP_NAME").toString()+"의 \n게시물 : "+title+" (를)을\n확인하였습니다.";
			    			String contents = "[세금계산서 발행 완료 안내]\n"
	    							+pname+"의 세금계산서 발행이 완료되었습니다.\n□ 공급자 : "+pname
	    							+"\n□ 공급받는자: "+sname
	    							+"\n□ 품목명 : "+subject
	    							+"\n□ 합계금액 : "+grandtotal+"원"
	    							+"\n□ 발행일 : "+issuedate+"\n\n\n※ 세금계산서 발행 관련 문의\n담당자 : "+admin+"\n연락처 : "+adminphone;

				    		
				    		//리스트 뽑기 - 현재 게시물 알림은 index=1
				    		JSONObject jsonObj2 = requestAPI.KakaoAllimTalkList(SettingData.Apikey,SettingData.Userid,SettingData.Senderkey,tocken);
				    		org.json.simple.JSONArray jsonObj_a = (org.json.simple.JSONArray) jsonObj2.get("list");
				    		jsonObj2 = (JSONObject) jsonObj_a.get(9); //템플릿 리스트
				    		
				    		String list = Component.getData("bills.AlimSelect",bill);
				    		String Sendurl  = "http://dymonitering.co.kr/"; 
				    		
				    		String phone = list.toString().replace("-", "");
				    			//받은 토큰으로 알림톡 전송		
				    			requestAPI.KakaoAllimTalkSend(SettingData.Apikey,SettingData.Userid,SettingData.Senderkey,tocken,jsonObj2,contents,phone,Sendurl);
				    		
				    		
				    	}else {
				    		
				    		String pname = bill.getDbl_p_name();
			    			String sname = bill.getDbl_s_name();
			    			String subject = bill.getDbl_subject();
			    			String grandtotal = bill.getDbl_grandtotal();
			    			String issuedate = bill.getDbl_issuedate();
			    			String admin = "대양기업 이시연";
			    			String adminphone = "061-332-8086";
				       		
				       		

//					    	String contents = name+"(이)가 \n발전소 : "+map.get("DPP_NAME").toString()+"의 \n게시물 : "+title+" (를)을\n확인하였습니다.";
			    			String contents = "[세금계산서 발행 완료 안내]\n"
	    							+sname+"의 세금계산서 발행이 완료되었습니다.\n□ 공급자 : "+pname
	    							+"\n□ 공급받는자: "+sname
	    							+"\n□ 품목명 : "+subject
	    							+"\n□ 합계금액 : "+grandtotal+"원"
	    							+"\n□ 발행일 : "+issuedate+"\n\n\n※ 세금계산서 발행 관련 문의\n담당자 : "+admin+"\n연락처 : "+adminphone;
						    		
						    		//리스트 뽑기 - 현재 게시물 알림은 index=1
						    		JSONObject jsonObj2 = requestAPI.KakaoAllimTalkList(SettingData.Apikey,SettingData.Userid,SettingData.Senderkey,tocken);
						    		org.json.simple.JSONArray jsonObj_a2 = (org.json.simple.JSONArray) jsonObj2.get("list");
						    		jsonObj2 = (JSONObject) jsonObj_a2.get(9); //템플릿 리스트
						    		
						    		String list = Component.getData("bills.AlimSelect2",bill);
						    		String Sendurl  = "http://dymonitering.co.kr/"; 
						    		
						    		String phone = list.toString().replace("-", "");
						    			//받은 토큰으로 알림톡 전송
						    			requestAPI.KakaoAllimTalkSend(SettingData.Apikey,SettingData.Userid,SettingData.Senderkey,tocken,jsonObj2,contents,phone,Sendurl);
				    	}
			    		
			    	}else {
			    		
			    		//전송상태 N으로 변경해서 체크박스 안사라지게 함
			    		Component.updateData("bills.checkChange", bill);
			    		
			    		
			    		// 전송실패시 고유번호 자동 +1 처리
//			    		String codeStr = "";
//			    		
//			    		String homekey = Component.getData("bills.homekey");
//			    		 
//			    		String codenum = homekey.substring(7,homekey.length());
//						int tempc = Integer.parseInt(codenum) + 1 ;
//						String homeKeyPront =  homekey.substring(0,7);
//						codeStr = homeKeyPront+tempc;
//						 
//						bill.setDbl_homeid(codeStr);
//						
//						Component.updateData("bills.homeIdUpdate_f", bill);
//						Component.updateData("bills.changeHomekey", codeStr);
			    	}
				return msg;
		}
	
	@Override
	@Async("threadPoolTaskExecutor")
	public void sendNTS(billDTO bill,
			@RequestParam(value="chkvalue")String dbl_keyno) throws Exception {
		
		String msg = "";
		String[] list = dbl_keyno.split(",");
	
		
		if(list.length == 0) {	
			msg = "전송할 세금계산서가 없습니다.";
		}else {
			for(int i= 0; i<list.length; i++) {
				
				//카카오톡 발급 토큰받기
				String tocken = requestAPI.TockenRecive(SettingData.Apikey,SettingData.Userid);
				tocken = URLEncoder.encode(tocken, "UTF-8");
				
				//전송 Y/N 체크
				Component.updateData("bills.checkYN", list[i]);
				
				bill = Component.getData("bills.selectAllView", list[i]);

				String subkey = bill.getDbl_sub_keyno();
				if(subkey.equals("1")){
					
					taxService.registIssue(bill, tocken);
					
				}else if(subkey.equals("2")){
					
					sendApi(bill, tocken);
					Thread.sleep(60000);
					
				}else {
					sendApi(bill, tocken);
				}
				
				
			}
		}
	}
	
	
	
	@Override
	@Async("threadPoolTaskExecutor")
	public void allSendNTS(billDTO bill, String subkey) throws Exception {
		
		String msg = "";
		List list = Component.getList("bills.AllsentNTS",subkey);		
		
		
		if(list.isEmpty()) {	
			msg = "전송할 세금계산서가 없습니다.";
		}else {
			for(Object l : list) {
				
				//카카오톡 발급 토큰받기
				String tocken = requestAPI.TockenRecive(SettingData.Apikey,SettingData.Userid);
				tocken = URLEncoder.encode(tocken, "UTF-8");
				
			
				//전송 Y/N 체크
				Component.updateData("bills.checkYN", l);
				bill = Component.getData("bills.selectAllView", l);
				
				if(subkey.equals("1")){
					taxService.registIssue(bill, tocken);
//						System.out.println("하나보냄");
//						Thread.sleep(60000);
				}else if(subkey.equals("2")){
					sendApi(bill, tocken);
//						System.out.println("하나보냄");
					Thread.sleep(60000);
				}else {
					sendApi(bill, tocken);
				}	
			}
			msg = "전체 전송이 완료되었습니다.";	
		}
		

	}
		
}
