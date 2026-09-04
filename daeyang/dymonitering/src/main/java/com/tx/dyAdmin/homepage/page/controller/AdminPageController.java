package com.tx.dyAdmin.homepage.page.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.config.annotation.service.ActivityHistoryService;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.file.FileCommonTools;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.publish.CommonPublishService;
import com.tx.common.utils.RemoveTag;
import com.tx.dyAdmin.admin.board.dto.BoardNotice;
import com.tx.dyAdmin.admin.domain.dto.HomeManager;
import com.tx.dyAdmin.admin.site.service.SiteService;
import com.tx.dyAdmin.homepage.menu.dto.Menu;
import com.tx.dyAdmin.homepage.menu.service.AdminMenuService;
import com.tx.dyAdmin.homepage.page.dto.HTMLViewData;
import com.tx.dyAdmin.homepage.page.service.PageService;

/**
 * 관리자 - 페이지관리
 * @author 
 * @version 1.0
 * @since 
 */
@Controller
public class AdminPageController {
	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	@Autowired SiteService SiteService;
	/** 메뉴리스트 서비스 */
	@Autowired private AdminMenuService AdminMenuService;
	
	@Autowired private CommonPublishService CommonPublishService;
	
	@Autowired private PageService PageService;
	
	/** 활동기록 서비스 */
	@Autowired
	private ActivityHistoryService ActivityHistoryService;
	
