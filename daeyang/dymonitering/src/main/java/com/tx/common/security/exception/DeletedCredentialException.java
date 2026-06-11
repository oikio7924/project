package com.tx.common.security.exception;

import org.springframework.security.core.AuthenticationException;

public class DeletedCredentialException extends AuthenticationException{

	private static final long serialVersionUID = -2070921822527251911L;

	public DeletedCredentialException() {
		super(Language.getExceptionMessage(5));
	}
	
}
