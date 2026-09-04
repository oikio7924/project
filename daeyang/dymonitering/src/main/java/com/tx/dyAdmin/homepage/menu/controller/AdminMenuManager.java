package com.tx.dyAdmin.homepage.menu.controller;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.codehaus.plexus.util.StringUtils;
import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.output.Format;
import org.jdom2.output.XMLOutputter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ibm.icu.text.SimpleDateFormat;
import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.config.annotation.service.ActivityHistoryService;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.dto.Common;
import com.tx.common.file.FileManageTools;
import com.tx.common.file.FileUploadTools;
import com.tx.common.file.dto.FileSub;
import com.tx.common.security.aes.AES256Cipher;
import com.tx.common.security.handler.ReloadableFilterInvocationSecurityMetadataSource;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.page.PageAccess;
import com.tx.common.service.publish.CommonPublishService;
import com.tx.common.service.xml.XMLService;
import com.tx.dyAdmin.admin.authority.service.AdminAuthorityService;
import com.tx.dyAdmin.admin.code.service.CodeService;
import com.tx.dyAdmin.admin.domain.dto.HomeManager;
import com.tx.dyAdmin.homepage.menu.dto.Menu;
import com.tx.dyAdmin.homepage.menu.dto.MenuHeaderTemplate;
import com.tx.dyAdmin.homepage.menu.service.AdminMenuService;
import com.tx.dyAdmin.homepage.menu.service.AdminMenuSessionService;
import com.tx.dyAdmin.member.dto.UserDTO;
import com.tx.dyAdmin.operation.qrcode.dto.QrCode;
import com.tx.dyAdmin.operation.qrcode.service.QrCodeService;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * 관리자 - 메뉴관리
 * @author 
 * @version 1.0
 * @since 
 */
@Controller
public class AdminMenuManager {
	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 리로드 권한설정 */
	@Autowired ReloadableFilterInvocationSecurityMetadataSource reloadableFilterInvocationSecurityMetadataSource;
	
	/** 파일업로드 툴*/
	@Autowired private FileUploadTools FileUploadTools;
	
	/** QrCode */
	@Autowired private QrCodeService QrCodeService;
	
	/** Xml */
	@Autowired private XMLService XMLService;
	
	/** 메뉴관리 서비스 */
	@Autowired private AdminMenuService AdminMenuService;
	
	/** 메뉴관리 서비스2 */
	@Autowired private AdminMenuSessionService AdminMenuSessionService;
	
	/** 파일관리 툴 */
	@Autowired FileManageTools FileManageTools;

	/** 권한관리 서비스 */
	@Autowired private AdminAuthorityService AdminAuthorityService;
	
	/** 페이지 처리 출 */
	@Autowired private PageAccess PageAccess;
	
	/** 퍼블리쉬 관리 툴 */
	@Autowired private CommonPublishService CommonPublishService;
	
	/** 활동기록 서비스 */
	@Autowired
	private ActivityHistoryService ActivityHistoryService;
	
	@Autowired CodeService CodeService;

	/**
	 * 메뉴관리 (List) - admin
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 * 
	 */   
	@RequestMapping(value = {"/dyAdmin/homepage/menumanage/menu.do","/dyAdmin/admin/menu.do"})
	@CheckActivityHistory(desc = "메뉴관리 방문")
	public String MenuManagerView(HttpServletRequest request,Model model,Menu Menu) throws Exception{ 
		
		//홈페이지 구분 리스트
		List<HomeManager> homeDivList = CommonService.getHomeDivCode(true);
		model.addAttribute("homeDivList", homeDivList);
		
		if("/dyAdmin/admin/menu.do".equals(request.getRequestURI()) ) {
			Menu.setMN_HOMEDIV_C(SettingData.HOMEDIV_ADMIN);
		}else {
			
			Menu.setMN_HOMEDIV_C(CommonService.getDefaultSiteKey(request));
		}
		
		
		
		
		Menu.setMN_DEL_YN("N");
		
		Menu.setMN_KEYNO(Menu.getMN_HOMEDIV_C());
		Menu = Component.getData("Menu.AMN_getDataByKey", Menu);
		model.addAttribute("menu", Menu);
		HomeManager hm = new HomeManager();
		hm.setHM_MN_HOMEDIV_C(Menu.getMN_HOMEDIV_C());
		hm = Component.getData("HomeManager.HM_getDataByHOMEDIV_C", hm);
		model.addAttribute("homeData", hm);
		Map<String, Object> user = CommonService.getUserInfo(request);
		String UI_KEYNO = (String) user.get("UI_KEYNO");
		String UIA_KEYNO = Component.getData("Authority.UIA_getDataByUIKEYNO", UI_KEYNO);
		hm.setUIA_KEYNO(UIA_KEYNO);
		model.addAttribute("resultList",AdminMenuService.getMenuList(hm, null,true));
		
		return "/dyAdmin/homepage/menu/pra_menu_list.adm";
	}
	
