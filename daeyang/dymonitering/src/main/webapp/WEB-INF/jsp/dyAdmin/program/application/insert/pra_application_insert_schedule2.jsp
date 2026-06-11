<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<div class="alert alert-block alert-success">
	<a class="close" data-dismiss="alert">×</a>
	<!-- <h4 class="alert-heading"><i class="fa fa-check-square-o"></i> Check validation!</h4> -->
	<p>
		프로그램에 대한 스케쥴 정보를 입력합니다.
	</p>
</div>
<div class="widget-body no-padding smart-form">
	<fieldset>
		<div class="row"> 
			<section class="col col-12">
				<h6>스케쥴 일정 등록</h6>   
				<div class="inline-group">
					<label class="radio">
						<input type="radio" name="schedule_inputType" checked="checked">
						<i></i>캘린더형</label>
					<label class="radio">
						<input type="radio" name="schedule_inputType">
						<i></i>데이터형</label>
				</div>
			</section>
		</div>
		<div class="row">
			<section class="col col-6">
				<div id="calendar_div"></div>
				<br/>
				<div class="text-center">
					<button class="btn btn-sm btn-primary" id="Board_Edit"	type="button" onclick="pf_programInsert()">	
						<i class="fa fa-floppy-o"></i> 추가하기
					</button>
				</div>
			</section>
			<section class="col col-6">
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<div id="date_direct_insert" >
					<div class="row">
				    	<section class="col col-6 em_time_wrap">  <p class="em_time_wrap_text">시작 시간 </p>
				            <select name="EM_TIME1" class="EM_TIME1"  style="width:45%;height: 30px;">
				               <option value="">선택</option>
				               <c:forEach begin="0" end="24" var="model">
				                  <option value="${model }">${model }</option>
				               </c:forEach>
				            </select> 시<i></i>
				            <select name="EM_TIME2" class="EM_TIME2"  style="width:45%;height: 30px;">
				               <option value="">선택</option>
				               <c:forEach begin="0" end="60" var="model">
				                  <option value="${model }">${model }</option>
				               </c:forEach>
				            </select> 분  <i></i>
		               </section>
		               <section class="col col-6 em_time_wrap">  <p class="em_time_wrap_text">종료 시간 </p>
				            <select name="EM_TIME3" class="EM_TIME3"  style="width:45%;height: 30px;">
				               <option value="">선택</option>
				               <c:forEach begin="0" end="24" var="model">
				                  <option value="${model }">${model }</option>
				               </c:forEach>
				            </select> 시<i></i>
				            <select name="EM_TIME4" class="EM_TIME4"  style="width:45%;height: 30px;">
				               <option value="">선택</option>
				               <c:forEach begin="0" end="60" var="model">
				                  <option value="${model }">${model }</option>
				               </c:forEach>
				            </select> 분<i></i>
			            </section>  
				    </div>
					<div class="row">
					<section class="col col-8">
						<label class="label">반복 요일 체크</label>
						<div class="inline-group">
							<label class="checkbox">
							<input type="checkbox" name="checkbox-inline">
							<i></i>일</label>
							<label class="checkbox">
							<input type="checkbox" name="checkbox-inline">
							<i></i>월</label>
							<label class="checkbox">
							<input type="checkbox" name="checkbox-inline">
							<i></i>화</label>
							<label class="checkbox">
							<input type="checkbox" name="checkbox-inline">
							<i></i>수</label>
							<label class="checkbox">
							<input type="checkbox" name="checkbox-inline">
							<i></i>목</label>
							<label class="checkbox">
							<input type="checkbox" name="checkbox-inline">
							<i></i>금</label>
							<label class="checkbox">
							<input type="checkbox" name="checkbox-inline">
							<i></i>토</label>
						</div> 
					</section>
					<section class="col col-4">
						<label class="label">반복 횟수</label>
						<label class="input"><i class="icon-prepend fa fa-edit"></i> 
							<input type="number" max="50" value="0">
						</label>
					</section>
					</div>
					<div class="row">
					<section class="col col-6">
						<label class="label">시작 날짜</label> <label class="input">
							<i class="icon-append fa fa-calendar"></i> <input type="text"
							class="datepic" id="visitorSearchStartDate" name="STDT"
							placeholder="시작 일자" readonly="readonly">
						</label>
					</section>
					<section class="col col-6">
						<label class="label">종료 날짜</label> <label class="input"> <i
							class="icon-append fa fa-calendar"></i> <input type="text"
							class="datepic" id="visitorSearchEndDate" name="ENDT"
							placeholder="종료 일자" readonly="readonly">
						</label>
					</section>
					</div>
					<div class="row">
					<section class="col col-6">
						<label class="label">제한 인원</label> 
						<label class="input"><i class="icon-prepend fa fa-edit"></i> 
							<input type="number" maxlength="3" value="0"/>
						</label>
					</section>
					</div>
					<br/>
					<div class="row">
						<div class="text-center">
							<button class="btn btn-sm btn-primary" id="Board_Edit"	type="button" onclick="pf_programInsert()">	
								<i class="fa fa-floppy-o"></i> 추가하기
							</button>
						</div>
					</div>
				</div>
			</section>
		</div>
	</fieldset>
	<fieldset id="main_schedule_list">

	</fieldset>
