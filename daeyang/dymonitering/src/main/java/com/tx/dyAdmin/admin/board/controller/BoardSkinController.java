package com.tx.dyAdmin.admin.board.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.config.annotation.service.ActivityHistoryService;
import com.tx.common.dto.Common;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.page.PageAccess;
import com.tx.common.service.publish.CommonPublishService;
import com.tx.dyAdmin.admin.board.dto.BoardSkin;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class BoardSkinController {

	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	/** 페이지 처리 출 */
	@Autowired private PageAccess PageAccess;
	/** 퍼블리쉬 관리 툴 */
	@Autowired private CommonPublishService CommonPublishService;
	/** 활동기록 서비스 */
	@Autowired
	private ActivityHistoryService ActivityHistoryService;
	
	@RequestMapping(value="/dyAdmin/homepage/board/skin/boardSkin.do")
	@CheckActivityHistory(desc="스킨 게시물 개별페이지 ", homeDiv= SettingData.HOMEDIV_ADMIN)
	public ModelAndView boardSkin(HttpServletRequest req) throws Exception{
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/board/skin/pra_board_skin_listView.adm");
		
		return mv;
	}
	
	@RequestMapping(value="/dyAdmin/homepage/board/skin/boardSkinAjax.do")
	public ModelAndView boardSkinAjax(
			HttpServletRequest req,
			Common search
			) throws Exception{
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/board/skin/pra_board_skin_listView_data");
		
		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"BoardSkin.BST_getListCnt",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		mv.addObject("resultList", Component.getList("BoardSkin.BST_getList", map));
		mv.addObject("search", search);
		
		return mv;
	}
	
	@RequestMapping(value="/dyAdmin/homepage/board/skin/boardSkin_InsertView.do")
	@CheckActivityHistory(desc="스킨 게시물 등록페이지 방문 ", homeDiv= SettingData.HOMEDIV_ADMIN)
	public ModelAndView boardSkinInsertView(HttpServletRequest req
			,@RequestParam(value="type",defaultValue="insert")String type
			,BoardSkin BoardSkin
			) throws Exception{
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/board/skin/pra_board_skin_insertView.adm");
		
		if(type.equals("update")) mv.addObject("BST",Component.getData("BoardSkin.BST_getData",BoardSkin));
		
		mv.addObject("FormList",Component.getListNoParam("BoardSkin.BST_FormList"));
		mv.addObject("action",type);
		
		mv.addObject("mirrorPage","/dyAdmin/homepage/board/skin/boardSkin.do");
		return mv;
	}
	
	@RequestMapping(value="/dyAdmin/homepage/board/skin/boardSkin_Action.do")
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	public ModelAndView boardSkinInsert(
			HttpServletRequest req
			,BoardSkin boardSkin
			,@RequestParam(value="action",required=false)String action
			,RedirectAttributes redirectAttributes
			) throws Exception{
		ModelAndView mv = new ModelAndView("redirect:/dyAdmin/homepage/board/skin/boardSkin.do");
		
		String query = "BoardSkin.BST_insert";
		String msg = "저장되었습니다.";
		
		if("update".equals(action)){
			query = "BoardSkin.BST_update";
			msg = "수정되었습니다.";
		}else if("delete".equals(action)){
			query = "BoardSkin.BST_delete";
			msg = "삭제되었습니다.";
		}
		
		// 활동기록
		ActivityHistoryService.setDescBoardSkinAction("게시판 스킨", action, req);
		Component.createData(query, boardSkin);
		redirectAttributes.addFlashAttribute("msg",msg);
		return mv;
	}
	
	@RequestMapping(value = "/dyAdmin/homepage/board/skin/boardSkinDistributeAjax.do")
	@ResponseBody
	public boolean boardSkinDistributeAjax(
			HttpServletRequest req
			,BoardSkin boardSkin)
			throws Exception {
		
		return CommonPublishService.BoardTemplate(boardSkin);
	}
	
	
	/*******************************************************************************************************************/
	/**
	 * 스킨 패키지 관리부분 시작!!!!!!!!!!!
	 */
	@RequestMapping(value = "/dyAdmin/homepage/board/skin/boardSkinPackage.do")
	@CheckActivityHistory(desc="스킨 패키지 관리자 페이지 ", homeDiv= SettingData.HOMEDIV_ADMIN)
	public ModelAndView boardSkinPackage(HttpServletRequest req) throws Exception{
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/board/skin/package/pra_boardPakage_skin_listView.adm");
		
		return mv;
	}
	
	
	@RequestMapping(value = "/dyAdmin/homepage/board/skin/boardSkinPakageAjax.do")
	public ModelAndView boardSkinPakageAjax(HttpServletRequest req
			,Common search
			) throws Exception{
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/board/skin/package/pra_boardPakage_skin_listView_data");

		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"BoardSkin.BSP_getListCnt",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		mv.addObject("resultList", Component.getList("BoardSkin.BSP_getList", map));
		mv.addObject("search", search);
		
		return mv;
	}
	
	
	@RequestMapping(value = "/dyAdmin/homepage/board/skin/boardSkinPackageInsertView.do")
	@CheckActivityHistory(desc="스킨 패키지 등록 페이지", homeDiv= SettingData.HOMEDIV_ADMIN)
	public ModelAndView boardSkinPackageInsertView(HttpServletRequest req
				,@RequestParam(value="type", defaultValue="insert") String type
				,BoardSkin BoardSkin
				) throws Exception{
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/board/skin/package/pra_boardPakage_skin_insertView.adm");
		
		if(type.equals("update")) mv.addObject("BSP",Component.getData("BoardSkin.BSP_getData",BoardSkin));

		BoardSkin boardTemp = new BoardSkin(); 
		
		mv.addObject("FormList",Component.getList("BoardSkin.BST_FormList",boardTemp));
		
		mv.addObject("action",type);
		mv.addObject("mirrorPage","/dyAdmin/homepage/board/skin/boardSkinPackage.do");
		return mv;
	}
	
	@RequestMapping(value="/dyAdmin/homepage/board/skin/boardSkinPackage_Action.do")
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	public ModelAndView boardSkinPackageInsert(
			HttpServletRequest req
			,BoardSkin boardSkin
			,@RequestParam(value="action",required=false)String action
			,RedirectAttributes redirectAttributes
			) throws Exception{
		ModelAndView mv = new ModelAndView("redirect:/dyAdmin/homepage/board/skin/boardSkinPackage.do");
		
		String query = "BoardSkin.BSP_insert";
		String msg = "저장되었습니다.";
		
		if("update".equals(action)){
			query = "BoardSkin.BSP_update";
			msg = "수정되었습니다.";
		}else if("delete".equals(action)){
			query = "BoardSkin.BSP_delete";
			msg = "삭제되었습니다.";
		}
		
		// 활동기록
		ActivityHistoryService.setDescBoardSkinAction("게시판 스킨 패키지", action, req);
		Component.createData(query, boardSkin);
		redirectAttributes.addFlashAttribute("msg",msg);
		
		return mv;
	}

	@RequestMapping(value = "/dyAdmin/homepage/board/skin/boardSkinPackageAjax.do")
	@CheckActivityHistory(desc="스킨 패키지 배포", homeDiv= SettingData.HOMEDIV_ADMIN)
	@ResponseBody
	public boolean boardSkinPackageAjax(
			HttpServletRequest req
			,BoardSkin boardSkin)
			throws Exception {
		boardSkin = Component.getData("BoardSkin.BSP_getData_WithForm",boardSkin);
		return CommonPublishService.BoardTemplatePackage(boardSkin);
	}
	
}
