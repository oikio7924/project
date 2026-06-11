<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<script src="/resources/smartadmin/js/plugin/moment/moment.min.js"></script>
<script src="/resources/api/fullcalendar/js/fullcalendar.js"></script>
<script src="/resources/api/fullcalendar/js/ko.js"></script>
<link rel="stylesheet" type="text/css" media="screen" href="/resources/api/fullcalendar/css/fullcalendar.css">
<script src="/resources/js/calendar/TronixCalendar.js"></script>
<link rel="stylesheet" type="text/css" media="screen" href="/resources/css/calendar/TronixCalendar.css">
<style>
.box_date_pick {width:100%; padding:15px 0; text-align:center;}
.box_date_pick ul {display:inline-block;}
.box_date_pick ul:after { visibility: hidden;display:block;font-size: 0;content:".";clear: both;height: 0;*zoom:1;}
.box_date_pick ul li {float:left; padding:10px; border:1px solid #ddd; border-right:none; color:#65a132; font-size:1em; cursor:pointer;}
.box_date_pick ul li:last-of-type {border-right:1px solid #ddd;}
.box_date_pick ul li img {vertical-align:middle;}
.box_date_pick ul li.date_box { cursor:auto;}


.box_date_pick ul li:not(.date_box):hover {background:#eee}

</style>



<div id="calendar_div"></div>

<!-- 게시판 리스트형 -->
<%@ include file="prc_board_data_listView_list.jsp"%>
<script type="text/javascript">
var setMonth = new Date().getMonth() + 1;
//ConversionDate = "2020-1" //달력 오픈 년,월을 지정해야 하는경우 사용. 미사용 시 현재 년월 오픈
$(document).ready(function() {
	$("#calendar_div").showCalendar(setMonth);
})

function SetSchedule(getDate){
	var lastday = lastDay(getDate);
	var index = parseInt(lastday.split("-")[2]);
	
	var startDate = "2018-01-17";	//등록된 시작날짜
	var endDate = "2018-02-28";		//등록된 종료날짜
	var holiday = "1,3";			//티켓날짜 등록시 제외할 요일 ex) 매주 월, 수 휴관
	
	var sd = new Date(startDate);
	var ed = new Date(endDate);
	for(var i = 1; i <= index; i++){
		//루프의 현재 일자 구하기
		var date = lastday.split("-")[0] + "-" + lastday.split("-")[1] +"-"; 
		var date_num = lastday.split("-")[0] + "" + lastday.split("-")[1]; 
		
		//일정 문자열 세팅
		if(i > 9 ){
			date += i;
			date_num += i;
		}else{
			date += "0" + i;
			date_num += "0" + i;
		}
		var tempDate = new Date(date);
		if(tempDate >= sd && tempDate <= ed && holiday.indexOf(tempDate.getDay()) == -1 ){
			$("#tronix"+i).addClass('ticketDay');
		}
	}
}
</script>