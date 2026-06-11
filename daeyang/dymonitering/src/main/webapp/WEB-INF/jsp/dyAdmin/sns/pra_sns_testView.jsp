<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>

<%-- <c:if test="${not empty SNSInfo}"> --%>
<!-- 페이스북, 밴드, 구글, 카카오스토리 동일 meta -->
<meta property="og:image" content="https://www.acc.go.kr/resources/upload/247/5928zw22zqew46e.jpg"> <!-- 이미지 url -->
<meta property="og:title" content="title">  <!-- 제목 -->
<meta property="og:type" content="website">
<meta property="og:description" content="content"> <!-- 내용 -->
<meta property="og:image:height" content="300">
<meta property="og:image:width" content="400">
<meta property="og:image:type" content="image/jpeg" />
 <!-- 트위터 meta -->
<!-- <meta name="twitter:card" content="summary"> -->
<%-- <meta name="twitter:image" content="http://acc.go.kr/resources/upload/${SNSInfo.IMG }"> --%>
<%-- <meta name="twitter:title" content="${SNSInfo.TITLE }">  --%>
<%-- <meta name="twitter:description" content="${SNSInfo.DESC }"> --%>
<%-- </c:if> --%>

<title>Insert title here</title>
<style type="text/css">

.div_cont{width:800px; height: 300px; background-color: #212121; padding: 20px;}
.div_img{width: 40%; float: left;}
.div_content{width: 60%; float: left;}
.title{width: 100%; margin-top: 10px;}
.cont{width: 100%; margin-top: 15px;}
.snsIconbox li{list-style-type: none; float: left; margin: 10px;}
.snsIconbox li img{width: 50px; height: 50px;}

</style>
</head>
<body>

<div class="warp">
	<div class="div_cont">
		<div class="div_img">
		<img alt="img" src="/resources/img/upload/1/02ylz9a379c5b58.jpg">
		</div>
		<div class="div_content">
		<input type="text" name="title" id="title" class="title" value="제목제목"><br>
		<textarea rows="5" cols="5" name="cont" id="cont" class="cont">내용내용내용</textarea>
		</div>
			<div class="snsIconbox">
				<ul class="detailView_right_contents_sns_ul clearfix">
					<li>
						<img onclick="facebook()" src="/resources/img/sns/sns_01fb.png" alt="facebook">
					</li>
					<li>
						<img onclick="twitter()" src="/resources/img/sns/sns_02twit.png" alt="twitter">
					</li>
					<li class="bandShareBtn">
						<img onclick="band()" src="/resources/img/sns/sns_03band.png" alt="band">
					</li>
					<li>
						<img onclick="cf_kakaoStroryShare2()" src="/resources/img/sns/sns_04kaka.png" alt="kakao"></a>
					</li>               
					<li>
						<img onclick="google()" src="/resources/img/sns/sns_05googleplus.png" alt="google">
					</li>
				</ul>	
				
			<div class="clear"></div>
		</div>
		
	</div>
</div>

</body>
<!-- 카카오톡 -->
<script src="/resources/common/js/sns/kakao.min.js"></script>
<!-- 구글플러스 -->
<script src="https://apis.google.com/js/platform.js" async defer>{lang: 'ko'}</script>

<script type="text/javascript">
var snsDesc = $('#cont').val();
//=======================공유==========================
//페이스북
function facebook(){
	var url = encodeURIComponent(document.URL); 
	window.open("http://www.facebook.com/share.php?u=" + url);
}
//트위터
function twitter(){
	var url = encodeURIComponent(document.URL);
	window.open("https://twitter.com/intent/tweet?text=\'"+snsDesc+"'\&url="+url); // text 파라미터 삭제함
}
//밴드
function band(){
	var url = encodeURIComponent(document.URL);
	// window.open("http://band.us/plugin/share?route=" + url + "&body=" + url); // body 파라미터 삭제함
	window.open("http://band.us/plugin/share?body=" + encodeURIComponent(snsDesc) +"&route=" + url);
}
//구글+
function google(){
	var url = encodeURIComponent(document.URL);
	window.open("https://plus.google.com/share?url=https://www.acc.go.kr/");
}

//카카오스토리
function cf_kakaoStroryShare2() {
	var url = document.URL;
	Kakao.Story.share({  
	    url: url,  
// 	    text: '${SNSInfo.TITLE }'
	    text: 'text'
	});
}

//카카오스토리 연동
window.onload=function(){
	  Kakao.init('ad39f96ab5a2f393088ed7c42106e2be'); 
	  
	  Kakao.Link.createTalkLinkButton({
	      container: '#kakaoLinkBtn',
// 	      label: '${SNSInfo.TITLE }',
	      label: 'title',
	      image: {
// 	        src: 'https://acc.go.kr/resources/upload/${SNSInfo.IMG }',
	        src: 'https://www.acc.go.kr/resources/upload/247/5928zw22zqew46e.jpg',
	        width: '300',
	        height: '200'
	      },
	      webButton: {
	        text: '링크 바로가기',
	        url: document.URL 
	      }
	    });  
}

</script>
</html>