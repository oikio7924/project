package com.tx.common.service.publish.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.servlet.ServletContext;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Service;
import org.springframework.util.ReflectionUtils;
import org.springframework.web.context.ServletContextAware;
import org.springframework.web.context.WebApplicationContext;

import com.tx.common.config.SettingData;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.file.FileManageTools;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.publish.CommonPublishService;
import com.tx.dyAdmin.admin.board.dto.BoardMainMini;
import com.tx.dyAdmin.admin.board.dto.BoardSkin;
import com.tx.dyAdmin.admin.domain.dto.HomeManager;
import com.tx.dyAdmin.admin.site.dto.SiteManagerDTO;
import com.tx.dyAdmin.homepage.menu.dto.MenuHeaderTemplate;
import com.tx.dyAdmin.homepage.popup.dto.PopupSkinDTO;
import com.tx.dyAdmin.homepage.popupzone.dto.PopupZoneCategoryDTO;
import com.tx.dyAdmin.homepage.research.dto.ResearchSkinDTO;
import com.tx.dyAdmin.homepage.resource.dto.ResourcesDTO;
import com.tx.dyAdmin.operation.survey.dto.SsDTO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service("CommonPublishService")
public class CommonPublishServiceImpl extends EgovAbstractServiceImpl implements CommonPublishService, ServletContextAware, ApplicationContextAware {

	private static final Logger log = LoggerFactory.getLogger(CommonPublishServiceImpl.class);

	/** 공통 컴포넌트 */
	@Autowired
	ComponentService Component;
	@Autowired
	CommonService CommonService;

	@Autowired
	FileManageTools FileManageTools;

	/** 현재 웹앱 경로 사용 시 RESOURCE_PATH/JSP_PATH를 배포 경로로 쓸 때 사용 (루트 컨텍스트에서는 setServletContext 미호출될 수 있어 ApplicationContext에서 보완) */
	private ServletContext servletContext;

	@PostConstruct
	public void init() throws Exception {

		if (SiteProperties.getAutoPublish()) {
			try {
				all();
			} catch (Exception e) {
				// 퍼블리시 실패(예: T_SURVEY_SKIN 등 일부 DB 테이블 없음) 시에도 서버 기동은 진행
				System.err.println("CommonPublishService init(all) 실패 - 퍼블리시(일부 JSP/리소스 생성)가 스킵될 수 있습니다. 원인: " + e.getMessage());
				e.printStackTrace();
			}
		}
	}

	@Override
	public boolean all() throws Exception {
		List<HomeManager> homeDivList = CommonService.getHomeDivCode(false);

		for (HomeManager homeManager : homeDivList) {

			String path = homeManager.getHM_SITE_PATH();
			String homeDiv = homeManager.getHM_MN_HOMEDIV_C();

			if (!resource(path, homeDiv, null)) return false;

			if (!layout(path, homeDiv, null, true)) return false;

			if (!page(path, homeDiv, null)) return false;

		}

		if (!miniBoard(null)) return false;

		if (!popupZone(null)) return false;

		if (!menuTemplate(null)) return false;

		if (!InsertFonts()) return false;
		
		try {
			if(!survey(true, "")) return false;
		} catch (Exception e) {
			// T_SURVEY_SKIN 테이블 없음 등 설문 미사용 시 스킵 (스택 없이 한 줄만 로그)
			System.err.println("CommonPublishServiceImpl: survey 스킵 (설문 미사용 시 무시 가능). 원인: " + e.getMessage());
		}
		
		if(!researchSkin(null)) return false;
		
		if(!popupSkin(null)) return false;
		
		if(!index(null, "index", null, true)) return false;
		
		if(!BoardTemplate(null)) return false;
		
		return true;
	}

	/**
	 * 리소스(css,js) 배포
	 */
	@Override
	public boolean resource(String path, String homeDiv, String key) throws Exception {

		String resourceTypeList[] = { "css", "js" };

		for (String resourceType : resourceTypeList) {
			if (!resource(path, homeDiv, key, resourceType))
				return false;
		}

		return true;
	}

