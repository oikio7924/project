package com.tx.dyAdmin.homepage.popupzone.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.dto.Common;
import com.tx.common.file.FileManageTools;
import com.tx.common.file.FileUploadTools;
import com.tx.common.file.dto.FileSub;
import com.tx.common.security.password.MyPasswordEncoder;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.page.PageAccess;
import com.tx.common.service.publish.CommonPublishService;
import com.tx.dyAdmin.homepage.popupzone.dto.PopupZoneCategoryDTO;
import com.tx.dyAdmin.homepage.popupzone.dto.PopupZoneListDTO;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class PopupZoneController {

	 
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 페이지 처리 출 */
	@Autowired private PageAccess PageAccess;
	
	/** 파일업로드 툴*/
	@Autowired private FileUploadTools FileUploadTools;
	
	/** 파일관리 툴 */
	@Autowired FileManageTools FileManageTools;
	
	/** 암호화 */
	@Autowired MyPasswordEncoder passwordEncoder;
	
	@Autowired private CommonPublishService CommonPublishService;
	
	/**
	 * 카테고리 관리
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/popupzone/category.do")
	@CheckActivityHistory(desc="카테고리 관리 페이지 방문")
	public ModelAndView categoryView(HttpServletRequest req
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/popupzone/category/pra_popupzone_category_listView.adm");
		mv.addObject("homeKey", CommonService.getDefaultSiteKey(req));
		return mv;
	}
	
	/**
	 * 카테고리 관리 - 페이징 ajax
	 * @param req
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/popupzone/pagingAjax.do")
	public ModelAndView categoryViewPagingAjax(HttpServletRequest req
			,Common search
			,@RequestParam(value="homeKey") String homeKey
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/popupzone/category/pra_popupzone_category_listview_data");

		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		map.put("TCGM_MN_HOMEDIV_C", homeKey);
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"PopupZone.TCGM_getListCnt",map, search.getPageUnit(), 10);
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		mv.addObject("resultList", Component.getList("PopupZone.TCGM_getList", map));
		mv.addObject("search", search);
		return mv;
	}
	
	
	@RequestMapping(value="/dyAdmin/homepage/popupzone/insertView.do")
	@CheckActivityHistory(desc="카테고리 등록 페이지 방문")
	public ModelAndView categoryInsertView(HttpServletRequest req
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/popupzone/category/pra_popupzone_category_insertView.adm");
		
		mv.addObject("homeKey", CommonService.getDefaultSiteKey(req));
		mv.addObject("formDataList", Component.getListNoParam("PopupZone.TCGM_getFormList"));
		mv.addObject("type","insert");
		mv.addObject("mirrorPage","/dyAdmin/homepage/popupzone/category.do");
		return mv;
	}
	
	
	@RequestMapping(value = "/dyAdmin/homepage/popupzone/insert.do")
	@CheckActivityHistory(desc="카테고리 등록 처리", homeDiv=SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView categoryInsert(PopupZoneCategoryDTO CategoryDTO,  HttpServletRequest req)
			throws Exception {
		ModelAndView mv = new ModelAndView("redirect:/dyAdmin/homepage/popupzone/category.do");
		
		CategoryDTO.setTCGM_KEYNO(CommonService.getTableKey("TCGM"));
		Component.createData("PopupZone.TCGM_insert", CategoryDTO);

		return mv;
	}
	
	@RequestMapping(value="/dyAdmin/homepage/popupzone/updateView.do")
	@CheckActivityHistory(desc="카테고리 수정/상세 페이지 방문")
	public ModelAndView categoryUpdateView(HttpServletRequest req
			, PopupZoneCategoryDTO CategoryDTO) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/popupzone/category/pra_popupzone_category_insertView.adm");
		
		//데이터 가져오기
		mv.addObject("TCGM_DATA", Component.getData("PopupZone.TCGM_getData", CategoryDTO));
		mv.addObject("formDataList", Component.getListNoParam("PopupZone.TCGM_getFormList"));
		mv.addObject("mirrorPage","/dyAdmin/homepage/popupzone/category.do");
		mv.addObject("type","update");
		return mv;
	}
	
	@RequestMapping(value = "/dyAdmin/homepage/popupzone/update.do")
	@CheckActivityHistory(desc="카테고리 수정 처리", homeDiv=SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView categoryUpdate(PopupZoneCategoryDTO CategoryDTO,  HttpServletRequest req)
			throws Exception {
		ModelAndView mv = new ModelAndView("redirect:/dyAdmin/homepage/popupzone/category.do");
		
		if(StringUtils.isEmpty(CategoryDTO.getTCGM_IMG_WIDTH())) CategoryDTO.setTCGM_IMG_WIDTH("0");

		if(StringUtils.isEmpty(CategoryDTO.getTCGM_IMG_HEIGHT())) CategoryDTO.setTCGM_IMG_HEIGHT("0");
		
		Component.updateData("PopupZone.TCGM_update", CategoryDTO);

		return mv;
	}
	
	@RequestMapping(value = "/dyAdmin/homepage/popupzone/delete.do")
	@CheckActivityHistory(desc="카테고리 삭제 처리", homeDiv=SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView MainMiniBoardDelete(PopupZoneCategoryDTO CategoryDTO,  HttpServletRequest req)
			throws Exception {
		ModelAndView mv = new ModelAndView("redirect:/dyAdmin/homepage/popupzone/category.do");
		
		Component.createData("PopupZone.TCGM_delete", CategoryDTO);

		return mv;
	}
	
	/**
	 * 카테고리 배포/전체배포
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/popupzone/createFileAjax.do")
	@ResponseBody
	@Transactional(rollbackFor=Exception.class)
	public boolean totCreateFile(HttpServletRequest req, PopupZoneCategoryDTO CategoryDTO)
			throws Exception {
		
		return CommonPublishService.popupZone(CategoryDTO);
		
	}
	
	
	/**
	 * 리스트 관리
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/popupzone/list.do")
	@CheckActivityHistory(desc="카테고리 관리 페이지 방문")
	public ModelAndView listView(HttpServletRequest req
			,@RequestParam(value="category", required=false) String category
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/popupzone/list/pra_popupzone_list_listView.adm");

		mv.addObject("categoryList", Component.getList("PopupZone.TCGM_getFormList",CommonService.createMap("TCGM_MN_HOMEDIV_C", CommonService.getDefaultSiteKey(req))));
		mv.addObject("category", category);
		return mv;
	}
	
	/**
	 * 리스트 관리 - 페이징 ajax
	 * @param req
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/popupzone/list/pagingAjax.do")
	public ModelAndView listViewPagingAjax(HttpServletRequest req
			,@RequestParam(value="category", required=false) String category
			,Common search
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/popupzone/list/pra_popupzone_list_listview_data");

		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		// SHOW_USING_YN 사용중인 리스트만 보기
		String SHOW_USING_YN = req.getParameter("SHOW_USING_YN");
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		map.put("category", category);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		if(SHOW_USING_YN != null) {
			map.put("SHOW_USING_YN", SHOW_USING_YN);			
		}
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"PopupZone.TLM_getListCnt",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		mv.addObject("resultList", Component.getList("PopupZone.TLM_getList", map));
		mv.addObject("search", search);
		return mv;
	}
	
	/**
	 * 메인배너 순서 변경
	 * @param req
	 * @param MainSlide
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/popupzone/list/orderUpdate.do")
	public ModelAndView listOrderUpdate(HttpServletRequest req
			,PopupZoneListDTO ListDTO
			) throws Exception {
		
		Component.updateData("PopupZone.TLM_OrderUpdate", ListDTO);
		ModelAndView mv  = new ModelAndView("redirect:/dyAdmin/homepage/popupzone/list.do");
		return mv;
	}
	
	/**
	 * 사용여부
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/popupzone/list/check.do")
	@Transactional
	public ModelAndView listCheck(PopupZoneListDTO ListDTO) throws Exception {
	
		Component.updateData("PopupZone.TLM_choiceYN", ListDTO);
		
		ModelAndView mv  = new ModelAndView("redirect:/dyAdmin/homepage/popupzone/list.do");
		return mv;
	}	
	
	@RequestMapping(value="/dyAdmin/homepage/popupzone/list/insertView.do")
	@CheckActivityHistory(desc="리스트 등록 페이지 방문")
	public ModelAndView listInsertView(HttpServletRequest req
			,@RequestParam(value="category", required=false) String category
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/popupzone/list/pra_popupzone_list_insertView.adm");
		
		mv.addObject("categoryList", Component.getList("PopupZone.TCGM_getFormList",CommonService.createMap("TCGM_MN_HOMEDIV_C", CommonService.getDefaultSiteKey(req))));
		mv.addObject("category", category);
		mv.addObject("type","insert");
		mv.addObject("mirrorPage","/dyAdmin/homepage/popupzone/list.do");
		return mv;
	}
	
	/**
	 * 리스트 등록
	 * @param req
	 * @param ListDTO
	 * @param file
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/popupzone/list/insert.do")
	@CheckActivityHistory(desc="리스트 등록 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView listInsert(HttpServletRequest req
			,PopupZoneListDTO ListDTO
			,@RequestParam(value="file", required=false) MultipartFile file
			,@RequestParam(value="resize", required=false) boolean resize
			) throws Exception {
		ListDTO.setTLM_KEYNO(CommonService.getTableKey("TLM"));
		
		int cnt;
		// 입력된 정렬기준의 절렬순서를 가지고 있는 메뉴를 찾아 갯수를 세는 sql문
		cnt = Component.getData("PopupZone.TLM_getListLV", ListDTO);
		
		//sql문 결과 데이터가 존재하는 경우, 해당 번호부터 해당 번호보다 큰 숫자의 정렬 순서들을 모두 +1해주는 코딩문 실행
		if(cnt > 0){
			Component.updateData("PopupZone.TLM_addListLV", ListDTO);
		}
		
		int width = ListDTO.getWIDTH();
		int height = ListDTO.getHEIGHT();
		
		if(file != null && !file.isEmpty()){
			FileSub fileSub = new FileSub().RESIZE_WIDTH(width).RESIZE_HEIGHT(height);
			fileSub.setIS_RESIZE(resize);
			fileSub = FileUploadTools.FileUpload(file, ListDTO.getTLM_REGNM(), fileSub, req);
			ListDTO.setTLM_FS_KEYNO(null);
            if(fileSub != null){
                ListDTO.setTLM_FS_KEYNO(fileSub.getFS_KEYNO());
            }
		}
		
		Component.createData("PopupZone.TLM_insert", ListDTO);
		ModelAndView mv  = new ModelAndView("redirect:/dyAdmin/homepage/popupzone/list.do");
		return mv;
	}
	
	
	@RequestMapping(value="/dyAdmin/homepage/popupzone/list/categoryInfoAjax.do")
	@ResponseBody
	public Object categoryInfoAjax(HttpServletRequest req
			, PopupZoneCategoryDTO CategoryDTO
			) throws Exception {
		HashMap<String, Object> data = Component.getData("PopupZone.TCGM_getCategoryData", CategoryDTO);
		return data;
	}
	
	
	@RequestMapping(value="/dyAdmin/homepage/popupzone/list/updateView.do")
	@CheckActivityHistory(desc="리스트 수정 페이지 방문")
	public ModelAndView listUpdateView(HttpServletRequest req
			, PopupZoneListDTO ListDTO
			,@RequestParam(value="category", required=false) String category
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/popupzone/list/pra_popupzone_list_insertView.adm");
		
		//데이터 가져오기
		mv.addObject("TLM_DATA", Component.getData("PopupZone.TLM_getData", ListDTO));
		mv.addObject("categoryList", Component.getList("PopupZone.TCGM_getFormList",CommonService.createMap("TCGM_MN_HOMEDIV_C", CommonService.getDefaultSiteKey(req))));
		mv.addObject("category", category);
		mv.addObject("type","update");
		mv.addObject("mirrorPage","/dyAdmin/homepage/popupzone/list.do");
		return mv;
	}
	
	/**
	 * 리스트 수정
	 * @param req
	 * @param ListDTO
	 * @param file
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/popupzone/list/update.do")
	@CheckActivityHistory(desc="리스트 수정 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView listUpdate(HttpServletRequest req
			,PopupZoneListDTO ListDTO
			,@RequestParam(value="file", required=false) MultipartFile file
			,@RequestParam(value="resize", required=false) boolean resize
			) throws Exception {
		
		int width = ListDTO.getWIDTH();
		int height = ListDTO.getHEIGHT();
		
		if(file != null && !file.isEmpty()){
			FileSub fileSub = new FileSub().RESIZE_WIDTH(width).RESIZE_HEIGHT(height);
			fileSub.setIS_RESIZE(resize);
			if(ListDTO.getTLM_FS_KEYNO() != null && !ListDTO.getTLM_FS_KEYNO().equals("")){
				fileSub.setFS_KEYNO(ListDTO.getTLM_FS_KEYNO());
			}
			fileSub = FileUploadTools.FileUpload(file, ListDTO.getTLM_REGNM(), fileSub, req);
            if(fileSub != null){
                ListDTO.setTLM_FS_KEYNO(fileSub.getFS_KEYNO());
            }
		}
		Component.updateData("PopupZone.TLM_update", ListDTO);
		Component.updateData("PopupZone.TLM_OrderUpdate", ListDTO);
		
		ModelAndView mv  = new ModelAndView("redirect:/dyAdmin/homepage/popupzone/list.do");
		return mv;
	}
	
	@RequestMapping(value="/dyAdmin/homepage/popupzone/list/delete.do")
	@CheckActivityHistory(desc="리스트 삭제 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	public ModelAndView listDelete(HttpServletRequest req
			, PopupZoneListDTO ListDTO
			) throws Exception {
		ModelAndView mv  = new ModelAndView("redirect:/dyAdmin/homepage/popupzone/list.do");
		Component.deleteData("PopupZone.TLM_delete", ListDTO);
		Component.updateData("PopupZone.TLM_OrderUpdateByDelete", ListDTO);
		
		return mv;
	}
	
}
