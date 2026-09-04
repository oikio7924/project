
package com.tx.common.service.skin.service;


/**
 * 게시판 스킨 서비스
 * @date 2020. 7. 1.
 * @author 이재령
 */
public interface CommonSkinService {

	
	public String getSkin(String type, String value) throws Exception;
	
	public String getBoardSkin(String type, String value) throws Exception;
	
}
