package com.tx.common.service.member.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.security.aes.AES256Cipher;
import com.tx.common.security.password.MyPasswordEncoder;
import com.tx.common.security.service.AuthenticationSessionService;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.mail.EmailService;
import com.tx.common.service.urlGet.UrlGetService;
import com.tx.common.service.weakness.WeaknessService;
import com.tx.dyAdmin.admin.site.dto.SiteManagerDTO;
import com.tx.dyAdmin.admin.site.service.SiteService;
import com.tx.dyAdmin.member.dto.JoinReqUserDTO;
import com.tx.dyAdmin.member.dto.ModReqUserDTO;
import com.tx.dyAdmin.member.dto.UserDTO;
import com.tx.dyAdmin.member.dto.UserSettingDTO;
import com.tx.dyAdmin.program.application.dto.ApplicationDTO;
/**
 * 
 * @FileName: MemberController.java
 * @Project : common
 * @Date    : 2017. 05. 31. 
 * @Author  : 이재령	
 * @Version : 1.0
 */
@Controller
public class CommonUserMemberController {

	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	@Autowired WeaknessService WeaknessService;
	
	/** 암호화 */
	@Autowired MyPasswordEncoder passwordEncoder;
	
	/** email **/
    @Autowired private EmailService EmailService;
    
    @Autowired AuthenticationSessionService AuthenticationSessionService;
    
    @Autowired SiteService SiteService;
    
    /**  URL 정보가져오기 */
	@Autowired UrlGetService UrlGetService;
    
