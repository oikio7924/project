<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

	
	<div class="tit-box">
		<p class="tit">최근 게시물</p>
		<%@ include file="/WEB-INF/jsp/dyAdmin/include/pra_import_mainSelect.jsp"%>
		<c:if test="${boardAuth}">
			<a href="/dyAdmin/homepage/board/dataView.do" class="btn btn-sm btn-primary moreBtn">
				<i class="fa fa-floppy-o"></i> 더보기
			</a>
		</c:if>
	</div>
	<div class="ds-festi-reservation"> <!-- 최근 게시물 -->
		<c:set var="boardTotal" value="0" />
		<c:if test="${not empty boardlist }">
			<c:set var="boardTotal" value="${boardlist[0].BN_TOTAL }" />
		</c:if>
		<fmt:formatNumber type="currency" value="${boardTotal}" pattern="###,###" var="boardTotalNumber" />
		<p>총 게시물 <c:out value="${boardTotalNumber}"/>건</p>
		<div class="table-box">
			<div class="t-col-1">
				<table class="tbl_da_sm">
					<colgroup>
						<col width="10%">
						<col width="20%">
						<col width="*">
						<col width="10%">
						<col width="20%">
					</colgroup>
					<thead>
						<tr>
							<th>번호</th>
							<th>게시판</th>
							<th>제목</th>
							<th>작성자</th>
							<th>작성일</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${boardlist}" var="model" varStatus="status">
						<tr>
							<td title="<c:out value="${model.BN_KEYNO}"/>"><c:out value="${model.BN_KEYNO}"/></td>
							<td title="<c:out value="${model.MN_NAME}"/>"><c:out value="${model.MN_NAME}"/></td>
							<td title="<c:out value="${model.BN_TITLE}" escapeXml="true"/>"><c:out value="${model.BN_TITLE}" escapeXml="true"/></td>
							<td title="<c:out value="${model.BN_UI_NAME}"/>"><c:out value="${model.BN_UI_NAME}"/></td>
							<td title="<c:out value="${fn:substring(model.BN_REGDT,0,19)}"/>"><c:out value="${fn:substring(model.BN_REGDT,0,19)}"/></td>
						</tr>
						</c:forEach>
						<c:if test="${empty boardlist}">
						<tr><td colspan="5">게시물이 없습니다.</td></tr>
						</c:if>
					</tbody>
				</table>
			</div>
		</div>
	</div> 
