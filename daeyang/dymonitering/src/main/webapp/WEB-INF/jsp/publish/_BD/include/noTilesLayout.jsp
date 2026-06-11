<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<%@ taglib prefix="tiles" 	uri="http://tiles.apache.org/tags-tiles" %>

<!DOCTYPE html>
<html lang="${homeData.HM_LANG }">
<head>

<meta charset="utf-8">
<meta name="description" content="전라남도 문화재단 입니다.">


<meta property="og:type" content="website" />
<meta property="og:title" content="전남문화재단" />
<meta property="og:description" content="전남문화재단 입니다." />
<meta property="og:url" content="http://jncf.or.kr/jact/intro.do" />
<meta name="Robots" content="INDEX, FOLLOW" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />


<meta name="author" content="">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- iOS web-app metas : hides Safari UI Components and Changes Status Bar Appearance -->
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>

<%-- <tiles:insertAttribute name="css"/>
<tiles:insertAttribute name="script"/> --%>
<link rel="shortcut icon" href="http://jncf.or.kr/resources/favicon.ico" type="image/x-icon">
<link rel="icon" href="http://jncf.or.kr/resources/favicon.ico" type="image/x-icon">
<link type="text/css" rel="stylesheet" href="/webjars/jquery-ui/1.12.1/jquery-ui.min.css">
<link href="/resources/api/bxslider/jquery.bxslider.css" type="text/css" rel="stylesheet">
<link rel="stylesheet" href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">


<link href="/resources/publish/jact/css/sub2.css" type="text/css" rel="stylesheet">
<link href="/resources/publish/jact/css/common.css" type="text/css" rel="stylesheet">


<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
<script src="/resources/js/common/common.js"></script>

</head>
<body style='font-family: MalgunGothic;'>
<tiles:insertAttribute name="body"/>
</body>
</html>











