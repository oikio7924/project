<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<c:forEach items="${list }" var="model" varStatus="status">
	<c:if test="${status.index == 0}">
		<c:set var="fristKeyno" value="${model.DPP_KEYNO}" />
	</c:if>

	<c:choose>
		<c:when test="${model.DDM_STATUS eq '정상' }">
			<c:set var="status" value="circle_statue green"/>
		</c:when>
		<c:when test="${model.DDM_STATUS eq '장애' }">
			<c:set var="status" value="circle_statue red"/>
		</c:when>
		<c:when test="${model.DDM_STATUS eq '대기' }">
			<c:set var="status" value="circle_statue orange"/>
		</c:when>
		<c:when test="${model.DDM_STATUS eq '연결 끊김' }">
			<c:set var="status" value="circle_statue blue"/>
		</c:when>
		<c:otherwise>
			<c:set var="status" value="circle_statue black"/>
		</c:otherwise>
	</c:choose>
	<tr>
	    <td><a href="javascript:;" onclick="detailInverter('${model.DPP_KEYNO}')"> [ ${model.DPP_AREA } ] ${model.DPP_NAME }</a></td>
	    <td><fmt:formatNumber value="${model.DDM_D_DATA }" pattern="0.00"/>(<fmt:formatNumber value="${model.DDM_D_DATA/model.DPP_VOLUM }" pattern="0.00"/>)</td>
	    <td><fmt:formatNumber value="${model.DDM_P_DATA }" pattern="0.00"/>(<fmt:formatNumber value="${model.DDM_P_DATA/model.DPP_VOLUM }" pattern="0.00"/>)</td>
	    <td><span class="${status }"></span></td>
	</tr>
</c:forEach>