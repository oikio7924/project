package com.tx.dyAdmin.homepage.popup.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.nhncorp.lucy.security.xss.XssFilter;
import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.dto.Common;
import com.tx.common.file.FileUploadTools;
import com.tx.common.file.dto.FileSub;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.page.PageAccess;
import com.tx.common.service.publish.CommonPublishService;
import com.tx.dyAdmin.admin.domain.dto.HomeManager;
import com.tx.dyAdmin.homepage.menu.dto.Menu;
import com.tx.dyAdmin.homepage.menu.service.AdminMenuService;
import com.tx.dyAdmin.homepage.popup.dto.PopupDTO;
import com.tx.dyAdmin.homepage.popup.dto.PopupSkinDTO;
import com.tx.dyAdmin.homepage.popup.dto.Popup_subDTO;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;


/**
 * 
 * @FileName: PopupController.java
 * @Project : popup
 * @Date    : 2017. 02. 10. 
 * @Author  : 양석기	
 * @Version : 1.0
 */
@Controller
public class PopupController {
	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 페이지 처리 출 */
	@Autowired private PageAccess PageAccess;
	
	/** 파일업로드 툴*/
	@Autowired private FileUploadTools FileUploadTools;
	
	/** 메뉴리스트 서비스 */
	@Autowired private AdminMenuService AdminMenuService;
	
	@Autowired private CommonPublishService CommonPublishService;
	
