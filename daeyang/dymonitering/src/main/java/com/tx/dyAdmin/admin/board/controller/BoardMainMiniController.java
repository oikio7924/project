package com.tx.dyAdmin.admin.board.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.dto.Common;
import com.tx.common.file.FileManageTools;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.page.PageAccess;
import com.tx.common.service.publish.CommonPublishService;
import com.tx.dyAdmin.admin.board.dto.BoardMainMini;
import com.tx.dyAdmin.homepage.menu.dto.Menu;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class BoardMainMiniController {

	 
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 페이지 처리 출 */
	@Autowired private PageAccess PageAccess;
	
	/** 파일관리 툴 */
	@Autowired FileManageTools FileManageTools;
	
	@Autowired private CommonPublishService CommonPublishService;
	
	/**
	 * 메인미니게시판 관리
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/board/MainMiniBoard.do")
	@CheckActivityHistory(desc="메인미니게시판 관리 페이지 방문")
	public ModelAndView MainMiniBoardView(HttpServletRequest req
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/board/mainmini/pra_board_mainmini_listView.adm");
		return mv;
	}
	
	/**
	 * 메인미니게시판 관리 - 페이징 ajax
	 * @param req
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/board/MainMiniBoardView/pagingAjax.do")
	public ModelAndView MainMiniBoardViewPagingAjax(HttpServletRequest req,
			Common search
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/board/mainmini/pra_board_mainmini_listview_data");

		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"BoardMainMini.BMM_getListCnt",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		mv.addObject("resultList", Component.getList("BoardMainMini.BMM_getList", map));
		mv.addObject("homeDivList", CommonService.getHomeDivCode(true));
		mv.addObject("search", search);
		return mv;
	}
	
	@RequestMapping(value="/dyAdmin/homepage/board/MainMiniBoard/insertView.do")
	@CheckActivityHistory(desc="미니게시판 등록 페이지 방문")
	public ModelAndView MainMiniBoardInsertView(HttpServletRequest req
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/board/mainmini/pra_board_mainmini_insertView.adm");
		
		mv.addObject("homeDivList", CommonService.getHomeDivCode(true));
		mv.addObject("formDataList", Component.getListNoParam("BoardMainMini.BMM_getFormList"));
		mv.addObject("type","insert");
		mv.addObject("mirrorPage","/dyAdmin/homepage/board/MainMiniBoard.do");
		return mv;
	}
	
	@RequestMapping(value="/dyAdmin/homepage/board/MainMiniBoard/updateView.do")
	@CheckActivityHistory(desc="미니게시판 수정/상세 페이지 방문")
	public ModelAndView MainMiniBoardUpdateView(HttpServletRequest req
			, BoardMainMini BoardMainMini) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/board/mainmini/pra_board_mainmini_insertView.adm");
		
		mv.addObject("homeDivList", CommonService.getHomeDivCode(true));
		//데이터 가져오기
		mv.addObject("BMM_DATA", Component.getData("BoardMainMini.BMM_getData", BoardMainMini));
		mv.addObject("formDataList", Component.getListNoParam("BoardMainMini.BMM_getFormList"));
		mv.addObject("mirrorPage","/dyAdmin/homepage/board/MainMiniBoard.do");
		mv.addObject("type","update");
		return mv;
	}
	
	@RequestMapping(value = "/dyAdmin/homepage/board/MainMiniBoard/update.do")
	@CheckActivityHistory(desc="미니게시판 수정 처리", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView MainMiniBoardUpdate(BoardMainMini BoardMainMini,  HttpServletRequest req)
			throws Exception {
		ModelAndView mv = new ModelAndView("redirect:/dyAdmin/homepage/board/MainMiniBoard.do");
		
		Component.updateData("BoardMainMini.BMM_update", BoardMainMini);
		
		CommonPublishService.miniBoard(BoardMainMini);

		return mv;
	}
	
	@RequestMapping(value = "/dyAdmin/homepage/board/MainMiniBoard/delete.do")
	@CheckActivityHistory(desc="미니게시판 삭제 처리", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView MainMiniBoardDelete(BoardMainMini BoardMainMini,  HttpServletRequest req)
			throws Exception {
		ModelAndView mv = new ModelAndView("redirect:/dyAdmin/homepage/board/MainMiniBoard.do");
		
		Component.updateData("BoardMainMini.BMM_delete", BoardMainMini);

		return mv;
	}
	
	
	/**
	 * 게시판 선택 시 게시판에 해당 되는 컬럼 데이터 불러오기
	 * 
	 * @param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/board/MainMiniBoard/board/selectAjax.do")
	@ResponseBody
	public List<HashMap<String,Object>> selectAjax(HttpServletRequest req, @ModelAttribute Menu Menu) throws Exception {
		
		HashMap<String, Object> map = new HashMap<>();
		map.put("MN_KEYNO", Menu.getMN_KEYNO());
		
		List<HashMap<String,Object>> list = Component.getList("BoardMainMini.BoardColumn_List", map);
		
		return list;
	}
	
	@RequestMapping(value = "/dyAdmin/homepage/board/MainMiniBoard/insert.do")
	@CheckActivityHistory(desc="미니게시판 등록 처리", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView MainMiniBoardInsert(BoardMainMini BoardMainMini,  HttpServletRequest req)
			throws Exception {
		ModelAndView mv = new ModelAndView("redirect:/dyAdmin/homepage/board/MainMiniBoard.do");
		
		BoardMainMini.setBMM_KEYNO(CommonService.getTableKey("BMM"));
		Component.createData("BoardMainMini.BMM_insert", BoardMainMini);
		
		CommonPublishService.miniBoard(BoardMainMini);
		
		return mv;
	}
	
	@RequestMapping(value = "/dyAdmin/homepage/board/MainMiniBoard/publishAjax.do")
	@ResponseBody
	@CheckActivityHistory(desc="미니게시판 파일 배포 처리", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public boolean publishFile(BoardMainMini BoardMainMini, HttpServletRequest req)
			throws Exception {
		
		
		return CommonPublishService.miniBoard(BoardMainMini);
		
	}
	
}
