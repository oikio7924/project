<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<%@ taglib prefix="tiles" 	uri="http://tiles.apache.org/tags-tiles" %>
<!DOCTYPE html>
<html lang="ko">
	<head>
	
	<meta charset="utf-8">
	<meta name="description" content="">
	<meta name="author" content="">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<!-- iOS web-app metas : hides Safari UI Components and Changes Status Bar Appearance -->
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="apple-mobile-web-app-status-bar-style" content="black">
	<meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
	<title>CT CMS</title>
	
	<tiles:insertAttribute name="css"/>
	
	
	<!-- Link to Google CDN's jQuery + jQueryUI; fall back to local -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
	<script>
	if (!window.jQuery) {
		document.write('<script src="/resources/smartadmin/js/libs/jquery-2.1.1.min.js"><\/script>');
	}
	</script>
	
	<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>
	<script>
	if (!window.jQuery.ui) {
		document.write('<script src="/resources/common/js/common/jquery-ui.min.js"><\\/script>');
	}
	</script>
	</head>
	
	
	
	
	<body class="smart-style-4">
		<!-- HEADER -->
		<header id="header">
			<tiles:insertAttribute name="header"/>
		</header>
		<!-- END HEADER -->
		
  		<c:if test="${not empty currentMenu }">		 
		<aside id="left-panel">
			<tiles:insertAttribute name="leftmenu"/>
		</aside>
  		</c:if>  
		
		<!-- MAIN PANEL -->
		<div id="main" role="main">
				
			<!-- RIBBON -->
			<div id="ribbon">
				<tiles:insertAttribute name="ribbon"/>
			</div>
			<!-- END RIBBON -->
			
			
			<!-- MAIN CONTENT -->
			<div id="content">
				<c:if test="${not empty currentMenu }">	
				<tiles:insertAttribute name="subTop"/>	
				</c:if>	
				<tiles:insertAttribute name="body"/>
			</div>
			<!-- END MAIN CONTENT -->	
		</div>
		<!-- END MAIN PANEL -->
		
		<!-- PAGE FOOTER -->
		<div class="page-footer">
			<tiles:insertAttribute name="footer"/>
		</div>
		<!-- END PAGE FOOTER -->
		<c:if test="${not empty popupList_W }">
			<%@ include file="/WEB-INF/jsp/dyAdmin/homepage/popup/popup_view_W.jsp" %>
		</c:if>
		<!-- END SHORTCUT AREA -->
		<tiles:insertAttribute name="script"/>
		<div class="loading_box">
			<div class="bg"></div>
			<img src="/resources/img/loading/loading.gif"
				title="Loading.." alt="로딩중"/>
		</div>
		
		<input type="hidden" id="tiles" value="adm">
	</body>
</html>