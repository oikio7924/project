package com.tx.common.file.thumnail;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

import com.tx.dyAdmin.admin.board.dto.BoardNotice;
import com.tx.dyAdmin.admin.board.dto.BoardType;

public interface ThumnailService {

	public String ThumnailAction(HttpServletRequest req, MultipartFile thumbnail, BoardType BoardType, BoardNotice BoardNotice, String FM_KEYNO) throws Exception;

	public String mainfolder(HttpServletRequest req) throws Exception;
	
	public void Tempdeletefolder(String realpath)  throws Exception;
}
