<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>

<style>
.view_background {
    width: 100%;
    border: 1px solid #000;
    background-size: 100% 100%;
}
.view_title {
    text-align: center;
    font-size: 44px;
    font-weight: 500;
}
.view_comment {
    margin-top: 20px;
    text-align: center;
    font-size: 19px;
    max-width: 70%;
    display: block;
    margin: 0 auto;
    letter-spacing: -1px;
    line-height: 27px;
    font-weight: 400;
}
</style>

<c:choose>
   <c:when test="${not empty homeData.HM_POPUP_SKIN_B}">
	   <c:import url="/common/popup/UserViewAjax.do?type=list&key=${homeData.HM_POPUP_SKIN_B }"/>
   </c:when>
   <c:otherwise>
    <div class="top-banner-wrap">
    <div class="topBanner-inner">
        <div class="close-b">
            <label><input type="checkbox" name="chkboxTopBanner"> <span>오늘 하루 열지 않기</span></label>
            <button type="button" class="btn-close" onclick="pf_closePop_B('TopBanner');"><i class="material-icons">close</i></button>
        </div>
        <ul class="top-banner-ul">
            <c:forEach var="list" items="${popupList_B}">
				<fmt:parseNumber value="${fn:substring(list.PI_KEYNO,5,20)}" var="numberType" />
				<li style="display:none;">
				<c:choose>
					<c:when test="${list.PI_TYPE eq 'A'}">
						<a href="${list.PI_LINK }" target="_blank" title="<c:out value='${list.PI_TITLE }' escapeXml='true'/>">
					     <img style="max-width:100%;" src="${list.THUMBNAIL_PATH}" class="img_css" alt="${list.FS_ORINM }">
				   		</a>
					</c:when>
					<c:when test="${list.PI_TYPE eq 'B'}">
					<div class="view_background" style="background-image: url(&quot;/resources/img/popup/background0${list.PI_BACKGROUND_COLOR}.jpg&quot;); float: none; list-style: none; position: relative;">
		        		<a href="${list.PI_LINK }" target="_blank" title="${list.PI_TITLE }">
			        		<p class="view_title" style="color:#8CC63E">${list.PI_TITLE2 }</p>
			        		<p class="view_comment" style="color:#ffffgf">${list.PI_COMMENT }</p>
		        		</a>
		        	</div>
					</c:when>
				</c:choose>
				</li>
			</c:forEach>
        </ul>
        <div class="slider-nav"></div>
    </div>
</div>
   </c:otherwise>
</c:choose>   


<script>
$(function(){
	var $topBannerSlide = $('.top-banner-ul');

	$topBannerSlide.slick({
		slidesToShow: 1,
		slidesToScroll: 1,
		arrows: true,
		autoplay: true,
		fade: true,
		speed:1000,
		infinite:true,
		autoplaySpeed: 4000,
		easing: 'swing',
		dots: true,
		prevArrow: '<span class="slick-arrow slick-prev"></span>',
		nextArrow: '<span class="slick-arrow slick-next"></span>',
		appendArrows: '.topBanner-inner .slider-nav',
		appendDots: '.topBanner-inner .slider-nav',
	});
	
});

var popupCookie = new Array();
//팝업창 닫을 때 체크박스 여부에 따른 처리
function pf_closePop_B(key) { 
	if($('input[name=chkbox'+key+']').is(':checked')){
		popupCookie.push(key)
		cf_setCookieAt00( "popup_b", popupCookie , 1 ); 
	}
	$('.top-banner-wrap').slideUp();
} 

</script>