	/**
	 * 메뉴리스트 조회 (List) - admin
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 * 
	 */   
	@RequestMapping(value = "/dyAdmin/homepage/menuListAjax.do")
	public ModelAndView MenuListViewAjax(HttpServletRequest request,HomeManager hm) throws Exception{ 
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/menu/pra_menu_list_data");
		
		hm = Component.getData("HomeManager.HM_getDataByHOMEDIV_C", hm);
		Map<String, Object> user = CommonService.getUserInfo(request);
		String UI_KEYNO = (String) user.get("UI_KEYNO");
		String UIA_KEYNO = Component.getData("Authority.UIA_getDataByUIKEYNO", UI_KEYNO);
		hm.setUIA_KEYNO(UIA_KEYNO);
		mv.addObject("resultList",AdminMenuService.getMenuList(hm, null,true));
		
		return mv;
	}
	
	/**
	 * 메뉴관리 (subList) - admin
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 * 
	 */   
	@RequestMapping(value = "/dyAdmin/homepage/menu/subList/listAjax.do")
	public ModelAndView MenuManagerSubList(Model model,Menu Menu,HttpServletRequest request) throws Exception{ 
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/menu/pra_menu_list_data");
		
		HomeManager hm = new HomeManager();
		hm.setHM_MN_HOMEDIV_C(Menu.getMN_HOMEDIV_C());
		hm = Component.getData("HomeManager.HM_getDataByHOMEDIV_C", hm);
		//권한별로 불러오기 
		Map<String, Object> user = CommonService.getUserInfo(request);
		String UI_KEYNO = (String) user.get("UI_KEYNO");
		String UIA_KEYNO = Component.getData("Authority.UIA_getDataByUIKEYNO", UI_KEYNO);
		hm.setUIA_KEYNO(UIA_KEYNO);
		hm.setHM_MN_MAINKEY(Menu.getMN_MAINKEY());
		mv.addObject("resultList",AdminMenuService.getMenuList(hm,null,false,true,true));
		
		return mv;
	}
	
	/**
	 * 메뉴 페이지 엑셀 - excel ajax
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 * 
	 */   
	@RequestMapping(value = "/dyAdmin/homepage/menu/excelAjax.do")
	public ModelAndView MenuExcelAjax(
			HttpServletResponse res
			,HttpServletRequest request
			, Model model,Menu Menu) throws Exception{ 
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/menu/pra_menu_list_excel");
		Menu.setMN_DEL_YN("N");
		HomeManager homeManager = Component.getData("Menu.AMN_getMenuList",Menu);
		//권한별로 불러오기 
		Map<String, Object> user = CommonService.getUserInfo(request);
		String UI_KEYNO = (String) user.get("UI_KEYNO");
		String UIA_KEYNO = Component.getData("Authority.UIA_getDataByUIKEYNO", UI_KEYNO);
		homeManager.setUIA_KEYNO(UIA_KEYNO);
		
		mv.addObject("resultList", AdminMenuService.getMenuList(homeManager,null, true, false,true));
		
		Integer HM_MENU_DEPTH = Component.getData("Menu.get_HomeDepth", Menu);

		mv.addObject("depth", HM_MENU_DEPTH);
		
		try {
			Cookie cookie = new Cookie("fileDownload", "true");
			cookie.setPath("/");
			res.addCookie(cookie);
		} catch (Exception e) {
			System.out.println("쿠키 에러 :: "+e.getMessage());
		}
		
		String WebName = Component.getData("Menu.excel_getWebName", Menu);
		mv.addObject("WEBNAME", WebName);
		
		return mv;
	}
	
	/**
	 * 메뉴 Xml 리스트 
	 * @param model
	 * @return
	 * @throws Exception
	 * 
	 */ 
	@ResponseBody
	@RequestMapping(value = "/dyAdmin/homepage/menu/xmlList/listAjax.do")
	public List<HashMap<String, Object>> MenuXmlListAjax(
			HttpServletResponse res
			, Model model,Menu Menu) throws Exception{ 
		
		List<HashMap<String, Object>> list = Component.getList("Menu.XML_getHistoryList", Menu); 

		for( int i = 0 ; i < list.size(); i++){	
			HashMap<String,Object> fileSub = list.get(i);
		    fileSub.put("encodeFsKey", AES256Cipher.encode(String.valueOf(fileSub.get("XH_FS_KEYNO"))));
		}
		
		return list;
	}

