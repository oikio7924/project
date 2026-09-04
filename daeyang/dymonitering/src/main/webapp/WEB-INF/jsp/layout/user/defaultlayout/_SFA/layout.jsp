<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<%@ taglib prefix="tiles" 	uri="http://tiles.apache.org/tags-tiles" %>
<!DOCTYPE html>
<html lang="${homeData.HM_LANG }">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">

    <title>대양 안전관리 시스템</title>
    <meta name="description" content="DAEYANG DASHBOARD">
    <meta property="og:title" content="대양 안전관리 시스템">
    <meta property="og:description" content="DAEYANG DASHBOARD">
    <meta property="og:locale" content="kr">
    <meta property="og:site_name" content="DAEYANG">

    <link rel="stylesheet" type="text/css" href="/resources/publish/_SFA/css/common.css">
    <link rel="stylesheet" type="text/css" href="/resources/publish/_SFA/css/mobile.css">
    
    <script src="https://code.jquery.com/jquery-3.5.0.js"></script>
    <!-- ✅ load jQuery ✅ -->

<script
  src="https://code.jquery.com/jquery-3.6.0.min.js"
  integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
  crossorigin="anonymous"
></script>

<!-- ✅ load jquery UI ✅ -->
<script
  src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"
  integrity="sha512-uto9mlQzrs59VwILcLiRYeLKPPbS/bT71da/OEBYEwcdNUk8jYIy+D176RYoop1Da+f9mvkYrmj5MCLZWEtQuA=="
  crossorigin="anonymous"
  referrerpolicy="no-referrer"></script>
	
    
<script type="text/javascript" src="/resources/publish/_SFA/js/common.js"></script>
</head>
<body>

	    <c:if test="${currentMenu.MN_URL eq '/sfa/safe/safe.do'}">
	        <tiles:insertAttribute name="body" />
	    </c:if>
		<c:if test="${currentMenu.MN_URL ne '/sfa/safe/safe.do' }">
		   	  <div class>
		   	  	<div class="flex bg-gray-50 false">	
			   	 	<tiles:insertAttribute name="leftmenu" />			   	 	
			   	 	<div class="flex flex-col flex-1 w-full">
				   	 	<tiles:insertAttribute name="header" />
			       	 	<tiles:insertAttribute name="body" />
		       	 	</div>
	       	 	</div>
	      	</div> 
	</c:if>
</body>

</html>