	/**
	 * 리소스(css,js) 배포
	 */
	@Override
	public boolean resource(String path, String homeDiv, String key, String resourceType) throws Exception {

		String resourceBase = checkSlush("RESOURCE_PATH");
		String filePath = resourceBase + "/publish/" + path + "/" + resourceType + "/";
		if (path != null && (path.equals("_DY") || path.equals("_SFA") || path.equals("_BD"))) {
			log.info("CommonPublishService 리소스 쓰기 경로 [RESOURCE_PATH] :: {}", resourceBase);
		}

		HashMap<String, Object> data = new HashMap<>();
		data.put("RM_MN_HOMEDIV_C", homeDiv);
		data.put("RM_TYPE", resourceType);

		if (StringUtils.isNotEmpty(key)) data.put("RM_KEYNO", key);

		List<HashMap<String, Object>> resourcesList = Component.getList("Resources.RM_getDataByDistribute", data);

		for (HashMap<String, Object> hashMap : resourcesList) {

			String str = StringUtils.defaultIfEmpty((String) hashMap.get("RM_DATA"), "");
			String fileName = (String) hashMap.get("RM_FILE_NAME") + "." + resourceType;

			boolean isCompression = fileName.contains(".min");
			if (!FileManageTools.create_File(filePath, fileName, str, isCompression)) {
				return false;
			}
		}
		return true;
	}

	/**
	 * 레이아웃 배포
	 */
	@Override
	public boolean layout(String path, String homeDiv, String scope, boolean distributeType) throws Exception {
		HashMap<String, Object> data = new HashMap<>();
		data.put("RM_MN_HOMEDIV_C", homeDiv);
		data.put("RM_TYPE", "layout");

		if (distributeType) {
			scope = "";
		}

		if (StringUtils.isNotEmpty(scope))
			data.put("RM_SCOPE", scope);

		String filePath = checkSlush("JSP_PATH") + "/publish/" + path + "/";

		List<ResourcesDTO> resourcesList = Component.getList("Resources.RM_getLayoutDataByDistribute", data);

		for (ResourcesDTO resources : resourcesList) {

			if ("layout".equals(resources.getRM_SCOPE())) {
				filePath = checkSlush("JSP_PATH") + "/layout/user/defaultlayout/" + path;
			}

			String layoutFilePath = filePath + "/";
			String str = StringUtils.defaultIfEmpty(resources.getRM_DATA(), "");
			String fileName = resources.getRM_FILE_NAME() + ".jsp";
			if (!resources.getRM_SCOPE().equals("prc_main") && !resources.getRM_SCOPE().equals("layout")) {
				layoutFilePath = filePath + "include/";
			}
			boolean isCompression = fileName.contains(".min");

			if (!FileManageTools.create_File(layoutFilePath, fileName, str, isCompression)) {
				return false;
			}
		}

		return true;
	}

	/**
	 * 페이지 배포
	 */
	@Override
	public boolean page(String path, String homeDiv, String key) throws Exception {

		String filePath = checkSlush("JSP_PATH") + "/publish/" + path + "/views/";

		HashMap<String, Object> data = new HashMap<>();
		data.put("MVD_MN_HOMEDIV_C", homeDiv);
		if (StringUtils.isNotEmpty(key)) {
			data.put("MVD_KEYNO", key);
		}

		List<HashMap<String, Object>> pageList = Component.getList("HTMLViewData.get_PageViewInfoDistribute", data);
		for (HashMap<String, Object> page : pageList) {
			String str = SettingData.JSPDATA;
			String MVD_DATA = (String) page.get("MVD_DATA");
			if (StringUtils.isNotEmpty(MVD_DATA)) {
				str += MVD_DATA;
			}
			String fileName = getFileName("page", (String) page.get("MN_KEYNO"), true);
			boolean isCompression = fileName.contains(".min");

			if (!FileManageTools.create_File(filePath, fileName, str, isCompression)) {
				return false;
			}
		}

		return true;
	}

