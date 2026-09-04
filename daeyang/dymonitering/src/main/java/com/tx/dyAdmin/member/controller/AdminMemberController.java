package com.tx.dyAdmin.member.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.dto.Common;
import com.tx.common.security.aes.AES256Cipher;
import com.tx.common.security.password.MyPasswordEncoder;
import com.tx.common.security.rsa.service.RsaService;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.page.PageAccess;
import com.tx.common.service.reqapi.requestAPIservice;
import com.tx.common.service.weakness.WeaknessService;
import com.tx.dyAdmin.admin.code.service.CodeService;
import com.tx.dyAdmin.member.dto.UserDTO;
import com.tx.dyAdmin.member.dto.UserSettingDTO;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import javaxt.utils.Array;

@Controller
public class AdminMemberController {

	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 암호화 */
	@Autowired MyPasswordEncoder passwordEncoder;
	
	/** RSA */
	@Autowired RsaService RsaService;
	
	/** 페이지 처리 출 */
	@Autowired private PageAccess PageAccess;
	
	@Autowired WeaknessService WeaknessService;
	
	@Autowired requestAPIservice requestAPI;
	
	@Autowired CodeService CodeService;
	@RequestMapping(value="/dyAdmin/user/login.do")
	public ModelAndView userForm(HttpServletRequest req
			,HttpSession session
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/member/pra_login.adm");
		
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
		
		
		return mv;
	}
	
	@RequestMapping(value="/dyAdmin/login/init.do")
	public ModelAndView loginInit(HttpServletRequest req
			) throws Exception {
		
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/member/pra_login_init.adm");
		
		return mv;
	}
	
	/**
	 * 회원비밀번호 수정
	 * @param req
	 * @param data
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/login/init/changePwd/ajax.do")
	@Transactional
	@ResponseBody
	public String cfMypagePwdUpdate(HttpServletRequest req
			, UserDTO UserDTO
			, @RequestParam(value="UI_PASSWORD1",defaultValue="") String UI_PASSWORD1
			) throws Exception {
		
		Map<String,Object> user = CommonService.getUserInfo(req);
		String result = "F";
		if(user != null){
			
			String encPwd = user.get("UI_PASSWORD").toString();
			if(passwordEncoder.matches(UserDTO.getUI_PASSWORD(), encPwd)){
				String encryptionPW = passwordEncoder.encode(UI_PASSWORD1);
				user.put("UI_PASSWORD", encryptionPW);
				Component.updateData("member.UI_updateUserInitPwd", user);
				
				Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		        SecurityContextHolder.getContext().setAuthentication(createNewAuthentication(authentication,user.get("UI_ID")+"", req));
				
				result = "S";
			}
			
		}
		
			
		return result;
	}
	
	/**
	 * 스프링 시큐리티 새로 고침
	 * @param currentAuth
	 * @param username
	 * @param req
	 * @return
	 * @throws Exception 
	 */
	private Authentication createNewAuthentication(Authentication currentAuth, String username, HttpServletRequest req) throws Exception {
		UserDTO user = Component.getData("member.selectUserInfo", username);
		user.decode();
        UserDetails newPrincipal = user;
        UsernamePasswordAuthenticationToken newAuth = 
            new UsernamePasswordAuthenticationToken(newPrincipal,currentAuth.getCredentials(),currentAuth.getAuthorities());
        newAuth.setDetails(currentAuth.getDetails());
        if(newAuth.getPrincipal() != null && newAuth.getPrincipal() instanceof UserDTO ){
        	
        	UserDTO principal =(UserDTO)newAuth.getPrincipal();
        	principal.decode();
        	Map<String, Object> map = CommonService.ConverObjectToMap(principal);
			String UIA_NAME = (String)map.get("UIA_NAME");
			Map<String, Object> authority = new HashMap<String,Object>();
			authority.put("authList", UIA_NAME.split(","));
			map.put("isAdmin", Component.getData("Authority.UIA_isAdmin", authority)); //관리자 여부
			req.getSession().setAttribute("userInfo", map);
		}
        return newAuth;
    }
	
