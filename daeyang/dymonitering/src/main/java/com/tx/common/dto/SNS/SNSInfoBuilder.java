package com.tx.common.dto.SNS;

import com.tx.common.config.tld.SiteProperties;

public class SNSInfoBuilder {
	
	private String TITLE,DESC,IMG,URL;
	
	private boolean isRequiredSummary = false;
	
	
	public SNSInfoBuilder setTitle(String title){
		this.TITLE = title;
		return this;
	}
	
	/**
	 * html 코드에서 텍스트를 추출해야될경우
	 * 파라미터 _isRequiredSummary를 true로 설정
	 * @param desc
	 * @param _isRequiredSummary
	 * @return
	 */
	public SNSInfoBuilder setDesc(String desc,boolean _isRequiredSummary){
		this.DESC = desc;
		this.isRequiredSummary = _isRequiredSummary;
		return this;
	}
	
	public SNSInfoBuilder setImg(String img){
		this.IMG = img;
		return this;
	}
	public SNSInfoBuilder setUrl(String url){
		this.URL = url;
		return this;
	}
	
	public SNSInfo build(){
		
		if(DESC == null) DESC = SiteProperties.getString("SNS_DESCRIPTION");
		if(IMG == null) IMG = SiteProperties.getString("SNS_IMAGE");
		SNSInfo SNSInfo = new SNSInfo();
		
		SNSInfo.setTITLE(TITLE);
		if(isRequiredSummary){
			SNSInfo.setContents(DESC);
		}else{
			SNSInfo.setDESC(DESC);
		}
		SNSInfo.setIMG(IMG);
		SNSInfo.setURL(URL);
		
		return SNSInfo;
	}
	
	public static SNSInfoBuilder Builder(){
	    return new SNSInfoBuilder();
	}
}
