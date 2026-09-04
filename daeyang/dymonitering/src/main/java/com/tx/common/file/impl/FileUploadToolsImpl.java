package com.tx.common.file.impl;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.nio.channels.FileChannel;
import java.security.SecureRandom;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.xml.bind.DatatypeConverter;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.tx.common.config.SettingData;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.file.FileCommonTools;
import com.tx.common.file.FileManageTools;
import com.tx.common.file.FileUploadTools;
import com.tx.common.file.dto.FileMain;
import com.tx.common.file.dto.FileSub;
import com.tx.common.file.thumnail.ThumnailService;
import com.tx.common.security.aes.AES256Cipher;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.storage.service.StorageSelectorService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @FileUploadTools
 * @Service : FileUploadTools
 * 공통기능의 파일 업로드를 관리 하는 툴 클래스 
 * @author 신희원
 * @version 1.0
 * @since 2014-11-12
 */

@Service("FileUploadTools")
public class FileUploadToolsImpl extends EgovAbstractServiceImpl implements FileUploadTools{
	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	@Autowired FileManageTools FileManageTools;
	
	@Autowired StorageSelectorService StorageSelector;
	
	@Autowired ThumnailService thumnail;
	
	@Autowired FileCommonTools FileCommonTools;
	
	//하나의 폴더당 내부 파일의 개수
	final private int FOLDER_FILE_CNT = 100;
	
	/**
	 * 네이버 스마트에디터2 용 파일 업로드
	 * @param request
	 * @param filename
	 * @return
	 * @throws Exception
	 */
	@Override
	public String FileUploadWithSMARTEDITOR(HttpServletRequest request, String filename) throws Exception {
		
	        MultipartHttpServletRequest multipart = (MultipartHttpServletRequest) request;
	        MultipartFile file1 = multipart.getFile("EditorImg");
			
		    String sFileInfo = "";
		   
		    //프로퍼티 경로 불러오기
		    String propertiespath = SiteProperties.getString("FILE_PATH");
		   
		    FileSub FileSub = new FileSub();
			
			String FS_EXT =  filename.substring(filename.lastIndexOf(".")+1);
			String FS_SIZE = request.getHeader("file-size");
			
			String FS_ORINM = filename;
			String FS_CHANGENM = setfilename();

			String menuName = request.getHeader("menuName");     
			menuName = URLDecoder.decode(menuName, "utf-8");

            //오늘 날짜 
            Date dt = new Date();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd"); 
            String date = sdf.format(dt).toString();
            
			//파일 정보 저장(db에 저장X)
			FileSub.setFS_EXT(FS_EXT);
			FileSub.setFS_ORINM(FS_ORINM);
			FileSub.setFS_FILE_SIZE(FS_SIZE);
			FileSub.setFS_CHANGENM(FS_CHANGENM);
			//게시판 / 메뉴키 / temp 로 경로 설정
            FileSub.setFS_FOLDER("board/temp/"+ date +"/" );
			
			/** 경로 설정 */			
			//파일 기본경로 _ 상세경로     		    
			FileCommonTools.createfolder(propertiespath + FileSub.getFS_FOLDER());
		   
		    String rlFileNm = propertiespath + FileSub.getFS_FOLDER() + FileSub.getFS_CHANGENM()+"."+FileSub.getFS_EXT();     
		   
		    ///////////////// 서버에 파일쓰기 /////////////////      
		    InputStream is = request.getInputStream();
		    if(is.available() == 0) {
		    	is = file1.getInputStream();
		    }
		    
		    try(OutputStream os=new FileOutputStream(rlFileNm);){
		    int numRead;     
		    byte b[] = new byte[Integer.parseInt(FileSub.getFS_FILE_SIZE())];
		    
		    
 		    while((numRead = is.read(b,0,b.length)) != -1){      
		 	   os.write(b,0,numRead);     
		    }
 		    
		    if(is != null) {      
		 	   is.close();     
		    }     
		   } catch (Exception e) {
		    System.out.println("파일업로드에러");
		   }
		    
		   new File(rlFileNm);
		   
		   String fileUrl = createSmartEditorFile(FileSub, rlFileNm);
		   
		   fileUrl = createSmartEditorFile(FileSub, rlFileNm);
           
           // 정보 출력 &sFileName :: img 태그의 title 속성을 원본파일명으로 적용시켜주기 위함     
           sFileInfo += "&bNewLine▶true&sFileName▶"+ filename+"&sFileURL▶" + fileUrl;     
		   
		return sFileInfo;
	}
	
	public String createSmartEditorFile(FileSub fileSub, String filePath) throws Exception {
		
		String fileUrl = null;
		
		fileUrl = fileSub.getFS_FOLDER() + fileSub.getFS_CHANGENM()+"."+fileSub.getFS_EXT();
	
		if(StringUtils.isNotEmpty(fileUrl)){
			try {
				fileUrl = "/common/file.do?file=" + AES256Cipher.encode(fileUrl);
			} catch (Exception e) {
				System.out.println("#LocalFileService getImgPath error");
			}
		}
		
		return fileUrl;
	}
	
	/**
 	 * QR-CODE 업로드
 	 * @param REGNM 등록자
 	 * @throws Exception
 	 */
	@Override
	public FileSub FileUploadByQrcode(BufferedImage bufferedImage, String REGNM, String FILENAME) {
		
		FileMain FileMain = new FileMain();
		FileMain.setFM_REGNM(REGNM);
		
		//메인코드 등록 처리
		Component.createData("File.AFM_FileInfoInsert",FileMain);
		//프로퍼티 경로 불러오기
		String propertiespath = SiteProperties.getString("FILE_PATH");
		
		FileSub FileSub = new FileSub();
		FileSub.setFS_FM_KEYNO(FileMain.getFM_KEYNO());
		
		String ext = "png";
		
		//확장자
		String FS_EXT = "";
		//변경 파일명
		String FS_CHANGENM = "";
		
		FileSub.setFS_FOLDER(SaveFolder(propertiespath));
		
		/** 경로 설정 */
		String uploadPath = propertiespath + FileSub.getFS_FOLDER();
		
		/** 확장자 취득 */
		FS_EXT = ext;
		/** 파일명 변환 후 저장*/
		FS_CHANGENM = setfilename();
		String filePath = uploadPath + FilenameUtils.getName(FS_CHANGENM + "." + FS_EXT);
		try {
		    
			FileSub.setFS_EXT(FS_EXT);
			FileSub.IS_RESIZE();
		    StorageSelector.createBufferedFile(bufferedImage, filePath, FileSub);
		    
		} catch (Exception e) {
		
		}

		//파일 정보 저장
		FileSub.setFS_ORINM(FILENAME + "." + FS_EXT);
		FileSub.setFS_CHANGENM(FS_CHANGENM);
		FileSub.setFS_REGNM(REGNM);
		FileSub.setFS_CONVERT_CHK("Y");
		Component.createData("File.AFS_FileInfoInsert", FileSub);	
		
		return FileSub;
	}
	
	/**
	 * favicon.ico 업로드
	 * @param thumbnail
	 * @param hm_TILES
	 * @param faviconPath :: 기존 파일 삭제를 위한 경로
	 * @return
	 */
	@Override
	public String FaviconUpload(MultipartFile file, String tiles, String faviconPath) throws Exception {
		
		return StorageSelector.favicon(file,tiles,faviconPath);
		
	}
	
