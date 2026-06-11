<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<style>
.artBoard{margin-top:2.5%;}

</style>

<form:form action="/dy/mobile.do" method="POST" id="Form">

<input type="hidden" id="DaliyType" name="DaliyType" value="${not empty DaliyType? DaliyType:'1' }">
<input type="hidden" id="InverterType" name="InverterType" value="${not empty InverterType? InverterType:'0' }">
<input type="hidden" id="keyno" name="keyno" value="${ob.DPP_KEYNO }">

    
    <!-- COMTAINER -->
    <div id="container">
        <section class="one_row left2">
	        <article class="artBoard mobile">
	            <h2 class="circle">설치현장선택</h2>
	
	            <p class="power_tit">[${ob.DPP_AREA }] ${ob.DPP_NAME }</p>
	
	            <div class="power_select">
	                <select class="select_nor select2 sm3 w100" id="DPP_KEYNO" name="DPP_KEYNO" value="${DPP_KEYNO }" onchange="DPPDataAjax(this.value);">
	                    <c:forEach items="${list }" var="list">
	                    	<option value="${list.DPP_KEYNO }" ${list.DPP_KEYNO eq DPP_KEYNO ? 'selected' : '' } >${list.DPP_NAME }</option>
	                    </c:forEach>
	                </select>
	            </div>
				
				<div class="power_select">
	                <select class="select_nor sm3 w100" id="InverterNum" name="InverterNum" value="${InverterNum }" onchange="ajaxData();" >
	                    <c:forEach varStatus="status" begin="1" end="${ob.DPP_INVER_COUNT }">
	                    	<c:choose>
		                    	<c:when test="${ob.DPP_KEYNO eq '93' }">
			                    	<c:if test="${status.index == 1}">
			                    	<option value="인버터 1호">한빛 1호</option>
			                    	</c:if>
			                    	<c:if test="${status.index == 2}">
			                    	<option value="인버터 2호">한빛 2호</option>
			                    	</c:if>
			                    	<c:if test="${status.index == 3}">
			                    	<option value="인버터 3호">한밭 1번</option>
			                    	</c:if>
			                    	<c:if test="${status.index == 4}">
			                    	<option value="인버터 4호">한밭 2번</option>
			                    	</c:if>
			                    	<c:if test="${status.index == 5}">
			                    	<option value="인버터 5호">한밭 3번</option>
			                    	</c:if>
			                    	<c:if test="${status.index == 6}">
			                    	<option value="인버터 6호">한밭 4번</option>
			                    	</c:if>
		                    	</c:when>
		                    	<c:when test="${ob.DPP_KEYNO eq '95' }">
			                    	<c:if test="${status.index == 1}">
			                    	<option value="인버터 1호">오남매 1호 1번</option>
			                    	</c:if>
			                    	<c:if test="${status.index == 2}">
			                    	<option value="인버터 2호">오남매 1호 2번</option>
			                    	</c:if>
			                    	<c:if test="${status.index == 3}">
			                    	<option value="인버터 3호">오남매 2호 1번</option>
			                    	</c:if>
			                    	<c:if test="${status.index == 4}">
			                    	<option value="인버터 4호">오남매 2호 2번</option>
			                    	</c:if>
			                    	<c:if test="${status.index == 5}">
			                    	<option value="인버터 5호">오남매 3호 1번</option>
			                    	</c:if>
			                    	<c:if test="${status.index == 6}">
			                    	<option value="인버터 6호">오남매 3호 2번</option>
			                    	</c:if>
			                    	<c:if test="${status.index == 7}">
			                    	<option value="인버터 7호">오남매 4호 1번</option>
			                    	</c:if>
			                    	<c:if test="${status.index == 8}">
			                    	<option value="인버터 8호">오남매 4호 2번</option>
			                    	</c:if>
			                    	<c:if test="${status.index == 9}">
			                    	<option value="인버터 9호">오남매 5호 1번</option>
			                    	</c:if>
		                    	</c:when>
		                    	<c:when test="${ob.DPP_KEYNO eq '96' }">
			                    	<c:if test="${status.index == 1}">
			                    	<option value="인버터 1호">하민 발전소</option>
			                    	</c:if>
			                    	<c:if test="${status.index == 2}">
			                    	<option value="인버터 2호">한결 발전소</option>
			                    	</c:if>
		                    	</c:when>
		                    	<c:when test="${ob.DPP_KEYNO eq '98' }">
			                    	<c:if test="${status.index == 1}">
			                    	<option value="인버터 1호">아라 1호 1번</option>
			                    	</c:if>
			                    	<c:if test="${status.index == 2}">
			                    	<option value="인버터 2호">아라 1호 2번</option>
			                    	</c:if>
			                    	<c:if test="${status.index == 3}">
			                    	<option value="인버터 3호">아라 1호 3번</option>
			                    	</c:if>
			                    	<c:if test="${status.index == 4}">
			                    	<option value="인버터 4호">아라 1호 4번</option>
			                    	</c:if>
			                    	<c:if test="${status.index == 5}">
			                    	<option value="인버터 5호">아라 2호 1번</option>
			                    	</c:if>
		                    	</c:when>
		                    	<c:otherwise>
		                    		<option value="인버터 ${status.count }호">인버터 ${status.count }호</option>
		                    	</c:otherwise>
	                    	</c:choose>
	                    </c:forEach>
	                </select>
	            </div>
					<c:choose>
                   		<c:when test="${ob.DPP_KEYNO eq '96' }">
                     		<h2 class="circle mgSm"><p id="inverterName" style="float:right;">[인버터 1호]</p>금일 발전량 | ${ob.DPP_NAME } </h2>
                     	</c:when>
                   	</c:choose>
                    
                     <div class="graph_b_gaue">
                         <div id="gauge_1" style="display: inline-block; width: 300px; height: 300px;"></div>
                         <div class="guage_txt" style="padding-bottom: 0px;">
                             <span>총 금일 발전량(%)</span>
                             <p><b id="AllPower" style="font-size: 1.1em;">0.0kWh / 0h</b></p>
                             <p style="text-align:center; color: gray;font-size: 5px;">* 발전량은 8시간 기준 <br> 100% 입니다.</p>
                         </div>
                     </div>
                     
                     <h2 class="circle mgSm">현재 발전량</h2>
                     
                     <div class="graph_b_gaue">
                         <div id="gauge_2" style="display: inline-block; width: 300px; height: 300px;"></div>
                         <div class="guage_txt">
                             <span>발전 전력</span>
                             <p><b id="Active">0.0</b></p>
                         </div>
                     </div>
				
	            <h2 class="location">발전소 현장정보</h2>
	
	            <div class="power_preview">
	                <!-- <div class="imgs" id="map" style="height: 200px"></div> -->
	            </div>
	
	            <p class="power_addr">${fn:substringAfter(ob.DPP_LOCATION,'//')}</p>
	
	            <ul class="power_info">
	                <li>
	                    <p class="lb battery">발전소 설비용량</p>
	                    <p class="rb"><span class="num">${ob.DPP_VOLUM }</span>kW</p>
	                </li>
	                
	                <c:choose>
	          			<c:when test="${ob.DDM_STATUS eq '정상' }">
	          				<c:set var="statusT" value="green"/>
	          			</c:when>
	          			<c:when test="${ob.DDM_STATUS eq '장애' }">
	          				<c:set var="statusT" value="red"/>
	          			</c:when>
	          			<c:otherwise>
	          				<c:set var="statusT" value="black"/>
	          			</c:otherwise>
	          		</c:choose>
	                
	                <li>
	                    <p class="lb invert">인버터상태</p>
	                    <p class="rb"><span class="check_c ${statusT }"></span>${empty ob.DDM_STATUS? '기타':ob.DDM_STATUS  }</p>
	                </li>
	                <li>
	                    <p class="lb time">최종수신 날짜 / 시간</p>
	                    <p class="rb w100">
	                        <span class="gb_txt">${empty ob.DDM_DATE? '현재 통신 없음': ob.DDM_DATE }</span>
	                    </p>
	                </li>
	            </ul>
	            
	            <!-- <div class="power_btns">
	                 <button type="button" class="btn_calcu" onclick="$('.base_pop_wrapper').addClass('on')">수익계산</button>
	            </div> -->
	            
	        </article> 
		</section>

		<section class="one_row right3">

            
            <div class="col n01">
                <article class="artBoard top">
                    <h2 class="circle">현장정보</h2>


		            <div class="table_wrapper n2">
		                <table class="tbl_normal sm">
		                    <colgroup>
		                        <col style="width: 30%;">
		                        <col style="width: 70%;">
		                    </colgroup>
		                    <tbody>
		                        <tr>
				                    <th class="txtL">현장명</th>
				                    <td class="txtR">${ob.DPP_NAME }</td>
				                </tr>
				                <tr>
				                    <th class="txtL">인버터</th>
				                    <td class="txtR">${ob.DPP_INVER_COUNT }대</td>
				                </tr>
				                <tr>
				                    <th class="txtL">인버터장비</th>
				                    <td class="txtR">${ob.DPP_INVER }</td>
				                </tr>
				                <tr>
				                    <th class="txtL">총용량</th>
				                    <td class="txtR">${ob.DPP_VOLUM }kW</td>
				                </tr>
		                    </tbody>
		                </table>
		            </div>
                    
                </article>  
                	
            </div>

            <div class="col n03">
                <article class="artBoard long">
                    <h2 class="circle">인버터 종합 발전실적 | ${ob.DPP_NAME } </h2>
                    
                    <div class="inverter_all_develope">
                        <ul class="list">
                            <li>
                                <span class="state black">전일</span>
                                <ul class="info">
                                    <li>
                                        <span class="sbj">발전시간</span>
                                        <span class="num"><b><fmt:formatNumber value="${ob.DDM_P_DATA/ob.DPP_VOLUM }" pattern="0.00"/></b>h</span>
                                    </li>
                                    <li>
                                        <span class="sbj">발전량</span>
                                        <span class="num"><b><fmt:formatNumber value="${ob.DDM_P_DATA}" pattern="0.00"/></b>kWh</span>
                                    </li>
                                </ul>
                            </li>
                            <li>
                                <span class="state red">금일</span>
                                <ul class="info">
                                    <li>
                                        <span class="sbj">발전시간</span>
                                        <span class="num"><b id="todayHour">0.00</b>h</span>
									</li>
                                    <li>
                                        <span class="sbj">발전량</span>
                                        <span class="num"><b id="todayGeneration">0.00</b>kWh</span>
                                    </li>
                                </ul>
                            </li>
                            <li>
                                <span class="state green">금월</span>
                                <ul class="info">
                                    <li>
                                        <span class="sbj">발전시간(평균)</span>
                                        <span class="num"><b id="monthlyHourAvg">0.00</b>h</span>
                                    </li>
                                    <li>
                                        <span class="sbj">발전량</span>
                                        <span class="num"><b id="monthlyGeneration">0.00</b>kWh</span>
                                    </li>
                                </ul>
                            </li>
                            <li>
                                <span class="state orange">금년</span>
                                <ul class="info">
                                    <li>
                                        <span class="sbj">발전시간</span>
                                        <span class="num"><b>
                                        	<fmt:formatNumber value="${year1/ob.DPP_VOLUM }" pattern="0.00"/>
                                        	</b>h
                                        </span>
                                    </li>
                                    <li>
                                        <span class="sbj">발전량</span>
                                        <span class="num"><b><fmt:formatNumber value="${year1 }" pattern="0.00"/></b>kWh</span>
                                    </li>
                                </ul>
                            </li>
                            <li>
                                <span class="state gray">누적</span>
                                <ul class="info">
                                    <li>
                                        <span class="sbj">발전시간</span>
                                        <span class="num"><b>
                                        	<fmt:formatNumber value="${ob.DDM_CUL_DATA/ob.DPP_VOLUM }" pattern="0.00"/>
                                        	</b>h
                                        </span>
                                    </li>
                                    <li>
                                        <span class="sbj">발전량</span>
                                        <span class="num"><b><fmt:formatNumber value="${ob.DDM_CUL_DATA }" pattern="0.00"/></b>kWh</span>
                                    </li>
                                </ul>
                            </li>
                        </ul>
                    </div>

                </article>  
            </div>

        </section>

		<!-- 세부 내용 표시 부분 -->
		<article class="artBoard bott_r" id="staticAjax">
		</article>
        
    </div>
    <!-- COMTAINER END -->