	/**
	 * 메뉴 페이지 xml - xml ajax
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 * 
	 */   
	@RequestMapping(value = "/dyAdmin/homepage/menu/xmlList/backupAjax.do")
	public void MenuXmlBackupAjax(
			  HttpServletRequest request
			, HttpServletResponse response
			, Model model
			, Menu Menu
			, HomeManager HomeManager) throws Exception{ 
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("MN_HOMEDIV_C", Menu.getMN_HOMEDIV_C());
		List<HashMap<String, Object>> MenuInfoList = Component.getList("Menu.XML_getMenuInfo", map);
		
		Document doc = new Document();  
		doc = getXmlfile(MenuInfoList);
		
		String WebName = Component.getData("Menu.excel_getWebName", Menu);
		Date today = new Date();
		SimpleDateFormat date = new SimpleDateFormat("yyyyMMddHHmmss");
		WebName = WebName+"_" + date.format(today) + ".xml";
		FileSub FileSub = new FileSub();
		String propertiespath = SiteProperties.getString("RESOURCE_PATH");

		FileManageTools.checkFolder(propertiespath + "attach/");

		String filepath = propertiespath + "attach/" + WebName;
		try(FileOutputStream out = new FileOutputStream(filepath);) {                               
				
			    //xml 파일을 떨구기 위한 경로와 파일 이름 지정해 주기
			    XMLOutputter serializer = new XMLOutputter();                 
			                                                                    
			    Format f = serializer.getFormat();                            
			    f.setEncoding("UTF-8");
			    //encoding 타입을 UTF-8 로 설정
			    f.setIndent(" ");                                             
			    f.setLineSeparator("\r\n");                                   
			    f.setTextMode(Format.TextMode.TRIM);                          
			    serializer.setFormat(f);                                      
			                                                                    
			    serializer.output(doc, out);
			    
			    out.flush();
			  
			    Map<String,Object> user = CommonService.getUserInfo(request);
			    FileSub = FileUploadTools.FileUploadByXML(WebName, filepath,(String)user.get("UI_KEYNO"));
		        
		      //String 으로 xml 출력
		     // XMLOutputter outputter = new XMLOutputter(Format.getPrettyFormat().setEncoding("UTF-8")) ;
		     // System.out.println(outputter.outputString(doc));
		  } catch (IOException e) {                                         
		      System.err.println("파일업로드 에러");                                        
		  }  
		   Menu.setXH_KEYNO(CommonService.getTableKey("XH"));
		   Menu.setXH_MN_KEYNO(Menu.getMN_HOMEDIV_C());
		   Menu.setXH_FS_KEYNO(FileSub.getFS_KEYNO());
		   Component.createData("Menu.XML_regist", Menu);
	}
	
	/**
	 * xml 파일 생성
	 @param resultList
	 @return
	 */
	private Document getXmlfile(List<HashMap<String, Object>> MenuInfoList) {
		Document document = null;
		Element rootElement = null;
		Element rootElement2 = null;
		
		// document 초기화.
	    document = new Document();
	    rootElement = new Element("menuInfo");
	    // root Element의 태그와 value값을 설정함.
	    rootElement.setAttribute("type", "menu");
	    // document와 Element값을 합치는 작업.
	    document.addContent(rootElement);
	   
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("table", "S_MENU_MANAGER");
		//컬럼명
		List<HashMap<String, Object>> MenuColumn = Component.getList("Menu.XML_getMenuColumn", map);
		
		if(MenuInfoList != null && MenuInfoList.size() > 0){
			for(HashMap<String, Object> MenuData : MenuInfoList){
				rootElement2 = new Element("manager");
				rootElement2.setAttribute("type", "info");
				if(MenuColumn != null && MenuColumn.size() > 0){
					for(HashMap<String, Object> column : MenuColumn){
						String value = null;
						String name = column.get("Field").toString();
						if(MenuData.get(name) == null){
							value = "";
						}else{
							value = MenuData.get(name).toString();
						}
						Element Element = null;
						// 실질적으로 element에 들어가는 태그와 value값을 설정하는 것.
						Element = new Element(name);
						Element.setText(value);
						// rootElement와 생성한 element를 합치는 작업
						rootElement2.addContent(Element); 
					}
					
				}
				rootElement.addContent(rootElement2);
			}
		}
	  return document;
		 
	}

