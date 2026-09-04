package com.tx.dyAdmin.main.controller;

import java.net.URI;
import java.net.URLEncoder;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.admin.code.service.CodeService;
import com.tx.dyAdmin.admin.keyword.dto.KeywordDTO;
import com.tx.dyAdmin.admin.site.service.SiteService;
import com.tx.dyAdmin.member.dto.UserDTO;
import com.tx.dyAdmin.statistics.dto.LogDTO;

/**
 * 
 * @FileName: AdminController.java
 * @Project : demo
 * @Date    : 2017. 02. 06. 
 * @Author  : 이재령	
 * @Version : 1.0
 */
@Controller
public class AdminController {

	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	@Autowired SiteService SiteService;
	@Autowired CodeService CodeService;
	
	@RequestMapping(value="/dyAdmin/index.do")
	@CheckActivityHistory(desc="관리자 메인 페이지 방문")
	public ModelAndView userForm(HttpServletRequest req, Map<String,Object> commandMap,UserDTO UserDTO,LogDTO log
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/pra_main.adm");
		String homeKey = null;
		String siteKey = (String)req.getSession().getAttribute("SITE_KEYNO");
		if(StringUtils.isNotBlank(siteKey)){
			homeKey = siteKey;
		}else{
			homeKey = SiteProperties.getString("HOMEPAGE_REP");
		}
		
		Cookie[] cookies = req.getCookies();  // 쿠키 조회하기
		if(cookies != null){
			List<HashMap<String, Object>> cookieList = new ArrayList<HashMap<String,Object>>();
			for(Cookie cookie:cookies){
				if(cookie.getName().contains("categoryWrap")){
					HashMap<String, Object> cookieMap = new HashMap<>();
					cookieMap.put("id", cookie.getName());
					cookieMap.put("mainCategory", cookie.getValue());
					cookieList.add(cookieMap);
				}
			}
			mv.addObject("cookieList",cookieList);
		}
		
		mv.addObject("homeKey",homeKey);
		return mv;
	}
	
	@RequestMapping(value="/dyAdmin/main/DataList/DataAjax.do")
	public ModelAndView mainBoardListAjax(
			HttpServletRequest req
			,HttpServletResponse res
			,@RequestParam(value="homeKey",required=false) String homeKey
			,@RequestParam(value="mainCategory",required=false) String mainCategory
			,@RequestParam(value="id",required=false) String id
			,@RequestParam(value="STDT",required=false) String STDT
			,@RequestParam(value="ENDT",required=false) String ENDT
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView();
		mv = getMainCategoryDataList(req,mv,mainCategory,homeKey,STDT,ENDT);
		Cookie cookie = new Cookie(id, mainCategory);
		cookie.setMaxAge(60*60*24*30);	// 쿠키의 유효시간을 30일
		cookie.setPath("/dyAdmin/index.do");        //쿠키 접근 경로 지정
		res.addCookie(cookie);
		mv.addObject("id",id);
		return mv;
	}
	
