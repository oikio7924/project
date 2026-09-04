<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<script src="/resources/api/mask/jquery.mask.js"></script>

<!-- 수강신청 폼 -->
<form id="Form" method="post">
	<input type="hidden" name="APP_AP_KEYNO" id="APP_AP_KEYNO"  value=""/>
	<input type="hidden" name="APP_ASM_KEYNO" id="APP_ASM_KEYNO"  value=""/>
	<input type="hidden" name="APP_ASS_KEYNO" id="APP_ASS_KEYNO"  value=""/>
	<input type="hidden" name="APP_APU_KEYNO" id="APP_APU_KEYNO"  value=""/>
	<input type="hidden" name="APP_ST_DATE" id="APP_ST_DATE"  value=""/>
	<input type="hidden" name="APP_ST_TIME" id="APP_ST_TIME"  value=""/>
	<input type="hidden" name="APP_COUNT" id="APP_COUNT"  value=""/>
	<input type="hidden" name="APP_SEQUENCE" id="APP_SEQUENCE"  value=""/>
	<input type="hidden" name="AP_PRICE" id="AP_PRICE"  value=""/>
	<input type="hidden" name="APP_DIVISION" id="APP_DIVISION"/>
	<input type="hidden" name="APP_EXPIRED" id="APP_EXPIRED"/>
	
	<input type="hidden" name="APD_AD_KEYNO" id="APD_AD_KEYNO"  value=""/>
	<input type="hidden" name="APD_CNT" id="APD_CNT"  value=""/>
	<input type="hidden" name="APD_PRICE" id="APD_PRICE"  value=""/>
	<input type="hidden" name="App_type" id="App_type" value=""/>
</form>

<!-- 수강대상자 폼 -->
<form:form id="UserForm" method="post">
	<input type="hidden" name="APU_UI_KEYNO" id="APU_UI_KEYNO" value="${userInfo.UI_KEYNO }">
	<input type="hidden" name="APU_NAME" id="APU_NAME" value="">
	<input type="hidden" name="APU_RELATION" id="APU_RELATION"  value="">
	<input type="hidden" name="APU_PHONE" id="APU_PHONE"  value="">
	<input type="hidden" name="APU_BIRTH" id="APU_BIRTH"  value="">
	<input type="hidden" name="APU_GENDER" id="APU_GENDER"  value="">
</form:form>

