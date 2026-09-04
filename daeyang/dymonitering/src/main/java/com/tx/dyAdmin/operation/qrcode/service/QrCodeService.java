package com.tx.dyAdmin.operation.qrcode.service;

import com.tx.common.file.dto.FileSub;
import com.tx.dyAdmin.operation.qrcode.dto.QrCode;

public interface QrCodeService{
	
	
	public QrCode getQrCode(String url, int width, int height, String file_name);
	
	public FileSub getMenuQrCode(String url, int width, int height, String file_name);
}
