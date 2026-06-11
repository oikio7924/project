package com.tx.common.file.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.tx.common.config.tld.SiteProperties;
import com.tx.common.file.FileCommonTools;
import com.tx.common.file.FileDownloadTools;
import com.tx.common.file.FileManageTools;
import com.tx.common.file.FileUploadTools;
import com.tx.common.file.dto.FileMain;
import com.tx.common.file.dto.FileSub;
import com.tx.common.security.aes.AES256Cipher;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.storage.service.StorageSelectorService;
import com.tx.dyAdmin.admin.board.dto.BoardPersonal;
import com.tx.dyAdmin.homepage.menu.dto.Menu;
import com.tx.user.service.hwpConvertService;

/**
 * 
 * @FileName: FileController.java
 * @Project : SafetheFood
 * @Date : 2016. 12. 21.
 * @Author : 이재령
 * @Version :
 */
@Controller
public class FileController {

	Logger log = Logger.getLogger(this.getClass());

	/** 공통 컴포넌트 */
	@Autowired
	ComponentService Component;
	@Autowired
	CommonService CommonService;

	/** 파일다운로드 툴 */
	@Autowired
	private FileDownloadTools FileDownloadTools;

	/** 파일업로드 툴 */
	@Autowired
	private FileUploadTools FileUploadTools;

	@Autowired
	FileManageTools FileManageTools;
	@Autowired
	private StorageSelectorService StorageSelector;

	@Autowired FileCommonTools FileCommonTools;
	
	@Autowired hwpConvertService hwpConvertService;

	/**
	 * 파일 다운로드 처리
	 * 
	 * @param model
	 * @param req
	 * @param FS_FM_KEYNO
	 * @throws Exception
	 */
	@RequestMapping(value = "/async/MultiFile/download.do")
	@ResponseBody
	public void MultiFileDownload(Model model, HttpServletRequest req, HttpServletResponse res,
			@RequestParam(value = "file", required = false) String file,
			@RequestParam(value = "FM_KEYNO", required = false) String FM_KEYNO) throws Exception {

		if (FM_KEYNO != null) {
			FM_KEYNO = AES256Cipher.decode(FM_KEYNO);
			FileMain FileMain = new FileMain();
			FileMain = Component.getData("File.AFM_FileSelect", FM_KEYNO);
			FileDownloadTools.FileDownload(FileMain, req, res);
		} else {
			String FS_KEYNO = AES256Cipher.decode(file);
			FileSub FileSub = new FileSub();
			FileSub.setFS_KEYNO(FS_KEYNO);
			FileSub = Component.getData("File.AFS_SubFileDetailselect", FileSub);
			// FileDownload
			FileDownloadTools.FileDownload(FileSub, req, res);
		}
	}

