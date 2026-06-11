<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<link rel="stylesheet" type="text/css" href="/resources/common/css/program.css">
<style>
/* 페이지 넘버 */
.pageNumberBox {width:100%; margin-bottom:20px; text-align:center;}
.pageNumberUl {display:inline-block; text-align:center;}
.pageNumberUl:after { visibility: hidden; display:block;font-size: 0;content:".";clear: both;height: 0;*zoom:1;}
.pageNumberUl li { float:left; margin:0 2px; padding:3px; border:1px solid #e5e6e5; vertical-align:middle;min-width:30px;}
.pageNumberUl li a { font-size:13px; color:#58595b; display:inline-block; width:100%; height:100%; padding:2px 5px 3px; text-align:center;}
.pageNumberUl li.active {background-color:#58595b;}
.pageNumberUl li.active a {color:#fff;}
.pagetext{font-size: 16px;}
@media all and (max-width:850px){	
	.pageNumberUl {margin-top:10px;}
}
</style>

<div class="left mgB15">
	<div>
		<a href="javascript:;" onclick="pf_applySort(this, 'B');" class="default_btn mgT10 left APD" id="applyBefore">
			관람 전
		</a>
		<a href="javascript:;" onclick="pf_applySort(this, 'F');" class="default_btn mgT10 APD" id="applyAfter">
			관람 후
		</a>
		<a href="javascript:;" onclick="pf_applySort(this, 'R');" class="default_btn mgT10 right APD" id="applyRefund">
			취소 / 환불
		</a>
	</div>
</div>
<div class="subTableBox table_wrap_mobile">
	<table class="tbl_01 tbl_last_txtL" id="applicationTable">
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
				<th id="programName">행사명</th>
				<th id="programPrice">결제금액</th>
				<th class="PriceExpired">결제만료일</th>
				<th id="programCon">상태</th>
				<th id="programCnt"></th>
			</tr>
		</thead>
		<tbody id="applicationList">
			<c:if test="${not empty programList }">
				<c:forEach items="${programList }" var="model">
					<tr id="applyTr">
						<td>${model.REGDT}</td>
						<td><span class="applyDate">${model.APP_ST_DATE}</span> /(${model.APP_SEQUENCE})${model.APP_ST_TIME}</td>
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
		        						<font onclick="pf_ProgramApply('P','<fmt:parseNumber value="${model.APP_KEYNO}"/>', '', '', '');" class="cancel">결제하기</font>
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
			        				<td colspan="2">관람완료</td>
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
			<c:if test="${empty programList }">
				<tr>
					<td id="tdBlank">예매내역이 없습니다.</td>
				</tr>
			</c:if>
		</tbody>
	</table>
</div>
<div id="pageDiv">
	<div class="pageNumberBox dt-toolbar-footer">
		<c:if test="${not empty programList }">
			<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
				<span class="pagetext">총 ${pageInfo.totalRecordCount }건  / 총 ${pageInfo.totalPageCount} 페이지 중 ${pageInfo.currentPageNo} 페이지</span>
			</div>
			<div class="col-sm-6 col-xs-12">
					<ul class="pageNumberUl" >
						<ui:pagination paginationInfo="${pageInfo }" type="normal_board" jsFunction="pf_LinkPage" />
				    </ul>
			</div>
	    </c:if>
	    <c:if test="${empty programList }">
	    	<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
			<span class="pagetext">0건 중 0~0번째 결과(총  ${pageInfo.totalRecordCount }건중 매칭된 데이터)</span>
			</div>
	    </c:if>
	</div>
</div>
<!-- end widget grid -->
<form:form id="Form" method="post">
	<input type="hidden" name="pageIndex" id="pageIndex" value="${search.pageIndex}">
	<input type="hidden" name="searchCondition" id="searchCondition" value="">
</form:form>
      
<script>

var type = '${search.searchCondition}'
//화면 호출시 가장 먼저 호출되는 부분
$(function (){
	if(type == "B"){
		$(".APD").removeClass("fs16");
		$("#applyBefore").addClass("fs16");
		$(".PriceExpired").show();
		$("#applicationList #tdBlank").attr("colspan", 8);
	}else if(type == "F"){
		$(".APD").removeClass("fs16");
		$("#applyAfter").addClass("fs16");
		$(".PriceExpired").hide();
		$("#applicationList #tdBlank").attr("colspan", 7);
	}else if(type == "R"){
		$(".APD").removeClass("fs16");
		$("#applyRefund").addClass("fs16");
		$(".PriceExpired").hide();
		$("#applicationList #tdBlank").attr("colspan", 7);
	}
});

//페이지 넘기기
function pf_LinkPage(num){
	$('#pageIndex').val(num);
	$('#searchCondition').val(type);
	$('#Form').attr('action','/dy/mypage/applycheck/program/iframe.do?type=A');
	$('#Form').submit();
}

//신청프로그램 환불하기
function pf_ProgramApply(type, key, Num, apkey, price){	
	if(price == ''){
		price = 0;
	}
	var setkey = cf_getKeyno(key, "APP");
	if(type == 'C'){
		if(confirm("취소하시겠습니까?")){
			$.ajax({
				url: '/dy/mypage/programApplyAjax.do',
		        type: 'POST',
		        data:  {
		        	'APP_KEYNO'  : setkey,
		        	'APPtype' 	 : type,
		        	'ApplyCont'  : Num,
		        	'AP_KEYNO'	 : apkey,
		        	'price'		 : price
		        },
		        async: false,  
		        success: function() {
		        	alert("취소되었습니다.");
		        	location.reload();
		        },
		        error: function(){
		        	alert("에러, 관리자에게 문의하세요.");
		        }
			});
		}
	}else if(type == 'P'){
		$.ajax({
			url: '/dy/mypage/programApplyAjax.do',
	        type: 'POST',
	        data:  {
	        	'APP_KEYNO' : setkey,
	        	'APPtype' : type
	        },
	        async: false,  
	        success: function() {
	        	alert("결제되었습니다.");
	        	location.reload();
	        },
	        error: function(){
	        	alert("에러, 관리자에게 문의하세요.");
	        }
		});
	}
	
}

//예매내역 구분
function pf_applySort(obj, type){
	
	$('#pageIndex').val(1);
	$('#searchCondition').val(type);
	$('#Form').attr('action','/dy/mypage/applycheck/program/iframe.do?type=A');
	$('#Form').submit();
	return false;
	
}

document.body.scrollIntoView(true);
parent.document.all.applyFrame.height = document.body.scrollHeight; 

</script>