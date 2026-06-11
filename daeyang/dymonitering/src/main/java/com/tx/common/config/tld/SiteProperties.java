package com.tx.common.config.tld;

import java.io.IOException;
import java.io.Reader;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.io.Resources;
import org.springframework.util.ReflectionUtils;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.tx.common.config.SettingData;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.admin.code.service.CodeService;
import com.tx.dyAdmin.admin.site.dto.SiteManagerDTO;

public class SiteProperties {
	
	private static ComponentService Component;
	
	private static ComponentService Component2;
	
	private static SiteManagerDTO siteManager;
	
	private static SiteManagerDTO SALT;
	
	private static CodeService CodeService;
	
	private static SettingData settingData = new SettingData();
	
	public static String getSalt() {
		try {
			
			if(SALT == null) {
				if(Component2 == null){
					Component2 = (ComponentService)getBean("ComponentService");
				}
				SALT = Component2.getData("SiteManager.getData","salt");
			}
			
			
		} catch (Exception e) {
			System.err.println("SiteProperties.getSalt 에러");
			return null;
		}	
		return SALT.getSALT();
	}
	
	public static String getString(String key) {
		
		return get(key);
	}
	public static Double getDouble(String key) {
		Double value = null;
		try{
			 value = Double.valueOf(get(key));
		}catch (Exception e) {
			System.err.println("SiteProperties.getDouble 에러 :: " + e.getMessage());
		}
		return  value;
	}
	public static Integer getInt(String key) {
		Integer value = null;
		try{
			 value = Integer.valueOf(get(key));
		}catch (Exception e) {
			System.err.println("SiteProperties.getInt 에러 :: " + e.getMessage());
		}
		return  value;
	}
	public static Boolean getBoolean(String key) {
		return  Boolean.valueOf(get(key));
	}
	public static List<Object> getList(String key) {
		
		String value = get(key);
		
		if(value == null){
			return null;
		}else{
			return  new ArrayList<>(Arrays.asList(value.split(",")));
		}
	}
	
	public static Float getFloat(String key) {
		Float value = null;
		try{
			 value = Float.valueOf(get(key));
		}catch (Exception e) {
			System.err.println("SiteProperties.getFloat 에러 :: " + e.getMessage());
		}
		return  value;
	}
	
	/**
	 * settingData 가져오기
	 * @param key
	 * @return
	 */
	public static String getData(String key) {
		
		String value = null;
		try{
			Field field = ReflectionUtils.findField(settingData.getClass(), key);
			field.setAccessible(true);
			value = field.get(settingData) + "";
		}catch (Exception e) {
		}
		return value;
	}
	
	public static List<HashMap<String, Object>> getCodeList(String mainCode){
		
		if(CodeService == null){
			try {
				CodeService = (CodeService)getBean("CodeService");
			} catch (Exception e) {
				// TODO Auto-generated catch block
			}
		}
		
		return CodeService.getCodeListisUse(mainCode,true);
	}
	
	public static boolean refresh() {
		try {
			if(Component == null){
				Component = (ComponentService)getBean("ComponentService");
			}
			
			
			siteManager = Component.getData("SiteManager.getData",getCmsUser());
				
		} catch (Exception e) {
			System.err.println("SiteProperties.refresh 에러  :: " + e.getMessage());
			return false;
		}

		
		return true;
	}
	
	public static String getCmsUser() {
		
		return getConfigProperties("cms.user");
	}
	
	public static boolean getAutoPublish() {
		
		return Boolean.valueOf(getConfigProperties("cms.autoPublish"));
	}
	
	public static String getConfigProperties(String key){
		String resource = "config.properties";
        Properties properties = new Properties();
        
        String value = "";
        try {
            Reader reader = Resources.getResourceAsReader(resource);
            properties.load(reader);
            value = properties.getProperty(key);
        } catch (IOException e) {           
        	System.err.println("SiteProperties.getConfigProperties 에러 :: " + e.getMessage());
        }
		
		return value;
	}
	
	private static String get(String key) {
		
		if(Component == null && !refresh()) return null;
		
		Field field = ReflectionUtils.findField(siteManager.getClass(), key);
		field.setAccessible(true);
		String value = null;
		try {
			value = (String) field.get(siteManager);
		} catch (Exception e) {
			System.err.println("SiteManager.get 에러 :: " + e.getMessage());
		} 
		
		return value;
		
	}
	
	private static Object getBean(String beanName) throws Exception {
		
		//현재 요청중인 thread local의 HttpServletRequest 객체 가져오기
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		 
		//HttpSession 객체 가져오기
		HttpSession session = request.getSession();
		 
		//ServletContext 객체 가져오기
		ServletContext conext = session.getServletContext();
		 
		//Spring Context 가져오기
		WebApplicationContext wContext = WebApplicationContextUtils.getWebApplicationContext(conext);
		
		return wContext.getBean(beanName);
		
	}
}
