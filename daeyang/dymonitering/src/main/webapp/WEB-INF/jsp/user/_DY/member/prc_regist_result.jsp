<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>


<div class="w_inner">   
    	<div class="header">
        	<div class="join_text">
				<h1>회원가입 완료</h1>
			</div>
			<div class="B_arrow">
				<img src="/resources/img/icon/v_arrow_icon.png" alt="파란 화살표">
			</div>
        </div>
        
		<!--main 시작-->
		<div class="user_join">
			<h1><span class="text">${userInfo.UI_NAME }님</span> 회원가입을<br>진심으로 축하합니다.</h1>
		</div>
			<!--main 끝-->

			<!--footer 시작-->
		<div class="move_text">
			<p>확인버튼을 누르시면 종합차트페이지로 이동합니다.</p>
		</div>
		
		<button type="button" id="btn" onclick="location.href='/${tiles}/index.do'">확인</button>
                      
</div>