	/**
	 * 메뉴 xml 파일 업로드
	 * @param beforeFile
	 * @param REGNM
	 * @param FM_KEYNO 
	 * @param width
	 * @param height
	 * @return
	 * @throws Exception
	 */
	@Override
	public FileSub FileUploadByXML(String filename, String filepath, String REGNM) throws Exception {
		
		String FM_KEYNO = makeFileMainData(REGNM);
		//프로퍼티 경로 불러오기
		String propertiespath = SiteProperties.getString("FILE_PATH");
		
		FileSub FileSub = new FileSub();
		
		File beforeFile = new File(filepath);
		
		//확장자
		String FS_EXT =  filename.substring(filename.lastIndexOf(".")+1);
		//원본파일명
		String FS_ORINM = filename;
		//파일사이즈
		String FS_SIZE  = beforeFile.length() +"";
		
		//변경 파일명
		String FS_CHANGENM = setfilename();
		
		FileSub.setFS_FM_KEYNO(FM_KEYNO);
		FileSub.setFS_FOLDER(SaveFolder(propertiespath));
		
		/** 경로 설정 */
		//파일 기본경로     
		//파일 기본경로 _ 상세경로     
		FileCommonTools.createfolder(propertiespath + FileSub.getFS_FOLDER());

		String rlFileNm = propertiespath + FileSub.getFS_FOLDER() + FS_CHANGENM+"."+FS_EXT;
		
		try(FileInputStream inputStream = new FileInputStream(filepath);        
			FileOutputStream outputStream = new FileOutputStream(rlFileNm);
			FileChannel fcin  =  inputStream.getChannel();
			FileChannel fcout = outputStream.getChannel()	
				){

			long size = fcin.size();
			fcin.transferTo(0, size, fcout);
			
		}catch(Exception e){
			FileSub.setFS_KEYNO("");
			return FileSub;
		}
		
		//파일 정보 저장
		FileSub.setFS_FILE_SIZE(FS_SIZE);
		FileSub.setFS_EXT(FS_EXT);
		FileSub.setFS_ORINM(FS_ORINM);
		FileSub.setFS_CHANGENM(FS_CHANGENM);
		FileSub.setFS_REGNM(REGNM);
		FileSub.setFS_ALT(FS_ORINM);
		FileSub.setFS_CONVERT_CHK("Y");
		StorageSelector.createXmlFile(rlFileNm,FileSub);
		Component.createData("File.AFS_FileInfoInsert", FileSub);
		return FileSub;
		
		
	}
	
	
	/**
 	 * 하나의 파일을 업로드 한다.
 	 * + 리사이즈 여부(기본리사이즈)
	 * @param file
	 * @param fileSub
	 * @param REGNM
	 * @param isResize
	 * @return
	 */
	@Override
	public FileSub FileUpload(MultipartFile file, FileSub fileSub, String REGNM, boolean isResize, HttpServletRequest request) {
	
		if(isResize){
			return FileUpload(file, fileSub, REGNM, SettingData.DEFAULT_IMG_RESIZE_WIDTH, SettingData.DEFAULT_IMG_RESIZE_HEIGHT, request);
		}else{
			return FileUpload(file, REGNM, new FileSub(fileSub.getFS_FM_KEYNO(), fileSub.getFS_KEYNO()),request);
		}
		
	}

	/**
	 * 하나의 파일을 업로드 한다.
	 * + 입력값에 의한 리사이즈
	 * @param file
	 * @param fileSub
	 * @param REGNM
	 * @param width
	 * @param height
	 * @return
	 */
	@Override
	public FileSub FileUpload(MultipartFile file, FileSub fileSub, String REGNM, int width, int height, HttpServletRequest req) {
		return FileUpload(file, REGNM, new FileSub(fileSub.getFS_FM_KEYNO(), fileSub.getFS_KEYNO()).IS_RESIZE().RESIZE_WIDTH(width).RESIZE_HEIGHT(height), req);
	}

	/**
	 * 하나의 파일을 업로드 한다.
	 * + 리사이즈(IS_RESIZE)
	 * @param file
	 * @param REGNM 등록자
	 * @param fsVO 수정 분기를 위한 FS_KEYNO, 그 외 등록/수정에 이미지 리사이징, 썸네일 생성 등의 정보 전달용 DTO
	 * 관리자 : 파일관리용
	 * fsVO에 fsKey키 있는 경우 파일 수정 처리
	 * fsVO에 IS_RESIZE :: true일 경우 리사이즈 처리
	 * fsVO에 IS_MAKE_THUMBNAIL :: true일 경우 썸네일 생성 처리
	 * fsVO에 IS_MAKE_MOVIE_THUMBNAIL :: true일 경우 동영상 썸네일 생성 처리
	 */
	@Override
	public FileSub FileUpload(MultipartFile file, String REGNM, FileSub fsVO, HttpServletRequest req) {
		
		if( fsVO == null ) fsVO = new FileSub();
		
		//프로퍼티 경로 불러오기
		String propertiespath = SiteProperties.getString("FILE_PATH");
		FileSub FileSub = null;
		boolean isUpdate = false;
		
		/* 수정or신규 여부 확인 */
		if(StringUtils.isNotEmpty(fsVO.getFS_KEYNO()) ){	
			FileSub = Component.getData("File.AFS_SubFileDetailselect", fsVO);
			if( FileSub == null ){
				FileSub = new FileSub();
			}else{
				isUpdate = true;
			}
		}else{
			FileSub = new FileSub();
		}
		
		//fmkey 셋팅
		if(!"none".equals(fsVO.getFS_FM_KEYNO())){	//FM_KEYNO -> none으로 할 경우 FM_KEYNO등록 안함
			if(StringUtils.isNotEmpty(fsVO.getFS_FM_KEYNO())){
				
				FileSub.setFS_FM_KEYNO(fsVO.getFS_FM_KEYNO());
				
			}else if(StringUtils.isNotEmpty(fsVO.getFM_KEYNO())){
				
				FileSub.setFS_FM_KEYNO(fsVO.getFM_KEYNO());
				
			}else{
				FileSub.setFS_FM_KEYNO(String.valueOf(CommonService.getTableAutoKey("S_COMMON_FILE_MAIN","FM_SEQ")));
			}
		}

		//확장자
		String FS_EXT = "";
		//원본파일명
		String FS_ORINM = "";
		//파일사이즈
		String FS_SIZE = "";
		//변경 파일명
		String FS_CHANGENM = "";
		
		//경로 설정
		String uploadPath = "";
		String filePath = "";
		
		//파일 처리
		if( file != null && StringUtils.isNotEmpty(file.getOriginalFilename())){
			/** 원본파일명 취득 */
			FS_ORINM = file.getOriginalFilename();
			/** 확장자 취득 */
			FS_EXT = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf('.')+1, file.getOriginalFilename().length());
		
			if(StringUtils.isNotEmpty(FS_EXT)){
				FS_EXT = FS_EXT.toLowerCase();
			}
			
			FileSub.setFS_EXT(FS_EXT);

			FileSub.setFS_CONVERT_CHK("Y");			
			if("hwp".equals(FS_EXT)) FileSub.setFS_CONVERT_CHK("N");
			
			/** 사이즈 취득 */
			FS_SIZE = Long.toString(file.getSize());
			
			try {
				//수정 시 기존파일 삭제
				if( isUpdate ){
                    uploadPath = propertiespath + FileSub.getFS_FOLDER() + FileSub.getFS_CHANGENM() +"."+ FileSub.getFS_EXT();
                    FileManageTools.deleteFolder(uploadPath);                
				}
				//파일명 변경
				FS_CHANGENM = setfilename();
				
				String rqpath = thumnail.mainfolder(req);
				FileSub.setFS_FOLDER(rqpath);
				
				/** 파일명 변환 후 저장*/
				uploadPath = propertiespath + FileSub.getFS_FOLDER();
				
				/** 원본 업로드 */
				filePath = uploadPath + FilenameUtils.getName(FS_CHANGENM + "." + FS_EXT);
				if(fsVO.getIS_RESIZE()){
					FileSub.setRESIZE_WIDTH(fsVO.getRESIZE_WIDTH());
					FileSub.setRESIZE_HEIGHT(fsVO.getRESIZE_HEIGHT());
				}
				//이게 업로드
				StorageSelector.createFile(file,filePath,fsVO,FileSub);
				
			} catch (Exception e) {
				System.out.println("#51 파일 저장중 에러!!");
			}
			//파일 정보 저장
			FileSub.setFS_FILE_SIZE(FS_SIZE);
			FileSub.setFS_ORINM(FS_ORINM);
			FileSub.setFS_CHANGENM(FS_CHANGENM);
		}
		FileSub.setFS_REGNM(REGNM);
		
		
		/* 뷰페이지에서 넘어온 FileSub 데이터 세팅 - FS_ALT, FS_COMMENTS */
		if( StringUtils.isNotEmpty(fsVO.getFS_ALT()) ){
			FileSub.setFS_ALT(fsVO.getFS_ALT());
		}
		if( StringUtils.isNotEmpty(fsVO.getFS_COMMENTS()) ){
			FileSub.setFS_COMMENTS(fsVO.getFS_COMMENTS());
		}
		
