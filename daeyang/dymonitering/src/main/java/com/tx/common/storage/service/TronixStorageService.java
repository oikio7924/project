package com.tx.common.storage.service;

import java.io.IOException;
import java.net.MalformedURLException;
import java.util.HashMap;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.tx.common.file.dto.FileSub;

public interface TronixStorageService {
	
	public String create(String filePath, String type) throws MalformedURLException, IOException;
	
	public String create(String filePath, String type, String folderName) throws MalformedURLException, IOException;

	public String create(String filePath, String type, boolean isResize,boolean isVideoThumbnail, int width, int height) throws MalformedURLException, IOException;
	
	public String create(String filePath, String type, boolean isResize,boolean isVideoThumbnail, int width, int height, String publicPath) throws MalformedURLException, IOException;
	
	public String create(MultipartFile file, String type, boolean isResize,boolean isVideoThumbnail, int width, int height) throws MalformedURLException, IOException;
	
	public void delete(String deletePublicPath) throws MalformedURLException, IOException;
	
	public void getImgPath(List<HashMap<String, Object>> boardNoticeDataList, String requestName, String responseName);
	
	public void getImgPath(HashMap<String, Object> map, String columName);
	
	public void getImgPath2(List<FileSub> fileSubList);
	
	public String getImgPathString(String filePath);
	
	public void createFile(String filePath, FileSub fsVO, FileSub FileSub) throws MalformedURLException, IOException, Exception;
	
	public void createBufferedFile(String filePath, FileSub FileSub) throws MalformedURLException, IOException, Exception;
	
	public void createCopyFile(FileSub fileSub) throws MalformedURLException, IOException, Exception;
	
	public String zip(List<FileSub> fsVO, String publicFolder) throws MalformedURLException, IOException;
	
	public String favicon(MultipartFile file, String tiles);
	
	public String getMimeType(String rootFilePath, HashMap<String,Object> fileSub) throws Exception;
	
	public String getFilePathByFileCopy(String rootFilePath, String filePath, boolean rootPathCk) throws Exception;
	
	public String filePathByPublicPath(String filePath);
	
	public void getImgPathByFileSub(List<FileSub> fileSubList);
}
