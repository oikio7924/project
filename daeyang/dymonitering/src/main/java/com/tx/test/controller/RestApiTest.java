package com.tx.test.controller;


import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.popbill.api.JoinForm;
import com.tx.common.config.SettingData;
import com.tx.common.dto.Common;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.excel.ExcelService;
import com.tx.common.service.mailExcel.MailAndExcelDownService;
import com.tx.common.service.page.PageAccess;
import com.tx.common.service.reqapi.requestAPIservice;
import com.tx.common.service.weakness.WeaknessService;
import com.tx.common.service.AsyncService.AsyncService;
import com.tx.dyAdmin.admin.code.service.CodeService;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

import com.tx.test.RestApiSample_getpkey;
import com.tx.test.dto.billDTO;
import com.tx.common.service.tax.taxService;


@Controller
public class RestApiTest {

	
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 페이지 처리 출 */
	@Autowired private PageAccess PageAccess;
	
	@Autowired WeaknessService WeaknessService;
	
	@Autowired CodeService CodeService;
	
	@Autowired requestAPIservice requestAPI;
	
	@Autowired AsyncService AsyncService;

	@Autowired taxService taxService;
	
	@Autowired MailAndExcelDownService emailExcel;
	
	@Autowired ExcelService excel;
	
	@RequestMapping("/dyAdmin/bills/billsproducer.do")
	public ModelAndView billsproducer(HttpServletRequest req) throws Exception {
	ModelAndView mv = new ModelAndView("/dyAdmin/bill/pra_bills_producer_insertView.adm");
	
		mv.addObject("billList",Component.getListNoParam("bills.billsSelect"));
		mv.addObject("billList_sub",Component.getListNoParam("bills.SuppliedSelect"));
	
	
	     return mv;
	}
	
	
	@RequestMapping("/autolist.do")
	@ResponseBody
	public String autolist(HttpServletRequest req,
			@RequestParam(value="subkey")String subkey) throws Exception {
		
		  String codeStr = "";
		  String msg = "";
		  
		  
		  List<HashMap<String, Object>> list = Component.getList("bills.PreMonthData", subkey);
		  String AutolistCount = Component.getData("bills.billInfoAutoSelect", subkey);
		  
		  ArrayList<HashMap<String, Object>> map = new ArrayList<HashMap<String,Object>>();
		  
		  String now = new SimpleDateFormat("yyyyMMdd").format(Calendar.getInstance().getTime());
		  String nowdate = now.replace("-", "");
		  String nowdate2 = nowdate.trim();
		  
		  String year = new SimpleDateFormat("yyyy").format(Calendar.getInstance().getTime());
		  String year2 = year.substring(2, year.length());
		  
		  Calendar cal = Calendar.getInstance();
		  String format = "yyyy-MM-dd";
		  String format2 = format.replace("-", "");
		  SimpleDateFormat sdf = new SimpleDateFormat(format2);
		  cal.add(cal.MONTH, -1);
		  String date = sdf.format(cal.getTime());
		  String month = new SimpleDateFormat("MM").format(Calendar.getInstance().getTime());
		  String month2 = date.substring(4,6);
		  
		  
		  if(AutolistCount.equals("0")) {
			  
			  if (list.size() > 0) {
				  
				  String homekey = Component.getData("bills.homekey");
				  int num = 0;
				  
				  for(HashMap<String, Object> l : list) {
					  
					  String codenum = homekey.substring(7,homekey.length());
					  int tempc = Integer.parseInt(codenum) + 1 ;
					  String code =  homekey.substring(0,7);
					  codeStr = code+tempc;
					  homekey = codeStr;
					  
					  l.put("dbl_issuedate", nowdate2);
					  l.put("dbl_checkYN", "N");
					  l.put("dbl_errormsg", "");
					  l.put("dbl_homeid", codeStr);
					  l.put("dbl_status", "1");
					  l.put("dbl_update", "up");
					  
					  //품목명 처리(Subject)
					  String subject = (String)l.get("dbl_subject");
					  String subject_sub = subject.substring(5, subject.length());
					  
					  
					  //
					  if(subkey.equals("1")) {
						  String subDate = year2+"."+month2;
						  l.put("dbl_subject",subDate+subject_sub);
						  l.put("dbl_unitprice", "");
						  l.put("dbl_supplyprice", "");
						  l.put("dbl_tax", "");
						  l.put("dbl_chargetotal", "");
						  l.put("dbl_taxtotal", "");
						  l.put("dbl_grandtotal", "");
					  }else if(subkey.equals("2")) {
						  String subDate = year2+"."+month2;
						  l.put("dbl_subject",subDate+subject_sub);
						  l.put("dbl_unitprice", "");
						  l.put("dbl_supplyprice", "");
						  l.put("dbl_tax", "");
						  l.put("dbl_chargetotal", "");
						  l.put("dbl_taxtotal", "");
						  l.put("dbl_grandtotal", "");
					  }else {	
						  String subDate = year2+"."+month;
						  l.put("dbl_subject",subDate+subject_sub);
					  }
					  
					  Component.createData("bills.billInfoInsertAuto", l);
					  map.add(num, l);
					  
					  num =+ 1;
				  }
				  
				  //Keytable에 가장 마지막 숫자 업데이트
				  Component.updateData("bills.changeHomekey", codeStr);
				  
				  msg = "세금계산서 발행 리스트 업데이트 완료";
			  } else {
				  msg = "첫 발행시에는 직접 등록해 주세요. 다음 발행부터는 버튼 클릭 시 자동으로 업데이트 됩니다."; 
			  }
		  }else {
			  msg = "이번달에 이미 자동업데이트를 실행했습니다.";
			  
		  }
		  

		  return msg;
	}
	
