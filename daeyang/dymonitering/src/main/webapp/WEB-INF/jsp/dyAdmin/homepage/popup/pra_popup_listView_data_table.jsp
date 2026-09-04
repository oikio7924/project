<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<div class="table-responsive">
	<table class="table table-bordered" style="text-align:center;margin-left: 15px;width: 98%;">
		<thead>
		<div class="pageNumberBox dt-toolbar-footer">
			<c:if test="${not empty resultList_sub }">
				<div class="col-sm-6 col-xs-12"
					style="line-height: 35px; text-align: left;">
					<span class="pagetext">총 ${paginationInfo.totalRecordCount }건 / 총 ${paginationInfo.totalPageCount} 페이지 중 ${paginationInfo.currentPageNo} 페이지</span>
				</div>
				<div class="col-sm-6 col-xs-12" style="text-align: right;">
					<ul class="pageNumberUl">
						<ui:pagination paginationInfo="${subPaginationInfo}" type="normal_board" jsFunction="pf_LinkPageSub" />
					</ul>
				</div>
			</c:if>
			<c:if test="${empty resultList_sub }">
				<div class="col-sm-6 col-xs-12"
					style="line-height: 35px; text-align: left;">
					<span class="pagetext">0건 중 0~0번째 결과(총 ${paginationInfo.totalRecordCount }건중 매칭된 데이터)</span>
				</div>
			</c:if>
		</div>
			<tr>
				<th style="text-align: center;">제목</th>
				<th style="text-align: center;">기간</th>
				<th style="text-align: center;">링크</th>
				<th style="text-align: center;">유형</th>
				<th style="text-align: center;">사용여부</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${empty resultList_sub }">
				<tr>
					<td colspan="5">검색된 데이터가 없습니다.</td>
				</tr>
			</c:if>

			<c:forEach items="${resultList_sub }" var="model">
						<tr>
							<td><a href="javascript:;"
								onclick="pf_popupMain('${model.PI_KEYNO}')"><c:out value="${model.PI_TITLE}" escapeXml="true" /></a></td>
							<c:choose>
								<c:when test="${model.PI_ENDDAY == '기간없음'}">
									<c:set var="model.PI_DATE" value="" />
									<td>기간없음</td>
								</c:when>
								<c:otherwise>
									<td>${model.PI_STARTDAY } ~ ${model.PI_ENDDAY }</td>
								</c:otherwise>
							</c:choose>
							<td>${model.PI_LINK }</td>
							<td>${model.PI_TYPE_TEXT }</td>
							<c:choose>
								<c:when test="${model.PI_CHECK eq 'Y' }">
								<td>
									<button type="button" class="btn btn-default btn-xs" onclick="pf_usePopup('${model.PI_KEYNO}','N', '${model.PI_MN_KEYNO}','${model.PI_LEVEL }')">
										<i class="fa fa-rotate-left"></i> 중지
									</button>
								</td>
								</c:when>
								<c:otherwise>
								<td>
									<a class="btn btn-primary btn-xs" href="#" onclick="pf_usePopup('${model.PI_KEYNO}','Y','${model.PI_MN_KEYNO }')"><i class="fa fa-repeat"></i> 복원</a> 
									<a class="btn btn-danger btn-xs" href="#" onclick="pf_DeletePopup('${model.PI_KEYNO}','${model.PI_MN_KEYNO }')"><i class="fa fa-trash-o"></i> 삭제</a>
								</td>
								</c:otherwise>
							</c:choose>
						</tr>
			</c:forEach>
		</tbody>
	</table>
</div>

<script>
function pf_LinkPageSub(num){
	menu_popup_view(num)
}
</script>
