package com.tx.common.file;

import java.io.FileNotFoundException;
import java.io.IOException;

public interface FileReadTools {
	
	/**
 	 * 파일 읽기
 	 * @param path 파일경로
 	 * @throws Exception
 	 */
	public String fileRead(String path) throws Exception;
	
	
	public String excelRead(String path) throws Exception;
	
	
	public String excelReadXls(String path) throws Exception;
	
	public String readDoc(String path) throws Exception;
	
	public String readDocx(String path) throws Exception;
	
	public String readPdf(String path) throws FileNotFoundException, IOException;
	
	public String readHwp(String path) throws Exception;
}
