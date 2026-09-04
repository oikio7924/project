<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<%@ taglib prefix="tiles" 	uri="http://tiles.apache.org/tags-tiles" %>

<meta charset="utf-8">
<meta name="description" content="<c:out value="${empty SNSInfo.description ? SNSInfo.DESC : SNSInfo.description }" escapeXml="true" ></c:out>">
<meta name="keywords" content="${SNSInfo.keywords }">
<meta name="author" content="">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- iOS web-app metas : hides Safari UI Components and Changes Status Bar Appearance -->
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>

<!-- 페이스북, 밴드, 구글, 카카오스토리 동일 meta -->
<meta property="og:image" content="${SNSInfo.IMG }"> <!-- 이미지 url -->
<meta property="og:title" content="${SNSInfo.TITLE }">  <!-- 제목 -->
<meta property="og:type" content="website">
<meta property="og:description" content="<c:out value="${SNSInfo.DESC}" escapeXml="true" ></c:out>"> <!-- 내용 -->
<meta property="og:image:width" content="${SNSInfo.IMG_WIDTH }">
<meta property="og:image:height" content="${SNSInfo.IMG_HEIGHT }">
<meta property="og:image:type" content="image/jpeg" />
 <!-- 트위터 meta -->
<meta name="twitter:card" content="summary">
<meta name="twitter:image" content="${SNSInfo.IMG }"> <!-- 이미지 url -->
<meta name="twitter:title" content="${SNSInfo.TITLE }"> 
<meta name="twitter:description" content="<c:out value="${SNSInfo.DESC}" escapeXml="true" ></c:out>">

<title><c:out value="${SNSInfo.TITLE}" escapeXml="true" ></c:out></title>

<!--[if lt IE 9]>
<script>
//IE8 이하 브라우저 업그레이드 권고
alert("브라우저의 버전이 너무 낮습니다.\n보안을 위해 브라우저의 버전을 업그레이드 해야합니다.");
location.href="/no_IELess9.jsp";
</script>
<![endif]-->


