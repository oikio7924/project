package com.tx.SafeAdmin.controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.jms.Session;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.transaction.Transactional;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang3.StringUtils;
import org.json.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.tx.dyAdmin.admin.board.dto.BoardColumn;
import com.tx.dyAdmin.admin.site.dto.SiteManagerDTO;
import com.tx.dyAdmin.member.dto.UserDTO;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.config.SettingData;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.dto.Common;
import com.tx.common.file.FileUploadTools;
import com.tx.common.file.dto.FileSub;
import com.tx.common.service.page.PageAccess;
import com.tx.common.security.aes.AES256Cipher;
import com.tx.common.service.reqapi.requestAPIservice;
import com.tx.common.service.excel.ExcelService;
import com.tx.SafeAdmin.dto.DateDTO;
import com.tx.SafeAdmin.dto.safeAdminDTO;
import com.tx.SafeAdmin.dto.safeUserDTO;
import com.tx.SafeAdmin.dto.safebillDTO;
import com.tx.SafeAdmin.RestApiSample_getpkey;
import com.tx.dyAdmin.admin.site.service.SiteService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class safeAdminController {

	@Autowired
	ComponentService Component;

	@Autowired
	CommonService CommonService;

	@Autowired
	requestAPIservice requestAPI;
	/** 페이지 처리 출 */
	@Autowired
	private PageAccess PageAccess;
	
	/** 프로퍼티 정보 */
    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;
    
    @Autowired SiteService SiteService;
    
    /** 파일업로드 툴*/
    @Autowired private FileUploadTools FileUploadTools;	
    
    
    @Autowired 
    com.tx.common.service.excel.ExcelService excel;	

	/*
	 * 메인페이지
	 **/
	@RequestMapping("/sfa/safe/safe.do")
	public String adminIntro(HttpServletRequest req) throws Exception {
		//ModelAndView mv = new ModelAndView("/user/_SFA/safe/prc_safemain_pb");
		//ModelAndView mv = new ModelAndView("/user/_SFA/safe/prc_admin_log_pb");
		

		return "redirect:/sfa/safe/checkingStatus.do";
	}

	/*
	 * 안전관리 전기안전설비점검 탭
	 **/
	@RequestMapping("/sfa/safe/safeAdmin.do")
	public ModelAndView safeAdmin(HttpServletRequest req,
			@RequestParam(value = "SU_KEYNO", required = false) String SU_KEYNO) throws Exception {

		ModelAndView mv = new ModelAndView("/user/_SFA/template/skin/prc_sfa_register_pb");
		
		Map<String, Object> user = CommonService.getUserInfo(req);
		String UI_KEYNO = user.get("UI_KEYNO").toString();
		Locale koreanLocale = Locale.KOREAN; 

		List<HashMap<String, Object>> result = Component.getListNoParam("sfa.jspselect");
		String now = new SimpleDateFormat("yyyy년 MM월 dd일 HH시 mm분 ss초").format(Calendar.getInstance().getTime());
		String year = new SimpleDateFormat("yyyy").format(Calendar.getInstance().getTime());
		String mon = new SimpleDateFormat("MM").format(Calendar.getInstance().getTime());
		String day = new SimpleDateFormat("dd").format(Calendar.getInstance().getTime());
		String time = new SimpleDateFormat("HH").format(Calendar.getInstance().getTime());
		String min = new SimpleDateFormat("mm").format(Calendar.getInstance().getTime());
		String sec = new SimpleDateFormat("ss").format(Calendar.getInstance().getTime());
		String dayOfWeek =  new SimpleDateFormat("E",koreanLocale).format(Calendar.getInstance().getTime());
		
		
		
		if(SU_KEYNO != null && !SU_KEYNO.isEmpty()) {
			mv.addObject("chk_su_keyno", SU_KEYNO);
		}
		mv.addObject("arialist", Component.getList("sfa.AreaSelect", UI_KEYNO));
		mv.addObject("safeuserlist", Component.getList("sfa.safeuserselect", UI_KEYNO));
		mv.addObject("now", now);
		mv.addObject("year", year);
		mv.addObject("mon", mon);
		mv.addObject("day", day);
		mv.addObject("time", time);
		mv.addObject("min", min);
		mv.addObject("sec", sec);
		mv.addObject("dayOfWeek", dayOfWeek);

		mv.addObject("result", result);
		mv.addObject("UI_KEYNO", UI_KEYNO);

		return mv;
	}

	/*
	 * 안전관리 게시판 탭
	 **/
//	@RequestMapping(value = "/sfa/safeAdmin/safeAdminboard.do")
//	public ModelAndView safeAdminboard(HttpServletRequest req
//			) throws Exception{
//		
//		ModelAndView mv = new ModelAndView("/publish/sfa/miniBoard/prp_BMM_0000000019");
//		
//		List<HashMap<String,Object>> result = Component.getListNoParam("sfa.jspselect");
//		
//		mv.addObject("result", result);
//		
//		
//		return mv;	
//	}
	/*
	 * 세금계산서 공급자, 공급받는자 등록 탭
	 **/
	@RequestMapping(value = "/sfa/safe/billsUser.do")
	public ModelAndView safebilluser(HttpServletRequest req) throws Exception {

		ModelAndView mv = new ModelAndView("/user/_SFA/bill/prc_bill_userInsert_pb");
		
		
		Map<String, Object> user = CommonService.getUserInfo(req);
		String UI_KEYNO = user.get("UI_KEYNO").toString();

		mv.addObject("UI_KEYNO", UI_KEYNO);
		mv.addObject("billList", Component.getList("sfabill.billsSelect", UI_KEYNO));
		mv.addObject("billList_sub", Component.getList("sfabill.SuppliedSelect", UI_KEYNO));

		return mv;
	}

	/*
	 * 세금계산서 작성 탭
	 **/
	@RequestMapping(value = "/sfa/safe/billsAdmin.do")
	public ModelAndView safebill(HttpServletRequest req) throws Exception {

		ModelAndView mv = new ModelAndView("/user/_SFA/bill/prc_bill_write_pb");

		
		Map<String, Object> user = CommonService.getUserInfo(req);
		String UI_KEYNO = user.get("UI_KEYNO").toString();
		
		//homekey 조합 후 table에 Insert
		String homekey = Component.getData("sfabill.KeyTable_YN", UI_KEYNO);
		
		//id에 homekey가 없으면 Insert
		if(homekey == null) {
			HashMap<String, Object> keytable = new HashMap<String, Object>();
			String UI_input = UI_KEYNO.replace("_", "");
			String codestr =  UI_input+"1";	
			
			keytable.put("kt_UI_KEYNO", UI_KEYNO);
			keytable.put("kt_homekey", codestr);
			
			Component.createData("sfabill.homekey_Insert", keytable);
		}
		
		mv.addObject("billList", Component.getList("sfabill.billsSelect", UI_KEYNO));
		mv.addObject("SuppliedList", Component.getList("sfabill.SuppliedSelect", UI_KEYNO));
		mv.addObject("loglist", Component.getList("sfabill.billslogselect",UI_KEYNO));
		mv.addObject("loglist3", Component.getListNoParam("sfabill.logList3"));

		String now = new SimpleDateFormat("yyyyMMdd").format(Calendar.getInstance().getTime());
		String nowdate = now.replace("-", "");
		String nowdate2 = nowdate.trim();
		String mmdd = new SimpleDateFormat("MMdd").format(Calendar.getInstance().getTime());
		String month = new SimpleDateFormat("MM").format(Calendar.getInstance().getTime());
		String year = new SimpleDateFormat("yyyy").format(Calendar.getInstance().getTime());
		String year2 = year.substring(2, year.length());

		mv.addObject("mmdd", mmdd);
		mv.addObject("nowDate", nowdate2);
		mv.addObject("itemName", year2 + "." + month + "월분 전기안전관리비");
		mv.addObject("UI_KEYNO", UI_KEYNO);

		return mv;
	}

	/*
	 * 세금계산서 전송현황 탭
	 **/
	@RequestMapping(value = "/sfa/safe/billsAdminLog.do")
	public ModelAndView safebilllog(HttpServletRequest req) throws Exception {

		ModelAndView mv = new ModelAndView("/user/_SFA/bill/prc_bill_log_pb");

		return mv;
	}

	/*
	 * 세금계산서 전송현황 탭
	 **/
	@RequestMapping(value = "/sfa/safe/safeAdminLog.do")
	public ModelAndView safeAdminlog(HttpServletRequest req) throws Exception {

		ModelAndView mv = new ModelAndView("/user/_SFA/safe/prc_admin_log_pb");

		return mv;
	}

	/*
	 * 안전관리 작성 양식 선택 Ajax
	 **/
	@RequestMapping(value = "/sfa/safeAdmin/safefunAjax.do")
	@ResponseBody
	public ModelAndView safeAdminSelectAjax(HttpServletRequest req,
			@RequestParam(value = "PC_PI_KEYNO", required = false) String PC_PI_KEYNO) throws Exception {

		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> user = CommonService.getUserInfo(req);
		String UI_KEYNO = user.get("UI_KEYNO").toString();

		
		String url = "";
		String now = new SimpleDateFormat("yyyy년 MM월 dd일 hh시 mm분").format(Calendar.getInstance().getTime());
		String year = new SimpleDateFormat("yyyy").format(Calendar.getInstance().getTime());
		String mon = new SimpleDateFormat("MM").format(Calendar.getInstance().getTime());
	

		String yearMin = "2020";
		String yearMax = year+1;
		
		
		
		if(PC_PI_KEYNO.equals("UI_JUN")){
			url = "/user/_SFA/template/skin/prc_sfa_electro";
		}
		mv.addObject("safeuserlist", Component.getList("sfa.safeuserselect", UI_KEYNO));
		mv.addObject("now", now);
		mv.setViewName(url);
		return mv;
	}

	/*
	 * 공급자 등록 페이지 공급자 정보 수정/삭제 select
	 **/
	@RequestMapping("/bills/providerSelectAjax.do")
	@ResponseBody
	public HashMap<String, Object> providerSelectAjax(HttpServletRequest req,
			@RequestParam(value = "dbp_keyno") String dbp_keyno) throws Exception {

		HashMap<String, Object> map = Component.getData("sfabill.billsSelect_one", dbp_keyno);

		return map;
	}

	/*
	 * 공급받는자 등록 페이지 공급받는자 정보 수정/삭제 select, 세금계산서 작성페이지 공급받는자 select
	 **/
	@RequestMapping("/sfa/bills/supliedSelectAjax.do")
	@ResponseBody
	public HashMap<String, Object> supliedSelectAjax(HttpServletRequest req,
			@RequestParam(value = "dbs_keyno") String dbs_keyno) throws Exception {

		HashMap<String, Object> map = Component.getData("sfabill.SuppliedSelect_one", dbs_keyno);

		return map;
	}

	/*
	 * 공급자 등록 ajax
	 **/
	@RequestMapping("/sfa/bills/billsActionAjax.do")
	@ResponseBody
	public String billsActionAjax(HttpServletRequest req, safebillDTO bill,
			@RequestParam(value = "buttionType", defaultValue = "insert") String type) throws Exception {

		String msg = "";

		if (type.equals("update")) {
			Component.updateData("sfabill.billsProvideUPdate", bill);
			msg = "수정이 완료 되었습니다.";
		} else {
			// 등록된 사업자등록번호 확인
			int count = Component.getCount("sfabill.billCount", bill);

			if (count > 0) {
				msg = "사업자 등록 번호가 이미 등록되어있습니다.";
			} else {
				Component.createData("sfabill.billsProvideInsert", bill);
				msg = "등록이 완료 되었습니다.";
			}
		}

		return msg;
	}

	/*
	 * 공급받는자 등록 ajax
	 **/
	@RequestMapping("/sfa/bills/billsActionAjax2.do")
	@ResponseBody
	public String billsActionAjax2(HttpServletRequest req, safebillDTO bill,
			@RequestParam(value = "buttionType2", defaultValue = "insert") String type) throws Exception {

		String msg = "";

		if (type.equals("update")) {
			Component.updateData("sfabill.billsProvideUPdate2", bill);
			msg = "수정이 완료 되었습니다.";
		} else {
			// 등록된 사업자등록번호 확인
			int count = Component.getCount("sfabill.billCount2", bill);

			if (count > 0) {
				msg = "사업자 등록 번호가 이미 등록되어있습니다.";
			} else {
				Component.createData("sfabill.billsProvideInsert2", bill);
				msg = "등록이 완료 되었습니다.";
			}
		}

		return msg;
	}

	/*
	 * 공급자 삭제 ajax
	 **/
	@RequestMapping("/sfa/bills/prodelete.do")
	@ResponseBody
	public String prodelete(HttpServletRequest req, @RequestParam(value = "dbp_keyno") String dbp_keyno)
			throws Exception {

		Component.deleteData("sfabill.proDelete", dbp_keyno);

		String msg = "공급자 삭제 완료";

		return msg;

	}

	/*
	 * 공급받는자 삭제 ajax
	 **/
	@RequestMapping("/sfa/bills/supdelete.do")
	@ResponseBody
	public String supdelete(
			HttpServletRequest req, @RequestParam(value = "dbs_keyno") String dbs_keyno
			)
			throws Exception {

		Component.deleteData("sfabill.supDelete", dbs_keyno);

		String msg = "공급받는자 삭제 완료";

		return msg;

	}

	/*
	 * 세금계산서 작성페이지 공급자, 공급받는자 따라오는 ajax
	 **/
	@RequestMapping("/dyAdmin/bills/proAndSupSelect2.do")
	@ResponseBody
	public HashMap<String, Object> proAndSupSelect(HttpServletRequest req,
			@RequestParam(value = "dbp_keyno") String dbp_keyno,
			@RequestParam(value = "dbl_sub_keyno") String dbl_sub_keyno) throws Exception {

		
		Map<String, Object> user = CommonService.getUserInfo(req);
		String UI_KEYNO = user.get("UI_KEYNO").toString();
		HashMap<String, Object> map = new HashMap<String, Object>();
		HashMap<String, Object> map2 = new HashMap<String, Object>();
		
		
		if (dbl_sub_keyno.equals("1")) {
			map = Component.getData("sfabill.proAndSupSelect1", dbp_keyno);
		} else if (dbl_sub_keyno.equals("2")) {
			map = Component.getData("sfabill.proAndSupSelect2", dbp_keyno);
		} else {
			map = Component.getData("sfabill.proAndSupSelect3", dbp_keyno);
		}

		//homeid 조합식
		String codeStr = "";
		String homekey = Component.getData("sfabill.homekey", UI_KEYNO);
		String codenum = homekey.substring(7,homekey.length());
		int tempc = Integer.parseInt(codenum) + 1 ;
		String code =  homekey.substring(0,7);
		codeStr = code+tempc;
		
		
		//homekey 테이블 업데이트
		map2.put("key", codeStr);
		map2.put("kt_UI_KEYNO", UI_KEYNO);
		Component.updateData("sfabill.changeHomekey", map2);
		
		
		
		map.put("dbl_homeid", codeStr);

		return map;
	}

	/*
	 * 세금계산서 정보 저장
	 **/
	@RequestMapping("/dyAdmin/bills/billsInfoInsert3sfa.do")
	@ResponseBody
	public String billsInfoIsnsertAjax3(HttpServletRequest req, safebillDTO bill) throws Exception {

		String msg = "";
//		String keyno = Component.getData("sfabill.billLogCount", bill);

		// 공급자 공급받는자 등록 확인
//		if (keyno != null && keyno != "") {

			// 공급자 공급받는자 중복된 것중 국세청 전송여부 확인
//			String chkYN = Component.getData("sfabill.checkYNselect", keyno);

//			if (chkYN.equals("Y")) {
//				msg = "1";
//			} else if (chkYN.equals("N")) {
//				msg = keyno;
//			}
//		} else {
		Component.createData("sfabill.subkey3Insert", bill);
		Component.updateData("sfabill.registNumberUpdate", bill);
		Component.createData("sfabill.billsInfoInsert", bill);
		msg = "저장 완료";
//		}

		return msg;

	}

	/*
	 * 세금계산서 정보 수정
	 **/
	@RequestMapping("/dyAdmin/bills/billsInfoUpdate2.do")
	@ResponseBody
	public String billsInfoUpdateAjax(HttpServletRequest req, safebillDTO bill) throws Exception {

		Component.updateData("sfabill.billsInfoUpdate", bill);

		String msg = "세금계산서 정보 수정 완료";

		return msg;

	}

	/*
	 * 세금계산서 정보 삭제
	 **/
	@RequestMapping("/dyAdmin/bills/deleteInfo2.do")
	@ResponseBody
	public String deleteInfo(HttpServletRequest req, @RequestParam(value = "chkvalue") String dbl_keyno)
			throws Exception {

		HashMap<String, Object> map = new HashMap<String, Object>();
		String msg = "";
		String[] dblkey = dbl_keyno.split(",");

		map.put("dblkey", dblkey);

		Component.deleteData("sfabill.billsDelete", dblkey);

		return msg;

	}

	/*
	 * 세금계산서 정보 보기
	 **/
	@RequestMapping("/dyAdmin/bills/selectAllView2.do")
	@ResponseBody
	public safebillDTO selectAllView(HttpServletRequest req, safebillDTO bill) throws Exception {

		Map<String, Object> user = CommonService.getUserInfo(req);
		String UI_KEYNO = user.get("UI_KEYNO").toString();
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		bill = Component.getData("sfabill.selectAllView", bill);
		
		
		//homeid 조합식
//		String codeStr = "";
//		String homekey = Component.getData("sfabill.homekey",UI_KEYNO);
//		String codenum = homekey.substring(7,homekey.length());
//		int tempc = Integer.parseInt(codenum) + 1 ;
//		String code =  homekey.substring(0,7);
//		codeStr = code+tempc;
		
		//homekey 테이블 +1수치 업데이트
//		map.put("key", codeStr);
//		map.put("kt_UI_KEYNO", UI_KEYNO);
//		Component.updateData("sfabill.changeHomekey", map);
		
		
		//homeid select(수정 전)
		//HashMap<String, Object> code = Component.getData("bills.CodeNumberSelect", bill);
			
		
//		HashMap<String, Object> code = Component.getData("sfabill.CodeNumberSelect", bill);
//		String codeStr = "";
//		codeStr = code.get("dbl_homeid").toString();
//		String codenum = codeStr.substring(7, codeStr.length());
//		int tempc = Integer.parseInt(codenum) + 1;
//		String code1 = bill.getDbp_co_num().toString().substring(3, 6);
//		String codeapi = bill.getDbp_apikey().toString();
//		String code2 = codeapi.substring(codeapi.length() - 6, codeapi.length() - 2);
//		codeStr = code1 + code2 + tempc;

//		bill.setDbl_homeid(codeStr);

		return bill;

	}

	/*
	 * 세금계산서 리스트 페이징 ajax
	 **/
	@RequestMapping(value = "/sfa/bills/pagingAjaxSFA.do")
	public ModelAndView listViewPaging3(HttpServletRequest req, Common search) throws Exception {

		ModelAndView mv = new ModelAndView("/user/_SFA/bill/pra_bills_writePaging_pb");

		Map<String, Object> user = CommonService.getUserInfo(req);
		String UI_KEYNO = user.get("UI_KEYNO").toString();
		
		List<HashMap<String, Object>> searchList = Component.getSearchList(req);

		Map<String, Object> map = CommonService.ConverObjectToMap(search);

		map.put("UI_KEYNO", UI_KEYNO);
		
		if (searchList != null) {
			map.put("searchList", searchList);
		}

		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(), "sfabill.Log_getListCnt3", map,
				search.getPageUnit(), 10);

		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		

		mv.addObject("paginationInfo", pageInfo);

		List<HashMap<String, Object>> resultList = Component.getList("sfabill.Log_getList3", map);
		mv.addObject("resultList3", resultList);
		mv.addObject("search", search);
		return mv;
	}

	/*
	 * 세금계산서 전송
	 **/
	@RequestMapping("/dyAdmin/bills/sendNTS2.do")
	@ResponseBody
	public void sendNTS(HttpServletRequest req, safebillDTO bill, @RequestParam(value = "chkvalue") String dbl_keyno,
			@RequestParam(value = "checkYN") String checkYN) throws Exception {

		String[] list = dbl_keyno.split(",");
		String[] list1 = checkYN.split(",");

		for (int i = 0; i < list.length; i++) {

			// 전송 Y/N 체크
			Component.updateData("sfabill.checkYN", list[i]);

			bill = Component.getData("sfabill.selectAllView", list[i]);

			sendApi(bill);
			
		}

		return;
	}

	// 실패 로그 확인 메세지
	@RequestMapping(value = "/dyAdmin/bills/sendingAjax2.do")
	@ResponseBody
	public String sendMSG(HttpServletRequest req, @RequestParam(value = "keyno") String keyno) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("dbl_keyno", keyno);
		map = Component.getData("sfabill.ErrorrMsg", map);

		String msg = (String) map.getOrDefault(("dbl_errormsg").toString(), "에러");

		return msg;
	}

	// 전송결과 확인
	@RequestMapping("/billsResultTest2.do")
	@ResponseBody
	public String billsResultTest(HttpServletRequest req) throws Exception {

		String msg2 = "";
		Map<String, Object> user = CommonService.getUserInfo(req);
		String UI_KEYNO = user.get("UI_KEYNO").toString();

		List<safebillDTO> result = Component.getList("sfabill.LogResultNeedData",UI_KEYNO);

		for (safebillDTO r : result) {

			String msg = "";
			String status = "-1";
			String chYn = "N";

			// 입력할 세금계산서 정보를 배열에 추가(JSONObject객체와 순서가 일치해야함.)
			List<List<String>> taxinfo = new ArrayList<>();
			taxinfo.add(Arrays.asList(r.getDbp_id(), r.getDbp_pass(), r.getDbp_apikey(), r.getDbl_homeid()));

			// JSONObject객체 생성
			JSONObject data = new JSONObject();

			// JSONObject객체에 세금계산서 정보를 추가
			data.put("hometaxbill_id", taxinfo.get(0).get(0)); // 회사코드
			data.put("spass", taxinfo.get(0).get(1)); // 패스워드
			data.put("apikey", taxinfo.get(0).get(2)); // 인증키
			data.put("homemunseo_id", taxinfo.get(0).get(3)); // 고유번호

			// 전자세금계산서 발행 후 리턴
			String restapi = RestApiSample_getpkey.Api("https://www.hometaxbill.com:8084/homtax/getpkey",
					data.toString());

			if (restapi.equals("fail")) {
				System.out.println("https://www.hometaxbill.com:8084/homtax/getpkey 서버에 문제가 발생했습니다.");
			}

			// Api에서 리턴받은 값으로 예외처리 및 출력
			JSONParser parser = new JSONParser();
			Object obj = parser.parse(restapi);
			JSONObject jsonObj = (JSONObject) obj;

			HashMap<String, String> Hlist = new LinkedHashMap<>();

			Hlist.put("code", (String) jsonObj.get("code"));
			Hlist.put("msg", (String) jsonObj.get("msg"));
			Hlist.put("msg2", (String) jsonObj.get("msg2"));
			Hlist.put("hometaxbill_id", (String) jsonObj.get("hometaxbill_id"));
			Hlist.put("homemunseo_id", (String) jsonObj.get("homemunseo_id"));
			Hlist.put("issueid", (String) jsonObj.get("issueid"));
			Hlist.put("declarestatus", (String) jsonObj.get("declarestatus"));

			if (!restapi.equals("fail")) {
				if (Hlist.get("issueid") != null) {
					System.out.println(r.getDbp_name() + ": 성공");
					msg = Hlist.get("msg").toString() + Hlist.get("msg2").toString();
					if (msg.contains("성공")) {
						status = "0";
						chYn = "Y";
					}
				} else {
					System.out.println(r.getDbp_name() + ": 실패");
					msg = (String) jsonObj.get("msg");
					System.out.println(
							"code : " + (String) jsonObj.get("code") + "\n" + "msg : " + (String) jsonObj.get("msg"));
				}
			} else {
				msg = "서버 호출 실패";
			}
			r.setDbl_status(status);
			r.setDbl_errormsg(msg);
			r.setDbl_checkYN(chYn);
			Component.updateData("sfabill.ChangeLogmsg", r);
		}
		return msg2;
	}

	/*
	 * 관리자 페이지 문자전송 페이지
	 **/
	@RequestMapping(value = "/txap/alim/message.do")
	public ModelAndView sendMessage(HttpServletRequest req, @ModelAttribute UserDTO UserDTO) throws Exception {

		ModelAndView mv = new ModelAndView("/sfa/Admin/prc_safe_Message.adm");

		mv.addObject("authList", Component.getListNoParam("Authority.UIA_GetList_message"));
//			mv.addObject("kakao",Component.getListNoParam("main.Kakaotalk"));
		return mv;
	}

	/*
	 * 문자 전송 기능
	 **/
	@RequestMapping("/sendMessage2.do")
	@ResponseBody
	public <E> String MessagesendAjax(HttpServletRequest req,
			@RequestParam(value = "UI_KEYNO", required = false) String user,
			@RequestParam(value = "content", required = false) String content) throws Exception {

		String[] userlist = user.split(",");

		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("userlist", userlist);

		String msg1 = "성공";

		String userid = "daeyang";
		String api = "qcp255q389pcsb3ddunfcb7ys93kbnli";
		String destination = user;
		String receiver = "";
		String msg = content;
		String image= "";
		
		List<UserDTO> list = Component.getList("sfa.Message_ad", map);

		for (UserDTO l : list) {
			l.decode();
			receiver = l.getUI_PHONE().toString().replace("-", "");
			destination = l.getUI_NAME().toString();
			requestAPI.sendMessage(userid, api, destination, receiver, msg, image);
		}

		return msg1;
	}

	/*
	 * 문자 전송 시 회원선택
	 **/
	@RequestMapping("/userkakakoselectAjax2.do")
	@ResponseBody
	public List<UserDTO> MessageuserselectAjax(HttpServletRequest req,
			@RequestParam(value = "UIA_KEYNO", required = false) String UIA_KEYNO) throws Exception {

		List userlist;

		if (UIA_KEYNO.equals("") || UIA_KEYNO == null) {
			List<UserDTO> list = Component.getListNoParam("sfa.Group_select_all");
			userlist = list;

		} else {
			List<UserDTO> list = Component.getList("sfa.Group_select", UIA_KEYNO);
			userlist = list; 
		}

//		    	List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
//		    	HashMap<String, Object> map = new HashMap<String, Object>();

		return userlist;
	}

	/*
	 * 관리자 페이지 발전소 등록 페이지
	 **/
	@RequestMapping(value = "/dyAdmin/safe/user.do")
	public ModelAndView UserInsert(HttpServletRequest req, @ModelAttribute UserDTO UserDTO) throws Exception {

		ModelAndView mv = new ModelAndView("/user/_SFA/safe/prc_admin_userInsert.adm");
		Map<String, Object> user = CommonService.getUserInfo(req);
		String UI_KEYNO = user.get("UI_KEYNO").toString();
		
		
		mv.addObject("safeuserlist", Component.getList("sfa.safeuserselect", UI_KEYNO));
		mv.addObject("monitering", Component.getListNoParam("sfa.monitering_Select"));
		mv.addObject("UI_KEYNO", UI_KEYNO);
		
		return mv;
	}
	
	/*
	 * 관리자 페이지 발전소 등록/수정
	 **/
	@RequestMapping("/sfa/safe/UserActionAjax.do")
	@ResponseBody
	public String UserInsertAjax(HttpServletRequest req, safeUserDTO user,
			@RequestParam(value = "buttionType2", defaultValue = "insert") String type) throws Exception {

		String msg = "";

		if (type.equals("update")) {
			Component.updateData("sfa.safeUserUPdate", user);
			System.out.println(user);
			msg = "수정이 완료 되었습니다.";
		} else {
			Component.createData("sfa.safeUserInsert", user);
			msg = "등록이 완료 되었습니다.";	
		}

		return msg;
	}
	
	/*
	 * 관리자 페이지 발전소 select
	 **/
	@RequestMapping("/sfa/safe/UserSelectAjax.do")
	@ResponseBody
	public HashMap<String, Object> UserSelectAjax(HttpServletRequest req,
			@RequestParam(value = "SU_KEYNO") String SU_KEYNO) throws Exception {

		HashMap<String, Object> map = Component.getData("sfa.safeuserselect_one", SU_KEYNO);

		return map;
	}
	
	/*
	 * 관리자 페이지 발전소 삭제 ajax
	 **/
	@RequestMapping("/sfa/safe/UserDelete.do")
	@ResponseBody
	public String USerDeleteAjax(HttpServletRequest req, @RequestParam(value = "SU_KEYNO") String SU_KEYNO)
			throws Exception {

		Component.updateData("sfa.safeUserDel_YN", SU_KEYNO);

		String msg = "발전소 삭제 완료";

		return msg;

	}
	
	/*
	 * 관리자 페이지 발전소 invert대수 자동완성 ajax
	 **/
	@RequestMapping("/sfa/safe/Inverternum.do")
	@ResponseBody
	public HashMap<String,Object> Inverternum(HttpServletRequest req, @RequestParam(value = "DPP_KEYNO") String DPP_KEYNO)
			throws Exception {

		HashMap<String, Object> map = Component.getData("sfa.InverterDPP_Select", DPP_KEYNO);

		return map;

	}
	
	/*
	 * 관리자 페이지 발전소 리스트 페이징 ajax
	 **/
	 @RequestMapping(value="/sfa/sfaAdmin/USerpagingAjax.do")
		public ModelAndView UserPaging(HttpServletRequest req,
				Common search
				, @RequestParam(value="UI_ID",required=false) String UI_ID
				, @RequestParam(value="AH_HOMEDIV_C",required=false) String AH_HOMEDIV_C
				) throws Exception {
			
			ModelAndView mv  = new ModelAndView("/user/_SFA/safe/prc_admin_userlogpaging");

			List<HashMap<String,Object>> searchList = Component.getSearchList(req);
			
			Map<String,Object> map = CommonService.ConverObjectToMap(search);
			
			Map<String, Object> user = CommonService.getUserInfo(req);
			String UI_KEYNO = user.get("UI_KEYNO").toString();
			
			
			
			if(searchList != null){
				map.put("searchList", searchList);
			}
			
			
			
			map.put("AH_HOMEDIV_C", AH_HOMEDIV_C);
			map.put("UI_ID", UI_ID);
			map.put("SU_UI_KEYNO", UI_KEYNO);
			
			PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"sfa.safeUser_getListCnt",map, search.getPageUnit(), 10);
			
			map.put("firstIndex", pageInfo.getFirstRecordIndex());
			map.put("lastIndex", pageInfo.getLastRecordIndex());
			map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
			
			mv.addObject("paginationInfo", pageInfo);
			
			List<HashMap<String,Object>> resultList = Component.getList("sfa.safeUser_getList", map); 
			mv.addObject("resultList4", resultList);
			mv.addObject("search", search);
			return mv;
		}
	 
	 	/**
		 * 전송 여부 check를 위한 데이터 뽑기
		 */
	 	@SuppressWarnings("unused")
		@ResponseBody
		@RequestMapping(value="/sfa/Admin/KaKaoSelect.do")
		public List AlimTalkSelect(HttpServletRequest req
				,@ModelAttribute UserDTO UserDTO
				,@RequestParam(value="SU_KEYNO",defaultValue="") String SU_KEYNO
				,@RequestParam(value="chkvalue",defaultValue="") String chkvalue
				) throws Exception {
			
	 		List userlist = null;
	 		
	 		if(SU_KEYNO != null || SU_KEYNO != "") {
	 			
	 			String[] list = SU_KEYNO.split(",");
	 			
	 			for(int i = 0; i<list.length; i++) {
	 				List<UserDTO> list2 = Component.getList("sfa.safeuserselect_one", list[i]);
	 				userlist = list2;
	 			}
	 		}else if(chkvalue != null || chkvalue != "") {
	 			
	 			String[] list = chkvalue.split(",");
	 			
	 			for(int i = 0; i<list.length; i++) {
	 				List<UserDTO> list2 = Component.getList("sfa.safeuserselect_one", list[i]);
	 				userlist = list2;
	 			}
	 			
	 		}
			
			
			return userlist;
		}

		/**
		 * 카카오톡 전송 여부 check N
		 */
		@ResponseBody
		@RequestMapping(value="/sfa/Admin/KakaoTalkCheckN.do")
		public String KakaoTalkCheckN(HttpServletRequest req
				,@ModelAttribute UserDTO UserDTO
				,@RequestParam(value="SU_KEYNO",defaultValue="") String SU_KEYNO
				) throws Exception {
			
			String[] list = SU_KEYNO.split(",");
			
			
			String msg = "";
			for(int i = 0; i<list.length; i++) {
				Component.updateData("sfa.kakaoupdateN", list[i]);
				msg = "알림 전송 예약이 취소되었습니다.";
			}
			
			
			return msg;
		}
		
		/**
		 * 카카오톡 전송 여부 check Y
		 */
		@ResponseBody
		@RequestMapping(value="/sfa/Admin/KakaoTalkCheckY.do")
		public String KakaoTalkCheckY(HttpServletRequest req
				,@ModelAttribute UserDTO UserDTO
				,@RequestParam(value="SU_KEYNO",defaultValue="") String SU_KEYNO
				) throws Exception {
			
			String[] list = SU_KEYNO.split(",");
			
			
			String msg = "";
			for(int i = 0; i<list.length; i++) {
				Component.updateData("sfa.kakaoupdateY", list[i]);
				msg = "알림 전송 예약이 설정되었습니다.";
			}
			
			
			return msg;
		}
		
		/*
		 * 카카오톡 전송여부 전체 Y
		 **/
		@RequestMapping("/sfa/Admin/AllCheckY.do")
		@ResponseBody
		public void KakaoTalkAllCheckY(HttpServletRequest req,
				@RequestParam(value = "chkvalue") String su_keyno
				) throws Exception {

			String[] list = su_keyno.split(",");

			for (int i = 0; i < list.length; i++) {

				Component.updateData("sfabill.checkYN", list[i]);
			}

			return;
		}
		
		/*
		 * 카카오톡 전송여부 전체 N
		 **/
		@RequestMapping("/sfa/Admin/AllCheckN.do")
		@ResponseBody
		public void KakaoTalkAllCheckN(HttpServletRequest req,
				@RequestParam(value = "chkvalue") String su_keyno
				) throws Exception {

			String[] list = su_keyno.split(",");

			for (int i = 0; i < list.length; i++) {

				Component.updateData("sfabill.checkYN", list[i]);
			}

			return;
		}
		/**
		 * 메시지 전송 여부 check N
		 */
		@ResponseBody
		@RequestMapping(value="/sfa/Admin/MsgCheckN.do")
		public String MsgCheckN(HttpServletRequest req
				,@ModelAttribute UserDTO UserDTO
				,@RequestParam(value="SU_KEYNO",defaultValue="") String SU_KEYNO
				) throws Exception {
			
			String[] list = SU_KEYNO.split(",");
			
			
			String msg = "";
			for(int i = 0; i<list.length; i++) {
				Component.updateData("sfa.msgupdateN", list[i]);
				msg = "알림 전송 예약이 취소되었습니다.";
			}
			
			
			return msg;
		}
		
		/**
		 * 메시지 전송 여부 check Y
		 */
		@ResponseBody
		@RequestMapping(value="/sfa/Admin/MsgCheckY.do")
		public String MsgCheckY(HttpServletRequest req
				,@ModelAttribute UserDTO UserDTO
				,@RequestParam(value="SU_KEYNO",defaultValue="") String SU_KEYNO
				) throws Exception {
			
			String[] list = SU_KEYNO.split(",");
			
			
			String msg = "";
			for(int i = 0; i<list.length; i++) {
				Component.updateData("sfa.msgupdateY", list[i]);
				msg = "알림 전송 예약이 취소되었습니다.";
			}
			
			
			return msg;
		}
		
		/*
		 * 카카오톡 전송 여부 전체 체크
		 **/
		@RequestMapping("/sfa/Admin/kakaoallcheck.do")
		@ResponseBody
		public void KakaoAllcheck(HttpServletRequest req, safebillDTO bill,
				@RequestParam(value = "chkvalue") String su_keyno) throws Exception {

			String[] list = su_keyno.split(",");
			

			for (int i = 0; i < list.length; i++) {

				Component.updateData("sfa.kakaoupdateY", list[i]);

			}

			return;
		}
		
	/*
	 * 안전관리 기록표 저장
	 **/
	@RequestMapping("/sfa/safe/safepaperInsert.do")
	@ResponseBody
	public String SafePaperInsert(HttpServletRequest req, safeAdminDTO bill) throws Exception {

		String msg = "";

		Component.createData("sfa.sapaperInsert", bill);
		msg = "등록이 완료 되었습니다.";

		return msg;
	}
	
	/*
	 * 대양에스코 안전관리 기록표 저장
	 **/
	@RequestMapping("/sfa/safe/safepaper2Insert.do")
	@ResponseBody
	public String SafePaper2Insert(HttpServletRequest req, safeAdminDTO bill) throws Exception {

		String msg = "";

		Component.createData("sfa.sapaper2Insert", bill);
//		System.out.println(bill);
		
//		msg = Component.getData("sfa.paperpreview", bill);
		
		msg = "저장이 완료되었습니다";


		return msg;
	}

	/*
	 * 안전관리 기록표 수정
	 **/
	@RequestMapping("/sfa/safeAdmin/safeAdminUpdate2.do")
	@ResponseBody
	public String SafePaperUpdate(HttpServletRequest req, safeAdminDTO bill) throws Exception {

		String msg = "";

		Component.updateData("sfa.sapaperUpdate2", bill);
		
		msg = "수정이 완료 되었습니다.";
//					 }
//				 }

		return msg;
	}

	/*
	 * 발전소 정보 자동작성 AJAX
	 **/
	@RequestMapping("/sfa/safe/safeuserselect.do")
	@ResponseBody
	public HashMap<String, Object> SafeUserInfoSelect(HttpServletRequest req, safeAdminDTO bill,
			@RequestParam(value = "SU_KEYNO") String SU_KEYNO
			,@RequestParam(value = "UIKEYNO") String UIKEYNO
			,@RequestParam(value = "formatDate") String formatDate
			) throws Exception {

		HashMap<String, Object> map = new HashMap<String, Object>();
		HashMap<String, Object> map2 = new HashMap<String, Object>();
		HashMap<String, Object> map3 = new HashMap<String, Object>();
		map3.put("SU_KEYNO", SU_KEYNO);
		map3.put("formatDate", formatDate);

		map2 = Component.getData("sfa.preDataSelect",SU_KEYNO);
		
		////첫작성시 데이터 없을때 빈map으로 return
		if(map2 == null) {
			map2 = new HashMap<>();
		}
		
		map.put("data", Component.getData("sfa.pre_next_select", SU_KEYNO));		
		map.put("count", Component.getData("sfa.safeWritecount",SU_KEYNO));		
		map.put("predate", Component.getData("sfa.preDateSelect",SU_KEYNO));
		map.put("datediff", Component.getData("sfa.dateDiff",SU_KEYNO));
		map.put("preData", map2);
		map.put("lastday", Component.getData("sfa.lastday"));
		map.put("prewatt", Component.getData("sfa.preWattSelect",map3));
		map.put("InverterData", Component.getList("sfa.InverterData_Select",SU_KEYNO));
		List<Object> currentData = Component.getList("sfa.CurrentData", SU_KEYNO);
		//첫작성시 데이터 없을때 빈배열로 return
		map.put("CurrentData", currentData != null ? currentData : Collections.emptyList());

		
		return map;
	}

	
	/*
	 * 저장 시 문자 or 카톡 전송 기능
	 **/
	@RequestMapping(value = "/sfa/Admin/sendAilmaAjax.do", produces = "application/text; charset=utf8")
	@ResponseBody
	public <E> String sendAilmAjax(
			@RequestParam(value = "SU_KEYNO") String SU_KEYNO,
			@RequestParam(value = "imgSrc") String binaryData,
			@RequestParam(value = "sa_writetype") String writetype,
			safeUserDTO safeuser,
			safeAdminDTO safeAdmin,
			@RequestParam HashMap<Object, Object> param, 
			HttpServletRequest request, 
			HttpServletResponse response) throws Exception {
		
		SiteManagerDTO site = new SiteManagerDTO();
		
		safeuser = Component.getData("sfa.safeuserselect_alim", SU_KEYNO);
		
		//캡쳐 부분
		ModelMap map = new ModelMap();
		
		FileOutputStream stream = null;
		
		System.out.println("binary file   "  + binaryData);
		if(binaryData == null || binaryData.trim().equals("")) {
		    throw new Exception();
		}
		binaryData = binaryData.replaceAll("data:image/jpeg;base64,", "");
		byte[] file = Base64.decodeBase64(binaryData);
		String fileName=  UUID.randomUUID().toString();
		
		String filePath = SiteProperties.getString("FILE_PATH") + fileName + ".jpeg";
		System.out.println(filePath);
		stream = new FileOutputStream(filePath);
		stream.write(file);
		stream.close();
		System.out.println("캡처 저장");
		    
		if(stream != null) {
			stream.close();
		}
		
		map.addAttribute("resultMap", "");
		
//		//안전관리 양식 정보 저장(양식별로 구분 해서 저장)
		if(writetype.equals("1")) {		
			Component.createData("sfa.sapaperInsert", safeAdmin);			
		}else if(writetype.equals("2")) {
			Component.createData("sfa.sapaper2Insert", safeAdmin);
		}
		
		String msg1 = "";
		
		String sulbiname = safeuser.getSU_SA_SULBI().toString();
		
		//문자 o, 카톡 o
		if(safeuser.getSU_SA_MSGYN().equals("Y") && safeuser.getSU_SA_KAKAOYN().equals("Y")){
			
			msg1 = "카카오톡, 문자메시지 전송 완료";
			String msg = "대양에스코 안전관리 점검 결과 안내\n"
							+sulbiname+ "의 안전관리점검 결과를 이미지로 보내드립니다.\n"
							+ "안전 관리 관련 문의\n"
							+ "안전관리자 : 이민환\n"
							+ "연락처 : 061-332-8086\n";
						
			String userid = "daeyang";
			String api = "qcp255q389pcsb3ddunfcb7ys93kbnli";
			String destination = safeuser.getSU_SA_SULBI().toString();
			
			String SAphone = safeuser.getSU_SA_PHONE1();
			String [] SAphonelist = SAphone.split(",");
			
			
			for(int i =0; i<SAphonelist.length; i++) {
					
					String receiver = SAphonelist[i];
				
//					if(writetype.equals("1")) {		
//						msg = safeAdmin.getSa_opinion();							
//					}else if(writetype.equals("2")) {			
//						msg = safeAdmin.getSa2_opinion();
//					}
					String image = filePath;
					
					requestAPI.sendMessage(userid, api, destination, receiver, msg, image);
					
					
					String pname = safeAdmin.getSa2_title();
					String sname = safeAdmin.getSa2_date();
					String subject = safeAdmin.getSa2_adminname();
					String grandtotal = safeAdmin.getSa2_problem();
					String issuedate = safeAdmin.getSa2_opinion();
					String admin = "대양기업 안전관리자";
					String adminphone = "061-332-8086";
					
					
					//이상유무 처리
					if(grandtotal.equals("1")) {
						grandtotal = "이상 유";
					}else{
						grandtotal = "이상 무";
					}
					
					//종합의견 처리
					if(issuedate.equals("") || issuedate == null) {
						issuedate = "발전소 이상없이 정상 작동 중";
					}
					
					String contents = "[안전 관리 점검 결과 안내]\n" + pname + "의 안전 관리 점검이 완료되었습니다.\n□ 발전소 명 : " + pname
							+ "\n□ 점검일 : " + sname + "\n□ 점검자 : " + subject + "\n□ 이상유무 : " + grandtotal
							+ "\n□ 종합의견 : " + issuedate + "\n\n\n※ 안전 관리 관련 문의\n담당자 : " + admin + "\n연락처 : " + adminphone;
					
					// 토큰받기
					String tocken = requestAPI.TockenRecive(SettingData.Apikey, SettingData.Userid);
					tocken = URLEncoder.encode(tocken, "UTF-8");
					
					// 리스트 뽑기 - 현재 게시물 알림은 index=1
					JSONObject jsonObj2 = requestAPI.KakaoAllimTalkList(SettingData.Apikey, SettingData.Userid,
							SettingData.Senderkey, tocken);
					org.json.simple.JSONArray jsonObj_a2 = (org.json.simple.JSONArray) jsonObj2.get("list");
					jsonObj2 = (JSONObject) jsonObj_a2.get(10); // 템플릿 리스트
					
//					String list = safeuser.getSU_SA_PHONE1();
					String Sendurl = "http://dymonitering.co.kr/";
					
					String phone = SAphonelist[i];
					// 받은 토큰으로 알림톡 전송
					requestAPI.KakaoAllimTalkSend(SettingData.Apikey, SettingData.Userid, SettingData.Senderkey, tocken,
							jsonObj2, contents, phone, Sendurl);
			}
			
			
			
			File file1 = new File(filePath);
			if(file1.delete()) {
				System.out.println("파일삭제 성공");
			}
			
		//문자 o, 카톡 x
		}else if(safeuser.getSU_SA_MSGYN().equals("Y") && safeuser.getSU_SA_KAKAOYN().equals("N")) {
			
			String SAphone = safeuser.getSU_SA_PHONE1();
			String [] SAphonelist = SAphone.split(",");
			
			msg1 = "문자메시지 전송 완료";
			
			for(int i =0; i<SAphonelist.length; i++) {
				
					String msg = "";
					String userid = "daeyang";
					String api = "qcp255q389pcsb3ddunfcb7ys93kbnli";
					String destination = safeuser.getSU_SA_SULBI().toString();
					String receiver = SAphonelist[i];
					if(writetype.equals("1")) {		
						msg = safeAdmin.getSa_opinion();							
					}else if(writetype.equals("2")) {
						msg = safeAdmin.getSa2_opinion();
					}
					String image = filePath;
					
					
					requestAPI.sendMessage(userid, api, destination, receiver, msg, image);
			}
		
			File file1 = new File(filePath);
			if(file1.delete()) {
				System.out.println("파일삭제 성공");
			}
			
		//문자 x, 카톡 o	
		}else if(safeuser.getSU_SA_MSGYN().equals("N") && safeuser.getSU_SA_KAKAOYN().equals("Y")) {
			
			String SAphone = safeuser.getSU_SA_PHONE1();
			String [] SAphonelist = SAphone.split(",");
			
			msg1 = "카카오톡 전송 완료";
			
			for(int i =0; i<SAphonelist.length; i++) {
				
					String pname = safeAdmin.getSa2_title();
					String sname = safeAdmin.getSa2_date();
					String subject = safeAdmin.getSa2_adminname();
					String grandtotal = safeAdmin.getSa2_problem();
					String issuedate = safeAdmin.getSa2_opinion();
					String admin = "대양기업 안전관리자";
					String adminphone = "061-332-8086";
					
					
					//이상유무 처리
					if(grandtotal.equals("1")) {
						grandtotal = "이상 유";
					}else {
						grandtotal = "이상 무";
					}
					
					//종합의견 처리
					if(issuedate.equals("") || issuedate == null) {
						issuedate = "발전소 이상없이 정상 작동 중";
					}
					
					String contents = "[안전 관리 점검 결과 안내]\n" + pname + "의 안전 관리 점검이 완료되었습니다.\n□ 발전소 명 : " + pname
							+ "\n□ 점검일 : " + sname + "\n□ 점검자 : " + subject + "\n□ 이상유무 : " + grandtotal
							+ "\n□ 종합의견 : " + issuedate + "\n\n\n※ 안전 관리 관련 문의\n담당자 : " + admin + "\n연락처 : " + adminphone;
					
					// 토큰받기
					String tocken = requestAPI.TockenRecive(SettingData.Apikey, SettingData.Userid);
					tocken = URLEncoder.encode(tocken, "UTF-8");
					
					// 리스트 뽑기 - 현재 게시물 알림은 index=1
					JSONObject jsonObj2 = requestAPI.KakaoAllimTalkList(SettingData.Apikey, SettingData.Userid,
							SettingData.Senderkey, tocken);
					org.json.simple.JSONArray jsonObj_a2 = (org.json.simple.JSONArray) jsonObj2.get("list");
					jsonObj2 = (JSONObject) jsonObj_a2.get(10); // 템플릿 리스트
					
//					String list = safeuser.getSU_SA_PHONE1();
					String Sendurl = "http://dymonitering.co.kr/";
					
					String phone = SAphonelist[i];
					// 받은 토큰으로 알림톡 전송
					requestAPI.KakaoAllimTalkSend(SettingData.Apikey, SettingData.Userid, SettingData.Senderkey, tocken,
							jsonObj2, contents, phone, Sendurl);
			}
			
			
		//문자 x, 카톡 x
		}else {
			
			msg1 = "선택된 전송 타입이 없습니다. 알림 타입을 선택해주세요.";
		}

		return msg1;
	}
	
	/*
	 * 발전소별 이전 작성 양식 조회(팝업)
	 **/ 
		@RequestMapping(value="/sfa/sfaAdmin/preview.do")
		@ResponseBody
		public Object PopUpController(HttpServletRequest req
			,@RequestParam(value="type") String writetype
			,DateDTO DateDTO) throws Exception {
			
			ModelAndView mv  = new ModelAndView("/sfa/Admin/MainPopup/prc_admin_MainPopup.notiles");
			HashMap<String, Object> map = new HashMap<String, Object>();
			String url = "";
			System.out.println(writetype);
			if(writetype.equals("1")) {
				map = Component.getData("sfa.preview", DateDTO);
				url = "/sfa/Admin/MainPopup/prc_admin_MainPopup.notiles";
			}else if(writetype.equals("2")) {
				map = Component.getData("sfa.preview2", DateDTO);
				url = "/sfa/Admin/MainPopup/prc_admin_MainPopup2.notiles";
			}
			//object로 보냄 getList는 배열, getData는 object 
			
			
			mv.setViewName(url);
			mv.addObject("list",map); //object로 보냄
			
			
			return mv;
		}
		
		/*
		 * 발전소별 이전 작성 데이터 조회 Ajax
		 **/ 
			@RequestMapping(value="/sfa/sfaAdmin/previewAjax.do")
			@ResponseBody
			public List PopUpControllerAjax(HttpServletRequest req
				,DateDTO DateDTO) throws Exception {
				
				HashMap<String, Object> map = new HashMap<String, Object>();			
				
				List userlist;
				
				userlist = Component.getList("sfa.previewData", DateDTO);								
				
				return userlist;
			}
			
			
			/*
			 * 발전소별 이전 작성 데이터 조회 placeholder
			 **/ 
			@RequestMapping(value="/sfa/sfaAdmin/previewplaceholder.do")
			@ResponseBody
			public HashMap<String,Object> previewpalceholder(HttpServletRequest req
				,@RequestParam(value="selectgroup") String selectgroup) throws Exception {
				
				HashMap<String, Object> map = new HashMap<String, Object>();			
				
				
				map.put("placeholder", Component.getData("sfa.placeholderView", selectgroup));			
				map.put("preData", Component.getData("sfa.placeholderPreView",selectgroup));
				
				return map;
			}
			
			/*
			 * 발전소별 이전 작성 양식 조회 Ajax
			 **/ 
			@RequestMapping(value="/sfa/sfaAdmin/prepaperviewAjax.do")
			@ResponseBody
			public Object previewAjax(HttpServletRequest req
				,DateDTO DateDTO
				,@RequestParam(value="sa2_title") String title) throws Exception {
				
				HashMap<String, Object> map = new HashMap<String, Object>();
				
				map = Component.getData("sfa.paperpreview", title);
				
				return map;
			}
				
			
			/*
			 * 안전관리 작성 양식 선택 Ajax
			 **/
			@RequestMapping(value = "/sfa/sfaAdmin/prepaperview.do")
			@ResponseBody
			public ModelAndView prepaperview(HttpServletRequest req,
					@RequestParam(value = "sa2_title", required = false) String title) throws Exception {

				ModelAndView mv = new ModelAndView();
				HashMap<String, Object> map = new HashMap<String, Object>();
				
				map = Component.getData("sfa.paperpreview", title);
				
				String url = "/sfa/Admin/preview/prc_sfa_EscoPreview.notiles";
				
				
				
				mv.addObject("preview", map);
				mv.addObject("safeuserlist", Component.getListNoParam("sfa.safeuserselect"));
				mv.setViewName(url);
				return mv;
			}
			
			
			/*
			 * 자동 저장
			 **/
			@RequestMapping("/sfa/safe/AutoInsert.do")
			@ResponseBody
			public String AutoInsert(HttpServletRequest req, safeAdminDTO user,
					@RequestParam(value = "buttionType2", defaultValue = "insert") String type) throws Exception {

				String msg = "";

				if (type.equals("update")) {
					Component.updateData("sfa.safeUserUPdate", user);
					System.out.println(user);
					msg = "수정이 완료 되었습니다.";
				} else {
					Component.createData("sfa.safeUserInsert", user);
					msg = "등록이 완료 되었습니다.";	
				}

				return msg;
			}
			
