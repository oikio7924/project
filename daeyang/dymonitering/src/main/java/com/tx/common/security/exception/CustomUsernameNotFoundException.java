package com.tx.common.security.exception;

import org.springframework.security.core.userdetails.UsernameNotFoundException;

public class CustomUsernameNotFoundException extends UsernameNotFoundException{

	private static final long serialVersionUID = -2070921822527251911L;

	public CustomUsernameNotFoundException() {
		super(Language.getExceptionMessage(1));
	}
	
}
