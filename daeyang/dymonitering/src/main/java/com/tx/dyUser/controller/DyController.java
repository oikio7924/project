package com.tx.dyUser.controller;

import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.transaction.Transactional;
import javax.websocket.RemoteEndpoint.Async;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.lf5.util.StreamUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.SettingData;
import com.tx.common.file.ByteArrayMultipartFile;
import com.tx.common.file.FileUploadTools;
import com.tx.common.file.dto.FileSub;
import com.tx.common.security.aes.AES256Cipher;
import com.tx.common.security.password.MyPasswordEncoder;
import com.tx.common.service.AsyncService.AsyncService;
import com.tx.common.service.AsyncService.Impl.AsyncServiceImpl;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.reqapi.requestAPIservice;
import com.tx.dyAdmin.member.dto.LicenseDTO;
import com.tx.dyAdmin.member.dto.UserDTO;
import com.tx.dyUser.dto.SerialDTO;
import com.tx.dyUser.wether.WetherService;
import com.tx.test.dto.billDTO;

@Controller
public class DyController {

//	private AsyncService async;
//
//	public DyController(AsyncService async) {
//		super();
//		this.async = async;
//	}

	@Autowired
	ComponentService Component;
	/** 페이지 처리 출 */

	@Autowired
	CommonService CommonService;

	/** 암호화 */
	@Autowired
	MyPasswordEncoder passwordEncoder;

	@Autowired
	requestAPIservice requestAPI;

	/** 파일업로드 툴 */
	@Autowired
	private FileUploadTools FileUploadTools;

	/**
	 * @return 관리자 종합현황 페이지
	 */
	@RequestMapping("/dy/moniter/overAll.do")
	public ModelAndView overAll(HttpServletRequest req) throws Exception {
		ModelAndView mv = new ModelAndView("/user/_DY/monitering/dy_overallStatus");
		HashMap<String, Object> cntM = new HashMap<String, Object>();
		HashMap<String, Object> type = new HashMap<String, Object>();

		Map<String, Object> user = CommonService.getUserInfo(req);
		type.put("UI_KEYNO", user.get("UI_KEYNO").toString());
		type.put("UIA_NAME", user.get("UIA_NAME").toString());

		// 종합현황은 관리자만 출입가능
		type.put("type", null);
		type.put("value", "정상");
		cntM.put("a", Component.getCount("main.select_Main_cnt", type));
		type.put("value", "장애");
		cntM.put("b", Component.getCount("main.select_Main_cnt", type));
		type.put("value", "미개통");
		cntM.put("c", Component.getCount("main.select_Main_cnt", type));
		type.put("value", "대기");
		cntM.put("d", Component.getCount("main.select_Main_cnt", type));

		mv.addObject("cntM", cntM);

		String sql = "main.select_MainData";
		// 삼환관리자 처리부분
		if (SettingData.samwhan.equals(user.get("UIA_KEYNO").toString())) {
			sql = "main.select_MainData_Ad";
		}
		mv.addObject("list", Component.getList(sql, type));
		mv.addObject("listSum", Component.getData("main.select_MainSum", type));

		return mv;
	}

	/**
	 * 어제 데이터만 정리(인버터별 최신값만 남기기)
	 * ttest.do의 하루 버전 (수동 실행용)
	 */
	@RequestMapping("/cleanupYesterday.do")
	public void cleanupYesterday(HttpServletRequest req) throws Exception {
		List<HashMap<String,Object>> list = Component.getListNoParam("main.selectPower");
		
		for(HashMap<String,Object> l : list) {
			String keyno = l.get("DPP_KEYNO").toString();
			
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("day", 1); // 어제
			map.put("keyno", keyno);
			
			// dy_inverter_data_main: 어제 데이터 중 최신 한 건만 남기고 삭제
			Component.deleteData("sub2.deleteMain", map);
			
			// dy_inverter_data: 어제 인버터별 최신값만 남기고 삭제
			List<String> slist = Component.getList("sub2.recent_date", map);
			map.put("list", slist);
			if (slist != null && slist.size() > 0) {
				Component.deleteData("sub2.deleteToday", map);
			}
		}
	}
	
	/**
	 * @return 관리자 종합현황 세부인버터 정보 추출
	 */
	@RequestMapping("/dy/moniter/overAll_Ajax.do")
	@ResponseBody
	public ModelAndView overAll_Ajax(HttpServletRequest req, @RequestParam(value = "keyno") String keyno)
			throws Exception {
		// 날씨 데이터, 용량, 현재발전, 금일, 전일 ,전월 ,금년, 누적 !
		ModelAndView mv = new ModelAndView("/user/_DY/monitering/ajax/dy_overallStatus_ajax");

		HashMap<String, Object> type = new HashMap<String, Object>();
		HashMap<String, Object> premap = new HashMap<String, Object>();

		Map<String, Object> user = CommonService.getUserInfo(req);
		type.put("UI_KEYNO", user.get("UI_KEYNO").toString());
		type.put("UIA_NAME", user.get("UIA_NAME").toString());

		// 단일 데이터 (금일, 전일, 현재발전, 설치용량)
		type.put("type", keyno);
		premap.put("keyno", keyno);

		String sql = "main.select_MainData";
		// 삼환관리자 처리부분
		if (SettingData.samwhan.equals(user.get("UIA_KEYNO").toString())) {
			sql = "main.select_MainData_Ad";
		}

		HashMap<String, Object> ob = Component.getData(sql, type);
		String area = ob.get("DPP_AREA").toString(); // 지역

		premap.put("area", area);
		premap.put("volum", Float.parseFloat(ob.get("DPP_VOLUM").toString())
				/ Float.parseFloat(ob.get("DPP_INVER_COUNT").toString()));

//	   mv.addObject("predata",Component.getList("main.PrecSelect",premap));

		mv.addObject("detail_Data", ob);

//		List<HashMap<String, Object>> weather = Component.getList("Weather.select_Weather", area);

//		if (weather.size() > 0) {
//			mv.addObject("Weather", weather.get(1));
//		}

		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		DateFormat format2 = new SimpleDateFormat("yyyy");
		Date d = new Date();
		String now = format.format(d);

		// 이번달 날짜 count
		Calendar c1 = Calendar.getInstance();
		Date Today = c1.getTime();
		c1.set(Calendar.DAY_OF_MONTH, 1);
		Date Fmon = c1.getTime();
		long diffDay = (Today.getTime() - Fmon.getTime()) / (24 * 60 * 60 * 1000);
		mv.addObject("month1Cnt", diffDay);

		format = new SimpleDateFormat("yyyy-MM");
		String nowd = format.format(c1.getTime());
		c1.add(Calendar.MONTH, -1);
		String pred = format.format(c1.getTime());
		c1.add(Calendar.MONTH, -1);
		String ppred = format.format(c1.getTime());

	Calendar c2 = Calendar.getInstance();
	c2.add(Calendar.YEAR, -1);
	String nowY = format2.format(c2.getTime()); // 작년

	type.put("date", "day");
	// 오남매 1호 전용 쿼리 사용 여부 결정 (25.08 분리 대응: 인버터 1,2호만 포함)
	String queryName = keyno.equals("95") ? "main.recent_sum_onam1" : "main.recent_sum";
	
	// 전월 누적치 차액(전달 - 전에전달)
	type.put("Conn_date", pred);
	float preC = Component.getData(queryName, type);

	type.put("Conn_date", ppred);
	float ppreC = Component.getData(queryName, type);
	mv.addObject("Prmonth", preC - ppreC);

	type.put("Conn_date", nowd);// 금월
	float TodayCum = Component.getData(queryName, type);
	mv.addObject("month1", TodayCum - preC);

	type.put("date", "year");
	type.put("Conn_date", nowY);
	float YearCum = Component.getData(queryName, type);
	mv.addObject("year1", TodayCum - YearCum);

	// 알림테이블 부분
		mv.addObject("ResultList", Component.getList("main.select_errorData", keyno));
		mv.addObject("UI_KEYNO", type.get("UI_KEYNO"));

//	   if(area.equals("나주")) {
//		   mv.addObject("area",area);
//		   mv.addObject("SensorData",Component.getListNoParam("main.sensorData"));
//	   }

		return mv;
	}

	/**
	 * @return 현장리스트 검색
	 */
	@RequestMapping("/dy/moniter/overAll_Ajax2.do")
	@ResponseBody
	public ModelAndView overAll_Ajax2(HttpServletRequest req, @RequestParam(value = "region") String region,
			@RequestParam(value = "status") String status) throws Exception {
		ModelAndView mv = new ModelAndView("/user/_DY/monitering/ajax/dy_overallStatus_ajax2");

		HashMap<String, Object> type = new HashMap<String, Object>();

		Map<String, Object> user = CommonService.getUserInfo(req);
		type.put("UI_KEYNO", user.get("UI_KEYNO").toString());
		type.put("UIA_NAME", user.get("UIA_NAME").toString());
		type.put("type", null);
		type.put("region", region);
		type.put("status", status);

		String sql = "main.select_MainData";
		if (SettingData.samwhan.equals(user.get("UIA_KEYNO").toString())) {
			sql = "main.select_MainData_Ad";
		}
		mv.addObject("list", Component.getList(sql, type));

		return mv;
	}

