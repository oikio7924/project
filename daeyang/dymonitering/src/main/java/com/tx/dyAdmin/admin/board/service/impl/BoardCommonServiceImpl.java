package com.tx.dyAdmin.admin.board.service.impl;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.codehaus.plexus.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.nhncorp.lucy.security.xss.XssFilter;
import com.tx.common.config.SettingData;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.dto.SNS.SNSInfo;
import com.tx.common.dto.SNS.SNSInfoBuilder;
import com.tx.common.file.FileCommonTools;
import com.tx.common.file.FileManageTools;
import com.tx.common.file.FileUploadTools;
import com.tx.common.file.dto.FileSub;
import com.tx.common.file.thumnail.ThumnailService;
import com.tx.common.security.password.MyPasswordEncoder;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.mail.EmailService;
import com.tx.common.service.page.PageAccess;
import com.tx.common.storage.service.StorageSelectorService;
import com.tx.dyAdmin.admin.board.dto.BoardColumn;
import com.tx.dyAdmin.admin.board.dto.BoardColumnData;
import com.tx.dyAdmin.admin.board.dto.BoardNotice;
import com.tx.dyAdmin.admin.board.dto.BoardPersonal;
import com.tx.dyAdmin.admin.board.dto.BoardType;
import com.tx.dyAdmin.admin.board.service.BoardCommonService;
import com.tx.dyAdmin.admin.board.service.PersonalfilterService;
import com.tx.dyAdmin.admin.code.service.CodeService;
import com.tx.dyAdmin.homepage.menu.dto.Menu;
import com.tx.user.service.hwpConvertService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Service("BoardCommonService")
public class BoardCommonServiceImpl extends EgovAbstractServiceImpl implements BoardCommonService {

	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 페이지 처리 출 */
	@Autowired private PageAccess PageAccess;
	
	/** 내용에서 개인정보보안 */
	@Autowired private PersonalfilterService PersonalService;
	
	/** email **/
    @Autowired private EmailService EmailService;
    
    @Autowired private ThumnailService ThumnailService;
    
    /** 파일업로드 툴*/
	@Autowired private FileUploadTools FileUploadTools;
	
	/** 암호화 */
	@Autowired MyPasswordEncoder passwordEncoder;
	
	@Autowired private StorageSelectorService StorageSelector;
	@Autowired private CodeService CodeService;
	
	@Autowired FileCommonTools FileCommonTools;
	@Autowired FileManageTools FileManageTools;
	@Autowired hwpConvertService hwpConvertService;
	
	/**
	 * 게시판첨부파일 확장자 가져오기
	 * @param boardType
	 * @return
	 */
	public String getBoardfilesExt(BoardType boardType) {
			
		String filesExt = SiteProperties.getString("FILE_EXT"); 
		if(boardType != null && StringUtils.isNotBlank(boardType.getBT_FILE_EXT())){
			filesExt = boardType.getBT_FILE_EXT();
		}
		return filesExt;
	}

	
	/**
	 * 개인정보 필터 체크
	 * @param response
	 * @param bt
	 * @param conTents
	 * @param mn_URL
	 * @return
	 * @throws IOException
	 */
	public String boardPersonalCheck(HttpServletResponse response, BoardType bt, String conTents, String mn_URL) throws IOException {
	
		if (bt != null && "Y".equals(bt.getBT_PERSONAL_YN())) {
			BoardPersonal boardPersonal = new BoardPersonal();
			boardPersonal = PersonalService.PersonalfilterCheck(conTents,bt.getBT_PERSONAL());
			if(boardPersonal.getResultBoolean() == false) {
				response.setContentType("text/html; charset=UTF-8");
				PrintWriter out = response.getWriter();
				out.println("<script>alert('잘못된 방법으로 접근했습니다.'); location.href='"+mn_URL+"';</script>");
				out.flush();			
				return "redirect:"+mn_URL;
			}	
		}
		return null;
	}
	
	/**
	 * 게시판 SNSInfo 셋팅
	 * @param boardNotice
	 * @param req
	 * @param mv
	 * @throws Exception
	 */
	public SNSInfo setBoardSnsInfo(HashMap<String, Object> boardNotice, HttpServletRequest req, ModelAndView mv) throws Exception {
		
		SNSInfo SNSInfo = SNSInfoBuilder.Builder()
									.setTitle((String)boardNotice.get("BN_TITLE"))
									.setDesc((String)boardNotice.get("BN_CONTENTS"), true)
									.build();
		
		String path  = (String)boardNotice.get("THUMBNAIL_PUBLIC_PATH");
		if(StringUtils.isNotEmpty(path)){
			SNSInfo.setIMG(CommonService.checkUrl(req) + path);
		}
		
		return SNSInfo;
	}
	
