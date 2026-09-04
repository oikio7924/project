package com.tx.common.service.publish.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.codehaus.plexus.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.SettingData;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.dto.Common;
import com.tx.common.file.FileManageTools;
import com.tx.common.security.aes.AES256Cipher;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.publish.CommonPublishService;
import com.tx.common.storage.service.StorageSelectorService;
import com.tx.dyAdmin.admin.board.dto.BoardColumn;
import com.tx.dyAdmin.admin.board.dto.BoardMainMini;
import com.tx.dyAdmin.homepage.popupzone.dto.PopupZoneCategoryDTO;

/**
 * 
 * @FileName: CommonPublishController.java
 * @Date    : 2019. 06. 10. 
 * @Author  : chul	
 * @Version : 1.0
 */
@Controller
public class CommonPublishController {

	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	@Autowired FileManageTools FileManageTools;
	
	@Autowired CommonPublishService CommonPublishService;
	
	@Autowired private StorageSelectorService StorageSelector;
	
	/**
	 * 미니게시판
	 * */
    @RequestMapping(value = "/common/Board/MainMiniBoard/UserViewAjax.do")
    public ModelAndView exam1(HttpServletRequest req, Common search, Map<String, Object> commandMap) throws Exception {
        ModelAndView mv  = new ModelAndView();
        
        try{
        	String key = (String) req.getParameter("key");
            
            BoardMainMini BoardMainMini = new BoardMainMini();
            BoardMainMini.setBMM_KEYNO(CommonService.getKeyno(key, "BMM"));
            
            //미니게시판 정보 가져오기
            HashMap<String,Object> dto = Component.getData("BoardMainMini.BMM_getData", BoardMainMini);
            
            //JSP 경로 설정
            String filePath = CommonPublishService.getFilePathWithName("miniBoard",(String)dto.get("BMM_KEYNO"),true);
            String jspPage = returnJspPage(filePath, "miniBoard", (String)dto.get("BMM_KEYNO"));
            
            HashMap<String, Object> map = new HashMap<>();
            String MN_KEYNO = (String)dto.get("BMM_MN_KEYNO");
            map.put("MN_KEYNO", MN_KEYNO);

            map.put("BOARD_COLUMN_TYPE_CHECK", SettingData.BOARD_COLUMN_TYPE_CHECK);
            map.put("BOARD_COLUMN_TYPE_CHECK_CODE", SettingData.BOARD_COLUMN_TYPE_CHECK_CODE);
            map.put("BOARD_COLUMN_TYPE_RADIO_CODE", SettingData.BOARD_COLUMN_TYPE_RADIO_CODE);
            map.put("BOARD_COLUMN_TYPE_SELECT_CODE", SettingData.BOARD_COLUMN_TYPE_SELECT_CODE);

            List<BoardColumn> BoardColumnList = Component.getList("BoardColumn.BL_getviewList", MN_KEYNO);
            map.put("BoardColumnList", BoardColumnList);
            map.put("SIZE", dto.get("BMM_SIZE"));
            map.put("BMM_SORT_COLUMN", dto.get("BMM_SORT_COLUMN"));
            map.put("BMM_SORT_DIRECTION", dto.get("BMM_SORT_DIRECTION"));

            List<HashMap<String, Object>> resultList = Component.getList("BoardMainMini.User_Board_List", map);
            StorageSelector.getImgPath(resultList);
            
            mv.addObject("resultList", resultList);
            mv.addObject("tiles", dto.get("BMM_MN_HOMEDIV_TILES"));
            mv.addObject("tilesUrl", dto.get("BMM_MN_HOMEDIV_URL"));
            mv.setViewName(jspPage); 
        } catch (Exception e) {
        	mv.setViewName("error/error");
		}
           
        
        return mv;
    }

