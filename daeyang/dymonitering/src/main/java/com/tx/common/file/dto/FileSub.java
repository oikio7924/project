package com.tx.common.file.dto;

import java.io.Serializable;
import java.util.List;

import com.tx.common.security.aes.AES256Cipher;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * @FileSub 공통기능의 하위 파일정보내용을 관리 하는 빈즈
 * @author 신희원
 * @version 1.0
 * @since 2014-11-12
 */

@Data
@Builder
@AllArgsConstructor
@EqualsAndHashCode(callSuper=false)
public class FileSub extends FileMain implements Serializable {

	private static final long serialVersionUID = -1493426419078958857L;

	// 고유키
	private String FS_KEYNO;

	// 상위 그룹키
	private String FS_FM_KEYNO;

	// 파일크기
	private String FS_FILE_SIZE;

	// 원본파일명칭
	private String FS_ORINM;

	// 코드화 완료된 파일명칭
	private String FS_CHANGENM;

	// 확장자
	private String FS_EXT;

	// 저장위치 절대경로
	private String FS_FOLDER;

	// 다운로드 횟수
	private Integer FS_DOWNCNT;

	// 파일키 배열 정보
	private List<String> GroupFS_KeyArray;

	// 모바일 리사이즈 이미지 키
	private String FS_M_KEYNO;

	// 등록일
	private String FS_REGDT;

	// 등록자
	private String FS_REGNM;

	// 경로
	private String FS_PATH;

	// 썸네일 이름
	private String FS_THUMBNAIL;

	// 파일 주석
	private String FS_ALT;

	// 파일 설명
	private String FS_COMMENTS;
	
	// 정렬순서
	private Integer FS_ORDER;

	// 원본이미지 가로픽셀
	@Builder.Default
	private int FS_ORIWIDTH = 0;

	// 원본이미지 세로픽셀
	@Builder.Default
	private int FS_ORIHEIGHT = 0;
	
	// FS_STORAGE
	private String FS_STORAGE;
	
	// FS_PUBLIC_PATH
	private String FS_PUBLIC_PATH;
	
	// FS_CONVERT_PATH
	private String FS_CONVERT_PATH;
	
	// FS_CONVERT_CHK
	private String FS_CONVERT_CHK;

	private String PATH;
	
	
	/* Image 파일 하위 속성 */
	// 업로드 이미지 리사이즈 속성
	@Builder.Default
	private boolean IS_RESIZE = false;
	@Builder.Default
	private int RESIZE_WIDTH = 0;
	@Builder.Default
	private int RESIZE_HEIGHT = 0;

	// 업로드 이미지의 썸네일 속성 - 썸네일 생성 이미지가 FileSub로 관리되어 지지 않기에 사용함.
	@Builder.Default
	private boolean IS_MAKE_THUMBNAIL = false;
	@Builder.Default
	private int THUMB_WIDTH = 0;
	@Builder.Default
	private int THUMB_HEIGHT = 0;
	@Builder.Default
	private boolean IS_MAKE_MOVIE_THUMBNAIL = false;
	@Builder.Default
	private boolean IS_MAKE_BOARDTHUMB = false;

	public void setIS_MAKE_MOVIE_THUMBNAIL(boolean iS_MAKE_MOVIE_THUMBNAIL) {
		IS_MAKE_MOVIE_THUMBNAIL = iS_MAKE_MOVIE_THUMBNAIL;
	}

	public FileSub() {
		super();
	}

	/**
	 * @param fS_KEYNO
	 * @param fS_FM_KEYNO
	 *          PK 주입용 생성자
	 */
	public FileSub(String fS_FM_KEYNO, String fS_KEYNO) {
		super();
		FS_FM_KEYNO = fS_FM_KEYNO;
		FS_KEYNO = fS_KEYNO;
	}
	
	public FileSub(String fS_FM_KEYNO, String fS_KEYNO, boolean isMovieThumb) {
		this(fS_FM_KEYNO, fS_KEYNO);
		this.IS_MAKE_MOVIE_THUMBNAIL = isMovieThumb;
	}
	
	public FileSub(String fS_FM_KEYNO, String fS_KEYNO, boolean isMovieThumb, boolean isMakeByBoard, String whereKey) {
		this(fS_FM_KEYNO, fS_KEYNO);
		this.IS_MAKE_MOVIE_THUMBNAIL = isMovieThumb;
		this.IS_MAKE_BOARDTHUMB = isMakeByBoard;
		System.out.println("whereKey :: " + whereKey);
		this.FM_WHERE_KEYS = whereKey;
	}
	
	public String getEncodeFsKey(){
		
		String encodeFsKey = "";
		try{
			encodeFsKey = AES256Cipher.encode(FS_KEYNO);
		}catch(Exception e){
			System.out.println("AES256Cipher.encode() 에러");
		}
		
		return encodeFsKey;
	}
	
	
	public String getEncodeFsFmKey(){
		
		String encodeFsFmKey = "";
		try{
			encodeFsFmKey = AES256Cipher.encode(FS_FM_KEYNO);
		}catch(Exception e){
			System.out.println("AES256Cipher.encode() 에러");
		}
		
		return encodeFsFmKey;
	}
	
	public String getEncodePath(){
		
		String encodePath = "";
		try{
			encodePath = AES256Cipher.encode(FS_PATH);
		}catch(Exception e){
			System.out.println("AES256Cipher.encode() 에러");
		}
		
		return encodePath;
	}
	
	
	public String getEncodePublicPath(){
		
		String encodePublicPath = "";
		try{
			encodePublicPath = AES256Cipher.encode(FS_PUBLIC_PATH);
		}catch(Exception e){
			System.out.println("AES256Cipher.encode() 에러");
		}
		
		return encodePublicPath;
	}
	
	public FileSub IS_RESIZE() {
		this.IS_RESIZE = true;
		return this;
	}

	public FileSub RESIZE_WIDTH(int RESIZE_WIDTH) {
		this.RESIZE_WIDTH = RESIZE_WIDTH;
		return this;
	}

	public FileSub RESIZE_HEIGHT(int RESIZE_HEIGHT) {
		this.RESIZE_HEIGHT = RESIZE_HEIGHT;
		return this;
	}

	public FileSub IS_MAKE_THUMBNAIL() {
		this.IS_MAKE_THUMBNAIL = true;
		return this;
	}
	
	public FileSub IS_MAKE_BOARDTHUMB() {
		this.IS_MAKE_BOARDTHUMB = true;
		return this;
	}

	public FileSub THUMB_WIDTH(int THUMB_WIDTH) {
		this.THUMB_WIDTH = THUMB_WIDTH;
		return this;
	}

	public FileSub THUMB_HEIGHT(int THUMB_HEIGHT) {
		this.THUMB_HEIGHT = THUMB_HEIGHT;
		return this;
	}

	public boolean getIS_RESIZE() {
		return IS_RESIZE;
	}

	public boolean getIS_MAKE_THUMBNAIL() {
		return IS_MAKE_THUMBNAIL;
	}

	public boolean getIS_MAKE_MOVIE_THUMBNAIL() {
		return IS_MAKE_MOVIE_THUMBNAIL;
	}

	public boolean getIS_MAKE_BOARDTHUMB() {
		return IS_MAKE_BOARDTHUMB;
	}
	
}
