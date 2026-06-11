<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<div class="pageNumberBox">
	<c:if test="${not empty resultList }">
		<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
			<span class="pagetext">총 ${paginationInfo.totalRecordCount }건  / 총 ${paginationInfo.totalPageCount} 페이지 중 ${paginationInfo.currentPageNo} 페이지 </span>
		</div>
		<div class="col-sm-6 col-xs-12 middlePage" style="text-align: right;">
				<ul class="pageNumberUl" >
					<ui:pagination paginationInfo="${paginationInfo }" type="normal_board" jsFunction="pf_LinkPage" />
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
<table id="dt_basic" class="pagingTable table table-striped table-bordered table-hover" width="100%">
	<thead>
		<%-- 모든필드 , 게시글 갯수 시작  --%>
		<tr>
			<th colspan="10">
				<div style="float:left;">
					<input type="text" class="form-control search-control" data-searchindex="all" placeholder="모든필드 검색" style="width:200px;display: inline-block;" />
					<button class="btn btn-sm btn-primary smallBtn" type="button" onclick="pf_LinkPage()" style="margin-right:10px;">
						<i class="fa fa-plus"></i> 검색
					</button>
				</div>
				<div style="float:right;">
					<button type="button" class="btn btn-sm btn-primary" onclick="pf_excel()">
						<i class="fa fa-file-excel-o"></i> 엑셀
					</button>
					<select name="pageUnit" id="pageUnit" style="width:50px;display:inline-block; vertical-align: top;height: 31px;" onchange="pf_LinkPage();">
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
				<input type="text" class="form-control search-control" data-searchindex="1" placeholder="번호 검색" />
			</th>
			<th class="hasinput">
				<input type="text" class="form-control search-control" data-searchindex="2" placeholder="ID 검색" />
			</th>
			<th class="hasinput">
				<input type="text" class="form-control search-control" data-searchindex="3" placeholder="이름 검색" />
			</th>
			<th class="hasinput">
				<input type="text" class="form-control search-control" data-searchindex="4" placeholder="권한 검색" />
			</th>
			<!-- 이메일과 전화번호는 암호화로 인해 검색 불가 -->
			<th class="hasinput"></th>
			<th class="hasinput"></th>
			<th class="hasinput">
				<input type="text" class="form-control search-control" data-searchindex="5" placeholder="가입날짜 검색" />
			</th>
			<th class="hasinput">
				<input type="text" class="form-control search-control" data-searchindex="6" placeholder="마지막 로그인 검색" />
			</th>
			<th class="hasinput">
				<select class="form-control selectFilter search-control" data-searchindex="7" style="width:100%;" onchange="pf_LinkPage()">
		            <option value="">전체</option>
		            <option value="O">O</option>
		            <option value="X">X</option>
		            <option value="탈퇴">탈퇴회원</option>
		         </select>
			</th>
			<th class="hasinput">카카오톡 전송 여부</th>
		</tr>
		<%-- 화살표 정렬 --%>
		<tr>
			<th class="arrow" data-index="1">번호</th>
			<th class="arrow" data-index="2">ID</th>
			<th class="arrow" data-index="3">이름</th>
			<th class="arrow min200" data-index="4">권한</th>
			<!-- 이메일과 전화번호는 암호화로 인해 검색 불가 -->
			<th class="min200" style="width:15%;">이메일</th>
			<th class="min200" style="width:15%;">전화번호</th>
			<th class="arrow min200" data-index="5">가입날짜</th>
			<th class="arrow min200" data-index="6">마지막 로그인</th>
			<th class="arrow" data-index="7">인증여부</th>
			<th style="text-align: center;"><input type="checkbox" id="cbx_chkAll" onclick="seletAll()"></td>
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
			<td>${model.COUNT}</td>
			<td>
				<c:choose>
					<c:when test="${model.AUTH eq 'O' || model.AUTH eq 'X'}">
					<c:set var="onclick" value="pf_openMemberInfoPopup('${model.UI_ID}')"/>		
					</c:when>
					<c:otherwise>
					<c:set var="onclick" value="alert('탈퇴한 회원입니다.')"/>
					</c:otherwise>
				</c:choose>
				<a href="javascript:;" onclick="${onclick}">${model.UI_ID }</a>
			</td>
			<td><c:out value="${model.UI_NAME}"/></td>
			<td>${model.UIA_NAME}</td>
			<td>${model.UI_EMAIL}</td>
			<td>${model.UI_PHONE}</td>
			<td>${model.UI_REGDT}</td>
			<td>${model.UI_LASTLOGIN}</td>
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
				<c:if test="${model.UI_ALIMYN eq 'Y'}">
				<td id ="chktd"><input type="checkbox" name="chk" id ="chk" value = "${model.UI_KEYNO}" onChange="checkcheck(this.value)" checked></td>
				</c:if>
				<c:if test="${model.UI_ALIMYN eq 'N'}">
				<td id ="chktd"><input type="checkbox" name="chk" id ="chk" value = "${model.UI_KEYNO}" onChange="checkcheck(this.value)"></td>
				</c:if>				
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
					<ui:pagination paginationInfo="${paginationInfo }" type="normal_board" jsFunction="pf_LinkPage" />
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

	pf_defaultPagingSetting('${search.orderBy}','${search.sortDirect}');

})

</script>
