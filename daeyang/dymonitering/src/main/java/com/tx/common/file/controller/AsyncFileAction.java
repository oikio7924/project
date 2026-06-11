package com.tx.common.file.controller;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.tika.Tika;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.tx.common.file.FileUploadTools;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;

/**
 * @AsyncFileAction
 * 비동기 처리 - 파일정보 및 배치 처리 등 비동기 처리로 수행할 서블릿을 담당한다.
 * @author 신희원
 * @version 1.0
 * @since 2014-11-16
 */

@Controller
public class AsyncFileAction {
	
	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 파일업로드 툴*/
	@Autowired private FileUploadTools FileUploadTools;
  

	
	/*
	 * CKEDITOR 관련 업로드 메소드 - 기존 문화전당 소스 (유저 권한관리 작업 중이라 관련처리 임시삭제함)
	 */
	
	
	/**
	 * 파일 상위 키 갱신 처리
	 * @return
	 * @throws Exception
	 */
	public String getMultFileMainFilekey() throws Exception{
		return CommonService.getTableKey("FM"); //파일 상위정보 키 갱신
	}
	
	/**
	 * 파일 타입 체크 (이미지인지 PDF인지...)
	 * @param reg, 문자열 fileType ( ex "image" 나 "pdf" 등 )
	*/
	public boolean fileTypeChk( HttpServletRequest req, String[] fileType ){
		final MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) req;
		final Map<String, MultipartFile> files = multiRequest.getFileMap();
		Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
		
		while (itr.hasNext()){
			Entry<String, MultipartFile> entry = itr.next();
			MultipartFile file = entry.getValue();
			
			Tika tika = new Tika();
	    String mimetype = "";
			try {
				mimetype = tika.detect(file.getInputStream());
			} catch (IOException e) {
				System.err.println("isImageFile() ERROR");
			}
			
			String mimetypeLowerCase = mimetype.toLowerCase();
			for( String ft : fileType ){
				if( ft == null ) { ft = ""; }
				if( mimetypeLowerCase.indexOf(ft.toLowerCase()) >= 0 ){
					return true;
				}
				if( ft.equals("master") ){ // 파일 업로드 제한 X 권한
					System.out.println("#51 : 확장자 체크 예외처리 : fileType 'master' in " + req.getRequestURI());
					return true;
				}
			}
		}
		return false;
	}
	
	
	/**
	 * 네이버 스마트에디터2 파일 업로드
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping("/async/file_uploader_html5/insertAjax.do")
	@ResponseBody
	public String file_uploader_html5(HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		//파일정보     
	    String sFileInfo = "";     
	    
 	    String filename = request.getHeader("file-name");     
	    filename = URLDecoder.decode(filename, "utf-8");
	    
	    //파일 확장자     
	    String filename_ext = filename.substring(filename.lastIndexOf(".")+1);     
	    //확장자를소문자로 변경     
	    filename_ext = filename_ext.toLowerCase();           
	    //이미지 검증 배열변수     
	    String[] allow_file = {"jpg","png","bmp","gif"};
	   
	   
	    //돌리면서 확장자가 이미지인지      
	    int cnt = 0;     
	    for(int i=0; i < allow_file.length; i++)      
		   if(filename_ext.equals(allow_file[i])) cnt++;
	    
	    //이미지가 아님     
	    if(cnt == 0) {      
		   return "NOTALLOW_"+filename;
	    }else{     
		   //이미지이므로 신규 파일로 디렉토리 설정 및 업로드    
		   sFileInfo = FileUploadTools.FileUploadWithSMARTEDITOR(request,filename);

		   return sFileInfo;
	    }
	}
	
}
