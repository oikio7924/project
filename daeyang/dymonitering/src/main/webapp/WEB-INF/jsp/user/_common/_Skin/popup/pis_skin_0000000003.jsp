<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<c:forEach var="list" items="${popupList_W}">
	<fmt:parseNumber value="${fn:substring(list.PI_KEYNO,5,20)}" var="numberType" />
	<div class="popUpWrap_01"  id="pop${numberType}"   data-top="${list.PI_TOP_LOC}" data-left="${list.PI_LEFT_LOC}"  style="width:${list.PI_WIDTH}px;height:${list.PI_HEIGHT + 48}px">
    	<div class="btnCloseBox">
        	<button type="button" onclick="pf_closePop_W('${numberType}');"><img src="/resources/img/icon/icon_close_popUp_01.png" alt="closeBox"></button>
        </div>
        <div class="contentsBox"  style="height:${list.PI_HEIGHT}px">
        	<!-- 레이아웃 팝업창 메인 이미지 -->   
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
<!--             	<img src="/resources/img/logo/logo.png" alt="logo"> -->
            </div>
            <div class="checkBox">
            	<label>오늘 하루동안 보지 않기 <input type="checkbox" name="chkbox${numberType}" value="checkbox"></label>
            	<button id="mobileClose" type="button" onclick="pf_closePop_W('${numberType}');" style="margin-right:5px;">close</button>
            </div>
        </div>   
    </div>
	

</c:forEach>