	/**
	 * @return 발전 현황
	 */
	@RequestMapping("/dy/moniter/general.do")
	public ModelAndView general(HttpServletRequest req, @RequestParam(value = "keyno", defaultValue = "0") String key,
			@RequestParam(value = "name", defaultValue = "인버터 1호") String name, HttpSession session) throws Exception {
		ModelAndView mv = new ModelAndView("/user/_DY/monitering/dy_generalStatus");
		// 회원별 발전소 키를 가지고 정보 확인 일단 기본키
		HashMap<String, Object> type = new HashMap<String, Object>();

		// 아이디 세션에 있는값 저장
		Map<String, Object> user = CommonService.getUserInfo(req);
		type.put("UI_KEYNO", user.get("UI_KEYNO").toString());
		type.put("UIA_NAME", user.get("UIA_NAME").toString());

		String sql = "main.select_MainData";
		String sql2 = "main.Power_SelectKEY";

		if (SettingData.samwhan.equals(user.get("UIA_KEYNO").toString())) {
			sql = "main.select_MainData_Ad";
			sql2 = "main.Power_SelectKEY_Ad";
		}

		if (key.equals("0")) {
			// 1. 세션에 키값 저장확인
			key = (String) session.getAttribute("DPP_KEYNO");
		}
		// 2. 세션에 키값 없다면
		if (key == null || StringUtils.isEmpty(key)) {
			key = Component.getData(sql2, type);
			// 선택된 키값 세션 저장(초기 제일 상위 KEY값 저장)
		}
		session.setAttribute("DPP_KEYNO", key);
		List<HashMap<String, Object>> m_list = Component.getList(sql, type);

		if (m_list.size() == 0) {
			mv = new ModelAndView("/user/_DY/monitering/dy_none");
			mv.addObject("none", "none");
			return mv;
		}

		mv.addObject("list", m_list);

		type.put("type", key);
		type.put("name", name);
		// 인버터 데이터
		HashMap<String, Object> ob = Component.getData(sql, type);
		type.put("group", "group");

		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		DateFormat format2 = new SimpleDateFormat("yyyy");
		Date d = new Date();
		String now = format.format(d);

		type.put("searchBeginDate", now);
		type.put("searchEndDate", now);

		// ✅ 최적화: 느린 쿼리 대신 최적화된 쿼리 사용 (7초 → 0.1초)
		List<HashMap<String, Object>> dataList = Component.getList("main.select_inverterData_daily_optimized", key);

		String area = ob.get("DPP_AREA").toString(); // 지역

//		List<HashMap<String, Object>> weather = Component.getList("Weather.select_Weather", area);

		// 이번달 날짜 count
		Calendar c1 = Calendar.getInstance();
		Date Today = c1.getTime();
		c1.set(Calendar.DAY_OF_MONTH, 1);
		Date Fmon = c1.getTime();
		long diffDay = (Today.getTime() - Fmon.getTime()) / (24 * 60 * 60 * 1000);
		mv.addObject("month1Cnt", diffDay);

		format = new SimpleDateFormat("yyyy-MM");

		String nowd = format.format(c1.getTime());

		c1.add(Calendar.MONTH, -1);
		String pred = format.format(c1.getTime());
		c1.add(Calendar.MONTH, -1);
		String ppred = format.format(c1.getTime());

	Calendar c2 = Calendar.getInstance();
	c2.add(Calendar.YEAR, -1);
	String nowY = format2.format(c2.getTime()); // 작년

	type.put("date", "day");
	// 오남매 1호 전용 쿼리 사용 여부 결정 (25.08 분리 대응: 인버터 1,2호만 포함)
	String queryName = key.equals("95") ? "main.recent_sum_onam1" : "main.recent_sum";
	
	// 전월 누적치 차액(전달 - 전에전달)
	type.put("Conn_date", pred);
	float preC = Component.getData(queryName, type);

	type.put("Conn_date", ppred);
	float ppreC = Component.getData(queryName, type);
	mv.addObject("Prmonth", preC - ppreC);

	type.put("Conn_date", nowd);// 금월

	// 성진 1,2호 25.09월부터 발전시작한것으로 간주하기위한 데이터 처리(그전까지의 누적값을 뺌)
	float TodayCum = Component.getData(queryName, type);
	if (key.equals("113")) {
		preC = preC - 1491055.84f;      // 전월값에도 보정 적용
		TodayCum = TodayCum - 1491055.84f;  // 금월값에도 보정 적용
	}
	mv.addObject("month1", TodayCum - preC);

	type.put("date", "year");
	type.put("Conn_date", nowY);
	float YearCum = Component.getData(queryName, type);
	mv.addObject("year1", TodayCum - YearCum);

	type.put("category", "안전관리");// 안전관리
		mv.addObject("boardList_A", Component.getList("main.PowerBoard_select", type));

		type.put("category", "유지관리");// 유지관리
		mv.addObject("boardList_B", Component.getList("main.PowerBoard_select", type));

		mv.addObject("DPP_KEYNO", key);
		mv.addObject("InverterNum", name);
		mv.addObject("invertDataList", dataList);
//		if (weather.size() > 0) {
//			mv.addObject("weatherToday", weather.get(1));
//			mv.addObject("weather", weather);
//		}
		mv.addObject("ob", ob);
		// 추가 그런포스펌프 데이터 추출
		if (key.equals("63")) {
//		   mv.addObject("pospump",Component.getListNoParam("main.pospump_data") );
			mv.addObject("pospump2", Component.getListNoParam("main.pospump_data_main"));
		}

		return mv;
	}

	/**
	 * @return 발전 현황 (단일 쿼리 최적화 버전)
	 * 기존: 30-60개 쿼리 → 최적화: 1개 쿼리로 97% 성능 개선
	 */
	@RequestMapping("/dy/moniter/generalAjax.do")
	@ResponseBody
	public HashMap<String, Object> generalAjax(HttpServletRequest req,
			@RequestParam(value = "keyno", defaultValue = "0") String key,
			@RequestParam(value = "name", defaultValue = "인버터 1호") String name, HttpSession session) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		
		if (key.equals("0")) {
			key = (String) session.getAttribute("DPP_KEYNO");
		}
		session.setAttribute("DPP_KEYNO", key);
		
		map.put("name", name);

		// ✅ 최적화: 모든 인버터 데이터를 단일 쿼리로 한 번에 조회
		List<HashMap<String, Object>> invertDataList = Component.getList("main.select_inverterData_daily_optimized", key);
		
		// 선택된 인버터의 데이터 찾기
		HashMap<String, Object> selectedInverterData = null;
		for (HashMap<String, Object> data : invertDataList) {
			if (name.equals(data.get("DI_NAME"))) {
				selectedInverterData = data;
				break;
			}
		}
		
		// 개별 인버터 데이터 설정
		if (selectedInverterData != null) {
			map.put("invertData", selectedInverterData);
		} else {
			// 데이터가 없는 경우 기본값
			HashMap<String, Object> defaultData = new HashMap<>();
			defaultData.put("Daily_Generation", 0.0);
			defaultData.put("Active_Power", 0.0);
			defaultData.put("Cumulative_Generation", 0.0);
			map.put("invertData", defaultData);
		}
		
		// 전체 인버터 리스트 (프론트 합산용)
		map.put("invertDataList", invertDataList);

