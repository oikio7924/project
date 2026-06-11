package com.tx.dyAdmin.operation.qrcode.service.impl;

import java.awt.image.BufferedImage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.client.j2se.MatrixToImageConfig;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.tx.common.file.FileUploadTools;
import com.tx.common.file.dto.FileSub;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.operation.qrcode.dto.QrCode;
import com.tx.dyAdmin.operation.qrcode.service.QrCodeService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("QrCodeService")
public class QrCodeServiceImpl extends EgovAbstractServiceImpl implements QrCodeService{
	
	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 파일업로드 툴*/
	@Autowired private FileUploadTools FileUploadTools;
	
	@Override
	public QrCode getQrCode(String url, int width, int height, String file_name) {
        QrCode QrCode = null;
		try {
			 // 코드인식시 링크걸 URL주소
            String codeurl = new String(url.getBytes("UTF-8"), "ISO-8859-1");
            // 큐알코드 바코드 생상값
            int qrcodeColor =   0xFF2e4e96;
            // 큐알코드 배경색상값
            int backgroundColor = 0xFFFFFFFF;
             
            QRCodeWriter qrCodeWriter = new QRCodeWriter();
            // 3,4번째 parameter값 : width/height값 지정

            BitMatrix bitMatrix = qrCodeWriter.encode(codeurl, BarcodeFormat.QR_CODE,width, height);
            //
            MatrixToImageConfig matrixToImageConfig = new MatrixToImageConfig(qrcodeColor,backgroundColor);
            BufferedImage bufferedImage = MatrixToImageWriter.toBufferedImage(bitMatrix,matrixToImageConfig);

            FileSub sub = FileUploadTools.FileUploadByQrcode(bufferedImage, "ADMIN", file_name);
            QrCode = new QrCode();
            
            QrCode.setCQ_KEYNO(CommonService.getTableKey("CQ"));
            QrCode.setCQ_URL(codeurl);
            QrCode.setCQ_FS_KEYNO(sub.getFS_KEYNO());
            QrCode.setCQ_NAME(file_name);
            QrCode.setCQ_WIDTH(width);
            QrCode.setCQ_HEIGHT(height);
            
            Component.createData("QrCode.CQ_insert", QrCode);
            
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
		return QrCode;  
	}
	
	public FileSub getMenuQrCode(String url, int width, int height, String file_name) {
		FileSub FileSub = null;
		try {
			// 코드인식시 링크걸 URL주소
			String codeurl = new String(url.getBytes("UTF-8"), "ISO-8859-1");
			// 큐알코드 바코드 생상값
			int qrcodeColor =   0xFF2e4e96;
			// 큐알코드 배경색상값
			int backgroundColor = 0xFFFFFFFF;
			
			QRCodeWriter qrCodeWriter = new QRCodeWriter();
			// 3,4번째 parameter값 : width/height값 지정
			
			BitMatrix bitMatrix = qrCodeWriter.encode(codeurl, BarcodeFormat.QR_CODE,width, height);
			//
			MatrixToImageConfig matrixToImageConfig = new MatrixToImageConfig(qrcodeColor,backgroundColor);
			BufferedImage bufferedImage = MatrixToImageWriter.toBufferedImage(bitMatrix,matrixToImageConfig);
			
			FileSub = FileUploadTools.FileUploadByQrcode(bufferedImage, "ADMIN",file_name);
			
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
		return FileSub;  
	}

}
