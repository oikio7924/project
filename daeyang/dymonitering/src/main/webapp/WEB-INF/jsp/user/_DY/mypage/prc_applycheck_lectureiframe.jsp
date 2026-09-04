<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script src="/resources/api/mask/jquery.mask.js"></script>
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

/* 수강자 리스트쪽 버튼 */
.userList, .userDelete , .userUpdate{ border: 1px solid;   border-radius: 5px;   padding: 3px 15px;  font-size: 13px;}
.userList{ background: #353333; 	color: #ffffff;}
a.userUpdate{cursor:pointer;text-decoration:none;   background: #e22931; 	color: #ffffff;}
a.userDelete{ cursor:pointer;    text-decoration:none;    background: #ffffff; 	color: #000; 	margin-left: 5px;}
#userAdd{display: none;}
.usertitle{margin: 10px 0 5px;  font-size: 18px;  color: #e22931;   background-size: auto;}
#UserTableWrap{margin-top: 60px;}

/* 수강대상자 팝업 */
#UserTableList .apuName, #UserTableList .apuRelation, #UserTableList .bracket{ width: auto; float: left;}
#UserTableList .bracket,  #UserTableList .apuRelation{padding: 0;}
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
	<div style="position: absolute; right: 0; top:25px;">
		<button class="userList" id="userList" onclick="pf_lectureUserList();">수강대상자 목록</button>
		<button class="userList" id="userAdd" onclick="pf_lectureUserAdd('N');">수강대상자 추가등록 +</button>
	</div>
</div>
<div id="LectureTableWrap">
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
			<caption>강좌내역</caption>
			<thead>
				<tr>
					<th id="programName">교육명</th>
					<th id="programDate">교육기간</th>
					<th id="programTime">시간</th>
					<th id="programNum">수강자</th>
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
			        				<td colspan="2">신청완료</td>
			        			</c:when>
			        			<c:when test="${search.searchCondition == 'R'}">
			        				<td colspan="2">취소완료</td>
			        			</c:when>
			        		</c:choose>
						</tr>
					</c:forEach>
				</c:if>
				<c:if test="${empty programList }">
					<tr>
						<td id="tdBlank" colspan="8">예매내역이 없습니다.</td>
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
</div>

<div id="UserTableWrap" style="display: none;">
	<div class="subTableBox table_wrap_mobile">
		<div class="subRealTitleBox">
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


<!-- end widget grid -->
<form:form id="Form" method="post">
	<input type="hidden" name="pageIndex" id="pageIndex" value="${search.pageIndex}">
	<input type="hidden" name="searchCondition" id="searchCondition" value="">
</form:form>

<script>
var UIKEY = '${userInfo.UI_KEYNO}'
var type = '${search.searchCondition}'
var action = '${action}';
//화면 호출시 가장 먼저 호출되는 부분
$(function (){
	$("#APUBIRTH").mask('0000-00-00');
	
	if(type == "B"){
		$(".APD").removeClass("fs16");
		$("#applyBefore").addClass("fs16");
		$(".PriceExpired").show();
		$("#lectureList #tdBlank").attr("colspan", 8);
	}else if(type == "F"){
		$(".APD").removeClass("fs16");
		$("#applyAfter").addClass("fs16");
		$(".PriceExpired").hide();
		$("#lectureList #tdBlank").attr("colspan", 7);
	}else if(type == "R"){
		$(".APD").removeClass("fs16");
		$("#applyRefund").addClass("fs16");
		$(".PriceExpired").hide();
		$("#lectureList #tdBlank").attr("colspan", 7);
	}
	
	if(action){
		pf_lectureUserList();
	}
	
});

//페이지 넘기기
function pf_LinkPage(num){
	$('#pageIndex').val(num);
	$('#searchCondition').val(type);
	$('#Form').attr('action','/dy/mypage/applycheck/program/iframe.do?type=L');
	$('#Form').submit();
}

//신청프로그램 환불하기
function pf_ProgramApply(type, key, Num, apkey, price){	
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
	$('#Form').attr('action','/dy/mypage/applycheck/program/iframe.do?type=L');
	$('#Form').submit();
	return false;
}

//수강대상자 목록
function pf_lectureUserList(){
	
	$.ajax({
		url: '/dy/mypage/ApplyUserListAjax.do',
        type: 'POST',
        data:  {
        	'key' : UIKEY
        },
        async: false,  
        success: function(data) {
        	var userList = [];
        	var userList = data.UserList;
        	
        	$.each(userList, function(i){
        		users = userList[i];
        		var key = cf_setKeyno(users.APU_KEYNO);
        		var temp =  '<tr>';
        			temp += '<th><span class="apuName">'+users.APU_NAME+'</span><span class="bracket">(</span><span class="apuRelation">'+users.APU_RELATION+'</span><span class="bracket">)</span></th>';
        			temp += '<td><span class="apuPhone">'+users.APU_PHONE+'</span> <span style="margin-left: 20px;" class="apuBirth">'+users.APU_BIRTH+'</span></td>';
        			temp += '<td>';
        			if(users.APU_SELFYN == 'N'){
        				temp += '<a class="userUpdate" title="수정하기" onclick="pf_lectureUserUpdate(this, \''+key+'\', \''+users.APU_GENDER+'\');">수정하기</a><a class="userDelete"  title="삭제하기" onclick="pf_lectureUserDelete(this, \''+key+'\');">삭제하기</a>';
        			}
        			temp += '</td></tr>';
        		
        		$("#UserTableList").append(temp);	
        	});
        	
        	$(".APD").removeClass("fs16");
        	$("#LectureTableWrap, #userList").hide();
        	$("#UserTableWrap, #userAdd").show();
        },
        error: function(){
        	alert("에러, 관리자에게 문의하세요.");
        }
	});
	
	//자동 길이 조절
	document.body.scrollIntoView(true);
	parent.document.all.leactureFrame.height = document.body.scrollHeight; 
}

//수강대상자 등록 팝업
function pf_lectureUserAdd(type){
	
	parent.AllWrap();
	if(type == 'N'){
		parent.pf_reset();
	}
}

//수강생 삭제
function pf_lectureUserDelete(obj, key){
	$tr = $(obj).closest("tr");
	
	if(confirm("수강대상자를 삭제하시겠습니까?")){
		$.ajax({
		    type   : "POST",
		    url    : "/dy/function/userDeleteAjax.do",
		    data   : {
		    	"APU_KEYNO": key
		    },
		    async:false,
		    success:function(data){
		    	$tr.remove();
		    	alert("삭제되었습니다.")
		    },
		    error: function() {
		    	alert("에러, 관리자에게 문의하세요.");
		    }
		});
	}
}

//수강생 추가
function family_regist(key){
	var gender = $(':input[name=GENDER]:radio:checked').val();
	var relation = $(':input[name=RELATION]:radio:checked').val();
	if(!$("#APUNAME").val()){
		alert("이름을 입력해주세요.");
		$("#APUNAME").focus();
		return false;
	}
	if(!gender){
		alert("성별을 선택해주세요.");
		return false;
	}
	if(!relation){
		alert("관계를 선택해주세요.");
		return false;
	}
	if(!$("#APUPHONE").val()){
		alert("휴대폰 번호를 입력해주세요.");
		$("#APUPHONE").focus();
		return false;
	}
	if(!$("#APUBIRTH").val()){
		alert("생년월일을 입력해주세요.");
		$("#APUBIRTH").focus();
		return false;
	}
	$("#APU_NAME").val($("#APUNAME").val());
	$("#APU_RELATION").val(relation);
	$("#APU_PHONE").val($("#APUPHONE").val());
	$("#APU_BIRTH").val($("#APUBIRTH").val());
	$("#APU_GENDER").val(gender);
	$.ajax({
	    type   : "POST",
	    url    : "/dy/function/userInsertAjax.do",
	    data   : $("#UserForm").serialize(),
	    async:false,
	    success:function(data){
	    	$("html").css("overflow-y", "");
			$("body").css("overflow-y", ""); 
			$("#pop_bg_opacity").fadeOut(); 
			$("#tour_contents_pop_box").hide();  
			var apukey = cf_setKeyno(data.APU_KEYNO);
			var temp =  '<tr>';
    			temp += '<th><span class="apuName">'+data.APU_NAME+'</span><span class="bracket">(</span><span class="apuRelation">'+data.APU_RELATION+'</span><span class="bracket">)</span></th>';
    			temp += '<td><span class="apuPhone">'+data.APU_PHONE+'</span> <span style="margin-left: 20px;" class="apuBirth">'+data.APU_BIRTH+'</span></td>';
    			temp += '<td>';
    			if(data.APU_SELFYN == 'N'){
    				temp += '<a class="userUpdate" title="수정하기" onclick="pf_lectureUserUpdate(this, \''+apukey+'\', \''+data.APU_GENDER+'\');">수정하기</a><a class="userDelete"  title="삭제하기" onclick="pf_lectureUserDelete(this, \''+apukey+'\');">삭제하기</a>';
    			}
    			temp += '</td></tr>';
			$("#UserTableList").append(temp);
	    },
	    error: function() {
	    	alert("에러, 관리자에게 문의하세요.");
	    }
	});
}

//수강생 수정
function pf_lectureUserUpdate(obj, key, MF){
	$tr = $(obj).closest("tr");
	var name = $tr.find(".apuName").text();
	var relation = $tr.find(".apuRelation").text();
	var phone = $tr.find(".apuPhone").text();
	var birth = $tr.find(".apuBirth").text();
	var gender = MF;
	
	$(parent.document).find("#APU_KEYNO").val(key);
	$(parent.document).find("#APUNAME").val(name);
	$(parent.document).find("#APUPHONE").val(phone);
	$(parent.document).find("#APUBIRTH").val(birth);
	$(parent.document).find("input:radio[name=GENDER][value="+gender+"]").prop("checked", true);
	$(parent.document).find("input:radio[name=RELATION][value="+relation+"]").prop("checked", true);
	$(parent.document).find("input[name=GENDER]");
	pf_lectureUserAdd('U');
}

document.body.scrollIntoView(true);
parent.document.all.leactureFrame.height = document.body.scrollHeight; 
</script>