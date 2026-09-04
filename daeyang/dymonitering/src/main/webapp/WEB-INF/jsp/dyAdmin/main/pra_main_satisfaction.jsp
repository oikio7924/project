<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

	<div class="tit-box">
		<p class="tit">페이지 최근 코멘트 내역</p>
		<%@ include file="/WEB-INF/jsp/dyAdmin/include/pra_import_mainSelect.jsp"%>
		
          <a href="/dyAdmin/homepage/research/pageComment.do" class="btn btn-sm btn-primary moreBtn">
             <i class="fa fa-floppy-o"></i> 더보기
          </a>
        
	</div>

	<c:set var="commentTotal" value="0" />
	<c:if test="${not empty satisfactionList }">
			<c:set var="commentTotal" value="${satisfactionList[0].TPR_TOTAL }" />
	</c:if>
		<fmt:formatNumber type="currency" value="${commentTotal}" pattern="###,###" var="commentTotalNumber" />
		
	
	<div class="ds-festi-reservation"> <!-- 페이지 평가 내역 -->
		<p>총 코멘트 내역 <c:out value="${commentTotalNumber}"/>건</p>
		<div class="table-box">
			<div class="t-col-1">
				<table class="tbl_da_sm">
					<colgroup>
						<col width="auto;">
						<col width="auto;">
						<col width="auto;">
						<col width="auto;">
					</colgroup>
					<thead>
						<tr>
							<th>번호</th>
                               <th>페이지</th>
                               <th>만족도</th>
                                <th style="width:15%;">IP</th>
                                <th style="width:40%;">코멘트</th>
                               <th>평가일</th>
						</tr>
					</thead>
					<tbody>
						 <c:forEach items="${satisfactionList}" var="model" varStatus="status">
                               <tr>
                                   <td><c:out value="${model.COUNT }"/></td>
                                   <td><c:out value="${model.MN_NAME }"/></td>
                                   <td><c:out value="${model.TPS_SCORE_NAME }"/></td>
                                   <td><c:out value="${model.TPS_IP }"/></td>
                                   <td>${model.TPS_COMMENT }
									</td>
                                   <td><c:out value="${model.TPS_REGDT }"/></td>
                               </tr>
                           </c:forEach>
						<c:if test="${empty satisfactionList}">
						<tr><td colspan="6">페이지 최근 코멘트 내역이 없습니다.</td></tr>
						</c:if>
					</tbody>
				</table>
			</div>
		</div>
	</div> 
