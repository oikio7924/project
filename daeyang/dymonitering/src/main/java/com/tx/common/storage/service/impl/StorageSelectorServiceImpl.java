package com.tx.common.storage.service.impl;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.List;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.tika.Tika;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.tx.common.config.SettingData;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.file.FileDownloadTools;
import com.tx.common.file.dto.FileMain;
import com.tx.common.file.dto.FileSub;
import com.tx.common.security.aes.AES256Cipher;
import com.tx.common.storage.service.IsImageFile;
import com.tx.common.storage.service.LocalFileService;
import com.tx.common.storage.service.StorageSelectorService;
import com.tx.common.storage.service.TronixStorageService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


@Service("StorageSelector")
public class StorageSelectorServiceImpl extends EgovAbstractServiceImpl implements StorageSelectorService  {

	
	@Value("#{config['cms.storage']}")
	private String STORAGE;
	
	@Autowired
	private FileDownloadTools FileDownloadTools;
	
	@Autowired
	private TronixStorageService TronixStorageService;
	
	@Autowired
	private LocalFileService LocalFileService;
	
	/**
	 * editer에 있는 이미지 경로 가져오기(encode)
	 * @param req
	 * @param BoardNotice
	 * @param fileSub
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getImageEncodeByEditor(String imgTag) throws Exception {
		
		if("tronix".equals(STORAGE)){
			imgTag = AES256Cipher.encode(imgTag,SiteProperties.getConfigProperties("cms.storage.secretKey"));
			imgTag = SiteProperties.getConfigProperties("cms.storage.url") + "/get.do?file=" + imgTag;
		}else if("none".equals(STORAGE)){
			imgTag = AES256Cipher.encode(imgTag);
			imgTag = "/common/file.do?file=" + imgTag;
		}
		
		return imgTag;
	}
	
	/**
	 * editer에 있는 이미지 경로 가져오기(decode)
	 * @param req
	 * @param BoardNotice
	 * @param fileSub
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getImageDecodeByEditor(String imgTag, String fullImgTag) throws Exception {
		
		if("tronix".equals(STORAGE)){
        	imgTag = AES256Cipher.decode(imgTag,SiteProperties.getConfigProperties("cms.storage.secretKey"));
		}else if("none".equals(STORAGE)){
        	imgTag = AES256Cipher.decode(imgTag);
		}
		
		return imgTag;
	}
	
	/**
	 * 게시판 에디터 파일 가져오기(복사)
	 * @param req
	 * @param BoardNotice
	 * @param fileSub
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getImgFilePathByEditor(String imgTag, String fullImgTag, boolean rootPathCk) throws Exception {

		String rootFilePath = SiteProperties.getString("FILE_PATH");
		
		if("tronix".equals(STORAGE)){
			if(fullImgTag.indexOf("get.do") != -1) {	//트로닉스 스토리지에 올라간 이미지 파일인 경우
				imgTag = SiteProperties.getConfigProperties("cms.storage.url") + "/resources/" + imgTag;
				imgTag = TronixStorageService.getFilePathByFileCopy(rootFilePath, imgTag, rootPathCk);
			}else if(rootPathCk){	//로컬에 올라간 이미지 파일인 경우
				imgTag =  rootFilePath + imgTag;
			}
		}else if("none".equals(STORAGE)){
			if(fullImgTag.indexOf("http") == -1) {	
				imgTag = rootFilePath + imgTag;
			}
		}
		
		return imgTag;
	}
	
	/**
	 * 게시판 첨부파일 가져오기
	 * @param req
	 * @param BoardNotice
	 * @param fileSub
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getThumbFileByAttachments(FileSub fileSub) throws Exception {
		String filePath = null; 
		String rootFilePath = SiteProperties.getString("FILE_PATH");
		
//		if(StringUtils.isBlank(fileSub.getFS_PUBLIC_PATH())){
//			String imgTag = fileSub.getFS_FOLDER() + fileSub.getFS_CHANGENM() + "." + fileSub.getFS_EXT();
//	        filePath = rootFilePath + imgTag;
//	        return rootFilePath + imgTag;
//		}
		
		if("tronix".equals(STORAGE)){
			filePath = TronixStorageService.getFilePathByFileCopy(rootFilePath, fileSub.getFS_PUBLIC_PATH(),true);
			
		}else if("none".equals(STORAGE)){
			String imgTag = fileSub.getFS_FOLDER() + fileSub.getFS_CHANGENM() + "." + fileSub.getFS_EXT();
	        filePath = rootFilePath + imgTag;
		}
		
		return filePath;
	}
	
	/**
	 * 게시판 본문에 있는 이미지 파일 이동
	 * @param req
	 * @param BoardNotice
	 * @param fileSub
	 * @return
	 * @throws Exception
	 */
	@Override
	public String folderMoveByContent(String filePath, String folderName, String fileName) throws Exception {
	
		String newFilePath = folderName + fileName;
		
		if("tronix".equals(STORAGE)){
			//에디터 이미지 처음 업로드 할 경우에만 로컬에 있는 경로에서 트로닉스 스토리지에 이미지 업로드 
			filePath = TronixStorageService.create(SiteProperties.getString("FILE_PATH") + filePath, "temp", folderName);
			filePath = filePath.substring(filePath.lastIndexOf(SiteProperties.getConfigProperties("cms.title")));
			
		}else if("none".equals(STORAGE)){
			
			File orfile = new File(filePath);
			File cofile = new File(SiteProperties.getString("FILE_PATH") + newFilePath);
			
			if(!cofile.exists()) {
				try( FileInputStream fis = new FileInputStream(orfile); //읽을파일
				     FileOutputStream fos = new FileOutputStream(cofile); //복사할파일
					) {
					int fileByte = 0; 
		            // fis.read()가 -1 이면 파일을 다 읽은것
		           while((fileByte = fis.read()) != -1) {
		               fos.write(fileByte);
		           }
				}
			}
			
			filePath = newFilePath;
		}
		
		return filePath;
	}
	