</form:form>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${sp:getString('DAUM_APPKEY')}&libraries=services"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/js/select2.min.js"></script>
<script src="/resources/smartadmin/js/plugin/select2/select2.min.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/css/select2.min.css" rel="stylesheet"/> 

<link rel="stylesheet" href="http://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

<script>
$(function(){
  	ajaxData();
  	updateMonthlyData();
  	searching();
});

function DPPDataAjax(keyno){
	$("#keyno").val(keyno);
	$("#Form").submit();
}

function ajaxData(){
	
	var DPP_KEYNO = $("#DPP_KEYNO").val();
	
	$.ajax({
        url: '/dy/moniter/generalAjax.do',
        type: 'POST',
        data: {
        	keyno : $("#DPP_KEYNO").val(),
        	name : $("#InverterNum").val()
        },
        async: false,  
        success: function(result) {
        	//인버터 이름 추가
        	if(DPP_KEYNO == '96'){
        		if(result.name == '인버터 1호'){	
	        		$("#inverterName").text("<하민 발전소>")
        		}else if(result.name == '인버터 2호'){
        			$("#inverterName").text("<한결 발전소>")
        		}
        	}else{ // 나머지 인버터들은 그대로
	        	$("#inverterName").text("<"+result.name+">")
        	}
        	
        	var volum = "${ob.DPP_VOLUM}";
        	var count = "${ob.DPP_INVER_COUNT}";
        	
        	var ALL_VOLUM = volum/count;
        	
        	//개별용량 추가
        	var other_count = "${ob.DPP_OTHER_VOLUM}";
        	
        	var volum_list = []
        	if(other_count != "") {
        	
        		volum_list = other_count.split(",")	
        		
        		//인버터 호에서 숫자만 추출
	        	var inverternumberstr = $("#InverterNum").val();
				var regex = /[^0-9]/g;
				var resulttemp = inverternumberstr.replace(regex, "");
				var numbering = parseInt(resulttemp);
        		
        		ALL_VOLUM = volum_list[numbering-1]
        	}
        	
        	
        	if(result.invertData == null){
        		$("#AllPower").text("0.0kW / 0.00h")
        		$("#Active").text("0.0kW")
        		chartOption(0.0,0.0,ALL_VOLUM);
        	}else{
        		var hour = result.invertData.Daily_Generation / (ALL_VOLUM);
        		$("#AllPower").text(result.invertData.Daily_Generation+"kWh / " + hour.toFixed(2) +"h")
            	$("#Active").text(result.invertData.Active_Power+"kW")
        		
            	var aDeg = (result.invertData.Daily_Generation/((ALL_VOLUM)*8))*100

             	chartOption(aDeg,result.invertData.Active_Power,ALL_VOLUM);
        	}
        	
        	// 전체 인버터 금일 발전량 합산
        	var totalDailyGen = 0;
        	if(result.invertDataList){
        		for(var i=0; i<result.invertDataList.length; i++){
        			totalDailyGen += parseFloat(result.invertDataList[i].Daily_Generation || 0);
       			}
      		}
      		
      		// 금일 발전량 반영
      		$("#todayGeneration").text(totalDailyGen.toFixed(2));
      		
      		// 금일 발전시간 = (총 발전량 / 설비용량)
      		var plantVolum = parseFloat(volum);
      		var todayHour = 0;
      		if(plantVolum > 0){
      			todayHour = totalDailyGen/plantVolum;
      		}
      		$("#todayHour").text(todayHour.toFixed(2));
      		
      		// 전역 변수에 저장 (dy_mobile_ajax에서 사용)
      		window.dy_mobile_todayGen = totalDailyGen;
      		window.dy_mobile_todayHour = todayHour;
        },
        error: function(){
        	alert("에러 관리자에 문의해주세요.");
        }
	});
}

