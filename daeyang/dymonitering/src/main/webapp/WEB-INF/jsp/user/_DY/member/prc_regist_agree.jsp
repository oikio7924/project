<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>



<form:form id="Form" action="/${tiles}/member/regist/info.do" method="post">
	<input type="hidden" name="data" id="data" value="data">
	
	<div class="Join_01_inner">
		<div class="J_header">
			<div class="join_title_01">
				<h1>회원가입</h1>
			</div>	
		</div>	
		<!-- header 끝 -->
		<!-- main_1 시작-->
		<div id="S_main_wrap_01">
			<div class="sub_main_01">
				<div class="title_h2_inner">
					<h1>회원가입약관</h1>

				</div>
				<div class="S_title_txt">
					<p><span class="star">* </span>회원가입약관 및 개인정보처리방침안내의 내용에 동의하셔야 회원가입 하실 수 있습니다.</p>
				</div>

				<div class="sub_title_01">
					<h1>회원가입약관</h1>
				</div>
			</div>
			<div class="sub_text_01">
				<p>제 1 조 (목적) 
					이 약관은 OOOO(이하 "OOOO"이라 함)이 운영하는 OOOO 홈페이지 회원(이하 “회원”이라 함) 가입과 혜택 등의(이하 "서비스"라 함) 이용조건 및 절차에 관하여 OOOO과 회원 간의 권리, 의무 및 책임사항의 규정을 목적으로 합니다.<br><br>

					제 2 조 (약관의 명시 및 개정)  </p>
			</div>
			<div class="sub_btn_01">
				<label for="check_box_01"><input type="checkbox" id="check_box_01" class="agree">회원가입약관의 내용에 동의합니다.</label>
			</div>
		</div>
		<!-- main_1 끝-->
		<!-- main_2 시작-->
		<div id="S_main_wrap_02">
			<div class="sub_main_02">
				<div class="title_h2_inner">
					<h1>개인정보처리방침안내</h1>
				</div>

				<div class="sub_title_02">
					<h1>개인정보처리방침안내</h1>
				</div>
			</div>
			<div class="sub_text_02">
				<p>(OOOO 홈페이지를 이용하여 주셔서 감사드립니다. <br>
					홈페이지에서의 개인정보보호방침에 대하여 설명해 드리겠습니다. <br><br>

					이는 현행 [공공기관의개인정보보호에관한법률] 및 [공공기관의 개인정보보호를 위한 기본지침]에 근거를 두고 있습니다.  </p>
			</div>
			<div class="sub_btn_02">
				<label for="check_box_02"><input type="checkbox" id="check_box_02" class="agree">개인정보처리방침안내의 내용에 동의합니다.</label>
			</div>
		</div>
		<!-- main_2 끝-->

		<!--footer 시작-->
		<div class="Btn_wrap">
			<div class="J_BTN">
				<button type="submit" id="join_Btn" onclick="return pf_check();"> 회원정보 입력</button>
			</div>
		</div>
		<!--footer 끝-->
	</div>
</div>




	
</form:form>

<script>
 
 $(function(){
	$('#agreeAll').on('change',function(){
		if($(this).is(':checked')){
			$('.agree').prop('checked',true)
		}else{
			$('.agree').prop('checked',false)
		}
	})	 
 })
 
 function pf_check(){
	 var state = true;
	 $('.agree').each(function(){
		 if(!$(this).is(':checked')){
			 alert('이용약관에 동의하여주세요.')
			 $(this).focus();
			 state = false;
			 return false;
		 }
	 });
	return state;	 
 }
 </script>

