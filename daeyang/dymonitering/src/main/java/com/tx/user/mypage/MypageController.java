package com.tx.user.mypage;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.dto.Common;
import com.tx.common.security.password.MyPasswordEncoder;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.page.PageAccess;
import com.tx.dyAdmin.admin.site.service.SiteService;
import com.tx.dyAdmin.program.application.dto.ApplicationDTO;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
/**
 * 
 * @FileName: MemberController.java
 * @Project : cf
 * @Date    : 2017. 05. 31. 
 * @Author  : 이재령	
 * @Version : 1.0
 */
@Controller
public class MypageController {

	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 암호화 */
	@Autowired MyPasswordEncoder passwordEncoder;
	
    
    /** 페이지 처리 */
	@Autowired private PageAccess PageAccess;
	
	@Autowired SiteService SiteService;
	
	
	/**
	 * 회원 예매/신청조회 페이지
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/{tiles}/mypage/applycheck.do")
	@CheckActivityHistory(desc="회원 예매/신청조회 페이지 방문")
	public ModelAndView applycheck(
			  HttpServletRequest req
			  ,@PathVariable String tiles
			) throws Exception {
		String sitePath = SiteService.getSitePath(tiles);
		ModelAndView mv  = new ModelAndView("/user/"+sitePath+"/mypage/prc_applycheck");
		return mv;
	}
	
	
	/**
	 * 수강대상자 리스트 조회
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/{tiles}/mypage/ApplyUserListAjax.do")
	@ResponseBody
	public Map<String,Object> ApplyUserList(
			HttpServletRequest req
			, @RequestParam HashMap<String,Object> map
			, ApplicationDTO ApplicationDTO
			, @RequestParam("key") String APU_UI_KEYNO
			, @PathVariable String tiles
			) throws Exception {
		Map<String,Object> returnMap = new HashMap<String,Object>();
		
		ApplicationDTO.setAPU_UI_KEYNO(APU_UI_KEYNO);
		
		List<HashMap<String, Object>> UserList = Component.getList("mypage.APU_List", ApplicationDTO);
		returnMap.put("UserList", UserList);	//수강대상자리스트
		
		return returnMap;
	}
	
	
	/**
	 * 회원 예매/신청조회 상세 팝업
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/{tiles}/mypage/applycheck/applypopupAjax.do")
	@ResponseBody
	public HashMap<String, String> applypopup(
			 @RequestParam(value="GP_KEYNO",required= false) String GP_KEYNO
			, @PathVariable String tiles
			) throws Exception {
	    HashMap<String, String> applyData = Component.getData("mypage.tour_apply_detail", GP_KEYNO);
		return applyData;
	}
	
	/**
	 * 회원 예매/신청 내역 삭제
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	
	@RequestMapping(value="/{tiles}/mypage/applycheck/applyCancelAjax.do")
	@ResponseBody
	public void applyCancelAjax(
			 @RequestParam(value="GP_KEYNO",required= false) String GP_KEYNO
			, @PathVariable String tiles
			) throws Exception {
	
		ApplicationDTO ApplicationDTO = new ApplicationDTO();
		ApplicationDTO.setGP_KEYNO(GP_KEYNO);
		Component.updateData("mypage.tour_apply_cancel", GP_KEYNO);
		
	}
	
	/**
	 * 회원 예매/신청조회 수정 팝업
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/{tiles}/mypage/applycheck/applyUpdateAjax.do")
	@ResponseBody
	public int applyUpdateAjax(
			  @RequestParam(value="GP_KEYNO",required= false) String GP_KEYNO
			, @PathVariable String tiles
			) throws Exception {
		HashMap<String, Object> applyData = Component.getData("mypage.tour_apply_detail", GP_KEYNO);
		String GSS_KEYNO = Integer.toString((int) applyData.get("GP_GSS_KEYNO"));

			//총 정원
			Integer maxCnt = Component.getCount("Group.GSS_MAX", GSS_KEYNO);
			//해당 신청일자에 신청한 총 인원수
			Integer person = Component.getCount("Group.GP_DuplicateData", applyData);
			if(person == null) {
				person = 0;
			}
			int remainCnt = maxCnt - person;
	
		
		return remainCnt;
	}	
	
	
}