// 금월 발전량/발전시간 업데이트
function updateMonthlyData(){
	$.ajax({
        url: '/dy/moniter/monthlyAjax.do',
        type: 'POST',
        data: {
        	keyno : "${ob.DPP_KEYNO}"
        },
        success: function(result) {
        	var monthlyGen = parseFloat(result.Monthly_Generation || 0);
        	$("#monthlyGeneration").text(monthlyGen.toFixed(2));
        	
        	// 금월 평균 발전시간 = (금월 발전량 / 설비용량) / 일수
        	var plantVolum = parseFloat("${ob.DPP_VOLUM}");
        	var dayCount = parseInt("${month1Cnt}") + 1; // 오늘 포함
        	var monthlyHourAvg = 0;
        	if(plantVolum > 0 && dayCount > 0){
        		monthlyHourAvg = (monthlyGen / plantVolum) / dayCount;
        	}
        	$("#monthlyHourAvg").text(monthlyHourAvg.toFixed(2));
        	
        	// 전역 변수에 저장
        	window.dy_mobile_monthlyGen = monthlyGen;
        	window.dy_mobile_monthlyHourAvg = monthlyHourAvg;
        },
        error: function(){
        	console.log("금월 발전량 로드 실패");
        }
	});
}

function chartOption(v1, v2, s1){
	  var chartDom = document.getElementById('gauge_1');
	  var myChart = echarts.init(chartDom);
	  var chartDom2 = document.getElementById('gauge_2');
	  var myChart2 = echarts.init(chartDom2);
	  
	  var option;
	  var option2;
	
	option = {
		       series: [
		           {
		               type: 'gauge',
		               center: ['50%', '50%'],
		               startAngle: 180,
		               endAngle: 0,
		               min: 0,
		               max: 100,
		               splitNumber: 10,
		               itemStyle: {
		                   color: '#f13a3a'
		               },
		               progress: {
		                   show: true,
		                   width: 30
		               },
		               pointer: {
		                   show: false
		               },
		               axisLine: {
		                   lineStyle: {
		                       width: 30
		                   }
		               },
		               axisTick: {
		                   distance: -40,
		                   splitNumber: 3,
		                   lineStyle: {
		                       width: 1,
		                       color: '#eee'
		                   }
		               },
		               splitLine: {
		                   distance: -43,
		                   length: 5,
		                   lineStyle: {
		                       width: 1,
		                       color: '#eee'
		                   }
		               },
		               axisLabel: {
		                   distance: 7,
		                   color: '#ddd',
		                   fontSize: 11
		               },
		               anchor: {
		                   show: false
		               },
		               title: {
		                   show: false
		               },
		               detail: {
		                   valueAnimation: true,
		                   width: '100%',
		                   lineHeight: 40,
		                   borderRadius: 8,
		                   offsetCenter: [0, '-15%'],
		                   fontSize: 0,
		                   fontWeight: 'bolder',
		                   formatter: '',
		                   color: 'white',
		                   show : 'false'
		               },
		               data: [
		                   {
		                       value: v1
		                       
		                   }
		               ]
		           }
		       ]
		   };
		   
		   option2 = {
		       series: [
		           {
		               type: 'gauge',
		               center: ['50%', '50%'],
		               startAngle: 180,
		               endAngle: 0,
		               min: 0,
		               max: s1,
		               splitNumber: 10,
		               itemStyle: {
		                   color: '#ff7d53'
		               },
		               progress: {
		                   show: true,
		                   width: 30
		               },
		               pointer: {
		                   show: false
		               },
		               axisLine: {
		                   lineStyle: {
		                       width: 30
		                   }
		               },
		               axisTick: {
		                   distance: -40,
		                   splitNumber: 3,
		                   lineStyle: {
		                       width: 1,
		                       color: '#eee'
		                   }
		               },
		               splitLine: {
		                   distance: -43,
		                   length: 5,
		                   lineStyle: {
		                       width: 1,
		                       color: '#eee'
		                   }
		               },
		               axisLabel: {
		                   distance: 7,
		                   color: '#ddd',
		                   fontSize: 11
		               },
		               anchor: {
		                   show: false
		               },
		               title: {
		                   show: false
		               },
		               detail: {
		                   valueAnimation: true,
		                   width: '60%',
		                   lineHeight: 40,
		                   borderRadius: 8,
		                   offsetCenter: [0, '-15%'],
		                   fontSize: 0,
		                   fontWeight: 'bolder',
		                   formatter: '',
		                   color: 'white',
		                   show : 'false'
		               },
		               data: [
		                   {
		                       value: v2
		                   }
		               ]
		           }
		       ]
		   };

		   option && myChart.setOption(option);
		   option2 && myChart2.setOption(option2);
		 	
}


function clean(){
	$("#rec1").val("");
	$("#smp1").val("");
}

function searching(){
	$.ajax({
        url: '/dy/mobileAjax.do',
        type: 'POST',
        data: {
        	keyno : $("#keyno").val(),
        	InverterType : $("#InverterType").val(),
        	DaliyType : $("#DaliyType").val(),
        	searchBeginDate : $("#searchBeginDate").val(),
        	searchEndDate : $("#searchEndDate").val()
        },
        async: false,  
        success: function(result) {
        	$("#staticAjax").html(result);
        	
        	// dy_mobile_ajax.jsp의 todayGeneration, todayHour 업데이트
        	if(window.dy_mobile_todayGen !== undefined){
        		$("#staticAjax #todayGeneration").text(window.dy_mobile_todayGen.toFixed(2));
        		$("#staticAjax #todayHour").text(window.dy_mobile_todayHour.toFixed(2));
        	}
        },
        error: function(){
        	alert("에러 관리자에 문의해주세요.");
        }
	});
	
}

$('.select2').select2({
    closeOnSelect: true
});

</script>