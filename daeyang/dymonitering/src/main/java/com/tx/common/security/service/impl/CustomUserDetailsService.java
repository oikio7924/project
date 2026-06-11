package com.tx.common.security.service.impl;

import java.util.ArrayList;
import java.util.Collection;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.tx.common.security.exception.AuthenticationNotFoundException;
import com.tx.common.security.exception.CustomUsernameNotFoundException;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.member.dto.UserDTO;

public class CustomUserDetailsService implements UserDetailsService {
    
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
 
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        UserDTO user = (UserDTO) Component.getData("member.selectUserInfo", username);
        if(user==null) {
            throw new CustomUsernameNotFoundException();
        }
        
        Collection<SimpleGrantedAuthority> roles = new ArrayList<SimpleGrantedAuthority>();
        
        if(user.getUIA_NAME() == null){
        	throw new AuthenticationNotFoundException();
        }
        
    	String authority[] = user.getUIA_NAME().split(",");
    	for(String auth : authority){
    		roles.add(new SimpleGrantedAuthority(auth));
    	}
    	user.setAuthorities(roles);
        
        return user;
    }
 
}


