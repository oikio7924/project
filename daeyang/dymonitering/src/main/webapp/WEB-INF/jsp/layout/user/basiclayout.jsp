<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<%@ taglib prefix="tiles" 	uri="http://tiles.apache.org/tags-tiles" %>

<!DOCTYPE html>
<html lang="${homeData.HM_LANG }">
<head>

<tiles:insertAttribute name="meta"/>
<tiles:insertAttribute name="css"/>
<tiles:insertAttribute name="script"/>

</head>
<body>
	
	
	<tiles:insertAttribute name="header"/>

	<c:if test="${currentMenu.MN_LEV eq 0 }"><!-- 메인화면 -->
		<tiles:insertAttribute name="body"/>
	</c:if>

	<c:if test="${currentMenu.MN_LEV ne 0 }"><!-- 서브 페이지  -->
		<tiles:insertAttribute name="subTop"/>
	    
    	<tiles:insertAttribute name="leftmenu"/>           
       	<tiles:insertAttribute name="rightTop"/>
        <tiles:insertAttribute name="body"/>	
	            
        <c:if test="${currentMenu.MN_GONGNULI_YN eq 'Y' && currentMenu.MN_PAGEDIV_C ne sp:getData('MENU_TYPE_BOARD') }">
			<%@ include file="/WEB-INF/jsp/user/_common/prc_gong_nuli.jsp" %>                            
        </c:if>
        <c:if test="${currentMenu.MN_RESEARCH eq 'Y' }">
        <script src="/resources/common/js/common/page_research.js"></script>
        <link href="/resources/common/css/page_research.css" type="text/css" rel="stylesheet">
           <div style="margin-top: 100px;">
         	 <c:choose>
 				<c:when test="${not empty homeData.HM_RESEARCH_SKIN}">
					<jsp:include page="/WEB-INF/jsp/user/Skin/research/prs_skin_${fn:substring(homeData.HM_RESEARCH_SKIN,4,20)}.jsp"/>
 				</c:when>
 				<c:otherwise>
 				</c:otherwise>
 			</c:choose>     	
           </div>
        </c:if>
	</c:if>

	<tiles:insertAttribute name="footer"/>

	<div class="loading_box">
		<div class="bg"></div>
		<img src="/resources/img/loading/loading.gif"
			title="Loading.." alt="로딩중"/>
	</div>
</body>
</html>








