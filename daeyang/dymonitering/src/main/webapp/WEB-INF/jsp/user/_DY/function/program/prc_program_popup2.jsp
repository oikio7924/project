<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<html lang="ko" xmlns="http://www.w3.org/1999/xhtml"><head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=2.0,user-scalable=yes">
	<title>ACC-날짜선택</title> 
 
	<link rel="stylesheet" type="text/css" href="/resources/api/FrontMArte/css/import.css">
	<link rel="stylesheet" type="text/css" href="/resources/api/FrontMArte/css/mypage.css">
	<link rel="stylesheet" type="text/css" href="/resources/api/FrontMArte/css/ticket.css">
	<link rel="stylesheet" type="text/css" href="/resources/api/FrontMArte/css/calendar.css">
	<link rel="stylesheet" type="text/css" href="/resources/api/FrontMArte/css/ticket_2.css">
     
    <link href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" rel="stylesheet">
	<script type="text/javascript" src="/resources/api/FrontMArte/js/jquery-1.11.0.min.js"></script>
	<script type="text/javascript" src="/resources/api/FrontMArte/js/jquery-ui-1.10.3.custom2.js"></script>
	<script type="text/javascript" src="/resources/api/FrontMArte/js/json2.js"></script>
	<script type="text/javascript" src="/resources/api/FrontMArte/js/comm.js"></script>
	<script type="text/javascript" src="/resources/api/FrontMArte/js/security.js"></script> 
	<script type="text/javascript" src="/resources/api/FrontMArte/js/fn_booking_date_seq.js"></script>
	<style type="text/css">
		.ui-datepicker-title {font-weight:bold; color : #333333;}
		.pop_viewCon {display: none;width: 400px;}
		.pop_viewCon .inbox {padding: 10px;margin: 50px;text-align: left;background: #fff;border: 5px solid #3571B5;}
		.pop_viewCon h4 {background: #6eabd7;color: #fff;font-size: 14px;font-weight: bold;padding: 8px 15px 6px 15px;}
		.pop_viewCon .etc {padding-top: 10px;margin: 30px;text-align: center;background: #fff;}
		.tab_dl dt {color: #505050;font-size: 14px;margin-top: 10px;margin-bottom: 3px;font-weight: bold;}
		.tab_dl dd {color: graytext;margin: 0;}
		body {font-size: 13px}
		.fn_right {float: right;font-size: 30px;margin-top: -13px;cursor: pointer; margin-right:-8px;}
	</style>

	<script type="text/javascript">



		  $(document).ready(function(){

			var LANG_TMP =  $("input[name='LANG']").val();
			var yearSuffix_LOCALE			= "";
			var monthNamesShort_LOCALE		= [""];
			var monthNames_LOCALE			= [""];
			var dayNamesMin_LOCALE			= [""];
			var showMonthAfterYear_LOCALE	= true;
 
			if(LANG_TMP != 'K' ){
			
				yearSuffix_LOCALE			= "";
				monthNamesShort_LOCALE		= [
											   "1월",
											   "2월",
											   "3월",
											   "4월",
											   "5월",
											   "6월",
											   "7월",
											   "8월",
											   "9월",
											   "10월",
											   "11월",
											   "12월",
											   ];
				monthNames_LOCALE			= [
											   "1월",
											   "2월",
											   "3월",
											   "4월",
											   "5월",
											   "6월",
											   "7월",
											   "8월",
											   "9월",
											   "10월",
											   "11월",
											   "12월"
											   ];
				showMonthAfterYear_LOCALE = false;
				dayNamesMin_LOCALE			= [ 
											   "일",
											   "월",
											   "화",
											   "수",
											   "목",
											   "금",
											   "토"
											  ];

			}else{
				yearSuffix_LOCALE			= "년";
				monthNamesShort_LOCALE		= ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'];
				monthNames_LOCALE			= ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'];
				showMonthAfterYear_LOCALE = true;
				dayNamesMin_LOCALE			= [ '일', '월', '화', '수', '목', '금', '토' ];
			}

			var PROGRAM_CD_date =  $("input[name='PROGRAM_CD']").val();
			var curDate = new Date();
			var eventdate = '2018-04-25';
			var d = new Date();
			d.setDate(d.getDate()+1)
			var Dif = d.getFullYear()+"-"+pad(d.getMonth()+1)+"-"+pad(d.getDate());

			curDate = curDate.getFullYear()+"-"+pad(curDate.getMonth()+1)+"-"+pad(curDate.getDate());

			var program_date = eventdate.split(",")[0];

			curDate = program_date; 

			var eventdate = '2018-04-25';

		    $( "#datepicker" ).datepicker({
				 defaultDate : curDate,
				 dateFormat : 'yy-mm-dd',
		         dayNames : [ '일요일' ,'월요일', '화요일', '수요일', '목요일', '금요일', '토요일'],
		         dayNamesMin : dayNamesMin_LOCALE,
		         monthNamesShort: monthNamesShort_LOCALE,
		         monthNames: monthNames_LOCALE,
				 yearSuffix: yearSuffix_LOCALE,
			     showMonthAfterYear : showMonthAfterYear_LOCALE ,
		         beforeShowDay: function(day) {

					if(eventdate.indexOf($.datepicker.formatDate('yy-mm-dd', day)) != -1) {	
						return [true, "eventday", "예매가능일", "printDate.getMonth()", "printDate.getFullYear()"];
					} else {
						return [true, "", "", "", ""];
					}

		         },
		         onSelect: function(date){

					//설날당일 무료 시작
					if((PROGRAM_CD_date == '10000464' || PROGRAM_CD_date == '10000469'|| PROGRAM_CD_date == '10000477')){
						if(date == '2018-03-02'){
							fn_bPopup('freePro1');
							selectDate('2011-03-01');
							return;
						}
					}
					//설날당일 무료 처리 끝 //
					
					var frm = document.frmSelSeq;
				
					frm.PLAY_DATE.value = "";
					frm.PLAY_SEQ_CD.value = "";
					frm.PLAY_ST_TIME.value = "";
					frm.PLAY_SEQ_NM.value = "";
					frm.PHYMAP_NBR.value = "";
					
					if(Dif == date && d.getHours() >= 17){
						selectDate("2001-01-01");
					}else{
						selectDate(date);
					}

					runEffect();
		         }
			 });
			 //selectDate(convertToDay(curDate));
			// selectDate(curDate);
			if(Dif != curDate || d.getHours() < 17){selectDate(curDate);}		//내일 공연 17시에 마감 처리
			if(LANG_TMP == "K")$("#"+PROGRAM_CD_date).bPopup();					//안내 팝업창

			//프로그램명 짧아서 해둠
			if(LANG_TMP == "K" && PROGRAM_CD_date =="10000468"){
					$(".ticket-title").text("[2018 ACC브런치콘서트 1회<문학심리학 박사 김정운의 '슈베르트, 겨울나그네'>]")
				}

			});		

		
		function seqSelect(playDate, playSeqCd, playStTime, playSeqNm, PhymapNbr,assignSeatCnt) {
			var frm = document.frmSelSeq;
			
			frm.PLAY_DATE.value = playDate;
			frm.PLAY_SEQ_CD.value = playSeqCd;
			frm.PLAY_ST_TIME.value = playStTime;
			frm.PLAY_SEQ_NM.value = playSeqNm;
			frm.PHYMAP_NBR.value = PhymapNbr;
			$("#ASSIGN_SEAT_CNT").val(assignSeatCnt);
		}
		
		function next() {
			var frm = document.frmSelSeq;
			
			var playDate = frm.PLAY_DATE.value;
			var playSeqCd = frm.PLAY_SEQ_CD.value;
			var playStTime = frm.PLAY_ST_TIME.value;
			var playSeqNm = frm.PLAY_SEQ_NM.value;
			var PhymapNbr = frm.PHYMAP_NBR.value;
			
			if (playDate == "" || playSeqCd == "" || playStTime == "" || playSeqNm == "") {
				
				alert("회차(시간)를 선택해주세요.");
				
				return;
			}
			
			goSeat(playDate, playSeqCd, playStTime, playSeqNm, PhymapNbr);
		}

			function pad(num) {
				num = num + '';
				return num.length < 2 ? '0' + num : num;
			}

		function runEffect() {

		  // get effect type from
		  var selectedEffect = "drop";

		  // Most effect types need no options passed by default
		  var options = {};
		  // some effects have required parameters
		  if ( selectedEffect === "scale" ) {
			options = { percent: 50 };
		  } else if ( selectedEffect === "size" ) {
			options = { to: { width: 200, height: 60 } };
		  }

		  // Run the effect
	//      $( ".effecta" ).toggle( selectedEffect, options, 500 );
			$( ".calendar_table3" ).hide();
			$( ".calendar_table3" ).show( selectedEffect, options, 500 );
		};
			
	</script>
	
	<script type="text/javascript">
		//top버튼 구현
		$(document).ready(function() {
			document.getElementById("focusId").blur();
			document.getElementById("focusId").focus();
			$(function() {
				$(window).scroll(function() {
					if ($(this).scrollTop() > 50) { // 스크롤 내릴 표시
						$('.top').fadeIn();
					} else {
						$('.top').fadeOut();
					}
				});

				$('.top').click(function() {
					$('body,html').animate({
						scrollTop : 0
					}, 800); // 탑 이동 스크롤 속도
					return false;
				});
			});
		});
	</script>
</head>
<body style="">
	<form name="frmDateSeq">
		<input type="hidden" name="PLAY_COMPANY_CD" value="800609">
		<input type="hidden" name="PLACE_CD" value="1002">
		<input type="hidden" name="REG_COMPANY_CD" value="800609">
		<input type="hidden" name="PROGRAM_CD" value="10000479">
		<input type="hidden" name="LANG" value="K">
		<input type="hidden" name="PLAY_SEQ_NM" value="">
		<input type="hidden" name="PLAY_DATE" id="PLAY_DATE" value="20180425">
		<input type="hidden" name="locale" value="ko_KR">
		<input type="hidden" name="ASSIGN_SEAT_CNT" value="" id="ASSIGN_SEAT_CNT">
	</form>
	
	<form name="frmSelSeq">
		<input type="hidden" name="PLAY_DATE" value="">
		<input type="hidden" name="PLAY_SEQ_CD" value="">
		<input type="hidden" name="PLAY_ST_TIME" value="">
		<input type="hidden" name="PLAY_SEQ_NM" value="">
		<input type="hidden" name="PHYMAP_NBR" value="">
	</form>

	<!-- 예매권 사용 -->
	<div id="booking_dis_pay_advticket"></div>

	<!-- 쿠폰 사용 -->
	<div id="booking_dis_pay_coupon"></div>

	<!-- 포인트 사용 -->
	<div id="booking_dis_pay_point"></div>

	<div id="page-890">
		<div id="con-890" style="width:95% !important;">
			<div class="page-tit-area bor_0">
				<div class="tickets_title_box">
					<h3 class="tickets_buy_title">
						
						
							티켓예매
						
					</h3>  
					<span class="ticket-title" tabindex="0" id="focusId">
						[ 2018 ACC브런치콘서트 3회&lt;클론 강원래의 이야기 노래선물&gt; ] 
					</span>
				</div>

				<div class="img_ticket_step_box img_tbox info_line">
					<ul class="t_m_menu">
						<li class="t_m_menu_li">
							<ul class="t_m_menu_info">
								<li class="now-pagee">
									<a>날짜와 회차선택</a>
								</li>
							</ul>
						</li>
						<li class="t_m_menu_li bb1">
							<ul class="t_m_menu_info">
								<li><a>좌석선택</a></li>
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
								<li><a>결제선택</a></li>
							</ul>
						</li>
					</ul>
				</div>
			</div>


			<div class="section">
				<!-- 날짜 및 회차선택 -->
                <div class="page-section pd375" style="border-top: 1px solid #e3e3e3;">
                	<div style="clear:both;">
			 			
						<ul class="calen_box_first">
							<!-- 캘린더 -->
							<li class="calendar2">
								<h2 class="dis-h5"><span class="line-h5"></span>날짜선택</h2>
								<div class="calendar2_inner" style="height:408px">
									<div id="datepicker" class="hasDatepicker"><div class="ui-datepicker-inline ui-datepicker ui-widget ui-widget-content ui-helper-clearfix ui-corner-all" style="display: block;"><div class="ui-datepicker-header ui-widget-header ui-helper-clearfix ui-corner-all"><a href="#" class="ion-android-arrow-dropleft-circle" data-handler="prev" data-event="click" title="Prev"><span class="skip">이전 달</span><span class="ui-icon ui-icon-circle-triangle-w"></span></a><a href="#" class="ion-android-arrow-dropright-circle" data-handler="next" data-event="click" title="Next"><span class="skip">다음 달</span><span class="ui-icon ui-icon-circle-triangle-e"></span></a><div class="ui-datepicker-title"><span class="ui-datepicker-year">2018</span>년&nbsp;<span class="ui-datepicker-month">4월</span></div></div><table class="ui-datepicker-calendar"><caption class="skip">날짜선택</caption><colgroup><col width="12.5%"><col width="15%"><col width="15%"><col width="15%"><col width="15%"><col width="15%"><col width="12.5%"></colgroup><thead><tr style="height:33px;"><th class="ui-datepicker-week-end"><span title="일요일">일</span></th><th><span title="월요일">월</span></th><th><span title="화요일">화</span></th><th><span title="수요일">수</span></th><th><span title="목요일">목</span></th><th><span title="금요일">금</span></th><th class="ui-datepicker-week-end"><span title="토요일">토</span></th></tr></thead><tbody><tr><td class=" ui-datepicker-week-end " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">1</a></td><td class=" " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">2</a></td><td class=" " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">3</a></td><td class=" " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">4</a></td><td class=" " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">5</a></td><td class=" " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">6</a></td><td class=" ui-datepicker-week-end " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">7</a></td></tr><tr><td class=" ui-datepicker-week-end " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">8</a></td><td class="  ui-datepicker-today" data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default ui-state-highlight" href="#">9</a></td><td class=" " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">10</a></td><td class=" " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">11</a></td><td class=" " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">12</a></td><td class=" " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">13</a></td><td class=" ui-datepicker-week-end " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">14</a></td></tr><tr><td class=" ui-datepicker-week-end " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">15</a></td><td class=" " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">16</a></td><td class=" " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">17</a></td><td class=" " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">18</a></td><td class=" " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">19</a></td><td class=" " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">20</a></td><td class=" ui-datepicker-week-end " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">21</a></td></tr><tr><td class=" ui-datepicker-week-end " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">22</a></td><td class=" " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">23</a></td><td class=" " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">24</a></td><td class=" ui-datepicker-days-cell-over eventday ui-datepicker-current-day" title="예매가능일" data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default ui-state-active ui-state-hover" href="#">25</a></td><td class=" " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">26</a></td><td class=" " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">27</a></td><td class=" ui-datepicker-week-end " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">28</a></td></tr><tr><td class=" ui-datepicker-week-end " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">29</a></td><td class=" " data-handler="selectDay" data-event="click" data-month="3" data-year="2018"><a class="ui-state-default" href="#">30</a></td><td class=" ui-datepicker-other-month ui-datepicker-unselectable ui-state-disabled">&nbsp;</td><td class=" ui-datepicker-other-month ui-datepicker-unselectable ui-state-disabled">&nbsp;</td><td class=" ui-datepicker-other-month ui-datepicker-unselectable ui-state-disabled">&nbsp;</td><td class=" ui-datepicker-other-month ui-datepicker-unselectable ui-state-disabled">&nbsp;</td><td class=" ui-datepicker-week-end ui-datepicker-other-month ui-datepicker-unselectable ui-state-disabled">&nbsp;</td></tr></tbody></table></div></div>
								</div>
								<p class="cal_"> ※ 인터넷과 모바일은 공연 전날 17시 마감되오니 이후에는 현장예매를 이용해주시기 바랍니다</p>
							</li>
							
							<!-- 회차(시간) 선택 -->
							<li class="now_list">
								<h2 class="dis-h5"><span class="line-h5"></span>회차(시간) 선택</h2>
								<div class="now_listed_inner">
									<table class="calendar_table3">
										<caption class="skip">회차(시간) 선택</caption>
										<colgroup>
											<col width="40%">
											<col width="30%">
											<col width="30%">
										</colgroup>
										
										<thead>
											<tr>
												<th scope="col">회차</th>
												<th scope="col" colspan="2" style="text-align:left;">등급/ 예매가능 매수</th>
											</tr>
										</thead>
										
										<tbody id="ListBox"><!-- 추가될 날짜 및 회차 목록 -->

	
	
	
	
	
	
	
	
	
		
			<tr>
				<td class="table3_bor_b_gray font_s_19">
					
						1회차(11:00)
					
					
				</td>
				<td class="table3_bor_b_gray edit_txt_align" style="text-overflow:ellipsis;overflow:hidden;white-space: nowrap;">
					
						
							사이드석 
							 / 7
							
								매
							
							<br>
						
					
						
							일반석 
							 / 33
							
								매
							
							<br>
						
					
				</td>
				<td class="table3_bor_b_gray">
					<a href="#" class="selC_on" onclick="seqSelect('20180425', '000001', '1100', '1회차', '001', '7');" alt="선택">
						선택
					</a>
				</td>
			</tr>
		
	
	

	
	
	
	
	
	
	
	
	
	



<script type="text/javascript">
	//선택버튼 구현
	$(".selC_on").click(function(){
		
		$('.selC_on').removeClass('selC_off');
		
		$(this).each(function(index,element){
			$(this).toggleClass('selC_off');
		});
	});
</script></tbody>
									</table>
								</div>
							</li>
						</ul>
					</div>
				</div>
				<!-- //날짜 및 회차선택 -->
				
				<div class="appl_btn" style="padding-top:10px;">
					<a href="#" class="btnpoint apply_btn" onclick="next();">다음</a>
				</div>
			</div>
		</div>
	</div>
	
	<!-- topBtn -->
	<a href="#top" class="top">top</a>
	<!-- //topBtn -->     


<!-- 복합전시관 18~19일 임시 무료 처리 시작 -->
	<script src="js/jquery.bpopup.min.js"></script>
	<script type="text/javascript">
		function fn_bPopup(no){
			$("#"+no).bPopup();

		}

		function fn_bPopup_close(no){
			$("#"+no).bPopup().close();
		}
	</script>

	<div id="10000455" class="pop_viewCon" style="width:840px;">
		<div class="inbox">
			
				<h4>[ 2018 ACC브런치콘서트 3회&lt;클론 강원래의 이야기 노래선물&gt; ] 유의 사항<span class="fn_right red" onclick="javascript:fn_bPopup_close('10000455');">X</span></h4>
				<dl class="tab_dl">
					<dt>1. 관람등급안내</dt>
					<dd>- 만 7세 이상  입장이 가능합니다.<br>
					- 생년월일이 확인가능한 증빙서류를 반드시 지참하셔야 하며 미확인 시 티켓의 유무와 상관없이 입장이 제한됩니다.<br>이와 관련하여 취소, 환불, 변경은 불가합니다.</dd>
					<dt>2. 티켓수령 안내</dt>
					<dd>- 예약 티켓 수령 및 현장구매는 공연시작 1시간 전부터 가능합니다.<br>
					- 할인 티켓의 경우 해당하는 증빙서류를 제시해야 하며 미지참 시 현장에서 차액 지불 후 수령 가능합니다.
					</dd><dt>3. 지연관객 안내</dt>
					<dd>- 본 공연은 공연 및 좌석의 특성상 공연 시작 후 입장이 제한될 수 있으니, 공연시작 10분전까지 반드시 입장하여 주시기 바랍니다.</dd>
					<dt>4. 기타안내</dt>
					<dd>- 공연 중 사전 협의되지 않은 사진촬영, 영상녹화, 음원 녹음은 불가합니다.<br>
					- 공연의 원작자, 제작사, 극장, 배우 분들과 모두 사전 협의한 내용이므로 협조 부탁드립니다.</dd>
				</dl>
			
		</div>
	</div>
	<div id="10000454" class="pop_viewCon" style="width:840px;">
		<div class="inbox">
			
				<h4>[ 2018 ACC브런치콘서트 3회&lt;클론 강원래의 이야기 노래선물&gt; ] 유의 사항<span class="fn_right red" onclick="javascript:fn_bPopup_close('10000454');">X</span></h4>
				<dl class="tab_dl">
					<dt>1. 관람등급안내</dt>
					<dd>- 만 7세 이상  입장이 가능합니다.<br>
					- 생년월일이 확인가능한 증빙서류를 반드시 지참하셔야 하며 미확인 시 티켓의 유무와 상관없이 입장이 제한됩니다.<br>이와 관련하여 취소, 환불, 변경은 불가합니다.</dd>
					<dt>2. 티켓수령 안내</dt>
					<dd>- 예약 티켓 수령 및 현장구매는 공연시작 1시간 전부터 가능합니다.<br>
					- 할인 티켓의 경우 해당하는 증빙서류를 제시해야 하며 미지참 시 현장에서 차액 지불 후 수령 가능합니다.
					</dd><dt>3. 지연관객 안내</dt>
					<dd>- 본 공연은 공연 및 좌석의 특성상 공연 시작 후 입장이 제한될 수 있으니, 공연시작 10분전까지 반드시 입장하여 주시기 바랍니다.</dd>
					<dt>4. 기타안내</dt>
					<dd>- 공연 중 사전 협의되지 않은 사진촬영, 영상녹화, 음원 녹음은 불가합니다.<br>
					- 공연의 원작자, 제작사, 극장, 배우 분들과 모두 사전 협의한 내용이므로 협조 부탁드립니다.</dd>
				</dl>
			
		</div>
	</div>
	<div id="10000468" class="pop_viewCon" style="width:840px;">
		<div class="inbox">
			
				<h4>[ 2018 ACC브런치콘서트 3회&lt;클론 강원래의 이야기 노래선물&gt; ] 유의 사항<span class="fn_right red" onclick="javascript:fn_bPopup_close('10000468');">X</span></h4>
				<dl class="tab_dl">
					<dt>1. 관람등급안내</dt>
					<dd>- 만 7세 이상  입장이 가능합니다.<br>
					- 생년월일이 확인가능한 증빙서류를 반드시 지참하셔야 하며 미확인 시 티켓의 유무와 상관없이 입장이 제한됩니다.<br>이와 관련하여 취소, 환불, 변경은 불가합니다.</dd>
					<dt>2. 티켓수령 안내</dt>
					<dd>- 예약 티켓 수령 및 현장구매는 공연시작 1시간 전부터 가능합니다.<br>
					- 할인 티켓의 경우 해당하는 증빙서류를 제시해야 하며 미지참 시 현장에서 차액 지불 후 수령 가능합니다.
					</dd><dt>3. 지연관객 안내</dt>
					<dd>- 본 공연은 공연 및 좌석의 특성상 공연 시작 후 입장이 제한될 수 있으니, 공연시작 10분전까지 반드시 입장하여 주시기 바랍니다.</dd>
					<dt>4. 기타안내</dt>
					<dd>- 공연 중 사전 협의되지 않은 사진촬영, 영상녹화, 음원 녹음은 불가합니다.<br>
					- 공연의 원작자, 제작사, 극장, 배우 분들과 모두 사전 협의한 내용이므로 협조 부탁드립니다.</dd>
				</dl>
			
		</div>
	</div>



	<div id="10000402" class="pop_viewCon" style="width:840px;">
		<div class="inbox">
			
				<h4>[ 2018 ACC브런치콘서트 3회&lt;클론 강원래의 이야기 노래선물&gt; ] 유의 사항<span class="fn_right red" onclick="javascript:fn_bPopup_close('10000402');">X</span></h4>
				<dl class="tab_dl">
					<dt>1. 관람등급안내</dt>
					<dd>- 만 12세 이상  입장이 가능합니다.<br>
					- 생년월일이 확인가능한 증빙서류를 반드시 지참하셔야 하며 미확인 시 티켓의 유무와 상관없이 입장이 제한됩니다.<br>이와 관련하여 취소, 환불, 변경은 불가합니다.</dd>
					<dt>2. 티켓수령 안내</dt>
					<dd>- 예약 티켓 수령 및 현장구매는 공연시작 1시간 전부터 가능합니다.<br>
					- 할인 티켓의 경우 해당하는 증빙서류를 제시해야 하며 미지참 시 현장에서 차액 지불 후 수령 가능합니다.
					</dd><dt>3. 지연관객 안내</dt>
					<dd>- 본 공연은 공연 및 좌석의 특성상 공연 시작 후 입장이 제한될 수 있으니, 공연시작 10분전까지 반드시 입장하여 주시기 바랍니다.</dd>
					<dt>4. 기타안내</dt>
					<dd>- 공연 중 사전 협의되지 않은 사진촬영, 영상녹화, 음원 녹음은 불가합니다.<br>
					- 공연의 원작자, 제작사, 극장, 배우 분들과 모두 사전 협의한 내용이므로 협조 부탁드립니다.</dd>
					<dd>- 본 공연은 1부 종료 후 인터미션 중 2부 공연을 위해 공간을 이동해야 합니다. 짧은 시간내에 입장을 완료하기 위해, 사전에 좌석을 확인하여 주시기 바랍니다.</dd>
				</dl>
			
		</div>
	</div>

	<div id="10000295x" class="pop_viewCon" style="width:540px;">
		<div class="inbox">
			
				<h4>[2018 ACC브런치콘서트 3회&lt;클론 강원래의 이야기 노래선물&gt; ]<span class="fn_right red" onclick="javascript:fn_bPopup_close('10000295x');">X</span></h4>
				<dl class="tab_dl">
					<dt>문화창조원 복합4관 [달의 이면]</dt>
					<dd>- 전시 오픈식 진행으로 당일(10/26) 복합전시 관람은 무료입니다.</dd>
				</dl>
			
		</div>
	</div>

	<div id="freePro" class="pop_viewCon" style="width:640px;">
		<div class="inbox">
			
				<h4>[설날 예매안내] <span class="fn_right red" onclick="javascript:fn_bPopup_close('freePro');">X</span></h4>
				<dl class="tab_dl">
					<dt>* 설날 당일(16일)은 무료입장입니다</dt>
					<dt>* 입장권은 현장에서 발권가능하며, 인터넷/모바일/콜센터 예매는 불가능합니다.</dt>
					<dt>* 무료입장권은 주차할인 및 면제가 적용되지 않습니다.</dt>
				</dl>
			
		</div>
	</div>
	<div id="freePro1" class="pop_viewCon" style="width:640px;">
		<div class="inbox">
			
				<h4>[감각과 지식사이 Otherly Space/Knowledge] <span class="fn_right red" onclick="javascript:fn_bPopup_close('freePro1');">X</span></h4>
				<dl class="tab_dl">
					<dt>* 전시 오픈식 진행으로 당일(3/2) 문화창조원 전시관람은 무료입니다.</dt>
				</dl>
			
		</div>
	</div>
<style>
.pop_viewCon { display:none; width:300px; }
.pop_viewCon .inbox {padding:10px;  margin:50px; text-align:left; background:#fff; border :5px solid #3571B5; }
.pop_viewCon h4 {background:#6eabd7; color:#fff; font-size:14px; font-weight:bold; padding:8px 15px 6px 15px;}
.pop_viewCon .etc{padding-top:10px;  margin:30px; text-align:center; background:#fff;}

.tab_dl dt{ color: #505050; font-size: 14px; margin-top: 5px;margin-bottom: 3px;font-weight: bold;}
.tab_dl dd{ color: graytext; margin: 0;}
.fn_right { float : right; font-size : 30px; margin-top:-10px;cursor:pointer}
</style>
<!-- 복합전시관 18~19일 임시 무료 처리 끝 -->

<div id="ui-datepicker-div" class="ui-datepicker ui-widget ui-widget-content ui-helper-clearfix ui-corner-all"></div></body></html>


<script>


var GlobalData_today = '20180417';
var GlobalData_GENRE_CD = '000001';
var MRCOUPON_PROGRAM_GRADE_LIST;
var PRICE_LIST;
var GRADEPRICE_LIST;
var GRADE_PRICE_LIST2;
var JSON_GRDAEPRICE;
var JSON_GRDAEPRICE2;

var ADVTICKET_NO_LIST;
var QUOTA_LIST;
var SEAT_INFO;

var max_booking_count = 8;

var T_Aval_point = 0;
var T_Acum_point = 0;
var T_Min_use_type = 0;
var T_Min_use_amt = 0;
var T_Max_use_type = 0;
var T_Max_use_amt = 0;
var T_Use_unit = 0;

function onstart() {
	
	// 배송선택까지는 GRADEPRICE_LIST를 사용하다가 PRICE_LIST를 사용하도록 변경되었음
	PRICE_LIST = JSON.parse('null');
	GRADEPRICE_LIST = JSON.parse('null');
	ADVTICKET_NO_LIST = JSON.parse('[{"PRICE":"","SEAT_GRADE_CD":"","ADVTICKET_NO":"","PKG_TYPE":"","LMT_CNT_FROM":"","PRICE_TYPE_CD":"","LMT_CNT_TO":""},{"PRICE":"","SEAT_GRADE_CD":"","ADVTICKET_NO":"","PKG_TYPE":"","LMT_CNT_FROM":"","PRICE_TYPE_CD":"","LMT_CNT_TO":""},{"PRICE":"","SEAT_GRADE_CD":"","ADVTICKET_NO":"","PKG_TYPE":"","LMT_CNT_FROM":"","PRICE_TYPE_CD":"","LMT_CNT_TO":""},{"PRICE":"","SEAT_GRADE_CD":"","ADVTICKET_NO":"","PKG_TYPE":"","LMT_CNT_FROM":"","PRICE_TYPE_CD":"","LMT_CNT_TO":""},{"PRICE":"","SEAT_GRADE_CD":"","ADVTICKET_NO":"","PKG_TYPE":"","LMT_CNT_FROM":"","PRICE_TYPE_CD":"","LMT_CNT_TO":""},{"PRICE":"","SEAT_GRADE_CD":"","ADVTICKET_NO":"","PKG_TYPE":"","LMT_CNT_FROM":"","PRICE_TYPE_CD":"","LMT_CNT_TO":""},{"PRICE":"","SEAT_GRADE_CD":"","ADVTICKET_NO":"","PKG_TYPE":"","LMT_CNT_FROM":"","PRICE_TYPE_CD":"","LMT_CNT_TO":""},{"PRICE":"","SEAT_GRADE_CD":"","ADVTICKET_NO":"","PKG_TYPE":"","LMT_CNT_FROM":"","PRICE_TYPE_CD":"","LMT_CNT_TO":""},{"PRICE":"","SEAT_GRADE_CD":"","ADVTICKET_NO":"","PKG_TYPE":"","LMT_CNT_FROM":"","PRICE_TYPE_CD":"","LMT_CNT_TO":""},{"PRICE":"","SEAT_GRADE_CD":"","ADVTICKET_NO":"","PKG_TYPE":"","LMT_CNT_FROM":"","PRICE_TYPE_CD":"","LMT_CNT_TO":""}]');
	// QUOTA_LIST = JSON.parse('');
	SEAT_INFO = JSON.parse('null');
	
	// 권종 위치 변경에 따른 변수 선언
	GRADE_PRICE_LIST2 = JSON.parse('[{"SEAT_GRADE_CD":"08","SEAT_GRADE_NAME":"자유석","PRICE_TYPE_NAME":"일반","PRICE_TYPE_CD":"000001","PRICE":20000,"CARDBIN_FLAG":"N","CARD_FLAG":"N","DLVR_TYPE":"0","USENOT_PAYMENT_TYPE":"000000","ORDER_NBR":301,"LMT_CNT_FROM":0,"LMT_CNT_TO":0,"REF_MAX_CNT":0,"SEAT_GRADE_ORDER":8,"CHOICE":0},{"SEAT_GRADE_CD":"08","SEAT_GRADE_NAME":"자유석","PRICE_TYPE_NAME":"경로우대(만65세이상)(50%)","PRICE_TYPE_CD":"004628","PRICE":10000,"CARDBIN_FLAG":"N","CARD_FLAG":"N","DLVR_TYPE":"0","USENOT_PAYMENT_TYPE":"000000","ORDER_NBR":302,"LMT_CNT_FROM":0,"LMT_CNT_TO":0,"REF_MAX_CNT":0,"SEAT_GRADE_ORDER":8,"CHOICE":0},{"SEAT_GRADE_CD":"08","SEAT_GRADE_NAME":"자유석","PRICE_TYPE_NAME":"장애인(50%)","PRICE_TYPE_CD":"000002","PRICE":10000,"CARDBIN_FLAG":"N","CARD_FLAG":"N","DLVR_TYPE":"0","USENOT_PAYMENT_TYPE":"000000","ORDER_NBR":303,"LMT_CNT_FROM":0,"LMT_CNT_TO":0,"REF_MAX_CNT":0,"SEAT_GRADE_ORDER":8,"CHOICE":0},{"SEAT_GRADE_CD":"08","SEAT_GRADE_NAME":"자유석","PRICE_TYPE_NAME":"국가유공자(50%)","PRICE_TYPE_CD":"000049","PRICE":10000,"CARDBIN_FLAG":"N","CARD_FLAG":"N","DLVR_TYPE":"0","USENOT_PAYMENT_TYPE":"000000","ORDER_NBR":304,"LMT_CNT_FROM":0,"LMT_CNT_TO":0,"REF_MAX_CNT":0,"SEAT_GRADE_ORDER":8,"CHOICE":0},{"SEAT_GRADE_CD":"08","SEAT_GRADE_NAME":"자유석","PRICE_TYPE_NAME":"문화누리카드(50%)","PRICE_TYPE_CD":"504701","PRICE":10000,"CARDBIN_FLAG":"Y","CARD_FLAG":"Y","DLVR_TYPE":"0","USENOT_PAYMENT_TYPE":"000000","ORDER_NBR":307,"LMT_CNT_FROM":0,"LMT_CNT_TO":0,"REF_MAX_CNT":0,"SEAT_GRADE_ORDER":8,"CHOICE":0},{"SEAT_GRADE_CD":"08","SEAT_GRADE_NAME":"자유석","PRICE_TYPE_NAME":"ACC릴레이티켓할인(20%)","PRICE_TYPE_CD":"505246","PRICE":16000,"CARDBIN_FLAG":"N","CARD_FLAG":"N","DLVR_TYPE":"0","USENOT_PAYMENT_TYPE":"000000","ORDER_NBR":308,"LMT_CNT_FROM":0,"LMT_CNT_TO":0,"REF_MAX_CNT":0,"SEAT_GRADE_ORDER":8,"CHOICE":0},{"SEAT_GRADE_CD":"08","SEAT_GRADE_NAME":"자유석","PRICE_TYPE_NAME":"예술인패스(50%)","PRICE_TYPE_CD":"505332","PRICE":10000,"CARDBIN_FLAG":"N","CARD_FLAG":"N","DLVR_TYPE":"0","USENOT_PAYMENT_TYPE":"000000","ORDER_NBR":319,"LMT_CNT_FROM":0,"LMT_CNT_TO":0,"REF_MAX_CNT":0,"SEAT_GRADE_ORDER":8,"CHOICE":0},{"SEAT_GRADE_CD":"08","SEAT_GRADE_NAME":"자유석","PRICE_TYPE_NAME":"문화패스(50%)","PRICE_TYPE_CD":"505333","PRICE":10000,"CARDBIN_FLAG":"N","CARD_FLAG":"N","DLVR_TYPE":"0","USENOT_PAYMENT_TYPE":"000000","ORDER_NBR":320,"LMT_CNT_FROM":0,"LMT_CNT_TO":0,"REF_MAX_CNT":0,"SEAT_GRADE_ORDER":8,"CHOICE":0}]');
	
	// 좌석 선택 내역
	JSON_GRDAEPRICE2 = JSON.parse('[{"SEAT_GRADE_CD":"08","SEAT_GRADE_NAME":"자유석","PRICE_TYPE_NAME":"일반","PRICE_TYPE_CD":"000001","PRICE":20000.0,"CARDBIN_FLAG":"N","CARD_FLAG":"N","DLVR_TYPE":"0","USENOT_PAYMENT_TYPE":"000000","ORDER_NBR":301.0,"LMT_CNT_FROM":0.0,"LMT_CNT_TO":0.0,"REF_MAX_CNT":0.0,"SEAT_GRADE_ORDER":8.0,"CHOICE":4.0},{"SEAT_GRADE_CD":"08","SEAT_GRADE_NAME":"자유석","PRICE_TYPE_NAME":"경로우대(만65세이상)(50 )","PRICE_TYPE_CD":"004628","PRICE":10000.0,"CARDBIN_FLAG":"N","CARD_FLAG":"N","DLVR_TYPE":"0","USENOT_PAYMENT_TYPE":"000000","ORDER_NBR":302.0,"LMT_CNT_FROM":0.0,"LMT_CNT_TO":0.0,"REF_MAX_CNT":0.0,"SEAT_GRADE_ORDER":8.0,"CHOICE":4.0},{"SEAT_GRADE_CD":"08","SEAT_GRADE_NAME":"자유석","PRICE_TYPE_NAME":"장애인(50 )","PRICE_TYPE_CD":"000002","PRICE":10000.0,"CARDBIN_FLAG":"N","CARD_FLAG":"N","DLVR_TYPE":"0","USENOT_PAYMENT_TYPE":"000000","ORDER_NBR":303.0,"LMT_CNT_FROM":0.0,"LMT_CNT_TO":0.0,"REF_MAX_CNT":0.0,"SEAT_GRADE_ORDER":8.0,"CHOICE":4.0},{"SEAT_GRADE_CD":"08","SEAT_GRADE_NAME":"자유석","PRICE_TYPE_NAME":"국가유공자(50 )","PRICE_TYPE_CD":"000049","PRICE":10000.0,"CARDBIN_FLAG":"N","CARD_FLAG":"N","DLVR_TYPE":"0","USENOT_PAYMENT_TYPE":"000000","ORDER_NBR":304.0,"LMT_CNT_FROM":0.0,"LMT_CNT_TO":0.0,"REF_MAX_CNT":0.0,"SEAT_GRADE_ORDER":8.0,"CHOICE":4.0},{"SEAT_GRADE_CD":"08","SEAT_GRADE_NAME":"자유석","PRICE_TYPE_NAME":"문화누리카드(50 )","PRICE_TYPE_CD":"504701","PRICE":10000.0,"CARDBIN_FLAG":"Y","CARD_FLAG":"Y","DLVR_TYPE":"0","USENOT_PAYMENT_TYPE":"000000","ORDER_NBR":307.0,"LMT_CNT_FROM":0.0,"LMT_CNT_TO":0.0,"REF_MAX_CNT":0.0,"SEAT_GRADE_ORDER":8.0,"CHOICE":4.0},{"SEAT_GRADE_CD":"08","SEAT_GRADE_NAME":"자유석","PRICE_TYPE_NAME":"ACC릴레이티켓할인(20 )","PRICE_TYPE_CD":"505246","PRICE":16000.0,"CARDBIN_FLAG":"N","CARD_FLAG":"N","DLVR_TYPE":"0","USENOT_PAYMENT_TYPE":"000000","ORDER_NBR":308.0,"LMT_CNT_FROM":0.0,"LMT_CNT_TO":0.0,"REF_MAX_CNT":0.0,"SEAT_GRADE_ORDER":8.0,"CHOICE":4.0},{"SEAT_GRADE_CD":"08","SEAT_GRADE_NAME":"자유석","PRICE_TYPE_NAME":"예술인패스(50 )","PRICE_TYPE_CD":"505332","PRICE":10000.0,"CARDBIN_FLAG":"N","CARD_FLAG":"N","DLVR_TYPE":"0","USENOT_PAYMENT_TYPE":"000000","ORDER_NBR":319.0,"LMT_CNT_FROM":0.0,"LMT_CNT_TO":0.0,"REF_MAX_CNT":0.0,"SEAT_GRADE_ORDER":8.0,"CHOICE":4.0},{"SEAT_GRADE_CD":"08","SEAT_GRADE_NAME":"자유석","PRICE_TYPE_NAME":"문화패스(50 )","PRICE_TYPE_CD":"505333","PRICE":10000.0,"CARDBIN_FLAG":"N","CARD_FLAG":"N","DLVR_TYPE":"0","USENOT_PAYMENT_TYPE":"000000","ORDER_NBR":320.0,"LMT_CNT_FROM":0.0,"LMT_CNT_TO":0.0,"REF_MAX_CNT":0.0,"SEAT_GRADE_ORDER":8.0,"CHOICE":4.0}]');

	// 쿠폰
	MRCOUPON_PROGRAM_GRADE_LIST = JSON.parse( '[]' );
	
	// 최종결제금약
	last_amt();
}


// 해당권종의 갯수 조회
function getTotalCount() {
	var totalcnt = 0;

	for (var i = 0; i < GRADE_PRICE_LIST2.length; i++) {
		var price_one = GRADE_PRICE_LIST2[i];
		totalcnt += parseInt(price_one.CHOICE, 10);
	}

	return totalcnt;
}


// 해당권종의 갯수 조회
function getTotalCount_Price(PriceTypeCd) {
	var totalcnt = 0;

	for (var i = 0; i < PRICE_LIST.length; i++) {
		var price_one = PRICE_LIST[i];

		if (price_one.PRICE_TYPE_CD == PriceTypeCd)
			totalcnt += parseInt(price_one.CHOICE, 10);
	}

	return totalcnt;
}


function getTotalCount_PriceSeatGrade(seat_grade_cd) {
	var totalcnt = 0;

	for (var i = 0; i < PRICE_LIST.length; i++) {
		var price_one = PRICE_LIST[i];

		if (price_one.SEAT_GRADE_CD == seat_grade_cd && price_one.PRICE_TYPE_CD != '500001')
			totalcnt += parseInt(price_one.CHOICE, 10);
	}

	return totalcnt;
}

function updatePriceList(addCnt, price_type_cd, seat_grade_cd) {

	var findflag = false;

	if (seat_grade_cd != '' && seat_grade_cd.length != 0) {

		for (var i = 0; i < PRICE_LIST.length; i++) {

			var price_one = PRICE_LIST[i];

			if (price_one.SEAT_GRADE_CD == seat_grade_cd &&
				price_one.PRICE_TYPE_CD == price_type_cd) {

				price_one.CHOICE = parseInt(price_one.CHOICE, 10) + addCnt;
				findflag = true;
				break;
			}
		}
	}

	return findflag;
}

function fn_couponAmtInit(){
	$('#COUPONINFOARR').val( "" );
	$('#COUPON_AMT').val( "" );
	$('#COUPON_NO').val( "" );
	$('#COUPON_PAYMENT_TYPE').val( "" );
	$('#COUPON_NAME').val( "" );

	var add_sale = -Number(getTotalCount_AdvAmt()) - fn_getPointAmt() - fn_getcouponAmt();

	$('#add_sale').empty();
	$('#add_sale').append(CommaNumber( add_sale ));

		$('#Last_ticket_payment').empty();
	$('#Last_ticket_payment').append(CommaNumber( fn_getTot_payment()-(fn_getPointAmt() + fn_getcouponAmt())) );

	$('#LAST_TICKET_PAYMENT').val( fn_getTot_Amt() - Number(getTotalCount_AdvAmt()) - fn_getPointAmt() - fn_getcouponAmt() );

}

function fn_getcouponAmt(){
	return Number(UnComma($('#COUPON_AMT').val()));
}

function fn_getPointAmt(){
	return Number(UnComma($('#c2s_point_use_amt').val()));
}

function fn_getTot_payment(){
	return Number(UnComma($('#Tot_payment').text()));
}

function fn_getTot_Amt(){
	return Number(UnComma($('#TOT_TKT_TOT_AMT').val()));
}

// 좌석 등급 선택시 쿠폰 금액 계산
function fn_couponClick(couponInfo){
	
	// 쿠폰 선택 시 포인트 초기화
	initPoint();
	
		couponInfoArr = couponInfo.split(":");

	// MR_COUPON_NBR : DISCOUNT_TYPE : DISCOUNT_AMT : USE_TICKET_CNT : MIN_CAN_AMT : MAX_CAN_AMT : MAX_LMT_AMT : MR_COUPON_NAME
	// 쿠폰번호 : 할인타입 : 할인금액(율): 할인매수 : 최소: 최대: 최대할인: 쿠폰이름
	var MR_COUPON_NBR   = couponInfoArr[0];
	var DISCOUNT_TYPE   = couponInfoArr[1];
	var DISCOUNT_AMT    = couponInfoArr[2];
	var USE_TICKET_CNT  = couponInfoArr[3];
	var MIN_CAN_AMT     = couponInfoArr[4];
	var MAX_CAN_AMT     = couponInfoArr[5];
	var MAX_LMT_AMT     = couponInfoArr[6];
	var MR_COUPON_NAME	= couponInfoArr[7];
	
	var iCnt = 0;
	var iSeatTot = 0;
	iCnt = getTotalCount();
	iSeatTot = $('#SEAT_COUNT').val();
	
	if ( iCnt != iSeatTot ){
		fn_couponFlag(false);
	    alert('매수를 선택 해 주세요.');
	    return;
	}
	
	// 금액 계산
	fn_coupon_calc(MR_COUPON_NBR, DISCOUNT_TYPE, DISCOUNT_AMT, USE_TICKET_CNT, MIN_CAN_AMT, MAX_CAN_AMT, MAX_LMT_AMT, MR_COUPON_NAME);
}

// 좌석 등급 선택시 쿠폰 금액 계산
function fn_couponUnClick(){
	var iCnt = 0;
	var iSeatTot = 0;
	iCnt = getTotalCount();
	iSeatTot = $('#SEAT_COUNT').val();

	fn_couponAmtInit();
}

function fn_couponFlag( flag ){
	$('input:radio[name=coupon_sel]').prop('checked',flag); 
}

// 총 금액
function get_tot_amt(){
	var sum = 0;

	for(var j=0;j < GRADE_PRICE_LIST2.length;j++){
		var grade = GRADE_PRICE_LIST2[j];

		var idxPrice = grade.PRICE;
		var ticketCnt = grade.CHOICE;
		sum =  sum + Number(ticketCnt)*Number(idxPrice);
	}

	return sum;
}


function fn_coupon_calc(MR_COUPON_NBR, DISCOUNT_TYPE, DISCOUNT_AMT, USE_TICKET_CNT, MIN_CAN_AMT, MAX_CAN_AMT, MAX_LMT_AMT, MR_COUPON_NAME)
{
	var normal_ticket_cnt = 0;
	var normal_ticket_sum = 0;
	var calc_couponAmt = 0;

	for(var i=0;i < GRADE_PRICE_LIST2.length;i++){
		var gp = GRADE_PRICE_LIST2[i];

		// alert("gp.SEAT_GRADE_CD:"+ gp.SEAT_GRADE_CD + ", gp.PRICE_TYPE_CD:"+ gp.PRICE_TYPE_CD +", gp.CHOICE:"+ gp.CHOICE );
		if( (gp.PRICE_TYPE_CD == '000001') && (Number(gp.CHOICE) > 0) ){
			normal_ticket_sum += Number(gp.CHOICE) * Number(gp.PRICE);
			normal_ticket_cnt += Number(gp.CHOICE);
		}
	}
	
	if ( normal_ticket_sum == 0){
		fn_couponFlag(false);
		alert( '일반인 경우에만 쿠폰혜택이 가능합니다. 그 외에 기본할인 선택 시에는 쿠폰혜택이 불가합니다.');
		return false;
	}

	if ( DISCOUNT_TYPE == '1' ){
		calc_couponAmt = normal_ticket_cnt * Number(DISCOUNT_AMT);
	} else if ( DISCOUNT_TYPE == '2' ){
		calc_couponAmt = normal_ticket_sum * Number(DISCOUNT_AMT) * 0.01;
	} else if ( DISCOUNT_TYPE == '3' ){
		calc_couponAmt = normal_ticket_sum;
	} else if ( DISCOUNT_TYPE == '4' ){
		calc_couponAmt = Number(DISCOUNT_AMT);
	}

	var total_amt = get_tot_amt();

	if ( MIN_CAN_AMT != 0 && MIN_CAN_AMT > total_amt ){
		alert('티켓금액이 최소 ' + CommaNumber(MIN_CAN_AMT) + '원 이상인 경우에만 사용 가능합니다.');
		fn_couponFlag(false);
		return false;
	}

	if ( MAX_CAN_AMT != 0 && MAX_CAN_AMT < total_amt ){
		alert('티켓금액이 최대 ' + CommaNumber(MAX_CAN_AMT) + '원 이하인 경우에만 사용 가능합니다.');
		fn_couponFlag(false);
		return false;
	}

	if ( MAX_LMT_AMT != 0 && MAX_LMT_AMT < calc_couponAmt ){
		alert( "쿠폰 최대 할인 적용 금액은 " + CommaNumber(MAX_LMT_AMT) + " 이하 까지 가능 합니다.");
		fn_couponFlag(false);
		return false;
	}


	$('#COUPONINFOARR').val( couponInfoArr );
	$('#COUPON_AMT').val( calc_couponAmt );
	$('#COUPON_NO').val( MR_COUPON_NBR );
	$('#COUPON_PAYMENT_TYPE').val( "000301" );
	$('#COUPON_NAME').val( MR_COUPON_NAME );

	var add_sale = -Number(getTotalCount_AdvAmt()) - fn_getPointAmt() - fn_getcouponAmt();

		$('#add_sale').empty();
	$('#add_sale').append(CommaNumber( add_sale ));

		$('#Last_ticket_payment').empty();
	$('#Last_ticket_payment').append(CommaNumber( fn_getTot_payment()-(fn_getPointAmt() + fn_getcouponAmt())) );

	$('#LAST_TICKET_PAYMENT').val( fn_getTot_Amt() - Number(getTotalCount_AdvAmt()) - fn_getPointAmt() - fn_getcouponAmt() );
}



// 쿠폰 추가
function add_couponticket() {

	var frm = document.frmDisPay;

	var addCouponNumber = document.getElementById('ADD_COUPON_NUMBER').value;

	if (addCouponNumber.length < 20) {

		alert('쿠폰번호 20자리를 입력해 주세요.');
		return;
	}

	if (Exist_CouponNumber()) {

		alert('이미 등록되어 있는 쿠폰 번호 입니다.');
		return;
	}

	var param = 'ADD_COUPON_NUMBER=' + addCouponNumber;

	$.ajax({
		type : 'post',
		url : 'booking_dis_pay_coupon_add.do',
		data : param,
		dataType : 'html',
		success : function(html) {

			if (html.length > 100) {
				removeNode();
				$(html).appendTo('#reserv_coupon_list');
				nodeCount();
			}
			else {

				alert(html.trim());
			}
		}
	});
}

function Exist_CouponNumber() {

	var new_no = document.getElementById('ADD_COUPON_NUMBER').value;
	var exist_no = document.getElementById(new_no);

	if (exist_no == '' || exist_no == null)
		return false;
	else
		return true;
}

function removeNode() {

	var couponlists = document.getElementById('reserv_coupon_list');
	couponlists.innerHTML = '';
}

function nodeCount() {

	var reserv_coupon_list = document.getElementById('reserv_coupon_list');
	var children = reserv_coupon_list.childNodes;
	var count = 0;

	for (var i = 0; i < children.length; i++) {

		if ('LI' == children[i].nodeName)
			count++;
	}

	// 사용안함 라디오 버튼은 기본 1개 존재하므로 1개를 빼야 함.
	if (count > 0)
		count--;

	var CouponListCount = document.getElementById('COUPON_LIST_COUNT');
	CouponListCount.innerHTML = count;
}

function pause(numberMillis) {

	var now = new Date();
	var exitTime = now.getTime() + numberMillis;

	while (true) {

		now = new Date();

		if (now.getTime() > exitTime)
	 		return;
	}
}

jv_flag = false;



// 선택한 예매권 금액 계산
function getTotalPrice_AdvPrice() {

	var price = 0;

	for (var i = 0; i < ADVTICKET_NO_LIST.length; i++) {

		var advticket_one = ADVTICKET_NO_LIST[i];

		if (advticket_one.ADVTICKET_NO.length != 0) {

			for (var k = 0; k < PRICE_LIST.length; k++) {

				var price_one = PRICE_LIST[k];

				if ((advticket_one.SEAT_GRADE_CD == price_one.SEAT_GRADE_CD) &&
					(price_one.PRICE_TYPE_CD == '000001')) {

					price += parseInt(price_one.PRICE, 10);
				}
			}
		}
	}

	return price;
}

// 선택된 예매권 총 금액
function getTotalCount_AdvAmt() {

	var totalamt = 0;

	for (var i = 0; i < ADVTICKET_NO_LIST.length; i++) {

		var advticket_one = ADVTICKET_NO_LIST[i];

		if (advticket_one.ADVTICKET_NO.length != 0)
			totalamt += parseInt(advticket_one.PRICE, 10);
	}

	return totalamt;
}

// 등급 코드와 갯수
function grade_cnt(){
	var grade = new Array();

	for(var i=0;i < PRICE_LIST.length;i++){
		var grade_cd = PRICE_LIST[i];
		grade[i] = grade_cd.ROW_GRADE_CD;
	}

	return grade;
}

// 등급과 권종에 따른 가격 담기
function Amount(seat_cd,price_type){
	var result=0;

	for(var i=0;i < GRADE_PRICE_LIST2.length;i++){
		var grade = GRADE_PRICE_LIST2[i];

		// 권종에 따라 수량 입력
		if(grade.SEAT_GRADE_CD == seat_cd){
			if(grade.PRICE_TYPE_CD == price_type){
				result = grade.PRICE;
			}
		}
	}
	return result;
}

// 권종 타입 배열에 담기
function price_type(seat_cd){
	var j=0;
	var type = new Array();

	for(var i=0;i < GRADE_PRICE_LIST2.length;i++){
		var grade = GRADE_PRICE_LIST2[i];
		if(grade.SEAT_GRADE_CD == seat_cd){
			type[j] = grade.PRICE_TYPE_CD;
			j++;
		}
	}

	return type;
}

// 매수 클리어
function seat_clear(id,name,price_type,cnt){
	document.getElementById(id).options.selectedIndex = '0';
	var obj ={
			value : '0',
			name  : name,
			id    : id
	}
	grade_choice(obj,price_type,cnt);
}

// 권종 갯수
function grade_choice(obj,price_type,cnt){

	// 수량변경 이벤트 발생하면  무조건 쿠폰 선택  초기화 한다.
	fn_couponFlag(false);

	// 수량 초과시 초기화
	if(!buy_count(obj,cnt)){
		document.getElementById(obj.id).options.selectedIndex = '0';
		return;
	}

	for(var i=0;i < GRADE_PRICE_LIST2.length;i++){
		var grade = GRADE_PRICE_LIST2[i];

		// 권종에 따라 수량 입력
		if(grade.SEAT_GRADE_CD == obj.name){
			if(grade.PRICE_TYPE_CD == price_type){
				grade.CHOICE = parseInt(obj.value);
			}
		}
	}

	$('#CNT').val(obj.value);
	tot_amt();
}


// 구매 수량 계산
function buy_count(obj,cnt){
	var choice = $('#buy_cnt_'+obj.name).text();
	var select_cnt = document.getElementsByName(obj.name);
	var bool = false;
	var tot = cnt;
	var sum =0;
	var type = new Array();
	type = price_type(obj.name);

	// 각 권종별로 수량 체크 기존 권종별로 좌석을 가져 올때 쓰였음
	for(var i= 0;i < select_cnt.length;i++){
		var idx = document.getElementById(obj.name+type[i]).options.selectedIndex;
		var idx_cnt = Number(document.getElementById(obj.name+type[i]).options[idx].value);
		sum = sum + idx_cnt;
	}

	if((tot-sum) < 0){
		alert('구매 수량을 초과 하였습니다.');
		return bool;
	}else{
		$('#buy_cnt_'+obj.name).empty();
		$('#buy_cnt_'+obj.name).append(sum);
		bool = true;
		return bool;
	}
}

// 총 금액
function tot_amt(){
	var sum = 0;

	for(var j=0;j < GRADE_PRICE_LIST2.length;j++){
		var grade = GRADE_PRICE_LIST2[j];

		var idxPrice = grade.PRICE;
		var ticketCnt = grade.CHOICE;
		sum =  sum + Number(ticketCnt)*Number(idxPrice);
	}

	$('#Tot_payment').empty();
	$('#Tot_payment').append(CommaNumber(sum));

	// 최종결제금액
	last_amt();
}

// 최종결제금액
function last_amt(){
	var frm = document.frmDisPay;
	var sum = UnComma($('#Tot_payment').text());
	var last_sum = 0;
	var commission = Number('0');
	var delivery = Number('');
	var add_sale = 0;
	var pay_sum = 0;
	var point = 0;

	if('false'){
		if($('#c2s_point_use_amt').val() == undefined){
			point = 0;
		}else{
			point = $('#c2s_point_use_amt').val();
		}
	}

	// 추가 할인 합계
	if((Number(getTotalCount_AdvAmt()) + Number($('#COUPON_AMT').val()) + Number(point)) > 0){
		add_sale = -Number(getTotalCount_AdvAmt()) - fn_getPointAmt() - fn_getcouponAmt();
	}

	// 티켓 금액 + 수수료 + 배송비
	pay_sum = Number(sum)+commission+delivery + Number(getTotalCount_AdvAmt()) ;
	last_sum = pay_sum + Number(add_sale);

	// 티켓 금액 == 할인 합계 체크
	if(!CheckedPayment(sum,add_sale,pay_sum,point,commission,delivery,last_sum))
	{
		return last_amt();
	}

	// 사용한 예매권 수량
	$('#adv_cnt').empty();
	$('#adv_cnt').append(getTotalCount_Adv());

	// 추가 할인 금액
	$('#add_sale').empty();
	$('#add_sale').append(CommaNumber(add_sale));

	// 최종결제금액
	$('#Last_ticket_payment').empty();
	$('#Last_ticket_payment').append(CommaNumber(last_sum));
}

function CheckedPayment(sum,add_sale,pay_sum,point,commission,delivery,last_sum)
{
	var frm = document.frmDisPay;

	if(Number(sum) < (-Number(add_sale)))
	{

		alert('추가할인 수단이 총 티켓 금액을 초과 하셨습니다.');

		// 사용한 예매권 수량
		$('#adv_cnt').empty();
		$('#adv_cnt').append('0');

		// 쿠폰할인 초기화
		$('#Tot_coupon').empty();
		$('#Tot_coupon').append('0');
		$('#COUPON_AMT').val('0');
		$('input:radio[name=coupon_sel]').prop('checked',false); 
		

		// 포인트 초기화
		$('#Tot_point_sub').empty();
		$('#Tot_point_sub').append('0');
		$('#c2s_point_use_amt').val('0');
		$('#pop_c2s_point_use_amt').val('0');
		$('#chkboxPointAllUsed').prop('checked',false);

		// 추가 할인 금액
		$('#add_sale').empty();
		$('#add_sale').append('0');

		return;
	}
	else
	{
		frm.TOT_TKT_TOT_AMT.value = sum;
		frm.TOT_TRAN_AMT.value = pay_sum;
		frm.TOT_POINT.value = point;
		frm.TOT_COMMISSION.value = commission;
		frm.TOT_DELIVERY.value = delivery;
		frm.LAST_TICKET_PAYMENT.value = last_sum;

		return true;
	}
}

// 권종 전체 수량 확인
function grade_num(){
	var sum =0;
	var grade_cd = grade_cnt();

	for(var i=0;i < grade_cd.length;i++){
		var type = price_type(grade_cd[i]);

		for(var j=0;j < type.length;j++){
			var idx = document.getElementById(grade_cd[i]+type[j]).options.selectedIndex;
			var idx_cnt = Number(document.getElementById(grade_cd[i]+type[j]).options[idx].value);

			sum = sum + idx_cnt;
		}
	}

	return sum;
}

// 권종 check
function grade_check(){
	var tot_amt = Number($('#Tot_payment').text());
	var sum = Number('4');
	var grade_cnt = Number(grade_num());
	var bool = true;
	var zero = 'false';

	if(zero !='true')
	{
		if(tot_amt <= 0){
			alert('권종을 먼저 선택해 주세요.');
			bool = false;
			return bool;
		}else if(sum != grade_cnt){
			alert('권종을 먼저 선택해 주세요.');
			bool = false;
			return bool;
		}
	}
	return bool;
}


// 예매권 권종 수량 확인(예매권은 무조건 일반권종으로)
function reserve_grade(seat_cd){
	var sum =0;
	var grade_cd = grade_cnt();
	var type = price_type(seat_cd);
	var zero = 'false';

	if(zero !='true')
	{
		for(var j=0;j < type.length;j++){
			if(type[j] == '000001'){
				var idx = document.getElementById(seat_cd+type[j]).options.selectedIndex;
				var idx_cnt = Number(document.getElementById(seat_cd+type[j]).options[idx].value);

				sum = sum + idx_cnt;
			}
		}
	}
	else
	{
		for(var j=0;j < type.length;j++){
			if(type[j] == '000001' || type[j] == '500001'){
				var idx = document.getElementById(seat_cd+type[j]).options.selectedIndex;
				var idx_cnt = Number(document.getElementById(seat_cd+type[j]).options[idx].value);

				sum = sum + idx_cnt;
			}
		}
	}
	return sum;
}

// 예매권 권종 체크 확인(예매권은 무조건 일반권종으로)
function ReserveCheck(seat_cd){
	var j=0;
	var type = new Array();

	for(var i=0;i < GRADE_PRICE_LIST2.length;i++){
		var grade = GRADE_PRICE_LIST2[i];
		if(grade.SEAT_GRADE_CD == seat_cd){
			if(grade.CHOICE == '0'){
				return false;
			}else{
				return true;
			}
			j++;
		}
	}
}

//꼼마찍기
function CommaNumber(num){
	var result = num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
	return result;
}

// 꼼마빼기
function UnComma(num){
	var result = num.toString().replace(/[^\d]+/g,'');

	return result;
}

// 예매권 등록 / 사용 팝업 표시
function booking_dis_pay_advticket() {
	var frm = document.frmDisPay;

	// 사용할 예매권
	var enterUseAdvticket = '';
	for (var i = 0; i < ADVTICKET_NO_LIST.length; i++) {
		var advticket_one = ADVTICKET_NO_LIST[i];
		if (advticket_one.ADVTICKET_NO.length != 0) {
			if (i > 0){
				enterUseAdvticket += '|';
			}
			enterUseAdvticket += advticket_one.ADVTICKET_NO;
		}
	}

	var param = 'PLAY_COMPANY_CD=' + frm.PLAY_COMPANY_CD.value + '&' +
				'PLACE_CD=' + frm.PLACE_CD.value + '&' +
				'REG_COMPANY_CD=' + frm.REG_COMPANY_CD.value + '&' +
				'PROGRAM_CD=' + frm.PROGRAM_CD.value + '&' +
				'PLAY_DATE=' + frm.PLAY_DATE.value + '&' +
				'PLAY_SEQ_CD=' + frm.PLAY_SEQ_CD.value + '&' +
				'PLAY_ST_TIME=' + frm.PLAY_ST_TIME.value + '&' +
				'ENTER_USE_ADVTICKET=' + enterUseAdvticket;

	$.ajax({
		type : 'post',
		url : 'booking_dis_pay_advticket.do',
		data : param,
		dataType : 'html',
		success : function(html) {

			$('#booking_dis_pay_advticket').empty();
			$(html).appendTo('#booking_dis_pay_advticket');
			$('#booking_dis_pay_advticket').dialog({
				width : 600,
				modal : true
			}).parents('.ui-dialog').find('.ui-dialog-titlebar').remove();
		}
	});
}

// 예매권 체크박스 누를때
function advPriceTypeClick(pkg_type, advticket_no, price_type_cd, seat_grade_cd, lmt_cnt_from, lmt_cnt_to, price) {

	if (document.getElementById(advticket_no).checked){
		var currCnt = 1;
		var iAddCnt = 1;
		var iCurrCnt = parseInt(currCnt, 10);
		var iCalcCnt = 0;

		// 매수제한 검사, 등급별 총매수 제한 검사
		iCalcCnt = CheckLimitTicket(iAddCnt, iCurrCnt, seat_grade_cd, lmt_cnt_from, lmt_cnt_to, price_type_cd);

		if (iCalcCnt == null) {
			document.getElementById(advticket_no).checked = false;
			return;
		}

		// 일반권종수량 > 예매권사용수량 검사, 아니면 선택불가 처리(일반 권종에 대해서만 예매권으로 대체 처리한다.)
		var normal_cnt = reserve_grade(seat_grade_cd);
		var adv_cnt = getTotalCount_Adv();

		if (normal_cnt <= adv_cnt) {
			document.getElementById(advticket_no).checked = false;
			alert('예매권은 ' + normal_cnt + ' 매 까지만 가능합니다.(일반 권종에 대해서만 예매권을 사용할 수 있습니다.)');
			return;
		}

		// 전체 수량 중에서 현재 등급에 대해서 재계산하여 갑을 가져온다.
		var TotalSeatGradeCount = getTotalSeatGradeCount(seat_grade_cd);

		// 추가
		for (var i = 0; i < ADVTICKET_NO_LIST.length; i++) {

			var advticket_one = ADVTICKET_NO_LIST[i];

			if (advticket_one.ADVTICKET_NO.length != 0){
				continue;
			}

			advticket_one.PKG_TYPE = pkg_type;
			advticket_one.ADVTICKET_NO = advticket_no;
			advticket_one.PRICE_TYPE_CD = price_type_cd;
			advticket_one.SEAT_GRADE_CD = seat_grade_cd;
			advticket_one.LMT_CNT_FROM = lmt_cnt_from;
			advticket_one.LMT_CNT_TO = lmt_cnt_to;
			advticket_one.PRICE = price;
			break;
		}

		// 합계 재계산
		last_amt();
	}else{
			var currCnt = getTotalCount_Adv();
			var iAddCnt = -1;
			var iCurrCnt = parseInt(currCnt, 10);
			var iCalcCnt = 0;

			// try {
			iCalcCnt = CheckLimitTicket(iAddCnt, iCurrCnt, seat_grade_cd, lmt_cnt_from, lmt_cnt_to, price_type_cd);

			if (iCalcCnt == null){
				return;
			}

			// 전체 수량 중에서 현재 등급에 대해서 재계산하여 갑을 가져온다.
			var TotalSeatGradeCount = getTotalSeatGradeCount(seat_grade_cd);

			// -----------------------------------------------------------------------------
			// 삭제
			for (var i = 0; i < ADVTICKET_NO_LIST.length; i++) {

				var advticket_one = ADVTICKET_NO_LIST[i];

				if (advticket_one.ADVTICKET_NO.length == 0){
					continue;
				}

				if (advticket_one.ADVTICKET_NO == advticket_no) {

					advticket_one.PKG_TYPE = '';
					advticket_one.ADVTICKET_NO = '';
					advticket_one.PRICE_TYPE_CD = '';
					advticket_one.SEAT_GRADE_CD = '';
					advticket_one.LMT_CNT_FROM = '';
					advticket_one.LMT_CNT_TO = '';
					advticket_one.PRICE = '';
				}
			}

			// 합계 재계산
			last_amt();
	}
}

// 해당 권종 수량 + 예매권 권종
function getTotalSeatGradeCount(seat_grade_cd) {

	var totalcnt = 0;

	for (var i = 0; i < PRICE_LIST.length; i++) {

		var price_one = PRICE_LIST[i];

		if (price_one.SEAT_GRADE_CD == seat_grade_cd && price_one.PRICE_TYPE_CD != '500001')
			totalcnt += parseInt(price_one.CHOICE, 10);
	}

	for (var i = 0; i < ADVTICKET_NO_LIST.length; i++) {

		var advticket_one = ADVTICKET_NO_LIST[i];

		if (advticket_one.ADVTICKET_NO.length != 0 && advticket_one.SEAT_GRADE_CD == seat_grade_cd)
			totalcnt++;
	}

	return totalcnt;
}

// 매수제한 검사, 등급별 총매수 제한 검사
function CheckLimitTicket(iAddCnt, iCurrCnt, seat_grade_cd, LmtCntFrom, LmtCntTo, price_type_cd) {

	var iCalcCnt = 0;

	if (iCalcCnt == null){
		return null;
	}

	if ((iAddCnt + grade_num()) > max_booking_count) {

		alert('티켓금액이 최대 8원 이하인 경우에만 사용 가능합니다.');
		return;
	}

	if (iAddCnt > 0) {

		if ((iAddCnt + iCurrCnt) <= max_booking_count) {

			if (LmtCntTo != 0) {

				if (LmtCntTo > (iAddCnt + iCurrCnt))
					iCalcCnt = iCurrCnt + 1;
			}
			else if (LmtCntTo == 0) {

				iCalcCnt = iCurrCnt + 1;
			}
		}

	}else {

		if (iCurrCnt < 0) {

			alert('CheckLimitTicket 2');
			return null;
		}else {

			iCalcCnt = iCurrCnt + -1;
		}
	}

	if(ReserveCheck(seat_grade_cd))
	{
		alert('등급별 해당 권종이 다릅니다.확인해 주시길 바랍니다.');
		return null;
	}

	if (seat_grade_cd != null && seat_grade_cd.length != 0) {

		// 권종리스트 중에서 해당등급의 수량을 가져 온다.
		var TotalPrice_SeatGradeCount = reserve_grade(seat_grade_cd);

		// 예매권 리스트 중에서 해당등급의 수량을 가져 온다.
		var TotalAdv_SeatGradeCount = getTotalCount_AdvSeatGrade(seat_grade_cd);

		// 예매권 사용 수량에 대한 검사
		if ((iAddCnt + TotalAdv_SeatGradeCount) > TotalPrice_SeatGradeCount) {
			alert('등급별 예매권 사용 가능 수량을 초과 하였습니다.');
			return null;
		}
	}

	return iCalcCnt;
}

// 예매권 사용 갯수 조회
function getTotalCount_Adv() {

	var totalcnt = 0;

	for (var i = 0; i < ADVTICKET_NO_LIST.length; i++) {

		var advticket_one = ADVTICKET_NO_LIST[i];

		if (advticket_one.ADVTICKET_NO.length != 0)
			totalcnt++;
	}

	return totalcnt;
}

// 예매권 리스트 중에서 해당등급의 수량을 가져 온다.
function getTotalCount_AdvSeatGrade(seat_grade_cd) {

	var totalcnt = 0;

	for (var i = 0; i < ADVTICKET_NO_LIST.length; i++) {

		var advticket_one = ADVTICKET_NO_LIST[i];

		if (advticket_one.ADVTICKET_NO.length != 0 && advticket_one.SEAT_GRADE_CD == seat_grade_cd)
			totalcnt++;
	}

	return totalcnt;
}

// 쿠폰 등록 / 사용 팝업 표시
function booking_dis_pay_coupon() {
	var frm = document.frmDisPay;
	// 사용할 쿠폰
	var enterUseCoupon = '';

	if ($('input[name=COUPON_LIST]:checked').val() == null)
		enterUseCoupon = 'NOT_USE_COUPON';
	else
		enterUseCoupon = $('input[name=COUPON_LIST]:checked').val();

	var param = 'ENTER_USE_COUPON=' + enterUseCoupon;

	$.ajax({
		type : 'post',
		url : 'booking_dis_pay_coupon.do',
		data : param,
		dataType : 'html',
		success : function(html) {

			$('#booking_dis_pay_coupon').empty();
			$(html).appendTo('#booking_dis_pay_coupon');
			$('#booking_dis_pay_coupon').dialog({
				width : 600,
				modal : true
			}).parents('.ui-dialog').find('.ui-dialog-titlebar').remove();
		}
	});
}

// 예매권 추가
function add_advticket() {

	var frm = document.frmDisPay;

	var PLAY_COMPANY_CD = frm.PLAY_COMPANY_CD.value;
	var PLACE_CD = frm.PLACE_CD.value;
	var REG_COMPANY_CD = frm.REG_COMPANY_CD.value;
	var PROGRAM_CD = frm.PROGRAM_CD.value;
	var PLAY_DATE = frm.PLAY_DATE.value;
	var PLAY_SEQ_CD = frm.PLAY_SEQ_CD.value;
	var PLAY_ST_TIME = frm.PLAY_ST_TIME.value;
	var addAdvNumber = document.getElementById('ADD_ADV_NUMBER').value;

	if (addAdvNumber.length < 20) {

		alert('예매권번호 20자리를 입력해 주세요.');
		return;
	}

	if (Exist_AdvNumber()) {

		alert('이미 등록되어 있는 예매권 번호 입니다.');
		return;
	}

	var param = 'PLAY_COMPANY_CD=' + frm.PLAY_COMPANY_CD.value + '&' +
				'PLACE_CD=' + frm.PLACE_CD.value + '&' +
				'REG_COMPANY_CD=' + frm.REG_COMPANY_CD.value + '&' +
				'PROGRAM_CD=' + frm.PROGRAM_CD.value + '&' +
				'PLAY_DATE=' + frm.PLAY_DATE.value + '&' +
				'PLAY_SEQ_CD=' + frm.PLAY_SEQ_CD.value + '&' +
				'PLAY_ST_TIME=' + frm.PLAY_ST_TIME.value + '&' +
				'ADD_ADV_NUMBER=' + addAdvNumber;

	$.ajax({
		type : 'post',
		url : 'booking_dis_pay_advticket_add.do',
		data : param,
		dataType : 'html',
		success : function(html) {

			if (html.length > 100) {

				var advlists = document.getElementById('reserv_adv_list');
				var li = document.createElement('li');

				li.innerHTML = html;	// '<li><p><input type=\"checkbox\" value=\"123123\" id=\"123123\" name=\"1234123\" data-role=\"none\" onclick=\"javascript:advPriceTypeClick();\" >adsfasdf 1매</p><p class=\"price\">1212122원</p></li>';
				advlists.appendChild(li);
			}
			else {

				alert(html.trim());
			}
		}
	});
}

function Exist_AdvNumber() {

	var new_no = document.getElementById('ADD_ADV_NUMBER').value;
	var exist_no = document.getElementById(new_no);

	if (exist_no == '' || exist_no == null)
		return false;
	else
		return true;
}

// 포인트 사용 팝업 표시
function booking_dis_pay_point() {

	var iCnt = 0;
	iCnt = getTotalCount();
	if ( iCnt == 0 ){
		alert('권종을 먼저 선택해 주세요.')
		return false;
	}

	var frm = document.frmDisPay;

	// 사용할 포인트
	var enterUsePoint = frm.TOT_POINT.value;
	if (enterUsePoint == ''){
		enterUsePoint = '0';
	}

	var param = 'REPLY_Aval_point=' + '0' + '&' +
				'REPLY_Acum_point=' + '0' + '&' +
				'REPLY_Min_use_type=' + '0' + '&' +
				'REPLY_Min_use_amt=' + '0' + '&' +
				'REPLY_Max_use_type=' + '0' + '&' +
				'REPLY_Max_use_amt=' + '0' + '&' +
				'REPLY_Use_unit=' + '0' + '&' +
				'ENTER_USE_POINT=' + enterUsePoint;

	$.ajax({
		type : 'post',
		url : 'booking_dis_pay_point.do',
		data : param,
		dataType : 'html',
		success : function(html) {

			$('#booking_dis_pay_point').empty();
			$(html).appendTo('#booking_dis_pay_point');
			$('#booking_dis_pay_point').dialog({
				width : 600,
				modal : true
			}).parents('.ui-dialog').find('.ui-dialog-titlebar').remove();
		}
	});
}

function initPoint(){
	$('#c2s_point_use_amt').val('0');
	$('#pop_c2s_point_use_amt').val('0');
	$('#Tot_point_sub').empty();
	$('#Tot_point_sub').append('0');
	$('#chkboxPointAllUsed').prop('checked',false);
}

// 사용 할 포인트 변경시
function changePoint() {

	var frm = document.frmDisPay;
	
	$('#pop_c2s_point_use_amt').val(UnComma($('#pop_c2s_point_use_amt').val()));

	// 사용 가능한 입력값인지 검사한다.
	if (!CheckLimitPoint($('#pop_c2s_point_use_amt').val())){
		$('#c2s_point_use_amt').val('0');
		$('#pop_c2s_point_use_amt').val('0');
		$('#chkboxPointAllUsed').prop('checked',false);
	}

	// 사용할 포인트 표시
	$('#Tot_point_sub').empty();
	$('#Tot_point_sub').append(CommaNumber($('#pop_c2s_point_use_amt').val()));
	
	$('#c2s_point_use_amt').val($('#pop_c2s_point_use_amt').val());
	$('#pop_c2s_point_use_amt').val(CommaNumber($('#c2s_point_use_amt').val()));

	// 결제금액 계산
	last_amt();
}

function CheckLimitPoint(in_point) {

	// 사용할 포인트가 0일 경우 그대로 TRUE 반환
	if (in_point == 0)
		return true;

	var frm = document.frmDisPay;

	var v_Min_use_amt = 0;
	var v_Max_use_amt = 0;
	var totprice = fn_getTot_payment() - fn_getcouponAmt()  ;

	var myPoint = T_Aval_point;

	// 0:제한없음,1:율,2:금액
	if (T_Min_use_type == 0){
		v_Min_use_amt = 0;
	}else if (T_Min_use_type == 1){
		v_Min_use_amt = totprice * T_Min_use_amt / 100;
	}else if (T_Min_use_type == 2){
		v_Min_use_amt = T_Min_use_amt;
	}

	// 0:제한없음,1:율,2:금액
	if (T_Max_use_type == 0){
		v_Max_use_amt = totprice;
	}else if (T_Max_use_type == 1){
		v_Max_use_amt = totprice * T_Max_use_amt / 100;
	}else if (T_Max_use_type == 2){
		v_Max_use_amt = T_Max_use_amt;
	}

	if ((in_point < v_Min_use_amt) || (in_point > v_Max_use_amt)) {

		alert('포인트 최소[' + v_Min_use_amt + '], 최대[' + v_Max_use_amt + '] 범위 내로 입력하셔야 합니다.');
		return false;
	}

	if ((in_point % T_Use_unit) != 0) {

		alert('포인트는  [' + T_Use_unit + '] 단위로만 사용 가능 합니다.');
		return false;
	}

	if (myPoint < in_point) {

		alert('포인트는  [' + myPoint + '] 까지만  사용 가능 합니다.');
		return false;
	}


	// 티켓 총 금액을 초과하였는지 체크
	if (totprice < in_point) {

		alert('티켓 총 금액을 초과하였습니다.\n다시 입력해 주세요.');
		return false;
	}

	return true;
}

// 포인트 모두 사용 체크박스 클릭 이벤트
function goPointAllClick() {
	
	var iCnt = 0;
	var iSeatTot = 0;
	iCnt = getTotalCount();
	iSeatTot = $('#SEAT_COUNT').val();
	
	if ( iCnt != iSeatTot ){
		$('#Tot_point_sub').empty();
		$('#pop_c2s_point_use_amt').val('0');
		$('#chkboxPointAllUsed').prop('checked',false);
	    alert('매수를 선택 해 주세요.');
	    return;
	}
	
	if (document.getElementById('chkboxPointAllUsed').checked){
		$('#pop_c2s_point_use_amt').val(CalcMaxPoint());
	}else{
		$('#pop_c2s_point_use_amt').val('0');
	}
	
	changePoint();
}

// 최대 포인트
function CalcMaxPoint() {

	var frm = document.frmDisPay;

	var v_Min_use_amt = 0;
	var v_Max_use_amt = 0;
	var totprice = fn_getTot_payment() - fn_getcouponAmt()  ;
	var myPoint = T_Aval_point;

	if (T_Min_use_type == 0){
		v_Min_use_amt = 0;
	}else if (T_Min_use_type == 1){
		v_Min_use_amt = jsParseInt(totprice) * T_Min_use_amt / 100;
	}else if (T_Min_use_type == 2){
		v_Min_use_amt = T_Min_use_amt;
	}

	if (T_Max_use_type == 0){
		v_Max_use_amt = totprice;
	}else if (T_Max_use_type == 1){
		v_Max_use_amt = jsParseInt(totprice) * T_Max_use_amt / 100;
	}else if (T_Max_use_type == 2){
		v_Max_use_amt = T_Max_use_amt;
	}

	c2s_point_use_amt = 0;

	if (myPoint >= totprice) {

		if (v_Max_use_amt >= totprice) {

			if ((T_Use_unit == 0) || (totprice % T_Use_unit) == 0){
				c2s_point_use_amt = totprice;
			}else{
				c2s_point_use_amt = parseInt((totprice / T_Use_unit), 10) * T_Use_unit;
			}
		}else {

				if ((v_Max_use_amt % T_Use_unit) == 0){
					c2s_point_use_amt = v_Max_use_amt;
				}else{
					c2s_point_use_amt = parseInt((v_Max_use_amt / T_Use_unit), 10) * T_Use_unit;
				}
		}
	}else if (myPoint < totprice) {

		if (v_Max_use_amt >= myPoint) {

			if ((T_Use_unit == 0) || (totprice % T_Use_unit) == 0){
				c2s_point_use_amt = myPoint;
			}else{
				c2s_point_use_amt = parseInt((myPoint / T_Use_unit), 10) * T_Use_unit;
			}
		}else if (v_Max_use_amt < myPoint) {

			if ((T_Use_unit == 0) || (totprice % T_Use_unit) == 0){
				c2s_point_use_amt = v_Max_use_amt;
			}else{
				c2s_point_use_amt = parseInt((v_Max_use_amt / T_Use_unit), 10) * T_Use_unit;
			}
		}
	}
	return c2s_point_use_amt;
}

function complete_choice(){
	var frm = document.frmDisPay;
	var Count = '4';
	var cnt = 0;
	var AdvCount2 = getTotalCount_Adv();

	for(var j=0;j < GRADE_PRICE_LIST2.length;j++){
		var grade = GRADE_PRICE_LIST2[j];
		var idxCnt = grade.CHOICE;
		cnt = cnt + Number(idxCnt);
	}

	if(Number(Count) != Number(cnt)){
		alert('선택하신 좌석 수량과 선택하신 티켓 수량이 맞지 않습니다.');
		return;
	}

	// 예매권패키지가 있을때
	if(AdvCount() > 0){
		if(Count != AdvCount2){
			alert('패키지예매권으로만 구매가능 합니다.');
			return;
		}
	}
		
	encodeURI();
	$('.form-select').val('0');
	$('input:radio[name=coupon_sel]').prop('checked',false); 
	$('#pop_c2s_point_use_amt').val('0');
	$('#chkboxPointAllUsed').prop('checked',false)
	frm.action = 'booking_delivery_svg.do';
	frm.method = 'post';
	frm.submit();
}

function AdvCount(){
	var cnt = 0;
	for(var i=0;i < GRADE_PRICE_LIST2.length;i++){
		var grade = GRADE_PRICE_LIST2[i];

		// 예매권패키지 따라 수량 입력
		if(grade.SEAT_GRADE_CD == '08'){
			if(grade.PRICE_TYPE_CD == '500001'){
				cnt = grade.CHOICE;
			}
		}
	}

	return cnt;
}

function goBookingAct_R() {

	var frm = document.frmDisPay;

	var encodeURI_Flag = "N";

	var double_dlvr_flag = "";
	var tmp_price_type = "";


	for( var i=0; i<GRADE_PRICE_LIST2.length; i++ ){
		var price_one = GRADE_PRICE_LIST2[i];


		// 선택한 권종에 대해서 검사
		if ( parseInt(price_one.CHOICE ,10) >0 ){

			dlvr_type= price_one.DLVR_TYPE; // 배송구분(0:전체, 1:현장수령만가능, 2:배송만가능)

			if ( ( frm.DELIVERY_KIND.value == "000002" ) && ( dlvr_type == "1" ) ) {

				alert( '고객님이 선택하신 ['+ price_one.PRICE_TYPE_NAME + '권종은 공연 당일\n현장매표소에오셔서 증빙자료(쿠폰,신분증,복지카드,\n국가유공자증 등)를 본인이 직접 제시하셔야만 입장권\n수령이 가능합니다.\n\n-증빙자료 미제출시 할인된 금액에 대해서 추가 결제 후 공연관람 가능\n\n-우편배송불가 ');

				return false;
			}

	    	if ( ( frm.DELIVERY_KIND.value == "000001" ) && ( dlvr_type == "2" ) ) {

				alert( price_one.PRICE_TYPE_NAME + '권종은 현장에서 수령하실 수 없습니다.\n(우편배송만 가능합니다.)');

				return false;
	    	}


	    	if ( ( double_dlvr_flag == "") && ( dlvr_type == "1" ) ){
	    		double_dlvr_flag = "1";
	    		tmp_price_type = price_one.PRICE_TYPE_NAME;
	    	}
	    	if ( ( double_dlvr_flag == "") && ( dlvr_type == "2" ) ){
	    		double_dlvr_flag = "2";
	    		tmp_price_type = price_one.PRICE_TYPE_NAME;
	    	}
	    	if  ( ( double_dlvr_flag == "1") && ( dlvr_type == "2" ) ) {
	    		price_type_name = price_one.PRICE_TYPE_NAME;

				alert( '[' + tmp_price_type + '] 권종은 현장수령만 가능하며,\n['+ price_type_name + '] 권종은 우편배송만 가능하오니\n동시에는 예매가 불가능 합니다.\n다시 선택하여 주십시요.');

				return false;
	    	}
	    	if  ( ( double_dlvr_flag == "2") && ( dlvr_type == "1" ) ) {
	    		price_type_name = price_one.PRICE_TYPE_NAME;

				alert( '[' + tmp_price_type + '] 권종은 우편배송만 가능하며,\n['+ price_type_name + '] 권종은 현장수령만 가능하오니\n동시에는 예매가 불가능 합니다.\n다시 선택하여 주십시요.');

				return false;
	    	}
		}
	}

	encodeURI();
	return true;
}

function encodeURI(){
	var frm = document.frmDisPay;

	frm.PRICE_LIST.value = encodeURIComponent( JSON.stringify(GRADE_PRICE_LIST2) );
	frm.ADVTICKET_NO_LIST.value = encodespecialChar( JSON.stringify( ADVTICKET_NO_LIST ) );

	frm.PLAY_SEQ_NM.value = encodespecialChar(frm.PLAY_SEQ_NM.value);
	frm.SEAT_INFO.value = encodeURIComponent( JSON.stringify(SEAT_INFO) );
	frm.GRADEPRICE_LIST.value = encodespecialChar(JSON.stringify(GRADEPRICE_LIST));
	frm.JSON_GRDAEPRICE2.value = encodespecialChar( JSON.stringify(JSON_GRDAEPRICE2) );
}


$(document).ready(function(){
	var monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
	$("#month_convert").text(monthNames[Number($("#month_convert").text())-1]);
});

function winOpen(no){
	var sH = screen.availHeight;
	var sW = screen.availWidth-200;
	window.open("https://www.acc.go.kr/ticket/Information/view?discount=4","_blank","width=500,height=700,left="+sW+", top=0");
}


</script>