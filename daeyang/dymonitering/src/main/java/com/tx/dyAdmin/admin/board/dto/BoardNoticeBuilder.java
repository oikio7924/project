package com.tx.dyAdmin.admin.board.dto;

import com.tx.common.dto.Common;
import com.tx.common.dto.CommonBuilder;

public class BoardNoticeBuilder extends CommonBuilder {
	
	private String BN_MN_KEYNO;
	
	
	public BoardNoticeBuilder setMnKey(String BN_MN_KEYNO){
		this.BN_MN_KEYNO = BN_MN_KEYNO;
		return this;
	}
	
	@Override
	public BoardNoticeBuilder setSearchParams(Common search){
		setSearchData(search);
		return this;
	}
	
	@Override
	public BoardNotice build(){
		
		BoardNotice notice = new BoardNotice();
		notice.setBN_MN_KEYNO(BN_MN_KEYNO);
		if(isSetSearchPrams){
			putSearchData(notice);
		}
		return notice;
	}
	
	public static BoardNoticeBuilder Builder(){
	    return new BoardNoticeBuilder();
	}
}
