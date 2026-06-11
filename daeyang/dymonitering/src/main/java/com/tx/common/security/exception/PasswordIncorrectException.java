package com.tx.common.security.exception;

import org.springframework.security.core.AuthenticationException;

public class PasswordIncorrectException extends AuthenticationException{

	private static final long serialVersionUID = -2070921822527251911L;

	public PasswordIncorrectException(int type) {
		super(Language.getExceptionMessage(type));
	}
	
}
