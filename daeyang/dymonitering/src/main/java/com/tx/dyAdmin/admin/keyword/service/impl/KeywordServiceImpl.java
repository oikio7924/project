package com.tx.dyAdmin.admin.keyword.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.admin.keyword.dto.KeywordDTO;
import com.tx.dyAdmin.admin.keyword.service.KeywordService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("KeywordService")
public class KeywordServiceImpl extends EgovAbstractServiceImpl implements KeywordService {
	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	private int KeywordSize = 500; // 노출되는 키워드 갯수(검색횟수순)
	private int minCount	=	50; // 노출될 키워드의 최소 검색횟수
	
	private KeywordDTO KeywordDTO = null;
	
	/**
	 * 키워드 등록
	 * @param keyword
	 * @param req
	 */
	@Override
	public void checkKeyword(String keyword,HttpServletRequest req){
		
		KeywordDTO  = new KeywordDTO();	
		
		KeywordDTO.setSK_KEYWORD(keyword);
		
		String ip = CommonService.getClientIP(req);
		KeywordDTO.setSK_IP(ip);
		
		Map<String, Object> map = CommonService.getUserInfo(req);
		if(map != null){
			KeywordDTO.setSK_USERID((String)map.get("UI_KEYNO"));
		}else{
			KeywordDTO.setSK_USERID("비회원");
		}
		
		Component.createData("keyword.SK_insert", KeywordDTO);
		
	}
	
	/**
	 * 키워드 조작
	 * @param keyword
	 * @param req
	 * @param size
	 */
	@Override
	public void updateKeyword(String keyword,HttpServletRequest req,int size){
		
		String ip = CommonService.getClientIP(req);
		List<KeywordDTO> list = new ArrayList<KeywordDTO>();
		KeywordDTO = null;
		long time = System.currentTimeMillis ( ); 
		for(int i =0;i<size;i++){
			KeywordDTO = new KeywordDTO();
			KeywordDTO.setSK_KEYWORD(keyword);
			KeywordDTO.setSK_IP(ip);
			
			KeywordDTO.setSK_USERID("관리자"+time+i);
			list.add(KeywordDTO);
		}
		Map<String, Object> map = new HashMap<String,Object>();
		
		map.put("list", list);
		
		
		Component.createData("keyword.SK_updateKeyword", map);
		
	}
	
	/**
	 * 키워드 목록 가져오기 갯수 파라미터로 받음
	 * @param size
	 * @return
	 */
	@Override
	public List<KeywordDTO> getKeywordList(){
		KeywordDTO = new KeywordDTO();
		KeywordDTO.setKeywordSize(KeywordSize);
		KeywordDTO.setMinCount(minCount);
		
		return Component.getList("keyword.SK_getList",KeywordDTO);
	}
	/**
	 * 키워드 목록 가져오기 갯수 파라미터로 받음
	 * @param size
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public List getKeywordList(int KeywordSize,int minCount){
		if(KeywordSize == 0){
			KeywordSize = this.KeywordSize;
		}
		if(minCount == 0){
			minCount = this.minCount;
		}
		KeywordDTO = new KeywordDTO();
		KeywordDTO.setKeywordSize(KeywordSize);
		KeywordDTO.setMinCount(minCount);
		
		return Component.getList("keyword.SK_getList",KeywordDTO);
	}
	
	/**
	 * 특정 키워드에 대한 상세 목록
	 * @param KeywordDTO
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public List getDetailList(KeywordDTO KeywordDTO){
		
		return Component.getList("keyword.SK_getDetailList",KeywordDTO);
	}
	
	/**
	 * 삭제
	 * @param KeywordDTO
	 */
	@Override
	public void deleteData(KeywordDTO KeywordDTO){
		Component.deleteData("keyword.SK_deleteData",KeywordDTO);
	}
	
	/**
	 * 삭제 - 키워드
	 * @param KeywordDTO
	 */
	@Override
	public void deleteDataWithKeyword(KeywordDTO KeywordDTO){
		Component.deleteData("keyword.SK_deleteDataWithKeyword",KeywordDTO);
	}
	
	
	
}
