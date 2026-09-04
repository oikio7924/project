package com.tx.common.dto;

import javax.servlet.http.HttpServletRequest;
import javax.validation.constraints.Pattern;

import org.apache.commons.lang3.StringUtils;

import com.tx.common.config.tld.SiteProperties;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Data
@ToString @Getter @Setter
public class TilesDTO {
	@Pattern(regexp = "^[a-z0-9]{0,10}$")
	private String tiles = null;
	
	public String getTiles(HttpServletRequest req) {
		
		
		return checkNull(tiles,req);
	}

	public String checkNull(String _tiles,
			HttpServletRequest req) {
		// TODO Auto-generated method stub
		
		if(StringUtils.isEmpty(_tiles)) {
			/**
			 * 비회원이 권한에 걸릴시 로그인페이지로 넘기는데
			 * 관련 로직 CustomFilterSecurityInterceptor class invoke method 에서 
			 * session에 currentTiles 넣어줌
			 */
			_tiles = (String) req.getSession().getAttribute("currentTiles");
		}
		if(StringUtils.isEmpty(_tiles)) {
			/**
			 * session에 currentTiles 값이 없을경우 대표 tiles 값을 가져옴
			 */
			_tiles = SiteProperties.getString("tiles");
		}
		
		return _tiles;
		
	}
	
}