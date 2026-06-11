<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<input type="hidden" id="userPageIndex" value="${paginationInfo.currentPageNo }">

<div class="row">
	<div class="col-sm-12">
		<div class="input-group">
			<input class="form-control" id="searchKeyword" value="${searchKeyword }" type="text" placeholder="아이디나 이름을 입력하여주세요." onkeydown="if(event.keyCode==13) {pf_LinkPage(); return false;}" >
			<div class="input-group-btn">
				<button class="btn btn-default" type="button" onclick="pf_LinkPage()">
					검색
				</button>
			</div>
		</div>
	</div>
</div>
<div class="row" style="margin-top:10px;">
	<div class="col-sm-12">
		<table id="dt_basic" class="table table-bordered table-hover" width="100%">
			<thead>
				<%-- 화살표 정렬 --%>
				<tr>
					<th>ID</th>
					<th>이름</th>
					<th>권한</th>
					<th>인증여부</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${empty resultList }">
				<tr>
					<td colspan="9">검색된 데이터가 없습니다.</td>
				</tr>
				</c:if>
				<c:forEach items="${resultList }" var="model">
				<tr>
					<td>${model.UI_ID }</td>
					<td><c:out value="${model.UI_NAME}"/></td>
					<td>${model.UIA_NAME}</td>
					<td>
						<c:choose>
							<c:when test="${model.AUTH eq 'O'}">
							<c:set var="color" value="#29088A"/>		
							</c:when>
							<c:when test="${model.AUTH eq 'X' }">
							<c:set var="color" value="#FF0040"/>		
							</c:when>
							<c:otherwise>
							<c:set var="color" value="red"/>
							</c:otherwise>
						</c:choose>
						<font color="${color }"><b>${model.AUTH}</b></font>
					</td>
					<td style="text-align:center;">
						<a href="javascript:;" onclick="pf_getMenuList('${model.UI_ID}',this);" class="showMenuList" title="메뉴 리스트 불러오기"><i class="fa fa-fw fa-lg fa-th-list"></i></a>
					</td>
				</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</div>

<div style="text-align:center">
	<ul class="pageNumberUl" >
		<ui:pagination paginationInfo="${paginationInfo }" type="normal_board" jsFunction="pf_LinkPage" />
	</ul>
</div>			    

<script>

function pf_LinkPage(num){
	num = num || 1;
	var keyword = $('#searchKeyword').val();
	pf_listview('B',num,keyword);
}

</script>


