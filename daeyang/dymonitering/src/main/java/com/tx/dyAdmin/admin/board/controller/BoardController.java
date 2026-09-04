package com.tx.dyAdmin.admin.board.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.codehaus.plexus.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.nhncorp.lucy.security.xss.XssFilter;
import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.config.annotation.service.ActivityHistoryService;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.dto.Common;
import com.tx.common.file.FileUploadTools;
import com.tx.common.file.dto.FileMain;
import com.tx.common.file.dto.FileSub;
import com.tx.common.security.aes.AES256Cipher;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.page.PageAccess;
import com.tx.common.storage.service.StorageSelectorService;
import com.tx.common.utils.RemoveTag;
import com.tx.dyAdmin.admin.board.dto.BoardColumn;
import com.tx.dyAdmin.admin.board.dto.BoardColumnData;
import com.tx.dyAdmin.admin.board.dto.BoardComment;
import com.tx.dyAdmin.admin.board.dto.BoardNotice;
import com.tx.dyAdmin.admin.board.dto.BoardType;
import com.tx.dyAdmin.admin.board.service.BoardCommonService;
import com.tx.dyAdmin.homepage.menu.dto.Menu;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class BoardController {

	
	
	/** 공통 컴포넌트 */
	@Autowired
	ComponentService Component;
	@Autowired
	CommonService CommonService;

	/** 파일업로드 툴 */
	@Autowired
	private FileUploadTools FileUploadTools;

	/** 활동기록 서비스 */
	@Autowired
	private ActivityHistoryService ActivityHistoryService;

	/** 페이지 처리 출 */
	@Autowired
	private PageAccess PageAccess;

	@Autowired private StorageSelectorService StorageSelector;
	
	@Autowired private BoardCommonService BoardCommonService;
	
	/**
	 * 게시물 관리 - 게시물 페이지 방문
	 * @param req
	 * @param Menu
	 * @param MN_KEYNO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/board/dataView.do")
	@CheckActivityHistory(desc = "게시물 페이지 방문")
	public ModelAndView BoardDataListView(
			  HttpServletRequest req
			, Menu Menu
			, @RequestParam(value = "MN_KEYNO", required = false) String MN_KEYNO
			) throws Exception {
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/board/data/pra_board_data_listView.adm");

		Menu.setMN_KEYNO(CommonService.getDefaultSiteKey(req));
		Menu = Component.getData("Menu.AMN_getMenuByKey", Menu);
		mv.addObject("selectedMenuKEY", MN_KEYNO);
		mv.addObject("Menu", Menu);

		return mv;
	}

	/**
	 * 게시물 관리 - 게시물 - 페이징 ajax
	 * @param req
	 * @param search
	 * @param MN_KEYNO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/board/dataView/pagingAjax.do")
	public ModelAndView BoardDataListViewPagingAjax(
			HttpServletRequest req
			, Common search
			, @RequestParam(value = "MN_KEYNO", required = false) String MN_KEYNO
			) throws Exception {
			
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/board/data/pra_board_data_listView_data");

		List<HashMap<String, Object>> searchList = Component.getSearchList(req);

		Map<String, Object> map = CommonService.ConverObjectToMap(search);
		map.put("MN_KEYNO", MN_KEYNO);
		if (searchList != null) {
			map.put("searchList", searchList);
		}

		map.put("BOARD_COLUMN_TYPE_CHECK", SettingData.BOARD_COLUMN_TYPE_CHECK);
		map.put("BOARD_COLUMN_TYPE_CHECK_CODE", SettingData.BOARD_COLUMN_TYPE_CHECK_CODE);
		map.put("BOARD_COLUMN_TYPE_RADIO_CODE", SettingData.BOARD_COLUMN_TYPE_RADIO_CODE);
		map.put("BOARD_COLUMN_TYPE_SELECT_CODE", SettingData.BOARD_COLUMN_TYPE_SELECT_CODE);

		List<BoardColumn> BoardColumnList = Component.getList("BoardColumn.BL_getviewList2", MN_KEYNO);
		map.put("BoardColumnList", BoardColumnList);
		
		BoardType BoardType = Component.getData("BoardType.BT_getData_pramMenukey",MN_KEYNO );
		
		if(BoardType != null){
			map.put("NumberingType", BoardType.getBT_NUMBERING_TYPE());
		}
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(), "BoardNotice.BN_getDataListCnt", map,search.getPageUnit(), 10);
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());

		mv.addObject("paginationInfo", pageInfo);
		
		mv.addObject("resultList", Component.getList("BoardNotice.BN_getDataList", map));
		mv.addObject("BoardType",BoardType);
		mv.addObject("BoardColumnList", BoardColumnList);
		mv.addObject("search", search);
		return mv;

	}

	/**
	 * 게시물 관리 - 게시물 - excel ajax
	 * @param req
	 * @param res
	 * @param search
	 * @param MN_KEYNO
	 * @param MN_NAME
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/board/dataView/excelAjax.do")
	public Object BoardDataListViewExcelAjax(
			  HttpServletRequest req
			, HttpServletResponse res
			, Common search
			, @RequestParam(value = "MN_KEYNO", required = false) String MN_KEYNO
			, @RequestParam(value = "MN_NAME", required = false) String MN_NAME) throws Exception {
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/board/data/pra_board_data_listView_excel");

		List<HashMap<String, Object>> searchList = Component.getSearchList(req);

		Map<String, Object> map = CommonService.ConverObjectToMap(search);
		map.put("MN_KEYNO", MN_KEYNO);
		if (searchList != null) {
			map.put("searchList", searchList);
		}

		map.put("BOARD_COLUMN_TYPE_CHECK", SettingData.BOARD_COLUMN_TYPE_CHECK);
		map.put("BOARD_COLUMN_TYPE_CHECK_CODE", SettingData.BOARD_COLUMN_TYPE_CHECK_CODE);
		map.put("BOARD_COLUMN_TYPE_RADIO_CODE", SettingData.BOARD_COLUMN_TYPE_RADIO_CODE);
		map.put("BOARD_COLUMN_TYPE_SELECT_CODE", SettingData.BOARD_COLUMN_TYPE_SELECT_CODE);

		List<BoardColumn> BoardColumnList = Component.getList("BoardColumn.BL_getviewList2", MN_KEYNO);
		map.put("BoardColumnList", BoardColumnList);

		mv.addObject("resultList", Component.getList("BoardNotice.BN_getDataList", map));
		mv.addObject("BoardColumnList", BoardColumnList);
		mv.addObject("search", search);
		mv.addObject("MN_NAME", MN_NAME);

		try {

			Cookie cookie = new Cookie("fileDownload", "true");
			cookie.setPath("/");
			res.addCookie(cookie);

		} catch (Exception e) {
			System.out.println("쿠키 에러 :: " + e.getMessage());
		}
		return mv;

	}

	/**
	 * 메뉴 비동기 현재 유저의 쓰기 권한이 있는 게시판만 return 시킴
	 * @param req
	 * @param Menu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/board/data/main/menu/selectAjax.do")
	@ResponseBody
	public List<Map<String, Object>> selectAjax(HttpServletRequest req, @ModelAttribute Menu Menu) throws Exception {
		
		List<Map<String, Object>> list = BoardCommonService.getAuthBoardMenuList(req, CommonService.createMap("MN_HOMEDIV_C", Menu.getMN_KEYNO()));
		
		return list;
	}

	/**
	 * 게시판 등록,수정 페이지 방문
	 * @param BoardType
	 * @param BoardColumn
	 * @param BoardNotice
	 * @param Menu
	 * @param req
	 * @param actionView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/board/data/actionView.do")
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	public ModelAndView BoardDataActionView(
			  @ModelAttribute BoardType BoardType
			, @ModelAttribute BoardColumn BoardColumn
			, @ModelAttribute BoardNotice BoardNotice
			, @ModelAttribute Menu Menu
			, HttpServletRequest req
			, @RequestParam(value="actionView", required=false) String actionView) throws Exception {
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/board/data/pra_board_data_insertView.adm");
		
		String action = "insert";
		boolean replyCk = false;
		
		//답글일 경우에 boardNotice값 필요
		if("insertView".equals(actionView) && StringUtils.isNotEmpty(BoardNotice.getBN_KEYNO())) replyCk = true;
		
		BoardType boardType = Component.getData("BoardType.BT_getData", BoardType.getBT_KEYNO());
		List<BoardColumn> columnList = Component.getList("BoardColumn.BL_getList", BoardType.getBT_KEYNO());
		
		//컬럼 타입이 셀렉트(코드),라디오(코드),체크박스(코드) 일 경우 관련 코드값 셋팅
		BoardCommonService.getBoardColumnCodeList(columnList,mv);
		
		Menu = Component.getData("Menu.AMN_getMenuByKey", Menu);
		
		String boardTitle = null;
		if("updateView".equals(actionView) || replyCk){	//수정페이지일 경우
			// 답글일 경우에 boardNotice값 필요
			HashMap<String, Object> boardNotice2 = BoardCommonService.getBoardDataByBoardNotice("BoardNotice.BN_getDataAdmin",BoardNotice);
			boardTitle = (String)boardNotice2.get("BN_TITLE");
			mv.addObject("BoardNotice", boardNotice2);
			
			if(!replyCk){
				action = "update";
				boardNotice2.put("FM_KEYNO", boardNotice2.get("BN_FM_KEYNO"));
				List<FileSub> fileSub = Component.getList("File.AFS_FileSelectFileSub", boardNotice2);
				StorageSelector.getImgPath2(fileSub);
				mv.addObject("FileSub",fileSub);
			}
		}
		
		mv.addObject("BoardType", boardType);
		mv.addObject("FILES_EXT", AES256Cipher.encode(BoardCommonService.getBoardfilesExt(boardType)));
		mv.addObject("BoardColumnList", columnList);
		mv.addObject("Menu", Menu);
		mv.addObject("mirrorPage", "/dyAdmin/homepage/board/dataView.do");
		mv.addObject("action", action);

		// 활동기록
		ActivityHistoryService.setDescBoardAction(Menu, boardTitle, actionView, req);
		
		return mv;
	}

	/**
	 * 게시판 등록,수정 작업
	 * @param BoardColumn
	 * @param BoardColumnData
	 * @param BoardNotice
	 * @param BD_BL_KEYNO
	 * @param BD_BL_TYPE
	 * @param BD_KEYNO
	 * @param action
	 * @param Menu
	 * @param thumbnail
	 * @param FM_KEYNO
	 * @param response
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/board/data/action.do")
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView BoardDataAction(
			  @ModelAttribute BoardColumn BoardColumn
			, @ModelAttribute BoardColumnData BoardColumnData
			, @ModelAttribute BoardNotice BoardNotice
			, @RequestParam(value = "BD_BL_KEYNO", required = false) String[] BD_BL_KEYNO
			, @RequestParam(value = "BD_BL_TYPE", required = false) String[] BD_BL_TYPE
			, @RequestParam(value = "BD_KEYNO", required = false) String[] BD_KEYNO
			, @RequestParam(value = "action", required = false) String action 
			, Menu Menu
			, @RequestParam(value = "thumbnail", required = false) MultipartFile thumbnail
			, @RequestParam(value = "FM_KEYNO", required = false) String FM_KEYNO
			, HttpServletResponse response
			, HttpServletRequest req) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		//메뉴정보 가져오기
	    Menu = Component.getData("Menu.AMN_getMenuByKey", Menu);
		
	    //개인정보 재필터
     	String ConTents = BoardNotice.getBN_CONTENTS();
        BoardNotice.setBN_CONTENTS_SEARCH(RemoveTag.remove(ConTents));    //태그제거한 내용 저장
        
		BoardType boardType = Component.getData("BoardType.BT_getData",BoardColumnData.getBD_BT_KEYNO());
		
		//개인정보필터 재확인
		String returnUrl = BoardCommonService.boardPersonalCheck(response, boardType,ConTents,"/dyAdmin/homepage/board/dataView.do?MN_KEYNO="+BoardNotice.getBN_MN_KEYNO());
		if (StringUtils.isNotBlank(returnUrl)) {
			mv.setViewName(returnUrl);
			return mv;
		}
		mv.setViewName("redirect: /dyAdmin/homepage/board/dataView.do?MN_KEYNO=" + BoardNotice.getBN_MN_KEYNO());

		//비밀글체크
		if (StringUtils.isNotEmpty(BoardNotice.getBN_SECRET_YN())) BoardNotice.setBN_SECRET_YN("N");
		//공지글체크
		if(StringUtils.isEmpty(BoardNotice.getBN_IMPORTANT()))	BoardNotice.setBN_IMPORTANT("N");

		//게시판 파일 관련 처리
		BoardCommonService.boardFileRelatedProcessing(req,Menu.getMN_KEYNO(),BoardNotice,boardType,thumbnail,FM_KEYNO);
		
		// 쉼표 별로 배열쪼개짐 문제 임시처리
		String[] BD_DATA = req.getParameterValues("BD_DATA");
				
		//컬럼 데이터에 들어갈 고정 값(게시물키, 메뉴키)
		BoardColumnData.setBD_BN_KEYNO(BoardNotice.getBN_KEYNO());
		BoardColumnData.setBD_MN_KEYNO(BoardNotice.getBN_MN_KEYNO());
		//게시판 컬럼 값 등록 처리
		BoardCommonService.boardColumnDataAction(action, BD_BL_KEYNO,BD_BL_TYPE,BD_DATA,BoardColumnData,BoardNotice,BD_KEYNO);
		
		if("update".equals(action)){	//히스토리 등록
			Component.createData("BoardNotice.BNH_insert", BoardNotice);
			BoardColumnData.setBDH_BNH_KEYNO(BoardNotice.getBNH_KEYNO());
			Component.createData("BoardColumnData.BDH_insert", BoardColumnData);
			BoardNotice.setBN_UPDATE_IP(CommonService.getClientIP(req));
			Component.updateData("BoardNotice.BN_update", BoardNotice);
		}else{
			BoardNotice.setBN_INSERT_IP(CommonService.getClientIP(req));
			Component.createData("BoardNotice.BN_insert", BoardNotice);
		}

		// 활동기록
		ActivityHistoryService.setDescBoardAction(Menu, BoardNotice.getBN_TITLE(), action, req);

		return mv;
	}

	/**
	 * 관리자 게시물 상세화면
	 * 
	 * @param BoardType
	 * @param BoardColumn
	 * @param BoardNotice
	 * @param BoardComment
	 * @param Menu
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/board/data/detailView.do")
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	public ModelAndView BoardDataDetailView(
			 @ModelAttribute BoardType BoardType
			,@ModelAttribute BoardColumn BoardColumn
			,@ModelAttribute BoardNotice BoardNotice
			,BoardComment BoardComment
			,@ModelAttribute Menu Menu
			, HttpServletRequest req) throws Exception {
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/board/data/pra_board_data_detailView.adm");

		HashMap<String, Object> noticeMap = BoardCommonService.getBoardDataByBoardNotice("BoardNotice.BN_getDataAdmin",BoardNotice,"Y","detail");

		mv.addObject("BoardNotice", noticeMap);
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("DEL_COMMENT_YN", BoardType.getBT_DEL_COMMENT_YN());
		map.put("BC_BN_KEYNO", BoardNotice.getBN_KEYNO());
		map.put("recordCountPerPage", BoardNotice.getRecordCountPerPage());
		map.put("firstIndex", BoardNotice.getFirstIndex());
		mv.addObject("BoardCommentList", Component.getList("BoardComment.BC_getList",map));
		List<BoardColumnData> BoardColumnDataList = Component.getList("BoardColumnData.BD_getList", BoardNotice.getBN_KEYNO());
		
		//코드값을 코드이름으로 변경하는 처리
		for(BoardColumnData b : BoardColumnDataList){
			if(b.getBD_DATA() != null && !b.getBD_DATA().equals("") &&
					( b.getBD_BL_TYPE().equals(SettingData.BOARD_COLUMN_TYPE_CHECK_CODE) ||
					b.getBD_BL_TYPE().equals(SettingData.BOARD_COLUMN_TYPE_RADIO_CODE) ||
					b.getBD_BL_TYPE().equals(SettingData.BOARD_COLUMN_TYPE_SELECT_CODE) ) ){
				Map<String,Object> typeList = new HashMap<String,Object>();
				String typeArray[] = b.getBD_DATA().split("\\|");
				typeList.put("typeArray", typeArray);
				b.setBD_DATA((String) Component.getData("Code.SC_getNameList", typeList));
			}
		}
		mv.addObject("BoardColumnDataList", BoardColumnDataList);
		mv.addObject("BoardColumnList", Component.getList("BoardColumn.BL_getviewList", noticeMap.get("BN_MN_KEYNO")));
		
		noticeMap.put("FM_KEYNO", noticeMap.get("BN_FM_KEYNO"));
		mv.addObject("FileSub",Component.getList("File.AFS_FileSelectFileSub", noticeMap));
		mv.addObject("BoardReplyList", Component.getList("BoardNotice.BN_getReplyList", Integer.valueOf(BoardNotice.getBN_KEYNO())));
		// 게시판 기능 사용 여부
		mv.addObject("BoardType", Component.getData("BoardType.BT_getData_pramMenukey", noticeMap.get("BN_MN_KEYNO")));

		mv.addObject("BoardNoticeHistoryList", Component.getList("BoardNotice.BNH_getList", Integer.valueOf(BoardNotice.getBN_KEYNO())));

		mv.addObject("mirrorPage", "/dyAdmin/homepage/board/dataView.do");
		
		Menu.setMN_KEYNO((String)noticeMap.get("BN_MN_KEYNO"));
		Menu = Component.getData("Menu.AMN_getMenuByKey", Menu);
		mv.addObject("Menu", Menu);

		// 활동기록
		ActivityHistoryService.setDescBoardAction(Menu, (String)noticeMap.get("BN_TITLE"), "detail", req);

		return mv;
	}

	/**
	 * 게시물 상세화면 - 코멘트 - 페이징 ajax
	 * 
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/board/data/detailView/comment/pagingAjax.do")
	public ModelAndView boardTypeViewPagingAjax(HttpServletRequest req, Common search, @RequestParam String BC_BN_KEYNO)
			throws Exception {

		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/board/data/pra_board_data_detailView_comment_data");

		List<HashMap<String, Object>> searchList = Component.getSearchList(req);

		Map<String, Object> map = CommonService.ConverObjectToMap(search);

		if (searchList != null) {
			map.put("searchList", searchList);
		}
		map.put("BC_BN_KEYNO", BC_BN_KEYNO);

		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(), "BoardComment.BC_getDataListCnt", map,
				search.getPageUnit(), 10);

		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());

		mv.addObject("paginationInfo", pageInfo);
		mv.addObject("resultList", Component.getList("BoardComment.BC_getDataList", map));
		mv.addObject("search", search);
		return mv;

	}

	/**
	 * 게시물 상세화면 - 코멘트 - excel ajax
	 * 
	 * @param req
	 * @param res
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/board/data/detailView/comment/excelAjax.do")
	public ModelAndView boardTypeViewExcelAjax(HttpServletRequest req, HttpServletResponse res, Common search,
			@RequestParam String BC_BN_KEYNO) throws Exception {
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/board/data/pra_board_data_detailView_comment_excel");

		List<HashMap<String, Object>> searchList = Component.getSearchList(req);

		Map<String, Object> map = CommonService.ConverObjectToMap(search);

		if (searchList != null) {
			map.put("searchList", searchList);
		}
		map.put("BC_BN_KEYNO", BC_BN_KEYNO);

		mv.addObject("resultList", Component.getList("BoardComment.BC_getDataList", map));
		mv.addObject("search", search);

		try {

			Cookie cookie = new Cookie("fileDownload", "true");
			cookie.setPath("/");
			res.addCookie(cookie);

		} catch (Exception e) {
			System.out.println("쿠키 에러 :: " + e.getMessage());
		}
		return mv;

	}
	
	@RequestMapping(value = "/dyAdmin/homepage/board/data/updateView/listAjax.do")
	@ResponseBody
	public List<BoardColumn> columnDatalist(@ModelAttribute BoardColumnData BoardColumnData, HttpServletRequest req)
			throws Exception {
		return Component.getList("BoardColumnData.BD_getList", BoardColumnData.getBD_BN_KEYNO());
	}

	@RequestMapping(value = "/dyAdmin/homepage/board/data/state.do")
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView BoardDataDelete(@ModelAttribute BoardNotice BoardNotice, @RequestParam (value="delComplete", required=false) boolean delComplete, HttpServletRequest req)
			throws Exception {
		ModelAndView mv = new ModelAndView("redirect: /dyAdmin/homepage/board/dataView.do?MN_KEYNO=" + BoardNotice.getBN_MN_KEYNO());
		if(delComplete) mv.setViewName("redirect:/dyAdmin/homepage/board/deleteView.do");
		Menu Menu = new Menu();
		Menu.setMN_KEYNO(BoardNotice.getBN_MN_KEYNO());
		Menu = Component.getData("Menu.AMN_getMenuByKey", Menu);
		
		BoardType BoardType = Component.getData("BoardType.BT_getData_pramMenukey",Menu.getMN_KEYNO());
		// 삭제정책(L:논리삭제, P: 물리삭제)
		if("P".equals(BoardType.getBT_DEL_POLICY()) || delComplete) {
			List<String> keyList = Component.getList("File.GetSubKey", BoardNotice.getBN_FM_KEYNO());
			//썸네일 파일 삭제
			if(StringUtils.isNotEmpty(BoardNotice.getBN_THUMBNAIL())){fileDelete(BoardNotice.getBN_THUMBNAIL(), BoardNotice);}
			//zip 파일 삭제
			FileMain fileMain = Component.getData("File.AFM_FileSelect", BoardNotice.getBN_FM_KEYNO());
			if(fileMain != null && StringUtils.isNotEmpty(fileMain.getFM_ZIP_PATH())) StorageSelector.zipFileDelete(fileMain);
			//첨부파일 물리삭제
			for (String FS_KEYNO : keyList) {
				fileDelete(FS_KEYNO, BoardNotice);
			}
			
			Component.deleteData("BoardNotice.BN_columnHistoryDelete", BoardNotice);
			Component.deleteData("BoardNotice.BN_columnDataDelete", BoardNotice);
			Component.deleteData("BoardNotice.BN_historyDelete", BoardNotice);
			Component.deleteData("BoardNotice.BN_delete", BoardNotice);
		} else {
			BoardNotice.setBN_DELNM(CommonService.getSessionUserKey(req));
			BoardNotice.setBN_DELETE_IP(CommonService.getClientIP(req));
			Component.updateData("BoardNotice.BN_stateModify", BoardNotice);
		}
		
		String type = "";
		if ("Y".equals(BoardNotice.getBN_DEL_YN())) {
			type = "delete";
		} else if ("N".equals(BoardNotice.getBN_DEL_YN())) {
			type = "recovery";
		} else if ("Y".equals(BoardNotice.getBN_USE_YN())) {
			type = "show";
		} else {
			type = "hide";
		}
		// 활동기록
		ActivityHistoryService.setDescBoardAction(Menu, BoardNotice.getBN_TITLE(), type, req);

		return mv;
	}
	
	public void fileDelete(String FS_KEYNO, BoardNotice BoardNotice){
		FileSub fileSub = Component.getData("File.AFS_SubFileDetailselect", FS_KEYNO);
		if (fileSub != null) {
			FileUploadTools.UpdateFileDelete(fileSub);
		} else {
			System.out.println("회원정보가 일치하지 않고 관리자도 아님 - 파일 삭제 불가");
		}
	}

	/**
	 * 관리자 게시물 이동 화면
	 * 
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/board/moveView.do")
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	public ModelAndView boardDataMoveView(HttpServletRequest req, BoardType BoardType, BoardNotice BoardNotice,
			Menu Menu) throws Exception {
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/board/data/pra_board_data_moveView.adm");
		Menu.setMN_KEYNO(BoardNotice.getBN_MN_KEYNO());
		Menu = Component.getData("Menu.AMN_getMenuByKey", Menu);
		mv.addObject("BoardNotice", Component.getData("BoardNotice.BN_getData", BoardNotice));
		mv.addObject("BoardType", Component.getData("BoardType.BT_getData", BoardType.getBT_KEYNO()));
		mv.addObject("boardList", BoardCommonService.getAuthBoardMenuList(req, CommonService.createMap("MN_HOMEDIV_C", Menu.getMN_HOMEDIV_C())));

		mv.addObject("mirrorPage", "/dyAdmin/homepage/board/dataView.do");

		// 활동기록
		ActivityHistoryService.setDescBoardAction(Menu, BoardNotice.getBN_TITLE(), "moveView", req);
		return mv;
	}

	/**
	 * 관리자 게시물 이동 체크
	 * 
	 * @param req
	 * @param BoardNotice
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/board/moveCheckAjax.do")
	@ResponseBody
	public int adminBoardmoveCheckAjax(HttpServletRequest req, @ModelAttribute BoardNotice BoardNotice)
			throws Exception {

		return Component.getCount("BoardNotice.BN_moveCheck", BoardNotice);
	}
	
	
	@RequestMapping(value = "/dyAdmin/homepage/board/moveView2.do")
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	public ModelAndView BoardDataMoveView2(@ModelAttribute BoardType BoardType,
			@ModelAttribute BoardColumn BoardColumn, @ModelAttribute BoardNotice BoardNotice, @ModelAttribute Menu Menu,
			HttpServletRequest req) throws Exception {
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/board/data/pra_board_data_insertView.adm");

		// 파일 확장자
		String fileExt = SiteProperties.getString("FILE_EXT");
		
		// 이동할 메뉴 게시판 메뉴 정보
		Menu = Component.getData("Menu.AMN_getMenuByKey", Menu);
		
		String move_memo = BoardNotice.getBN_MOVE_MEMO();

		HashMap<String, Object> boardNotice2 = BoardCommonService.getBoardDataByBoardNotice("BoardNotice.BN_getDataAdmin",BoardNotice);
		boardNotice2.put("BN_MOVE_MEMO", move_memo);
		
		mv.addObject("BoardNotice", boardNotice2);
		boardNotice2.put("FM_KEYNO", boardNotice2.get("BN_FM_KEYNO"));
		mv.addObject("FileSub",Component.getList("File.AFS_FileSelectFileSub", boardNotice2));
		mv.addObject("BoardType", Component.getData("BoardType.BT_getData_pramMenukey", Menu.getMN_KEYNO()));
		mv.addObject("PreBoardType", Component.getData("BoardType.BT_getData_pramMenukey", boardNotice2.get("BN_MN_KEYNO")));
		
		List<BoardColumnData> PreBoardColumnData = Component.getList("BoardColumnData.BD_getList", boardNotice2.get("BN_KEYNO"));
		mv.addObject("PreBoardColumnData", BoardCommonService.setCodeColumnData(PreBoardColumnData));
		
		List<BoardColumn> columnList = Component.getList("BoardColumn.BL_getList", Menu.getMN_BT_KEYNO());
		mv.addObject("BoardColumnList", columnList);

		//컬럼 타입이 셀렉트(코드),라디오(코드),체크박스(코드) 일 경우 관련 코드값 셋팅
		BoardCommonService.getBoardColumnCodeList(columnList,mv);
		
		mv.addObject("Menu", Menu);
		
		FileSub FileSub = new FileSub();
		FileSub.setFS_KEYNO((String)boardNotice2.get("BN_THUMBNAIL"));
		mv.addObject("File", Component.getData("File.AFS_SubFileDetailselect", FileSub));
		mv.addObject("mirrorPage", "/dyAdmin/homepage/board/dataView.do");
		mv.addObject("action", "move");

		// 활동기록
		ActivityHistoryService.setDescBoardAction(Menu, (String)boardNotice2.get("BN_TITLE"), "moveView", req);
		mv.addObject("fileExt", fileExt);
		return mv;
	}
	
	
	

	/**
	 * 관리자 게시물 이동
	 * 
	 * @param req
	 * @param BoardNotice
	 * @param BoardType
	 * @param Menu
	 * @param tiles
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/board/data/move.do")
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView boardDataMove(@ModelAttribute BoardType BoardType, @ModelAttribute BoardColumn BoardColumn,
			@ModelAttribute BoardColumnData BoardColumnData, @ModelAttribute BoardNotice BoardNotice,
			@RequestParam(value = "BD_BL_KEYNO", required = false) String[] BD_BL_KEYNO,
			@RequestParam(value = "BD_BL_TYPE", required = false) String[] BD_BL_TYPE
			, @RequestParam(value = "BD_KEYNO", required = false) String[] BD_KEYNO, @ModelAttribute Menu Menu,
			MultipartFile thumbnail, String FM_KEYNO, HttpServletRequest req) throws Exception {

		ModelAndView mv = new ModelAndView(
				"redirect:/dyAdmin/homepage/board/data/detailView.do?BN_KEYNO=" + BoardNotice.getBN_KEYNO());

		// 이동할 메뉴 게시판 메뉴 정보
		Menu = Component.getData("Menu.AMN_getMenuByKey", Menu);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("BN_KEYNO", BoardNotice.getBN_KEYNO());
		map.put("MN_KEYNO", Menu.getMN_KEYNO());
		map.put("BT_KEYNO", Menu.getMN_BT_KEYNO());
		Component.updateData("BoardNotice.BN_moveBoard", map);

		//기존 컬럼 데이터 삭제 처리
		Component.deleteData("BoardColumnData.BD_delete", map);
		
		//기존 히스토리 삭제 처리
		Component.deleteData("BoardNotice.BNH_delete", map);
		Component.deleteData("BoardColumnData.BDH_delete", map);
		
		// 쉼표 별로 배열쪼개짐 문제 임시처리
		String[] BD_DATA = req.getParameterValues("BD_DATA");

		BoardColumnData.setBD_BN_KEYNO(BoardNotice.getBN_KEYNO());
		BoardColumnData.setBD_MN_KEYNO(BoardNotice.getBN_MN_KEYNO());

		if (BoardNotice.getBN_SECRET_YN() == null || BoardNotice.getBN_SECRET_YN().equals("")) {
			BoardNotice.setBN_SECRET_YN("N");
		}
		

		//게시판 파일 관련 처리
		BoardCommonService.boardFileRelatedProcessing(req,Menu.getMN_KEYNO(),BoardNotice,BoardType,thumbnail,FM_KEYNO);

		
		for (int i = 0; i < BD_BL_KEYNO.length; i++) {
			
			BoardCommonService.columnDataInsert(BoardColumnData, BoardNotice, BD_BL_TYPE[i], BD_BL_KEYNO[i], BD_DATA[i]);
			
		}

		// 이동으로 인한 데이터 수정
		Component.updateData("BoardNotice.BN_update", BoardNotice);

		// 활동기록
		ActivityHistoryService.setDescBoardAction(Menu, BoardNotice.getBN_TITLE(), "move", req);

		return mv;
	}
	
	

	/**
	 * 관리자 게시판 등록 페이지
	 * 
	 * @param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/board/data/reply/insertView.do")
	public ModelAndView ReplyInsertView(@RequestParam(value = "BN_KEYNO", required = false) String BN_KEYNO,
			HttpServletRequest req) throws Exception {
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/board/reply/pra_board_reply_insertView.adm");

		mv.addObject("BN_KEYNO", BN_KEYNO);

		return mv;
	}

	/**
	 * 관리자 댓글 삭제
	 * 
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/board/data/comment/deleteAjax.do")
	@CheckActivityHistory(desc = "관리자 댓글 삭제 처리 작업 ", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	@ResponseBody
	public void CommentDlelte(@ModelAttribute BoardComment BoardComment, HttpServletRequest req) throws Exception {

		Component.updateData("BoardComment.BC_delete", BoardComment);

	}

	@RequestMapping(value = "/dyAdmin/homepage/board/data/detailView/compareAjax.do")
	@ResponseBody
	public Map<String, Object> compareAjax(@ModelAttribute BoardColumnData BoardColumnData,
			@ModelAttribute BoardNotice BoardNotice, HttpServletRequest req,
			@RequestParam(value = "COMPARE", required = false) String COMPARE) throws Exception {

		BoardNotice.setBN_COMPARE(COMPARE);
		BoardColumnData.setBD_COMPARE(COMPARE);

		Map<String, Object> map = new HashMap<String, Object>();
		BoardColumnData.setBDH_BNH_KEYNO(BoardNotice.getBNH_KEYNO());
		BoardColumnData.setBD_BN_KEYNO(BoardNotice.getBN_KEYNO());
		List<BoardColumnData> BoardColumnDataList = Component.getList("BoardColumnData.BDH_compareData",
				BoardColumnData);
		String bd_keyno = "";
		bd_keyno = BoardColumnDataList.get(0).getBD_KEYNO();
		int cnt = 1;
		List<BoardColumnData> BoardColmnDataCompare1 = new ArrayList<>();
		List<BoardColumnData> BoardColmnDataCompare2 = new ArrayList<>();
		for (int i = 0; i < BoardColumnDataList.size(); i++) {
			if (i != 0 && bd_keyno.equals(BoardColumnDataList.get(i).getBD_KEYNO())) {
				cnt++;
			}
			if (cnt == 1) {
				BoardColmnDataCompare1.add(BoardColumnDataList.get(i));
			} else if (cnt == 2) {
				BoardColmnDataCompare2.add(BoardColumnDataList.get(i));
			}
		}

		map.put("BoardNoticeCompare", Component.getList("BoardNotice.BNH_compareData", BoardNotice));
		map.put("BoardColmnDataCompare1", BoardColmnDataCompare1);
		map.put("BoardColmnDataCompare2", BoardColmnDataCompare2);
		return map;
	}

	/**
	 * 게시물 히스토리 내용보기
	 * 
	 * @param MVD_KEYNO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/board/data/detailView/historyContents.do")
	public String CreateHTML_DetailViewIframe(Model model, @ModelAttribute BoardNotice BoardNotice) throws Exception {

		BoardNotice = Component.getData("BoardNotice.BNH_getContents", BoardNotice.getBNH_KEYNO());

		// xss filter
		XssFilter filter = XssFilter.getInstance("lucy-xss-superset.xml");

		model.addAttribute("contents", filter.doFilter(BoardNotice.getBNH_BN_CONTENTS()));
		return "/dyAdmin/homepage/page/pra_page_detailView_iframe";
	}

	@RequestMapping(value = "/dyAdmin/homepage/board/data/restore.do")
	@CheckActivityHistory(desc = "게시물 복원 처리 작업", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView restore(@ModelAttribute BoardColumnData BoardColumnData,
			@ModelAttribute BoardNotice BoardNotice,
			@RequestParam(value = "bnh_keyno", required = false) Integer bnh_keyno,
			@RequestParam(value = "bn_keyno", required = false) String bn_keyno, HttpServletRequest req)
			throws Exception {
		BoardNotice.setBN_KEYNO(bn_keyno);
		ModelAndView mv = new ModelAndView("redirect:/dyAdmin/homepage/board/data/detailView.do?BN_KEYNO=" + bn_keyno);

		Component.createData("BoardNotice.BNH_insert", BoardNotice);
		BoardColumnData.setBDH_BNH_KEYNO(BoardNotice.getBNH_KEYNO());
		BoardColumnData.setBD_BN_KEYNO(BoardNotice.getBN_KEYNO());
		Component.createData("BoardColumnData.BDH_insert", BoardColumnData);

		BoardNotice.setBNH_KEYNO(bnh_keyno);
		BoardColumnData.setBDH_BNH_KEYNO(bnh_keyno);
		Component.createData("BoardNotice.BN_restore_update", BoardNotice);
		Component.createData("BoardColumnData.BL_restore_update", BoardColumnData);
		return mv;
	}
	
	@RequestMapping(value="/dyAdmin/homepage/board/{key:[\\d]+}/deleteView.do")
	@CheckActivityHistory(type="hashmap")
	public ModelAndView boardDataDeleteView(HttpServletRequest req
			, BoardType BoardType
			, BoardNotice BoardNotice
			, Menu Menu
			, @PathVariable String key
			) throws Exception {
		ModelAndView mv =new ModelAndView("/dyAdmin/homepage/board/data/pra_board_data_deleteView.adm");
		Menu = Component.getData("Menu.AMN_getMenuByKey", Menu);

		HashMap<String, Object> noticeMap = BoardCommonService.getBoardDataByBoardNotice("BoardNotice.BN_getData",BoardNotice);
		mv.addObject("BoardNotice", noticeMap);
		mv.addObject("BoardType",Component.getData("BoardType.BT_getData", BoardType.getBT_KEYNO().trim()));
		mv.addObject("mirrorPage", "/dyAdmin/homepage/board/dataView.do");
		
		//활동기록
		ActivityHistoryService.setDescBoardAction(Menu,(String)noticeMap.get("BN_TITLE"),"moveView", req);
		return mv;
	}
	
	
	/**
	 * 게시물 관리 - 게시물 삭제대장 페이지 방문
	 * @param req
	 * @param Menu
	 * @param MN_KEYNO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/board/deleteView.do")
	@CheckActivityHistory(desc = "게시물 삭제대장 페이지 방문")
	public ModelAndView BoardDataDeleteView(
			  HttpServletRequest req
			, Menu Menu
			) throws Exception {
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/board/data/deleteView/pra_board_data_del_listView.adm");
		
		Menu.setMN_KEYNO(CommonService.getDefaultSiteKey(req));
		
		Menu = Component.getData("Menu.AMN_getMenuByKey", Menu);
		mv.addObject("HOMEDIV_C", Menu.getMN_KEYNO());
		mv.addObject("Menu", Menu);
		mv.addObject("homeDivList", CommonService.getHomeDivCode(false));

		return mv;
	}

	/**
	 * 게시물 관리 - 게시물 삭제대장 - 페이징 ajax
	 * @param req
	 * @param search
	 * @param MN_KEYNO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/board/deleteView/pagingAjax.do")
	public ModelAndView BoardDataDeleteListViewPagingAjax(
			HttpServletRequest req
			, Common search
			) throws Exception {
			
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/board/data/deleteView/pra_board_data_del_listView_data");

		List<HashMap<String, Object>> searchList = Component.getSearchList(req);

		Map<String, Object> map = CommonService.ConverObjectToMap(search);
		if (searchList != null) {
			map.put("searchList", searchList);
		}
		
		//접근권한 있는 게시판만 가져오기
		Menu menu = new Menu();
		menu.setMN_KEYNO(req.getParameter("MN_HOMEDIV_C"));
		List<Map<String, Object>> list =  BoardCommonService.getAuthBoardMenuList(req, CommonService.createMap("MN_HOMEDIV_C", menu.getMN_KEYNO()));
		HashSet<String> main_set = new HashSet<String>();
		HashSet<String> sub_set = new HashSet<String>();
		if(list.size() == 0){list = null;}
		else{
			for (Map<String, Object> map2 : list) {
				main_set.add(map2.get("MN_MAIN_NAME").toString());
				sub_set.add(map2.get("MN_SUB_NAME").toString());
			}
		}
		map.put("keyList", list);
		mv.addObject("boardMain", main_set);
		mv.addObject("boardSub", sub_set);
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(), "BoardNotice.BN_getDelListCnt", map,search.getPageUnit(), 10);
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());

		mv.addObject("paginationInfo", pageInfo);
		
		mv.addObject("resultList", Component.getList("BoardNotice.BN_getDelList", map));
		mv.addObject("search", search);
		return mv;

	}

	/**
	 * 게시물 관리 - 게시물 삭제대장 - excel ajax
	 * @param req
	 * @param res
	 * @param search
	 * @param MN_KEYNO
	 * @param MN_NAME
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/board/deleteView/excelAjax.do")
	public Object BoardDeleteListViewExcelAjax(
			  HttpServletRequest req
			, HttpServletResponse res
			, Common search
			, @RequestParam(value = "MN_NAME", required = false) String MN_NAME) throws Exception {
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/board/data/deleteView/pra_board_data_del_listView_excel");

		List<HashMap<String, Object>> searchList = Component.getSearchList(req);

		Map<String, Object> map = CommonService.ConverObjectToMap(search);
		if (searchList != null) {
			map.put("searchList", searchList);
		}

		//접근권한 있는 게시판만 가져오기
		Menu menu = new Menu();
		menu.setMN_KEYNO(req.getParameter("MN_HOMEDIV_C"));
		List<Map<String, Object>> list =  selectAjax(req, menu);
		map.put("keyList", list);
		mv.addObject("resultList", Component.getList("BoardNotice.BN_getDelList", map));
		mv.addObject("search", search);
		mv.addObject("MN_NAME", MN_NAME);

		try {
			Cookie cookie = new Cookie("fileDownload", "true");
			cookie.setPath("/");
			res.addCookie(cookie);

		} catch (Exception e) {
			System.out.println("쿠키 에러 :: " + e.getMessage());
		}
		return mv;

	}
	
}