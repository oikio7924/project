package com.tx.common.file;

import java.io.File;

/**
 * @FileUploadTools
 * 공통기능의 파일 업로드를 관리 하는 툴 클래스 
 * @author 신희원
 * @version 1.0
 * @since 2014-11-12
 */

/**
 * @author admin
 *
 */

public interface FileManageTools{
	
	/**
	 * 파일 생성 
	 * @param filePath 
	 * @param fileName 
	 * @throws Exception
	 */
	public boolean create_File(String filePath, String fileName, String data,boolean isCompression);
	
	/**
	 * 파일 복사
	 * @param oriFilePath 
	 * @param newFilePath 
	 * @param fileName 
	 * @throws Exception
	 */
	public boolean file_copy(String oriFilePath, String newFilePath, String fileName) throws Exception;
	
	
	/**
	 * 파일 읽기
	 * @param filePath 
	 * @param fileName 
	 * @throws Exception
	 */
	public String read_file(String filePath, String fileName) throws Exception;
	
	/**
	 * 파일 및 폴더 삭제
	 * @param filePath 
	 * @throws Exception
	 */
	public void delete_Folder(String filePath) throws Exception;
	
    
    /**
     * 디렉토리 하위 모든 파일 복사
     * @param fromDirectory
     * @param toDirectory
     * @throws Exception
     */
    public void directoryCopy(File from, File to);
    
    /**
     * 파일 유무 체크
     * @param String filepath
     * @throws Exception
     */
	public boolean fileExistsCheck(String filepath) throws Exception;
    
	  /**
     * 파일 디렉토리 생성
     * @param String filepath
     * @throws Exception
     */
	public void checkFolder(String filepath);
		
	/**
	 * 파일 디렉토리 삭제
	 * @param String filepath
	 * @throws Exception
	 */
	public void deleteFolder(String filepath);
	
}
