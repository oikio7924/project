package com.tx.common.service.skin.service.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.StringTokenizer;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tx.common.config.SettingData;
import com.tx.common.config.tld.SiteProperties;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.skin.dto.CommonSampleSkin;
import com.tx.common.service.skin.service.CommonSkinService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("CommonSkinService")
public class CommonSkinServiceImpl extends EgovAbstractServiceImpl implements CommonSkinService {

	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	List<CommonSampleSkin> sampleList = null;
	List<CommonSampleSkin> sampleBoardList = null;
	
	@PostConstruct
	public void init(){
		initSampleList();
		initBoardSampleList();
	}
	
	@Override
	public String getSkin(String type, String value) throws Exception {
		
		CommonSampleSkin bss = checkSample(type,value,sampleList);
		//DB에서 불러옴
		if(bss == null) return getCommonSkinQueryData(type,value);
		
		return getSkinToFile(bss.getPath());
	}
	
	@Override
	public String getBoardSkin(String type, String value) throws Exception {
		
		CommonSampleSkin bss = checkSample(type,value,sampleBoardList);
		//DB에서 불러옴
		if(bss == null) return getSkin(value);
		
		return getSkinToFile(bss.getPath());
	}

	private String getSkinToFile(String path) {
		// TODO Auto-generated method stub
		
		 String jspPath = SiteProperties.getString("JSP_PATH");
		 
		 File file = new File(jspPath + path);
		 
		 StringBuilder skin = new StringBuilder();
		 
		 try(FileReader reader = new FileReader(file)) {
			 int cur = 0;
	         while((cur = reader.read()) != -1){
	        	 skin.append((char)cur);
	         }
	         //맨위 두줄 지움
//	         if(skin.toString().contains(SettingData.JSPDATA)) //게시판에서 false떠서 일단 주석처리... 
	         skin.delete(0, SettingData.JSPDATA.length());
	         
		} catch (FileNotFoundException e) {
			System.out.println("BoardSkinServiceImpl.getSkinToFile 파일 없음 ");
		} catch (IOException e) {
			System.out.println("BoardSkinServiceImpl.getSkinToFile 파일 읽는중 에러 ");
		}
			 
		return skin.toString();
	}

	private CommonSampleSkin checkSample(String type, String value, List<CommonSampleSkin> skinList) {
		// TODO Auto-generated method stub
		
		for(CommonSampleSkin bss : skinList){
			if(bss.compare(type, value)) return bss;
		}
		return null;
	}
	
	/**
	 * DB에서 불러옴 (게시판)
	 * @param key
	 * @return
	 */
	private String getSkin(String key) {

		return Component.getData("BoardSkin.boardSkinForm",key);
	}

	
	/**
	 * 게시판 샘플 파일 저장
	 */
	private void initBoardSampleList() {
		// TODO Auto-generated method stub
		sampleBoardList = new ArrayList<>();
		//list :: list, no_detail, calender, gallery
		//insert :: normal
		//detail :: normal, no
		HashMap<String, List<String>> boardTypeMap = new HashMap<String, List<String>>();
		String listType[] = {"list","no_detail","calendar","gallery"};
		String detailType[] = {"normal"};
		String insertType[] = {"normal","no"};
		boardTypeMap.put("list", Arrays.asList(listType));
		boardTypeMap.put("detail", Arrays.asList(detailType));
		boardTypeMap.put("insert", Arrays.asList(insertType));
		
		for (String key : boardTypeMap.keySet()) {
			
			for (int i = 0; i < boardTypeMap.get(key).size(); i++) {
				
				sampleBoardList.add(CommonSampleSkin.builder()
								.type(key)
								.value(boardTypeMap.get(key).get(i))
								.path("user/_common/_Skin/board/"+key+"/prp_board_"+boardTypeMap.get(key).get(i)+".jsp")
								.build());
				
			}

		}
				
	}
	
	/**
	 * 스킨 샘플 파일 저장
	 */
	private void initSampleList() {
		// TODO Auto-generated method stub
		sampleList = new ArrayList<>();
		
		String skinType[] = {"menuTemplate","miniBoard","popupZone","research","survey","popup"};
			
		for (int i = 0; i < skinType.length; i++) {
			
			if("popup".equals(skinType[i])){
				setCommonSkinData(skinType[i],"banner_basic");
				setCommonSkinData(skinType[i],"layout_basic");
			}else{
				setCommonSkinData(skinType[i],"basic");
			}
		}
				
	}

	private void setCommonSkinData(String type, String key){
		sampleList.add(CommonSampleSkin.builder()
				.type(type)
				.value(key)
				.path(getCommonSkinPath(type,key))
				.build());
	}
	
	/**
	 * 쿼리 데이터 가져오기
	 */
	private String getCommonSkinQueryData(String type, String key) {
		
		String query = null;
		String value = null;
		
		switch (type) {
		case "miniBoard":
			query = "BoardMainMini.getSkinForm";
			value = CommonService.getKeyno(key, "BMM");
			break;
			
		case "popupZone":
			query = "PopupZone.getSkinForm";
			value = CommonService.getKeyno(key, "TCGM");
			break;
			
		case "menuTemplate":
			query = "Menu.getSkinForm";
			value = CommonService.getKeyno(key, "SMT");
			break;
			
		case "survey": 
			query = "survey.getSkinForm";
			value = CommonService.getKeyno(key, "SS");
			break;
			
		case "research":
			query= "Satisfaction.getSkinForm";
			value = CommonService.getKeyno(key, "PRS");
			break;
			
		case "popup":
			query= "Popup.getSkinForm";
			value = CommonService.getKeyno(key, "PIS");
			break;
			
		default:
			break;
		}
		
		return Component.getData(query,value);
		
	}
	
	
	/**
	 * 샘플 파일 경로
	 */
	private String getCommonSkinPath(String type, String key) {
		
		String filePath = null;
		
		String path = "/publish/Skin";
		
        String defaultSkin = "basic,banner_basic,layout_basic";
        StringTokenizer st = new StringTokenizer(defaultSkin, ",");
        
        while(st.hasMoreTokens()) {
            if(st.nextToken().equals(key)){
    			path = "user/_common/_Skin";
            }
        }
	
		filePath = path + "/" + type+"/prp_" + type + "_" + key + ".jsp";
		
		return filePath;
	}

}
