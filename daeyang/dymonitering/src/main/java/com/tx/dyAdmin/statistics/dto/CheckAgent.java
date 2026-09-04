package com.tx.dyAdmin.statistics.dto;

import org.codehaus.plexus.util.StringUtils;

public class CheckAgent {
	
	
	/**
	 * 브라우저 구분 
	 * @author 이재령 
	 * @date 2019-01-10
	 * @param agent
	 * @return
	 */
	static public String getBrowser(String agent){
		
		String browser = "";
		
		if(StringUtils.isBlank(agent)){
			browser = "정보없음";
		}else{
			if(checkSearchBot(agent)){
				browser = "searchbot";
			}else if(agent.contains("Trident/7.0")){
				browser = "IE11";
			}else if(agent.contains("MSIE 10")){
				browser = "IE10";
			}else if(agent.contains("MSIE 9")){
				browser = "IE9";
			}else if(agent.contains("MSIE 8")){
				browser = "IE8";
			}else if(agent.contains("MSIE 7")){
				browser = "IE7";
			}else if(agent.contains("MSIE 6")){
				browser = "IE6";
			}else if(agent.contains("MSIE 5")){
				browser = "IE5";
			}else if(agent.contains("edge")){
				browser = "Edge";
			}else if(agent.contains("Chrome/")){
				browser = "Chrome";
			}else if(agent.contains("Safari")){
				browser = "Safari";
			}else if(agent.contains("Firefox/")){
				browser = "Firefox";
			}else if(agent.contains("Opera")){
				browser = "Opera";
			}else if(agent.contains("opr")){
				browser = "Opera";
			}else if(agent.contains("inapp")){
				browser = "inapp";
			}else if(agent.contains("Kakaotalk")){
				browser = "Kakaotalk";
			}else if(agent.contains("Facebook")){
				browser = "Facebook";
			}else{
				browser = "기타";
			}
			
		}
		return browser;
		
	}
	
	static public String getOS(String agent){
		String OS = "";
		
		if(StringUtils.isBlank(agent)){
			OS = "정보없음";
		}else{
			agent = agent.toLowerCase();
			if(checkSearchBot(agent)){
				OS = "searchbot";
			}else if(agent.contains("windows nt 10.0")){
				OS = "Windows10";
			}else if(agent.contains("android")){
				OS = "ANDROID";
			}else if(agent.contains("linux")){
				OS = "Linux";
			}else if(agent.contains("macintosh")){
				OS = "MacOS";
			}else if(agent.contains("iphone")){
				OS = "IPHONE";
			}else if(agent.contains("ipad")){
				OS = "IPAD";
			}else if(agent.contains("windows nt 6.1")){
				OS = "Windows7";
			}else if(agent.contains("windows nt 6.2")){
				OS = "Windows8";
			}else if(agent.contains("windows nt 6.3")){
				OS = "Windows8";
			}else if(agent.contains("windows nt 6.0")){
				OS = "WindowsVista";
			}else if(agent.contains("windows nt 5.1")){
				OS = "WindowsXP";
			}else if(agent.contains("windows nt 5.0")){
				OS = "Windows2000";
			}else if(agent.contains("windows nt 4.0")){
				OS = "WindowsNT";
			}else if(agent.contains("windows 98")){
				OS = "Windows98";
			}else if(agent.contains("windows 95")){
				OS = "Windows95";
			}else{
				OS = "기타";
			}
			
		}
		return OS;
	}
	
	/**
	 * 서치봇 체크
	 * @param agent
	 * @return
	 */
	private static boolean checkSearchBot(String agent) {
		
		if(
				agent.contains("bot") ||
				agent.contains("slurp") ||
				agent.contains("baiduspider") ||
				agent.contains("sogou") ||
				agent.contains("exabot") ||
				agent.contains("facebookexternalhit") ||
				agent.contains("ia_archiver ") ||
				agent.contains("yeti") ||
				agent.contains("daum") ||
				agent.contains("kakaotalk-scrap") ||
				agent.contains("zgrab") ||
				agent.contains("avast! antivirus") ||
				agent.contains("curl/") ||
				agent.contains("go-http-client") 
			){
			return true;
		}else{
			return false;
		}
	}
	
}
