<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<style>
    
 .visitor_bar{
	position: relative;
	height: 20px;
	margin:0;
}
.visitor_bar span {
    position: absolute;
  	top:6px;
    left: 0;
    height: 15px;
    background: #ddd;
}
.footTr{ 
    background: #878787;
	color: #fff;
}
 .footTd{text-align: center;}
    
</style>
<div id="content">
	<section id="widget-grid" class="">
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" id="chart_page" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-bar-chart-o"></i>
						</span>
						<h2>메뉴별 통계 그래프</h2>
					</header>
					<div class="widget-body">
						<form:form id="Form" name="Form" method="post" class="smart-form">
							<input type="hidden" name="searchbot" value="${searchbot }">
							<div class="bg-color-white padding-10">
								<div class="row">
									<section class="col col-2">
										<label class="label">시작</label> <label class="input"> <i class="icon-append fa fa-calendar"></i> <input type="text" class="datepic" id="visitorSearchStartDate" name="STDT" placeholder="검색 일자" readonly="readonly">
										</label>
									</section>
									<section class="col col-2">
										<label class="label">끝</label> <label class="input"> <i class="icon-append fa fa-calendar"></i> <input type="text" class="datepic" id="visitorSearchEndDate" name="ENDT" placeholder="검색 일자" readonly="readonly">
										</label>
									</section>
									<section class="col col-2">
									<label class="label">검색기간</label> <label class="input">
									<label class="select">
										<select class="form-control input-sm" name="orderCondition" id="searchDate" onchange="pf_settingSearchDate(this.value)">
							              	<option value="">선택하세요.</option>
							                <option value="1" ${search.orderCondition eq '1'? 'selected':'' }>오늘</option>
							                <option value="2" ${search.orderCondition eq '2'? 'selected':'' }>이번달</option>
							                <option value="3" ${search.orderCondition eq '3'? 'selected':'' }>일주일</option>
							                <option value="4" ${search.orderCondition eq '4'? 'selected':'' }>보름</option>
							                <option value="5" ${search.orderCondition eq '5'? 'selected':'' }>1개월</option>
							                <option value="6" ${search.orderCondition eq '6'? 'selected':'' }>2개월</option>
							                <option value="7" ${search.orderCondition eq '7'? 'selected':'' }>3개월</option>
							                <option value="8" ${search.orderCondition eq '8'? 'selected':'' }>6개월</option>
							                <option value="9" ${search.orderCondition eq '9'? 'selected':'' }>1년</option>
							                <option value="10" ${search.orderCondition eq '10'? 'selected':'' }>전체</option>
							            </select> <i></i> 
									</label>
								</section>
									
									<section class="col col-2">
										<label class="label">접속 단말기 선택</label>
										<select class="form-control input-sm" id="DEVICE" name="DEV" onchange="getHtml()">
											<option value="0">적용 단말기 선택</option>
											<option value="P">PC 보기</option>
											<option value="M">MOBILE 보기</option>	
										</select>
									</section>
									<section class="col col-2">
										<label class="label">홈페이지 선택</label>
										<select class="form-control input-sm" id="HOMEDIV" name="HOME_DIV" onchange="getHtml()">
											<option value="0">적용 홈페이지 선택</option>
												<c:forEach items="${homeDivList }" var="model">
												<option value="${model.MN_KEYNO }" ${MN_HOMEDIV_C eq model.MN_KEYNO ? 'selected' : '' }>${model.MN_NAME }</option>
												</c:forEach>											
										</select>
									</section>
									<section class="col col-2">
										<label class="label">&nbsp;</label>
										<div class="btn-group">
 											<button class="btn btn-sm btn-primary" onclick="getHtml()" type="button" style="margin-right:10px;">
												<i class="fa fa-floppy-o"></i> 조회
											</button>
											<button class="btn btn-sm btn-primary" onclick="pf_download()" type="button">
												<i class="fa fa-floppy-o"></i> 엑셀
											</button>
										</div>
									</section>
								</div>
							</div>
						</form:form>
						<div class="tab-content">
							<table class="table table-bordered table-hover" id="maintable" style="width:100%;">
								<thead>
									<tr>
										<th width="10%">순위</th>
										<th width="10%">홈페이지</th>
										<th width="10%">메뉴</th>
										<th class="text-center" width="50%">그래프</th>
										<th width="10%">카운트</th>
										<th width="10%">퍼센트</th>
									</tr>
								</thead>
								<tbody>
								</tbody>
							</table>
						</div>
					</div>
					<!--2번째 탭컨텐츠끝  -->
				</div>
		</div>
	</article>
</div>
<script src="/resources/smartadmin/js/plugin/horizontal/jquery.horizBarChart.js"></script>

<script type="text/javascript">
var applicationTable = null;