	private ModelAndView getMainCategoryDataList(HttpServletRequest req, ModelAndView mv, String mainCategory, String homeKey,String STDT,String ENDT) {

		switch (mainCategory) {
		case "board":
			mv.setViewName("/dyAdmin/main/pra_main_board");
			mv.addObject("boardlist",Component.getList("MainSQL.get_mainPageBoardList",homeKey));
			break;
		case "member":
			mv.setViewName("/dyAdmin/main/pra_main_member");
			List<UserDTO> memberlist = Component.getListNoParam("MainSQL.get_mainPageMemberList");
			for(UserDTO user : memberlist){
				user.decode();
			}
			mv.addObject("memberlist",memberlist);
			break;
		case "keyword":
			mv.setViewName("/dyAdmin/main/pra_main_keyword");
			break;
		case "menuCount":
			mv.setViewName("/dyAdmin/main/pra_main_menuCount");
			break;
		case "visitorCount":
			mv.setViewName("/dyAdmin/main/pra_main_visitorCount");
			break;

		default:
			break;
		}
		return mv;
	}
	
	
	
	
	/**
	 * 키워드 관리자 페이지를 위한 ajax처리
	 * */
	@ResponseBody
	@RequestMapping(value="/dyAdmin/main/keywordCount/DataAjax.do")
	public HashMap<String, Object> getKeywordCountDataAjax(HttpServletRequest req, KeywordDTO keyword) throws Exception {
		HashMap<String, Object> keywordMap = new HashMap<>();
		Object getObject = getKeywordCountData(req,Component.getList("MainSQL.get_mainPageKeywordList", keyword));
		keywordMap.put("keywordObject", getObject);
		Integer keywordListcnt =  Component.getData("MainSQL.get_mainPageKeywordListCnt",keyword);
		DecimalFormat df = new DecimalFormat("#,###");
		String keywordListcntFormat = df.format(keywordListcnt);
		keywordMap.put("keywordListCnt", keywordListcntFormat);
		return keywordMap;
	}
	
	public Object getKeywordCountData(HttpServletRequest req, List<HashMap<String, Object>> list) throws Exception {
	
		StringBuilder bulder = new StringBuilder();
		HashMap<String, Object> keyword = new HashMap<String, Object>();
		if(list !=null && list.size()>0){
			for(int i=0; i< list.size();  i++){
				keyword = list.get(i);
				bulder.append("<tr><td>")
				.append(keyword.get("COUNT"))
				.append("</td><td>")
				.append(keyword.get("SK_KEYWORD"))
				.append("</td><td>")
				.append(keyword.get("SK_SIZE"))
				.append("</td></tr>");

			} 
		}else{
			bulder.append("<tr><td colspan='3'>결과가 없습니다.</td></tr>");
		}
		return bulder.toString();
	}
	
	
	/**
	 * 통계부분 관리자 페이지를 위한 ajax처리
	 * */
	@ResponseBody
	@RequestMapping(value="/dyAdmin/main/menuCount/DataAjax.do")
	public HashMap<String, Object> getMenuCountDataAjax(HttpServletRequest req, LogDTO log) throws Exception {
		HashMap<String, Object> menuMap = new HashMap<>();
		List<LogDTO> list = Component.getList("MainSQL.get_mainPageMenuCount", log);
		
		Object getObject = getMenuCountData(req,list);
		menuMap.put("menuObject", getObject);
		menuMap.put("menuList", list);
		
		return menuMap;
	}
	

	
	public Object getMenuCountData(HttpServletRequest req, List<LogDTO> list) throws Exception {
		
		int total = 0;
		if(list != null && list.size()>0){
			
			for(int i=0; i<list.size(); i++){
				total += list.get(i).getSelectCount();
			}
			
			for(int i=0; i<list.size(); i++){ //평균
				list.get(i).setNo(i+1);
				if(total > 0) {
					float a = list.get(i).getSelectCount() / (float)total * 100;
					a *= 100;
					int ii =   (int) a;
					a = (float) (ii* 0.01);
					list.get(i).setPersent(a);
				}
			}
		}
		
		StringBuilder bulder = new StringBuilder();
		
		LogDTO log = new LogDTO();
		int totalCnt = 0;
		float totalPercent = 0;
		if(list !=null && list.size()>0){
			for(int i=0; i< list.size();  i++){
				log = list.get(i);
				bulder.append("<tr><td>")
				.append(log.getNo())
				.append("</td>")
				.append("<td>" + log.getMN_NAME()) 
				.append("</td><td>")
				.append(log.getSelectCount())
				.append("</td><td>")
				.append(log.getPersent())
				.append("%</td></tr>");
				totalCnt += log.getSelectCount();
				totalPercent += log.getPersent();
			} 
		}else{
			bulder.append("<tr><td colspan='4'>결과가 없습니다.</td></tr>");
		}
		bulder.append("<tr><td colspan='2' class='footTd'>")
		.append("총합</td><td>")
		.append(totalCnt)
		.append("<td>")
		.append(Math.round(totalPercent*100)/100.0)
		.append("%</td></tr>");
		
		return bulder.toString();
	}
	
	
	/**
	 * 통계부분 관리자 페이지를 위한 ajax처리
	 * */
	@ResponseBody
	@RequestMapping(value="/dyAdmin/main/visitorCount/DataAjax.do")
	public HashMap<String, Object> getVisitorCountDataAjax(HttpServletRequest req, LogDTO log) throws Exception {
		HashMap<String, Object> menuMap = new HashMap<>();
		List<LogDTO> list = Component.getList("MainSQL.get_mainPageVisitorCount", log);
		
		Object getObject = getVisitorCountData(req,list,log);
		menuMap.put("visitorObject", getObject);
		menuMap.put("visitorList", list);
		
		return menuMap;
	}
	
