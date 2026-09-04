package com.tx.common.file.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tx.common.config.tld.SiteProperties;
import com.tx.common.file.FileCommonTools;
import com.tx.common.file.FileReadTools;
import com.tx.common.file.FileUploadTools;
import com.tx.common.file.dto.FileSub;
import com.tx.common.security.aes.AES256Cipher;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.storage.service.StorageSelectorService;
import com.tx.dyAdmin.admin.board.dto.BoardPersonal;
import com.tx.dyAdmin.admin.board.service.PersonalfilterService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("FileCommonTools")
public class FileCommonToolsImpl extends EgovAbstractServiceImpl implements FileCommonTools{
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	@Autowired StorageSelectorService StorageSelector;
	
	@Autowired FileCommonTools FileCommonTools;
	/** 파일업로드 툴 */
	@Autowired private FileUploadTools FileUploadTools;
	
	/** 파일읽기 툴 */
	@Autowired FileReadTools FileReadTools;
	@Autowired PersonalfilterService PersonalfilterService;
	
	
	private final String CHECK_STRORAGE_STR = "do?file=";
	
	public String getFileSubStringPathByContent(String path){
		return path.substring(path.indexOf(CHECK_STRORAGE_STR)+CHECK_STRORAGE_STR.length());
	}
	
	/**
	 * editer에 있는 이미지 경로 가져오기(decode)
	 * @param imgTag
	 * @param fullImgTag
	 * @return
	 * @throws Exception
	 */
	public String getImageDecodeByEditor(String imgTag, String fullImgTag) throws Exception {
		
		if(fullImgTag.indexOf("get.do?file=") > 0){
        	imgTag = AES256Cipher.decode(imgTag,SiteProperties.getConfigProperties("cms.storage.secretKey"));
		}else if(fullImgTag.indexOf("file.do?file=") > 0){
        	imgTag = AES256Cipher.decode(imgTag);
		}
		
		return imgTag;
	}
	
	/**
	 * 본문 파일 폴더 이동
	 */
	private String folderMoveByContent(String filePath, String keyno, String MN_KEYNO, boolean editerCheck, String menuType) throws Exception{
		String fileName = filePath.substring(filePath.lastIndexOf("/")+1);

		String newFolder = folderMove(keyno, MN_KEYNO, editerCheck, menuType);
		String newFilePath = null;
		
		if(StringUtils.isNotBlank(newFolder)) {
			newFilePath = StorageSelector.folderMoveByContent(filePath, newFolder, fileName);
		}
		return newFilePath;
	}
	
	/**
	 * new 폴더 생성
	 * @param keyno  :: 키값으로 폴더생성
	 * @param MN_KEYNO :: 메뉴키로 폴더생성
	 * @param editerCheck :: contents폴더 추가로 생성
	 * @param menuType	  :: 메뉴이름으로 폴더 생성
	 * @return
	 * @throws Exception
	 */
	public String folderMove(String keyno, String MN_KEYNO, boolean editerCheck, String menuType) throws Exception{
		
		String propertiespath = SiteProperties.getString("FILE_PATH"); 
		ArrayList<String> list = new ArrayList<>();
		
		String copyfilepath = menuType+"/";
		
		if(list != null) {
			for (String file : list) {
				copyfilepath += file +"/";
			}
		}
		if(StringUtils.isNotEmpty(MN_KEYNO)){
		copyfilepath +=  CommonService.setKeyno(MN_KEYNO) + "/" + keyno + "/";
		}
		
		if(editerCheck) {
			copyfilepath += "contents/";
		}

		//폴더 생성 체크
		createfolder(propertiespath + copyfilepath);
		
		return copyfilepath;
	}
	
	//폴더생성
	public void createfolder(String path) throws Exception{
		File file = new File(path);
		if(!file.exists()) {
			file.mkdirs();
		}
	}

	/**
	 * 에디터 이미지 업로드할 경우 이미지 경로를 체크해서 변경해준다.
	 */
	@Override
	public String editorImgCheck(String contents, String folderNm) throws Exception {
	
		return editorImgCheck(contents,null,null,folderNm);
	}
	
	@Override
	public String editorImgCheck(String contents, String keyno, String menuKeyno, String folderNm) throws Exception {
		  Pattern pattern  =  Pattern.compile("<img[^>]*src=[\"']?([^>\"']+)[\"']?[^>]*>");
	      Matcher match = pattern.matcher(contents);
	      String filePath = "";
	      boolean check = false;

	      if("board".equals(folderNm)) check = true;
	      
	      while(match.find()){
	          String fullImgTag = match.group(1);
	          if(fullImgTag.indexOf(CHECK_STRORAGE_STR) > -1) {
	          	String src = FileCommonTools.getFileSubStringPathByContent(fullImgTag);
	          	if(src.indexOf("${") == -1){	//큐알코드 이미지 들어갔을 때 방지
	          		filePath = FileCommonTools.getImageDecodeByEditor(src, fullImgTag);
	          		if((filePath.indexOf("${") != -1 || filePath.indexOf("temp/") != -1) && fullImgTag.indexOf("file.do?file=") > 0){
	          			filePath = StorageSelector.getImgFilePathByEditor(filePath,fullImgTag,false);
	          			
	          			String path = folderMoveByContent(filePath, keyno, menuKeyno, check, folderNm);
	          			
	          			path = StorageSelector.getImageEncodeByEditor(path);
	          			contents = contents.replace(fullImgTag, path);
	          		}
	          	}
	          }
	      }
     return contents;
	}
	
	/**
	 * 파일의 개인정보 체크
	 */
	@Override
	public BoardPersonal filePersonalCheck(String BT_PERSONAL, FileSub FileSub, String filePath) throws Exception {

		BoardPersonal boardPersonal = new BoardPersonal();
		try {
			String fileExt = FileSub.getFS_EXT();
			String fileContent = "";
			
			if (fileExt.toLowerCase().equals("txt")) {
				fileContent = FileReadTools.fileRead(filePath);
			} else if (fileExt.toLowerCase().equals("xlsx")) {
				fileContent = FileReadTools.excelRead(filePath);
			} else if (fileExt.toLowerCase().equals("xls")) {
				fileContent = FileReadTools.excelReadXls(filePath);
			} else if (fileExt.toLowerCase().equals("doc")) {
				fileContent = FileReadTools.readDoc(filePath);
			} else if (fileExt.toLowerCase().equals("docx")) {
				fileContent = FileReadTools.readDocx(filePath);
			} else if (fileExt.toLowerCase().equals("pdf")) {
				fileContent = FileReadTools.readPdf(filePath);
			}else if (fileExt.toLowerCase().equals("hwp")) {
				fileContent = FileReadTools.readHwp(filePath);
			}
			boardPersonal = PersonalfilterService.PersonalfilterCheck(fileContent.toString(), BT_PERSONAL);

			//스토리지일경우 카피한 파일은 무조건 삭제해야함
			StorageSelector.deleteThumbFileByBoard(filePath);
			//개인정보 필터걸린 파일 삭제
			if(boardPersonal.getResultBoolean() == false) FileUploadTools.UpdateFileDelete(FileSub);
			
		} catch (Exception exception) {
			System.out.println("파일에서 필터링 중 에러");
		}
		return boardPersonal;
	}

}
