package com.tx.user.service;

import java.text.ParseException;
import java.util.HashMap;
import java.util.List;

import com.tx.dyAdmin.program.application.dto.ApplicationDTO;

public interface ClientProgramService {
	
	/** 클라이언트용 프로그램 리스트
	 * @param map
	 * @return
	 */
	List<HashMap<String, Object>> getPrograms(ApplicationDTO dto) throws ParseException;

}