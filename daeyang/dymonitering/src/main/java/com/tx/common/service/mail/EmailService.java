package com.tx.common.service.mail;

import javax.servlet.http.HttpServletRequest;

import org.apache.velocity.VelocityContext;

import com.tx.dyAdmin.admin.board.dto.BoardNotice;
import com.tx.dyAdmin.member.dto.UserDTO;

public interface EmailService {
	
	public void sendEmail(String emailTitle, String email, String contents) throws Exception;
	
	
	/**
	 * 게시물 등록/수정 이메일
	 * @param email 
	 * @throws Exception 
	 *   */
	public void sendBoardEmail(String menuName, BoardNotice boardNotice, int boardKey, String email, HttpServletRequest req, String tiles, String action) throws Exception;
	
	/**
	 * 회원 활성화 인증메일 보내기
	 * ( 아이디 + divStr(구분자) + 현재시간(밀리세컨드) 문자열을 암호화 후 return  
	 * @throws Exception 
	 *   */
	public String sendAuthEmail(UserDTO UserDTO, HttpServletRequest req, String tiles) throws Exception;
	
	/**
	 * 아이디 및 비밀번호 찾기
	 * @param reciver
	 * @param UserDTO
	 * @throws Exception
	 */
	public void newPswToEmail(UserDTO UserDTO, HttpServletRequest req, String tiles, String type) throws Exception;
	
		
	/**
	 * 이메일 인증 코드 생성
	 * ( 아이디 + divStr(구분자) + 현재시간(밀리세컨드) 문자열을 암호화 후 return  
	 * @throws Exception 
	 *   */
	public String makeEmailAuthCode(UserDTO UserDTO) throws Exception;
	
	/**
	 * 이메일 인증 코드 생성
	 * @throws Exception 
	 *   */
	public UserDTO isEmailAuthCode(String encodedInfo) throws Exception;
	
	/**
	 * 휴면계정 정보 조회
	 * @throws Exception
	 */
	public UserDTO isDormancyInfo(String encodedInfo) throws Exception;
	
	
	/** velocity 이메일 설정
	 * @throws Exception
	 */
	public String velocity(String vm, VelocityContext velocityContext) throws Exception;
	
}