	/**
	 * 페이지 미리보기 배포
	 */
	@Override
	public boolean pagePreview(String tiles, String contents) throws Exception {
		contents = SettingData.JSPDATA + contents;
		String filePath = checkSlush("JSP_PATH") + "/publish/" + tiles + "/views/temp/";

		return FileManageTools.create_File(filePath, "temp.jsp", contents, false);
	}

	/**
	 * 미니게시판 배포
	 */
	@Override
	public boolean miniBoard(BoardMainMini BoardMainMini) throws Exception {

		if (BoardMainMini == null) BoardMainMini = new BoardMainMini();

		List<HashMap<String, Object>> list = Component.getList("BoardMainMini.BMM_getData", BoardMainMini);

		for (HashMap<String, Object> mini : list) {
			String fileName = getFileName("miniBoard", (String) mini.get("BMM_KEYNO"), true);
			String filePath = checkSlush("JSP_PATH") + "/publish/Skin/miniBoard/";

			String data = SettingData.JSPDATA + mini.get("BMM_FORM");
			if (!FileManageTools.create_File(filePath, fileName, data, false)) {
				return false;
			}
		}

		return true;
	}

	/**
	 * 팝업존 카테고리 배포
	 */
	public boolean popupZone(PopupZoneCategoryDTO CategoryDTO) throws Exception {

		if (CategoryDTO == null) CategoryDTO = new PopupZoneCategoryDTO();

		// 데이터 가져오기
		List<HashMap<String, Object>> categoryList = Component.getList("PopupZone.TCGM_getData", CategoryDTO);

		for (HashMap<String, Object> cateogry : categoryList) {
			String fileName = getFileName("popupZone", (String) cateogry.get("TCGM_KEYNO"), true);
			String filePath = "/publish/Skin/popupZone/";
			String fullPath = checkSlush("JSP_PATH") + filePath;
			String data = SettingData.JSPDATA + cateogry.get("TCGM_FORM");

			// 파일 내용 저장
			if (!FileManageTools.create_File(fullPath, fileName, data, false)) {
				return false;
			}

		}

		return true;
	}

	/**
	 * 설문 스킨 배포
	 * T_SURVEY_SKIN 테이블이 없어도 예외만 로그하고 true 반환(나머지 배포는 계속 진행)
	 */
	@Override
	public boolean survey(boolean distributeType, String SS_KEYNO)
			throws Exception {
		HashMap<String, Object> data = new HashMap<>();
		
		if (!distributeType) {
			data.put("SS_KEYNO", SS_KEYNO);
		}

		String filePath = checkSlush("JSP_PATH") + "/publish/Skin";

		// T_SURVEY_SKIN 테이블이 없으면 쿼리하지 않음 (설문 미사용 시 예외/스택 방지)
		try {
			Object cnt = Component.getData("survey.surveySkinTableExists", null);
			if (cnt == null || (cnt instanceof Number && ((Number) cnt).intValue() == 0)) {
				return true;
			}
		} catch (Exception e) {
			return true;
		}

		try {
			List<SsDTO> SsList = Component.getList("survey.SS_getSkinData", data);

			for (SsDTO SsDTO : SsList) {
				String str = StringUtils.defaultIfEmpty(SsDTO.getSS_DATA(), "");
				String fileName = getFileName("survey", SsDTO.getSS_KEYNO(), true);
				String layoutFilePath = filePath + "/survey/";
				boolean isCompression = fileName.contains(".min");

				if (!FileManageTools.create_File(layoutFilePath, fileName, str, isCompression)) {
					return false;
				}
			}
		} catch (Exception e) {
			// 설문 테이블/데이터 오류 시 설문 스킨 배포만 스킵
			System.err.println("CommonPublishServiceImpl.survey 스킵 (설문 스킨 미사용 시 무시 가능): " + e.getMessage());
		}

		return true;
	}

