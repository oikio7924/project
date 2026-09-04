<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
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
<link href="/resources/css/common.css" type="text/css" rel="stylesheet">


<style>
.errorBox_wrap {margin:30px auto; background-color:#fff; width:100%; border:5px solid #ddd; padding:20px 20px; text-align:center;}
.errorBox_wrap .imgBox {margin:20px 0 30px;}
.errorBox_wrap .imgBox img {width:150px;}
.errorBox_wrap .letterBox h1 {font-size:25px; color:#333; font-weight:600;}
.errorBox_wrap .letterBox h2 {font-size:18px; color:#777; font-weight:400; margin:20px 0;}
.errorBox_wrap .letterBox p {font-size:14px; color:#888; font-weight:300;}
.errorBox_wrap .btnBox {margin:25px 0;}
.btnErrorBack {font-size:14px; font-weight:400; padding:8px 15px;}


</style>


</head>

<body>
   
    
    
    <!------------------------------------------------------------------------
    		 SubContents START       
	------------------------------------------------------------------------->
    <div class="subWrap">
        
        <!------------------- 서브컨텐츠 시작 ---------------------------->
        <div class="sub_contentBox">
        	<!---------------------------------------------------
               ** 에러페이지 시작
            ----------------------------------------------------->
            	<div class="errorBox_wrap">
                	<div class="errorBox">
                        <div class="letterBox">
                        	<h1>죄송합니다.<br>해당 게시물은 비밀글입니다.</h1>
                            <h2>비밀글은 본인과 관리자만 확인할수있습니다.</h2>
                        </div>
                        <div class="btnBox">
                        	<a href="javascript:;" class="btn btnBlack btnErrorBack" onclick="location.href='/'">메인화면</a>
                        	<c:if test="${empty userInfo }">
                        	<a href="javascript:;" class="btn btnBlack btnErrorBack" onclick="cf_login()">로그인</a>
                        	</c:if>
                        </div>
                    </div>
                </div>
            
            
        	<!---------------------------------------------------
               ** 에러페이지 종료
            ----------------------------------------------------->
        
            
        </div> 
    </div>
    <!------------------------------------------------------------------------
    		 SubContents START       
	-------------------------------------------------------------------------> 
   
         
</body>
</html>
