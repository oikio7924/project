package com.tx.common.file.impl;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.tika.Tika;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;

import com.tx.common.config.tld.SiteProperties;
import com.tx.common.file.FileDownloadTools;
import com.tx.common.file.dto.FileMain;
import com.tx.common.file.dto.FileSub;
import com.tx.common.storage.service.StorageSelectorService;
import com.tx.common.service.component.ComponentService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @FileDownloadTools
 * @Service : FileDownloadTools
 * 공통기능의 다운로드를 관리 하는 툴 클래스 
 * @author 신희원 
 * @version 1.0
 * @since 2014-11-12
 */
@Service("FileDownloadTools")
public class FileDownloadToolsImpl extends EgovAbstractServiceImpl implements FileDownloadTools{
	
	private static final Logger logger = LoggerFactory.getLogger(FileDownloadToolsImpl.class);
    
    /** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	
	@Autowired StorageSelectorService StorageSelector;
    
    /**
     * 브라우저 구분 얻기.
     * 
     * @param request
     * @return
     */
    private String getBrowser(HttpServletRequest request) {
        String header = request.getHeader("User-Agent");
        if (header.indexOf("MSIE") > -1 || header.indexOf("Trident") > -1) {
            return "MSIE";
        } else if (header.indexOf("Chrome") > -1) {
            return "Chrome";
        } else if (header.indexOf("Opera") > -1) {
            return "Opera";
        }
        return "Firefox";
    }  

    /**
     * Disposition 지정하기.
     * @param filename
     * @param request
     * @param response
     * @throws Exception
     */
    private void setDisposition(String filename, HttpServletRequest request, HttpServletResponse response) throws Exception {

    	String browser = getBrowser(request);
		String dispositionPrefix = "attachment; filename=";
		String encodedFilename = null;
	
	if (browser.equals("MSIE")) {
	    encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
	} else if (browser.equals("Firefox")) {
	    encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
	} else if (browser.equals("Opera")) {
	    encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
	} else if (browser.equals("Chrome")) {
	    StringBuffer sb = new StringBuffer();
	    for (int i = 0; i < filename.length(); i++) {
		char c = filename.charAt(i);
		if (c > '~') {
		    sb.append(URLEncoder.encode("" + c, "UTF-8"));
		} else {
		    sb.append(c);
		}
	    }
	    //크롬 , 있을 시 다운로드 안되는 문제 작업 ""으로 파일명 감싸기
	    encodedFilename = "\"" + sb.toString() + "\"";
	} else {
	    //throw new RuntimeException("Not supported browser");
	    throw new IOException("Not supported browser");
	}
	dispositionPrefix=dispositionPrefix.replaceAll("\r", "").replaceAll("\n", "");
	encodedFilename=encodedFilename.replaceAll("\r", "").replaceAll("\n", "");
	response.setHeader("Content-Disposition", dispositionPrefix + encodedFilename);

		if ("Opera".equals(browser)){
		    response.setContentType("application/octet-stream;charset=UTF-8");
		}
    }

    
    /**
     * 첨부파일로 등록된 파일에 대하여 다운로드를 제공한다.
     * @param commandMap
     * @param response
     * @throws Exception
     */
    @Override
    public void FileDownload(FileSub FileSub, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	Component.updateData("File.AFS_FileDownCouting", FileSub);
    	
    	StorageSelector.download(FileSub, request, response);
    	
    }
    
    
    /**
     * 첨부파일로 등록된 파일에 대하여 다운로드를 제공한다.
     * @param commandMap
     * @param response
     * @throws Exception
     */
    @Override
    public void FileDownload(FileMain FileMain, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	
    	StorageSelector.download(FileMain, request, response);
    	
    }
    
    /**
     * 파일 다운로드
     * @param file
     * @param name
     * @param request
     * @param response
     * @throws Exception
     */
    @Override
    public void FileDownload(String filepath, String filename, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	/** 경로 설정 */
		String uploadPath = SiteProperties.getString("RESOURCE_PATH")+ filepath; 
	    File uFile = new File(uploadPath);
	    FileDownload(uFile,filename,request,response);
    }
    
    @Override
    public void FileDownload(File file,String name, HttpServletRequest request, HttpServletResponse response) throws Exception{
    	long fSize = (long)file.length();
	    if (fSize > 0) {
		 	String mimetype = "application/x-msdownload";
			setDisposition(name, request, response);
			response.setContentLengthLong(fSize);
			

			try (	BufferedInputStream in = new BufferedInputStream(new FileInputStream(file));
					BufferedOutputStream out = new BufferedOutputStream(response.getOutputStream());){
			    // MAC Safari브라우져에서 확장자exe 추가되는 문제로 Tika로 mime-type 선언
			    Tika tika = new Tika();
			    mimetype = tika.detect(in);
			    response.setContentType(mimetype);
			    FileCopyUtils.copy(in, out);
			    out.flush();
			} catch (IOException ex) {
				logger.debug("IO 에러");
			}  
	    }
    }
    
    @Override
    public void FileDownload(URL url,String name, HttpServletRequest request, HttpServletResponse response) throws Exception{
		
    	URLConnection uCon = url.openConnection();

		try (	
				InputStream is = uCon.getInputStream();
				BufferedInputStream in = new BufferedInputStream(is);
				BufferedOutputStream out = new BufferedOutputStream(response.getOutputStream());){
		    // MAC Safari브라우져에서 확장자exe 추가되는 문제로 Tika로 mime-type 선언
			
			String mimetype = "application/x-msdownload";
			setDisposition(name, request, response);
			//response.setContentLength(fSize);
		    Tika tika = new Tika();
		    mimetype = tika.detect(in);
		    response.setContentType(mimetype);
		    FileCopyUtils.copy(in, out);
		    out.flush();
		} catch (IOException ex) {
			logger.debug("IO 에러");
			System.out.println(ex.getMessage());
		}  
    }
    
    
    
    /**
     * 구글뷰어 미리보기 파일 호출
     * @param commandMap
     * @param response
     * @throws Exception
     */
    @Override
    public void googlePath(FileSub FileSub, HttpServletRequest request, HttpServletResponse response) throws Exception {    	
    	StorageSelector.download(FileSub, request, response);
    	
    }
    
    
}
