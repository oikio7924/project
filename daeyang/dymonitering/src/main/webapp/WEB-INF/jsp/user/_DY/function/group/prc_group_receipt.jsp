<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<link href="/resources/common/css/calendar/TronixCalendar.css" rel="stylesheet" type="text/css" />
<link href="/resources/common/css/calendar/TronixCalendar2.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" 	src="/resources/common/js/guide.js"></script>

<script src="/resources/smartadmin/js/plugin/moment/moment.min.js"></script>
<script src="/resources/api/fullcalendar/js/fullcalendar.js"></script>
<script src="/resources/api/fullcalendar/js/ko.js"></script>
<link rel="stylesheet" type="text/css" media="screen" href="/resources/api/fullcalendar/css/fullcalendar.css">
<link rel="stylesheet" type="text/css" href="/resources/common/css/program.css">

<style> 
	.input_form .blind , .confirm_info_span{display: none;}
	#receipt_pop_box {border: none;}
	#tour_contents_pop_box { width: 1114px; height: 570px; min-height: 650px;} 
	.contents_pop_header { height: 55px;}
	.fc-event {font-size: 13px;}
	.receipt_pop_header{background: #397fc6;}
	.contents_pop_body{height: 575px;}
	.fc-content-skeleton table {min-height: 70px;}
	#tour_contents_pop_box{height: 370px;	}
</style>

<script>
var freePerson = "";	//최대 참가인원
var minJoin = 10; 		//최소 참가인원

$(document).ready(function() {
	/* 약관 동의 처리 */
	$('#agree_notice').change(function(){
		$('.agreement_next').show();
		$('.agreement').hide();
		$("#receipt_pop_box").focus();  
	});
	
	/* 연락처 등록 처리 */
	$("#CT_BASIC_TEL_1").val("${userInfo.UI_PHONE}".split("-")[0]);
	$("#CT_BASIC_TEL_2").val("${userInfo.UI_PHONE}".split("-")[1]);
	$("#CT_BASIC_TEL_3").val("${userInfo.UI_PHONE}".split("-")[2]);
	
	/* 인솔자 정보 기본정보와 동일 처리*/
	$("#basic_same").on("click", function() {
		if ($(this).is(":checked")) {
			var phone1 = $("#CT_BASIC_TEL_1").val()
			var phone2 = $("#CT_BASIC_TEL_2").val()
			var phone3 = $("#CT_BASIC_TEL_3").val()
			$("#CT_LEADER_TEL_1").val(phone1);
			$("#CT_LEADER_TEL_2").val(phone2);
			$("#CT_LEADER_TEL_3").val(phone3);
			$("#GP_NAME").val($("#UI_NAME").val());
			var phone = phone1 +"-"+ phone2 +"-"+ phone3;
			$("#GP_PHONE").val(phone)
 		} else {
			$("#GP_NAME").val("");
			$(".CT_LEADER_TEL").val("");
		}
	});
	
	/* 교통편 변경 */
	$("input[name=GP_TRAFFIC]").change(function(){
		$(".traffic_info").hide();
		var val = $(this).val();
		switch(val){
		case("C" || "E"):
			$(".subway_info").show();
			break;
		case "B":
			$(".bus_group_info").show();
			break;
		default:
			$(".subway_info").show();
			break;
		}
	});
});

/* ***********************************************************************************
 * 
 * 신청 팝업 세팅
 * 
 *************************************************************************************/
function pf_DetailMove(tourInfo){

	if ("${userInfo.UI_ID}" == null || "${userInfo.UI_ID}" == '') {
		if (confirm("로그인이 필요합니다. 확인 버튼을 누르시면 로그인페이지로 이동합니다.")) {
			location.href = "/user/member/login.do?tiles=cf";
			return;
		}
	}
	
	//신청가능 인원수
	freePerson = tourInfo.cnt; 
	
	//기본코스일 경우 알림창 호출  
	alert(minJoin+'인 미만의 개인 및 그룹이신 경우에는 별도의 예약없이 희망 시작시간에 맞추어 방문자센터로 와주시면 됩니다.');
	
	//레이어 팝업 띄우기처리
	$("#pop_bg_opacity2").show();
	$("#receipt_pop_box").fadeOut("fast"); 
	$("#receipt_pop_box").fadeIn("slow");  
	$("#freePerson").text(freePerson);
	//신청작성할 때 입력된거 초기화
	$("#GP_GROUPNAME").val("");
	$("#GP_NAME").val("");
	$(".CT_LEADER_TEL").val("");
	$("#GP_HEADCOUNT").val("");
	$("#GP_WHEELCHAIR").val(0);
	$("#GP_YUMOCAR").val(0);
	$("input[name=basic_same]").prop("checked", false);
	$("input[name=GP_TRAFFIC][value='C']").prop("checked", true);	//첫번째 교통수단 선택
	var temp = $("#receipt_pop_box");
	
	// 화면의 중앙에 레이어를 띄운다.
	if (temp.outerHeight() < $(document).height() ) temp.css('margin-top', '-'+temp.outerHeight()/2+'px');
	else temp.css('top', '0px');
	if (temp.outerWidth() < $(document).width() ) temp.css('margin-left', '-'+temp.outerWidth()/2+'px');
	else temp.css('left', '0px'); 
	
	//레이어팝업 닫기 처리
	temp.find('a.receipt_pop_cbtn').click(function(e){
		$("#pop_bg_opacity2").fadeOut(); 
		$("#receipt_pop_box").fadeOut();   
		$("#tour_confirm_box").hide();
		$("#tour_contents_bg_box").hide();
		$("#tour_confirm_bg_box").hide();
	}); 
	//초기 포커스 설정 
	$("#CT_ORGANIZATION").focus();  
	
	if (tourInfo != null) {
		
		$("#tour_date").text(
				tourInfo.year +"-"+ tourInfo.month +"-"+  tourInfo.date + "/" + tourInfo.time);
		}
		var tourdate = $("#tour_date").text();
		var temp = tourdate.split("/");
		var gp_date = temp[0];
		var gp_time = temp[1];
		var titlekey = $("#programTitle option:selected").val();
		$("#GP_GM_KEYNO").val(titlekey);
		$("#GP_GSM_KEYNO").val(tourInfo.mainKey);
		$("#GP_GSS_KEYNO").val(tourInfo.subKey);
		$("#GSS_MAXIMUM").val(tourInfo.cnt);
		$("#GP_DATE").val(gp_date);
		$("#GP_TIME").val(gp_time);
}

function pf_tourInfo_init(tourInfo){
}

/* ***********************************************************************************
 * 
 * ACC투어 신청
 * 
 *************************************************************************************/
 function pf_receipt(){
	 layerPop = $(".online_regist");
	 
	 $("#confirm_notice_chk").removeAttr('checked');
	 
	//입력폼 체크 
	if ($("#CT_BASIC_TEL_1").val() == '' || $("#CT_BASIC_TEL_2").val() == '' || $("#CT_BASIC_TEL_3").val() == '') {
		alert("기본정보 연락처를 확인하세요.");
		$("#CT_BASIC_TEL_1").focus();
		return;
	}
	if ($("#GP_GROUPNAME").val() == '') {
		alert("단체명을 확인하세요.");
		$("#GP_GROUPNAME").focus();
		return;
	}
	if ($("#GP_NAME").val() == '') {
		alert("인솔자정보 인솔자명을 확인하세요.");
		$("#GP_NAME").focus();
		return;
	}
	if ($("#CT_LEADER_TEL_1").val() == '' || $("#CT_LEADER_TEL_2").val() == '' || $("#CT_LEADER_TEL_3").val() == '') {
		alert("인솔자정보 연락처를 확인하세요.");
		$("#CT_LEADER_TEL_1").focus();
		return;
	}
		
	var maxJoin = parseInt(freePerson); //최대 참가인원
	var join = parseInt($("#GP_HEADCOUNT").val());	 //참가 신청인원
	if ($("#GP_HEADCOUNT").val() == "") {
		alert("참가인원을 확인하세요.");
		$("#GP_HEADCOUNT").focus();
		return;
	}

	if (join < minJoin) {
		alert("총 관람자수가 " + minJoin + "명 이하인 경우 전당투어 신청이 제한됩니다.");
		$("#GP_HEADCOUNT").focus();
		return;
	}
	
	if (join > maxJoin) {
		alert("참가인원은 " + maxJoin + "명을 초과 할 수 없습니다.");
		$("#GP_HEADCOUNT").val("");
		$("#GP_HEADCOUNT").focus();
		return;
	}
	
	//등록 처리 시작  
	$.ajax({
		type : "POST",
		url : "/dy/function/Group/TourInsert.do",
		data : $("#Form").serialize(),
		async:false,
		success : function(result){
			// 인원 초과시
			if (result == '0') {
				alert("신청가능한 인원이 초과 되었습니다.");
				return;
				//성공
			} else if (result == '9') {
				alert("신청되었습니다.\n신청하신 내역은 마이페이지에서 확인 가능합니다.");
				$("html").css("overflow-y", "");
				$("body").css("overflow-y", ""); 
				$("#pop_bg_opacity").fadeOut(); 
				$("#pop_bg_opacity2").fadeOut(); 
				$("#receipt_pop_box").fadeOut();   
				$("#tour_contents_pop_box").hide();
				$("#tour_contents_bg_box").hide();
// 	 			pf_tour_complete_open();
			}
		},
		error: function(){
			alert('알수없는 에러 발생. 관리자한테 문의하세요.')
			return false;
		}
	});
	
// 	 pf_tour_confirm_open();
}

/* ***********************************************************************************
 * 
 * 전당투어 신청
 * 최종 신청내역 팝업 호출  -> 전당투어 신청 -> 완료팝업 호출 -> 마이페이지 이동
 * D : 기본코스(도슨트) ||   L : 연계코스   ||  S : 특별코스
 * 
 *************************************************************************************/
//1. 등록 최종확인창 호출
	function pf_tour_confirm_open() {
		$("#tour_confirm_bg_box").show();

		var type = $("#CT_TYPE").val();
		switch (type) {
		case "L":
			type = "연계코스(ACC투어-문화정보원)";
			break;
		case "S":
			type = "특별코스";
			break;
		default:
			type = "기본코스";
			break;
		}

		var name = $.trim($("#tour_name").text());
		var tel = $("#CT_BASIC_TEL_1").val() + "-" + $("#CT_BASIC_TEL_2").val()
				+ "-" + $("#CT_BASIC_TEL_3").val();
		var readertel = $("#CT_LEADER_TEL_1").val() + "-"
				+ $("#CT_LEADER_TEL_2").val() + "-"
				+ $("#CT_LEADER_TEL_3").val()
		var item = $("#CT_NEED_ITEM_1").val() + "/"
				+ $("#CT_NEED_ITEM_2").val();
		var join = $("#join_person").val();
		if ($("#total_person").val() > 0) {
			join += " / " + $("#total_person").val();
			$(".confirm_info_span").show();
		}
		join += " 명"
		var traffic = $("input:radio[name='GR_OR_TRAFFIC']:checked").val();
		switch (traffic) {
		case "A":
			traffic = "대중교통";
			break;
		case "C":
			traffic = "버스(단체)";
			break;
		case "D":
			traffic = "기타(" + $("#GR_OR_TRAFFIC_EXP").val() + ")";
			break;
		}

		var dt = $("#tour_date").text();
		dt = dt.split("/");
		//투어신청 완료팝업 

		var dt2 = $.trim(dt[0]);
		var y = dt2.split("-")[0];
		var m = dt2.split("-")[1];
		var d = dt2.split("-")[2];
		var h = dt[1].split(":")[0];
		var mm = dt[1].split(":")[1];
		var confirmTime = y + "년 " + m + "월 " + d + "일" + h + "시" + mm + "분";

		$("#confirm_time").text(confirmTime); //등록시간
		$("#tour_confirm_name").text(name); //등록자 
		//투어신청 최종확인팝업  
		$("#cofirm_info_type").text(type);
		$("#cofirm_info_date").text(dt); //등록시간
		$("#cofirm_info_name").text(name + " (" + tel + ")"); //신청자
		$("#cofirm_info_group").text($("#CT_ORGANIZATION").val()); //단체명   
		$("#cofirm_info_reader").text(
				$("#CT_LEADER_NAME").val() + " (" + readertel + ")"); //인솔자 이름   
		$("#cofirm_info_item").text(item + " 개"); // 유모차/휠체어 
		$("#cofirm_info_join").text(join); // 참가인원/총 인원 
		$("#cofirm_info_traffic").text(traffic); // 교통편  

		$("#tour_confirm_box").show(function() {
			$("#tour_confirm_box").focus();
		});

	}
	
	
</script>

<!-- 전당투어 일정 팝업 창 -->
<div id="tour_contents_pop_box" tabindex="0">
	<div id="tour_contents_bg_box"></div>
	<div class="pop-container"> 
		<div class="pop-conts">
		<div class="contents_pop_header"> 
			<div class="contents_pop_title">투어 온라인신청</div>
			<a href="javascript:;" class="contents_pop_cbtn">
				<img src="/resources/img/calendar/close_btn.gif" alt="닫기">
			</a>
		</div>
		<div class="contents_pop_body">
			<!-- 캘린터 -->
			<div class="box_date_pick">
				<ul>
			    	<li id="prevYear"><img src="/resources/img/icon/icon_arrow_left_2_calendar.png" alt="이전날짜"></li>
			    	<li id="prevMonth"><img src="/resources/img/icon/icon_arrow_left_calendar.png" alt="이전달"></li>
			    	<li class="date_box"></li>
			    	<li id="nextMonth"><img src="/resources/img/icon/icon_arrow_right_calendar.png" alt="다음날짜"></li>
			    	<li id="nextYear"><img src="/resources/img/icon/icon_arrow_right_2_calendar.png" alt="다음달"></li>
			    </ul>                        
			</div> 
			<div id="calendar" class="m_top_40"></div>
			<div class="calendar_selected_listBox"> 
				<div class="selected_date"></div>
				<ul class="selected_list"> 
				</ul>
			</div>
		</div>   
		<div class="contents_pop_footer"></div>   
		</div>
	</div>
</div> 


<!-- 전당투어 온라인신청 팝업창 -->
<div id="receipt_pop_box" tabindex="0">
	<div id="tour_confirm_bg_box"></div>
	<div class="pop-container">  
		<div class="pop-conts">
		<div class="receipt_pop_header"> 
			<div class="contents_pop_title" >투어 온라인신청서 작성하기</div> 
			<a href="javascript:;" class="receipt_pop_cbtn">
				<img src="/resources/img/calendar/close_btn.gif" alt="닫기">
			</a>
		</div>
		<div class="receipt_pop_body">  
			<form  method="post" name="Form" id="Form"> 
				<input type="hidden" name=Type value="I" />
				<input type="hidden" name=GP_DATE id="GP_DATE" />
				<input type="hidden" name="GP_TIME" id="GP_TIME" />
				<input type="hidden" name="GP_GM_KEYNO" id="GP_GM_KEYNO" />
				<input type="hidden" name="GP_GSM_KEYNO" id="GP_GSM_KEYNO" />
				<input type="hidden" name="GP_GSS_KEYNO" id="GP_GSS_KEYNO"/>
				<input type="hidden" name="GSS_MAXIMUM" id="GSS_MAXIMUM"/>
				<input type="hidden" name="GP_UI_KEYNO" value="${userInfo.UI_KEYNO }" />
				<input type="hidden" name="UI_NAME" id="UI_NAME" value="${userInfo.UI_NAME }" />
				<input type="hidden" name="GP_PHONE" id="GP_PHONE" />
				<div class="agreement_next" style="display: none;">
					<div class="tour_receipt_wrap">
						<div class="label_header">
							기본정보
						</div>
						<div class="tour_receipt_box">
							<div class="label_text">투어일정</div>
							<div class="input_form_4" id="tour_date"></div>
							<div class="label_text">이름</div>
							<div class="input_form_4" id="tour_name">
								${userInfo.UI_NAME } 
					 		</div>
				 			<div class="label_text">이메일</div>  
							<div class="input_form_4" id="tour_email">
								${userInfo.UI_EMAIL }
					 		</div>
				 			<label for="CT_BASIC_TEL_1"> 
						 		<div class="label_text">연락처</div>
								<div class="input_form"> 
									<input type="text" class="tel" maxlength="3" id="CT_BASIC_TEL_1" onKeyDown="return cf_only_Num(event);"/> -
									<label for="CT_BASIC_TEL_2" class="blind">연락처 중간번호</label>
									<input type="text" class="tel" maxlength="4" id="CT_BASIC_TEL_2" onKeyDown="return cf_only_Num(event);"/> -
									<label for="CT_BASIC_TEL_3" class="blind">연락처 끝번호</label>
									<input type="text" class="tel" maxlength="4" id="CT_BASIC_TEL_3" onKeyDown="return cf_only_Num(event);"/>  
						 		</div> 
					 		</label>
					 		<label>
						 		<div class="label_text group_text">단체명</div>
								<div class="input_form">
									<label for="GP_GROUPNAME" class="blind">단체명</label>
									<input type="text" maxlength="50" name="GP_GROUPNAME" id="GP_GROUPNAME"/> 
						 		</div>
					 		</label>
				 			<div class="clear"></div>
				 		</div>
				 	</div>
				 	<div class="tour_receipt_box">
				 		<label for="basic_same">
					 		<div> 
								<div class="label_header" style="float: left;">인솔자 정보</div>  
								<div style=" float:left; padding-top: 4px; margin-left:20px; font-size: 12px; font-weight: normal; color: #55595b;">
									<input type="checkbox" id="basic_same" name="basic_same"/>기본정보와 동일
								</div>
								<div class="clear"></div> 
							</div>
						</label>
						<div class="clear"></div>
						<div class="tour_receipt_wrap">
						<label for="GP_NAME">
						<div class="label_text">이름</div>
						<div class="input_form">
							<input type="text" maxlength="30" name="GP_NAME" id="GP_NAME" /> 
				 		</div>
				 		</label>  
				 		<label for="CT_LEADER_TEL_1">
					 		<div class="label_text">연락처</div>
							<div class="input_form">
								<input type="text" class="tel CT_LEADER_TEL" id="CT_LEADER_TEL_1" maxlength="3" onKeyDown="return cf_only_Num(event);"/> -
								<label for="CT_BASIC_TEL_2" class="blind">인솔자 연락처 중간번호</label>
								<input type="text" class="tel CT_LEADER_TEL" id="CT_LEADER_TEL_2" maxlength="4" onKeyDown="return cf_only_Num(event);"/> -
								<label for="CT_BASIC_TEL_3" class="blind">인솔자 연락처 끝번호</label>
								<input type="text" class="tel CT_LEADER_TEL" id="CT_LEADER_TEL_3" maxlength="4" onKeyDown="return cf_only_Num(event);"/>  
					 		</div>
			 			</label>
		 				<div class="clear"></div>
		 				</div>
					</div>
		 		
			 		<div class="tour_receipt_wrap">
				 		<div class="label_header"> 
				 			관람 인원
						</div>
						<div class="tour_receipt_box">
						<label for="GP_YUMOCAR">
							<div class="label_text">유모차<br> 필요개수</div>
							<div class="input_form">
								<input class="w15" type="text" maxlength="2" id="GP_YUMOCAR" name="GP_YUMOCAR" value="0" onKeyDown="return cf_only_Num(event);"/> 개
					 		</div>
				 		</label>
				 		<label for="GP_WHEELCHAIR">
							<div class="label_text">휠체어<br> 필요개수</div>
							<div class="input_form"> 
								<input class="w15" type="text" maxlength="2" id="GP_WHEELCHAIR" name="GP_WHEELCHAIR" value="0" onKeyDown="return cf_only_Num(event);"/> 개
					 		</div>
				 		</label>
				 		<label for="GP_HEADCOUNT">  
							<div class="label_text">참가인원</div>
							<div class="input_form"> 
								<input class="w15" type="text" maxlength="4" id="GP_HEADCOUNT" name="GP_HEADCOUNT" onKeyDown="return cf_only_Num(event);"/> 명
					 		</div>    
				 		</label> 
				 		 
				 		<div class="clear"></div>
				 		<ul class="tour_person_notice">
				 			<li>현재  <b><span id="freePerson"></span>명</b> 예약 가능합니다.</li> 
				 			<!-- <li> 
				 			인원 조정이 필요한 단체의 경우 아래의 칸에 총 인원을 기입하여 주시기 바랍니다. 담당자의 연락 후 예약이 확정됩니다.
				 			</li> 
				 			<li>문의사항: 1899-5566</li>
				 			 <li> 
				 			<label for="total_person">               
							<div class="label_text total_person_text"> 희망 총 인원</div>   
							<div class="input_form total_person_text">   
								<input class="w15" type="text"  maxlength="3" id="total_person" onKeyDown="return cf_only_Num(this);"/> 명
					 		</div>
					 		</label>
					 		</li> -->
				 		</ul> 
				 		
						</div>
						
				 		<div class="clear"></div>
			 		</div>
			 		
			 		<div class="tour_receipt_wrap">
				 		<div class="label_header"> 
				 			교통편
						</div>
						
						<div class="tour_receipt_box tour_traffic_wrap">
							<div class="input_form_4">
								<label for="GP_TRAFFIC_C">
									<input type="radio" id="GP_TRAFFIC_C" name="GP_TRAFFIC" value="C" checked="checked">대중교통
								</label>
								<label for="GP_TRAFFIC_B">
									<input type="radio" id="GP_TRAFFIC_B" name="GP_TRAFFIC" value="B">버스(단체)
								</label>
								<label for="GP_TRAFFIC_E">
									<input type="radio" id="GP_TRAFFIC_E" name="GP_TRAFFIC" value="E">기타
								</label>
								<label for="GP_TRAFFIC_EXP">
									<input type="text" id="GP_TRAFFIC_EXP" name="GP_TRAFFIC_EXP" value="" size="6" />
								</label>
					 		</div> 
					 		<div class="clear"></div>
					 		<div class="traffic_box">
					 			<div class="traffic_info subway_info">
					 				<ul>
					 					<li>지하철 오시는 길 : 문화전당역 하차</li>
					 					<li> 
					 						버스로 오시는 길 : 국립아시아문화전당 또는 문화전당역
					 						<ul class="guideMap_UL1">  
									    		<li style="background: none;">
									    			<div class="bus"><span class="label green" style="margin-rigth:20px;">지선</span>
									    			수완12, 1187, 518, 석곡87, 송정98, 풍암61, 첨단95, 금남55, 419, 금남57
									    			</div>
									    		</li>
												<li style="background: none;">
												<div class="bus"><span class="label red" style="margin-rigth:20px;">급행</span>
													첨단09, 순환01, 진월07, 풍암06</div>
												</li>
												<li style="background: none;"><div class="bus"><span class="label blue" style="margin-rigth:20px;">간선</span>
													지원45, 금호36, 봉선37, 봉선27, 일곡28, 지원15, 운림35, 진월17, 문흥39</div>
												</li>
												<li style="background: none;"><div class="bus"><span class="label sky" style="margin-rigth:20px;">공항</span>
													1000</div>
												</li> 
									    	</ul>
					 					</li>
					 				</ul>
					 			</div> 
					 			<div class="traffic_info bus_group_info"> 
					 				<div>
				 						<img style="width:100%; cursor: pointer;" src="/resources/img/calendar/tour_info_map2.jpg" onclick="gonyImgWin('/resources/img/calendar/tour_info_map2.jpg')" alt="단체버스 가이드 이미지" />
					 				</div> 
					 				<div>
					 					<div style="font-size:14px; margin-bottom:3px; margin-top:10px;">
					 						<b>ACC투어에 참여하는 단체 관람객 대형버스 주차 구역 안내(<span style="color:red;">유료 주차장</span>)</b>
					 					</div>
					 					<div style="font-size:13px;">
						 					<div>국립아시아문화전당 부설주차장(구. 광주여고)에 주차 하실 수 있습니다.</div>
						 					<ul>  
						 						<li>대상:16인승 이상 (미니버스, 대형버스 등)</li>
												<li>장소:상단의 사진 참고</li>
												<li>※전당 주변은 주정차 단속구역으로 주차 시 과태료가 부과될 수 있습니다.</li>
						 					</ul>
										</div>
					 				</div>
					 				<div class="clear"></div>
					 			</div>
					 		</div>
			 				<div class="clear"></div>
			 			</div>
			 		</div>
			 		<!-- 등록 박스 -->
					<div class="online_registBox">
						<a href="javascript:pf_receipt();" class="online_regist" style="background-color: #086ad8;">온라인 신청</a>
					</div>
				</div>   
				
				<!--개인정보활용  -->
				<div class="agreement">
					<div class="label_header" style="margin-top:20px; "> 
			 			<div style="float: left;">개인정보활용</div>  
						
						<div class="clear"></div> 
					</div>
					<div class="agreement_contents">
						<p>&lt;개인정보 수집 및 이용에 대한 안내&gt;
						<br>1.개인정보의 수집 이용 목적
						<br> - ACC투어 신청 확인용
						<br>2. 수집하려는 개인정보의 항목
						<br> - 필수 : 단체명 또는 예약명, 성명, 인솔자 등 연락처(전화번호 또는 휴대폰번호) 
						<br> - 서비스 이용과정에서 자동으로 생성되어 수집되는 정보
						<br> (IP Address, 쿠키, 방문 일시, 서비스 이용 기록, 불량 이용 기록)
						<br>3. 개인정보의 보유 및 이용기간
						<br> - 개인정보의 수집 및 이용목적이 달성되면 지체없이 파기
						<br>4. 위 개인정보의 수집.이용.제공에 대하여 동의를 거부할 수 있습니다. 다만, 동의거부시에는 투어 입장관련 제한을 받을 수 있습니다.</p>
						<div class="clear"></div>
			 		</div>
		 			<div class="clear"></div> 
		 			<div class="label_footer">
			 		<label for="agree_notice" style=" text-aline:center;float:left; padding-top: 4px; margin-left:20px; font-size: 15px; font-weight: normal; color: #55595b;">
					<input type="checkbox" id="agree_notice" name="basic_same"/>개인정보활용에 동의합니다.</label>
		 			</div>
		 			<div class="clear"></div>
				</div> 
			</form> 
			</div>  
		</div>
	</div>
</div>
 
<div id="pop_bg_opacity"></div>
<div id="pop_bg_opacity2"></div>

<!-- 
<div id="tour_confirm_box" class="acc_confirm_box" tabindex="0">
	<a href="javascript:;" class="confirm_close_btn"
		onclick="pf_tour_close()"> <img
		src="/resources/img/calendar/close_btn.gif" alt="" />
	</a>
	<div class="acc_confirm_top">
		<div class="confirm_note">국립아시아문화전당 투어를 신청하시겠습니까?</div>
	</div>
	<div class="acc_confirm_mid">
		<div class="acc_confirm_info">
			<div>
				<div class="cofirm_info_th">투어구분</div>
				<div id="cofirm_info_type" class="cofirm_info_td"></div>
			</div>
			<div>
				<div class="cofirm_info_th">투어일정</div>
				<div id="cofirm_info_date" class="cofirm_info_td"></div>
			</div>
			<div>
				<div class="cofirm_info_th">신청자 (연락처)</div>
				<div id="cofirm_info_name" class="cofirm_info_td"></div>
			</div>
			<div>
				<div class="cofirm_info_th group_text">단체명</div>
				<div id="cofirm_info_group" class="cofirm_info_td"></div>
			</div>
			<div>
				<div class="cofirm_info_th">인솔자 (연락처)</div>
				<div id="cofirm_info_reader" class="cofirm_info_td"></div>
			</div>
			<div>
				<div class="cofirm_info_th">유모차 / 휠체어</div>
				<div id="cofirm_info_item" class="cofirm_info_td"></div>
			</div>
			<div>
				<div class="cofirm_info_th">
					참가인원 <span class="confirm_info_span"> / 희망인원</span>
				</div>
				<div id="cofirm_info_join" class="cofirm_info_td"></div>
			</div>
			<div>
				<div class="cofirm_info_th">교통편</div>
				<div id="cofirm_info_traffic" class="cofirm_info_td"></div>
			</div>
		</div>

		<div class="acc_confirm_notice">
			※ 투어종류/일정/인원 등 위의 신청내용을 모두 확인하였습니다. <br /> ※ 신청시간 기준으로 10분 이상 지연 시 <span>자동취소</span>됩니다.
			<br /> ※ 방문당일 현장에서 <a href="javascript:;" id="noticeBtn"
				onclick="pf_notice_show()">"관람예절 준수 서약서"</a>를 작성 및 제출 후 투어가 시작됩니다.
		</div>

		<div>
		<input type="checkbox" id="confirm_notice_chk" name="confirm_notice_chk" /> 
		<label for="confirm_notice_chk">위 내용에 동의합니다.</label> 
		</div>

		<div class="custom_checkbox acc_confirm_checkbox">
			<input type="checkbox" id="confirm_notice_chk"
				class="regist_agreeBox" tabindex="-1"> <label
				for="confirm_notice_chk" class="agreeChkBtn" tabindex="0">위의
				내용을 확인하였으며, 이에 동의합니다. </label>
		</div>


		<div class="acc_confirm_complete">
			<div class="acc_complete_info">
				<div>
					<b><span id="tour_confirm_name">ㅇㅇㅇ</span>님, <span
						id="confirm_time">00년 00월 00일 00시 00분</span></b>
				</div>
				<div>국립아시아문화전당 ACC투어 예약이 완료되었습니다.</div>
			</div>
			<div>투어 시작 10분 전까지 방문자센터로 와주시길 바랍니다.</div>
			<div>* 인원조정이 필요한 단체의 경우 담당자 연락 후 예약 확정됩니다.</div>
		</div>
	</div>
	<div class="acc_confirm_bottom">
		<a href="javascript:;" class="acc_tour_btn acc_confirm_btn"
			onclick="pf_tour_confirm()">확인</a> <a href="javascript:;"
			class="acc_tour_btn acc_cancel_btn" onclick="pf_tour_close()">취소</a>
		<div class="clear"></div>
	</div>
</div>


<div id="tour_notice_box" class="acc_confirm_box" tabindex="0">
	<a href="javascript:;" class="confirm_close_btn"
		onclick="pf_tour_close2()"> <img
		src="/resources/img/calendar/close_btn.gif" alt="" />
	</a>
	<div class="normal_tour">
		<div class="acc_confirm_top">
			<div class="confirm_note">관람예절 준수 서약서</div>
		</div>
		<div class="acc_confirm_mid"
			style="border-top: 1px solid #bbb; border-bottom: 1px solid #bbb; padding: 5px 0;">
			<div>본인은 투어를 신청한 인솔 책임자로서 원만한 관람진행과 시설 및 전시물의 보전,
				단체 관람객의 안전사고 예방을 위해 다음 사항을 준수할 것을 서약합니다.</div>
			<div class="acc_notice_box">
				<div>▣ 정숙한 관람 분위기 조성 및 실내 질서 유지</div>
				<div>만일 부주의 등 과실에 의해 발생한 시설 및 전시물 훼손 또는 인명사고에 대하여는 인솔 책임자 및 인솔
					단체에 그 책임이 있습니다.</div>
			</div>
			<div class="acc_notice_box">
				<div>▣ 다른 관람객들의 쾌적한 관람 및 실내 이동에 대한 배려</div>
				<div>소수의 일반인들이 단체로 인해 방해 받지 않도록 학생들을 대상으로 충분히 사전교육을 해야 하며,입장
					이후에도 인솔 및 지도를 지속할 책임이 있습니다.</div>
			</div>
			<div class="acc_notice_box">
				<div>▣ 유사시 전당 측의 조치에 대한 적극적 수용</div>
				<div>전당 관계 직원, 인솔 책임자의 지시 및 협조 요구에도 불구하고 참가자들의 소란,무질서, 전시물
					손괴행위 등으로 원만한 관람이 불가능하다고 판단 될 경우 전당 측은 즉시 퇴관을 명할 수 있으며, 차후 단체 관람 신청
					시 접수를 거부할 수 있습니다.</div>
			</div>
			<div class="acc_notice_box">
				<div>▣ 휴대 제한 품목</div>
				<div>
					· <span style="letter-spacing: -1px;">관람에 다음과 같은 물품은 반입할 수
						없습니다. (껌, 음료 등 음식물, 풍선, 셀카봉 등)</span> <br /> · 전당 내 필기, 스케치는 가능하나 연필의
					경우에만 허용됩니다. <br /> · 문화정보원은 작품 보호를 위해 음식물 및 가방, 파우치 반입이 불가능합니다.
				</div>
			</div>
			<div class="acc_notice_box">
				<div>▣ 전당 미화 유지를 위한 협조</div>
				<div>전당 내 시설 및 취식 공간 이용 시 청결한 시설 관리 및 전당 미화 유지에 협조할 책임이 있습니다.</div>
			</div>
		</div>
	</div>

	<div class="acc_confirm_bottom">
		<a href="javascript:;" class="acc_tour_btn acc_cancel_btn"
			onclick="pf_tour_close2()">닫기</a>
		<div class="clear"></div>
	</div>
</div>

 -->