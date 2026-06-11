<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<style>
	#ProgramName{font-size: 25px; font-weight: bold;}
	#programIntro{width: 53%;	 margin: 0 auto;  font-family: sans-serif;}
	.tbl_01 td {border-right: none; border-left: none;}
	.tdTitle{font-weight: bold;  color: #444;}
</style>
<!-- widget grid -->
<section id="widget-grid" class="">
	<!-- row -->
	<div class="row subRightContentsBottomWrap">
		<div class="subSubtitleBox">
		<div class="inner clearfix" style="text-align: left;">
			<select class="selectDefault mobileW100" onchange="pf_ProgramSelect();" id="programTitle">
				<option value="">단체프로그램 선택</option>
				<c:forEach items="${GroupList }" var="model" varStatus="index">
					<option value="${model.GM_KEYNO }" ${index.first ? 'selected' : '' }>${model.GM_NAME }</option>
				</c:forEach>
			</select>
		</div>
			<h1>
				<span id="ProgramName">${DetailData.GM_NAME}</span>
				<br>
				"해설사와 함께하는 신나는 투어"
			</h1>
		</div>
		<div class="subRealContentsBox">
			<div class="row subImgFirstDiviceBox">
				<div class="centerBox" >	
					<div class="subRealTitleBox">
						<h1>투어소개</h1>
					</div>	
						<div class="subRealContents" style="text-align: center;">
							<h4 id="programIntro">
								<pre>${DetailData.GM_INTRODUCE }</pre>
							</h4>
						</div>
				</div>
			</div>
			<div class="subRealTitleBox">
				<h1>투어안내</h1>
			</div>
			
			<div class="subTableBox table_wrap_mobile">
				<input type="hidden" value="${DetailData.GM_KEYNO }" id="programKey">
				<input type="hidden" value="${DetailData.GM_HOLIDAY }" id="holiday">
				<table class="tbl_01 tbl_last_txtL">
					<colgroup>
						<col width="1%">
						<col width="5%">
					</colgroup>
					<caption>투어안내</caption>
					<tbody>
						<tr>
							<td class="tdTitle">투어구분</td>
							<td><span id="tdDivision">${DetailData.GM_DIVISION_TEMP}</span></td>
						</tr>
						<tr>
							<td class="tdTitle">참여비용</td>
							<td>무료</td>
						</tr>
						<tr>
							<td class="tdTitle">운영시간</td>
							<td><span id="tdDate">${DetailData.GM_DATE}</span></td>
						</tr>
						<tr>
							<td class="tdTitle">장소</td>
							<td><span id="tdPlace">${DetailData.PM_NAME}</span></td>
						</tr>
						<tr>
							<td class="tdTitle">예약방법</td>
							<td>
								- 온라인 및 현장접수<br>
								- 전화 예약 불가<br>
								- 희망일 하루 전까지 접수가능
							</td>
						</tr>
						<tr>
							<td class="tdTitle">투어 설명</td>
							<td id="tdSummary">
							<pre>${DetailData.GM_SUMMARY}</pre>
							</td>
						</tr>
					</tbody>
				</table>
				<div class="textR pdT15">
					<button class="btn btnSmall_write" onclick="pf_booking(1, this);">예약하기</button>
				</div>
			</div>
		</div>
	</div>

</section>
<!-- end widget grid -->

<%@ include file="/WEB-INF/jsp/user/_DY/function/group/prc_group_receipt.jsp"%>

<script type="text/javascript">

$(function(){
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
	    	
// 	    	var newDate = new Date(y+"-"+m+"-"+d)
	    	
// 	    	pf_checkDate();
	    	if(m == 11){
	    		m = 0;
	    		y += 1;
	    	}else{
		    	m += 1;
	    	}
	    	setDateTitle();
	    })
});

//3달 제한걸기
function pf_checkDate(){
	
}

