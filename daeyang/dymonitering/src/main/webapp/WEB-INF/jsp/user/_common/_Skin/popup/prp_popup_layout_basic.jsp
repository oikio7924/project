<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style type="text/css">
/* 팝업 레이아웃 */
.popUpWrap_01 {position:fixed; top:calc(50% - 185px); left:calc(50% - 150px); z-index:30000; width:300px; background-color: #fff;} 
.popUpWrap_01 .contentsBox {padding:20px; height:300px; overflow-y:auto; overflow-x:hidden;border: black 1px solid;}
.popUpWrap_01 .contentsBox > a {text-decoration: none;}
.popUpWrap_01 .bottomBox {padding:5px 15px 5px 20px; display:table; width:100%;position:absolute;bottom:0} 
.popUpWrap_01 .bottomBox:after { visibility: hidden; display:block;font-size: 0;content:".";clear: both;height: 0;*zoom:1;} 
.popUpWrap_01 .bottomBox .logoBox {display:table-cell; width:50%;} 
.popUpWrap_01 .bottomBox .checkBox {display:table-cell; width:50%; vertical-align:middle; text-align:right;} 
.popUpWrap_01 .bottomBox .checkBox label {font-size:11px; font-weight:500;} 
.popUpWrap_01 .btnCloseBox {position: absolute; bottom: 1px; right: -30px; width: 30px; height: 30px; background-color: #444444; 
   text-align: center; cursor: pointer; padding-top: 3px;}
#PopupClose {margin-left: 10px; margin-right:5px; color: #fff;}
@media all and (max-width:850px){    
    .popUpWrap_01 {width:100% !important;top:0 !important;left:0 !important;outline: 2000px solid rgba(0,0,0,0.5);} 
    .popUpWrap_01 .bottomBox {border:1px solid #eee} 
    .popUpWrap_01 .bottomBox .logoBox {display:none;} 
    .popUpWrap_01 .bottomBox .checkBox {width:100%;} 
    .img_css {width:100%;} 
 } 

#layerPopupMask{display:none;position:fixed;left:0;top:0;width:100%;height:100%;z-index:1000;background:rgba(0,0,0,0.7)}
.layerPopup{position:fixed;top:0;width:70%;z-index:1001;}
.layerPopup .popup_area{overflow:hidden;}
.layerPopup .popup_area .popup_image{display:block;}
.layerPopup .popup_area .popup_image img{width:100%;}
.layerPopup .btn_close{position:absolute;top:0px;right:0px;display:block;width:20px;height:20px;line-height:999em;overflow:hidden;padding:10px}
.layerPopup .popup_close {display:table;table-layout:fixed;width:100%;background:#3f3f3f}
.layerPopup .popup_close .col {position:relative;display:table-cell;text-align:center;vertical-align:top;}
.layerPopup .popup_close .col_btn_01 {background:#3f3f3f}
.layerPopup .popup_close .col_btn_02 {background:#666666}
.layerPopup .popup_close .col a,
.layerPopup .popup_close .col button,
.layerPopup .popup_close .col label{box-sizing:border-box;display:block;width:100%;height:45px;padding:0;background:none;border:0 none;font-size:14px;line-height:45px;color:#fff;cursor:pointer;}
.layerPopup .popup_close .col label input{position:absolute;visibility:hidden;margin:0;padding:0;width:0;height:0;}

</style>

<c:set var="userAgentInfo" value="${header['User-Agent']}" />
<c:set var="isMobile" value="false"/>
<c:if test="${fn:contains(userAgentInfo,'iPhone') || fn:contains(userAgentInfo,'Android')}">
	<c:set var="isMobile" value="true"/>
</c:if>

<c:choose>
	<c:when test="${isMobile}">
	    <c:forEach var="list" items="${popupList_W}">
	 		<fmt:parseNumber value="${fn:substring(list.PI_KEYNO,5,20)}" var="numberType" />
	     <div class="layerPopup" id="pop${numberType}" style="display: block;">
			<div class="popup_area">
					 <!-- 팝업창 메인 이미지 -->  
		                 <c:if test="${empty list.FS_KEYNO}">
		                   <a href="${not empty list.PI_LINK ? list.PI_LINK : '#'}" target="_blank" title="<c:out value='${list.PI_TITLE }' escapeXml='true'/>">
		                       <c:out value="${list.PI_CONTENTS}" escapeXml="false"/>
		                   </a>
		                </c:if>
		                <c:if test="${not empty list.FS_KEYNO}">
		                   <a href="${not empty list.PI_LINK ? list.PI_LINK : '#'}" target="_blank" title="<c:out value='${list.PI_TITLE }' escapeXml='true'/>" class="popup_image">
		                    <img style="max-width:100%;" src="${list.THUMBNAIL_PATH}" alt="${list.FS_ORINM }">
		                   </a>
		                </c:if> 
				<div class="popup_close">
					<div class="col col_btn_01"><label class="btn_close_t" onclick="pf_closeMobliePop_W('${numberType}');"><input type="checkbox" name="popupCloseCheck${numberType}"> 오늘 하루 안보기</label></div>
					<div class="col col_btn_02"><button class="btn_close_n" onclick="pf_closeMobliePop_W('${numberType}');">닫기</button></div>
				</div>
			</div>
		 </div>
	</c:forEach>
	</c:when>
	
	<c:otherwise>
		<c:forEach var="list" items="${popupList_W}">
			<fmt:parseNumber value="${fn:substring(list.PI_KEYNO,5,20)}" var="numberType" />
			<div class="popUpWrap_01"  id="pop${numberType}"   data-top="${list.PI_TOP_LOC}" data-left="${list.PI_LEFT_LOC}"  style="width:${list.PI_WIDTH}px;height:${list.PI_HEIGHT + 48}px">
		    	<div class="btnCloseBox">
		        	<button type="button" onclick="pf_closePop_W('${numberType}');"><img src="/resources/img/icon/icon_close_popUp_01.png" alt="closeBox"></button>
		        </div>
		        <div class="contentsBox"  style="height:${list.PI_HEIGHT}px">
		        	<!-- 팝업창 메인 이미지 -->   
				     <c:if test="${empty list.FS_KEYNO}">
					     <a href="${list.PI_LINK }" target="_blank" title="<c:out value='${list.PI_TITLE }' escapeXml='true'/>">
						      <c:out value="${list.PI_CONTENTS}" escapeXml="false"/>
					     </a>
				     </c:if>
				     
				     <c:if test="${not empty list.FS_KEYNO}">
					     <div style="width: 100%;height: 100%;">
					     <a href="${list.PI_LINK }" target="_blank" title="<c:out value='${list.PI_TITLE }' escapeXml='true'/>">
					      <img style="max-width:100%;" src="${list.THUMBNAIL_PATH}" class="img_css" alt="${list.FS_ORINM }">
					     </a>
					     </div>
				     </c:if>
		        </div>
		        <div class="bottomBox">
		        	<div class="logoBox">
<!-- 		            	<img src="/resources/img/logo/logo.png" alt="logo"> -->
		            </div>
		            <div class="checkBox">
		            	<label>오늘 하루동안 보지 않기 <input type="checkbox" name="chkbox${numberType}" value="checkbox"></label>
		            	<button id="mobileClose" type="button" onclick="pf_closePop_W('${numberType}');" style="margin-right:5px;">close</button>
		            </div>
		        </div>   
		    </div>
		</c:forEach>
	</c:otherwise>
</c:choose>

