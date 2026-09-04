package com.tx.common.file.dto;

import java.io.Serializable;

import lombok.Data;


/**
 * @FileMain
 * 공통기능의 상위 파일정보를 관리 하는 빈즈
 * @author 신희원
 * @version 1.0
 * @since 2014-11-12
 */
@Data
public class FileMain implements Serializable {
	
	//시리얼 넘버
	static final long serialVersionUID = 42L;
	
	//고유키
	private String FM_KEYNO = null;
	
	//업로드일자
	private String FM_REGDT = null;
	
	//업로드 사용자
	private String FM_REGNM = null;
	
	//알집 경로
	private String FM_ZIP_PATH = "";
	
	
	private int FS_CNT = 0;
	
	//사용 처 추적용 키 목록
	protected String FM_WHERE_KEYS;
	//파일 설명
	private String FM_COMMENTS;
	
	private String ZIP_NAME;
	
	
	public FileMain() {
		super();
	}

	public FileMain(String fM_KEYNO, String fM_REGNM) {
		super();
		FM_KEYNO = fM_KEYNO;
		FM_REGNM = fM_REGNM;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	/**
	 * @return
	 * 사용 처 키의 배열을 반환
	 */
	public String[] getArrayFM_WHERE_KEYS(){
		if( FM_WHERE_KEYS == null ){
			return null;
		}else{
			return FM_WHERE_KEYS.split("\\,",-1);
		}
	}		
}
