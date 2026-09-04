<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
 
<!-- 네이버 -->
<script type="text/javascript" src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.0.js" charset="utf-8"></script>
<!-- 카카오 -->
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<!-- 페이스북 -->
 <script async defer crossorigin="anonymous" src="https://connect.facebook.net/ko_KR/sdk.js#xfbml=1&version=v5.0&appId=${SiteManager.SNSLOGIN_FACEBOOK_APPID}&autoLogAppEvents=1"></script>
<div class="idSearchWrap">
	<p class="smallIntro">
    	* 회원탈퇴시 아래 내용을 먼저 확인해주세요. 회원탈퇴는 신청 즉시 처리되며, 로그인이 필요한 서비스는 더이상 이용할 수 없게 됩니다.
    </p>
    <form:form id="Form" method="post">
    <div class="dummyInput" style="position:absolute;">
	    <input style="visibility: hidden;" type="text">
	    <input style="visibility: hidden;" type="password">
	    <input type="hidden" id="TOKEN" name ="TOKEN">
    </div>
    
    <div class="formBox clearfix">
    	<ul class="listFormUl">
        	<li>
            	<p class="title"><span class="colorR">*</span> <label for="UI_PASSWORD"> SNS계정 회원 탈퇴</label></p>
                <p class="formBoxInner">
                	<c:choose>
						<c:when test="${userInfo.UI_SNS_TYPE eq 'naver'}">
						<img src="/resources/img/icon/icon_sns01_naver.png" alt="네이버 로그인" style="width: 30px; vertical-align: middle;"> 네이버 아이디 사용자입니다. 
						</c:when >
						<c:when test="${userInfo.UI_SNS_TYPE eq 'kakao'}">
						<img src="/resources/img/icon/icon_main_sns_kakao.png" alt="카카오 로그인" style="width: 30px; vertical-align: middle;"> 카카오 아이디 사용자입니다.
						</c:when>
						<c:otherwise>
						<img src="/resources/img/icon/icon_sns01_facebook.png" alt="페이스북 로그인" style="width: 30px; vertical-align: middle;"> 페이스북 아이디 사용자입니다.
						</c:otherwise>
						
					</c:choose>
                </p>
            </li>
        	<li>
            	<p class="title"><span class="colorR">*</span> <label for="UW_DEL_REASON">탈퇴사유</label></p>
                <p class="formBoxInner">
                	<select class="txtDefault txtWlong_1" name="UW_DEL_REASON" id="UW_DEL_REASON">
                    	<option value="">선택</option>
                    	<c:forEach items="${sp:getCodeList('AQ') }" var="model" varStatus="status">
                    		<c:if test="${status.count ne 1 }">
	                    	<option value="${model.SC_KEYNO }">${model.SC_CODENM }</option>
	                    	</c:if>
                    	</c:forEach>
                    </select>
                </p>
            </li>
        	<li>
            	<p class="title"><span class="colorR">*</span> <label for="stopSearch_01">자동등록방지</label></p>
                <div class="formBoxInner">
                	<div class="txtDefault" id="catpcha" style="float:left;padding:0;"></div>
                	<button type="button" class="btn btnReward" style="float:left;"  onclick="changeCaptcha();">새로고침</button>
              		<button type="button" class="btn btn_autoUpload mgR15" onclick="audioCaptcha();">
              			<img src="/resources/img/icon/icon_speak_01.png" alt="자동등록방지">
              		</button>
                    <input type="text" class="txtDefault txtWshort_230" id="stopJoin" placeholder="자동등록방지 숫자 입력">
                </div>
            </li>
        </ul>
    </div>
    <div class="btnBox">
    	<button type="button" class="btn btnBig_02" onclick="pf_withdraw();">탈퇴</button>
    </div>
    </form:form>
</div>


<div id="audiocatpch" style="display: none;"></div>

<script>

//화면 호출시 가장 먼저 호출되는 부분 
$(document).ready(function() {
	changeCaptcha(); //Captcha Image 요청
	
		var naver_clientid = '${SiteManager.SNSLOGIN_NAVER_CLIENT_ID}'
		var kakao_jskey = '${SiteManager.SNSLOGIN_KAKAO_JSKEY}'
		var facebook_appid = '${SiteManager.SNSLOGIN_FACEBOOK_APPID}'
	
			// 네이버 아이디 연동 
			var naverLogin = new naver.LoginWithNaverId(
										{
											clientId : naver_clientid,  /* 개발자센터에 등록한 ClientID 실섭 */
											/* clientId : "V5mR6UeCjAUvNOMkdr5C", */ /* 개발자센터에 등록한 ClientID  local*/
											callbackUrl : location_origin+"/${currentTiles}/naver/callback.do", // 네이버 콜백 유알엘
											isPopup: true,
											callbackHandle: true
					
											
										/* 로그인 버튼의 타입을 지정 */
										});
			
			
									window.addEventListener('load', function () {
										naverLogin.getLoginStatus(function (status) {
											if (status) {
												/* (5) 필수적으로 받아야하는 프로필 정보가 있다면 callback처리 시점에 체크 */

//		 									 	 
											 	sns_out_url = naverLogin.accessToken; 
											 	$("#TOKEN").val(sns_out_url);
												
												
											} else {
												console.log("callback 처리에 실패하였습니다.");
											}
										});
									});
	
});




