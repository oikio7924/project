<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script>
var popupCookieW = new Array();
var cookieKeys = '${CookieKeys}'

$(document).ready(function() {
	popupCookieW.push(cookieKeys)
    <c:if test="${!isMobile}">
	pf_checkDraggable();
    $(window).resize(pf_checkDraggable);
    </c:if>
    <c:if test="${isMobile}">
    $('#layerPopupMask').show();
    $(".layerPopup").each(function(){
    	$(this).center();
    });
    </c:if>
});

jQuery.fn.center = function () {
	this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) + $(window).scrollTop()) + "px");
    this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) + $(window).scrollLeft()) + "px");
    return this;
}


var currentPopupDraggableStatus = false;
function pf_checkDraggable(){
   var width_size = window.outerWidth;
   if (width_size >= 1000) {
      if(!currentPopupDraggableStatus){
         $('.popUpWrap_01').draggable().each(function(){
            $(this).css({
               top:$(this).data('top'),
               left:$(this).data('left')
            })
         });
         currentPopupDraggableStatus = true;
      }
   }else{
      if(currentPopupDraggableStatus){
         $( ".popUpWrap_01" ).draggable( "option", "revert", true );   
         currentPopupDraggableStatus = false;
      }
   }
}

//팝업창 닫을 때 체크박스 여부에 따른 처리
function pf_closePop_W(key) { 
   if($('input[name=chkbox'+key+']').is(':checked')){
	   popupCookieW.push(key)
      cf_setCookieAt00( "popup_w", popupCookieW , 1 ); 
   }
   $('#pop'+key).hide();

} 
//팝업창 닫을 때 체크박스 여부에 따른 처리
function pf_closeMobliePop_W(key) { 
	if($('input[name=popupCloseCheck'+key+']').is(':checked')){
		popupCookieW.push(key)
      cf_setCookieAt00( "popup_w", popupCookieW , 1 ); 
    }
	
   $('#pop'+key).hide();
   if($('.layerPopup:visible').length < 1){
	   $('#layerPopupMask').hide();
   }

} 



</script>

