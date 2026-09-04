<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<script src="/resources/api/mask/jquery.mask.js"></script>
<script type="text/javascript" src="/resources/common/js/validation/jquery.validate.js"></script>
<style>
.error {color: red;}
</style>

<form:form id="Form" action="/${tiles}/member/regist/result.do" method="post" commandName="JoinReqUserDTO">
<input type="hidden" name="tiles" id="tiles" value="${tiles}">
<input type="hidden" name="UI_ZENDER" id="UI_ZENDER" value="">
<input type="hidden" name="PASSWORD_REGEX" id="PASSWORD_REGEX" value="${userInfoSetting.SC_CODEVAL01}">
<div class="J_Wapper_inner">
	
	<div class="Join_T_title">
		<h1>회원가입</h1>
	</div>    
	
	<!--main_1 이용정보 입력 시작-->
	<div class="Main_01_title">
		<ul class="J_subTitle_01">
			<li>이용정보 입력</li>
			<li><span class="red_Star">*</span> 필수입력항목</li>
		</ul>
	</div>
	                   
    <div class="main_Information">
			<div class="m_user_id_wrap">
				<div class="main_user_id">
					<h1>아이디<span class="red_Star"> *</span></h1>
				</div>

				<label for="UI_ID"><input type="text" autocomplete="off" placeholder="아이디(이메일)를 입력해주세요." id="UI_ID" name="UI_ID" maxlength="16" value="${JoinReqUserDTO.UI_ID }"></label>
				<!-- <button type="button" id="J_btn_01">이메일 인증</button> -->
				<form:errors path="UI_ID" cssClass="error"/>
				<p>영문자,숫자,_만 가능.최소 3자 이상 입력하세요.</p>
			</div>

			<div class="m_user_pw_wrap">
				<div class="main_user_password">
					<h1>비밀번호<span class="red_Star"> *</span></h1>
				</div>
				
				<label for="UI_PASSWORD"><input type="password" autocomplete="off" placeholder="비밀번호를 입력해주세요." id="UI_PASSWORD" name="UI_PASSWORD" maxlength="25" value="${JoinReqUserDTO.UI_PASSWORD }"></label>
				<form:errors path="UI_PASSWORD" cssClass="error"/>
			</div>
			<div class="m_pw_confirm_wrap">
				<div class="main_user_pw_Confirm">
					<h1>비밀번호 확인<span class="red_Star"> *</span></h1>
				</div>
				
				<label for="UI_PASSWORD2"><input type="password" autocomplete="off" placeholder="비밀번호를 확인하여 입력해주세요." id="UI_PASSWORD2" maxlength="25" name="UI_PASSWORD2"></label>
			</div>
		</div>
		<!--main_1 이용정보 입력 끝-->

		<!--main_2 이용정보 입력 시작-->
		<div class="Main_02_title">
				<h1>개인정보입력</h1>
		</div>



		<div class="main_Privacy">
			<div class="m_user_name_wrap">
				<div class="main_user_name">
					<h1>이름<span class="red_Star"> *</span></h1>
				</div>

				<label for="UI_NAME"><input type="text" autocomplete="off" placeholder="이름을 입력해주세요." id="UI_NAME" name="UI_NAME" maxlength="25" value="${JoinReqUserDTO.UI_NAME }"></label>
				<form:errors path="UI_NAME" cssClass="error"/>
			</div>

			<div class="m_user_email_wrap">
				<div class="main_user_email">
					<h1>E_Mail</h1>
				</div>
				
				<label for="UI_EMAIL"><input type="text" autocomplete="off" placeholder="E-Mail을  입력해주세요." id="UI_EMAIL" name="UI_EMAIL" maxlength="50" ></label>
			</div>
			<div class="m_user_phone_wrap">
				<div class="main_user_phone">
					<h1>휴대폰번호</h1>
				</div>
				
				<label for="UI_PHONE"><input type="text" autocomplete="off" placeholder="휴대폰번호를 입력해주세요." id="UI_PHONE" name="UI_PHONE" placeholder="000-0000-0000" onkeyup="pf_autoHypenPhone(this,this.value)" maxlength="13" ></label>
			</div>
		</div>
		<!--main_2 이용정보 입력 끝-->
		
		<!--main_3 자동등록방지 시작-->
		<div class="Main_03_title">
				<h1>자동등록방지</h1>
		</div>

		<div class="m_user_auto_wrap">
				<div class="main_auto">
					<h1>자동등록방지<span class="red_Star"> *</span></h1>
				</div>
				<div id="number_01">
					<div id="catpcha" style="float:left;padding:0;"></div>
					<div class="auto_sound_wrap">
						<button type="button" onclick="changeCaptcha();"><img src="/resources/img/icon/auto_arrow_icon.jpg" alt="재시도 아이콘"></button>
						<button type="button" onclick="audioCaptcha();"><img src="/resources/img/icon/sound_icon.jpg" alt="스피커  아이콘"></button>
					</div>
				</div>
				<label for="number_02"><input type="text" id="stopJoin" autocomplete="off" placeholder=""> </label>
				<p>자동등록방지 숫자를 순서대로 입력하여 주세요.</p>
		</div>
		<!--main_3 자동등록방지 끝-->

		<!--footer 시작-->
		<div class="footer_btn">
			<button type="button" id="join_cancel_btn" onclick="location.href='/user/member/login.do?tiles=cf'">가입취소</button>
			<button type="submit" id="join_ok_btn">가입하기</button>
		</div>
	
