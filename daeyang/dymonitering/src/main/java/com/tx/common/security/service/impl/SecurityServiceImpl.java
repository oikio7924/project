package com.tx.common.security.service.impl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import com.tx.common.security.service.SecurityService;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.member.dto.UserDTO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("SecurityService")
public class SecurityServiceImpl extends EgovAbstractServiceImpl implements SecurityService{

	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	/**	
	 * 스프링 시큐리티 권한 생성
	 * @param currentAuth
	 * @param username
	 * @param req
	 * @return
	 */
	public Authentication createNewAuthentication(Authentication currentAuth, String username, HttpServletRequest req) {
		
		UserDTO user = Component.getData("member.selectUserInfo", username);
		user.decode();
        UserDetails newPrincipal = user;
        Collection<SimpleGrantedAuthority> roles = new ArrayList<SimpleGrantedAuthority>();
        String authority[] = user.getUIA_NAME().split(",");
		for(String auth : authority){
			roles.add(new SimpleGrantedAuthority(auth));
		}
		
        UsernamePasswordAuthenticationToken newAuth = 
            new UsernamePasswordAuthenticationToken(newPrincipal,currentAuth.getCredentials(),roles);
        newAuth.setDetails(currentAuth.getDetails());
        Object principal = newAuth.getPrincipal();
		Map<String, Object> map = null;
		try {
			map = CommonService.ConverObjectToMap(principal);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println("principal 변환 에러");
		}
		if (principal != null && principal instanceof UserDTO && map != null) {	
			String UIA_NAME = (String)map.get("UIA_NAME");
			Map<String, Object> authorityMap = new HashMap<String,Object>();
			authorityMap.put("authList", UIA_NAME.split(","));
			map.put("isAdmin", Component.getData("Authority.UIA_isAdmin", authorityMap)); //관리자 여부
			String ip = CommonService.getClientIP(req);
			map.put("ip", ip);
			req.getSession().setAttribute("userInfo", map);

		}
        return newAuth;
    }
	
	
}
