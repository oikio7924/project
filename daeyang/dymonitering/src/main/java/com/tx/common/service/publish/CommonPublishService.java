package com.tx.common.service.publish;

import com.tx.dyAdmin.admin.board.dto.BoardMainMini;
import com.tx.dyAdmin.admin.board.dto.BoardSkin;
import com.tx.dyAdmin.homepage.menu.dto.MenuHeaderTemplate;
import com.tx.dyAdmin.homepage.popup.dto.PopupSkinDTO;
import com.tx.dyAdmin.homepage.popupzone.dto.PopupZoneCategoryDTO;
import com.tx.dyAdmin.homepage.research.dto.ResearchSkinDTO;

public interface CommonPublishService {

	
	public boolean all() throws Exception;
	
	public boolean resource(String path, String homeDiv , String key) throws Exception;
	
	public boolean resource(String path, String homeDiv , String key, String resourceType) throws Exception;
	
	public boolean layout(String path, String homeDiv , String scope, boolean distributeType) throws Exception;
	
	public boolean page(String path, String homeDiv , String key) throws Exception;
	
	public boolean pagePreview(String path, String contents) throws Exception;
	
	public boolean miniBoard(BoardMainMini BoardMainMini) throws Exception;
	
	public boolean popupZone(PopupZoneCategoryDTO CategoryDTO) throws Exception;
		
	public boolean menuTemplate(MenuHeaderTemplate MenuHeaderTemplate) throws Exception;
	
	public boolean survey(boolean distributeType, String SS_KEYNO) throws Exception;
	
	public boolean researchSkin(ResearchSkinDTO ResearchSkinDTO) throws Exception;

	public boolean popupSkin(PopupSkinDTO popupSkinDTO) throws Exception;

	public String getFileName(String type , String key, boolean isAddExt);

	public String getFilePathWithName(String type, String key, boolean isAddExt);
	
	public String getFilePathWithName(String type, String key, boolean isAddExt, String boardType);
	
	public boolean index(String key, String resourceType, String scope, boolean distributeType) throws Exception;	
	
	public boolean sitemap(String filename, String data) throws Exception;

	public boolean BoardTemplate(BoardSkin boardSkin) throws Exception;
	
	public boolean BoardTemplatePackage(BoardSkin boardskin) throws Exception;

	



}