	/**
	 * 회원가입 - 약관동의
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/{tiles}/member/regist.do")
	@CheckActivityHistory(desc="회원가입 - 약관동의 페이지 방문")
	public ModelAndView MemberRegist(HttpServletRequest req, Map<String,Object> commandMap
			,@PathVariable String tiles
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/user/"+SiteService.getSitePath(tiles)+"/member/prc_regist_agree");
		
		Map<String, Object> user = CommonService.getUserInfo(req);
		//로그인한 상태라면 메인화면으로 리다이렉트
		if(user != null){
			mv.setViewName("redirect:/"+tiles+"/index.do");
			return mv;
		}
		
		mv.addObject("userInfoSetting", Component.getData("member.US_getData",tiles));
		mv.addObject("tiles",tiles);
		return mv;
	}
	
	/**
	 * 회원가입 - 회원정보
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/{tiles}/member/regist/info.do")
	@CheckActivityHistory(type="homeTiles",desc="회원가입 - 회원정보 페이지 방문")
	public ModelAndView MemberRegistInfo(HttpServletRequest req
			, @RequestParam(value="data",defaultValue="") String data
			, @PathVariable String tiles
			, @RequestParam(value="msg",required= false) String msg
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/user/"+SiteService.getSitePath(tiles)+"/member/prc_regist_info");
       
		req.setAttribute("homeTiles", tiles);
		
		if(!data.equals("data")){ //약관동의에서 넘어올때만 data에 값 들어옴
			mv.setViewName("redirect:/"+tiles+"/member/regist.do");
			return mv;
		}
		
		if(msg != null){
			mv.addObject("msg", msg);
		}
		
		mv.addObject("userInfoSetting", Component.getData("member.US_getData2",CommonService.getSiteMap(tiles)));
		mv.addObject("mirrorPage", "/"+tiles+"/member/regist.do");
		mv.addObject("tiles",tiles);
		return mv;
	}
	/**
	 * 회원가입 - 가입완료
	 * @param req
	 * @param data
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/{tiles}/member/regist/result.do")
	@Transactional
	@CheckActivityHistory(type="homeTiles",desc="회원가입 - 가입완료 작업")
	public ModelAndView MemberRegistSave(HttpServletRequest req
			, UserDTO UserDTO 
			, @Valid @ModelAttribute("JoinReqUserDTO") JoinReqUserDTO JoinReqUserDTO
			, BindingResult bindingResult
			, @PathVariable String tiles
			, RedirectAttributes redirectAttributes
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/user/"+SiteService.getSitePath(tiles)+"/member/prc_regist_result");
		
		String regex = Component.getData("member.get_PasswordRegex",CommonService.getSiteMap(tiles));
		if(StringUtils.isBlank(regex)){
			regex = SettingData.PASSWORD_REGEX;
		}
		
		UserSettingDTO setting = Component.getData("member.US_getData", tiles);
		// 커맨드객체 검증
		JoinReqUserDTO.checkEtcValid(bindingResult, setting, regex);
		
		if(bindingResult.hasErrors()) {
			
			mv.addObject("userInfoSetting", Component.getData("member.US_getData2",CommonService.getSiteMap(tiles)));
			mv.addObject("mirrorPage", "/"+tiles+"/member/regist.do");
			mv.addObject("tiles",tiles);
			mv.setViewName("/user/"+SiteService.getSitePath(tiles)+"/member/prc_regist_info");
			return mv;
		}
		
		req.setAttribute("homeTiles", tiles);
		
		String encryptionPW = passwordEncoder.encode(req.getParameter("UI_PASSWORD"));	
		
		UserDTO.setUI_KEYNO(CommonService.getTableKey("UI"));
		UserDTO.setUI_PASSWORD(encryptionPW);
		
		if(setting.getUS_AUTH() != null && setting.getUS_AUTH().equals("N")){ // 인증 미사용시
			UserDTO.setUI_AUTH_YN("Y");
		}else{ 
			UserDTO.setUI_AUTH_YN("N");
		}
		
		UserDTO.encode();
		Component.createData("member.UI_insert", UserDTO);
		UserDTO.decode();
		if(setting.getUS_AUTH() != null && setting.getUS_AUTH().equals("E")){	//이메일
			EmailService.sendAuthEmail(UserDTO,req,tiles);
			mv.addObject("Auth", "emailAuth");
		}else if(setting.getUS_AUTH() != null && setting.getUS_AUTH().equals("A")){	//관리자
			mv.addObject("Auth", "adminAuth");
		}
//		else if(setting.getUS_AUTH() != null && setting.getUS_AUTH().equals("P")){	//핸드폰
//			mv.addObject("Auth", "phoneAuth");
//		}
			
			
		if(setting.getUS_UIA_KEYNO() != null && !setting.getUS_UIA_KEYNO().equals("")){
			Map<String, Object> map = new HashMap<String,Object>();
			map.put("UI_KEYNO", UserDTO.getUI_KEYNO());
			map.put("UIA_KEYNO", setting.getUS_UIA_KEYNO().split(","));
			Component.createData("member.UI_setAuthority", map);
		}
		
		mv.addObject("mirrorPage", "/"+tiles+"/member/regist.do");
		mv.addObject("userInfo", UserDTO);
		mv.addObject("tiles",tiles);
		
		return mv;
	}
	
	
	/**
	 * 아이디 비번찾기
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/{tiles}/member/{type:find||dormancy}.do")
	public ModelAndView MemberFind(HttpServletRequest req, Map<String,Object> commandMap
			, @PathVariable String tiles
			, @PathVariable String type
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/user/"+SiteService.getSitePath(tiles)+"/member/prc_find");
		mv.addObject("type",type);
		mv.addObject("tiles",tiles);
		return mv;
	}
	
	/**
	 * 아이디 비번찾기 - 아이디 리스트 가져오기
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/{tiles}/member/getID.do")
	public ModelAndView MemberIdListFind(UserDTO UserDTO
			, @PathVariable String tiles
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/user/"+SiteService.getSitePath(tiles)+"/member/prc_find_list");
		UserDTO.setUI_EMAIL(AES256Cipher.encode(UserDTO.getUI_EMAIL()));		
		List<UserDTO> resultList = Component.getList("member.UI_findUserWithEmail", UserDTO);	

		mv.addObject("resultList", resultList);
		mv.addObject("mirrorPage", "/"+tiles+"/member/find.do");
		return mv;
	}
	
	
	/**
	 * 이메일 확인후 메일 전송(휴면계정)
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/{tiles}/member/find/confirm.do")
	@ResponseBody
	public boolean MemberFindConfirm(HttpServletRequest req
			, UserDTO UserDTO
			, @RequestParam(value="type") String type
			, @PathVariable String tiles
			) throws Exception {
		boolean state = false;
		UserDTO.setUI_EMAIL(AES256Cipher.encode(UserDTO.getUI_EMAIL()));
		
		UserDTO user = Component.getData("member.UI_findUserIDWithEmail", UserDTO);			
		
		if(user !=null) {
			EmailService.newPswToEmail(user,req, tiles, type);			
			state = true;
		}
		
		return state;
	}
	
	
	/**
	 * 아이디 선택 후 메일 전송
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/{tiles}/member/find/sendEmail.do")
	@ResponseBody
	public UserDTO MemberFindsendEmail(HttpServletRequest req
			, UserDTO UserDTO
			, @PathVariable String tiles
			) throws Exception {
		
		UserDTO user = Component.getData("member.UI_IdCheck", UserDTO);					
		EmailService.newPswToEmail(user,req, tiles, "find");			
		user.setUI_EMAIL(AES256Cipher.decode(user.getUI_EMAIL()));
		
		return user;
	}
	
	/**
	 * 비밀번호 변경
	 * @param req
	 * @param tiles
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/{tiles}/member/pwdchange.do")
	@CheckActivityHistory(desc="비밀번호 변경 페이지 방문")
	public ModelAndView passwordChange(HttpServletRequest req
			,@PathVariable String tiles
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/user/"+SiteService.getSitePath(tiles)+"/member/prc_password_change");
		
		mv.addObject("userInfoSetting", Component.getData("member.US_getData2",CommonService.getSiteMap(tiles)));
		mv.addObject("tiles",tiles);

		return mv;
	}
	
	/**
	 * 비밀번호 수정
	 * @param req
	 * @param UserDTO
	 * @param UI_PASSWORD2
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/{tiles}/password/info/update.do")
	@CheckActivityHistory(type="homeTiles", desc="비밀번호 수정 작업")
	public ModelAndView cfPasswordInfoUpdate(HttpServletRequest req
			, UserDTO UserDTO
			, @PathVariable String tiles
			, @RequestParam(value="UI_PASSWORD2",defaultValue="") String UI_PASSWORD2
			) throws Exception {
		ModelAndView mv  = new ModelAndView("redirect:/"+tiles+"/index.do");
		Map<String, Object> user = CommonService.getUserInfo(req);
		
		UserDTO.setUI_KEYNO(user.get("UI_KEYNO")+"");
		UserDTO.setUI_AUTH_YN("Y");
		
		if(!UI_PASSWORD2.equals("")){
			UserDTO.setUI_PASSWORD(passwordEncoder.encode(UI_PASSWORD2));
		}else{
			UserDTO.setUI_PASSWORD("");
		}
		Component.updateData("member.UI_passwordUpdate", UserDTO);
		req.setAttribute("homeTiles", tiles);
		
		return mv;
	}
	
	/**
	 * 비밀번호 일정기간 뒤 변경
	 * @param req
	 * @param date
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/{tiles}/password/after/update.do")
	@CheckActivityHistory(type="homeTiles", desc="비밀번호 일정기간 뒤 변경")
	public ModelAndView cfPasswordInfoUpdate(HttpServletRequest req
			, UserDTO UserDTO
			,@PathVariable String tiles
			) throws Exception {
		ModelAndView mv  = new ModelAndView("redirect:/"+tiles+"/index.do");
		
		Map<String, Object> user = CommonService.getUserInfo(req);
		SiteManagerDTO SiteManagerDTO =  Component.getData("SiteManager.getData",SiteProperties.getCmsUser());
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("UI_KEYNO", (String)user.get("UI_KEYNO"));
		if(SiteManagerDTO.getPASSWORD_CYCLE() == null || SiteManagerDTO.getPASSWORD_CYCLE().isEmpty()){
			SiteManagerDTO.setPASSWORD_CYCLE("0");
		}
		map.put("REVISE_DATE", Integer.parseInt(SiteManagerDTO.getPASSWORD_CYCLE()));
		
		Component.updateData("member.UI_passwordAfterUpdate", map);
		req.setAttribute("homeTiles", tiles);
		
		return mv;
	}
	
	
	
	/**
	 * 회원정보 수정 페이지
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/{tiles}/mypage/info.do")
	@CheckActivityHistory(desc="회원정보 수정 페이지 방문")
	public ModelAndView MypageInfo(HttpServletRequest req, Map<String,Object> commandMap
			, @RequestParam(value="msg",required= false) String msg
			, @PathVariable String tiles
			) throws Exception {
		ModelAndView mv  = new ModelAndView();
		Map<String, Object> user = CommonService.getUserInfo(req);
		String UI_SNS_ID = (String)user.get("UI_SNS_ID");
		if (StringUtils.isEmpty(UI_SNS_ID)) {
			 mv  = new ModelAndView("/user/"+SiteService.getSitePath(tiles)+"/mypage/prc_info");	
		}else {
			mv  = new ModelAndView("/user/"+SiteService.getSitePath(tiles)+"/mypage/prc_info_sns");	
		}
		
		if(msg != null){
			mv.addObject("msg", msg);
		}
		
		mv.addObject("userInfoSetting", Component.getData("member.US_getData2",CommonService.getSiteMap(tiles)));
		mv.addObject("tiles",tiles);
		return mv;
	}
	
	
	
	/**
	 * 회원정보 수정
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/{tiles}/mypage/info/userUpdate.do")
	@CheckActivityHistory(type="homeTiles",desc="회원정보 수정 작업")
	public ModelAndView MypageInfoUpdate(HttpServletRequest req
			, UserDTO UserDTO 
			, @Valid @ModelAttribute("ModReqUserDTO") ModReqUserDTO ModReqUserDTO
			, BindingResult bindingResult
			, @RequestParam(value="UI_PASSWORD2",defaultValue="") String UI_PASSWORD2
			, @PathVariable String tiles
			, RedirectAttributes redirectAttributes
			) throws Exception {
		ModelAndView mv  = new ModelAndView("redirect:/"+tiles+"/mypage/info.do");
		Map<String, Object> user = CommonService.getUserInfo(req);
		String password = user.get("UI_PASSWORD")+"";
		boolean isCurrentPWMatch = passwordEncoder.matches(UserDTO.getUI_PASSWORD(), password);
		
		String regex = Component.getData("member.get_PasswordRegex",CommonService.getSiteMap(tiles));
		
		String msg = null;
		
		if(StringUtils.isBlank(regex)){
			regex = SettingData.PASSWORD_REGEX;
		}
		
		UserSettingDTO setting = Component.getData("member.US_getData", tiles);
		// 커맨드객체 검증
		ModReqUserDTO.checkEtcValid(bindingResult, setting, regex, req, isCurrentPWMatch);
		
		if(bindingResult.hasErrors()) {
			mv.addObject("userInfoSetting", Component.getData("member.US_getData2",CommonService.getSiteMap(tiles)));
			mv.addObject("mirrorPage", "/"+tiles+"/mypage/info.do");
			mv.addObject("tiles",tiles);
			mv.setViewName("/user/"+SiteService.getSitePath(tiles)+"/mypage/prc_info");
			return mv;
		}
		
		req.setAttribute("homeTiles", tiles);
		
		UserDTO.setUI_KEYNO(user.get("UI_KEYNO")+"");
		UserDTO.setUI_AUTH_YN("Y");
		
		if(!UI_PASSWORD2.equals("")){
			UserDTO.setUI_PASSWORD(passwordEncoder.encode(UI_PASSWORD2));
		}else{
			UserDTO.setUI_PASSWORD("");
		}
		Component.updateData("member.UI_updateUser", UserDTO);
		
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        SecurityContextHolder.getContext().setAuthentication(AuthenticationSessionService.updateAuthentication(authentication,user.get("UI_ID")+"", req));
		
		msg = "변경되었습니다.";
		
		redirectAttributes.addFlashAttribute("msg",msg);
		return mv;
	}
	
	
	/**
	 * 회원탈퇴 페이지
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/{tiles}/mypage/withdraw.do")
	@CheckActivityHistory(desc="회원탈퇴 페이지 방문")
	public ModelAndView MypageWithdraw(HttpServletRequest req, Map<String,Object> commandMap
			, @PathVariable String tiles
			) throws Exception {
		ModelAndView mv  = new ModelAndView();
		Map<String, Object> user = CommonService.getUserInfo(req);
		String UI_SNS_ID = (String)user.get("UI_SNS_ID");
		
		if (StringUtils.isEmpty(UI_SNS_ID)) {
			 mv  = new ModelAndView("/user/"+SiteService.getSitePath(tiles)+"/mypage/prc_withdraw");	
		}else {
			mv  = new ModelAndView("/user/"+SiteService.getSitePath(tiles)+"/mypage/prc_withdraw_sns");	
			SiteManagerDTO SiteManagerDTO =  Component.getData("SiteManager.getData",SiteProperties.getCmsUser());
			mv.addObject("SiteManager", SiteManagerDTO);
		}
		mv.addObject("tiles",tiles);
		return mv;
	}
	/**
	 * 회원탈퇴
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/{tiles}/mypage/withdraw/action.do")
	@ResponseBody
	@Transactional
	@CheckActivityHistory(type="homeTiles",desc="회원탈퇴 작업")
	public boolean MypageWithdrawAction(HttpServletRequest req
			,UserDTO UserDTO
			,@PathVariable String tiles
			,@RequestParam(value="SNS_OUT_URL", required=false) String SNS_OUT_URL // naver 접근 토큰 
			) throws Exception {
		Map<String, Object> user = CommonService.getUserInfo(req);
        req.setAttribute("homeTiles", tiles);
        boolean result = false;
        String password ="";
        if(user.get("UI_PASSWORD") != null) {
        	password =user.get("UI_PASSWORD")+"";
        }
       
        		
		String UI_SNS_ID = (String)user.get("UI_SNS_ID");
		
		if((StringUtils.isEmpty(UI_SNS_ID) && passwordEncoder.matches(UserDTO.getUI_PASSWORD(), password)) || StringUtils.isNotEmpty(UI_SNS_ID)){
			String DEL_POLICY = SiteProperties.getString("USER_DEL_POLICY");
			
			UserDTO.setUI_ID(user.get("UI_ID")+"");
			UserDTO.setUI_KEYNO(user.get("UI_KEYNO")+"");
			UserDTO.setUW_ZENDER(user.get("UI_ZENDER")+"");
			UserDTO.setUW_KEYNO(CommonService.getTableKey("UW"));
			
			//회원 탈퇴 등록
			Component.createData("member.UW_insert", UserDTO);
			
			//해당 유저 게시글 삭제 처리
			Component.updateData("BoardNotice.BN_userDelete", UserDTO);
			
			// 삭제정책(Y:논리삭제, N: 물리삭제)
			if(DEL_POLICY.equals("Y")) {
				Component.updateData("member.UI_deleteL", UserDTO);
			} else {				
				//회원별 권한 삭제
				Component.deleteData("Authority.delete_auth_roll",UserDTO);
				Component.deleteData("Authority.delete_auth_resource",UserDTO);
				Component.deleteData("Authority.delete_auth_member",UserDTO);
				Component.deleteData("Authority.delete_auth",UserDTO);
				Component.deleteData("member.UI_deleteP", UserDTO);
			}
			
			result = true;
			
			 // SNS 로그인 연동해제 부분
	        if(StringUtils.isNoneEmpty(SNS_OUT_URL)) {
	        	String UserSNSType = (String) user.get("UI_SNS_TYPE");
				if(UserSNSType.equals("naver")) {
	        	String[] token= SNS_OUT_URL.split("\\.");
				String accessToken = token[1];
				SiteManagerDTO SiteManagerDTO =  Component.getData("SiteManager.getData",SiteProperties.getCmsUser());
				String nci = SiteManagerDTO.getSNSLOGIN_NAVER_CLIENT_ID();
				String ncs = SiteManagerDTO.getSNSLOGIN_NAVER_CLIENT_SECRET();
				
				String url ="https://nid.naver.com/oauth2.0/token?grant_type=delete&client_id="+nci+"&client_secret="+ncs+"&access_token="+accessToken+"&service_provider=NAVER";
				
				
				result = UrlGetService.UrlGetNaver(url);
				}
			}
		}else{
			result =  false;
		}
		
		
		 
	      
	        
	       return result;
		
		
	}
	
}