<div class="lecture_popup_contentWrap">
	<div class="tableWrap">
		<h2 class="dis-h5" style="width: 100%; margin: 15px 0 0 10px;"><span class="line-h5"></span>신청강좌내역</h2>
		<table id="lectureTable" class="lecturetable">
			<caption>신청강좌내역 테이블</caption>
			<colgroup>
				<col width="25%">
				<col width="25%">
				<col width="25%">
				<col width="25%">
			</colgroup>
			<thead>
				<tr>
					<th>강좌명</th>
					<td colspan="3"><c:out value="${resultData.AP_NAME}"/></td>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>교육기간</td>
					<td><c:out value="${resultData.AP_DATE_COMMENT }"/></td>
					<td>나이제한</td>
					<td>
					<c:if test="${resultData.AP_LIMIT_AGE_YN == 'Y'}">
						<c:out value="${resultData.AP_LIMIT_AGE_MIN }"/> - <c:out value="${resultData.AP_LIMIT_AGE_MAX }"/>세
					</c:if>
					<c:if test="${resultData.AP_LIMIT_AGE_YN == 'N'}">
						제한없음
					</c:if>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<div class="tableWrap">
		<h2 class="dis-h5" style="width: 100%; margin: 15px 0 0 10px;"><span class="line-h5"></span>수강신청</h2>
		<div>
			<div class="now_listed_inner" style="width: 280px; height: 264px; float: left;">
				<div id="calendar_div"></div> 
			</div>
			<div style="width: calc(100% - 300px); margin-left: 20px; float: left;">
				<div style="overflow-y: scroll; height: 100px;">
					<table class="lecturetable slide_table3">
						<caption>시간테이블</caption>
						<colgroup>
							<col width="25%">
							<col width="25%">
							<col width="15%">
							<col width="15%">
							<col width="20%">
						</colgroup>
						<thead>
							<tr>
								<th>클래스</th>
								<th>시간</th>
								<th>정원</th>
								<th>잔여</th>
								<th>상태</th>
							</tr>
						</thead>
						<tbody id="ListBox">
						</tbody>
					</table>
				</div>
				
				<div style="margin-top: 30px; overflow-y:scroll; height: 100px;">
					<table class="lecturetable slide_table3">
						<caption>요금테이블</caption>
						<colgroup>
							<col width="40%">
							<col width="30%">
							<col width="30%">
						</colgroup>
						<thead>
							<tr>
								<th>요금명</th>
								<th>수강료</th>
								<th>대상</th>
							</tr>
						</thead>
						<tbody class="saleListBox" >
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="clear"></div>
		<div id="pop_viewContant" class="pop_viewCon ticketInfo">
			<div class="inbox">
				<h4>티켓 안내 <span class="fn_right red" onclick="javascript:fn_bPopup_close();">X</span></h4>
				<pre class="tab_dl">
				</pre>
			</div>
	    </div>
	</div>
	
	<div class="tableWrap" style="position: relative;">
		<div class="usertitleWrap">
			<h2 class="dis-h5" style="width: 100%; margin: 15px 0 0 10px;"><span class="line-h5"></span>수강대상자 지정</h2>
			<div style="position: absolute; right: 0; top:25px;">
				<button id="userDelete" onclick="pf_lectureUserDelete();">수강대상자 삭제</button>
				<button id="userAdd" onclick="pf_lectureUserAdd();">수강대상자 추가등록</button>
			</div>
		</div>
		<div class="userTableWrap">
			<table class="lecturetable" >
				<caption>수강대상자 지정 테이블</caption>
				<colgroup>
					<col width="10%">
					<col width="40%">
					<col width="10%">
					<col width="20%">
					<col width="20%">
				</colgroup>
				<thead>
					<tr>
						<th>선택</th>
						<th>이름</th>
						<th>관계</th>
						<th>휴대폰</th>
						<th>생년월일</th>
					</tr>
				</thead>
				<tbody id="userList">
					<c:forEach items="${userList }" var="model">
					<c:set value="${fn:substring(model.APU_BIRTH, 0, 4)  }" var="birthYear" />
					<c:set value="${nowYear - birthYear + 1}" var="Nai" />
						<tr class="yesContent">
							<fmt:parseNumber value="${model.APU_KEYNO}" integerOnly="true" var="key"/>
							<c:set var="checkAge" value="${resultData.AP_LIMIT_AGE_YN == 'Y' && (resultData.AP_LIMIT_AGE_MIN > Nai || resultData.AP_LIMIT_AGE_MAX < Nai )}"/>
							<td>
							<input type="radio" name="userSelect" value="${key }" ${checkAge ? 'disabled="disabled"':'' } />
							<input type="hidden" id="selfYN" value="${model.APU_SELFYN }"/></td>
							<td><c:out value="${model.APU_NAME }"/>
							<c:if test="${checkAge}">
								<font color="red">(신청가능한 나이가 아닙니다.)</font>
							</c:if>
							</td>
							<td><c:out value="${model.APU_RELATION }"/></td>
							<td><c:out value="${model.APU_PHONE }"/></td>
							<td><c:out value="${model.APU_BIRTH }"/></td>
							
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
	
	<div class="popup-bottom-btn" style="margin-top: 10px;">
		<button class="btn-popup-sav" onclick="pf_lectureInsert();">신청하기</button>
		<button class="btn-popup-cancel" onclick="pf_close('program_contents_pop_box');">취소하기</button>
	</div>
</div>

