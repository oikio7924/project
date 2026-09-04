<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>


<script type="text/javascript" src="/resources/api/rsa/jsbn.js"></script>
<script type="text/javascript" src="/resources/api/rsa/rsa.js"></script>
<script type="text/javascript" src="/resources/api/rsa/prng4.js"></script>
<script type="text/javascript" src="/resources/api/rsa/rng.js"></script>
<script type="text/javascript" src="/resources/api/rsa/login.js"></script>
<style>
.login-field-box .row .log-f {
    width: 90%;
    height: 70px;
    border: 1px solid #bbb;
    margin-top: -1px;
    padding-left: 55px;
    position: relative;
    font-size: 16px;
}

#login-con {
    width: 99%;
    padding: 120px 10px 120px;
}

</style>
<form:form id="securedLoginForm" name="securedLoginForm" action="/sfa/j_spring_security_check.do" method="post" style="display: none;">
	<input type="hidden" name="customReturnPage" value="${customReturnPage}" />
	<input type="hidden" id="rsaPublicKeyModulus" value="${publicKeyModulus}" />
	<input type="hidden" id="rsaPublicKeyExponent" value="${publicKeyExponent}" />
	<input type="hidden" name="securedUsername" id="securedUsername" value="" />
	<input type="hidden" name="securedPassword" id="securedPassword" value="" />
</form:form>

<form:form id="Form">
<input type="hidden" name="customReturnPage" value="${customReturnPage}" />
<section id="login-con">
<div class="log-inner">
	<!-- 로그인 -->
	<div class="login-logo-b">
		<img src="/resources/img/safeAdmin/bg_main2-1.png" alt="로고">
	</div>
		<fieldset>
			<legend>로그인</legend>
			<div class="login-field-box">
				<div class="row">
					<input type="text" name="UI_ID" id="UI_ID" class="log-f id" placeholder="아이디를 입력하세요">
				</div>
				<div class="row">
					<input type="password" name="UI_PASSWORD" id="UI_PASSWORD" class="log-f pwd" placeholder="비밀번호를 입력하세요">
				</div>
				<div class="check-b clearfix">
					<div class="left">
						<label><input type="checkbox" id="idSave" style="position: relative;top: -1px;left: 10px;margin-right: 15px;"> 아이디저장</label>
						<p class="samllChar" style=" color:red;margin: 10px;">${customExceptionmsg}</p>
					</div>
					<div class="right">
						<ul class="bt_ul clearfix">
						<a href="javascript:;" onclick="showMemSearchPop()"><li>아이디 | 비밀번호 찾기</li></a>
						</ul>
					</div>
				</div>
			</div>
		</fieldset>

		<div class="log-btn-box">
			<button type="submit" class="login-btn1 purple" onclick="validateEncryptedForm(); return false;">로그인</button>
<!-- 			<button type="button" class="login-btn1 gray" onclick="location.href='/jact/member/regist.do'">회원가입</button> -->
		</div>
</div>
</section>

</form:form>