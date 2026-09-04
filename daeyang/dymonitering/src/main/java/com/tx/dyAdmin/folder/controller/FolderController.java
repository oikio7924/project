package com.tx.dyAdmin.folder.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.file.FileDownloadTools;
import com.tx.common.file.FileUploadTools;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.admin.domain.dto.HomeManager;
import com.tx.dyAdmin.homepage.menu.dto.Menu;


@Controller
public class FolderController {
		
	/** 파일업로드 툴*/
	@Autowired private FileUploadTools FileUploadTools;
	/** 파일다운로드 툴*/
	@Autowired
	private FileDownloadTools FileDownloadTools;
	
	@Autowired
	private CommonService CommonService;
	
	@Autowired ComponentService Component;	

	@RequestMapping(value="/dyAdmin/homepage/webFolder.do")
	@CheckActivityHistory(desc="웹폴더관리 페이지 방문")
	public ModelAndView folderManage(HttpServletRequest req
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/folder/pra_folder_list.adm");
		String MN_HOMEDIV_C = CommonService.getDefaultSiteKey(req);
		HomeManager hm = Component.getData("HomeManager.HM_getDataByHOMEDIV_C", MN_HOMEDIV_C);
		mv.addObject("homePage", hm.getHM_SITE_PATH());
		return mv;
	}
	
