<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<div class="idSearchWrap">
	<p class="smallIntro">
    	* 회원탈퇴시 아래 내용을 먼저 확인해주세요. 회원탈퇴는 신청 즉시 처리되며, 로그인이 필요한 서비스는 더이상 이용할 수 없게 됩니다.
    </p>
    <form:form id="Form" method="post">
    <div class="dummyInput" style="position:absolute;">
	    <input style="visibility: hidden;" type="text">
	    <input style="visibility: hidden;" type="password">
    </div>
    
    <div class="formBox clearfix">
    	<ul class="listFormUl">
        	<li>
            	<p class="title"><span class="colorR">*</span> <label for="UI_PASSWORD">비밀번호</label></p>
                <p class="formBoxInner">
                	<input type="password" class="txtDefault txtWlong_1" name="UI_PASSWORD" id="UI_PASSWORD" maxlength="30">
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
	
	
	if(!$('#UI_PASSWORD').val()){
		alert('비밀번호를 입력하여주세요.')
		$('#UI_PASSWORD').focus()
		return false;
	}
	
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
    $.ajax({
        url: '/dy/mypage/withdraw/action.do',
        type: 'POST',
        data: {
        	'UI_PASSWORD' : $('#UI_PASSWORD').val(),
        	'UW_DEL_REASON' : $('#UW_DEL_REASON').val()
        },
        async: false,  
        success: function(result) {
             if(result){
            	 alert('회원탈퇴처리 되었습니다.')
            	 location.href="/dy/logout.do";
             }else{
            	 alert('비밀번호를 확인하여주세요.')
             }
       }
   }).done(function(){
	   cf_loading_out();
   });
    
    
    
}





</script>


