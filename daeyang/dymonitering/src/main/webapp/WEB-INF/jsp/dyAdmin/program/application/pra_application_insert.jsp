<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script src="/resources/api/mask/jquery.mask.js"></script>

<style>
.jarviswidget-color-blueDark .nav-tabs li:not(.active) a {color:#333 !important;}
.popover {
z-index: 1052;
}
</style>

<!-- widget grid -->
<section id="widget-grid" class="">
	<div class="row">
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
			<!-- Widget ID (each widget will need unique ID)-->
			<div class="jarviswidget jarviswidget-color-blueDark" id="wid-id-0"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>프로그램 ${action eq 'Insert' ? '등록':'수정' }</h2>

				</header>
				<!-- widget div-->
				<div>
					<!-- widget edit box -->
					<div class="jarviswidget-editbox">
						<!-- This area used as dropdown edit box -->
					</div>
					<!-- end widget edit box -->
					
					<!-- widget content -->
					<div class="widget-body">
						<form:form id="Form" class="smart-form" name="Form" method="post">
							<input type="hidden" name="AP_KEYNO" value="${resultData.AP_KEYNO }">
							<input type="hidden" name="AP_DEADLINE" id="AP_DEADLINE">
							<input type="hidden" name="schduleGroupData" id="schduleGroupData" value="">
							<input type="hidden" name="App_type" id="App_type" value="">
							<input type="hidden" name="AP_STDT" id="AP_STDT" value="${resultData.AP_STDT }">
							<input type="hidden" name="AP_ENDT" id="AP_ENDT" value="${resultData.AP_ENDT }">
							<input type="hidden" name="AP_MN_HOMEDIV_C" id="AP_MN_HOMEDIV_C" value="${AP_MN_HOMEDIV_C}">
							<input type="hidden" id="action" name="action" value="${action}" />
		 
						<div class="tab-content" style="margin:5px;">
							<div class="tab-pane active">
								<ul class="nav nav-tabs">
									<li class="active">
										<a href="#iss1" data-toggle="tab" aria-expanded="false">프로그램 관리</a>
									</li>
									<li class="">
										<a href="#iss2" data-toggle="tab" aria-expanded="false">스케줄 관리</a>
									</li>
								<!-- 	<li class="">
										<a href="#iss3" data-toggle="tab" aria-expanded="true">요금 관리</a>
									</li> -->
								</ul>
								<div class="tab-content padding-10">
									<div class="tab-pane active in " id="iss1">
									<%@ include file="insert/pra_application_insert_main.jsp"%>
									</div>
									<div class="tab-pane fade" id="iss2">
									<%@ include file="insert/pra_application_insert_schedule.jsp"%>
									</div>
								</div>
							</div>
						</div>
						<footer> 
							<button class="btn btn-sm btn-default" type="button" onclick="cf_back('/dyAdmin/program/application/application.do')"> 
								<i class="fa fa-times"></i> 목록
							</button>
							<c:if test="${action eq 'Insert' }">
								<button class="btn btn-sm btn-primary" type="button" onclick="pf_programAction('${action}')">	
									<i class="fa fa-floppy-o"></i> 저장
								</button>
							</c:if>
							<c:if test="${action eq 'Update' }">
								<button class="btn btn-sm btn-danger" type="button" onclick="pf_programAction('Delete')">	
									<i class="fa fa-floppy-o"></i> 삭제
								</button>
								<button class="btn btn-sm btn-primary" type="button" onclick="pf_programAction('${action}')">	
									<i class="fa fa-floppy-o"></i> 수정
								</button>
							</c:if>
							 
						</footer>
						</form:form>
					</div>
					<!-- end widget content -->
				</div>
				<!-- end widget div -->
			</div>
			<!-- end widget -->
		</article>
	</div>
	
</section>
<!-- end widget grid -->


<script>
var typeApply = '${sp:getData("PROGRAM_APPLY")}';
var typeLecture = '${sp:getData("PROGRAM_LECTURE")}';
var DEADLINE = '${resultData.AP_DEADLINE}';

$(function(){
	//$('.nav-tabs li a').eq(1).trigger('click');
// 	$("#apply_start, #apply_end").mask('yyyy-dd-mm');
})

function pf_programAction(type){
	$('#action').val(type);
	if(type != 'Delete'){
		if(!pf_checkForm()){
			return false;
		}
	}
var functionName = '';
	if(type == 'Insert'){
		type = '등록';
		functionName = pf_programInsert;
	}else if(type == 'Update'){
		type = '수정';
		if(DEADLINE == 'Y'){
			alert("마감된 프로그램입니다.");
			return false;
		}
		functionName = pf_programUpdate;
	}else{
		type = '삭제';
		functionName = pf_programDelete;
	}
	
	if(confirm(type+"하시겠습니까?")){
		functionName();
		cf_replaceTrim($("#Form"));
		$('#Form').attr('action','/dyAdmin/program/application/action.do');
		$('#Form').submit();
	}
}


function pf_programInsert(){
	var deadline = $("input[name=DEADLINE]").prop("checked");
	if(deadline){
		$("#AP_DEADLINE").val("Y");
	}else if(!deadline){
		$("#AP_DEADLINE").val("N");		
	}
}

 function pf_programUpdate(){
	if(applyCount != 0){
		$("#App_type").val('X');
	}else{
		$("#App_type").val('O');
	}
}
 
 function pf_programDelete(){
		if(applyCount != null && applyCount != 0){
			cf_smallBox('error', '신청자가 있는 프로그램은 삭제하실 수 없습니다.', 3000,'#d24158');
			return false;
		}
}

var applyCount = '${ApplyCnt}'
function pf_applyLimit(){
	if(applyCount != 0){
		alert("신청자가 있는 프로그램은 스케줄을 변경 하실 수 없습니다.");
		return false;
	}else{
		return true;
	}
	
}


function pf_checkForm(){
	
	if(!pf_checkVal('#AP_NAME','프로그램 이름을 입력해주세요.',0)){
		
		return false;
	}
	
	if(!pf_checkVal('#AP_DATE_COMMENT','프로그램 일시를 입력해주세요.',0)){
		
		return false;
	}

	if(!pf_checkVal('#AP_PLACE','장소를 선택해주세요.',0)){
		return false;
	}
	
	if(!pf_checkVal('#AP_SUMMARY','프로그램 설명을 입력해주세요.',0)){
		return false;
	}
	
	if($("#AP_TYPE").val() == typeApply){
		if(!pf_checkVal('#AP_TICKET_CNT','예매 가능한 최대수를 입력해주세요.',0)){
			return false;
		}
	}else if($("#AP_TYPE").val() == typeLecture){
		if($('input[name=AP_LIMIT_AGE_YN]:checked').val() == 'Y'){
			var min = parseInt($('#AP_LIMIT_AGE_MIN').val());
			var max = parseInt($('#AP_LIMIT_AGE_MAX').val());
			if(min == '0'){
				alert('나이제한 최소값을 설정하여주세요.');
				$('.nav-tabs li a').eq(0).trigger('click');
				setTimeout(function(){
					$('#AP_LIMIT_AGE_MIN').focus();	
				},300)
				return false;
			}
			if(max == '0'){
				alert('나이제한 최대값을 설정하여주세요.');
				$('.nav-tabs li a').eq(0).trigger('click');
				setTimeout(function(){
					$('#AP_LIMIT_AGE_MAX').focus();	
				},300)
				return false;
			}
			if(min > max){
				alert('나이제한 최대값보다 최소값이 더 큽니다.확인하여주세요.');
				$('.nav-tabs li a').eq(0).trigger('click');
				setTimeout(function(){
					$('#AP_LIMIT_AGE_MAX').focus();	
				},300)
				return false;
				
			}
		}
	}
	
	var charge = parseInt($("#AP_PRICE").val());
	var ap_expried = parseInt($("#AP_EXPIRED").val());
	if(charge > 0 && ap_expried == 0){
		alert('결제 만료일수를 입력해주세요.');
		$('.nav-tabs li a').eq(0).trigger('click');
		setTimeout(function(){
			$('#AP_EXPIRED').focus();	
		},300)
		return false;
	}
	

	if($("#apply_start").val()){
		if(!/^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/.test( $("#apply_start").val() )){
			alert("날짜 형식이 올바르지 않습니다.(YYYY-MM-DD)");
			$("#apply_start").focus();
			return false;
		}
	}
	
	if($("#apply_end").val()){
		if(!/^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/.test( $("#apply_end").val() )){
			alert("날짜 형식이 올바르지 않습니다.(YYYY-MM-DD)");
			$("#apply_end").focus();
			return false;
		}
	}
	
	if(scheduleList.length < 1){
		alert('스케줄을 등록하여주세요.');
		$('.nav-tabs li a').eq(1).trigger('click');
		return false;
	}
	
	var AP_STDT;
	var AP_ENDT;
	for(var i in scheduleList ){
		if(scheduleList[i]){
			var st_date =  scheduleList[i].st_date
			var en_date =  scheduleList[i].en_date
			var day =  scheduleList[i].day
			
			
			var checkStDate = st_date;
			var checkEnDate = en_date;
			if(day && day.length > 0){
				checkStDate = pf_getDateOfDay(st_date,day[0],'S');
				if(checkStDate > en_date){
					checkStDate = '';
				}
				checkEnDate = pf_getDateOfDay(en_date,day[day.length - 1],'E');
				
				
				
				if(checkEnDate < st_date){
					checkEnDate = '';
				}
			}
			
			
			if(checkStDate && ( (AP_STDT && AP_STDT > checkStDate) || !AP_STDT ) ){
				AP_STDT = checkStDate;
			}
			
			if(checkEnDate && ( (AP_ENDT && AP_ENDT < checkEnDate) || !AP_ENDT ) ){
				AP_ENDT = checkEnDate;
			}
			
			
		}
		
	}
	
	$('#AP_STDT').val(AP_STDT);
	$('#AP_ENDT').val(AP_ENDT);
	
	var apply_start = $('#apply_start').val();
	var apply_end = $('#apply_end').val();
	
	if(apply_start && AP_STDT && apply_start > AP_STDT){
		alert('예매 시작일이 스케줄 시작일('+AP_STDT+') 보다 늦습니다. 날짜를 확인하여주세요.');
		$('.nav-tabs li a').eq(0).trigger('click');
		setTimeout(function(){
			$('#apply_start').focus();	
		},300)
		return false;
	}
	
	if(apply_end && AP_ENDT && apply_end > AP_ENDT){
		alert('예매 종료일이 스케줄 종료일('+AP_ENDT+') 보다 늦습니다. 날짜를 확인하여주세요.');
		$('.nav-tabs li a').eq(0).trigger('click');
		setTimeout(function(){
			$('#apply_end').focus();	
		},300)
		return false;
	}
	
	
	$('#schduleGroupData').val(JSON.stringify(scheduleList));	//배열을 스트링 형태로 저장하기
	return true;
}


function pf_getDateOfDay(checkDate,day,type){
	
	var thisDate = new Date(checkDate);
	var thisDay = thisDate.getDay();
	var term;
	
	if(type == 'S'){
		term = day - thisDay;
		if(term < 0){
			term += 7;
		}
		
	}else{
		term = day - thisDay;
		if(term > 0){
			term -=7;
		}
	}
	
	
	thisDate.setDate(thisDate.getDate() + term);
	
	return cf_getToday(thisDate);
	
}


function pf_checkVal(obj,text,index){
	if(!$(obj).val().trim()){
		alert(text);
		$('.nav-tabs li a').eq(index).trigger('click');
		setTimeout(function(){
			$(obj).focus();	
		},300)
		$(obj).focus();
		return false;
	}
	return true;
}

</script>

<%@ include file="insert/pra_application_insert_modal.jsp"%>
