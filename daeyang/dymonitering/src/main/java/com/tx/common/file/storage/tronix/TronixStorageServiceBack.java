//package com.tx.common.file.storage.tronix;
//
//import java.awt.Image;
//import java.io.BufferedReader;
//import java.io.File;
//import java.io.FileInputStream;
//import java.io.IOException;
//import java.io.InputStream;
//import java.io.InputStreamReader;
//import java.io.OutputStream;
//import java.io.OutputStreamWriter;
//import java.io.PrintWriter;
//import java.net.HttpURLConnection;
//import java.net.MalformedURLException;
//import java.net.URL;
//import java.net.URLConnection;
//import java.util.HashMap;
//import java.util.List;
//
//import javax.imageio.ImageIO;
//
//import org.apache.commons.io.FileUtils;
//import org.apache.commons.lang3.StringUtils;
//import org.apache.tika.Tika;
//import org.aspectj.util.FileUtil;
//import org.springframework.web.multipart.MultipartFile;
//
//import com.tx.common.config.SettingData;
//import com.tx.common.config.tld.SiteProperties;
//import com.tx.common.file.dto.FileSub;
//import com.tx.common.storage.service.StorageSelector;
//import com.tx.common.security.aes.AES256Cipher;
//
//
//public class TronixStorageServiceBack {
//
//	
//	private String CRLF = "\r\n"; // Line separator required by multipart/form-data. 
//	private String charset = "UTF-8";
//	private String projectName = null;
//	private String url = null;
//	private String secretKey = null;
//	
//	public TronixStorageServiceBack(){
//		projectName = SiteProperties.getConfigProperties("cms.title");
//		url = SiteProperties.getConfigProperties("cms.storage.url");
//		secretKey = SiteProperties.getConfigProperties("cms.storage.secretKey");
//	}
//	
//	public String create(String filePath, String type) throws MalformedURLException, IOException{
//		return create(filePath, type, false, false, 0, 0);
//	}
//	
//	public String create(String filePath, String type, String folderName) throws MalformedURLException, IOException{
//		return create(filePath, type, false, false, 0, 0, folderName);	//publicPath 대신에 폴더 경로들어감
//	}
//	
//	public String create(String filePath, String type, boolean isResize,boolean isVideoThumbnail, int width, int height) throws MalformedURLException, IOException{
//		return create(filePath, type, isResize, isVideoThumbnail, width, height, null);
//	}
//	
//	public String create(String filePath, String type, boolean isResize,boolean isVideoThumbnail, int width, int height, String publicPath) throws MalformedURLException, IOException {
//		
//		String fullUrl = url + "/upload.do";
//		
//		String boundary = Long.toHexString(System.currentTimeMillis()); // Just generate some unique random value.
//		
//		String fileName = null;
//		
//		URLConnection connection = new URL(fullUrl).openConnection();
//		connection.setDoOutput(true);
//		connection.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);
//		
//		File newFile = null;
//		if("copy".equals(type)){
//			URL url = new URL(filePath);
//			String propertiespath = SiteProperties.getString("FILE_PATH");
//			
//			String urlPath = filePathByPublicPath(filePath);
//			
//			fileName = urlPath.substring(urlPath.lastIndexOf("/")+1);
//			
//			newFile = new File(propertiespath + urlPath);
//			FileUtils.copyURLToFile(url, newFile);
//			
//			publicPath = filePath;
//			
//		}else{
//			fileName = filePath.substring(filePath.lastIndexOf("/")+1);
//			
//			newFile = new File(filePath);
//		}
//		
//			
//		try (
//		    OutputStream output = connection.getOutputStream();
//		    PrintWriter writer = new PrintWriter(new OutputStreamWriter(output, charset), true);
//			InputStream input = new FileInputStream(newFile);
//		) {
//			
//			// Send normal param.
//			
//			writerAppend(writer,boundary,"projectName",projectName);
//			
//		    if(isResize) writerAppend(writer,boundary,"isResize","Y");
//		    
//		    if(isVideoThumbnail) writerAppend(writer,boundary,"isVideoThumbnail","Y");
//		    
//		    if(width != 0 ) writerAppend(writer,boundary,"width",width+"");
//		    
//		    if(height != 0 ) writerAppend(writer,boundary,"height",height+"");
//		    
//		    if(publicPath !=  null ) writerAppend(writer,boundary,"publicPath",publicPath);
//		    
//		    if(type !=  null ) writerAppend(writer,boundary,"type",type);
//		    
//		    
//		    writerAppendFile(writer,boundary,fileName,input,output);
//		    
//		    output.flush(); // Important before continuing with writer!
//		    writer.append(CRLF).flush(); // CRLF is important! It indicates end of boundary.
//
//		    // End of multipart/form-data.
//		    writer.append("--" + boundary + "--").append(CRLF).flush();
//		} catch (IOException e) {
//			System.out.println("클라우드 파일 전송 에러");
//			System.out.println(e.getMessage());
//		}
//
//		// Request is lazily fired whenever you need to obtain information about response.
//		int responseCode = ((HttpURLConnection) connection).getResponseCode();
//		System.out.println("responseCode :: " + responseCode); // Should be 200
//		
//		if("copy".equals(type)) newFile.delete();
//		
//		if(responseCode == 200) return getResponse(connection);
//		
//		return null;
//		
//	}
//	
//	public String create(MultipartFile file, String type, boolean isResize,boolean isVideoThumbnail, int width, int height) throws MalformedURLException, IOException {
//		
//		String fullUrl = url + "/upload.do";
//		
//		String boundary = Long.toHexString(System.currentTimeMillis()); // Just generate some unique random value.
//		
//		String fileName = file.getOriginalFilename();
//		
//		URLConnection connection = new URL(fullUrl).openConnection();
//		connection.setDoOutput(true);
//		connection.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);
//		
//		try (
//				OutputStream output = connection.getOutputStream();
//				PrintWriter writer = new PrintWriter(new OutputStreamWriter(output, charset), true);
//				) {
//			
//			// Send normal param.
//			
//			writerAppend(writer,boundary,"projectName",projectName);
//			
//			if(isResize) writerAppend(writer,boundary,"isResize","Y");
//			
//			if(isVideoThumbnail) writerAppend(writer,boundary,"isVideoThumbnail","Y");
//			
//			if(width != 0 ) writerAppend(writer,boundary,"width",width+"");
//			
//			if(height != 0 ) writerAppend(writer,boundary,"height",height+"");
//			
//			if(type !=  null ) writerAppend(writer,boundary,"type",type);
//			
//			writerAppendFile(writer,boundary,fileName,file.getInputStream(),output);
//			
//			output.flush(); // Important before continuing with writer!
//			writer.append(CRLF).flush(); // CRLF is important! It indicates end of boundary.
//			
//			// End of multipart/form-data.
//			writer.append("--" + boundary + "--").append(CRLF).flush();
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			System.out.println("클라우드 파일 전송 에러");
//			System.out.println(e.getMessage());
//		}
//		
//		// Request is lazily fired whenever you need to obtain information about response.
//		int responseCode = ((HttpURLConnection) connection).getResponseCode();
//		System.out.println("responseCode :: " + responseCode); // Should be 200
//		
//		if(responseCode == 200) return getResponse(connection);
//		
//		return null;
//		
//	}
//	
//	private String getResponse(URLConnection connection) throws IOException {
//		// TODO Auto-generated method stub
//		InputStream is =  connection.getInputStream();
//		
//		BufferedReader rd = new BufferedReader(new InputStreamReader(is));
//		String line;
//		StringBuffer response = new StringBuffer(); 
//		while((line = rd.readLine()) != null) {
//			response.append(line);
//		}
//		rd.close();
//		
//		return response.toString();
//	}
//
//	private void writerAppend(PrintWriter writer, String boundary, String name, String value) {
//		// TODO Auto-generated method stub
//		writer.append("--" + boundary).append(CRLF);
//	    writer.append("Content-Disposition: form-data; name=\""+name+"\"").append(CRLF);
//	    writer.append("Content-Type: text/plain; charset=" + charset).append(CRLF);
//	    writer.append(CRLF).append(value).append(CRLF).flush();
//	}
//	
//	private void writerAppendFile(PrintWriter writer, String boundary, String fileName, InputStream input,
//			OutputStream output) throws IOException {
//		// // Send binary file.
//		writer.append("--" + boundary).append(CRLF);
//		writer.append("Content-Disposition: form-data; name=\"file\"; filename=\"" + fileName + "\"").append(CRLF);
//		writer.append("Content-Type: " + URLConnection.guessContentTypeFromName(fileName)).append(CRLF);
//		writer.append("Content-Transfer-Encoding: binary").append(CRLF);
//		writer.append(CRLF).flush();
//		
//		FileUtil.copyStream(input, output);
//		
//	}
//
//	public void delete(String deletePublicPath) throws MalformedURLException, IOException {
//		
//		String fullUrl = url + "/delete.do";
//		
//		String boundary = Long.toHexString(System.currentTimeMillis()); // Just generate some unique random value.
//		
//		URLConnection connection = new URL(fullUrl).openConnection();
//		connection.setDoOutput(true);
//		connection.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);
//		
//		try (
//				OutputStream output = connection.getOutputStream();
//				PrintWriter writer = new PrintWriter(new OutputStreamWriter(output, charset), true);
//				) {
//			
//			// Send normal param.
//			writerAppend(writer,boundary,"projectName",projectName);
//			
//			if(deletePublicPath != null) writerAppend(writer,boundary,"deletePublicPath",deletePublicPath);
//			
//			output.flush(); // Important before continuing with writer!
//			writer.flush(); // CRLF is important! It indicates end of boundary.
//			
//			// End of multipart/form-data.
//			writer.append("--" + boundary + "--").append(CRLF).flush();
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			System.out.println("클라우드 파일 전송 에러");
//			System.out.println(e.getMessage());
//		}
//		
//		// Request is lazily fired whenever you need to obtain information about response.
//		int responseCode = ((HttpURLConnection) connection).getResponseCode();
//		System.out.println("responseCode :: " + responseCode); // Should be 200
//		
//		if(responseCode == 200){
//			InputStream is =  connection.getInputStream();
//			
//			BufferedReader rd = new BufferedReader(new InputStreamReader(is));
//			String line;
//			StringBuffer response = new StringBuffer(); 
//			while((line = rd.readLine()) != null) {
//				response.append(line);
//			}
//			rd.close();
//			
//		}
//		
//	}
//	
//	public void getImgPath(List<HashMap<String, Object>> boardNoticeDataList, String requestName, String responseName) {
//		// TODO Auto-generated method stub
//		
//		for(HashMap<String, Object> boardNotice : boardNoticeDataList){
//			
//			String FS_PUBLIC_PATH = (String)boardNotice.get(requestName);
//			
//			
//			String path = "";
//			
//			if(StringUtils.isNotBlank(FS_PUBLIC_PATH)){
//				try {
//					FS_PUBLIC_PATH = FS_PUBLIC_PATH.substring(FS_PUBLIC_PATH.indexOf(projectName));
//					
//					path = url + "/get.do?file=" + AES256Cipher.encode(FS_PUBLIC_PATH,secretKey);
//				} catch (Exception e) {
//					// TODO Auto-generated catch block
//					System.out.println("#TronixStorageService getImgPath :: " + e.getMessage());
//				}
//			}
//			boardNotice.put(responseName, path);
//		}
//	}
//	
//	public void getImgPath(HashMap<String, Object> map, String columName) {
//		// TODO Auto-generated method stub
//		String FS_PUBLIC_PATH = (String) map.get(columName+"_PUBLIC_PATH");
//		
//		String path = "";
//		
//		if(StringUtils.isNotBlank(FS_PUBLIC_PATH)){
//			try {
//				FS_PUBLIC_PATH = FS_PUBLIC_PATH.substring(FS_PUBLIC_PATH.indexOf(projectName));
//				
//				path = url + "/get.do?file=" + AES256Cipher.encode(FS_PUBLIC_PATH,secretKey);
//			} catch (Exception e) {
//				// TODO Auto-generated catch block
//				System.out.println("#TronixStorageService getImgPath :: " + e.getMessage());
//			}
//		}
//		map.put(columName+"_PUBLIC_PATH", path);
//	}
//	
//	public void getImgPath2(List<FileSub> fileSubList) {
//		// TODO Auto-generated method stub
//		for(FileSub fileSub : fileSubList){
//			String name = StringUtils.isNotEmpty(fileSub.getFS_THUMBNAIL()) ? fileSub.getFS_THUMBNAIL() : fileSub.getFS_PUBLIC_PATH(); 
//			fileSub.setFS_PUBLIC_PATH(name);
//			
//		}
//	}
//	
//	public String getImgPathString(String filePath) {
//		
//		if(StringUtils.isNotBlank(filePath)){
//			try {
//				filePath = filePath.substring(filePath.indexOf(projectName));
//				
//				filePath = url + "/get.do?file=" + AES256Cipher.encode(filePath,secretKey);
//			} catch (Exception e) {
//				// TODO Auto-generated catch block
//				System.out.println("#TronixStorageService getImgPath :: " + e.getMessage());
//			}
//		}
//		
//		return filePath;
//	}
//
//	public void createFile(String filePath, FileSub fsVO, FileSub FileSub) throws MalformedURLException, IOException, Exception {
//		// TODO Auto-generated method stub
//		
//		File newFile = new File(filePath);
//		
//		String publicPath = "";
////		String thumbnail = "";
//		
//		if( StorageSelector.isImageFile(newFile) ){
//			
//			Image imgSrc = ImageIO.read(newFile);
//			FileSub.setFS_ORIWIDTH(imgSrc.getWidth(null));
//			FileSub.setFS_ORIHEIGHT(imgSrc.getHeight(null));
//			
//			/** 이미지 리사이즈  */
//			if( fsVO.getIS_RESIZE() ){
//				publicPath  = create(filePath,"create",true,false, fsVO.getRESIZE_WIDTH(), fsVO.getRESIZE_HEIGHT());
//			}else{
//				publicPath  = create(filePath,"create");
//			}
//			
//			/** 이미지 썸네일 생성(리사이즈 기본)  */
////			if( fsVO.getIS_MAKE_THUMBNAIL() ){
////				thumbnail  = create(filePath,"thumb",true,false, fsVO.getTHUMB_WIDTH(), fsVO.getTHUMB_HEIGHT(),publicPath);
////			}
//			
//		}else if (StorageSelector.isVideoFile(newFile)){
//			if( fsVO.getIS_MAKE_MOVIE_THUMBNAIL() ){
//				publicPath  = create(filePath,"create",false,true, SettingData.DEFAULT_VIDEO_IMG_WIDTH, SettingData.DEFAULT_VIDEO_IMG_HEIGHT);
//			}
//		}else{
//			publicPath  = create(filePath,"create");
//			FileSub.setFS_ORIWIDTH(0);
//			FileSub.setFS_ORIHEIGHT(0);
//		}
//		
//		if(StringUtils.isNotEmpty(FileSub.getFS_PUBLIC_PATH())){
//			delete(FileSub.getFS_PUBLIC_PATH());
//		}
//		if(StringUtils.isNotEmpty(FileSub.getFS_THUMBNAIL())){
//			delete(FileSub.getFS_THUMBNAIL());
//		}
//		
//		
//		FileSub.setFS_PUBLIC_PATH(publicPath);
////		FileSub.setFS_THUMBNAIL(thumbnail);
//		
//	}
//	
//	public void createBufferedFile(String filePath, FileSub FileSub) throws MalformedURLException, IOException, Exception {
//		// TODO Auto-generated method stub
//		
//		File newFile = new File(filePath);
//
//		String publicPath = "";
//		String thumbnail = "";
//		
//		if( StorageSelector.isImageFile(newFile) ){
//			
//			Image imgSrc = ImageIO.read(newFile);
//			FileSub.setFS_ORIWIDTH(imgSrc.getWidth(null));
//			FileSub.setFS_ORIHEIGHT(imgSrc.getHeight(null));
//			
//			/** 이미지 리사이즈  */
//			if( FileSub.getIS_RESIZE() ){
//				FileSub.setRESIZE_WIDTH(imgSrc.getWidth(null));
//				FileSub.setRESIZE_HEIGHT(imgSrc.getHeight(null));
//				publicPath  = create(filePath,"create",true,false, FileSub.getRESIZE_WIDTH(), FileSub.getRESIZE_HEIGHT());
//			}else{
//				publicPath  = create(filePath,"create");
//			}
//
//			/** 이미지 썸네일 생성(리사이즈 기본) */
//			if( FileSub.getIS_MAKE_THUMBNAIL() ){
//				FileSub.setTHUMB_WIDTH(SettingData.DEFAULT_IMG_RESIZE_WIDTH);
//				FileSub.setTHUMB_HEIGHT(SettingData.DEFAULT_IMG_RESIZE_HEIGHT);
//				thumbnail  = create(filePath,"thumb", false, false, FileSub.getTHUMB_WIDTH(), FileSub.getTHUMB_HEIGHT(), publicPath);
//			}
//			
//		}else{
//			FileSub.setFS_ORIWIDTH(0);
//			FileSub.setFS_ORIHEIGHT(0);
//			publicPath  = create(filePath,"create");
//		}
//
//		if(StringUtils.isNotEmpty(FileSub.getFS_PUBLIC_PATH())){
//			delete(FileSub.getFS_PUBLIC_PATH());
//		}
//		if(StringUtils.isNotEmpty(FileSub.getFS_THUMBNAIL())){
//			delete(FileSub.getFS_THUMBNAIL());
//		}
//		
//		FileSub.setFS_PUBLIC_PATH(publicPath);
//		FileSub.setFS_THUMBNAIL(thumbnail);
//		
//	}
//
//	public void createCopyFile(FileSub fileSub) throws MalformedURLException, IOException, Exception {
//		// TODO Auto-generated method stub
//		
//		String publicPath = "";
//		String thumbnail = "";
//		String FS_EXT = fileSub.getFS_EXT();
//		String FS_SIZE = fileSub.getFS_FILE_SIZE();
//
//		publicPath  = create(fileSub.getFS_PUBLIC_PATH(),"copy");
//		
//		/** 이미지 썸네일 생성(리사이즈 기본) */
//		if( fileSub.getIS_MAKE_THUMBNAIL() ){
//			fileSub.setTHUMB_WIDTH(SettingData.DEFAULT_IMG_RESIZE_WIDTH);
//			fileSub.setTHUMB_HEIGHT(SettingData.DEFAULT_IMG_RESIZE_HEIGHT);
//			thumbnail  = create(fileSub.getFS_THUMBNAIL(),"copy", false, false, fileSub.getTHUMB_WIDTH(), fileSub.getTHUMB_HEIGHT());
//		}
//		
//		fileSub.setFS_PUBLIC_PATH(publicPath);
//		fileSub.setFS_THUMBNAIL(thumbnail);
//		fileSub.setFS_FILE_SIZE(FS_SIZE);
//		fileSub.setFS_EXT(FS_EXT);
//		
//	}
//
//	/**
//	 * zip 파일 생성
//	 * @param fsVO
//	 * @return
//	 * @throws MalformedURLException
//	 * @throws IOException
//	 */
//	public String zip(List<FileSub> fsVO, String publicFolder) throws MalformedURLException, IOException {
//		// TODO Auto-generated method stub
//		
//		String fullUrl = url + "/zip.do";
//		
//		String boundary = Long.toHexString(System.currentTimeMillis()); // Just generate some unique random value.
//		
//		URLConnection connection = new URL(fullUrl).openConnection();
//		connection.setDoOutput(true);
//		connection.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);
//		
//		
//		try (
//		    OutputStream output = connection.getOutputStream();
//		    PrintWriter writer = new PrintWriter(new OutputStreamWriter(output, charset), true);
//		) {
//			
//			// Send normal param.
//			
//			if(publicFolder !=  null) writerAppend(writer,boundary,"publicFolder",publicFolder);	//게시물 같이 지정된 경로에 넣어야할 경우에 해당 경로 추가
//			writerAppend(writer,boundary,"projectName",projectName);
//
//			for(FileSub fs : fsVO){
//				writerAppend(writer,boundary,"files",fs.getFS_PUBLIC_PATH());
//				writerAppend(writer,boundary,"names",fs.getFS_ORINM());
//			}
//			
//			
//		    output.flush(); // Important before continuing with writer!
//		    writer.append(CRLF).flush(); // CRLF is important! It indicates end of boundary.
//
//		    // End of multipart/form-data.
//		    writer.append("--" + boundary + "--").append(CRLF).flush();
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			System.out.println("클라우드 zip 전송 에러");
//			System.out.println(e.getMessage());
//		}
//
//		// Request is lazily fired whenever you need to obtain information about response.
//		int responseCode = ((HttpURLConnection) connection).getResponseCode();
//		System.out.println("responseCode :: " + responseCode); // Should be 200
//		
//		if(responseCode == 200){
//			InputStream is =  connection.getInputStream();
//			
//			BufferedReader rd = new BufferedReader(new InputStreamReader(is));
//			String line;
//			StringBuffer response = new StringBuffer(); 
//			while((line = rd.readLine()) != null) {
//			 response.append(line);
//			}
//			rd.close();
//			
//			return response.toString();
//		}
//		
//		return null;
//	}
//
//	public String favicon(MultipartFile file, String tiles) {
//		// TODO Auto-generated method stub
//		return null;
//	}
//
//	
//	public String getMimeType(String rootFilePath, HashMap<String,Object> fileSub) throws Exception {
//		Tika tika = new Tika();
//		String mimetype = "";
//		String filePath = fileSub.get("FS_PUBLIC_PATH").toString();
//		
//		URL url = new URL(filePath);
//		String urlPath = filePathByPublicPath(filePath);
//		
//		File file = new File(rootFilePath + urlPath);
//		FileUtils.copyURLToFile(url, file);
//		
//		try {
//			mimetype = tika.detect(file);
//		} catch (Exception e) {
//			mimetype = null;
//		}
//    
//		file.delete();
//		
//		return mimetype;
//	}
//	
//	public String getFilePathByFileCopy(String rootFilePath, String filePath, boolean rootPathCk) throws Exception {
//		
//		URL url = new URL(filePath);
//		String urlPath = filePathByPublicPath(filePath);
//		
//		File file = new File(rootFilePath + urlPath);
//		FileUtils.copyURLToFile(url, file);
//		
//		if(rootPathCk){
//			return rootFilePath + urlPath;
//		}
//		
//		return urlPath;
//	}
//	
//	/**
//	 * publicPath 자르기
//	 * @param filePath
//	 * @return
//	 */
//	public String filePathByPublicPath(String filePath){
//		
//		String urlPath = filePath.substring(filePath.lastIndexOf(projectName));
//		urlPath = urlPath.substring(urlPath.indexOf("/")+1);
//		
//		return urlPath;
//	}
//	
//
//	
//}
