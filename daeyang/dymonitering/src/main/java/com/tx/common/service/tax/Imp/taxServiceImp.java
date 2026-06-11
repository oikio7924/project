package com.tx.common.service.tax.Imp;

import java.awt.Component;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;

import org.codehaus.plexus.util.StringUtils;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import com.popbill.api.IssueResponse;
import com.popbill.api.JoinForm;
import com.popbill.api.PopbillException;
import com.popbill.api.Response;
import com.popbill.api.TaxinvoiceService;
import com.popbill.api.taxinvoice.MgtKeyType;
import com.popbill.api.taxinvoice.Taxinvoice;
import com.popbill.api.taxinvoice.TaxinvoiceAddContact;
import com.popbill.api.taxinvoice.TaxinvoiceDetail;
import com.popbill.api.taxinvoice.TaxinvoiceLog;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.reqapi.requestAPIservice;
import com.tx.common.config.SettingData;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.tax.taxService;
import com.tx.test.dto.billDTO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("taxService")
public class taxServiceImp extends EgovAbstractServiceImpl implements taxService{
    
	@Autowired
    private TaxinvoiceService taxinvoiceService;
	
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	@Autowired requestAPIservice requestAPI;

	public void registIssue(billDTO bill, String tocken) throws Exception {
	        /**
	         * 작성된 세금계산서 데이터를 팝빌에 저장과 동시에 발행(전자서명)하여 "발행완료" 상태로 처리합니다. - 세금계산서 국세청 전송 정책
	         * [https://developers.popbill.com/guide/taxinvoice/java/introduction/policy-of-send-to-nts]
	         * - "발행완료"된 전자세금계산서는 국세청 전송 이전에 발행취소(CancelIssue API) 함수로 국세청 신고 대상에서 제외할 수 있습니다. -
	         * 임시저장(Register API) 함수와 발행(Issue API) 함수를 한 번의 프로세스로 처리합니다. - 세금계산서 발행을 위해서 공급자의 인증서가 팝빌
	         * 인증서버에 사전등록 되어야 합니다. └ 위수탁발행의 경우, 수탁자의 인증서 등록이 필요합니다. -
	         * https://developers.popbill.com/reference/taxinvoice/java/api/issue#RegistIssue
	         */
			//날짜 생성부분
		    String now = new SimpleDateFormat("yyyyMMdd").format(Calendar.getInstance().getTime());
		 	String nowdate = now.replace("-", "");
		 	String nowdate2 = nowdate.trim();
	        
		 	
		 	/***************************************************************************
	         * 세금계산서 정보
	         ****************************************************************************/
	        Taxinvoice taxinvoice = new Taxinvoice();

	        // 발행형태, {정발행, 역발행, 위수탁} 중 기재
	        taxinvoice.setIssueType("정발행");

	        // 과세형태, {과세, 영세, 면세} 중 기재
	        taxinvoice.setTaxType("과세");

	        // 과금방향, {정과금, 역과금} 중 기재
	        // └ 정과금 = 공급자 과금 , 역과금 = 공급받는자 과금
	        // -'역과금'은 역발행 세금계산서 발행 시에만 이용가능
	        taxinvoice.setChargeDirection("정과금");

	        // 작성일자, 날짜형식(yyyyMMdd)
	        taxinvoice.setWriteDate(nowdate2);

	        
	        //체크해야댐
	        // {영수, 청구, 없음} 중 기재
	        taxinvoice.setPurposeType("청구");


	        /***************************************************************************
	         * 공급자 정보
	         ****************************************************************************/

	        // 공급자 사업자번호 (하이픈 '-' 제외 10 자리)
	        taxinvoice.setInvoicerCorpNum(bill.getDbp_co_num());
	        
	        // 공급자 종사업장 식별번호, 필요시 기재. 형식은 숫자 4자리.
	        taxinvoice.setInvoicerTaxRegID("");

	        // 공급자 상호
	        taxinvoice.setInvoicerCorpName(bill.getDbp_name());

	        // 공급자 문서번호, 1~24자리 (숫자, 영문, '-', '_') 조합으로 사업자 별로 중복되지 않도록 구성
	        taxinvoice.setInvoicerMgtKey(bill.getDbl_homeid());

	        // 공급자 대표자 성명
	        taxinvoice.setInvoicerCEOName(bill.getDbp_ceoname());

	        // 공급자 주소
	        taxinvoice.setInvoicerAddr(bill.getDbp_address());

	        // 공급자 종목
	        taxinvoice.setInvoicerBizClass(bill.getDbp_bizclassification());

	        // 공급자 업태
	        taxinvoice.setInvoicerBizType(bill.getDbp_biztype());

	        // 공급자 담당자 성명
	        taxinvoice.setInvoicerContactName(bill.getDbp_ir_name());

	        // 공급자 담당자 메일주소
	        taxinvoice.setInvoicerEmail(bill.getDbp_email());

	        // 공급자 담당자 연락처
	        taxinvoice.setInvoicerTEL(bill.getDbp_ir_cell());

	        // 공급자 담당자 휴대폰번호
	        taxinvoice.setInvoicerHP(bill.getDbp_ir_cell());

	        // 발행 안내 문자 전송여부 (true / false 중 택 1)
	        // └ true = 전송 , false = 미전송
	        // └ 공급받는자 (주)담당자 휴대폰번호 {invoiceeHP1} 값으로 문자 전송
	        // - 전송 시 포인트 차감되며, 전송실패시 환불처리
	        taxinvoice.setInvoicerSMSSendYN(false);

	        /***************************************************************************
	         * 공급받는자 정보
	         ****************************************************************************/
	        String InvoiceeType = "사업자";
	        // 공급받는자 구분, [사업자, 개인, 외국인] 중 기재
	        
	        
	        if(StringUtils.isEmpty(bill.getDbl_partytypecode())) {
	        	InvoiceeType = "사업자";
	        }else if(bill.getDbl_partytypecode().toString().equals("02")) {
	        	InvoiceeType = "개인";
	        	System.out.println("개인");
	        	
	        }else if(bill.getDbl_partytypecode().toString().equals("03")) {
	        	InvoiceeType = "외국인";
	        	System.out.println("외국인");
	        }
	        
	        taxinvoice.setInvoiceeType(InvoiceeType);

	        // 공급받는자 사업자번호
	        // - {invoiceeType}이 "사업자" 인 경우, 사업자번호 (하이픈 ('-') 제외 10자리)
	        // - {invoiceeType}이 "개인" 인 경우, 주민등록번호 (하이픈 ('-') 제외 13자리)
	        // - {invoiceeType}이 "외국인" 인 경우, "9999999999999" (하이픈 ('-') 제외 13자리)
	        taxinvoice.setInvoiceeCorpNum(bill.getDbs_co_num());

	        // 공급받는자 종사업장 식별번호, 필요시 숫자4자리 기재
	        taxinvoice.setInvoiceeTaxRegID(bill.getDbs_taxnum());

	        // 공급받는자 상호
	        taxinvoice.setInvoiceeCorpName(bill.getDbs_name());

	        // [역발행시 필수] 공급받는자 문서번호, 1~24자리 (숫자, 영문, '-', '_') 를 조합하여 사업자별로 중복되지 않도록 구성
	        taxinvoice.setInvoiceeMgtKey("");

	        // 공급받는자 대표자 성명
	        taxinvoice.setInvoiceeCEOName(bill.getDbs_ceoname());

	        // 공급받는자 주소
	        taxinvoice.setInvoiceeAddr(bill.getDbs_address());

	        // 공급받는자 종목
	        taxinvoice.setInvoiceeBizClass(bill.getDbs_bizclassification());

	        // 공급받는자 업태
	        taxinvoice.setInvoiceeBizType(bill.getDbs_biztype());

	        // 공급받는자 담당자 성명
	        taxinvoice.setInvoiceeContactName1(bill.getDbs_name1());

	        // 공급받는자 담당자 메일주소
	        // 팝빌 개발환경에서 테스트하는 경우에도 안내 메일이 전송되므로,
	        // 실제 거래처의 메일주소가 기재되지 않도록 주의
	        taxinvoice.setInvoiceeEmail1(bill.getDbs_email1());

	        // 공급받는자 담당자 연락처
	        taxinvoice.setInvoiceeTEL1(bill.getDbs_cell1());

	        // 공급받는자 담당자 휴대폰번호
	        taxinvoice.setInvoiceeHP1(bill.getDbs_cell1());

	        // 역발행 안내 문자 전송여부 (true / false 중 택 1)
	        // └ true = 전송 , false = 미전송
	        // └ 공급자 담당자 휴대폰번호 {invoicerHP} 값으로 문자 전송
	        // - 전송 시 포인트 차감되며, 전송실패시 환불처리
	        taxinvoice.setInvoiceeSMSSendYN(false);

	        /***************************************************************************
	         * 세금계산서 기재정보
	         ****************************************************************************/

	        // 공급가액 합계
	        taxinvoice.setSupplyCostTotal(bill.getDbl_chargetotal().replace(",", ""));

	        // 세액 합계
	        taxinvoice.setTaxTotal(bill.getDbl_taxtotal().replace(",", ""));

	        // 합계금액, 공급가액 + 세액
	        taxinvoice.setTotalAmount(bill.getDbl_grandtotal().replace(",", ""));

	        // 일련번호
	        taxinvoice.setSerialNum("0715");

	        // 현금
	        taxinvoice.setCash(bill.getDbl_cash().replace(",", ""));

	        // 수표
	        taxinvoice.setChkBill(bill.getDbl_scheck().replace(",", ""));

	        // 어음
	        taxinvoice.setNote(bill.getDbl_draft().replace(",", ""));

	        // 외상미수금
	        taxinvoice.setCredit(bill.getDbl_uncollected().replace(",", ""));

	        // 비고
	        // {invoiceeType}이 "외국인" 이면 remark1 필수
	        // - 외국인 등록번호 또는 여권번호 입력
	        taxinvoice.setRemark1(bill.getDescription());
	        taxinvoice.setRemark2("");
	        taxinvoice.setRemark3("");

	        // 책번호 '권' 항목, 최대값 32767
	        taxinvoice.setKwon((short) 1);

	        // 책번호 '호' 항목, 최대값 32767
	        taxinvoice.setHo((short) 1);

	        // 사업자등록증 이미지 첨부여부 (true / false 중 택 1)
	        // └ true = 첨부 , false = 미첨부(기본값)
	        // - 팝빌 사이트 또는 인감 및 첨부문서 등록 팝업 URL (GetSealURL API) 함수를 이용하여 등록
	        taxinvoice.setBusinessLicenseYN(false);

	        // 통장사본 이미지 첨부여부 (true / false 중 택 1)
	        // └ true = 첨부 , false = 미첨부(기본값)
	        // - 팝빌 사이트 또는 인감 및 첨부문서 등록 팝업 URL (GetSealURL API) 함수를 이용하여 등록
	        taxinvoice.setBankBookYN(false);

	        /***************************************************************************
	         * 수정세금계산서 정보 (수정세금계산서 작성시에만 기재) - 수정세금계산서 작성방법 안내 -
	         * https://developers.popbill.com/guide/taxinvoice/java/introduction/modified-taxinvoice#intro
	         ****************************************************************************/

	        // 수정사유코드, 수정사유에 따라 1~6 중 선택기재.
	        taxinvoice.setModifyCode(null);

	        // 수정세금계산서 작성시 원본세금계산서 국세청 승인번호 기재
	        taxinvoice.setOrgNTSConfirmNum(null);

	        /***************************************************************************
	         * 상세항목(품목) 정보
	         ****************************************************************************/

	        taxinvoice.setDetailList(new ArrayList<TaxinvoiceDetail>());

	        // 상세항목 객체
	        TaxinvoiceDetail detail = new TaxinvoiceDetail();

	        detail.setSerialNum((short) 1); // 일련번호, 1부터 순차기재
	        detail.setPurchaseDT(nowdate2); // 거래일자
	        detail.setItemName(bill.getDbl_subject()); // 품목명
	        detail.setSpec(""); // 규격
	        detail.setQty(bill.getDbl_quantity()); // 수량
	        detail.setUnitCost(bill.getDbl_unitprice().replace(",", "")); // 단가
	        detail.setSupplyCost(bill.getDbl_supplyprice().replace(",", "")); // 공급가액
	        detail.setTax(bill.getDbl_tax().replace(",", "")); // 세액
	        detail.setRemark(bill.getDescription()); // 비고

	        taxinvoice.getDetailList().add(detail);

//	        detail = new TaxinvoiceDetail();
//
//	        detail.setSerialNum((short) 2);
//	        detail.setPurchaseDT("20230102");
//	        detail.setItemName("품목명2");
//	        detail.setSpec("규격");
//	        detail.setQty("1");
//	        detail.setUnitCost("50000");
//	        detail.setSupplyCost("50000");
//	        detail.setTax("5000");
//	        detail.setRemark("품목비고2");
//
//	        taxinvoice.getDetailList().add(detail);

	        /***************************************************************************
	         * 추가담당자 정보 - 세금계산서 발행 안내 메일을 수신받을 공급받는자 담당자가 다수인 경우 담당자 정보를 - 추가하여 발행 안내메일을 다수에게 전송할 수
	         * 있습니다. (최대 5명)
	         ****************************************************************************/

	        taxinvoice.setAddContactList(new ArrayList<TaxinvoiceAddContact>());

	        TaxinvoiceAddContact addContact = new TaxinvoiceAddContact();

//	        addContact.setSerialNum(1); // 일련번호 (1부터 순차적으로 입력 (최대 5))
//	        addContact.setContactName(bill.getDbs_name2()); // 담당자 성명
//	        addContact.setEmail(bill.getDbs_email2()); // 이메일
//
//	        taxinvoice.getAddContactList().add(addContact);

	        addContact.setSerialNum(1); // 일련번호 (1부터 순차적으로 입력 (최대 5))
	        addContact.setContactName("오인경"); // 담당자 성명
	        addContact.setEmail("dy7924@dycompany.co.kr"); // 이메일

	        taxinvoice.getAddContactList().add(addContact);
	        
	        // 거래명세서 동시작성여부 (true / false 중 택 1)
	        // └ true = 사용 , false = 미사용
	        // - 미입력 시 기본값 false 처리
	        Boolean WriteSpecification = false;

	        // {writeSpecification} = true인 경우, 거래명세서 문서번호 할당
	        // - 미입력시 기본값 세금계산서 문서번호와 동일하게 할당
	        String DealInvoiceKey = null;

	        // 메모
	        String Memo = "즉시발행 메모";

	        // 지연발행 강제여부 (true / false 중 택 1)
	        // └ true = 가능 , false = 불가능
	        // - 미입력 시 기본값 false 처리
	        // - 발행마감일이 지난 세금계산서를 발행하는 경우, 가산세가 부과될 수 있습니다.
	        // - 가산세가 부과되더라도 발행을 해야하는 경우에는 forceIssue의 값을
	        // true로 선언하여 발행(Issue API)를 호출하시면 됩니다.
	        Boolean ForceIssue = false;
	        
	        try {

	            IssueResponse response = taxinvoiceService.registIssue(bill.getDbp_co_num(), taxinvoice,
	                    WriteSpecification, Memo, ForceIssue, DealInvoiceKey);

	            System.out.println(response.getCode());
	            String code = String.valueOf(response.getCode());
	            System.out.println(response.getMessage());
	            String msg = response.getMessage();
	           
				
				
				
		    	String subkey = bill.getDbl_sub_keyno();
		    	
		    	bill.setDbl_status("0");
				bill.setDbl_errormsg(msg);
				bill.setDbl_issuedate(nowdate2);
				bill.setDbl_sub_issuedate(nowdate2);
				
				Component.updateData("bills.codemsgUpdate", bill);
				
		    	if(subkey.equals("1")||subkey.equals("2")) {
		    		
		    			String pname = bill.getDbl_p_name();
		    			String sname = bill.getDbl_s_name();
		    			String subject = bill.getDbl_subject();
		    			String grandtotal = bill.getDbl_grandtotal();
		    			String issuedate = bill.getDbl_issuedate();
		    			String admin = "대양기업 조유리";
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
//				    			requestAPI.KakaoAllimTalkSend(SettingData.Apikey,SettingData.Userid,SettingData.Senderkey,tocken,jsonObj2,contents,phone,Sendurl);
			    		
			    		
			    	}else {
			    		
			    		String pname = bill.getDbl_p_name();
		    			String sname = bill.getDbl_s_name();
		    			String subject = bill.getDbl_subject();
		    			String grandtotal = bill.getDbl_grandtotal();
		    			String issuedate = bill.getDbl_issuedate();
		    			String admin = "대양기업 조유리";
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
			    		


	        } catch (PopbillException e) {
	          // 전송 실패 시	
	        
	        	
	        	bill.setDbl_status("-1");
				bill.setDbl_errormsg(e.getMessage());
				Component.updateData("bills.codemsgUpdate", bill);
				
				//전송상태 N으로 변경해서 체크박스 안사라지게 함
				Component.updateData("bills.checkChange", bill);
	            
	        }
	    }
		
	public String result(String HomeId, String CopNum) {
		/**
         * 세금계산서의 상태에 대한 변경이력을 확인합니다. -
         * https://developers.popbill.com/reference/taxinvoice/java/api/info#GetLogs
         */

        // 세금계산서 유형 (SELL-매출, BUY-매입, TRUSTEE-위수탁)
        MgtKeyType mgtKeyType = MgtKeyType.SELL;

        // 세금계산서 문서번호
        String mgtKey = HomeId;
//       String mgtKey = "daeyang2845";
        String CorpNum = CopNum; //사업자등록번호
//       String CorpNum = "6838800157"; //사업자등록번호
        String DcCode="";
       
        try {

            TaxinvoiceLog[] taxinvoiceLogs = taxinvoiceService.getLogs(CorpNum, mgtKeyType, mgtKey);
            //100 임시저장 , 101 수정 , 102 개봉 , 103 수신확인 , 111 메일재전송 , 112 문자재전송 , 113 팩스 재전송 , 122 문자전송결과 , 123 팩스 전송결과 
            //124 휴폐업 확인 , 125 문서번호 할당 , 220 역발행요청 , 221 역발행요청 거부 , 222 역발행요청취소 , 230 발행 , 240 발행취소 , 250 국세청전송 요청 , 251 국세청전송 대기 
            //252 국세청전송 진행중 , 253 국세청 전송 접수 , 254 국세청 전송 성공 , 255 국세청전송 실패
            System.out.println(taxinvoiceLogs[taxinvoiceLogs.length-1].getDocLogType());
            DcCode = taxinvoiceLogs[taxinvoiceLogs.length-1].getDocLogType().toString();
            if(DcCode.equals("100")) {
            	DcCode = "세금계산서 임시저장 상태";
            	
			}else if(DcCode.equals("250")){
				DcCode = "국세청전송 요청";
				
			}else if(DcCode.equals("102")){
				DcCode = "개봉";
				
			}else if(DcCode.equals("251")){
				DcCode = "국세청전송 대기";
				
			}else if(DcCode.equals("252")){
				DcCode = "국세청전송 진행중";
				
			}else if(DcCode.equals("253")){
				DcCode = "국세청 전송 접수";
				
			}else if(DcCode.equals("254")){
				DcCode = "국세청 전송 성공";
				
			}else if(DcCode.equals("255")){
				DcCode = "국세청전송 실패";
			}else {
				DcCode = "국세청전송 진행중";
			}

        } catch (PopbillException e) {
      
        	DcCode = "오류내용 : "+e;
        }
        
     return DcCode;   
	}
	
	
	public Response Join(JoinForm joinInfo) throws PopbillException{
		
		Response joinMessage = taxinvoiceService.joinMember(joinInfo);
		
		System.out.println(joinMessage);
		
		return joinMessage;
	}
		
		
}
