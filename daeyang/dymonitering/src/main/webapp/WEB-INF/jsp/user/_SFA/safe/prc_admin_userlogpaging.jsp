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
<div class="tableMobileWrap" style="overflow-x: auto;">
<table id="dt_basic" class="pagingTable table table-striped table-bordered table-hover">
	<thead>
		<%-- 모든필드 , 게시글 갯수 시작  --%>
		<tr>
			<th colspan="${colspan}">
				<div style="float:left;">
					<input type="text" class="form-control search-control" data-searchindex="all" placeholder="모든필드 검색" style="width:200px;display: inline-block;" />
					<button class="btn btn-sm btn-primary smallBtn" type="button" onclick="pf_LinkPage()" style="margin-right:10px;">
						<i class="fa fa-plus"></i> 검색
					</button>
					<button class="btn btn-sm btn-primary" type="button" onclick="location.href='/sfa/safe/checkingStatus.do'" style="margin-right:10px;">
						<i class="glyphicon glyphicon-chevron-up"></i> 안전관리 페이지로 이동
					</button>
				</div>
				
				</th>
		</tr>
		</thead>
		<%-- 모든필드  ,  엑셀다운, 게시글 갯수 끝  --%>
											<colgroup>
											<col style="width: 20%;">
											<col style="width: 20%;">
											<col style="width: 20%;">
											<col style="width: 20%;">
											<col style="width: 20%;">
										</colgroup>
										<thead>
										<tr>
											<th class="hasinput"><input type="text"
												class="form-control search-control" data-searchindex="1"
												placeholder="번호 검색" /></th>
											<th class="hasinput"><input type="text"
												class="form-control search-control" data-searchindex="2"
												placeholder="발전소 검색" /></th>
											<th class="hasinput"><input type="text"
												class="form-control search-control" data-searchindex="3"
												placeholder="주소 검색" /></th>
											<th class="hasinput">카카오톡 전송 여부</th>
											<th class="hasinput">문자 전송 여부</th>
										</tr>
										<%-- 화살표 정렬 --%>
										<tr>
											<th class="arrow" style="text-align: center;" data-index="1">번호</th>
											<th class="arrow" style="text-align: center;" data-index="2">발전소 명</th>
											<th class="arrow" style="text-align: center;" data-index="3">주소</th>
											<th style="text-align: center;"><input type="checkbox" id="cbx_chkAll" onclick="seletAll()" onchange="allcheck()"></th>
											<th style="text-align: center;"><input type="checkbox" id="cbx_chkAll2" onclick="seletAll2()"></th>
										</tr>
									</thead>
									<tbody style="text-align: center;">
										<c:if test="${empty resultList4 }">
											<tr>
												<td colspan="8">검색된 데이터가 없습니다.</td>
											</tr>
										</c:if>
										<c:forEach items="${resultList4}" var="b">
											<c:if test="${b.SU_Del_YN eq 'N' }">
												<tr>
													<td style="white-space: nowrap;">${b.COUNT}</td>
													<td style="white-space: nowrap;"><a href="javascript:;" onclick="providerSelect2('${b.SU_KEYNO }')">${b.SU_SA_SULBI}</a></td>
													<td style="white-space: nowrap;">${b.SU_SA_AD}</td>
													<c:if test="${b.SU_SA_KAKAOYN eq 'Y'}">
													<td id ="chktd"><input type="checkbox" name="chk" id ="chk" value = "${b.SU_KEYNO}" onChange="checkcheck(this.value)" checked> </td>
													</c:if>
													<c:if test="${b.SU_SA_KAKAOYN eq 'N'}">
													<td id ="chktd"><input type="checkbox" name="chk" id ="chk" value = "${b.SU_KEYNO}" onChange="checkcheck(this.value)"> </td>
													</c:if>
													<c:if test="${b.SU_SA_MSGYN eq 'Y'}">
													<td id ="chktd"><input type="checkbox" name="chk2" id ="chk2" value = "${b.SU_KEYNO}" onChange="checkcheck2(this.value)" checked></td>
													</c:if>
													<c:if test="${b.SU_SA_MSGYN eq 'N'}">
													<td id ="chktd"><input type="checkbox" name="chk2" id ="chk2" value = "${b.SU_KEYNO}" onChange="checkcheck2(this.value)"></td>
													</c:if>
												</tr>
											</c:if>
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


