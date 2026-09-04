//package com.tx.common.file.storage.local;
//
//import java.awt.Graphics;
//import java.awt.Image;
//import java.awt.image.BufferedImage;
//import java.io.File;
//import java.io.FileInputStream;
//import java.io.FileNotFoundException;
//import java.io.FileOutputStream;
//import java.io.IOException;
//import java.util.HashMap;
//import java.util.List;
//import java.util.zip.ZipEntry;
//import java.util.zip.ZipOutputStream;
//
//import javax.imageio.ImageIO;
//import javax.servlet.ServletContext;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpSession;
//
//import org.apache.commons.io.FileUtils;
//import org.apache.commons.io.FilenameUtils;
//import org.apache.commons.lang3.StringUtils;
//import org.jcodec.api.FrameGrab;
//import org.jcodec.api.JCodecException;
//import org.jcodec.common.DemuxerTrack;
//import org.jcodec.common.NIOUtils;
//import org.jcodec.common.SeekableByteChannel;
//import org.jcodec.common.model.Picture;
//import org.jcodec.containers.mp4.demuxer.MP4Demuxer;
//import org.jcodec.scale.AWTUtil;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.web.context.WebApplicationContext;
//import org.springframework.web.context.request.RequestContextHolder;
//import org.springframework.web.context.request.ServletRequestAttributes;
//import org.springframework.web.context.support.WebApplicationContextUtils;
//import org.springframework.web.multipart.MultipartFile;
//
//import com.tx.common.config.SettingData;
//import com.tx.common.config.tld.SiteProperties;
//import com.tx.common.file.CMYKConverter;
//import com.tx.common.file.FileManageTools;
//import com.tx.common.file.dto.FileSub;
//import com.tx.common.storage.service.StorageSelector;
//import com.tx.common.security.aes.AES256Cipher;
//
//public class LocalFileService {
//
//	@Autowired FileManageTools FileManageTools;
//
//	public void create(String filePath, FileSub fsVO, FileSub FileSub) throws Exception {
//		// TODO Auto-generated method stub
//		
//		if( StorageSelector.isImageFile(filePath) ){
//			
//			Image imgSrc = ImageIO.read(new File(filePath));
//			FileSub.setFS_ORIWIDTH(imgSrc.getWidth(null));
//			FileSub.setFS_ORIHEIGHT(imgSrc.getHeight(null));
//			
//			/** 이미지 리사이즈  */
//			if( fsVO.getIS_RESIZE() ){
//				ImgResize(filePath, filePath, FileSub.getFS_EXT(), fsVO.getRESIZE_WIDTH(), fsVO.getRESIZE_HEIGHT() );
//			}
//			
//			/** 이미지 썸네일 생성(리사이즈 기본)  */
//			if( fsVO.getIS_MAKE_THUMBNAIL() ){
//				
////				String thumbFileName = filePath.substring(filePath.lastIndexOf("/")+1,filePath.lastIndexOf(".")) +"_thumbnail";
////				String uploadPath = filePath.substring(0,filePath.lastIndexOf("/"));
////				String thumbFilePath = uploadPath + FilenameUtils.getName( thumbFileName + "." + FileSub.getFS_EXT());
////				int thumbWidth = fsVO.getTHUMB_WIDTH();
////				int thumbHeight = fsVO.getTHUMB_HEIGHT();
////				Image resizedImg = ImgResize(filePath, thumbFilePath, FileSub.getFS_EXT(), thumbWidth, thumbHeight);
////				if( resizedImg != null ){
////					FileSub.setFS_THUMBNAIL(thumbFileName);
////				}
//			}
//		}else if (StorageSelector.isVideoFile(filePath)){
//			if( fsVO.getIS_MAKE_MOVIE_THUMBNAIL() ){
//				String thumbFileName = filePath.substring(filePath.lastIndexOf("/")+1,filePath.lastIndexOf(".")) +"_thumbnail";
//				String uploadPath = filePath.substring(0,filePath.lastIndexOf("/"));
//				String thumbFilePath = uploadPath + FilenameUtils.getName( thumbFileName + "." + SettingData.DEFAULT_VIDEO_IMG_EXT);
//				if(VideoImgResize(new File(filePath), thumbFilePath, SettingData.DEFAULT_VIDEO_IMG_EXT, SettingData.DEFAULT_VIDEO_IMG_WIDTH, SettingData.DEFAULT_VIDEO_IMG_HEIGHT)){
//					FileSub.setFS_THUMBNAIL(thumbFileName);
//				}
//			}
//		}else{
//			FileSub.setFS_ORIWIDTH(0);
//			FileSub.setFS_ORIHEIGHT(0);
//			FileSub.setFS_THUMBNAIL(null);
//		}
//	}
//	
//	public void createBufferedFile(String filePath, FileSub FileSub) throws Exception {
//		// TODO Auto-generated method stub
//		
//		if( StorageSelector.isImageFile(filePath) ){
//			
//			Image imgSrc = ImageIO.read(new File(filePath));
//			FileSub.setFS_ORIWIDTH(imgSrc.getWidth(null));
//			FileSub.setFS_ORIHEIGHT(imgSrc.getHeight(null));
//			
//		}else{
//			FileSub.setFS_ORIWIDTH(0);
//			FileSub.setFS_ORIHEIGHT(0);
//			FileSub.setFS_THUMBNAIL(null);
//		}
//	}
//	
//	public void getImgPath(List<HashMap<String, Object>> boardNoticeDataList, String requestName, String responseName) {
//		// TODO Auto-generated method stub
//		for(HashMap<String, Object> boardNotice : boardNoticeDataList){
//			
//			String THUMBNAIL_PATH = (String)boardNotice.get(requestName);
//			
//			String thumbnail = "";
//			
//			if(StringUtils.isNotEmpty(THUMBNAIL_PATH)){
//				try {
//					thumbnail = "/common/file.do?file=" + AES256Cipher.encode(THUMBNAIL_PATH);
//				} catch (Exception e) {
//					// TODO Auto-generated catch block
//					System.out.println("#LocalFileService getImgPath :: " + e.getMessage());
//				}
//			}
//			boardNotice.put(responseName, thumbnail);
//		}
//	}
//	
//	public void getImgPath2(List<FileSub> fileSubList) {
//		// TODO Auto-generated method stub
//		for(FileSub fileSub : fileSubList){
//			
//			String name = StringUtils.isNotEmpty(fileSub.getFS_THUMBNAIL()) ? fileSub.getFS_THUMBNAIL() : fileSub.getFS_CHANGENM(); 
//			
//			String fullPath = "/resources/img/upload/" + fileSub.getFS_FOLDER() + name + "." + fileSub.getFS_EXT();
//			fileSub.setFS_PUBLIC_PATH(fullPath);
//			
//		}
//	}
//	
//	public String getImgPathString(String filePath) {
//		
//		if(StringUtils.isNotEmpty(filePath)){
//			try {
//				filePath = "/common/file.do?file=" + AES256Cipher.encode(filePath);
//			} catch (Exception e) {
//				// TODO Auto-generated catch block
//				System.out.println("#LocalFileService getImgPath :: " + e.getMessage());
//			}
//		}
//		
//		return filePath;
//	}
//
//	public void getImgPath(HashMap<String, Object> map, String columName) {
//		// TODO Auto-generated method stub
//		String THUMBNAIL_PATH = (String) map.get(columName+"_PATH");
//		
//		String thumbnail = "";
//		
//		if(StringUtils.isNotBlank(THUMBNAIL_PATH)){
//			try {
//				thumbnail = "/common/file.do?file=" + AES256Cipher.encode(THUMBNAIL_PATH);
//			} catch (Exception e) {
//				// TODO Auto-generated catch block
//				System.out.println("#LocalFileService getImgPath :: " + e.getMessage());
//			}
//		}
//		map.put(columName+"_PUBLIC_PATH", thumbnail);
//	}
//	
//	public String fileCopy(FileSub fileSub, String fS_CHANGENM) throws Exception {
//		
//		String propertiespath = SiteProperties.getString("FILE_PATH");
//		
//		//확장자
//		String FS_EXT = fileSub.getFS_EXT();
//		
//		String beforeFilePath = propertiespath + fileSub.getFS_FOLDER() + FilenameUtils.getName(fileSub.getFS_CHANGENM() + "." + FS_EXT); 
//		
//		//파일사이즈
//		String FS_SIZE = "";
//		
//		//썸네일 이름
//		String thumbnail = "";
//		
//		/** 경로 설정 */
//		String uploadPath = propertiespath + fileSub.getFS_FOLDER();
//	
//		/** 파일명 변환 후 저장*/
//		String filePath = uploadPath + FilenameUtils.getName(fS_CHANGENM + "." + FS_EXT);
//		
//		File beforeFile = new File(beforeFilePath);
//		
//		File file = new File(filePath);
//		
//		FileUtils.copyFile(beforeFile, file);
//		
//		/** 사이즈 취득 */
//		FS_SIZE = file.length()+"";
//		
//		fileSub.setFS_FILE_SIZE(FS_SIZE);
//		fileSub.setFS_EXT(FS_EXT);
//		fileSub.setFS_THUMBNAIL(thumbnail);
//		
//		return filePath;
//		
//	}
//	
//	public void thumbnail(FileSub fileSub, String filePath, int width, int height) throws Exception {
//		
//		String propertiespath = SiteProperties.getString("FILE_PATH");
// 		String thumbnail = fileSub.getFS_CHANGENM() +"_thumbnail";
// 		String thumbFilePath = propertiespath + fileSub.getFS_FOLDER() + FilenameUtils.getName(thumbnail + "." + fileSub.getFS_EXT());
// 		
//		ImgResize(filePath, thumbFilePath, fileSub.getFS_EXT(), width, height);
//		
//		fileSub.setFS_THUMBNAIL(thumbnail);
//		
//	}
//	
//	public String zip(List<FileSub> fsVO, String propertiespath, String folder, String zipName) {
//		// TODO Auto-generated method stub
//		
//		String zipPath = "";
//		
//		byte[] buf = new byte[1024];
//		/** 원본 업로드 */
//		String uploadPath = propertiespath + folder;
//		/**알집 하나만**/
//		String attachments = uploadPath+ zipName;
//		
//		
//		try( ZipOutputStream out = new ZipOutputStream(new FileOutputStream(attachments));) {
//    		if(fsVO != null) {
//    			for (int i=0; i<fsVO.size(); i++) {
//    				String Path = (fsVO.get(i).getFS_FOLDER()+ fsVO.get(i).getFS_CHANGENM()+"." +fsVO.get(i).getFS_EXT());
//    				
//    				try( FileInputStream in = new FileInputStream(propertiespath + Path);) {
//	                    String fileName = fsVO.get(i).getFS_ORINM();
//	                    
//	                    ZipEntry ze = new ZipEntry(fileName);
//	                    out.putNextEntry(ze);
//	                    int len;
//	                    while ((len = in.read(buf)) > 0) {
//	                        out.write(buf, 0, len);
//	                    }
//	                    out.closeEntry();
//					} catch (Exception e) {
//						System.out.println("압축파일에러");
//					}
//                }
//    		}
//    		zipPath = folder+zipName;
//       } catch (IOException e) {
//    	   System.out.println("ZipOutputStream 에러");
//    	   System.out.println(e);
//       }
//		
//		return zipPath;
//	}
//	
//	public String favicon(MultipartFile file, String tiles) {
//		// TODO Auto-generated method stub
//		//프로퍼티 경로 불러오기
//		String propertiespath = SiteProperties.getString("RESOURCE_PATH") + "favicon/";
//		
//		FileManageTools.checkFolder(propertiespath);
//
//		propertiespath += tiles;
//		
//		FileManageTools.checkFolder(propertiespath);
//		
//		String filePath = propertiespath + "/favicon.ico";
//		
//		try {
//			file.transferTo(new File(filePath));
//			
//			
//		} catch (Exception e) {
//				System.out.println("파일 저장중 에러!!");
//				return "";
//		}
//		
//		return filePath.substring(filePath.indexOf("/resources"));
//
//	}
//	
//	
//	/**
// 	 * 비디오 파일 썸네일 추출
// 	 * @param Filepath
// 	 * @throws Exception
// 	 */
// 	private boolean VideoImgResize(File newFile, String filePath, String EXT, int width, int height)throws Exception{
// 	    
// 	    boolean status = false;
// 	    
// 	    double frameNumber = 0d;
// 	    String fileName = newFile.getAbsolutePath();
//
// 	    try {
// 	       SeekableByteChannel bc = NIOUtils.readableFileChannel(newFile);
// 	       MP4Demuxer dm = new MP4Demuxer(bc);
// 	       DemuxerTrack vt = dm.getVideoTrack();
// 	       frameNumber = vt.getMeta().getTotalDuration() / 5.0;
// 	   } catch (FileNotFoundException e1) {
// 	       System.out.println("동영상 썸네일 에러 : 파일 못찾음");
// 	   } catch (Exception e) {
// 	       System.out.println("동영상 썸네일 에러 : 에러!!");
// 	   }
//
// 	    try {
//
// 	       Picture frame = FrameGrab.getNativeFrame(new File(fileName), frameNumber);
// 	       // 새 이미지  저장하기
// 	       BufferedImage newImage = AWTUtil.toBufferedImage(frame);
// 	       
// 	       ImageIO.write(newImage, EXT, new File(filePath));
// 	       
// 	       status = true;
//
// 	   } catch (IOException e) {
// 	       System.out.println("동영상 썸네일 에러 : 입출력 에러!!");
// 	   } catch (JCodecException e) {
// 	       System.out.println("동영상 썸네일 에러 : Jcodec 에러!!");
// 	   } catch (Exception e){
// 	       System.out.println("동영상 썸네일 에러 : 에러!!");
// 	   }
// 	   
// 	   return status;
// 	    
// 	}
// 	
// 	/**
//	 * 업로드 파일 삭제
//	 * @param deletefile
// 	 * @throws Exception 
//	 */
//	public void delete(FileSub fileSub) throws Exception {
//		
//		String uploadPath = SiteProperties.getString("FILE_PATH");
//		
//		if(fileSub != null){
//			FileManageTools.deleteFolder(uploadPath + fileSub.getFS_FOLDER() + FilenameUtils.getName(fileSub.getFS_CHANGENM() + "." + fileSub.getFS_EXT()));
//			//썸네일 이미지 유무체크 후 물리삭제 진행
//			if( StringUtils.isNotEmpty(fileSub.getFS_THUMBNAIL()) ){
//				FileManageTools.deleteFolder(uploadPath+fileSub.getFS_FOLDER() + FilenameUtils.getName(fileSub.getFS_THUMBNAIL() + "." + fileSub.getFS_EXT()));           
//			}
//		}
//	}
//	
// 	/**
// 	 * 이미지 파일 사이즈 변경
// 	 * @param Filepath
// 	 * @throws Exception
// 	 */
// 	public static Image ImgResize(String Filepath, String newFilepath, String EXT, int width, int height)throws Exception{
// 		
// 		// 원본 이미지 가져오기
//		Image imgSrc = null;
//		try{
//			imgSrc = ImageIO.read(new File(Filepath));
//		}catch(Exception e){
//			
//			CMYKConverter CMYKConverter = (CMYKConverter) getBean("CMYKConverter");
//			try{
//				imgSrc =  CMYKConverter.readImage(new File(Filepath));
//			}catch(Exception e2){
//				System.out.println("리사이징을 위한 이미지 읽어오기 에러 : 파일 아님");
//				return null;
//			}
//		}
//		
//		if( imgSrc == null ){
//			System.out.println("리사이징을 위한 이미지 읽어오기 에러 : 이미지파일 아님");
//			return null;
//		}
//		
//		if(height == 0){
//			height=width * imgSrc.getHeight(null) / imgSrc.getWidth(null);
//		}
//		
//        // 이미지 리사이즈
//        // Image.SCALE_DEFAULT : 기본 이미지 스케일링 알고리즘 사용
//        // Image.SCALE_FAST    : 이미지 부드러움보다 속도 우선
//        // Image.SCALE_SMOOTH  : 속도보다 이미지 부드러움을 우선
//        // Image.SCALE_AREA_AVERAGING  : 평균 알고리즘 사용
//        Image resizeImage = imgSrc.getScaledInstance(width, height, Image.SCALE_SMOOTH);
//
//        // 새 이미지  저장하기
//        BufferedImage newImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
//        Graphics g = newImage.getGraphics();
//        g.drawImage(resizeImage, 0, 0, null);
//        g.dispose();
//        ImageIO.write(newImage, EXT, new File(newFilepath));
// 		
//        return resizeImage;
// 	}
// 	
// 	
// 	private static Object getBean(String beanName) throws Exception {
//		
//		//현재 요청중인 thread local의 HttpServletRequest 객체 가져오기
//		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
//		 
//		//HttpSession 객체 가져오기
//		HttpSession session = request.getSession();
//		 
//		//ServletContext 객체 가져오기
//		ServletContext conext = session.getServletContext();
//		 
//		//Spring Context 가져오기
//		WebApplicationContext wContext = WebApplicationContextUtils.getWebApplicationContext(conext);
//		
//		return wContext.getBean(beanName);
//		
//	}
//
//	
//
//	
//
//	
//
//	
//
//	
//
//
//	
//	
//}
