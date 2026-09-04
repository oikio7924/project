package com.tx.common.security.password;

public interface MyPasswordEncoder {
	
	
	public String encode(CharSequence rawPassword);
	
	public boolean matches(CharSequence rawPassword, String encodedPassword);
	
	
}
