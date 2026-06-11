package com.tx.dyAdmin.admin.code.service;

import java.util.HashMap;
import java.util.List;

public interface CodeService {
	
	public void setCodeList();
	
	public List<HashMap<String, Object>> getCodeListisUse(String MC_IN_C, boolean isUse);
	
	public List<HashMap<String, Object>> getCodeListAll(String MC_IN_C);

	void setCodeOne(String MC_IN_C);
	
	public List<HashMap<String, Object>> getCodeListisUseBySelectlist(List<String> list);

	
}