	/**
	 * 팝업관리
	 * @param commandMap
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/popup/popup.do")
	@CheckActivityHistory(desc="팝업 관리 페이지 방문")
	public ModelAndView popupMain(Map<String,Object> commandMap
			, @RequestParam(value="msg",defaultValue="", required=false) String msg
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/popup/pra_popup_listView.adm");
		
		return mv;
	}
	
	/**
	 * 팝업관리 - 페이징 ajax
	 * @param req
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/popup/pagingAjax.do")
	public ModelAndView boardTypeViewPagingAjax(HttpServletRequest req
			, Common search
			, @RequestParam(value="PI_CHECK", required=false) String PI_CHECK
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/popup/pra_popup_listView_data");

		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		map.put("PI_CHECK", PI_CHECK);
		
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"Popup.PI_getListCnt_1",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		mv.addObject("resultList", Component.getList("Popup.PI_getList_1", map));
		mv.addObject("search", search);
		
		SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat ( "yyyy-MM-dd", Locale.KOREA );
		Date currentTime = new Date ();
		String sysdate = mSimpleDateFormat.format ( currentTime );
    	mv.addObject("sysdate", sysdate);
    	
    	mv.addObject("MN_HOMEDIV_C", CommonService.getDefaultSiteKey(req));
		
		return mv;
		
	}
	
	
	/**
	 * 팝업관리 - excel ajax
	 * @param req
	 * @param res
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/popup/excelAjax.do")
	public ModelAndView boardTypeViewExcelAjax(HttpServletRequest req
			, HttpServletResponse res
			, Common search
			, @RequestParam String PI_CHECK
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/popup/pra_popup_listView_data_excel");
		
		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		mv.addObject("resultList", Component.getList("Popup.PI_getList_1", map));
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
	
	/**
	 * 팝업 등록 페이지 방문
	 * @param req
	 * @param PopupDTO
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/popup/insertView.do")
	@CheckActivityHistory(desc="팝업 추가 등록 페이지 방문")
	public ModelAndView popupAdd(HttpServletRequest req
			, PopupDTO PopupDTO
			, @RequestParam(value="msg",defaultValue="") String msg
			, @RequestParam(value="action",defaultValue="insert") String action
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/popup/pra_popup_insertView.adm");
		
		String MN_HOMEDIV_C = CommonService.getDefaultSiteKey(req);
		
		if(!msg.equals("")){
			mv.addObject("msg",msg);
		}
		//홈페이지 구분 리스트
		HashMap<String, Object> popupData = Component.getData("Popup.PI_select", PopupDTO);
		 
		if(popupData != null) {
			action = "update";
			//xss filter
			XssFilter filter = XssFilter.getInstance("lucy-xss-superset.xml");
			if(popupData.get("PI_CONTENTS") != null && !popupData.get("PI_CONTENTS").equals("")){
            	popupData.put("PI_CONTENTS", filter.doFilter(popupData.get("PI_CONTENTS").toString()));
            }
			PopupDTO.setPI_HOMEKEY(MN_HOMEDIV_C);
			mv.addObject("popupSubListData", Component.getList("Popup.PI_select_one",PopupDTO));
		}
		mv.addObject("action", action);
		mv.addObject("popupData", popupData);
		mv.addObject("MN_HOMEDIV_C", MN_HOMEDIV_C);
		mv.addObject("mirrorPage", "/dyAdmin/homepage/popup/popup.do");
		
		return mv;
	}
	
	
	/**
	 * 팝업 등록작업
	 * @param commandMap
	 * @param PopupDTO
	 * @param req
	 * @param Popup_subDTO
	 * @param fileW
	 * @param fileA
	 * @param resize
	 * @param MN_MENU_TITLE
	 * @param MN_SUB_TITLE
	 * @param redirectAttributes
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/popup/insert.do")
	@CheckActivityHistory(desc="팝업 등록 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView popupSave(HttpServletRequest req
			,@ModelAttribute PopupDTO PopupDTO
			,@ModelAttribute Popup_subDTO Popup_subDTO
			,@RequestParam(value="fileW", required=false) MultipartFile fileW
			,@RequestParam(value="fileA", required=false) MultipartFile fileA
			,@RequestParam(value="resize", defaultValue="Ninsert") String resize
			,@RequestParam(value="MN_HOMEDIV_C") String MN_HOMEDIV_C
			,@RequestParam(value="popupSubListKey") String popupSubListKey
			,@RequestParam(value="popupSubListType") String popupSubListType
			,@RequestParam(value="action") String action
			,RedirectAttributes redirectAttributes
			) throws Exception {
		ModelAndView mv  = new ModelAndView("redirect:/dyAdmin/homepage/popup/popup.do");
		redirectAttributes.addFlashAttribute("msg","성공적으로 등록되었습니다.");
		
		int width = 0;
		int height = 0;
		PopupDTO.setPI_RESIZE_CHECK(resize);
		PopupDTO.setPI_CHECK("Y");
		
		if(PopupDTO.getPI_DIVISION().equals("W")){
			PopupDTO.setPI_TOP_LOC(PopupDTO.getPI_TOP_LOC().equals("")? "10" : PopupDTO.getPI_TOP_LOC());    //상단 위치
			PopupDTO.setPI_LEFT_LOC(PopupDTO.getPI_LEFT_LOC().equals("")? "10" : PopupDTO.getPI_LEFT_LOC()); //왼쪽 위치
			PopupDTO.setPI_WIDTH(PopupDTO.getPI_WIDTH().equals("")? "300" : PopupDTO.getPI_WIDTH()); 		 //팝업 너비
			PopupDTO.setPI_HEIGHT(PopupDTO.getPI_HEIGHT().equals("")? "300" : PopupDTO.getPI_HEIGHT());      //팝업 높이		
			
			width = Integer.parseInt(PopupDTO.getPI_WIDTH());
			height = Integer.parseInt(PopupDTO.getPI_HEIGHT());
			
		}else if(PopupDTO.getPI_DIVISION().equals("B")){
			width = SettingData.DEFAULT_IMG_POPUP_WIDTH;
			height = SettingData.DEFAULT_IMG_POPUP_HEIGHT;
		}
		
		MultipartFile file = null;
		
		if(fileW != null && !fileW.isEmpty()){
			file = fileW;
		}else if(fileA != null && !fileA.isEmpty()){
			file = fileA;
		}
		
		if(file != null){
			Map<String, Object> map = CommonService.getUserInfo(req);
			FileSub FileSub = new FileSub();
			FileSub.setFS_FM_KEYNO("none");
			
			if(StringUtils.isNotBlank(PopupDTO.getPI_FS_KEYNO())){
				if("Y".equals(resize)){
					FileSub = FileUploadTools.FileUpload(file, FileSub, (String)map.get("UI_KEYNO"),width,height,req);
				}else{
					FileSub = FileUploadTools.FileUpload(file, FileSub, (String)map.get("UI_KEYNO"), false,req);
				}
			}else{
				FileSub = FileUploadTools.imageChange(PopupDTO.getPI_FS_KEYNO(), file, (String)map.get("UI_KEYNO"),"Y".equals(resize),req);
			}
            if(FileSub != null){
                PopupDTO.setPI_FS_KEYNO(FileSub.getFS_KEYNO());
            }

		}
		
		if(StringUtils.isEmpty(PopupDTO.getPI_FS_KEYNO())) PopupDTO.setPI_FS_KEYNO(null); 	//fs 없으면 null
		
		String PI_KEY = PopupDTO.getPI_KEYNO();
		Popup_subDTO.setPC_PI_KEYNO(PI_KEY);		//팝업서브메인키
		Popup_subDTO.setPC_MAINKEY(MN_HOMEDIV_C);	//홈페이지 키
		
		if("insert".equals(action)){
			PI_KEY = CommonService.getTableKey("PI");
			PopupDTO.setPI_KEYNO(PI_KEY);				//팝업 기본키
			Component.createData("Popup.PI_insert",PopupDTO);
		}else{
			//팝업 서브에 삭제후 다시 추가
			Component.deleteData("Popup.SUB_POPUP_DELETE", Popup_subDTO);	
			Component.updateData("Popup.PI_update", PopupDTO);		
		}

		if(StringUtils.isNotEmpty(popupSubListKey)){
			String[] subKey = popupSubListKey.split(",",-1);
			String[] subType = popupSubListType.split(",",-1);
			
			for(int i=0; i < subKey.length; i++) {
				Popup_subDTO.setPC_PI_MN_TYPE(subType[i]);
				Popup_subDTO.setPC_SUBKEY(subKey[i]);
				Component.createData("Popup.PC_insert", Popup_subDTO);
			}
			
		}
		
		return mv;
	}
	
	/**
	 * 메뉴 리스트
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 * 
	 */   
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/dyAdmin/homepage/popup/menu/listAjax.do")
	@ResponseBody
	public HashMap<String, Object> MenuManagerSubList(Model model,Menu Menu) throws Exception{ 
		
		HashMap<String, Object> map = new HashMap<>();
		List list= Component.getList("Menu.AMN_getUserMenuListByHOMEDIV3",Menu);
		map.put("list", list);
		
		return map;
	}
	
	
	/**
	 * 팝업 삭제 작업
	 * @param PopupDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/popup/deleteAjax.do")
	@CheckActivityHistory(desc="팝업 삭제 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@ResponseBody
	public ModelAndView popupDelete(PopupDTO PopupDTO) throws Exception{
		ModelAndView mv  = new ModelAndView("redirect:/dyAdmin/homepage/popup/popup.do");
	    Component.deleteData("Popup.PI_delete", PopupDTO); 
	    return mv;
	}
	
	/**
	 * 사용여부
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/popup/check.do")
	@Transactional
	public ModelAndView popupCheck(PopupDTO PopupDTO) throws Exception {
		
		if(PopupDTO.getPI_CHECK().equals("Y")){
			Component.updateData("Popup.PI_choiceY", PopupDTO);
		}else{
			Component.updateData("Popup.PI_choiceN", PopupDTO);
		}
		ModelAndView mv  = new ModelAndView("redirect:/dyAdmin/homepage/popup/popup.do");
		return mv;
	}
	
	
	
	/**
	 * 메뉴별팝업관리 테이블 뷰
	 * @param req
	 * @param Sub_value
	 * @param type_b
	 * @param search_sub
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/popup/popup_list_tableAjax.do")
	public ModelAndView popup_list_subAjax(
			HttpServletRequest req
			,@RequestParam (value="pageIndex", required=false) Integer pageIndex
			,@RequestParam (value="Sub_value", required=false) String Sub_value
			,@RequestParam (value="type_b", required=false) String type_b
			, Common search_sub
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/popup/pra_popup_listView_data_table");
		
		HashMap<String,Object> map = new HashMap<>();
		
		map.put("pageIndex", pageIndex);
		map.put("Sub_value", Sub_value);
		map.put("type_b", type_b);
		
		PaginationInfo pageInfo_sub = PageAccess.getPagInfo(pageIndex,"Popup.PI_getSubListCnt",map, 10, 10);
		
		map.put("firstIndex", pageInfo_sub.getFirstRecordIndex());
		map.put("lastIndex", pageInfo_sub.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo_sub.getRecordCountPerPage());
		
		mv.addObject("subPaginationInfo", pageInfo_sub);
		mv.addObject("resultList_sub", Component.getList("Popup.PI_getSubList", map));
		
    	return mv;
	}
	

	/**
	 * 메뉴리스트 불러오기
	 * @param req
	 * @param mn_keyno
	 * @param name
	 * @param search_sub
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/popup/popup_menuListAjax.do")
	@ResponseBody
	public ModelAndView popup_menuList_mainAjax(HttpServletRequest req
			,Menu Menu
			,@RequestParam(value="pageName",required=false) String pageName
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/popup/"+pageName);

		Menu.setMN_DEL_YN("N");
		HomeManager homeManager = Component.getData("Menu.AMN_getMenuList",Menu);
		//권한별 메뉴 조회
		Map<String,Object> user = CommonService.getUserInfo(req);
		String userKeyno = ((String) user.get("UI_KEYNO"));
		String UIA_KEYNO = Component.getData("Authority.UIA_getDataByUIKEYNO", userKeyno);
		homeManager.setHM_MN_HOMEDIV_C(CommonService.getDefaultSiteKey(req));
		homeManager.setUIA_KEYNO(UIA_KEYNO);
			
		mv.addObject("homeManager", homeManager);
		mv.addObject("menuList", AdminMenuService.getMenuList(homeManager,null,false,true,true));
		
		return mv;
	}
	
	
	
	/**
	 * 팝업 스킨관리
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/popup/popupSkin.do")
	@CheckActivityHistory(desc="팝업 스킨관리 페이지 방문")
	public ModelAndView PopupSkinView(HttpServletRequest req
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/popup/skin/pra_popup_skin_listView.adm");
		return mv;
	}
	
	/**
	 * 팝업 스킨관리 - 페이징 ajax
	 * @param req
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/popupSkin/pagingAjax.do")
	public ModelAndView PopupSkinViewPagingAjax(HttpServletRequest req,
			Common search
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/popup/skin/pra_popup_skin_listView_data");

		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"Popup.PIS_getListCnt",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		mv.addObject("resultList", Component.getList("Popup.PIS_getList", map));
		mv.addObject("homeDivList", CommonService.getHomeDivCode(true));
		mv.addObject("search", search);
		return mv;
	}
	
	@RequestMapping(value="/dyAdmin/homepage/popupSkin/insertView.do")
	@CheckActivityHistory(desc="팝업 스킨 등록 페이지 방문")
	public ModelAndView PopupSkinInsertView(HttpServletRequest req
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/popup/skin/pra_popup_skin_insertView.adm");
		
		mv.addObject("homeDivList", CommonService.getHomeDivCode(true));
		mv.addObject("formDataList", Component.getListNoParam("Popup.PIS_getFormList"));
		mv.addObject("type","insert");
		mv.addObject("mirrorPage","/dyAdmin/homepage/popup/popupSkin.do");
		return mv;
	}
	
	@RequestMapping(value="/dyAdmin/homepage/popupSkin/updateView.do")
	@CheckActivityHistory(desc="팝업 스킨 수정/상세 페이지 방문")
	public ModelAndView PopupSkinUpdateView(HttpServletRequest req
			, PopupSkinDTO PopupSkinDTO) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/popup/skin/pra_popup_skin_insertView.adm");
		
		mv.addObject("homeDivList", CommonService.getHomeDivCode(true));
		//데이터 가져오기
		HashMap<String, Object> map = Component.getData("Popup.PIS_getData", PopupSkinDTO);
		mv.addObject("PIS_DATA", map);
		
		map = Component.getData("Popup.PIS_getSkinUsingHP", PopupSkinDTO);
		mv.addObject("PIS_HP", map);
		
		mv.addObject("formDataList", Component.getList("Popup.PIS_getFormList", PopupSkinDTO));
		mv.addObject("mirrorPage","/dyAdmin/homepage/popup/popupSkin.do");
		mv.addObject("type","update");
		return mv;
	}
	
	@RequestMapping(value = "/dyAdmin/homepage/popupSkin/insert.do")
	@CheckActivityHistory(desc="팝업 스킨 등록 처리", homeDiv=SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView PopupSkinInsert(PopupSkinDTO PopupSkinDTO,  HttpServletRequest req)
			throws Exception {
		ModelAndView mv = new ModelAndView("redirect:/dyAdmin/homepage/popup/popupSkin.do");
		
		PopupSkinDTO.setPIS_KEYNO(CommonService.getTableKey("PIS"));
		Component.createData("Popup.PIS_insert", PopupSkinDTO);
		
		CommonPublishService.popupSkin(PopupSkinDTO);
		
		setHistory(PopupSkinDTO, req);
		
		return mv;
	}
	
	@RequestMapping(value = "/dyAdmin/homepage/popupSkin/update.do")
	@CheckActivityHistory(desc="팝업스킨 수정 처리", homeDiv=SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView PopupSkinUpdate(PopupSkinDTO PopupSkinDTO,  HttpServletRequest req)
			throws Exception {
		ModelAndView mv = new ModelAndView("redirect:/dyAdmin/homepage/popup/popupSkin.do");
		
		PopupSkinDTO = setHistory(PopupSkinDTO, req);
		
		Component.updateData("Popup.PIS_update", PopupSkinDTO);
		
		CommonPublishService.popupSkin(PopupSkinDTO);

		return mv;
	}
	
	public PopupSkinDTO setHistory(PopupSkinDTO PopupSkinDTO, HttpServletRequest req){
		/* 히스토리 저장 시작 */
		String REGDT = Component.getData("Popup.get_historyDate", PopupSkinDTO);
		Map<String, Object> user = CommonService.getUserInfo(req);
		String regName = ((String) user.get("UI_ID"));
		
