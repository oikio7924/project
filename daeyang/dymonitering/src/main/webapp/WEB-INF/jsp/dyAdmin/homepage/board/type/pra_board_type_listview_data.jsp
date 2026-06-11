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

<c:set var="colspan" value="12"/>

<div class="tableMobileWrap">
<table id="dt_basic" class="pagingTable table table-striped table-bordered table-hover" width="100%">
	<thead>
		<%-- 모든필드 , 게시글 갯수 시작  --%>
		<tr>
			<th colspan="${colspan}">
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
				<select class="form-control search-control" data-searchindex="1" style="width:100%;" onchange="pf_LinkPage()">
		            <option value="">명칭</option>
		            <c:forEach items="${ resultList}" var="model">
			            <option value="${model.BT_TYPE_NAME }">${model.BT_TYPE_NAME }</option>
		            </c:forEach>
		        </select>
			</th>
			<th class="hasinput min200">
				<input type="text" class="form-control search-control" data-searchindex="2" placeholder="게시판 유형 검색" />
			</th>
			<th class="hasinput min200" style="width:30%;">
				<input type="text" class="form-control search-control" data-searchindex="3" placeholder="메뉴 검색" />
			</th>
			<th class="hasinput">
				<select class="form-control search-control" data-searchindex="4" name="" style="width:100%;" onchange="pf_LinkPage()">
					<option value="">추가  HTML여부</option>
					<option value="O">O</option>
					<option value="X">X</option>
		      	</select>
			</th>
			<th class="hasinput">
				<select class="form-control search-control" data-searchindex="5" name="" style="width:100%;" onchange="pf_LinkPage()">
					<option value="">썸네일 여부</option>
					<option value="O">O</option>
					<option value="X">X</option>
		      	</select>
			</th>
			<th class="hasinput">
				<select class="form-control search-control" data-searchindex="6" name="" style="width:100%;" onchange="pf_LinkPage()">
					<option value="">댓글 여부</option>
					<option value="O">O</option>
					<option value="X">X</option>
		      	</select>
			</th>
			<th class="hasinput">
				<select class="form-control search-control" data-searchindex="7" name="" style="width:100%;" onchange="pf_LinkPage()">
					<option value="">답글 여부</option>
					<option value="O">O</option>
					<option value="X">X</option>
		      	</select>
			</th>
			<th class="hasinput">
				<select class="form-control search-control" data-searchindex="8" name="" style="width:100%;" onchange="pf_LinkPage()">
					<option value="">비밀글 여부</option>
					<option value="O">O</option>
					<option value="X">X</option>
		      	</select>
			</th>
			<th class="hasinput">
				<select class="form-control search-control" data-searchindex="9" name="" style="width:100%;" onchange="pf_LinkPage()">
					<option value="">업로드 여부</option>
					<option value="O">O</option>
					<option value="X">X</option>
		      	</select>
			</th>
			<th class="hasinput">
				<select class="form-control search-control" data-searchindex="10" name="" style="width:100%;" onchange="pf_LinkPage()">
					<option value="">Web 에디터 추가</option>
					<option value="O">O</option>
					<option value="X">X</option>
		      	</select>
			</th>
			<th class="hasinput min200">
        		<input type="text" class="form-control search-control" data-searchindex="11" placeholder="이메일 수신여부" />
			</th>
			<th class="hasinput">
				<select class="form-control search-control" data-searchindex="12" name="" style="width:100%;" onchange="pf_LinkPage()">
					<option value="">파일 미리보기</option>
					<option value="O">O</option>
					<option value="X">X</option>
		      	</select>
			</th>
		</tr>
		<%-- 화살표 정렬 --%>
		<tr>
			<th class="arrow" data-index="1">명칭</th>
			<th class="arrow" data-index="2">게시판 유형</th>
			<th class="arrow" data-index="3">사용중인 메뉴</th>
			<th class="arrow" data-index="4">추가 HTML</th>
			<th class="arrow" data-index="5">썸네일 사용여부</th>
			<th class="arrow" data-index="6">답글</th>
			<th class="arrow" data-index="7">댓글</th>
			<th class="arrow" data-index="8">비밀글</th>
			<th class="arrow" data-index="9">업로드</th>
			<th class="arrow" data-index="10">Web 에디터 추가 여부</th>
			<th class="arrow" data-index="11">이메일 수신여부</th>
			<th class="arrow" data-index="12">파일 미리보기</th>
		</tr>
	</thead>
	<tbody>
		<c:if test="${empty resultList }">
			<tr>
				<td colspan="${colspan}">검색된 데이터가 없습니다.</td>
			</tr>
		</c:if>
		<c:forEach items="${resultList }" var="model">
		<tr>
			<td><a href="javascript:pf_boardTypeAction('updateView','${model.BT_KEYNO}')">${model.BT_TYPE_NAME} </a></td>
			<td>${model.BT_LIST_TITLE }</td>
			<td>
				${model.MN_NAME }
			</td>
			<td>
				<font color="${model.BT_HTML_YN eq 'O' ? '#29088A':'#FF0040' }"><b>${model.BT_HTML_YN}</b></font>
			</td>
			<td>
				<font color="${model.BT_THUMBNAIL_YN eq 'O' ? '#29088A':'#FF0040' }"><b>${model.BT_THUMBNAIL_YN}</b></font>
			</td>
			<td>
				<font color="${model.BT_REPLY_YN eq 'O' ? '#29088A':'#FF0040' }"><b>${model.BT_REPLY_YN}</b></font>
			</td>
			<td>
				<font color="${model.BT_COMMENT_YN eq 'O' ? '#29088A':'#FF0040' }"><b>${model.BT_COMMENT_YN}</b></font>
			</td>
			<td>
				<font color="${model.BT_SECRET_YN eq 'O' ? '#29088A':'#FF0040' }"><b>${model.BT_SECRET_YN}</b></font>
			</td>
			<td>
				<font color="${model.BT_UPLOAD_YN eq 'O' ? '#29088A':'#FF0040' }"><b>${model.BT_UPLOAD_YN}</b></font>
			</td>
			<td>
				<font color="${model.BT_HTMLMAKER_PLUS_YN eq 'O' ? '#29088A':'#FF0040' }"><b>${model.BT_HTMLMAKER_PLUS_YN}</b></font>
			</td>
			<td>
				<font color="${model.BT_EMAIL ne 'X' ? '#29088A':'#FF0040' }"><b>${model.BT_EMAIL}</b></font>
			</td>
			<td>
				<font color="${model.BT_PREVIEW_YN ne 'X' ? '#29088A':'#FF0040' }"><b>${model.BT_PREVIEW_YN}</b></font>
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
