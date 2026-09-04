package com.tx.template.controller;

import java.net.URLDecoder;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.dto.TilesDTO;
import com.tx.common.dto.SNS.SNSInfo;
import com.tx.common.dto.SNS.SNSInfoBuilder;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.publish.CommonPublishService;
import com.tx.dyAdmin.admin.site.service.SiteService;
import com.tx.dyAdmin.homepage.menu.dto.Menu;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class TemplateController {
	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	@Autowired SiteService SiteService;
	@Autowired CommonPublishService CommonPublishService;
	
	
	@RequestMapping(value="/{tiles}/index.do")
	public ModelAndView templateIndex(HttpServletRequest req
			, @PathVariable String tiles
			, @RequestParam(value = "msg", defaultValue = "") String msg
			, @RequestParam(value="inverter", defaultValue="all")String inverter
			) throws Exception {
		ModelAndView mv = new ModelAndView();

		if("user".equals(tiles)){
			tiles = new TilesDTO().checkNull(null, req);
			mv.setViewName("redirect:/"+tiles+"/index.do");
			return mv;
		}
		
		String sitePath = SiteService.getSitePath(tiles);
		if(StringUtils.isEmpty(sitePath)){
			mv.setViewName("");
			return mv;
		}
		
		//관리자 체크해서 권한없을시  redirect 시킨다.
//		Map<String, Object> user = CommonService.getUserInfo(req);
		/*String userKeyno = ((String) user.get("UI_KEYNO"));
		if(userKeyno != null) {
			String UIA_KEYNO = Component.getData("Authority.UIA_getDataByUIKEYNO", userKeyno);
		}*/
		
		//모바일 부분 체크 이후 url 변경
		String userAgent = req.getHeader("user-agent");
		boolean mobile1 = userAgent.matches( ".*(iPhone|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson).*");
		boolean mobile2 = userAgent.matches(".*(LG|SAMSUNG|Samsung).*");

		if (mobile1 || mobile2) {
			mv.setViewName("redirect:/"+tiles+"/mobile.do");
		}
		
		//안전관리
		else if("sfa".equals(tiles)) {
			mv.setViewName("redirect:/"+tiles+"/safe/safe.do");
		}
		
		//개발팀 인허가 일정관리
		else if("bd".equals(tiles)) {
			mv.setViewName("redirect:/"+tiles+"/main.do");
		}
		
		//모니터링
		else {
			mv.setViewName("redirect:/"+tiles+"/moniter/general.do");
		}
		
		
		if(!"".equals(msg)) {
			mv.addObject("msg", URLDecoder.decode(msg, "UTF-8")); // 현재 회원인증후 메세지
		}

		return mv;
		
	}
	
	/**
	 * 사용자 정의형 URL mapping
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 * 
	 */   					 
	@RequestMapping(value = {"/{a}","/{a}/{b}","/{a}/{b}/{c}","/{a}/{b}/{c}/{d}","/{a}/{b}/{c}/{d}/{e}","/{a}/{b}/{c}/{d}/{e}/{f}"})
	@CheckActivityHistory
	public String userCustomURLMappingPatterns2(Model model
			, HttpServletRequest req
			, @RequestParam(value="MVH_KEYNO", required=false) String MVH_KEYNO
			) throws Exception{ 
		
		String URI = (String) req.getRequestURI();
		System.err.println("######### 901 : 사용자정의형 URL : " + URI );
		
		String tilesNm = URI.split("/")[1];
		
		Menu Menu = new Menu();
		Menu.setMN_URL(URI);
		Menu = Component.getData("Menu.AMN_getSimpleMenuByURL", Menu);		
		
		if( Menu != null ){
			
			String pageDiv = Menu.getMN_PAGEDIV_C();
			
			Integer key = Integer.parseInt(Menu.getMN_KEYNO().split("_")[1]);
			
			/* 메뉴가 게시판형일 경우 */
			if(SettingData.MENU_TYPE_BOARD.equals(pageDiv) && StringUtils.isNotEmpty(Menu.getMN_BT_KEYNO()) ){
				return "forward:/"+tilesNm+"/Board/main/"+ key +"/view.do";
			}
			
			/* 메뉴가 일반뷰형이거나 소개페이지일 경우 */
			if(SettingData.MENU_TYPE_PAGE.equals(pageDiv) || 
					( SettingData.MENU_TYPE_SUBMENU.equals(pageDiv) && StringUtils.isNotEmpty(Menu.getMN_FORWARD_URL()))){
				
				HashMap<String, Object> hTMLViewData = new HashMap<>();
				hTMLViewData = Component.getData("HTMLViewData.MVD_getData", Menu.getMN_KEYNO());
				model.addAttribute("HTMLViewData", hTMLViewData);
				if(hTMLViewData != null){

					SNSInfo SNSInfo = SNSInfoBuilder.Builder()
							.setTitle((String)hTMLViewData.get("MN_NAME"))
							.setDesc((String)hTMLViewData.get("VIEW_DATA"), true)
							.build();
					model.addAttribute("SNSInfo", SNSInfo);
					
					String returnPage= "/publish/"+hTMLViewData.get("HM_SITE_PATH").toString()+"/views/"+CommonPublishService.getFileName("page", (String)hTMLViewData.get("MN_KEYNO"),false); 
					System.out.println("returnPage :: " + returnPage);
					return returnPage;
				}
			}
			
			/* 메뉴가 링크형일 경우 */
			if(SettingData.MENU_TYPE_LINK.equals(pageDiv)){
				String forward = Menu.getMN_FORWARD_URL();			
				return "redirect:"+forward;
			}
		}
		
		
		return "";
		
	}
	
}