</div>	
 </form:form>
 
 
 
 <script>
 
//화면 호출시 가장 먼저 호출되는 부분 
 $(document).ready(function() {
 	
	 changeCaptcha(); //Captcha Image 요청
 	
 	$("#Form").validate({

         onfocusout : function (element) {

             $(element).valid();

         },
         
         submitHandler: function(form) {   
        	
            return Membership_save();
           }, 

         rules : {

         	UI_ID : {required:true, minlength:4, maxlength:16, loginID:true, dupleCheck:true},
         	
			UI_PASSWORD : {required:true, passwordChk:true},

         	UI_PASSWORD2 : {required:true, equalTo:"#UI_PASSWORD"},

         	UI_NAME : {required:true, minlength:2, maxlength:20,forbiddenWordCheck:true},

         	UI_EMAIL : {required:false, minlength:5, maxlength:50, email:true}
         	
         },

         messages : {

         	UI_ID : {required:"필수정보를 적어주세요.", minlength:jQuery.validator.format("최소 {0}자 이상"), maxlength:jQuery.validator.format("최대 {0}자 이하"), loginID:"아이디 형식이 잘못되었습니다.", dupleCheck:"이미 존재하거나 사용할 수 없는 아이디 입니다."},

         	UI_PASSWORD : {required:"필수정보를 적어주세요.", passwordChk:"비밀번호 형식이 잘못되었습니다."},

         	UI_PASSWORD2 : {required:"필수정보를 적어주세요.", equalTo:"입력한 비밀번호가 서로 일치하지 않습니다."},

         	UI_NAME : { minlength:jQuery.validator.format("최소 {0}자 이상"), maxlength:jQuery.validator.format("최대 {0}자 이하"),forbiddenWordCheck:"사용할 수 없는 이름입니다."},
         
         	UI_EMAIL : { minlength:jQuery.validator.format("최소 {0}자 이상"), maxlength:jQuery.validator.format("최대 {0}자 이하"), email:"이메일 형식이 잘못되었습니다."}
         	
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
 
 //회원가입
 function Membership_save(){
	 
 	
	 var state = true;
	 
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
	 $('#catpcha').html('<img style="height:46px;" src="/common/captcha/img.do?rand='+ Math.random()+'" alt="자동등록방지"/>');
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


//휴대폰번호
function pf_autoHypenPhone(obj,str){
   str = str.replace(/[^0-9]/g, '');
   var tmp = '';
   if(str.length < 4){
       tmp += str;
   }else if(str.length < 7){
       tmp += str.substr(0, 3);
       tmp += '-';
       tmp += str.substr(3);
   }else if(str.length < 11){
       tmp += str.substr(0, 3);
       tmp += '-';
       tmp += str.substr(3, 3);
       tmp += '-';
       tmp += str.substr(6);
   }else{              
       tmp += str.substr(0, 3);
       tmp += '-';
       tmp += str.substr(3, 4);
       tmp += '-';
       tmp += str.substr(7);
   }
   $(obj).val(tmp)
}



</script>
 
 
                
