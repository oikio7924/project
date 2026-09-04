<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script>

var popupCookieB = new Array();
//팝업창 닫을 때 체크박스 여부에 따른 처리
function pf_closePop_B(key) { 
	if($('input[name=chkbox'+key+']').is(':checked')){
		popupCookieB.push(key)
		cf_setCookieAt00( "popup_b", popupCookieB , 1 ); 
	}
	$('.top-banner-wrap').slideUp();
} 

</script>

