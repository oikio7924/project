package com.tx.dyAdmin.homepage.popup.dto;

import lombok.Data;

@Data
public class PopupDTO {

	private String PI_KEYNO
				 , PI_FS_KEYNO
				 , PI_TITLE
				 , PI_CONTENTS
				 , PI_TOP_LOC
				 , PI_LEFT_LOC
				 , PI_DEL
				 , PI_MN_TYPE
				 , PI_CHECK
				 , PI_STARTDAY
				 , PI_ENDDAY
				 , PI_WIDTH
				 , PI_HEIGHT
				 , PI_LINK
				 , PI_MN_NAME
				 , FS_ORINM
				 , PI_BACKGROUND_COLOR
				 , PI_TITLE_COLOR
				 , PI_COMMENT_COLOR
				 , PI_TYPE
				 , PI_TITLE2
				 , PI_DIVISION
				 , PI_COMMENT
				 , PI_RESIZE_CHECK;
	
	private String PI_HOMEKEY;
	
	//순번
	private Integer PI_LEVEL;
	
	//순번2
	private Integer PI_LEVEL_AFTER;
}
