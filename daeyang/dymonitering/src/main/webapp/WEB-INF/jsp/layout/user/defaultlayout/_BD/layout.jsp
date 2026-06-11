<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<%@ taglib prefix="tiles" 	uri="http://tiles.apache.org/tags-tiles" %>
<!DOCTYPE html>
<html lang="${homeData.HM_LANG }">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">

    <title>사업개발부 일정관리</title>
    <meta name="description" content="대양기업 사업개발부 일정관리 프로그램입니다.">
    <meta property="og:title" content="사업개발부 일정관리 ">
    <meta property="og:description" content="대양기업 사업개발부 일정관리 프로그램입니다.">
    <meta property="og:locale" content="kr">
    <meta property="og:site_name" content="DAEYANG">

    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <link rel="stylesheet" type="text/css" href="/resources/publish/_BD/css/common.css">
    <link rel="stylesheet" type="text/css" href="/resources/publish/_BD/css/mobile.css">

    <script src="https://code.jquery.com/jquery-3.5.0.js"></script>
    <!-- ✅ load jQuery ✅ -->

<script
  src="https://code.jquery.com/jquery-3.6.0.min.js"
  integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
  crossorigin="anonymous"
></script>
<script type="text/javascript" src="/resources/publish/_BD/js/common.js"></script>
<!-- ✅ load jquery UI ✅ -->
<script
  src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"
  integrity="sha512-uto9mlQzrs59VwILcLiRYeLKPPbS/bT71da/OEBYEwcdNUk8jYIy+D176RYoop1Da+f9mvkYrmj5MCLZWEtQuA=="
  crossorigin="anonymous"
  referrerpolicy="no-referrer"></script>
  
<style type="text/css" >
.wrap-loading {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.7);
            z-index: 1000;
            text-align: center;
            color: white;
            font-size: 24px;
            line-height: 100vh; /* 세로 중앙 정렬을 위해 사용 */
}

.display-none {
    display: none; !important
}
.wrap-loading div{ /*로딩 이미지*/
    position: fixed;
    top:50%;
    left:50%;
    margin-left: -21px;
    margin-top: -21px;
} 
</style>
</head>
<body>
   	  <div>
	   	<div class="wrap-loading display-none">
	    	<div><img src="/resources/img/loading/loading.gif" /></div>
		</div>
   	  	<div class="flex bg-gray-50 false">	
	   	 	<tiles:insertAttribute name="leftmenu" />			   	 	
	   	 	<div class="flex flex-col flex-1 w-full">
<%-- 		   	 	<tiles:insertAttribute name="header" /> --%>
				<tiles:insertAttribute name="header" />
	       	 	<tiles:insertAttribute name="body" />
       	 	</div>
      	 	</div>
     	</div> 
</body>

</html>