	/**
	 * 팝업존
	 * */
    @RequestMapping(value = "/common/operation/popupzone/UserViewAjax.do")
	public ModelAndView userView(HttpServletRequest req, Common search, Map<String, Object> commandMap) throws Exception {
		ModelAndView mv  = new ModelAndView();
		try{
			String key = (String) req.getParameter("key");
			PopupZoneCategoryDTO CategoryDTO = new PopupZoneCategoryDTO();
			CategoryDTO.setTCGM_KEYNO(CommonService.getKeyno(key, "TCGM"));
			
			//카테고리 정보 가져오기
			HashMap<String,Object> dto = Component.getData("PopupZone.TCGM_getData", CategoryDTO);
			
			 //JSP 경로 설정
            String filePath = CommonPublishService.getFilePathWithName("popupZone",(String)dto.get("TCGM_KEYNO"),false);
            String jspPage = filePath;
			
			HashMap<String, Object> map = new HashMap<>();
			map.put("TCGM_KEYNO", (String) dto.get("TCGM_KEYNO"));

			List<HashMap<String, Object>> resultList = Component.getList("PopupZone.TCGM_getListByTCGM_Keyno", map);
			StorageSelector.getImgPath(resultList);
			for(HashMap<String,Object> res : resultList) {
				if(StringUtils.isNotEmpty((String)res.get("FS_CHANGENM"))) {
					String Path = res.get("FS_FOLDER").toString()+"/"+ res.get("FS_CHANGENM").toString()+"."+res.get("FS_EXT").toString();
					Path = AES256Cipher.encode(Path);
					res.put("Path", Path);
				}
			}
			mv.addObject("resultList", resultList);
			
			 mv.setViewName(jspPage); 
		}catch (Exception e) {
			mv.setViewName("error/error");
		}
		
		
		return mv;
	}
	
    /**
     * 메뉴스킨
     * @param req
     * @param search
     * @param commandMap
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/common/Menu/MenuHeaderTemplate/UserViewAjax.do")
    public ModelAndView MenuHeaderCopy(HttpServletRequest req
    			,@RequestParam(value="key") String key
    		) throws Exception {
        ModelAndView mv  = new ModelAndView();
        try{
            String smtKey = CommonService.getKeyno(key, "SMT");
            //JSP 경로 설정
            String filePath = CommonPublishService.getFilePathWithName("menuTemplate",smtKey,true);
            String jspPage = returnJspPage(filePath, "menuTemplate", smtKey);
    	
            mv.setViewName(jspPage); 
            
        } catch (Exception e) {
        	mv.setViewName("error/error");
		}
                   
        return mv;
    }
    
    /**
     * 게시판 스킨
     * @param req
     * @param type
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/common/board/UserViewAjax.do")
    public ModelAndView UserViewAjax(HttpServletRequest req
    		,@RequestParam(value="type",required=false)String type
    ) throws Exception {
        ModelAndView mv  = new ModelAndView();

        String key = (String) req.getParameter("key");
            
        String filePath = CommonPublishService.getFilePathWithName("board",key,true,type);
        String jspPage = returnJspPage(filePath, "board", key, type);
        
        mv.setViewName(jspPage); 
  
        return mv;
    }
    
    /**
     * 페이지평가 스킨
     * @param req
     * @param type
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/common/research/UserViewAjax.do")
    public ModelAndView researchUserViewAjax(HttpServletRequest req
    ) throws Exception {
        ModelAndView mv  = new ModelAndView();

      	String key = (String) req.getParameter("key");

       String filePath = CommonPublishService.getFilePathWithName("research",key,true);
       String jspPage = returnJspPage(filePath, "research", key);
     	
        mv.setViewName(jspPage); 
      
        return mv;
    }
    
    /**
     * 팝업 스킨
     * @param req
     * @param type
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/common/popup/UserViewAjax.do")
    public ModelAndView popupUserViewAjax(HttpServletRequest req
    ) throws Exception {
        ModelAndView mv  = new ModelAndView();

      	String key = (String) req.getParameter("key");

      	String filePath = CommonPublishService.getFilePathWithName("popup",key,true);
        String jspPage = returnJspPage(filePath, "popup", key);
        
        mv.setViewName(jspPage); 
                 
        return mv;
    }
    
    /**
     * 설문 스킨
     * @param req
     * @param type
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/common/survey/UserViewAjax.do")
    public ModelAndView surveyUserViewAjax(HttpServletRequest req
    ) throws Exception {
        ModelAndView mv  = new ModelAndView();

      	String key = (String) req.getParameter("key");
      	 
      	String filePath = CommonPublishService.getFilePathWithName("survey",key,true);
        String jspPage = returnJspPage(filePath, "survey", key);
                           	
        mv.setViewName(jspPage); 
                 
        return mv;
    }
    
    private String returnJspPage(String filePath, String type, String key, String boardType) {
    	 String jspPage = "";
         try {
             if (FileManageTools.fileExistsCheck(SiteProperties.getString("JSP_PATH") + filePath)) {
                 jspPage = CommonPublishService.getFilePathWithName(type, key, false, boardType) ;
             } else {
                 jspPage = "/error/error";
             }
         } catch (Exception e) {
             jspPage = "/error/error";
         }
         
         return jspPage;
    }

    private String returnJspPage(String filePath, String type, String key) {
    	return returnJspPage(filePath, type, key, null);
    }
}