	/**
	 * 게시물 메일 전송
	 * @param req
	 * @param tiles
	 * @param boardType
	 * @param boardNotice
	 * @param menu
	 * @param action
	 * @throws Exception 
	 */
	public void sendBoardEmail(HttpServletRequest req, String tiles, BoardType boardType, BoardNotice boardNotice, Menu menu, String action) throws Exception {
	  
		if("Y".equals(boardType.getBT_EMAIL_YN())){
	        String typeName = "등록";
	        if("update".equals(action)) typeName = "수정";
			int boardKey = Integer.parseInt(boardNotice.getBN_KEYNO());
	        
	        String[] emails = boardType.getBT_EMAIL_ADDRESS().split(",");

	        if(StringUtils.isNotEmpty(menu.getMN_EMAIL())){
	            emails = menu.getMN_EMAIL().split(",");
	        }

	        for(String email : emails){
	            //빈칸 제거
	            EmailService.sendBoardEmail(menu.getMN_NAME(),boardNotice,boardKey,email.trim(),req,tiles, typeName);
	        }
	        
	    }
	}
	
	
	/**
	 * 코드값을 코드이름으로 변경하는 처리
	 * @param BoardColumnDataList
	 * @return
	 */
	public List<BoardColumnData> setCodeColumnData(List<BoardColumnData> BoardColumnDataList) {
		for(BoardColumnData b : BoardColumnDataList){
			if(b.getBD_DATA() != null && !b.getBD_DATA().equals("") &&
					( b.getBD_BL_TYPE().equals(SettingData.BOARD_COLUMN_TYPE_CHECK_CODE) ||
					b.getBD_BL_TYPE().equals(SettingData.BOARD_COLUMN_TYPE_RADIO_CODE) ||
					b.getBD_BL_TYPE().equals(SettingData.BOARD_COLUMN_TYPE_SELECT_CODE) ) ){
				Map<String,Object> typeList = new HashMap<String,Object>();
				String typeArray[] = b.getBD_DATA().split("\\|");
				typeList.put("typeArray", typeArray);
				b.setBD_DATA((String)Component.getData("Code.SC_getNameList", typeList));
			}
		}
		
		return BoardColumnDataList;
	}
	
	
	/**
	 * 게시판 파일 관련 처리
	 * @param req
	 * @param mn_KEYNO
	 * @param boardNotice
	 * @param boardType
	 * @param thumbnail
	 * @param fM_KEYNO
	 * @throws Exception
	 */
	public void boardFileRelatedProcessing(HttpServletRequest req, String mn_KEYNO, BoardNotice boardNotice,
			BoardType boardType, MultipartFile thumbnail, String fM_KEYNO) throws Exception {
		
		//현재 메뉴에 대한 정보를 가져와서 같이 넘겨준다
		req.setAttribute("currentMn", CommonService.setKeyno(mn_KEYNO));
		req.setAttribute("currentBn", boardNotice.getBN_KEYNO());
		
		//썸네일 처리
		if("Y".equals(boardType.getBT_THUMBNAIL_YN())) {
			boardNotice.setBN_THUMBNAIL(ThumnailService.ThumnailAction(req, thumbnail, boardType, boardNotice, fM_KEYNO));
        }else{
            boardNotice.setBN_THUMBNAIL(null);
        }
		
		//contents에 있는 이미지 중에 에디터 이미지 골라서 폴더 이동 후 temp 삭제해버림
		if(StringUtils.isNotBlank(boardNotice.getBN_CONTENTS())) {
			boardNotice.setBN_CONTENTS(FileCommonTools.editorImgCheck(boardNotice.getBN_CONTENTS(), boardNotice.getBN_KEYNO(), boardNotice.getBN_MN_KEYNO(), "board"));
		}
		
		if(StringUtils.isNotEmpty(fM_KEYNO)){
			boardNotice.setBN_FM_KEYNO(fM_KEYNO);
			
			//압축파일 설정
			if("Y".equals(boardType.getBT_ZIP_YN()) && "Y".equals(boardNotice.getFileUpdateCheck())) {
				FileSub zipsub = new FileSub();
				zipsub.setFS_FM_KEYNO(fM_KEYNO);
				List<FileSub> list = Component.getList("File.AFS_SubFileselectpath", zipsub);
				if(list != null && list.size() > 0) {
					FileUploadTools.zip(req, list);
				}
			}
		}else{
			boardNotice.setBN_FM_KEYNO(null);
		}
		
	}
	
	
	/**
	 * 게시판 컬럼 데이터 등록 작업
	 * @param bD_BL_KEYNO
	 * @param bD_BL_TYPE
	 * @param bD_DATA
	 * @param boardColumnData
	 * @param boardNotice
	 */
	public void boardColumnDataAction(String type, String[] bD_BL_KEYNO, String[] bD_BL_TYPE, String[] bD_DATA, BoardColumnData boardColumnData, BoardNotice boardNotice, String[] bD_KEYNO) {
		
		for(int i = 0; i < bD_BL_KEYNO.length; i++){
			
			if("insert".equals(type)){
				
				columnDataInsert(boardColumnData,boardNotice,bD_BL_TYPE[i],bD_BL_KEYNO[i],bD_DATA[i]);
				
			}else{
				
				if (StringUtils.isBlank(bD_KEYNO[i])) {	//컬럼 데이터 등록
					
					columnDataInsert(boardColumnData,boardNotice,bD_BL_TYPE[i],bD_BL_KEYNO[i],bD_DATA[i]);
					
				} else {	//컬럼 데이터 수정
					
					setColumnData(boardColumnData,boardNotice,bD_BL_TYPE[i],bD_DATA[i]);
					
					boardColumnData.setBD_KEYNO(bD_KEYNO[i]);
					Component.createData("BoardColumnData.BD_update", boardColumnData);
					
			   }
			}
		}
		
		if("insert".equals(type)){
			
			if(StringUtils.isNotEmpty(boardNotice.getBN_PWD())){ //비회원 비밀번호
				boardNotice.setBN_PWD(passwordEncoder.encode(boardNotice.getBN_PWD()));
			}
			
			if(StringUtils.isEmpty(boardNotice.getBN_MAINKEY())){ // 게시믈 등록시
				boardNotice.setBN_MAINKEY(boardNotice.getBN_KEYNO());
				boardNotice.setBN_SEQ(1);
				boardNotice.setBN_DEPTH(0);
			}else{ // 답글일시
				boardNotice.setBN_SEQ(boardNotice.getBN_SEQ()+1);
				boardNotice.setBN_DEPTH(boardNotice.getBN_DEPTH()+1);
				Component.updateData("BoardNotice.BN_updateSeq", boardNotice);
			}
		
		}
		
	}
	
	
	/**
	 * 컬럼데이터넣기 Insert
	 * @param boardColumnData
	 * @param boardNotice
	 * @param bD_BL_TYPE
	 * @param bD_BL_KEYNO
	 * @param bD_DATA
	 */
	public void columnDataInsert(BoardColumnData boardColumnData, BoardNotice boardNotice, String bD_BL_TYPE, String bD_BL_KEYNO, String bD_DATA){
		boardColumnData.setBD_BL_KEYNO(bD_BL_KEYNO);
		
		setColumnData(boardColumnData,boardNotice,bD_BL_TYPE,bD_DATA);
		
		boardColumnData.setBD_BL_TYPE(bD_BL_TYPE);
		Component.createData("BoardColumnData.BD_insert", boardColumnData);
	}
	
