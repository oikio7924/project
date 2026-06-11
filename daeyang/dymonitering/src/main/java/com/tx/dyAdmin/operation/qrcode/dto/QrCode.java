package com.tx.dyAdmin.operation.qrcode.dto;

import com.tx.common.security.aes.AES256Cipher;

import lombok.Data;

@Data
public class QrCode {
    
    private String CQ_KEYNO, CQ_URL, CQ_NAME, CQ_FS_KEYNO, FS_CHANGENM;
    private int CQ_WIDTH, CQ_HEIGHT;
    
    
    public String getEncodeFsKey(){
		
		String encodeFsKey = "";
		try{
			encodeFsKey = AES256Cipher.encode(CQ_FS_KEYNO);
		}catch(Exception e){
			System.out.println("AES256Cipher.encode() 에러");
		}
		
		return encodeFsKey;
	}
    
	public void setCQ_WIDTH(Integer cQ_WIDTH) {
		if(cQ_WIDTH == null){
			cQ_WIDTH = 0;
		}else{
			CQ_WIDTH = cQ_WIDTH;
		}
	}

	public void setCQ_HEIGHT(Integer cQ_HEIGHT) {
		if(cQ_HEIGHT == null){
			CQ_HEIGHT = 0;
		}else{
			CQ_HEIGHT = cQ_HEIGHT;
		}
	}
}
