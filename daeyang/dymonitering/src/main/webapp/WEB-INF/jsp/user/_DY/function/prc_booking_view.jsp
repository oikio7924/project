<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script src="/resources/smartadmin/js/plugin/moment/moment.min.js"></script>
<script src="/resources/api/fullcalendar/js/fullcalendar.js"></script>
<script src="/resources/api/fullcalendar/js/ko.js"></script>
<link rel="stylesheet" type="text/css" media="screen" href="/resources/api/fullcalendar/css/fullcalendar.css">

<style>

.btn_margin{
 margin: 10px;
}

.Datetime{display: none;}

.box_date_pick {width:100%; padding:15px 0; text-align:center;}
.box_date_pick ul {display:inline-block;}
.box_date_pick ul:after { visibility: hidden;display:block;font-size: 0;content:".";clear: both;height: 0;*zoom:1;}
.box_date_pick ul li {float:left; padding:10px; border:1px solid #ddd; border-right:none; color:#65a132; font-size:1em; cursor:pointer;}
.box_date_pick ul li:last-of-type {border-right:1px solid #ddd;}
.box_date_pick ul li img {vertical-align:middle;}
.box_date_pick ul li.date_box { cursor:auto;}


.box_date_pick ul li:not(.date_box):hover {background:#eee}

</style>

<!-- widget grid -->
<section id="widget-grid" class="">

	<!-- row -->
	<div class="row">

		<!-- NEW WIDGET START -->
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">

			<!-- Widget ID (each widget will need unique ID)-->
			<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>

				</header>
				<!-- widget div-->
				<div>

					<!-- widget content -->
					<div class="widget-body no-padding">

					  <div role="content">							
												
						 <div class="">
							<h1>${TITLE}</h1>
							<br>
							<p>${CONTENTS}</p>								
							<br>
							
							<div class="well well-sm well-light" style="width: 50%; float: left;" >
								<div class="alert alert-danger fade in" style="text-align: center;">
									<h3>예약 일정</h3>
						        </div>
								<div class="row" style="width: 90%; margin: 0 auto;">
					
									<div class="box_date_pick">
										<ul>
									    	<li id="prevYear"><img src="/resources/img/icon/icon_arrow_left_2_calendar.png" alt="이전년도"></li>
									    	<li id="prevMonth"><img src="/resources/img/icon/icon_arrow_left_calendar.png" alt="이전달"></li>
									    	<li class="date_box"></li>
									    	<li id="nextMonth"><img src="/resources/img/icon/icon_arrow_right_calendar.png" alt="다음달"></li>
									    	<li id="nextYear"><img src="/resources/img/icon/icon_arrow_right_2_calendar.png" alt="다음년도"></li>
									    </ul>                        
									</div> 
									<div id="calendar"></div>
					
								</div>
							</div>	
							
							<div class="well well-sm well-light Datetime" style="width: 49%; float: left;" >	
								<div class="alert alert-danger fade in" style="text-align: center;">
									<h3>예약 시간</h3>
						        </div>
						     	    <p id="fullcalday" style="left: 1px;"></p>
								<div class="Datetime_list" id="Datetime_list" style="width: 90%; margin: 0 auto;">
					
																
					
								</div>
					
							</div>
			
						  </div>							

					   </div>				

					</div>
					<!-- end widget content -->

				</div>
				<!-- end widget div -->

			</div>
			<!-- end widget -->
		</article>
		<!-- WIDGET END -->

	</div>

	<!-- end row -->
	
</section>
<!-- end widget grid -->

 <div id="Date_Choice" title="예약 신청">
	<form:form id="DateChoiceForm" action="" method="post">	
	<div class="widget-body ">
		<fieldset>
			<div class="form-horizontal">
				<fieldset>
					<div class="table-responsive">
						<table class="table">
							<thead>
								<tr>
									<th> <i class=""></i> 제 목 </th>
									<th> <i class=""></i> 날 짜</th>`
									<th> <i class=""></i> 시 간 </th>
									<th width="20%"> <i class=""></i> 남은 자리 / 총 인원수</th>
								</tr>
							</thead>
							<tbody id="tbody">
								<tr class='success'>
									  <td id="title" style="text-align: center;"></td>
									  <td id="date" style="text-align: center;"></td>
									  <td id="time" style="text-align: center;"></td>
									  <td id="count" style="text-align: center;"></td>
							    </tr>							
							</tbody>
						</table>
					</div>
				</fieldset>
			</div>
		</fieldset>
	</div>
	</form:form>
</div> 

<script type="text/javascript">

var date = new Date('${firstDate}');
var d = date.getDate();
var m = date.getMonth();
var y = date.getFullYear();
	
$(document).ready(function(){
	
	var calendar = $('#calendar').fullCalendar({

        header: {
			left: '',			        	
        	center: '',
	        right: ''
	    },
	    height: "auto",
	    lang:"ko",
        events: function(start, end, timezone, callback){
        	var options = "start="+start.unix()+"&end="+end.unix();
        	
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

        	 pf_bookingDatelist(calEvent.BSM_KEYNO,calEvent.BSS_DATE,calEvent.start._i);
        	
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
	
 	pf_bookingDialog('#Date_Choice','예약 신청','예약 완료','pf_DateChoice()');	

    setDateTitle();
    
})

function pf_bookingDialog(obj,title,successText,successFnc,cancelText){
	var cancelText = cancelText || '취소';
	var data = {
			autoOpen : false,
			width : 800,
			resizable : false,
			modal : true,
			title : title
		}
	if(successText){
		data.buttons = [{
			html : "<i class='fa fa-floppy-o'></i>&nbsp; "+successText,
			"class" : "btnSmall_01 bgColorW",
			"color" : "white",
			click : function() {
				if(eval(successFnc)){
					$(this).dialog("close");
				}
			}
		}, {
			html : "<i class='fa fa-times'></i>&nbsp; "+cancelText,
			"class" : "btnSmall_01 bgColorPink",
			click : function() {
				$(this).dialog("close");
			}
		}]
	}else{
		data.buttons = [{
			html : "<i class='fa fa-times'></i>&nbsp; 확인",
			"class" : "btn btn-primary",
			click : function() {
				$(this).dialog("close");
			}
		}]
	}
	$(obj).dialog(data);
}

function setDateTitle(){
	
	$('#calendar').fullCalendar('gotoDate',new Date(y,m));
	var mString = (m+1)+ '';
	$('.date_box').text(y+"."+ ( mString.length == 1 ? '0'+mString:mString ) )
}

 function getEvents(options){
	var events = [];
	
	<c:forEach items="${BSS_List}" var="list">
	<c:if test="${list.BSS_DATE >= sysdate }">

	
		<c:if test="${date1 eq list.BSS_DATE}">
		</c:if>
		<c:if test="${date1 ne list.BSS_DATE}">
			events.push({
				
				title:'예약',
				start:'<c:out value="${list.BSS_DATE}"></c:out>',
				BSM_KEYNO: '<c:out value="${list.BSS_BSM_KEYNO}"></c:out>',
				BSS_DATE: '<c:out value="${list.BSS_DATE}"></c:out>',
				color: '#2196F3'
				
			});
		</c:if>	
		  <c:set var="date1" value="${list.BSS_DATE}"></c:set>
	</c:if>	
	</c:forEach>
	
	$.ajax({
		type: "POST",
		url: "/dy/function/holidayAjax.do",
		data:options,
		async:false,
		success : function(result){

			var holidayList = result.holidayList;
			$.each(holidayList,function(i){
				events.push({
                       title: holidayList[i].THM_NAME,
                       start: holidayList[i].THM_DATE,
                       allDay:true,
                       className: "holiday"
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
 

 var main_key;

 //예약 날짜 시간 다이얼로그 표시
  function pf_bookingDatetime(key,title,date,time,count,allcount){
 	 main_key = key;
 	 $('#Date_Choice').dialog('open');
 	 $('#title').text(title);				  
 	 $('#date').text(date);				  
 	 $('#time').text(time);				  
 	 $('#count').text(count+"/"+allcount);		 	  

  }
  
 //원하는 날짜 시간 선택 예약 완료
  function pf_DateChoice(){
 	  $.ajax({
 			type: "POST",
 			url: "/dy/function/booking_UserSaveAjax.do",
 			data: "main_key=" + main_key+"&userkey="+'${userInfo.UI_KEYNO}',
 			async:false,
 			success : function(data){
 				if(data){
 				
 					alert('예약신청이 완료되었습니다.')	
 					location.href="/dy/function/booking.do";
 					
 				}else{
 					alert('예약신청 중 에러 발생. 관리자한테 문의하세요.')	
 				}
 			},
 			error: function(){
 				alert('예약신청 중 에러 발생. 관리자한테 문의하세요.')
 				return false;
 			}
 		}); 
  }
  
  //날짜 예약 버튼 클릭시 날짜에 맞는 예약시간 리스트 출력
  function pf_bookingDatelist(key,date,calday){
	  
	  var now = new Date(); // 현재시간
	  var fulldate = now.getFullYear() + "" + (now.getMonth() < 10? "0"+(now.getMonth()+1) : (now.getMonth()+1)) + "" + (now.getDate() < 10? "0"+now.getDate() : now.getDate()) + "";
      var nowtime = fulldate + (now.getHours() < 10? "0"+now.getHours() : now.getHours()) + "" + (now.getMinutes() < 10? "0"+now.getMinutes() : now.getMinutes()) + "";

 	 $.ajax({
 			type: "POST",
 			url: "/dy/function/booking_DatelistAjax.do",
 			data: "key=" + key+"&date="+date,
 			async:false,
 			success : function(data){
 				if(data){
 					$('.Datetime').show();
 					$('#Datetime_list').html("")
 					 $.each(data,function(i){
 						 
 						 var arrtime = data[i].BSS_TIME.split(" "); 						 
						 
						 var bookingTime = data[i].BSS_TIME.replace(/[^0-9]/g,"");
						 var fullcalday = calday.replace(/[^0-9]/g,"");
						 var bookingTimeCheck = 1;
						 var endtime = fullcalday + 2400;
						 
						bookingTimeCheck = bookingTime * 1;
						 
						 if(bookingTimeCheck < 1000){
							bookingTime = "0" + bookingTime;
						 }
						 
						bookingTime = fullcalday + bookingTime;
						 
						bookingTime *= 1;
						
						 if(arrtime[1] == "PM"){
							bookingTime += 1200;
							 
							if(bookingTime >= endtime){
								bookingTime -= 1200;
							}
						 }
 						 
 		                  var temp = "<li class='btn_margin'><span><i class='fa fa-clock-o'></i>"+ data[i].BSS_TIME+"</span> ";
 		                  
 		                   if(data[i].BSS_COUNT == '0' || bookingTime < nowtime){
 			         		 temp += '<button class="btnSmall_02 bgColorR" type="button" ><span class="btn-label"><i class="glyphicon glyphicon-thumbs-up"></i></span>마 감</button></li>';  
 			                }else{
 			                 temp += '<button class="btnSmall_02 bgColorG_Deep" type="button" '
 			                        + "onclick=\"pf_bookingDatetime('"+data[i].BSS_KEYNO+"','"+data[i].BSM_TITLE+"','"+data[i].BSS_DATE+"','"+data[i].BSS_TIME+"','"+data[i].BSS_COUNT+"','"+data[i].BSS_NUM+"')\"> "
 			                        + '<span class="btn-label"><i class="glyphicon glyphicon-thumbs-up"></i></span>예 약</button></li>';
 			                }  
 		                  
 		                  $('#Datetime_list').append(temp); 		                 
 					}) 
 					
 					$('#fullcalday').text(calday); 	
 				}else{
 					alert('예약리스트 출력 중 에러 발생. 관리자한테 문의하세요.')	
 				}
 			},
 			error: function(){
 				alert('예약리스트 출력 중 에러 발생. 관리자한테 문의하세요.')
 				return false;
 			}
 		}); 
 	 
  }
	
</script>