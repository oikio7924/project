<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<%@ taglib prefix="tiles" 	uri="http://tiles.apache.org/tags-tiles" %>
<%@ include file="/WEB-INF/jsp/setting/settingData.jsp"%>

<!DOCTYPE html>
<html lang="${homeData.HM_LANG }">

<script async src="https://www.googletagmanager.com/gtag/js?id=UA-144545189-1"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-144545189-1');
</script>
<head>
<meta charset="utf-8">
<meta name="description" content="">
<meta name="author" content="">

<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- iOS web-app metas : hides Safari UI Components and Changes Status Bar Appearance -->
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
<script src="/resources/js/common/common.js"></script>

<c:if test="${not empty SNSInfo}">
<!-- 페이스북, 밴드, 구글, 카카오스토리 동일 meta -->
<c:if test="${not empty SNSInfo.IMG }">
<meta property="og:image" content="${domain}/resources/img/upload/${SNSInfo.IMG }"> <!-- 이미지 url -->
</c:if>
<c:if test="${empty SNSInfo.IMG }">
<meta property="og:image" content="${domain}/resources/img/sns/jact_link.jpg"> <!-- 이미지 url -->
</c:if>
<meta property="og:title" content="${SNSInfo.TITLE }">  <!-- 제목 -->
<meta property="og:description" content="<c:out value="${SNSInfo.DESC}" escapeXml="true" ></c:out>"> <!-- 내용 -->
<meta property="og:type" content="website">
<meta property="og:url" content="${domain}">
<meta property="og:image:height" content="300">
<meta property="og:image:width" content="400">
<meta property="og:image:type" content="image/jpeg" />
 <!-- 트위터 meta -->
<meta name="twitter:card" content="summary">
<c:if test="${not empty SNSInfo.IMG }">
<meta name="twitter:image" content="${domain}/resources/img/upload/${SNSInfo.IMG }"> <!-- 이미지 url -->
</c:if>
<c:if test="${empty SNSInfo.IMG }">
<meta name="twitter:image" content="${domain}/resources/img/sns/jact_link.jpg"> <!-- 이미지 url -->
</c:if>

<meta name="twitter:title" content="${SNSInfo.TITLE }"> 
<meta name="twitter:description" content="<c:out value="${SNSInfo.DESC}" escapeXml="true" ></c:out>">
</c:if>
<c:if test="${empty SNSInfo}">
<!-- 페이스북, 밴드, 구글, 카카오스토리 동일 meta -->
<meta property="og:image" content="${domain}/resources/img/sns/jact_link.jpg"> <!-- 이미지 url -->
<c:if test="${empty currentMenu}">
<meta property="og:title" content="전남문화재단">  <!-- 제목 -->
</c:if>
<c:if test="${not empty currentMenu}">
<meta property="og:title" content="전남문화재단 ">  <!-- 제목 -->
</c:if>
<meta property="og:type" content="website">
<meta property="og:image:height" content="406">
<meta property="og:image:width" content="209">
<meta property="og:image:type" content="image/jpeg" />
 <!-- 트위터 meta -->
<meta name="twitter:card" content="summary">
<meta name="twitter:image" content="${domain}/resources/img/sns/jact_link.jpg">
<c:if test="${empty currentMenu}">
<meta name="twitter:title" content="전남문화재단"> 
</c:if>
<c:if test="${not empty currentMenu}">
<meta name="twitter:title" content="전남문화재단 - ${currentMenu.MN_NAME }"> 
</c:if>

</c:if>

<title>${homeData.HM_TITLE } 
<c:if test="${not empty currentMenu && not empty currentMenu.MN_MAINKEY}"> - ${currentMenu.MN_NAME }</c:if><c:if test="${not empty SearchKeywordss }"> - ${SearchKeywordss eq 'nosearch'?'전체': SearchKeywordss}</c:if>${currentMenu.MN_NAME  eq '회원가입' || not empty userInfoSetting? '- 회원가입약관':''} ${currentMenu.MN_NAME  eq '회원가입' && empty userInfoSetting ? '- 회원가입등록 ':''}
</title>

<%-- <tiles:insertAttribute name="css"/> --%>
<%-- <tiles:insertAttribute name="script"/> --%>
<meta name="naver-site-verification" content="1674c2c22c64d99f129e94920246b11d51dc88f3" />
</head>
<body>
		
<tiles:insertAttribute name="header"/>
<c:if test="${currentMenu.MN_LEV eq 0 }">
<tiles:insertAttribute name="body"/>
</c:if>

<c:if test="${currentMenu.MN_LEV ne 0 }">
<div id="subContentsWrap_01">
		<tiles:insertAttribute name="subTop"/>
        		<div class="inner1200">
        				<tiles:insertAttribute name="rightTop"/>
        		</div>
        	
            	<tiles:insertAttribute name="body"/>	
            
</div>

</c:if>


<tiles:insertAttribute name="footer"/>

<!-- <div class="loading_box"> -->
<!-- 	<div class="bg"></div> -->
<!-- 	<img src="/resources/img/loading/loading.gif" -->
<!-- 		title="Loading.." alt="로딩중"/> -->
<!-- </div> -->

  
</body>


</html>











