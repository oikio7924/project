<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<div class="subTopWrap">
	<div class="subTopNaviBox clearfix">
    	<div class="naviBox">
        	<ul>
            	<li class="homePlace"><a href="/">HOME</a></li>
            	<c:forEach items="${fn:split(currentMenu.MN_MAINNAMES,',') }" var="model">
            		<li><a href="#">${model }</a></li>
            	</c:forEach>
            </ul>
        </div>
        <div class="snsBox clearfix">
        	<h1>SNS</h1>
            <div class="icon"><button type="button"><img src="/resources/img/icon/icon_snsSubTop_share.png" alt="sns공유버튼"></button></div>
            <ul class="clearfix">
            	<li><button type="button" title="페이스북" onclick="facebook()"><img src="/resources/img/icon/icon_snsSubTop_facebook.png" alt="페이스북"></button></li>
            	<li><button type="button" title="블로그" onclick="cf_blog()"><img src="/resources/img/icon/icon_snsSubTop_blog.png" alt="블로그"></button></li>
            	<li><button type="button" title="트위터" class="snsButton" onclick="twitter()"><img src="/resources/img/icon/icon_snsSubTop_twitter.png" alt="유투브"></button></li>
            	<li><button type="button" title="카톡"  id="kakaoButton" onclick="pf_kakao()"><img src="/resources/img/icon/icon_snsSubTop_kakao.png" alt="유투브"></button></li>
            	<li><button type="button" title="카카오스토리" class="snsButton" onclick="cf_kakaoStroryShare2()"><img src="/resources/img/icon/icon_snsSubTop_kakaostory.png" alt="유투브"></button></li>
            	<li><button type="button" title="링크복사" class="snsButton" id="clipboard"><img src="/resources/img/icon/icon_snsSubTop_clipboard.png" alt="유투브"></button></li>
            </ul>
        </div>
    </div>
</div>
<script> 
window.onload = function(){
    $(document).ready(function(){
    	
        var clipboard = new Clipboard('#clipboard', {
            text: function(trigger) {
                return location.href;
            }
        });
        $('#clipboard').on('click',function(){
        	if(isMobile.iOS()){
        		alert('아이폰에서는 지원하지 않습니다.')
        	}else{
	        	alert('클립보드로 현재 주소('+location.href+')가 복사되었습니다.')
        	}
        })
    });
};

//<![CDATA[
  // // 사용할 앱의 JavaScript 키를 설정해 주세요.
  Kakao.init('eabacb1e3bdc76d1351d4233e18e30ef');
  // // 카카오링크 버튼을 생성합니다. 처음 한번만 호출하면 됩니다.
  function pf_kakao() {
	  
	  var title = '';
	  var desc = '';
	  var image = '';
	  var url = location.href;
	  if('${SNSInfo}'){
		  title = '<c:out value="${SNSInfo.TITLE}" />';
		  desc = '<c:out value="${SNSInfo.DESC}" />';
		  if('${SNSInfo.IMG }'){
			  image = '${domain}/${SNSInfo.IMG }';
		  }else{
			  image = '${domain}/resources/img/sns/gjcf_sns.jpg';  
		  }
		  
	  }else{
		  title = '광주문화재단 - <c:out value="${currentMenu.MN_NAME}" />';
		  desc = '';
		  image = '${domain}/resources/img/sns/gjcf_sns.jpg'; 
	  }
	  
    Kakao.Link.sendDefault({
      objectType: 'feed',
      content: {
          title: title,
          description: desc,
          imageUrl: image,
          link: {
        	  mobileWebUrl: url,
              webUrl: url
          }
        },
      buttons: [
        {
          title: '웹으로 보기',
          link: {
            mobileWebUrl: url,
            webUrl: url
          }
        }
      ]
    });
  }
  
  
  
//]]>

</script>