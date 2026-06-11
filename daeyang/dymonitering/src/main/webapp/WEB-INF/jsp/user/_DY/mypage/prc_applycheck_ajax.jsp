<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<c:choose>
	<c:when test="${type eq 'apply' }">	
		<div id="ApplyTableWrap">
	<div class="subTableBox table_wrap_mobile" style="overflow-x: scroll;">
		<table class="tbl_01 tbl_last_txtL">
		<colgroup> 
			<col width="15%"> 
			<col width="15%">
			<col width="5%"> 
			<col width="20%"> 
			<col width="5%"> 
			<col width="15%">
			<col width="10%">
			<col width="5%">
			<col width="10%">
		</colgroup> 
			<caption>강좌내역</caption>
			<thead>
				<tr>
					<th class="programName">교육명</th>
					<th class="programDate">교육기간</th>
					<th class="programTime">시간</th>
					<th class="programNum">수강자</th>
					<th class="programPrice">결제금액</th>
					<th class="PriceExpired">결제만료일</th>
					<th class="programCon">상태</th>
					<th class="programCnt"></th>
					<th class="programSeat">예약좌석</th>
				</tr>
			</thead>
			<tbody id="applicationList">
				<c:if test="${not empty applyProgramList }">
					<c:forEach items="${applyProgramList }" var="model">
						<tr id="applyTr">
							<td>${model.AP_NAME}</td>
							<td><span class="applyDate">${model.APP_ST_DATE}</span></td>
							<td><span class="applyTime">${model.APP_ST_TIME}</span></td>
							<td>${model.APU_NAME }(${model.APU_RELATION })</td>
			        		<c:if test="${model.totalPrice == 0 || empty model.totalPrice }">
				        		<td>무료</td>		        		
			        		</c:if>
			        		<c:if test="${model.totalPrice != 0 && not empty model.totalPrice }">
				        		<td><fmt:formatNumber value="${model.totalPrice }" type="number"/>원</td>
			        		</c:if>
			        		<td class="PriceExpired">${model.APP_EXPIRED}</td>
			        		<c:choose>
			        			<c:when test="${search.searchCondition == 'B'}">
			        				<td>
			        					<c:if test="${model.APP_STATUS eq sp:getData('APPLY_WAITING')}">
			        						<a style="cursor: pointer;" onclick="pf_ProgramApply('P','<fmt:parseNumber value="${model.APP_KEYNO}"/>', '', '', '');" class="cancel">
			        						<font>결제하기</font>
			        						</a>
			        					</c:if>
			        					<c:if test="${model.APP_STATUS eq sp:getData('APPLY_COMPLETE')}">
			        						신청완료
			        					</c:if>
			        					<c:if test="${model.APP_STATUS eq sp:getData('APPLY_RESERVE')}">
			        						<font color="red">접수대기</font>
			        					</c:if>
			        				</td>
			        				<td>
			        					<c:if test="${model.APP_STATUS eq sp:getData('APPLY_WAITING')}">
			        						<button type="button" class="btn btnSmall_write btn-default" onclick="pf_ProgramApply('C','<fmt:parseNumber value="${model.APP_KEYNO}"/>', '${model.APP_COUNT }', '${model.APP_AP_KEYNO }', '${model.totalPrice }');" >신청취소</button>
			        					</c:if>
			        					<c:if test="${model.APP_STATUS eq sp:getData('APPLY_COMPLETE')}">
			        						<button type="button" class="btn btnSmall_write btn-default" onclick="pf_ProgramApply('C','<fmt:parseNumber value="${model.APP_KEYNO}"/>', '${model.APP_COUNT }', '${model.APP_AP_KEYNO }', '${model.totalPrice }');" >신청취소</button>
			        					</c:if>
			        					<c:if test="${model.APP_STATUS eq sp:getData('APPLY_RESERVE')}">
			        						<button type="button" class="btn btnSmall_write btn-default" onclick="pf_ProgramApply('C','<fmt:parseNumber value="${model.APP_KEYNO}"/>', '0',  '${model.APP_AP_KEYNO }', '${model.totalPrice }');" >신청취소</button>
			        					</c:if>
			        				</td>
			        			</c:when>
			        			<c:when test="${search.searchCondition == 'F'}">
			        				<td colspan="2">신청완료</td>
			        			</c:when>
			        			<c:when test="${search.searchCondition == 'R'}">
			        				<td colspan="2">취소완료</td>
			        			</c:when>
			        		</c:choose>
			        		<td class="ProgramSeat" >${model.SEATNAME}</td>
			        		
						</tr>
					</c:forEach>
				</c:if>
				<c:if test="${empty applyProgramList }">
					<tr>
						<td id="tdBlank" colspan="9">예매내역이 없습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>
	</div>
