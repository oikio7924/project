package com.tx.common.dto;

public class CommonBuilder {

	protected String searchKeyword;
	protected String searchCondition;
	protected String orderCondition;
	protected String orderBy;
	protected String sortDirect;
	protected String searchBeginDate;
	protected String searchEndDate;
	
	protected int pageUnit;
	protected int pageIndex;
	
	protected boolean isSetSearchPrams = false;
	
	public CommonBuilder setSearchParams(Common search){
		setSearchData(search);
		return this;
	}
	
	protected void setSearchData(Common search){
		isSetSearchPrams = true;
		this.searchKeyword   = search.getSearchKeyword().trim();
		this.searchCondition = search.getSearchCondition();
		this.orderCondition  = search.getOrderCondition();
		this.orderBy         = search.getOrderBy();
		this.sortDirect      = search.getSortDirect();
		this.searchBeginDate = search.getSearchBeginDate();
		this.searchEndDate   = search.getSearchEndDate();
		this.pageIndex       = search.getPageIndex();
	}
	
	/*protected <U extends Common> void putSearchData(U  obj){
		Common dto = (U)obj;
		setVal(dto);
	}*/
	
	protected void putSearchData(Common common){
		common.setSearchKeyword(searchKeyword);
		common.setSearchCondition(searchCondition);
		common.setOrderCondition(orderCondition);
		common.setOrderBy(orderBy);
		common.setSortDirect(sortDirect);
		common.setSearchBeginDate(searchBeginDate);
		common.setSearchEndDate(searchEndDate);
		common.setPageIndex(pageIndex);
	}
	
	public Common build(){
		Common common = new Common();
		putSearchData(common);
		return common;
	}
	
}
