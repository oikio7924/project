<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<c:if test="${not empty HTMLViewData.MVD_TILES}">
<jsp:include page="/WEB-INF/jsp/layout/${HTMLViewData.MVD_TILES}/script.jsp" flush="false">
	<jsp:param value="preview" name="preview"/>
</jsp:include>
<jsp:include page="/WEB-INF/jsp/layout/${HTMLViewData.MVD_TILES}/css.jsp" flush="false">
	<jsp:param value="preview" name="preview"/>
</jsp:include>
</c:if>
<c:out value="${HTMLViewData.MVD_DATA}" escapeXml="false"/>



