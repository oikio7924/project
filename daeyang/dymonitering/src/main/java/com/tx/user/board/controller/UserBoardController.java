package com.tx.user.board.controller;

import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.codehaus.plexus.util.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.mysql.fabric.xmlrpc.base.Array;
import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.config.annotation.service.ActivityHistoryService;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.dto.Common;
import com.tx.common.file.FileManageTools;
import com.tx.common.file.FileUploadTools;
import com.tx.common.file.dto.FileMain;
import com.tx.common.file.dto.FileSub;
import com.tx.common.security.aes.AES256Cipher;
import com.tx.common.security.password.MyPasswordEncoder;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.page.PageAccess;
import com.tx.common.service.reqapi.requestAPIservice;
import com.tx.common.service.weakness.WeaknessService;
import com.tx.common.storage.service.StorageSelectorService;
import com.tx.common.utils.RemoveTag;
import com.tx.dyAdmin.admin.board.dto.BoardColumn;
import com.tx.dyAdmin.admin.board.dto.BoardColumnData;
import com.tx.dyAdmin.admin.board.dto.BoardNotice;
import com.tx.dyAdmin.admin.board.dto.BoardNoticeBuilder;
import com.tx.dyAdmin.admin.board.dto.BoardType;
import com.tx.dyAdmin.admin.board.service.BoardCommonService;
import com.tx.dyAdmin.admin.keyword.service.KeywordService;
import com.tx.dyAdmin.homepage.menu.dto.Menu;
import com.tx.dyAdmin.member.dto.UserDTO;
import com.tx.dyAdmin.operation.holiday.service.HolidayService;
import com.tx.dyAdmin.statistics.service.AdminStatisticsService;
import com.tx.user.service.hwpConvertService;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class UserBoardController {

	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	/** 파일업로드 툴 */
	@Autowired private FileUploadTools FileUploadTools;
	/** 암호화 */
	@Autowired MyPasswordEncoder passwordEncoder;
	/** 페이지 처리 출 */
	@Autowired private PageAccess PageAccess;
	/** 키워드 서비스 */
	@Autowired private KeywordService KeywordService;
	/** 휴일 관리 */
	@Autowired private HolidayService HolidayService;
	/** 활동기록 서비스 */
	/** statistics **/
	@Autowired private AdminStatisticsService AdminStatisticsService;
	/** 알림톡 **/
	@Autowired requestAPIservice requestAPI;
	
	
	@Autowired private ActivityHistoryService ActivityHistoryService;
	@Autowired private BoardCommonService BoardCommonService;
	@Autowired private StorageSelectorService StorageSelector;
	@Autowired private WeaknessService WeaknessService;
	@Autowired FileManageTools FileManageTools;
	@Autowired hwpConvertService hwpConvertService;

	@RequestMapping(value = "/{tiles}/Board/main/{keyno:[\\d]+}/view.do")
	public ModelAndView BoardListView(
			HttpServletRequest req
			, @PathVariable String tiles
			, @PathVariable String keyno
			, @RequestParam(value = "msg", required = false) String msg
			, @RequestParam(value = "category", required = false) Integer category
			, Common search
			, HttpSession session
			, @RequestParam(value = "BN_PLANT_NAME", required = false) String BN_PLANT_NAME
			) throws Exception {
		ModelAndView mv = CommonService.setCommonJspPath(tiles, "/user/_common/_Board/data/prc_board_data_listView");

		HashMap<String,Object> type = new HashMap<String, Object>();
		String key = "";
		
		Map<String, Object> user = CommonService.getUserInfo(req);
 	    type.put("UI_KEYNO",user.get("UI_KEYNO").toString());
 	    type.put("UIA_NAME",user.get("UIA_NAME").toString());
 	    
	    String sql2 = "main.Power_SelectKEY";
	    String sql3 = "main.Power_SelectKEYs";
	    //삼환관리자 처리부분
	    if(SettingData.samwhan.equals(user.get("UIA_KEYNO").toString())) {
		    sql2 = "main.Power_SelectKEY_Ad";
		    sql3 = "main.Power_SelectKEYs_Ad";
	    }
 	    
 	    if(key.equals("0")) {
		   key = (String) session.getAttribute("DPP_KEYNO");
 	    }
 	    if(key == null || StringUtils.isEmpty(key)) {
		   key = Component.getData(sql2,type);
 	    }
 	    List<HashMap<String,Object>> list = Component.getList(sql3,type);
 	    mv.addObject("plantKey",list);
 	    session.setAttribute("DPP_KEYNO", key);
		
		
		String MN_KEYNO = CommonService.getKeyno(keyno, "MN");

		Menu menu = Menu.builder().MN_KEYNO(MN_KEYNO).build();
		menu = Component.getData("Menu.AMN_getMenuByKey", menu);

		BoardNotice BoardNotice = BoardNoticeBuilder.Builder().setSearchParams(search).setMnKey(MN_KEYNO).build();

		BoardType BoardType = Component.getData("BoardType.BT_getData_pramMenukey", MN_KEYNO);

		BoardNotice.setBN_CATEGORY_NAME(BoardType.getCategoryName(category));

		Map<String, Object> map = CommonService.ConverObjectToMap(BoardNotice);
		
		map.put("BN_PLANT_NAME",key);
		map.put("plantList",list);
		map.put("DPPKEY",BN_PLANT_NAME);
		
		map.put("NumberingType", BoardType.getBT_NUMBERING_TYPE());
		map.put("BT_DEL_COMMENT_YN", BoardType.getBT_DEL_COMMENT_YN());
		map.put("BT_REPLY_YN", BoardType.getBT_REPLY_YN());
		map.put("BT_DEL_LISTVIEW_YN", BoardType.getBT_DEL_LISTVIEW_YN());
		map.put("BT_SHOW_MINE_YN", BoardType.getBT_SHOW_MINE_YN());
		map.put("BT_CATEGORY_INPUT", BoardType.getBT_CATEGORY_INPUT());
		map.put("BT_CATEGORY_YN", BoardType.getBT_CATEGORY_YN());
		map.put("searchCondition", search.getSearchCondition());	//첨부파일 검사할때 필요(fileNames)

		map.put("BOARD_COLUMN_TYPE_CHECK", SettingData.BOARD_COLUMN_TYPE_CHECK);
		map.put("BOARD_COLUMN_TYPE_CHECK_CODE", SettingData.BOARD_COLUMN_TYPE_CHECK_CODE);
		map.put("BOARD_COLUMN_TYPE_RADIO_CODE", SettingData.BOARD_COLUMN_TYPE_RADIO_CODE);
		map.put("BOARD_COLUMN_TYPE_SELECT_CODE", SettingData.BOARD_COLUMN_TYPE_SELECT_CODE);
		map.put("BOARD_COLUMN_TYPE_TITLE", SettingData.BOARD_COLUMN_TYPE_TITLE);
		List<BoardColumn> BoardColumnList = Component.getList("BoardColumn.BL_getviewList2", MN_KEYNO);
		map.put("BoardColumnList", BoardColumnList);

		if ("Y".equals(BoardType.getBT_SHOW_MINE_YN())) {
			user = CommonService.getUserInfo(req);
			if (user != null) {
				String isAdmin = (String) user.get("isAdmin");
				String UI_KEYNO = user.get("UI_KEYNO") + "";
				map.put("isAdmin", isAdmin);
				map.put("UI_KEYNO", UI_KEYNO);
			} else {
				map.put("isAdmin", "N");
			}
		}

		PaginationInfo pageInfo = PageAccess.getPagInfo(BoardNotice.getPageIndex(), "BoardNotice.BN_getUserDataCount", map, BoardType.getBT_PAGEUNIT(), BoardType.getBT_PAGESIZE());
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		map.put("BT_SUBJECT_NUM", BoardType.getBT_SUBJECT_NUM());
		
		List<HashMap<String, Object>> BoardNoticeDataList = Component.getList("BoardNotice.BN_getUserDataList", map);
		StorageSelector.getImgPath(BoardNoticeDataList);

		//키워드 등록
		if (StringUtils.isNotEmpty(BoardNotice.getSearchKeyword())) KeywordService.checkKeyword(BoardNotice.getSearchKeyword(), req);

		mv.addObject("BN_PLANT_NAME", BN_PLANT_NAME);
		mv.addObject("paginationInfo", pageInfo);
		mv.addObject("BoardNoticeDataList", BoardNoticeDataList);
		mv.addObject("BoardColumnList", BoardColumnList);
		mv.addObject("BoardType", BoardType);
		mv.addObject("category", category);
		mv.addObject("Menu", menu);
		mv.addObject("mirrorPage", menu.getMN_URL());
		mv.addObject("msg", msg);

		//홑따옴표 검색
		if(StringUtils.isNotEmpty(BoardNotice.getSearchKeyword())) BoardNotice.setSearchKeyword(BoardNotice.getSearchKeyword().replace("'", "\\'"));
		
		mv.addObject("BoardNotice", BoardNotice);
		mv.addObject("searchCondition", search.getSearchCondition());

		//board html사용할 경우
		if (BoardType.getBT_HTML_YN().equals("Y")) mv.addObject("BoardHtml", Component.getData("BoardHtml.BIH_getData_pramMenukey_use", MN_KEYNO));

		return mv;
	}

	/**
	 * 유저 게시판 상세보기
	 * 
	 * @param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/{tiles}/Board/{keyno:[\\d]+}/detailView.do")
	@Transactional
	@CheckActivityHistory(type = "hashmap")
	public ModelAndView BoardDataDetailView(HttpServletRequest req
			, @ModelAttribute Menu Menu
			, @ModelAttribute FileSub FileSub
			, @PathVariable String keyno
			, @PathVariable String tiles
			, @RequestParam(value = "BN_PWD", defaultValue = "") String BN_PWD
			, @RequestParam(value = "category", required = false) Integer category
			, @RequestParam(value = "pageIndex", required = false) Integer pageIndex
			, @RequestParam(value = "auth", defaultValue = "") String auth) throws Exception {
		
		ModelAndView mv = CommonService.setCommonJspPath(tiles, "/user/_common/_Board/data/prc_board_data_detailView");

		String UI_KEYNO = "", ANONYMOUS = "Y", isAdmin = "N", NowUser ="";
		Map<String, Object> user = CommonService.getUserInfo(req);
		if (user != null) {
			isAdmin = (String) user.get("isAdmin");
			UI_KEYNO = (String) user.get("UI_KEYNO");
			ANONYMOUS = "N";
			NowUser = user.get("UI_NAME").toString();
		}

		BoardType BoardType = Component.getData("BoardType.BT_getData_pramBoardkey", keyno);

		HashMap<String, Object> noticeMap = new HashMap<String, Object>();
		noticeMap.put("BN_KEYNO", keyno);
		noticeMap.put("BT_SHOW_MINE_YN", BoardType.getBT_SHOW_MINE_YN());
		noticeMap.put("BT_DEL_COMMENT_YN", BoardType.getBT_DEL_COMMENT_YN());
		noticeMap.put("UI_KEYNO", UI_KEYNO);
		noticeMap.put("ANONYMOUS", ANONYMOUS);
		noticeMap.put("isAdmin", isAdmin);

		noticeMap = BoardCommonService.getBoardDataByHashMap("BoardNotice.BN_getDataForDetail", noticeMap, BoardType.getBT_XSS_YN(), "detail");

		// 비밀글과 자기만 볼수 있는 게시판글 체크
		if (!auth.equals("Y")) { // auth 값이 Y가 아니면 비밀글 인증함
			// 비밀글일시 본인이거나 관리자만 볼수있음
			if ("Y".equals(BoardType.getBT_SHOW_MINE_YN()) || (BoardType.getBT_SECRET_YN().equals("Y") && "Y".equals(noticeMap.get("BN_SECRET_YN")))) {
				if (user == null) { // 비회원일시
					boolean checkPwd = false;
					// 회원이 작성한 비밀 글 클릭 시 오류처리
					if(StringUtils.isNotEmpty((String) noticeMap.get("BN_PWD"))){
						checkPwd = passwordEncoder.matches(BN_PWD, (String) noticeMap.get("BN_PWD"));
					}
					
					if (!checkPwd) { // 비밀번호 틀리면
						mv.setViewName("/error/board_secret");
						return mv;
					}
				} else {
					if (isAdmin.equals("N") && !UI_KEYNO.equals(noticeMap.get("BN_REGNM"))
							&& !UI_KEYNO.equals(noticeMap.get("WRITE_ID"))) {// 비밀글 답변비밀글 읽을수 있게처리
						mv.setViewName("/error/board_secret");
						return mv;
					}

				}

			}
		}

		String MN_KEYNO = (String) noticeMap.get("BN_MN_KEYNO");

		Menu.setMN_KEYNO(MN_KEYNO);
		Menu = Component.getData("Menu.AMN_getMenuByKey", Menu);

		mv.addObject("mirrorPage", Menu.getMN_URL());
		// Page Data
		mv.addObject("BoardNotice", noticeMap);
		
		noticeMap.put("UI_KEYNO",UI_KEYNO);
		mv.addObject("ownerCheck", Component.getCount("main.PlantOwnerCnt",noticeMap));
		mv.addObject("NowUser",NowUser);
		
		mv.addObject("BoardType", BoardType);

		mv.addObject("BoardColumnList", Component.getList("BoardColumn.BL_getviewList", MN_KEYNO));
		
		List<BoardColumnData> BoardColumnDataList = Component.getList("BoardColumnData.BD_getList", noticeMap.get("BN_KEYNO"));
		mv.addObject("BoardColumnDataList", BoardCommonService.setCodeColumnData(BoardColumnDataList));

		HashMap<String, Object> map = new HashMap<>();
		map.put("FM_KEYNO", noticeMap.get("BN_FM_KEYNO"));		
		map.put("PATH", CommonService.checkUrl(req) + "/resources/img/upload/");
		
		List<FileSub> fileSubList = Component.getList("File.AFS_FileSelectFileSub", map);
		
		//hwp파일 미리보기 변환 체크 
		if("Y".equals(BoardType.getBT_PREVIEW_YN()) && fileSubList.size() > 0) BoardCommonService.setAttachmentsConvertCheck(req, fileSubList, map);
		
		StorageSelector.getImgPathByfileSub(fileSubList);
		mv.addObject("FileSub", fileSubList);
		mv.addObject("category", category);
		mv.addObject("pageIndex", pageIndex);

		// 이전글, 다음글
		if (StringUtils.isNumeric(String.valueOf(noticeMap.get("BOARD_NUMBER")))) {
			int BOARD_NUMBER = Integer.parseInt(String.valueOf(noticeMap.get("BOARD_NUMBER")));
			Map<String, Object> board = new HashMap<String, Object>();
			board.put("BN_KEYNO", keyno);
			board.put("BT_SHOW_MINE_YN", BoardType.getBT_SHOW_MINE_YN());
			board.put("UI_KEYNO", UI_KEYNO);
			board.put("ANONYMOUS", ANONYMOUS);
			board.put("isAdmin", isAdmin);
			board.put("BOARD_NUMBER", BOARD_NUMBER);
			List<HashMap<String, Object>> prevAndNextList = Component.getList("BoardNotice.BN_getPrevNext", board);
			for (HashMap<String, Object> prevAndNextMap : prevAndNextList) {
				String prevNextType = (String) prevAndNextMap.get("prevNextType");
				mv.addObject(prevNextType, prevAndNextMap);
			}
		}

		// SNS
		mv.addObject("SNSInfo", BoardCommonService.setBoardSnsInfo(noticeMap, req, mv));

		// 조회수 처리 2017-06-12 세션 추가
		if (req.getSession().getAttribute(keyno) == null) {
			
			AdminStatisticsService.addStatistics(req, "B",String.valueOf(noticeMap.get("BN_KEYNO")) , Menu.getMN_MAINKEY());
			Component.updateData("BoardNotice.BN_addHits", noticeMap);
			req.getSession().setAttribute(keyno, 'y');
		}
		String currentPosition = (String) req.getSession().getAttribute("currentPosition");
		if (currentPosition != null) {
			mv.addObject("currentPosition", currentPosition);
			req.getSession().removeAttribute("currentPosition");
		}
		
		//댓글 사용할 경우 마지막 댓글 페이지 수 계산
		if("Y".equals(BoardType.getBT_COMMENT_YN())){
			HashMap<String, Object> pagingMap = new HashMap<String, Object>();
			pagingMap.put("BC_BN_KEYNO", keyno);
			pagingMap.put("DEL_COMMENT_YN", BoardType.getBT_DEL_COMMENT_YN());
			PaginationInfo pageInfo = PageAccess.getPagInfo(1,"BoardComment.BC_getListCnt",pagingMap, BoardType.getBT_PAGEUNIT_C(), BoardType.getBT_PAGESIZE_C());
			mv.addObject("newCommentIndex", pageInfo.getTotalPageCount());
		}

		// 활동기록
		ActivityHistoryService.setDescBoardAction(Menu, (String) noticeMap.get("BN_TITLE"), "detail", req);

		return mv;
	}


	/**
	 * 비회원 비밀번호 체크
	 * 
	 * @param BoardNotice
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/{tiles}/Board/checkPwdAjax.do")
	@ResponseBody
	public boolean BoardCheckPwdAjax(BoardNotice BoardNotice) throws Exception {

		HashMap<String, Object> notice = Component.getData("BoardNotice.BN_getData", BoardNotice);

		boolean match = passwordEncoder.matches(BoardNotice.getBN_PWD(), (String) notice.get("BN_PWD"));

		return match;
	}

	/**
	 * 유저 등록, 수정 페이지
	 * 
	 * @param boardType
	 * @param BoardColumn
	 * @param BoardNotice
	 * @param Menu
	 * @param category
	 * @param actionView
	 * @param req
	 * @param tiles
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/{tiles}/BoardData/actionView.do")
	@CheckActivityHistory(type = "hashmap")
	public ModelAndView BoardDataActionView(@ModelAttribute BoardType boardType,
			@ModelAttribute BoardColumn BoardColumn, @ModelAttribute BoardNotice BoardNotice, @ModelAttribute Menu Menu,
			@RequestParam(value = "category", required = false) Integer category,
			@RequestParam(value = "actionView", required = false) String actionView, HttpServletRequest req,
			@PathVariable String tiles,
			HttpSession session) throws Exception {
		ModelAndView mv = CommonService.setCommonJspPath(tiles, "/user/_common/_Board/data/prc_board_data_insertView");
		
		HashMap<String,Object> type = new HashMap<String, Object>();
		String key = "";
		
		Map<String, Object> user = CommonService.getUserInfo(req);
 	    type.put("UI_KEYNO",user.get("UI_KEYNO").toString());
 	    type.put("UIA_NAME",user.get("UIA_NAME").toString());
 	    
 	    String sql = "main.select_MainData";
	    String sql2 = "main.Power_SelectKEY";
	    //삼환관리자 처리부분
	    if(SettingData.samwhan.equals(user.get("UIA_KEYNO").toString())) {
		    sql = "main.select_MainData_Ad";
		    sql2 = "main.Power_SelectKEY_Ad";
	    }
 	    
 	    if(key.equals("0")) {
		   key = (String) session.getAttribute("DPP_KEYNO");
 	    }
 	    if(key == null) {
		   key = Component.getData(sql2,type);
 	    }
 	    session.setAttribute("DPP_KEYNO", key);
 	    mv.addObject("Plant_List", Component.getList(sql,type));
		
		String action = "insert";
		boolean replyCk = false;

		// 답글일 경우에 boardNotice값 필요
		if ("insertView".equals(actionView) && StringUtils.isNotEmpty(BoardNotice.getBN_KEYNO())) replyCk = true;

		// 게시판 권한 체크
		if (StringUtils.isNotEmpty(BoardNotice.getBN_PWD()) && "updateView".equals(actionView) && !WeaknessService.selfBoardCheck(req, BoardNotice.getBN_KEYNO())) {
			mv.setViewName("/error/board_auth");
			return mv;
		}

		boardType = Component.getData("BoardType.BT_getData", boardType.getBT_KEYNO().trim());
		List<BoardColumn> columnList = Component.getList("BoardColumn.BL_getList", boardType.getBT_KEYNO());

		// 컬럼 타입이 셀렉트(코드),라디오(코드),체크박스(코드) 일 경우 관련 코드값 셋팅
		BoardCommonService.getBoardColumnCodeList(columnList, mv);

		Menu = Component.getData("Menu.AMN_getMenuByKey", Menu);

		String boardTitle = null;
		if ("updateView".equals(actionView) || replyCk) {
			// 답글일 경우에 boardNotice값 필요
			HashMap<String, Object> noticeMap = BoardCommonService
					.getBoardDataByBoardNotice("BoardNotice.BN_getDataAdmin", BoardNotice);
			boardTitle = (String) noticeMap.get("BN_TITLE");
			mv.addObject("BoardNotice", noticeMap);

			if (!replyCk ) {
				action = "update";
				if(noticeMap.get("BN_FM_KEYNO") !=null){
					List<FileSub> FileSubList = Component.getList("File.AFS_FileSelectPutMainkey",String.valueOf(noticeMap.get("BN_FM_KEYNO")));
					StorageSelector.getImgPath2(FileSubList);
					mv.addObject("FileSub", FileSubList);
				}
			}
		}

		if ("Y".equals(boardType.getBT_HTML_YN())) {
			mv.addObject("BoardHtml", Component.getData("BoardHtml.BIH_getData_pramMenukey_use", Menu.getMN_KEYNO()));
		}

		mv.addObject("replyCk", replyCk);
		mv.addObject("Menu", Menu);
		mv.addObject("FILES_EXT", AES256Cipher.encode(BoardCommonService.getBoardfilesExt(boardType)));
		mv.addObject("BoardType", boardType);
		mv.addObject("BoardColumnList", columnList);
		mv.addObject("mirrorPage", Menu.getMN_URL());
		mv.addObject("action", action);
		mv.addObject("category", category);

		ActivityHistoryService.setDescBoardAction(Menu, boardTitle, actionView, req);

		return mv;
	}

	/**
	 * 유저 게시글,답글 - 등록,수정 작업
	 * 
	 * @param response
	 * @param BoardColumn
	 * @param BoardColumnData
	 * @param BoardNotice
	 * @param BD_BL_KEYNO
	 * @param BD_BL_TYPE
	 * @param BD_KEYNO
	 * @param category
	 * @param thumbnail
	 * @param Menu
	 * @param FM_KEYNO
	 * @param action
	 * @param req
	 * @param tiles
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/{tiles}/BoardData/action.do")
	@Transactional
	@CheckActivityHistory(type = "hashmap")
	public ModelAndView BoardDataAction(HttpServletResponse response, @ModelAttribute BoardColumn BoardColumn,
			@ModelAttribute BoardColumnData BoardColumnData, @ModelAttribute BoardNotice BoardNotice,
			@RequestParam(value = "BD_BL_KEYNO", required = false) String[] BD_BL_KEYNO,
			@RequestParam(value = "BD_BL_TYPE", required = false) String[] BD_BL_TYPE,
			@RequestParam(value = "BD_KEYNO", required = false) String[] BD_KEYNO,
			@RequestParam(value = "category", required = false) Integer category,
			@RequestParam(value = "thumbnail", required = false) MultipartFile thumbnail, @ModelAttribute Menu Menu,
			@RequestParam(value = "FM_KEYNO", required = false) String FM_KEYNO,
			@RequestParam(value = "action", required = false) String action, HttpServletRequest req,
			@PathVariable String tiles) throws Exception {

		ModelAndView mv = new ModelAndView();

		if ("update".equals(action) && !WeaknessService.selfBoardCheck(req, BoardNotice.getBN_KEYNO())) {
			mv.setViewName("/error/board_auth");
			return mv;
		}

		Menu = Component.getData("Menu.AMN_getMenuByKey", Menu);

		String ConTents = BoardNotice.getBN_CONTENTS();
		
        BoardNotice.setBN_CONTENTS_SEARCH(RemoveTag.remove(ConTents));    //태그제거한 내용 저장
        
		BoardType boardType = Component.getData("BoardType.BT_getData", BoardColumnData.getBD_BT_KEYNO().trim());

		// 개인정보필터 재확인
		String returnUrl = BoardCommonService.boardPersonalCheck(response, boardType, ConTents, Menu.getMN_URL());
		if (StringUtils.isNotBlank(returnUrl)) {
			mv.setViewName(returnUrl);
			return mv;
		}

		// 쉼표 별로 배열쪼개짐 문제 처리
		String[] BD_DATA = req.getParameterValues("BD_DATA");

		BoardColumnData.setBD_BN_KEYNO(BoardNotice.getBN_KEYNO());
		BoardColumnData.setBD_MN_KEYNO(BoardNotice.getBN_MN_KEYNO());

		if (StringUtils.isEmpty(BoardNotice.getBN_SECRET_YN())) BoardNotice.setBN_SECRET_YN("N");
		if (StringUtils.isEmpty(BoardNotice.getBN_IMPORTANT())) BoardNotice.setBN_IMPORTANT("N");

		// 게시판 파일 관련 처리
		BoardCommonService.boardFileRelatedProcessing(req, Menu.getMN_KEYNO(), BoardNotice, boardType, thumbnail, FM_KEYNO);

		// 게시판 컬럼 값 등록 처리
		BoardCommonService.boardColumnDataAction(action, BD_BL_KEYNO, BD_BL_TYPE, BD_DATA, BoardColumnData, BoardNotice, BD_KEYNO);

		if ("update".equals(action)) { // 히스토리 등록
			Component.createData("BoardNotice.BNH_insert", BoardNotice);
			BoardColumnData.setBDH_BNH_KEYNO(BoardNotice.getBNH_KEYNO());
			Component.createData("BoardColumnData.BDH_insert", BoardColumnData);
			BoardNotice.setBN_UPDATE_IP(CommonService.getClientIP(req));
			Component.updateData("BoardNotice.BN_update", BoardNotice);
		} else {
			BoardNotice.setBN_INSERT_IP(CommonService.getClientIP(req));
			
			//현재 유저가 안전관리자 인지 체크하기 ( 안전관리자일때만 알림톡 전송 ) 
			HashMap<String,Object> checking = Component.getData("main.SendUserCheck", BoardNotice.getBN_REGNM());
			
			if(checking.get("UIA_KEYNO").equals("UIA_EWXHE")) {
				alimTalkSendMethod(BoardNotice,checking,7);
				BoardNotice.setBN_SEND_CHECK('N');
			}else if(checking.get("UIA_KEYNO").equals("UIA_NWMDX")) {
				alimTalkSendMethod(BoardNotice,checking,5);
				BoardNotice.setBN_SEND_CHECK('Y');
			}
			
			Component.createData("BoardNotice.BN_insert", BoardNotice);
		}

		// 이메일
		BoardCommonService.sendBoardEmail(req, tiles, boardType, BoardNotice, Menu, action);

		ActivityHistoryService.setDescBoardAction(Menu, BoardNotice.getBN_TITLE(), action, req);

		StringBuilder viewNameBuilder = new StringBuilder().append("redirect:").append(Menu.getMN_URL());
		
		if (category != null) viewNameBuilder.append("?category=").append(category);

		mv.setViewName(viewNameBuilder.toString());

		return mv;
	}

	/**
	 * 유저 게시판 글 삭제
	 * 
	 * @param BoardNotice
	 * @param Menu
	 * @param req
	 * @param category
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/{tiles}/Board/delete.do")
	@Transactional
	@CheckActivityHistory(type = "hashmap")
	public ModelAndView BoardDataDelete(
			 	 @ModelAttribute BoardNotice BoardNotice
				,@ModelAttribute Menu Menu
				,HttpServletRequest req
				,@RequestParam (value="category", required=false) Integer category
				) throws Exception {
		ModelAndView mv = new ModelAndView();

		if (StringUtils.isNotEmpty(BoardNotice.getBN_PWD()) && !WeaknessService.selfBoardCheck(req, BoardNotice.getBN_KEYNO())) {
			mv.setViewName("/error/board_auth");
			return mv;
		}

		Menu.setMN_KEYNO(BoardNotice.getBN_MN_KEYNO());
		Menu = Component.getData("Menu.AMN_getMenuByKey", Menu);

		BoardType BoardType = Component.getData("BoardType.BT_getData_pramMenukey", Menu.getMN_KEYNO());
		// 삭제정책(L:논리삭제, P: 물리삭제)
		if ("L".equals(BoardType.getBT_DEL_POLICY())) {
			BoardNotice.setBN_DEL_YN("Y");
			BoardNotice.setBN_DELNM(CommonService.getSessionUserKey(req));
			BoardNotice.setBN_DELETE_IP(CommonService.getClientIP(req));
			Component.updateData("BoardNotice.BN_stateModify", BoardNotice);
		} else {
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
			
		}

		// 활동기록
		ActivityHistoryService.setDescBoardAction(Menu, BoardNotice.getBN_TITLE(), "delete", req);

		StringBuilder viewNameBuilder = new StringBuilder().append("redirect:").append(Menu.getMN_URL());
		
		if (category != null) viewNameBuilder.append("?category=").append(category);

		mv.setViewName(viewNameBuilder.toString());

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
	 * 컬럼 데이터 리스트 불러오기
	 * 
	 * @param BoardColumnData
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/{tiles}/BoardData/updateView/listAjax.do")
	@ResponseBody
	public List<BoardColumn> columnDatalist(@ModelAttribute BoardColumnData BoardColumnData, HttpServletRequest req)
			throws Exception {
		return Component.getList("BoardColumnData.BD_getList", BoardColumnData.getBD_BN_KEYNO());
	}

	/**
	 * 캘린더형 게시판 데이터 ajax로 가져오기
	 * 
	 * @param req
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/{tiles}/Board/main/viewAjax.do")
	@ResponseBody
	public Map<String, Object> BoardListViewAjax(HttpServletRequest req, @RequestParam Map<String, Object> map)
			throws Exception {

		if (map.get("start") != null) {
			SimpleDateFormat dayTime = new SimpleDateFormat("yyyy-MM-dd");
			String start = dayTime.format(new Date(Long.parseLong((String) map.get("start")) * 1000));
			String end = dayTime.format(new Date(Long.parseLong((String) map.get("end")) * 1000));

			map.put("BN_STDT", start);
			map.put("BN_ENDT", end);
		}

		String STDT = (String) map.get("BN_STDT");
		String ENDT = (String) map.get("BN_ENDT");

		Map<String, Object> data = new HashMap<String, Object>();

		data.put("MN_KEYNO", map.get("MN_KEYNO"));
		data.put("BOARD_COLUMN_TYPE_TITLE", SettingData.BOARD_COLUMN_TYPE_TITLE);
		// data.put("BOARD_COLUMN_TYPE_CALENDAR",
		// SettingData.BOARD_COLUMN_TYPE_CALENDAR);
		data.put("BOARD_COLUMN_TYPE_CALENDAR_START", SettingData.BOARD_COLUMN_TYPE_CALENDAR_START);
		data.put("BOARD_COLUMN_TYPE_CALENDAR_END", SettingData.BOARD_COLUMN_TYPE_CALENDAR_END);
		// 제목,시작,종료일 BL_KEYNO 가져옴
		List<Map<String, Object>> result = Component.getList("BoardNotice.BN_getBLkeys", data);
		for (Map<String, Object> r : result) {
			String TYPE = (String) r.get("TYPE");
			switch (TYPE) {
			case "TITLE":
				map.put("NAME_BL_KEYNO", r.get("BL_KEYNO"));
				break;
			case "STDT":
				map.put("STDT_BL_KEYNO", r.get("BL_KEYNO"));
				break;
			case "ENDT":
				map.put("ENDT_BL_KEYNO", r.get("BL_KEYNO"));
				break;
			default:
				break;
			}
		}

		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("eventList", Component.getList("BoardNotice.BN_getUserDataListCalendar", map));
		returnMap.put("holidayList", HolidayService.getHolidays(STDT, ENDT));

		return returnMap;
	}

	/**
	 * 기존 썸네일 제거
	 * 
	 * @param BN_KEYNO
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/Board/delectAjax.do")
	@ResponseBody
	public void deletedataAjax(String BN_KEYNO) throws Exception {
		BoardNotice bn = Component.getData("BoardNotice.getData_boardNotice", BN_KEYNO);
		Component.updateData("BoardNotice.Thumbnail_delete", BN_KEYNO);
		FileSub fileSub = Component.getData("File.AFS_SubFileDetailselect", bn.getBN_THUMBNAIL());
		FileUploadTools.UpdateFileDelete(fileSub);
	}
	

	/**
	 * 금칙어 여부 체크
	 * @param BT_KEYNO, BN_CONTENTS
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/Board/forbiddenAjax.do")
	@ResponseBody
	public List<String> forbiddenAjax(String BN_CONTENTS, String BT_KEYNO) throws Exception {
		BoardType BoardType = Component.getData("BoardType.BT_getData", BT_KEYNO);
		String[] banArray = BoardType.getBT_FORBIDDEN().split(",");
		List<String> banList = new ArrayList<>();
		for(int i=0; i<banArray.length; i++){
			if(BN_CONTENTS.indexOf(banArray[i]) > -1){
				//금칙어가 포함된 경우 배열에 담아준다
				if(banList.indexOf(banArray[i]) < 0) {
					banList.add(banArray[i]);
				}
			}
		}
		return banList;
	}

	/**
	 * bn키 생성
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/commn/boardKey/selectAjax.do")
	@ResponseBody
	public synchronized Integer getBoardKey() throws Exception {
		return CommonService.getTableAutoKey("B_BOARD_NOTICE", "BN_SEQ");
	}
	
	
	/**
	 * 미리보기 화면 출력
	 * @param fileKey
	 * @param filePath
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/Board/convertAjax.do")
	@ResponseBody
	public String dataConvertAjax(String enFileKey, String enFilePath, HttpServletRequest req, String tiles) throws Exception {
		
	    String deFilePath = AES256Cipher.decode(enFilePath);
	    String deFileKey = AES256Cipher.decode(enFileKey);

	    // 확장자 가져오는 코드
	    deFilePath = AES256Cipher.decode(deFilePath.substring(deFilePath.indexOf("do?file=")+8));
	    String[] nameArray = deFilePath.split("/");
	    String fileName = nameArray[nameArray.length - 1];
	    String[] strArray = fileName.split("\\.");
	    String lower = strArray[1].toLowerCase();

	    String domainPath = CommonService.checkUrl(req);

	    // 구글 뷰어 안타는 path(path 값을 던져줌)
	    String noGooglePath = domainPath + "/user/Board/noGooglePath.do?path=";
	    // 구글 뷰어 타는 path(파일 키값을 던져줌)	    
	    String googlePath = domainPath + "/async/file/GooglePath.do?file=" + enFileKey;

	    FileSub sub = new FileSub();
	    sub.setFS_KEYNO(deFileKey);
	    sub = Component.getData("File.AFS_SubFileDetailselect", sub);

	    String result = "";

	    if ("doc".equals(lower) || "ppt".equals(lower) || "xls".equals(lower) || "pdf".equals(lower) || "txt".equals(lower)) {
	        result += "<iframe id='viewer' onload='load()' src='https://docs.google.com/viewer?embedded=true&url=" + googlePath + "'" +
	            "width='100%' height='100%' frameborder='0' title='미리보기'></iframe>'";

	    } else if ("docx".equals(lower) || "pptx".equals(lower) || "xlsx".equals(lower)) {
	        result += "<iframe id='viewer' onload='load()' src='https://docs.google.com/gview?embedded=true&url=" + googlePath + "'" +
	            "width='100%' height='100%' frameborder='0' title='미리보기'></iframe>'";

	    } else if ("bmp".equals(lower) || "jpg".equals(lower) || "png".equals(lower) || "gif".equals(lower) || "jpeg".equals(lower)) {
	        if ("none".equals((String) sub.getFS_STORAGE())) {
	            String Path = domainPath + 
	            SiteProperties.getString("FILE_PATH")
	            .substring(SiteProperties.getString("FILE_PATH").indexOf("/resources/"), SiteProperties.getString("FILE_PATH").length())
	            + sub.getFS_FOLDER() + "/" + sub.getFS_CHANGENM() + "." + sub.getFS_EXT();
	            noGooglePath += AES256Cipher.encode(Path);
	        } else {
	        	noGooglePath += enFilePath;
	        }
	        
	        result += "<div class='imgViewer'><img id='viewer' onload='load()' src='" + noGooglePath + "'></img></div>";

	    } else if ("hwp".equals(lower)) {
	        String outputPath = SiteProperties.getString("FILE_PATH") + "preView/" + deFileKey; // Xhtml이 저장될 디렉토리
	        StringBuilder runCommand = new StringBuilder(); // pyhwp를 실행할 커맨더를 조립할 String Builder 객체

	        sub.setFS_PUBLIC_PATH(deFilePath);

	        String path = StorageSelector.getThumbFileByAttachments(sub);

	        // 미리보기 파일이 예기치 못하게 지워졌을 경우
	        if (!FileManageTools.fileExistsCheck(outputPath + "/index.xhtml")) {
	            StringBuilder outPath = new StringBuilder()
	                .append(outputPath.replace(SiteProperties.getString("RESOURCE_PATH"), domainPath + "/resources/"))
	                .append("/index.xhtml");

	            sub = FileSub.builder().FS_KEYNO(deFileKey)
	                .FS_CONVERT_CHK("N")
	                .FS_CONVERT_PATH(outPath.toString())
	                .build();

	            Component.updateData("File.updateConvChk", sub);

	            hwpConvertService.conventHwp(outputPath, path, runCommand, deFileKey, domainPath);
	        }

	        StringBuilder outPath = new StringBuilder().append(outputPath.replace(SiteProperties.getString("RESOURCE_PATH"),
	            CommonService.checkUrl(req) + "/resources/")).append("/index.xhtml");

	        String enPath = AES256Cipher.encode(outPath.toString());
	        noGooglePath += enPath;

	        result += "<iframe id='viewer' onload='load()' src='" + noGooglePath + "' style='width:100%; height:100%'></iframe>";

	    }

	    return result;
	}
	
	/**
	 * 구글 뷰어 안타는 파일 path 복호화
	 * @param path
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/Board/noGooglePath.do")
	public String noGooglePath(String path) throws Exception {
	    String filePath = AES256Cipher.decode(path);
	    return "redirect:" + filePath;
	}


	/**
	 * 변환중 미리보기 리로딩
	 * @param filekey
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/Board/previewAjax.do")
	@ResponseBody
	public List <FileSub> previewAjax(String filekey) throws Exception {
	    HashMap < String, Object > map = new HashMap <> ();
	    filekey = AES256Cipher.decode(filekey);

	    FileSub sub = new FileSub();
	    sub.setFS_KEYNO(filekey);
	    sub = Component.getData("File.AFS_SubFileDetailselect", sub);

	    String outputPath = SiteProperties.getString("FILE_PATH") + "preView/" + filekey.substring(3, filekey.length()); // Xhtml이 저장될 디렉토리

	    if (FileManageTools.fileExistsCheck(outputPath + "/index.xhtml")) {
	        if (sub.getFS_CONVERT_PATH() != null && "N".equals(sub.getFS_CONVERT_CHK())) {
	            sub.setFS_CONVERT_CHK("Y");
	            Component.updateData("File.updateConvChk", sub);
	        }
	    }

	    map.put("FM_KEYNO", sub.getFS_FM_KEYNO());

	    List < FileSub > fileList = Component.getList("File.AFS_FileSelectFileSub", map);

        StorageSelector.getImgPathByfileSub(fileList);	        

	    for (FileSub fileSub: fileList) {
	        fileSub.setFS_KEYNO(AES256Cipher.encode(fileSub.getFS_KEYNO()));
	        fileSub.setFS_PATH(AES256Cipher.encode(fileSub.getFS_PATH()));

	        if (!"none".equals(fileSub.getFS_STORAGE())) {
	            fileSub.setFS_PUBLIC_PATH(AES256Cipher.encode(fileSub.getFS_PUBLIC_PATH()));
	        }

	    }

	    return fileList;
	}
	
	
    public void alimTalkSendMethod(BoardNotice notice, HashMap<String, Object> check,int cnt) throws Exception {
    	HashMap<String,Object> map = Component.getData("main.PowerOneSelect",notice.getBN_PLANT_NAME());

    	String contents = check.get("UI_NAME").toString() +" (이)가\n발전소 : "+ map.get("DPP_NAME").toString()+"의 \n게시물 : "+notice.getBN_TITLE()+" (를)을 \n등록했습니다.";
//    	url = "http://dymonitering.co.kr/";
    	String url = "http://dymonitering.co.kr/dy/Board/"+notice.getBN_KEYNO().toString()+"/detailView.do?pageIndex=1";
    	if(cnt == 5) {
    		contents = map.get("DPP_NAME").toString()+"에 새로운 게시물이 등록되었습니다. 확인해주세요.";
//    		url = "http://dymonitering.co.kr/dy/Board/"+notice.getBN_KEYNO().toString()+"/detailView.do?pageIndex=1";
    	}
    	
    	//토큰받기
		String tocken = requestAPI.TockenRecive(SettingData.Apikey,SettingData.Userid);
		tocken = URLEncoder.encode(tocken, "UTF-8");
    	
		//리스트 뽑기 - 현재 게시물 알림은 index=1
		JSONObject jsonObj = requestAPI.KakaoAllimTalkList(SettingData.Apikey,SettingData.Userid,SettingData.Senderkey,tocken);
		JSONArray jsonObj_a = (JSONArray) jsonObj.get("list");
		jsonObj = (JSONObject) jsonObj_a.get(cnt); //발전소 게시물 확인

    	//전송할 회원 리스트 ( 슈퍼개발자만 일단 )
    	List<UserDTO> list = Component.getList("main.NotUserData_Admin",map);
		
		for(UserDTO l : list) {
    		l.decode();
    		String phone = l.getUI_PHONE().toString().replace("-", "");
    		//받은 토큰으로 알림톡 전송		
    		requestAPI.KakaoAllimTalkSend(SettingData.Apikey,SettingData.Userid,SettingData.Senderkey,tocken,jsonObj,contents,phone,url);
    	}
    }
	
}