		return map;
	}

	/**
	 * 금월 발전량 계산 (dy_inverter_data_main 테이블 기반)
	 */
	@RequestMapping("/dy/moniter/monthlyAjax.do")
	@ResponseBody
	public HashMap<String, Object> monthlyAjax(HttpServletRequest req,
			@RequestParam(value = "keyno", defaultValue = "0") String key, HttpSession session) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		HashMap<String, Object> type = new HashMap<String, Object>();

		if (key.equals("0")) {
			key = (String) session.getAttribute("DPP_KEYNO");
		}

		type.put("type", key);

		// 이번달/전달 날짜 설정
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM");
		Calendar c1 = Calendar.getInstance();
		String nowd = format.format(c1.getTime());
		
		c1.add(Calendar.MONTH, -1);
		String pred = format.format(c1.getTime());

		// 전월 누적치 (dy_inverter_data_main 테이블에서)
		type.put("date", "day");  // 월별 조회 설정
		type.put("Conn_date", pred);
		float preC = Component.getData("main.recent_sum_main", type);
		
		// 금월 누적치 (dy_inverter_data_main 테이블에서)
		type.put("Conn_date", nowd);
		float TodayCum = Component.getData("main.recent_sum_main", type);
		
		// 성진 1,2호 25.09월부터 발전시작한것으로 간주하기위한 데이터 처리(그전까지의 누적값을 뺌)
		if (key.equals("113")) {
			preC = preC - 1491055.84f;      // 전월값에도 보정 적용
			TodayCum = TodayCum - 1491055.84f;  // 금월값에도 보정 적용
		}
		
		// 금월 발전량 = 금월 누적 - 전월 누적
		float monthlyGen = TodayCum - preC;
		monthlyGen = (float) Math.round(monthlyGen * 100) / 100f;
		
		map.put("Monthly_Generation", monthlyGen);

		return map;
	}

	/**
	 * @return 통계 분석
	 */
	@RequestMapping("/dy/moniter/stastics.do")
	public ModelAndView stastics(HttpServletRequest req,
			@RequestParam(value = "DPP_KEYNO", defaultValue = "0") String key, HttpSession session,
			@RequestParam(value = "DaliyType", defaultValue = "1") String DaliyType,
			@RequestParam(value = "searchBeginDate", required = false) String searchBeginDate,
			@RequestParam(value = "searchEndDate", required = false) String searchEndDate,
			@RequestParam(value = "InverterType", defaultValue = "0") String InverterType) throws Exception {
		ModelAndView mv = new ModelAndView("/user/_DY/monitering/dy_statstics");
		HashMap<String, Object> type = new HashMap<String, Object>();

		Map<String, Object> user = CommonService.getUserInfo(req);
		type.put("UI_KEYNO", user.get("UI_KEYNO").toString());
		type.put("UIA_NAME", user.get("UIA_NAME").toString());

		String sql = "main.select_MainData";
		String sql2 = "main.Power_SelectKEY";
		// 삼환관리자 처리부분
		if (SettingData.samwhan.equals(user.get("UIA_KEYNO").toString())) {
			sql = "main.select_MainData_Ad";
			sql2 = "main.Power_SelectKEY_Ad";
		}

		if (key.equals("0")) {
			key = (String) session.getAttribute("DPP_KEYNO");
		}
		if (key == null || StringUtils.isEmpty(key)) {
			key = Component.getData(sql2, type);
		}
		session.setAttribute("DPP_KEYNO", key);
		mv.addObject("list", Component.getList(sql, type));

		type.put("type", key);
		HashMap<String, Object> ob = Component.getData(sql, type);

		mv.addObject("ob", ob);
//    	mv.addObject("DPP_KEYNO", key);

		mv.addObject("InverterType", InverterType);
		mv.addObject("DaliyType", DaliyType);
		mv.addObject("searchBeginDate", searchBeginDate);
		mv.addObject("searchEndDate", searchEndDate);

		return mv;
	}

	/**
	 * @return 통계 분석 ajax
	 */
	@RequestMapping("/dy/moniter/stasticsAjax.do")
	@ResponseBody
	public ModelAndView stasticsAjax(HttpServletRequest req, HttpServletResponse res,
			@RequestParam(value = "keyno", defaultValue = "1") String keyno,
			@RequestParam(value = "searchBeginDate", required = false) String searchBeginDate,
			@RequestParam(value = "searchEndDate", required = false) String searchEndDate,
			@RequestParam(value = "InverterType", defaultValue = "0") String InverterType,
			@RequestParam(value = "DaliyType", defaultValue = "1") String DaliyType,
			@RequestParam(value = "excel", required = false) String excel,
			@RequestParam(value = "excelType", required = false) String excelType) throws Exception {
		ModelAndView mv = new ModelAndView("/user/_DY/monitering/ajax/dy_statstics_ajax");

		HashMap<String, Object> type = new HashMap<String, Object>();
		List<HashMap<String, Object>> result = new ArrayList<HashMap<String, Object>>();
		List<HashMap<String, Object>> errorlist = new ArrayList<HashMap<String, Object>>();
		List<List<String>> MainList = new ArrayList<List<String>>();

		type.put("type", keyno);

		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		Date d = new Date();
		String now = format.format(d);

		if (searchBeginDate == null || searchBeginDate.equals("") || DaliyType.equals("1")) {
			searchBeginDate = now;
		}
		if (searchEndDate == null || searchEndDate.equals("") || DaliyType.equals("1")) {
			searchEndDate = now;
		}

		type.put("searchBeginDate", searchBeginDate);
		type.put("searchEndDate", searchEndDate);
		type.put("InverterType", InverterType);
		type.put("DaliyType", DaliyType);

		HashMap<String, Object> ob = Component.getData("main.select_MainData", type);
		errorlist = Component.getList("main.error_data", type);

		int numbering = Integer.parseInt(ob.get("DPP_INVER_COUNT").toString());

		if (DaliyType.equals("1")) {
			// ✅ 통계분석용: 모든 시간대 데이터 조회
			result = Component.getList("main.select_inverterData_daily_all", keyno);
			
			// JSP에서 사용하는 daily 필드 추가
			for (HashMap<String, Object> row : result) {
				Object dailyGen = row.get("Daily_Generation");
				if (dailyGen != null) {
					row.put("daily", dailyGen);
				} else {
					row.put("daily", 0);
				}
			}

			// 당일일때만 오늘날짜 데이터 뽑는것
			type.put("minmax", "min");
			mv.addObject("mindata", Component.getData("main.daily_statistics_MinMax", type));
			type.put("minmax", "max");
			mv.addObject("maxdata", Component.getData("main.daily_statistics_MinMax", type));

			// 리스트 숫자에 맞게 투입 (종합일때) 그래프 처리
			// MainList.add(Component.getList("main.select_inverterData_date",type)); //날짜
			// 먼저 등록

			List<String> TenM = new ArrayList<>(Arrays.asList(
					new String[] { "06:00", "06:30", "07:00", "07:30", "08:00", "08:30", "09:00", "09:30", "10:00",
							"10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00",
							"15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "18:30", "19:00", "19:30" }));
			MainList.add(TenM);

			if (InverterType.equals("0")) {
				// ✅ 최적화: 모든 인버터 데이터를 단일 쿼리로 조회 (10-20개 쿼리 → 1개)
				List<HashMap<String, Object>> allData = Component.getList("main.select_inverterData_active_optimized", type);
				
				// 인버터별, 시간대별로 데이터를 Map에 저장 (시간대를 키로 사용)
				Map<String, Map<String, String>> inverterTimeDataMap = new HashMap<>();
				for (HashMap<String, Object> row : allData) {
					String diName = (String) row.get("DI_NAME");
					String timeSlot = (String) row.get("time_slot");
					String power = String.valueOf(row.get("power"));
					
					if (diName != null && timeSlot != null) {
						inverterTimeDataMap.computeIfAbsent(diName, k -> new HashMap<>()).put(timeSlot, power);
					}
				}
				
				// MainList에 인버터 순서대로 추가
				for (int i = 1; i <= numbering; i++) {
					String inverterName = "인버터 " + i + "호";
					Map<String, String> timeDataMap = inverterTimeDataMap.getOrDefault(inverterName, new HashMap<>());
					
					// TenM 시간대 리스트를 기준으로 순서대로 데이터 매핑
					List<String> subList = new ArrayList<>();
					for (String timeSlot : TenM) {
						// 해당 시간대의 데이터가 있으면 사용, 없으면 "0"
						String power = timeDataMap.getOrDefault(timeSlot, "0");
						subList.add(power);
					}
					
					MainList.add(subList);
				}
			} else {
				// select = 2이면 인버터 별, InverterType = 1
				type.put("inverterNum", InverterType);
				List<String> subList = Component.getList("main.select_inverterData_active", type);
				MainList.add(subList);
			}
		} else {
			String sql = "main.select_inverterData_other";

			// excelType = 0(시간),1(일),2(월)
			if (excel == null) {
				if (DaliyType.equals("4")) {
					sql = "select_inverterData_other_excelType2_orType4";
				}
			} else {
				sql = "select_inverterData_other_excelType2_orType4";
				// excel 실행시 쿼리 부분
				if (excelType.equals("0")) {
					sql = "sub.select_hourData";
				}
				type.put("excelType", excelType);
			}

			result = Component.getList(sql, type);

			type.put("now", now);

			// 최대 최솟값 날짜랑 데이터 뽑기
			type.put("minmax", "min");
			mv.addObject("mindata", Component.getData("main.select_inverterData_other_MINMAX", type));
			type.put("minmax", "max");
			mv.addObject("maxdata", Component.getData("main.select_inverterData_other_MINMAX", type));
			// avg,sum
			mv.addObject("avgdata", Component.getData("main.select_inverterData_other_AVGSUM", type));
		}

		mv.addObject("MainList", MainList);

		mv.addObject("InverterType", InverterType);
		mv.addObject("DaliyType", DaliyType);
		mv.addObject("searchBeginDate", searchBeginDate);
		mv.addObject("searchEndDate", searchEndDate);
		mv.addObject("ob", ob);
		mv.addObject("result", result);
		mv.addObject("errorlist", errorlist);

		if (excel != null) {

			mv.addObject("DPP_NAME", ob.get("DPP_NAME"));
			mv.addObject("now", now);

			if (excel.equals("excel")) {

				mv.addObject("excelType", excelType);

				if (excelType.equals("0")) {
					mv.addObject("DaliyType", "1");
				}

				mv.setViewName("/user/_DY/monitering/excel/dy_statstic_excel");
			} else {
				mv.setViewName("/user/_DY/monitering/excel/dy_statstic_error_excel");
			}

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

	/**
	 * @return 통계 분석 detail_data_list
	 */
	@RequestMapping("/dy/moniter/stasticsAjax3.do")
	@ResponseBody
	public ModelAndView stasticsAjax(HttpServletRequest req, HttpServletResponse res,
			@RequestParam(value = "keyno", defaultValue = "1") String keyno,
			@RequestParam(value = "searchBeginDate", required = false) String searchBeginDate,
			@RequestParam(value = "searchEndDate", required = false) String searchEndDate,
			@RequestParam(value = "DaliyType", defaultValue = "1") String DaliyType,
			@RequestParam(value = "InverterType", defaultValue = "0") String InverterType,
			// 251029 수정 - 무한 스크롤 구현: page, pageSize 파라미터 추가
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "pageSize", defaultValue = "200") int pageSize) throws Exception {
		ModelAndView mv = new ModelAndView("/user/_DY/monitering/ajax/dy_statstics_ajax2");

		HashMap<String, Object> type = new HashMap<String, Object>();

		List<HashMap<String, Object>> result1 = new ArrayList<HashMap<String, Object>>();

		// 251029 수정 - 무한 스크롤 구현: offset 계산 및 페이징 파라미터 설정
		int offset = (page - 1) * pageSize;
		type.put("offset", offset);
		type.put("pageSize", pageSize);

		//251120 수정 - 당일일 때 날짜 자동 설정 및 DaliyType 파라미터 추가
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		Date d = new Date();
		String now = format.format(d);

		if (searchBeginDate == null || searchBeginDate.equals("") || DaliyType.equals("1")) {
			searchBeginDate = now;
		}
		if (searchEndDate == null || searchEndDate.equals("") || DaliyType.equals("1")) {
			searchEndDate = now;
		}

		type.put("searchBeginDate", searchBeginDate);
		type.put("searchEndDate", searchEndDate);
		type.put("InverterType", InverterType);
		type.put("DaliyType", DaliyType);
		type.put("type", keyno);

		HashMap<String, Object> ob = Component.getData("main.select_MainData", type);

		// 251029 수정 - 상세보기 데이터 조회: 설정 기간의 모든 데이터 표시

		// [기존 코드] - 집계된 데이터만 조회, 상세 Vpv/Ipv 필드 없음
		/*
		String sql = "sub.select_hourData";
		if (DaliyType.equals("1")) {
			sql = "main.select_inverterData_daily_optimized";
			result1 = Component.getList(sql, keyno);
		} else {
			result1 = Component.getList(sql, type);
		}
		*/

		// [수정 코드] - 상세 데이터 조회, 기간 필터 적용, 스크롤 지원
		String sql = "main.select_inverterData_daily_detail_optimized";
		result1 = Component.getList(sql, type);

		mv.addObject("result1", result1);
		mv.addObject("ob", ob);

		return mv;
	}

	/**
	 * @return 설정 등록
	 */
	@RequestMapping("/dy/moniter/setting.do")
	public ModelAndView setting(HttpServletRequest req) throws Exception {
		ModelAndView mv = new ModelAndView("/user/_DY/monitering/dy_setting");

		UserDTO userDTO = new UserDTO();
		Map<String, Object> user = CommonService.getUserInfo(req);

		userDTO.setUI_ID(user.get("UI_ID").toString());

		userDTO = Component.getData("member.UI_IdCheck", userDTO);

		userDTO.decode();

		mv.addObject("user", userDTO);

		return mv;
	}

	/**
	 * @return 회원 수정 등록
	 */
	@RequestMapping("/dy/moniter/settingAction.do")
	public ModelAndView settingUpdate(HttpServletRequest req, UserDTO userDTO) throws Exception {
		ModelAndView mv = new ModelAndView("redirect:/dy/moniter/setting.do");
		userDTO.setUI_PASSWORD(passwordEncoder.encode(userDTO.getPassword()));
		userDTO.encode();
		Component.updateData("main.SettingUpdate", userDTO);

		return mv;
	}

	/**
	 * @return 파일 등록
	 */
	@RequestMapping("/dy/moniter/filedown.do")
	public ModelAndView filedown(HttpServletRequest req, HttpSession session,
			@RequestParam(value = "DPP_KEYNO", defaultValue = "0") String key,
			@RequestParam(value = "dls_now", defaultValue = "1") String dls_now) throws Exception {
		ModelAndView mv = new ModelAndView("/user/_DY/monitering/filedown/dy_filedown");

		HashMap<String, Object> type = new HashMap<String, Object>();

		Map<String, Object> user = CommonService.getUserInfo(req);

		type.put("UI_KEYNO", user.get("UI_KEYNO").toString());
		type.put("UIA_NAME", user.get("UIA_NAME").toString());

		String sql = "main.select_MainData";
		String sql2 = "main.Power_SelectKEY";
		// 삼환관리자 처리부분
		if (SettingData.samwhan.equals(user.get("UIA_KEYNO").toString())) {
			sql = "main.select_MainData_Ad";
			sql2 = "main.Power_SelectKEY_Ad";
		}

		if (key.equals("0")) {
			key = (String) session.getAttribute("DPP_KEYNO");
		}
		if (key == null || StringUtils.isEmpty(key)) {
			key = Component.getData(sql2, type);
		}

		session.setAttribute("DPP_KEYNO", key);
		mv.addObject("list", Component.getList(sql, type));

		type.put("type", key);
		HashMap<String, Object> ob = Component.getData(sql, type);

		mv.addObject("UI_KEYNO", user.get("UI_KEYNO").toString());

		if (ob.get("DPP_DLS_KEYNO") != null && !ob.get("DPP_DLS_KEYNO").toString().isEmpty()) {
			dls_now = ob.get("DPP_DLS_KEYNO").toString();
		} else {
			dls_now = "1";
		}

		if (ob.get("DPP_FM_KEYNO") != null && !ob.get("DPP_FM_KEYNO").equals("")) {
			FileSub fsVo = new FileSub();
			fsVo.setFS_FM_KEYNO(ob.get("DPP_FM_KEYNO").toString());
			List<FileSub> list = Component.getList("File.AFS_SubFileselectpath", fsVo);

			ArrayList<String> keylist = new ArrayList<String>();
			for (FileSub l : list) {
				keylist.add(l.getEncodeFsKey());
			}

			mv.addObject("RList", list);
			mv.addObject("KeynoList", keylist);

			ob.put("DPP_FM_KEYNO", AES256Cipher.encode(ob.get("DPP_FM_KEYNO").toString()));
		}

		type.put("dls_now", dls_now);
		type.put("dls_dpp_keyno", key);

//    	mv.addObject("dlsData",Component.getData("li.liView", type));

//    	mv.addObject("dlmData",Component.getData("li.main_liView", type));

		// 여기서 뽑긴하는데
//    	if(ob.get("DPP_DLS_KEYNO") != null && ob.get("DPP_DLS_KEYNO") != "") {
//    		dls_now = ob.get("DPP_DLS_KEYNO").toString();
//    	}else {
//    		dls_now = "1";
//    	}

		// 파일등록 목록
		List<String> documentList = Arrays.asList(
				// 발전사업허가
				"사전조사보고서", "발전사업허가 신청서", "사업자 인적자료", "지적 공부(지적도 및 토지대장 등)", // 공통
				"사용승낙서(해당 시)", "설계 도면", // 공통
				"발전사업허가 접수증",
				// 개발행위허가
				"개발행위허가 신청서", "사용승낙서", // 공통
				"물량산출표", "구조안전확인서", // 공통
				"지반인발조사서", // 공통
				"측량성과도", "개발행위허가 접수증",
				// PPA
				"PPA 신청서", "단선결선도", "사업자등록증", // 공통
				"발전사업허가증", // 공통
				"개발행위허가증", // 공통
				"모듈 자료", // 공통
				"인버터 자료", // 공통
				"PPA 접수증",
				// 공사계획신고
				"공사계획 신고서", "감리배치확인서", // 공통
				"공사계획신고 접수증",
				// 사용전검사
				"사용전검사·점검 신청서", "전기안전관리자선임 증명서", "수검자 서식", "감리보고서", "전기계산서",
				// 설비확인
				"설비확인 신청서", "공사계획신고필증", "사용전검사확인증", "전력수급계약서", "상업운전개시확인서", "개발행위준공검사 접수증", "개발행위준공필증", "설비확인서",
				"기타 자료");

		mv.addObject("DocuList", documentList);
		mv.addObject("dls_now", dls_now);
		mv.addObject("ob", ob);

		return mv;
	}

	/**
	 * 사업개발부 화면 모듈화
	 */
	@RequestMapping("/dy/moniter/fileDownAjax.do")
	@ResponseBody
	public ModelAndView fileDownAjax(HttpServletRequest req, HttpServletResponse res, String page) throws Exception {
		ModelAndView mv = new ModelAndView("");

		String jspTartget = "";
		if (page.equals("1")) {
			jspTartget = "/user/_DY/monitering/filedown/dy_PowerGenBusPermit";
		} else if (page.equals("2")) {
			jspTartget = "/user/_DY/monitering/filedown/dy_DevPermit";
		} else if (page.equals("3")) {
			jspTartget = "/user/_DY/monitering/filedown/dy_PpaRes";
		} else if (page.equals("4")) {
			jspTartget = "/user/_DY/monitering/filedown/dy_ConsPlan";
		} else if (page.equals("5")) {
			jspTartget = "/user/_DY/monitering/filedown/dy_PreUseTest";
		} else if (page.equals("6")) {
			jspTartget = "/user/_DY/monitering/filedown/dy_EquipCheck";
		}

		mv.setViewName(jspTartget);

		return mv;
	}

	/**
	 * sub 데이터 출력
	 */
	@RequestMapping("/dy/moniter/SubdataView.do")
	@ResponseBody
	public HashMap<String, Object> SubdataView(LicenseDTO license) throws Exception {

		LicenseDTO licenseMain = Component.getData("li.main_liView", license);
		LicenseDTO licenseApp = Component.getData("li.app_liView", license);
		LicenseDTO licenseMan = Component.getData("li.man_liView", license);
		LicenseDTO licenseCom = Component.getData("li.com_liView", license);
		LicenseDTO licenseManLink = Component.getData("li.man_liView_link", license);

		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("licenseMain", licenseMain);
		map.put("licenseApp", licenseApp);
		map.put("licenseMan", licenseMan);
		map.put("licenseCom", licenseCom);
		map.put("licenseManLink", licenseManLink);

		return map;
	}

	/**
	 * Main_sub 데이터 등록
	 */
	@RequestMapping("/dy/moniter/Subdatainsert.do")
	@ResponseBody
	public String Subdatainsert(LicenseDTO license,
			@RequestParam(value = "DPP_KEYNO", required = false) String DPP_KEYNO) throws Exception {
		String msg = "저장완료";
		String now = license.getDls_now();

		if (license.getSavetype().toString().equals("2")) {
			license.setDls_dpp_keyno(DPP_KEYNO);

			msg = "수정완료";

			if (now.equals("2")) {
				Component.createData("li.main_liUpdate", license);
			}
			Component.createData("li.app_liUpdate", license);
			Component.createData("li.man_liUpdate", license);
			Component.createData("li.com_liUpdate", license);
			// Component.createData("li.li_plant_update", license);
		} else {
			license.setDls_dpp_keyno(DPP_KEYNO);

			if (now.equals("2")) {
				Component.createData("li.main_liInsert", license);
			}
			Component.createData("li.app_liInsert", license);
			Component.createData("li.man_liInsert", license);
			Component.createData("li.com_liInsert", license);
			Component.createData("li.li_plant_update", license);
		}

		return msg;
	}

	/**
	 * @return 파일 등록 or 수정
	 */
	@RequestMapping("/dy/moniter/DownAction.do")
	@Transactional
	public ModelAndView filedownAction(HttpServletRequest req, MultipartHttpServletRequest request,
			@RequestParam(value = "action", defaultValue = "insert") String action,
			@RequestParam(value = "UI_KEYNO", required = false) String UI_KEYNO,
			@RequestParam(value = "DPP_KEYNO", required = false) String DPP_KEYNO,
			@RequestParam(value = "DPP_NAME", required = false) String DPP_NAME,
			@RequestParam(value = "DPP_FM_KEYNO", required = false) String DPP_FM_KEYNO) throws Exception {
		DPP_FM_KEYNO = AES256Cipher.decode(DPP_FM_KEYNO);

		ModelAndView mv = new ModelAndView("redirect:/dy/moniter/filedown.do");

		List<FileSub> fslist = new ArrayList<FileSub>();
		List<String> list = new ArrayList<String>();
		List<MultipartFile> files;

		MultipartFile zipFile = request.getFile("fileAll");
		if (zipFile != null && !zipFile.isEmpty()) {
			files = extractZipFiles(zipFile); // zip에서 추출한 파일로 새 리스트 생성
		} else {
			files = request.getFiles("file"); // 기존 개별 업로드 파일 목록
		}

		FileSub fsVo = new FileSub();
		HashMap<String, Object> map = new HashMap<String, Object>();

		if (action.equals("insert")) {
			fsVo.setFS_FM_KEYNO(FileUploadTools.makeFileMainData(UI_KEYNO).toString());
		} else {
			fsVo.setFS_FM_KEYNO(DPP_FM_KEYNO);
			list = Component.getList("File.GetSubKey", DPP_FM_KEYNO);
		}

		int i = 0;
		for (MultipartFile m : files) {
			if (action.equals("update")) {
				fsVo.setFS_KEYNO(list.get(i).toString());
			}

			fslist.add(FileUploadTools.FileUpload(m, UI_KEYNO, fsVo, req));
			i++;
		}

		map.put("DPP_KEYNO", DPP_KEYNO);
		map.put("FS_FM_KEYNO", fsVo.getFS_FM_KEYNO().toString());

		Component.updateData("sub.fileKeyInsert", map);

		req.setAttribute("currentBn", DPP_NAME);
		FileUploadTools.zip(req, fslist);

		return mv;
	}

	private List<MultipartFile> extractZipFiles(MultipartFile zipFile) throws Exception {
		List<MultipartFile> extractedFiles = new ArrayList<>();

		try (ZipInputStream zis = new ZipInputStream(zipFile.getInputStream(), StandardCharsets.UTF_8)) {
			ZipEntry entry;
			while ((entry = zis.getNextEntry()) != null) {
				if (!entry.isDirectory()) {
					String fileName = Paths.get(entry.getName()).getFileName().toString();

					ByteArrayOutputStream baos = new ByteArrayOutputStream();
					StreamUtils.copy(zis, baos);
					byte[] fileBytes = baos.toByteArray();

					MultipartFile extracted = new ByteArrayMultipartFile("file", fileName,
							Files.probeContentType(Paths.get(fileName)), fileBytes);

					extractedFiles.add(extracted); // 압축 해제된 파일들 리스트에 추가
				}
			}
		}

		return extractedFiles;
	}

	/**
	 * @return 모바일 부분
	 */
	@RequestMapping("/dy/mobile.do")
	public ModelAndView MobileView(HttpServletRequest req,
			@RequestParam(value = "keyno", defaultValue = "0") String key,
			@RequestParam(value = "name", defaultValue = "인버터 1호") String name,
			@RequestParam(value = "DaliyType", defaultValue = "1") String DaliyType,
			@RequestParam(value = "searchBeginDate", required = false) String searchBeginDate,
			@RequestParam(value = "searchEndDate", required = false) String searchEndDate,
			@RequestParam(value = "InverterType", defaultValue = "0") String InverterType, HttpSession session)
			throws Exception {
		ModelAndView mv = new ModelAndView("/user/_DY/monitering/mobile/dy_mobile");

		HashMap<String, Object> type = new HashMap<String, Object>();
		// 아이디 세션에 있는값 저장
		Map<String, Object> user = CommonService.getUserInfo(req);

		if (user != null) {
			type.put("UI_KEYNO", user.get("UI_KEYNO").toString());
			type.put("UIA_NAME", user.get("UIA_NAME").toString());
		} else {
			mv = new ModelAndView("redirect:/user/member/login.do");
			return mv;
		}

		String sql = "main.select_MainData";
		String sql2 = "main.Power_SelectKEY";
		// 삼환관리자 처리부분
		if (SettingData.samwhan.equals(user.get("UIA_KEYNO").toString())) {
			sql = "main.select_MainData_Ad";
			sql2 = "main.Power_SelectKEY_Ad";
		}

		if (key.equals("0")) {
			// 1. 세션에 키값 저장확인
			key = (String) session.getAttribute("DPP_KEYNO");
		}
		// 2. 세션에 키값 없다면
		if (key == null || StringUtils.isEmpty(key)) {
			key = Component.getData(sql2, type);
			// 선택된 키값 세션 저장(초기 제일 상위 KEY값 저장)
		}
		session.setAttribute("DPP_KEYNO", key);
		List<HashMap<String, Object>> m_list = Component.getList(sql, type);

		if (m_list.size() == 0) {
			mv = new ModelAndView("/user/_DY/monitering/dy_none");
			mv.addObject("none", "none");
			return mv;
		}

		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		Date d = new Date();
		String now = format.format(d);

		type.put("InverterType", InverterType);

		mv.addObject("list", Component.getList(sql, type));

		type.put("type", key);
		type.put("name", name);

		// 인버터 데이터
		HashMap<String, Object> ob = Component.getData(sql, type);
		mv.addObject("ob", ob);

		// 당일일때만 오늘날짜 데이터 뽑는것
		type.put("minmax", "min");
		mv.addObject("mindata", Component.getData("main.daily_statistics_MinMax", type));
		type.put("minmax", "max");
		mv.addObject("maxdata", Component.getData("main.daily_statistics_MinMax", type));

		String area = ob.get("DPP_AREA").toString(); // 지역
//		List<HashMap<String, Object>> weather = Component.getList("Weather.select_Weather", area);

//		if (weather.size() > 0) {
//			mv.addObject("weatherToday", weather.get(1));
//			mv.addObject("weather", weather);
//		}

		mv.addObject("InverterType", InverterType);
		mv.addObject("DaliyType", DaliyType);

		DateFormat format2 = new SimpleDateFormat("yyyy");

		// 이번달 날짜 count
		Calendar c1 = Calendar.getInstance();
		Date Today = c1.getTime();
		c1.set(Calendar.DAY_OF_MONTH, 1);
		Date Fmon = c1.getTime();
		long diffDay = (Today.getTime() - Fmon.getTime()) / (24 * 60 * 60 * 1000);
		mv.addObject("month1Cnt", diffDay);

		format = new SimpleDateFormat("yyyy-MM");
		String nowd = format.format(c1.getTime());
		c1.add(Calendar.MONTH, -1);
		String pred = format.format(c1.getTime());
		c1.add(Calendar.MONTH, -1);
		String ppred = format.format(c1.getTime());

	Calendar c2 = Calendar.getInstance();
	c2.add(Calendar.YEAR, -1);
	String nowY = format2.format(c2.getTime()); // 작년

	type.put("date", "day");
	// 오남매 1호 전용 쿼리 사용 여부 결정 (25.08 분리 대응: 인버터 1,2호만 포함)
	String queryName = key.equals("95") ? "main.recent_sum_onam1" : "main.recent_sum";
	
	// 전월 누적치 차액(전달 - 전에전달)
	type.put("Conn_date", pred);
	float preC = Component.getData(queryName, type);

	type.put("Conn_date", ppred);
	float ppreC = Component.getData(queryName, type);
	mv.addObject("Prmonth", preC - ppreC);

	type.put("Conn_date", nowd);// 금월

	// 성진 1,2호 25.09월부터 발전시작한것으로 간주하기위한 데이터 처리(그전까지의 누적값을 뺌)
	float TodayCum = Component.getData(queryName, type);
	if (key.equals("113")) {
		preC = preC - 1491055.84f;      // 전월값에도 보정 적용
		TodayCum = TodayCum - 1491055.84f;  // 금월값에도 보정 적용
	}
	mv.addObject("month1", TodayCum - preC);

	type.put("date", "year");
	type.put("Conn_date", nowY);
	float YearCum = Component.getData(queryName, type);
	mv.addObject("year1", TodayCum - YearCum);

	return mv;
	}

	/**
	 * @return 모바일 통계
	 */
	@RequestMapping("/dy/mobileAjax.do")
	@ResponseBody
	public ModelAndView mobileAjax(HttpServletRequest req, HttpServletResponse res,
			@RequestParam(value = "keyno", defaultValue = "1") String keyno,
			@RequestParam(value = "searchBeginDate", required = false) String searchBeginDate,
			@RequestParam(value = "searchEndDate", required = false) String searchEndDate,
			@RequestParam(value = "InverterType", defaultValue = "0") String InverterType,
			@RequestParam(value = "DaliyType", defaultValue = "1") String DaliyType) throws Exception {
		ModelAndView mv = new ModelAndView("/user/_DY/monitering/ajax/dy_mobile_ajax");

		HashMap<String, Object> type = new HashMap<String, Object>();
		List<HashMap<String, Object>> result = new ArrayList<HashMap<String, Object>>();

		type.put("type", keyno);

		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		Date d = new Date();
		String now = format.format(d);

		if (searchBeginDate == null || searchBeginDate.equals("") || DaliyType.equals("1")) {
			searchBeginDate = now;
		}
		if (searchEndDate == null || searchEndDate.equals("") || DaliyType.equals("1")) {
			searchEndDate = now;
		}

		type.put("searchBeginDate", searchBeginDate);
		type.put("searchEndDate", searchEndDate);
		type.put("InverterType", InverterType);
		type.put("DaliyType", DaliyType);

		HashMap<String, Object> ob = Component.getData("main.select_MainData", type);
		// 당일일때만 오늘날짜 데이터 뽑는것
		type.put("minmax", "min");
		mv.addObject("mindata", Component.getData("main.daily_statistics_MinMax", type));
		type.put("minmax", "max");
		mv.addObject("maxdata", Component.getData("main.daily_statistics_MinMax", type));

		List<List<String>> MainList = new ArrayList<List<String>>();

		int numbering = Integer.parseInt(ob.get("DPP_INVER_COUNT").toString());

		if (DaliyType.equals("1")) {

//    		result =  Component.getList("main.select_inverterData",type);
//    		result =  changeDailyData(result);
			// 당일일때만 오늘날짜 데이터 뽑는것
			type.put("minmax", "min");
			mv.addObject("mindata", Component.getData("main.daily_statistics_MinMax", type));
			type.put("minmax", "max");
			mv.addObject("maxdata", Component.getData("main.daily_statistics_MinMax", type));

			// 리스트 숫자에 맞게 투입 (종합일때) 그래프 처리
			// MainList.add(Component.getList("main.select_inverterData_date",type)); //날짜
			// 먼저 등록
			List<String> TenM = new ArrayList<>(Arrays.asList(
					new String[] { "06:00", "06:30", "07:00", "07:30", "08:00", "08:30", "09:00", "09:30", "10:00",
							"10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00",
							"15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "18:30", "19:00", "19:30" }));
			MainList.add(TenM);

			if (InverterType.equals("0")) {
				// ✅ 최적화: 모바일 페이지도 단일 쿼리로 조회 (10-20개 쿼리 → 1개)
				List<HashMap<String, Object>> allData = Component.getList("main.select_inverterData_active_optimized", type);
				
				// 인버터별, 시간대별로 데이터를 Map에 저장 (시간대를 키로 사용)
				Map<String, Map<String, String>> inverterTimeDataMap = new HashMap<>();
				for (HashMap<String, Object> row : allData) {
					String diName = (String) row.get("DI_NAME");
					String timeSlot = (String) row.get("time_slot");
					String power = String.valueOf(row.get("power"));
					
					if (diName != null && timeSlot != null) {
						inverterTimeDataMap.computeIfAbsent(diName, k -> new HashMap<>()).put(timeSlot, power);
					}
				}
				
				// MainList에 인버터 순서대로 추가
				for (int i = 1; i <= numbering; i++) {
					String inverterName = "인버터 " + i + "호";
					Map<String, String> timeDataMap = inverterTimeDataMap.getOrDefault(inverterName, new HashMap<>());
					
					// TenM 시간대 리스트를 기준으로 순서대로 데이터 매핑
					List<String> subList = new ArrayList<>();
					for (String timeSlot : TenM) {
						// 해당 시간대의 데이터가 있으면 사용, 없으면 "0"
						String power = timeDataMap.getOrDefault(timeSlot, "0");
						subList.add(power);
					}
					
					MainList.add(subList);
				}
			} else {
				type.put("inverterNum", InverterType);
				List<String> subList = Component.getList("main.select_inverterData_active", type); // 인버터 개별 등록
				MainList.add(subList);
			}
		} else {
//    		result =  Component.getList("main.select_inverterData_other",type);

			// 최대 최솟값 날짜랑 데이터 뽑기
			type.put("minmax", "min");
			mv.addObject("mindata", Component.getData("main.select_inverterData_other_MINMAX", type));
			type.put("minmax", "max");
			mv.addObject("maxdata", Component.getData("main.select_inverterData_other_MINMAX", type));
			// avg,sum
			mv.addObject("avgdata", Component.getData("main.select_inverterData_other_AVGSUM", type));
		}

		mv.addObject("MainList", MainList);
		mv.addObject("InverterType", InverterType);
		mv.addObject("DaliyType", DaliyType);
		mv.addObject("searchBeginDate", searchBeginDate);
		mv.addObject("searchEndDate", searchEndDate);
		mv.addObject("ob", ob);
		mv.addObject("result", result);

		return mv;
	}

	/**
	 * 안전관리자 부분
	 */
	@RequestMapping("/dy/moniter/stastics2.do")
	public ModelAndView stastics2(HttpServletRequest req,
			@RequestParam(value = "DPP_KEYNO", defaultValue = "0") String key, HttpSession session,
			@RequestParam(value = "DaliyType", defaultValue = "1") String DaliyType,
			@RequestParam(value = "searchBeginDate", required = false) String searchBeginDate,
			@RequestParam(value = "searchEndDate", required = false) String searchEndDate,
			@RequestParam(value = "InverterType", defaultValue = "0") String InverterType) throws Exception {
		ModelAndView mv = new ModelAndView("/user/_DY/monitering/dy_statstics2");
		HashMap<String, Object> type = new HashMap<String, Object>();

		Map<String, Object> user = CommonService.getUserInfo(req);
		type.put("UI_KEYNO", user.get("UI_KEYNO").toString());
		type.put("UIA_NAME", user.get("UIA_NAME").toString());

		if (key.equals("0")) {
			key = (String) session.getAttribute("DPP_KEYNO");
		}
		if (key == null || StringUtils.isEmpty(key)) {
			key = Component.getData("main.Power_SelectKEY", type);
		}
		session.setAttribute("DPP_KEYNO", key);
		mv.addObject("list", Component.getList("main.select_MainData", type));

		type.put("type", key);
		HashMap<String, Object> ob = Component.getData("main.select_MainData", type);

		mv.addObject("ob", ob);
		mv.addObject("DPP_KEYNO", key);

		mv.addObject("InverterType", InverterType);
		mv.addObject("DaliyType", DaliyType);
		mv.addObject("searchBeginDate", searchBeginDate);
		mv.addObject("searchEndDate", searchEndDate);

		return mv;
	}

	/**
	 * @return 통계 분석 ajax
	 */
	@RequestMapping("/dy/moniter/stasticsAjax2.do")
	@ResponseBody
	public ModelAndView stasticsAjax2(HttpServletRequest req,
			@RequestParam(value = "keyno", defaultValue = "1") String keyno,
			@RequestParam(value = "searchBeginDate", required = false) String searchBeginDate,
			@RequestParam(value = "searchEndDate", required = false) String searchEndDate,
			@RequestParam(value = "InverterType", defaultValue = "0") String InverterType,
			@RequestParam(value = "DaliyType", defaultValue = "1") String DaliyType) throws Exception {
		ModelAndView mv = new ModelAndView("/user/_DY/monitering/ajax/dy_statstics_ajax2");

		HashMap<String, Object> type = new HashMap<String, Object>();
		type.put("type", keyno);

	DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	Date d = new Date();
	String now = format.format(d);

	if (searchBeginDate == null || StringUtils.isEmpty(searchBeginDate)) {
		searchBeginDate = now;
	}
	if (searchEndDate == null || StringUtils.isEmpty(searchEndDate)) {
		searchEndDate = now;
	}

		type.put("searchBeginDate", searchBeginDate);
		type.put("searchEndDate", searchEndDate);
		type.put("InverterType", InverterType);

		HashMap<String, Object> ob = Component.getData("main.select_MainData", type);

		// ✅ 최적화: 느린 쿼리 대신 최적화된 쿼리 사용 (7초 → 0.1초)
		List<HashMap<String, Object>> result = Component.getList("main.select_inverterData_daily_optimized", keyno);
		// changeDailyData 불필요 - 이미 계산됨
		// result = changeDailyData(result);

		List<HashMap<String, Object>> charList = Component.getList("main.Statics_Two", type);

		HashMap<String, Object> tempList = new HashMap<String, Object>();
		HashMap<String, Object> map = new HashMap<String, Object>();

		List<String> dates = Component.getListNoParam("main.Statics_date");
		int tempNum = 0;
		int tempSd = 0;

		for (int i = tempNum; i < charList.size(); i++) {

			String sd = charList.get(i).get("subDate").toString();
			String name = charList.get(i).get("DI_NAME").toString();

			if (!map.containsKey(name)) {
				tempSd = 0;
			}

			float f = 0;
			float n = Float.parseFloat(charList.get(i).get("Daily_Generation").toString());

			for (int j = tempSd; j < dates.size(); j++) {

				String dd = dates.get(j).toString();

				if (sd.equals(dd)) {
					if (map.containsKey(name)) {
						f = n - Float.parseFloat(tempList.get(name).toString());
						tempList.put(name, n);
						String ii = map.get(name).toString();
						ii = ii + "," + f;
						map.put(name, ii);
					} else {
						f = n;
						tempList.put(name, f);
						map.put(name, f);
					}
					if ((i + 1) != charList.size()) {
						if (name.equals(charList.get(i + 1).get("DI_NAME").toString())) {
							tempNum = i + 1;
							tempSd = j + 1;
							break;
						}
					}
				} else {
					if (map.containsKey(name)) {
						f = 0;
						tempList.put(name, n);
						String ii = map.get(name).toString();
						ii = ii + "," + f;
						map.put(name, ii);
					} else {
						f = 0;
						tempList.put(name, f);
						map.put(name, f);
					}
				}
			}
		}

		List<String[]> MainList = new ArrayList<String[]>();

		for (int i = 0; i < map.size(); i++) {
			String m = map.get("인버터 " + (i + 1) + "호").toString();
			String[] ml = m.split(",");
			MainList.add(ml);
		}

		mv.addObject("MainList", MainList);

		mv.addObject("InverterType", InverterType);
		mv.addObject("DaliyType", DaliyType);
		mv.addObject("searchBeginDate", searchBeginDate);
		mv.addObject("searchEndDate", searchEndDate);
		mv.addObject("ob", ob);
		mv.addObject("result", result);
		return mv;
	}

	/**
	 * @return 알림톡 - 안전관리자 게시물 등록확인 (관리자그룹에 전송)
	 */
	@RequestMapping("/allimTalkAjax.do")
	@ResponseBody
	public String allimTalk(HttpServletRequest req, @RequestParam(value = "bnkey", required = false) String BN_KEYNO,
			@RequestParam(value = "key", required = false) String DPP_KEYNO,
			@RequestParam(value = "title", required = false) String title,
			@RequestParam(value = "name", required = false) String name) throws Exception {

		String msg = "성공";
		HashMap<String, Object> map = Component.getData("main.PowerOneSelect", DPP_KEYNO);

		String contents = name + "(이)가 \n발전소 : " + map.get("DPP_NAME").toString() + "의 \n게시물 : " + title
				+ " (를)을\n확인하였습니다.";
		// 토큰받기
		String tocken = requestAPI.TockenRecive(SettingData.Apikey, SettingData.Userid);
		tocken = URLEncoder.encode(tocken, "UTF-8");

		// 리스트 뽑기 - 현재 게시물 알림은 index=1
		JSONObject jsonObj = requestAPI.KakaoAllimTalkList(SettingData.Apikey, SettingData.Userid,
				SettingData.Senderkey, tocken);
		JSONArray jsonObj_a = (JSONArray) jsonObj.get("list");
		jsonObj = (JSONObject) jsonObj_a.get(6); // 발전소 게시물 확인

		// 확인 눌렀을때 현재 - 슈퍼관리자한테만
		List<UserDTO> list = Component.getListNoParam("main.NotUserData_Admin");
		String Sendurl = "http://dymonitering.co.kr/";
		for (UserDTO l : list) {
			l.decode();
			String phone = l.getUI_PHONE().toString().replace("-", "");
			// 받은 토큰으로 알림톡 전송
			requestAPI.KakaoAllimTalkSend(SettingData.Apikey, SettingData.Userid, SettingData.Senderkey, tocken,
					jsonObj, contents, phone, Sendurl);
		}

		Component.updateData("main.UpdateBNcheck", BN_KEYNO);

		return msg;
	}

	/*
	 * @RequestMapping("/sendMessage.do")
	 * 
	 * @ResponseBody public <E> String kakakosendAjax(HttpServletRequest req,
	 * 
	 * @RequestParam(value="UI_KEYNO",required=false)String user,
	 * 
	 * @RequestParam(value="content",required=false)String content ) throws
	 * Exception{
	 * 
	 * String[] userlist = user.split(",");
	 * 
	 * HashMap<String, Object> map = new HashMap<String, Object>();
	 * map.put("userlist", userlist);
	 * 
	 * 
	 * String msg1 = "성공";
	 * 
	 * 
	 * String userid = "daeyang"; String api = "qcp255q389pcsb3ddunfcb7ys93kbnli";
	 * String destination = user; String receiver = ""; String msg = content;
	 * 
	 * List<UserDTO> list = Component.getList("main.Kakaotalk_ad",map);
	 * 
	 * for(UserDTO l : list) { l.decode(); receiver =
	 * l.getUI_PHONE().toString().replace("-", ""); destination =
	 * l.getUI_NAME().toString(); //requestAPI.sendMessage(userid, api,
	 * destination,receiver, msg); }
	 * 
	 * 
	 * return msg1; }
	 */

//    @RequestMapping("/userkakakoAjax.do")
//    @ResponseBody
//    public <E> String kakakosendAjax(HttpServletRequest req,
//    		@RequestParam(value="UI_KEYNO",required=false)String user,
//    		@RequestParam(value="content",required=false)String content
//    		) throws Exception{
//    	
//    	
//    	String[] userlist = user.split(",");
////    	List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
//    	HashMap<String, Object> map = new HashMap<String, Object>();
//    	map.put("userlist", userlist);
//    	
//    	String msg = "성공";
//    	
////    	String contents = name+"(이)가 \n발전소 : "+map.get("DPP_NAME").toString()+"의 \n게시물 : "+title+" (를)을\n확인하였습니다.";
//    	String contents = content+"에 새로운 게시물이 등록되었습니다. 확인해주세요.";
//    	//토큰받기
//    	String tocken = requestAPI.TockenRecive(SettingData.Apikey,SettingData.Userid);
//    	tocken = URLEncoder.encode(tocken, "UTF-8");
//    	
//    	//리스트 뽑기 - 현재 게시물 알림은 index=1
//    	JSONObject jsonObj = requestAPI.KakaoAllimTalkList(SettingData.Apikey,SettingData.Userid,SettingData.Senderkey,tocken);
//    	JSONArray jsonObj_a = (JSONArray) jsonObj.get("list");
//    	jsonObj = (JSONObject) jsonObj_a.get(5); //템플릿 리스트 
//    	
//    	List<UserDTO> list = Component.getList("main.Kakaotalk_ad",map);
//    	String Sendurl  = "http://dymonitering.co.kr/"; 
//    	for(UserDTO l : list) {
//    		l.decode();
//    		String phone = l.getUI_PHONE().toString().replace("-", "");
//    		//받은 토큰으로 알림톡 전송		
//    		requestAPI.KakaoAllimTalkSend(SettingData.Apikey,SettingData.Userid,SettingData.Senderkey,tocken,jsonObj,contents,phone,Sendurl);
//    	}
//    	
//    	
//    	return msg;
//    }

	/**
	 * @return 날씨 등록 테스트
	@RequestMapping("/wether.do")
	public void wether(HttpServletRequest req) throws Exception {

		ModelAndView mv = new ModelAndView("");
		WetherService w = new WetherService();
		String[] regionL = { "나주", "광주", "해남", "화성", "세종", "영암", "김제", "곡성", "남원", "음성", "진천", "부산", "부안", "안성", "포천" };
		Component.deleteData("Weather.Daily_WeatherDelete");

		for (String r : regionL) {
			ArrayList<String> list = w.Daily_Wether(r);
			list.addAll(w.Sunrise_setData(r));
			WeatherOrganize(list);
		}
//		List<HashMap<String, Object>> list = Component.getListNoParam("sub.hourData");
//		Component.getData("sub.inserthourDetail",list);
	}
	 */

	/**
	 * @return
	 */
	/*
	 * @RequestMapping("/testxlsx.do") public void testxlsx(HttpServletRequest req)
	 * throws Exception{ String path =
	 * "D:/workspace/dysystem/src/main/webapp/resources/temp/b.xlsx"; //String text
	 * = filetool.excelRead(); // check file File file = new File(path); if
	 * (!file.exists() || !file.isFile() || !file.canRead()) { throw new
	 * IOException(path); }
	 * 
	 * // Workbook XSSFWorkbook wb = new XSSFWorkbook(new FileInputStream(file));
	 * 
	 * // Text Extraction ExcelExtractor extractor = new XSSFExcelExtractor(wb);
	 * extractor.setFormulasNotResults(true); extractor.setIncludeSheetNames(false);
	 * System.out.println( extractor.getText() );
	 * 
	 * // Getting cell contents for( int i=0; i<wb.getNumberOfSheets(); i++) { for(
	 * Row row : wb.getSheetAt(i) ) { System.out.print("row : " + row.getRowNum());
	 * 
	 * ArrayList<String> list = new ArrayList<String>();
	 * 
	 * list.add("전기업"); list.add("태양광발전업"); for( Cell cell : row ) {
	 * System.out.print(cell.getColumnIndex()); System.out.print(" - ");
	 * 
	 * String value = ""; System.out.println(cell.getCellType());
	 * if(cell.getCellType() == CellType.NUMERIC) { Long roundVal =
	 * Math.round(cell.getNumericCellValue()); Double doubleVal =
	 * cell.getNumericCellValue(); if (doubleVal.equals(roundVal.doubleValue())) {
	 * value = String.valueOf(roundVal); } else { value = String.valueOf(doubleVal);
	 * } }else { value = cell.getRichStringCellValue().toString(); }
	 * list.add(value); } Component.updateData("sub.excelsuppl", list); } }
	 * 
	 * }
	 * 
	 * 
	 * @RequestMapping("/exceltext.do") public void exceltext(HttpServletRequest
	 * req) throws Exception{ String path =
	 * "D:/dy/src/main/webapp/resources/aa.xlsx"; //String text =
	 * filetool.excelRead(); // check file File file = new File(path); if
	 * (!file.exists() || !file.isFile() || !file.canRead()) { throw new
	 * IOException(path); }
	 * 
	 * // Workbook XSSFWorkbook wb = new XSSFWorkbook(new FileInputStream(file));
	 * 
	 * // Text Extraction ExcelExtractor extractor = new XSSFExcelExtractor(wb);
	 * extractor.setFormulasNotResults(true); extractor.setIncludeSheetNames(false);
	 * System.out.println( extractor.getText() );
	 * 
	 * // Getting cell contents for( int i=0; i<wb.getNumberOfSheets(); i++) { for(
	 * Row row : wb.getSheetAt(i) ) { if (row.getRowNum() > 2) {
	 * System.out.print("row : " + row.getRowNum());
	 * 
	 * ArrayList<String> list = new ArrayList<String>(); list.add("전기업");
	 * list.add("태양광 발전업"); for( Cell cell : row ) {
	 * System.out.print(cell.getColumnIndex()); System.out.print(" - ");
	 * 
	 * String value = ""; System.out.println(cell.getCellType());
	 * if(cell.getCellType() == CellType.NUMERIC) { Long roundVal =
	 * Math.round(cell.getNumericCellValue()); Double doubleVal =
	 * cell.getNumericCellValue(); if (doubleVal.equals(roundVal.doubleValue())) {
	 * value = String.valueOf(roundVal); } else { value = String.valueOf(doubleVal);
	 * } }else { value = cell.getRichStringCellValue().toString(); }
	 * 
	 * if(cell.getColumnIndex() == 1) { value = value.replace("-",""); }
	 * 
	 * list.add(value); System.out.println(value); }
	 * Component.createData("sub.excelsuppl", list);
	 * 
	 * } } }
	 * 
	 * }
	 */
	
/*
	public void WeatherOrganize(ArrayList<String> weatherList) {
		// 혹시모를 갯수 체크
		int count = Integer.parseInt(weatherList.get(weatherList.size() - 4));

		for (int i = 0; i < count; i++) {
			HashMap<String, Object> map = new HashMap<String, Object>();
			// 시간 0
			map.put("date", weatherList.get(i).toString());
			// 날씨 0+5 * 1
			map.put("weather", weatherList.get(i + count * 1).toString());
			// 강수 0+5 * 2
			map.put("rn1", weatherList.get(i + count * 2).toString());
			// 강수 0+5 * 3
			map.put("sky", weatherList.get(i + count * 3).toString());
			// 온도 0+5 * 4
			map.put("t1h", weatherList.get(i + count * 4).toString());
			// 습도 0+5 * 5
			map.put("reh", weatherList.get(i + count * 5).toString());
			// 풍속 0+5 * 6
			map.put("wsd", weatherList.get(i + count * 6).toString());
			// 지역
			map.put("region", weatherList.get((weatherList.size() - 3)).toString());
			// 일출
			map.put("sunrise", weatherList.get((weatherList.size() - 2)).toString());
			// 일몰
			map.put("sunset", weatherList.get((weatherList.size() - 1)).toString());
			Component.createData("Weather.Daily_WeatherData", map);
		}
	}
*/
	@RequestMapping("/ttest.do")
	public void ttest(HttpServletRequest req) throws Exception {

		 List<HashMap<String,Object>> list = Component.getListNoParam("main.selectPower");

		 for(HashMap<String,Object> l : list) {

		 String keyno = l.get("DPP_KEYNO").toString();
		//String keyno = "31";

			// 1단계: 중복 데이터 삭제 (dy_detail_data는 제외 - inverter_data 복사 시점에 이미 정리된 상태 반영)
			Component.deleteData("sub2.deleteDuplicateInverterData", keyno); // dy_inverter_data
			Component.deleteData("sub2.deleteDuplicateMainData", keyno); // dy_inverter_data_main
			
			// 2단계: 2년 넘은 데이터 완전 삭제
			Component.deleteData("sub2.deleteOver2Years", keyno); // dy_inverter_data
			Component.deleteData("sub2.deleteMainOver2Years", keyno); // dy_inverter_data_main
			
			// 3단계: 2년 전까지의 데이터 정리 (인버터별 최신값만 남기기)
			// 2년 = 730일
			for (int i = 730; i > 0; i--) {
	
				System.out.print("day : ");
				System.out.println(i);
	
				HashMap<String, Object> map = new HashMap<String, Object>();
	
				map.put("day", i);
				map.put("keyno", keyno);
	
				Component.deleteData("sub2.deleteMain", map);
	
				List<String> slist = Component.getList("sub2.recent_date", map);
	
				map.put("list", slist);
				if (slist.size() > 0) {
					Component.deleteData("sub2.deleteToday", map);
				}
			}
		 }
	}

	/* 25/11/06 inverter data 수동등록 메소드
	 * @RequestMapping("/ttest2.do") public void ttest2(HttpServletRequest req)
	 * throws Exception {
	 * 
	 * List<HashMap<String,Object>> list =
	 * Component.getListNoParam("main.selectPower");
	 * 
	 * for(HashMap<String,Object> l : list) {
	 * 
	 * String keyno = l.get("DPP_KEYNO").toString();
	 * 
	 * List<HashMap<String,Object>> detaildata =
	 * Component.getList("sub2.detailselect", keyno);
	 * 
	 * if(detaildata.size()> 0) {
	 * Component.getData("sub2.insertInverterData",detaildata); }
	 * 
	 * } }
	 */
	
	
	
	
	
	
	
	
	@RequestMapping(value = "/imageCreate.do")
	@ResponseBody
	public ModelMap ImgSaveTest(@RequestParam HashMap<Object, Object> param, final HttpServletRequest request,
			final HttpServletResponse response) throws Exception {
		ModelMap map = new ModelMap();

		String binaryData = request.getParameter("imgSrc");
		FileOutputStream stream = null;
		try {
			System.out.println("binary file   " + binaryData);
			if (binaryData == null || binaryData.trim().equals("")) {
				throw new Exception();
			}
			binaryData = binaryData.replaceAll("data:image/png;base64,", "");
			byte[] file = Base64.decodeBase64(binaryData);
			String fileName = UUID.randomUUID().toString();

			stream = new FileOutputStream("D:/" + fileName + ".png");
			stream.write(file);
			stream.close();
			System.out.println("캡처 저장");

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("에러 발생");
		} finally {
			if (stream != null) {
				stream.close();
			}
		}

		map.addAttribute("resultMap", "");
		return map;
	}

	public List<HashMap<String, Object>> changeDailyData(List<HashMap<String, Object>> result) {
		HashMap<String, Object> result_d = new HashMap<String, Object>();

		Collections.reverse(result);

		for (HashMap<String, Object> r : result) {

			String diname = r.get("DI_NAME").toString();
			float cData = 0;

			if (result_d.containsKey(diname)) {
				float FirstData = Float.parseFloat(result_d.get(diname).toString());
				float nowData = Float.parseFloat(r.get("Cumulative_Generation").toString());

				float dailyData = (nowData - FirstData);
				r.put("daily", dailyData);
			} else {
				cData = Float.parseFloat(r.get("Cumulative_Generation").toString());
				result_d.put(diname, cData);
				r.put("daily", 0);
			}
		}

		Collections.reverse(result);

		return result;
	}

//   @RequestMapping("/allimTalkSend.do")
//   @ResponseBody
//   public void allimTalkSend(HttpServletRequest req) throws Exception{

//   	String msg = "성공";
//   	
//   	//토큰받기
//   	String tocken = requestAPI.TockenRecive(SettingData.Apikey,SettingData.Userid);
//   	tocken = URLEncoder.encode(tocken, "UTF-8");
//   	
//   	//리스트 뽑기 - 현재 게시물 알림은 index=1
//   	JSONObject jsonObj = requestAPI.KakaoAllimTalkList(SettingData.Apikey,SettingData.Userid,SettingData.Senderkey,tocken);
//   	JSONArray jsonObj_a = (JSONArray) jsonObj.get("list");
//   	jsonObj = (JSONObject) jsonObj_a.get(1); //발전소 게시물 확인
//   	
//   	//받은 토큰으로 알림톡 전송		
////   	requestAPI.KakaoAllimTalkSend(SettingData.Apikey,SettingData.Userid,SettingData.Senderkey,tocken,jsonObj,"");
//   	
//   	return msg;

//	   try {
//			List<HashMap<String,Object>> list = Component.getListNoParam("main.selectPower");
//			
//			for(HashMap<String,Object> l : list) {
//				
//				
//				HashMap<String,Object> map = new HashMap<String, Object>();
//				
//				String keyno = l.get("DPP_KEYNO").toString();
//				
//				Component.deleteData("main.deleteMain",keyno);
//				
//				List<String> slist = Component.getList("main.recent_date", keyno);
//				
//				if(slist != null && slist.size() > 0) {
//					map.put("list", slist);
//					map.put("keyno", keyno);
//					
//					Component.deleteData("main.deleteToday", map);
//				}
//				
//				
//			}
//		}catch (Exception e) {
//			System.out.println(e);
//		}
//	   
//   }
	
}