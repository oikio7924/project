package com.tx.user.service;


public interface memberService {
	
	/** 유저 휴면계정 스케줄링
	 * @param map
	 * @return
	 */
	public void DormancySchedule() throws Exception;
}