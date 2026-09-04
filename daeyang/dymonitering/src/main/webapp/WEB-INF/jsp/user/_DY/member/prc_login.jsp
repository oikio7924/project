<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>

<form:form id="Form" name="Form" action="/user/j_spring_security_check.do" method="post">
<input type="hidden" name="tiles" value="${tiles}" />


<div id="Login_wrap">
    <div class="bg"></div>
    <section class="in_login">
        <h1 class="logo"><a href="/" title="대양기업"><img src="/resources/img/sub/logo_login.jpg" alt="DAEYANG"></a></h1>
        <h2><b>SOLAR</b> ManageMent SERVICE</h2>

        <h3>태양광  종합관리 서비스</h3>
        <h4>대양기업 태양광 종합관리 서비스 로그인 페이지입니다.</h4>

            <p class="log"><input type="text" class="log_txt id" placeholder="ID(아이디)" name="UI_ID" id="UI_IDs" ></p>
            <p class="log"><input type="password" class="log_txt pwd" placeholder="PW(비밀번호)" name="UI_PASSWORD" id="UI_PASSWORD" autocomplete="off"></p>
            <input type="checkbox" id="idSave" /> <label for="idSave" style="margin-right: 25px;">아이디저장</label>
            <input type="checkbox" id="autoLogin" name="_spring_security_remember_me"> <label for="autoLogin">자동로그인</label>
            <button type="submit" class="btn_login" id="login_button" onclick="validateLoginForm(); return false;" >로그인</button>
    </section>
</div>

</form:form>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
//화면 호출시 가장 먼저 호출되는 부분 
// $(document).ready(function() {
//  		var location_origin = location.origin;
// });
$(function(){
	var errormsg = "${customExceptionmsg}";
	
	if(errormsg!=""){
		alert(errormsg);
	}
	
	var saveId = cf_getCookie('saveId');
	if(saveId){
		$('#idSave').attr('checked',true);
		$('#autoLogin').attr('checked',true);
		$('#UI_IDs').val(saveId);
		$('#UI_PASSWORD').focus();
	}else{
		$('#UI_IDs').focus();
	}
});

function validateLoginForm() {
    var username = document.getElementById("UI_IDs").value;
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
	
	if($('#autoLogin').is(':checked')){
		cf_setCookie('autoLogin',username)
	}else{
		cf_clearCookie('autoLogin');
	}
	
	
	// POST 로그인 폼에 값을 설정하고 발행(submit) 한다.
    var Form = document.getElementById("Form");
    Form.submit();
}
</script>
