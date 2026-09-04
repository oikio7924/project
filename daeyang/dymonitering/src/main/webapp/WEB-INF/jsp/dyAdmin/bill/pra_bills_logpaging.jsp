<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


 <div class="pageNumberBox">
	<c:if test="${not empty resultLis4 }">
		<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
			<span class="pagetext">총 ${paginationInfo.totalRecordCount }건  / 총 ${paginationInfo.totalPageCount} 페이지 중 ${paginationInfo.currentPageNo} 페이지 </span>
		</div>
		<div class="col-sm-6 col-xs-12 middlePage" style="text-align: right;">
				<ul class="pageNumberUl" >
					<ui:pagination paginationInfo="${paginationInfo }" type="normal_board" jsFunction="pf_LinkPage" />
			    </ul>
		</div>
    </c:if>
    <c:if test="${empty resultList4 }">
		<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
		<span class="pagetext">0건 중 0~0번째 결과(총  ${paginationInfo.totalRecordCount }건중 매칭된 데이터)</span>
		</div>
    </c:if>
    <div style="clear: both"></div>
</div>

<c:set var="colspan" value="8"/>
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
		</thead>
		<%-- 모든필드  ,  엑셀다운, 게시글 갯수 끝  --%>
											<colgroup>
											<col style="width: 5%; display: none;">
											<col style="width: 5%;">
											<col style="width: 10%;">
											<col style="width: 10%;">
											<col style="width: 20%;">
											<col style="width: 20%;">
											<col style="width: 10%;">
											<col style="width: 10%;">
											<col style="width: 10%;">
										</colgroup>
										<thead>
										<tr>
											<th class="hasinput" style="display: none;"></th>
											<th class="hasinput"><input type="text"
												class="form-control search-control" data-searchindex="1"
												placeholder="번호 검색" /></th>
											<th class="hasinput"><select class="form-control search-control"
												data-searchindex="2" style="width: 100%;" onchange="pf_LinkPage()">
													<option value="">전체</option>
													<option value="1">한전발행</option>
													<option value="2">거래처 발행</option>
													<option value="3">안전관리자 발행</option>
											</select></th>
											<th class="hasinput"><input type="text"
												class="form-control search-control" data-searchindex="3"
												placeholder="공급자 검색" /></th>
											<th class="hasinput"><input type="text"
												class="form-control search-control" data-searchindex="4"
												placeholder="공급받는자 검색" /></th>
											<th class="hasinput"><input type="text"
												class="form-control search-control" data-searchindex="5"
												placeholder="품목명 검색" /></th>
											<th class="hasinput" ><input type="text"
												class="form-control search-control" data-searchindex="6"
												placeholder="합계금액 검색" /></th>
											<th class="hasinput" ><input type="text"
												class="form-control search-control" data-searchindex="7"
												placeholder="날짜 검색" /></th>
											<th class="hasinput"><select class="form-control search-control"
												data-searchindex="8" style="width: 100%;" onchange="pf_LinkPage()">
													<option value="">전체</option>
													<option value="-1">전송실패</option>
													<option value="0">전송완료</option>
													<option value="2">전송대기</option>
											</select></th>
										</tr>
										<%-- 화살표 정렬 --%>
										<tr>
											<th style="text-align: center; display: none;">키값</th>
											<th class="arrow" style="text-align: center;" data-index="1">번호</th>
											<th class="arrow" style="text-align: center;" data-index="2">발행종류</th>
											<th class="arrow" style="text-align: center;" data-index="3">공급자 명</th>
											<th class="arrow" style="text-align: center;" data-index="4">공급받는자 명</th>
											<th class="arrow" style="text-align: center;" data-index="5">품목명</th>
											<th class="arrow" style="text-align: center;" data-index="6">합계금액</th>
											<th class="arrow" style="text-align: center;" data-index="7">등록날짜</th>
											<th class="arrow" style="text-align: center;" data-index="8">전송 상태</th>
										</tr>
									</thead>
									<tbody style="text-align: center;">
										<c:if test="${empty resultList4 }">
											<tr>
												<td colspan="8">검색된 데이터가 없습니다.</td>
											</tr>
										</c:if>
										<c:forEach items="${resultList4 }" var="b">
											<tr>
												<td style="display: none;">${b.dbl_keyno}</td>
												<td>${b.COUNT}</td>
												<c:if test="${b.dbl_sub_keyno eq '1' }">
												<td>한전 발행</td>
												</c:if>
												<c:if test="${b.dbl_sub_keyno eq '2' }">
												<td>거래처 발행</td>
												</c:if>
												<c:if test="${b.dbl_sub_keyno eq '3' }">
												<td>안전관리자 발행</td>
												</c:if>
												<td><a onclick = "taxpopup('${b.dbl_keyno}');" style="cursor: pointer;" id="listtable" name ="listtable" value ="${b.dbl_keyno}">${b.dbl_p_name}</a></td>
												<td>${b.dbl_s_name}</td>
												<td>${b.dbl_subject}</td>
												<td>${b.dbl_grandtotal}</td>
												<td>${b.dbl_issuedate}</td>
												<c:if test="${b.dbl_status eq '1' }">
												<td>전송준비</td>
												</c:if>
												<c:if test="${b.dbl_status eq '2' }">
												<td style="color: #3333FF">전송대기</td>
												</c:if>                         						
												<c:if test="${b.dbl_status eq '0' }">
												<td style="color: #00CC66">전송완료</td>
												</c:if>
												<c:if test="${b.dbl_status eq '-1' }">
													<td><a href="javascript:;" onclick="logAlarm('${b.dbl_keyno}')" style="color: #FF0000">전송실패</a></td>
												</c:if>
											</tr>
										</c:forEach>
									</tbody>
								</table>

