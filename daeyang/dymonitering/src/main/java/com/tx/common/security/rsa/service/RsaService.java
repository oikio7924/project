package com.tx.common.security.rsa.service;

import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.spec.InvalidKeySpecException;

import javax.servlet.http.HttpServletRequest;

public interface RsaService{
	
	public void setRsa(HttpServletRequest req) throws NoSuchAlgorithmException, InvalidKeySpecException;
	
	public String decryptRsa(PrivateKey privateKey, String securedValue) throws Exception;
	
}
