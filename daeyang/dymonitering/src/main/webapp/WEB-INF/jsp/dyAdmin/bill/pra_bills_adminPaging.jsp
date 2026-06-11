<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<div class="pageNumberBox">
	<c:if test="${not empty resultList3 }">
		<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
			<span class="pagetext">총 ${paginationInfo.totalRecordCount }건  / 총 ${paginationInfo.totalPageCount} 페이지 중 ${paginationInfo.currentPageNo} 페이지 </span>
		</div>
		<div class="col-sm-6 col-xs-12 middlePage" style="text-align: left;">
				<ul class="pageNumberUl" >
					<ui:pagination paginationInfo="${paginationInfo }" type="normal_board" jsFunction="pf_LinkPage" />
			    </ul>
		</div>
    </c:if>
    <c:if test="${empty resultList3 }">
		<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
		<span class="pagetext">0건 중 0~0번째 결과(총  ${paginationInfo.totalRecordCount }건중 매칭된 데이터)</span>
		</div>
    </c:if>
    <div style="clear: both"></div>
</div>
<div class="bg-color-white">
							<div class="tableMobileWrap">
								<table id="dt_basic"
									class="pagingTable table table-striped table-bordered table-hover"
									width="100%">
									<colgroup>
											<col style="width: 3%;">
											<col style="width: 5%;">
											<col style="width: 10%;">
											<col style="width: 20%;">
											<col style="width: 20%;">
											<col style="width: 10%;">
											<col style="width: 10%;">
											<col style="width: 10%;">
										</colgroup>
									<thead>
										<tr>
											<th colspan="10">
												<div style="float: left;">
													<input type="text" class="form-control search-control"
														data-searchindex="all" placeholder="모든필드 검색"
														style="width: 200px; display: inline-block;" />
													<button class="btn btn-sm btn-primary smallBtn"
														type="button" onclick="pf_LinkPage()"
														style="margin-right: 10px;">
														<i class="fa fa-plus"></i> 검색
													</button>
													<button class="btn btn-sm btn-primary smallBtn"
														type="button" onclick="TaxListUpdate_DY()"
														style="margin-right: 10px;">
														<i class="fa fa-plus"></i> 세금계산서 리스트 업데이트
													</button>
													<button class="btn btn-sm btn-primary smallBtn"
														id ="UpdateButton" type="button" onclick="DeleteUpdate()"
														style="margin-right: 10px;">
														업데이트 되돌리기
													</button>
												</div>
											</th>
										</tr>
										<tr>
											<th style="text-align: center;">선택</th>
											<th class="hasinput"><input type="text"
												class="form-control search-control" data-searchindex="1"
												placeholder="번호 검색" /></th>
											<th class="hasinput"><input type="text"
												class="form-control search-control" data-searchindex="2"
												placeholder="공급자 검색" /></th>
											<th class="hasinput"><input type="text"
												class="form-control search-control" data-searchindex="3"
												placeholder="공급받는자 검색" /></th>
											<th class="hasinput"><input type="text"
												class="form-control search-control" data-searchindex="4"
												placeholder="품목명 검색" /></th>
											<th class="hasinput" ><input type="text"
												class="form-control search-control" data-searchindex="5"
												placeholder="합계금액 검색" /></th>
											<th class="hasinput" ><input type="text"
												class="form-control search-control" data-searchindex="6"
												placeholder="날짜 검색" /></th>
											<th class="hasinput"></th>
										</tr>
										<%-- 화살표 정렬 --%>
										<tr>
											<th style="text-align: center;"><input type="checkbox" id="cbx_chkAll" onclick="seletAll()"></td>
											<th class="arrow" style="text-align: center;" data-index="1">번호</th>
											<th class="arrow" style="text-align: center;" data-index="2">공급자 명</th>
											<th class="arrow" style="text-align: center;" data-index="3">공급받는자 명</th>
											<th class="arrow" style="text-align: center;" data-index="4">품목명</th>
											<th class="arrow" style="text-align: center;" data-index="5">합계금액</th>
											<th class="arrow" style="text-align: center;" data-index="6">등록날짜</th>
											<th class="arrow" style="text-align: center;" data-index="7">전송 상태</th>
										</tr>
									</thead>
									<tbody style="text-align: center;">
										<c:if test="${empty resultList3 }">
											<tr>
												<td colspan="8">검색된 데이터가 없습니다.</td>
											</tr>
										</c:if>
										<c:forEach items="${resultList3 }" var="b">
											<tr>
												<c:if test="${b.dbl_checkYN eq 'N' }">
												<td><input type="checkbox" name="chk" id ="chk" value = "${b.dbl_keyno}"></td>
												</c:if>
												<c:if test="${b.dbl_checkYN eq 'W' }">
												<td><input type="checkbox" name="" id ="" value = "${b.dbl_keyno}" disabled></td>
												</c:if>                         						
												<c:if test="${b.dbl_checkYN eq 'Y' }">
												<td><input type="checkbox" name="" id ="" value = "${b.dbl_keyno}" disabled></td>
												</c:if>
												<td>${b.COUNT}</td>
												<td><a href="javascript:;" onclick="detailView('${b.dbl_keyno}'); focus_p();">${b.dbl_p_name}</a></td>
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
													<td><a href="javascript:;" onclick="logAlarm('${b.dbl_keyno}');" style="color: #FF0000">전송실패</a></td>
												</c:if>
										</c:forEach>
											</tr>
									</tbody>
								</table>
							</div>
							<div style="text-align: center;">
							<button class="btn btn-sm btn-primary" id="deleteButton"
								type="button" onclick="sendNTS()" style="width : 100px; margin-left: 2%;">전송</button>
							<button class="btn btn-sm btn-primary" id="deleteButton"
								type="button" onclick="AllSendNTS()" style="width : 100px;">전체 전송</button>
