package com.tx.common.service.schedule;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.tx.common.config.SettingData;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.reqapi.requestAPIservice;
import com.tx.dyAdmin.member.dto.UserDTO;
import com.tx.dyUser.wether.WetherService;
import com.tx.test.dto.billDTO;


@Service("ScheduleService")
public class ScheduleService {

	//** 공통 컴포넌트 *//*
	@Autowired
	ComponentService Component;
	//** 알림톡 API *//*
	@Autowired
	requestAPIservice requestAPI;
	


	//날씨 데이터 매시 57분마다 
	//@Scheduled(cron="0 58 * * * ?")
	public void test() throws Exception{
       WetherService w = new WetherService();
		
	   String[] regionL = {"나주","광주","해남","화성","세종","영암","김제","곡성","남원","음성","진천","부산","부안","안성","포천"};
	   
	   Component.deleteData("Weather.Daily_WeatherDelete");
	   
	   for (String r : regionL) {
		   ArrayList<String> list = w.Daily_Wether(r);
		   list.addAll(w.Sunrise_setData(r));
		   
		   WeatherOrganize(list);
	   }
    }

	//10분 마다 연결체크 
	@Scheduled(cron="* 10 7-19 * * ?")
	public void Internet_Conn() throws Exception{
	   List<String> list = Component.getListNoParam("sub.Conect_Status_sel");
	   //System.out.println(list);
	   if(list.size() > 0) {
		   for(String l : list) {
			   //i -> keyno
			   Component.updateData("sub.con_main_update", l);
			   Component.updateData("sub.con_sub_update", l);
			   
		   }
	   }
	}
	
	// 매시간 40분에 inverter값 들어오는지 체크
	//@Scheduled(cron="0 40 8-17 * * 1-5")
	public void TimeDataInputCheck() throws Exception {
		List<HashMap<String,Object>> list = Component.getListNoParam("main.DataInputCheck");
		
		//토큰받기
		String tocken = requestAPI.TockenRecive(SettingData.Apikey,SettingData.Userid);
		tocken = URLEncoder.encode(tocken, "UTF-8");
		
		for(HashMap<String,Object> l : list) {
			String ch = l.get("checked").toString();
			if(ch.equals("N")) { 
				
				SimpleDateFormat sdf = new SimpleDateFormat("HH시 mm분");
				Calendar c1 = Calendar.getInstance(); 
				
				String today = sdf.format(c1.getTime());
				String dpName = l.get("DPP_NAME").toString();
				String inverter = "인버터";  
				String warn = "통신";
				
				String Contents = "현재 "+dpName+"의 "+inverter+"에서 "+today+"에 "+warn+"에 대한 에러가 발생했습니다."; 
		    	
				//리스트 뽑기 - 현재 게시물 알림은 index=1
				JSONObject jsonObj = requestAPI.KakaoAllimTalkList(SettingData.Apikey,SettingData.Userid,SettingData.Senderkey,tocken);
				org.json.simple.JSONArray jsonObj_a = (org.json.simple.JSONArray) jsonObj.get("list");
				jsonObj = (JSONObject) jsonObj_a.get(2); //발전소 게시물 확인

		    	
		    	//전송할 회원 리스트 - 관리자만
		    	String [] ls = {"010-9860-1540"};
				
				for(String ll : ls) {
					
		    		String phone = ll.replace("-", "");
		    		String url = "http://dymonitering.co.kr/";
		    		//받은 토큰으로 알림톡 전송
		    		requestAPI.KakaoAllimTalkSend(SettingData.Apikey,SettingData.Userid,SettingData.Senderkey,tocken,jsonObj,Contents,phone,url);
		    	}
			}
		}
	}
	
