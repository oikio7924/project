package com.tx.dyAdmin.operation.holiday.service.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.icu.util.ChineseCalendar;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.operation.holiday.dto.HolidayDTO;
import com.tx.dyAdmin.operation.holiday.service.HolidayService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 
 * @FileName: HolidayService.java
 * @Date    : 2017. 03. 29. 
 * @Author  : 이재령	
 * @Version : 1.0
 */
@Service("HolidayService")
public class HolidayServiceImpl extends EgovAbstractServiceImpl implements HolidayService {

	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	
	@Override
	public ArrayList<HolidayDTO> getHolidays(String STDT, String ENDT) throws Exception{
		
		ArrayList<HolidayDTO> hList = new ArrayList<HolidayDTO>();
		
		String date[] = STDT.split("-");
		int sY = Integer.parseInt(date[0]);
//		int sM = Integer.parseInt(date[1]);
//		int sD = Integer.parseInt(date[2]);
		date = ENDT.split("-");
		int eY = Integer.parseInt(date[0]);
//		int eM = Integer.parseInt(date[1]);
//		int eD = Integer.parseInt(date[2]);
		
		
		List<Object> list = Component.getListNoParam("Holiday.THM_selectAll");
		
		HolidayDTO holiday = null;
		@SuppressWarnings("unused")
		int Y,M,D;
		
		for(Object object : list){
			holiday = (HolidayDTO)object;
			boolean lunar = false;
			if(holiday.getTHM_LUNAR().equals("Y")){
				lunar = true;
			}
			date = holiday.getTHM_DATE().split("-"); 
			Y = Integer.parseInt(date[0]);
			M = Integer.parseInt(date[1]);
			D = Integer.parseInt(date[2]);
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd") ;
			Date sDate = dateFormat.parse(STDT) ;
		    Date eDate = dateFormat.parse(ENDT) ;
		    Date nDate = dateFormat.parse(holiday.getTHM_DATE()) ;
		    
			switch (holiday.getTHM_TYPE()) {
			case "Y": //매년
				for(int i = sY-1 ; i <=eY+1 ; i++){
					checkDate(hList,getHoliday(holiday.getTHM_NAME(),i+"-"+M+"-"+D,lunar,holiday.getTHM_NATIONAL()),STDT,ENDT);
				}
				break;
			case "M": //매월
				for(int i = sY-1 ; i <=eY+1 ; i++){
					int startM = i == sY-1 ? M : 1;
					int endM = i == eY+1 ? M : 12;
					for(int j = startM ; j <=endM ; j++){
						checkDate(hList,getHoliday(holiday.getTHM_NAME(),i+"-"+j+"-"+D,lunar,holiday.getTHM_NATIONAL()),STDT,ENDT);
					}
				}
				break;
			case "D": //매주
			    
				Calendar cal = Calendar.getInstance() ;
			    cal.setTime(nDate);
			    int dayNum = cal.get(Calendar.DAY_OF_WEEK);
			    
			    cal.setTime(sDate);
			    int sDayNum = cal.get(Calendar.DAY_OF_WEEK);
			    
			    if(dayNum - sDayNum > 0){
			    	cal.add(Calendar.DATE, dayNum - sDayNum);
			    }else if(dayNum - sDayNum < 0){
			    	cal.add(Calendar.DATE, dayNum - sDayNum + 7);
			    }
			    while(true){
			    	if(cal.getTime().compareTo(eDate) > 0){
			    		break;
			    	}
			    	checkDate(hList,getHoliday(holiday.getTHM_NAME(),cal.getTime(),lunar,holiday.getTHM_NATIONAL()),STDT,ENDT);
			    	cal.add(Calendar.DATE, 7);
			    }
				break;
			case "N": //반복없음
		    	checkDate(hList,getHoliday(holiday,lunar),STDT,ENDT);
				break;
			default:
				break;
			}
		}
		hList = settingSubstituteholiday(hList,STDT,ENDT); //대체공휴일 추가
		
		return hList;
	}
	
