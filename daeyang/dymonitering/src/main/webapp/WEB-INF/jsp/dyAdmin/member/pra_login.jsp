<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>

<div class="row">
	<div style="margin:0 auto;max-width:500px;">
		<div class="well no-padding">
			<form:form method="post" id="Form" name="Form" action="/dyAdmin/j_spring_security_check.do" class="smart-form client-form">
				<header>
					로그인
				</header>

				<fieldset>
					
					<section>
						<label class="label">아이디</label>
						<label class="input"> <i class="icon-append fa fa-user"></i>
							<input type="text" name="UI_ID" id="UI_ID">
							<b class="tooltip tooltip-top-right"><i class="fa fa-user txt-color-teal"></i> 아아디를 입력하세요</b></label>
					</section>

					<section>
						<label class="label">비밀번호</label>
						<label class="input"> <i class="icon-append fa fa-lock"></i>
							<input type="password" name="UI_PASSWORD" id="UI_PASSWORD">
							<b class="tooltip tooltip-top-right"><i class="fa fa-lock txt-color-teal"></i> 비밀번호를 입력하세요.</b> </label>
						<div class="error_message" style="color:red;">${customExceptionmsg }</div>
						<div class="note">
							<a href="/dy/member/find.do">비밀번호 찾기</a>
						</div>
					</section>

					<section>
						<label class="checkbox">
							<input type="checkbox" name="_spring_security_remember_me" id="idSave">
							<i></i>자동 로그인</label>
					</section>
				</fieldset>
				<footer>
					<button type="submit" class="btn btn-primary" onclick="validateLoginForm(); return false;">
						로그인
					</button>
				</footer>
			</form:form>

		</div>
	</div>
</div>

<script type="text/javascript">
$(function(){
	var saveId = cf_getCookie('saveId');
	if(saveId){
		$('#idSave').attr('checked',true);
		$('#UI_ID').val(saveId);
		$('#UI_PASSWORD').focus();
	}else{
		$('#UI_ID').focus();
	}
})

function validateLoginForm() {
	//나중에 관리자 보수업체 로그인 확인할때 사용(보류)
//	alert($('.type li.active').attr("value"))	
//	var loginType = $('.type li.active').attr("value");
	
    var username = document.getElementById("UI_ID").value;
    var password = document.getElementById("UI_PASSWORD").value;
    if (!username || !password) {
        alert("ID/비밀번호를 입력해주세요.");
        return false;
    }

    try {
    	submit(username, password);
    } catch(err) {
        alert(err);
    }
    return false;
}

function submit(username, password) {
	
	//아이디 저장 체크시 쿠키에 저장
	if($('#idSave').is(':checked')){
		cf_setCookie('saveId',username)
	}else{
		cf_clearCookie('saveId');
	}
	
	// POST 로그인 폼에 값을 설정하고 발행(submit) 한다.
    var Form = document.getElementById("Form");
    Form.submit();
}
</script>
