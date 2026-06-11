<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>



<article class="artBoard lb">
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
                    <td class="txtR">${detail_Data.DPP_NAME }</td>
                </tr>
                <tr>
                    <th class="txtL">인버터</th>
                    <td class="txtR">${detail_Data.DPP_INVER_COUNT }대</td>
                </tr>
                <tr>
                    <th class="txtL">인버터장비</th>
                    <td class="txtR">${detail_Data.DPP_INVER }</td>
                </tr>
                <tr>
                    <th class="txtL">총용량</th>
                    <td class="txtR">${detail_Data.DPP_VOLUM }kW</td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="table_wrapper n2 mgT">
        <table class="tbl_normal sm">
            <colgroup>
                <col style="width: 20%;">
                <col style="width: 30%;">
                <col style="width: 20%;">
                <col style="width: 30%;">
            </colgroup>
            <thead>
                <tr>
                    <th colspan="4" class="txtL">[ ${detail_Data.DPP_AREA } ] ${detail_Data.DPP_NAME }</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th class="txtL">현재발전</th>
                    <td class="txtR"><b><fmt:formatNumber value="${empty detail_Data.DDM_ACTIVE_P? 0:detail_Data.DDM_ACTIVE_P  }" pattern="0.00"/></b>kW</td>
                    <th class="txtL"></th>
                    <td class="txtR"><b></b></td>
                </tr>
                <tr>
                    <th class="txtL">금일</th>
                    <td class="txtR"><b id="todayGeneration">0.00</b>kWh</td>
                    <th class="txtL">발전시간</th>
                    <td class="txtR"><b id="todayHour">0.00</b>h</td>
                </tr>
                <tr>
                    <th class="txtL">전일</th>
                    <td class="txtR"><b><fmt:formatNumber value="${empty detail_Data.DDM_P_DATA ? 0 : detail_Data.DDM_P_DATA  }" pattern="0.00"/></b>kWh</td>
                    <th class="txtL"></th>
                    <td class="txtR"><b><fmt:formatNumber value="${detail_Data.DDM_P_DATA/detail_Data.DPP_VOLUM  }" pattern="0.00"/></b>h</td>
                </tr>
                <tr>
                    <th class="txtL">금월</th>
                    <td class="txtR"><b id="monthlyGeneration">0.00</b>kWh</td>
                    <th class="txtL" style="font-size:11px;">발전시간(평균)</th>
                    <td class="txtR"><b id="monthlyHourAvg">0.00</b>h</td>
                </tr>
                <tr>
                    <th class="txtL">금년</th>
                    <td class="txtR"><b><fmt:formatNumber value="${year1 }" pattern="0.00"/></b>kWh</td>
                    <th class="txtL">발전시간</th>
                    <td class="txtR"><b>
                    	<%-- <c:if test="${year.CNT ne '0'}">
                    		<fmt:formatNumber value="${((year.DATA/detail_Data.DPP_VOLUM) + detail_Data.DDM_T_HOUR)/year.CNT }" pattern="0.00"/>
                    	</c:if>
                    	<c:if test="${year.CNT eq '0'}">
                       		<fmt:formatNumber value="${empty detail_Data.DDM_T_HOUR ? 0 : detail_Data.DDM_T_HOUR  }" pattern="0.00"/>
                       	</c:if> --%>
                    	<fmt:formatNumber value="${year1/detail_Data.DPP_VOLUM }" pattern="0.00"/>
                    	</b>h</td>
                </tr>
                <tr>
                    <th class="txtL">누적</th>
                    <td class="txtR"><b><fmt:formatNumber value="${detail_Data.DDM_CUL_DATA }" pattern="0.00"/></b>kWh</td>
                    <th class="txtL">발전시간</th>
                    <td class="txtR"><b>
                    	<%-- <c:if test="${all.CNT ne '0'}">
                    		<fmt:formatNumber value="${((all.DATA/detail_Data.DPP_VOLUM) + detail_Data.DDM_T_HOUR)/all.CNT }" pattern="0.00"/>
                    	</c:if>
                    	<c:if test="${year.CNT eq '0'}">
                       		<fmt:formatNumber value="${empty detail_Data.DDM_T_HOUR ? 0 : detail_Data.DDM_T_HOUR  }" pattern="0.00"/>
                       	</c:if> --%>
                       	<fmt:formatNumber value="${detail_Data.DDM_CUL_DATA/detail_Data.DPP_VOLUM }" pattern="0.00"/>
                    	</b>h
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</article>



<article class="artBoard rb half">
    <h2 class="location" id="map_name">[ ${detail_Data.DPP_AREA } ] ${detail_Data.DPP_NAME }</h2>

    <div class="map_box_c" id="map">
    </div>
</article>