</div>

<%-- 하단 페이징 --%>
<div class="pageNumberBox dt-toolbar-footer">
	<c:if test="${not empty resultList4 }">
		<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
			<span class="pagetext">총 ${paginationInfo.totalRecordCount }건  / 총 ${paginationInfo.totalPageCount} 페이지 중 ${paginationInfo.currentPageNo} 페이지</span>
		</div>
		<div class="col-sm-6 col-xs-12" style="text-align: left;">
				<ul class="pageNumberUl" >
					<ui:pagination paginationInfo="${paginationInfo }" type="normal_board" jsFunction="pf_LinkPage" />
			    </ul>
		</div>
    </c:if>
    <c:if test="${empty resultList4 }">
    	<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
		<span class="pagetext">0건 중 0~0번째 결과(총  ${paginationInfo.totalRecordCount }건중 매칭된 데이터)</span>
		</div>
    </c:if>
</div>
<%-- <%@ include file="pra_bills_popup.jsp"%> --%>

  

<script type="text/javascript">

$(function(){

	pf_defaultPagingSetting('${search.orderBy}','${search.sortDirect}');

})


function taxpopup(value){

	var left = Math.ceil((window.screen.width - 1000)/2);
	var top = Math.ceil((window.screen.height - 820)/2);
	var popOpen	= window.open("/dyAdmin/bills/log/controller.do?listtable="+value, "Taxpopup","width=1200px,height=900px,top="+top+",left="+left+",status=0,toolbar=0,menubar=0,location=false,scrollbars=yes");
	popOpen.focus();
}

function logAlarm(keyno){
	$.ajax({
		url: '/dyAdmin/bills/sendingAjax.do',
		type: 'POST',
		data: {
			"keyno" : keyno
		},
		async: false,
		success : function(data){
			alert(data)
		}
	});
	
}
// function senddata(){
	
// 	$.ajax({
// 		type: "POST",
// 		url: "/dyAdmin/bills/log/controller.do",
// 		async: false,
// 		data: $('#Form').serializeArray(),
// 		success : function(data){
// 			alert(data);
			
// 		}, 
// 		error: function(){
			
// 		}
// }); 
	
// }

</script>