		double VersionNum = Component.getData("Popup.get_historyVersion", PopupSkinDTO);
		VersionNum += 0.01;
		PopupSkinDTO.setPISH_KEYNO(CommonService.getTableKey("PISH"));
		PopupSkinDTO.setPISH_PIS_KEYNO(PopupSkinDTO.getPIS_KEYNO());
		PopupSkinDTO.setPISH_STDT(REGDT);
		PopupSkinDTO.setPISH_MODNM(regName);
		PopupSkinDTO.setPIS_MODNM(regName);
		PopupSkinDTO.setPISH_DATA(PopupSkinDTO.getPIS_FORM());
		PopupSkinDTO.setPISH_VERSION(VersionNum);

		String message = PopupSkinDTO.getPISH_COMMENT();
		if(StringUtils.isEmpty(PopupSkinDTO.getPISH_COMMENT())) {
			message = "no message";
		}
		PopupSkinDTO.setPISH_COMMENT(message);
		Component.createData("Popup.PISH_insert", PopupSkinDTO);
		/* 히스토리 저장 끝 */
		return PopupSkinDTO;

	}
	
	@RequestMapping(value = "/dyAdmin/homepage/popupSkin/delete.do")
	@CheckActivityHistory(desc="팝업 스킨 삭제 처리", homeDiv=SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView PopupSkinDelete(PopupSkinDTO PopupSkinDTO,  HttpServletRequest req)
			throws Exception {
		ModelAndView mv = new ModelAndView("redirect:/dyAdmin/homepage/popup/popupSkin.do");
		
		Component.updateData("Popup.PIS_delete", PopupSkinDTO);

		return mv;
	}
	
	@RequestMapping(value = "/dyAdmin/homepage/popupSkin/publishAjax.do")
	@ResponseBody
	@CheckActivityHistory(desc="팝업 스킨 파일 배포 처리", homeDiv=SettingData.HOMEDIV_ADMIN)
	@Transactional
	public boolean publishFile(PopupSkinDTO PopupSkinDTO, HttpServletRequest req)
			throws Exception {
		
		
		return CommonPublishService.popupSkin(PopupSkinDTO);
		
	}
	
	/**
	 * 팝업 스킨 관리 - 데이터 Ajax
	 * 
	 * @param PopupSkinDTO
	 * @return
	 * @throws Exception
	 * 
	 */
	@RequestMapping(value = "/dyAdmin/homepage/popupSkin/skindataAjax.do")
	@ResponseBody
	public HashMap<String, Object> popupSkinDataAjax(PopupSkinDTO PopupSkinDTO) throws Exception {
		HashMap<String, Object> map = new HashMap<>();

		// 오라클 data 충돌 오류 방지용
		String PIS_KEYNO = PopupSkinDTO.getPIS_KEYNO();

		// 데이터 정보 불러오기
		map.put("SkinData", Component.getData("Popup.PIS_getData", PopupSkinDTO));
		map.put("SkinDataHistory", Component.getList("Popup.PISH_getList", PIS_KEYNO));

		return map;
	}
	
	/**
	 * 스킨 관리 - 스킨 복원처리
	 * 
	 * @param req
	 * @param PopupSkinDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/popupSkin/returnPageAjax.do")
	@ResponseBody
	public String popupSkinReturnPageAjax(HttpServletRequest req
			,PopupSkinDTO PopupSkinDTO
			) throws Exception {
		PopupSkinDTO = Component.getData("Popup.PISH_getData", PopupSkinDTO);		
		return PopupSkinDTO.getPISH_DATA();
	}
	
	/**
	 * 스킨 관리 - 최신데이터와 비교, 변경사항
	 * 
	 * @param req
	 * @param PopupSkinDTO
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/dyAdmin/homepage/popupSkin/compareAjax.do")
	@ResponseBody
	public List popupSkinCompareAjax(HttpServletRequest req
			,PopupSkinDTO PopupSkinDTO
			) throws Exception {
		return Component.getList("Popup.PISH_compareData", PopupSkinDTO);
	}	

	/**
	 * 스킨 사용 여부 판단
	 * 
	 * @param PIS_KEYNO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/popupSkin/useSkinAjax.do")
	@ResponseBody
	public Integer popupUseSkinAjax(@RequestParam(value = "PIS_KEYNO", required = false) String PIS_KEYNO
			) throws Exception {		
		return Component.getCount("Popup.PIS_getSkinUsing", PIS_KEYNO);
	}
	
}