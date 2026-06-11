package com.tx.common.service.member.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.plexus.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.dto.TilesDTO;
import com.tx.common.security.password.MyPasswordEncoder;
import com.tx.common.security.rsa.service.RsaService;
import com.tx.common.security.service.AuthenticationSessionService;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.admin.site.dto.SiteManagerDTO;
import com.tx.dyAdmin.admin.site.service.SiteService;
import com.tx.dyAdmin.member.dto.UserDTO;
import com.tx.dyAdmin.member.dto.UserSettingDTO;
import com.tx.dyUser.dto.SerialDTO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 
 * @FileName: LoginController.java
 * @Project : demo
 * @Date    : 2017. 02. 06. 
 * @Author  : 이재령	
 * @Version : 1.0
 */
@Controller
public class CommonMemberController {
	
	private static final Logger logger = LoggerFactory.getLogger(CommonMemberController.class);

	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 암호화 */
	@Autowired MyPasswordEncoder passwordEncoder;
	
	/** RSA */
	@Autowired RsaService RsaService;
	@Autowired SiteService SiteService;
	@Autowired AuthenticationSessionService AuthenticationSessionService;
	
	@RequestMapping(value="/user/member/login.do")
	public ModelAndView memberLogion(HttpServletRequest req, Map<String,Object> commandMap
			, @Valid TilesDTO TilesDTO
			,HttpSession session
			,HttpServletResponse res
			) throws Exception {
		String tiles = TilesDTO.getTiles(req);
		
		Map<String, Object> user = CommonService.getUserInfo(req);
		
		ModelAndView mv  = new ModelAndView();
		
		//로그인한 상태라면 각 tiles에 맞는 메인화면으로 리다이렉트
		if(user != null){
			//ID에 맞게 tiles 변경(임시)
			if(user.get("UI_ID").equals("daeyang0715")) {
				tiles = "dy";
			}else if(user.get("UI_ID").equals("dyesco0715")){
				tiles = "sfa";
			}
			
			mv.setViewName("redirect:/"+tiles+"/index.do");
			return mv;
			
		//로그인한 상태가 아니라면 tiles = dy로 바꿔서 로그인 페이지로
		}else {
			if( tiles == null || tiles.equals("cf") ||tiles.equals("sfa") || tiles.equals("bd")) tiles = "dy";
			mv.setViewName("/user/"+SiteService.getSitePath(tiles)+"/member/prc_login");
		}
		
	
		SiteManagerDTO SiteManagerDTO =  Component.getData("SiteManager.getData",SiteProperties.getCmsUser());
		mv.addObject("SiteManager", SiteManagerDTO);
		
		
		//리턴페이지 셋팅
		if(req.getParameter("returnPage") != null){
			session.setAttribute("returnPage", req.getParameter("returnPage"));
		}else if(session.getAttribute("referrerPage") == null){
			session.setAttribute("referrerPage", req.getHeader("Referer"));
		}
		
		//에러메세지 셋팅
		if(req.getSession().getAttribute("customExceptionmsg") != null){
			mv.addObject("customExceptionmsg",req.getSession().getAttribute("customExceptionmsg"));
			req.getSession().removeAttribute("customExceptionmsg");
		}
		
			
		//RsaService.setRsa(req);
		mv.addObject("tiles",tiles);
		
		mv.addObject("mirrorPage", "/"+tiles+"/member/login.do");
		
		
		return mv;
	}
	