//		@RequestMapping("/imageInsert.do")
//		@ResponseBody
//		public String ImageInsert(HttpServletRequest req,
//			@RequestParam(value="sa2_opinion") String MultipartFile) throws Exception {
//
//			String msg = "123";
//			System.out.println(MultipartFile);
////			String prefix = ((org.springframework.web.multipart.MultipartFile) MultipartFile1).getOriginalFilename().substring(((org.springframework.web.multipart.MultipartFile) MultipartFile1).getOriginalFilename().lastIndexOf("."), ((org.springframework.web.multipart.MultipartFile) MultipartFile1).getOriginalFilename().length());
////			String fileName=  UUID.randomUUID().toString()+	prefix;
////		
////		
////			String pathname = propertiesService.getString("resourcePath") + fileName;
////			File dest = new File(pathname);			
////			File folder = new File(pathname);
////			if(!folder.isDirectory()) {
////				folder.mkdirs();
////			}
//			
//			return msg;
//		}
			
			
	/*
	 * 홈택스빌 api 메소드
	 **/
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
	public String sendApi(safebillDTO bill) throws Exception {
		
		String now = new SimpleDateFormat("yyyyMMdd").format(Calendar.getInstance().getTime());
	 	String nowdate = now.replace("-", "");
	 	String nowdate2 = nowdate.trim();
		
		
		// JSONObject객체 생성
		JSONObject data = new JSONObject();

		// JSONObject객체에 세금계산서 정보를 추가
		data.put("hometaxbill_id", bill.getDbp_id()); // 회사코드 (아이디) (사용자코드 1001 *
		data.put("spass", bill.getDbp_pass()); // 패스워드 *
		data.put("apikey", bill.getDbp_apikey()); // 인증키*
		data.put("homemunseo_id", bill.getDbl_homeid()); // 고유번호*
		data.put("signature", bill.getSignature()); // 전자서명

		data.put("issueid", bill.getDbl_issueid()); // 승인번호(자동생성)
		data.put("typecode1", bill.getDbl_typecode1()); // (세금)계산서 종류1*
		data.put("typecode2", bill.getDbl_typecode2()); // (세금)계산서 종류2*
		data.put("description", bill.getDescription()); // 비고
		data.put("issuedate", nowdate2); // 작성일자*

		data.put("modifytype", bill.getModifytype()); // 수정사유-
		data.put("purposetype", bill.getDbl_purposetype()); // 영수/청구 구분*
		data.put("originalissueid", bill.getOriginalissueid()); // 당초전자(세금)계산서 승인번호-
		data.put("si_id", bill.getSi_id()); // 수입신고번호-
		data.put("si_hcnt", bill.getDbl_si_hcnt()); // 수입총건 *

		data.put("si_startdt", bill.getSi_startdt()); // 일괄발급시작일-
		data.put("si_enddt", bill.getSi_enddt()); // 일괄발급종료일-
		data.put("ir_companynumber", bill.getDbp_co_num()); // 공급자 사업자등록번호*
		data.put("ir_biztype", bill.getDbp_biztype()); // 공급자 업태*
		data.put("ir_companyname", bill.getDbp_name()); // 공급자 상호*

		data.put("ir_bizclassification", bill.getDbp_bizclassification()); // 공급자 업종*
		data.put("ir_ceoname", bill.getDbp_ceoname()); // 공급자 대표자성명*
		data.put("ir_busename", bill.getDbp_busename()); // 공급자 담당부서명
		data.put("ir_name", bill.getDbp_ir_name()); // 공급자 담당자명*
		data.put("ir_cell", bill.getDbp_ir_cell()); // 공급자 담당자전화번호*

		data.put("ir_email", bill.getDbp_email()); // 공급자 담당자이메일*
		data.put("ir_companyaddress", bill.getDbp_address()); // 공급자 주소*
		data.put("ie_companynumber", bill.getDbs_co_num()); // 공급받는자 사업자등록번호*
		data.put("ie_biztype", bill.getDbs_biztype()); // 공급받는자 업태*
		data.put("ie_companyname", bill.getDbs_name()); // 공급받는자 사업체명*

		data.put("ie_bizclassification", bill.getDbs_bizclassification()); // 공급받는자 업종*
		data.put("ie_taxnumber", bill.getDbs_taxnum()); // 공급받는자 종사업장번호
		data.put("partytypecode", bill.getDbl_partytypecode()); // 공급받는자 구분 01=사업자등록번호 02=주민등록번호 03=외국인*
		data.put("ie_ceoname", bill.getDbs_ceoname()); // 공급받는자 대표자명*
		data.put("ie_busename1", bill.getDbs_busename1()); // 공급받는자 담당부서1

		data.put("ie_name1", bill.getDbs_name1()); // 공급받는자 담당자명1*
		data.put("ie_cell1", bill.getDbs_cell1()); // 공급받는자 담당자연락처1*
		data.put("ie_email1", bill.getDbs_email1()); // 공급받는자 담당자이메일1*
		data.put("ie_busename2", bill.getDbs_name2()); // 공급받는자 담당부서2
		data.put("ie_name2", bill.getDbs_name2()); // 공급받는자 담당자명2

		data.put("ie_cell2", bill.getDbs_cell2()); // 공급받는자 담당자연락처2
		data.put("ie_email2", bill.getDbs_email2()); // 공급받는자 담당자이메일2
		data.put("ie_companyaddress", bill.getDbs_address()); // 공급받는자 회사주소*
		data.put("su_companynumber", bill.getSu_companynumber()); // 수탁사업자 사업자등록번호-
		data.put("su_biztype", bill.getSu_biztype()); // 수탁사업자 업태-

		data.put("su_companyname", bill.getSu_companyname()); // 수탁사업자 상호명-
		data.put("su_bizclassification", bill.getSu_bizclassification()); // 수탁사업자 업종-
		data.put("su_taxnumber", bill.getSu_taxnumber()); // 수탁사업자 종사업장번호-
		data.put("su_ceoname", bill.getSu_ceoname()); // 수탁사업자 대표자명-
		data.put("su_busename", bill.getSu_busename()); // 수탁사업자 담당부서명-

		data.put("su_name", bill.getSu_name()); // 수탁사업자 담당자명-
		data.put("su_cell", bill.getSu_cell()); // 수탁사업자 담당자전화번호-
		data.put("su_email", bill.getSu_email()); // 수탁사업자 담당자이메일-
		data.put("su_companyaddress", bill.getSu_companyaddress()); // 수탁사업자 회사주소-

		data.put("cash", bill.getDbl_cash().replace(",", "")); // 현금*
		data.put("scheck", bill.getDbl_scheck().replace(",", "")); // 수표*
		data.put("draft", bill.getDbl_draft().replace(",", "")); // 어음*
		data.put("uncollected", bill.getDbl_uncollected().replace(",", "")); // 외상 미수금*
		data.put("chargetotal", bill.getDbl_chargetotal().replace(",", "")); // 총 공급가액*
		data.put("taxtotal", bill.getDbl_taxtotal().replace(",", "")); // 총 세액 *
		data.put("grandtotal", bill.getDbl_grandtotal().replace(",", "")); // 총 금액*

		JSONArray jArray = new JSONArray();

		JSONObject sObject = new JSONObject();
		sObject.put("description", bill.getDescription()); // 품목별 비고입력
		sObject.put("supplyprice", bill.getDbl_supplyprice().replace(",", "")); // 품목별 공급가액
		sObject.put("quantity", bill.getDbl_quantity()); // 품목수량
		sObject.put("unit", bill.getDbl_unit()); // 품목규격
		sObject.put("subject", bill.getDbl_subject()); // 품목명
		sObject.put("gyymmdd", nowdate2); // 공급연원일
		sObject.put("tax", bill.getDbl_tax().replace(",", "")); // 세액
		sObject.put("unitprice", bill.getDbl_unitprice().replace(",", "")); // 단가
		jArray.put(sObject);

		// 세금계산서 detail정보를 JSONObject객체에 추가
		data.put("taxdetailList", jArray);// 배열을 넣음

		System.out.println(data);

		// 전자세금계산서 발행 후 리턴
			String restapi = Api("https://www.hometaxbill.com:8084/homtax/post", data.toString());
//		String restapi = Api("http://115.68.1.5:8084/homtax/post", data.toString());

		if (restapi.equals("fail")) {
				System.out.println("https://www.hometaxbill.com:8084/homtax/post 서버에 문제가 발생했습니다.");
//			System.out.println("http://115.68.1.5:8084/homtax/post 서버에 문제가 발생했습니다.");
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
		} else {
			System.out.println("code : -1" + "\n" + "msg : 서버호출에 실패했습니다.");
			msg = "서버호출에 실패했습니다.";
		}

		String code = (String) jsonObj.get("code");
		bill.setDbl_status(code);
		bill.setDbl_errormsg(msg);
		bill.setDbl_issuedate(nowdate2);
		bill.setDbl_sub_issuedate(nowdate2);

		Component.updateData("sfabill.codemsgUpdate", bill);

		// 카카오톡 전송 & 전송실패시 체크 풀기
		if (code.equals("0")) {
			String subkey = bill.getDbl_sub_keyno();
			if (subkey.equals("1") || subkey.equals("2")) {

				String pname = bill.getDbl_p_name();
				String sname = bill.getDbl_s_name();
				String subject = bill.getDbl_subject();
				String grandtotal = bill.getDbl_grandtotal();
				String issuedate = bill.getDbl_issuedate();
				String admin = "대양기업 이시연";
				String adminphone = "061-332-8086";

//		    			String contents = name+"(이)가 \n발전소 : "+map.get("DPP_NAME").toString()+"의 \n게시물 : "+title+" (를)을\n확인하였습니다.";
				String contents = "[세금계산서 발행 완료 안내]\n" + pname + "의 세금계산서 발행이 완료되었습니다.\n□ 공급자 : " + pname
						+ "\n□ 공급받는자: " + sname + "\n□ 품목명 : " + subject + "\n□ 합계금액 : " + grandtotal + "원"
						+ "\n□ 발행일 : " + issuedate + "\n\n\n※ 세금계산서 발행 관련 문의\n담당자 : " + admin + "\n연락처 : " + adminphone;

				// 토큰받기
				String tocken = requestAPI.TockenRecive(SettingData.Apikey, SettingData.Userid);
				tocken = URLEncoder.encode(tocken, "UTF-8");

				// 리스트 뽑기 - 현재 게시물 알림은 index=1
				JSONObject jsonObj2 = requestAPI.KakaoAllimTalkList(SettingData.Apikey, SettingData.Userid,
						SettingData.Senderkey, tocken);
				org.json.simple.JSONArray jsonObj_a = (org.json.simple.JSONArray) jsonObj2.get("list");
				jsonObj2 = (JSONObject) jsonObj_a.get(9); // 템플릿 리스트

				String list = Component.getData("sfabill.AlimSelect", bill);
				String Sendurl = "http://dymonitering.co.kr/";

				String phone = list.toString().replace("-", "");
				// 받은 토큰으로 알림톡 전송
				requestAPI.KakaoAllimTalkSend(SettingData.Apikey, SettingData.Userid, SettingData.Senderkey, tocken,
						jsonObj2, contents, phone, Sendurl);

			} else {

				String pname = bill.getDbl_p_name();
				String sname = bill.getDbl_s_name();
				String subject = bill.getDbl_subject();
				String grandtotal = bill.getDbl_grandtotal();
				String issuedate = bill.getDbl_issuedate();
				String admin = "대양기업 이시연";
				String adminphone = "061-332-8086";

//				    	String contents = name+"(이)가 \n발전소 : "+map.get("DPP_NAME").toString()+"의 \n게시물 : "+title+" (를)을\n확인하였습니다.";
				String contents = "[세금계산서 발행 완료 안내]\n" + sname + "의 세금계산서 발행이 완료되었습니다.\n□ 공급자 : " + pname
						+ "\n□ 공급받는자: " + sname + "\n□ 품목명 : " + subject + "\n□ 합계금액 : " + grandtotal + "원"
						+ "\n□ 발행일 : " + issuedate + "\n\n\n※ 세금계산서 발행 관련 문의\n담당자 : " + admin + "\n연락처 : " + adminphone;

				// 토큰받기
				String tocken = requestAPI.TockenRecive(SettingData.Apikey, SettingData.Userid);
				tocken = URLEncoder.encode(tocken, "UTF-8");

				// 리스트 뽑기 - 현재 게시물 알림은 index=1
				JSONObject jsonObj2 = requestAPI.KakaoAllimTalkList(SettingData.Apikey, SettingData.Userid,
						SettingData.Senderkey, tocken);
				org.json.simple.JSONArray jsonObj_a2 = (org.json.simple.JSONArray) jsonObj2.get("list");
				jsonObj2 = (JSONObject) jsonObj_a2.get(9); // 템플릿 리스트

				String list = Component.getData("sfabill.AlimSelect2", bill);
				String Sendurl = "http://dymonitering.co.kr/";

				String phone = list.toString().replace("-", "");
				// 받은 토큰으로 알림톡 전송
				requestAPI.KakaoAllimTalkSend(SettingData.Apikey, SettingData.Userid, SettingData.Senderkey, tocken,
						jsonObj2, contents, phone, Sendurl);
			}

		} else {
//			전송상태 N으로 변경해서 체크박스 안사라지게 함
			Component.updateData("sfabill.checkChange", bill);
		}

		return msg;
	}
	
	
	/*
	 * 안전관리 작성 양식 선택 Ajax
	 **/
	@RequestMapping(value = "/sfa/safe/insertExcel.do")
	public String insertExcel(HttpServletRequest req,
			@RequestParam(value = "excelFile", required=false) MultipartFile file
			) throws Exception {
		
		Map<String, Object> user = CommonService.getUserInfo(req);
		String UI_KEYNO = user.get("UI_KEYNO").toString();
		
		
		ArrayList<ArrayList<String>> result = excel.readFilter_And_Insert(file);
		
		if(result.size() > 0) {
			//발전소명, 지역, 주소, 용량, 전압, CT비, 인버터대수, 검침일, 번호1 ,번호2, 전화번호1, 2, 3, 4, 5, 월별점검횟수
			for(ArrayList<String> re : result) {
				HashMap<String , Object> m = new HashMap<String, Object>();
				
				m.put("a",re.get(0));				
				m.put("b",re.get(1));				
				m.put("c",re.get(2));
				m.put("d",re.get(3));
				m.put("e",re.get(4));
				m.put("f",re.get(5));
				m.put("g",re.get(6));
				m.put("h",re.get(7));
				m.put("i",re.get(8));
				m.put("j",re.get(9));
				m.put("k",re.get(10));
				m.put("l",re.get(11));
				m.put("m",re.get(12));
				m.put("n",re.get(13));
				m.put("o",re.get(14));
				m.put("p",re.get(15));
				m.put("q",UI_KEYNO);
				
				
				Component.createData("sfa.ExcelInsert", m);
				
			}
		}
		
		return "redirect:/dyAdmin/safe/user.do";
		
		
	}
	
	
	@RequestMapping("/autolistsfa.do")
	@ResponseBody
	public String autolistSFA(HttpServletRequest req) throws Exception {
		
		  Map<String, Object> user = CommonService.getUserInfo(req);
		  String UI_KEYNO = user.get("UI_KEYNO").toString();  
		  
		  String msg = "";
		  String codeStr = "";
		  
		  List<HashMap<String, Object>> list = Component.getList("sfabill.PreMonthData", UI_KEYNO);
		  HashMap<String, Object> KeyUpdate = new HashMap<String, Object>();
		  
		  
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
		  
		  if (list.size() > 0) {
			  
			  String homekey = Component.getData("sfabill.homekey",UI_KEYNO);
			  
			  for(HashMap<String, Object> l : list) {
				  
				  
				  String codenum = homekey.substring(7,homekey.length());
				  int tempc = Integer.parseInt(codenum) + 1 ;
				  String code =  homekey.substring(0,7);
				  codeStr = code+tempc;
				  homekey = codeStr;
				  
				//품목명 처리(Subject)
				  String subject = (String)l.get("dbl_subject");
		    	  String subject_sub = subject.substring(5, subject.length());
		    	  
		    	  String subDate = year2+"."+month2;
		    	  l.put("dbl_subject",subDate+subject_sub);
		    	  l.put("dbl_issuedate", nowdate2);
		    	  l.put("dbl_checkYN", "N");
		    	  l.put("dbl_errormsg", "");
		    	  l.put("dbl_homeid", codeStr);
		    	  l.put("dbl_status", "1");
		    	  
		    	  
		    	  Component.createData("sfabill.billInfoInsertAuto", l);
			  }
			  
			  KeyUpdate.put("UI_KEYNO", UI_KEYNO);
			  KeyUpdate.put("key", codeStr);
			  
			//Keytable에 가장 마지막 숫자 업데이트
			 Component.updateData("sfabill.changeHomekey", KeyUpdate);
			 
			 msg = "세금계산서 발행리스트 업데이트 완료";
			 
		  } else {
			  msg = "첫 발행시에는 직접 등록해 주세요. 다음 발행부터는 버튼 클릭 시 자동으로 업데이트 됩니다.";
		  }
		  
		return msg;
	}
	
	
	@RequestMapping("/sfa/safe/AreaChangeList.do")
	@ResponseBody
	public List AreaChangeList(HttpServletRequest req, 
			@RequestParam(value = "area") String area) throws Exception {
		
		Map<String, Object> user = CommonService.getUserInfo(req);
		String UI_KEYNO = user.get("UI_KEYNO").toString();
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		List map2;
		
		
		map.put("area", area);
		map.put("UI_KEYNO", UI_KEYNO);
		
		if(area.equals("all")) {
			map2 = Component.getList("sfa.safeuserselect", UI_KEYNO);
		}else{
			map2 = Component.getList("sfa.AreaPlantSelect", map);
		}

		return map2;
	}
	
	//고유번호 자동수정 
	@RequestMapping("/sfa/bills/HomeIdUpdate_SFA.do")
	@ResponseBody
	public String HomeIdUpdate(HttpServletRequest req,
			@RequestParam(value="subkey")String subkey) throws Exception {
	
		Map<String, Object> user = CommonService.getUserInfo(req);
		String UI_KEYNO = user.get("UI_KEYNO").toString();
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		map.put("subkey", subkey);
		map.put("UI_KEYNO", UI_KEYNO);
		
		
		 List<HashMap<String, Object>> list = Component.getList("sfabill.f_ListSelect_sfa", map);
		 
		 String now = new SimpleDateFormat("yyyyMMdd").format(Calendar.getInstance().getTime());
		 String nowdate = now.replace("-", "");
		 String nowdate2 = nowdate.trim();
		 
		 
		 String msg = "";
		 String codeStr = "";
		 String homekey = Component.getData("sfabill.homekey");
		 
		 
		 if (list.size() > 0) {
			 for(HashMap<String, Object> l : list) {
				 
				 String codenum = homekey.substring(7,homekey.length());
				 int tempc = Integer.parseInt(codenum) + 1 ;
				 String code =  homekey.substring(0,7);
				 codeStr = code+tempc;
				 homekey = codeStr;
				 
				 l.put("dbl_homeid", codeStr);
				 l.put("dbl_issuedate", nowdate2);
				 l.put("dbl_sub_issuedate", nowdate2);
				 
				 Component.updateData("sfabill.homeIdUpdate_f_sfa", l);
			 }
			 msg = "전송 실패한 리스트의 고유번호가 수정되었습니다. 발행할 리스트를 전송하세요."; 
			 
			 //Keytable에 가장 마지막 숫자 업데이트
			 Component.updateData("sfabill.changeHomekey", codeStr);
			 
		 }else {
			 msg = "고유번호를 수정할 리스트가 없습니다.";
		 }
		 
		 return msg;
	}
	
	
	@RequestMapping("/sfa/bills/allSendNTS_SFA.do")
	@ResponseBody
	public String allSendNTS(HttpServletRequest req, safebillDTO bill,
			@RequestParam(value="subkey")String subkey) throws Exception {
		
		String msg = "";
		Map<String, Object> user = CommonService.getUserInfo(req);
		String UI_KEYNO = user.get("UI_KEYNO").toString();
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		map.put("subkey", subkey);
		map.put("UI_KEYNO", UI_KEYNO);
		
		List list = Component.getList("sfabill.AllsentNTS_sfa",map);
		
		if(list.isEmpty()) {	
			msg = "전송할 세금계산서가 없습니다.";
		}else {
			for(Object l : list) {
				//전송 Y/N 체크
				Component.updateData("sfabill.checkYN", l);
				bill = Component.getData("sfabill.selectAllView", l);
				
				sendApi(bill);
			}
			msg = "전체 전송이 완료되었습니다.";	
		}
		
		return msg;
	}
	
	/*
	* 점검현황
	**/
	@RequestMapping(value = "/sfa/safe/checkingStatus.do")
	public ModelAndView safeAdminCheck(HttpServletRequest req) throws Exception {

		ModelAndView mv = new ModelAndView("/user/_SFA/safe/prc_admin_check_pb");
		
		Map<String, Object> user = CommonService.getUserInfo(req);
		String UI_KEYNO = user.get("UI_KEYNO").toString();
		
			
		//지역 전체 출력 
		List<HashMap<String, Object>> map =  Component.getList("sfa.Area_select",UI_KEYNO);
		mv.addObject("map",map);
		return mv;
	}
	
	@RequestMapping("/postget.do")
	@ResponseBody
	public HashMap<String, Object> postget(HttpServletRequest req, 
			@RequestParam(value="dbp_keyno")String dbp_keyno) throws Exception {
		
		HashMap<String, Object> map = Component.getData("bills.billsSelect_one", dbp_keyno);
		
		
		return map;
	}
	
}