	/**
	 * 폰트 자동 배포
	 */
	public boolean InsertFonts() throws Exception {
		String OS = System.getProperty("os.name").toLowerCase();
		if (OS.indexOf("nix") >= 0 || OS.indexOf("nux") >= 0 || OS.indexOf("aix") >= 0) {
			File folder_before = new File(checkSlush("RESOURCE_PATH") + "/fontDefault");
			File folder_after = new File("/usr/share/");
			File folder_ck = new File("/usr/share/fonts");
			if (!(folder_ck.exists() && folder_ck.isDirectory())) {
				copy(folder_before, folder_after);
			}
		}
		return true;
	}
	

	 /**
     * 페이지평가 스킨 배포
     */
    @Override
    public boolean researchSkin(ResearchSkinDTO ResearchSkinDTO) throws Exception{
        
        if(ResearchSkinDTO == null ) ResearchSkinDTO = new ResearchSkinDTO();
        
        List<HashMap<String,Object>> list = Component.getList("Satisfaction.PRS_getData", ResearchSkinDTO);
        
        for (HashMap<String,Object> search: list) {
            String fileName = getFileName("research", (String)search.get("PRS_KEYNO"),true);
            String filePath = checkSlush("JSP_PATH") + "/publish/Skin/research/";
            
            String data = SettingData.JSPDATA + search.get("PRS_FORM");
            if(!FileManageTools.create_File(filePath, fileName, data, false)){
                return false;
            }
        }
        
        return true;
    }


    /**
     * 팝업 스킨 배포
     */
    @Override
    public boolean popupSkin(PopupSkinDTO PopupSkinDTO) throws Exception{
        
        if(PopupSkinDTO == null ) PopupSkinDTO = new PopupSkinDTO();
        
        List<HashMap<String,Object>> list = Component.getList("Popup.PIS_getData", PopupSkinDTO);
        
        for (HashMap<String,Object> search: list) {
            String fileName = getFileName("popup", (String)search.get("PIS_KEYNO"),true);
            String filePath = checkSlush("JSP_PATH") + "/publish/Skin/popup/";
            
            String data = SettingData.JSPDATA + search.get("PIS_FORM");
            if(!FileManageTools.create_File(filePath, fileName, data, false)){
                return false;
            }
        }
        
        return true;
    }

	// 파일 복사
	public boolean copy(File a, File b) {
		File[] target_file = a.listFiles();
		for (File file : target_file) {
			File temp = new File(b.getAbsolutePath() + File.separator + file.getName());
			if (file.isDirectory()) {
				temp.mkdir();
				copy(file, temp);
			} else {			
				try (FileInputStream fis = new FileInputStream(file); //읽을파일
					 FileOutputStream fos = new FileOutputStream(temp); //복사할파일
					) {
					byte[] bb = new byte[4096];
					int cnt = 0;
					while((cnt = fis.read(bb)) != -1) {
						fos.write(bb, 0, cnt);
					}
				} catch (Exception e) {
					System.out.println("파일 copy 에러");
				} 
			}
		}
		return true;
	}

	@Override
	public String getFileName(String type, String key, boolean isAddExt) {

		String fileName = null;

		if(!"board".equals(type) && !key.contains("basic")) {	//게시판은 키값 그대로
			key = key.substring(key.indexOf("_"));
		}else{
			key = "_"+key;
		}

		switch (type) {
		case "page":
			fileName = "prp_views" + key;
			break;

		default:
			fileName = "prp_"+ type + key;
			break;
		}
		if (isAddExt) {
			fileName += ".jsp";
		}
		
		return fileName;
	}
	
	@Override
	public String getFilePathWithName(String type, String key, boolean isAddExt) {
		return getFilePathWithName(type,key,isAddExt,null);
	}
	
	@Override
	public String getFilePathWithName(String type, String key, boolean isAddExt, String boardType) {
		
		String fileName = getFileName(type,key,isAddExt);
		String filePath = null;
		
		switch (type) {
		case "board":
			if(isNumberCheck(key)){
				filePath= "/publish/Skin/"+type+"/"+boardType+"/";
			}else{
				filePath = "user/_common/_Skin/"+type+"/"+boardType+"/";	 
			}
			break;

		default:
			
			if(!key.contains("basic")) {
				filePath= "/publish/Skin/"+type+"/";
			}else{
				filePath= "user/_common/_Skin/"+type+"/";
			}
			
			break;
		}
		
		return filePath + fileName;
	}