	@RequestMapping(value="/{tiles}/naver/callback.do")
	public ModelAndView naverLoginfCallback(HttpServletRequest req, Map<String,Object> commandMap
			,@PathVariable String tiles
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/user/"+SiteService.getSitePath(tiles)+"/member/naver_callback.notiles");
		SiteManagerDTO SiteManagerDTO =  Component.getData("SiteManager.getData",SiteProperties.getCmsUser());
		mv.addObject("SiteManager", SiteManagerDTO);
		return mv;
	}
	
	
	@RequestMapping(value="/{tiles}/reward/snsLoginAjax.do")
	@Transactional
	@ResponseBody
	public boolean snsLogin(HttpServletRequest req
			, @PathVariable String tiles
			, UserDTO UserDTO
			, @RequestParam(value="uniqId", required=false, defaultValue="") String sns_uniqId
			, @RequestParam(value="name", required=false, defaultValue="") String sns_name
			, @RequestParam(value="email", required=false, defaultValue="") String sns_email
			, @RequestParam(value="type", required=false, defaultValue="") String sns_type
			) throws Exception {
		
		boolean check = false;
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("uniqId", sns_uniqId);
		paramMap.put("type", sns_type);
		
		UserDTO user = Component.getData("member.getSnsMember", paramMap);
		
		if(user == null) {
			// 신규 가입처리
			//String encryptionPW = passwordEncoder.encode("$sns_" + sns_type + "_pw_" + sns_uniqId);
			
			UserDTO.setUI_KEYNO(CommonService.getTableKey("UI"));
			UserDTO.setUI_NAME(sns_name);
			UserDTO.setUI_REP_NAME(sns_name);
			UserDTO.setUI_SNS_ID(sns_uniqId);
			UserDTO.setUI_EMAIL(sns_email);
			UserDTO.setUI_SNS_TYPE(sns_type);
			UserDTO.setUI_ID("$sns_" + sns_type + "_id_" + sns_uniqId);
			UserDTO.setUI_AUTH_YN("Y");
			UserDTO.encode();	
			Component.createData("member.UI_snsInsert", UserDTO);
			
			// 권한부여
			UserSettingDTO setting = Component.getData("member.US_getData", tiles);
			if(setting.getUS_UIA_KEYNO() != null && !setting.getUS_UIA_KEYNO().equals("")){
				Map<String, Object> map = new HashMap<String,Object>();
				map.put("UI_KEYNO", UserDTO.getUI_KEYNO());
				map.put("UIA_KEYNO", setting.getUS_UIA_KEYNO().split(","));
				Component.createData("member.UI_setAuthority", map);
			}
			
			user = Component.getData("member.getSnsMember", paramMap);
		}
		
		if(user != null) {
			// 스프링 권한 인증
			Collection<SimpleGrantedAuthority> roles = new ArrayList<SimpleGrantedAuthority>();
			String authority[] = user.getUIA_NAME().split(",");
			for(String auth : authority){
				roles.add(new SimpleGrantedAuthority(auth));
			}
			user.setAuthorities(roles);
			Collection<? extends GrantedAuthority> authorities = user.getAuthorities();
			
			Authentication authentication = new UsernamePasswordAuthenticationToken(user, user.getUI_PASSWORD(), authorities);
	        SecurityContextHolder.getContext().setAuthentication(AuthenticationSessionService.updateAuthentication(authentication, user.getUI_ID()+"", req));
			check = true;
	        
			return check;
		}
		
		return check;
	}
	
	
	
	@RequestMapping(value="/user/login/denied.do")
	@CheckActivityHistory(desc="접근 거부 페이지 방문")
	public ModelAndView loginDenied(HttpServletRequest req
			) throws Exception {
		
		return new ModelAndView("/error/denied");
	}
	