	/**
	 * 컬럼데이터 세팅
	 * @param boardColumnData
	 * @param boardNotice
	 * @param bD_BL_TYPE
	 * @param bD_DATA
	 */
	private void setColumnData(BoardColumnData boardColumnData, BoardNotice boardNotice, String bD_BL_TYPE, String bD_DATA){
		if(bD_BL_TYPE.equals(SettingData.BOARD_COLUMN_TYPE_TITLE)) { // 제목일경우
			boardNotice.setBN_TITLE(bD_DATA);
			boardColumnData.setBD_DATA(bD_DATA);
		} else if (bD_BL_TYPE.equals(SettingData.BOARD_COLUMN_TYPE_PWD)) {
			boardColumnData.setBD_DATA(passwordEncoder.encode(bD_DATA));
		} else {
			boardColumnData.setBD_DATA(bD_DATA);
		}
	}
	
	/**
	 * 컬럼 타입이 셀렉트(코드),라디오(코드),체크박스(코드) 일 경우 관련 코드값 셋팅
	 * @param columnList
	 * @param mv
	 */
	public void getBoardColumnCodeList(List<BoardColumn> columnList, ModelAndView mv) {
		
		List<String> typeList = new ArrayList<String>();
		for(BoardColumn c : columnList){
			if(c.getBL_TYPE().equals(SettingData.BOARD_COLUMN_TYPE_CHECK_CODE) ||
					c.getBL_TYPE().equals(SettingData.BOARD_COLUMN_TYPE_RADIO_CODE) ||
					c.getBL_TYPE().equals(SettingData.BOARD_COLUMN_TYPE_SELECT_CODE) )
				if(StringUtils.isNotEmpty(c.getMC_IN_C())) typeList.add(c.getMC_IN_C());
		}
		
		if(typeList.size() > 0){
	
			mv.addObject("BoardColumnCodeList",CodeService.getCodeListisUseBySelectlist(typeList));
		}
		
	}
	
	
	/**
	 * 게시판 데이터 가져오기 HashMap
	 * @param query
	 * @param boardMap
	 * @return
	 */
	public HashMap<String, Object> getBoardDataByHashMap(String query, HashMap<String, Object> boardMap) {
		
		return getBoardDataByHashMap(query, boardMap, null, null);
	}
	
