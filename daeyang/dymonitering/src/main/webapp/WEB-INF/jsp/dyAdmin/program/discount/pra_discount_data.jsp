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
</div> <!--위쪽페이징 끝  -->

<table id="dt_basic" class="pagingTable table table-striped table-bordered table-hover" width="100%">
	<thead>
		<%-- 모든필드 , 게시글 갯수 시작  --%>
		<tr>
			<th colspan="7">
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
		</tr><%-- 모든필드 , 게시글 갯수 끝  --%>
								
		<tr>
			<th class="hasinput min200">
				<input type="text" class="form-control search-control" data-searchindex="1" placeholder="번호 검색" />
			</th>
			<th class="hasinput min200">
				<input type="text" class="form-control search-control" data-searchindex="2" placeholder="이름 검색" />
			</th>	
			<th class="hasinput">
				<select class="form-control selectFilter search-control" data-searchindex="3" name="" style="width:100%;" onchange="pf_LinkPage()">
					<option value="">전체</option>
		            <option value="O">O</option>
		            <option value="X">X</option>
      			</select>
			</th>  
			</th>        
	        <th class="hasinput min200">
				<input type="text" class="form-control search-control" data-searchindex="4" placeholder="할인 검색" />
			</th>
	        <th class="hasinput min200">
				<input type="text" class="form-control search-control" data-searchindex="5" placeholder="설명 검색" />
			</th>
	       <th class="hasinput">
				<select class="form-control selectFilter search-control" data-searchindex="6" name="" style="width:100%;" onchange="pf_LinkPage()">
					<option value="">전체</option>
		            <option value="O">O</option>
		            <option value="X">X</option>
      			</select>
			</th>  
			<th></th>
		</tr>
		<tr>
			<th class="arrow" data-index="1" style="width:5%;">번호</th>
			<th class="arrow" data-index="2"style="width:15%;">이름</th>
			<th class="arrow" data-index="3"style="width:10%;">사용여부</th>
			<th class="arrow" data-index="4"style="width:10%;">할인</th>
			<th class="arrow" data-index="5"style="width:30%;">설명</th>
			<th class="arrow" data-index="6"style="width:10%;">기본적용여부</th>
			<th style="width:20%;">설정</th>
		</tr>
	</thead>
	<tbody>
		<c:if test="${empty resultList}">
			<tr><td colspan="7">검색된 데이터가 없습니다.</td></tr>
		</c:if>
		<c:forEach items="${resultList }" var="model" varStatus="status">
		<tr>
			<td><c:out value="${model.COUNT }"/></td>
			<td><c:out value="${model.AD_NAME }" /></td>								
			<td>
				<font color="${model.AD_USE eq 'O' ? '#29088A':'#FF0040' }"><b>${model.AD_USE}</b></font>
			</td>								
			<td><c:out value="${model.MONEY }"/></td>
			<td>
				<span style="display:inline-block;text-overflow:ellipsis;white-space:nowrap;word-wrap:normal;width:300px;overflow:hidden;">
				<c:out value="${model.AD_COMENT }"/>
				</span>
				<a href="javascript:;" onclick="pf_openComent(this)">전체보기</a>
			</td>								
			<td>
				<font color="${model.AD_DEFAULT_YN eq 'O' ? '#29088A':'#FF0040' }"><b>${model.AD_DEFAULT_YN}</b></font>
			</td>
			<td>
				<button class="btn btn-sm btn-success" type="button" onclick="pf_openUpdate('${model.AD_KEYNO}')">수정</button>
				<button class="btn btn-sm btn-danger" type="button" onclick="pf_delete('${model.AD_KEYNO}')">삭제</button>
			</td>								
		</tr>
		</c:forEach>
		</tbody>
	</table>
<!--테이블 끝  -->
	
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
					