	@RequestMapping("/listDelete.do")
	@ResponseBody
	public String listDelete(HttpServletRequest req,
			@RequestParam(value="subkey")String subkey) throws Exception {
		
		
		String msg = "";
		String AutolistCount = Component.getData("bills.billInfoAutoSelect", subkey);
		
		if(AutolistCount.equals("0")) {
			msg = "되돌릴 리스트가 없습니다";
		}else {
			
			Component.deleteData("bills.billInfoDeleteAuto", subkey);
			msg = "업데이트 리스트 되돌리기 완료";
		}
		
		return msg;
	}
	 

	 @RequestMapping("/dyAdmin/bills/hanjeon.do")
	   public ModelAndView billshanjeon(HttpServletRequest req) throws Exception {
		   ModelAndView mv = new ModelAndView("/dyAdmin/bill/pra_bills_hanjeon.adm");
		   
		   mv.addObject("billList",Component.getListNoParam("bills.billsSelect"));
		   mv.addObject("SuppliedList",Component.getListNoParam("bills.SuppliedSelect"));
		   mv.addObject("loglist",Component.getListNoParam("bills.billslogselect"));
		   mv.addObject("loglist1",Component.getListNoParam("bills.logList1"));
		   
		   String now = new SimpleDateFormat("yyyyMMdd").format(Calendar.getInstance().getTime());
		   String nowdate = now.replace("-", "");
		   String nowdate2 = nowdate.trim();
		   String mmdd = new SimpleDateFormat("MMdd").format(Calendar.getInstance().getTime());
//		   String month = new SimpleDateFormat("MM").format(Calendar.getInstance().getTime());
		   String year = new SimpleDateFormat("yyyy").format(Calendar.getInstance().getTime());
		   String year2 = year.substring(2, year.length());
		   
		   
		   Calendar cal = Calendar.getInstance();
		   String format = "yyyy-MM-dd";
		   String format2 = format.replace("-", "");
		   SimpleDateFormat sdf = new SimpleDateFormat(format2);
		   cal.add(cal.MONTH, -1); //월을 한달 뺀다.
		   String date = sdf.format(cal.getTime());
		   String month2 = date.substring(4,6);
		   
		   mv.addObject("mmdd",mmdd);
		   mv.addObject("nowDate",nowdate2);
		   mv.addObject("itemName",year2+"."+month2+"월분 발전대금");
		
	      return mv;
	  }
	 
	 
	 @RequestMapping("/dyAdmin/bills/client.do")
	   public ModelAndView billsclient(HttpServletRequest req) throws Exception {
		   ModelAndView mv = new ModelAndView("/dyAdmin/bill/pra_bills_client.adm");
		   
		   mv.addObject("billList",Component.getListNoParam("bills.billsSelect"));
		   mv.addObject("SuppliedList",Component.getListNoParam("bills.SuppliedSelect"));
		   mv.addObject("loglist",Component.getListNoParam("bills.billslogselect"));
		   mv.addObject("loglist2",Component.getListNoParam("bills.logList2"));
		   
		   String now = new SimpleDateFormat("yyyyMMdd").format(Calendar.getInstance().getTime());
		   String nowdate = now.replace("-", "");
		   String nowdate2 = nowdate.trim();
		   String mmdd = new SimpleDateFormat("MMdd").format(Calendar.getInstance().getTime());
		   String month = new SimpleDateFormat("MM").format(Calendar.getInstance().getTime());
		   String year = new SimpleDateFormat("yyyy").format(Calendar.getInstance().getTime());
		   
		   
		   Calendar cal = Calendar.getInstance();
		   String format = "yyyy-MM-dd";
		   String format2 = format.replace("-", "");
		   SimpleDateFormat sdf = new SimpleDateFormat(format2);
		   cal.add(cal.MONTH, -1); //월을 1달 뺀다.
		   System.out.println(cal);
		   String date = sdf.format(cal.getTime());
		   String year2 = date.substring(2,4);
		   String month2 = date.substring(4,6);
		   
		   
		   mv.addObject("mmdd",mmdd);
		   mv.addObject("nowDate",nowdate2);
		   mv.addObject("itemName",year2+"."+month2+"월분 발전대금");
		   
	      return mv;
	  }
	 
	 
	 @RequestMapping("/dyAdmin/bills/admin.do")
	   public ModelAndView billsadmin(HttpServletRequest req) throws Exception {
		   ModelAndView mv = new ModelAndView("/dyAdmin/bill/pra_bills_admin.adm");
		   
		   mv.addObject("billList",Component.getListNoParam("bills.billsSelect"));
		   mv.addObject("SuppliedList",Component.getListNoParam("bills.SuppliedSelect"));
		   mv.addObject("loglist",Component.getListNoParam("bills.billslogselect"));
		   mv.addObject("loglist3",Component.getListNoParam("bills.logList3"));
		   
		   String now = new SimpleDateFormat("yyyyMMdd").format(Calendar.getInstance().getTime());
		   String nowdate = now.replace("-", "");
		   String nowdate2 = nowdate.trim();
		   String mmdd = new SimpleDateFormat("MMdd").format(Calendar.getInstance().getTime());
		   String month = new SimpleDateFormat("MM").format(Calendar.getInstance().getTime());
		   String year = new SimpleDateFormat("yyyy").format(Calendar.getInstance().getTime());
		   String year2 = year.substring(2, year.length());
		   
		   mv.addObject("mmdd",mmdd);
		   mv.addObject("nowDate",nowdate2);
		   mv.addObject("itemName",year2+"."+month+"월분 전기안전관리비");
		
	      return mv;
	  }

