<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<div class="pageNumberBox">
	<c:if test="${not empty resultList }">
		<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
			<span class="pagetext">총 ${paginationInfo.totalRecordCount }건  / 총 ${paginationInfo.totalPageCount} 페이지 중 ${paginationInfo.currentPageNo} 페이지 </span>
		</div>
		<div class="col-sm-6 col-xs-12 middlePage" style="text-align: right;">
				<ul class="pageNumberUl" >
					<ui:pagination paginationInfo="${paginationInfo }" type="normal_board" jsFunction="pf_LinkPage2" />
			    </ul>
		</div>
    </c:if>
    <c:if test="${empty resultList }">
		<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
		<span class="pagetext">0건 중 0~0번째 결과(총  ${paginationInfo.totalRecordCount }건중 매칭된 데이터)</span>
		</div>
    </c:if>
    <div style="clear: both"></div>
</div>

<div class="tableMobileWrap">
<table class="pagingTable table table-striped table-bordered table-hover" width="100%">
	<thead>
		<%-- 모든필드 , 게시글 갯수 시작  --%>
		<tr>
			<th colspan="5">
				<div style="float:left;">
					<input type="text" class="form-control search-control" data-searchindex="all" placeholder="모든필드 검색" style="width:200px;display: inline-block;" />
					<button class="btn btn-sm btn-primary smallBtn" type="button" onclick="pf_LinkPage(1,'Form2');" style="margin-right:10px;">
						<i class="fa fa-plus"></i> 검색
					</button>
				</div>
				<div style="float:right;">
					<button type="button" class="btn btn-sm btn-primary" onclick="pf_excel('Form2')">
						<i class="fa fa-file-excel-o"></i> 엑셀
					</button>
					<select name="pageUnit" style="width:50px;display:inline-block; vertical-align: top;height: 31px;" onchange="pf_LinkPage(1,'Form2');">
				    	<option value="10" ${10 eq search.pageUnit ? 'selected' : '' }>10</option>
				    	<option value="25" ${25 eq search.pageUnit ? 'selected' : '' }>25</option>
				    	<option value="50" ${50 eq search.pageUnit ? 'selected' : '' }>50</option>
				    	<option value="75" ${75 eq search.pageUnit ? 'selected' : '' }>75</option>
				    	<option value="100" ${100 eq search.pageUnit ? 'selected' : '' }>100</option>
				    </select>
			    </div>
			</th>
		</tr>
		<%-- 모든필드  ,  엑셀다운, 게시글 갯수 끝  --%>
		<tr>
			<th class="hasinput">
				<select class="form-control search-control" data-searchindex="1" style="width:100%;">
		            <option value="">선택하세요.</option>
	              	<c:forEach items="${homeDivList }" var="model">
	              	<option value="${model.MN_NAME }">${model.MN_NAME }</option>
	              	</c:forEach>
	            </select>
			</th>
			<th class="hasinput">
				<input type="text" class="form-control search-control" data-searchindex="2" placeholder="메뉴 검색" />
			</th>
			<th class="hasinput">
				<input type="text" class="form-control search-control" data-searchindex="3" placeholder="제목 검색" />
			</th>
			<th class="hasinput">
				<input type="text" class="form-control search-control" data-searchindex="4" placeholder="기간 검색" />
			</th>
			<th></th>
		</tr>
		<%-- 화살표 정렬 --%>
		<tr>
			<th class="arrow" data-index="1">홈페이지</th>
			<th class="arrow" data-index="2">메뉴</th>
			<th class="arrow" data-index="3">제목</th>
			<th class="arrow" data-index="4">기간</th>
			<th>사용여부</th>
		</tr>
	</thead>
	<tbody>
		<c:if test="${empty resultList }">
			<tr>
				<td colspan="5">검색된 데이터가 없습니다.</td>
			</tr>
		</c:if>
		<c:forEach items="${resultList }" var="model">
		<tr>
			<td>${model.PI_MN_MAINNAME }</td>
			<td>${model.PI_MN_NAME }</td>
			<td>
				<a href="javascript:;" onclick="pf_popupMain('${model.PI_KEYNO}')"><c:out value="${model.PI_TITLE}" escapeXml="true"/></a>
			</td>
			<c:choose>
				<c:when test="${sysdate <= model.PI_ENDDAY }">
					<c:set var="dateClass" value=""/>	
				</c:when>
				<c:otherwise>
					<c:set var="dateClass" value="red"/>
				</c:otherwise>
			</c:choose>
			<c:choose>
					<c:when test="${model.PI_ENDDAY == '9999-99-99'}">
					<c:set var="model.PI_DATE" value=""/>
					<td>기간 없음</td> </c:when>
					<c:otherwise><td class="${dateClass}">${model.PI_DATE }</td> </c:otherwise>
			</c:choose>
			<td>
				<a class="btn btn-primary btn-xs" href="#" onclick="pf_usePopup('${model.PI_KEYNO}','Y','${model.PI_MN_KEYNO }')">
					<i class="fa fa-repeat"></i> 복원
				</a>
				<a class="btn btn-danger btn-xs" href="#" onclick="pf_DeletePopup('${model.PI_KEYNO}','${model.PI_MN_KEYNO }')">
					<i class="fa fa-trash-o"></i> 삭제
				</a>
			</td>
		</tr>
		</c:forEach>
	</tbody>
</table>
</div>
<%-- 하단 페이징 --%>
<div class="pageNumberBox dt-toolbar-footer">
	<c:if test="${not empty resultList }">
		<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
			<span class="pagetext">총 ${paginationInfo.totalRecordCount }건  / 총 ${paginationInfo.totalPageCount} 페이지 중 ${paginationInfo.currentPageNo} 페이지</span>
		</div>
		<div class="col-sm-6 col-xs-12" style="text-align: right;">
				<ul class="pageNumberUl" >
					<ui:pagination paginationInfo="${paginationInfo }" type="normal_board" jsFunction="pf_LinkPage2" />
			    </ul>
		</div>
    </c:if>
    <c:if test="${empty resultList }">
    	<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
		<span class="pagetext">0건 중 0~0번째 결과(총  ${paginationInfo.totalRecordCount }건중 매칭된 데이터)</span>
		</div>
    </c:if>
</div>

<script type="text/javascript">

$(function(){

	pf_defaultPagingSetting('Form2','${search.orderBy}','${search.sortDirect}');

})

function pf_LinkPage2(num){
	pf_LinkPage(num,'Form2');
}

</script>
