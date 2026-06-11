package com.tx.common.security.service.impl;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.access.SecurityConfig;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.security.web.util.matcher.RequestMatcher;

import com.tx.common.security.service.SecuredObjectService;
import com.tx.common.service.component.ComponentService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
 
public class SecuredObjectServiceImpl extends EgovAbstractServiceImpl implements SecuredObjectService {
 
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	
     
    @Override
    public LinkedHashMap<RequestMatcher, List<ConfigAttribute>> getRolesAndUrl() throws Exception {
    	
        LinkedHashMap<RequestMatcher, List<ConfigAttribute>> ret = new LinkedHashMap<RequestMatcher, List<ConfigAttribute>>();
        LinkedHashMap<Object, List<ConfigAttribute>> data = getRolesAndResources("URL");
        Set<Object> keys = data.keySet();
        for(Object key : keys){
            ret.put((AntPathRequestMatcher)key, data.get(key));
        }
        return ret;
    }
 
    /**
     * 사용안함
     */
    @Override
    public LinkedHashMap<String, List<ConfigAttribute>> getRolesAndMethod()
            throws Exception {
        /*LinkedHashMap<String, List<ConfigAttribute>> ret = new LinkedHashMap<String, List<ConfigAttribute>>();
        LinkedHashMap<Object, List<ConfigAttribute>> data = getRolesAndResources("METHOD");
        Set<Object> keys = data.keySet();
        for(Object key : keys){
            ret.put((String)key, data.get(key));
        }
        return ret;*/
    	return null;
    }
    
    /**
     * 사용안함
     */
    @Override
    public LinkedHashMap<String, List<ConfigAttribute>> getRolesAndPointcut()
            throws Exception {
       /* LinkedHashMap<String, List<ConfigAttribute>> ret = new LinkedHashMap<String, List<ConfigAttribute>>();
        LinkedHashMap<Object, List<ConfigAttribute>> data = getRolesAndResources("POINTCUT");
        Set<Object> keys = data.keySet();
        for(Object key : keys){
            ret.put((String)key, data.get(key));
        }
        return ret;*/
    	return null;
    }
    
    /**
     * 사용안함
     */
    @Override
    public List<ConfigAttribute> getMatchedRequestMapping(String url) throws Exception {
//        return securedObjectDao.getRegexMatchedRequestMapping(url);
    	return null;
    }
 
    /**
     * 사용안함
     */
    @Override
    public String getHierarchicalRoles() throws Exception {
    	//return securedObjectDao.getHierarchicalRoles();
    	return null;
    }
    
    private LinkedHashMap<Object, List<ConfigAttribute>> getRolesAndResources(String resourceType) throws Exception {
    	 
        LinkedHashMap<Object, List<ConfigAttribute>> resourcesMap = new LinkedHashMap<Object, List<ConfigAttribute>>();
 
        boolean isResourcesUrl = true;
        
        List<Map<String, Object>> resultList = null;
        
        if ("METHOD".equals(resourceType)) {
            isResourcesUrl = false;
            resultList = new ArrayList<>();
        } else if ("POINTCUT".equals(resourceType)) {
            isResourcesUrl = false;
            resultList = new ArrayList<>();
        } else {
        	resultList = Component.getListNoParam("Security.getSqlRolesAndUrl");
        }
 
        Iterator<Map<String, Object>> itr = resultList.iterator();
        Map<String, Object> tempMap;
        String preResource = null;
        String presentResourceStr;
        Object presentResource;
        while (itr.hasNext()) {
            tempMap = itr.next();
 
            presentResourceStr = (String) tempMap.get(resourceType);
            // url 인 경우 RequestKey 형식의 key를 Map에 담아야 함
            presentResource = isResourcesUrl ? new AntPathRequestMatcher(presentResourceStr) : presentResourceStr;
            List<ConfigAttribute> configList = new LinkedList<ConfigAttribute>();
 
            // 이미 requestMap 에 해당 Resource 에 대한 Role 이 하나 이상 맵핑되어 있었던 경우,
            // sort_order 는 resource(Resource) 에 대해 매겨지므로 같은 Resource 에 대한 Role 맵핑은 연속으로 조회됨.
            // 해당 맵핑 Role List (SecurityConfig) 의 데이터를 재활용하여 새롭게 데이터 구축
            if (preResource != null && presentResourceStr.equals(preResource)) {
                List<ConfigAttribute> preAuthList = resourcesMap.get(presentResource);
                Iterator<ConfigAttribute> preAuthItr = preAuthList.iterator();
                while (preAuthItr.hasNext()) {
                    SecurityConfig tempConfig = (SecurityConfig) preAuthItr.next();
                    configList.add(tempConfig);
                }
            }
 
            configList.add(new SecurityConfig((String) tempMap.get("AUTHORITY")));
            // 만약 동일한 Resource 에 대해 한개 이상의 Role 맵핑 추가인 경우
            // 이전 resourceKey 에 현재 새로 계산된 Role 맵핑 리스트로 덮어쓰게 됨.
            resourcesMap.put(presentResource, configList);
 
            // 이전 resource 비교위해 저장
            preResource = presentResourceStr;
        }
                 
        return resourcesMap;
    }
 
}
