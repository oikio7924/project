<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<style>
tr.alert_msg td {padding-top:0px;font-size:12px;}
label.error {color:red;padding-top:3px;font-size:12px;}

</style>
<div class="row">
	<div style="margin:0 auto;max-width:500px;">
		<div class="well no-padding">
			<form method="post" id="Form" class="smart-form client-form">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
				<header>
					환영합니다 제공된 비밀번호를 변경하여주세요.
				</header>

				<fieldset>
					
					<section>
						<label class="label">현재 비밀번호</label>
						<label class="input"> <i class="icon-append fa fa-user"></i>
							<input type="password" name="UI_PASSWORD" id="UI_PASSWORD">
							<b class="tooltip tooltip-top-right"><i class="fa fa-lock txt-color-teal"></i>현재 비밀번호를 입력하세요</b></label>
					</section>
					<section>
						<label class="label">변경된 비밀번호</label>
						<label class="input"> <i class="icon-append fa fa-user"></i>
							<input type="password" name="UI_PASSWORD1" id="UI_PASSWORD1">
							<b class="tooltip tooltip-top-right"><i class="fa fa-lock txt-color-teal"></i>변경된 비밀번호를 입력하세요</b></label>
					</section>
					<section>
						<label class="label">변경된 비밀번호 확인</label>
						<label class="input"> <i class="icon-append fa fa-user"></i>
							<input type="password" name="UI_PASSWORD2" id="UI_PASSWORD2">
							<b class="tooltip tooltip-top-right"><i class="fa fa-lock txt-color-teal"></i>변경된 비밀번호를 재입력하세요</b></label>
					</section>

					
				</fieldset>
				<footer>
					<button type="button" class="btn btn-default" onclick="pf_home()">
						나중에 변경하기
					</button>
					<button type="submit" class="btn btn-primary">
						비밀번호 변경
					</button>
					
				</footer>
			</form>

		</div>
	</div>
</div>

<!-- validation -->
<script type="text/javascript" src="/resources/common/js/validation/jquery.validate.js"></script>

<script>
$(document).ready(function() {
	
	 $("#Form").validate({

        onfocusout : function (element) {

            $(element).valid();

        },
        
        submitHandler: function(form) {   
        	if(pf_pwdCheck()){
        		if(pf_updatePwd()){
        			location.href='/${tiles}/index.do';
        			
        		};
        	}
        	return false;        	
        	
          }, 

        rules : {
        	
        	UI_PASSWORD : {required:true},

        	UI_PASSWORD1 : {required:true, minlength:8, maxlength:16, passwordChk:true, notEqualTo:"#UI_PASSWORD"},
        	
        	UI_PASSWORD2 : {required:true, equalTo:"#UI_PASSWORD1"}
        	
        },

        messages : {


        	UI_PASSWORD : {required:"필수정보를 적어주세요."},

        	UI_PASSWORD1 : {required:"필수정보를 적어주세요.", minlength:jQuery.validator.format("최소 {0}자 이상"), maxlength:jQuery.validator.format("최대 {0}자 이하"), passwordChk:"비밀번호 형식이 잘못되었습니다.", notEqualTo:"기존 비밀번호와 같습니다."},

        	UI_PASSWORD2 : {required:"필수정보를 적어주세요.", equalTo:"입력한 비밀번호가 서로 일치하지 않습니다."}

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
            	if($(element).hasClass('inputID')){
	              	$(element).parent().find('.errorBox').html(error)
            	}else{
            		$(element).after(error);
            	}
          }

    });
	
});

function pf_pwdCheck(){
	
	var state = true;
	 
	 $.ajax({
	        url: '/common/member/update/checkPassword.do',
	        type: 'POST',
	        data: $('#Form').serializeArray(),
	        async: false,  
	        success: function(result) {
	            if(!result){
		           	  alert('현재 비밀번호가 일치하지 않습니다.')
		           	  $('#UI_PASSWORD').focus();
		           	  state = false;
	             }	       },
	       error :function(){
	    	   alert('에러 발생. 관리자에게 문의하세요.');
	    	   state = false;
	       }
	  });
	 if(!state){
		 return state;
	 }
	 return state;
}

function pf_updatePwd(){
	 $.ajax({
	        url: '/dyAdmin/login/init/changePwd/ajax.do',
	        type: 'POST',
	        data: $('#Form').serializeArray(),
	        async: false,  
	        success: function(result) {
	            if(result == 'S'){
		           	 alert('성공적으로 변경되었습니다.')
		           	 pf_home();
		           	  
	             }else{
	            	 alert('비밀번호 변경에 실패했습니다. 다시 시도하여주세요.')
	             }	       
	        },
	       	error :function(){
	    	   alert('에러 발생. 관리자에게 문의하세요.');
	       	}
	  });
}

function pf_home(){
	pf_cancelEvent()
	location.href='/dyAdmin/index.do'
}

//이벤트 취소
function pf_cancelEvent(){
    if(event.preventDefault){
        event.preventDefault();
    }else{
        event.returnValue = false;
    }
}


</script> 
