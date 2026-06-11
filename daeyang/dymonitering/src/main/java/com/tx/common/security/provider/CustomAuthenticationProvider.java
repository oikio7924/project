package com.tx.common.security.provider;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.tx.common.config.session.CustomSessionRegistry;
import com.tx.common.security.exception.AccountConnectionLimitExceededException;
import com.tx.common.security.exception.AccountLockException;
import com.tx.common.security.exception.AccountLockedException;
import com.tx.common.security.exception.AuthenticationNotFoundException;
import com.tx.common.security.exception.DeletedCredentialException;
import com.tx.common.security.exception.NotCertifiedCredentialException;
import com.tx.common.security.exception.PasswordIncorrectException;
import com.tx.common.security.password.MyPasswordEncoder;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.member.dto.UserDTO;

import lombok.Data;
 
@Data
public class CustomAuthenticationProvider implements AuthenticationProvider{
 
	
	protected final Log logger = LogFactory.getLog(CustomAuthenticationProvider.class);
	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	
	/** 암호화 */
	@Autowired MyPasswordEncoder passwordEncoder;
	
	@Autowired UserDetailsService CustomUserDetailsService;
	
	@Autowired
    private CustomSessionRegistry sessionRegistry;
	
	private boolean usedLimitMaxSession = false;
	
	private int maxSessions = 0;
	
	private boolean existingSessionKill = true;
	
	public Authentication authenticate(Authentication authentication) throws AuthenticationException {
    		
			UserDTO user = getUserDTO(authentication);
			
            checkLockUser(user);
            
            checkPassword(user,authentication);
            
    		if(user.getUI_AUTH_YN().equals("N")){
    			throw new NotCertifiedCredentialException();
    		}
    		
    		if(user.getUIA_NAME() == null){
    			throw new AuthenticationNotFoundException();
    		}
    		
    		if(user.getUI_DELYN().equals("Y")){
    			throw new DeletedCredentialException();
    		}
    		
    		if(usedLimitMaxSession){
    			//같은 아이디 동시접속자수 체크
    			if(checkMaxSessions(user.getUI_ID())){
    				throw new AccountConnectionLimitExceededException();
    			}
    		}
    		
            //잠금 관련 해제 처리
     		Component.updateData("member.updateUnlock", user);
           
            return new UsernamePasswordAuthenticationToken(user, user.getPassword(), user.getAuthorities());
    }
	
	/**
	 * 일반 로그인시 id로 UserDTO를 가져온다.
	 * 리멤버미 일경우 authentication.getPrincipal() 에 UserDTO가 저장되어있다.
	 * @param authentication
	 * @return
	 * @throws UsernameNotFoundException
	 */
	private UserDTO getUserDTO(Authentication authentication) throws UsernameNotFoundException {
		// TODO Auto-generated method stub
		UserDTO user = null;
		if(authentication.getPrincipal() instanceof UserDTO){
			user = (UserDTO) authentication.getPrincipal();
			user.setRememberMe(true);
		}else{
			user = (UserDTO) CustomUserDetailsService.loadUserByUsername(authentication.getName());
		}
		
		return user;
	}

	/**
	 * 패스워드 체크 
	 * 5회 틀릴시 잠금처리
	 * rememberMe로 접근시 체크 안함.
	 * @param user
	 * @param authentication
	 * @throws AuthenticationException
	 */
	private void checkPassword(UserDTO user, Authentication authentication) throws AuthenticationException {
		// TODO Auto-generated method stub
		
		if(user.isRememberMe()) return;
		
		String password = (String) authentication.getCredentials();
		
		if (passwordEncoder.matches(password, user.getUI_PASSWORD())) {
			if("Y".equals(user.getUI_DORMANCY())) { // 휴면계정이면(마지막 로그인이 2년 전)
				throw new PasswordIncorrectException(9);
			} else {				
				return;
			}
		}
		
		/*
		 * int count = 0;
		 * 
		 * if(StringUtils.isNumeric(user.getUI_TRY_COUNT())) { count =
		 * Integer.parseInt(user.getUI_TRY_COUNT()); }
		 * 
		 * count++; user.setUI_TRY_COUNT(count+"");
		 * 
		 * if(count >= 5) { user.setUI_LOCKYN("Y");
		 * Component.updateData("member.updateLock", user); throw new
		 * AccountLockException(); }
		 * 
		 * Component.updateData("member.updateTryCount", user);
		 */
    	throw new PasswordIncorrectException(2);
	}

	/**
	 * /**
	 * 계정 잠겨있는지 여부
	 * @param user
	 * @throws LockedException
	 */
	private void checkLockUser(UserDTO user) throws LockedException {
		// TODO Auto-generated method stub
		
		if("N".equals(user.getUI_LOCKYN())) return;
		
		Date today = new Date();
        Date targetDate = null;
        try {
        	targetDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(user.getLockDate());
        } catch (Exception e) {
        	logger.debug("error : LOCKDATE 값 잘못들어가 있음. 로그인 처리");
        	return;
        }
        long diffSec = (today.getTime() - targetDate.getTime()) / 1000;
        long minute = diffSec / 60;
        
      	if(minute < 30) throw new AccountLockedException();
  		
	}

	/**
	 * 해당 id로 기존 로그인한 세션을 확인하여 maxSessions 값을 넘어가면 기존 session을 죽인다.
	 * @param id
	 */
    private boolean checkMaxSessions(String id) {
    	
    	
    	List<Object> allPrincipals = sessionRegistry.getAllPrincipals();
    	
    	int existCount = 0;
    	for(Object principal : allPrincipals) {
            
    		if(principal instanceof UserDTO) {
                UserDTO user = (UserDTO) principal;
                String UI_ID = user.getUI_ID();
                if(id.equals(UI_ID)){
                	if(++existCount >= maxSessions){
                		if(existingSessionKill){
                			HttpSession session = sessionRegistry.getSession(principal);
                			sessionRegistry.removeSessionInformation(session.getId());
                			session.invalidate();
                		}else{
                			return true;
                		}
                	}
                }
                
            }
        }
    	
    	return false;
    	
	}

	public boolean supports(Class<?> arg0) {
        return true;
    }
    
 
}