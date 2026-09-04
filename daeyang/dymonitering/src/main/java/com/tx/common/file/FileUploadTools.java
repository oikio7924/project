package com.tx.common.file;

import java.awt.image.BufferedImage;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

import com.tx.common.file.dto.FileSub;

/**
 * @FileUploadTools
 * 공통기능의 파일 업로드를 관리 하는 툴 클래스 
 * @author 신희원
 * @version 1.0
 * @since 2014-11-12
 */

/**
 * @author admin
 *
 */
public interface FileUploadTools{
	
	/**
	 * 네이버 스마트에디터2 용 파일 업로드
	 * @param request
	 * @param filename
	 * @return
	 * @throws Exception
	 */
	public String FileUploadWithSMARTEDITOR(HttpServletRequest request, String filename) throws Exception;

	/**
 	 * QR-CODE 업로드
 	 * @param REGNM 등록자
 	 * @throws Exception
 	 */
	public FileSub FileUploadByQrcode(BufferedImage bufferedImage, String REGNM, String FILENAME);
	
	/**
	 * favicon.ico 업로드
	 * @param thumbnail
	 * @param hm_TILES
	 * @param faviconPath :: 기존 파일 삭제를 위한 경로
	 * @return
	 */
	public String FaviconUpload(MultipartFile thumbnail, String hm_TILES, String faviconPath) throws Exception;

	/**
 	 * XML 업로드 - 스토리지 작업필요
 	 * @param filename 파일이름
 	 * @param filepath 파일경로
 	 * @param REGNM 등록자
 	 * @throws Exception
 	 */
	public FileSub FileUploadByXML(String filename, String filepath, String REGNM) throws Exception;
	

	/**
 	 * 하나의 파일을 업로드 한다.
 	 * + 리사이즈 여부(기본리사이즈)
	 * @param file
	 * @param fileSub
	 * @param REGNM
	 * @return
	 */
	public FileSub FileUpload(MultipartFile file, FileSub fileSub, String REGNM, boolean isResize, HttpServletRequest requset);
	
	
	/**
	 * 하나의 파일을 업로드 한다.
	 * + 입력값에 의한 리사이즈
	 * @param file
	 * @param FS_FM_KEYNO 메인코드 키
	 * @param REGNM
	 * @param width
	 * @param height
	 * @return
	 */
	public FileSub FileUpload(MultipartFile file, FileSub fileSub, String REGNM, int width, int height, HttpServletRequest request);
	
	
	/**
	 * 하나의 파일을 업로드 한다.
	 * + 리사이즈(IS_RESIZE)
	 * @param file
	 * @param REGNM 등록자
	 * @param FileSub 수정 분기를 위한 FS_KEYNO, 그 외 등록/수정에 이미지 리사이징, 썸네일 생성 등의 정보 전달용 DTO
	 * 관리자 : 파일관리용
	 * FileSub에 fsKey키 있는 경우 파일 수정 처리
	 * FileSub에 IS_RESIZE :: true일 경우 리사이즈 처리
	 * FileSub에 IS_MAKE_THUMBNAIL :: true일 경우 썸네일 생성 처리
	 * FileSub에 IS_MAKE_MOVIE_THUMBNAIL :: true일 경우 동영상 썸네일 생성 처리
	 */
	public FileSub FileUpload(MultipartFile file, String REGNM, FileSub FileSub, HttpServletRequest request);
	
	/**
 	 * 다중 파일을 업로드 한다.
 	 * + 리사이즈
 	 * @param request 요청
 	 * @param REGNM 등록자
 	 * @param fileOpt 리사이즈/썸네일 생성 여부, 가로세로 크기 등 전달 DTO
 	 * @throws Exception
 	 */
	public FileSub FileUpload(HttpServletRequest request, String REGNM, FileSub fileOpt, String FILES_EXT);
	
	/**
	 * 다중
	 * 리사이즈  + 순번에 따른 리사이징 이미지를 업로드 한다.
 	 * height 0 일때는 height값 autoSizing
 	 * @param request 요청
 	 * @param FS_FM_KEYNO 메인코드 키
     * @param REGNM 등록자
     * @param cnt 파일번호
     * @param width 리사이즈 가로크기
     * @param height 리사이즈 높이
     * @return
     * @throws Exception
    */
	public FileSub resizeFileUpload(HttpServletRequest request, String FS_FM_KEYNO, String REGNM, int cnt, int width, int height) throws Exception;

	public FileSub resizeFileUpload(HttpServletRequest request, String FS_FM_KEYNO, String REGNM, int cnt, int width, int height, String FILES_EXT) throws Exception;
	