	@Autowired FileCommonTools FileCommonTools;
	
	
	/**
	 * HTML소스 DB 리스트 페이지 방문 - admin 
	 * @param req
	 * @param model
	 * @param hTMLViewData
	 * @param MN_HOMEDIV_C
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/page.do")
	@CheckActivityHistory(desc = "페이지관리 방문")
	public String CreateHTML_ListView(HttpServletRequest req
			,Model model
			,HTMLViewData hTMLViewData
			) throws Exception{  
		
		//홈페이지 구분 리스트
		model.addAttribute("HTMLViewData", hTMLViewData);
		
		model.addAttribute("MN_HOMEDIV_C", CommonService.getDefaultSiteKey(req));
		model.addAttribute("mirrorPage","/dyAdmin/homepage/page.do");
		
		return "/dyAdmin/homepage/page/pra_page_list.adm";
	}
	
	/**
	 * HTML소스 메뉴 리스트 불러오기
	 * @param model
	 * @param Menu
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/page/subList/listAjax.do")
	public ModelAndView pageManagerSubList(
			Model model
			,Menu Menu
			,HttpServletRequest request
			) throws Exception{ 
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/page/pra_page_list_data");
		
		if(Menu.getMN_HOMEDIV_C() == null || Menu.getMN_HOMEDIV_C().equals("")){
			Menu.setMN_HOMEDIV_C(SiteProperties.getString("HOMEPAGE_REP"));
		}
		Menu.setMN_DEL_YN("N");
		HomeManager homeManager = Component.getData("Menu.AMN_getMenuList",Menu);
		mv.addObject("homeManager", homeManager);
		List<String> pageDivList = new ArrayList<String>();
		pageDivList.add(SettingData.MENU_TYPE_PAGE);
		pageDivList.add(SettingData.MENU_TYPE_SUBMENU);
		
		//권한 없는 페이지 제거하기
		//권한별 메뉴 조회
        Map<String, Object> user = CommonService.getUserInfo(request);
        String UI_KEYNO = (String) user.get("UI_KEYNO");
		String UIA_KEYNO = Component.getData("Authority.UIA_getDataByUIKEYNO", UI_KEYNO);
		homeManager.setUIA_KEYNO(UIA_KEYNO);
		List<Menu> list = AdminMenuService.getMenuList(homeManager, pageDivList,true);
		
		mv.addObject("menuActionAuthData", Component.getData("Menu.getMenuActionAuthData",homeManager));
		mv.addObject("menuList", list);
		
		return mv;
	}
	
	
	/**
	 * HTML소스 DB 저장 페이지  방문 - admin
	 * @param model
	 * @param hTMLViewData
	 * @param req
	 * @param Menu
	 * @param action
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/page/insertView.do")
	public ModelAndView CreateHTML_insertView(
			 Model model
			,HTMLViewData hTMLViewData
			,HttpServletRequest req
			,Menu Menu
			) throws Exception{
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/page/pra_page_insertView");
		
		Map< String, ? > inputFlashMap = RequestContextUtils.getInputFlashMap(req);
		if(null != inputFlashMap) {
			Menu.setMN_KEYNO((String) inputFlashMap.get("MN_KEYNO"));
			Menu.setMN_HOMEDIV_C((String) inputFlashMap.get("MN_HOMEDIV_C"));
		}
		
		hTMLViewData.setMVD_MN_HOMEDIV_C(Menu.getMN_HOMEDIV_C());
		
		String MVD_KEYNO = Component.getData("HTMLViewData.get_pageViewKey", Menu.getMN_KEYNO());
		if(StringUtils.isEmpty(MVD_KEYNO)){	//페이지를 처음 등록하는 경우에는 페이지 데이터를 생성해준다.
			/* 작성자 정보 저장 */
			String User = "";
			Map<String, Object> map = CommonService.getUserInfo(req);
			if( map.get("UI_KEYNO") != null && !map.get("UI_KEYNO").toString().isEmpty() ){
				User = map.get("UI_KEYNO").toString();
			}
			MVD_KEYNO = CommonService.getTableKey("MVD");
			hTMLViewData.setMVD_KEYNO(MVD_KEYNO);
			hTMLViewData.setMVD_REGNM(User);
			hTMLViewData.setMVD_MN_KEYNO(Menu.getMN_KEYNO());
			Component.createData("HTMLViewData.MVD_regist", hTMLViewData);
		}
		
		mv.addObject("HTMLViewData",Component.getData("HTMLViewData.get_PageViewInfo", CommonService.createMap("MVD_KEYNO", MVD_KEYNO)));
		
		mv.addObject("homeUrl", Component.getData("Menu.get_homeUrl", Menu.getMN_HOMEDIV_C())); //미리보기에 필요한 url을 넘겨준다.
		mv.addObject("Menu", Component.getData("Menu.AMN_getDataByKey",Menu));
		
		return mv;	
	}
	
	/**
	 * HTML소스 DB 저장 페이지  방문 - admin
	 * @param model
	 * @param hTMLViewData
	 * @param req
	 * @param Menu
	 * @param action
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/page/DataViewAjax.do")
	@ResponseBody
	public String DataViewAjax(
			HTMLViewData hTMLViewData
			) throws Exception{
		
		return hTMLViewData.getMVD_DATA();	
	}
	
	/**
	 * HTML소스 DB 히스토리 데이터 불러오기
	 * @param hTMLViewData
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/page/history/dataAjax.do")
	@ResponseBody
	public List<HTMLViewData> getHistoryDataAjax(
			HTMLViewData hTMLViewData
			) throws Exception{
		
		return Component.getList("HTMLViewData.MVH_getList", hTMLViewData.getMVD_KEYNO());	
	}
	

	/**
	 * 버전 체크
	 * @param hTMLViewData
	 * @param currentVersion
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/page/versionCheckAjax.do")
	@Transactional
	@ResponseBody
	public HashMap<String, Object> pageDataVersionCheck(
			  @ModelAttribute HTMLViewData hTMLViewData
			, @RequestParam(value="currentVersion", required=false) Double currentVersion)
			throws Exception {
		
		HashMap<String, Object> resultMap = new HashMap<>();
		
		//버전 체크 후, boolean값과 버전값을 map에 저장
		PageService.dataVersionCheck(resultMap, hTMLViewData, currentVersion);
		
		resultMap.put("historyMainKey", hTMLViewData.getMVD_KEYNO());
		
		return resultMap;
	}

	/**
	 * HTML소스 DB 저장 작업 
	 * @param model
	 * @param hTMLViewData
	 * @param MVD_DATA_BEFORE
	 * @param currentVersion
	 * @param req
	 * @param redirectAttributes
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dyAdmin/homepage/page/insertAjax.do")
	@CheckActivityHistory(type="hashmap", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	@ResponseBody
	public ModelAndView CreateHTML_Regist(Model model
			, HTMLViewData hTMLViewData
			, @RequestParam(value="MVD_DATA_BEFORE", required=false) String MVD_DATA_BEFORE
			, @RequestParam(value="currentVersion", defaultValue="0.0") Double currentVersion
			, HttpServletRequest req
			, RedirectAttributes redirectAttributes
			, @RequestParam(value="HomeName", required=false) String HomeName
			) throws Exception{ 
		ModelAndView mv  = new ModelAndView();
		
		hTMLViewData.setMVD_REGNM("#01 USER_DTO"); // (세션없을 시 임시저장)
		
		//이미지 업로드할 경우 이미지 경로 변경.
		hTMLViewData.setMVD_DATA(FileCommonTools.editorImgCheck(hTMLViewData.getMVD_DATA(), hTMLViewData.getMVD_KEYNO(), hTMLViewData.getMVD_MN_KEYNO(), "pageView"));
		
		/* 작성자 정보 저장 */
		String User = "";
		Map<String, Object> map = CommonService.getUserInfo(req);
		if( StringUtils.isNotBlank((String)map.get("UI_KEYNO"))){
			User = (String)map.get("UI_KEYNO");
		}
		
	    String MVD_DATA = hTMLViewData.getMVD_DATA();
		hTMLViewData.setMVD_DATA(StringEscapeUtils.unescapeHtml3(MVD_DATA));
		
		if(StringUtils.isNotEmpty(hTMLViewData.getMVD_KEYNO())){
            hTMLViewData.setMVD_DATA_SEARCH(RemoveTag.remove(MVD_DATA));
			hTMLViewData.setMVD_MODNM(User);
			Component.updateData("HTMLViewData.MVD_update", hTMLViewData);
		}
		
		/* 히스토리 저장 시작*/
		double VersionNum = currentVersion;
		VersionNum += 0.01;
		String REGDT = Component.getData("HTMLViewData.get_historyDate",hTMLViewData);
		hTMLViewData.setMVH_KEYNO(CommonService.getTableKey("MVH"));
		hTMLViewData.setMVH_MVD_KEYNO(hTMLViewData.getMVD_KEYNO());
		hTMLViewData.setMVH_STDT(REGDT);
		hTMLViewData.setMVH_MODNM(User);
		hTMLViewData.setMVH_DATA(StringEscapeUtils.unescapeHtml3(MVD_DATA));
		hTMLViewData.setMVH_VERSION(VersionNum);
		
		String message = hTMLViewData.getMVH_COMMENT();
		if(hTMLViewData.getMVH_COMMENT() == null || hTMLViewData.getMVH_COMMENT().equals("")){
			message = "no message";
		}
		hTMLViewData.setMVH_COMMENT(message);
		Component.createData("HTMLViewData.MVH_regist", hTMLViewData);
		/* 히스토리 저장 끝*/
	    
		//메뉴 수정일 업데이트
		HashMap<String, Object> modimap = new HashMap<>();
		modimap.put("MODNM", User);
		modimap.put("MN_KEYNO", hTMLViewData.getMVD_MN_KEYNO());
		Component.updateData("Menu.change_MenuModifyTime", modimap);
		
		//활동기록
		ActivityHistoryService.setDescPageAction(HomeName, "insert", req);
		
		redirectAttributes.addFlashAttribute("msg","저장되었습니다.");
		redirectAttributes.addFlashAttribute("MN_KEYNO",hTMLViewData.getMVD_MN_KEYNO());
		redirectAttributes.addFlashAttribute("MN_HOMEDIV_C",hTMLViewData.getMVD_MN_HOMEDIV_C());
		mv.setViewName("redirect:/dyAdmin/homepage/page/insertView.do");
		
		return mv;

	}

	/**
	 * HTML소스 DB 미리보기 페이지 - admin
	 * 
	 * @param MVD_KEYNO
	 * @return
	 * @throws Exception
	 */   
	@RequestMapping(value = "/dyAdmin/homepage/page/detailView/iframe.do")
	public String CreateHTML_DetailViewIframe(
			Model model,
			HTMLViewData hTMLViewData
			) throws Exception{
		
		hTMLViewData = Component.getData("HTMLViewData.MVD_getDataPreview", hTMLViewData);
		
		model.addAttribute("HTMLViewData",hTMLViewData);
		return "/dyAdmin/homepage/page/pra_page_detailView_iframe";
	}
	
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/dyAdmin/homepage/page/compareAjax.do")
	@ResponseBody
	public List CreateHTML_CompareAjax(
			Model model,
			HTMLViewData hTMLViewData
			) throws Exception{
		
		return Component.getList("HTMLViewData.MVH_compareData", hTMLViewData);
	}
	
	
	/**
	 * HTML소스 DB 복원 - admin
	 * 
	 * @param MVD_KEYNO
	 * @return
	 * @throws Exception
	 */   
	@RequestMapping(value = "/dyAdmin/homepage/page/detailView/returnPageAjax.do")
	@CheckActivityHistory(type="hashmap", homeDiv= SettingData.HOMEDIV_ADMIN)
	@ResponseBody
	public HashMap<String, Object> CreateHTML_DetailViewReturnPageAjax(HTMLViewData hTMLViewData
			) throws Exception{	
		
		return PageService.dataReturnPage(hTMLViewData);
	}
	
	/**
	 * 페이지 배포 - admin
	 * 
	 * @param 
	 * @return
	 * @throws Exception
	 */ 
	@RequestMapping(value = "/dyAdmin/homepage/page/distributeAjax.do")
	@CheckActivityHistory(type="hashmap", homeDiv= SettingData.HOMEDIV_ADMIN)
	@ResponseBody
	public Boolean CreateHTML_DistributeAjax(HttpServletRequest req
			, Model model
			, HTMLViewData hTMLViewData
			, @RequestParam(value="HomeName", required=false) String HomeName
			) throws Exception{
		
		String path = Component.getData("HomeManager.get_sitePath", hTMLViewData.getMVD_MN_HOMEDIV_C());
		String MVD_MN_HOMEDIV_C = StringUtils.defaultIfEmpty(hTMLViewData.getMVD_MN_HOMEDIV_C(), null);
		String MVD_KEYNO = StringUtils.defaultIfEmpty(hTMLViewData.getMVD_KEYNO(), null);
	
		//활동기록
		ActivityHistoryService.setDescPageAction(HomeName, "distribute", req);
		
		return CommonPublishService.page(path, MVD_MN_HOMEDIV_C, MVD_KEYNO);
	}
	
	
	@RequestMapping(value = "/dyAdmin/homepage/page/previewAjax.do")
	@ResponseBody
	public String CreateHTML_PreviewAjax(
			  @RequestParam(value="HomeKey", required=false) String HomeKey
			, @RequestParam(value="Keyno", required=false) String Keyno
			, @RequestParam(value="keyType", required=false) String keyType
			, @RequestParam(value="contents", required=false) String contents
			) throws Exception{ 
		
		String path = Component.getData("HomeManager.get_sitePath", HomeKey);
		HashMap<String, Object> pageData = new HashMap<>();
		if(keyType.equals("main")){
			pageData= Component.getData("HTMLViewData.get_PageViewInfo", CommonService.createMap("MVD_KEYNO", Keyno));
		}else if(keyType.equals("history")){
			pageData= Component.getData("HTMLViewData.MVD_getDataHistory", Keyno);
			contents = (String)pageData.get("MVD_DATA");
		}
		contents = StringUtils.defaultIfEmpty(contents, "");
		CommonPublishService.pagePreview(path, contents);
		
		return pageData.get("MN_URL")+"";
		
	}
	
	/**
	 * HTML소스 DB 미리보기 - admin
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 * 
	 */   
	@RequestMapping(value = "/{tiles}/homepage/page/preview.do")
	@CheckActivityHistory(desc = "페이지관리 콘텐츠 미리보기", homeDiv= SettingData.HOMEDIV_ADMIN)
	public ModelAndView CreateHTML_Preview(
			  @RequestParam(value="mirrorPage", defaultValue="") String mirrorPage
			, @PathVariable String tiles
			) throws Exception{ 
		
		ModelAndView mv = new ModelAndView("/publish/"+SiteService.getSitePath(tiles)+"/views/temp/temp");
		
		mv.addObject("mirrorPage", mirrorPage);
		
		return mv;
	}
	
    @RequestMapping(value = "/test/pageTest.do")
    @ResponseBody
    public void test(
            ) throws Exception{ 
        List<HTMLViewData> list = Component.getListNoParam("HTMLViewData.test");
        
        for (HTMLViewData dto : list) {
            HTMLViewData data = new HTMLViewData();
            data.setMVD_KEYNO(dto.getMVD_KEYNO());
            data.setMVD_DATA_SEARCH(RemoveTag.remove(dto.getMVD_DATA()));
            Component.updateData("HTMLViewData.test_update", data);
        }
        
    }
    @RequestMapping(value = "/test/boardTest.do")
    @ResponseBody
    public void board(
            ) throws Exception{ 
        List<BoardNotice> list = Component.getListNoParam("BoardNotice.test");
        
        for (BoardNotice dto : list) {
            BoardNotice data = new BoardNotice();
            data.setBN_KEYNO(dto.getBN_KEYNO());
            data.setBN_CONTENTS_SEARCH(RemoveTag.remove(dto.getBN_CONTENTS()));
            Component.updateData("BoardNotice.test_update", data);
        }
        
    }
	
}
