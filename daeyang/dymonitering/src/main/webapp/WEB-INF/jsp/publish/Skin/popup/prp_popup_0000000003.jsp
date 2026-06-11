<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<div class="top-banner-wrap">
    <div class="topBanner-inner">
        <div class="close-b">
            <label><input type="checkbox" name="chkboxTopBanner"> <span>오늘 하루 열지 않기</span></label>
            <button type="button" class="btn-close" onclick="pf_closePop_B('TopBanner');"><i class="material-icons">close</i></button>
        </div>
        <ul class="top-banner-ul">
            <c:forEach var="list" items="${popupList_B}">
				<fmt:parseNumber value="${fn:substring(list.PI_KEYNO,5,20)}" var="numberType" />
				<li>
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
