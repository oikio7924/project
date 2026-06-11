<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

	<div class="tit-box">
		<p class="tit">회원 목록</p>
        <%@ include file="/WEB-INF/jsp/dyAdmin/include/pra_import_mainSelect.jsp"%>
		<sec:authorize url="/dyAdmin/person/view.do">
              <a href="/dyAdmin/person/view.do" class="btn btn-sm btn-primary moreBtn">
                  <i class="fa fa-floppy-o"></i> 더보기
              </a>
        </sec:authorize>
        
	</div>

	<div class="ds-festi-reservation"> <!-- 회원 목록 -->
		<c:set var="memberTotal" value="0" />
           <c:set var="leaveMemberTotal" value="0" />
           <c:if test="${not empty memberlist }">
               <c:set var="memberTotal" value="${memberlist[0].UI_TOTAL }" />
               <c:set var="leaveMemberTotal" value="${memberlist[0].UI_TOTAL_LEAVE }" />
           </c:if>
           <fmt:formatNumber type="currency" value="${memberTotal }" pattern="###,###" var="memberTotalNumber" />
           <fmt:formatNumber type="currency" value="${leaveMemberTotal }" pattern="###,###" var="leaveMemberTotalNumber" />

           <p>총회원수 <c:out value="${memberTotalNumber}"/>명 중 탈퇴 : <c:out value="${leaveMemberTotal}"/>명</p>
		<div class="table-box">
			<div class="t-col-1">
				<table class="tbl_da_sm">
					<colgroup>
						<col>
						<col>
						<col>
						<col>
						<col width="10%;">
					</colgroup>
					<thead>
						<tr>
							<th>ID</th>
							<th>이름</th>
							<th>가입일자</th>
							<th>권한</th>
							<th>인증여부</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${memberlist}" var="model" varStatus="status">
                            <tr>
                                <td title="<c:out value="${model.UI_ID }"/>"><c:out value="${model.UI_ID }"/></td>
                                <td title="<c:out value="${model.UI_NAME }"/>"><c:out value="${model.UI_NAME }"/></td>
                                <td title="<c:out value="${fn:substring(model.UI_REGDT,0,10) }"/>"><c:out value="${fn:substring(model.UI_REGDT,0,10) }"/></td>
                                <td title="<c:out value="${model.UIA_NAME }"/>" style="${model.UIA_NAME eq '탈퇴회원' ? 'color:red;':''}"><c:out value="${model.UIA_NAME }"/></td>
                                <td><c:out value="${model.UI_AUTH_YN eq 'Y' ? 'O' : 'X'}"/></td>
                            </tr>
                           </c:forEach>
						<c:if test="${empty memberlist}">
						<tr><td colspan="5">회원이 없습니다.</td></tr>
						</c:if>
					</tbody>
				</table>
			</div>
		</div>
	</div> 
