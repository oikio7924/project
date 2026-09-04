package com.tx.user.board.controller;



import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.security.password.MyPasswordEncoder;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.page.PageAccess;
import com.tx.dyAdmin.admin.board.dto.BoardComment;
import com.tx.dyAdmin.admin.board.dto.BoardType;
import com.tx.dyAdmin.admin.board.service.BoardCommonService;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class UserBoardCommentController {

	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;

	/** 암호화 */
	@Autowired MyPasswordEncoder passwordEncoder;
	
	@Autowired BoardCommonService BoardCommonService;
	
	/** 페이지 처리 출 */
	@Autowired private PageAccess PageAccess;
	
	/**
	 * 유저 댓글 리스트
	 * @param 
	 * @throws Exception  
	 */ 
	@RequestMapping(value="/{tiles}/Board/comment/listAjax.do")
	public ModelAndView CommentListAjax(@ModelAttribute BoardComment BoardComment
			, HttpServletRequest req
			, @PathVariable String tiles
			, @RequestParam(value="BT_SECRET_COMMENT_YN", required=false) String BT_SECRET_COMMENT_YN
			, @RequestParam(value="BT_DEL_COMMENT_YN", required=false) String BT_DEL_COMMENT_YN
			, BoardType BoardType
			, @RequestParam(value="type", required=false) String type
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/user/_common/_Board/data/detailView/prc_board_data_detailView_reply_ajax"); 
		
		Map<String, Object> user = CommonService.getUserInfo(req);
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("BC_BN_KEYNO", BoardComment.getBC_BN_KEYNO());
		map.put("DEL_COMMENT_YN", BT_DEL_COMMENT_YN);
		
		if(!"page".equals(type)) {
			PaginationInfo pageInfo = PageAccess.getPagInfo(1,"BoardComment.BC_getListCnt",map, BoardType.getBT_PAGEUNIT_C(), BoardType.getBT_PAGESIZE_C());
			BoardComment.setPageIndex(pageInfo.getTotalPageCount());
		}
		
	
		PaginationInfo pageInfo = PageAccess.getPagInfo(BoardComment.getPageIndex(),"BoardComment.BC_getListCnt",map, BoardType.getBT_PAGEUNIT_C(), BoardType.getBT_PAGESIZE_C());
		
		map.put("pageIndex", pageInfo.getCurrentPageNo());
		map.put("bestCount", 3); //best 조건
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		//관리자 검증
		if(user != null){
			String isAdmin = (String)user.get("isAdmin");
			String UI_KEYNO = user.get("UI_KEYNO")+"";
			mv.addObject("isAdmin", isAdmin);
			map.put("UI_KEYNO", UI_KEYNO);
		} else {
			mv.addObject("isAdmin", "N");
		}
		
		mv.addObject("paginationInfo", pageInfo);
		mv.addObject("BT_SECRET_COMMENT_YN", BT_SECRET_COMMENT_YN);
		mv.addObject("BoardCommentList", Component.getList("BoardComment.BC_getList",map));
		
		return mv;
	}
	

	/**
	 * 유저 댓글 등록
	 * @param 
	 * @throws Exception  
	 */ 
	@RequestMapping(value="/{tiles}/Board/comment/insertAjax.do")
	@Transactional
	@ResponseBody
	public boolean CommentInsert(BoardComment BoardComment
			,HttpServletRequest req
			) throws Exception {
		
		Map<String, Object> user = CommonService.getUserInfo(req);
		BoardComment.setBC_BN_KEYNO(BoardComment.getBC_BN_KEYNO());
		BoardComment.setBC_CONTENTS(BoardComment.getBC_CONTENTS());
		BoardComment.setBC_REGNM((String) user.get("UI_KEYNO"));
		
		Component.createData("BoardComment.BC_insert", BoardComment);
		
		return true;
	}
	
	
	/**
	 * 유저 댓글 수정
	 * @param 
	 * @throws Exception  
	 */ 
	@RequestMapping(value="/{tiles}/Board/comment/updateAjax.do")
	@Transactional
	@ResponseBody
	public void CommentUpdate(@ModelAttribute BoardComment BoardComment
			,HttpServletRequest req
			) throws Exception {
		
		Component.updateData("BoardComment.BC_update", BoardComment);
		
	}
	
	/**
	 * 유저 댓글 삭제
	 * @param 
	 * @throws Exception  
	 */ 
	@RequestMapping(value="/{tiles}/Board/comment/deleteAjax.do")
	@Transactional
	@ResponseBody
	public void CommentDlelte(@ModelAttribute BoardComment BoardComment
			,HttpServletRequest req
			) throws Exception {
		
		Component.updateData("BoardComment.BC_delete", BoardComment);
		
	}
	
	/**
	 * 유저 댓글 좋아요
	 * @param 
	 * @throws Exception  
	 */ 
	@RequestMapping(value="/{tiles}/Board/comment/likeUpdateAjax.do")
	@Transactional
	@ResponseBody
	public HashMap<String, Object> CommentLikeUpdate(
			 HttpServletRequest req
			,@ModelAttribute BoardComment BoardComment
			,@RequestParam(value="TYPE", required=false) String type
			) throws Exception {

		HashMap<String, Object> retrunType = new HashMap<>();
		Map<String, Object> user = CommonService.getUserInfo(req);
		
		if(user != null){
			String BC_KEYNO = BoardComment.getBC_KEYNO();
			BoardComment.setBCS_UI_KEYNO((String)user.get("UI_KEYNO"));
			BoardComment.setBCS_BC_KEYNO(BC_KEYNO);
			BoardComment.setBCS_TYPE(type);
			HashMap<String, Object> likeMap  = Component.getData("BoardComment.BCS_getCnt", BoardComment);
			if(likeMap != null){
				String bcs_type = (String)likeMap.get("BCS_TYPE");
		        int bcs_cnt = Integer.parseInt(String.valueOf(likeMap.get("NUM")));
				if(bcs_cnt > 0 && bcs_type != null){
					retrunType.put("type", "msg");
					if(!type.equals(bcs_type)){
						if(bcs_type.equals("Y")){
							retrunType.put("value", "이미 좋아요하신 글입니다.");
						}else{
							retrunType.put("value", "이미 싫어요하신 글입니다.");
						}
					}else{
						Component.deleteData("BoardComment.BCS_delete", BoardComment );
						retrunType.put("result", "success");
						retrunType.put("type", "del");
						retrunType.put("value", Component.getData("BoardComment.BCS_getCnt2", BoardComment));
					}
				}else{
					Component.createData("BoardComment.BCS_insert", BoardComment );
					retrunType.put("result", "success");
					retrunType.put("type", "int");
					retrunType.put("value", Component.getData("BoardComment.BCS_getCnt2", BoardComment));
				}
			}
		}else{
			retrunType.put("result", "error");
		}
		
		return retrunType;
	}
	
	
	
}