	/**
	 * 게시판 썸네일 저장하는 부분 && 폴더 이동하는 부분
	 * @param req
	 * @param BoardNotice
	 * @param fileSub
	 * @return
	 * @throws Exception
	 */
	@Override
	public void createThumbFileByBoard(String filePath, FileSub fileSub) throws Exception {
		String publicPath = null;
		if("tronix".equals(STORAGE)){
			publicPath = TronixStorageService.create(filePath,"temp",fileSub.getFS_FOLDER());
			new File(filePath).delete();
			
		}else if("none".equals(STORAGE)){

		}
		
		fileSub.setFS_PUBLIC_PATH(publicPath);
		fileSub.setFS_STORAGE(STORAGE);
	}
	
	/**
	 * 게시판 썸네일 저장하고 파일 삭제하기(로컬에 복사한 파일 삭제하기)
	 */
	@Override
	public void deleteThumbFileByBoard(String thumbFilePath) throws Exception {
		if("tronix".equals(STORAGE)){
			new File(thumbFilePath).delete();
		}
	}
	
	/**
	 * 실제 파일 저장하는 부분
	 * @param file
	 * @param filePath
	 * @param fileSub 
	 * @param fsVO 
	 * @throws Exception 
	 */
	@Override
	public void createFile(MultipartFile file, String filePath, FileSub fsVO, FileSub fileSub) throws Exception {
		
		File newFile = new File(filePath);
		file.transferTo(newFile);
		
		LocalFileService.create(filePath,fsVO,fileSub);
		
		/*if("tt".equals(STORAGE)){
			if(fsVO.getIS_MAKE_BOARDTHUMB()){
				fileSub.setFS_PUBLIC_PATH(TronixStorageService.create(filePath,"temp",fileSub.getFS_FOLDER()));
			}else{
				TronixStorageService.createFile(filePath,fsVO,fileSub);
			}
			newFile.delete();	//로컬에 저장된 파일 삭제
			
		}else if("none".equals(STORAGE)){
			LocalFileService.create(filePath,fsVO,fileSub);
		}*/
		
		fileSub.setFS_STORAGE(STORAGE);
		
	}
	
	@Override
	public void createBufferedFile(BufferedImage bufferedImage, String filePath, FileSub fileSub) throws Exception {
		String FS_SIZE = "";
		//썸네일 이름
		File newFile = new File(filePath);
		ImageIO.write(bufferedImage, fileSub.getFS_EXT(), newFile);
	    
		/** 사이즈 취득 */
	    FS_SIZE = newFile.length()+"";
	    if("tronix".equals(STORAGE)){
			TronixStorageService.createBufferedFile(filePath, fileSub);
			newFile.delete();	//로컬에 저장된 파일 삭제
			
		}else if("none".equals(STORAGE)){
			
			LocalFileService.createBufferedFile(filePath,fileSub);
			if(fileSub.getIS_MAKE_THUMBNAIL()){
				LocalFileService.thumbnail(fileSub,filePath,SettingData.DEFAULT_IMG_RESIZE_WIDTH, SettingData.DEFAULT_IMG_RESIZE_HEIGHT);
			}
		}
		
	   fileSub.setFS_FILE_SIZE(FS_SIZE);
	   fileSub.setFS_STORAGE(STORAGE);
	   
	}
	
