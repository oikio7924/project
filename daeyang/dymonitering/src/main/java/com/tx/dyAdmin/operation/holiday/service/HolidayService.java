package com.tx.dyAdmin.operation.holiday.service;

import java.util.ArrayList;

import com.tx.dyAdmin.operation.holiday.dto.HolidayDTO;

/**
 * 휴일 관리 서비스
 * @author admin
 *
 */
public interface HolidayService {
	
	public ArrayList<HolidayDTO> getHolidays(String STDT, String ENDT) throws Exception;
	
	public ArrayList<HolidayDTO> getHolidaysType(String STDT, String ENDT, String holidayType) throws Exception;
}