   /**
	 * 다중
	 * 리사이즈 
 	 * 순번에 따른 리사이징 이미지를 업로드 한다.
 	 * height 0 일때는 height값 autoSizing
 	 * @param request 요청
 	 * @param FS_FM_KEYNO 메인코드 키
 	 * @param addFM_WHERE_KEY 호출하는 컨텐츠의 PK (참조용)
     * @param FM_COMMENTS 파일의 용도 및 목적 등
     * @param REGNM 등록자
     * @param cnt 파일번호
     * @param width 리사이즈 가로크기
     * @param height 리사이즈 높이
     * @return
     * @throws Exception
    */
  	public FileSub resizeFileUpload(HttpServletRequest request, String FS_FM_KEYNO, String addFM_WHERE_KEY, String FM_COMMENTS, String REGNM, int cnt, int width, int height, boolean isThumbnail) throws Exception;

  	public FileSub resizeFileUpload(HttpServletRequest request, String FS_FM_KEYNO, String addFM_WHERE_KEY, String FM_COMMENTS, String REGNM, int cnt, int width, int height, boolean isThumbnail,String FILES_EXT) throws Exception;
  
	/**
 	 * cnt번째 파일을 업로드 한다.
 	 * @param request 요청
 	 * @param FS_FM_KEYNO 메인코드 키
 	 * @param REGNM 등록자
 	 * @param cnt 업로드할 파일 번호 (1~)
 	 * @throws Exception
 	 */
//	public FileSub imageUploadNthFileWithDefaultResizing(HttpServletRequest request, String REGNM, int cnt) throws Exception;
	
	/**
	 * 파일들을 업로드하고 이미지는 기본 썸네일을 생성한다.
	 * @param request
	 * @param FS_FM_KEYNO
	 * @param REGNM
	 * @return
	 * @throws Exception
	 */
	public FileSub FileUploadWithDefaultThumb(HttpServletRequest request, String FS_FM_KEYNO, String REGNM) throws Exception;
	
	/**
 	 * 다중 파일을 업로드 하며 함께 전달된 FileSub 리스트의 내용을 주입한다.
 	 * @param request 요청 - 다중 파일 및 그에 수반하는 더즁 파라미터들을 전달
 	 * @param REGNM 등록자
 	 * @param count 몇번 째 파일을 업로드 할 것인지 ( -1 : 모든 파일 )
 	 * @param fsParam 컨트롤러에서 주입하는 데이터를 담는 DTO.
 	 * - IS_RESIZE, RESIZE_WIDTH, RESIZE_HEIGHT (리사이즈 여부 및 크기)
 	 * - IS_MAKE_THUMBNAIL, THUMB_WIDTH, THUMB_HEIGHT (썸네일 생성 여부 및 리사이즈 크기)
 	 * - FS_KEYNO (파일 교체 및 수정을 원할 경우 전달)
 	 * - FS_FM_KEYNO (부모키 FM_KEYNO)
 	 *  리사이징/썸네일 생성 여부 및 가로세로 크기 값 등. 수정을 위한 FS_KEYNO는 count가 -1이 아닌 경우에만 사용 가능
 	 *  isThumbnail :: true이면 FS_ALT, FS_COMMENTS 값이 필수
 	 * @throws Exception
 	 * @return 마지막 업로드 된 파일의 FileSub 객체
 	 */
	public FileSub FileUploadNthFile(HttpServletRequest request, String REGNM, int count, FileSub fileOpt, boolean isThumbnail, String FILES_EXT) throws Exception;
	
	/**
 	 * DATA URI 데이터 기반으로 업로드 합니다  + 썸네일 생성
 	 * @param imgInfo	해쉬맵으로 uri,title,ext 정보를 담고있음
 	 * @param FS_FM_KEYNO 메인코드 키
 	 * @param REGNM 등록자
 	 * IS_RESIZE :: true 옵션 넣으면 리사이즈 처리
 	 * @throws Exception
 	 */
	public FileSub FileUploadByDataURI(HashMap<String, String> imgInfo, String FS_FM_KEYNO, String REGNM) throws Exception;
	
	/**
	 * 이미지 변경 메소드
	 * @param FS_KEYNO
	 * @param req
	 * @param cnt 넘어온 파일 정보중 몇번째 파일인가
	 * @param resize 리사이즈 된 이미지 있는지 여부 
	 * @return
	 * @throws Exception
	 */
	public FileSub imageChange(String FS_KEYNO, HttpServletRequest req,String ID,int cnt,boolean resize,int width,int height, boolean isThumbnail) throws Exception;
	
	public FileSub imageChange(String FS_KEYNO, HttpServletRequest req,String ID,int cnt,boolean resize,int width,int height, boolean isThumbnail, String FILES_EXT) throws Exception;