	public Object getVisitorCountData(HttpServletRequest req, List<LogDTO> list, LogDTO year) throws Exception {
		
		StringBuilder bulder = new StringBuilder();
		
		if(list !=null && list.size() > 0){
			
			for (int i = 0; i < list.size(); i++) {
				LogDTO log = list.get(i);
				
				String monthString = log.getVisitorType();
				
				if(i%4==0) bulder.append("<div class=\"t-col-3\"><table class=\"tbl_da_sm\"><thead><tr><th>월별</th><th>"+year.getLastYear()+"년도</th><th>"+year.getThisYear()+"년도</th></tr></thead><tbody>");
				
				bulder.append("<tr>")
				.append("<td>"+monthString+"월</td>")
				.append("<td>"+log.getLastCount()+"명</td>")
				.append("<td>"+log.getThisCount()+"명</td>")
				.append("</tr>");
				
				if(i%4==3) bulder.append("</tbody></table></div>");
				
			}
			
		}else{
			bulder.append("<div class=\"table-box table_wrap_mobile\"><table class=\"tbl_da_sm\" id=\"menuTable\"><tbody><tr><th colspan=\"4\">결과가 없습니다.</th></tr><tr></tbody></table></div>");
		}
		
		return bulder.toString();
	}
	
	
	/**
	 * 사이트 세션에 넣기
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/setSiteAjax.do")
	@ResponseBody
	public void setSiteAjax(
			HttpServletRequest req
			,HttpServletResponse res
			,@RequestParam(value="SITE_KEYNO",required=false) String SITE_KEYNO
			,@RequestParam(value="SITE_NAME",required=false) String SITE_NAME
			) throws Exception {
		String cookieValue = null;
		if(StringUtils.isNotBlank(SITE_KEYNO)){
			SITE_NAME = SITE_NAME.trim();
			cookieValue = URLEncoder.encode(CommonService.setKeyno(SITE_KEYNO)+"|"+SITE_NAME, "UTF-8");
		}else{
			cookieValue = URLEncoder.encode(SITE_KEYNO, "UTF-8");
		}
		Cookie cookie = new Cookie("siteVal", cookieValue);
		cookie.setMaxAge(60*60*24*365);	// 쿠키의 유효시간을 1년
		res.addCookie(cookie);
		SiteService.setSessionVal(req, SITE_KEYNO, SITE_NAME);
	}
	
	/**
	 * 에러 페이지
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/error.do")
	@CheckActivityHistory(desc="에러  페이지 방문")
	public ModelAndView error(HttpServletRequest req) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/error/error");
		
		try {
			String refererURI = new URI(req.getHeader("referer")).getPath();
			System.out.println("에러 ::/error.do:: referer :: " + refererURI);
			String tiles[] = refererURI.split("/");
			mv.addObject("tiles", tiles[1]);
		}catch(Exception e){
			System.out.println("에러 ::/error.do:: " + e.getMessage()+" :: " + CommonService.getClientIP(req));
		}
		return mv;
	}
	
}
