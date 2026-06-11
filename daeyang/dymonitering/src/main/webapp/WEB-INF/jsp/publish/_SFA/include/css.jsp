<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>

<link type="text/css" rel="stylesheet" href="/resources/common/css/dyAdmin/common.css">
<link rel="stylesheet" type="text/css" media="all" href="/resources/common/css/dyAdmin/subTop.css">

<!-- Basic Styles -->
<link rel="stylesheet" type="text/css" media="all" href="/resources/smartadmin/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" media="all" href="/resources/smartadmin/css/font-awesome.min.css">

<!-- SmartAdmin Styles : Caution! DO NOT change the order -->
<link rel="stylesheet" type="text/css" media="all" href="/resources/smartadmin/css/smartadmin-production-plugins.min.css">
<link rel="stylesheet" type="text/css" media="all" href="/resources/smartadmin/css/smartadmin-production.min.css">
<link rel="stylesheet" type="text/css" media="all" href="/resources/smartadmin/css/smartadmin-skins.min.css">

<!-- SmartAdmin RTL Support is under construction-->
<link rel="stylesheet" type="text/css" media="all" href="/resources/smartadmin/css/smartadmin-rtl.min.css"> 

<!-- Demo purpose only: goes with demo.js, you can delete this css when designing your own WebApp -->
<link rel="stylesheet" type="text/css" media="all" href="/resources/smartadmin/css/demo.min.css">

<!-- FAVICONS -->
<c:choose>
	<c:when test="${not empty homeData.HM_FAVICON }">
		<c:set var="homeIcon" value="${domain }${homeData.HM_FAVICON }"/>
	</c:when>
	<c:otherwise>
		<c:set var="homeIcon" value="${domain }/resources/favicon.ico"/>
	</c:otherwise>
</c:choose>
<link rel="shortcut icon" href="${homeIcon }" type="image/x-icon">
<link rel="icon" href="${homeIcon }" type="image/x-icon">

<!-- GOOGLE FONT -->
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Open+Sans:400italic,700italic,300,400,700">

<!-- Specifying a Webpage Icon for Web Clip 
	 Ref: https://developer.apple.com/library/ios/documentation/AppleApplications/Reference/SafariWebContent/ConfiguringWebApplications/ConfiguringWebApplications.html -->
<link rel="apple-touch-icon" href="/resources/smartadmin/img/splash/sptouch-icon-iphone.png">
<link rel="apple-touch-icon" sizes="76x76" href="/resources/smartadmin/img/splash/touch-icon-ipad.png">
<link rel="apple-touch-icon" sizes="120x120" href="/resources/smartadmin/img/splash/touch-icon-iphone-retina.png">
<link rel="apple-touch-icon" sizes="152x152" href="/resources/smartadmin/img/splash/touch-icon-ipad-retina.png">

<!-- Startup image for web apps -->
<link rel="apple-touch-startup-image" href="/resources/smartadmin/img/splash/ipad-landscape.png" media="screen and (min-device-width: 481px) and (max-device-width: 1024px) and (orientation:landscape)">
<link rel="apple-touch-startup-image" href="/resources/smartadmin/img/splash/ipad-portrait.png" media="screen and (min-device-width: 481px) and (max-device-width: 1024px) and (orientation:portrait)">
<link rel="apple-touch-startup-image" href="/resources/smartadmin/img/splash/iphone.png" media="screen and (max-device-width: 320px)">
		
<c:if test="${empty currentMenu }">		
<style>
body {background:#fff;}
.smart-style-4 #content>.row:first-child {background:#fff; border-bottom:none;}
#main {margin-left:0}
#content {padding:20px;}
</style>
</c:if>

		