	public HashMap<String, Object> getBoardDataByHashMap(String query, HashMap<String, Object> boardMap, String xssCk, String type) {
		
		HashMap<String, Object> noticeMap = getResultBoardDataMap(Component.getData(query, boardMap),xssCk,type);
		
		return noticeMap;
	}
	
	/**
	 * 게시판 데이터 가져오기 BoardNotice
	 * @param query
	 * @param boardNotice
	 * @return
	 */
	public HashMap<String, Object> getBoardDataByBoardNotice(String query, BoardNotice boardNotice) {
		
		return getBoardDataByBoardNotice(query, boardNotice, null, null);
	}
	
	public HashMap<String, Object> getBoardDataByBoardNotice(String query, BoardNotice boardNotice, String xssCk, String type) {
		
		HashMap<String, Object> noticeMap = getResultBoardDataMap(Component.getData(query, boardNotice),xssCk,type);
		
		return noticeMap;
	}
	
	private HashMap<String, Object> getResultBoardDataMap(HashMap<String, Object> resultData, String xssCk, String type) {
		
		if(resultData != null){
			StorageSelector.getImgPath(resultData);
			
			// xss filter
			if ("Y".equals(xssCk) && "detail".equals(type) && StringUtils.isNotBlank((String)resultData.get("BN_CONTENTS"))) {
				XssFilter filter = XssFilter.getInstance("lucy-xss-superset.xml");
				String content = resultData.get("BN_CONTENTS").toString().replace("<o:p>", "").replace("</o:p>", "");
				resultData.put("BN_CONTENTS", filter.doFilter(content));
			}
		}
		
		return resultData;
	}

	/*
	 * 댓글 마지막 페이지 가져오기
	 */
	public Integer commentLastPage(HashMap<String, Object> map) throws Exception{

		PaginationInfo pageInfo = PageAccess.getPagInfo(1,"BoardComment.BC_getListCnt",map,5);
		
		return pageInfo.getTotalPageCount();
	}
	
	/**
	 * hwp파일 미리보기 변환 체크 
	 */
	public void setAttachmentsConvertCheck(HttpServletRequest req, List<FileSub> fileSubList, HashMap<String, Object> map) throws Exception{
		
		for (FileSub fileSub : fileSubList) {
			if ("hwp".equals((String)fileSub.getFS_EXT())) {
				//변환 경로 없고 변환체크도 N일 경우
				if (StringUtils.isEmpty((String) fileSub.getFS_CONVERT_PATH()) && "N".equals((String) fileSub.getFS_CONVERT_CHK())) {
					FileSub sub = new FileSub();
					
					String FS_KEYNO = (String) fileSub.getFS_KEYNO();
					String outputPath = SiteProperties.getString("FILE_PATH") + "preView/" + FS_KEYNO;

					StringBuilder outPath = new StringBuilder()
						.append(outputPath.replace(SiteProperties.getString("RESOURCE_PATH"), CommonService.checkUrl(req) + "/resources/"))
						.append("/index.xhtml");
					
					sub.setFS_KEYNO(FS_KEYNO);
					sub.setFS_CONVERT_PATH(outPath.toString());

					if (!FileManageTools.fileExistsCheck(outputPath + "/index.xhtml")) { // 파일이 없으면
						StringBuilder runCommand = new StringBuilder();
						
						String path = StorageSelector.getThumbFileByAttachments(fileSub);
												
						Component.updateData("File.updateConvChk", sub);
						
						hwpConvertService.conventHwp(outputPath, path, runCommand, FS_KEYNO, CommonService.checkUrl(req));	//파일 생성
						
						fileSubList = Component.getList("File.AFS_FileSelectFileSub", map);
						
					}
				}
			}
		}
	}
	
	/**
	 * 권한체크
	 * @param req
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getAuthBoardMenuList(HttpServletRequest req, HashMap<String, Object> map) throws Exception {
		List<Map<String, Object>> list = Component.getList("Menu.AMN_getBoardTypeList_menu", map);
		Map<String,Object> user = CommonService.getUserInfo(req);
		
		String userAuth[] = ((String) user.get("UIA_NAME")).split(",");
		boolean write = true;
		if(!SettingData.PROGRAMER_KEY.equals(String.valueOf(user.get("UI_KEYNO")))){
			for (int i = 0; i < list.size(); i++) {
				write = false;
				String authList = (String) list.get(i).get("AUTHLIST");
				if (authList != null) {
					for (String auth : userAuth) {
						if (authList.contains(auth)) {
							write = true;
							break;
						}
					}
				} else {
					write = true;
				}

				if (!write) {
					list.remove(i--);
				}

			}
		}
		

		return list;
	}
	
}
