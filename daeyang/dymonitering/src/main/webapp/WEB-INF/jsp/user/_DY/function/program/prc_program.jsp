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
<script type="text/javascript" src="/resources/api/FrontMArte/js/json2.js"></script>
<script type="text/javascript" src="/resources/api/FrontMArte/js/comm.js"></script>
<script type="text/javascript" src="/resources/api/FrontMArte/js/security.js"></script> 
<script type="text/javascript" src="/resources/api/FrontMArte/js/fn_booking_date_seq.js"></script>
<script src="/resources/smartadmin/js/plugin/moment/moment.min.js"></script>

<link rel="stylesheet" type="text/css" href="/resources/common/css/program.css">
<script type="text/javascript" src="/resources/common/js/program.js"></script>

	<div id="credit_pop" class="place_pop_layer">
		<div class="pop_container"> 
			<div class="pop_title">장소이름</div> 
			<a href="javascript:;" class="cbtn" title="닫기" onclick="pf_pop_close();">
				<img src="/resources/img/calendar/btn_close_gray.png" alt="닫기">
			</a>   
			<div class="pop_conts">
				 <a href="javascript:;">
				 	<img id="placeImg" width="400" height="250">
				 </a>
			</div>
		</div>
	</div>

    <ul id="programPageUl">    	
    <!-- 반복시작  -->
		<c:if test="${empty resultList }">
			<div class="one">
				<span>검색된 데이터가 없습니다.</span>
			</dib>
		</c:if>
		
        <c:forEach items="${resultList }" var="model">
        <input type="hidden" value="${model.AP_TYPE }" id="APType">
            <div class="one"> <!-- one -->
                    <div class="letter-box">
                        <p class="date-p">
                            <span class="sq">행사기간</span>
                            <span class="txt"><c:out value="${model.AP_STDT}"/> ~ <c:out value="${model.AP_ENDT}"/></span>
                        </p>
                        <p class="title">${model.AP_NAME}</p>
						<div class="applyBtn">
								<button type="button" onclick="pf_regist('${model.AP_KEYNO}', '${model.reserve_type}')" class="btn btnSmall_write btn-default">
								<span class="icon"><i class="xi-check-min"></i></span>
								<span class="txt"><c:out value="${model.buttonText }"/></span>
								</button>
						</div>
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
            </div> <!-- oneEND -->
    	</c:forEach>
	<!-- 반복끝  -->
    	
    </ul>
<!-- 팝업 창 -->
<div id="program_contents_pop_box" tabindex="0">
	<div class="pop-container"> 
		<div class="pop-conts">
			<div class="contents_pop_header"> 
				<div class="contents_pop_title"></div>
				<a href="javascript:;" class="contents_pop_cbtn" onclick="pf_close('program_contents_pop_box')">
					<img src="/resources/img/calendar/close_btn.gif" alt="닫기">
				</a>
			</div>
			<div id="ticket_frame" class="contents_pop_body" scrolling="no" >
			</div>      
			<div class="contents_pop_footer"></div>   
		</div>
	</div>
</div> 
<div class="black-reserved-popUp"></div>
<script>
var selectedKey;
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
				location.href = "/${currentTiles}/member/login.do";
				return;
			}
			return false;
		}
		selectedKey = key;
		var	url = "/${currentTiles}/function/program/iframeAjax.do";
		keyurl = url;
		keyurl = url + "?key=" + selectedKey + "&type="+AP_TYPE;
		
		 $.ajax({
		        url: keyurl,
		        type: 'POST',
		        async: false,  
		        success: function(data) {

		        	if(AP_TYPE == '${sp:getData("PROGRAM_APPLY")}'){
						$(".contents_pop_title").text("티켓예매");
					}else if(AP_TYPE == '${sp:getData("PROGRAM_LECTURE")}'){
						$(".contents_pop_title").text("수강신청");				
					}
		        	
					$("#ticket_frame").html(data);
					
 					//투명막씌우기
					$('.black-reserved-popUp').fadeIn();
					$("#program_contents_pop_box").show(); 
					
					$("#program_contents_pop_box").focus();
					
		       },
		       error: function(){
		    	   alert('에러, 관리자에게 문의하세요.');
		    	   return false;S
		       }
		   })
	}
}

function pf_close(id){
	$("#"+id).hide();   
	if(id == 'program_contents_pop_box'){
		$('.black-reserved-popUp').fadeOut();
	}	
}

//장소 팝업 띄우기
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

//티켓할인 설명 닫기
function fn_bPopup_close(){
	$("#pop_viewContant").fadeOut();
}
</script>