		/*
		 * 신규 등록이 아닌 기존파일 교체를 위한 프로세스 3. - DB데이터 갱신 : 등록자, 파일용량, 원본파일명 등
		 */
		if( isUpdate ){ //수정
			Component.updateData("FileManage.AFS_FileUpdateData", FileSub);
			
		}else{ //신규
			Component.createData("File.AFS_FileInfoInsert", FileSub);
		}
		
		return FileSub;
	}
	
	/**
 	 * 다중 파일을 업로드 한다.
 	 * + 리사이즈
 	 * @param request 요청
 	 * @param REGNM 등록자
 	 * @param fileOpt 리사이즈/썸네일 생성 여부, 가로세로 크기 등 전달 DTO
 	 * @throws Exception
 	 */
	@Override
	public FileSub FileUpload(HttpServletRequest request, String REGNM, FileSub fileOpt, String FILES_EXT) {
		//주의 : 4번째 FileSub Option 파라미터가 들어갈 경우 request 내 모든 파일의 정보를 갈음하게 됨
		return FileUploadNthFile(request, REGNM, -1, fileOpt, false, FILES_EXT);
	}
	
	/**
	 * 다중
	 * 리사이즈  + 순번에 따른 리사이징 이미지를 업로드 한다.
 	 * height 0 일때는 height값 autoSizing
 	 * @param request 요청
 	 * @param FS_FM_KEYNO 메인코드 키
     * @param REGNM 등록자
     * @param cnt 파일번호
     * @param width 리사이즈 가로크기
     * @param height 리사이즈 높이
     * @return
     * @throws Exception
    */
	@Override
	public FileSub resizeFileUpload(HttpServletRequest request, String FS_FM_KEYNO, String REGNM, int cnt, int width, int height)
			throws Exception {
		
		return resizeFileUpload(request, FS_FM_KEYNO, REGNM, cnt, width, height, null);
	}
	
	@Override
	public FileSub resizeFileUpload(HttpServletRequest request, String FS_FM_KEYNO, String REGNM, int cnt, int width, int height, String FILES_EXT)
			throws Exception {
		FileSub fileOpt = new FileSub();
		fileOpt.setFS_FM_KEYNO(FS_FM_KEYNO);
		fileOpt.IS_RESIZE().RESIZE_WIDTH(width).RESIZE_HEIGHT(height);
		
		return FileUploadNthFile(request, REGNM, cnt, fileOpt, false, FILES_EXT);
	}
	
	/**
	 * 다중
	 * 리사이즈  + 순번에 따른 리사이징 이미지를 업로드 한다.
 	 * height 0 일때는 height값 autoSizing
 	 * @param request 요청
 	 * @param FS_FM_KEYNO 메인코드 키
 	 * @param addFM_WHERE_KEY 호출하는 컨텐츠의 PK (참조용)
     * @param FM_COMMENTS 파일의 용도 및 목적 등
     * @param REGNM 등록자
     * @param cnt 파일번호
     * @param width 리사이즈 가로크기
     * @param height 리사이즈 높이
     * @return
     * @throws Exception
    */
	@Override
	public FileSub resizeFileUpload(HttpServletRequest request, String FS_FM_KEYNO, String addFM_WHERE_KEY, String FM_COMMENTS, String REGNM, int cnt, int width, int height, boolean isThumbnail)
					throws Exception {
		//FS_FM_KEYNO == null일 경우 updateFileMain에서 키값 생성해줌
		return resizeFileUpload(request, FS_FM_KEYNO, addFM_WHERE_KEY, FM_COMMENTS, REGNM, cnt, width, height, isThumbnail, null);
	}
	
	@Override
	public FileSub resizeFileUpload(HttpServletRequest request, String FS_FM_KEYNO, String addFM_WHERE_KEY, String FM_COMMENTS, String REGNM, int cnt, int width, int height, boolean isThumbnail, String FILES_EXT)
					throws Exception {
		FileSub fileOpt = new FileSub();
		fileOpt.setFS_FM_KEYNO(FS_FM_KEYNO);
		fileOpt.setFM_WHERE_KEYS(addFM_WHERE_KEY);
		fileOpt.setFM_COMMENTS(FM_COMMENTS);
		fileOpt.IS_RESIZE().RESIZE_WIDTH(width).RESIZE_HEIGHT(height);
		
		return FileUploadNthFile(request, REGNM, cnt, fileOpt, isThumbnail, FILES_EXT);
	}
	
	
	/**
 	 * cnt번째 파일을 업로드 한다.
 	 * @param request 요청
 	 * @param FS_FM_KEYNO 메인코드 키
 	 * @param REGNM 등록자
 	 * @param cnt 업로드할 파일 번호 (1~)
 	 * @throws Exception
 	 */