	/**
	 * 메뉴 페이지 xml - xml 복원
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 * 
	 */ 
	@ResponseBody
	@Transactional
	@RequestMapping(value = "/dyAdmin/homepage/menu/xmlList/refreshAjax.do")
	public String MenuXmlRefreshAjax(
			  HttpServletRequest request
			, HttpServletResponse response
			, Model model
			, Menu Menu) throws Exception{ 
		List<String> list = Component.getList("Menu.XML_getAllMenuList", Menu);
		if(list != null && list.size() > 0){
			Component.deleteData("Menu.XML_MenuListDel", Menu);
		}
		FileSub FileSub = new FileSub();
		FileSub.setFS_KEYNO(AES256Cipher.decode(Menu.getXH_FS_KEYNO()));
		FileSub = Component.getData("File.AFS_SubFileDetailselect", FileSub);
		XMLService.getXmlData(FileSub,"S_MENU_MANAGER","manager",1);
		return Menu.getMN_HOMEDIV_C();
	}
	
	 
	/**
	 * 메뉴 페이지 xml - xml 삭제
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 * 
	 */ 
	@ResponseBody
	@RequestMapping(value = "/dyAdmin/homepage/menu/xmlList/deleteAjax.do")
	public void MenuXmlDeleteAjax(
			HttpServletRequest request
			, HttpServletResponse response
			, Model model
			, Menu Menu) throws Exception{ 
		Menu.setXH_KEYNO(AES256Cipher.decode(Menu.getXH_KEYNO()));		
		Component.deleteData("Menu.XML_Delete", Menu);
	}
	
	

	 
	/**
	 * url 중복체크
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 * 
	 */ 
	@RequestMapping(value = "/dyAdmin/homepage/menu/urlCheckAjax.do")
	@ResponseBody
	public Integer MenuUrlCheckAjax(
			  @ModelAttribute Menu Menu
			) throws Exception{ 
		
		Menu.setMN_PAGEDIV_C(SettingData.MENU_TYPE_LINK);
		
		return Component.getCount("Menu.AMN_getMenuUrlList",Menu);
	}
	
	
	/**
	 * 메뉴 - 등록,수정,권한 폼 불러오기
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 * 
	 */
	@RequestMapping(value = "/dyAdmin/homepage/menu/menuManagerAjax.do")
	public ModelAndView MenuManagerAjax(
		 	  @ModelAttribute Menu Menu
			, @RequestParam(value="action", required=false) String action
			, @RequestParam(value="lev", required=false) Integer lev
			, @RequestParam(value="name", required=false) String name
            , @RequestParam(value="tVal", required=false) String tVal
            ,HttpServletRequest req
			) throws Exception{ 
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/menu/pra_menu_insert");

		String AUTH_KEY = "";
		if(action != null && action.equals("Update")){
			AUTH_KEY = tVal;
			mv.addObject("resultData",Component.getData("Menu.AMN_getData",tVal));
		}else{
			AUTH_KEY = Menu.getMN_MAINKEY();
			mv.addObject("mainUrl",tVal);
		}
		
		//홈페이지 구분 리스트
		List<HomeManager> homeDivList = CommonService.getHomeDivCode(true);
		mv.addObject("homeDivList", homeDivList);
		//메뉴 타입 리스트
		mv.addObject("menuList",CodeService.getCodeListisUse("AF", true));
		//게시판 타입 리스트
		mv.addObject("boardTypeList",Component.getListNoParam("BoardType.BT_getList2"));
		
		mv.addObject("length",Component.getData("Menu.AMN_getMenuCnt",Menu));
		
		mv.addObject("homeData", Component.getData("HomeManager.HM_getDataByHOMEDIV_C", Menu.getMN_HOMEDIV_C()));
		
		mv.addObject("lev",lev);
		mv.addObject("action",action);
		mv.addObject("name",name);
		mv.addObject("Menu",Menu);
		
		HashMap<String, Object> menu = Component.getData("Menu.MN_getMenuData", AUTH_KEY);
		mv.addObject("menuData", menu);
		mv.addObject("anonymousData", Component.getData("Authority.UIA_GetAnonymous", AUTH_KEY));
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("AUTH_KEY", AUTH_KEY);
		map.put("MenuLev", lev);
		mv.addObject("MainMenuAuth", Component.getData("Authority.get_MainMenuAuth", map));
		UserDTO subType = new UserDTO();
		subType.setUIR_TYPE(SettingData.AUTHORITY_SUB_BOARD);
		mv.addObject("boardAuthorityList", Component.getList("Authority.UIR_GetList", subType));
		mv.addObject("menuAuthorityUserList", AdminAuthorityService.getUserList(AUTH_KEY));
		
		HashMap<String, Object> dethManu = new HashMap<>();
		dethManu.put("MN_HOMEDIV_C", menu.get("MN_HOMEDIV_C"));
		dethManu.put("MN_PAGEDIV_C", SettingData.MENU_TYPE_SUBMENU);
		dethManu.put("MN_URL", menu.get("MN_URL"));
		//권한별 메뉴 조회
		Map<String,Object> user = CommonService.getUserInfo(req);
		String userKeyno = ((String) user.get("UI_KEYNO"));
		String UIA_KEYNO = Component.getData("Authority.UIA_getDataByUIKEYNO", userKeyno);
		dethManu.put("UIA_KEYNO", UIA_KEYNO);
		mv.addObject("menuSubMenuList",Component.getList("Menu.get_subMenuList", dethManu));
		
		return mv;
	}
	