	@Override
	public void createFileCopy(FileSub fileSub, String fS_CHANGENM) throws Exception {
		
		if("tronix".equals(STORAGE)){
			TronixStorageService.createCopyFile(fileSub);
			
		}else if("none".equals(STORAGE)){
			String filePath = null;
			filePath = LocalFileService.fileCopy(fileSub, fS_CHANGENM);
			if(fileSub.getIS_MAKE_THUMBNAIL()){
				LocalFileService.thumbnail(fileSub,filePath,SettingData.DEFAULT_IMG_RESIZE_WIDTH, SettingData.DEFAULT_IMG_RESIZE_HEIGHT);
			}
		}
		
		fileSub.setFS_STORAGE(STORAGE);
		
	}
	
	@Override
	public void download(FileSub FileSub, HttpServletRequest request, HttpServletResponse response) throws Exception{
		if("tronix".equals(STORAGE)){
			URL url = new URL(FileSub.getFS_PUBLIC_PATH());
			
			FileDownloadTools.FileDownload(url,FileSub.getFS_ORINM(),request,response);
			
		}else if("none".equals(STORAGE)){
			
			/** 경로 설정 */
			String uploadPath = SiteProperties.getString("FILE_PATH")+ FileSub.getFS_FOLDER(); 
		    File uFile = new File(uploadPath, FilenameUtils.getName(FileSub.getFS_CHANGENM() + "." + FileSub.getFS_EXT()));
		    FileDownloadTools.FileDownload(uFile,FileSub.getFS_ORINM(),request,response);
		}
	}
	
	@Override
	public void download(FileMain fileMain, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String uploadPath = SiteProperties.getString("FILE_PATH");
    	String path = uploadPath + fileMain.getFM_ZIP_PATH();
	    String name = fileMain.getZIP_NAME()+"_첨부파일.zip";
    	if(fileMain.getZIP_NAME() == null) {
    		name = fileMain.getFM_ZIP_PATH().toString().substring(fileMain.getFM_ZIP_PATH().toString().lastIndexOf("/")+1);
    	}
		if("none".equals(STORAGE)){
		   
	    	/** 경로 설정 */
		    File uFile = new File(path);

		    FileDownloadTools.FileDownload(uFile,name,request,response);
		}
	}
	
	@Override
	public void updateFileDelete(FileSub fileSub) throws Exception {
		
		if("tronix".equals(STORAGE)){
			
			TronixStorageService.delete(fileSub.getFS_PUBLIC_PATH());
			
			if( StringUtils.isNotEmpty(fileSub.getFS_THUMBNAIL()) ){
				TronixStorageService.delete(fileSub.getFS_THUMBNAIL());
			}
			
		}else if("none".equals(STORAGE)){
			
			LocalFileService.delete(fileSub, null);
		}
	}
	
	@Override
	public void zipFileDelete(FileMain fileMain) throws Exception {
		
		if("tronix".equals(STORAGE)){
			TronixStorageService.delete(fileMain.getFM_ZIP_PATH());
		}else if("none".equals(STORAGE)){
			LocalFileService.delete(null,fileMain);
		}
	}
	

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
	@Override
	public String zip(List<FileSub> fsVO, String propertiespath, String folder, String zipName) throws MalformedURLException, IOException {		
		String zipPath = "";
		
		if("none".equals(STORAGE)){
			zipPath = LocalFileService.zip(fsVO,propertiespath,folder,zipName);
		}
		return zipPath;
	}
	
	@Override
	public String getMimeType(HashMap<String,Object> fileSub) throws MalformedURLException, IOException {
		
		String mimeType = "";
		String rootFilePath = SiteProperties.getString("FILE_PATH");
		
		if("none".equals(STORAGE)){
			String fileWebPath = fileSub.get("FS_FOLDER") + FilenameUtils.getName( fileSub.get("FS_CHANGENM") + "." + fileSub.get("FS_EXT") );
			String filePath = rootFilePath + fileWebPath;
			
			try {
				mimeType = IsImageFile.getFileMimeType(filePath);
			} catch (Exception e) {
				System.out.println("mimeType 에러");
			}
		}
		return mimeType;
	}
	
