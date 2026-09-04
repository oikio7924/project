package com.tx.common.file.thumnail.impl;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.PostConstruct;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.imgscalr.Scalr;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.drew.imaging.ImageMetadataReader;
import com.drew.metadata.Directory;
import com.drew.metadata.Metadata;
import com.drew.metadata.exif.ExifIFD0Directory;
import com.drew.metadata.jpeg.JpegDirectory;
import com.ibm.icu.text.SimpleDateFormat;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.file.FileCommonTools;
import com.tx.common.file.FileUploadTools;
import com.tx.common.file.dto.FileMain;
import com.tx.common.file.dto.FileSub;
import com.tx.common.file.thumnail.ThumnailService;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.storage.service.StorageSelectorService;
import com.tx.dyAdmin.admin.board.dto.BoardNotice;
import com.tx.dyAdmin.admin.board.dto.BoardType;
import com.tx.dyAdmin.homepage.menu.dto.Menu;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("ThumnailService")
public class ThumnailServiceIml extends EgovAbstractServiceImpl implements ThumnailService {

	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 파일업로드 툴*/
	@Autowired private FileUploadTools FileUploadTools;
	@Autowired StorageSelectorService StorageSelector;
	@Autowired FileCommonTools FileCommonTools;

	boolean isStartServlet = false;
	private final String CHECK_STRORAGE_STR = "do?file=";
	
	@PostConstruct
	public void init() {
		isStartServlet = true;
	}
	
	public String ThumnailAction(
			HttpServletRequest req, MultipartFile thumbnail, BoardType BoardType, BoardNotice boardNotice, String FM_KEYNO) throws Exception {
		
			FileSub ThumbFS = new FileSub();
			String key = null;
			
			if(StringUtils.isNotEmpty(boardNotice.getBN_THUMBNAIL())) key = boardNotice.getBN_THUMBNAIL();
			
			ThumbFS.setFS_KEYNO(key);
			
			if(thumbnail != null && !thumbnail.isEmpty()){
				FileSub thumbFileSub = null;
				int thumbnail_width = BoardType.getBT_THUMBNAIL_WIDTH();
				int thumbnail_height = BoardType.getBT_THUMBNAIL_HEIGHT();
				
				if(StringUtils.isEmpty(boardNotice.getBN_THUMBNAIL())){
					thumbFileSub = FileUploadTools.resizeThumbNailFileUpload(req, null, boardNotice.getBN_KEYNO()
											, "게시판 썸네일 이미지", boardNotice.getBN_REGNM(),thumbnail_width, thumbnail_height);
				}else{
					thumbFileSub = FileUploadTools.thumbNailImageChange(boardNotice.getBN_THUMBNAIL(), req, boardNotice.getBN_MODNM(), thumbnail_width, thumbnail_height);
				}
				if(thumbFileSub != null){
					ThumbFS = thumbFileSub;
				}
				
			}else if("Y".equals(BoardType.getBT_THUMBNAIL_INSERT()) && StringUtils.isBlank(boardNotice.getBN_THUMBNAIL())){
				///본문에서 이미지 태그 찾아오기
		        String contents = boardNotice.getBN_CONTENTS();
		       
		        if(StringUtils.isEmpty(contents)){	//상세내용이 null일 경우(입력란 없을시)
		        	
		        	ThumbFS = makeThumbByAttachments(req, FM_KEYNO, boardNotice, ThumbFS);
		        	
		        }else{
		        	
		        	//이미지 태그 정규식
		        	Pattern pattern  =  Pattern.compile("<img[^>]*src=[\"']?([^>\"']+)[\"']?[^>]*>");
		        	// 내용 중에서 이미지 태그를 찾아라!
		        	Matcher match = pattern.matcher(contents);
		        	String imgTag = null;
		        	if(match.find()){
		        		String fullImgTag = match.group(1); // 글 내용 중에 첫번째 이미지 태그를 뽑아옴. 경로
		        		
		        		if(fullImgTag.indexOf(CHECK_STRORAGE_STR) != -1) {
		        			imgTag = FileCommonTools.getFileSubStringPathByContent(fullImgTag);
		        			imgTag = FileCommonTools.getImageDecodeByEditor(imgTag,fullImgTag);
		        		}else{
		        			imgTag = fullImgTag;
		        		}
		        		
		        		String changeNm = imgTag.substring(imgTag.lastIndexOf("/")+1,imgTag.lastIndexOf("."));
		        		if(!checkImgUrl(boardNotice,changeNm)){
		        			boolean urlCk = true;
		        			
		        			if(fullImgTag.indexOf(CHECK_STRORAGE_STR) != -1){	//에디터로 업로드한 이미지일 경우
		        				imgTag = StorageSelector.getImgFilePathByEditor(imgTag,fullImgTag,true);
		        				urlCk = false;
		        			}
		        			ThumbFS = searchThumbFileByContent(req, ThumbFS, imgTag, urlCk);
		        			
		        			String thumbPath = SiteProperties.getString("FILE_PATH") + ThumbFS.getFS_FOLDER() + ThumbFS.getFS_CHANGENM() + "." + ThumbFS.getFS_EXT();
		        			
		        			StorageSelector.createThumbFileByBoard(thumbPath, ThumbFS);
		        			SearcgThumnailTag(boardNotice,ThumbFS);
		        			
		        			//스토리지에서 파일 복사해온 경우 사용하고 다시 지워줌
		        			StorageSelector.deleteThumbFileByBoard(thumbPath);
		        			
		        		}
		        	}else if(StringUtils.isNotBlank(FM_KEYNO)) {
		        		ThumbFS = makeThumbByAttachments(req, FM_KEYNO, boardNotice, ThumbFS);
		        	}
		        	
		        }
			}
			
		return ThumbFS.getFS_KEYNO();
	}
	