	/**
	 * 메뉴 - 뎁스 이동
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 * 
	 */
	@RequestMapping(value = "/dyAdmin/homepage/menu/menuDethMoveAjax.do")
	public List<HashMap<String, Object>> MenuDethMoveAjax(
			@ModelAttribute Menu Menu
			,HttpServletRequest req
			) throws Exception{ 
		ModelAndView mv = new ModelAndView("/dyAdmin/homepage/menu/pra_menu_insert");
		
		HashMap<String, Object> dethManu = new HashMap<>();
		dethManu.put("MN_HOMEDIV_C", Menu.getMN_HOMEDIV_C());
		dethManu.put("MN_PAGEDIV_C", SettingData.MENU_TYPE_SUBMENU);
		//권한별 메뉴 조회
				Map<String,Object> user = CommonService.getUserInfo(req);
				String userKeyno = ((String) user.get("UI_KEYNO"));
				String UIA_KEYNO = Component.getData("Authority.UIA_getDataByUIKEYNO", userKeyno);
				dethManu.put("UIA_KEYNO", UIA_KEYNO);
		mv.addObject("menuSubMenuList",Component.getList("Menu.get_subMenuList",dethManu));
		
		List<HashMap<String, Object>> resultList = Component.getList("Menu.get_subMenuList",dethManu);
		
		return resultList;
	}
	
