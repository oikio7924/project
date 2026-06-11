<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>
#tableWrap.mini th.display,
#tableWrap.mini td.display {display:none;}
</style>

<div class="pageNumberBox">
	<c:if test="${not empty SQ }">
		<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
			<span class="pagetext">총 ${paginationInfo.totalRecordCount }건  / 총 ${paginationInfo.totalPageCount} 페이지 중 ${paginationInfo.currentPageNo} 페이지 </span>
		</div>
		<div class="col-sm-6 col-xs-12 middlePage" style="text-align: right;">
				<ul class="pageNumberUl" >
					<ui:pagination paginationInfo="${paginationInfo }" type="normal_board" jsFunction="pf_LinkPage" />
			    </ul>
		</div>
    </c:if>
    <c:if test="${empty SQ }">
		<div class="col-sm-8 col-xs-12" style="line-height: 35px; text-align: left;">
		<span class="pagetext">0건 중 0~0번째 결과(총  ${paginationInfo.totalRecordCount }건중 매칭된 데이터)</span>
		</div>
    </c:if>
    <div style="clear: both"></div>
</div>

<c:set var="colspan" value="9"/>

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
					<button type="button" class="btn btn-sm btn-primary" onclick="pf_question_excel()">
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
		<%-- 모든필드,  엑셀다운, 게시글 갯수 끝  --%>
		<tr>
			<th class="hasinput">
				<input type="text" class="form-control search-control" data-searchindex="1" placeholder="번호 검색" />
			</th>
			<th class="hasinput">
				<select class="form-control search-control" data-searchindex="2" >
		            <option value="">선택하세요.</option>
	              	<option value="T">주관식(텍스트박스)</option>
	              	<option value="R">객관식(라디오박스)</option>
	              	<option value="O">객관식(라디오, 기타)</option>
	              	<option value="C">객관식(체크박스)</option>
	            </select>
			</th>
			<th class="hasinput">
				<input type="text" class="form-control search-control" data-searchindex="3" placeholder="질문 검색" />
			</th>
			<th class="hasinput display">
				<input type="text" class="form-control search-control" data-searchindex="4" placeholder="카테고리 텍스트 검색" />
			</th>
			<th class="hasinput display">
				<input type="text" class="form-control search-control" data-searchindex="5" placeholder="문항 설명 검색" />
			</th>
			<th class="hasinput display">
				<select class="form-control search-control" data-searchindex="6" >
		            <option value="">선택하세요.</option>
	              	<option value="Y">Y</option>
	              	<option value="N">N</option>
	            </select>
			</th>
		</tr>
		<%-- 화살표 정렬 --%>
		<tr>
			<th class="arrow" data-index="1" width="10%";>번호</th>
			<th class="arrow" data-index="2" width="15%">타입</th>
			<th class="arrow" data-index="3" width="20%";>질문</th>
			<th class="arrow display" data-index="4" width="20%";>카테고리 텍스트</th>
			<th class="arrow display" data-index="5" width="25%";>문항 설명</th>
			<th class="arrow display" data-index="6" width="10%";>기타의견 유무</th>
		</tr>
	</thead>
	<tbody>
		<c:if test="${empty SQ }">
			<tr>
				<td colspan="${colspan}">검색된 데이터가 없습니다.</td>
			</tr>
		</c:if>
		<c:forEach items="${SQ }" var="model">
		<tr>
			<td>${model.SQ_NUM }</td>
			<c:if test="${model.SQ_ST_TYPE eq 'T' }">
				<td>주관식(텍스트박스)</td>
			</c:if>
			<c:if test="${model.SQ_ST_TYPE eq 'R' }">
				<td>객관식(라디오박스)</td>
			</c:if>
			<c:if test="${model.SQ_ST_TYPE eq 'O' }">
				<td>객관식(라디오, 기타)</td>
			</c:if>			
			<c:if test="${model.SQ_ST_TYPE eq 'C' }">
				<td>객관식(체크박스)</td>
			</c:if>						
			<td>
				<a href="javascript:;" onclick="pf_insertSurvey('${model.SQ_KEYNO }', '${model.COUNT }')">${model.SQ_QUESTION }</a>
			</td>
			<td class="display">${model.SQ_KG_TEXT }</td>
			<td class="display">${model.SQ_COMMENT }</td>
			<td class="display">${model.SQ_ORDER_TYPE }</td>
		</tr>
		</c:forEach>
	</tbody>
</table>
</div>
<%-- 하단 페이징 --%>
<div class="pageNumberBox dt-toolbar-footer">
	<c:if test="${not empty SQ }">
		<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
			<span class="pagetext">총 ${paginationInfo.totalRecordCount }건  / 총 ${paginationInfo.totalPageCount} 페이지 중 ${paginationInfo.currentPageNo} 페이지</span>
		</div>
		<div class="col-sm-6 col-xs-12" style="text-align: right;">
				<ul class="pageNumberUl" >
					<ui:pagination paginationInfo="${paginationInfo }" type="normal_board" jsFunction="pf_LinkPage" />
			    </ul>
		</div>
    </c:if>
    <c:if test="${empty SQ }">
    	<div class="col-sm-8 col-xs-12" style="line-height: 35px; text-align: left;">
		<span class="pagetext">0건 중 0~0번째 결과(총  ${paginationInfo.totalRecordCount }건중 매칭된 데이터)</span>
		</div>
    </c:if>
</div>

<script type="text/javascript">

$(function(){
	pf_defaultPagingSetting('${search.orderBy}','${search.sortDirect}');
})

function pf_insertSurvey(key, count){
	key = key || '';
	
	pf_togleArticle('Y');

	var keyno = '${SQ_SM_KEYNO}';
	
	$.ajax({
		type: "POST",
		url: "/dyAdmin/operation/survey/questionlListDetailView.do",
		data: {
			"SQ_KEYNO" : key,	
			"SQ_SM_KEYNO" : keyno,
			"COUNT" : count
		},
		async :false,
		success : function(data){
			$('#inputFormBox').html(data);            			
		},
		error: function(jqXHR, textStatus, errorThrown){
			cf_smallBox('ajax', '알수없는 에러 발생. 관리자한테 문의하세요.', 3000,'gray');
		}
   }).done(function(){
	   cf_loading_out();
   });			
}

function pf_togleArticle(action){
	if(action == 'Y'){
		$('#list-article').removeClass('col-lg-12').addClass('col-lg-4');
		$('#insert-article').show();
		$('#tableWrap').addClass('mini')
	}else{
		$('#list-article').removeClass('col-lg-4').addClass('col-lg-12');
		$('#insert-article').hide();
		$('#tableWrap').removeClass('mini')
	}
}
</script>
