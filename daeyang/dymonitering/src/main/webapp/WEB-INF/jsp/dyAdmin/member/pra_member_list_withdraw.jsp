<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>
.table-bordered th {
	text-align: center;
}
</style>

<!-- 회원 정보 등록 레이어창 --> 
<div id="member-withdraw" title="회원 탈퇴 목록">
	<div class="widget-body ">
		<table class="table table-bordered">
			<colgroup>
				<col width="10%">
				<col width="55%">
				<col width="25%">
				<col width="10%">
			</colgroup>
			<thead>
				<tr>
					<th>번호</th>
					<th>탈퇴 사유</th>
					<th>탈퇴 날짜</th>
					<th>성별</th>
				</tr>
			</thead>
			<tbody id="withdraw_tbody">
			</tbody>
		</table>
	</div>
</div>



<script type="text/javascript">

$(document).ready(function() {
	cf_setttingDialog('#member-withdraw','회원 탈퇴 목록');
});


function pf_openWithdrawPopup(){
	$("#withdraw_tbody").empty();
	$.ajax({
		type: "POST",
		url: "/dyAdmin/person/withdrawListAjax.do",
		async:false,
		success : function(list){
			$.each(list, function(i){
				var model = list[i];
				
				var temp = "";
				temp += "<tr>";
				temp += "<td>" + model.COUNT  + "</td>";
				temp += "<td>" + model.UW_DEL_REASON  + "</td>";
				temp += "<td>" + model.UW_REGDT  + "</td>";
				temp += "<td>" + model.UW_ZENDER  + "</td>";
				temp += "</tr>";
				
				$("#withdraw_tbody").append(temp);		
			});
				
			$('#member-withdraw').dialog('open');	
			$('#member-withdraw').css("max-height", "400px");

		},
		error: function(){
			alert('에러. 관리자한테 문의하세요.')
			return false;
		}
	});
	
	
}

</script>
