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
public class BoardNormalPagination extends AbstractPaginationRenderer implements ServletContextAware{
	public BoardNormalPagination() {
	} 
	
	public void initVariables(){
		firstPageLabel    = "<li class=\"pageAllPrev\"><a href=\"?pageIndex={1}\"  onclick=\"{0}({1});return false; \"><img src=\"/resources/img/icon/icon_board_all_prev.png\"  alt=\"전체이전\"/></a></li>"; 
        previousPageLabel = "<li class=\"pagePrev\"><a href=\"?pageIndex={1}\"  onclick=\"{0}({1});return false; \"><img src=\"/resources/img/icon/icon_board_prev.png\"  alt=\"이전\"/></a></li>";
        currentPageLabel  = "<li class=\"active\"><a href=\"javascript:;\">{0}</a></li>";
        otherPageLabel    = "<li><a href=\"?pageIndex={1}\" onclick=\"{0}({1});return false; \">{2}</a></li>";
        nextPageLabel     = "<li class=\"pageNext\"><a href=\"?pageIndex={1}\"  onclick=\"{0}({1});return false; \"><img src=\"/resources/img/icon/icon_board_next.png\"  alt=\"다음\"/></a></li>";
        lastPageLabel     = "<li class=\"pageAllNext\"><a href=\"?pageIndex={1}\"  onclick=\"{0}({1});return false; \"><img src=\"/resources/img/icon/icon_board_all_next.png\"  alt=\"전체다음\"/></a></li>";
	} 
	
	public void setServletContext(ServletContext servletContext){
		initVariables();
	} 
}

