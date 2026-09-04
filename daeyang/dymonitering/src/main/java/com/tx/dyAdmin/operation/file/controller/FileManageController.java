package com.tx.dyAdmin.operation.file.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.dto.Common;
import com.tx.common.file.dto.FileMain;
import com.tx.common.file.dto.FileSub;
import com.tx.common.security.aes.AES256Cipher;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.page.PageAccess;
import com.tx.common.storage.service.StorageSelectorService;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * 관리자 파일관리 컨트롤러
 * @author 
 * @version 1.0
 * @since 
 */
@Controller
public class FileManageController {

	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 페이지 처리  */
	@Autowired private PageAccess PageAccess;
	
	@Autowired private StorageSelectorService StorageSelector;
	/**
	 * 파일 관리 - 메인 목록
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/operation/file.do")
	@CheckActivityHistory(desc="파일관리 페이지 방문")
	public ModelAndView viewFileMainList(HttpServletRequest req
			,Map<String,Object> commandMap
			,@ModelAttribute("search") Common search
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/operation/file/manage/pra_fileManage.adm");
		
		return mv;
	}
	
	
	/**
	 * 파일 관리 - 메인 등록
	 * @param req
	 * @param fileMain
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/operation/file/manage/mainInsertAjax.do")
	@ResponseBody
	public FileMain mainFileInsertAction(HttpServletRequest req
			,FileMain fileMain
			) throws Exception{
		
		fileMain.setFM_REGNM(CommonService.getSessionUserKey(req));
		Component.createData("File.AFM_FileInfoInsert", fileMain);
		
		return fileMain;
	}
	
	/**
	 * 파일 관리 - 메인 수정
	 * @param req
	 * @param fm - FM_KEYNO, FM_WHERE_KEYS(추가X), FM_COMMENTS 
	 * @return
	 * @throws Exception
	 */
	private FileMain fileMainInfoUpdateAction(HttpServletRequest req
			,FileMain fm
			) throws Exception{
		
		fm.setFM_REGNM(CommonService.getSessionUserKey(req));
		Component.updateData("FileManage.AFM_FileUpdateData", fm);
		
		return fm;
	}
	
	/**
	 * 파일 관리 - 메인 수정 후 VIEW 리턴
	 * @param req
	 * @param fileMain
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/operation/file/manage/main/UpdateAjax.do")
	@ResponseBody
	public ModelAndView mainFileRefresh(HttpServletRequest req
			,FileMain fileMain
			) throws Exception{
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/operation/file/manage/pra_fileManageDetailMainAjax");
		fileMainInfoUpdateAction(req, fileMain);
		mv.addObject("fileMain", Component.getData("FileManage.AFM_FileManageDetail", fileMain));
		
		return mv;
	}
		
	/**
	 * 파일 관리 - 파일관리 ajax
	 * @param req
	 * @param commandMap
	 * @param UserDTO
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="/dyAdmin/operation/file/manage/pagingAjax.do")
	public ModelAndView programApplicationAjax(HttpServletRequest req, Map<String,Object> commandMap,
			Common search
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/operation/file/manage/pra_fileManage_data");
		
		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"FileManage.AFM_FileManageListCnt",map, search.getPageUnit(), 10);
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		mv.addObject("paginationInfo", pageInfo);
		
		@SuppressWarnings("rawtypes")
		List<Map> list = Component.getList("FileManage.AFM_FileManageList", map);
		mv.addObject("resultList", list);
		mv.addObject("search", search);
		return mv;
	}
	
	// 파일 관리 - 파일관리  엑셀
	@RequestMapping(value="/dyAdmin/operation/file/manage/excelAjax.do")
	public Object programfileSubExcel(HttpServletRequest req
			, HttpServletResponse res
			, Common search
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/operation/file/manage/pra_fileSub_excel");
		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		if(searchList != null){
			map.put("searchList", searchList);
		}
		mv.addObject("resultList", null);
//		mv.addObject("resultList", Component.getList("FileManage.AFS_getDataList", map));
		mv.addObject("search", search);
		try {
			Cookie cookie = new Cookie("fileDownload", "true");
	        cookie.setPath("/");
	        res.addCookie(cookie);
        } catch (Exception e) {
            System.out.println("쿠키 에러 :: "+e.getMessage());
        }
		return mv;
		
	}
	
	/**
	 * 파일 관리 - 파일관리 - 수정화면
	 * @param req
	 * @param commandMap
	 * @param UserDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/operation/file/manage/detailView.do")
	@CheckActivityHistory(desc="파일관리 - 상세 페이지 방문")
	public ModelAndView fileMainUpdateView(HttpServletRequest req, Map<String,Object> commandMap
			, @RequestParam(value="key", required=false) String key
			, @ModelAttribute("search") Common search
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/operation/file/manage/pra_fileManageDetail.adm");
		
		FileMain fm = new FileMain();
		fm.setFM_KEYNO(key);
		mv.addObject("fileMain", Component.getData("FileManage.AFM_FileManageDetail", fm));
		mv.addObject("mirrorPage", "/dyAdmin/operation/file.do");
		return mv;
	}

	/**
	 * 파일 관리 - 비동기 파일Sub 목록
	 * @param req
	 * @param commandMap
	 * @param UserDTO
	 * @return
	 * @throws Exception
	 */
//	@ResponseBody
	@RequestMapping(value="/dyAdmin/operation/file/subListAjax.do")
	@CheckActivityHistory(desc="파일관리 - 등록 페이지 방문")
	public ModelAndView fileMainInsertView(HttpServletRequest req
			,@RequestParam(value="fmKey", required=false, defaultValue="") String fmKey
			,@RequestParam(value="fsKey", required=false, defaultValue="") String fsKey
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/operation/file/manage/pra_fileManageDetailSubAjax");
		List<HashMap<String, Object>> fileSubList = getFileSubList(fmKey, fsKey);
		for (HashMap<String, Object> hashMap : fileSubList) {
			hashMap.put("FS_ENCODE",AES256Cipher.encode(String.valueOf(hashMap.get("FS_KEYNO"))));
		}
		mv.addObject("fileSubList", fileSubList);
		mv.addObject("baseUrl", CommonService.checkUrl(req));
		return mv;
	}
	
	/**
	 * @param FM_KEYNO
	 * @param FS_KEYNO
	 * @return
	 * @throws Exception
	 * file 메인
	 */
	private List<HashMap<String, Object>> getFileSubList(String FM_KEYNO, String FS_KEYNO)
			throws Exception {
		FileSub fs = new FileSub();
		fs.setFS_KEYNO(FS_KEYNO);
		fs.setFS_FM_KEYNO(FM_KEYNO);
		List<HashMap<String,Object>> fileSubList = Component.getList("FileManage.AFS_FileSelectByKey", fs);
		StorageSelector.getImgPath(fileSubList);
		StorageSelector.getImgPath(fileSubList,"FS_THUMBNAIL","FS_THUMBNAIL_PATH");
		
		for( int i = 0 ; i < fileSubList.size(); i++){
			HashMap<String,Object> fileSub = fileSubList.get(i);
			String fileWebPath = fileSub.get("FS_FOLDER") + FilenameUtils.getName( fileSub.get("FS_CHANGENM") + "." + fileSub.get("FS_EXT") );
			
			fileSub.put("fileWebPath", fileWebPath);
			fileSub.put("mimeType", StorageSelector.getMimeType(fileSub));
            fileSub.put("encodeFsKey", AES256Cipher.encode((String.valueOf(fileSub.get("FS_KEYNO")))));
		}
		return fileSubList;
	}
	
}
