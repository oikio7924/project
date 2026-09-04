<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<form:form id="Form" action="/${tiles }/mypage/info/update.do" method="post">
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
                          <p class="title"><span class="colorR">*</span> <label for="">SNS 아이디 </label></p>
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
                          <p class="title"><span class="colorR">*</span> <label for="UI_EMAIL">이메일</label></p>
                          <p class="formBoxInner">
                              <input type="text" class="txtDefault txtWlong_1"  id="UI_EMAIL" value="${userInfo.UI_EMAIL }" disabled="disabled">
                          </p>
                      </li>
                      <li>
                          <p class="title"><span class="colorR">*</span> <label for="UI_NAME">이름</label></p>
                          <p class="formBoxInner">
                              <input type="text" class="txtDefault txtWlong_1" name="UI_NAME" id="UI_NAME" value="${userInfo.UI_NAME }">
                          </p>
                      </li>
                       <li>
                          <p class="title"><span class="colorR">*</span> <label for="UI_REP_NAME">기관명 및 별명</label></p>
                          <p class="formBoxInner">
                              <input type="text" class="txtDefault txtWlong_1" name="UI_REP_NAME" id="UI_REP_NAME" value="${userInfo.UI_REP_NAME }">
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
      
      var ui_sns_id = "${empty userInfo.UI_SNS_ID} ";

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

        

        	UI_NAME : {required:false, minlength:2, maxlength:20},
        	
        	UI_REP_NAME : {required:false, minlength:2, maxlength:20},

        	UI_EMAIL : {required:true, minlength:5, maxlength:50, email:true}
        	
        },

        messages : {

        

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