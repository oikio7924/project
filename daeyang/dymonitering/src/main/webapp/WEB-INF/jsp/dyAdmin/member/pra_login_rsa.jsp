<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<script type="text/javascript" src="/resources/api/rsa/jsbn.js"></script>
<script type="text/javascript" src="/resources/api/rsa/rsa.js"></script>
<script type="text/javascript" src="/resources/api/rsa/prng4.js"></script>
<script type="text/javascript" src="/resources/api/rsa/rng.js"></script>
<script type="text/javascript" src="/resources/api/rsa/login.js"></script>

<form:form id="securedLoginForm" name="securedLoginForm" action="/dyAdmin/j_spring_security_check.do" method="post" style="display: none;">
	<input type="hidden" id="rsaPublicKeyModulus" value="${publicKeyModulus }"/>
	<input type="hidden" id="rsaPublicKeyExponent" value="${publicKeyExponent }"/>
	<input type="hidden" name="securedUsername" id="securedUsername" value=""/>
	<input type="hidden" name="securedPassword" id="securedPassword" value=""/>
</form:form>

<div class="row">
	<div style="margin:0 auto;max-width:500px;">
		<div class="well no-padding">
			<form method="post" id="Form" name="Form" action="/dyAdmin/j_spring_security_check.do" class="smart-form client-form">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
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
							<input type="checkbox" name="remember" id="idSave">
							<i></i>ID 기억하기</label>
					</section>
				</fieldset>
				<footer>
					<button type="submit" class="btn btn-primary" onclick="validateEncryptedForm(); return false;">
						로그인
					</button>
				</footer>
			</form>

		</div>
	</div>
</div>
