package com.tx.common.security.password.impl;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.crypto.password.StandardPasswordEncoder;
import org.springframework.stereotype.Service;

import com.tx.common.security.password.MyPasswordEncoder;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("MyPasswordEncoder")
public class SHA256PasswordEncoder extends EgovAbstractServiceImpl implements MyPasswordEncoder {
	
	
	/** 암호화 */
	PasswordEncoder passwordEncoder = new StandardPasswordEncoder("TRONIX$(%&@!CTCMS");	//SHA256
//	PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
	
	@Override
	public String encode(CharSequence rawPassword){
		return passwordEncoder.encode(rawPassword);
	}
	
	@Override
	public boolean matches(CharSequence rawPassword, String encodedPassword){
		return passwordEncoder.matches(rawPassword, encodedPassword);
	}
	
	
}
