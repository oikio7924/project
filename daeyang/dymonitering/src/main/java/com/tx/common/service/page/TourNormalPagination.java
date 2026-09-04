package com.tx.common.service.page;

import javax.servlet.ServletContext;

import org.springframework.web.context.ServletContextAware;

import egovframework.rte.ptl.mvc.tags.ui.pagination.AbstractPaginationRenderer;

/**
 * @Pagination
 * Jsp 화면 페이지 처리 UI 생성 클래스 (게시판) 
 * @author 신희원
 * @version 1.0
 * @since 2014-11-14
 */
public class TourNormalPagination extends AbstractPaginationRenderer implements ServletContextAware{
	public TourNormalPagination() {
	} 
	
	public void initVariables(){
        previousPageLabel = "<li class=\"btnBox prev\"><a href=\"?pageIndex={1}\"  onclick=\"{0}({1});return false; \"><i class=\"material-icons\">keyboard_arrow_left</i></a></li>";
        currentPageLabel  = "<li class=\"active\"><a href=\"javascript:;\">{0}</a></li>";
        otherPageLabel    = "<li><a href=\"?pageIndex={1}\" onclick=\"{0}({1});return false; \">{2}</a></li>";
        nextPageLabel     = "<li class=\"btnBox next\"><a href=\"?pageIndex={1}\"  onclick=\"{0}({1});return false; \"><i class=\"material-icons\">keyboard_arrow_right</i></a></li>";
	} 
	
	public void setServletContext(ServletContext servletContext){
		initVariables();
	} 
}