	/**
	 * 파일 상위 키 갱신 처리
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/async/MultiFile/mainkey/select.do")
	@ResponseBody
	public Integer getMultFileMainFilekey() throws Exception {
		return CommonService.getTableAutoKey("S_COMMON_FILE_MAIN", "FM_SEQ"); // 파일 상위정보 키 갱신
	}

	/**
	 * 파일 업로드 처리
	 * 
	 * @param req
	 * @param FS_FM_KEYNO
	 * @throws Exception
	 */
	@RequestMapping(value = "/async/MultiFile/uploadAjax.do")
	@ResponseBody
	public HashMap<String, Object> MultiFileUpLoad(
			  HttpServletRequest req
			, String FS_FM_KEYNO
			, int BT_FILE_IMG_WIDTH
			, int BT_FILE_IMG_HEIGHT
			, @RequestParam(value="BT_MOVIE_THUMBNAIL_YN", required=false) String BT_MOVIE_THUMBNAIL_YN
			, @RequestParam(value="BT_PERSONAL_YN", required=false) String BT_PERSONAL_YN
			, @RequestParam(value="BT_PERSONAL", required=false) String BT_PERSONAL
			, @RequestParam(value="BT_PREVIEW_YN", required=false) String BT_PREVIEW_YN
			, @RequestParam(value="UPLOADKEY", required = false) String filesExt
			, @RequestParam(value="BN_KEYNO", required = false) String BN_KEYNO
			, Menu Menu
			) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		// 등록자
		if (req.getSession().getAttribute("userInfo") != null) {
			String UI_KEYNO = CommonService.getSessionUserKey(req);

			boolean isMakeByBoard = false;
			if (StringUtils.isNotEmpty(BN_KEYNO)) {
				req.setAttribute("currentBn", BN_KEYNO);
				req.setAttribute("currentMn", CommonService.setKeyno(Menu.getMN_KEYNO()));
				isMakeByBoard = true;
			}

			Boolean isMovieThumb = false;
			if (BT_MOVIE_THUMBNAIL_YN.equals("Y")) isMovieThumb = true;

			if (StringUtils.isNotEmpty(UI_KEYNO)) {
				FileSub FileSub = new FileSub();
				// 수정부분
				if (BT_FILE_IMG_WIDTH == 0 && BT_FILE_IMG_HEIGHT == 0) {
					FileSub = FileUploadTools.FileUpload(req, UI_KEYNO, new FileSub(FS_FM_KEYNO, null, isMovieThumb, isMakeByBoard,BN_KEYNO), filesExt);
				} else {
					FileSub = FileUploadTools.FileUpload(req, UI_KEYNO, 
								new FileSub(FS_FM_KEYNO, null, isMovieThumb, isMakeByBoard,BN_KEYNO).IS_MAKE_THUMBNAIL().THUMB_WIDTH(BT_FILE_IMG_WIDTH).THUMB_HEIGHT(BT_FILE_IMG_HEIGHT), filesExt);
				}
				if (FileSub.getFS_EXT() == null) throw new NullPointerException();

				/*개인정보체크*/
				String path = null;
				HashMap<String,Object> personalMap = new HashMap<String,Object>(); 

				boolean personalCk = true;
				
				if ("Y".equals(BT_PERSONAL_YN)) {
					if(StringUtils.isEmpty(path)) path = StorageSelector.getThumbFileByAttachments(FileSub);
					BoardPersonal BoardPersonal = FileCommonTools.filePersonalCheck(BT_PERSONAL, FileSub, path);	
					personalCk = BoardPersonal.getResultBoolean();
					
					if(!personalCk){
						personalMap.put("boardPersonalArray", BoardPersonal.getResultArray());
						personalMap.put("orinm", FileSub.getFS_ORINM());
					}
				}
				
				personalMap.put("boardPersonalBoolean", personalCk);
				resultMap.put("personalMap", personalMap);
				resultMap.put("FileSub", FileSub);
				
				if(personalCk && "hwp".equals(FileSub.getFS_EXT()) && "Y".equals(BT_PREVIEW_YN)){	//개인정보체크 통과(personalCk :: true)했고, hwp 파일이고 , 미리보기 사용할 경우 미리보기 만들기
					if(StringUtils.isEmpty(path)) path = StorageSelector.getThumbFileByAttachments(FileSub);
					String outputPath = SiteProperties.getString("FILE_PATH") + "preView/"+ FileSub.getFS_KEYNO();
					StringBuilder runCommand = new StringBuilder();
					hwpConvertService.conventHwp(outputPath, path, runCommand, FileSub.getFS_KEYNO(), CommonService.checkUrl(req));
				}

				return resultMap;

			} else {
				throw new NullPointerException("#00 로그인 세션 정보 내 키값이 없습니다.");
			}

		} else {
//			throw new NullPointerException("#00 로그인 세션 정보가 없습니다.");
			
			boolean isMakeByBoard = false;
			if (StringUtils.isNotEmpty(BN_KEYNO)) {
				req.setAttribute("currentBn", BN_KEYNO);
				req.setAttribute("currentMn", CommonService.setKeyno(Menu.getMN_KEYNO()));
				isMakeByBoard = true;
			}

			Boolean isMovieThumb = false;
			if (BT_MOVIE_THUMBNAIL_YN.equals("Y")) isMovieThumb = true;

			FileSub FileSub = new FileSub();
			// 수정부분
			if (BT_FILE_IMG_WIDTH == 0 && BT_FILE_IMG_HEIGHT == 0) {
				FileSub = FileUploadTools.FileUpload(req, "비회원", new FileSub(FS_FM_KEYNO, null, isMovieThumb, isMakeByBoard,BN_KEYNO), filesExt);
			} else {
				FileSub = FileUploadTools.FileUpload(req, "비회원", 
							new FileSub(FS_FM_KEYNO, null, isMovieThumb, isMakeByBoard,BN_KEYNO).IS_MAKE_THUMBNAIL().THUMB_WIDTH(BT_FILE_IMG_WIDTH).THUMB_HEIGHT(BT_FILE_IMG_HEIGHT), filesExt);
			}
			if (FileSub.getFS_EXT() == null) throw new NullPointerException();

			/*개인정보체크*/
			String path = null;
			HashMap<String,Object> personalMap = new HashMap<String,Object>(); 

			boolean personalCk = true;
			
			if ("Y".equals(BT_PERSONAL_YN)) {
				if(StringUtils.isEmpty(path)) path = StorageSelector.getThumbFileByAttachments(FileSub);
				BoardPersonal BoardPersonal = FileCommonTools.filePersonalCheck(BT_PERSONAL, FileSub, path);	
				personalCk = BoardPersonal.getResultBoolean();
				
				if(!personalCk){
					personalMap.put("boardPersonalArray", BoardPersonal.getResultArray());
					personalMap.put("orinm", FileSub.getFS_ORINM());
				}
			}
			
			personalMap.put("boardPersonalBoolean", personalCk);
			resultMap.put("personalMap", personalMap);
			resultMap.put("FileSub", FileSub);
			
			if(personalCk && "hwp".equals(FileSub.getFS_EXT()) && "Y".equals(BT_PREVIEW_YN)){	//개인정보체크 통과(personalCk :: true)했고, hwp 파일이고 , 미리보기 사용할 경우 미리보기 만들기
				if(StringUtils.isEmpty(path)) path = StorageSelector.getThumbFileByAttachments(FileSub);
				String outputPath = SiteProperties.getString("FILE_PATH") + "preView/"+ FileSub.getFS_KEYNO();
				StringBuilder runCommand = new StringBuilder();
				hwpConvertService.conventHwp(outputPath, path, runCommand, FileSub.getFS_KEYNO(), CommonService.checkUrl(req));
			}

			return resultMap;
			
		}

	}

	/**
	 * 파일 관리자용 업로드 처리
	 * 
	 * @param req
	 * @param FS_FM_KEYNO
	 * @param FS_KEYNO
	 * @param fileName
	 *            - 업로드할 파일 form의 name값 - defaultValue : file
	 * @throws Exception
	 */
	@RequestMapping(value = "/async/MultiFile/single/uploadAjax.do")
	@ResponseBody
	public FileSub MultiFileUpLoadInFileManage(HttpServletRequest req, String FS_FM_KEYNO,
			@RequestParam(value = "FS_KEYNO", required = false, defaultValue = "") String FS_KEYNO,
			@RequestParam(value = "fileName", required = false, defaultValue = "file") String fileName, FileSub fileSub)
			throws Exception {

		// 세션 내 유저키
		String User = CommonService.getSessionUserKey(req);

		if (!User.isEmpty()) {
			final MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) req;
			final Map<String, MultipartFile> files = multiRequest.getFileMap();
			MultipartFile file = null;
			if (files.get(fileName) != null) {
				file = files.get(fileName);
			} else {
				Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
				if (itr.hasNext()) {
					Entry<String, MultipartFile> entry = itr.next();
					file = entry.getValue();
				}
			}

			// request 값 추가
			fileSub = FileUploadTools.FileUpload(file, User, fileSub, req);

		} else {
			throw new NullPointerException();
		}

		return fileSub;
	}

	/**
	 * @param req
	 *            - FS_KEYNO, FS_ALT, FS_COMMENTS...
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/async/file/info/uploadAjax.do")
	@ResponseBody
	public List<FileSub> fileInfoUpdate(HttpServletRequest req) throws Exception {
		List<FileSub> fsList = new ArrayList<FileSub>();
		// 세션 내 유저키
		// String User = CommonService.getSessionUserKey(req);
		// if( !User.isEmpty() ){
		fsList = FileUploadTools.getFileSubInfoList(req);
		for (FileSub fs : fsList) {
			Component.updateData("FileManage.AFS_SubInfoUpdate", fs);
		}
		// }else{
		// throw new NullPointerException();
		// }

		return fsList;
	}

	/**
	 * 파일 삭제
	 * 
	 * @param model
	 * @param req
	 * @param FS_KEYNO
	 * @throws Exception
	 */
	@RequestMapping(value = "/async/MultiFile/fs/deleteAjax.do")
	@ResponseBody
	public String MultiFileDelete(HttpServletRequest req,
			@RequestParam(value = "FS_KEYNO", required = false) String keyno,
			@RequestParam(value = "deleteFileKeys", required = false) String deleteFileKeys) throws Exception {

		// Map<String, Object> map = CommonService.getUserInfo(req);
		//
		// if(map == null){
		// System.out.println("유저 정보가 없음 - 파일 삭제 불가");
		// return "유저 정보가 없음 - 파일 삭제 불가";
		// }

		String keyList[] = null;

		if (keyno != null) {
			keyList = new String[] {keyno};	//파일관리메뉴에서 삭제할때 사용
		} else if (deleteFileKeys != null) {
			keyList = deleteFileKeys.split(",");
		} else {
			System.out.println("키값이 안넘어옴");
			return "키값이 안넘어옴";
		}
		for (String FS_KEYNO : keyList) {
			FileSub fileSub = Component.getData("File.AFS_SubFileDetailselect", FS_KEYNO);
			// String isAdmin = map.get("isAdmin") +"";
			// String userId = map.get("UI_KEYNO") +"";
			// 관리자 이거나 파일 업로드 한사람일경우만 삭제
			// if(FileSub != null && (isAdmin.equals("Y") ||
			// FileSub.getFS_REGNM().equals(userId))){
			if (fileSub != null) {
				/* 2019.01.21. 물리파일도 함께 삭제 */
				FileUploadTools.UpdateFileDelete(fileSub);
			} else {
				System.out.println("회원정보가 일치하지 않고 관리자도 아님 - 파일 삭제 불가");
				return "회원정보가 일치하지 않고 관리자도 아님 - 파일 삭제 불가";
			}
		}

		return "S";
	}

	/**
	 * 파일
	 * 
	 * @param request
	 * @param response
	 * @param file
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/common/file.do", method = RequestMethod.GET, produces = "application/octet-stream")
	public FileSystemResource commonFile(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "file") String file) throws Exception {

		if (file != null && !file.isEmpty()) {
			try {
				file = AES256Cipher.decode(file);
			} catch (Exception e) {
				return null;
			}

			File f = new File(SiteProperties.getString("FILE_PATH") + file);

			if (f.exists()) {
				response.setContentType("application/octet-stream");
				return new FileSystemResource(f);
			} else {
				return null;
			}
		}
		return null;
	}


	/**
	 * google 뷰어 미리보기 파일 가져오기
	 * 
	 * @param model
	 * @param req
	 * @param FS_FM_KEYNO
	 * @throws Exception
	 */
	@RequestMapping(value = "/async/file/GooglePath.do")
	@ResponseBody
	public void GooglePath(Model model, HttpServletRequest req, HttpServletResponse res,
			@RequestParam(value = "file", required = false) String file) throws Exception {

		String FS_KEYNO = AES256Cipher.decode(file);
		FileSub FileSub = new FileSub();
		FileSub.setFS_KEYNO(FS_KEYNO);
		FileSub = Component.getData("File.AFS_SubFileDetailselect", FileSub);
		FileDownloadTools.googlePath(FileSub, req, res);
	}
}
