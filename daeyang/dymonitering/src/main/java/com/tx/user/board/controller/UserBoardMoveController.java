package com.tx.user.board.controller;



import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.codehaus.plexus.util.StringUtils;
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

import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.config.annotation.service.ActivityHistoryService;
import com.tx.common.security.password.MyPasswordEncoder;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.weakness.WeaknessService;
import com.tx.dyAdmin.admin.board.dto.BoardColumn;
import com.tx.dyAdmin.admin.board.dto.BoardColumnData;
import com.tx.dyAdmin.admin.board.dto.BoardNotice;
import com.tx.dyAdmin.admin.board.dto.BoardType;
import com.tx.dyAdmin.admin.board.service.BoardCommonService;
import com.tx.dyAdmin.homepage.menu.dto.Menu;

@Controller
public class UserBoardMoveController {

	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 암호화 */
	@Autowired MyPasswordEncoder passwordEncoder;
	
    /** 활동기록 서비스*/
	@Autowired private ActivityHistoryService ActivityHistoryService;
	
	@Autowired private BoardCommonService BoardCommonService;
	
	@Autowired private WeaknessService WeaknessService;

	
	
	/**
	 * 게시물 이동 사유 등록 페이지 방문
	 * @param req
	 * @param BoardType
	 * @param BoardNotice
	 * @param Menu
	 * @param tiles
	 * @param key
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/{tiles}/Board/{key:[\\d]+}/moveView.do")
	@CheckActivityHistory(type="hashmap")
	public ModelAndView boardDataMoveView(HttpServletRequest req
			, BoardType BoardType
			, BoardNotice BoardNotice
			, Menu Menu
			, @PathVariable String tiles
			, @PathVariable String key
			) throws Exception {
//		ModelAndView mv  = new ModelAndView("/user/"+SiteService.getSitePath(tiles)+"/board/data/prc_board_data_moveView");
		ModelAndView mv = CommonService.setCommonJspPath(tiles, "/user/_common/_Board/data/prc_board_data_moveView");
		
		Map<String, Object> user = CommonService.getUserInfo(req);
		Menu = Component.getData("Menu.AMN_getMenuByKey", Menu);
		//관리자 검증
		if(user != null && "N".equals(user.get("isAdmin"))){
			mv.setViewName("redirect:"+Menu.getMN_URL());
			return mv;
		}
		
		if(!WeaknessService.selfBoardCheck(req,BoardNotice.getBN_KEYNO())){
			mv.setViewName("/error/board_auth");
			return mv;
		}
		HashMap<String, Object> noticeMap = BoardCommonService.getBoardDataByBoardNotice("BoardNotice.BN_getData",BoardNotice);
		mv.addObject("BoardNotice", noticeMap);
		mv.addObject("BoardType",Component.getData("BoardType.BT_getData", BoardType.getBT_KEYNO().trim()));
        mv.addObject("boardList",BoardCommonService.getAuthBoardMenuList(req, CommonService.createMap("MN_HOMEDIV_C", Menu.getMN_HOMEDIV_C()))); 
		
		mv.addObject("tiles", tiles);
		mv.addObject("mirrorPage", Menu.getMN_URL());
		
		//활동기록
		ActivityHistoryService.setDescBoardAction(Menu,(String)noticeMap.get("BN_TITLE"),"moveView", req);
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
	@RequestMapping(value = "/{tiles}/Board/moveCheckAjax.do")
	@ResponseBody
	public int adminBoardmoveCheckAjax(HttpServletRequest req, @ModelAttribute BoardNotice BoardNotice)
			throws Exception {
		
		return Component.getCount("BoardNotice.BN_moveCheck", BoardNotice);
	}
	
	/**
	 * 게시판 이동 시 등록 페이지방문
	 * @param BoardType
	 * @param BoardColumn
	 * @param BoardNotice
	 * @param Menu
	 * @param req
	 * @param tiles
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/{tiles}/Board/move/insertView.do")
	@CheckActivityHistory(type="hashmap")
	public ModelAndView BoardDataMoveView2(
			 @ModelAttribute BoardType BoardType
			,@ModelAttribute BoardColumn BoardColumn
			,@ModelAttribute BoardNotice BoardNotice
			,@ModelAttribute Menu Menu
			,HttpServletRequest req
			,@PathVariable String tiles
			) throws Exception {
		ModelAndView mv  = CommonService.setCommonJspPath(tiles, "/user/_common/_Board/data/prc_board_data_insertView");
		
		if(!WeaknessService.selfBoardCheck(req,BoardNotice.getBN_KEYNO())){
			mv.setViewName("/error/board_auth");
			return mv;
		}
		// 이동할 메뉴 게시판 메뉴 정보
		Menu = Component.getData("Menu.AMN_getMenuByKey", Menu);
		
		String move_memo = BoardNotice.getBN_MOVE_MEMO();
		HashMap<String, Object> noticeMap = Component.getData("BoardNotice.BN_getData",BoardNotice);
		noticeMap.put("BN_MOVE_MEMO",move_memo);
		
		mv.addObject("BoardNotice", noticeMap);
		mv.addObject("FileSub", Component.getList("File.AFS_FileSelectPutMainkey",String.valueOf(noticeMap.get("BN_FM_KEYNO"))));
		mv.addObject("BoardType",Component.getData("BoardType.BT_getData_pramMenukey", Menu.getMN_KEYNO()));
		mv.addObject("PreBoardType", Component.getData("BoardType.BT_getData_pramMenukey", noticeMap.get("BN_MN_KEYNO")));
		
		List<BoardColumnData> PreBoardColumnData = Component.getList("BoardColumnData.BD_getList", noticeMap.get("BN_KEYNO"));
		mv.addObject("PreBoardColumnData",BoardCommonService.setCodeColumnData(PreBoardColumnData));
		
		List<BoardColumn> columnList = Component.getList("BoardColumn.BL_getList", Menu.getMN_BT_KEYNO());
		mv.addObject("BoardColumnList",columnList);
		
		//컬럼 타입이 셀렉트(코드),라디오(코드),체크박스(코드) 일 경우 관련 코드값 셋팅
		BoardCommonService.getBoardColumnCodeList(columnList,mv);
		
		mv.addObject("Menu", Menu);
		mv.addObject("mirrorPage", Menu.getMN_URL());
		mv.addObject("action","move");
		
		
		ActivityHistoryService.setDescBoardAction(Menu,(String)noticeMap.get("BN_TITLE"),"moveView", req);
		
		return mv;
	}
	
	
	/**
	 * 이동된 게시물의 등록, 수정 작업
	 * @param BoardColumn
	 * @param BoardColumnData
	 * @param BoardNotice
	 * @param BD_BL_KEYNO
	 * @param BD_BL_TYPE
	 * @param tiles
	 * @param BD_KEYNO
	 * @param Menu
	 * @param thumbnail
	 * @param FM_KEYNO
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/{tiles}/Board/data/move.do")
	@CheckActivityHistory(type="hashmap")
	@Transactional
	public ModelAndView boardDataMove(
			  @ModelAttribute BoardColumn BoardColumn
			, @ModelAttribute BoardColumnData BoardColumnData
			, @ModelAttribute BoardNotice BoardNotice
			, @RequestParam(value = "BD_BL_KEYNO", required = false) String[] BD_BL_KEYNO
			, @RequestParam(value = "BD_BL_TYPE", required = false) String[] BD_BL_TYPE
			, @PathVariable String tiles
			, @RequestParam(value = "BD_KEYNO", required = false) String[] BD_KEYNO
			, @ModelAttribute Menu Menu
			, @RequestParam (value="thumbnail", required=false)	  MultipartFile thumbnail
			, @RequestParam (value="FM_KEYNO", required=false)	  String FM_KEYNO
			, HttpServletRequest req
			, HttpServletResponse res
			) throws Exception {
		
        String key = BoardNotice.getBN_KEYNO();
		ModelAndView mv  = new ModelAndView("redirect:/"+tiles+"/Board/"+key+"/detailView.do");
		
		if(!WeaknessService.selfBoardCheck(req,BoardNotice.getBN_KEYNO())){
			mv.setViewName("/error/board_auth");
			return mv;
		}
		
		// 이동할 메뉴 게시판 메뉴 정보
		Menu = Component.getData("Menu.AMN_getMenuByKey", Menu);
		
		String ConTents = BoardNotice.getBN_CONTENTS();
		BoardType boardType = Component.getData("BoardType.BT_getData",BoardColumnData.getBD_BT_KEYNO().trim());
		
		//개인정보필터 재확인
		String returnUrl = BoardCommonService.boardPersonalCheck(res, boardType,ConTents,Menu.getMN_URL());
		if (StringUtils.isNotBlank(returnUrl)) {
			mv.setViewName(returnUrl);
			return mv;
		}
		
		
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
		BoardNotice.setBN_FM_KEYNO(FM_KEYNO);
		
		if (StringUtils.isEmpty(BoardNotice.getBN_SECRET_YN())) {
			BoardNotice.setBN_SECRET_YN("N");
		}
		
		//게시판 파일 관련 처리
		BoardCommonService.boardFileRelatedProcessing(req,Menu.getMN_KEYNO(),BoardNotice,boardType,thumbnail,FM_KEYNO);
		
		for (int i = 0; i < BD_BL_KEYNO.length; i++) {
			BoardCommonService.columnDataInsert(BoardColumnData, BoardNotice, BD_BL_TYPE[i], BD_BL_KEYNO[i], BD_DATA[i]);
		}
		
		// 이동으로 인한 데이터 수정
		Component.updateData("BoardNotice.BN_update", BoardNotice);
		
		// 활동기록
		ActivityHistoryService.setDescBoardAction(Menu, BoardNotice.getBN_TITLE(), "move", req);
			

		return mv;
	}
	
	@RequestMapping(value="/{tiles}/Board/{key:[\\d]+}/deleteView.do")
	@CheckActivityHistory(type="hashmap")
	public ModelAndView boardDataDeleteView(HttpServletRequest req
			, BoardType BoardType
			, BoardNotice BoardNotice
			, Menu Menu
			, @PathVariable String tiles
			, @PathVariable String key
			) throws Exception {
		ModelAndView mv = CommonService.setCommonJspPath(tiles, "/user/_common/_Board/data/prc_board_data_deleteView");
		
		Map<String, Object> user = CommonService.getUserInfo(req);
		Menu = Component.getData("Menu.AMN_getMenuByKey", Menu);
		//관리자 검증
		if(user != null && "N".equals(user.get("isAdmin"))){
			mv.setViewName("redirect:"+Menu.getMN_URL());
			return mv;
		}
		
		if(!WeaknessService.selfBoardCheck(req,BoardNotice.getBN_KEYNO())){
			mv.setViewName("/error/board_auth");
			return mv;
		}
		HashMap<String, Object> noticeMap = BoardCommonService.getBoardDataByBoardNotice("BoardNotice.BN_getData",BoardNotice);
		mv.addObject("BoardNotice", noticeMap);
		mv.addObject("BoardType",Component.getData("BoardType.BT_getData", BoardType.getBT_KEYNO().trim()));
		mv.addObject("tiles", tiles);
		mv.addObject("mirrorPage", Menu.getMN_URL());
		
		//활동기록
		ActivityHistoryService.setDescBoardAction(Menu,(String)noticeMap.get("BN_TITLE"),"moveView", req);
		return mv;
	}

}