/* 
 * Captcha Image 요청
 * [주의] IE의 경우 CaptChaImg.jsp 호출시 매번 변하는 임의의 값(의미없는 값)을 파라미터로 전달하지 않으면
 * '새로고침'버튼을 클릭해도 CaptChaImg.jsp가 호출되지 않는다. 즉, 이미지가 변경되지 않는 문제가 발생한다. 
 *  그러나 크롭의 경우에는 파라미터 전달 없이도 정상 호출된다.
 */
function changeCaptcha() {
 //IE에서 '새로고침'버튼을 클릭시 CaptChaImg.jsp가 호출되지 않는 문제를 해결하기 위해 "?rand='+ Math.random()" 추가 
	 $('#catpcha').html('<img style="height:32px;" src="/common/captcha/img.do?rand='+ Math.random()+'" alt="자동등록방지"/>');
}



function winPlayer(objUrl) {
 $('#audiocatpch').html(' <bgsound src="' + objUrl + '">');
}

/* 
 * Captcha Audio 요청
 * [주의] IE의 경우 CaptChaAudio.jsp 호출시 매번 매번 변하는 임의의 값(의미없는 값)을 파라미터로 전달하지 않으면
 * '새로고침'된 이미지의 문자열을 읽지 못하고 최초 화면 로드시 로딩된 이미지의 문자열만 읽는 문제가 발생한다. 
 * 이 문제의 원인도 결국 매번 변하는 파라미터 없이는 CaptChaAudio.jsp가 호출되지 않기 때문이다. 
 * 그러나 크롭의 경우에는 파라미터 전달 없이도 정상 호출된다.  
 */


/* 
 function audioCaptcha() {

   var uAgent = navigator.userAgent;
   var soundUrl = '/common/captcha/audio.do?lan=kor';
   if (uAgent.indexOf('Trident') > -1 || uAgent.indexOf('MSIE') > -1) {
       //IE일 경우 호출
       winPlayer(soundUrl+'&agent=msie&rand='+ Math.random());
   } else if (!!document.createElement('audio').canPlayType) {
       //Chrome일 경우 호출
       try { new Audio(soundUrl).play(); } catch(e) { winPlayer(soundUrl); }
   } else window.open(soundUrl, '', 'width=1,height=1');
 }
*/

 function audioCaptcha() {

   var agent = navigator.userAgent.toLowerCase(); // 브라우져 종류 확인
   var soundUrl = '/common/captcha/audio.do?lan=kor';
   if((navigator.appName == 'Netscape' && agent.indexOf('trident') != -1) || (agent.indexOf("msie") != -1)){  
       //IE일 경우 호출(IE의 경우, wav 파일을 읽기 위해서 동적으로 bgsound를 호출해야 하기 때문에 일부러 지우고 재생성)
       var origPlayer = document.getElementById('audiocatpch');
       if (origPlayer) {
           origPlayer.src = '';
           origPlayer.outerHtml = '';
           document.body.removeChild(origPlayer);
           delete origPlayer;
       }
       var newPlayer = document.createElement('bgsound');
       newPlayer.setAttribute('src', soundUrl+'&agent=msie&rand='+ Math.random());
       document.body.appendChild(newPlayer);	
   } else if (!!document.createElement('audio').canPlayType) {
       //Chrome일 경우 호출
       try { new Audio(soundUrl).play(); } catch(e) { winPlayer(soundUrl); }
   } else window.open(soundUrl, '', 'width=1,height=1');
 }



function pf_withdraw(){
	var kakao_jskey = '${SiteManager.SNSLOGIN_KAKAO_JSKEY}'
	var facebook_appid = '${SiteManager.SNSLOGIN_FACEBOOK_APPID}'
	
	
	if(!$('#UW_DEL_REASON').val()){
		alert('탈퇴사유를 선택하여주세요.')
		$('#UW_DEL_REASON').focus()
		return false;
	}
	
	
	 if ( !$('#stopJoin').val() ) {
         alert('이미지에 보이는 숫자 또는 스피커를 통해 들리는 숫자를 입력해 주세요.');
         return false;
    }
	
	 
	var state = true;
    $.ajax({
          url: '/common/captcha/submit.do',
          type: 'POST',
          data: 'answer=' + $('#stopJoin').val(),
          async: false,  
          success: function(resp) {
               if(!resp){
            	   alert('입력하신 값이 일치하지 않습니다. 다시 확인하여주세요.')
            	   state = false;
               }
               changeCaptcha();
               $('#stopJoin').val('');
         }
    });
    
    if(!state){
    	return false;
    }
    cf_loading();
    var token =  $('#TOKEN').val();
    var sns_type = "${userInfo.UI_SNS_TYPE}"
    $.ajax({
        url: '/${currentTiles}/mypage/withdraw/action.do',
        type: 'POST',
        data: {
        	'UW_DEL_REASON' : $('#UW_DEL_REASON').val(),
   			'SNS_OUT_URL' : token 
        },
        async: false,  
        success: function(result) {
             if(result){
            	 if(sns_type == 'kakao'){
            		 Kakao.init(kakao_jskey);
            		       Kakao.API.request({
            		        url: '/v1/user/unlink'
            		});
            	 }
            	 if(sns_type == 'facebook'){
            		
						FB.getLoginStatus(function(response) {
							  if (response.status === 'connected') {
							    var accessToken = response.authResponse.accessToken;
							  
							  } 
							} );
						
						
						
			
            	 }
            	 
            	 
            	 
            	 
            	 
            	 
            	 alert('회원탈퇴처리 되었습니다.')
            	 
            	 
            	 location.href="/user/logout.do";
             }else{
            	 alert('비밀번호를 확인하여주세요.')
             }
       }
   }).done(function(){
	   cf_loading_out();
   });
    
    
    
}





</script>


