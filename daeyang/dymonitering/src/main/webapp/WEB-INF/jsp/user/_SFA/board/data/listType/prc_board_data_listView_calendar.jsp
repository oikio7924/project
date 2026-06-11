<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<script src="/resources/smartadmin/js/plugin/moment/moment.min.js"></script>
<script src="/resources/api/fullcalendar/js/fullcalendar.js"></script>
<script src="/resources/api/fullcalendar/js/ko.js"></script>
<link rel="stylesheet" type="text/css" media="screen" href="/resources/api/fullcalendar/css/fullcalendar.css">

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



<div class="box_date_pick">
	<ul>
    	<li id="prevYear"><img src="/resources/img/icon/icon_arrow_left_2_calendar.png" alt="이전날짜"></li>
    	<li id="prevMonth"><img src="/resources/img/icon/icon_arrow_left_calendar.png" alt="이전달"></li>
    	<li class="date_box"></li>
    	<li id="nextMonth"><img src="/resources/img/icon/icon_arrow_right_calendar.png" alt="다음날짜"></li>
    	<li id="nextYear"><img src="/resources/img/icon/icon_arrow_right_2_calendar.png" alt="다음달"></li>
    </ul>                        
</div> 
<div id="calendar"></div>



<!-- 게시판 리스트형 -->
<%@ include file="prc_board_data_listView_list.jsp"%>
<script type="text/javascript">
		
var date = new Date();
var d = date.getDate();
var m = date.getMonth();
var y = date.getFullYear();


$(document).ready(function() {
		
	
		setDateTitle('default');
	    $('#calendar').fullCalendar({
	
	        header: {
				left: '',			        	
	        	center: '',
		        right: ''
		    },
		    height: "auto",
		    lang:"ko",
	        events: function(start, end, timezone, callback){
	        	var options = "&start="+start.unix()+"&end="+end.unix();
	        	
                callback(getEvents(options));
					
	        	
	        } ,
	        eventRender: function(event, element) {
	            
	            if(event.className[0] == 'holiday'){
	            	$day = $('.fc-day-top[data-date='+event.start._i+']');
	            	$day.addClass('fc-holiday');
	            	$day.find('.fc-day-number').after('<span class="fc-day-title">'+event.title+'</span>')
	            	return false;
	            }
	        },
	        eventClick: function(calEvent, jsEvent, view) {
	        	var detailNumber = calEvent.className[0].replace('detail-','');
	        	pf_DetailMove(detailNumber)
	        },
	        eventMouseover: function(event, jsEvent, view){
		       // $(this).css("color", "green")
	        	
	        },
	      	eventMouseout: function(event, jsEvent, view){
		       // $(this).css("color", "white")
	      	}
	    });
		
	    $('#prevYear').click(function(){
	    	y -= 1;
	    	setDateTitle();
	    })
	    $('#prevMonth').click(function(){
	    	if(m == 0){
	    		m = 11;
	    		y -= 1;
	    	}else{
		    	m -= 1;
	    	}
	    	setDateTitle();
	    })
	    $('#nextYear').click(function(){
	    	y += 1;
	    	setDateTitle();
	    })
	    $('#nextMonth').click(function(){
	    	if(m == 11){
	    		m = 0;
	    		y += 1;
	    	}else{
		    	m += 1;
	    	}
	    	setDateTitle();
	    })
	    

})

function setDateTitle(type){
	
	if(type == undefined){
		$('#calendar').fullCalendar('gotoDate',new Date(y,m));
	}
	var mString = (m+1)+ '';
	$('.date_box').text(y+"."+ ( mString.length == 1 ? '0'+mString:mString ) )
}


function getEvents(options){
	
	var events = [];
	$.ajax({
		type: "POST",
		url: "/common/Board/main/viewAjax.do",
		data: "MN_KEYNO=${menu.MN_KEYNO}"+options,
		async:false,
		success : function(result){
			var eventList = result.eventList;
			
			$.each(eventList,function(i){
				var endDate = new Date(eventList[i].BN_ENDT);
				endDate.setDate(endDate.getDate()+1)
				
				events.push({
                       title: eventList[i].BN_NAME,
                       start: eventList[i].BN_STDT,
                       end: endDate.format(),
                       allDay:true,
                       className: 'detail-'+Number(eventList[i].BN_KEYNO.substring(5,20))
                       /*, backgroundColor: '#b8e096' */
                   });
			})
			var holidayList = result.holidayList;
			$.each(holidayList,function(i){
				events.push({
                       title: holidayList[i].THM_NAME,
                       start: holidayList[i].THM_DATE,
                       allDay:true,
                       className: "holiday"
                       /* , rendering:'background'
                       , backgroundColor: 'gray' */ 
                   });
			})
		},
		error: function(){
			alert('알수없는 에러 발생. 관리자한테 문의하세요.')
			return false;
		}
	});
	return events;
}

</script>