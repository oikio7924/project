package com.tx.common.security.handler;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

import lombok.Data;
 
/**
 * 인증 실패 핸들러
 * @author TerryChang
 *
 */
@Data
public class CustomAuthenticationFailureHandler implements AuthenticationFailureHandler {
 
    private String loginidname;         // 로그인 id값이 들어오는 input 태그 name
    private String loginpasswdname;     // 로그인 password 값이 들어오는 input 태그 name
    private String loginredirectname;       // 로그인 성공시 redirect 할 URL이 지정되어 있는 input 태그 name
    private String exceptionmsgname;        // 예외 메시지를 request의 Attribute에 저장할 때 사용될 key 값
    
    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response, AuthenticationException exception) throws IOException, ServletException {
        
    	
    	
    	String tiles = (String)request.getParameter("tiles");
    	if(tiles == null){
    		String URL = request.getServletPath();
    		tiles = URL.split("/")[1];
    	}
		
		String defaultFailureUrl = "/dyAdmin/user/login.do";
		if(!"dyAdmin".equals(tiles)){
			defaultFailureUrl = "/user/member/login.do?tiles="+tiles;
		}
		
		String message = exception.getMessage();

		/*if("tiles".equals(tiles)){
			if("DORMANCY".equals(message)){	
				defaultFailureUrl = "/" + tiles + "/member/dormancy.do";
			}
		}*/
		
        request.getSession().setAttribute("customExceptionmsg", message);
        
        if(request.getParameter("returnPage") != null){
        	request.getSession().setAttribute("returnPage", request.getParameter("returnPage"));
		}
        
        
        response.sendRedirect(request.getContextPath() + defaultFailureUrl);

    }
 
}
