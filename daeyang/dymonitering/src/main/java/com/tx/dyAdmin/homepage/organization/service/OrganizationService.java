package com.tx.dyAdmin.homepage.organization.service;

import java.util.HashMap;
import java.util.List;

/**글 조직도용 데이터포멧에 맞게 작성
 * @author gwp
 *
 */
public interface OrganizationService {
	
	public String doStartTagInternal(String DN_HOMEDIV_C) throws Exception;	
	
	/**
	 * 리스트 가져오기
	 * @param pageDivList 
	 * @param _depth 
	 * @param req
	 * @param tour
	 * @param REGNM
	 * @throws Exception
	 */
	public List<HashMap<String, Object>> getOrganList(String MN_HOMEDIV_C) throws Exception;
}