	/**
	 * 첨부파일로 썸네일 생성
	 * @param req
	 * @param fM_KEYNO
	 * @param boardNotice
	 * @param thumbFS
	 * @throws Exception
	 */
	private FileSub makeThumbByAttachments(HttpServletRequest req, String fM_KEYNO, BoardNotice boardNotice, FileSub thumbFS) throws Exception{
		HashMap<String, Object> map = new HashMap<>();
		map.put("FM_KEYNO", fM_KEYNO);
    	List<FileSub> ListSub = Component.getList("File.AFS_FileSelectFileSub", map);
    	for(FileSub s : ListSub) {
			String type = s.getFS_EXT();
			if(type.equals("png") || type.equals("jpg") || type.equals("bmg") || type.equals("gif") || type.equals("jpeg")) {
				if(!checkImgUrl(boardNotice,s.getFS_CHANGENM())){
					
					String thumbFilePath = StorageSelector.getThumbFileByAttachments(s);
					
					thumbFS = searchThumbFileByAttachments(req, thumbFilePath, s);
					String thumbPath = SiteProperties.getString("FILE_PATH") + thumbFS.getFS_FOLDER() + thumbFS.getFS_CHANGENM() + "." + thumbFS.getFS_EXT();
					
					StorageSelector.createThumbFileByBoard(thumbPath, s);
        			SearcgThumnailTag(boardNotice,thumbFS);
        			
        			//스토리지에서 파일 복사해온 경우 사용하고 다시 지워줌
        			StorageSelector.deleteThumbFileByBoard(thumbFilePath);
        			
        			break;
    			}
    		}
    	}
    	return thumbFS;
	}
	