	/** 폴더 리스트 Ajax
	 * @param model
	 * @param filePath
	 * @param fileDepth
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/webFolder/listAjax.do")
	public ModelAndView webFolderListAjax(
			@RequestParam(value="filePath", required=false) String filePath,
			@RequestParam(value="fileDepth", required=false) int fileDepth) throws Exception{ 
		ModelAndView mv  = new ModelAndView("/dyAdmin/folder/pra_folder_list_data");
		
		filePath = SiteProperties.getString("WEBFILE_PATH") + filePath;
		
		File file = new File(filePath);
		
		// 초기 폴더가 없으면 만든다
		if(!file.exists()){
			file.mkdirs();
		}
		
		int depth = 0;
		// 하위 폴더들 조회
		List<HashMap<String,Object>> folderList = new ArrayList<HashMap<String, Object>>();
		
		folderSearch(file, depth,folderList);
		
		HashMap<String,Object> resultMap = new HashMap<>();
		List<HashMap<String,Object>> resultList = new ArrayList<HashMap<String, Object>>();
		for (HashMap<String, Object> hashMap : folderList) {
			// 폴더만 가져오기
			resultMap = new HashMap<>();
				if(Integer.parseInt(hashMap.get("fileDepth").toString()) == fileDepth){
					resultMap.put("fileNm", hashMap.get("fileNm"));
					resultMap.put("filePath", hashMap.get("filePath").toString());
					resultMap.put("fileDepth", hashMap.get("fileDepth"));
					resultList.add(resultMap);
			}
		}
		mv.addObject("resultList", resultList);
		
		return mv;
	}
	
	public static void folderSearch(File file, int depth, List<HashMap<String,Object>> folderList) throws Exception{
		// 더이상 하위 디렉토리 없으면 반환
		if(!file.isDirectory()) {
			return;
		}
		
		HashMap<String,Object> map = new HashMap<>();
		map.put("fileNm", file.getName());
		map.put("fileDepth", depth);
		
		//경로 자르기
		int pathLength = SiteProperties.getString("WEBFILE_PATH").length();
		String filePath = file.toPath().toString().substring(pathLength);
		
		filePath = filePath.replace("\\", "/");
		map.put("filePath", filePath);
		folderList.add(map);
		
		for(File f : file.listFiles(File::isDirectory)) {
			folderSearch(f, depth+1,folderList);
		}
	}
	
	/** 파일 리스트 Ajax
	 * @param model
	 * @param mainPath
	 * @param mainDepth
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/webFolder/FilelistAjax.do")
	public ModelAndView webFolderFileListAjax(
			@RequestParam(value="mainPath", required=false) String mainPath
			,@RequestParam(value="mainDepth", required=false) int mainDepth
			) throws Exception{ 
		ModelAndView mv  = new ModelAndView("/dyAdmin/folder/pra_folder_filelist");
		
		mainPath =  SiteProperties.getString("WEBFILE_PATH") + mainPath;
		
		File file = new File(mainPath);
		
		// 하위 파일들 조회
		List<HashMap<String,Object>> fileList = new ArrayList<HashMap<String, Object>>();
		fileSearch(file, mainDepth, fileList, null);
		
		HashMap<String,Object> resultMap = new HashMap<>();
		List<HashMap<String,Object>> resultList = new ArrayList<HashMap<String, Object>>();
		for (HashMap<String, Object> hashMap : fileList) {
			resultMap = new HashMap<>();
				if(Integer.parseInt(hashMap.get("fileDepth").toString()) == (mainDepth+1)){
					resultMap.put("fileNm", hashMap.get("fileNm"));
					resultMap.put("filePath", hashMap.get("filePath"));
					resultMap.put("fileDepth", hashMap.get("fileDepth"));
					resultList.add(resultMap);
			}
		}
		mv.addObject("resultList", resultList);
		
		
		return mv;
	}
	
	public static void fileSearch(File file, int depth, List<HashMap<String,Object>> fileList, String type) throws Exception{
		
		HashMap<String,Object> map = new HashMap<>();
		map.put("fileNm", file.getName());
		map.put("fileDepth", depth);
		//경로 자르기
		int pathLength = SiteProperties.getString("WEBFILE_PATH").length();
		String filePath = file.toPath().toString().substring(pathLength);
		
		filePath = filePath.replace("\\", "/");
		map.put("filePath", filePath);
		fileList.add(map);
		
		// 더이상 하위 디렉토리 없으면 반환
		if(!file.isDirectory()) {
			return;
		}
		
		if(StringUtils.isBlank(type)){
			for(File f : file.listFiles(File::isFile)) {
				fileSearch(f, depth+1,fileList, "");
			}
		}else{
			// 모든 파일들 가져옴
			for(File f : file.listFiles()) {
				fileSearch(f, depth+1,fileList, type);
			}
		}
	}

	@RequestMapping(value = "/dyAdmin/homepage/webFolder/folderInsertAjax.do")
	@CheckActivityHistory(desc = "웹폴더 등록 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	@ResponseBody
	public String  folderInsertAjax(HttpServletRequest req
			,@RequestParam(value="mainPath", required=false) String mainPath
			,@RequestParam(value="FILE_NAME", required=false) String FILE_NAME) throws Exception{ 
		
		mainPath =  SiteProperties.getString("WEBFILE_PATH") + mainPath + "/" + FILE_NAME;
		
		File file = new File(mainPath);
		if(file.mkdir()){
			return "success";
		}else{
			return "fail";
		}
		
	}
	
	@RequestMapping(value = "/dyAdmin/homepage/webFolder/folderUpdateAjax.do")
	@CheckActivityHistory(desc = "웹폴더 수정 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	@ResponseBody
	public String folderUpdateAjax(HttpServletRequest req
			,@RequestParam(value="mainPath", required=false) String mainPath
			,@RequestParam(value="FILE_NAME", required=false) String FILE_NAME) throws Exception{ 
		
		String parentPath = mainPath.substring(0, mainPath.lastIndexOf("/"));
		mainPath =  SiteProperties.getString("WEBFILE_PATH") + mainPath;
		String newPath =  SiteProperties.getString("WEBFILE_PATH")+ parentPath + "/" + FILE_NAME;
		
		File file = new File(mainPath);
		File newFile = new File(newPath);
		if(file.exists()){
			//이름 변경
			if(file.renameTo(newFile)){
				return "success";
			}else{
				return "fail";
			}
		}else{
			//이동 (추후 수정)
			return "fail";
		}
	}
	
	@RequestMapping(value = "/dyAdmin/homepage/webFolder/folderDeleteAjax.do")
	@CheckActivityHistory(desc = "웹폴더 삭제 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@ResponseBody
	@Transactional
	public String folderDeleteAjax(HttpServletRequest req
			,@RequestParam(value="mainPath", required=false) String mainPath) throws Exception{
		
		mainPath =  SiteProperties.getString("WEBFILE_PATH") + mainPath;
		File file = new File(mainPath);
		
		while(file.exists()){
			File[] folder_list = file.listFiles();
			// 하위 파일들 우선 제거
			for (File files : folder_list) {
				files.delete();
			}
			// 대상 폴더 삭제
			if(folder_list.length == 0 && file.isDirectory()){
				file.delete();
			}
		}

		return "success";
	}
	
	/** 압축 다운로드
	 * @param req
	 * @param res
	 * @param mainPath
	 * @param FILE_NAME
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/webFolder/folderDownAjax.do")
	@ResponseBody
	public String folderDownAjax(HttpServletRequest req, 
							HttpServletResponse res, 
							@RequestParam(value="mainPath", required=false) String mainPath,
							@RequestParam(value="FILE_NAME", required=false) String FILE_NAME) throws Exception{ 
		// 하위 모든 파일 리스트들을 가져온다
		List<HashMap<String,Object>> fileList = new ArrayList<HashMap<String,Object>>();
		String Filepath = SiteProperties.getString("WEBFILE_PATH")+ mainPath; 
		File file = new File(Filepath);
		fileSearch(file, 1, fileList, "all");
		
		// zip 파일 생성
		return FileUploadTools.zip(fileList, FILE_NAME);
	}

	@RequestMapping(value = "/async/file/MultiFile/uploadAjax.do")
	@ResponseBody
	public synchronized String MultiFileUpLoadNews(HttpServletRequest req
		,@RequestParam(value="mainPath", required=false) String mainPath
		,@RequestParam(value="fileChkArr", required=false) String fileChkArr
		,@RequestParam(value="fileNmArr", required=false) String fileNmArr
		) throws Exception{ 
		String path = "";
		path = SiteProperties.getString("WEBFILE_PATH") + mainPath;
		
		MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) req;
		
		String newName = "";
		String originName = multiRequest.getFileMap().entrySet().iterator().next().getValue().getOriginalFilename();
		
		String[] chkArr = fileChkArr.split(",");
		String[] nameArr = fileNmArr.split(",");
		
		
		for(int i=0; i<chkArr.length; i++){
			
			if("N".equals(chkArr[i].toString())){
				// 복사본을 만들 파일인 경우
				for(int j=0; j<nameArr.length; j++){
					// 현재 파일인지 비교
					if(j == i && originName.equals(nameArr[j])) {
						// 이름 변경 처리
						newName = changeNm(path, nameArr[j]);
					}
				}
			}
			
		}
		
		//파일 업로드
		boolean chk = FileUploadTools.FileUploadNthFileByPath(req, path, newName);
		if(!chk){
			throw new NullPointerException();
		} 
		return "success";
	}
	
	public String changeNm(String path, String originName) throws Exception{
		String newNm = "";
		String oldNm = originName.substring(0, originName.lastIndexOf("."));
		String ext = originName.substring(originName.lastIndexOf("."));
		
		File file = new File(path);
		
		String fileName = "";
		int befNum = 0;
		int num = 0;
		
		//원본 파일을 넣었는데 폴더 안에 복사본 파일이 있는 경우 마지막 순번이 필요함
		for(File f : file.listFiles()) {
			if(f.getName().lastIndexOf("_(") > 0){
				fileName = f.getName().substring(0, f.getName().lastIndexOf("_("));
				if(fileName.equals(oldNm)){
					//폴더 안 복사본 파일 마지막 넘버 추출
					befNum = Integer.parseInt(f.getName().substring(f.getName().lastIndexOf("_(")+2, f.getName().lastIndexOf(")")));
					if(befNum > num) num = befNum;
				}
			}
		}
	
		newNm = oldNm + "_(" + (num+1) + ")" + ext;
		return newNm;
	}


	@RequestMapping(value = "/dyAdmin/file/webFile/fileUpdateAjax.do")
	@CheckActivityHistory(desc = "파일 수정 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	@ResponseBody
	public String fileUpdateAjax(HttpServletRequest req
			,@RequestParam(value="mainPath", required=false) String mainPath
			,@RequestParam(value="FILE_NAME", required=false) String FILE_NAME) throws Exception{ 
		
		
		String parentPath = mainPath.substring(0, mainPath.lastIndexOf("/")+1);
		mainPath =  SiteProperties.getString("WEBFILE_PATH") +  mainPath;
		String newPath =  SiteProperties.getString("WEBFILE_PATH") + parentPath + "/" + FILE_NAME;
		
		File folder = new File(SiteProperties.getString("WEBFILE_PATH")+ parentPath);
		File file = new File(mainPath);
		File newFile = new File(newPath);
		
		if(checkName(folder, FILE_NAME)){ return "duplicate"; }
		
		if(file.exists()){
			//이름 변경
			if(file.renameTo(newFile)){
				return "success";
			}else{
				return "fail";
			}
		}else{
			//이동 (추후 수정)
			return "fail";
		}
		
	}
	
	public boolean checkName(File file, String FILE_NAME) throws Exception{
		boolean status = false;
		int cnt = 0;

		List<HashMap<String,Object>> fileList = new ArrayList<HashMap<String, Object>>();
		fileSearch(file, 0, fileList, null);
		for (HashMap<String, Object> hashMap : fileList) {
			if(hashMap.get("fileNm").equals(FILE_NAME)) cnt = 1;
		}
		if(cnt > 0 ) {
			status = true;
		}
		return status;
	}
	
	@RequestMapping(value = "/dyAdmin/file/webFile/fileDeleteAjax.do")
	@CheckActivityHistory(desc = "웹파일 삭제 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@ResponseBody
	@Transactional
	public String fileDeleteAjax(HttpServletRequest req
			,@RequestParam(value="mainPath", required=false) String mainPath) throws Exception{
		
		mainPath =  SiteProperties.getString("WEBFILE_PATH") + mainPath;
		File file = new File(mainPath);
		
		file.delete();
		
		return "success";
	}
	
	@RequestMapping(value = "/dyAdmin/file/webFile/filesDeleteAjax.do")
	@CheckActivityHistory(desc = "선택 웹파일 삭제 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@ResponseBody
	@Transactional
	public String filesDeleteAjax(HttpServletRequest req, 
			@RequestParam(value="Paths",defaultValue="") String Paths) throws Exception{ 
		
		String[] path_arr = Paths.split(",");
		String mainPath = "";
		for(int i = 0 ; i < path_arr.length; i++) {
			mainPath =  SiteProperties.getString("WEBFILE_PATH") + path_arr[i].trim();
			File file = new File(mainPath);
			file.delete();
		}
		return "success";
	}
	
	@RequestMapping(value = "/async/file/MultiFile/download.do")
	@ResponseBody
	public void MultiFileDownload(
			HttpServletRequest req 
			, HttpServletResponse res 
			,@RequestParam(value="mainPath", required=false) String mainPath
			,@RequestParam(value="zip", required=false) String zip
			) throws Exception{
		
		String fileName = mainPath.substring(mainPath.lastIndexOf("/")+1);
		/** 경로 설정 */
		String uploadPath = SiteProperties.getString("WEBFILE_PATH")+ mainPath;
		if("zip".equals(zip)){
			uploadPath = mainPath;
		}
	    File uFile = new File(uploadPath);
	    FileDownloadTools.FileDownload(uFile,fileName,req,res);

	}
	
	@RequestMapping(value = "/dyAdmin/file/webFile/getWebfilePath.do")
	@ResponseBody
	public String getWebfilePath(HttpServletRequest req,
			@RequestParam(value="path", required=false) String path) throws Exception{ 
		String resourcePath = SiteProperties.getString("WEBFILE_PATH") + path;
		return resourcePath;
	}
	
}
