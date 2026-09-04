package com.tx.dyAdmin.admin.ipfilter.service.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.admin.ipfilter.dto.IP;
import com.tx.dyAdmin.admin.ipfilter.dto.URL;
import com.tx.dyAdmin.admin.ipfilter.service.IpFilterService;
import com.tx.dyAdmin.admin.ipfilter.service.IpTree;
import com.tx.dyAdmin.admin.ipfilter.service.NumberNode;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("IpFilter")
public class IpFilterServiceImpl  extends EgovAbstractServiceImpl implements IpFilterService {
	
	
	private final static String WHITELIST = "SC_FKDJV"; //화이트리스트 코드
//	private final static String BLACKLIST = "SC_NVDBQ"; //블랙리스트 코드
	
	private List<URL> urlList = null;
    @Autowired
    ComponentService Component;
    

    @PostConstruct
	public void init(){
		urlList = new ArrayList<URL>();
		
		List<?> list = Component.getList("ipfilter.IPM_select","Y");
		
		for(Object l : list){
			IP ip = (IP)l;
			addURL(ip);
		}
	}
	
	/**
	 * IP 체크
	 * @param ipTree
	 * @param ip
	 * @return
	 */
    @Override
	public boolean checkIP(String url, String ip) {
		// TODO Auto-generated method stub
		
		URL URL = checkURL(url); 
		if(URL == null || URL.getIpTree() == null){
			return true;
		}else{
			IpTree ipTree = URL.getIpTree();
			
			NumberNode now = ipTree.getRoot();
			NumberNode child;
			String ipNumber[] = ip.split(IpTree.delimiter);
			boolean state = true;
			if(URL.getType().equals("SC_NVDBQ")){
				state = false;
			}
			
			for(String number : ipNumber){
				child = now.getChild(number);
				if(child == null) {
					state = !state;
					break;
				}
				now = child;
			}
			
			return state;
		}
	}
    
	/**
	 * 해당 URL에 적용되는 화이트/블랙리스트가 있는지 조사
	 * @param url
	 * @return
	 */
	private URL checkURL(String url) {
		
		for(URL URL : urlList){
			for(String u : URL.getUrl()){
				if(u.contains("*")){
					u = u.substring(0,u.indexOf("*"));
					if(url.startsWith(u)){
						return URL;
					}
				}else if(url.equals(u)){
					return URL;
				}
			}
		}
		
		
		return null;
	}
	
	/**
	 * URL 추가
	 * @param ip
	 */
	@Override
	public void addURL(IP ip) {
		
		URL url = new URL();
		url.setKeyno(ip.getIPM_KEYNO());
		url.setUrl(ip.getIPM_URL().split("\n"));
		url.setType(ip.getIPM_TYPE());
		
		ip.setIPS_IPM_KEYNO(ip.getIPM_KEYNO());
		if(ip.getIPM_TYPE().equals(WHITELIST)){
			ip.setIPS_TYPE("W");
		}else{
			ip.setIPS_TYPE("B");
		}
		url.setIpTree(new IpTree(Component.getList("ipfilter.IP_selectOnlyIP",ip)));
		urlList.add(url);
		
	}
	
	/**
	 * URL 수정
	 * @param ip
	 */
	@Override
	public void updateURL(IP ip) {
		
		boolean exist = false;
		for(URL u : urlList){
			//해당 url이 존재하는지 체크
			if(u.getKeyno().equals(ip.getIPM_KEYNO())){
				exist = true;
				//미사용으로 변경시 list에서 삭제
				if(ip.getIPM_USEYN().equals("N")){
					urlList.remove(u);
					break;
				}
				// 화이트리스트 <-> 블랙리스트 변경시
				if(!u.getType().equals(ip.getIPM_TYPE())){
					u.setIpTree(new IpTree(Component.getList("ipfilter.IP_selectOnlyIP",ip)));
				}
				u.setUrl(ip.getIPM_URL().split("\n"));
			}
		}
		
		//존재하지 않을시
		if(!exist){
			addURL(ip);
		}
		
		
	}
	
	/**
	 * URL 삭제
	 * @param ip
	 */
	@Override
	public void removeURL(IP ip) {
		for(URL u : urlList){
			if(u.getKeyno().equals(ip.getIPM_KEYNO())){
				urlList.remove(u);
				break;
			}
		}
		
	}
	
	
	/**
	 * IP 추가
	 * @param keyno
	 * @param ip
	 * @return
	 */
	@Override
	public void addIP(String keyno, String ip) {
		IpTree tree = getIpTree(keyno);
		if(tree != null){
			tree.addTree(ip);
		}
	}
	
		
	/**
	 * IP 삭제
	 * @param keyno
	 * @param ip
	 * @return
	 */
	@Override
	public void removeIP(String keyno, String ip) {
		IpTree tree = getIpTree(keyno);
		if(tree != null){
			tree.removeTree(ip);
		}
	}
	
	
	/**
	 * IP 수정
	 * @param keyno
	 * @param ip
	 * @return
	 */
	@Override
	public void updateIP(String keyno, String beforeIp, String newIp) {
		IpTree tree = getIpTree(keyno);
		if(tree != null){
			tree.updateTree(beforeIp, newIp);
		}
		
	}
	
	/**
	 * get IpTree 	
	 * @param keyno
	 * @return
	 */
	private IpTree getIpTree(String keyno) {
		for(URL u : urlList){
			if(u.getKeyno().equals(keyno)){
				return u.getIpTree();
			}
		}
		return null;
	}
}
