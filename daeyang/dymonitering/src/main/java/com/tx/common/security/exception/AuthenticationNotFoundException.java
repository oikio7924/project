package com.tx.common.security.exception;

import org.springframework.security.core.userdetails.UsernameNotFoundException;

public class AuthenticationNotFoundException extends UsernameNotFoundException{

	private static final long serialVersionUID = -2070921822527251911L;

	public AuthenticationNotFoundException() {
		super(Language.getExceptionMessage(4));
	}
	
}