	@Override
	public void setServletContext(ServletContext servletContext) {
		this.servletContext = servletContext;
	}

	@Override
	public void setApplicationContext(ApplicationContext applicationContext) {
		// 루트 WebApplicationContext에서는 ServletContextAware가 호출되지 않을 수 있음 → 여기서 ServletContext 보완
		if (this.servletContext == null && applicationContext instanceof WebApplicationContext) {
			this.servletContext = ((WebApplicationContext) applicationContext).getServletContext();
		}
	}

	private String checkSlush(String properties) {

		// 현재 웹앱 배포 경로 사용(DB가 dysystem 등 다른 프로젝트 경로일 때 test 프로젝트에 리소스 생성)
		if (servletContext != null) {
			String realPath = null;
			if ("RESOURCE_PATH".equals(properties)) {
				realPath = servletContext.getRealPath("/resources");
				if (realPath == null) realPath = servletContext.getRealPath("/") + "resources";
			} else if ("JSP_PATH".equals(properties)) {
				realPath = servletContext.getRealPath("/WEB-INF/jsp");
				if (realPath == null) realPath = servletContext.getRealPath("/") + "WEB-INF/jsp";
			}
			if (realPath != null && !realPath.isEmpty()) {
				if (!realPath.endsWith("/") && !realPath.endsWith(File.separator)) {
					realPath = realPath + "/";
				}
				return realPath;
			}
		}

		String path = getSiteManagerData(properties);
		if (path != null && !path.endsWith("/")) {
			path = path + "/";
		}
		return path;
	}

	private String getSiteManagerData(String key) {

		SiteManagerDTO siteManager = Component.getData("SiteManager.getData", SiteProperties.getCmsUser());

		Field field = ReflectionUtils.findField(siteManager.getClass(), key);
		field.setAccessible(true);
		String value = null;
		try {
			value = (String) field.get(siteManager);
		} catch (Exception e) {
			System.err.println("CommonPublishServiceImpl.getSiteManagerData 에러 :: " + e.getMessage());
		}

		return value;

	}

	/** 메뉴 헤더 템플렛 배포 */
	@Override
	public boolean menuTemplate(MenuHeaderTemplate MenuHeaderTemplate) throws Exception {

		if (MenuHeaderTemplate == null)
			MenuHeaderTemplate = new MenuHeaderTemplate();

		List<HashMap<String, Object>> list = Component.getList("Menu.SMT_getData", MenuHeaderTemplate);

		for (HashMap<String, Object> template : list) {
			String fileName = getFileName("menuTemplate", (String) template.get("SMT_KEYNO"), true);
			String filePath = checkSlush("JSP_PATH") + "/publish/Skin/menuTemplate/";

			String data = SettingData.JSPDATA + template.get("SMT_FORM");
			if (!FileManageTools.create_File(filePath, fileName, data, false)) {
				return false;
			}

		}
		return true;
	}
	
	 /**
     * 인덱스 배포
     */
    @Override
    public boolean index(String key, String resourceType, String scope, boolean distributeType) throws Exception{
    	
    	String filePath = checkSlush("JSP_PATH");
    	
    	if(StringUtils.isNotEmpty(filePath)){
    		filePath = CommonService.pathSubString(checkSlush("JSP_PATH"), 12);
    	}

		HashMap<String, Object> data = new HashMap<>();
		data.put("RM_TYPE", "index");
		if (distributeType) {
			scope="";
		}
		if(StringUtils.isNotEmpty(scope))
		data.put("RM_SCOPE", scope);

		if (StringUtils.isNotEmpty(key))
		data.put("RM_KEYNO", key);

		List<HashMap<String, Object>> resourcesList = Component.getList("Resources.RM_getDataByDistribute", data);

		for (HashMap<String, Object> hashMap : resourcesList) {

			String str = StringUtils.defaultIfEmpty((String) hashMap.get("RM_DATA"), "");
			String fileName = (String) hashMap.get("RM_FILE_NAME");
			if("index".equals(hashMap.get("RM_SCOPE"))){
				fileName += ".jsp";
			}else if("robots".equals(hashMap.get("RM_SCOPE"))){
				fileName += ".txt";
			}
			boolean isCompression = fileName.contains(".min");
			if (!FileManageTools.create_File(filePath, fileName, str, isCompression)) {
				return false;
			}
		}
        
        return true;
    }
    
