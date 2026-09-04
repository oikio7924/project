<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<link rel="stylesheet" type="text/css" href="/resources/common/css/program.css">
<style>
/* 	.subRightContentsBottomWrap{
		width: 60%;
		margin: 0 auto;
	} */
	.tbl_last_txtL tr th {
	    font-weight: normal;
		text-align: center;
		padding: 10px;
		border-bottom: 1px solid #dddddd !important;
		border-top: 1px solid #dddddd !important;
	}
	.tbl_01 td{
		text-align: left;
		padding-left: 15px;
		border-bottom: 1px solid #dddddd !important;
		border-top: 1px solid #dddddd !important;
	}
</style>
<section class="" id="updateGroup">
	<div class="receipt_pop_header"> 
		<div class="contents_pop_title" >투어 신청 내역</div> 
	</div>
	<!-- row -->
	<div class="row subRightContentsBottomWrap">
		<div class="row subImgFirstDiviceBox">
			<div class="centerBox" >	
				<div class="subRealTitleBox">
					<h1>기본내역</h1>
				</div>	
			</div>
		</div>
		
		<div class="subTableBox table_wrap_mobile">
			<table class="tbl_01 tbl_last_txtL">
				<colgroup>
					<col width="10%">
					<col width="25%">
				</colgroup>
				<caption>기본정보</caption>
				<tbody>
					<tr>
						<th>성명</th>	
						<td>${userInfo.UI_NAME}</td>	
					</tr>
					<tr>
						<th>휴대폰 번호</th>
						<td>${userInfo.UI_PHONE}</td>
					</tr>
					<tr>
						<th>이메일</th>
						<td>${userInfo.UI_EMAIL}</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<!-- row -->
	<div class="row subRightContentsBottomWrap">
		<div class="row subImgFirstDiviceBox">
			<div class="centerBox" >	
				<div class="subRealTitleBox">
					<h1>투어 신청 내역</h1>
				</div>	
			</div>
		</div>
		
		<div class="subTableBox table_wrap_mobile">
			<table class="tbl_01 tbl_last_txtL">
				<colgroup>
					<col width="10%">
					<col width="25%">
				</colgroup>
				<caption>기본정보</caption>
				<tbody>
					<tr>
						<th>구분</th>	
						<td> 코스</td>	
					</tr>
					<tr>
						<th>투어일시</th>
						<td id = "date"></td>
					</tr>
					<tr>
						<th>단체명</th>
						<td id = "groupName"></td>
					</tr>
					<tr>
						<th>참가인원</th>
						<td id = "headCount">명</td>
					</tr>
					<tr>
						<th>인솔자</th>
						<td id = "leader"></td>
					</tr>
					<tr>
						<th>인솔자 연락처</th>
						<td id = "phone"></td>
					</tr>
					<tr>
						<th>유모차/휠체어</th>
						<td id = "rider"> 개</td>
					</tr>
					<tr>
						<th>교통편</th>
						<td id = "traffic">
					
						</td >
					</tr>
					<tr>
						<th>온라인 신청일자</th>
						<td id ="regdt"></td>
					</tr>
				</tbody>
			</table>
		</div>
		<!-- 등록 박스 -->
	
	</div>

</section>

<script>
$(function(){
	/* 그룹 팝업 */
	cf_setttingDialog('#updateGroup','단체예약 정보','예약취소','pf_reservation_Cancel()');
	/*cf_setttingDialog2 ,'수정','pf_reservation_Update()' */
});

function pf_close(){
	window.close();
}




function pf_reservation_Cancel(){
	var key = $('#GP_KEYNO').val();
	if(confirm("예약을 취소하시겠습니까?")){
		$.ajax({
			url: '/${tiles}/mypage/applycheck/applyCancelAjax.do',
	        type: 'POST',
	        data: 'GP_KEYNO='+key,
	        async: false,  
	        success: function() {
	        	alert("예약이 취소되었습니다.");
	        	$('#updateGroup').dialog('close');
	        	location.reload();
	        },
	        error: function(){
	        	alert("에러, 관리자에게 문의하세요.");
	        }
		});
	}
}

/* function pf_reservation_Update(){
	var key = $('#GP_KEYNO').val();
	if(confirm("예약정보를 수정하시겠습니까?")){
		$.ajax({
			url: '/${tiles}/mypage/applycheck/applyUpdateAjax.do',
	        type: 'POST',
	        data:  {
	        	'GP_KEYNO' : key,
	        },
	        async: false,  
	        success: function(data) {
	         alert('dd?');
	        	
	        	
	        },
	        error: function(){
	        	alert("에러, 관리자에게 문의하세요.");
	        }
		});
	}
	
	
} */
</script>