function seletAll(){
	
	if($("#cbx_chkAll").is(":checked")) $("input[name=chk]").prop("checked", true);
	else $("input[name=chk]").prop("checked", false);
}

function allcheck() {
	
	var array = new Array(); 
	$('input:checkbox[name=chk]:checked').each(function() { // 체크된 체크박스의 value 값을 가지고 온다.
	    array.push(this.value);
	});
	
	$("#chkvalue").val(array);
	console.log($("#chkvalue").val());
	
// 	$.ajax({
// 		url: '/sfa/Admin/KaKaoSelect.do?${_csrf.parameterName}=${_csrf.token}',
// 		type: 'POST',
// 		data: $('#Form').serializeArray(),
// 		async: false,
// 		success : function(data){
// 			alert("qwe");
// 			for(int i=0; i<data.length; i++){
				
// 				console.log(data[i].SU_SA_KAKAOYN);
				
// 				if(data[i].SU_SA_KAKAOYN == "Y"){
// 					$.ajax({
// 						url: '/sfa/Admin/KakaoTalkCheckN.do?${_csrf.parameterName}=${_csrf.token}',
// 						type: 'POST',
// 						data: {
// 				        	"SU_KEYNO": data[i].SU_KEYNO
// 				        },
// 						async: false,
// 						success : function(data){
// 						}
// 					});
// 				}else if(data[i].SU_SA_KAKAOYN == "N"){
// 					$.ajax({
// 						url: '/sfa/Admin/KakaoTalkCheckY.do?${_csrf.parameterName}=${_csrf.token}',
// 						type: 'POST',
// 						data: {
// 				        	"SU_KEYNO": data[i].SU_KEYNO
// 				        },
// 						async: false,
// 						success : function(data){
// 						}
// 					});	
// 				}
// 			}
// 		}
// 	});		
}

function seletAll2(){
	
	if($("#cbx_chkAll2").is(":checked")) $("input[name=chk2]").prop("checked", true);
	else $("input[name=chk2]").prop("checked", false);
}

function checkcheck(value){
	$.ajax({
		url: '/sfa/Admin/KaKaoSelect.do?${_csrf.parameterName}=${_csrf.token}',
		type: 'POST',
		data: {
        	"SU_KEYNO": value
        },
		async: false,
		success : function(data){
			
			console.log(data[0].SU_SA_KAKAOYN);
			
			if(data[0].SU_SA_KAKAOYN == "Y"){
				$.ajax({
					url: '/sfa/Admin/KakaoTalkCheckN.do?${_csrf.parameterName}=${_csrf.token}',
					type: 'POST',
					data: {
			        	"SU_KEYNO": value
			        },
					async: false,
					success : function(data){
					}
				});
			}else if(data[0].SU_SA_KAKAOYN == "N"){
				$.ajax({
					url: '/sfa/Admin/KakaoTalkCheckY.do?${_csrf.parameterName}=${_csrf.token}',
					type: 'POST',
					data: {
			        	"SU_KEYNO": value
			        },
					async: false,
					success : function(data){
					}
				});	
			}
		}
	});
}

function checkcheck2(value){
	$.ajax({
		url: '/sfa/Admin/KaKaoSelect.do?${_csrf.parameterName}=${_csrf.token}',
		type: 'POST',
		data: {
        	"SU_KEYNO": value
        },
		async: false,
		success : function(data){
			
			console.log(data[0].SU_SA_MSGYN);
			
			if(data[0].SU_SA_MSGYN == "Y"){
				$.ajax({
					url: '/sfa/Admin/MsgCheckN.do?${_csrf.parameterName}=${_csrf.token}',
					type: 'POST',
					data: {
			        	"SU_KEYNO": value
			        },
					async: false,
					success : function(data){
					}
				});
			}else if(data[0].SU_SA_MSGYN == "N"){
				$.ajax({
					url: '/sfa/Admin/MsgCheckY.do?${_csrf.parameterName}=${_csrf.token}',
					type: 'POST',
					data: {
			        	"SU_KEYNO": value
			        },
					async: false,
					success : function(data){
					}
				});	
			}
		}
	});
}

</script>