	/**
	 * 메뉴관리 (등록) - admin
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 * 
	 */   					 
	@RequestMapping(value = "/dyAdmin/homepage/menu/insertAjax.do")
	@CheckActivityHistory(desc = "메뉴 등록 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	@ResponseBody
	public HashMap<String, Object> MenuManagerResist(
			 Model model
			,@ModelAttribute Menu Menu
			,@RequestParam(value="accessRole",required=false) String[] accessRole
			,@RequestParam(value="viewRole",required=false) String[] viewRole
			,@RequestParam(value="actionRole",required=false) String[] actionRole
			, HttpServletRequest req
			) throws Exception{ 
		
		Menu.setMN_KEYNO(CommonService.getTableKey("MN"));
		int a;
		// 입력된 정렬기준의 절렬순서를 가지고 있는 메뉴를 찾아 갯수를 세는 sql문
		a = Component.getData("Menu.AMN_getMNLV", Menu);
		
		//sql문 결과 데이터가 존재하는 경우, 해당 번호부터 해당 번호보다 큰 숫자의 정렬 순서들을 모두 +1해주는 코딩문 실행
		if(a>0){
			Component.updateData("Menu.AMN_addMNLV", Menu);
		}
		
		QrCodeInput(req, Menu);	
		
		Map<String,Object> user = CommonService.getUserInfo(req);
		Menu.setMN_REGNM((String)user.get("UI_KEYNO"));
		
		
		Component.createData("Menu.AMN_regist",Menu);
		
		AuthorityProcess(Menu.getMN_KEYNO(),accessRole,viewRole,actionRole,req);
		
		//저장할때 해당키 수정시간저장
		AdminMenuSessionService.updateTime(Menu.getMN_HOMEDIV_C());
		
		return Component.getData("Menu.MN_getMenuData", Menu.getMN_KEYNO());
	}
	
	
	/**
	 * 권한 처리 작업
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 * 
	 */   	
	private void AuthorityProcess(String MN_KEYNO,String[] accessRole,String[] viewRole,String[] actionRole,HttpServletRequest req) throws Exception{
		
		HashMap<String,Object> map = new HashMap<String,Object>();
		map.put("MN_KEYNO", MN_KEYNO);
		Component.deleteData("Authority.MN_deleteData", map);
		
		List<HashMap<String,Object>> roleList = new ArrayList<HashMap<String,Object>>();
		HashMap<String,Object> role = null;
		if(accessRole != null){
			for(String access : accessRole){
				role = new HashMap<String,Object>();
				role.put("UIA_KEYNO", access);
				role.put("UIR_KEYNO", SettingData.AUTHORITY_ROLE_ACCESS);
				roleList.add(role);
			}
		}
		if(viewRole != null){
			for(String view : viewRole){
				role = new HashMap<String,Object>();
				role.put("UIA_KEYNO", view);
				role.put("UIR_KEYNO", SettingData.AUTHORITY_ROLE_VIEW);
				roleList.add(role);
			}
		}
		if(actionRole != null){
			for(String action : actionRole){
				role = new HashMap<String,Object>();
				role.put("UIA_KEYNO", action);
				role.put("UIR_KEYNO", SettingData.AUTHORITY_ROLE_ACTION);
				roleList.add(role);
			}
		}
		
		UserDTO subType = new UserDTO();
		subType.setUIR_TYPE(SettingData.AUTHORITY_SUB_BOARD);
		List<UserDTO> subTypeList = Component.getList("Authority.UIR_GetList", subType);
		
		for(UserDTO sub : subTypeList){
			String name = sub.getUIR_NAME();
			String key = sub.getUIR_KEYNO();
			
			String boardAuthList[] = req.getParameterValues(name+"Role");
			if(boardAuthList != null){
				for(String boardAuth : boardAuthList){
					role = new HashMap<String,Object>();
					role.put("UIA_KEYNO", boardAuth);
					role.put("UIR_KEYNO", key);
					roleList.add(role);
				}
			}
		}
		if(roleList.size() > 0){
			map.put("roleList", roleList);
			Component.createData("Authority.UAR_Menu_insertAll", map);
		}
				
	}
	
	
	
	
	/**
	 * 메뉴관리 (수정) - admin
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 * 
	 */   					 
	@RequestMapping(value = "/dyAdmin/homepage/menu/updateAjax.do")
	@CheckActivityHistory(desc = "메뉴관리 수정 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	@ResponseBody
	public HashMap<String, Object> MenuManagerUpdate(
			 HttpServletRequest request
			,Model model
			,Menu Menu
			,HttpServletRequest req
			,@RequestParam(value="accessRole",required=false) String[] accessRole
			,@RequestParam(value="viewRole",required=false) String[] viewRole
			,@RequestParam(value="actionRole",required=false) String[] actionRole
			,QrCode QrCode
			) throws Exception{ 
		
		
		if(!(Menu.getMN_beforeURL().equals(Menu.getMN_URL()))) {
			//QR코드 생성
			QrCodeInput(req, Menu);
		}
		
		Map<String,Object> user = CommonService.getUserInfo(req);
		Menu.setMN_MODNM((String)user.get("UI_KEYNO"));
		
		Component.updateData("Menu.AMN_update",Menu);
		Component.updateData("Menu.MN_OrderUpdate",Menu);
		
		//소메뉴일시 하위 메뉴들 url 변경
		if(Menu.getMN_PAGEDIV_C().equals(SettingData.MENU_TYPE_SUBMENU)){ //SC_QXCFB 소메뉴 코드
			Component.updateData("Menu.AMN_updateSubList",Menu);
		}
		
		AuthorityProcess(Menu.getMN_KEYNO(),accessRole,viewRole,actionRole,req);	//권한 설정

		if(Menu.getDethCHANGEYN()){
			MenuDethMoveProcess(Menu);			//뎁스 변경
		}
		
		//저장할때 해당키 수정시간저장
		AdminMenuSessionService.updateTime(Menu.getMN_HOMEDIV_C());
			
		return Component.getData("Menu.MN_getMenuData", Menu.getMN_KEYNO());
	}
	
	/**
	 * 뎁스 변경 처리 작업
	 *
	 * @param menu
	 * @return
	 * @throws Exception
	 * 
	 */
	private void MenuDethMoveProcess(Menu menu) throws Exception {

		Component.updateData("Menu.set_changeDethOrder", menu); //해당 뎁스의 메뉴들 순서 정렬
		String urlDepth[] = menu.getDethChUrl().substring(menu.getDethChUrl().indexOf("/")+1).split("/");
		int chDepth = urlDepth.length - 1;
		menu.setDethInterval(menu.getMN_LEV() - chDepth);		//소메뉴 하위 메뉴들 뎁스 수정
		
		if(StringUtils.isNotBlank(menu.getMN_PAGEDIV_C())){
			if(menu.getMN_PAGEDIV_C().equals(SettingData.MENU_TYPE_SUBMENU)){
				Component.updateData("Menu.set_updateSubMenuUrl", menu);
			}
		}
		
		HashMap<String, Object> menuMap = new HashMap<>();
		menuMap.put("MN_LEV", chDepth);
		menuMap.put("MN_ORDER", Component.getData("Menu.get_changeDethOrder", menu));	//무조건 마지막 순서로 배정
		menuMap.put("MN_URL", menu.getDethChUrl());
		menuMap.put("MN_MAINKEY", menu.getDethSubMenuKey());
		menuMap.put("MN_KEYNO", menu.getMN_KEYNO());
		Component.updateData("Menu.set_changeDeth", menuMap);
	}
	
	/**
	 * 메뉴관리 (보이기/감추기) - admin
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 * 
	 */   					 
	@RequestMapping(value = "/dyAdmin/homepage/menu/show/updateAjax.do")
	@CheckActivityHistory(desc = "메뉴관리 보이기/감추기/사용여부 수정작업" , homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	@ResponseBody
	public HashMap<String, Object> MenuManagerShow(
			 Model model
			,Menu Menu
			,@RequestParam(value="processType",required=false) String processType
			, HttpServletRequest req) throws Exception{ 
		HashMap<String, Object> map = new HashMap<>();
		if(processType != null){
			if(processType.equals("show")){
				map.put("colunm", "MN_SHOW_YN");
				map.put("value", Menu.getMN_SHOW_YN());
			}else if(processType.equals("use")){
				map.put("colunm", "MN_USE_YN");
				map.put("value", Menu.getMN_USE_YN());
			}
		}
		Map<String,Object> user = CommonService.getUserInfo(req);
		map.put("MN_MODNM", (String)user.get("UI_KEYNO"));
		map.put("MN_KEYNO", Menu.getMN_KEYNO());
		Component.updateData("Menu.AMN_ShowUse",map);
		//저장할때 해당키 수정시간저장
		AdminMenuSessionService.updateTime(Menu.getMN_HOMEDIV_C());
		return Component.getData("Menu.MN_getMenuData", Menu.getMN_KEYNO());
	}
	
	
	/**
	 * 메뉴관리 (삭제) - admin
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 * 
	 */   					 
	@RequestMapping(value = "/dyAdmin/homepage/menu/deleteAjax.do")
	@CheckActivityHistory(desc = "메뉴관리 - 삭제 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@ResponseBody
	public HashMap<String, Object> MenuManagerDelete(Model model,Menu Menu, HttpServletRequest req) throws Exception{ 
		
		Menu = Component.getData("Menu.AMN_getDataByKey", Menu);
		Component.updateData("Menu.AMN_DeleteOrder", Menu);
		Map<String,Object> user = CommonService.getUserInfo(req);
		Menu.setMN_MODNM((String)user.get("UI_KEYNO"));
		Component.deleteData("Menu.AMN_DeleteByLikeURL", Menu);
		
		//메뉴에 해당하는 권한 삭제
		Component.deleteData("Authority.MN_deleteData", Menu.getMN_KEYNO());
		
		//메뉴에 해당하는 뷰페이지 삭제
		Component.deleteData("HTMLViewData.delete_pageView", Menu.getMN_KEYNO());
				
		//저장할때 해당키 수정시간저장
		AdminMenuSessionService.updateTime(Menu.getMN_HOMEDIV_C());
		
		return Component.getData("Menu.MN_getMenuData", Menu.getMN_KEYNO());
	}
	
	public void QrCodeInput(HttpServletRequest req, Menu Menu) {
		String url = req.getScheme()+"://"+req.getServerName()+":"+req.getServerPort()+Menu.getMN_URL();
		
		String filename = Menu.getMN_URL().replaceAll("/", "_");
		FileSub sub = QrCodeService.getMenuQrCode(url, 100, 100, filename);
		String QR_KEY = sub.getFS_KEYNO();
		Menu.setMN_QR_KEYNO(QR_KEY);
	}
	/**
	 * 
	 * @param 2019-09-03 신강철
	 * @param 단일 QR초기화
	 */
	@RequestMapping(value = "/dyAdmin/user/QRcodeAjax.do")
	@ResponseBody
	public void QrCodeInput_Mapping(HttpServletRequest req, Menu Menu) {
		String url = req.getScheme()+"://"+req.getServerName()+":"+req.getServerPort()+Menu.getMN_URL();
		
		String filename = Menu.getMN_URL().replaceAll("/", "_");
		FileSub sub = QrCodeService.getMenuQrCode(url, 100, 100, filename);
		String QR_KEY = sub.getFS_KEYNO();
		Menu.setMN_QR_KEYNO(QR_KEY);
		Component.createData("Menu.ch_QRcode", Menu);
	}
	/**
	 * 
	 * @param 2019-09-03 신강철
	 * @param 천체 QR초기화
	 */
	@RequestMapping(value = "/dyAdmin/user/AllQRcodeAjax.do")
	@ResponseBody
	public void QrCodeInput_all(HttpServletRequest req, Menu Menu) {
		Menu.setMN_SHOW_YN("Y");
		List<Menu> MenuList = Component.getList("AMN_getUserMenuListByHOMEDIV", Menu); 
		for(Menu m : MenuList) {
			QrCodeInput_Mapping(req, m);
		}
		
	}
	
	
	
	/**
	 * 메뉴 템플렛 관리
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/menumanage/template.do")
	@CheckActivityHistory(desc="메뉴관리 - 메뉴 템플릿관리 방문")
	public ModelAndView MenuTemplate(HttpServletRequest req
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/menu/menutemplate/pra_menu_template_listView.adm");
		return mv;
	}
	
	
	/**
	 * 메뉴 템플렛 관리 - 페이징 ajax
	 * @param req
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/homepage/menumanage/template/pagingAjax.do")
	public ModelAndView MenuTemplatePagingAjax(HttpServletRequest req,
			Common search
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/menu/menutemplate/pra_menu_template_listview_data");

		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"Menu.SMT_getListCnt",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		mv.addObject("resultList", Component.getList("Menu.SMT_getList", map));
		mv.addObject("search", search);
		return mv;
	}
	
	
	
	
	@RequestMapping(value="/dyAdmin/homepage/menumanage/template/actionView.do")
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	public ModelAndView MenuTemplateInsertView(HttpServletRequest req,
			@RequestParam(value="action", required=false) String action
			, MenuHeaderTemplate MenuHeaderTemplate
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/homepage/menu/menutemplate/pra_menu_template_insertView.adm");
		
		if("update".equals(action)){
			mv.addObject("SMT_DATA", Component.getData("Menu.SMT_getData", MenuHeaderTemplate));
			mv.addObject("type","update");
		}else{
			mv.addObject("type","insert");
		}
		ActivityHistoryService.setDescMenuSkinAction("메뉴 스킨관리", "insertView", req);
		mv.addObject("formDataList", Component.getListNoParam("Menu.SMT_getFormList"));
		mv.addObject("mirrorPage","/dyAdmin/homepage/menumanage/template.do");
		return mv;
	}
	

	
	@RequestMapping(value = "/dyAdmin/homepage/menumanage/template/action.do")
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView MenuTemplateInsert(MenuHeaderTemplate MenuHeaderTemplate,  HttpServletRequest req,
			 @RequestParam(value="action", required=false) String action )
			throws Exception {
		ModelAndView mv = new ModelAndView("redirect:/dyAdmin/homepage/menumanage/template.do");
		
		
		if("update".equals(action)){
		Component.updateData("Menu.SMT_update", MenuHeaderTemplate);
		}else{
		MenuHeaderTemplate.setSMT_KEYNO(CommonService.getTableKey("SMT"));	
		Component.createData("Menu.SMT_insert", MenuHeaderTemplate);
		}
		
		// 활동기록
		ActivityHistoryService.setDescMenuSkinAction("메뉴 스킨관리", action, req);
		return mv;
	}
	

	
	@RequestMapping(value = "/dyAdmin/homepage/menumanage/template/delete.do")
	@CheckActivityHistory(desc="메뉴 헤더템플렛 삭제 처리", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public ModelAndView MenuTemplateDelete(MenuHeaderTemplate MenuHeaderTemplate,  HttpServletRequest req)
			throws Exception {
		ModelAndView mv = new ModelAndView("redirect:/dyAdmin/homepage/menumanage/template.do");
		
		Component.updateData("Menu.SMT_delete", MenuHeaderTemplate);

		return mv;
	}
	
	
	
	
	@RequestMapping(value = "/dyAdmin/homepage/menumanage/template/publishAjax.do")
	@ResponseBody
	@CheckActivityHistory(desc="메뉴 헤더템플렛 파일 배포 처리", homeDiv = SettingData.HOMEDIV_ADMIN)
	@Transactional
	public boolean publishFile(MenuHeaderTemplate MenuHeaderTemplate, HttpServletRequest req)
			throws Exception {
		
		
		return CommonPublishService.menuTemplate(MenuHeaderTemplate);
		
	}
	
	

	
	
}
