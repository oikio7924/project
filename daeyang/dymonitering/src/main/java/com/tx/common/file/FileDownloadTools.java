package com.tx.common.file;
import java.io.File;
import java.net.URL;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tx.common.file.dto.FileMain;
import com.tx.common.file.dto.FileSub;

/**
 * @FileDownloadTools
 * 공통기능의 다운로드를 관리 하는 툴 클래스 
 * @author 신희원 
 * @version 1.0
 * @since 2014-11-12
 */
public interface FileDownloadTools{
	
    /**
     * 첨부파일로 등록된 파일에 대하여 다운로드를 제공한다.
     * @param commandMap
     * @param response
     * @throws Exception
     */
    public void FileDownload(FileSub FileSub, HttpServletRequest request, HttpServletResponse response) throws Exception;
    
    /**
     * 파일 다운로드
     * @param file
     * @param name
     * @param request
     * @param response
     * @throws Exception
     */
    public void FileDownload(String filepath,String filename, HttpServletRequest request, HttpServletResponse response) throws Exception;

	public void FileDownload(FileMain fileMain, HttpServletRequest req, HttpServletResponse res) throws Exception;
	
	public void FileDownload(File file,String name, HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	public void FileDownload(URL url,String name, HttpServletRequest request, HttpServletResponse response) throws Exception;

	public void googlePath(FileSub FileSub, HttpServletRequest request, HttpServletResponse response) throws Exception;
    
}
