package com.tx.dyAdmin.admin.board.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.admin.board.dto.BoardHtml;
import com.tx.dyAdmin.admin.board.dto.BoardType;
import com.tx.dyAdmin.homepage.menu.dto.Menu;

@Controller
public class BoardHtmlController {

	/** 공통 컴포넌트 */
	@Autowired
	ComponentService Component;
	@Autowired
	CommonService CommonService;

	
	@RequestMapping(value = "/dyAdmin/homepage/board/data/html/insertView.do")
	@CheckActivityHistory(desc = "게시물 소개 HTML 등록  페이지 방문")
	public ModelAndView BoardHtmlInsertView(HttpServletRequest req, @ModelAttribute Menu Menu,
			@ModelAttribute BoardHtml BoardHtml, @ModelAttribute BoardType BoardType) throws Exception {
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/board/html/pra_board_html_insertView.adm");
		mv.addObject("Menu", Menu);
		mv.addObject("BoardType", BoardType);
		mv.addObject("BoardHtml", Component.getData("BoardHtml.BIH_getData_pramMenukey", Menu.getMN_KEYNO()));
		mv.addObject("mirrorPage", "/dyAdmin/homepage/board/dataView.do");

		return mv;
	}

	@RequestMapping(value = "/dyAdmin/homepage/board/data/html/insert.do")
	@CheckActivityHistory(desc = "게시물 소개 HTML 등록  작업", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView BoardHtmlInsert(@ModelAttribute BoardHtml BoardHtml, HttpServletRequest req) throws Exception {
		ModelAndView mv = new ModelAndView("redirect: /dyAdmin/homepage/board/dataView.do?MN_KEYNO=" + BoardHtml.getBIH_MN_KEYNO());
		Component.createData("BoardHtml.BIH_insert", BoardHtml);
		
		HashMap<String, Object> modimap = new HashMap<>();
		modimap.put("MODNM", BoardHtml.getBIH_REGNM());
		modimap.put("MN_KEYNO", BoardHtml.getBIH_MN_KEYNO());
		Component.updateData("Menu.change_MenuModifyTime", modimap);
		return mv;
	}

	@RequestMapping(value = "/dyAdmin/homepage/board/data/html/update.do")
	@CheckActivityHistory(desc = "게시물 소개 HTML 수정 작업", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView BoardHtmlUpdate(@ModelAttribute BoardHtml BoardHtml, HttpServletRequest req) throws Exception {
		ModelAndView mv = new ModelAndView("redirect: /dyAdmin/homepage/board/dataView.do?MN_KEYNO=" + BoardHtml.getBIH_MN_KEYNO());
		Component.createData("BoardHtml.BIH_update", BoardHtml);
		
		HashMap<String, Object> modimap = new HashMap<>();
		modimap.put("MODNM", BoardHtml.getBIH_REGNM());
		modimap.put("MN_KEYNO", BoardHtml.getBIH_MN_KEYNO());
		Component.updateData("Menu.change_MenuModifyTime", modimap);
		return mv;
	}

	@RequestMapping(value = "/dyAdmin/homepage/board/data/html/delete.do")
	@CheckActivityHistory(desc = "게시물 소개 HTML 삭제 작업", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView BoardHtmlDelete(@ModelAttribute BoardHtml BoardHtml, HttpServletRequest req) throws Exception {
		ModelAndView mv = new ModelAndView("redirect: /dyAdmin/homepage/board/dataView.do?MN_KEYNO=" + BoardHtml.getBIH_MN_KEYNO());
		Component.createData("BoardHtml.BIH_use_update", BoardHtml);
		return mv;
	}

}