//프로그램 고르기
function pf_ProgramSelect(){
	var titlekey = $("#programTitle option:selected").val();
	if(titlekey){
		$.ajax({
		    type   : "post",
		    url    : "/dy/function/groupAjax.do",
		    data   : "GM_KEYNO="+titlekey+"&apTiles=${currentTiles}",
		    success:function(data){
		    		var programdata = data.programdata;
		    		
		    		$("#holiday").val(programdata.GM_HOLIDAY);
		    		$("#programKey").val(programdata.GM_KEYNO);
		    		$("#ProgramName").text(programdata.GM_NAME);
		    		$("#programIntro pre").html(programdata.GM_INTRODUCE);
		    		$("#tdPlace").text(programdata.PM_NAME);
		    		$("#tdDate").text(programdata.GM_DATE);
		    		$("#tdDivision").text(programdata.GM_DIVISION_TEMP);
		    		$("#tdSummary pre").html(programdata.GM_SUMMARY);
		    		
		    },
		    error: function() {
		    	alert("에러");
		    }
		});
	}
}

//시간세팅
var date = new Date();
var d = date.getDate();
var m = date.getMonth();
var y = date.getFullYear();


/* ***********************************************************************************
 * 
 * 투어 캘린더 호출
 * 
 *************************************************************************************/

function pf_booking(num, obj){
	
	d = date.getDate();
	m = date.getMonth();
	y = date.getFullYear();
	//투명막씌우기
	$("#pop_bg_opacity").show();
	$("#tour_contents_pop_box").show(); 
	$("html").css("overflow-y", "hidden");
	$("body").css("overflow-y", "hidden");
	var temp = $("#tour_contents_pop_box");
	
// 	 화면의 중앙에 레이어를 띄운다.  
	if (temp.outerHeight() < $(document).height() ) temp.css('margin-top', '-'+temp.outerHeight()/2+'px');
	else temp.css('top', '0px');
	if (temp.outerWidth() < $(document).width() ) temp.css('margin-left', '-'+temp.outerWidth()/2+'px');
	else temp.css('left', '0px');
	
	// 전당투어 달력 레이어팝업 닫기 처리
	temp.find('a.contents_pop_cbtn').click(function(e){ 
		$("html").css("overflow-y", "");
		$("body").css("overflow-y", ""); 
		$("#pop_bg_opacity").fadeOut(); 
		$("#tour_contents_pop_box").hide();   
		//기존에는 페이지로드시 달력을 세팅했지만 버튼별 캘린더 세팅이 달라 캘린더를 초기화함
		$("#calendar_div").html("");  
	}); 
	$("#tour_contents_pop_box").focus();
	 
	//캘린더 나타내기
	setDateTitle('default');
	$('#calendar').fullCalendar('destroy');
	$('#calendar').fullCalendar({
			
	        header: {
				left: '',			        	
	        	center: '',
		        right: ''
		    },
		    height: "auto",
		    lang:"ko",
	        events: function(start, end, timezone, callback){
	        	var holidayType = $("#holiday").val();
	        	var key = $("#programKey").val();
	        	var options = "&start="+start.unix()+"&end="+end.unix()+"&GM_KEYNO="+key+"&GM_HOLIDAY="+holidayType;
	        	//데이터 표시하기
             	 callback(getEvents(options));
	        	
	        } ,
	        eventRender: function(event, element) {
	            if(event.className[0] == 'holiday'){
	            	$day = $('.fc-day-top[data-date='+event.start._i+']');
	            	$day.addClass('fc-holiday');
	            	$day.find('.fc-day-number').after('<span class="fc-day-title">'+event.title+'</span>')
	            	return false;
	            }else if(event.className[0] == 'deadline'){
	            	
	            	var temp = $(element).find(".fc-title").text().replace('신청마감','<font style="color:red">  신청마감</font>')
	            	
	            	$(element).find(".fc-title").html(temp);
	            	
	            }
	            
	        },
	        eventClick: function(calEvent, jsEvent, view) {
	        	var tourInfo = new Object();
	        	var year = calEvent.start._d.getFullYear();
	        	var month = calEvent.start._d.getMonth()+1;
	        	var date = calEvent.start._d.getDate();
	        	var time = calEvent.title;
	        	var key = calEvent.className;
	        	var st_time = time.substring(2,7);
	        	var cnt1 = time.indexOf("(")+1;
	        	var cnt2 = time.indexOf(")");
	        	var cnt = time.substring(cnt1, cnt2);
	        	tourInfo.year= year;
	        	tourInfo.month = cf_setTwoDigit(month);
	        	tourInfo.date = date;
	        	tourInfo.time = st_time;
	        	tourInfo.cnt = cnt;
	        	tourInfo.mainKey = key[0];
	        	tourInfo.subKey = key[1];
	        	
	        	if(cnt == null || cnt == ""){
	        		alert("선택하신 일정은 신청이 마감되었습니다.");
		        	return false;
	        	}
	        	pf_DetailMove(tourInfo)
	        },
	        eventMouseover: function(event, jsEvent, view){
	        	$(jsEvent.currentTarget).find('.fc-content').css("background", "#66666c");
	        	$(jsEvent.currentTarget).find('.fc-content').css("color", "#ffffff");
	        	
	        },
	      	eventMouseout: function(event, jsEvent, view){
	      		$(jsEvent.currentTarget).find('.fc-content').css("background", "#ffffff");
	      		$(jsEvent.currentTarget).find('.fc-content').css("color", "#66666c");
	      	}
	    });
	  
	 
	    $("#tour_contents_pop_box").draggable();
}