	private boolean checkImgUrl(BoardNotice boardNotice,String changeNm) throws Exception{
		
		if(StringUtils.isNotBlank(boardNotice.getBN_THUMBNAIL())) {
			FileSub filesub = Component.getData("File.AFS_SubFileDetailselect",boardNotice.getBN_THUMBNAIL());
			//현재 있는 썸네일과 동일하다면 그냥 넘기고
        	if(compliteImage(filesub,changeNm)) {
        		return true;
        	}else {
        		//기존의 썸네일 지우기
        		StorageSelector.updateFileDelete(filesub);
        	}
        }
		return false;
	}
	
	//이미지 제목 비교
	private boolean compliteImage(FileSub filesub, String name) throws Exception{
		String name1 = name + "_thumb";
		String name2 = filesub.getFS_CHANGENM();
		if(name1.equals(name2)) {
			return true;
		}
		return false;
	}
	
	//본문에서 이미지 찾기
	private void SearcgThumnailTag(BoardNotice BoardNotice, FileSub sub) throws Exception {
		//메인 추가
        String fmKey = insertFileMain(BoardNotice);
       
        //서브 추가
        sub.setFS_FM_KEYNO(fmKey);
        sub.setFS_REGNM(BoardNotice.getBN_REGNM());
        sub.setFM_WHERE_KEYS(BoardNotice.getBN_KEYNO());
		sub.setFS_CONVERT_CHK("Y");
		
        //썸네일 fs 저장
        Component.createData("File.AFS_FileInfoInsert", sub);
	}
	
	public String insertFileMain(BoardNotice boardNotice){

		FileMain main = new FileMain();
        main.setFM_REGNM(boardNotice.getBN_REGNM());
        main.setFM_WHERE_KEYS(boardNotice.getBN_KEYNO());
        main.setFM_COMMENTS("썸네일");
        
        //썸네일 fm 저장
        Component.createData("File.AFM_FileInfoInsert",main);
        return main.getFM_KEYNO();
	}
	
	//상위 메뉴 찾기
	public Menu menuSearch(Menu menu, ArrayList<String> list) throws Exception{
		
		if(StringUtils.isEmpty(menu.getMN_MAINKEY())) {
			menu = Component.getData("Menu.AMN_getDataByKey",menu);
		}
		
		Menu MainMenu = Component.getData("Menu.get_Maindata",menu.getMN_MAINKEY());
		
		if(MainMenu != null && MainMenu.getMN_LEV() > 1) {
			String filename = CommonService.setKeyno(MainMenu.getMN_KEYNO());
			list.add(filename);
			menuSearch(MainMenu,list);
		}
		return menu;
	}
	
	//폴더생성
//	public void createfolder(String path) throws Exception{
//		File file = new File(path);
//		if(!file.exists()) {
//			file.mkdirs();
//		}
//	}
		
	public void deleteFolder(String path) {
		if(!getDate().equals(path.substring(path.lastIndexOf("/")+1))) {
		    File folder = new File(path);
		    try {
		    	if(folder.exists()){
	                File[] folder_list = folder.listFiles(); //파일리스트 얻어오기
					for (int i = 0; i < folder_list.length; i++) {
					    if(folder_list[i].isFile()) {
					    	folder_list[i].delete();
					    }else {
					    	deleteFolder(folder_list[i].getPath()); //재귀함수호출
					    }
					    folder_list[i].delete();
					 }
				folder.delete(); //폴더 삭제
		      }
		   } catch (Exception e) {
				System.out.println("폴더 삭제 에러");
		   }
		}
    }
		
	private String getDate(){
		Date dt = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd"); 
		return sdf.format(dt).toString();
	}
	
	public String mainfolder(HttpServletRequest req) throws Exception {
		
		//현재메뉴 불러오기
		String propertiespath = SiteProperties.getString("FILE_PATH");
		String path = "";

		if(StringUtils.isNotEmpty((String)req.getAttribute("currentBn")) && StringUtils.isNotEmpty((String)req.getAttribute("currentMn"))) {
			//게시판 update 할 경우 파일들 move할 경우
			path += "board/"+ (String)req.getAttribute("currentMn")+ "/"; 
			path += (String)req.getAttribute("currentBn")+ "/";
		}else {
			//일반 첨부파일 업로드 할 경우
			path = FileUploadTools.SaveFolder(propertiespath);
		}
		
		FileCommonTools.createfolder(propertiespath + path);
		
		return path;
	}
	