	/**
	 * 이미지 변경 메소드
	 * @param FS_KEYNO
	 * @param file
	 * @param ID
	 * @return
	 * @throws Exception
	 */
	public FileSub imageChange(String FS_KEYNO, MultipartFile file,String ID,boolean resize ,HttpServletRequest req) throws Exception;
	
	/**
	 * 게시판 썸네일 생성 관련
	 * @param request
	 * @param FS_FM_KEYNO
	 * @param addFM_WHERE_KEY
	 * @param FM_COMMENTS
	 * @param REGNM
	 * @param cnt
	 * @param width
	 * @param height
	 * @param isThumbnail
	 * @return
	 * @throws Exception
	 */
	public FileSub resizeThumbNailFileUpload(HttpServletRequest request, String FS_FM_KEYNO, String addFM_WHERE_KEY, String FM_COMMENTS, String REGNM, int width, int height) throws Exception;
	public FileSub thumbNailImageChange(String FS_KEYNO, HttpServletRequest req, String regNm, int width, int height) throws Exception;
	
	/**
	 * 업로드 파일 삭제 
	 */
	public void UpdateFileDelete(FileSub fileSub);
	
	/**
	 * 이미지 파일 삭제 
	 * @param imgList
	 */
	public void UpdateFileDelete(List<FileSub> imgList) throws Exception;
	
	/**
	 * 업로드 파일 교체 - 스토리지 수정해야함
	 * @param deletefile
	 * @return 
	 * jsa
	 */
	public FileSub UpdateFileSub(HttpServletRequest requeset, FileSub fileSubNew) throws Exception;

	/**
	 * 넘어온 FS_KEYNO 로 새로운 파일 복사 생성
	 * @param FS_KEYNO
	 * @param fM_KEYNO
	 * @param REGNM
	 * @return
	 * @throws Exception
	 */
	public FileSub FileCopy(String FS_KEYNO, String FM_KEYNO, String REGNM) throws Exception;


	/**
 	 * 업로드시 폴더 여부 확인 및 생성
 	 * 2018-07-13 이재령
 	 * 날짜 분류 폴도 추가 
 	 * ex) upload/20180713/1... 2.... 3
 	 * @param Uploadpath
 	 */
	public String SaveFolder(String Uploadpath);
	
	/**
	  * 파일 업로드 내부의 고유키 부여
	  * @comment
	  * 2016.04.08. SooAn
	  *  웹에디터에서 이미지의 원활한 수정을 위해서
	  *  100글자에서 10글자로 대폭 축소시킴.
	  *  예측 위험발생가능성 - 폴더 당 최대생성하는 파일갯수 50회 중 1/36^15 의 확률로 발생 추측
	  *  2018.07.12 이재령
	  *  파일명에 현재시간 추가
	  * @return
	  */ 
	public String setfilename();
	
	/**
	 * FILE_MAIN 데이터 생성
	 * @return FM_KEYNO
	 */
	public String makeFileMainData(String REGNM) throws Exception;


	/**
	 * @param req
	 * @return
	 * List<FileSub> 다중으로 넘어온 FS_KEYNO(수정), FS_ALT, FS_COMMENTS
	 */
	public List<FileSub> getFileSubInfoList(HttpServletRequest req);
	
	/**
	 * 뷰 페이지에서 다중으로 넘어온 개별적인 FileSub 관련 request param을 List로 반환 
	 * @param req - 필수(!) : FS_ALT, FS_COMMENTS, 
	 * @param req - 옵션 : FS_FM_KEYNO, FS_KEYNO(수정), IS_RESIZE(RESIZE_WIDTH, RESIZE_HEIGHT),
	 *  IS_MAKE_THUMBNAIL(THUMB_WIDTH, THUMB_HEIGHT)
	 * @param fileLength 총 파일 개수
	 * @param count - 파일번호 (-1일 경우 req 파일 전체) 
	 * @return List<FileSub>
	 */
	public List<FileSub> getFileSubList(HttpServletRequest req, int fileLength, int count, boolean isThumbnail);
	
	/**
	 * 압축파일 생성
	 * @param fsVO
	 */
	public void zip(HttpServletRequest req, List<FileSub> fsVO) throws Exception;
	
	/**
	 * FS_FM_KEYNO를 통해 유무를 확인하고 없을 시 INSERT
	 * @param fs
	 * @param REGNM
	 * @return FM키 존재할 경우 true
	 */
	public String updateFileMain(String FS_FM_KEYNO, FileSub fs, String REGNM);

	/** 파일 경로로 업로드
	 * @param request
	 * @param path
	 * @return
	 */
	public boolean FileUploadNthFileByPath(HttpServletRequest request, String path, String newName) throws Exception;

	/** 압축 파일 생성 후 경로 리턴
	 * @param files
	 * @param fileName
	 * @return
	 */
	public String zip(List<HashMap<String, Object>> files, String fileName) throws Exception; 
}