//	@Override
//	public FileSub imageUploadNthFileWithDefaultResizing(HttpServletRequest request, String REGNM, int cnt) throws Exception {
//		return FileUploadNthFile(request, REGNM, cnt, new FileSub().IS_RESIZE()
//					.RESIZE_WIDTH(SettingData.DEFAULT_IMG_RESIZE_WIDTH), false)
//					.RESIZE_HEIGHT(SettingData.DEFAULT_IMG_RESIZE_HEIGHT);
//	}
	
	/**
	 * 파일들을 업로드하고 이미지는 기본 썸네일을 생성한다.
	 * @param request
	 * @param FS_FM_KEYNO
	 * @param REGNM
	 * @return
	 * @throws Exception
	 */
	@Override
	public FileSub FileUploadWithDefaultThumb(HttpServletRequest request, String FS_FM_KEYNO, String REGNM) throws Exception {
		return FileUploadNthFile(request, REGNM, -1, new FileSub(FS_FM_KEYNO, null).IS_MAKE_THUMBNAIL().THUMB_WIDTH(SettingData.DEFAULT_IMG_THUMBNAIL_RESIZE_WIDTH).THUMB_WIDTH(SettingData.DEFAULT_IMG_THUMBNAIL_RESIZE_HEIGHT), false, null);
	}
	
	/**
 	 * 다중 파일을 업로드 하며 함께 전달된 FileSub 리스트의 내용을 주입한다.
 	 * @param request 요청 - 다중 파일 및 그에 수반하는 더즁 파라미터들을 전달
 	 * @param REGNM 등록자
 	 * @param count 몇번 째 파일을 업로드 할 것인지 ( -1 : 모든 파일 )
 	 * @param fsParam 컨트롤러에서 주입하는 데이터를 담는 DTO.
 	 * - IS_RESIZE, RESIZE_WIDTH, RESIZE_HEIGHT (리사이즈 여부 및 크기)
 	 * - IS_MAKE_THUMBNAIL, THUMB_WIDTH, THUMB_HEIGHT (썸네일 생성 여부 및 리사이즈 크기)
 	 * - FS_KEYNO (파일 교체 및 수정을 원할 경우 전달)
 	 * - FS_FM_KEYNO (부모키 FM_KEYNO)
 	 *  리사이징/썸네일 생성 여부 및 가로세로 크기 값 등. 수정을 위한 FS_KEYNO는 count가 -1이 아닌 경우에만 사용 가능
 	 *  isThumbnail :: true이면 FS_ALT, FS_COMMENTS 값이 필수
 	 * @throws Exception
 	 * @return 마지막 업로드 된 파일의 FileSub 객체
 	 */
	@Override
	public FileSub FileUploadNthFile(HttpServletRequest request, String REGNM, int count, FileSub fsParam, boolean isThumbnail, String FILES_EXT) {

		FileSub fileSub = new FileSub();
		final MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
		final Map<String, MultipartFile> files = multiRequest.getFileMap();
		Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
		List<FileSub> fsList = getFileSubList(request, files.size(), count, isThumbnail); //다중 파라미터 FS_ALT, FS_COMMENTS를 List로
		int fsIdx = 0; //list index
		int fileCount = 1; //request 내 파일 카운트
		int fsListSize = fsList.size();
		
		/** 파일 저장 처리 */  
		while (itr.hasNext()){
			Entry<String, MultipartFile> entry = itr.next();
			
			boolean fileExtPass = true;
			
			if( count == -1 || count == fileCount ){
				MultipartFile file = entry.getValue();
				
				FileSub fsVO = new FileSub();
				if( file != null ){
					
					String FS_EXT = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf('.')+1, file.getOriginalFilename().length()).toLowerCase();
					
					if(StringUtils.isNotBlank(FILES_EXT)){
						try {
							FILES_EXT = AES256Cipher.decode(FILES_EXT);
							if(!FILES_EXT.contains(FS_EXT)){
								fileExtPass = false; 
							}
						} catch (Exception e) {
							fileExtPass = false; 
						}
					}
					
					if(fileExtPass){
						//FileSub 배열 정보값 주입
						if( fsIdx < fsListSize ){
							fsVO = fsList.get(fsIdx);
						}
						
						//객체로 전달받은 param 주입 - request로부터 받은 param보다 우선순위 낮음.
						if( fsParam != null ){
							
							//모든 파일 정보를 하나의 DTO로 갈음하는 것 방지
							if( count != -1 ){
								//옵션으로 FS_KEYNO 전달 : 파일 변경
								if( StringUtils.isEmpty(fsVO.getFS_KEYNO()) ){
									fsVO.setFS_KEYNO(fsParam.getFS_KEYNO());
								}
							}
							
							//FileMain
							if( StringUtils.isEmpty(fsVO.getFS_FM_KEYNO()) ){
								fsVO.setFS_FM_KEYNO(fsParam.getFS_FM_KEYNO());
							}
							if( StringUtils.isEmpty(fsVO.getFM_WHERE_KEYS()) ){
								fsVO.setFM_WHERE_KEYS(fsParam.getFM_WHERE_KEYS());
							}
							if( StringUtils.isEmpty(fsVO.getFM_COMMENTS()) ){
								fsVO.setFM_COMMENTS(fsParam.getFM_COMMENTS());
							}
							//리사이징/썸네일 생성 //fsVO는 디폴트 false니까 fsParam에 값이 있으면 넣어줘야함
							//게시판 썸네일 생성할 때 체크 true - 스토리지에서만 필요
							if( fsVO.getIS_MAKE_BOARDTHUMB() == false ){
								fsVO
								.setIS_MAKE_BOARDTHUMB(fsParam.getIS_MAKE_BOARDTHUMB());
							}
							if( fsVO.getIS_RESIZE() == false ){
								fsVO
								.RESIZE_WIDTH(fsParam.getRESIZE_WIDTH())
								.RESIZE_HEIGHT(fsParam.getRESIZE_HEIGHT())
								.setIS_RESIZE(fsParam.getIS_RESIZE());
							}
							if( fsVO.getIS_MAKE_THUMBNAIL() == false ){
								fsVO
								.THUMB_WIDTH(fsParam.getTHUMB_WIDTH())
								.THUMB_HEIGHT(fsParam.getTHUMB_HEIGHT())
								.setIS_MAKE_THUMBNAIL(fsParam.getIS_MAKE_THUMBNAIL());
							}
							if( fsVO.getIS_MAKE_MOVIE_THUMBNAIL() == false ){
								fsVO
								.THUMB_WIDTH(fsParam.getTHUMB_WIDTH())
								.THUMB_HEIGHT(fsParam.getTHUMB_HEIGHT())
								.setIS_MAKE_MOVIE_THUMBNAIL(fsParam.getIS_MAKE_MOVIE_THUMBNAIL());
							}
						}
						//메인코드 실재 확인 및 신규등록 처리 - FM_WHERE_KEYS, FM_COMMENTS 주입
						fsVO.setFS_FM_KEYNO(updateFileMain(fsVO.getFS_FM_KEYNO(), fsVO, REGNM));
						
						//실제 파일 저장 DB 
						fileSub = FileUpload(file, REGNM, fsVO, request);
						//파일경로 가져옴
					}
				}
			}
			
			fsIdx++;
			fileCount++;
		}
		
		
		FileSub fsVO = new FileSub();
		if (fsParam != null) {
			// FileMain
			if (StringUtils.isEmpty(fsVO.getFS_FM_KEYNO())) {
				fsVO.setFS_FM_KEYNO(fsParam.getFS_FM_KEYNO());
			}
			if (StringUtils.isEmpty(fsVO.getFM_WHERE_KEYS())) {
				fsVO.setFM_WHERE_KEYS(fsParam.getFM_WHERE_KEYS());
			}
			if (StringUtils.isEmpty(fsVO.getFM_COMMENTS())) {
				fsVO.setFM_COMMENTS(fsParam.getFM_COMMENTS());
			}
		}
		return fileSub;
	}
	
	@Override
	public boolean FileUploadNthFileByPath(HttpServletRequest request, String path, String newName) throws Exception {
		
		boolean chk = false;
		final MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
		final Map<String, MultipartFile> files = multiRequest.getFileMap();
		Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
		
		FileCommonTools.createfolder(path);	//폴더 생성
		
		/** 파일 저장 처리 */  
		while (itr.hasNext()){
			Entry<String, MultipartFile> entry = itr.next();
				MultipartFile file = entry.getValue();
				if( file != null ){
					FileUpload(file, path, newName);
					chk = true;
				}
			}
		return chk;
	}
	
	
	private void FileUpload(MultipartFile file, String path, String newName) {
		//프로퍼티 경로 불러오기
		String uploadPath = path;
		//경로 설정
		String filePath = "";
		//파일 처리
		if( file != null && file.getOriginalFilename() != null && !file.getOriginalFilename().equals("") ){
			try {
				/** 원본 업로드 */
				filePath = uploadPath + "/" + FilenameUtils.getName(file.getOriginalFilename());
				File befFile = new File(filePath);
				
				if(StringUtils.isNotBlank(newName)){
					// 복사본 만드는 경우
					String newfilePath = uploadPath + "/" + newName;
					File newFile = new File(newfilePath);

					file.transferTo(newFile);
				}else{
					file.transferTo(befFile);
				}
			} catch (Exception e) {
				System.out.println("#51 파일 저장중 에러!!");
				e.printStackTrace();
			}
		}
	}
	
	/**
 	 * DATA URI 데이터 기반으로 업로드 합니다  + 썸네일 생성
 	 * @param imgInfo	해쉬맵으로 uri,title,ext 정보를 담고있음
 	 * @param FS_FM_KEYNO 메인코드 키
 	 * @param REGNM 등록자
 	 * IS_RESIZE :: true 옵션 넣으면 리사이즈 처리
 	 * @throws Exception
 	 */
	@Override
	public FileSub FileUploadByDataURI(HashMap<String, String> imgInfo, String FS_FM_KEYNO, String REGNM) {
		
		FileMain FileMain = new FileMain();
		FileMain.setFM_KEYNO(FS_FM_KEYNO);
		FileMain.setFM_REGNM(REGNM);
		
		//메인코드 확인 및 등록 처리
		int result = Component.getCount("File.AFM_MainFileChecking", FileMain);
		if(result == 0){
			Component.createData("File.AFM_FileInfoInsert",FileMain);
		}
		
		//프로퍼티 경로 불러오기
		String propertiespath = SiteProperties.getString("FILE_PATH");
		
		FileSub FileSub = new FileSub();
		FileSub.setFS_FM_KEYNO(FS_FM_KEYNO);
		
		String uri = imgInfo.get("uri");
		String title = imgInfo.get("title");
		String ext = imgInfo.get("ext");
		
		//확장자
		String FS_EXT = "";
		//변경 파일명
		String FS_CHANGENM = "";
		
		FileSub.setFS_FOLDER(SaveFolder(propertiespath));
		
		/** 경로 설정 */
		String uploadPath = propertiespath + FileSub.getFS_FOLDER();
	
		
		/** 확장자 취득 */
		FS_EXT = ext;
		/** 파일명 변환 후 저장*/
		FS_CHANGENM = setfilename();
		FileSub.setFS_EXT(FS_EXT);
		FileSub.setFS_CHANGENM(FS_CHANGENM);
		FileSub.IS_MAKE_THUMBNAIL();
		
		String filePath = uploadPath + FilenameUtils.getName(FS_CHANGENM + "." + FS_EXT);
		try {
			 byte[] imagedata = DatatypeConverter.parseBase64Binary(uri.substring(uri.indexOf(",") + 1));
			 BufferedImage bufferedImage = ImageIO.read(new ByteArrayInputStream(imagedata));
			 
			 /*업로드*/
		     StorageSelector.createBufferedFile(bufferedImage, filePath, FileSub);
		     
		} catch (Exception e) {
		}
		//파일 정보 저장
		FileSub.setFS_ORINM(title + "." + FS_EXT);
		FileSub.setFS_REGNM(REGNM);
		FileSub.setFS_CONVERT_CHK("Y");
		Component.createData("File.AFS_FileInfoInsert", FileSub);	
			
		return FileSub;
	}

	
	/**
	 * 이미지 변경 메소드
	 * @param FS_KEYNO
	 * @param req - FS_KEYNO param 여부에 따라 신규/수정 분기처리, FS_FM_KEYNO, FS_ALT, FS_COMMENTS 등
	 * @param cnt 넘어온 파일 정보중 몇번째 파일인가
	 * @param resize 리사이즈 된 이미지 있는지 여부 
	 * @return
	 * @throws Exception
	 */
	@Override
	public FileSub imageChange(String FS_KEYNO, HttpServletRequest req, String regNm, int cnt, boolean resize, int width, int height, boolean isThumbnail) throws Exception{
		
		return imageChange(FS_KEYNO, req, regNm, cnt, resize, width, height, isThumbnail, null);
	}

	@Override
	public FileSub imageChange(String FS_KEYNO, HttpServletRequest req, String regNm, int cnt, boolean resize, int width, int height, boolean isThumbnail, String FILES_EXT) throws Exception{
		FileSub FileSub = new FileSub();
//		FileSub.setFS_KEYNO(FS_KEYNO);
//		FileSub=Component.getData("File.AFS_SubFileDetailselect", FileSub);
//		String FM_KEY = "";
//		
//		if(FileSub != null){
//			//기존의 이미지 삭제
//			UpdateFileDelete(FS_KEYNO);
//			FM_KEY = FileSub.getFS_FM_KEYNO();
//		}else{
//			FM_KEY = CommonService.getTableKey("FM");
//		}
		
		if(resize && width != 0){ // 리사이즈 한 파일만 저장
			FileSub = FileUploadNthFile(req, regNm, cnt, new FileSub(null, FS_KEYNO).IS_RESIZE().RESIZE_WIDTH(width).RESIZE_HEIGHT(height), isThumbnail, FILES_EXT);
		}else{ // 리사이즈 안함
			FileSub = FileUploadNthFile(req, regNm, cnt, new FileSub(null, FS_KEYNO), isThumbnail, FILES_EXT);
		}
		
		return FileSub;
	}
	
	/**
	 * 이미지 변경 메소드
	 * @param FS_KEYNO
	 * @param file
	 * @param ID
	 * @return
	 * @throws Exception
	 */
	@Override
	public FileSub imageChange(String FS_KEYNO, MultipartFile file,String ID,boolean isResize, HttpServletRequest req) throws Exception{
		FileSub fileSub = new FileSub();
		fileSub.setFS_KEYNO(FS_KEYNO);
		fileSub = Component.getData("File.AFS_SubFileDetailselect", fileSub);
		
		if(fileSub == null){
			fileSub = new FileSub();
			fileSub.setFM_KEYNO(CommonService.getTableKey("FM"));
		}
		//새로운 이미지 등록
		fileSub = FileUpload(file, fileSub, ID, isResize, req);
		
		return fileSub;
	}
	
	public FileSub resizeThumbNailFileUpload(HttpServletRequest request, String FS_FM_KEYNO, String addFM_WHERE_KEY, String FM_COMMENTS, String REGNM, int width, int height)
			throws Exception {
		FileSub fileOpt = new FileSub();
		fileOpt.setFS_FM_KEYNO(FS_FM_KEYNO); 
		fileOpt.setFM_WHERE_KEYS(addFM_WHERE_KEY);
		fileOpt.setFM_COMMENTS(FM_COMMENTS);
		fileOpt.IS_RESIZE().RESIZE_WIDTH(width).RESIZE_HEIGHT(height);
		fileOpt.setIS_MAKE_BOARDTHUMB(true);
		
		return FileUploadNthFile(request, REGNM, 1, fileOpt, true, null);
	}
	
	public FileSub thumbNailImageChange(String FS_KEYNO, HttpServletRequest req,String regNm,int width,int height) throws Exception{
		FileSub FileSub = new FileSub(null, FS_KEYNO).IS_RESIZE().RESIZE_WIDTH(width).RESIZE_HEIGHT(height).IS_MAKE_BOARDTHUMB();
		return FileUploadNthFile(req, regNm, 1, FileSub, true, null);
	}
	
	/**
	 * 업로드 파일 삭제 
	 */
	@Override
	public void UpdateFileDelete(FileSub fileSub) {
		
		//DB정보 삭제처리
		Component.deleteData("File.AFS_FileUploadDelete", fileSub);
		
		try {
			StorageSelector.updateFileDelete(fileSub);
		} catch (Exception e) {
			System.out.println("파일 삭제 에러");
		}
		
	}
	
	
	/**
	 * 이미지 파일 삭제 
	 * @param imgList
	 * @throws Exception 
	 */
	@Override
	public void UpdateFileDelete(List<FileSub> imgList) throws Exception {
		String uploadPath = SiteProperties.getString("FILE_PATH");
		for(int i=0; i<imgList.size(); i++) {
			FileSub fileSub = new FileSub();
			fileSub.setFS_KEYNO(imgList.get(i).getFS_KEYNO());
			//파일삭제처리
			fileSub = Component.getData("File.AFS_SubFileDetailselect", fileSub);
			
			if(fileSub != null){
				FileManageTools.fileExistsCheck(
						uploadPath + fileSub.getFS_FOLDER()
						+ FilenameUtils.getName(fileSub.getFS_CHANGENM() + "." + fileSub.getFS_EXT()));
			
				//DB정보 삭제처리
				Component.deleteData("File.AFS_FileUploadDelete", fileSub);
			}
		}
	}
	
	/**
	 * 업로드 파일 교체 - 스토리지 수정해야함
	 * @param deletefile
	 * @return 
	 * jsa
	 * @throws Exception 
	 */
	@Override
	public FileSub UpdateFileSub( HttpServletRequest requeset, FileSub fileSubNew ) throws Exception {
		String uploadPath = SiteProperties.getString("FILE_PATH");
		FileSub fileSubOld = Component.getData("File.AFS_SubFileDetailselect", fileSubNew);
		
		if(fileSubOld != null){
            FileManageTools.deleteFolder(uploadPath + fileSubOld.getFS_FOLDER()
            + FilenameUtils.getName(fileSubOld.getFS_CHANGENM() + "." + fileSubOld.getFS_EXT()));
			//DB정보 삭제처리
			Component.deleteData("File.AFS_FileUploadDelete", fileSubOld);
			
			//썸네일 이미지 유무체크 후 물리삭제 진행
			if( StringUtils.isNotEmpty(fileSubOld.getFS_THUMBNAIL()) ){
                FileManageTools.deleteFolder(uploadPath + fileSubOld.getFS_FOLDER() 
                + FilenameUtils.getName(fileSubOld.getFS_CHANGENM() + "_thumbnail." + fileSubOld.getFS_EXT()));
			}
		}
		
		return fileSubNew;
	}


	/**
	 * 넘어온 FS_KEYNO 로 새로운 파일 복사 생성
	 * @param FS_KEYNO
	 * @param fM_KEYNO
	 * @param REGNM
	 * @return
	 * @throws Exception
	 */
	@Override
	public FileSub FileCopy(String FS_KEYNO, String FM_KEYNO, String REGNM) throws Exception {
		
		//프로퍼티 경로 불러오기
		String propertiespath = SiteProperties.getString("FILE_PATH");
			
		FileSub FileSub = new FileSub();
		FileSub.setFS_KEYNO(FS_KEYNO);
		
		//기존 데이터 불러옴
		FileSub = Component.getData("File.AFS_SubFileDetailselect", FileSub);
		
		//변경 파일명
		String fS_CHANGENM = "";
		
		FileSub.setFS_FOLDER(SaveFolder(propertiespath));
	
		/** 파일명 변환 후 저장*/
		fS_CHANGENM = setfilename();

		FileSub.IS_MAKE_THUMBNAIL();
		/*업로드*/
	    StorageSelector.createFileCopy(FileSub, fS_CHANGENM);
	    
		//파일 정보 저장
		FileSub.setFS_FM_KEYNO(FM_KEYNO);
		FileSub.setFS_REGNM(REGNM);
		FileSub.setFS_CHANGENM(fS_CHANGENM);
		FileSub.setFS_CONVERT_CHK("Y");
		Component.createData("File.AFS_FileInfoInsert", FileSub);	
			
		return FileSub;
	}
	
	/**
 	 * 업로드시 폴더 여부 확인 및 생성
 	 * 2018-07-13 이재령
 	 * 날짜 분류 폴도 추가 
 	 * ex) upload/20180713/1... 2.... 3
 	 * @param Uploadpath
 	 */
	@Override
	public String SaveFolder(String Uploadpath){
		String folderPath = "";
		String RtnValue = "";
		FileManageTools.checkFolder(Uploadpath);

		Date dt = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd"); 
		folderPath = sdf.format(dt).toString()+"/";

		FileManageTools.checkFolder(Uploadpath + folderPath);

		File FilegetCnt = new File(Uploadpath + folderPath); 
		String Cntfiles[] = FilegetCnt.list();	
		if(Cntfiles.length == 0){
			FileManageTools.checkFolder(Uploadpath + folderPath + "1/");
			RtnValue = folderPath + "1/";
		}else if(Cntfiles.length > 0){
			boolean FolderCheck = false;
			Loop:
			for(int i = 1; i <= Cntfiles.length; i++){
				File CntToT = new File(Uploadpath + folderPath + i +"/"); 
				if(CntToT.list().length < FOLDER_FILE_CNT){
					RtnValue = folderPath + i + "/";
					FolderCheck = true;
					break Loop;
				}
			}
			if(FolderCheck == false){
				RtnValue = folderPath + (Cntfiles.length + 1) + "/";
				FileManageTools.checkFolder(Uploadpath + folderPath + (Cntfiles.length + 1) + "/");
			}  
		}
		return RtnValue;
 	}
 	
	/**
	  * 파일 업로드 내부의 고유키 부여
	  * @comment
	  * 2016.04.08. SooAn
	  *  웹에디터에서 이미지의 원활한 수정을 위해서
	  *  100글자에서 10글자로 대폭 축소시킴.
	  *  예측 위험발생가능성 - 폴더 당 최대생성하는 파일갯수 50회 중 1/36^15 의 확률로 발생 추측
	  *  2018.07.12 이재령
	  *  파일명에 현재시간 추가
	  * @return
	  */
	@Override
	public String setfilename(){
		
		Date dt = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss"); 
		
		String buf = sdf.format(dt).toString() + "_";
		
		SecureRandom rnd =new SecureRandom();
		
		for(int i=0 ; i < 10 ; i++){  
		    if(rnd.nextBoolean()){ 
		        buf +=((char)((int)(rnd.nextInt(26))+97)); 
		    }else{
		        buf+=((rnd.nextInt(10))); 
		    }
		}
       return buf;
	}
	

	/**
	 * FILE_MAIN 데이터 생성
	 * @return FM_KEYNO
	 */
	@Override
	public String makeFileMainData(String REGNM) throws Exception {
		
		FileMain FileMain = new FileMain();
		FileMain.setFM_REGNM(REGNM);
		
		Component.createData("File.AFM_FileInfoInsert",FileMain);
		
		return FileMain.getFM_KEYNO();
	}
	
	
	/**
	 * @param req
	 * @return
	 * List<FileSub> 다중으로 넘어온 개별적인 FS_KEYNO(수정), FS_ALT, FS_COMMENTS
	 */
	@Override
	public List<FileSub> getFileSubInfoList(HttpServletRequest req) {
		List<FileSub> list = new ArrayList<FileSub>();	
		/* 파일 필수 컬럼 */
		String[] fS_ALT = req.getParameterValues("FS_ALT");
		String[] fS_COMMENTS = req.getParameterValues("FS_COMMENTS");
		String[] fS_ORDER = req.getParameterValues("FS_ORDER");
		/* 파일 필수 컬럼 끝 */
		if(fS_ORDER != null){
		int size = fS_ORDER.length;
			if(size > 0){
				//FS_KEYNO를 전송하여 수정을 시도할 경우
				String[] fS_KEYNO = new String[size];
				copyArrayValues( fS_KEYNO, req.getParameterValues("FS_KEYNO") );
				
				for( int i = 0; i < size; i++ ){
					FileSub fs = new FileSub();
					fs.setFS_ALT(fS_ALT[i]);
					fs.setFS_COMMENTS(fS_COMMENTS[i]);
					fs.setFS_KEYNO(fS_KEYNO[i]);
					fs.setFS_ORDER(Integer.parseInt(fS_ORDER[i]));
					list.add(fs);
				}
			}
		}
		
		return list;
	}
	
	/**
	 * 뷰 페이지에서 다중으로 넘어온 개별적인 FileSub 관련 request param을 List로 반환 
	 * @param req - 필수(!) : FS_ALT, FS_COMMENTS, 
	 * @param req - 옵션 : FS_FM_KEYNO, FS_KEYNO(수정), IS_RESIZE(RESIZE_WIDTH, RESIZE_HEIGHT),
	 *  IS_MAKE_THUMBNAIL(THUMB_WIDTH, THUMB_HEIGHT)
	 * @param count 
	 * @param fileLength 
	 * @return List<FileSub>
	 */
	@Override
	public List<FileSub> getFileSubList(HttpServletRequest req, int fileLength, int count, boolean isThumbnail) {

		List<FileSub> list = new ArrayList<FileSub>();		
		int size = 1;
		String[] fS_ALT = null;
		String[] fS_COMMENTS = null;
		if(!isThumbnail){
			/* 파일 필수 컬럼 */
			fS_ALT = req.getParameterValues("FS_ALT");
			fS_COMMENTS = req.getParameterValues("FS_COMMENTS");
			/* 파일 필수 컬럼 끝 */
		}
		
		if( fS_ALT != null && fS_COMMENTS != null ){
			
			//리스트 길이
			size = fS_ALT.length > fS_COMMENTS.length ? fS_ALT.length : fS_COMMENTS.length;
			
			//FileMain
			String[] fS_FM_KEYNO = new String[size];
			copyArrayValues( fS_FM_KEYNO, req.getParameterValues("FS_FM_KEYNO") );
			String[] fM_WHERE_KEYS = new String[size];
			copyArrayValues( fM_WHERE_KEYS, req.getParameterValues("FM_WHERE_KEYS") );
			String[] fM_COMMENTS = new String[size];
			copyArrayValues( fM_COMMENTS, req.getParameterValues("FM_COMMENTS") );
			
			//FS_KEYNO를 전송하여 파일 수정을 시도할 경우
			String[] fS_KEYNO = new String[size];
			copyArrayValues( fS_KEYNO, req.getParameterValues("FS_KEYNO") );
			
			//이미지 리사이징 정보
			String[] IS_RESIZE = new String[size];
			String[] RESIZE_WIDTH = new String[size];
			String[] RESIZE_HEIGHT = new String[size];
			copyArrayValues( IS_RESIZE, req.getParameterValues("IS_RESIZE") );
			copyArrayValues( RESIZE_WIDTH, req.getParameterValues("RESIZE_WIDTH") );
			copyArrayValues( RESIZE_HEIGHT, req.getParameterValues("RESIZE_HEIGHT") );
			
			//썸네일 생성 및 리사이징 정보
			String[] IS_MAKE_THUMBNAIL = new String[size];
			String[] THUMB_WIDTH = new String[size];
			String[] THUMB_HEIGHT = new String[size];
			copyArrayValues( IS_MAKE_THUMBNAIL, req.getParameterValues("IS_MAKE_THUMBNAIL") );
			copyArrayValues( THUMB_WIDTH, req.getParameterValues("THUMB_WIDTH") );
			copyArrayValues( THUMB_HEIGHT, req.getParameterValues("THUMB_HEIGHT") );
			
			
			for( int i = 0; i < size; i++ ){
				FileSub fs = new FileSub();
				fs.setFS_ALT(fS_ALT[i]);
				fs.setFS_COMMENTS(fS_COMMENTS[i]);
				
				fs.setFS_FM_KEYNO(CommonService.getKeyno(fS_FM_KEYNO[i], "FM")); //숫자 키로 넘어온 경우에 대비
				fs.setFS_KEYNO(CommonService.getKeyno(fS_KEYNO[i], "FS")); //숫자 키로 넘어온 경우에 대비
				
				boolean iS_RESIZE = StringUtils.isNotEmpty(IS_RESIZE[i]) ? Boolean.parseBoolean(IS_RESIZE[i]) : false;
				if( iS_RESIZE ){
					int rESIZE_WIDTH = StringUtils.isNotEmpty(RESIZE_WIDTH[i]) ? Integer.parseInt(RESIZE_WIDTH[i]) : SettingData.DEFAULT_IMG_RESIZE_WIDTH;
					int rESIZE_HEIGHT = StringUtils.isNotEmpty(RESIZE_HEIGHT[i]) ? Integer.parseInt(RESIZE_HEIGHT[i]) : SettingData.DEFAULT_IMG_RESIZE_HEIGHT;
					fs.IS_RESIZE().RESIZE_WIDTH(rESIZE_WIDTH).RESIZE_HEIGHT(rESIZE_HEIGHT);
				}
				
				boolean iS_MAKE_THUMBNAIL = StringUtils.isNotEmpty(IS_MAKE_THUMBNAIL[i]) ? Boolean.parseBoolean(IS_MAKE_THUMBNAIL[i]) : false;
				if( iS_MAKE_THUMBNAIL ){
					int tHUMB_WIDTH = StringUtils.isNotEmpty(THUMB_WIDTH[i]) ? Integer.parseInt(THUMB_WIDTH[i]) : SettingData.DEFAULT_IMG_THUMBNAIL_RESIZE_WIDTH;
					int tHUMB_HEIGHT = StringUtils.isNotEmpty(THUMB_HEIGHT[i]) ? Integer.parseInt(THUMB_HEIGHT[i]) : SettingData.DEFAULT_IMG_THUMBNAIL_RESIZE_HEIGHT;
					fs.IS_MAKE_THUMBNAIL().THUMB_WIDTH(tHUMB_WIDTH).THUMB_HEIGHT(tHUMB_HEIGHT);
				}
				list.add(fs);
			}
		}
		
		return list;
		
	}
	
	/**
	 * 압축파일 생성
	 * @param fsVO
	 * @throws Exception 
	 */
	@Override
	public void zip(HttpServletRequest req, List<FileSub> fsVO) throws Exception {
		
		if(fsVO.size() > 1) {
			String propertiespath = SiteProperties.getString("FILE_PATH");
			
			String folder = thumnail.mainfolder(req);
			String zipName = "";
			
			if(StringUtils.isNotEmpty((String)req.getAttribute("currentBn"))) zipName = (String)req.getAttribute("currentBn") + ".zip";
			 
			String zipPath = StorageSelector.zip(fsVO,propertiespath,folder,zipName);
			
			if(StringUtils.isNotEmpty(zipPath)){
				FileMain FileMain = new FileMain();
				FileMain.setFM_KEYNO(fsVO.get(0).getFS_FM_KEYNO());
				FileMain.setFM_ZIP_PATH(zipPath);
				Component.updateData("File.AFM_FileUPdate", FileMain);
			}	
		}
	}
	

	@Override
	public String zip(List<HashMap<String,Object>> files, String fileName) throws Exception {
		byte[] buf = new byte[1024];
		
	    String uploadPath = SiteProperties.getString("FILE_PATH") + "zipFile/";
		String zip_name = fileName;
		
        FileCommonTools.createfolder(uploadPath);    //폴더 생성
        
		/**알집 하나만**/
		String attachments = uploadPath + zip_name + ".zip";
		try( ZipOutputStream out = new ZipOutputStream(new FileOutputStream(attachments));) {
    		if(files != null) {
    			for (int i=0; i<files.size(); i++) {
    				// 파일이 있는 폴더만 압축
    				String Path = SiteProperties.getString("WEBFILE_PATH") + files.get(i).get("filePath").toString();
    				if(files.get(i).get("fileNm").toString().contains(".")){
    					try( FileInputStream in = new FileInputStream(Path);) {
    						
    						ZipEntry ze = new ZipEntry(files.get(i).get("filePath").toString());
    						out.putNextEntry(ze);
    						int len;
    						while ((len = in.read(buf)) > 0) {
    							out.write(buf, 0, len);
    						}
    						out.closeEntry();
    						
    					} catch (Exception e) {
    						e.printStackTrace();
    						System.out.println("압축파일에러");
    					}
    				}
                }
    		}
   		 
       } catch (IOException e) {
    	   System.out.println("ZipOutputStream 에러");
       }
		return attachments;
	}
	

	/**
	 * target배열의 최대 길이까지 source배열의 값을 주입 
	 * @param target
	 * @param source
	 * @return
	 */
	private String[] copyArrayValues( String[] target, String[] source ){
		int targetLen = target != null ? target.length : 0;
		int sourceLen = source != null ? source.length : 0;
		if( targetLen != sourceLen ){
			throw new NullPointerException("다중 파라미터 배열의 길이가 다름");
		}
		for( int i = 0; i < targetLen && i < sourceLen ; i++ ){
			target[i] = new String(source[i]);
		}
		
		return target;
	}
	
	
	/**
	 * 파일 업로드 시 FileMain 정보
	 * @param req
	 * @param fm - FM_KEYNO, FM_WHERE_KEYS(신규or추가), FM_COMMENTS 
	 * @return
	 * @throws Exception
	 */
	public FileMain addWhereKeyUpdateAction(HttpServletRequest req
			,FileMain fm
			) throws Exception{
		
		fm.setFM_REGNM(CommonService.getSessionUserKey(req));
		fm.setFM_KEYNO(CommonService.getKeyno(fm.getFM_KEYNO(), "FM"));
		
		String ADD_PK = fm.getFM_WHERE_KEYS();
		//기존 FM_WHERE_KEYS에 KEY를 추가
		if( StringUtils.isNotEmpty(ADD_PK) ){
			FileMain oldFm = Component.getData("FileManage.AFM_FileManageDetail", fm);
			String FM_WHERE_KEYS = oldFm.getFM_WHERE_KEYS();
			if( StringUtils.isNotEmpty(FM_WHERE_KEYS) ){
				if( FM_WHERE_KEYS.indexOf(ADD_PK) == -1 ){
					FM_WHERE_KEYS = FM_WHERE_KEYS + "," + ADD_PK;
				}
			}else{
				FM_WHERE_KEYS = ADD_PK;
			}
			fm.setFM_WHERE_KEYS(FM_WHERE_KEYS);
		}
		
		Component.updateData("FileManage.AFM_FileUpdateData", fm);
		
		return fm;
	}
	
	/**
	 * FS_FM_KEYNO를 통해 유무를 확인하고 없을 시 INSERT
	 * @param fs
	 * @param REGNM
	 * @return FM키 존재할 경우 true
	 */
	public String updateFileMain(String FS_FM_KEYNO, FileSub fs, String REGNM) {
		//FS_KEYNO가 있을 경우(수정프로세스) 부모키를 찾아 리턴
		if( StringUtils.isNotEmpty(fs.getFS_KEYNO()) ){
			HashMap<String,Object> fsResult = Component.getData("FileManage.AFS_FileSelectByKey", fs);
			if( fsResult != null ){
				return fsResult.get("FS_FM_KEYNO").toString();
			}
		}
		
		//fm값이 안넘어올 경우 fm값 가져오기
		if(StringUtils.isEmpty(FS_FM_KEYNO)) FS_FM_KEYNO = String.valueOf(CommonService.getTableAutoKey("S_COMMON_FILE_MAIN","FM_SEQ"));
		
		//FM키 실재 여부를 체크하고 없으면 생성
		FileMain FileMain = new FileMain();
		FileMain.setFM_KEYNO(FS_FM_KEYNO);
		FileMain.setFM_REGNM(REGNM);
		FileMain.setFM_WHERE_KEYS(fs.getFM_WHERE_KEYS());
		FileMain.setFM_COMMENTS(fs.getFM_COMMENTS());
		
		//메인코드 확인 및 등록 처리
		int result = Component.getCount("File.AFM_MainFileChecking", FileMain);
		if(result == 0){
			if( StringUtils.isEmpty(FileMain.getFM_KEYNO()) ){
				FileMain.setFM_KEYNO(CommonService.getTableKey("FM"));
			}
			Component.createData("File.AFM_FileInfoInsert", FileMain);
			
		}else{
			//이미 FM키가 있고 수정할 정보가 있다면 update - FM_WHERE_KEYS는 기존 data에 추가됨
			if( StringUtils.isNotEmpty(fs.getFM_WHERE_KEYS())
					|| StringUtils.isNotEmpty(fs.getFM_COMMENTS()) ){
				String ADD_PK = FileMain.getFM_WHERE_KEYS();
				//기존 FM_WHERE_KEYS에 KEY를 추가
				if( StringUtils.isNotEmpty(ADD_PK) ){
					FileMain oldFm = Component.getData("FileManage.AFM_FileManageDetail", FileMain);
					String FM_WHERE_KEYS = oldFm.getFM_WHERE_KEYS();
					if( StringUtils.isNotEmpty(FM_WHERE_KEYS) ){
						if( FM_WHERE_KEYS.indexOf(ADD_PK) == -1 ){
							FM_WHERE_KEYS = FM_WHERE_KEYS + "," + ADD_PK;
						}
					}else{
						FM_WHERE_KEYS = ADD_PK;
					}
					FileMain.setFM_WHERE_KEYS(FM_WHERE_KEYS);
					Component.updateData("FileManage.AFM_FileUpdateData", FileMain);
				}
			}
		}
		
		return FileMain.getFM_KEYNO();
	}
	
	/**
	 * 
	 * 게시판 메뉴별 폴더 생성
	 */
	public String Menufolder(String Uploadpath ) {
		
		return "Path";
	}
}
