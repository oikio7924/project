<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>

<form:form id="Form" name="Form" action="/${tiles}/password/info/update.do" method="post">
	<input type="hidden" name="PASSWORD_REGEX" id="PASSWORD_REGEX" value="${userInfoSetting.SC_CODEVAL01}">
	<div class="modifyRowBox">
		<h1>개인정보 입력</h1>
		<ul class="listFormUl">
			<li>
       			<span class="smallParagh">
                	※영문자, 숫자중 임의로 4자에서 16자까지 조합해 사용할 수 있으며, 대소문자를 구분하오니 입력시 대소문자의 상태를 확인하시기 바랍니다
            	</span>
       		</li>
			<li>
		        <p class="title"><span class="colorR">*</span> <label for="UI_PASSWORD2">새 비밀번호</label></p>
		        <p class="formBoxInner">
		            <input type="password" class="txtDefault txtWlong_1" name="UI_PASSWORD2" id="UI_PASSWORD2">
		        </p>
		    </li>
		    <li>
		       <p class="title"><span class="colorR">*</span> <label for="UI_PASSWORD2">새 비밀번호</label></p>
		       <p class="formBoxInner">
		           <input type="password" class="txtDefault txtWlong_1" name="UI_PASSWORD3" id="UI_PASSWORD3">
		       </p>
		   </li>
		</ul>
	</div>
	
	<button type="submit">비밀번호 변경하기</button>
	<button type="button" onclick="location.href='/${tiles}/index.do'">나중에 변경하기</button>
	<%-- <c:if test="${not empty sp:getString('PASSWORD_CYCLE') || sp:getString('PASSWORD_CYCLE') > 0}">
		<button type="button" class="btn-join1 bgGray" onclick="location.href='/${tiles}/password/after/update.do'">${sp:getString('PASSWORD_CYCLE')}일 뒤에 변경하기</button>
	</c:if> --%>
</form:form> 

<script type="text/javascript">

$(document).ready(function() {
	
	$("#Form").validate({

        onfocusout : function (element) {

            $(element).valid();

        },
        
        submitHandler: function(form) {
        	if(confirm('비밀번호를 변경하시겠습니까?')){
				return true;
        	}
          }, 

        rules : {

        	UI_PASSWORD2 : {required:false, minlength:4, maxlength:16, passwordChk:true},
        	UI_PASSWORD3 : {required:false, equalTo:"#UI_PASSWORD2"},
        	
        },

        messages : {

        	UI_PASSWORD2 : {minlength:jQuery.validator.format("최소 {0}자 이상"), maxlength:jQuery.validator.format("최대 {0}자 이하"), passwordChk:"비밀번호 형식이 잘못되었습니다."},
        	UI_PASSWORD3 : {equalTo:"입력한 비밀번호가 서로 일치하지 않습니다."},
        	
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

</script>