</div>
										
		<div class='row' id='sub_schedule' style='display: none;'>
	<section class='col col-2'>
		<label class='label'>날짜</label>
		<label class='input'><i class='icon-append fa fa-calendar'></i>
		<input type='text' class='datepic subschedule_date' placeholder='날짜'  readonly='readonly' value=''/></label></section>
	<section class='col col-2'>
		<label class='label'>시작 시간</label>
		<select style='width:40%;height: 30px;'>
			<option value=''>선택</option>
			<c:forEach begin='0' end='24' var='model'>
			<option value='${model }'>${model }</option>
			</c:forEach></select> 시<i></i>
		<select style='width:40%;height: 30px;'>
			<option value=''>선택</option>
			<c:forEach begin='0' end='60' var='model'>
			<option value='${model }'>${model }</option>
			</c:forEach></select> 분<i></i></section>
	<section class='col col-2'>
		<label class='label'>종료 시간</label>
		<select style='width:40%;height: 30px;'>
			<option value=''>선택</option>
			<c:forEach begin='0' end='24' var='model'>
			<option value='${model }'>${model }</option>
			</c:forEach></select> 시<i></i>
		<select style='width:40%;height: 30px;'>
			<option value=''>선택</option>
			<c:forEach begin='0' end='60' var='model'>
 			<option value='${model }'>${model }</option>
			</c:forEach></select> 분<i></i></section>
	<section class='col col-3'>
		<label class='label'>제한 인원</label>
		<label class='input'><i class='icon-prepend fa fa-edit'></i>
		<input type='number' maxlength='3' value='0'/></label></section>
	<label class='label'>&nbsp;</label><button class='btn btn-sm btn-primary text-center' onclick='pf_sub_delete(this)'>자식 삭제</button>
</div>

<script src="/resources/common/js/calendar/TronixCalendar.js"></script>
<link rel="stylesheet" type="text/css" media="screen" href="/resources/common/css/calendar/TronixCalendar.css">
<script>

var setMonth = new Date().getMonth() + 1;
var schedule_list = [];

$(function(){
	$("#calendar_div").showCalendar(setMonth);
})


function SetSchedule(getDate){
	var lastday = lastDay(getDate);
	var date = lastday.split("-")[0] + "-" + lastday.split("-")[1] +"-"; 
	
	var index = parseInt(lastday.split("-")[2]);
	/* 
	var startDate = "2018-01-17";	//등록된 시작날짜
	var endDate = "2018-02-28";		//등록된 종료날짜
	var holiday = "1,3";			//티켓날짜 등록시 제외할 요일 ex) 매주 월, 수 휴관
	
	var sd = new Date(startDate);
	var ed = new Date(endDate);
	*/
	for(var i = 1; i <= index; i++){
		//루프의 현재 일자 구하기
		var date_num = lastday.split("-")[0] + "-" + lastday.split("-")[1] +"-"; 
		
		//일정 문자열 세팅
		if(i > 9 ){
			date_num += i;
		}else{
			date_num += "0" + i;
		}
		schedule_list.forEach(function (item, index){
			if(item == date_num){
				$("#tronix"+i).addClass('click');
			}
		});	
	} 
	
	$('.tronixTr').css('height', '60px');
	
	
	$('.tronixTd').click(function (){
		var arr_index = -1;
		var id = $(this).attr('id');
		day = $(this).text();
		if(day < 10){
			day = "0" + day;
		}
		day = date + day;

		schedule_list.forEach(function (item, index){
			if(item == day){
				arr_index = index;
			}
		});	
		
		//alert(arr_index);
		if(arr_index == -1 && id != 'tronix'){
			schedule_list.push(day);
			$(this).addClass('click');
		}else if(arr_index != -1){
			alert("index : " + arr_index + " arr : " + schedule_list.splice(arr_index, 1));
			$(this).removeClass('click');
		}
		
	});
}

function pf_programInsert(){
	schedule_list.sort();
	var html = 		"<fieldset id='test'>"
				+	"<div class='row'><section class='col col-6'>"
				+	"<label class='label'>클래스명</label>"
				+	"<label class='input'><i class='icon-prepend fa fa-edit'></i>"
				+	"<input type='text' placeholder='강좌명을 입력하세요'  maxlength='50'/></label>"
				+	"</section><section class='col col-3'>"
				+	"<label class='label'>시작 일시</label>"
				+	"<label class='input'><i class='icon-append fa fa-calendar'></i>"
				+	"<input type='text' class='datepic'id='mainschedule_stdt' placeholder='시작 날짜'  readonly='readonly' value='"+schedule_list[0]+"'/></label>"
				+	"</section><section class='col col-3'>"
				+	"<label class='label'>종료 일시</label>"
				+	"<label class='input'><i class='icon-append fa fa-calendar'></i>"
				+	"<input type='text' class='datepic'id='mainschedule_endt' placeholder='종료 날짜'  readonly='readonly' value='"+schedule_list[schedule_list.length - 1]+"'/></label>"
				+	"</section></div>"
				+	"<div class='row'><section class='col col-12'><label class='label'>일정 코멘트</label>"
				+	"<label class='textarea'><textarea row='3' placeholder='일정 설명'></textarea></label></section></div>"
				+	"<label class='label'>메인 스케쥴</label><fieldset style='border:1px solid #ccc'>"
				+	"<div class='text-right'><button type='button' class='btn btn-sm btn-primary' onclick='pf_sub_create(this)'>자식 추가</button></div>";
	
				
	
	schedule_list.forEach(function (item, index){
		var temp = $('#sub_schedule').clone().show();
		temp.find('.subschedule_date').val(item);
		
		html += temp.html();	
	});

	html += "</fieldset><br><div class='text-center'><button class='btn btn-sm btn-primary' onclick='pf_delete(this)'>삭제</button></div></fieldset>";
	$('#main_schedule_list').append(html);
}

function pf_delete(obj){
	$(obj).closest('fieldset').remove();
}

function pf_sub_delete(obj){
	$(obj).parent('div').remove();
}

function pf_sub_create(obj){
	var temp = 	$('#sub_schedule').clone().show();
	
	$(obj).closest('fieldset').append(temp);
}

</script>								
								