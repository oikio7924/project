package com.tx.dyAdmin.statistics.dto;

import com.tx.common.dto.Common;

import lombok.Data;
import lombok.EqualsAndHashCode;


@Data
@EqualsAndHashCode(callSuper=false)
public class StatisticsDTO extends Common {
	
	private static final long serialVersionUID = 621937432376974413L;

	//T_STATISTICS_BOARDCNT
	private String   STM_KEYNO
					,STM_IP
					,STM_REGDT
					,STM_TYPE
					,STM_MAINKEY
					,STM_CONNECT_KEY;

	//페이지 리스트에 게시되는 페이지 건수
	private int STM_PAGESIZE = 10;
	private String STM_CASE = null;
	private String STM_ORDER = "A";
	
	//검색
	private String YEAR_DIV
				 , MONTH_DIV
				 , DATE_DIV
				 , MENU_DIV
				 , MENU_MAIN_DIV
				 , BOARD_DIV
				 , MENU_NM
				 , MENU_MAIN_NM
				 , BOARD_NM
				 , HOMEKEY;
	
	
	
}
