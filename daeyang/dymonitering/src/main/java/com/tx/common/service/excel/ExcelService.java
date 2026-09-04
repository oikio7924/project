package com.tx.common.service.excel;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.MultipartFile;

public interface ExcelService {
	
	public void createExcelWorkBook(HttpServletResponse response) throws Exception;
	
	public void ExcelInsert(MultipartFile file, String organHomeKey)throws Exception;
	
	public ArrayList<ArrayList<String>> readFilter_And_Insert(MultipartFile file) throws IOException;
	
	public void createExcelData(HttpServletResponse response, List<HashMap<String,Object>> result) throws IOException;
	
	
}
