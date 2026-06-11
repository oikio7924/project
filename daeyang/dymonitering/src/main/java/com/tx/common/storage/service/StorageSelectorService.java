package com.tx.common.storage.service;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.net.MalformedURLException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.MultipartFile;

import com.tx.common.file.dto.FileMain;
import com.tx.common.file.dto.FileSub;


public interface StorageSelectorService {

	
	
	/**
	 * editer에 있는 이미지 경로 가져오기(encode)
	 * @param req
	 * @param BoardNotice
	 * @param fileSub
	 * @return
	 * @throws Exception
	 */
	public String getImageEncodeByEditor(String imgTag) throws Exception;
	
	/**
	 * editer에 있는 이미지 경로 가져오기(decode)
	 * @param req
	 * @param BoardNotice
	 * @param fileSub
	 * @return
	 * @throws Exception
	 */
	public String getImageDecodeByEditor(String imgTag, String fullImgTag) throws Exception;
	
	/**
	 * 게시판 에디터 파일 가져오기(복사)
	 * @param req
	 * @param BoardNotice
	 * @param fileSub
	 * @return
	 * @throws Exception
	 */
	public String getImgFilePathByEditor(String imgTag, String fullImgTag, boolean rootPathCk) throws Exception;
	
	/**
	 * 게시판 첨부파일 가져오기
	 * @param req
	 * @param BoardNotice
	 * @param fileSub
	 * @return
	 * @throws Exception
	 */
	public String getThumbFileByAttachments(FileSub fileSub) throws Exception;
	
	/**
	 * 게시판 본문에 있는 이미지 파일 이동
	 * @param req
	 * @param BoardNotice
	 * @param fileSub
	 * @return
	 * @throws Exception
	 */
	public String folderMoveByContent(String filePath, String folderName, String fileName) throws Exception;
	
	/**
	 * 게시판 썸네일 저장하는 부분 && 폴더 이동하는 부분
	 * @param req
	 * @param BoardNotice
	 * @param fileSub
	 * @return
	 * @throws Exception
	 */
	public void createThumbFileByBoard(String filePath, FileSub fileSub) throws Exception;
	
	/**
	 * 게시판 썸네일 저장하고 파일 삭제하기(로컬에 복사한 파일 삭제하기)
	 */
	public void deleteThumbFileByBoard(String thumbFilePath) throws Exception;
	
	/**
	 * 실제 파일 저장하는 부분
	 * @param file
	 * @param filePath
	 * @param fileSub 
	 * @param fsVO 
	 * @throws Exception 
	 */
	public void createFile(MultipartFile file, String filePath, FileSub fsVO, FileSub fileSub) throws Exception;
	
	public void createBufferedFile(BufferedImage bufferedImage, String filePath, FileSub fileSub) throws Exception;
	
	public void createFileCopy(FileSub fileSub, String fS_CHANGENM) throws Exception;
	
	public void download(FileSub FileSub, HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	public void download(FileMain fileMain, HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	public void updateFileDelete(FileSub fileSub) throws Exception;
	
	public void zipFileDelete(FileMain fileMain) throws Exception;
	

	/**
	 * 파일들 압축
	 * @param fsVO 
	 * @param zip_name 
	 * @param folder 
	 * @param propertiespath 
	 * @param zipName 
	 * @throws IOException 
	 * @throws MalformedURLException 
	 */
	public String zip(List<FileSub> fsVO, String propertiespath, String folder, String zipName) throws MalformedURLException, IOException;
	
	public String getMimeType(HashMap<String,Object> fileSub) throws MalformedURLException, IOException;
	
	/**
	 * 게시물 썸네일 이미지 경로 - 암호화
	 * @param boardNoticeDataList
	 */
	public void getImgPath(List<HashMap<String, Object>> boardNoticeDataList);
	
	public void getImgPath(List<HashMap<String, Object>> boardList, String requestName, String responseName);
	
	/**
	 * 게시물 이미지 첨부파일 이미지 경로 - 암호화
	 * @param boardNoticeDataList
	 */
	public void getImgPathByfileSub(List<FileSub> fileSubList);
	
	/**
	 * 게시물 썸네일 이미지 경로 - 암호화
	 * @param map
	 */
	public void getImgPath(HashMap<String, Object> map);
	
	/**
	 * 게시물 썸네일 이미지 경로 - 암호화
	 * @param map
	 */
	public void getImgPath(HashMap<String, Object> map, String columName);
	
	/**
	 * 게시물 썸네일 이미지 경로 - 암호화 X
	 * @param fileSubList
	 */
	public void getImgPath2(List<FileSub> fileSubList);
	
	public String getImgPathString(String filePath);
	
	public String favicon(MultipartFile file, String tiles, String faviconPath) throws MalformedURLException, IOException;
	

	/**
	 * @param filePath
	 * @param fileSub
	 * @throws Exception
	 */
	public void createXmlFile(String filePath,FileSub fileSub) throws Exception;


}
