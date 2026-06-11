package com.tx.common.service.mail.impl;

import java.io.StringWriter;
import java.security.SecureRandom;
import java.util.Calendar;
import java.util.Date;
import java.util.Properties;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;

import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.icu.text.SimpleDateFormat;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.security.aes.AES256Cipher;
import com.tx.common.security.password.MyPasswordEncoder;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.mail.EmailService;
import com.tx.dyAdmin.admin.board.dto.BoardNotice;
import com.tx.dyAdmin.member.dto.UserDTO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EmailService")
public class EmailServiceImpl extends EgovAbstractServiceImpl implements EmailService{
	
	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 암호화 */
	@Autowired MyPasswordEncoder passwordEncoder;
	
	@Autowired
	private EmailSender emailSender;
	
	@Override
	public void sendEmail(String emailTitle, String email, String contents) throws Exception {
	    	emailSender.sendEmail(email, emailTitle, contents);
	}
	/**
	 * 게시물 등록/수정 이메일
	 * @param email 
	 * @throws Exception 
	 *   */
	@Override
	public void sendBoardEmail(String menuName, BoardNotice boardNotice, int boardKey, String email, HttpServletRequest req, String tiles, String action) throws Exception {
		SimpleDateFormat format = new SimpleDateFormat ( "yyyy-MM-dd HH:mm:ss");
		String today = format.format(new Date());
		
		String emailTitle = "["+menuName + "] 게시판에 게시물이 " + action + "되었습니다.";
		String domain = CommonService.checkUrl(req);
		String boardUrl = domain + "/"+tiles+"/Board/" + boardKey + "/detailView.do";
		
	    VelocityContext velocityContext = new VelocityContext();
	    velocityContext.put("domain",domain);
	    velocityContext.put("emailTitle",emailTitle);
	    velocityContext.put("boardName",boardNotice.getBN_TITLE());
	    velocityContext.put("boardContent",boardNotice.getBN_CONTENTS());
	    velocityContext.put("boardRegdt",today);
	    velocityContext.put("boardUrl", boardUrl);

	    // velocityEngine property설정
	    String veloTemplate = velocity("boardEmail.vm", velocityContext);
		 
		emailSender.sendEmail(email, emailTitle, veloTemplate);
	}
	
	
	/**
	 * 회원 활성화 인증메일 보내기
	 * ( 아이디 + divStr(구분자) + 현재시간(밀리세컨드) 문자열을 암호화 후 return  
	 * @throws Exception 
	 *   */
	@Override
	public String sendAuthEmail(UserDTO UserDTO, HttpServletRequest req, String tiles) throws Exception{
		String ret = "";
		
		String emailTitle = SiteProperties.getString("HOMEPAGE_NAME") + " 계정 활성화 안내";
		String domain = CommonService.checkUrl(req);
		String encodedInfo = makeEmailAuthCode(UserDTO);
		String AuthURL = domain + "/"+tiles+"/member/signAuth/update.do?userinfo=" + encodedInfo;

	    VelocityContext velocityContext = new VelocityContext();
	    velocityContext.put("domain",domain);
	    velocityContext.put("AuthURL",AuthURL);
	    velocityContext.put("UI_NAME", UserDTO.getUI_NAME());
	    
	    // velocityEngine property설정	
	    String veloTemplate = velocity("emailAuth.vm", velocityContext);
	    
		emailSender.sendEmail(UserDTO.getUI_EMAIL(), emailTitle, veloTemplate);
		
		return ret;
	}

	
	/**
	 * 아이디 및 비밀번호 찾기, 휴면계정 해제
	 * @param reciver
	 * @param UserDTO
	 * @throws Exception
	 */
	@Override
	public void newPswToEmail(UserDTO UserDTO, HttpServletRequest req, String tiles, String type) throws Exception{
		
		String emailTitle = SiteProperties.getString("HOMEPAGE_NAME") + " 계정 안내";
		String domain = CommonService.checkUrl(req);
		String url = domain + "/user/member/login.do?tiles="+tiles;
		if("dormancy".equals(type)){
			 emailTitle = SiteProperties.getString("HOMEPAGE_NAME") + " 휴면계정 해지 안내";
			 String encodedInfo = UserDTO.getUI_EMAIL()+"::"+AES256Cipher.encode(UserDTO.getUI_ID());
			 url = domain + "/"+tiles+"/member/dormancy/update.do?userinfo="+encodedInfo;
		}
		StringBuffer buffer = new StringBuffer();
		Random random = SecureRandom.getInstanceStrong();
		
		// 비밀번호랜덤 생성
		String chars[] = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,1,2,3,4,5,6,7,8,9".split(",");
		for (int i = 0; i < 8; i++) {
			buffer.append(chars[random.nextInt(chars.length)]);
		}
		
		// 서버 비밀번호 변경 (UI_KEYNO 필요)
		UserDTO.setUI_PASSWORD( passwordEncoder.encode(buffer.toString()));
		Component.updateData("member.UI_updateUserTempPwd", UserDTO);
		
	    VelocityContext velocityContext = new VelocityContext();
	    velocityContext.put("user", UserDTO);
	    velocityContext.put("pwd", buffer.toString());
	    velocityContext.put("url",url);
	    velocityContext.put("domain",domain);
	    
	    // velocityEngine property설정
		
	    String veloTemplate = "";
	    if("dormancy".equals(type)){
	    	veloTemplate = velocity("DormancyConfirm.vm", velocityContext);
	    }else{
	    	veloTemplate = velocity("idAndPwdConfirm.vm", velocityContext);
	    }
	    
		// 비밀번호 발송
	    String email = AES256Cipher.decode(UserDTO.getUI_EMAIL());
		emailSender.sendEmail(email, emailTitle, veloTemplate);
	}
	
		
	/**
	 * 이메일 인증 코드 생성
	 * ( 아이디 + divStr(구분자) + 현재시간(밀리세컨드) 문자열을 암호화 후 return  
	 * @throws Exception 
	 *   */
	@Override
	public String makeEmailAuthCode(UserDTO UserDTO) throws Exception{
		String beforeEncInfo = "";
		String encodedInfo = "";
		String divStr = "^_^";
		
		Calendar cal = Calendar.getInstance();
		beforeEncInfo += UserDTO.getUI_ID() + divStr;
		beforeEncInfo += cal.getTimeInMillis();
		
		encodedInfo = AES256Cipher.encode(beforeEncInfo);
		UserDTO.setUI_AUTH_DATA(beforeEncInfo);
		Component.updateData("member.UI_userSignAuthData", UserDTO);
		
		return encodedInfo;
	}
	
