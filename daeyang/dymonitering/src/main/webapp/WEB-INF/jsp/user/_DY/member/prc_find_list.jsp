<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>

<div class="idSearchWrap">
	<p class="smallIntro">
		* 사용자님의 아이디를 선택하시면 해당 아이디에 등록된 이메일 주소를 통해 임시 비밀번호를 발송해드립니다.
    </p>
    <div class="formBox clearfix">
    	<ul class="listFormUl">
    		<c:forEach items="${resultList }" var="model">
        	<li>
            	<p class="title"><span class="colorR">*</span> <label for="UI_EMAIL">아이디</label> </p>
                <p class="formBoxInner"><button type="button" onclick="pf_emailSend('${model.UI_ID}')">${model.UI_ID }</button></p>
            </li>
            </c:forEach>
        </ul>
    </div>
     <div class="btnBox">
    	<button type="button" class="btn btnBig_02" onclick="cf_login('main');">로그인</button>
    </div>
</div>

<script>

function pf_emailSend(key) {
	  cf_loading();
	    $.ajax({
	        url: '/${tiles}/member/find/sendEmail.do',
	        type: 'POST',
	        data: {"UI_ID":key},
	        async: false,  
	        success: function(resp) {
            	alert(resp.UI_EMAIL + '으로 계정정보를 전송하였습니다.\n확인하여 주세요.')
	       }
	   }).done(function(){
		   cf_loading_out();
	   });
}

</script>
