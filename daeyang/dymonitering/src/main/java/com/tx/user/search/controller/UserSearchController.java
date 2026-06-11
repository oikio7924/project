package com.tx.user.search.controller;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.dto.Common;
import com.tx.common.security.aes.AES256Cipher;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.page.PageAccess;
import com.tx.dyAdmin.admin.board.dto.BoardNotice;
import com.tx.dyAdmin.admin.keyword.service.impl.KeywordServiceImpl;
import com.tx.dyAdmin.admin.site.service.SiteService;
import com.tx.dyAdmin.homepage.menu.dto.Menu;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * 
 * @FileName: SearchController.java
 * @Project : cf
 * @Date    : 2017. 06. 12. 
 * @Author  : 이재령	
 * @Version : 1.0
 */
@Controller
public class UserSearchController {

	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;

	/** 페이지 처리 출 */
	@Autowired private PageAccess PageAccess;
	
	/** 키워드 서비스 */
	@Autowired private KeywordServiceImpl KeywordService;
	
	@Autowired SiteService SiteService;

	/**
	 * 통합검색
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/{tiles}/search.do")
	@CheckActivityHistory(desc="통합검색 페이지 방문")
	public ModelAndView cfUseSearch(HttpServletRequest req
			, Common search
			, Menu Menu
			, BoardNotice BoardNotice
			, @PathVariable String tiles
			, @RequestParam(value="detail",required=false) String detail) throws Exception {
		String sitePath = SiteService.getSitePath(tiles);
		ModelAndView mv = new ModelAndView("/user/"+sitePath+"/search/prc_search");
		
		String AH_HOMEDIV_C = Component.getData("HomeManager.get_HomeKey", tiles);

		if(detail != null){
			mv.addObject("detail",detail);
		}
		
		if(search.getSearchKeyword().equals("")){ // 검색어가 없을시 그냥 리턴처리
			return mv;
		}
		
		search.setSearchKeyword(search.getSearchKeyword().trim());
		Menu.setSearchKeyword(search.getSearchKeyword().trim());
		BoardNotice.setSearchKeyword(search.getSearchKeyword().trim());
		
		search.setSearchKeywordArr(search.getSearchKeyword().split(" "));
		Menu.setSearchKeywordArr(search.getSearchKeywordArr());
		BoardNotice.setSearchKeywordArr(search.getSearchKeywordArr());
		
		if(search.getSearchCondition() != null && !search.getSearchCondition().equals("")){
			
			String date[] = getDateScope(search.getSearchCondition());
			if(date != null){
				search.setSearchBeginDate(date[0]);
				search.setSearchEndDate(date[1]);
				Menu.setSearchBeginDate(date[0]);
				Menu.setSearchEndDate(date[1]);
				BoardNotice.setSearchBeginDate(date[0]);
				BoardNotice.setSearchEndDate(date[1]);
			}
		}
		
		String domain = CommonService.checkUrl(req);
		
		//권한 체크 (로그인 안 했을 경우 비회원, 했을 경우 해당 권한을 가져옴)
		Map<String,Object> user = CommonService.getUserInfo(req);
		String userAuth = "UIA_EAFDS";
		if(user != null){
			userAuth = Component.getData("Authority.UIA_getDataByUIKEYNO",  (String)user.get("UI_KEYNO"));
		}
		Menu.setUserAuth(userAuth);			// 메뉴
		BoardNotice.setUserAuth(userAuth);	// 게시판,자료,인물
		
		
		//메뉴
		mv.addObject("search",search);
		
		Menu.setMN_HOMEDIV_C(AH_HOMEDIV_C);
		
		
		PaginationInfo menuPageInfo = PageAccess.getPagInfo(Menu.getPageIndex(),"search.MN_getMenuListCnt",Menu, 5,5);
		Menu.setFirstIndex(0);
		Menu.setRecordCountPerPage(3);
		Menu.setPageIndex(1);
		mv.addObject("menuPaginationInfo", menuPageInfo);
		
		
		List<Map<String,Object>> menuSearchList = Component.getList("search.MN_getMenuList", Menu);
		
		setMenuInfo(menuSearchList,domain,search.getSearchKeywordArr());
		
		mv.addObject("menuSearchList", menuSearchList );
		
		//게시판
		BoardNotice.setBN_MN_KEYNO(AH_HOMEDIV_C);
		
		PaginationInfo boardPageInfo = PageAccess.getPagInfo(BoardNotice.getPageIndex(),"search.BN_getCnt",BoardNotice, 5,5);
		BoardNotice.setFirstIndex(0);
		BoardNotice.setRecordCountPerPage(3);
		BoardNotice.setPageIndex(1);
		mv.addObject("boardPaginationInfo", boardPageInfo);
		
		List<Map<String,Object>> boardSearchList = Component.getList("search.BN_getList", BoardNotice);
		
		setBoardInfo(boardSearchList,tiles, domain,search.getSearchKeywordArr());
		
		
		mv.addObject("boardSearchList", boardSearchList);
		
		
		//자료
		PaginationInfo filePageInfo = PageAccess.getPagInfo(BoardNotice.getPageIndex(),"search.FS_getCnt",BoardNotice, 5,5);
		BoardNotice.setFirstIndex(0);
		BoardNotice.setRecordCountPerPage(3);
		BoardNotice.setPageIndex(1);
		mv.addObject("filePaginationInfo", filePageInfo);
		
		List<Map<String,Object>> fileSearchList = Component.getList("search.FS_getList", BoardNotice);
		
		setFileInfo(fileSearchList,tiles,domain,search.getSearchKeywordArr());
		
		mv.addObject("fileSearchList", fileSearchList );
		
		//인물 (권한 체크 보류)
		PaginationInfo deptPageInfo = PageAccess.getPagInfo(BoardNotice.getPageIndex(),"search.dept_getCnt",BoardNotice, 5,5);
		BoardNotice.setFirstIndex(0);
		BoardNotice.setRecordCountPerPage(3);
		BoardNotice.setPageIndex(1);
		mv.addObject("deptPaginationInfo", deptPageInfo);
		
		List<Map<String,Object>> deptSearchList = Component.getList("search.dept_getList", BoardNotice);
		
//		setDeptInfo(deptSearchList,domain,search.getSearchKeywordArr());
		
		mv.addObject("deptSearchList", deptSearchList);		
		
		if(search.getSearchKeyword() != null && !search.getSearchKeyword().equals("")){
			KeywordService.checkKeyword(search.getSearchKeyword(), req);
		}
		return mv;
	}
		
	
	private void setFileInfo(List<Map<String, Object>> fileSearchList,String tiles, String domain, String[] searchKeywordArr) {
		// TODO Auto-generated method stub
		for(Map<String,Object> fileSearch : fileSearchList){
			fileSearch.put("MN_MAINNAMES", Component.getData("search.MN_getMainNames",fileSearch.get("BN_MN_KEYNO")));
			try {
				fileSearch.put("encodeFsKey", AES256Cipher.encode(String.valueOf(fileSearch.get("FS_KEYNO"))));
			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("encodeFsKey 에러");
			}
			setBoardDetailUrl(fileSearch,tiles,domain);
			
		}
		
	}


	private void setBoardInfo(List<Map<String, Object>> boardSearchList, String tiles, String domain, String[] searchKeywordArr) {
		// TODO Auto-generated method stub
		for(Map<String,Object> boardSearch : boardSearchList){
			boardSearch.put("MN_MAINNAMES", Component.getData("search.MN_getMainNames",boardSearch.get("BN_MN_KEYNO")));
			
			setSearchContents(boardSearch,"BN_CONTENTS",searchKeywordArr);
			setMenuUrl(boardSearch,domain);
			setBoardDetailUrl(boardSearch, tiles, domain);
		}
	}


	private void setMenuInfo(List<Map<String, Object>> menuSearchList, String domain, String[] searchKeywordArr) {
		// TODO Auto-generated method stub
		
		for(Map<String,Object> menuSearch : menuSearchList){
			menuSearch.put("MN_MAINNAMES", Component.getData("search.MN_getMainNames",menuSearch.get("MN_KEYNO")));
			
			setSearchContents(menuSearch,"MVD_DATA",searchKeywordArr);
			
			setMenuUrl(menuSearch,domain);
			
		}
		
		
	}


	private void setSearchContents(Map<String, Object> search, String columnName, String[] searchKeywordArr) {
		//페이지 관리에서 관리하는 메뉴라면 본문 내용 셋팅
		if(search.get(columnName) != null){
			search.put(columnName, getText((String)search.get(columnName),searchKeywordArr));
		}
	}


	private void setMenuUrl(Map<String, Object> menuSearch, String domain) {
		//도메인 셋팅
		String HM_CLIENT_URL = (String)menuSearch.get("HM_CLIENT_URL");
		if(StringUtils.isEmpty(HM_CLIENT_URL)){
			HM_CLIENT_URL = domain;
		}
		menuSearch.put("MN_URL", HM_CLIENT_URL + menuSearch.get("MN_URL"));
	}
	
	private void setBoardDetailUrl(Map<String, Object> boardSearch, String tiles, String domain) {
		// TODO Auto-generated method stub
		String BN_URL = (String)boardSearch.get("HM_CLIENT_URL");
		if(StringUtils.isEmpty(BN_URL)){
			BN_URL = domain;
		}
		//${model.MN_TILES}/Board/${BN_KEYNO_NUMBERTYPE }/detailView.do
		BN_URL += "/" + tiles + "/Board/" + boardSearch.get("BN_KEYNO")+ "/detailView.do";
		
		boardSearch.put("BN_URL", BN_URL);
	}
	

	/**
	 * html 에서 태그 제거 + 글자 자르기 + 하이라이트 표시 ( 키워드를 <font class="searchKeyword"></font>로 감쌈)
	 * @param content
	 * @param searchKeywardArr 
	 * @return
	 */
	private String getText(String content, String[] searchKeywardArr) {
        content = content.replaceAll("<!--.*-->","");

		Pattern SCRIPTS = Pattern.compile("<script([^'\"]|\"[^\"]*\"|'[^']*')*?</script>",Pattern.DOTALL);
		Pattern STYLE = Pattern.compile("<style[^>]*>.*</style>",Pattern.DOTALL);
		Pattern TAGS = Pattern.compile("<(/)?([a-zA-Z0-9]*)(\\s[a-zA-Z0-9]*=[^>]*)?(\\s)*(/)?>");
//		Pattern nTAGS = Pattern.compile("<\\w+\\s+[^<]*\\s*>");
		Pattern ENTITY_REFS = Pattern.compile("&[^;]+;");
		Pattern WHITESPACE = Pattern.compile("\\s\\s+");

		Matcher m;

		m = SCRIPTS.matcher(content);
		content = m.replaceAll("");

		m = STYLE.matcher(content);
		content = m.replaceAll("");

		m = TAGS.matcher(content);
		content = m.replaceAll("");

		m = ENTITY_REFS.matcher(content);
		content = m.replaceAll("");

		m = WHITESPACE.matcher(content);
		content = m.replaceAll(" "); 
		
		String firstEllipsis = "···"; 
		String lastEllipsis = "···"; 
		
		int length = content.length(); // 검색 내용 길이
		int start = length, end = 0;
		
		for(String keyword : searchKeywardArr){
			if(content.contains(keyword) && content.indexOf(keyword) < start){ // 모든 키워드를 포문 돌려서 가장 먼저 나오는 키워드의 시작 인덱스를 구함
				start = content.indexOf(keyword);  // 검색된 키워드 첫 index
				end  = start + keyword.length();   // 검색된 키워드 끝 index
			}
		}
		
		if(start < length){ // 키워드가 존재할시
			int first = 0,last = 0;
			if(length - end < 150){ //검색된 키워드 뒤로 글자가 부족할경우 앞에 글을 좀더 길게 자름
				first = start - 150 - (150 - (length - end));
				if(first < 0){
					first = 0;
					firstEllipsis = "";
				}
				last = length;
				lastEllipsis = "";
			}else if (start < 150){ //검색된 키워드 앞으로 글자가 부족할 경우 뒤에서 글을 좀더 길게 자름
				first = 0;
				firstEllipsis = "";
				last = end + 150 + (150 - start);
				if(last > length){
					last = length;
					lastEllipsis = "";
				}
			}else{
				first = start - 150 ;
				last = end + 150;
			}
			
			
			content = firstEllipsis +  content.substring(first, last) + lastEllipsis;
		}else if(length > 300){
			content = content.substring(0, 300) + lastEllipsis;
		}
		
		for(String keyword : searchKeywardArr){
			if(content.contains(keyword)){ 
				content = content.replaceAll(keyword, "<span class=\"r_tour_text\">"+keyword+"</span>");
			}
		}
		
		
		
		return content;

	}



	
	