	/**
	 * 첨부파일로 썸네일 저장하는 부분
	 * @param req
	 * @param BoardNotice
	 * @param fileSub
	 * @return
	 * @throws Exception
	 */
	@Transactional
	public FileSub searchThumbFileByAttachments(HttpServletRequest req, String thumbFilePath, FileSub fileSub) throws Exception {
		String FS_CHANGENM = fileSub.getFS_CHANGENM();
        String FS_EXT = fileSub.getFS_EXT();
        
        searchThumbFile(req, thumbFilePath, fileSub,FS_CHANGENM, FS_EXT);
        
        return fileSub;
	}
	
	/**
	 * 본문에서 이미지 태그 찾아서 썸네일 저장하는 부분
	 * @param req
	 * @param BoardNotice
	 * @param fileSub
	 * @return
	 * @throws Exception
	 */
	@Transactional
	public FileSub searchThumbFileByContent(HttpServletRequest req, FileSub fileSub, String imgPath, boolean urlCk) throws Exception {

		String FS_CHANGENM = imgPath.substring(imgPath.lastIndexOf("/")+1,imgPath.lastIndexOf("."));
		String FS_EXT = imgPath.substring(imgPath.lastIndexOf(".")+1);
		
		if(urlCk){
			//확장자 처리
			if(FS_EXT.indexOf("jpeg") != -1) {
				FS_EXT = FS_EXT.substring(0,4);
			}else {
				FS_EXT = FS_EXT.substring(0,3);
			}
			
			if(imgPath.indexOf("http") != -1) {	//태그에 http가 포함되어 있으면
				imgPath = saveImage(req,imgPath,FS_CHANGENM,FS_EXT);
			}
		}
		
		searchThumbFile(req, imgPath, fileSub, FS_CHANGENM, FS_EXT);
		
		return fileSub;
	}
	
	private void searchThumbFile(HttpServletRequest req, String path, FileSub fileSub, String FS_CHANGENM, String FS_EXT) throws Exception {
		String propertiespath = SiteProperties.getString("FILE_PATH"); 
		
		BufferedImage srcImg = ImageIO.read(new File(path));
						
		srcImg = searchThumbFileRotate(srcImg, path);
		
		// 썸네일의 너비와 높이 입니다. 
		int dw = 278, dh = 188; 
		// 원본 이미지의 너비와 높이 입니다. 
		int ow = srcImg.getWidth(); 
		int oh = srcImg.getHeight();
		// 원본 너비를 기준으로 하여 썸네일의 비율로 높이를 계산합니다. 
		int nw = ow; 
		int nh = (ow * dh) / dw;
		// 계산된 높이가 원본보다 높다면 crop이 안되므로 // 원본 높이를 기준으로 썸네일의 비율로 너비를 계산합니다. 
		if(nh > oh) { nw = (oh * dw) / dh; nh = oh; }
		
		// 계산된 크기로 원본이미지를 가운데에서 crop 합니다. 
		BufferedImage cropImg = Scalr.crop(srcImg, (ow-nw)/2, (oh-nh)/2, nw, nh);
		//crop된 이미지로 썸네일을 생성합니다.
		BufferedImage destImg = Scalr.resize(cropImg, dw, dh);
		
		String Menufolder = mainfolder(req);
		fileSub.setFS_FOLDER(Menufolder);
		String thumbName = FS_CHANGENM+"_thumb";
		String filePath = propertiespath +fileSub.getFS_FOLDER()+ thumbName + "."+ FS_EXT;
		File thumFile = new File(filePath);
		
		//파일생성
		ImageIO.write(destImg, FS_EXT.toUpperCase(), thumFile);
		
		//서브 추가
		fileSub.setFS_ORINM(thumbName+"."+FS_EXT);
		fileSub.setFS_CHANGENM(thumbName);
		fileSub.setFS_EXT(FS_EXT);
		fileSub.IS_RESIZE().RESIZE_WIDTH(dw).RESIZE_HEIGHT(dh);
		fileSub.setFS_FILE_SIZE(Integer.toString((int)thumFile.length()));
		fileSub.setFS_ORIWIDTH(dw);
		fileSub.setFS_ORIHEIGHT(dh);	
	}
	