	/**
	 * 로그 아웃 후 홈페이지 분기처리
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/common/logout.do")
	public ModelAndView logout(HttpServletRequest req
			) throws Exception {
		ModelAndView mv  = new ModelAndView("redirect:/");
		String tiles = (String)req.getSession().getAttribute("currentTiles");
		
		if(StringUtils.isNotEmpty(tiles)){
			mv.setViewName("redirect:/"+tiles+"/index.do");
		}
		return mv;
	}
	
	/**
	 * 아이디 중복체크 , 금지단어 체크
	 * @param req
	 * @param UserDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/common/member/regist/checkIdEmailAjax.do")
	@ResponseBody
	public String commonMemberRegistCheck(HttpServletRequest req
			, UserDTO UserDTO
			, @RequestParam(value="tiles") String tiles
			
			) throws Exception {
		
		String result = Component.getData("member.UI_checkIdAndEmail", UserDTO);
		if(result != null && result.contains("id")){
			return "id";
		}
		
		UserSettingDTO setting = Component.getData("member.US_getData",tiles);
		if(setting != null){
			//금지단어 체크
			if(UserDTO.getUI_ID()!= null && !UserDTO.getUI_ID().equals("")){
				String UI_ID = UserDTO.getUI_ID();
//			System.out.println("아이디 : "+UI_ID );
				for(String f : setting.getUS_ID_FILTER().split(",")){
					if(UI_ID.contains(f)){
						return "idFilter";
					}
				}
			}
			
			if(UserDTO.getUI_NAME()!= null && !UserDTO.getUI_NAME().equals("")){
				String UI_NAME = UserDTO.getUI_NAME();
				for(String f : setting.getUS_ID_FILTER().split(",")){
					if(UI_NAME.contains(f)){
						return "nameFilter";
					}
				}
			}
		}
		return "ok";
		
	}
	
	/**
	 * 금지단어 체크
	 * @param req
	 * @param ResearchSkinDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/common/member/update/forbiddenWorkdCheckAjax.do")
	@ResponseBody
	public String commonMemberUpdateForbiddenWorkdCheckAjax(HttpServletRequest req
			, @RequestParam(value="tiles") String tiles
			, @RequestParam(value="text") String text
			) throws Exception {
		
		UserSettingDTO setting = Component.getData("member.US_getData",tiles);
		if(setting != null){
			//금지단어 체크
			if(StringUtils.isNotEmpty(text)){
				for(String f : setting.getUS_ID_FILTER().split(",")){
					if(text.contains(f)){
						return "F";
					}
				}
			}
		}
		return "S";
		
	}
	
	
	/**
	 * 비밀번호 체크
	 * @param req
	 * @param UserDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/common/member/update/checkPassword.do")
	@ResponseBody
	public boolean commonMemberUpdateCheckPassword(HttpServletRequest req
			, UserDTO UserDTO
			) throws Exception {
		
		Map<String, Object> user = CommonService.getUserInfo(req);
		
		String password = user.get("UI_PASSWORD")+"";
		
		return passwordEncoder.matches(UserDTO.getUI_PASSWORD(), password);
		
	}
	
	/**
	 * 아이디 체크
	 * @param req
	 * @param UserDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/common/member/update/checkId.do")
	@ResponseBody
	public boolean commonMemberUpdateCheckId(HttpServletRequest req
			, UserDTO UserDTO
			, @RequestParam(value="tiles") String tiles
			) throws Exception {
		int result = Component.getCount("member.UI_checkId", UserDTO);
		
		if(result == 1){
			return true;
		}else{
			UserSettingDTO setting = Component.getData("member.US_getData",tiles);
			//금지단어 체크
			if(setting !=null && setting.getUS_ID_FILTER() !=null && !setting.getUS_ID_FILTER().equals("")) {
				if(UserDTO.getUI_ID()!= null && !UserDTO.getUI_ID().equals("")){
					String UI_ID = UserDTO.getUI_ID();
					for(String f : setting.getUS_ID_FILTER().split(",")){
						if(UI_ID.contains(f)){
							return true;
						}
					}
				}
			}
			return false;
		}
	}
	
	/**
	 * 비밀번호 체크
	 * @param req
	 * @param UserDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/common/member/update/checkPwd.do")
	@ResponseBody
	public boolean commonMemberUpdateCheckPwd(HttpServletRequest req
			, UserDTO UserDTO
			, @RequestParam(value="type",required=false) String type
			) throws Exception {
		
		
		String encPwd = null;
		if(type != null && "admin".equals(type)){
			Map<String, Object> user = CommonService.getUserInfo(req);
			if(user != null){
				encPwd = (String)user.get("UI_PASSWORD");
			}
		}else{
			UserDTO user = Component.getData("member.UI_IdCheck", UserDTO);
			encPwd = user.getUI_PASSWORD();
		}
		
		if(StringUtils.isEmpty(encPwd)){
			return false;
		}
		
		return passwordEncoder.matches(UserDTO.getUI_PASSWORD(), encPwd);
	}
	
	
	/**
	 * 금지단어 체크
	 * @param req
	 * @param UserDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/common/member/update/checkIdEmailAjax.do")
	@ResponseBody
	public String commonMemberUpdateCheck(HttpServletRequest req
			, UserDTO UserDTO
			, @RequestParam(value="tiles") String tiles
			
			) throws Exception {
		
		
		UserSettingDTO setting = Component.getData("member.US_getData",tiles);
		//금지단어 체크
		if(UserDTO.getUI_NAME()!= null && !UserDTO.getUI_NAME().equals("")){
			String UI_NAME = UserDTO.getUI_NAME();
			for(String f : setting.getUS_ID_FILTER().split(",")){
				if(UI_NAME.contains(f)){
					return "nameFilter";
				}
			}
		}
		
		return "ok";
		
	}
	
	/**
	 * 로그인 체크
	 * @param req
	 * @param UserDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/common/member/checkLogin.do")
	@ResponseBody
	public String commonMemberCheckLogin(HttpServletRequest req
			) throws Exception {
		
		
		Map<String, Object> user = CommonService.getUserInfo(req);
		
		return (user == null) ? "N":"Y";
		
	}
	
	
	//25/12/02 RTU-DB 처리 로직
	// @RequestMapping("/common/insert.do")
	// public ResponseEntity<?> ReceiveData (
	// 			@RequestBody SerialDTO request , 
	// 			@RequestHeader(value = "X-API-Key" , required = false)String apikey
	// 		) throws Exception {
				
	// 	// 1) API Key 검증
    //     if (apikey == null || !apikey.equals("hyungkiDae")) {
    //         return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
    //                 .body("Invalid API key");
    //     }
    //     // 2) Value 값 들어왔는지 확인
    //     if (request.getDP_KEYNO() == null || request.getDP_KEYNO().isEmpty()) {
    //     	return ResponseEntity.status(HttpStatus.BAD_REQUEST)
    //     			.body("{\"message\":\"values is empty\"}");
    //     }
        
    //     String method = request.getMethod();
        
    //     System.out.println("받은 value : " + request.getDP_KEYNO());
    //     System.out.println("받은 time : " + request.getTime());
        
    //     if(method.equals("insert")) {
    //     	Component.getData("sub2.insertInverterData",request); 
    //     }
		
    //     String successMSG = "{\"status\":\"전송 ok\"}" ;
        
	// 	return ResponseEntity.ok().body(successMSG);
		
	// }

	//25/12/08 insert 저장 로직
	@RequestMapping("/common/insert.do")
	@ResponseBody
	public ResponseEntity<?> ReceiveData (
		@RequestBody SerialDTO request, 
		@RequestHeader(value = "X-API-Key", required = false) String apikey
	) throws Exception {
		if (apikey == null || !apikey.equals("hyungkiDae")) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
					.body("{\"status\":\"error\", \"message\":\"Invalid API key\"}");
		}
		
		if (request == null) {
			return ResponseEntity.status(HttpStatus.BAD_REQUEST)
					.body("{\"status\":\"error\", \"message\":\"Request body is null\"}");
		}
		
		String method = Optional.ofNullable(request.getMethod()).orElse("").trim();
		
		if ("insert".equalsIgnoreCase(method)) {
			String types = Optional.ofNullable(request.getTypes()).orElse("").trim();
			// mainInsert는 클라이언트가 DDM_DPP_KEYNO만 보냄. 그 외 types는 DP_KEYNO 필수.
			if ("mainInsert".equalsIgnoreCase(types)) {
				if (request.getDDM_DPP_KEYNO() == null || request.getDDM_DPP_KEYNO().trim().isEmpty()) {
					return ResponseEntity.status(HttpStatus.BAD_REQUEST)
							.body("{\"status\":\"error\", \"message\":\"DDM_DPP_KEYNO is empty\"}");
				}
			} else if (request.getDP_KEYNO() == null || request.getDP_KEYNO().isEmpty()) {
				return ResponseEntity.status(HttpStatus.BAD_REQUEST)
						.body("{\"status\":\"error\", \"message\":\"DP_KEYNO is empty\"}");
			}
			
			try {
				if("inverterInsert".equalsIgnoreCase(types)){
					// 빈 문자열을 null로 변환
					convertEmptyStringsToNull(request);
					Component.createData("sub2.insertInverterData", request);
									
					// dy_inverter_data_main 자동 업데이트
					updateMainData(request.getDP_KEYNO());
					
				} else if("mainInsert".equalsIgnoreCase(types)){
					// dy_inverter_data_main 저장
					Component.createData("sub2.insertMainData", request);
					
				} else if("errorInsert".equalsIgnoreCase(types)){
					Component.createData("main.insertInverterError", request);
					
				} else if("noDataInsert".equalsIgnoreCase(types)){
					// noData 저장: 데이터 부족 시 5개 필드만 저장
					// DP_KEYNO, DI_NAME, Cumulative_Generation, Daily_Generation, Work_Mode
					Component.createData("sub2.insertNoData", request);
					
					// dy_inverter_data_main 자동 업데이트 (noData도 메인 데이터에 반영)
					updateMainData(request.getDP_KEYNO());
					
				} else {
					return ResponseEntity.status(HttpStatus.BAD_REQUEST)
							.body("{\"status\":\"error\", \"message\":\"Invalid types. Must be 'inverterInsert', 'mainInsert', 'errorInsert', or 'noDataInsert'\"}");
				}
				
				return ResponseEntity.ok().body("{\"status\":\"success\", \"message\":\"전송 ok\"}");
			
			} catch (Exception e) {
				return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
						.body("{\"status\":\"error\", \"message\":\"저장 실패: " + e.getMessage() + "\"}");
			}		
		}
		
		return ResponseEntity.status(HttpStatus.BAD_REQUEST)
				.body("{\"status\":\"error\", \"message\":\"Invalid method. Must be 'insert'\"}");
	}
	
	/**
	 * SerialDTO의 빈 문자열을 null로 변환
	 * @param dto SerialDTO 객체
	 */
	private void convertEmptyStringsToNull(SerialDTO dto) {
		if(dto == null) {
			return;
		}
		
		try {
			java.lang.reflect.Field[] fields = SerialDTO.class.getDeclaredFields();
			for(java.lang.reflect.Field field : fields) {
				if(field.getType() == String.class) {
					field.setAccessible(true);
					String value = (String) field.get(dto);
					if(value != null && value.trim().isEmpty()) {
						field.set(dto, null);
					}
				}
			}
		} catch (Exception e) {
			// 예외 발생 시 무시 (필드 변환 실패는 치명적이지 않음)
		}
	}
	