	// 아이디 중복 체크 
	@RequestMapping(value="/dyAdmin/user/IdCheckAjax.do")
	@ResponseBody
	public String IdCheckAjax(HttpServletRequest req	
			,@ModelAttribute UserDTO UserDTO
			) throws Exception {
		
		String UI_ID = UserDTO.getUI_ID();
		UserDTO = Component.getData("member.UI_IdCheck",UserDTO);	
		
		String result; 
		
		if(UserDTO == null){
			UserSettingDTO setting = Component.getData("member.US_getData","adm");
			result = "Y"; // 사용가능
			for(String filter : setting.getUS_ID_FILTER().split(",")){
				if(UI_ID.contains(filter)){
					result = "X";
					break;
				}
			}
		}else{
			result = "N"; // 이미 존재하는 아이디
		}
		
		return result;
	}
	
	/**
	 * 회원관리 셋팅
	 * @param req
	 * @param UserDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/person/setting.do")
	@CheckActivityHistory(desc="회원관리 셋팅 페이지 방문")
	public ModelAndView adminMemberSetting(HttpServletRequest req
			,@ModelAttribute UserDTO UserDTO
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/member/pra_member_setting.adm");
		mv.addObject("homeList",Component.getListNoParam("member.US_getList"));
		mv.addObject("authList",Component.getListNoParam("Authority.UIA_GetList2"));
		mv.addObject("PasswordRegex",CodeService.getCodeListisUse("CR", true));
		return mv;
	}	
		
	/**
	 * 회원관리 셋팅 저장
	 * @param req
	 * @param ResearchSkinDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/person/setting/insert.do")
	@CheckActivityHistory(desc="회원관리 셋팅 저장 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView adminMemberSettingInsert(HttpServletRequest req
			,@RequestParam(value="US_TYPE") String[] US_TYPE 
			,@RequestParam(value="US_UIA_KEYNO",required=false) String[] US_UIA_KEYNO
			,@RequestParam(value="US_AUTH",required=false) String[] US_AUTH
			,@RequestParam(value="US_REGEX",required=false) String[] US_REGEX
			,@RequestParam(value="US_ID_FILTER",required=false) String[] US_ID_FILTER
			,@RequestParam(value="US_INFO1",required=false) String[] US_INFO1
			,@RequestParam(value="US_INFO2",required=false) String[] US_INFO2
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("redirect:/dyAdmin/person/setting.do");
		
		
		
		UserSettingDTO setting = null;
		for(int i=0;i<US_TYPE.length;i++){
			setting = new UserSettingDTO();
			setting.setUS_TYPE(US_TYPE[i]);
			setting.setUS_UIA_KEYNO(US_UIA_KEYNO[i]);
			setting.setUS_AUTH(US_AUTH[i]);
			setting.setUS_REGEX(US_REGEX[i]);
			setting.setUS_ID_FILTER(US_ID_FILTER[i]);
			setting.setUS_INFO1(US_INFO1[i]);
			setting.setUS_INFO2(US_INFO2[i]);
			Component.createData("member.US_insertData", setting);
		}
		
		return mv;
	}	
	/**
	 * 회원 리스트
	 * @param req
	 * @param UserDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/person/view.do")
	@CheckActivityHistory(desc="회원 목록 페이지 방문")
	public ModelAndView adminMemberView(HttpServletRequest req
			,@ModelAttribute UserDTO UserDTO
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/member/pra_member_list.adm");
		mv.addObject("userInfoSetting", Component.getData("member.US_getData2",CommonService.getSiteMap("")));
		mv.addObject("authoritylist",Component.getListNoParam("Authority.UIA_GetList2"));
		return mv;
	}
	
	/**
	 * 회원 리스트 - 페이징 ajax
	 * @param req
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/person/view/pagingAjax.do")
	public ModelAndView adminMemberViewPaging(HttpServletRequest req,
			Common search
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/member/pra_member_list_data");

		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"member.UI_getListCnt",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		
		List<HashMap<String,Object>> resultList = Component.getList("member.UI_getList", map); 
		mv.addObject("resultList", userInfoDecode(resultList));
		mv.addObject("search", search);
		return mv;
		
		
	}
	/**
	 * 회원 리스트 - excel ajax
	 * @param req
	 * @param res
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/person/view/excelAjax.do")
	public ModelAndView adminMemberViewExcelAjax(HttpServletRequest req
			, HttpServletResponse res
			, Common search
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/member/pra_member_list_excel");
		
		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		List<HashMap<String,Object>> resultList = Component.getList("member.UI_getList", map); 
		mv.addObject("resultList", userInfoDecode(resultList));
		mv.addObject("search", search);
		
		try {
            
			Cookie cookie = new Cookie("fileDownload", "true");
	        cookie.setPath("/");
	        res.addCookie(cookie);
            
        } catch (Exception e) {
            System.out.println("쿠키 에러 :: "+e.getMessage());
        }
		return mv;
		
	}
	
	private List<HashMap<String, Object>> userInfoDecode(List<HashMap<String, Object>> userList) {
		
		for(HashMap<String, Object> user : userList){
			String UI_EMAIL = (String)user.get("UI_EMAIL");
			String UI_PHONE = (String)user.get("UI_PHONE");
			
			try{
				if(StringUtils.isNotBlank(UI_EMAIL)){
					user.put("UI_EMAIL", AES256Cipher.decode(UI_EMAIL));
				}
				if(StringUtils.isNotBlank(UI_PHONE)){
					user.put("UI_PHONE", AES256Cipher.decode(UI_PHONE));
				}
				
			}catch(Exception e){
				System.out.println("UserDTO 복호화중 에러 :: " + e.getMessage());
			}
		}
		
		return userList;
	}
	
	
	/**
	 * 회원 정보 불러오기 ajax
	 * @param req
	 * @param UserDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/person/dataAjax.do")
	@ResponseBody
	public UserDTO adminMemberDataAjax(HttpServletRequest req
			,@ModelAttribute UserDTO UserDTO
			) throws Exception {
		
		UserDTO = Component.getData("member.UI_select",UserDTO);
		UserDTO.decode();
		
		return UserDTO;
	}
	
	/**
	 * 비밀번호 체크
	 * @param req
	 * @param pwd
	 * @param encPwd
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/user/pwdCheckAjax.do")
	@ResponseBody
	public boolean adminMemberPwdCheckAjax(HttpServletRequest req
			,@RequestParam("pwd") String pwd
			,@RequestParam("encPwd") String encPwd
			) throws Exception {
		
		return passwordEncoder.matches(pwd, encPwd);
	}
	
	@RequestMapping(value="/dyAdmin/person/insertAjax.do")
	@Transactional
	@ResponseBody
	@CheckActivityHistory(desc="회원 등록 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	public HashMap<String, Object> adminMemberInsertAjax(HttpServletRequest req
			,@ModelAttribute UserDTO UserDTO
			) throws Exception {
		boolean regexBoolean = true;
		HashMap<String, Object> resultMap = new HashMap<>();
		
		String msg = "성공적으로 등록 되었습니다.";
		String regex = SettingData.PASSWORD_REGEX;
		
		/*if(!WeaknessService.regexCheck(SettingData.ID_REGEX, UserDTO.getUI_ID())){
			msg = "아이디 형식이 잘못되었습니다.";
			regexBoolean = false;
		}else{
			if(!WeaknessService.regexCheck(regex, UserDTO.getUI_PASSWORD())){
				msg = "비밀번호 형식이 잘못되었습니다.";
				regexBoolean = false;
			}else{
				if(!WeaknessService.regexCheck(SettingData.EMAIL_REGEX, UserDTO.getUI_EMAIL())){
					msg = "이메일 형식이 잘못되었습니다.";
					regexBoolean = false;
				}
			}
		}*/
		
