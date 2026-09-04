<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script src="/resources/common/js/calendar/TronixCalendar.js"></script>
<link rel="stylesheet" type="text/css" media="screen" href="/resources/common/css/calendar/TronixCalendar.css">
<link href="/resources/common/css/calendar/TronixCalendar2.css" rel="stylesheet" type="text/css" />

<link rel="stylesheet" type="text/css" href="/resources/api/FrontMArte/css/import.css">
<link rel="stylesheet" type="text/css" href="/resources/api/FrontMArte/css/mypage.css">
<link rel="stylesheet" type="text/css" href="/resources/api/FrontMArte/css/ticket.css">
<link rel="stylesheet" type="text/css" href="/resources/api/FrontMArte/css/calendar.css">
<link rel="stylesheet" type="text/css" href="/resources/api/FrontMArte/css/ticket_2.css">
<link href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="/resources/common/css/program.css">
<script type="text/javascript" src="/resources/api/FrontMArte/js/json2.js"></script>
<script type="text/javascript" src="/resources/api/FrontMArte/js/comm.js"></script>
<script type="text/javascript" src="/resources/api/FrontMArte/js/security.js"></script> 
<script type="text/javascript" src="/resources/api/FrontMArte/js/fn_booking_date_seq.js"></script>
<script src="/resources/smartadmin/js/plugin/moment/moment.min.js"></script>

