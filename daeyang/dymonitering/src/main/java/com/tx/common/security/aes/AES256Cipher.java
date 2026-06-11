package com.tx.common.security.aes;

import java.security.spec.AlgorithmParameterSpec;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;

import com.tx.common.config.tld.SiteProperties;

/**
 * Created by 김선호 on 2018-04-26.
 */
public class AES256Cipher {

    private static byte[] ivBytes = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
    // 알고리즘/모드/패딩
    private static final String algorithm = "AES/CBC/PKCS5Padding";
    
    public static String encode(String str) throws Exception {

    	return encode(str, SiteProperties.getSalt());
	}

	public static String decode(String str) throws Exception {
		return decode(str, SiteProperties.getSalt());
	}
	
	
	public static String encode(String str, String secretKey) throws Exception {

		byte[] bytes = str.getBytes("UTF-8");

		Cipher cipher = getCipher(Cipher.ENCRYPT_MODE, secretKey);
		
		return new String(Base64.encodeBase64(cipher.doFinal(bytes)));
	}

	public static String decode(String str, String secretKey) throws Exception {
        str = str.replaceAll(" ", "+");
		byte[] bytes = Base64.decodeBase64(str.getBytes());

		Cipher cipher = getCipher(Cipher.DECRYPT_MODE, secretKey);
		
		return new String(cipher.doFinal(bytes));
	}
	
	
	private static Cipher getCipher(int decryptMode, String secretKey) throws Exception{
		
		AlgorithmParameterSpec spec = new IvParameterSpec(ivBytes);
		
		SecretKeySpec keySpec = new SecretKeySpec(secretKey.getBytes("UTF-8"), "AES");

		Cipher cipher;
		cipher = Cipher.getInstance(algorithm);
		cipher.init(decryptMode, keySpec, spec);
		
		return cipher;
	}
}