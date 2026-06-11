<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>

<div class="shadowBox"></div>
	
	<c:if test="${not empty popupList_B }">
<%-- 	<%@ include file="/WEB-INF/jsp/txap/operation/popup/popup_view_B.jsp" %> --%>
	</c:if>
	
	
	<tiles:insertAttribute name="header"/>
	
	<c:if test="${currentMenu.MN_LEV eq 0 }"><!-- 메인화면 -->
	<div id="contents_start">
		<tiles:insertAttribute name="body"/>
	</div>
	</c:if>

	<c:if test="${currentMenu.MN_LEV ne 0 }"><!-- 서브 페이지  -->
	<div id="subContentsWrap_01">
		<tiles:insertAttribute name="subTop"/>
	    
	    <div class="subBottomWrap">
	    	<tiles:insertAttribute name="leftmenu"/>           
	        <div class="subRightContentsWrap"  id="contents_start">
	        	<tiles:insertAttribute name="rightTop"/>
	            <div class="subRightContentsBottomWrap">
	            	<tiles:insertAttribute name="body"/>	
	            </div>
	            
	            <c:if test="${currentMenu.MN_GONGNULI_YN eq 'Y' && currentMenu.MN_PAGEDIV_C ne sp:getData('MENU_TYPE_BOARD') }">
		            <div style="margin-top: 150px;">
<%-- 						<%@ include file="/WEB-INF/jsp/common/prc_gong_nuli.jsp" %>                             --%>
		            </div>
	            </c:if>
	            <c:if test="${currentMenu.MN_RESEARCH eq 'Y' }">
		            <div style="margin-top: 150px;">
<%-- 						<%@ include file="/WEB-INF/jsp/txap/operation/research/prc_page_research.jsp" %>                             --%>
		            </div>
	            </c:if>
	        </div>
	    </div>
	</div>
	</c:if>

	<tiles:insertAttribute name="footer"/>
