package com.tx.dyAdmin.member.dto;

import java.io.Serializable;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;

import org.apache.commons.lang3.StringUtils;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.SpringSecurityCoreVersion;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.util.Assert;

import com.tx.common.dto.Common;
import com.tx.common.security.aes.AES256Cipher;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class UserDTO extends Common implements UserDetails  {
	
	private static final long serialVersionUID = -3793808669767332434L;
	
	private String  
					// U_USERINFO 테이블
					UI_KEYNO,
					UI_ID,
					UI_PASSWORD,
					UI_NAME,
					UI_EMAIL,
					UI_PHONE,
					UI_BIRTH,
					UI_ZENDER,
					UI_AUTHORITY,
					UI_DELYN,
					UI_REGDT,
					UI_MODDT,
					UI_AUTH_YN,
					UI_AUTH_DATA,
					UI_REP_NAME,
					UI_COMPANY,
					UI_RANK,
					UI_LASTLOGIN,
					UI_TRY_COUNT,
					UI_LOGIN_COUNT,
					UI_LOCKYN,
					UI_LOCKDATE,
					lockDate,
					UI_PWD_INIT,
					UI_PASSWORD_CHDT,
					UI_PRE_PASSWORD,
					UI_SNS_ID,
					UI_SNS_TYPE,
					UI_DORMANCY,
					UI_ALIMYN,
					
					// U_USERINFO_AUTHORITY 테이블
					UIA_KEYNO,
					UIA_NAME,
					UIA_COMMENT,
					UIA_SYSTEM,
					UIA_MAINKEY,
					UIA_DIVISION,
					UIA_HOMEKEY,
					
					// U_USERINFO_ROLL 테이블
					UIR_KEYNO,
					UIR_NAME,
					UIR_SYSTEM,
					UIR_TYPE,
					UIR_TYPE_NAME,
					UIR_COMMENT
					
					// U_USERINFO_WITHDRAW 테이블
					, UW_KEYNO
					, UW_REGDT
					, UW_DEL_REASON
					, UW_ZENDER
					, UI_DEL_REASON
					;
	
	
	


	//사용자 정의
	private int UI_TOTAL = 0; // 총 회원수
	private int UI_TOTAL_LEAVE = 0; // 총 탈퇴회원
				


	private boolean accountNonExpired = true;
    private boolean accountNonLocked = true;
	private boolean credentialsNonExpired = true;
    private boolean enabled = true;
    
    private boolean rememberMe = false;
    
	private Set<GrantedAuthority> authorities; // 계정이 가지고 있는 권한 목록
	
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		return authorities;
	}
	
	public void setAuthorities(Collection<? extends GrantedAuthority> authorities) {
		this.authorities = Collections.unmodifiableSet(sortAuthorities(authorities));
		//this.authorities = authorities;
	}
	
	
	@Override
	public String getUsername() {
		return getUI_ID();
	}
	
	@Override
	public String getPassword() {
		return getUI_PASSWORD();
	}
	
	@Override
	public boolean isAccountNonExpired() {
		return accountNonExpired;
	}
	@Override
	public boolean isAccountNonLocked() {
		
		return accountNonLocked;
	}
	@Override
	public boolean isCredentialsNonExpired() {
		return credentialsNonExpired;
	}
	@Override
	public boolean isEnabled() {
		return enabled;
	}

	public void setAccountNonExpired(boolean accountNonExpired) {
		this.accountNonExpired = accountNonExpired;
	}
	public void setAccountNonLocked(boolean accountNonLocked) {
		this.accountNonLocked = accountNonLocked;
	}
	public void setCredentialsNonExpired(boolean credentialsNonExpired) {
		this.credentialsNonExpired = credentialsNonExpired;
	}
	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}
	private static SortedSet<GrantedAuthority> sortAuthorities(Collection<? extends GrantedAuthority> authorities) {

		Assert.notNull(authorities, "Cannot pass a null GrantedAuthority collection");
		SortedSet<GrantedAuthority> sortedAuthorities = new TreeSet<GrantedAuthority>(new AuthorityComparator());
		for (GrantedAuthority grantedAuthority : authorities) {
			Assert.notNull(grantedAuthority, "GrantedAuthority list cannot contain any null elements");
			sortedAuthorities.add(grantedAuthority);
			}
		return sortedAuthorities;
	}
	
	@SuppressWarnings("serial")
	private static class AuthorityComparator implements Comparator<GrantedAuthority>, Serializable {
		@SuppressWarnings("unused")
		private static final long serialVersionUId = SpringSecurityCoreVersion.SERIAL_VERSION_UID;

		@Override
		public int compare(GrantedAuthority g1, GrantedAuthority g2) {
			if (g2.getAuthority() == null) {
				return -1;
			}
			if (g1.getAuthority() == null) {
				return 1;
			}
			return g1.getAuthority().compareTo(g2.getAuthority());
		}
		
		
	}
	
	
	public void decode(){
		
		try{
			if(StringUtils.isNotBlank(this.UI_EMAIL)){
				this.UI_EMAIL = AES256Cipher.decode(this.UI_EMAIL);
			}
			if(StringUtils.isNotBlank(this.UI_PHONE)){
				this.UI_PHONE = AES256Cipher.decode(this.UI_PHONE);
			}
			
		}catch(Exception e){
			System.out.println("UserDTO 복호화중 에러 :: " + e.getMessage());
		}
		
	}
	
	public void encode(){
		try{
			if(StringUtils.isNotBlank(this.UI_EMAIL)){
				this.UI_EMAIL = AES256Cipher.encode(this.UI_EMAIL);
			}
			if(StringUtils.isNotBlank(this.UI_PHONE)){
				this.UI_PHONE = AES256Cipher.encode(this.UI_PHONE);
			}
			
		}catch(Exception e){
			System.out.println("UserDTO 암호화중 에러 :: " + e.getMessage());
		}
	}

}