	@Override
	public ArrayList<HolidayDTO> getHolidaysType(String STDT, String ENDT, String holidayType) throws Exception{
		
		ArrayList<HolidayDTO> hList = new ArrayList<HolidayDTO>();
		
		String date[] = STDT.split("-");
		int sY = Integer.parseInt(date[0]);
//		int sM = Integer.parseInt(date[1]);
//		int sD = Integer.parseInt(date[2]);
		date = ENDT.split("-");
		int eY = Integer.parseInt(date[0]);
//		int eM = Integer.parseInt(date[1]);
//		int eD = Integer.parseInt(date[2]);
		
		
		HolidayDTO holiday = new HolidayDTO();
		holiday.setHolidayType(holidayType);

		List<Object> list = Component.getList("Holiday.THM_selectAll", holiday);
		
		@SuppressWarnings("unused")
		int Y,M,D;
		
		for(Object object : list){
			holiday = (HolidayDTO)object;
			boolean lunar = false;
			if(holiday.getTHM_LUNAR().equals("Y")){
				lunar = true;
			}
			date = holiday.getTHM_DATE().split("-"); 
			Y = Integer.parseInt(date[0]);
			M = Integer.parseInt(date[1]);
			D = Integer.parseInt(date[2]);
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd") ;
			Date sDate = dateFormat.parse(STDT) ;
			Date eDate = dateFormat.parse(ENDT) ;
			Date nDate = dateFormat.parse(holiday.getTHM_DATE()) ;
			
			switch (holiday.getTHM_TYPE()) {
			case "Y": //매년
				for(int i = sY-1 ; i <=eY+1 ; i++){
					checkDate(hList,getHoliday(holiday.getTHM_NAME(),i+"-"+M+"-"+D,lunar,holiday.getTHM_NATIONAL()),STDT,ENDT);
				}
				break;
			case "M": //매월
				for(int i = sY-1 ; i <=eY+1 ; i++){
					int startM = i == sY-1 ? M : 1;
					int endM = i == eY+1 ? M : 12;
					for(int j = startM ; j <=endM ; j++){
						checkDate(hList,getHoliday(holiday.getTHM_NAME(),i+"-"+j+"-"+D,lunar,holiday.getTHM_NATIONAL()),STDT,ENDT);
					}
				}
				break;
			case "D": //매주
				
				Calendar cal = Calendar.getInstance() ;
				cal.setTime(nDate);
				int dayNum = cal.get(Calendar.DAY_OF_WEEK);
				
				cal.setTime(sDate);
				int sDayNum = cal.get(Calendar.DAY_OF_WEEK);
				
				if(dayNum - sDayNum > 0){
					cal.add(Calendar.DATE, dayNum - sDayNum);
				}else if(dayNum - sDayNum < 0){
					cal.add(Calendar.DATE, dayNum - sDayNum + 7);
				}
				while(true){
					if(cal.getTime().compareTo(eDate) > 0){
						break;
					}
					checkDate(hList,getHoliday(holiday.getTHM_NAME(),cal.getTime(),lunar,holiday.getTHM_NATIONAL()),STDT,ENDT);
					cal.add(Calendar.DATE, 7);
				}
				break;
			case "N": //반복없음
				checkDate(hList,getHoliday(holiday,lunar),STDT,ENDT);
				break;
			default:
				break;
			}
		}
		hList = settingSubstituteholiday(hList,STDT,ENDT); //대체공휴일 추가
		
		return hList;
	}
	
