<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>
.dl-horizontal dt {line-height: 32px;}
#draggableWrap {width:800px;height:500px;border:2px solid #2183f0;margin:20px;position:relative;}
.draggable {  padding: 0.5em;position:absolute;top:0;left:0;cursor: pointer;text-align: center; 
		background-color: #00000017;
}
.draggable i {float:right;}
/* .settingSeatTable {margin:20px auto 0;min-height:400px;overflow: scroll;} */
.settingSeatTable td {text-align: center;}
.settingSeatTable input[type=text] {width: 50px;margin: 5px;padding: 5px;height:20px;text-align: center;}
.seatCheckList { color: white; background-color: #2c699d;}
.activeSeat{ color: white;background-color: red;}
.reservedSeat{ color: white; background-color: black;}
.seatCheckListEX { color: white; background-color: #2c699d;}
.activeSeatEX{ color: white;background-color: red;}
.reservedSeatEX{ color: white; background-color: black;}

.seatTable td {padding: 4px;font-size: 10px;}
.seatTable td button{font-size: 10px !important; padding: 4px; width: 25px; }
.groupTitleP {height:3px;}
.ex {width: 25px; height: 22px; float:left; margin:2px; text-align:center !important; line-height: 21px;}
.exPtag {float: left; margin: 3px; line-height: 19px;}
</style>


<form name="frmSelSeq" id="Form" method="post">
	<input type="hidden" name="APP_AP_KEYNO" id="APP_AP_KEYNO" value="" />
	<input type="hidden" name="APP_ASM_KEYNO" id="APP_ASM_KEYNO" value="" />
	<input type="hidden" name="APP_ASS_KEYNO" id="APP_ASS_KEYNO" value="" />
	<input type="hidden" name="A	PU_UI_KEYNO" id="APU_UI_KEYNO" value="${userInfo.UI_KEYNO }"/> 
	<input type="hidden" name="APP_APU_KEYNO" id="APP_APU_KEYNO" value="${userInfo.UI_KEYNO }" />
	<input type="hidden" name="APP_ST_DATE" id="APP_ST_DATE" value="" /> 
	<input type="hidden" name="APP_ST_TIME" id="APP_ST_TIME" value="" /> 
	<input type="hidden" name="APP_COUNT" id="APP_COUNT" value="" /> 
	<input type="hidden" id="APPcnt" value="" /> 
	<input type="hidden" name="APP_SEQUENCE" id="APP_SEQUENCE" value="" /> 
	<input type="hidden" name="AP_PRICE" id="AP_PRICE" value="" /> 
	<input type="hidden" name="APP_DIVISION" id="APP_DIVISION" /> 
	<input type="hidden" name="APP_EXPIRED" id="APP_EXPIRED" /> 
	<input type="hidden" name="App_type" id="App_type" />
	<input type="hidden" name="AP_SEAT_YN" id="AP_SEAT_YN" value="${resultData.AP_SEAT_YN}" />

<div id="page-890">
	<div id="con-890" style="width: 95% !important;">
		<div class="page-tit-area bor_0">
			<div class="tickets_title_box">
				<span class="ticket-title" tabindex="0" id="focusId"> </span>
			</div>

			<div class="img_ticket_step_box img_tbox info_line">
				<ul class="t_m_menu">
					<li class="t_m_menu_li">
						<ul class="t_m_menu_info">
							<li><a>날짜와 회차선택</a></li>
						</ul>
					</li>
					<li class="t_m_menu_li">
						<ul class="t_m_menu_info">
						
								<li><a>${resultData.AP_SEAT_YN == 'Y' ? '인원/좌석' : '인원선택'}</a></li>
							
						</ul>
					</li>
					<li class="t_m_menu_li">
						<ul class="t_m_menu_info">
							<li><a>할인적용</a></li>
						</ul>
					</li>
					<li class="t_m_menu_li">
						<ul class="t_m_menu_info">
							<li><a>티켓 수령 선택</a></li>

						</ul>
					</li>
					<li class="t_m_menu_li">
						<ul class="t_m_menu_info">
							<li><a>예약확인</a></li>
						</ul>
					</li>
				</ul>
			</div>
		</div>

		<div class="section step1">
			<!-- 날짜 및 회차선택 -->
			<div class="page-section pd375">
				<div style="clear: both;">

					<ul class="calen_box_first">
						<!-- 캘린더 -->
						<li class="now_list">
							<h2 class="dis-h5">
								<span class="line-h5"></span>날짜 선택
							</h2>
							<div class="now_listed_inner">
								<div id="calendar_div"></div>
							</div>
						</li>
						<!-- 회차(시간) 선택 -->
						<li class="now_list">
							<h2 class="dis-h5">
								<span class="line-h5"></span>회차(시간) 선택
							</h2>
							<div class="now_listed_inner">
								<table class="calendar_table3">
									<caption class="skip">회차(시간) 선택</caption>
									<colgroup>
										<col width="25%">
										<col width="30%">
										<col width="20%">
										<col width="25%">
									</colgroup>

									<thead>
										<tr>
											<th scope="col">회차</th>
											<th scope="col">시간</th>
											<th scope="col">예매가능 매수</th>
											<th scope="col"></th>
										</tr>
									</thead>

									<tbody id="ListBox">
										<!-- 추가될 날짜 및 회차 목록 -->
									</tbody>
								</table>
							</div>
						</li>
					</ul>
				</div>
			</div>
			<!-- //날짜 및 회차선택 -->

			<!-- 이전/다음 버튼  -->
			<div class="appl_btn" style="padding-bottom: 20px;">
				<a href="javascript:;" class="btnpoint apply_btn" onclick="next(1);">다음</a>
			</div>
		</div>

		<div class="section step2" style="display: none;">
			<!-- 인원 선택 -->
			<div class="page-section pd375">
				<div style="clear: both; padding-top: 15px;">
					<div class="benefit_bor-top">
						<ul class="cou_benefit_con3"
							style="border-bottom: 1px solid #2183f0;">
							<li class="benefit_title5-1">인원수를 선택 해 주세요.  &nbsp&nbsp선택 가능한 인원 수 : 최대 <span class="maxTicket"> </span> 명 </li>
							<li class="benefit_title6-1" id="priceList">
							<select id="08" name="08" title="인원수 선택" class="form-select" style="width: 180px;"></select> <label for="08" class="skip">인원수 선택</label></li>
						</ul>
					</div>
			
				</div>
			</div>
			<!-- //인원 선택 -->
			<!-- 좌석선택  -->
			<c:if test="${resultData.AP_SEAT_YN eq 'Y'}">
				<div style="margin-left: 18px; height: 10px;">
					<div class="seatCheckListEX ex"></div><p class="exPtag">선택가능</p> 
					<div class="activeSeatEX ex"></div><p class="exPtag">선택</p>
					<div class="reservedSeatEX ex">X</div><p class="exPtag">선택불가</p> 
					<p class="exPtag"><b style=" font-weight: bold;">&ensp;&ensp;현재 선택된 좌석 :</b></p> <p class="exPtag" id="selectedSeat"></p>
				</div>
			</c:if>	
				
				<div id="draggableWrap" >
				
				</div>
			
			<!-- //좌석선택 -->

			<!-- 이전/다음 버튼  -->
			<div class="appl_btn" style="padding-bottom: 20px; margin-left: 5px;">
				<a href="javascript:;" class="btnpoint" onclick="next(2);">다음</a>
			</div>
			<div class="appl_btn" style="padding-bottom: 20px;">
				<a href="javascript:;" class="btnpoint_gray_prev"
					onclick="goDateSeq(1);">이전</a>
			</div>
		</div>

		<div class="section step3" style="display: none;">
			<!-- 할인 적용 -->
			<div class="page-section pd375" style="padding-bottom: 20px;">
				<h5 class="dis-h5">
					<span class="line-h5"></span>할인 및 매수 선택
				</h5>
				<div class="salelist">
					<ul class="sale_info" style="border-bottom: 0px">
						<li class="seats-edit">
							<div class="center-where">
								<span class="seats_kind">인원수</span><br> <span
									class="font-13">(<em id="ticket_ticket_CHOICE"
									style="font-weight: 900; color: #fff;"></em>명 중 <em
									id="buy_cnt_08" style="font-weight: 900; color: #fff;">0</em>명
									선택)
								</span>
							</div>
						</li>

						<li style="height: 375px; overflow-x: hidden; overflow-y: auto;">
							<ul class="sale_info_detail">

							</ul>
						</li>
					</ul>
				</div>
			</div>
			<div id="pop_viewContant" class="pop_viewCon ticketInfo">
				<div class="inbox">
					<h4>
						티켓 안내 <span class="fn_right red"
							onclick="javascript:fn_bPopup_close();">X</span>
					</h4>
					<pre class="tab_dl"></pre>
				</div>
			</div>
			<!-- //할인적용 -->
			<!-- 이전/다음 버튼  -->
			<div class="appl_btn" style="padding-bottom: 20px; margin-left: 5px;">
				<a href="javascript:;" class="btnpoint" onclick="next(3);">다음</a>
			</div>
			<div class="appl_btn" style="padding-bottom: 20px;">
				<a href="javascript:;" class="btnpoint_gray_prev"
					onclick="goDateSeq(2);">이전</a>
			</div>
		</div>

		<div class="section step4" style="display: none;">
			<!-- 티켓 수령 선택 -->
			<div class="page-section pd375">
				<h5 class="dis-h5">
					<span class="line-h5"></span>티켓 수령 방법
				</h5>
				<p class="info_warning"
					style="clear: both; line-height: 25px; padding-top: 15px;">※
					원하시는 배송방법을 선택해 주세요.</p>
				<div style="clear: both;">
					<div class="benefit_bor-top">
						<ul class="cou_benefit_con4">
							<li class="benefit_title8"><input type="radio"
								class="align-edit" id="delivery01" name="delivery"
								value="000001" checked="checked"><label for="delivery01"
								class="skip">현장수령 하겠습니다. (무료)</label> 현장수령 하겠습니다.</li>
						</ul>
					</div>
				</div>
			</div>
			<!-- //티켓 수령 선택 -->
			<!-- 이전/다음 버튼  -->
			<div class="appl_btn" style="padding-bottom: 20px; margin-left: 5px;">
				<a href="javascript:;" class="btnpoint" onclick="next(4);">다음</a>
			</div>
			<div class="appl_btn" style="padding-bottom: 20px;">
				<a href="javascript:;" class="btnpoint_gray_prev"
					onclick="goDateSeq(3);">이전</a>
			</div>
		</div>

		<div class="section step5" style="display: none;">
			<!-- 결제선택 -->
			<div class="page-section pd375">
				<h5 class="dis-h5">
					<span class="line-h5"></span>예약 내용 확인하기
				</h5>
				<div class="salelist pdb25 pdt15" style="padding-bottom: 30px;">
					<div class="benefit_bor-top">
						<ul class="cou_benefit_con4">
							<li class="benefit_title5 credit_sel step1li">
							</li>
							<li class="benefit_title6 account_sel step2li"></li>
						</ul>
					</div>
				</div>
				<!-- //결제 선택 -->
				<!-- 이전/다음 버튼  -->
				<div class="appl_btn"
					style="padding-bottom: 20px; margin-left: 5px;">
					<a href="javascript:;" class="btnpoint" onclick="pf_Insert();">예약하기</a>
				</div>
				<div class="appl_btn" style="padding-bottom: 20px;">
					<a href="javascript:;" class="btnpoint_gray_prev"
						onclick="goDateSeq(4);">이전</a>
				</div>
			</div>
		</div>
	</div>
	</form>
	<script>
var ScheduleCnt = 1;
var scheduleList = [];
var ProgramSchdule = new Array();
var setMonth = new Date().getMonth() + 1;
var selectedKey;
var nowStD;
var lastday;
var selectedKey = '${resultData.AP_KEYNO}'
var selected_price = '${resultData.AP_PRICE}'
var holidayType = '${resultData.AP_HOILDAY}'
var programType = '${resultData.AP_TYPE}'
var apukey = '${apu_keyno}'
var charge_expired = '${resultData.AP_EXPIRED}'
var now_date = '${now_date}'
var group = '${seatGroups}';
var seatYN = "${resultData.AP_SEAT_YN}";
var ap_place = "${resultData.AP_PLACE}";
var max_ticketCnt;
var checkedSeat = [];
var buyable_Tickets;
//주간태그에 날짜태그 추가
$.fn.addDateTag = function(text){
  if(text == null){
    text = '';
  }     
  this.td = $("<td onclick=\"pf_selected('"+getDate+'-'+cf_setTwoDigit(text)+"',this) \">").addClass('tronixTd').attr('id', 'tronix' + text).html("<span>"+text+"</span>");
  
  if(this.tr != null){
    $(this.tr).append(this.td);
    this.td = null;
  }
};

$(function(){
	
	$(".t_m_menu").find(".t_m_menu_li:nth-child(1)").find("li").addClass("now-pagee");
	
	//무료일때
	if(selected_price == '0'){
		$ul = $(".t_m_menu")
		$ul.find(".t_m_menu_li:nth-child(3),.t_m_menu_li:nth-child(4)").hide();
	}
	
	
$("#calendar_div").showCalendar(setMonth);
	
	$(".step1").show();
	$(".step2, .step3, .step4, .step5").hide();	
	
	$("#tour_contents_pop_box").focus();
});

function SetSchedule(getDate){

	nowStD = dateToString(new Date(getDate+"-01"));	//그 달의 첫날
	lastday = lastDay(getDate+"-01");			//마지막일자 및 변수값세팅
	
	$.ajax({
	    type   : "post",
	    url    : "/${currentTiles}/function/programApplyAjax.do",
	    data   : {
		    "holidayType":holidayType,
		    "key":selectedKey,
		    "nowStD":nowStD,
		    "nowEnD":lastday,
		    "programType":programType
	    },
	    async:false,
	    success:function(dataes){
	    	var data 	  = dataes.eventList;
	    	var mainTitle = dataes.MainTitle;
	    	var AP_WAITING_YN = dataes.AP_WAITING_YN;
	    	var holiday   = dataes.holidayList;
	    	scheduleList = data;
	    	holidayList = holiday;
	    	$("#focusId").text("["+mainTitle+"]");
	    	WAITING = AP_WAITING_YN;
	    },
	    error: function() {
	    	alert("에러, 관리자에게 문의하세요.");
	    }
	});
	var checkB = false;
	$.each(scheduleList,function(i){
		if(!scheduleList[i]){
			return true;
		}
		var schedule = scheduleList[i];
		
		//현재날짜
		var now = new Date();
		var today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
		today = today.getFullYear()+"-"+cf_setTwoDigit(today.getMonth()+1)+"-"+cf_setTwoDigit(today.getDate());
		
		if(today <= schedule){
			insertSchedule(schedule);
			if(!checkB){
				var dd = schedule.split("-")[2];
				var d = dd.replace(/(^0+)/, "");
				$('#tronix'+d).trigger("onclick");
				checkB = true;
			}
		}
		
		if(i == 0){
			//첫번째꺼만 뽑기
			
		}
		
	});
	
	$.each(holidayList,function(j){
		if(!holidayList[j]){
			return true;
		}
		var holiday = holidayList[j];
		holidaySchedule(holiday.THM_DATE, holiday.THM_NAME);
	});
	return false;
}

//휴일 넣기 함수
function holidaySchedule(day, text){
	var d = day.split("-")[2];
	var dd = d.replace(/(^0+)/, "");
	var td = $('#tronix'+dd);
	var schedule = $(td).append("<p style='font-size:10px;'>"+text+"</p>");
	
	td.append(schedule); // 해당 날짜에 스케쥴 붙이기
}
//일정 넣기 함수
function insertSchedule(day){
	var d = day.split("-")[2];
	var dd = d.replace(/(^0+)/, "");
	var td = $('#tronix'+dd);
	var schedule = $(td).addClass('hasEvent');
	
	td.append(schedule); // 해당 날짜에 스케쥴 붙이기
}
//지난 일정
/* function LastSchedule(day){
	var d = day.split("-")[2];
	var dd = d.replace(/(^0+)/, "");
	var td = $('#tronix'+dd);
	var schedule = $(td).addClass('deadline');
	
	td.append(schedule); // 해당 날짜에 스케쥴 붙이기
} */

//날짜 클릭했을때
function pf_selected(date,obj){

	if(!$(obj).hasClass('hasEvent')){
		$("#ListBox").html("<tr class='noContent'><td colspan='4' class='table3_bor_b_gray'>예약할 수 있는 콘텐츠가 없습니다.</td></tr>");
		$(".calendar_table3").hide().show("slide", { direction: "left" }, 500);
		return false;
	}

	//배경색 바꾸기
	$("#ListBox").find('.yesContent').remove();
	$("#ListBox").find('.noContent').remove();
	$('.tronixTd').removeClass('onSelected');
	$(obj).addClass("onSelected");
	
	$("#APP_AP_KEYNO").val("");
	$("#APP_ASM_KEYNO").val("");
	$("#APP_ASS_KEYNO").val("");
	$("#APP_ST_DATE").val("");
	$("#APP_ST_TIME").val("");
	$("#APP_COUNT").val("");
	$("#APP_SEQUENCE").val("");
	
	$.ajax({
	    type   : "post",
	    url    : "/${currentTiles}/function/programTimeAjax.do",
	    data   : {
		    "key":selectedKey,
		    "date":date,
	    },
	    async:false,
	    success:function(data){
	    	if(data.length == 0){
	    		$("#ListBox").html("<tr class='noContent'><td colspan='4' class='table3_bor_b_gray'>예약할 수 있는 콘텐츠가 없습니다.</td></tr>");
	    	}else{
	    		var timeList = [];
	    		timeList = data;
	    		
	    		var now = new Date();
				var today = new Date(now.getFullYear(), now.getMonth(), now.getDate(), now.getHours(), now.getMinutes());
				today = today.getFullYear()+"-"+cf_setTwoDigit(today.getMonth()+1)+"-"+cf_setTwoDigit(today.getDate())+" "+cf_setTwoDigit(today.getHours())+":"+cf_setTwoDigit(today.getMinutes());
	    	
	    		$.each(timeList, function(i){
	    			var times = timeList[i];
	    			var applyTime = times.ST_DATE+" "+times.ST_TIME;
	    			
	    			var temp = '<tr class="yesContent"><td class="table3_bor_b_gray font_s_19"><span class="Apply_turn">'+(i+1)+'회차</span></td>';
	    				temp += '<td class="table3_bor_b_gray font_s_19"><span class="Apply_turn">'+times.ST_TIME+'</span></td>';
	    				temp += '<td class="table3_bor_b_gray font_s_19">';  					
	    				if(times.cnt <= 0){
		    				temp += '<span class="Apply_conut">0</span>매';	    					
	    				}else {
		    				temp += '<span class="Apply_conut">'+times.cnt+'</span>매';	    		    					
	    				}
	    				
	    				temp += '<br></td>';
	    				temp += '<td class="table3_bor_b_gray">';
    				if(applyTime > today){
		    				if(WAITING == 'N'){
		    					if(times.cnt <= 0){
			    					temp += '<a href="javascript:;" class="selC_on2" alt="매진">매진</a></td></tr>';	    					
			    				}else if(times.cnt > 0){
			    					temp += '<a href="javascript:;" class="selC_on" onclick="seqSelect(this, \''+date+'\', \''+times.ST_TIME+'\', \''+(i+1)+'회차\', \''+times.ASM_KEYNO+'\', \''+times.ASS_KEYNO+'\', \''+times.cnt+'\', \'N\');" alt="선택">선택</a></td></tr>';	    						    					
			    				}
		    				}else if(WAITING == 'Y'){
		    					if(times.cnt <= 0){
			    					temp += '<a href="javascript:;" class="selC_on" onclick="seqSelect(this, \''+date+'\', \''+times.ST_TIME+'\', \''+(i+1)+'회차\', \''+times.ASM_KEYNO+'\', \''+times.ASS_KEYNO+'\', \''+times.cnt+'\', \'W\');" alt="대기자 접수">대기자 접수</a></td></tr>';	    					
			    				}else if(times.cnt > 0){
			    					temp += '<a href="javascript:;" class="selC_on" onclick="seqSelect(this, \''+date+'\', \''+times.ST_TIME+'\', \''+(i+1)+'회차\', \''+times.ASM_KEYNO+'\', \''+times.ASS_KEYNO+'\', \''+times.cnt+'\', \'N\');" alt="선택">선택</a></td></tr>';	    						    					
			    				}
		    				}
	    			}else if(applyTime < today){
	    				temp += '<a href="javascript:;" class="selC_on" onclick="seqSelect(this, \''+date+'\', \''+times.ST_TIME+'\', \''+(i+1)+'회차\', \''+times.ASM_KEYNO+'\', \''+times.ASS_KEYNO+'\', \''+times.cnt+'\', \'D\');" alt="접수마감" style="background:#ad0808">접수마감</a></td></tr>';	 
	    			}
	    				
	    			$("#ListBox").append(temp);
	    			
	    		});
	    	}
// 	    	$(".calendar_table3").hide().show("slide", { direction: "left" }, 500);
	    },
	    error: function() {
	    	alert("에러");
	    }
	});
}

//선택버튼 클릭
function seqSelect(obj, StDate, StTime, SeqNm, AsmKey, AssKey, cnt, type) {
	if(type == "D"){
		alert("접수마감 된 프로그램입니다.");
		return false;
	}
	$("#App_type").val(type);
	
	$(obj).addClass("selC_off");
	
	$(".selC_on").click(function(){
		$('.selC_on').removeClass('selC_off');
		$(this).each(function(index,element){
			$(this).toggleClass('selC_off');
		});
	});
	
	$("#APP_ASM_KEYNO").val(AsmKey);
	$("#APP_ASS_KEYNO").val(AssKey);
	$("#APP_ST_DATE").val(StDate);
	$("#APP_ST_TIME").val(StTime);
	$("#APP_SEQUENCE").val(SeqNm);
	$("#APPcnt").val(cnt);
}

function pf_appCnt(){
	var cntVal = $("#08 option:selected").val();
	$("#APP_COUNT").val(cntVal);
}


//다음
var ajax_last_num = 0;//ajax 중복요청왔을때 계속 ajax success 코드가 실행되는 것을 방지하기 위해 마지막 요청 카운트 저장. 전역변수
function next(num) {
	//프로그램 키값
	$("#APP_AP_KEYNO").val(selectedKey);

	if(num==1){
		var asmKey = $("#APP_ASM_KEYNO").val();
		var assKey = $("#APP_ASS_KEYNO").val();
		var st_date = $("#APP_ST_DATE").val();
		var st_time = $("#APP_ST_TIME").val();
		var seq = $("#APP_SEQUENCE").val();
		
		if (!asmKey || !$("#APP_ST_TIME").val() || !assKey || !st_date || !st_time || !seq) {
			alert("회차(시간)를 선택해주세요.");
			return;
		}
		
		var seatBackGround;
		var reservedSeat;
		var group = '${seatGroups}';
		$.ajax({
		    type   : "post",
		    url    : "/${currentTiles}/function/program/ticketCnt.do",
		    data   : {
			    "AP_KEYNO":selectedKey,
			    "APS_AP_KEYNO": selectedKey,
			    "APS_APP_ST_DATE" : st_date,
			    "APS_APP_ST_TIME" : st_time,
			    "AP_PLACE" : ap_place
		    },
		    async:false,
		    success:function(data){
		    	var ticket = data.ticketCnt;
		    	var ticketCnt = ticket.AP_TICKET_CNT;
		    	max_ticketCnt  = ticketCnt;
		    	remain_ticketCnt = $("#APPcnt").val();
		    	if(max_ticketCnt > remain_ticketCnt){
		    		max_ticketCnt = remain_ticketCnt;
		    	}
		    	$(".maxTicket").html(max_ticketCnt);
		    	
		    	
		    	reservedSeat = data.reservedSeat;
		    	seatBackGround = data.seatBackGround;
	    		var temp =  '<option value="0">인원수 선택</option>';
	    		var length = Number(ticketCnt);
	    		var wating = $("#App_type").val();
	    		
	    		if(wating == 'W'){	//대기자는 무조건 1매만 예매 가능
	    			length = 1;
	    		}else if(length > Number($('#APPcnt').val())){
	    			length = Number($('#APPcnt').val());
	    		}
	    
			    if(seatYN == 'N'){	
		    		if(ticket){
			    		for(i = 1; i <= length; i++){
			    			temp += '<option value="'+i+'" >'+i+'</option>';		    			
			    		}
			    	
			    	}
		    		
			    }	
			    $("#08").html(temp);
		    	
		    	//좌석선택 
		    	if(seatYN == 'Y'){
		    		$("#draggableWrap").show();
		    		
		    		if( group){
		    			pf_settingSeatGroupsData(group,reservedSeat,seatBackGround);
		    		}
		    	}else{
		    		$("#draggableWrap").hide();
		    	}		
		    	
		    	
		    	
		    }
		});
		
		
		
			
		
		var seatPlanWidth = '${resultData.PM_SEATPLAN_WIDTH}';
		var seatPlanHeight = '${resultData.PM_SEATPLAN_HEIGHT}';
		if(seatPlanWidth != '0'){
			$('#draggableWrap').css({
				'width':seatPlanWidth,
				'height':seatPlanHeight
			})
		}else if(seatPlanWidth == '0'){
			$('#draggableWrap').css({
				'width':'800px',
				'height':'500px'
			})
		}
		//좌석선택 끝
		
		
	}else if(num==2){
		
		//ajax 요청 시작하기 전에. ajax 요청이 들어있는 함수내의 지역변수
		var current_ajax_num = 0; //ajax 중복요청왔을때 계속 ajax success 코드가 실행되는 것을 방지하기 위해 지금 들어온 요청의 카운트 저장 
		pf_appCnt();
		var cnt = $("#APP_COUNT").val();
		if(!cnt || cnt == '0'){
			alert("인원수를 선택해 주세요.");
			return;
		}
		$("#ticket_ticket_CHOICE").text(cnt);
		
		var checkedSeatGo='';
		if(checkedSeat !="" ){
			checkedSeatGo = "/&nbsp;예약좌석 :&nbsp" + checkedSeat;
		}
		
		//무료일 때
		if(selected_price == '0'){
			$li = $(".t_m_menu").find(".t_m_menu_li:nth-child("+num+")").find(".t_m_menu_info"); 
			$li.append('<li><p class="info_detail ellipsis step2p">예약인원 ('+cnt+'명)'+checkedSeatGo+'</p></p></li>');	
			next(4);
			return false;
		}
	
		$.ajax({
		    type   : "post",
		    url    : "/${currentTiles}/function/programChargeAjax.do",
		    data   : {
			    "key":selectedKey,
		    },
		    async:false,
		    beforeSend:function(request){ 
		    	ajax_last_num = parseInt(ajax_last_num) + 1;
		    	//전체 요청의 마지막 count 를 +1 
	    	},
		    success:function(data){
		    	if(current_ajax_num == (parseInt(ajax_last_num) - 1)){ // ajax 요청이 중복해서 많이 들어올 경우 현재 요청이 마지막 요청인지 확인하는 분기
			    	
			    	//일반요금
			    	var origin_price = data.program_price.AP_PRICE;
			    	var price = numberFormat(origin_price);
			    	
					//할인 요금
			    	var charge = data.chargeList;
					var saleList = [];
					saleList = charge;
					var temp2 =	'<option value="0">매수선택</option>';
					var length = Number($("#08").val());
					
		    		for(i = 1; i <= length; i++){
		    			temp2 += '<option value="'+i+'">'+i+'</option>';		    			
		    		}
					
					
					$.each(saleList, function(i){
						sales = saleList[i];
						
						var adkey = sales.AD_KEYNO
						var key = cf_setKeyno(sales.AD_KEYNO);
						var newId = cf_getNewKeyno(key, "T", "A");
						var tmp = cf_getNewKeyno(key,"", "B");
						var notmp = cf_getNewKeyno(key,"", "C");
						var number = cf_getNewKeyno(key,"", "D");
						
						var name = sales.AD_NAME;							//할인이름
						var discountType = sales.AD_TYPE					//할인 유형
						var origin_dis = sales.AD_MONEY		
						var discount = numberFormat(origin_dis);			//할인율
						
						var calc = origin_price * (1 - (origin_dis / 100))	//할인계산(퍼센트)
						var calc_won = origin_price-origin_dis				//할인계산(원)
						
						if(calc_won < 0){calc_won = 0;}
						
						var temp =  '<li id='+newId+' style="border-bottom: 1px solid #2377ce;" name='+tmp+'>';
							temp += '<ul class="sale_info_inner" id='+tmp+'><li class="disconutName">';
							
							if(discountType == 'C'){
								temp += ''+name+'';							
							}else if(discountType == 'A'){
								temp += ''+name+'('+discount+'%)';	
								temp += '<span class="fr" style="cursor:pointer">';
								
								temp += '<img src="/resources/img/calendar/ticket_discount_info_2.jpg" onclick="pf_saleComent(\''+adkey+'\');">';
								temp += '</span>';
							}else if(discountType == 'B'){
								temp += ''+name+'('+discount+'원)';
								temp += '<span class="fr" style="cursor:pointer">';
								temp += '<img src="/resources/img/calendar/ticket_discount_info_2.jpg"  onclick="pf_saleComent(\''+adkey+'\');">';
								temp += '</span>';
							}
	
							temp += '</li><li class="sale_edit1">';
							if(discountType == 'C'){
								temp += '<span class="russia">'+price+'</span>&nbsp;원';							
							}else if(discountType == 'A'){
								temp += '<span class="russia">'+numberFormat(Math.ceil(calc))+'</span>&nbsp;원';							
							}else if(discountType == 'B'){
								temp += '<span class="russia">'+numberFormat(calc_won)+'</span>&nbsp;원';												
							}
							
							temp += '</li><li class="sale_edit2">';
		                	temp += '<select name="09" id='+notmp+' title="매수선택" class="form-select" style="width:150px;" onchange="grade_choice(this,\''+notmp+'\')">';
							temp += temp2;
							temp += '</select>';
							temp += '<a href="javascript:void(0);" class="btn-seata" title="선택 초기화" onclick="pf_chogi(this);">X</a>';
							temp += '</li></ul></li>';
							$(".sale_info_detail").append(temp);
					});
		    	}
		    },
		    error: function() {
		    	alert("에러");
		    }
		});
	}else if(num==3){
		if(selected_price != '0'){
			var cnt = $("#ticket_ticket_CHOICE").text();
			var ticketCnt = $("#buy_cnt_08").text();
			if(cnt != ticketCnt){
				alert("선택하신 인원수와 선택하신 티켓 수량이 맞지 않습니다.");
				return false;
			}
		}
	}else if(num==4){
		$('.step1li').text($('.step1p').text());
		$('.step2li').text($('.step2p').text());
	}
	
		$ul = $(".t_m_menu");
		$ul.find(".t_m_menu_li").find("li").removeClass("now-pagee"); 
		$li = $ul.find(".t_m_menu_li:nth-child("+num+")").find(".t_m_menu_info"); 
		
		if(num==1){
			$li.append('<li><p class="info_detail ellipsis step1p">'+st_date+' '+seq+'('+st_time+')</p></p></li>');			
		}else if(num==2){
			$li.append('<li><p class="info_detail ellipsis step2p">예약인원 ('+cnt+'명)</p></p></li>');						
		}else if(num==3){
			$li.append('<li><p class="info_detail ellipsis step3p">할인</p></p></li>');						
		}else if(num==4){
			$li.append('<li><p class="info_detail ellipsis step4p">현장수령</p></p></li>');						
		}
		
		$ul.find(".t_m_menu_li:nth-child("+(num+1)+")").find("li").addClass("now-pagee");
		
		$(".section").hide();
		$(".step"+(num+1)+"").show();		
}

function goDateSeq(num){
	
	if((num == 3 || num == 4) && selected_price == '0'){
		num = 2 ;
	}
	
	//위의 메뉴부분 css
	$ul = $(".t_m_menu")
	$li = $ul.find(".t_m_menu_li:nth-child("+num+")").find(".t_m_menu_info"); 
	$ul.find("li").removeClass("now-pagee");
	$li.find("li").addClass("now-pagee");
	$li.find("li:nth-child(2)").remove();
	
	$(".section").hide();
	$(".step"+num+"").show();
}

//키값 변경
function cf_getNewKeyno(number,tableName ,type){
	
	number = number + '';
	for(var i=number.length;i<6;i++){
		number = '0' + number;
	}
	if(type == 'A'){
		return tableName + '_' + number //키값 변경
	}else if(type == 'B'){
		return '08'  +number + 'tmp' //키값 변경(tmp)
	}else if(type == 'C'){
		return '08'  +number //키값 변경(tmp 제거)
	}else if(type == 'D'){
		return number //키값 변경(숫자만)
	}
}

var sumtotal = 0;
function grade_choice(obj, id){
var sum = 0;
	var cnt = $("#APP_COUNT").val();
	$("select[name=09]").each(function(i){
		var selectCnt = $(this).val();
		
		sum += parseInt(selectCnt);
		
		if(cnt < sum){
			alert("구매 가능한 매수를 초과하였습니다.");
			sum -= $(this).val();
			$(this).val("0");
			return false;
		}
	});
	$("#buy_cnt_08").text(sum);
	
	sumtotal = sum;
}
function pf_chogi(obj){
	var d = $(obj).prev().val();
	$(obj).prev().val("0");
	sumtotal -= d;
	$("#buy_cnt_08").text(sumtotal);
}

function pf_saleComent(key){
	
	$.ajax({
		type : "POST",
		url : "/${currentTiles}/function/program/SaleComentAjax.do",
		data : {
			"AD_KEYNO" : key
		},
		async:false,
		success : function(data){
			$(".inbox").find("pre").text(data);
			$("#pop_viewContant").fadeIn();
		},
		error: function(){
			alert('알수없는 에러 발생. 관리자한테 문의하세요.')
			return false;
		}
	});
}

function pf_Insert(){
	var wating = $("#App_type").val();	//대기자인지 아닌지
	var app_st_date = $("#APP_ST_DATE").val();	//공연일

	var APP_expired = pf_expired(now_date, charge_expired);
	 if(seatYN == "Y"){
		if(pf_dupleSeatCheck()){
			alert('이미 예약된 좌석입니다.')
			return false;
		}
	 }
	
	if(APP_expired > app_st_date){
		APP_expired = app_st_date;
	}
	$("#APP_EXPIRED").val(APP_expired);
	
	$("#APP_DIVISION").val('${sp:getData("PROGRAM_APPLY")}');
	$("#AP_PRICE").val(selected_price);
	$("#APP_APU_KEYNO").val(apukey);
	var form = document.getElementById("Form");
	$("select[name=09]").each(function(i){
		var saleSelect = $(this).val();
		if(saleSelect != 0){
			var saleCnt = $(this).val();
// 			var saleName = $(this).parent().siblings(".disconutName").text();	//할인명
			var salePrice = $(this).parent().siblings(".sale_edit1").find(".russia").text();
			var key = $(this).parent().parent().parent().attr("id");
			var AD = cf_setKeyno(key);
			var ADkey = cf_getKeyno(AD, "AD");

			//키
			var hiddenKey = document.createElement("input");
			hiddenKey.setAttribute("type", "hidden");
			hiddenKey.setAttribute("name", "APD_AD_KEYNO");
			hiddenKey.setAttribute("value", ADkey);
			form.appendChild(hiddenKey);
			
			//매수
			var hiddenCnt = document.createElement("input");
			hiddenCnt.setAttribute("type", "hidden");
			hiddenCnt.setAttribute("name", "APD_CNT");
			hiddenCnt.setAttribute("value", saleCnt);
			form.appendChild(hiddenCnt);

			//가격
			var hiddenPrice = document.createElement("input");
			hiddenPrice.setAttribute("type", "hidden");
			hiddenPrice.setAttribute("name", "APD_PRICE");
			hiddenPrice.setAttribute("value", unNumberFormat(salePrice));
			form.appendChild(hiddenPrice);
		}
	});
	
	
	//선택 좌석 
	$.each(checkedSeat,function(index, item){
		var hiddenCheckedSeat = document.createElement("input");
		hiddenCheckedSeat.setAttribute("type", "hidden");
		hiddenCheckedSeat.setAttribute("name", "seatCheckList");
		hiddenCheckedSeat.setAttribute("value", item);
		form.appendChild(hiddenCheckedSeat);
	})
	

	//등록 처리 시작  
	$.ajax({
		type : "POST",
		url : "/${currentTiles}/function/programInsert.do",
		data : $("#Form").serialize(),
		async:false,
		success : function(result){
			if(wating == 'N'){	//대기자아님
		    	if(selected_price == 0){
			    	alert("신청되었습니다.\n신청하신 내역은 마이페이지에서 확인 가능합니다.");	    		
		    	}else{
			    	alert("수강 신청이 완료 되었습니다.\n수강을 위해 결제부탁드립니다. \n예약 후 기간 내 결제되지 않을시 자동 취소됩니다. \n결제만료일은  "+APP_expired+"입니다.");	    			    		
		    	}
	    	}else{
		    	if(selected_price == 0){	//대기자
			    	alert("대기자로 수강 신청이 완료 되었습니다.\n공석이 생길 경우 자동으로 신청이 완료 됩니다.\n신청하신 내역은 마이페이지에서 확인 가능합니다.");	    			    				    		
		    	}else{
			    	alert("대기자로 수강 신청이 완료 되었습니다.\n공석이 생길 경우 자동으로 신청이 완료 됩니다. \n신청 완료 후 기간 내 결제되지 않을시 자동 취소됩니다. \n결제만료일은  "+APP_expired+"입니다.");	    			    		
		    	}
	    	}
			pf_close('program_contents_pop_box');
		},
		error: function(){
			alert('알수없는 에러 발생. 관리자한테 문의하세요.')
			return false;
		}
	});
}

//티켓할인 설명 닫기
function fn_bPopup_close(){
	$("#pop_viewContant").fadeOut();
}

function pf_settingSeatGroupsData(group,reservedSeat,seatBackGround){
	seatGroups = JSON.parse(group);
	seatGroupCount = seatGroups.length;
	
	
	
	$.each(seatGroups,function(count){
		seatGroup = seatGroups[count];
		var temp = '';
		temp += '<div class="draggable ui-widget-content" id="draggable'+count+'" data-count="'+count+'" style="top:'+seatGroup.top+'px;left:'+seatGroup.left+'px">';
		temp    += '<p class="groupTitleP"><span class="seatGroupTitle">'+ seatGroup.title +'</span></p><br>';
		temp    += '<table class="seatTable">';
		var table = seatGroup.table;
		for(var i=0;i<table.length;i++){
			temp    += '<tr>';
			var colList = table[i];
			for(var j=0;j<colList.length;j++){
				temp    += '<td><button type="button" name="seatCheckList" class="seatCheckList" id =\"'+seatGroup.title+'_'+colList[j]+'\" onclick="pf_activeSeat(this.id);">'+ colList[j] +'</button></td>';		
				
			}
			temp    += '</tr>';
		}
		
		temp    += '</table>';
		temp    += '</div>'
		
		
		$('#draggableWrap').append(temp);
		if(seatBackGround != null || seatBackGround == 'undefined'){
			var seatBackGroundImg = seatBackGround.SEATBACKGROUND_PUBLIC_PATH
		$("#draggableWrap").css("background-image","url("+seatBackGroundImg+")");
		$("#draggableWrap").css("background-size","cover");
		}
		
	});
	
	if(reservedSeat != null ){
		$(".seatCheckList").each(function(i){
			var reservedID = $(this).attr("id").trim()
			var seatUseCk = false;
			if( reservedSeat.includes(reservedID)) {
				seatUseCk = true;

				$(this).prop("disabled",seatUseCk);
				$(this).attr("class","reservedSeat");
				$(".reservedSeat").text('X');
			}
			
		})
		
	}
}



//자바스크립트로 체크박스 조작 방지 
function pf_dupleSeatCheck(){
	var st_date = $("#APP_ST_DATE").val();
	var st_time = $("#APP_ST_TIME").val();
	var duplechk = false;
	

	
	$.ajax({
	    type   : "post",
	    url    : "/${currentTiles}/function/program/dupleSeatCheckAjax.do",
	    data   : {
		    "AP_KEYNO":selectedKey,
		    "APS_AP_KEYNO": selectedKey,
		    "APS_APP_ST_DATE" : st_date,
		    "APS_APP_ST_TIME" : st_time,
		    "checkedSeat" :checkedSeat
	    },
	    async:false,
	    success:function(data){
	
		    if(data){
		    	duplechk = true;
		    }
	    }
	    ,
		error: function(){
			alert('알수없는 에러 발생. 관리자한테 문의하세요.')
			return false;
		}
   
	});
	 
	return duplechk;
}


function pf_activeSeat(id){
	var getClass = $("#"+id).attr('class');
	var temp;
	var activeTick = $(".activeSeat").length
	
			if(getClass == 'activeSeat'){
				$("#"+id).attr("class","seatCheckList");
				checkedSeat = jQuery.grep(checkedSeat, function(value) { return value != id; });
			}else{
				if(activeTick < max_ticketCnt){
				$("#"+id).attr("class","activeSeat");
				checkedSeat.push(id);
				}else{
					alert('최대 구매할 수 있는 티켓수 :'+max_ticketCnt+' 를 초과하였습니다.')	
					return false;
				}
			}
			activeTick = $(".activeSeat").length;
			temp = '<option value="'+activeTick+'" selected>'+activeTick+'</option>';	
			$("#08").html(temp);
			var selectSeat = "";
			var last = checkedSeat.length-1;
			$.each(checkedSeat,function(i,index){
				if( i != last){
				selectSeat += checkedSeat[i]+",&nbsp;";
				}else{
				selectSeat += checkedSeat[i];
				}
			})
			
			$("#selectedSeat").html(selectSeat);
			pf_appCnt();
		
}
</script>