<article class="artBoard rb half">
	<h2 class="circle">알림</h2>
	
	<div class="table_wrapper con_h" style = "overflow-x : auto ">
	    <table class="tbl_normal">
	        <colgroup>
	            <col style="width: 20%;">
	            <col style="width: 10%;">
	            <col style="width: 22%;">
	            <col style="width: 10%;">
	            <col style="width: 20%;">
	            <col style="width: 25%;">
	        </colgroup>
            <thead>
                <tr>
                    <th>현장명</th>
                    <th>인버터명</th>
                    <th>시간</th>
                    <th>인버터</th>
                    <th>DSP 에러</th>
                    <th>DSP 에러 <br>(Slave)</th>
                </tr>
            </thead>
	        <tr>
	            <tbody>
	            <c:choose>
		            <c:when test="${UI_KEYNO eq 'UI_RTAKX'}">
		            </c:when>
		            <c:otherwise>
		            	<c:forEach items="${ResultList }" var="list">
							<tr>
			                    <td style ="white-space: nowrap;">[ ${list.DPP_AREA } ] ${list.DPP_NAME }</td>
			                    <td style ="white-space: nowrap;">${list.DIE_INVERTER_NAME }</td>
			                    <td style ="white-space: nowrap;">${list.DIE_DATE }</td>
			                    <td style ="white-space: nowrap;">${list.DPP_INVER }</td>
			                    <td style ="white-space: nowrap;">${list.DIE_DSP_ERROR eq 'Normal' ? '정상' : list.DIE_DSP_ERROR }</td>
			                    <td style ="white-space: nowrap;">${list.DIE_DSP_S_ERROR eq 'Normal' ? '정상' : list.DIE_DSP_S_ERROR  }</td>
		              	  	</tr>            	
		            	</c:forEach>
		            </c:otherwise>
	            </c:choose>
	            </tbody>
	        </tr>
	    </table>
	</div>
</article>


<script>
// 카카오맵 API 로드 완료 대기 함수
function waitForKakao(callback) {
	if (typeof kakao !== 'undefined' && kakao.maps) {
		callback();
	} else {
		setTimeout(function() {
			waitForKakao(callback);
		}, 100);
	}
}

$(function(){
	// 카카오맵 API가 로드된 후 지도 초기화
	waitForKakao(function() {
		pf_setMap();
	});
	updateTodayData();
	updateMonthlyData();
});


function pf_setMap(){
	lat = "${detail_Data.DPP_X_LOCATION}"
	lng = "${detail_Data.DPP_Y_LOCATION}"
	
	if(!lat || !lng || lat == "" || lng == "") {
		console.error("지도 좌표가 없습니다. lat:", lat, "lng:", lng);
		return;
	}
	
	$("#map").html("")
	
	var container = document.getElementById("map");
	if(!container) {
		console.error("지도를 담을 영역(#map)을 찾을 수 없습니다.");
		return;
	}
	
	// 카카오맵 API 확인
	if (typeof kakao === 'undefined' || !kakao.maps) {
		console.error("카카오맵 API가 로드되지 않았습니다.");
		return;
	}
	
	var options = {
		center: new kakao.maps.LatLng(lat, lng),
		level: 3
	};
	map = new kakao.maps.Map(container, options);
	
	map.setMapTypeId(kakao.maps.MapTypeId.HYBRID); 
	
	marker = new kakao.maps.Marker({ 
	    // 지도 중심좌표에 마커를 생성합니다 
	    position: map.getCenter() 
	}); 
	marker.setMap(map);
}

function updateTodayData(){
	$.ajax({
        url: '/dy/moniter/generalAjax.do',
        type: 'POST',
        data: {
        	keyno : "${detail_Data.DPP_KEYNO}",
        	name : "인버터 1호"
        },
        async: true,  // ✅ 비동기 처리로 변경
        success: function(result) {
        	// 전체 인버터 발전량 합산
        	var totalDailyGen = 0;
        	if(result.invertDataList){
        		for(var i=0; i<result.invertDataList.length; i++){
        			totalDailyGen += parseFloat(result.invertDataList[i].Daily_Generation || 0);
       			}
      		}
      		
      		// 금일 발전량 반영
      		$("#todayGeneration").text(totalDailyGen.toFixed(2));
      		
      		// 금일 발전시간 = (총 발전량 / 설비용량)
      		var plantVolum = parseFloat("${detail_Data.DPP_VOLUM}");
      		var todayHour = 0;
      		if(plantVolum > 0){
      			todayHour = totalDailyGen/plantVolum;
      		}
      		$("#todayHour").text(todayHour.toFixed(2));
        },
        error: function(){
        	console.log("당일 발전량 로드 실패");
        }
	});
}

function updateMonthlyData(){
	$.ajax({
        url: '/dy/moniter/monthlyAjax.do',
        type: 'POST',
        data: {
        	keyno : "${detail_Data.DPP_KEYNO}"
        },
        async: true,  // ✅ 비동기 처리로 변경
        success: function(result) {
        	var monthlyGen = parseFloat(result.Monthly_Generation || 0);
        	$("#monthlyGeneration").text(monthlyGen.toFixed(2));
        	
        	// 금월 평균 발전시간 = (금월 발전량 / 설비용량) / 일수
        	var plantVolum = parseFloat("${detail_Data.DPP_VOLUM}");
        	var dayCount = parseInt("${month1Cnt}") + 1; // 오늘 포함
        	var monthlyHourAvg = 0;
        	if(plantVolum > 0 && dayCount > 0){
        		monthlyHourAvg = (monthlyGen / plantVolum) / dayCount;
        	}
        	$("#monthlyHourAvg").text(monthlyHourAvg.toFixed(2));
        },
        error: function(){
        	console.log("금월 발전량 로드 실패");
        }
	});
}
</script>