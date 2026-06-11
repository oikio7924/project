package com.tx.dyAdmin.admin.board.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.config.annotation.service.ActivityHistoryService;
import com.tx.common.dto.Common;
import com.tx.common.security.password.MyPasswordEncoder;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.page.PageAccess;
import com.tx.dyAdmin.admin.board.dto.BoardColumn;
import com.tx.dyAdmin.admin.board.dto.BoardSkin;
import com.tx.dyAdmin.admin.board.dto.BoardType;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class BoardTypeController {

	 
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 페이지 처리 출 */
	@Autowired private PageAccess PageAccess;
	
	
	/** 암호화 */
	@Autowired MyPasswordEncoder passwordEncoder;
	
	/** 활동기록 서비스 */
	@Autowired private ActivityHistoryService ActivityHistoryService;
	/**
	 * 게시판 타입관리
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/board/typeView.do")
	@CheckActivityHistory(desc = "게시판 타입 페이지 방문", homeDiv= SettingData.HOMEDIV_ADMIN)
	public ModelAndView boardTypeView(HttpServletRequest req
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/board/type/pra_board_type_listView.adm");
		
		return mv;
	}
	
	/**
	 * 게시판 타입관리 - 페이징 ajax
	 * @param req
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/board/typeView/pagingAjax.do")
	public ModelAndView boardTypeViewPagingAjax(HttpServletRequest req,
			Common search
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/board/type/pra_board_type_listview_data");

		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"BoardType.BT_getListCnt",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		mv.addObject("resultList", Component.getList("BoardType.BT_getList", map));
		mv.addObject("search", search);
		return mv;
		
		
	}
	
	
	/**
	 * 게시판 타입관리 - excel ajax
	 * @param req
	 * @param res
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/board/typeView/excelAjax.do")
	public ModelAndView boardTypeViewExcelAjax(HttpServletRequest req
			, HttpServletResponse res
			, Common search
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/board/type/pra_board_type_listview_excel");
		
		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		mv.addObject("resultList", Component.getList("BoardType.BT_getList", map));
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
	
	@RequestMapping(value="/dyAdmin/homepage/board/type/actionView.do")
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	public ModelAndView BoardInsertView(
			  HttpServletRequest req
			, @ModelAttribute BoardType BoardType
			, @RequestParam(value="action") String action
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/board/type/pra_board_type_insertView.adm");
		
		//코드 AC 게시판 형태 ex)리스트형, 갤러리형
//		mv.addObject("MainCodeList", Component.getListNoParam("Code.AMC_GetList"));
		if(action != null && action.equals("updateView")){
			mv.addObject("BoardType",Component.getData("BoardType.BT_getData", BoardType.getBT_KEYNO()));
			mv.addObject("BoardColumnList",Component.getList("BoardColumn.BL_getList", BoardType.getBT_KEYNO()));
		}
		
		// 활동기록
		ActivityHistoryService.setDescBoardTypeAction(action, req);
		
		mv.addObject("SkinForm",Component.getListNoParam("BoardSkin.BST_FormList"));
		mv.addObject("PackageForm",Component.getListNoParam("BoardSkin.BSP_list"));
		mv.addObject("mirrorPage","/dyAdmin/homepage/board/typeView.do");
		mv.addObject("action",action);
		return mv;
	}
	
	
	@RequestMapping(value="/dyAdmin/homepage/board/type/action.do")
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView BoardUpdate(@ModelAttribute BoardType BoardType
			,@RequestParam(value="action") String action
			,@RequestParam(value="BL_KEYNO",required = false) String BL_KEYNO []
			,@RequestParam(value="BL_COLUMN_LEVEL",required = false) String BL_COLUMN_LEVEL []
			,@RequestParam(value="BL_COLUMN_NAME",required = false) String BL_COLUMN_NAME []
			,@RequestParam(value="BL_VALIDATE",required = false) String BL_VALIDATE []
			,@RequestParam(value="BL_LISTVIEW_YN",required = false) String BL_LISTVIEW_YN []
			,@RequestParam(value="BL_OPTION_DATA",required = false) String BL_OPTION_DATA []
			,@RequestParam(value="BL_TYPE",required = false) String BL_TYPE []
			,@RequestParam(value="delete_bl_keyno",required = false) String delete_bl_keyno []
			,@ModelAttribute BoardColumn boardcolumn
			,HttpServletRequest req
			) throws Exception {
		ModelAndView mv  = new ModelAndView("redirect:/dyAdmin/homepage/board/typeView.do");
		
		if(action != null){
			if(action.equals("insert")){
				BoardType.setBT_KEYNO(CommonService.getTableKey("BT"));
				Component.createData("BoardType.BT_insert", BoardType); 
			}else{
				Component.createData("BoardType.BT_update", BoardType);
			}
		}
		
		BoardColumn BoardColumn = new BoardColumn();
		BoardColumn.setBL_BT_KEYNO(BoardType.getBT_KEYNO());
		
		if(delete_bl_keyno != null){
			for(int i = 0; i < delete_bl_keyno.length; i++){
				Component.deleteData("BoardColumn.BL_delete", delete_bl_keyno[i]);
			}
		}
		
		if(BL_COLUMN_LEVEL.length==1){
			boardcolumn.setBL_BT_KEYNO(BoardType.getBT_KEYNO());
			if(StringUtils.isEmpty(boardcolumn.getBL_KEYNO())){
				Component.createData("BoardColumn.BL_insert", boardcolumn);
			}else{
				Component.updateData("BoardColumn.BL_update", boardcolumn);
			}
		}else{
			for(int i = 0; i < BL_COLUMN_LEVEL.length; i++){
				BoardColumn.setBL_KEYNO(BL_KEYNO[i]);
				BoardColumn.setBL_COLUMN_LEVEL(BL_COLUMN_LEVEL[i]);
				BoardColumn.setBL_COLUMN_NAME(BL_COLUMN_NAME[i]);
				BoardColumn.setBL_LISTVIEW_YN(BL_LISTVIEW_YN[i]);
				BoardColumn.setBL_OPTION_DATA(BL_OPTION_DATA[i]);
				BoardColumn.setBL_VALIDATE(BL_VALIDATE[i]);
				BoardColumn.setBL_TYPE(BL_TYPE[i]);
				if(StringUtils.isEmpty(BoardColumn.getBL_KEYNO())){
					Component.createData("BoardColumn.BL_insert", BoardColumn);
				}else{
					Component.updateData("BoardColumn.BL_update", BoardColumn);
				}
			}
		}
		
		// 활동기록
		ActivityHistoryService.setDescBoardTypeAction(action, req);
				
		return mv;
	}
	
	@RequestMapping(value = "/dyAdmin/homepage/board/type/updateView/listAjax.do")
	@ResponseBody
	public List<BoardColumn> columnlist(
			@ModelAttribute BoardColumn BoardColumn,HttpServletRequest req
		)throws Exception{
		return Component.getList("BoardColumn.BL_getList", BoardColumn.getBL_BT_KEYNO());
	}
	
	/**
	 * 게시판 타입 삭제
	 * @param BoardType
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/board/type/delete.do")
	@CheckActivityHistory(desc="게시판타입삭제 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView BoardDelete(@ModelAttribute BoardType BoardType
			,HttpServletRequest req
			) throws Exception {
		ModelAndView mv  = new ModelAndView("redirect:/dyAdmin/homepage/board/typeView.do");
		Component.updateData("BoardType.BT_delete", BoardType);
		
		return mv;
	}
	
	
	@RequestMapping(value="/dyAdmin/homepage/board/type/SkinDataSearch.do")
	@ResponseBody
	public BoardSkin BoardSkinajaxdata(
			BoardSkin boardSkin
			)throws Exception {

		return Component.getData("BoardSkin.BSP_getData",boardSkin);
	}
}