	/**
	 * 당일 dy_inverter_data에서 인버터별 최신값만 남기고 나머지 삭제
	 * DyController의 ttest.do와 동일한 로직 (당일 데이터만 처리)
	 */
	private void cleanupTodayInverterData(String dpKeyno) {
		try {
			if(dpKeyno == null || dpKeyno.isEmpty()) {
				return;
			}
			
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("day", 0); // 당일 데이터
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
			logger.warn("당일 인버터 데이터 정리 중 에러 발생: " + e.getMessage());
		}
	}
	
	/**
	 * dy_inverter_data_main 자동 업데이트
	 * inverterInsert 저장 후 호출
	 */
	private void updateMainData(String dpKeyno) {
		try {
			if(dpKeyno == null || dpKeyno.isEmpty()) {
				return;
			}
			
			// 발전소 정보 조회
			HashMap<String,Object> plant = Component.getData("main.PowerOneSelect", dpKeyno);
			if(plant == null) {
				return;
			}
			
			Double plantVolum = Double.parseDouble(plant.get("DPP_VOLUM").toString());
			Integer inverterCount = Integer.parseInt(plant.get("DPP_INVER_COUNT").toString());
			
			// 어제 발전량 조회
			HashMap<String,Object> prePowerMap = new HashMap<>();
			prePowerMap.put("keyno", dpKeyno);
			HashMap<String,Object> prePower = Component.getData("sub2.select_prePower", prePowerMap);
			Double yesterdayPower = 0.0;
			if(prePower != null && prePower.get("dPower") != null) {
				yesterdayPower = Double.parseDouble(prePower.get("dPower").toString());
			}
			
			// 당일 발전량, 누적 발전량, 현재 발전량 조회
			HashMap<String,Object> powerMap = new HashMap<>();
			powerMap.put("keyno", dpKeyno);
			HashMap<String,Object> power = Component.getData("sub2.select_Power", powerMap);
			Double todayPower = 0.0;
			Double cumulativePower = 0.0;
			Double activePower = 0.0;
			if(power != null) {
				if(power.get("today_power") != null) {
					todayPower = Double.parseDouble(power.get("today_power").toString());
				}
				if(power.get("cumulative_power") != null) {
					cumulativePower = Double.parseDouble(power.get("cumulative_power").toString());
				}
				if(power.get("active_power") != null) {
					activePower = Double.parseDouble(power.get("active_power").toString());
				}
			}
			
			// 발전시간 계산
			Double generationHour = (plantVolum > 0) ? todayPower / plantVolum : 0.0;
			
			// 평균 현재 발전량 계산
			Double avgActivePower = (inverterCount > 0) ? activePower / inverterCount : activePower;
			
			// 상태 확인 (최신 인버터 수 N건만 보고 Work_Mode 판단)
			String status = "정상";
			HashMap<String,Object> workModeMap = new HashMap<>();
			workModeMap.put("keyno", dpKeyno);
			int invCount = (inverterCount != null && inverterCount > 0) ? inverterCount : 1;
			workModeMap.put("inv_count", invCount);
			HashMap<String,Object> workModeData = Component.getData("sub2.select_WorkMode", workModeMap);
			if(workModeData != null && workModeData.get("work_mode") != null) {
				String workMode = workModeData.get("work_mode").toString();
				// Work_Mode를 DDM_STATUS 형식으로 변환
				if("Fault".equalsIgnoreCase(workMode)) {
					status = "장애";
				} else if("Wait".equalsIgnoreCase(workMode)) {
					status = "대기";
				} else if("noData".equalsIgnoreCase(workMode)) {
					status = "연결 끊김";
				} else {
					status = "정상";
				}
			}
			
			// SerialDTO 형식으로 변환하여 저장
			SerialDTO serialDTO = new SerialDTO();
			serialDTO.setDDM_DPP_KEYNO(dpKeyno);
			serialDTO.setDDM_P_DATA(String.valueOf(yesterdayPower));
			serialDTO.setDDM_D_DATA(String.valueOf(todayPower));
			serialDTO.setDDM_T_HOUR(String.valueOf(generationHour));
			serialDTO.setDDM_STATUS(status);
			serialDTO.setDDM_ACTIVE_P(String.valueOf(avgActivePower));
			serialDTO.setDDM_CUL_DATA(String.valueOf(cumulativePower));
			
			// 기존 오늘 날짜 데이터 삭제 (중복 방지)
			Component.deleteData("sub2.deleteMainToday", dpKeyno);
			
			// dy_inverter_data_main 저장
			Component.createData("sub2.insertMainData", serialDTO);
		} catch (Exception e) {
			// 에러 발생 시 메인 프로세스는 계속 진행
		}
	}
	
	
	//select 전송부
	@RequestMapping(value = "/common/select.do", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
	@ResponseBody
	public String SendData (
		@RequestBody SerialDTO request, 
		@RequestHeader(value = "X-API-Key", required = false) String apikey
	) throws Exception {
		logger.info("=== /common/select.do 호출 시작 ===");
		
		if (apikey == null || !apikey.equals("hyungkiDae")) {
			logger.warn("API Key 검증 실패");
			return "API ERROR";
		}
		
		if (request.getDP_KEYNO() == null || request.getDP_KEYNO().isEmpty()) {
			logger.warn("DP_KEYNO가 비어있음");
			return "DP_KEYNP ERROR";
		}
		 
		String method = Optional.ofNullable(request.getMethod()).orElse("").trim();
		logger.info("요청 method: [{}], length = {}", method, method.length());
		logger.info("DP_KEYNO: {}, DI_NAME: {}", request.getDP_KEYNO(), request.getDI_NAME());
		
		if ("select".equalsIgnoreCase(method)) {
			String types = Optional.ofNullable(request.getTypes()).orElse("").trim();
			try {
				ObjectMapper mapper = new ObjectMapper();
				// Orange Pi API: types별 조회 → 응답은 { "rows": [ [컬럼값,...], ... ] }
				if ("checkData".equalsIgnoreCase(types)) {
					HashMap<String, Object> row = Component.getData("sub2.Check_data", request);
					List<Object> rowList = new ArrayList<>();
					if (row != null && !row.isEmpty()) {
						rowList.add(row.get("Cumulative_Generation"));
						rowList.add(row.get("Daily_Generation"));
						rowList.add(row.get("Conn_date"));
					}
					HashMap<String, Object> out = new HashMap<>();
					out.put("rows", rowList.isEmpty() ? new ArrayList<>() : java.util.Collections.singletonList(rowList));
					return mapper.writeValueAsString(out);
				}
				if ("preAllData".equalsIgnoreCase(types)) {
					HashMap<String, Object> row = Component.getData("sub2.PreAll_data", request);
					List<Object> rowList = new ArrayList<>();
					if (row != null && row.get("Cumulative_Generation") != null) {
						rowList.add(row.get("Cumulative_Generation"));
					}
					HashMap<String, Object> out = new HashMap<>();
					out.put("rows", rowList.isEmpty() ? new ArrayList<>() : java.util.Collections.singletonList(rowList));
					return mapper.writeValueAsString(out);
				}
				if ("prePower".equalsIgnoreCase(types)) {
					HashMap<String, Object> param = new HashMap<>();
					param.put("keyno", request.getDP_KEYNO());
					HashMap<String, Object> row = Component.getData("sub2.select_prePower", param);
					List<Object> rowList = new ArrayList<>();
					if (row != null && !row.isEmpty()) {
						rowList.add(row.get("dPower") != null ? row.get("dPower") : 0);
						rowList.add(row.get("Total_Generation_Hour") != null ? row.get("Total_Generation_Hour") : 0);
					}
					HashMap<String, Object> out = new HashMap<>();
					out.put("rows", rowList.isEmpty() ? new ArrayList<>() : java.util.Collections.singletonList(rowList));
					return mapper.writeValueAsString(out);
				}
				if ("power".equalsIgnoreCase(types)) {
					HashMap<String, Object> param = new HashMap<>();
					param.put("keyno", request.getDP_KEYNO());
					HashMap<String, Object> row = Component.getData("sub2.select_Power", param);
					List<Object> rowList = new ArrayList<>();
					if (row != null && !row.isEmpty()) {
						rowList.add(row.get("today_power") != null ? row.get("today_power") : 0);
						rowList.add(row.get("cumulative_power") != null ? row.get("cumulative_power") : 0);
						rowList.add(row.get("active_power") != null ? row.get("active_power") : 0);
					}
					HashMap<String, Object> out = new HashMap<>();
					out.put("rows", rowList.isEmpty() ? new ArrayList<>() : java.util.Collections.singletonList(rowList));
					return mapper.writeValueAsString(out);
				}
				if ("inverterData".equalsIgnoreCase(types)) {
					// LCD용: 당일 발전소 전체 인버터 상세 데이터 (인버터별 최신 1건)
					HashMap<String, Object> param = new HashMap<>();
					param.put("keyno", request.getDP_KEYNO());
					List<HashMap<String, Object>> rows = Component.getList("sub2.Lcd_inverter_data", param);
					HashMap<String, Object> out = new HashMap<>();
					out.put("status", "success");
					out.put("rows", rows != null ? rows : new ArrayList<>());
					return mapper.writeValueAsString(out);
				}
				// types 없음: 발전소 정보 조회 (기존 동작)
				HashMap<String, Object> dto = Component.getData("sub2.inverterSelect", request);
				logger.info("select 메서드 처리 완료 (발전소 정보)");
				return mapper.writeValueAsString(dto != null ? dto : new HashMap<>());
			} catch (Exception e) {
				logger.error("select 메서드 처리 중 에러 발생", e);
				return "DB SELECT 에러";
			}
		}
		
		if ("previousCumulative".equalsIgnoreCase(method)) {
			logger.info("previousCumulative 메서드 처리 시작 - DP_KEYNO: {}, DI_NAME: {}", 
					request.getDP_KEYNO(), request.getDI_NAME());
			try {
				ObjectMapper mapper = new ObjectMapper();
				logger.info("Component.getData('sub2.previousCumulative') 호출 전");
				HashMap<String, Object> result = Component.getData("sub2.previousCumulative", request);
				logger.info("Component.getData('sub2.previousCumulative') 호출 후 - result: {}", result);
				
				// 결과가 없으면 null 반환
				if (result == null || result.isEmpty()) {
					logger.info("어제 누적값 없음 - DP_KEYNO: {}, DI_NAME: {}", 
							request.getDP_KEYNO(), request.getDI_NAME());
					HashMap<String, Object> emptyResult = new HashMap<>();
					emptyResult.put("status", "success");
					emptyResult.put("cumulative", null);
					String response = mapper.writeValueAsString(emptyResult);
					logger.info("빈 결과 반환: {}", response);
					return response;
				}
				
				// Cumulative_Generation, Conn_date 반환 (RTU 일일검증에서 Conn_date로 전일 여부 확인)
				Object cumulativeValue = result.get("Cumulative_Generation");
				Object connDateObj = result.get("Conn_date");
				// RTU가 날짜 인식하도록 문자열로 포맷 (Jackson 직렬화 시 숫자/형식 이슈 방지)
				Object connDate = null;
				if (connDateObj instanceof Date) {
					connDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format((Date) connDateObj);
				} else if (connDateObj != null) {
					connDate = connDateObj.toString();
				}
				logger.info("어제 누적값 조회 성공 - DP_KEYNO: {}, DI_NAME: {}, Cumulative: {}, Conn_date: {}", 
						request.getDP_KEYNO(), request.getDI_NAME(), cumulativeValue, connDate);
				
				HashMap<String, Object> response = new HashMap<>();
				response.put("status", "success");
				response.put("cumulative", cumulativeValue);
				if (connDate != null) {
					response.put("Conn_date", connDate);
				}
				String jsonResponse = mapper.writeValueAsString(response);
				logger.info("최종 응답: {}", jsonResponse);
				return jsonResponse;
			
			} catch (Exception e) {
				logger.error("어제 누적값 조회 실패 - DP_KEYNO: {}, DI_NAME: {}, 에러: {}", 
						request.getDP_KEYNO(), request.getDI_NAME(), e.getMessage(), e);
				try {
					ObjectMapper mapper = new ObjectMapper();
					HashMap<String, Object> errorResult = new HashMap<>();
					errorResult.put("status", "error");
					errorResult.put("message", "어제 누적값 조회 실패: " + e.getMessage());
					String errorResponse = mapper.writeValueAsString(errorResult);
					logger.info("에러 응답 반환: {}", errorResponse);
					return errorResponse;
				} catch (Exception ex) {
					logger.error("에러 응답 생성 실패", ex);
					return "DB SELECT 에러";
				}
			}
		}
		
		// Orange Pi 일일검증: 오늘 첫 Normal 기록의 Daily_Generation (DB Work_Mode=Normal 기준)
		if ("todayFirstNormalDailyGeneration".equalsIgnoreCase(method)) {
			try {
				ObjectMapper mapper = new ObjectMapper();
				HashMap<String, Object> result = Component.getData("sub2.todayFirstNormalDailyGeneration", request);
				HashMap<String, Object> response = new HashMap<>();
				response.put("status", "success");
				if (result != null && result.containsKey("Daily_Generation")) {
					response.put("Daily_Generation", result.get("Daily_Generation"));
					response.put("daily", result.get("Daily_Generation"));
					response.put("dailyGeneration", result.get("Daily_Generation"));
				} else {
					response.put("Daily_Generation", null);
					response.put("daily", null);
				}
				return mapper.writeValueAsString(response);
			} catch (Exception e) {
				logger.error("todayFirstNormalDailyGeneration 조회 실패 - DP_KEYNO: {}, DI_NAME: {}", request.getDP_KEYNO(), request.getDI_NAME(), e);
				try {
					ObjectMapper mapper = new ObjectMapper();
					HashMap<String, Object> err = new HashMap<>();
					err.put("status", "error");
					err.put("message", e.getMessage());
					return mapper.writeValueAsString(err);
				} catch (Exception ex) { return "DB SELECT 에러"; }
			}
		}
		
		// Orange Pi 일일검증: 오늘 첫 Normal 기록의 Cumulative_Generation
		if ("todayFirstNormalCumulative".equalsIgnoreCase(method)) {
			try {
				ObjectMapper mapper = new ObjectMapper();
				HashMap<String, Object> result = Component.getData("sub2.todayFirstNormalCumulative", request);
				HashMap<String, Object> response = new HashMap<>();
				response.put("status", "success");
				if (result != null && result.containsKey("Cumulative_Generation")) {
					response.put("cumulative", result.get("Cumulative_Generation"));
					response.put("Cumulative_Generation", result.get("Cumulative_Generation"));
				} else {
					response.put("cumulative", null);
				}
				return mapper.writeValueAsString(response);
			} catch (Exception e) {
				logger.error("todayFirstNormalCumulative 조회 실패 - DP_KEYNO: {}, DI_NAME: {}", request.getDP_KEYNO(), request.getDI_NAME(), e);
				try {
					ObjectMapper mapper = new ObjectMapper();
					HashMap<String, Object> err = new HashMap<>();
					err.put("status", "error");
					err.put("message", e.getMessage());
					return mapper.writeValueAsString(err);
				} catch (Exception ex) { return "DB SELECT 에러"; }
			}
		}
		
		// Orange Pi 일일검증: 오늘 첫 기록의 Cumulative_Generation (상태 무관)
		if ("todayFirstCumulative".equalsIgnoreCase(method)) {
			try {
				ObjectMapper mapper = new ObjectMapper();
				HashMap<String, Object> result = Component.getData("sub2.todayFirstCumulative", request);
				HashMap<String, Object> response = new HashMap<>();
				response.put("status", "success");
				if (result != null && result.containsKey("Cumulative_Generation")) {
					response.put("cumulative", result.get("Cumulative_Generation"));
					response.put("Cumulative_Generation", result.get("Cumulative_Generation"));
				} else {
					response.put("cumulative", null);
				}
				return mapper.writeValueAsString(response);
			} catch (Exception e) {
				logger.error("todayFirstCumulative 조회 실패 - DP_KEYNO: {}, DI_NAME: {}", request.getDP_KEYNO(), request.getDI_NAME(), e);
				try {
					ObjectMapper mapper = new ObjectMapper();
					HashMap<String, Object> err = new HashMap<>();
					err.put("status", "error");
					err.put("message", e.getMessage());
					return mapper.writeValueAsString(err);
				} catch (Exception ex) { return "DB SELECT 에러"; }
			}
		}
		
		logger.warn("지원하지 않는 method: [{}] - '종료' 반환", method);
		return "종료";
	}
}