function setDateTitle(type){
	
	if(type == undefined){
		$('#calendar').fullCalendar('gotoDate',new Date(y,m));
	}
	var mString = (m+1)+ '';
	$('.date_box').text(y+"."+ ( mString.length == 1 ? '0'+mString:mString ) );
	if(mString > m+3){
		alert("최대 3개월까지 신청가능합니다.");
	}else if(mString < m){
		alert("신청기간이 종료되었습니다.");
	}
}

function getEvents(options){
	var events = [];
	$.ajax({
		type: "POST",
		url: "/dy/function/groupViewAjax.do",
		data: options,
		async:false,
		success : function(result){
			//현재날짜
			var now = new Date();
			var today = new Date(now.getFullYear(), now.getMonth(), now.getDate(), now.getHours(), now.getMinutes());
			today = today.getFullYear()+"-"+cf_setTwoDigit(today.getMonth()+1)+"-"+cf_setTwoDigit(today.getDate())+" "+cf_setTwoDigit(today.getHours())+":"+cf_setTwoDigit(today.getMinutes());
			var eventList = result.eventList;
			$.each(eventList,function(j){
				var st_time = eventList[j].GSS_ST_TIME;
				var en_time = eventList[j].GSS_EN_TIME;
				var st_date = eventList[j].st_date;
				var mainKey = eventList[j].MAIN_KEYNO;
				var subKey = eventList[j].SUB_KEYNO;
				var title = eventList[j].GSS_SUBTITLE;
				var cnt = eventList[j].GSS_MAXIMUM;
				var temp =  "· "+ eventList[j].GSS_ST_TIME;
				var className =Number(mainKey) +" "+ Number(subKey);
				if(en_time){
// 					temp += ' ~ ' + en_time; 
				}
				var tourTime = st_date+" "+st_time;
				if(tourTime > today){	//날짜가 지났으면 신청버튼 안보이게
					if(cnt <= 10){
						className = 'deadline';
						temp += '신청마감'
					}else{
						temp += " " + title +" ("+ cnt +')';					
					}
					events.push({
	                    title: temp,
	                    start: eventList[j].st_date,
	                    allDay:false,
	                    className:className,
	                    backgroundColor: 'white' 
	                });
				}
				/* else if(st_date == today){
					temp = '최소한 1일전까지\n 투어신청이 가능합니다.'
					events.push({
	                    title: temp,
	                    start: eventList[j].st_date,
	                    allDay:false,
	                    className:className,
	                    backgroundColor: 'white' 
	                });
				}
				 */
			})
			
			var holidayList = result.holidayList;
			$.each(holidayList,function(i){
				events.push({
                       title: holidayList[i].THM_NAME,
                       start: holidayList[i].THM_DATE,
                       allDay:true,
                       className: "holiday",
                       rendering : 'bakground',
                       backgroundColor: 'gray',
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