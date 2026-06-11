<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>
.error {color: red;}
</style>

<form:form id="Form" action="/${tiles }/mypage/info/userUpdate.do" method="post" commandName="ModReqUserDTO">
<input type="hidden" name="tiles" value="${tiles}">
<input type="hidden" name="UI_MAILLING" id="UI_MAILLING" value="${userInfo.UI_MAILLING }">
<input type="hidden" name="PASSWORD_REGEX" id="PASSWORD_REGEX" value="${userInfoSetting.SC_CODEVAL01}">
<div class="idSearchWrap">
      	<p class="smallIntro">
          	* 기본정보 (*는 필수입력사항입니다.)
          </p>
          <div class="contentsBox2 formBox clearfix">
          	
              	<div class="modifyRowBox">
                  	<h1>개인정보 입력</h1>
                  	<ul class="listFormUl">
                  		<li>
                  			<span class="smallParagh">
                                    * <c:out value="${not empty userInfoSetting.SC_CODENM || userInfoSetting.SC_CODENM != null ? userInfoSetting.SC_CODENM  : '영문자, 숫자, 특수문자 중 임의로 8자에서 16자까지 조합' }"/>
                       			<br>* 대소문자를 구분하오니 입력시 대소문자의 상태를 확인 하시기 바랍니다.
                              </span>
                  		</li>
                      <li>
                          <p class="title"><span class="colorR">*</span> <label for="UI_PASSWORD">현재비밀번호</label></p>
                          <p class="formBoxInner">
                              <input type="password" class="txtDefault txtWlong_1" name="UI_PASSWORD" id="UI_PASSWORD">
                              <form:errors path="UI_PASSWORD" cssClass="error"/>
                          </p>
                      </li>
                      <li>
                          <p class="title"><span class="colorR">*</span> <label for="UI_PASSWORD2">새 비밀번호</label></p>
                          <p class="formBoxInner">
                              <input type="password" class="txtDefault txtWlong_1" name="UI_PASSWORD2" id="UI_PASSWORD2">
                              <form:errors path="UI_PASSWORD2" cssClass="error"/>
                          </p>
                      </li>
                      <li>
                          <p class="title"><span class="colorR">*</span> <label for="UI_PASSWORD3">새 비밀번호 확인</label></p>
                          <p class="formBoxInner">
                              <input type="password" class="txtDefault txtWlong_1" name="UI_PASSWORD3" id="UI_PASSWORD3">
                          </p>
                      </li>
                      </ul>
                  </div>
              	<div class="modifyRowBox">
                  	<h1>개인정보 입력</h1>
                  	<ul class="listFormUl">
                      <li>
                          <p class="title"><span class="colorR">*</span> <label for="UI_EMAIL">이메일</label></p>
                          <p class="formBoxInner">
                              <input type="text" class="txtDefault txtWlong_1"  id="UI_EMAIL" value="${userInfo.UI_EMAIL }" disabled="disabled">
                          </p>
                      </li>
                      <li>
                          <p class="title"><span class="colorR">*</span> <label for="UI_NAME">이름</label></p>
                          <p class="formBoxInner">
                              <input type="text" class="txtDefault txtWlong_1" name="UI_NAME" id="UI_NAME" value="${userInfo.UI_NAME }">
                              <form:errors path="UI_NAME" cssClass="error"/>
                          </p>
                      </li>
                       <li>
                          <p class="title"><span class="colorR">*</span> <label for="UI_REP_NAME">기관명 및 별명</label></p>
                          <p class="formBoxInner">
                              <input type="text" class="txtDefault txtWlong_1" name="UI_REP_NAME" id="UI_REP_NAME" value="${userInfo.UI_REP_NAME }">
                              <form:errors path="UI_REP_NAME" cssClass="error"/>
                          </p>
                          <p class="smallParagh mgT5">
	                       	* 화면에 보이길 희망하는 문구 입력(기관명 or 이름)후 선택 . 단, 아이디로 보이길 희망한다면 선택 하지 않아도 무관
	                    </p>
                      </li>
                      </ul>
                  </div>
              	<div class="modifyRowBox">
                  	<h1>기타 개인설정</h1>
                  	<ul class="listFormUl">
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
              </ul>
          </div>
          <div class="btnBox">
          	<button type="submit" class="btn btnBig_02">변경</button>
          	<button type="reset" class="btn btnBig_02">취소</button>
          </div>