	/**
	 * 게시물 첨부파일 경로 - 암호화
	 * @param fileSubList
	 */
	@Override
	public void getImgPath(List<HashMap<String, Object>> boardNoticeDataList) {		
		if("none".equals(STORAGE)){
			getImgPath(boardNoticeDataList, "THUMBNAIL_PATH", "THUMBNAIL_PATH");
		}
	}
	
	@Override
	public void getImgPath(List<HashMap<String, Object>> boardList, String requestName, String responseName) {		
		if("none".equals(STORAGE)){
			
			LocalFileService.getImgPath(boardList, requestName, responseName);
		}
	}
	
	@Override
	public void getImgPathByfileSub(List<FileSub> fileSubList) {		
		if("tronix".equals(STORAGE)){
			
			TronixStorageService.getImgPathByFileSub(fileSubList);
			
		}else if("none".equals(STORAGE)){
			
			LocalFileService.getImgPathByFileSub(fileSubList);
		}
	}
	
	/**
	 * 게시물 썸네일 이미지 경로 - 암호화
	 * @param map
	 */
	@Override
	public void getImgPath(HashMap<String, Object> map) {
		getImgPath(map,"THUMBNAIL");
	}
	
	/**
	 * 게시물 썸네일 이미지 경로 - 암호화
	 * @param map
	 */
	@Override
	public void getImgPath(HashMap<String, Object> map, String columName) {
		if("tronix".equals(STORAGE)){
			
			TronixStorageService.getImgPath(map,columName);
			
		}else if("none".equals(STORAGE)){
			
			LocalFileService.getImgPath(map,columName);
		}
	}
	
	/**
	 * 게시물 썸네일 이미지 경로 - 암호화 X
	 * @param fileSubList
	 */
	@Override
	public void getImgPath2(List<FileSub> fileSubList) {
		if("tronix".equals(STORAGE)){
			
			TronixStorageService.getImgPath2(fileSubList);
			
		}else if("none".equals(STORAGE)){
			
			LocalFileService.getImgPath2(fileSubList);
		}
	}
	
	@Override
	public String getImgPathString(String filePath) {
		if("tronix".equals(STORAGE)){
			filePath = TronixStorageService.getImgPathString(filePath);
		}else if("none".equals(STORAGE)){
			
			filePath = LocalFileService.getImgPathString(filePath);
		}
		
		return filePath;
	}
	
	@Override
	public String favicon(MultipartFile file, String tiles, String faviconPath) throws MalformedURLException, IOException {	
		if("tronix".equals(STORAGE)){
			if(StringUtils.isNoneEmpty(faviconPath)){
				TronixStorageService.delete(faviconPath);
			}
			return TronixStorageService.create(file,"create",false,false,0,0);
			
		}else if("none".equals(STORAGE)){
			
			return LocalFileService.favicon(file,tiles);
		}
		
		return "";
		
	}
	
	
	public static boolean isImageFile(File file) {
		return isGetFile(file, "image");
	}
	
	public static boolean isImageFile(String filePath) {

		return isGetFilePath(filePath, "image");
	}
	
	public static boolean isVideoFile(File file) {
		return isGetFile(file, "video");
	}

	public static boolean isVideoFile(String filePath) {
		return isGetFilePath(filePath, "video");
	}
	
	public static boolean isGetFile(File file, String type) {
		try {
			
			String mimeType = getFileMimeType(file.getPath());			
			if(StringUtils.isNotEmpty(mimeType)) {
				return mimeType.indexOf(type) > -1;
			}
		} catch (Exception e) {
			System.out.println("isGetFile 에러");
		}		
		return false;
	}
	
	public static boolean isGetFilePath(String filePath, String type) {
		try {
			String mimeType = getFileMimeType(filePath);			
			if(StringUtils.isNotEmpty(mimeType)) {
				return mimeType.indexOf(type) > -1;
			}
		} catch (Exception e) {
			System.out.println("isGetFilePath 에러");
		}		
		return false;
	}
	
	public static String getFileMimeType(String filePath) throws Exception {
		Tika tika = new Tika();
		String mimetype = "";
		try {
			mimetype = tika.detect(filePath);
		} catch (Exception e) {
			mimetype = null;
		}
    
		return mimetype;
	}
	

	/**
	 * @param filePath
	 * @param fileSub
	 * @throws Exception
	 */
	@Override
	public void createXmlFile(String filePath,FileSub fileSub) throws Exception {
		if("tronix".equals(STORAGE)){
			fileSub.setFS_PUBLIC_PATH(TronixStorageService.create(filePath,"create"));
			new File(filePath).delete();	//로컬에 저장된 파일 삭제
		}
		fileSub.setFS_STORAGE(STORAGE);
		
	}


}
