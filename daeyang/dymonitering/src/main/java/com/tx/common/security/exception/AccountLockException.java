package com.tx.common.security.exception;

import org.springframework.security.core.AuthenticationException;

public class AccountLockException extends AuthenticationException{

	private static final long serialVersionUID = -2070921822527251911L;

	public AccountLockException() {
		super(Language.getExceptionMessage(6));
	}
	
}
