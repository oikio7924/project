package com.tx.dyAdmin.admin.code.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.annotation.PostConstruct;

import org.apache.http.client.utils.CloneUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.admin.code.service.CodeService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("CodeService")
public class CodeServiceImpl extends EgovAbstractServiceImpl implements CodeService{
	
	@Autowired ComponentService Component;
	private HashMap<String, ArrayList<HashMap<String, Object>>> CodeListMap = null;
	
	@PostConstruct
	public void init(){
		setCodeList();
	}
	

	
	@Override
	public void setCodeList(){
		List<HashMap<String, Object>> SubCodeList = Component.getListNoParam("Code.ASC_GetListAll2");
		
		HashMap<String, ArrayList<HashMap<String, Object>>> SubCodeListMap = new HashMap<String, ArrayList<HashMap<String, Object>>>();
	
		if(SubCodeList != null && SubCodeList.size() > 0){
			for(HashMap<String, Object> MainCode : SubCodeList){
				
				String key = (String)MainCode.get("SC_MC_IN_C");
				ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
				
				if (SubCodeListMap.containsKey(key)) {
                    // 이미 해당 key가 맵에 있을 때에는 value를 불러온 뒤 넣음
                    list = SubCodeListMap.get(key);
                    list.add(MainCode);
                } else {
                    // 맵에 key가 없다면 새로 value를 추가
                    list.add(MainCode);
                }
				SubCodeListMap.put(key, list);
			}
		}
		CodeListMap = SubCodeListMap;
	}
	
	/**
	 * 입력받은 메인키의 서브코드만 업데이트 되도록 수정 
	 */
	@Override 
	public void setCodeOne(String MC_IN_C){
		List<HashMap<String, Object>> SubCodeList = Component.getList("Code.ASC_GetListAll",MC_IN_C);
		CodeListMap.put(MC_IN_C, (ArrayList<HashMap<String, Object>>) SubCodeList);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<HashMap<String, Object>> getCodeListisUse(String MC_IN_C, boolean isUse){
		if (MC_IN_C.equals("")||MC_IN_C.isEmpty())return null;
		List<HashMap<String, Object>> subListDeepCopy = null;
		try {
			subListDeepCopy = (List<HashMap<String, Object>>)CloneUtils.clone(CodeListMap.get(MC_IN_C));
			if(subListDeepCopy != null && isUse){
				for(Iterator<HashMap<String, Object>> it = subListDeepCopy.iterator() ; it.hasNext() ; ) {
					HashMap<String, Object> sub = it.next();
					if("N".equals(sub.get("SC_USE_YN"))){
						it.remove();
					}
				}
			}
			
		} catch (CloneNotSupportedException e) {
			System.out.println("서브코드 리스트 deep복사 에러");
		}

		return subListDeepCopy;
	}
	
	
	/**
	 * MC_KEYNO로 코드 리스트 가져올 때 사용
	 */
	@Override
	public List<HashMap<String, Object>> getCodeListisUseBySelectlist(List<String> list){
		List<HashMap<String, Object>>  CodeListisUseBySelectlist = new ArrayList<HashMap<String, Object>>();
		
		for ( String MC_IN_C : list) CodeListisUseBySelectlist.addAll(CodeListMap.get(MC_IN_C));
		
		return CodeListisUseBySelectlist;
	}
	
	@Override
	public List<HashMap<String, Object>> getCodeListAll(String MC_IN_C){
		return getCodeListisUse(MC_IN_C,false);
	}
	

}
