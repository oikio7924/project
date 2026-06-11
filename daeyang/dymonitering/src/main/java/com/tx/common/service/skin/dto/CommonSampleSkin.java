package com.tx.common.service.skin.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CommonSampleSkin {

	
	
	private String type,value,path;
	
	
	public boolean compare(String _type, String _value){
		return _type.equals(type) && _value.equals(value);
	}
	
}
