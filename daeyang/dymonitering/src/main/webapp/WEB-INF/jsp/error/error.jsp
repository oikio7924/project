<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">
<title>에러</title>
<link rel="shortcut icon" href="/resources/favicon.ico" type="image/x-icon">
<link rel="icon" href="/resources/favicon.ico" type="image/x-icon">

<style>
.errorBox_wrap {margin:30px auto; background-color:#fff; border:5px solid #ddd; padding:20px 20px; text-align:center;}
.errorBox_wrap .imgBox {margin:20px 0 30px;}
.errorBox_wrap .imgBox img {width:150px;}
.errorBox_wrap .letterBox h1 {font-size:25px; color:#333; font-weight:600;}
.errorBox_wrap .letterBox h2 {font-size:18px; color:#777; font-weight:400; margin:20px 0;}
.errorBox_wrap .letterBox p {font-size:14px; color:#888; font-weight:300;}
.errorBox_wrap .btnBox {margin:25px 0;}
.btnErrorBack {font-size:14px; font-weight:400; padding:8px 15px;}
@media all and (max-width:1000px){	

	.errorBox_wrap .letterBox h1 {font-size:15px;}
	.errorBox_wrap .letterBox h2 {font-size:12px;}
	.errorBox_wrap .letterBox p {font-size:10px; }
	.btnErrorBack {font-size:10px;}
}

</style>


</head>

<body>
   	<div class="subWrap">
        <div class="sub_contentBox">
            	<div class="errorBox_wrap">
                	<div class="errorBox">
                        <div class="letterBox">
                        	<h1>죄송합니다.<br>요청하신 페이지를 찾을 수 없습니다.</h1>
                            <h2>페이지의 URL이나 이름이 변경되었거나 일시적으로 사용할 수 없습니다.</h2>
                            <p>주소가 정확하다면 브라우저의 '새로 고침(reload)'버튼을 눌러 확인하시거나, 잠시후에 다시 접속을 시도해 주십시오.</p>
                        </div>
                        <div class="btnBox">
                        	<c:if test="${empty tiles }">
                        		<a href="javascript:;" class="btn btnBlack btnErrorBack" onclick="location.href='/'">메인화면</a>
                        	</c:if>
                        	<c:if test="${not empty tiles}">
	                        	<a href="javascript:;" class="btn btnBlack btnErrorBack" onclick="location.href='/${tiles}/index.do'">메인화면</a>
                        	</c:if>
                        </div>
                    </div>
                </div>
        </div> 
    </div>
</body>
</html>