		if(regexBoolean){
			String encPwd = passwordEncoder.encode(UserDTO.getUI_PASSWORD());
			UserDTO.setUI_PASSWORD(encPwd);
			UserDTO.setUI_KEYNO(CommonService.getTableKey("UI"));
			
			String authority = UserDTO.getUIA_KEYNO();
			if(StringUtils.isNotEmpty(authority)){
				Map<String, Object> map = new HashMap<String,Object>();
				map.put("UI_KEYNO", UserDTO.getUI_KEYNO());
				map.put("UIA_KEYNO", authority.split(","));
				Component.deleteData("member.UI_deleteAuthority", map);
				Component.createData("member.UI_setAuthority", map);
			}
			
			UserDTO.encode();
			Component.createData("member.UI_insert", UserDTO);
		}
		
		resultMap.put("msg", msg);
		resultMap.put("regexBoolean", regexBoolean);
		return resultMap;
	}
	
	@RequestMapping(value="/dyAdmin/person/updateAjax.do")
	@Transactional
	@ResponseBody
	@CheckActivityHistory(desc="회원 정보수정 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	public void adminMemberUpdatekAjax(HttpServletRequest req
			,@ModelAttribute UserDTO UserDTO
			,@RequestParam(value="UI_PASSWORD2",defaultValue="") String UI_PASSWORD2
			,@RequestParam(value="UI_PASSWORD3",defaultValue="") String UI_PASSWORD3
			,@RequestParam(value="UIA_KEYNO_BEFORE",defaultValue="") String UIA_KEYNO_BEFORE
			,@RequestParam(value="UIA_DIVISION",defaultValue="") String UIA_DIVISION
			) throws Exception {
		
		
		if(!UI_PASSWORD2.equals("") && UI_PASSWORD2.equals(UI_PASSWORD3)){
			String encPwd =passwordEncoder.encode(UI_PASSWORD2);
			UserDTO.setUI_PASSWORD(encPwd);
		}else{
			UserDTO.setUI_PASSWORD("");
		}
		
		UserDTO.encode();
		Component.updateData("member.UI_updateUser", UserDTO);
		
		
		if(UIA_KEYNO_BEFORE.equals(SettingData.AUTHORITY_ADMIN)){
			//슈퍼관리자는 권한 수정 안함
		}else if(UserDTO.getUIA_KEYNO() != null && !UIA_KEYNO_BEFORE.equals(UserDTO.getUIA_KEYNO())){
			//권한이 변경되면 권한 수정작업
			Map<String, Object> map = new HashMap<String,Object>();
			map.put("UI_KEYNO", UserDTO.getUI_KEYNO());
			map.put("UIA_KEYNO", UserDTO.getUIA_KEYNO().split(","));
			Component.deleteData("member.UI_deleteAuthority", map);
			Component.createData("member.UI_setAuthority", map);
			//유저 커스텀 권한이라면 삭제
			if("U".equals(UIA_DIVISION)){
				List<HashMap<String,Object>> columns = new ArrayList<HashMap<String,Object>>();
				HashMap<String,Object> column = new HashMap<String,Object>();
				column.put("name", "UIA_KEYNO");
				column.put("operator", "=");
				column.put("value", UIA_KEYNO_BEFORE);
				columns.add(column);
				CommonService.deleteData("U_USERINFO_AUTHORITY",columns);
				CommonService.deleteData("U_USERINFO_AUTHORITY_ROLL",columns);
				CommonService.deleteData("U_USERINFO_MEMBER_AUTHORITY",columns);
				CommonService.deleteData("U_USERINFO_RESOURCE_AUTHORITY",columns);
			}
			
		}
	}
	
	
	@RequestMapping(value="/dyAdmin/person/deleteAjax.do")
	@CheckActivityHistory(desc="회원 탈퇴 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@ResponseBody
	public void member_Delete(HttpServletRequest req
			,UserDTO UserDTO
			) throws Exception {
		
		UserDTO = Component.getData("member.UI_select",UserDTO);
		UserDTO.decode();
		
		UserDTO.setUW_DEL_REASON("SC_ULYMD");
		
		String DEL_POLICY = SiteProperties.getString("USER_DEL_POLICY");
		
		UserDTO.setUW_ZENDER(UserDTO.getUI_ZENDER());
		UserDTO.setUW_KEYNO(CommonService.getTableKey("UW"));
		
		//회원 탈퇴 등록
		Component.createData("member.UW_insert", UserDTO);
		
		//해당 유저 게시글 삭제 처리
		Component.updateData("BoardNotice.BN_userDelete", UserDTO);
		
		// 삭제정책(Y:논리삭제, N: 물리삭제)
		if(DEL_POLICY.equals("Y")) {
			Component.updateData("member.UI_deleteL", UserDTO);
		} else {
			Component.deleteData("member.UI_deleteP", UserDTO);
		}
		
	}
	
	/**
	 * 탈퇴 목록 리스트 조회
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="/dyAdmin/person/withdrawListAjax.do")
	public List<UserDTO> withdrawList(
			HttpServletRequest req ) throws Exception {
		List<UserDTO> list = new ArrayList<>();
		list = Component.getListNoParam("member.UW_getList");
		return list;
	}
	
	/**
	 * 카카오톡 전송
	 */
	@ResponseBody
	@RequestMapping(value="/dyAdmin/kakaotalk/ailim.do")
	public ModelAndView kakakotalk(HttpServletRequest req
			,@ModelAttribute UserDTO UserDTO
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/member/pra_member_kakao.adm");
		
		HashMap<String,Object> type = new HashMap<String, Object>();
    	Map<String, Object> user = CommonService.getUserInfo(req);
		
		 String sql = "main.select_MainData";
		    String sql2 = "main.Power_SelectKEY";
		    //삼환관리자 처리부분
		    if(SettingData.samwhan.equals(user.get("UIA_KEYNO").toString())) {
			    sql = "main.select_MainData_Ad";
			    sql2 = "main.Power_SelectKEY_Ad";
		    }
		
		mv.addObject("list", Component.getList(sql,type));
		
		
		mv.addObject("authList",Component.getListNoParam("Authority.UIA_GetList_kakao"));
		mv.addObject("kakao",Component.getListNoParam("main.Kakaotalk"));
		return mv;
	}
	
	/*
	 * 문자 전송 시 회원선택
	 **/
	@RequestMapping("/userkakakoselectAjax.do")
	@ResponseBody
	public List<UserDTO> MessageuserselectAjax(HttpServletRequest req,
			@RequestParam(value = "UIA_KEYNO", required = false) String UIA_KEYNO) throws Exception {

		List userlist;

		if (UIA_KEYNO.equals("") || UIA_KEYNO == null) {
			List<UserDTO> list = Component.getListNoParam("main.Group_select_all");
			userlist = list;

		} else {
			List<UserDTO> list = Component.getList("main.Group_select", UIA_KEYNO);
			userlist = list;
		}

		return userlist;
	}
	
	/*
	 * 문자 전송
	 **/
	@RequestMapping("/sendMessageMinWon.do")
	@ResponseBody
	public String sendMessageMinWon(HttpServletRequest req,
			@RequestParam(value="UI_KEYNO",required=false)String user,
    		@RequestParam(value="content",required=false)String content,
    		@RequestParam(value="DPP_KEYNO",required=false)String DPP_KEYNO) throws Exception {
		    
		String msg1 = "";
//		String[] userlist = user.split(",");
//    	map.put("userlist", userlist);
    	
    	HashMap<String,Object> map = Component.getData("main.PowerOneSelect",DPP_KEYNO);

   
		//여러 발전소 동시에 보낼수도 있으니 일단 list를 유지시킴.
		List<UserDTO> list = Component.getList("main.Message_ad",map);
		
		String userid = "daeyang";
		String api = "qcp255q389pcsb3ddunfcb7ys93kbnli";
		String img = "";
		
		
		for(UserDTO l : list) {
				
			l.decode();
			String destination = l.getUI_NAME().toString();
			String receiver = l.getUI_PHONE().toString().replace("-", "");
			String msg = "대양기업 시공 진행 상황 안내\n"
					+destination+ "의 시공 진행 상황을 안내드립니다.\n"
					+"=======================\n"
					+ content+"\n" 
					+"=======================\n"
					+ "시공 관련 문의\n"
					+ "연락처 : 061-332-8086\n";
//				String image = filePath;
			
			requestAPI.sendMessage(userid, api, destination, receiver, msg, img);
		}
	
		
		msg1 = "문자메시지 전송완료";
		
		return msg1;
	}
	
	
	/**
	 * 카카오톡 예약 전송
	 */
	@ResponseBody
	@RequestMapping(value="/dyAdmin/person/ailim.do")
	public String AlimTalkSend(HttpServletRequest req
			,@ModelAttribute UserDTO UserDTO
			,@RequestParam(value="chkvalue",defaultValue="") String UI_KEYNO
			) throws Exception {
		
		String[] list = UI_KEYNO.split(",");
		
		
		String msg = "";
		for(int i = 0; i<list.length; i++) {
			Component.updateData("member.ALimTalkUD", list[i]);
			msg = "카카오톡 알림은 매일 오후 9시에 전송 됩니다.";
		}
		
		
		return msg;
	}	
	
	
	/**
	 * 카카오톡 전송 여부 check N
	 */
	@ResponseBody
	@RequestMapping(value="/dyAdmin/person/ailimcancle.do")
	public String AlimTalkCancle(HttpServletRequest req
			,@ModelAttribute UserDTO UserDTO
			,@RequestParam(value="UI_KEYNO",defaultValue="") String UI_KEYNO
			) throws Exception {
		
		String[] list = UI_KEYNO.split(",");
		
		
		String msg = "";
		for(int i = 0; i<list.length; i++) {
			Component.updateData("member.updateN", list[i]);
			msg = "알림 전송 예약이 취소되었습니다.";
		}
		
		
		return msg;
	}
	
	/**
	 * 카카오톡 전송 여부 check Y
	 */
	@ResponseBody
	@RequestMapping(value="/dyAdmin/person/sendchk.do")
	public String AlimTalkCheck(HttpServletRequest req
			,@ModelAttribute UserDTO UserDTO
			,@RequestParam(value="UI_KEYNO",defaultValue="") String UI_KEYNO
			) throws Exception {
		
		String[] list = UI_KEYNO.split(",");
		
		
		String msg = "";
		for(int i = 0; i<list.length; i++) {
			Component.updateData("member.ALimTalkUD", list[i]);
			msg = "알림 전송 예약이 취소되었습니다.";
		}
		
		
		return msg;
	}
	
	@ResponseBody
	@RequestMapping(value="/dyAdmin/person/AlimSelect.do")
	public List AlimTalkSelect(HttpServletRequest req
			,@ModelAttribute UserDTO UserDTO
			,@RequestParam(value="UI_KEYNO",defaultValue="") String UI_KEYNO
			) throws Exception {
		
		String[] list = UI_KEYNO.split(",");
		List userlist = null;
		
		for(int i = 0; i<list.length; i++) {
//			map.put("list", Component.getData("member.AlimInfoSelect", list[i]));
			List<UserDTO> list2 = Component.getList("member.AlimInfoSelect", list[i]);
			userlist = list2;
		}
		
		
		return userlist;
	}
}


