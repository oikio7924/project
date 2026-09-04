package com.tx.dyAdmin.admin.domain.service;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.tx.common.dto.Common;

public interface AdmDomainService {

	public ModelAndView paging(String returnUrl, HttpServletRequest req, Common search) throws Exception;

	public ModelAndView excel(String returnUrl, HttpServletRequest req, HttpServletResponse res, Common search) throws Exception;

	public ModelAndView data(String returnUrl, String HM_KEYNO) throws Exception;

	public String checkTilesName(String value, String type) throws Exception;

	public String insert(HashMap<String, Object> paramMap, HttpServletRequest req) throws Exception;

	public String update(HashMap<String, Object> paramMap, HttpServletRequest req) throws Exception;

	public void delete(String HM_KEYNO, HttpServletRequest req) throws Exception;

}