	@RequestMapping("/dyAdmin/bills/proAndSupSelect.do")
	@ResponseBody
	public HashMap<String,Object> proAndSupSelect(HttpServletRequest req,
			@RequestParam(value="dbp_keyno")String dbp_keyno,
			@RequestParam(value="dbl_sub_keyno")String dbl_sub_keyno
			) throws Exception {
		 
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		
		
		if(dbl_sub_keyno.equals("1")) { 
			map = Component.getData("bills.proAndSupSelect1",dbp_keyno);
		}else if(dbl_sub_keyno.equals("2")) {
			map = Component.getData("bills.proAndSupSelect2",dbp_keyno);		
		}else {
			map = Component.getData("bills.proAndSupSelect3",dbp_keyno);
		}
		
		
		//homeid 조합식
		String codeStr = "";
		String homekey = Component.getData("bills.homekey");
		String codenum = homekey.substring(7,homekey.length());
		int tempc = Integer.parseInt(codenum) + 1 ;
		String code =  homekey.substring(0,7);
		codeStr = code+tempc;
		
		//homekey 테이블 업데이트
		Component.updateData("bills.changeHomekey", codeStr);
		
		
		
		map.put("dbl_homeid", codeStr);
		 
		
		return map;
}
	
	
	
	@RequestMapping("/dyAdmin/bills/billsActionAjax.do")
	@ResponseBody
	public String billsActionAjax(HttpServletRequest req,billDTO bill, 
			@RequestParam(value="buttionType", defaultValue="insert")String type) throws Exception {
		 
		 String msg = "";
		 
		 if(type.equals("update")) {
			 Component.updateData("bills.billsProvideUPdate", bill);
			 msg = "수정이 완료 되었습니다.";
		 }else {
			//등록된 사업자등록번호 확인 
			 int count = Component.getCount("bills.billCount",bill);
			 
			 if(count > 0) {
				 msg = "사업자 등록 번호가 이미 등록되어있습니다.";
			 }else {
				 Component.createData("bills.billsProvideInsert", bill);
				 msg = "등록이 완료 되었습니다.";
			 }
		 }
		
		 return msg;
	}
	@RequestMapping("/dyAdmin/bills/providerSelectAjax.do")
	@ResponseBody
	public HashMap<String, Object> providerSelectAjax(HttpServletRequest req,
			@RequestParam(value="dbp_keyno")String dbp_keyno
			) throws Exception {
		
		HashMap<String,Object> map = Component.getData("bills.billsSelect_one",dbp_keyno);
		
		
		return map;
	}
	