	private BufferedImage searchThumbFileRotate(BufferedImage srcImg, String path) throws Exception {
	    int orientation = 1; // 회전정보, 1. 0도, 3. 180도, 6. 270도, 8. 90도 회전한 정보
	    int width = 0; // 이미지의 가로폭
	    int height = 0; // 이미지의 세로높이

	    File imageFile = new File(path);
	    Metadata metadata; 
	    Directory directory; 
	    JpegDirectory jpegDirectory; 

	    try {
	        metadata = ImageMetadataReader.readMetadata(imageFile); // 이미지 메타 데이터 객체
	        directory = metadata.getFirstDirectoryOfType(ExifIFD0Directory.class); // 이미지의 Exif 데이터를 읽기 위한 객체
	        jpegDirectory = metadata.getFirstDirectoryOfType(JpegDirectory.class); // JPG 이미지 정보를 읽기 위한 객체
	        if (directory != null) {
	            orientation = directory.getInt(ExifIFD0Directory.TAG_ORIENTATION); // 회전정보
	        }

	    } catch (Exception e) {
	        orientation = 1;
	    }

	    // 회전 시킨다.
	    switch (orientation) {
	        case 6: // 이미지 회전값이 270 기운 경우 (왼쪽으로 90 기운 경우)
	            srcImg = Scalr.rotate(srcImg, Scalr.Rotation.CW_90); 
	            break;
	        case 1: // @details 이미지 회전값이 0인경우 ( 정방향 )
	            break;
	        case 3: // 이미지 회전값이 180 기운 경우
	            srcImg = Scalr.rotate(srcImg, Scalr.Rotation.CW_180);  
	            break;
	        case 8: // 이미지 회전값이 90 기운 경우
	            srcImg = Scalr.rotate(srcImg, Scalr.Rotation.CW_270);    
	            break;

	        default:
	            orientation = 1;
	            break;
	    }

	    return srcImg;
	}

	//url 이미지 저장
	public String saveImage(HttpServletRequest req, String imgurl, String name, String ext) throws Exception{
		String propertiespath = SiteProperties.getString("FILE_PATH");
		String folderpath = mainfolder(req);
		URL url = new URL(imgurl);
		String result = null;
	
		try (InputStream in = url.openStream();
			 OutputStream out = new FileOutputStream(propertiespath +folderpath+ name + "." + ext);
			 ){
			  while(true){
                //이미지를 읽어온다.
                int data = in.read();
                if(data == -1){
                    break;
                }
                //이미지를 쓴다.
                out.write(data);
             }
		  	result =  propertiespath+folderpath+ name + "." + ext;
		}catch(Exception e){
			System.out.println("url 이미지 저장 에러");
		}
		return result;
	}
	
	
//  @Scheduled(fixedRate=100000)   //테스트용 10초 주기
	@Scheduled(cron="0 0 3 * * ?")  
	public void tempDelete() throws Exception{
		if(isStartServlet) {
			String propertiespath = SiteProperties.getString("FILE_PATH");
			Tempdeletefolder(propertiespath+"board/temp/");
		}
    }
	
	
	//temp 폴더 삭제 
	public void Tempdeletefolder(String realpath)  throws Exception{
		String path = realpath;
	    deleteFolder(path);
	}
	
}
