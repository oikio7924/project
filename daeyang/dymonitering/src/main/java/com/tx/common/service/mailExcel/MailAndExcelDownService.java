package com.tx.common.service.mailExcel;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletResponse;

public interface MailAndExcelDownService {

	
	public ArrayList<HashMap<String, Object>> main(HttpServletResponse res,String hostmap, String user, String passw) throws Exception;
	
	public void ExcelDown( ArrayList<ArrayList<String>> dataSheet, HttpServletResponse res) throws Exception;
}
