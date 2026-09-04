package com.tx.common.storage.service;

import java.awt.Image;
import java.util.HashMap;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.tx.common.file.dto.FileMain;
import com.tx.common.file.dto.FileSub;

public interface LocalFileService {

	public void create(String filePath, FileSub fsVO, FileSub FileSub) throws Exception;
	
	public void createBufferedFile(String filePath, FileSub FileSub) throws Exception;
	
	public void getImgPath(List<HashMap<String, Object>> boardNoticeDataList, String requestName, String responseName);
	
	public void getImgPathByFileSub(List<FileSub> FileSub);
	
	public void getImgPath2(List<FileSub> fileSubList);
	
	public String getImgPathString(String filePath);
	
	public void getImgPath(HashMap<String, Object> map, String columName);
	
	public String fileCopy(FileSub fileSub, String fS_CHANGENM) throws Exception;
	
	public void thumbnail(FileSub fileSub, String filePath, int width, int height) throws Exception;
	
	public String zip(List<FileSub> fsVO, String propertiespath, String folder, String zipName);
	
	public String favicon(MultipartFile file, String tiles);
	
	public void delete(FileSub fileSub, FileMain fileMain) throws Exception;
	
	public Image ImgResize(String Filepath, String newFilepath, String EXT, int width, int height)throws Exception;
	
}