	@RequestMapping("/dyAdmin/bills/supliedSelectAjax.do")
	@ResponseBody
	public HashMap<String, Object> supliedSelectAjax(HttpServletRequest req,
			@RequestParam(value="dbs_keyno")String dbs_keyno
			) throws Exception {
		
		HashMap<String,Object> map = Component.getData("bills.SuppliedSelect_one",dbs_keyno);
		
		
		return map;
	}
	
	
	
	@RequestMapping("/dyAdmin/bills/billsActionAjax2.do")
	@ResponseBody
	public String billsActionAjax2(HttpServletRequest req,billDTO bill,
			@RequestParam(value="buttionType2", defaultValue="insert")String type) throws Exception {
		 
		 String msg = "";
		 
		 if(type.equals("update")) {
			 Component.updateData("bills.billsProvideUPdate2", bill);
			 msg = "수정이 완료 되었습니다.";
		 }else {
			//등록된 사업자등록번호 확인 
			 int count = Component.getCount("bills.billCount2",bill);
			 
			 if(count > 0) {
				 msg = "사업자 등록 번호가 이미 등록되어있습니다.";
			 }else {
				 Component.createData("bills.billsProvideInsert2", bill);
				 msg = "등록이 완료 되었습니다.";
			 }
		 }
		
		 return msg;
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
	public String sendApi( billDTO bill , String tocken)
			throws Exception {
			
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
//			String restapi = Api("http://115.68.1.5:8084/homtax/post", data.toString());
			
			if(restapi.equals("fail")) {
				System.out.println("https://www.hometaxbill.com:8084/homtax/post 서버에 문제가 발생했습니다.");
//				System.out.println("http://115.68.1.5:8084/homtax/post 서버에 문제가 발생했습니다.");
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

	
//		    			String contents = name+"(이)가 \n발전소 : "+map.get("DPP_NAME").toString()+"의 \n게시물 : "+title+" (를)을\n확인하였습니다.";
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
			       		
			       		

//				    	String contents = name+"(이)가 \n발전소 : "+map.get("DPP_NAME").toString()+"의 \n게시물 : "+title+" (를)을\n확인하였습니다.";
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
//		    		String codeStr = "";
//		    		
//		    		String homekey = Component.getData("bills.homekey");
//		    		 
//		    		String codenum = homekey.substring(7,homekey.length());
//					int tempc = Integer.parseInt(codenum) + 1 ;
//					String homeKeyPront =  homekey.substring(0,7);
//					codeStr = homeKeyPront+tempc;
//					 
//					bill.setDbl_homeid(codeStr);
//					
//					Component.updateData("bills.homeIdUpdate_f", bill);
//					Component.updateData("bills.changeHomekey", codeStr);
		    	}		    	
			
			return msg;
	}
	

	@RequestMapping("/dyAdmin/bills/billsInfoInsert1.do")
	@ResponseBody
	public String billsInfoIsnsertAjax1(HttpServletRequest req,billDTO bill) throws Exception {
		
		
		String msg = "";
//		 String keyno = Component.getData("bills.billLogCount",bill);
		 
		//공급자 공급받는자 등록 확인 	
//			if(keyno != null && keyno != "") {
//				
//				msg = keyno;	
//				//공급자 공급받는자 중복된 것중 국세청 전송여부 확인
//				String chkYN = Component.getData("bills.checkYNselect", keyno);
//				
//				if(chkYN.equals("Y")) {
//					msg = "1";
//				}else if(chkYN.equals("N")) {
//				}	 
//			}else {
		Component.createData("bills.subkey1Insert", bill);
		Component.updateData("bills.registNumberUpdate", bill);
		Component.createData("bills.billsInfoInsert", bill);
		msg = "저장 완료";
//		 }


		return msg;
	
	}
	@RequestMapping("/dyAdmin/bills/billsInfoInsert2.do")
	@ResponseBody
	public String billsInfoIsnsertAjax2(HttpServletRequest req,billDTO bill) throws Exception {
		
		
		String msg = "";
//		 String keyno = Component.getData("bills.billLogCount",bill);
		 
		//공급자 공급받는자 등록 확인 	
//			if(keyno != null && keyno != "") {	
//				
//				msg = keyno;
				
//				//공급자 공급받는자 중복된 것중 국세청 전송여부 확인
//				String chkYN = Component.getData("bills.checkYNselect", keyno);
//				
//				if(chkYN.equals("Y")) {
//					msg = "1";
//				}else if(chkYN.equals("N")) {
//				}	 
//			}else {
		Component.createData("bills.subkey2Insert", bill);
		Component.updateData("bills.registNumberUpdate", bill);
		Component.createData("bills.billsInfoInsert", bill);
		msg = "저장 완료";
//		 }


		return msg;
	
	}
	
	@RequestMapping("/dyAdmin/bills/billsInfoInsert3.do")
	@ResponseBody
	public String billsInfoIsnsertAjax3(HttpServletRequest req,billDTO bill) throws Exception {
		
		String msg = "";
//		String keyno = Component.getData("bills.billLogCount",bill);
		
		
		//공급자 공급받는자 등록 확인 	
//		if(keyno != null && keyno != "") {
//			
//			msg = keyno;	
//			//공급자 공급받는자 중복된 것중 국세청 전송여부 확인
//			String chkYN = Component.getData("bills.checkYNselect", keyno);
//			
//			if(chkYN.equals("Y")) {
//				msg = "1";
//			}else if(chkYN.equals("N")) {
//				
//			}	 
//		 }else{
		Component.createData("bills.subkey3Insert", bill);
		Component.updateData("bills.registNumberUpdate", bill);
		Component.createData("bills.billsInfoInsert", bill);
		msg = "저장 완료";
//		 }


		return msg;
	
	}
	
	@RequestMapping("/dyAdmin/bills/billsInfoUpdate.do")
	@ResponseBody
	public String billsInfoUpdateAjax(HttpServletRequest req, billDTO bill) throws Exception {
		
						
		Component.updateData("bills.billsInfoUpdate", bill);
		
		String msg = "세금계산서 정보 수정 완료";
			


		return msg;
	
	}
	
	@RequestMapping("/dyAdmin/bills/selectAllView.do")
	@ResponseBody
	public billDTO selectAllView(HttpServletRequest req,billDTO bill) throws Exception {
		
		
		bill = Component.getData("bills.selectAllView", bill);
		
		//homeid 조합식
//		String codeStr = "";
//		String homekey = Component.getData("bills.homekey");
//		String codenum = homekey.substring(7,homekey.length());
//		int tempc = Integer.parseInt(codenum) + 1 ;
//		String code =  homekey.substring(0,7);
//		codeStr = code+tempc;
		
		//homekey 테이블 +1수치 업데이트
//		Component.updateData("bills.changeHomekey", codeStr);
		
		
		//homeid select(수정 전)
		//HashMap<String, Object> code = Component.getData("bills.CodeNumberSelect", bill);
	
//		bill.setDbl_homeid(codeStr);
		
		
		return bill;
	
	}
	
	
	@RequestMapping("/dyAdmin/bills/sendNTS.do")
	@ResponseBody
	public void sendNTS(HttpServletRequest req,billDTO bill,
			@RequestParam(value="chkvalue")String dbl_keyno) throws Exception {
		
		String[] list = dbl_keyno.split(",");
		
		for(String l : list) {
			
			Component.updateData("bills.checkYI", l);
			
		}
		
		AsyncService.sendNTS(bill, dbl_keyno);	
	}
	
	
	
	@RequestMapping("/dyAdmin/bills/deleteInfo.do")
	@ResponseBody
	public String deleteInfo(HttpServletRequest req,
			@RequestParam(value="chkvalue")String dbl_keyno) throws Exception {
		
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		String msg = "";
		String [] dblkey = dbl_keyno.split(",");
		
		map.put("dblkey", dblkey);

		Component.deleteData("bills.billsDelete", dblkey);
	
		return msg;
	
	}
	
	/**
	 * 공급자 리스트 - 페이징 ajax
	 * @param req
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/bills/pagingAjax1.do")
	public ModelAndView listViewPaging1(HttpServletRequest req,
			Common search
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/bill/pra_bills_hanjeonPaging");

		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"bills.Log_getListCnt1",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		
		List<HashMap<String,Object>> resultList = Component.getList("bills.Log_getList1", map); 
		mv.addObject("resultList1", resultList);
		mv.addObject("search", search);
		return mv;
	}
	
	
	@RequestMapping(value="/dyAdmin/bills/pagingAjax2.do")
	public ModelAndView listViewPaging2(HttpServletRequest req,
			Common search
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/bill/pra_bills_clientPaging");

		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"bills.Log_getListCnt2",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		
		List<HashMap<String,Object>> resultList = Component.getList("bills.Log_getList2", map);
		mv.addObject("resultList2", resultList);
		mv.addObject("search", search);
		return mv;
	}
	
	@RequestMapping(value="/dyAdmin/bills/pagingAjax3.do")
	public ModelAndView listViewPaging3(HttpServletRequest req,
			Common search
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/bill/pra_bills_adminPaging");

		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"bills.Log_getListCnt3",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		
		List<HashMap<String,Object>> resultList = Component.getList("bills.Log_getList3", map); 
		mv.addObject("resultList3", resultList);
		mv.addObject("search", search);
		return mv;
	}
	

	
	//실패 로그 확인 메세지
	@RequestMapping(value="/dyAdmin/bills/sendingAjax.do")
	@ResponseBody
	public String sendMSG(HttpServletRequest req,
			@RequestParam(value="keyno")String keyno
			) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("dbl_keyno",keyno);
		map = Component.getData("bills.ErrorrMsg", map);

		String msg = (String) map.getOrDefault(("dbl_errormsg").toString(), "에러");
		return msg;
	}
	
	
	@RequestMapping("/dyAdmin/bills/prodelete.do")
	@ResponseBody
	public String prodelete(HttpServletRequest req,
			@RequestParam(value="dbp_keyno")String dbp_keyno) throws Exception {
		
		
	
		Component.deleteData("bills.proDelete", dbp_keyno);
		
		String msg = "공급자 삭제 완료";
	
		return msg;
	
	}
	
	@RequestMapping("/dyAdmin/bills/supdelete.do")
	@ResponseBody
	public String supdelete(HttpServletRequest req,
			@RequestParam(value="dbs_keyno")String dbs_keyno) throws Exception {
			
		
		Component.deleteData("bills.supDelete", dbs_keyno);
		
		String msg = "공급받는자 삭제 완료";
	
		return msg;
	
	}
	
	@RequestMapping("/dyAdmin/bills/senddelay.do")
	@ResponseBody
	public void delaysend(HttpServletRequest req, billDTO bill,
			@RequestParam(value="chkvalue")String dbl_keyno,
			@RequestParam(value="checkYN")String checkYN) throws Exception {
		
			String[] list = dbl_keyno.split(",");
			String[] list1 = checkYN.split(",");
		
		for(int i= 0; i<list.length; i++) {
			
			//전송대기(W)로 변경, 전송대기 2로 변경
			Component.updateData("bills.checkYW", list[i]);
		
		}
		return;
	}
	
	
	//전송결과 확인
	@RequestMapping("/billsResultTest.do")
	@ResponseBody
	public String billsResultTest(HttpServletRequest req) throws Exception {
		
		String msg2 = "전송 상태가 새로고침 되었습니다.";
		
		List<billDTO> result = Component.getListNoParam("bills.LogResultNeedData");
		
		for(billDTO r: result) {
			
			String subKey = r.getDbl_sub_keyno();
			
			
			
			//한전 발행일 경우
			if(subKey.equals("1")) {
				billsResultTest2(r);
				
			// 한전발행 아닐경우
			}else {
				
				String msg = "";
				String status = "-1";
				String chYn = "N";
				
				// 입력할 세금계산서 정보를 배열에 추가(JSONObject객체와 순서가 일치해야함.)
				List<List<String>> taxinfo = new ArrayList<>();
				taxinfo.add(Arrays.asList(r.getDbp_id(),r.getDbp_pass(),r.getDbp_apikey(),r.getDbl_homeid()));
				
				// JSONObject객체 생성
				JSONObject data = new JSONObject();
				
				// JSONObject객체에 세금계산서 정보를 추가
				data.put("hometaxbill_id", taxinfo.get(0).get(0));			// 회사코드
				data.put("spass", taxinfo.get(0).get(1));					// 패스워드
				data.put("apikey", taxinfo.get(0).get(2));					// 인증키
				data.put("homemunseo_id", taxinfo.get(0).get(3));			// 고유번호
				
				// 전자세금계산서 발행 후 리턴
				String restapi = RestApiSample_getpkey.Api("https://www.hometaxbill.com:8084/homtax/getpkey", data.toString());
				
				if(restapi.equals("fail")) {
					System.out.println("https://www.hometaxbill.com:8084/homtax/getpkey 서버에 문제가 발생했습니다.");
					return "홈택스빌 서버 응답 오류. 새로고침 후 다시 전송상태현황 버튼을 클릭해 주세요.";
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
						System.out.println(r.getDbp_name() + ": 성공");
						msg = Hlist.get("msg").toString() + Hlist.get("msg2").toString();
						if(msg.contains("성공")) {
							status = "0";
							chYn = "Y";
						}
					} else {
						System.out.println(r.getDbp_name() + ": 실패");
						msg = (String) jsonObj.get("msg");
						System.out.println("code : " + (String) jsonObj.get("code") + "\n" + "msg : " + (String) jsonObj.get("msg"));
						
					}
				}else {
					msg = "서버 호출 실패";
				}
				
				r.setDbl_status(status);
				r.setDbl_errormsg(msg);
				r.setDbl_checkYN(chYn);
				Component.updateData("bills.ChangeLogmsg", r);
			}
			
		}
		return msg2;
	}
	
	//한전 발행 전송결과 확인
	public void billsResultTest2(billDTO r) throws Exception {
		
		
		String msg = "";
		String status = "";
		String chYn = ""; 	
		
		String HomeId = r.getDbl_homeid();
		String CopNum = r.getDbp_co_num();
		
		String DcCode = taxService.result(HomeId, CopNum);
		
		if(DcCode.equals("국세청 전송 성공") || DcCode.equals("개봉") ) {
			 msg = DcCode;
			 status = "0";
			 chYn = "Y"; 	
			
		}else {
			 msg = DcCode;
			 status = "-1";
			 chYn = "N";
			
			
		}
		r.setDbl_status(status);
		r.setDbl_errormsg(msg);
		r.setDbl_checkYN(chYn);
		Component.updateData("bills.ChangeLogmsg", r);
		
		
	}
	
	
	@RequestMapping("/dyAdmin/bills/HomeIdUpdate.do")
	@ResponseBody
	public String HomeIdUpdate(HttpServletRequest req,billDTO bill,
			@RequestParam(value="subkey")String subkey) throws Exception {
	
		 List<HashMap<String, Object>> list = Component.getList("bills.f_ListSelect", subkey);
		 
		 String now = new SimpleDateFormat("yyyyMMdd").format(Calendar.getInstance().getTime());
		 String nowdate = now.replace("-", "");
		 String nowdate2 = nowdate.trim();
		 
		 
		 String msg = "";
		 String codeStr = "";
		 String homekey = Component.getData("bills.homekey");
		 
		 
		 if (list.size() > 0) {
			 for(HashMap<String, Object> l : list) {
				 
				 String codenum = homekey.substring(7,homekey.length());
				 int tempc = Integer.parseInt(codenum) + 1 ;
				 String code =  homekey.substring(0,7);
				 codeStr = code+tempc;
				 homekey = codeStr;
				 
				 l.put("dbl_homeid", codeStr);
				 l.put("dbl_issuedate", nowdate2);
				 l.put("sub_issuedate", nowdate2);
				 
				 Component.updateData("bills.homeIdUpdate_f", l);
			 }
			 msg = "전송 실패한 리스트의 고유번호가 수정되었습니다. 발행할 리스트를 전송하세요."; 
			 
			 //Keytable에 가장 마지막 숫자 업데이트
			 Component.updateData("bills.changeHomekey", codeStr);
			 
		 }else {
			 msg = "고유번호를 수정할 리스트가 없습니다.";
		 }
		 
		 return msg;
	}
	
	
	@RequestMapping("/dyAdmin/bills/allSendNTS.do")
	@ResponseBody
	public void allSendNTS(HttpServletRequest req, billDTO bill,
			@RequestParam(value="subkey")String subkey) throws Exception {
		
		String msg = "";
		String[] list = subkey.split(",");

		for(String l : list) {
			
			Component.updateData("bills.checkYI", l);
			
		}
		
		
		AsyncService.allSendNTS(bill, subkey);
			
	}
	
	@ResponseBody
	@RequestMapping("/dyAdmin/bills/testasync.do")
	public void testtt(billDTO bill) throws Exception {
		
		//토큰받기
		String tocken = requestAPI.TockenRecive(SettingData.Apikey,SettingData.Userid);
		tocken = URLEncoder.encode(tocken, "UTF-8");
				
		
		AsyncService.sendApi(bill, tocken);
	}
	
	
	/**
	 * 
	 * @param bill
	 * @throws Exception
	 * 메일 접근이후 엑셀 다운로드 테스트 진행 
	 */
	@RequestMapping("/dyAdmin/bills/excelAjax.do")
	public ModelAndView mailReadExcelDownload( 
			
			HttpServletResponse res 
			,HttpServletRequest req
			,Common search
			
			) throws Exception {
		
		ModelAndView mv = new ModelAndView("dyAdmin/bill/pra_bills_hanjeon_excel");
		//대양기업
		String[] user1 = {"imap.naver.com","daeyang0715@naver.com","eodid2015!@"};
		String[] user2 = {"imap.naver.com","khk8086@naver.com","kimhk8086"};
		
		ArrayList<String[]> Userlist = new ArrayList<String[]>();
		ArrayList<HashMap<String, Object>> sheet = new ArrayList<HashMap<String, Object>>();
		
		Userlist.add(user1);
		Userlist.add(user2);
		
		for(String[] u : Userlist) {
			ArrayList<HashMap<String, Object>> temp = new ArrayList<HashMap<String, Object>>();
			temp = emailExcel.main(res,u[0],u[1],u[2]);
			
			sheet.addAll(temp);
		}
		
		//여기서 excel 다운로드
        if(sheet.size() > 0 ) {
	    	mv.addObject("sheet",sheet);
	    	
	    	try {
	    		Cookie cookie = new Cookie("fileDownload", "true");
				cookie.setPath("/");
				res.addCookie(cookie);
			} catch (Exception e) {
				System.out.println("쿠키 에러 :: " + e.getMessage());
			}
        	
        }
        return mv;
	}
	
	@ResponseBody
	@RequestMapping(value = "/popBillInsertExcel.do")
	public String PopBillJoinExcel(HttpServletRequest req,
			@RequestParam(value = "excelFile2", required=false) MultipartFile file
			) throws Exception {
	

		ArrayList<ArrayList<String>> result = excel.readFilter_And_Insert(file);
		
		if(result.size() > 0) {
			
			for(ArrayList<String> re : result) {
				JoinForm m = new JoinForm();
				
				m.setID(re.get(0));				
				m.setPassword(re.get(1));
				m.setLinkID("DAEYANG");
				m.setCorpNum(re.get(2));
				m.setCEOName(re.get(3));
				m.setCorpName(re.get(4));
				m.setAddr(re.get(5));
				m.setBizType(re.get(6));
				m.setBizClass(re.get(7));
				m.setContactName(re.get(8));
				m.setContactEmail(re.get(9));
				m.setContactTEL(re.get(10));
				
				taxService.Join(m);
				
			}
		}
		
		return "회원가입 완료";
		
		
	}
	
	
	
}
