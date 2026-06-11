<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<%@ taglib prefix="tiles" 	uri="http://tiles.apache.org/tags-tiles" %>

<!DOCTYPE html>
<html lang="${homeData.HM_LANG }">

<head>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
    <tiles:insertAttribute name="meta" />
    <tiles:insertAttribute name="css" />
    <tiles:insertAttribute name="script" />
</head>

<body>

<%-- 	<c:if test="${not empty popupList_B }">
      <jsp:include page="${popupBannerPath}"/>
    </c:if> --%>

	<c:if test="${currentMenu.MN_DATA1 ne 'mobile' }">
		<c:if test="${currentMenu.MN_URL eq '/dy/member/login.do' }">
	        <tiles:insertAttribute name="body" />
	    </c:if>
		<c:if test="${currentMenu.MN_URL ne '/dy/member/login.do' }">
		<c:set var="apart" value="${fn:contains(currentMenu.MN_URL,'/dy/member/regist')}" />
		   	  <div id="wrap">
	         	<tiles:insertAttribute name="header" />
	        	<tiles:insertAttribute name="subTop" />
	       	 	<tiles:insertAttribute name="body" />
	      	</div> 
		</c:if>
	</c:if>
	<c:if test="${currentMenu.MN_DATA1 eq 'mobile' }">
		<div id="wrap">
		    <tiles:insertAttribute name="header" />
			<tiles:insertAttribute name="body" />
		</div>
	</c:if>
<%-- 	<c:if test="${not empty popupList_W }">
       <jsp:include page="${popupLayoutPath}"/>
    </c:if> --%>
	
	<div class="loading_box">
        <div class="bg"></div>
        <img src="${pageContext.request.contextPath}/resources/img/loading/loading.gif" title="Loading.." alt="로딩중" />
    </div>
</body>

</html>