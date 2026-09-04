package com.tx.dyAdmin.admin.keyword.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.tx.dyAdmin.admin.keyword.dto.KeywordDTO;

public interface KeywordService {
	
	
	/**
	 * 키워드 등록
	 * @param keyword
	 * @param req
	 */
	public void checkKeyword(String keyword,HttpServletRequest req);
	
	/**
	 * 키워드 조작
	 * @param keyword
	 * @param req
	 * @param size
	 */
	public void updateKeyword(String keyword,HttpServletRequest req,int size);
	
	/**
	 * 키워드 목록 가져오기 갯수 파라미터로 받음
	 * @param size
	 * @return
	 */
	public List<KeywordDTO> getKeywordList();
	
	/**
	 * 키워드 목록 가져오기 갯수 파라미터로 받음
	 * @param size
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public List getKeywordList(int KeywordSize,int minCount);
	
	/**
	 * 특정 키워드에 대한 상세 목록
	 * @param KeywordDTO
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public List getDetailList(KeywordDTO KeywordDTO);
	
	/**
	 * 삭제
	 * @param KeywordDTO
	 */
	public void deleteData(KeywordDTO KeywordDTO);
	
	/**
	 * 삭제 - 키워드
	 * @param KeywordDTO
	 */
	public void deleteDataWithKeyword(KeywordDTO KeywordDTO);
	
	
	
}
