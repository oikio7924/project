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
public class ManagerPagination extends AbstractPaginationRenderer implements ServletContextAware{
	public ManagerPagination() {
	} 
	
	public void initVariables(){
		
		firstPageLabel    = "<a class=\"btn first1\" href=\"javascript:;\" onclick=\"{0}({1});return false;\"></a>"; 
        previousPageLabel = "<button class=\"align-bottom inline-flex items-center justify-center cursor-pointer leading-5 transition-colors duration-150 font-medium focus:outline-none p-2 rounded-md text-gray-600 focus:outline-none border border-transparent opacity-50 cursor-not-allowed\" onclick=\"{0}({1});return false;\">이전</button>";
        currentPageLabel  = "<button class=\"mr-1 align-bottom inline-flex items-center justify-center cursor-pointer leading-5 transition-colors duration-150 font-medium focus:outline-none px-3 py-1 rounded-md text-xs text-black bg-badge-gray border border-transparent active:bg-indigo-600 hover:bg-indigo-700 focus:ring focus:ring-gray-300\" type=\"button\" return false;\">{0}</button>";;
        otherPageLabel    = "<button class=\"mr-1 align-bottom inline-flex items-center justify-center cursor-pointer leading-5 transition-colors duration-150 font-medium focus:outline-none px-3 py-1 rounded-md text-xs text-white bg-indigo-600 border border-transparent active:bg-indigo-600 hover:bg-indigo-700 focus:ring focus:ring-gray-300\" type=\"button\" onclick=\"{0}({1});return false;\">{2}</button>";;
        nextPageLabel     = "<a class=\"align-bottom inline-flex items-center justify-center cursor-pointer leading-5 transition-colors duration-150 font-medium focus:outline-none p-2 rounded-md text-gray-600 focus:outline-none border border-transparent opacity-50 cursor-not-allowed\" href=\"javascript:;\" onclick=\"{0}({1});return false;\">다음</a>";
        lastPageLabel     = "<a class=\"btn last\" href=\"javascript:;\" onclick=\"{0}({1});return false;\"></a>";
	} 
	
	public void setServletContext(ServletContext servletContext){
		initVariables();
	} 
}