	/**
	 * 이메일 인증 코드 생성
	 * @throws Exception 
	 *   */
	@Override
	public UserDTO isEmailAuthCode(String encodedInfo) throws Exception{
		String decodedInfo = AES256Cipher.decode(encodedInfo.replaceAll(" ", "+"));
		
		return Component.getData("member.UI_userSignAuthConfirm", decodedInfo);
	}
	
	/**
	 * 휴면 정보 조회
	 * @throws Exception 
	 *   */
	@Override
	public UserDTO isDormancyInfo(String encodedInfo) throws Exception{
		String[] decodedInfo= (encodedInfo.replaceAll(" ", "+")).split("::");
		UserDTO user = new UserDTO();
		user.setUI_EMAIL(decodedInfo[0]);
		user.setUI_ID(AES256Cipher.decode(decodedInfo[1]));
		
		return  Component.getData("member.UI_findUserIDWithEmail", user);
	}
	@Override
	public String velocity(String vm, VelocityContext velocityContext) throws Exception {
		VelocityEngine velocityEngine = new VelocityEngine();
		StringWriter stringWriter = new StringWriter();
		Properties properties = new Properties();
	    properties.setProperty("resource.loader", "class, file");
	    properties.setProperty("file.resource.loader.class", "org.apache.velocity.runtime.resource.loader.FileResourceLoader");
	    
	    //파일 경로 설정
	    properties.setProperty("file.resource.loader.path", SiteProperties.getString("JSP_PATH").replace("jsp", "emailForm"));
	    velocityEngine.init(properties);
	    
	    velocityEngine.mergeTemplate(vm, "UTF-8", velocityContext, stringWriter);
	    return stringWriter.toString();
	}
	
}