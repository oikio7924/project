<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<c:forEach begin="1" end="100" step="1" var="model">
	${model}번째 사람이 춤을 춘다
	<c:forEach begin="1" end="${model }" var="model2">
	.
	</c:forEach>
  <br>
</c:forEach>