	/**
	 * 대체공휴일 셋팅
	 * · 설날, 추석 연휴가 다른 공휴일과 겹치는 경우 그 날 다음의 첫 번째 비공휴일을 공휴일로 함
	 * · 어린이날이 토요일 또는 다른 공휴일과 겹치는 경우 그 날 다음의 첫 번째 비공휴일을 공휴일로 함 
	 * (어린이날 외의 토요일은 대체공휴일에 포함되지 않습니다)
	 * @param hList
	 * @return
	 * @throws ParseException 
	 */
	@SuppressWarnings("unlikely-arg-type")
	private ArrayList<HolidayDTO> settingSubstituteholiday(ArrayList<HolidayDTO> hList,String STDT,String ENDT) throws ParseException {
		
		Map<String,String> map = new HashMap<String,String>();
		
		ArrayList<HolidayDTO> SubstituteholidayList = new ArrayList<HolidayDTO>(); 
		
		for(HolidayDTO h : hList){
			String name = h.getTHM_NAME();
			if(name.equals("어린이날") || name.contains("추석") || name.contains("설날")){ //어린이날,추석,설날만 따로 리스트에 넣어둠
				SubstituteholidayList.add(h);
			}else if(h.getTHM_NATIONAL().equals("Y")){ //나머지 공휴일(일반휴일 제외)
				map.put(h.getTHM_DATE(), "H");
			}
		}
		
		if(SubstituteholidayList.size() == 0){ //어린이날,추석,설날이 없으면 그냥 빠져나옴
			return hList;
		}
		
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd") ;
		Date sDate = dateFormat.parse(STDT) ;
	    Date eDate = dateFormat.parse(ENDT) ;
		
	    Calendar cal = Calendar.getInstance() ;
	    cal.setTime(sDate);
	    while(cal.getTime().compareTo(eDate) <= 0){ //시작날짜와 종료날짜 사이의 토요일과 일요일을 map에 넣음
	    	int dayNum = cal.get(Calendar.DAY_OF_WEEK);
	    	if(dayNum == 7 && map.get(dateFormat.format(cal.getTime())) == null){ //토요일 이고 해당 날짜가 공휴일이 아니라면
	    		map.put(dateFormat.format(cal.getTime()), "S");
	    		cal.add(Calendar.DATE, 1);
	    	}else if(dayNum == 1){ //일요일
	    		map.put(dateFormat.format(cal.getTime()), "H");
	    		cal.add(Calendar.DATE, 6);
	    	}else{ 
	    		cal.add(Calendar.DATE, 1);
	    	}
	    }
		
	    HolidayDTO temp = null;
	    for(HolidayDTO h : SubstituteholidayList){
	    	String name = h.getTHM_NAME();
	    	if(name.equals("어린이날")){
	    		if(map.get(h.getTHM_DATE()) != null){ //어린이날이 토요일이나 공휴일 이라면
	    			cal.setTime(dateFormat.parse(h.getTHM_DATE()));
	    			while(true){ //하루씩 추가하면서 토요일이나 공휴일이 아닌날을 찾아서 대체공휴일로 지정함
	    				cal.add(Calendar.DATE, 1);
	    				if(map.get(dateFormat.format(cal.getTime())) == null){
	    					temp = new HolidayDTO();
	    					temp.setTHM_NAME("대체공휴일");
	    					temp.setTHM_DATE(dateFormat.format(cal.getTime()));
	    					temp.setTHM_NATIONAL("Y");
	    					hList.add(temp);
	    					break;
	    				}
	    			}
	    			
	    		}
	    	}else{ // 설날이나 추석
	    		if(map.get(h.getTHM_DATE()) != null && map.get(h.getTHM_DATE()).equals("H")){ //설날이나 추석은 공휴일인지만 체크 (토요일은 제외)
	    			cal.setTime(dateFormat.parse(h.getTHM_DATE()));
	    			if(name.contains("전날")){ //연휴 다음날부터 시작하니 날짜 +2
	    				cal.add(Calendar.DATE, 2);
	    			}else if(!name.contains("다음날")){ //당일
	    				cal.add(Calendar.DATE, 1);
	    			}
	    			
	    			while(true){
	    				cal.add(Calendar.DATE, 1);
	    				if(map.get(dateFormat.format(cal.getTime())) == null || map.get(cal.getTime()).equals("S")){
	    					temp = new HolidayDTO();
	    					temp.setTHM_NAME("대체공휴일");
	    					temp.setTHM_DATE(dateFormat.format(cal.getTime()));
	    					temp.setTHM_NATIONAL("Y");
	    					hList.add(temp);
	    					break;
	    				}
	    			}
	    		}
	    	}
	    }
	    
		
		return hList;
	}