<!-- 수강대상자 등록 -->
<div id="lecture_contents_pop_box" tabindex="0">
	<div class="pop-container"> 
		<div class="pop-conts">
			<div class="contents_pop_header"> 
				<div class="contents_pop_title">수강대상자 등록</div>
				<a href="javascript:;" class="contents_pop_cbtn" onclick="pf_close('lecture_contents_pop_box')" style="text-align: right;">
					<img src="/resources/img/calendar/close_btn.gif" alt="닫기" style="max-width: 70%;">
				</a>
			</div>
			<div>
				<h2 class="dis-h5" style="margin: 15px 0 0 10px;"><span class="line-h5"></span>수강생 정보를 입력 해 주세요</h2>
				<div class="tableWrap">
					<table class="UserTable">
						<caption>수강생등록 테이블</caption>
						<colgroup>
							<col width="40%">
							<col width="60%">
						</colgroup>
							<tbody>
								<tr>
									<th>이름</th>
									<td><input type="text" id="APUNAME" class="userAdd" maxlength="25"/></td>
								</tr>	
								<tr>
									<th>성별</th>
									<td>
										<label for="GENDER_M">
											<input type="radio" id="GENDER_M" name="GENDER" value="M"/>남자
										</label>
										<label for="GENDER_W">
											<input type="radio" id="GENDER_W" name="GENDER" value="W"/>여자
										</label>
									</td>
								</tr>	
								<tr>
									<th>관계</th>
									<td>
										<label for="RELATION_C">
											<input type="radio" id="RELATION_C"  name="RELATION" value="자녀"/>자녀
										</label>
										<label for="RELATION_P">
											<input type="radio" id="RELATION_P"  name="RELATION" value="배우자"/>배우자
										</label>
										<label for="RELATION_E">
											<input type="radio" id="RELATION_E"  name="RELATION" value="기타"/>기타
										</label>
									</td>
								</tr>	
								<tr>
									<th>휴대폰 번호</th>
									<td>
										<input class="userAdd" id="APUPHONE" type="text" placeholder="ex) 000-0000-0000" onkeyup="cf_autoHypenPhone(this,this.value)" maxlength="13"/>
									</td>
								</tr>	
								<tr>
									<th>생년월일</th>
									<td>
										<input class="userAdd" id="APUBIRTH" type="text" placeholder="ex) 1999-01-01" onblur="pf_birth();"/>
									</td>
								</tr>	
							</tbody>
					</table>
					<div class="popup-bottom-btn mt20">
			            <button type="button" class="btn-popup-sav focusPoint" onclick="javascript:family_regist('${userInfo.UI_KEYNO }');">저장</button>
			        </div>
				</div>
			</div>
			<div class="contents_pop_footer"></div>   
		</div>
	</div>
</div> 
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
var charge_expired = '${resultData.AP_EXPIRED}'
var now_date = '${now_date}'

var AGE_YN = '${resultData.AP_LIMIT_AGE_YN}'
var AGE_MIN = parseInt('${resultData.AP_LIMIT_AGE_MIN}');
var AGE_MAX = parseInt('${resultData.AP_LIMIT_AGE_MAX}');
var nowYear = parseInt('${nowYear};');

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
	
	$("#calendar_div").showCalendar(setMonth);
	
	$(".step1").show();
	$(".step2, .step3, .step4, .step5").hide();	
	
	$("#lecture_contents_pop_box").focus();
	
	$("#APUBIRTH").mask('0000-00-00');
	
	
	
});