</div>
</form:form> 
      
      
<div id="audiocatpch" style="display: none;"></div>
      
      <script>

//화면 호출시 가장 먼저 호출되는 부분 
$(document).ready(function() {
	
	var msg = '${msg}';
	if(msg){
		alert(msg);
	}
	
	changeCaptcha(); //Captcha Image 요청
	
	$("#Form").validate({

        onfocusout : function (element) {

            $(element).valid();

        },
        
        submitHandler: function(form) {        	
           return Membership_update();
          }, 

        rules : {

        	UI_PASSWORD : {required:true, minlength:4, maxlength:16},
        	
        	UI_PASSWORD2 : {required:false, passwordChk:true},

        	UI_PASSWORD3 : {required:false, equalTo:"#UI_PASSWORD2"},

        	UI_NAME : {required:false, minlength:2, maxlength:20},
        	
        	UI_REP_NAME : {required:false, minlength:2, maxlength:20},

        	UI_EMAIL : {required:true, minlength:5, maxlength:50, email:true}
        	
        },

        messages : {

        	UI_PASSWORD : {required:"필수정보를 적어주세요.", minlength:jQuery.validator.format("최소 {0}자 이상"), maxlength:jQuery.validator.format("최대 {0}자 이하")},
        	
        	UI_PASSWORD2 : {passwordChk:"비밀번호 형식이 잘못되었습니다."},

        	UI_PASSWORD3 : {equalTo:"입력한 비밀번호가 서로 일치하지 않습니다."},

        	UI_NAME : {minlength:jQuery.validator.format("최소 {0}자 이상"), maxlength:jQuery.validator.format("최대 {0}자 이하")},
        	
        	UI_REP_NAME : {minlength:jQuery.validator.format("최소 {0}자 이상"), maxlength:jQuery.validator.format("최대 {0}자 이하")},
        	
        	UI_EMAIL : {required:"필수정보를 적어주세요.", minlength:jQuery.validator.format("최소 {0}자 이상"), maxlength:jQuery.validator.format("최대 {0}자 이하"), email:"이메일 형식이 잘못되었습니다."}
        	
        }, 

        invalidHandler : function(form, validator) {

            var errors = validator.numberOfInvalids();

            if( errors ) 

            {
                $("h3 span.ok").html("(유효성 검사 실패)"); 

                alert(validator.errorList[0].message);

                validator.errorList[0].element.focus();

            }

        },
        
        errorPlacement: function(error, element) {
            	if($(element).hasClass('phonesize')){
	              	$(element).parent().find('.errorMessage').html(error)
            	}else{
            		$(element).after(error);
            	}
          }

    });
	
});

//회원정보 수정
function Membership_update(){
	 var state = true;
	 
	 $.ajax({
	        url: '/common/member/update/checkPassword.do',
	        type: 'POST',
	        data: $('#Form').serializeArray(),
	        async: false,  
	        success: function(result) {
	            if(!result){
		           	  alert('비밀번호가 잘못되었습니다.')
		           	  $('#UI_PASSWORD').focus();
		           	  state = false;
	             }	       },
	       error :function(){
	    	   alert('에러! 관리자한테 문의하세요');
	    	   state = false;
	       }
	  });
	 if(!state){
		 return state;
	 }
	 
	 $.ajax({
        url: '/common/member/update/checkIdEmailAjax.do',
        type: 'POST',
        data: $('#Form').serializeArray(),
        async: false,  
        success: function(result) {
            if(result == 'nameFilter'){
	           	  alert('사용할수없는 이름입니다. 다른 이름을 입력하여주세요.')
	           	  $('#UI_NAME').focus();
	           	  state = false;
             }else if(result == 'nickFilter'){
	           	  alert('사용할수없는 별명입니다. 다른 별명을 입력하여주세요.')
	           	  $('#UI_NICKNAME').focus();
	           	  state = false;
             }
       },
       error :function(){
    	   alert('에러!! 관리자한테 문의하세요');
    	   state = false;
       }
  });
	 if(!state){
		 return state;
	 }
	if ( !$('#stopJoin').val() ) {
        alert('이미지에 보이는 숫자 또는 스피커를 통해 들리는 숫자를 입력해 주세요.');
        return false;
   }
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
        },
       error :function(){
    	   alert('에러!!! 관리자한테 문의하세요');
    	   state = false;
       }
   });
   
  return state;
}
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



</script>