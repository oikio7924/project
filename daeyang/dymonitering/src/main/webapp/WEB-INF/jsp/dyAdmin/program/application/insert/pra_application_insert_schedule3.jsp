<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<div class="alert alert-info">
	<a class="close" data-dismiss="alert">×</a>
	<!-- <h4 class="alert-heading"><i class="fa fa-check-square-o"></i> Check validation!</h4> -->
	<p>
		프로그램에 대한 스케쥴 정보를 입력합니다.
	</p>
</div>
<header style="text-align:right;">
	<button class="btn btn-sm btn-success" id="Board_Delete" type="button" onclick="pf_addSchedule('C')"> 
		<i class="fa fa-plus"></i> 스케쥴 추가(캘린더형)
	</button>
	<button class="btn btn-sm btn-success" id="Board_Delete" type="button" onclick="pf_addSchedule('T')"> 
		<i class="fa fa-plus"></i> 스케쥴 추가(텍스트형)
	</button>
</header>
<fieldset>
	<p>스케쥴을 추가하여주세요.</p>	
</fieldset>						
										
										
<script>

$(function(){
	cf_setttingDialog("#insertScheduleText", "insert", "스케쥴 추가", "pf_insertScheduleText()");
})

//스케쥴 추가 모달창 오픈
function pf_addSchedule(type){
	if(type == 'T'){
		$('#insertScheduleText').dialog('open');
	}
}
</script>
										