function SetSchedule(getDate){
	$("#APP_AP_KEYNO").val(selectedKey);
	nowStD = dateToString(new Date(getDate+"-01"));	//그 달의 첫날
	lastday = lastDay(getDate+"-01");			//마지막일자 및 변수값세팅
	$.ajax({
	    type   : "post",
	    url    : "/dy/function/programApplyAjax.do",
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
	    	var holiday   = dataes.holidayList;
	    	scheduleList = data;
	    	holidayList = holiday;
	    	$("#focusId").text("["+mainTitle+"]");
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
	var schedule = $(td).addClass("holiday");
	
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

//날짜 클릭했을때
function pf_selected(date,obj){

	$("#APP_ST_DATE").val(date);	//input안에 시작날짜 넣기
	
	if(!$(obj).hasClass('hasEvent')){
		$("#ListBox").html("<tr class='noContent'><td colspan='5' class='table3_bor_b_gray'>데이터가 없습니다.</td></tr>");
		$(".slide_table3").hide().show("slide", { direction: "left" }, 500);
		return false;
	}

	//배경색 바꾸기
	$("#ListBox").find('.yesContent').remove();
	$("#ListBox").find('.noContent').remove();
	$('.tronixTd').removeClass('onSelected');
	$(obj).addClass("onSelected");
	
	$("#APP_SEQUENCE").val("");
	
	$.ajax({
	    type   : "post",
	    url    : "/dy/function/programTimeAjax.do",
	    data   : {
		    "key":selectedKey,
		    "date":date,
	    },
	    async:false,
	    success:function(data){
	    	if(data.length == 0){
	    		$("#ListBox").html("<tr class='noContent'><td colspan='5' class='table3_bor_b_gray'>데이터가 없습니다.</td></tr>");
	    	}else{
	    		var timeList = [];
	    		timeList = data;
	    		
	    		var now = new Date();
				var today = new Date(now.getFullYear(), now.getMonth(), now.getDate(), now.getHours(), now.getMinutes());
				today = today.getFullYear()+"-"+cf_setTwoDigit(today.getMonth()+1)+"-"+cf_setTwoDigit(today.getDate())+" "+cf_setTwoDigit(today.getHours())+":"+cf_setTwoDigit(today.getMinutes());
	    	
				$.each(timeList, function(i){
	    			var times = timeList[i];
	    			var lectureTime = times.ST_DATE+" "+times.ST_TIME;
	    			var temp = '<tr class="yesContent">';
	    				if(lectureTime > today){
		    				if(times.title == '신청가능'){
			    				temp += '<td><input type="radio" name="timeList"/><span class="Apply_turn">${resultData.AP_NAME }</span></td>';	    					
		    				}else{
			    				temp += '<td><input type="radio" name="timeList"/><span class="Apply_turn">'+times.title+'</span></td>';	    						    					
		    				}
	    				}else if(lectureTime < today){
	    					temp += '<td><input type="radio" disabled="disabled"/><span class="Apply_turn">${resultData.AP_NAME }</span></td>';	   
		    			}	
		    				temp += '<td><span class="Apply_turn startTime">'+times.ST_TIME+'</span></td>';
		    				temp += '<td style="text-overflow:ellipsis;overflow:hidden;white-space: nowrap;"><span class="Apply_conut">'+times.totalcnt+'</span></td>';	
		    				if(times.cnt > 0){
			    				temp += '<td style="text-overflow:ellipsis;overflow:hidden;white-space: nowrap;"><span class="Apply_conut remainCnt">'+times.cnt+'</span></td>';    	    					
		    				}else{
			    				temp += '<td style="text-overflow:ellipsis;overflow:hidden;white-space: nowrap;"><span class="Apply_conut remainCnt"><font color="red">(대기자접수중)</font></span></td>';    	    						    					
		    				}
	    				if(lectureTime > today){		
		    				temp += '<td style="text-overflow:ellipsis;overflow:hidden;white-space: nowrap;"><span class="Apply_conut">신청가능일</span></td>';	
	    				}else if(lectureTime < today){
	    					temp += '<td style="text-overflow:ellipsis;overflow:hidden;white-space: nowrap;"><span class="Apply_conut" style="color:red">(접수마감)</span></td>';	   
		    			}
		    				temp += '<input type="hidden" class="ASM_KEY" value="'+times.ASM_KEYNO+'"/>';
		    				temp += '<input type="hidden" class="ASS_KEY" value="'+times.ASS_KEYNO+'"/>';
		    				temp += '</tr>'	    					
		    			
	    			
	    			$("#ListBox").append(temp);
    				$("input:radio[name='timeList']:first").prop("checked","checked");

	    		});
	    	}
	    },
	    error: function() {
	    	alert("에러");
	    }
	});
	
	$.ajax({
	    type   : "post",
	    url    : "/dy/function/programChargeAjax.do",
	    data   : {
		    "key":selectedKey,
	    },
	    async:false,
	    success:function(data){
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
	    		
	    		$(".saleListBox").find("tr").remove();	//요금제 리셋시키고 다시 붙여넣기
	    		if(origin_price > 0){	//유료강좌
					$.each(saleList, function(i){
						sales = saleList[i];
						
						var adkey = sales.AD_KEYNO;
						var key = cf_setKeyno(sales.AD_KEYNO);
						var newId = cf_getNewKeyno(key, "T", "A");
						var tmp = cf_getNewKeyno(key,"", "B");
						var notmp = cf_getNewKeyno(key,"", "C");
						var number = cf_getNewKeyno(key,"", "D");
						
						var name = sales.AD_NAME;							//할인이름
						var discountType = sales.AD_TYPE					//할인 유형
						var origin_dis = sales.AD_MONEY		
						var discount = numberFormat(origin_dis);			//할인율
						
						var calc = origin_price * (1 - (origin_dis / 100))	//할인계산
						var calc_won = origin_price-origin_dis				//할인계산(원)
						if(calc_won < 0){calc_won = 0;}
						
	   					var temp =  '<tr class="yesContent">';
	   						
	   						temp += '<td><input type="radio" name="discount" value="'+adkey+'"/>';	//요금명
		   						if(discountType == 'C'){	//일반
	// 								temp += ''+name+'';							
									temp += '<span class="Apply_turn">${resultData.AP_NAME }</span>';							
								}else if(discountType == 'A'){	//퍼센트
									temp += ''+name+'('+discount+'%)';	
									temp += '<span class="fr" style="cursor:pointer">';
									
									temp += '<img src="/resources/img/calendar/ticket_discount_info_2.jpg" onclick="pf_saleComent(\''+adkey+'\');">';
									temp += '</span>';
								}else if(discountType == 'B'){	//원
									temp += ''+name+'('+discount+'원)';
									temp += '<span class="fr" style="cursor:pointer">';
									temp += '<img src="/resources/img/calendar/ticket_discount_info_2.jpg"  onclick="pf_saleComent(\''+adkey+'\');">';
									temp += '</span>';
								}
	   						temp += '</td>'
	   						temp += '<td class="lecturePrice">';	//수강료
	   							if(discountType == 'C'){
									temp += '<span class="russia">'+price+'</span>&nbsp;원';							
								}else if(discountType == 'A'){
									temp += '<span class="russia">'+numberFormat(Math.ceil(calc))+'</span>&nbsp;원';							
								}else if(discountType == 'B'){
									temp += '<span class="russia">'+numberFormat(calc_won)+'</span>&nbsp;원';												
								}
	   						temp += '</td>';
							temp +=  '<td>무료회원</td>'; 			//대상
							
							temp +=  '</tr>';
							
						$(".saleListBox").append(temp);
						$("input:radio[name='discount']:first").prop("checked","checked");
					});
	    		}else if(origin_price <= 0){	//무료강좌
	    			var temp =  '<tr class="yesContent">';
						temp += '<td><input type="radio" name="discount" value="'+saleList[0].AD_KEYNO+'"/>';	//요금명
						temp += '<span class="Apply_turn">${resultData.AP_NAME }</span>';							
						temp += '</td>'
						temp += '<td class="lecturePrice">';	//수강료
						temp += '<span class="russia">'+price+'</span>&nbsp;원';							
						temp += '</td>';
						temp +=  '<td>무료회원</td>'; 			//대상
						temp +=  '</tr>';
						
					$(".saleListBox").append(temp);
					$("input:radio[name='discount']:first").prop("checked","checked");
	    		}
				$(".slide_table3").hide().show("slide", { direction: "left" }, 500);
	    },
	    error: function() {
	    	alert("에러");
	    }
	});
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

//수강대상자 등록 팝업
function pf_lectureUserAdd(){
	$(".userAdd").val("");
	$("input[name=RELATION]").prop("checked", false);
	$("input[name=GENDER]").prop("checked", false);
	$("#lecture_contents_pop_box").show(); 
	var temp = $("#lecture_contents_pop_box");
	
// 	// 화면의 중앙에 레이어를 띄운다.  
	if (temp.outerHeight() < $(document).height() ) temp.css('margin-top', '-'+temp.outerHeight()/2+'px');
	else temp.css('top', '0px');
	if (temp.outerWidth() < $(document).width() ) temp.css('margin-left', '-'+temp.outerWidth()/2+'px');
	else temp.css('left', '0px');
	
	$("#lecture_contents_pop_box").focus();
}

//수강생 추가
function family_regist(key){
	var gender = $(':input[name=GENDER]:radio:checked').val();
	var relation = $(':input[name=RELATION]:radio:checked').val();
	if(!$("#APUNAME").val()){
		alert("이름을 입력해주세요.");
		$("#APUNAME").focus();
		return false;
	}
	if(!gender){
		alert("성별을 선택해주세요.");
		return false;
	}
	if(!relation){
		alert("관계를 선택해주세요.");
		return false;
	}
	if(!$("#APUPHONE").val()){
		alert("휴대폰 번호를 입력해주세요.");
		$("#APUPHONE").focus();
		return false;
	}
	if(!$("#APUBIRTH").val()){
		alert("생년월일을 입력해주세요.");
		$("#APUBIRTH").focus();
		return false;
	}
	$("#APU_NAME").val($("#APUNAME").val());
	$("#APU_RELATION").val(relation);
	$("#APU_PHONE").val($("#APUPHONE").val());
	$("#APU_BIRTH").val($("#APUBIRTH").val());
	$("#APU_GENDER").val(gender);
	$.ajax({
	    type   : "POST",
	    url    : "/dy/function/userInsertAjax.do",
	    data   : $("#UserForm").serialize(),
	    async:false,
	    success:function(data){
	    	var birthyear = parseInt(data.APU_BIRTH.substr(0,4));
	    	var Nai = nowYear - birthyear + 1;
	    	var checkAge = (AGE_YN == 'Y' && (AGE_MIN > Nai || AGE_MAX < Nai));
	    	$("html").css("overflow-y", "");
			$("body").css("overflow-y", ""); 
			$("#pop_bg_opacity").fadeOut(); 
			$("#lecture_contents_pop_box").hide();  
			var apukey = cf_setKeyno(data.APU_KEYNO);
			var temp = '<tr class="yesContent">';
				temp += '<td><input type="radio" name="userSelect" value="'+apukey+'"'+ (checkAge ? ' disabled="disabled"':'') + '><input type="hidden" id="selfYN" value='+data.APU_SELFYN+'></td>';
				temp += '<td>'+data.APU_NAME;
				if(checkAge){
					temp += '<font color="red">(신청가능한 나이가 아닙니다.)</font>'
				}
				temp += '</td>';
				temp += '<td>'+data.APU_RELATION+'</td>';
				temp += '<td>'+data.APU_PHONE+'</td>';
				temp += '<td>'+data.APU_BIRTH+'</td>';
			$("#userList").append(temp);
	    },
	    error: function() {
	    	alert("에러, 관리자에게 문의하세요.");
	    }
	});
}

//수강생 삭제
function pf_lectureUserDelete(){
	var radio = $(':input[name=userSelect]:radio:checked');
	$tr = radio.closest("tr");
	var self = $tr.find("#selfYN").val();
	var APU_key = radio.val();
	if(!APU_key){
		alert("수강대상자를 선택하세요.");
		return false;
	}
	if(self == "Y"){
		alert("자신은 삭제할 수 없습니다.");
		return false;
	}
	if(confirm("선택한 수강대상자를 삭제하시겠습니까?")){
		$.ajax({
		    type   : "POST",
		    url    : "/dy/function/userDeleteAjax.do",
		    data   : {
		    	"APU_KEYNO": APU_key
		    },
		    async:false,
		    success:function(data){
		    	radio.parents('tr').remove();
		    	alert("삭제되었습니다.")
		    },
		    error: function() {
		    	alert("에러, 관리자에게 문의하세요.");
		    }
		});
	}
}

//생년월일 유효성
function pf_birth(){
	var birth = $("#APUBIRTH").val();
	var format = /^(19[3-9][0-9]|20\d{2})-(0[0-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/;
    if(birth && !format.test(birth)){
     alert("유효하지 않습니다. \n생년월일은 1930-01-01부터 2099-12-31까지 입력 가능합니다.");
   	 $("#APUBIRTH").val('');
   	 $("#APUBIRTH").focus();
     return false;
    }
}

//요금할인 설명
function pf_saleComent(key){
	
	$.ajax({
		type : "POST",
		url : "/dy/function/program/SaleComentAjax.do",
		data : {
			"AD_KEYNO" : key
		},
		async:false,
		success : function(data){
			$(".inbox").find("pre").text(data);
			$("#pop_bg_opacity").show();
			$("#pop_viewContant").fadeIn();
		},
		error: function(){
			alert('알수없는 에러 발생. 관리자한테 문의하세요.')
			return false;
		}
	});
}

//설명 닫기
function fn_bPopup_close(){
	$("#pop_bg_opacity").fadeOut(); 
	$("#pop_viewContant").fadeOut();
}

//신청하기
function pf_lectureInsert(){
	var APP_expired = pf_expired(now_date, charge_expired);
	
	$TimeChecked = $("input[name=timeList]:radio:checked");		//시간
	$ChargeChecked = $("input[name=discount]:radio:checked");	//요금
	$UserChecked = $("input[name=userSelect]:radio:checked");	//수강자
	
	if(!$TimeChecked.val()){
		alert("선택된 강의가 없습니다.");
		return false;
	}
	
	if(!$UserChecked.val()){
		alert("수강대상자를 선택하세요.");
		return false;
	}
	
	$timeTr = $TimeChecked.closest("tr");
	
	$RemainCnt	= $timeTr.find(".remainCnt").text();	//잔여인원수
	var st_time = $timeTr.find(".startTime").text();
	var ASM_KEY = $timeTr.find(".ASM_KEY").val();
	var ASS_KEY = $timeTr.find(".ASS_KEY").val();

	$("#APP_EXPIRED").val(APP_expired);
	$("#APP_ST_TIME").val(st_time);
	$("#APP_ASM_KEYNO").val(ASM_KEY);
	$("#APP_ASS_KEYNO").val(ASS_KEY);
	$("#APP_COUNT").val('1');
	
	if($RemainCnt > 0){
		$("#App_type").val('N');
	}else if($RemainCnt == '(대기자접수중)'){	//대기자
		$("#App_type").val('W');
	}
	$chargeTr = $ChargeChecked.closest("tr");
	var price = $chargeTr.find(".lecturePrice span").text();
	
	$("#APD_AD_KEYNO").val($ChargeChecked.val());
	$("#APD_CNT").val('1');
	$("#APD_PRICE").val(unNumberFormat(price));
	
	var userKey = $UserChecked.val();
	$("#APP_APU_KEYNO").val(userKey);
	$("#AP_PRICE").val(selected_price);
	$("#APP_DIVISION").val('${sp:getData("PROGRAM_LECTURE")}');
	
// 	if($RemainCnt == '(대기자접수중)'){	//대기자
// 		if(confirm("대기자로 신청하시겠습니까?")){
			
// 		}else{
// 			return false;
// 		}
// 	}
	if(confirm("수강신청하시겠습니까?")){
		$.ajax({
		    type   : "POST",
		    url    : "/dy/function/programInsert.do",
		    data   : $("#Form").serialize(),
		    async:false,
		    success:function(data){
		    	if($RemainCnt != '(대기자접수중)'){	//대기자아님
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
		    error: function() {
		    	alert("에러, 관리자에게 문의하세요.");
		    	return false;
		    }
		});
	}
}
	

</script>