<!-- 							<button class="btn btn-sm btn-primary" id="deleteButton" -->
<!-- 								type="button" onclick="delaysend()" style="width : 100px;">지연 전송</button> -->
							<button class="btn btn-sm btn-primary" id="deleteButton"
								type="button" onclick="deleteInfo()" style="width : 100px; background-color: #E53935;">삭제</button>
							<button class="btn btn-sm btn-primary" id="deleteButton"
								type="button" onclick="HomeIdUpdte()" style="width : 100px; background-color: #000000;">고유번호수정</button>
							</div>
							</div>
<%-- 하단 페이징 --%>
<div class="pageNumberBox dt-toolbar-footer">
	<c:if test="${not empty resultList3 }">
		<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
			<span class="pagetext">총 ${paginationInfo.totalRecordCount }건  / 총 ${paginationInfo.totalPageCount} 페이지 중 ${paginationInfo.currentPageNo} 페이지</span>
		</div>
		<div class="col-sm-6 col-xs-12" style="text-align: left;">
				<ul class="pageNumberUl" >
					<ui:pagination paginationInfo="${paginationInfo }" type="normal_board" jsFunction="pf_LinkPage" />
			    </ul>
		</div>
    </c:if>
    <c:if test="${empty resultList3 }">
    	<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
		<span class="pagetext">0건 중 0~0번째 결과(총  ${paginationInfo.totalRecordCount }건중 매칭된 데이터)</span>
		</div>
    </c:if>
</div>
<script type="text/javascript">

$(function(){
	pf_defaultPagingSetting('${search.orderBy}','${search.sortDirect}');
})


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

function TaxListUpdate_DY() {
	
	var subkey = $("#dbl_sub_keyno").val();
	
	$.ajax({
		url: '/autolist.do',
		type: 'POST',
		data: {
			"subkey" : subkey
		},
		async: false,
		success : function(data){
			alert(data)
			location.reload();
		}
	});
}


function DeleteUpdate() {
	
	var subkey = $("#dbl_sub_keyno").val();
	
	if(confirm("업데이트 된 리스트를 되돌리시겠습니까?")){	
		$.ajax({
			
			url: '/listDelete.do',
			type: 'POST',
			data: {
				"subkey" : subkey
			},
			async: false,
			success : function(data){
				alert(data)
				location.reload();
			}
		});	
	}else{
		
	}
	
}

function HomeIdUpdte() {
	
	var subkey = $("#dbl_sub_keyno").val();
	
	
	$.ajax({
		url: '/dyAdmin/bills/HomeIdUpdate.do',
		type: 'POST',
		data: {
			"subkey" : subkey
		},
		async: false,
		success : function(data){
			alert(data);
		}
	});	
}

function AllSendNTS(){
	
	var subkey = $("#dbl_sub_keyno").val();
	if(confirm("전체 전송하시겠습니까?")){	
		alert("전송 완료")
		location.reload();
		$.ajax({
			url: '/dyAdmin/bills/allSendNTS.do',
			type: 'POST',
			data: {
				"subkey" : subkey
			},
			success : function(data){
				alert(data);
				location.reload();
			}
		});
	}
}


</script>