	/**
	 * 주어진 날짜 사이에 있으면 list에 추가
	 * @param hList
	 * @param holiday
	 * @param STDT
	 * @param ENDT
	 * @throws ParseException
	 */
	private void checkDate(ArrayList<HolidayDTO> hList, HolidayDTO holiday, String STDT, String ENDT) throws ParseException {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd") ;
		Date sDate = dateFormat.parse(STDT) ;
	    Date eDate = dateFormat.parse(ENDT) ;
	    Date nDate = dateFormat.parse(holiday.getTHM_DATE()) ;
	    if(sDate.compareTo(nDate) <= 0 && eDate.compareTo(nDate) >= 0 ){
	    	hList.add(holiday);
	    }
	    
		
	}



	private HolidayDTO getHoliday(String NAME, Date DATE,boolean LUNAR,String NATIONAL) throws ParseException {
		return getHoliday(NAME,getDateByString(DATE),LUNAR,NATIONAL);
	}

	private HolidayDTO getHoliday(HolidayDTO holiday,boolean LUNAR) throws ParseException {
		
		return getHoliday(holiday.getTHM_NAME(),holiday.getTHM_DATE(),LUNAR,holiday.getTHM_NATIONAL());
	}
	
	private HolidayDTO getHoliday(String NAME, String DATE,boolean LUNAR,String NATIONAL) throws ParseException {
		HolidayDTO temp = new HolidayDTO();
		temp.setTHM_NAME(NAME);
		if(LUNAR){
			DATE = convertLunarToSolar(DATE);
		}
		temp.setTHM_DATE(getDateByString(DATE));
		temp.setTHM_NATIONAL(NATIONAL);
		return temp;
	}
	
	private String getDateByString(Object date) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(date);
    }
	
	private String getDateByString(String date) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date temp = null;
        try {
			temp = sdf.parse(date);
		} catch (ParseException e) {
			System.out.println("날짜  에러");;
		}
        return sdf.format(temp);
    } 
     
    /**
     * 음력날짜를 양력날짜로 변환
     * @param 음력날짜 (yyyy-MM-dd)
     * @return 양력날짜 (yyyy-MM-dd)
     */
    private String convertLunarToSolar(String date) {
        ChineseCalendar cc = new ChineseCalendar();
        Calendar cal = Calendar.getInstance();
        int y = Integer.parseInt(date.split("-")[0]);
		int m = Integer.parseInt(date.split("-")[1]);
		int d = Integer.parseInt(date.split("-")[2]); 
        cc.set(ChineseCalendar.EXTENDED_YEAR,y + 2637);
        cc.set(ChineseCalendar.MONTH, m - 1);
        cc.set(ChineseCalendar.DAY_OF_MONTH, d);
         
        cal.setTimeInMillis(cc.getTimeInMillis());
        return getDateByString(cal.getTime());    
    }
     
    /**
     * 양력날짜를 음력날짜로 변환
     * @param 양력날짜 (yyyy-MM-dd)
     * @return 음력날짜 (yyyy-MM-dd)
     */
    @SuppressWarnings("unused")
	private String converSolarToLunar(String date) {
        ChineseCalendar cc = new ChineseCalendar();
        Calendar cal = Calendar.getInstance();
        int y = Integer.parseInt(date.split("-")[0]);
		int m = Integer.parseInt(date.split("-")[1]);
		int d = Integer.parseInt(date.split("-")[2]);  
        cal.set(Calendar.YEAR, y);
        cal.set(Calendar.MONTH, m - 1);
        cal.set(Calendar.DAY_OF_MONTH, d);
         
        cc.setTimeInMillis(cal.getTimeInMillis());
         
        y = cc.get(ChineseCalendar.EXTENDED_YEAR) - 2637;
        m = cc.get(ChineseCalendar.MONTH) + 1;
        d = cc.get(ChineseCalendar.DAY_OF_MONTH);
         
        StringBuffer ret = new StringBuffer();
        ret.append(String.format("%04d", y)).append("-");
        ret.append(String.format("%02d", m)).append("-");
        ret.append(String.format("%02d", d));
         
        return ret.toString();
    }
    


	
}