$(document).ready(function(){
	
	datepickerOption.onSelect = function(selectedDate) {
		$('#visitorSearchEndDate').val($('#LC_STDT').val());
		$('#visitorSearchEndDate').datepicker('option', 'minDate', selectedDate);
	} 
	$('#visitorSearchStartDate').datepicker(datepickerOption)
	datepickerOption.onSelect = function(selectedDate) {
		$('#visitorSearchStartDate').datepicker('option', 'maxDate', selectedDate);
	}
	$('#visitorSearchEndDate').datepicker(datepickerOption);
	
	//checkTodate(); //날짜 초기화
	getHtml();

}); 

function checkTodate() {
	var d = new Date();
	var thisDate = leadingZeros(d.getFullYear(), 4) + '-'
			+ leadingZeros(d.getMonth() + 1, 2) + '-'
			+ leadingZeros(d.getDate(), 2);
	$('#visitorSearchStartDate').val(thisDate);
	$('#visitorSearchEndDate').val(thisDate);
}

function leadingZeros(n, digits) {
	var zero = '';
	n = n.toString();
	if (n.length < digits) {
		for (i = 0; i < digits - n.length; i++)
			zero += '0';
	}
	return zero + n;
}

//비동기로 ajax 조회
function getHtml() {
	$.ajax({
		type : "post",
		data : $('#Form').serialize(),
		url : "/dyAdmin/statistics/menucount/pagingAjax.do",
		async : false,
		success : function(data, textStatus, xhr) {
			if(applicationTable){
				applicationTable.destroy();
			}
			$("#maintable tbody").empty().html(data);
			$(document).find('.chart').horizBarChart({
		        selector: '.bar',
		        speed: 500
		    });
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
		}
	});
}

function pf_download(){
	$("#Form").attr("action", "/dyAdmin/statistics/menucount/excelAjax.do");
	$("Form").submit();
}

 //관리자 게시판 날짜검색 관련 함수
function pf_settingSearchDate(value){
	
	var date = new Date();
	var yyyy = date.getFullYear();
	var mm = date.getMonth()+1; 
	var dd = date.getDate();
	
	var stdt = yyyy + "-" + pf_setTwoDigit(mm) + "-" + pf_setTwoDigit(dd);
	var endt = stdt;
	
	if(value == 1){ // 오늘
		
	}else if(value == 2){ //이번달
		stdt = yyyy + "-" + pf_setTwoDigit(mm) + "-01";
		
	}else if(value == 3){ //일주일
		stdt = pf_getNewDate('d',-7);
		
	}else if(value == 4){ //보름
		stdt = pf_getNewDate('d',-15);
		
	}else if(value == 5){ //1개월
		stdt = pf_getNewDate('m',-1);
		
	}else if(value == 6){ //2개월
		stdt = pf_getNewDate('m',-2);
		
	}else if(value == 7){ //3개월
		stdt = pf_getNewDate('m',-3);
		
	}else if(value == 8){ //6개월
		stdt = pf_getNewDate('m',-6);
	}else if(value == 9){ //1년
		stdt = pf_getNewDate('y',-1);
	}else if(value == 10){ //전체
		stdt = '';
		endt = '';
	}else if(value == 11){ //저번 기수
		if(dd > 15){
			stdt = yyyy + "-" + pf_setTwoDigit(mm) + "-01";
			endt = yyyy + "-" + pf_setTwoDigit(mm) + "-15";
		}else{
			date.setMonth(date.getMonth - 1);
			yyyy = date.getFullYear();
			mm = date.getMonth()+1; 
			
			stdt = yyyy + "-" + pf_setTwoDigit(mm) + "-16";
			
			var lastDay = ( new Date( yyyy, mm, 0) ).getDate();
			
			endt = yyyy + "-" + pf_setTwoDigit(mm) + lastDay;
		}
	}else if(value == 12){ //이번 기수
		
		if(dd > 15){
			stdt = yyyy + "-" + pf_setTwoDigit(mm) + "-16";	
		}else{
			stdt = yyyy + "-" + pf_setTwoDigit(mm) + "-01";
		}
	}else{
		return false;
	}
	
	$('#visitorSearchStartDate').val(stdt);
	$('#visitorSearchEndDate').val(endt);
	getHtml();
	
	function pf_getNewDate(type,num){
		if(type == 'd'){
			date.setDate(date.getDate() + num);
			
		}else if(type == 'm'){
			date.setMonth(date.getMonth() + num);
		}else if(type == 'y'){
			date.setFullYear(date.getFullYear() + num);
		}
		
		yyyy = date.getFullYear();
		mm = date.getMonth()+1; 
		dd = date.getDate();
		
		return yyyy + "-" + pf_setTwoDigit(mm) + "-" + pf_setTwoDigit(dd);
	}
}

function pf_setTwoDigit(value){
	value = value + "";
	if( value.length == 1) {
		return value = '0' + value;
	}else{
		return value;
	}
}
</script>