</div>
		
		<div class="page-box Page-box_02">
			<ul class="page-ul">
				<ui:pagination paginationInfo="${applyPaginationInfo }" type="normal_board" jsFunction="pf_linkpage_apply" />
			</ul>
		</div>
	</c:when>
	
	<c:when test="${type eq 'lecture' }">
	<div id="LectureTableWrap">
		<div class="A_table table_wrap_mobile">
	<table class="tbl_01 tbl_last_txtL">
		<colgroup>
			<col width="15%">
			<col width="20%">
			<col width="10%">
			<col width="20%">
			<col width="10%">
			<col width="15%">
			<col width="5%">
			<col width="5%">
		</colgroup>
		<caption>신청내역</caption>
		<thead>
			<tr>
				<th id="programApply">예매일</th>
				<th id="programDate">행사일시</th>
				<th id="programNum">예매번호</th>
				<th id="programName">프로그램명</th>
 				<th id="programPrice">결제금액</th>
 				<th class="PriceExpired">결제만료일</th>
				<th id="programCon">상태</th>
				<th id="programCnt"></th>
			</tr>
		</thead>
		<tbody id="lectureList">
			<c:if test="${not empty lectureProgramList }">
				<c:forEach items="${lectureProgramList }" var="model">
					<tr class="applyTr">
						<td>${model.REGDT}</td>
						<td><span class="applyDate">${model.APP_ST_DATE}</span> / <c:out value="${model.APP_ST_TIME}"/></td>
						<td>${model.APP_KEYNO}</td>
		        		<td>${model.AP_NAME}</td>
						<c:if test="${model.totalPrice == 0 || empty model.totalPrice }">
			        		<td>무료</td>		        		
		        		</c:if>
		        		<c:if test="${model.totalPrice != 0 && not empty model.totalPrice }">
			        		<td><fmt:formatNumber value="${model.totalPrice }" type="number"/>원</td>
		        		</c:if>
		        		<td class="PriceExpired">${model.APP_EXPIRED}</td>
		        		<c:choose>
		        			<c:when test="${search.searchCondition == 'B'}">
		        				<td>
		        					<c:if test="${model.APP_STATUS eq sp:getData('APPLY_WAITING')}">
		        						<a style="cursor:pointer;" onclick="pf_ProgramApply('P','<fmt:parseNumber value="${model.APP_KEYNO}"/>', '', '', '');" class="cancel">
			        						<font>결제하기</font>
		        						</a>
		        					</c:if>
		        					<c:if test="${model.APP_STATUS eq sp:getData('APPLY_COMPLETE')}">
		        						신청완료
		        					</c:if>
		        					<c:if test="${model.APP_STATUS eq sp:getData('APPLY_RESERVE')}">
		        						<font color="red">접수대기</font>
		        					</c:if>
		        				</td>
		        				<td>
		        					<c:if test="${model.APP_STATUS eq sp:getData('APPLY_WAITING')}">
		        						<button type="button" class="btn btnSmall_write btn-default" onclick="pf_ProgramApply('C','<fmt:parseNumber value="${model.APP_KEYNO}"/>', '${model.APP_COUNT }', '${model.APP_AP_KEYNO }', '${model.totalPrice }');" >신청취소</button>
		        					</c:if>
		        					<c:if test="${model.APP_STATUS eq sp:getData('APPLY_COMPLETE')}">
		        						<button type="button" class="btn btnSmall_write btn-default" onclick="pf_ProgramApply('C','<fmt:parseNumber value="${model.APP_KEYNO}"/>', '${model.APP_COUNT }', '${model.APP_AP_KEYNO }', '${model.totalPrice }');" >신청취소</button>
		        					</c:if>
		        					<c:if test="${model.APP_STATUS eq sp:getData('APPLY_RESERVE')}">
		        						<button type="button" class="btn btnSmall_write btn-default" onclick="pf_ProgramApply('C','<fmt:parseNumber value="${model.APP_KEYNO}"/>', '0',  '${model.APP_AP_KEYNO }', '${model.totalPrice }');" >신청취소</button>
		        					</c:if>
		        				</td>
		        			</c:when>
		        			<c:when test="${search.searchCondition == 'F'}">
			        				<td colspan="2">참여완료</td>
		        			</c:when>
		        			<c:when test="${search.searchCondition == 'R'}">
		        				<c:if test="${model.APP_STATUS eq sp:getData('APPLY_CANCEL')}">
	        						<td colspan="2">취소완료</td>
	        					</c:if>
		        				<c:if test="${model.APP_STATUS eq sp:getData('APPLY_EXPIRED')}">
	        						<td colspan="2" style="color: red">결제만료</td>
	        					</c:if>
		        			</c:when>
		        		</c:choose>
					</tr>
				</c:forEach>
			</c:if>
			<c:if test="${empty lectureProgramList }">
				<tr>
					<td id="tdBlank" colspan="8">예매내역이 없습니다.</td>
				</tr>
			</c:if>
		</tbody>
	</table>
