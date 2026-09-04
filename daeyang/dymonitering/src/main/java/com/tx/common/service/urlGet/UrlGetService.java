package com.tx.common.service.urlGet;

import java.io.IOException;

import org.json.simple.parser.ParseException;

/**
 * 개인정보필터 서비스
 */

public interface UrlGetService {
	public boolean UrlGetNaver(String URL) throws IOException, ParseException;
	public boolean UrlGetKaKao(String URL, String Auth) throws IOException, ParseException;
	public boolean UrlGetFaceBook(String URL) throws IOException, ParseException;
}
