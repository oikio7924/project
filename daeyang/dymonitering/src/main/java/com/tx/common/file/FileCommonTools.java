package com.tx.common.file;

import com.tx.common.file.dto.FileSub;
import com.tx.dyAdmin.admin.board.dto.BoardPersonal;

public interface FileCommonTools {

	public String getFileSubStringPathByContent(String path);
	
	public String getImageDecodeByEditor(String imgTag, String fullImgTag) throws Exception;
	
	public void createfolder(String path) throws Exception;
	
	public String editorImgCheck(String contents, String keyno, String menuKeyno, String folderNm) throws Exception;
	
	public String editorImgCheck(String contents, String folderNm) throws Exception;
	
	public BoardPersonal filePersonalCheck(String BT_PERSONAL, FileSub FileSub, String filePath) throws Exception;
}
