package com.tx.user.member.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.security.aes.AES256Cipher;
import com.tx.common.security.password.MyPasswordEncoder;
import com.tx.common.security.service.AuthenticationSessionService;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.mail.EmailService;
import com.tx.dyAdmin.member.dto.UserDTO;
import com.tx.dyAdmin.member.dto.UserSettingDTO;
import com.tx.dyAdmin.program.application.dto.ApplicationDTO;
/**
 * 
 * @FileName: MemberController.java
 * @Project : cf
 * @Date    : 2017. 05. 31. 
 * @Author  : 이재령	
 * @Version : 1.0
 */
//@Controller
public class MemberController {

	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 암호화 */
	@Autowired MyPasswordEncoder passwordEncoder;
	
	/** email **/
    @Autowired private EmailService EmailService;
    
    @Autowired AuthenticationSessionService AuthenticationSessionService;
    
	/**
	 * 회원가입 - 약관동의
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dy/member/regist.do")
	@CheckActivityHistory(desc="회원가입 - 약관동의 페이지 방문")
	public ModelAndView cfMemberRegist(HttpServletRequest req, Map<String,Object> commandMap
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/user/dy/member/prc_regist_agree");
		
		mv.addObject("userInfoSetting", Component.getData("member.US_getData","cf"));
		
		return mv;
	}
	
	/**
	 * 회원가입 - 회원정보
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dy/member/regist/info.do")
	@CheckActivityHistory(desc="회원가입 - 회원정보 페이지 방문")
	public ModelAndView cfMemberRegistInfo(HttpServletRequest req
			, @RequestParam(value="data",defaultValue="") String data
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/user/dy/member/prc_regist_info");
		
		
		if(!data.equals("data")){ //약관동의에서 넘어올때만 data에 값 들어옴
			mv.setViewName("redirect:/dy/member/regist.do");
			return mv;
		}
		
		mv.addObject("userInfoSetting", Component.getData("member.US_getData","cf"));
		mv.addObject("mirrorPage", "/dy/member/regist.do");
		return mv;
	}
	/**
	 * 회원가입 - 가입완료
	 * @param req
	 * @param data
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dy/member/regist/result.do")
	@Transactional
	@CheckActivityHistory(desc="회원가입 - 가입완료 작업")
	public ModelAndView cfMemberRegistSave(HttpServletRequest req
			, UserDTO UserDTO
			, @RequestParam(value="tiles") String tiles
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/user/dy/member/prc_regist_result");
	
		UserSettingDTO setting = Component.getData("member.US_getData",tiles);
		
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
			EmailService.sendAuthEmail(UserDTO,req,"cf");
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
		
		mv.addObject("mirrorPage", "/dy/member/regist.do");
		mv.addObject("userInfo", UserDTO);
		return mv;
	}
	
	
	/**
	 * 아이디 비번찾기
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dy/member/{type:find||dormancy}.do")
	public ModelAndView cfMemberFind(HttpServletRequest req, Map<String,Object> commandMap, @PathVariable String type
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/user/dy/member/prc_find");
		mv.addObject("type", type);
		return mv;
	}
	
	/**
	 * 이메일 확인후 메일 전송
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dy/member/find/confirm.do")
	@ResponseBody
	public boolean cfMemberFindConfirm(HttpServletRequest req
			, UserDTO UserDTO
			, @RequestParam(value="type") String type
			) throws Exception {
		boolean state = false;
		
		List<UserDTO> userList = Component.getList("member.UI_findUserWithEmail", UserDTO);
		
		if(userList != null){
			for(UserDTO u : userList){
				if(UserDTO.getUI_EMAIL().equals(AES256Cipher.decode(u.getUI_EMAIL()))){
					EmailService.newPswToEmail(u,req,"cf", type);
					state = true;
					break;
				}
			}
		}
		
		
		return state;
	}
	
	/**
	 * 회원정보 수정 페이지
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dy/mypage/info.do")
	@CheckActivityHistory(desc="회원정보 수정 페이지 방문")
	public ModelAndView cfMypageInfo(HttpServletRequest req, Map<String,Object> commandMap
			,@RequestParam(value="msg",required= false) String msg) throws Exception {
		ModelAndView mv  = new ModelAndView("/user/dy/mypage/prc_info");
		
		if(msg != null){
			mv.addObject("msg", msg);
		}
		return mv;
	}
	
	
	
	/**
	 * 회원정보 수정
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dy/mypage/info/update.do")
	@CheckActivityHistory(desc="회원정보 수정 작업")
	public ModelAndView cfMypageInfoUpdate(HttpServletRequest req
			, UserDTO UserDTO
			, @RequestParam(value="UI_PASSWORD2",defaultValue="") String UI_PASSWORD2
			) throws Exception {
		ModelAndView mv  = new ModelAndView("redirect:/dy/mypage/info.do");
		Map<String, Object> user = CommonService.getUserInfo(req);
		
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
		
		
		return mv;
	}
	
	
	
	
	/**
	 * 회원탈퇴 페이지
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dy/mypage/withdraw.do")
	@CheckActivityHistory(desc="회원탈퇴 페이지 방문")
	public ModelAndView cfMypageWithdraw(HttpServletRequest req, Map<String,Object> commandMap
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/user/dy/mypage/prc_withdraw");
		
		return mv;
	}
	/**
	 * 회원탈퇴
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dy/mypage/withdraw/action.do")
	@ResponseBody
	@CheckActivityHistory(desc="회원탈퇴 작업")
	public boolean cfMypageWithdrawAction(HttpServletRequest req
			,UserDTO UserDTO
			) throws Exception {
		Map<String, Object> user = CommonService.getUserInfo(req);
		
		String password = user.get("UI_PASSWORD")+"";
		
		
		if(passwordEncoder.matches(UserDTO.getUI_PASSWORD(), password)){
            String DEL_POLICY = SiteProperties.getString("USER_DEL_POLICY");
            
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
                Component.deleteData("member.UI_deleteP", UserDTO);
            }
			return true;
		}else{
			return false;
		}
		
	}

	
}