	/**
	 * 날짜 리턴
	 * @param searchCondition
	 * @return
	 */
	private String[] getDateScope(String searchCondition) {
		String date[] = new String[2];
		Calendar cal = Calendar.getInstance();
	    cal.setTime(new Date());
	    /*cal.add(Calendar.DATE, 2);
	    cal.add(Calendar.MONTH, 2);*/
	    DateFormat df = new SimpleDateFormat("yyyy-MM-dd");


		switch (searchCondition) {
		case "day":
			date[1] =  df.format(cal.getTime());
			date[0] =  df.format(cal.getTime());
			break;
		case "week":
			date[1] =  df.format(cal.getTime());
			cal.add(Calendar.DATE, -7);
			date[0] =  df.format(cal.getTime());
			break;
		case "month":
			date[1] =  df.format(cal.getTime());
			cal.add(Calendar.MONTH, -1);
			date[0] =  df.format(cal.getTime());
			break;
		case "year":
			date[1] =  df.format(cal.getTime());
			cal.add(Calendar.YEAR, -1);
			date[0] =  df.format(cal.getTime());
			break;
		case "all":
		case "etc":
			return null;
		default:
			break;
		}
		
		return date;
	}

	@RequestMapping(value="/{tiles}/search/{type}/dataAjax.do")
	public ModelAndView cfUseSearchAjax(HttpServletRequest req
			, Common search
			, Menu Menu
			, BoardNotice BoardNotice
			,@PathVariable String tiles
			,@PathVariable String type) throws Exception {
		String sitePath = SiteService.getSitePath(tiles);
		ModelAndView mv  = new ModelAndView("/user/"+sitePath+"/search/prc_search_ajax");
		
		String AH_HOMEDIV_C = Component.getData("HomeManager.get_HomeKey", tiles);
		
		//권한 체크 (로그인 안 했을 경우 비회원, 했을 경우 해당 권한을 가져옴)
		Map<String,Object> user = CommonService.getUserInfo(req);
		String userAuth = "UIA_EAFDS";
		if(user != null){
			userAuth = Component.getData("Authority.UIA_getDataByUIKEYNO",  (String)user.get("UI_KEYNO"));
		}
		Menu.setUserAuth(userAuth);			// 메뉴
		BoardNotice.setUserAuth(userAuth);	// 게시판,자료,인물
		// 게시판, 자료에서 쓰는 홈 구분 키
		BoardNotice.setBN_MN_KEYNO(AH_HOMEDIV_C);

		mv.addObject("type",type);
		search.setSearchKeyword(search.getSearchKeyword().trim());
		Menu.setSearchKeyword(search.getSearchKeyword().trim());
		BoardNotice.setSearchKeyword(search.getSearchKeyword().trim());
		
		search.setSearchKeywordArr(search.getSearchKeyword().split(" "));
		Menu.setSearchKeywordArr(search.getSearchKeywordArr());
		BoardNotice.setSearchKeywordArr(search.getSearchKeywordArr());
		switch (type) {
		case "menu":
			Menu.setSearchKeywordArr(Menu.getSearchKeyword().split(" "));
			if(search.getSearchCondition() != null && !search.getSearchCondition().equals("")){
				String date[] = getDateScope(search.getSearchCondition());
				if(date != null){
					Menu.setSearchBeginDate(date[0]);
					Menu.setSearchEndDate(date[1]);
				}
			}
			//메뉴
			Menu.setMN_HOMEDIV_C(AH_HOMEDIV_C);
			
			PaginationInfo menuPageInfo = PageAccess.getPagInfo(Menu.getPageIndex(),"search.MN_getMenuListCnt",Menu, 5,5);
			Menu.setFirstIndex(menuPageInfo.getFirstRecordIndex());
			Menu.setLastIndex(menuPageInfo.getLastRecordIndex());
			Menu.setRecordCountPerPage(menuPageInfo.getRecordCountPerPage());
			Menu.setPageIndex(menuPageInfo.getCurrentPageNo());
			mv.addObject("menuPaginationInfo", menuPageInfo);
			
			List<Map<String,Object>> menuSearchList = Component.getList("search.MN_getMenuList", Menu);
			setMenuInfo(menuSearchList,CommonService.checkUrl(req),search.getSearchKeywordArr());
			
			mv.addObject("menuSearchList", menuSearchList );
			break;
		case "board":
			BoardNotice.setSearchKeywordArr(BoardNotice.getSearchKeyword().split(" "));
			
			if(search.getSearchCondition() != null && !search.getSearchCondition().equals("")){
				String date[] = getDateScope(search.getSearchCondition());
				if(date != null){
					BoardNotice.setSearchBeginDate(date[0]);
					BoardNotice.setSearchEndDate(date[1]);
				}
			}
			//게시판
			PaginationInfo boardPageInfo = PageAccess.getPagInfo(BoardNotice.getPageIndex(),"search.BN_getCnt",BoardNotice, 5,5);
			BoardNotice.setFirstIndex(boardPageInfo.getFirstRecordIndex());
			BoardNotice.setLastIndex(boardPageInfo.getLastRecordIndex());
			BoardNotice.setRecordCountPerPage(boardPageInfo.getRecordCountPerPage());
			BoardNotice.setPageIndex(boardPageInfo.getCurrentPageNo());
			mv.addObject("boardPaginationInfo", boardPageInfo);
			
			List<Map<String,Object>> boardSearchList = Component.getList("search.BN_getList", BoardNotice);
			for(Map<String,Object> b : boardSearchList){
				b.put("MN_MAINNAMES", Component.getData("search.MN_getMainNames",b.get("BN_MN_KEYNO")));
				if(b.get("BN_CONTENTS") != null){
					String BN_CONTENTS = b.get("BN_CONTENTS") + "";
					BN_CONTENTS = getText(BN_CONTENTS,search.getSearchKeywordArr());
					b.put("BN_CONTENTS", BN_CONTENTS);
				}
			}
			mv.addObject("boardSearchList", boardSearchList );
			break;
		case "file":
			BoardNotice.setSearchKeywordArr(BoardNotice.getSearchKeyword().split(" "));
			if(search.getSearchCondition() != null && !search.getSearchCondition().equals("")){
				String date[] = getDateScope(search.getSearchCondition());
				if(date != null){
					BoardNotice.setSearchBeginDate(date[0]);
					BoardNotice.setSearchEndDate(date[1]);
				}
			}
			//자료
			PaginationInfo filePageInfo = PageAccess.getPagInfo(BoardNotice.getPageIndex(),"search.FS_getCnt",BoardNotice, 5,5);
			BoardNotice.setFirstIndex(filePageInfo.getFirstRecordIndex());
			BoardNotice.setLastIndex(filePageInfo.getLastRecordIndex());
			BoardNotice.setRecordCountPerPage(filePageInfo.getRecordCountPerPage());
			BoardNotice.setPageIndex(filePageInfo.getCurrentPageNo());
			mv.addObject("filePaginationInfo", filePageInfo);
			
			List<Map<String,Object>> fileSearchList = Component.getList("search.FS_getList", BoardNotice);
			for(Map<String,Object> b : fileSearchList){
				b.put("MN_MAINNAMES", Component.getData("search.MN_getMainNames",b.get("BN_MN_KEYNO")));
				b.put("encodeFsKey", AES256Cipher.encode(String.valueOf(b.get("FS_KEYNO"))));
			}
			mv.addObject("fileSearchList", fileSearchList );
			break;
			
		case "dept":
			BoardNotice.setSearchKeywordArr(BoardNotice.getSearchKeyword().split(" "));
			BoardNotice.setBN_MN_KEYNO(AH_HOMEDIV_C);
			if(search.getSearchCondition() != null && !search.getSearchCondition().equals("")){
				String date[] = getDateScope(search.getSearchCondition());
				if(date != null){
					BoardNotice.setSearchBeginDate(date[0]);
					BoardNotice.setSearchEndDate(date[1]);
				}
			}
			//인물
			PaginationInfo deptPageInfo = PageAccess.getPagInfo(BoardNotice.getPageIndex(),"search.dept_getCnt",BoardNotice, 5,5);
			BoardNotice.setFirstIndex(deptPageInfo.getFirstRecordIndex());
			BoardNotice.setLastIndex(deptPageInfo.getLastRecordIndex());
			BoardNotice.setRecordCountPerPage(deptPageInfo.getRecordCountPerPage());
			BoardNotice.setPageIndex(deptPageInfo.getCurrentPageNo());
			mv.addObject("deptPaginationInfo", deptPageInfo);
			
			List<Map<String,Object>> deptSearchList = Component.getList("search.dept_getList", BoardNotice);
			mv.addObject("deptSearchList", deptSearchList);
			break;	
			
		default:
			break;
		}
		return mv;
	}

	
}