    /**
     * 사이트맵 배포
     */
    @Override
    public boolean sitemap(String filename, String data) throws Exception{
    	
    	String filePath = checkSlush("JSP_PATH");
    	
    	if(StringUtils.isNotEmpty(filePath)){
    		filePath = CommonService.pathSubString(checkSlush("JSP_PATH"), 12);
    	}

    	return FileManageTools.create_File(filePath, filename + ".xml", data, false);
    	
    }
    
    /** 게시판 스킨 배포 */
	@Override
	public boolean BoardTemplate(BoardSkin boardSkin) throws Exception {
		
		List<BoardSkin> BoarList = Component.getList("BoardSkin.BST_getData",boardSkin);
		
		if(BoarList != null) {
			for(BoardSkin b : BoarList) {
				String fileName = "prp_board_"+ b.getBST_KEYNO()+".jsp";
				String filePath = checkSlush("JSP_PATH") + "/publish/Skin/board/"+b.getBST_TYPE()+"/";				
				String data = SettingData.JSPDATA + b.getBST_FORM();
				if (!FileManageTools.create_File(filePath, fileName, data, false)) {
					return false;
				}
			}
		}
		return true;
	}
    
	/** 게시판 스킨 패키지 배포 */
	@Override
	public boolean BoardTemplatePackage(BoardSkin boardskin) throws Exception {
		if(boardskin != null) {
			String filePath = checkSlush("JSP_PATH") + "/publish/Skin/board/";
			
			if(boardskin.getBSP_LIST_FORM() != null) {
				String fileNameList = "prp_board_"+ boardskin.getBSP_LIST_KEYNO()+".jsp";
				String dataList = SettingData.JSPDATA + boardskin.getBSP_LIST_FORM();
				if (!FileManageTools.create_File(filePath+"list/", fileNameList, dataList, false)) {
					return false;
				}
			}
			
			if(boardskin.getBSP_DETAIL_FORM() != null) {
				String fileNameDetail = "prp_board_"+ boardskin.getBSP_DETAIL_KEYNO()+".jsp";
				String dataDetail = SettingData.JSPDATA + boardskin.getBSP_DETAIL_FORM();
				if (!FileManageTools.create_File(filePath+"detail/", fileNameDetail, dataDetail, false)) {
					return false;
				}
			}
			
			if(boardskin.getBSP_INSERT_FORM() != null) {
				String fileNameInsert = "prp_board_"+ boardskin.getBSP_INSERT_KEYNO()+".jsp";
				String dataInsert = SettingData.JSPDATA + boardskin.getBSP_INSERT_FORM();
				if (!FileManageTools.create_File(filePath+"insert/", fileNameInsert, dataInsert, false)) {
					return false;
				}
			}
		}
		return true;
	}
	
	
	private boolean isNumberCheck(String key){
 	   
        char tmp;
		boolean output = true;	
		String input = key;
		
		for(int i = 0 ; i < input.length() ; i++) {	//입력받은 문자열인 input의 길이만큼 반복문 진행(배열이 아닌 문자열의 길이기 때문에 length가 아닌 length()를 사용해야한다.)
			tmp = input.charAt(i);	//한글자씩 검사하기 위해서 char형 변수인 tmp에 임시저장
			if(Character.isDigit(tmp) == false) {	//문자열이 숫자가 아닐 경우
				output = false;	//output의 값을 false로 바꿈
				break;
			}
		}
		
		return output;
    }
	

}