<style type="text/css">
	body {font-size: 13px}
	.contents_pop_body{height: 690px;}
	#tour_contents_pop_box{	height: 751px;}
	.selC_on2 {display: inline-block;  width: 92px; height: 34px; line-height: 34px; font-size: 15px; text-align: center; background: #bf1010; color: #fff !important; font-weight: bold;  border-radius: 20px;}
	.contents_pop_header {height: 55px;	}
	
	/* 장소이미지 팝업 */
	a {  text-decoration: none;    color: #393f45;  border: none;}
	img {border: 0;}
</style>
<div id="credit_pop" class="pop_layer">
	<div class="pop_container"> 
		<div class="pop_title">장소이름</div> 
		<a href="javascript:;" class="cbtn" title="닫기" onclick="pf_pop_close();">
			<img src="/resources/img/calendar/btn_close_gray.png" alt="닫기">
		</a>   
		<div class="pop_conts">
			 <a href="#">
			 	<img id="placeImg" width="400" height="250">
			 </a>
		</div>
	</div>
</div>

    <ul>
    	<c:forEach items="${resultList }" var="model">
   		<input type="hidden" value="${model.AP_TYPE }" id="APType">
    	<li>
    		<p class="title">${model.AP_NAME }</p>
    		<div class="applyBtn">
    			<fmt:parseNumber value="${fn:substring(model.AP_KEYNO,4,20)}" integerOnly="true" var="key"/>
    				<c:if test="${model.AP_DEADLINE == 'N'}">	
    					
		    			<c:if test="${not empty model.AP_APPLY_ST_DATE && not empty model.AP_APPLY_EN_DATE }">	<!-- 예매시작 O, 예매종료 O -->
		    				<c:if test="${now_date < model.AP_APPLY_ST_DATE }">
			    				<button type="button" onclick="pf_regist('${key}', 'B')" class="btn btnSmall_write btn-default">${not empty model.AP_BUTTON_TEXT1 ? model.AP_BUTTON_TEXT1 : '예매예정'}</button>
			    			</c:if>
		    				<c:if test="${model.AP_APPLY_ST_DATE <= now_date && now_date <= model.AP_APPLY_EN_DATE }">
			    				<button type="button" onclick="pf_regist('${key}', 'G')" class="btn btnSmall_write btn-default">${not empty model.AP_BUTTON_TEXT2  ? model.AP_BUTTON_TEXT2 : '예매하기'}</button>
			    			</c:if>
		    				<c:if test="${model.AP_APPLY_EN_DATE < now_date}">
			    				<button type="button" onclick="pf_regist('${key}', 'E')" class="btn btnSmall_write btn-default">${not empty model.AP_BUTTON_TEXT3  ? model.AP_BUTTON_TEXT3 : '마감'}</button>
			    			</c:if>
			    		</c:if>
			    			
		    			<c:if test="${not empty model.AP_APPLY_ST_DATE && empty model.AP_APPLY_EN_DATE }">	<!-- 예매시작 O, 예매종료 X -->
		    				<c:if test="${now_date < model.AP_APPLY_ST_DATE }">
			    				<button type="button" onclick="pf_regist('${key}', 'B')" class="btn btnSmall_write btn-default">${not empty model.AP_BUTTON_TEXT1 ? model.AP_BUTTON_TEXT1 : '예매예정'}</button>
			    			</c:if>
		    				<c:if test="${model.AP_APPLY_ST_DATE <= now_date && now_date <= model.AP_ENDT }">
			    				<button type="button" onclick="pf_regist('${key}', 'G')" class="btn btnSmall_write btn-default">${not empty model.AP_BUTTON_TEXT2  ? model.AP_BUTTON_TEXT2 : '예매하기'}</button>
			    			</c:if>
		    				<c:if test="${model.AP_ENDT < now_date}">
			    				<button type="button" onclick="pf_regist('${key}', 'E')" class="btn btnSmall_write btn-default">${not empty model.AP_BUTTON_TEXT3  ? model.AP_BUTTON_TEXT3 : '마감'}</button>
			    			</c:if>
			    		</c:if>
			    			
		    			<c:if test="${empty model.AP_APPLY_ST_DATE && not empty model.AP_APPLY_EN_DATE }">	<!-- 예매시작 X, 예매종료 O -->
		    				<c:if test="${now_date < model.AP_STDT }">
			    				<button type="button" onclick="pf_regist('${key}', 'B')" class="btn btnSmall_write btn-default">${not empty model.AP_BUTTON_TEXT1 ? model.AP_BUTTON_TEXT1 : '예매예정'}</button>
			    			</c:if>
		    				<c:if test="${model.AP_STDT <= now_date && now_date <= model.AP_APPLY_EN_DATE }">
			    				<button type="button" onclick="pf_regist('${key}', 'G')" class="btn btnSmall_write btn-default">${not empty model.AP_BUTTON_TEXT2  ? model.AP_BUTTON_TEXT2 : '예매하기'}</button>
			    			</c:if>
		    				<c:if test="${model.AP_APPLY_EN_DATE < now_date}">
			    				<button type="button" onclick="pf_regist('${key}', 'E')" class="btn btnSmall_write btn-default">${not empty model.AP_BUTTON_TEXT3  ? model.AP_BUTTON_TEXT3 : '마감'}</button>
			    			</c:if>
			    		</c:if>
			    			
		    			<c:if test="${empty model.AP_APPLY_ST_DATE && empty model.AP_APPLY_EN_DATE }">	<!-- 예매시작 X, 예매종료 X -->
		    				<c:if test="${now_date < model.AP_STDT }">
			    				<button type="button" onclick="pf_regist('${key}', 'B')" class="btn btnSmall_write btn-default">${not empty model.AP_BUTTON_TEXT1 ? model.AP_BUTTON_TEXT1 : '예매예정'}</button>
			    			</c:if>
		    				<c:if test="${model.AP_STDT <= now_date && now_date <= model.AP_ENDT }">
			    				<button type="button" onclick="pf_regist('${key}', 'G')" class="btn btnSmall_write btn-default">${not empty model.AP_BUTTON_TEXT2  ? model.AP_BUTTON_TEXT2 : '예매하기'}</button>
			    			</c:if>
		    				<c:if test="${model.AP_ENDT < now_date}">
			    				<button type="button" onclick="pf_regist('${key}', 'E')" class="btn btnSmall_write btn-default">${not empty model.AP_BUTTON_TEXT3  ? model.AP_BUTTON_TEXT3 : '마감'}</button>
			    			</c:if>
			    		</c:if>
    				</c:if>
    				
    				<c:if test="${model.AP_DEADLINE == 'Y'}">	<!-- 강제마감이면 무조건 마감표시 -->
	    				<button type="button" onclick="pf_regist('${key}', 'E')" class="btn btnSmall_write btn-default">${not empty model.AP_BUTTON_TEXT3  ? model.AP_BUTTON_TEXT3 : '마감'}</button>
    				</c:if>
    			
    		</div>
    		<pre class="summary">${model.AP_SUMMARY }</pre>
    		<div class="list_etc">
	    		<div class="date">${model.AP_DATE_COMMENT }</div>
		    		<div class="place"><c:out value="${model.PM_NAME}"/>
			    		<a href="javascritp:;" onclick="pf_imgView('${model.PM_NAME}', '${model.FS_PATH}');">
				    		<img class="placeMarker" src="/resources/img/calendar/detail_spot.png" alt="place_marker" style="margin-left: 5px;">
			    		</a>
		    		</div>
    		</div>
    		
    		<div class="list_etc2">
    			<p class="price">
    				<c:choose>
    					<c:when test="${model.AP_PRICE == '0'}">
    						무료
    					</c:when>
    					<c:otherwise>
			    			<fmt:formatNumber value="${model.AP_PRICE }" type="number"/>원
    					</c:otherwise>
    				</c:choose>
    			</p>
    		</div>
    	</li>
    	</c:forEach>
    </ul>
<!-- 팝업 창 -->
<div id="tour_contents_pop_box" tabindex="0">
	<div id="tour_contents_bg_box"></div>
	<div class="pop-container"> 
		<div class="pop-conts">
			<div class="contents_pop_header"> 
				<div class="contents_pop_title">티켓예매</div>
				<a href="javascript:;" class="contents_pop_cbtn">
					<img src="/resources/img/calendar/close_btn.gif" alt="닫기">
				</a>
			</div>
			<iframe id="ticket_frame" class="contents_pop_body" scrolling="no" >
					
			</iframe>      
			<div class="contents_pop_footer"></div>   
		</div>
	</div>
</div> 
<div id="pop_bg_opacity"></div>
<script>
var ScheduleCnt = 1;
var scheduleList = [];
var ProgramSchdule = new Array();
var setMonth = new Date().getMonth() + 1;
var selectedKey;
var nowStD;
var lastday;
var keyurl = "";
var typeApply = '${sp:getData("PROGRAM_APPLY")}';
var typeLecture = '${sp:getData("PROGRAM_LECTURE")}';

$(function(){
	$(".t_m_menu").find(".t_m_menu_li:nth-child(2)").addClass("bb1");
	$(".t_m_menu").find(".t_m_menu_li:nth-child(1)").find("li").addClass("now-pagee");
});

//신청하기 버튼
function pf_regist(key, type){
	var AP_TYPE = $("#APType").val();
	if(type == 'B'){
		alert("예매 시작전입니다.");
		return false;
	}else if(type == 'E'){
		alert("마감 된 프로그램입니다.");
		return false;
	}else if(type == 'G'){
		if ("${userInfo.UI_ID}" == null || "${userInfo.UI_ID}" == '') {
			if (confirm("로그인이 필요합니다. 확인 버튼을 누르시면 로그인페이지로 이동합니다.")) {
				location.href = "/user/member/login.do?tiles=cf";
				return;
			}
			return false;
		}
		selectedKey = key;
		var	url = "/dy/function/program/iframe.do";
		
		
			keyurl = url;
			keyurl = url + "?key=" + selectedKey + "&type="+AP_TYPE;
			
			$("#ticket_frame").attr("src", keyurl); 
			$("#ticket_frame").submit(); 

			if(AP_TYPE == '${sp:getData("PROGRAM_APPLY")}'){
				$(".contents_pop_title").text("티켓예매");
			}else if(AP_TYPE == '${sp:getData("PROGRAM_LECTURE")}'){
				$(".contents_pop_title").text("수강신청");				
			}
			//투명막씌우기
			$(".contents_pop_footer").show();
			$("#pop_bg_opacity").show();
			$("#tour_contents_pop_box").show(); 
			$("html").css("overflow-y", "hidden");
			$("body").css("overflow-y", "hidden");
			var temp = $("#tour_contents_pop_box");
			
			// 화면의 중앙에 레이어를 띄운다.  
			if (temp.outerHeight() < $(document).height() ) temp.css('margin-top', '-'+temp.outerHeight()/2+'px');
			else temp.css('top', '0px');
			if (temp.outerWidth() < $(document).width() ) temp.css('margin-left', '-'+temp.outerWidth()/2+'px');
			else temp.css('left', '0px');
			
			// 전당투어 달력 레이어팝업 닫기 처리
			temp.find('a.contents_pop_cbtn').click(function(e){ 
				pf_close()
			}); 
			$("#tour_contents_pop_box").focus();
	
	}
}

function pf_close(){
		$("html").css("overflow-y", "");
		$("body").css("overflow-y", ""); 
		$("#pop_bg_opacity").fadeOut(); 
		$("#tour_contents_pop_box").hide();   
		//기존에는 페이지로드시 달력을 세팅했지만 버튼별 캘린더 세팅이 달라 캘린더를 초기화함
}

function pf_imgView(name, path){
	if(path){
		$(".pop_title").text(name);
		$("#placeImg").attr("src", path);
		$("#credit_pop").show();
		var windowWidth = $(window).width() / 2;
		var windowHeight = $(window).height() / 2;
		var width =$("#credit_pop").width() /2; 
		var height = $("#credit_pop").height() /2;
		$("#credit_pop").css({
			top : windowHeight - height,
			left : windowWidth - width
		});
		
	}
}
function pf_pop_close(){
	$("#credit_pop").hide();
}

</script>