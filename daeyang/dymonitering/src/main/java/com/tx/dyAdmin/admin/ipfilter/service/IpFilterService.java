package com.tx.dyAdmin.admin.ipfilter.service;

import com.tx.dyAdmin.admin.ipfilter.dto.IP;

public interface IpFilterService {
	
	
	/**
	 * IP 체크
	 * @param ipTree
	 * @param ip
	 * @return
	 */
	public boolean checkIP(String url, String ip);
	
	/**
	 * URL 추가
	 * @param ip
	 */
	public void addURL(IP ip);
	
	/**
	 * URL 수정
	 * @param ip
	 */
	public void updateURL(IP ip);
	
	/**
	 * URL 삭제
	 * @param ip
	 */
	public void removeURL(IP ip);
	
	/**
	 * IP 추가
	 * @param keyno
	 * @param ip
	 * @return
	 */
	public void addIP(String keyno, String ip);
	
		
	/**
	 * IP 삭제
	 * @param keyno
	 * @param ip
	 * @return
	 */
	public void removeIP(String keyno, String ip);
	
	/**
	 * IP 수정
	 * @param keyno
	 * @param ip
	 * @return
	 */
	public void updateIP(String keyno, String beforeIp, String newIp);
	
}