	//오전 8시 30분에 통신 체크 한번
	//@Scheduled(cron="0 0 9 * * ?")
	public void InverterDataSend() throws Exception {
		List<HashMap<String,Object>> list = Component.getListNoParam("main.PowerConCheck");
		
		for(HashMap<String,Object> l : list) {
			String ch = l.get("checking").toString();
			if(ch.equals("N")) { //오늘날짜 데이터가 들어오지않음
				//알림전송하면됌
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); 
				Calendar c1 = Calendar.getInstance(); 
				
				String today = sdf.format(c1.getTime());
				String dpName = l.get("DPP_NAME").toString();
				String Contents = "현재 "+dpName+"의 인버터에서 "+today+"에 통신에 대한 에러가 발생했습니다."; 
				
				int cnt = 2; //
				
				//토큰받기
				String tocken = requestAPI.TockenRecive(SettingData.Apikey,SettingData.Userid);
				tocken = URLEncoder.encode(tocken, "UTF-8");
		    	
				//리스트 뽑기 - 현재 게시물 알림은 index=1
				JSONObject jsonObj = requestAPI.KakaoAllimTalkList(SettingData.Apikey,SettingData.Userid,SettingData.Senderkey,tocken);
				org.json.simple.JSONArray jsonObj_a = (org.json.simple.JSONArray) jsonObj.get("list");
				jsonObj = (JSONObject) jsonObj_a.get(cnt); //발전소 게시물 확인

		    	
		    	//전송할 회원 리스트 - 관리자만
		    	List<UserDTO> ls = Component.getListNoParam("main.NotUserData_Admin");
				
				for(UserDTO ll : ls) {
					ll.decode();
		    		String phone = "010-9860-1540";
		    		String url = "http://dymonitering.co.kr/";
		    		//받은 토큰으로 알림톡 전송		
		    		requestAPI.KakaoAllimTalkSend(SettingData.Apikey,SettingData.Userid,SettingData.Senderkey,tocken,jsonObj,Contents,phone,url);
		    	}
			}
		}
	}
	
	
	
	//21시30분에 데이터 합치기   
	@Scheduled(cron="0 30 21 * * ?")
	public void scheduleTest() throws Exception {
		
		try {
			List<HashMap<String,Object>> list = Component.getListNoParam("main.selectPower");
			
			for(HashMap<String,Object> l : list) {
				String keyno = l.get("DPP_KEYNO").toString();
				Component.deleteData("main.deleteMain", keyno);
				// dy_inverter_data 당일 정리: main.recent_date(LIMIT 100·20:30 등) 대신 sub2와 동일하게 DI_NAME별 최신만 유지
				cleanupInverterDataByDay(keyno, 0);
			}
		}catch (Exception e) {
			System.out.println(e);
		}
		
	}

	//21시에 데이터 추가   
	@Scheduled(cron="0 0 21 * * ?")
	public void Insertforpredict() throws Exception {
		
	   String[] keylist = {"23","31","33","40"};
		
		for(String k : keylist) {
			List<HashMap<String, Object>> list = Component.getList("main.selectHourData", k);
			Component.getData("main.insertHourData",list);
		}
	}

	
	//시간별 데이터 추출 세달 전까지만 수집
	@Scheduled(cron="0 30 20 * * ?")
	public void InsertDetail() throws Exception {
		try {
			List<HashMap<String,Object>> list = Component.getListNoParam("main.selectPower");
			
			for(HashMap<String,Object> l : list) {	
				String keyno = l.get("DPP_KEYNO").toString();
				List<HashMap<String, Object>> datas = Component.getList("sub.10minutes_Data", keyno);
				
				// 1단계: dy_inverter_data에서 dy_detail_data로 데이터 복사
				if(datas.size() > 0) {			
					Component.getData("sub.insert_10minutes_Detail",datas); //InverterData DetailData로 Insert
				}
				
				// 2단계: 10년 넘은 데이터 삭제 (detail_data는 날·인버터별 최신 1건만 유지)
				Component.deleteData("sub.10minutes_Delete", keyno); // detail_data
				Component.deleteData("sub2.deleteOver2Years", keyno); // inverter_data
				Component.deleteData("sub2.deleteMainOver2Years", keyno); // inverter_data_main
				
				// 3단계: detail_data로 복사 완료 후, 당일 inverter_data에서 인버터별 최신값만 남기고 나머지 삭제
				// ttest.do와 동일한 로직 사용 (당일만 처리)
				cleanupInverterDataByDay(keyno, 0);
			}
		} catch (Exception e) {
			System.out.println(e);
		}
		

	}
	
	//매일 22시에 중복 데이터 삭제
	@Scheduled(cron="0 0 22 * * ?")
	public void deleteDuplicateData() throws Exception {
		try {
			List<HashMap<String,Object>> list = Component.getListNoParam("main.selectPower");
			
			for(HashMap<String,Object> l : list) {
				String keyno = l.get("DPP_KEYNO").toString();
				
				// 2개 테이블의 중복 데이터 삭제 (dy_detail_data는 중복삭제 안 함 - inverter_data 상태 그대로 복사되므로)
				Component.deleteData("sub2.deleteDuplicateInverterData", keyno); // dy_inverter_data
				Component.deleteData("sub2.deleteDuplicateMainData", keyno); // dy_inverter_data_main
				
				System.out.println("중복 데이터 삭제 완료 - 발전소: " + keyno);
			}
		} catch (Exception e) {
			System.out.println("중복 데이터 삭제 중 에러 발생: " + e.getMessage());
			e.printStackTrace();
		}
	}
	
	/**
	 * dy_inverter_data에서 특정 날짜의 인버터별 최신값만 남기고 나머지 삭제
	 * ttest.do와 동일한 로직 (day=0이면 당일, day=1이면 어제 등)
	 */
	private void cleanupInverterDataByDay(String dpKeyno, int day) {
		try {
			if(dpKeyno == null || dpKeyno.isEmpty()) {
				return;
			}
			
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("day", day);
			map.put("keyno", dpKeyno);
			
			// 인버터별 최신 날짜 조회
			List<String> slist = Component.getList("sub2.recent_date", map);
			
			// 최신값이 아닌 데이터 삭제
			if(slist != null && slist.size() > 0) {
				map.put("list", slist);
				Component.deleteData("sub2.deleteToday", map);
			}
		} catch (Exception e) {
			// 에러 발생 시 메인 프로세스는 계속 진행
			System.out.println("인버터 데이터 정리 중 에러 발생 (day=" + day + "): " + e.getMessage());
		}
	}
	
	@Scheduled(cron="0 */15 * * * ?")
	public void error_Main_Update() throws Exception {
		
		try {
			// 최적화: 모든 발전소를 한 번에 조회 (144개 쿼리 → 1개 쿼리)
			List<String> faultKeynoList = Component.getListNoParam("main.select_fault_keyno_all");
			
			if(faultKeynoList != null && faultKeynoList.size() > 0) {
				for(String error_Keyno : faultKeynoList) {
					Component.updateData("main.update_maindb_fault", error_Keyno);
				}
				System.out.println("[스케줄러] 장애 발전소 업데이트: " + faultKeynoList.size() + "개");
			}
		} catch (Exception e) {
			System.err.println("[스케줄러 오류] 장애 체크 실패: " + e.getMessage());
			e.printStackTrace();
		}
	}
	
	
	
	//오후 7시에 국세청 전송
	@Scheduled(cron="0 0 19 * * ?")
	public void senddelay() throws Exception {
	  
	  billDTO bill = new billDTO();
	  
	  List<HashMap<String,Object>> list = Component.getListNoParam("bills.status2select");
	  
	  if (list != null ) {
		  for(HashMap<String,Object> l : list) {
			     
	    	  String keyno = l.get("dbl_keyno").toString();
	 
	    	  Component.updateData("bills.checkYN", keyno);
	 
	    	  bill = Component.getData("bills.selectAllView", keyno);
	     
	     sendApi(bill);
		  }
	  }
	}
	   
	   
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
	   

	   @SuppressWarnings("unchecked")
	   public String sendApi( billDTO bill)
	         throws Exception {
	       // JSONObject객체 생성
		   JSONObject data = new JSONObject();
	
		   // JSONObject객체에 세금계산서 정보를 추가
		   data.put("hometaxbill_id", bill.getDbp_id());            // 회사코드 (아이디) (사용자코드 1001 *
		   data.put("spass", bill.getDbp_pass());                           // 패스워드 *
		   data.put("apikey", bill.getDbp_apikey() );                        // 인증키*
		 data.put("homemunseo_id",bill.getDbl_homeid());               // 고유번호*
		 data.put("signature",bill.getSignature() );                     // 전자서명
		 
		 data.put("issueid",bill.getDbl_issueid() );                        // 승인번호(자동생성)
		 data.put("typecode1",bill.getDbl_typecode1());                     // (세금)계산서 종류1*
		 data.put("typecode2",bill.getDbl_typecode2());                     // (세금)계산서 종류2*
		 data.put("description",bill.getDescription());                  // 비고
		 data.put("issuedate",bill.getDbl_issuedate());                     // 작성일자*
		 
		 data.put("modifytype",bill.getModifytype() );                  // 수정사유-
		 data.put("purposetype",bill.getDbl_purposetype());                  // 영수/청구 구분*
		 data.put("originalissueid",bill.getOriginalissueid());            // 당초전자(세금)계산서 승인번호-
		 data.put("si_id",bill.getSi_id() );                           // 수입신고번호-
		 data.put("si_hcnt",bill.getDbl_si_hcnt());                        // 수입총건 *
		 
		 data.put("si_startdt",bill.getSi_startdt() );                  // 일괄발급시작일-
		 data.put("si_enddt",bill.getSi_enddt() );                     // 일괄발급종료일-
		 data.put("ir_companynumber",bill.getDbp_co_num() );               // 공급자 사업자등록번호*
		 data.put("ir_biztype",bill.getDbp_biztype());                  // 공급자 업태*
		 data.put("ir_companyname",bill.getDbp_name());                  // 공급자 상호*
		 
		 data.put("ir_bizclassification",bill.getDbp_bizclassification() );   // 공급자 업종*
		 data.put("ir_ceoname",bill.getDbp_ceoname());                  // 공급자 대표자성명*
		 data.put("ir_busename",bill.getDbp_busename());                  // 공급자 담당부서명
		 data.put("ir_name", bill.getDbp_ir_name());                        // 공급자 담당자명*
		 data.put("ir_cell", bill.getDbp_ir_cell());                        // 공급자 담당자전화번호*
		 
		 data.put("ir_email",bill.getDbp_email());                     // 공급자 담당자이메일*
		 data.put("ir_companyaddress",bill.getDbp_address() );         // 공급자 주소*
		 data.put("ie_companynumber", bill.getDbs_co_num());            // 공급받는자 사업자등록번호*
		 data.put("ie_biztype",bill.getDbs_biztype());               // 공급받는자 업태*
		 data.put("ie_companyname",bill.getDbs_name() );            // 공급받는자 사업체명*
		    
		 data.put("ie_bizclassification",bill.getDbs_bizclassification() );   // 공급받는자 업종*
		 data.put("ie_taxnumber",bill.getDbs_taxnum() );               // 공급받는자 종사업장번호
		 data.put("partytypecode",bill.getDbl_partytypecode() );               // 공급받는자 구분 01=사업자등록번호 02=주민등록번호 03=외국인*
		 data.put("ie_ceoname",bill.getDbs_ceoname() );                  // 공급받는자 대표자명*
		 data.put("ie_busename1",bill.getDbs_busename1() );               // 공급받는자 담당부서1
		 
		 data.put("ie_name1",bill.getDbs_name1() );                     // 공급받는자 담당자명1*
		 data.put("ie_cell1",bill.getDbs_cell1() );                     // 공급받는자 담당자연락처1*
		 data.put("ie_email1",bill.getDbs_email1() );                     // 공급받는자 담당자이메일1*
		 data.put("ie_busename2",bill.getDbs_name2() );               // 공급받는자 담당부서2
		 data.put("ie_name2",bill.getDbs_name2() );                     // 공급받는자 담당자명2
		 
		 data.put("ie_cell2",bill.getDbs_cell2());                     // 공급받는자 담당자연락처2
		 data.put("ie_email2",bill.getDbs_email2() );                     // 공급받는자 담당자이메일2
		 data.put("ie_companyaddress",bill.getDbs_address() );         // 공급받는자 회사주소*
		 data.put("su_companynumber",bill.getSu_companynumber() );         // 수탁사업자 사업자등록번호-
		 data.put("su_biztype",bill.getSu_biztype() );                  // 수탁사업자 업태-
		 
		 data.put("su_companyname",bill.getSu_companyname() );            // 수탁사업자 상호명-
		 data.put("su_bizclassification",bill.getSu_bizclassification() );   // 수탁사업자 업종-
		 data.put("su_taxnumber",bill.getSu_taxnumber() );               // 수탁사업자 종사업장번호-
		 data.put("su_ceoname",bill.getSu_ceoname() );                  // 수탁사업자 대표자명-
		 data.put("su_busename",bill.getSu_busename() );                  // 수탁사업자 담당부서명-
		 
		 data.put("su_name",bill.getSu_name() );                        // 수탁사업자 담당자명-
		 data.put("su_cell",bill.getSu_cell() );                        // 수탁사업자 담당자전화번호-
		 data.put("su_email",bill.getSu_email() );                     // 수탁사업자 담당자이메일-
		 data.put("su_companyaddress",bill.getSu_companyaddress() );         // 수탁사업자 회사주소-
		 
		 data.put("cash",bill.getDbl_cash().replace(",", ""));                           // 현금*
		 data.put("scheck",bill.getDbl_scheck().replace(",", ""));                        // 수표*
		 data.put("draft",bill.getDbl_draft().replace(",", ""));                           // 어음*
		 data.put("uncollected",bill.getDbl_uncollected().replace(",", ""));                  // 외상 미수금*
		 data.put("chargetotal",bill.getDbl_chargetotal().replace(",","")) ;                  // 총 공급가액*
		 data.put("taxtotal",bill.getDbl_taxtotal().replace(",", ""));                     // 총 세액 *
		 data.put("grandtotal",bill.getDbl_grandtotal().replace(",", ""));                  // 총 금액*
		 
		 JSONArray jArray = new JSONArray();
		 
		    
		 JSONObject sObject = new JSONObject();
		 sObject.put("description", bill.getDescription() );                     // 품목별 비고입력
		 sObject.put("supplyprice",bill.getDbl_supplyprice().replace(",", ""));            // 품목별 공급가액
		 sObject.put("quantity",bill.getDbl_quantity() );                           // 품목수량
		 sObject.put("unit",bill.getDbl_unit() );                                 // 품목규격
		 sObject.put("subject",bill.getDbl_subject() );                              // 품목명
		 sObject.put("gyymmdd",bill.getDbl_sub_issuedate() );                     // 공급연원일
		 sObject.put("tax",bill.getDbl_tax().replace(",", ""));                        // 세액
		 sObject.put("unitprice",bill.getDbl_unitprice().replace(",", ""));               // 단가
		 jArray.put(sObject);
		
		 // 세금계산서 detail정보를 JSONObject객체에 추가
		 data.put("taxdetailList", jArray);// 배열을 넣음
		
		 System.out.println(data);
		 
		 // 전자세금계산서 발행 후 리턴
		 String restapi = Api("https://www.hometaxbill.com:8084/homtax/post", data.toString());
//		 String restapi = Api("http://115.68.1.5:8084/homtax/post", data.toString());
		 
		 if(restapi.equals("fail")) {
			 System.out.println("https://www.hometaxbill.com:8084/homtax/post 서버에 문제가 발생했습니다.");
//			 System.out.println("http://115.68.1.5:8084/homtax/post 서버에 문제가 발생했습니다.");
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
			 }else {
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
		
		   
			   //String contents = name+"(이)가 \n발전소 : "+map.get("DPP_NAME").toString()+"의 \n게시물 : "+title+" (를)을\n확인하였습니다.";
			   String contents = "[세금계산서 발행 완료 안내]\n"
					   +pname+"의 세금계산서 발행이 완료되었습니다.\n□ 공급자 : "+pname
					   +"\n□ 공급받는자: "+sname
					   +"\n□ 품목명 : "+subject
					   +"\n□ 합계금액 : "+grandtotal+"원"
					   +"\n□ 발행일 : "+issuedate+"\n\n\n※ 세금계산서 발행 관련 문의\n담당자 : "+admin+"\n연락처 : "+adminphone;
		
		   //	토큰받기
			   String tocken = requestAPI.TockenRecive(SettingData.Apikey,SettingData.Userid);
			   tocken = URLEncoder.encode(tocken, "UTF-8");
		   
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
		  
		  
		
		   //String contents = name+"(이)가 \n발전소 : "+map.get("DPP_NAME").toString()+"의 \n게시물 : "+title+" (를)을\n확인하였습니다.";
		   String contents = "[세금계산서 발행 완료 안내]\n"
				   +sname+"의 세금계산서 발행이 완료되었습니다.\n□ 공급자 : "+pname
				   +"\n□ 공급받는자: "+sname
				   +"\n□ 품목명 : "+subject
				   +"\n□ 합계금액 : "+grandtotal+"원"
				   +"\n□ 발행일 : "+issuedate+"\n\n\n※ 세금계산서 발행 관련 문의\n담당자 : "+admin+"\n연락처 : "+adminphone;
		 
			 //토큰받기
			 String tocken = requestAPI.TockenRecive(SettingData.Apikey,SettingData.Userid);
			 tocken = URLEncoder.encode(tocken, "UTF-8");
			 
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
			 Component.updateData("bills.checkChange", bill);
	     }
         return msg;
	   }
	   
	
   public void WeatherOrganize(ArrayList<String> weatherList) {
	   //혹시모를 갯수 체크
	   int count = Integer.parseInt(weatherList.get(weatherList.size()-4));
	   
	   for(int i=0;i<count;i++) {
		   HashMap<String,Object> map = new HashMap<String,Object>();
		   //시간 0
		   map.put("date",weatherList.get(i).toString());
		   //날씨 0+5 * 1
		   map.put("weather",weatherList.get(i+count*1).toString());
		   //강수 0+5 * 2
		   map.put("rn1",weatherList.get(i+count*2).toString());
		   //강수 0+5 * 3
		   map.put("sky",weatherList.get(i+count*3).toString());
		   //온도 0+5 * 4
		   map.put("t1h",weatherList.get(i+count*4).toString());
		   //온도 0+5 * 5
		   map.put("reh",weatherList.get(i+count*5).toString());
		   //온도 0+5 * 6
		   map.put("wsd",weatherList.get(i+count*6).toString());
		   //지역
		   map.put("region",weatherList.get((weatherList.size()-3)).toString());
		   //일출
		   map.put("sunrise",weatherList.get((weatherList.size()-2)).toString());
		   //일몰
		   map.put("sunset",weatherList.get((weatherList.size()-1)).toString());
		   
		   Component.createData("Weather.Daily_WeatherData", map);
	  }

   	//에러 체크 알림 10시에 몰아서 한번
//  	@Scheduled(cron="0 0 10 * * ?")  
// 	public void ErrorDataSend() throws Exception {
// 		List<HashMap<String,Object>> list = Component.getListNoParam("main.PowerConCheck");
// 		
// 		for(HashMap<String,Object> l : list) {
// 			String ch = l.get("checking").toString();
// 			if(ch.equals("N")) { //오늘날짜 데이터가 들어오지않음
// 				//알림전송하면됌
// 				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); 
// 				Calendar c1 = Calendar.getInstance(); 
// 				
// 				String today = sdf.format(c1.getTime());
// 				String dpName = l.get("DPP_NAME").toString();
// 				String Contents = "현재 "+dpName+"의 인버터에서 "+today+"에 통신에 대한 에러가 발생했습니다."; 
// 				
// 				int cnt = 2; //
// 				
// 				//토큰받기
// 				String tocken = requestAPI.TockenRecive(SettingData.Apikey,SettingData.Userid);
// 				tocken = URLEncoder.encode(tocken, "UTF-8");
// 		    	
// 				//리스트 뽑기 - 현재 게시물 알림은 index=1
// 				JSONObject jsonObj = requestAPI.KakaoAllimTalkList(SettingData.Apikey,SettingData.Userid,SettingData.Senderkey,tocken);
// 				JSONArray jsonObj_a = (JSONArray) jsonObj.get("list");
// 				jsonObj = (JSONObject) jsonObj_a.get(cnt); //발전소 게시물 확인
//
// 		    	
// 		    	//전송할 회원 리스트 - 관리자만
// 		    	List<UserDTO> ls = Component.getListNoParam("main.NotUserData_Admin");
// 				
// 				for(UserDTO ll : ls) {
// 					ll.decode();
// 		    		String phone = ll.getUI_PHONE().toString().replace("-", "");
// 		    		String url = "http://dymonitering.co.kr/";
// 		    		//받은 토큰으로 알림톡 전송		
// 		    		requestAPI.KakaoAllimTalkSend(SettingData.Apikey,SettingData.Userid,SettingData.Senderkey,tocken,jsonObj,Contents,phone,url);
// 		    	}
// 			}
// 		}
// 	}
  }
}