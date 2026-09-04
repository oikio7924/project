<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<c:if test="${not empty currentPath }">
	<jsp:include page="/WEB-INF/jsp/publish/${currentPath }/include/footer.jsp"/>
</c:if>