</div>
		<div class="page-box Page-box_02">
			<ul class="page-ul">
				<ui:pagination paginationInfo="${lecturePaginationInfo }" type="normal_board" jsFunction="pf_linkpage_lecture" />
			</ul>
		</div>
</div>
		
<div id="UserTableWrap" style="display: none;">
	<div class="subTableBox table_wrap_mobile">
		<div class="subRealTitleBox" style="width:90%">
			<h2 class="usertitle">수강대상자관리</h2>
		</div>
		<table class="tbl_01 tbl_last_txtL" id="applicationTable">
			<colgroup>
				<col width="20%">
				<col width="60%">
				<col width="20%">
			</colgroup>
			<caption>수강대상자관리</caption>
			<tbody id="UserTableList">
			</tbody>
			<tbody>
			</tbody>
		</table>
		
	</div>
</div>

	</c:when>
	
		<c:when test="${type eq 'group' }">
		
		<div class="A_table table_wrap_mobile">
	<table class="tbl_01 tbl_last_txtL">
		<colgroup>
			<col width="10%">
			<col width="25%">
			<col width="40%">
			<col width="20%">
		</colgroup>
		<caption>신청내역</caption>
		<thead>
			<tr>
				<th id="programDiv">구분</th>
				<th id="programName">프로그램명</th>
				<th id="groupName">그룹이름</th>
				<th id="programDate">투어일정</th>
				<th id="tdCondition">상태</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${not empty groupProgramList }">
				<c:forEach items="${groupProgramList }" var="model">
					<tr>
						<td>${model.GM_DIVISION}</td>
						<td>${model.GM_NAME}</td>
		        		<td>
		        			<a href="javascript:;" onclick="pf_ApplyDetailView('${model.GP_KEYNO}');">
		        				${model.GP_GROUPNAME}
	       					</a>
	       				</td>
						<td><span class="gpDate">${model.GP_DATE}</span> / ${model.GP_TIME }</td>
						<td class="tdState">예약완료</td>
					</tr>
				</c:forEach>
			</c:if>
			<c:if test="${empty groupProgramList }">
				<tr>
					<td id="tdBlank" colspan="3">단체 신청 내역이 없습니다.</td>
				</tr>
			</c:if>
		</tbody>
	</table>
</div>
		<div class="page-box Page-box_02">
			<ul class="page-ul">
				<ui:pagination paginationInfo="${groupPaginationInfo }" type="normal_board" jsFunction="pf_linkpage_group" />
			</ul>
		</div>
	</c:when>
</c:choose>

<script>
var div = '${type}'
var type = '${search.searchCondition}'
$(function(){
//탭 css 처리
	if(type == "B"){
		$(".APD"+div).removeClass("fs16");
		$("#"+div+"Before").addClass("fs16");
	}else if(type == "F"){
		$(".APD"+div).removeClass("fs16");
		$("#"+div+"After").addClass("fs16");
	}else if(type == "R"){
		$(".APD"+div).removeClass("fs16");
		$("#"+div+"Refund").addClass("fs16");
	}
});

//단체예약 상세보기
function pf_ApplyDetailView(key){	//세션만료됐을때 처리?
		
		cf_loading();
		$.ajax({
			type: "POST",
			url: "/${tiles}/mypage/applycheck/applypopupAjax.do",
			data: "GP_KEYNO=" + key,
			async:false,
			success : function(data){
				$('#date').html(data.GP_DATE+ "/" +data.GP_TIME);
			/* 	var groupName = "<input type='text' name='GP_GROUPNAME' value='"+data.GP_GROUPNAME+"'/>" */
			 	$('#groupName').html(data.GP_GROUPNAME);
				$('#headCount').html(data.GP_HEADCOUNT);
				$('#leader').html(data.GP_NAME);
				$('#phone').html(data.GP_PHONE);
				$('#rider').html("유모차 :"+ data.GP_YUMOCAR  +"/  휠체어 :" + data.GP_WHEELCHAIR);
				if(data.GP_TRAFFIC == "C"){
					$('#traffic').html("대중교통");
				}else if(data.GP_TRAFFIC == "B"){
					$('#traffic').html("버스");
				}else{
					$('#traffic').html(data.GP_TRAFFIC_EXP);
				}
				
				$('#regdt').html(data.GP_REGDT); 
				
			},
			error: function(){
				alert('에러. 관리자한테 문의하세요.')
				location.reload();
				return false;
			}
		}).done(function(){
			cf_loading_out();
		});
		
	$('#GP_KEYNO').val(key);
	$('#updateGroup').dialog('open');
	
}
</script>
