package com.tx.common.storage.service;

import java.io.File;

import org.apache.commons.lang3.StringUtils;
import org.apache.tika.Tika;

public class IsImageFile {

	
	public static boolean isImageFile(File file) {
		return isGetFile(file, "image");
	}
	
	public static boolean isImageFile(String filePath) {

		return isGetFilePath(filePath, "image");
	}
	
	public static boolean isVideoFile(File file) {
		return isGetFile(file, "video");
	}

	public static boolean isVideoFile(String filePath) {
		return isGetFilePath(filePath, "video");
	}
	
	public static boolean isGetFile(File file, String type) {
		try {
			
			String mimeType = getFileMimeType(file.getPath());			
			if(StringUtils.isNotEmpty(mimeType)) {
				return mimeType.indexOf(type) > -1;
			}
		} catch (Exception e) {
			System.out.println("isGetFile 에러");
		}		
		return false;
	}
	
	public static boolean isGetFilePath(String filePath, String type) {
		try {
			String mimeType = getFileMimeType(filePath);			
			if(StringUtils.isNotEmpty(mimeType)) {
				return mimeType.indexOf(type) > -1;
			}
		} catch (Exception e) {
			System.out.println("isGetFilePath 에러");
		}		
		return false;
	}
	
	public static String getFileMimeType(String filePath) throws Exception {
		Tika tika = new Tika();
		String mimetype = "";
		try {
			mimetype = tika.detect(filePath);
		} catch (Exception e) {
			mimetype = null;
		}
    
		return mimetype;
	}
}
