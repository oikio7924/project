package com.tx.dyAdmin.admin.board.service;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.dto.SNS.SNSInfo;
import com.tx.common.file.dto.FileSub;
import com.tx.dyAdmin.admin.board.dto.BoardColumn;
import com.tx.dyAdmin.admin.board.dto.BoardColumnData;
import com.tx.dyAdmin.admin.board.dto.BoardNotice;
import com.tx.dyAdmin.admin.board.dto.BoardType;
import com.tx.dyAdmin.homepage.menu.dto.Menu;

public interface BoardCommonService {

	public String getBoardfilesExt(BoardType boardType);
	
	public String boardPersonalCheck(HttpServletResponse response, BoardType bt, String conTents, String mn_URL) throws IOException;
	
	public SNSInfo setBoardSnsInfo(HashMap<String, Object> boardNotice, HttpServletRequest req, ModelAndView mv) throws Exception;
	
	public void sendBoardEmail(HttpServletRequest req, String tiles, BoardType boardType, BoardNotice boardNotice, Menu menu, String action) throws Exception;
	
	public List<BoardColumnData> setCodeColumnData(List<BoardColumnData> BoardColumnDataList);
	
	public void boardFileRelatedProcessing(HttpServletRequest req, String mn_KEYNO, BoardNotice boardNotice, BoardType boardType, MultipartFile thumbnail, String fM_KEYNO) throws Exception;
	
	public void boardColumnDataAction(String type, String[] bD_BL_KEYNO, String[] bD_BL_TYPE, String[] bD_DATA, BoardColumnData boardColumnData, BoardNotice boardNotice, String[] bD_KEYNO);
	
	public void getBoardColumnCodeList(List<BoardColumn> columnList, ModelAndView mv);
	
	public void columnDataInsert(BoardColumnData boardColumnData, BoardNotice boardNotice, String bD_BL_TYPE, String bD_BL_KEYNO, String bD_DATA);
	
	public HashMap<String, Object> getBoardDataByHashMap(String query, HashMap<String, Object> boardMap);
	
	public HashMap<String, Object> getBoardDataByHashMap(String query, HashMap<String, Object> boardMap,String xssCk, String type);
	
	public HashMap<String, Object> getBoardDataByBoardNotice(String query, BoardNotice boardNotice);
	
	public HashMap<String, Object> getBoardDataByBoardNotice(String query, BoardNotice boardNotice,String xssCk, String type);
	
	public Integer commentLastPage(HashMap<String, Object> map) throws Exception;
	
	public void setAttachmentsConvertCheck(HttpServletRequest req, List<FileSub> fileSubList, HashMap<String, Object> map) throws Exception;
	
	public List<Map<String, Object>> getAuthBoardMenuList(HttpServletRequest req, HashMap<String, Object> map) throws Exception;
	
}
