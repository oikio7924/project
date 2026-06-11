<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/css/select2.min.css" rel="stylesheet" />

<form:form action="" method="POST" id="Form">
<input type="hidden" value="${ob.DPP_KEYNO }" id="n_keyno" name="n_keyno">
<div id="container" class="heightFix">
    <div class="flex_wrapper">
        <section class="one_row left2">
            <article class="artBoard top2">
                <h2 class="circle">발전소</h2>

                <p class="power_tit">[${ob.DPP_AREA }] ${ob.DPP_NAME }</p>

				<div class="power_select">
                    <select class="select_nor sm3 w100 form-control select2" id="DPP_KEYNO" name="DPP_KEYNO" value="${DPP_KEYNO }" onchange="DPPDataAjax();">
                        <c:forEach items="${list }" var="list">
                        	<option value="${list.DPP_KEYNO }" ${list.DPP_KEYNO eq DPP_KEYNO ? 'selected' : '' } >${list.DPP_NAME }</option>
                        </c:forEach>
                    </select>
                </div>
				
                <h2 class="location">발전소 현장정보</h2>

                <div class="power_preview">
                    <div class="imgs" id="map" style="height: 200px"></div> <!-- 카카오맵 -->
                </div>

                <p class="power_addr">${fn:substringAfter(ob.DPP_LOCATION,'//')} </p>

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
               			<c:when test="${ob.DDM_STATUS eq '연결 끊김' }">
               				<c:set var="statusT" value="black"/>
               			</c:when>
               			<c:otherwise>
               				<c:set var="statusT" value="gray"/>
               			</c:otherwise>
               		</c:choose>
                    
                    <li>
                        <p class="lb invert">인버터상태</p>
                        <p class="rb"><span class="check_c ${statusT }"></span> ${empty ob.DDM_STATUS? '미개통':ob.DDM_STATUS }</p>
                    </li>
                    <li>
                        <p class="lb time">발전소등록 날짜 / 시간</p>
                        <p class="rb w100">
                            <span class="gb_txt">${ob.DPP_DATE }</span>
                        </p>
                    </li>
                    <li>
                        <p class="lb time">최종수신 날짜 / 시간</p>
                        <p class="rb w100">
                            <span class="gb_txt" id="Conndate">${empty ob.DDM_DATE? '현재 통신 없음': ob.DDM_DATE }</span>
                        </p>
                    </li>
                </ul>

            </article>  
        </section>


        <section class="one_row right2" id="statics_ajax">

        </section>

        
    </div>
    
</div>
</form:form>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${sp:getString('DAUM_APPKEY')}&libraries=services"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>
<script type="text/javascript" src="/resources/publish/_DY/js/echarts.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/js/select2.min.js"></script>

<script src="/resources/common/js/html2canvas.js"></script>

<script type="text/javascript">



//이미지(png)로 다운로드
function print(div){
	div = div[0]
	html2canvas(div).then(function(canvas){
		var myImage = canvas.toDataURL();
		downloadURI(myImage, "D://ttest.png") 
	});
}
function downloadURI(uri, name){
	var link = document.createElement("a")
	link.download = name;
	link.href = uri;
	document.body.appendChild(link);
	link.click();
}


$(function(){
	pf_setMap();
	statics_ajax();
	$('.select2').select2({
	    closeOnSelect: true
	});
});

function DPPDataAjax(){
	$('#Form').attr('action','/dy/moniter/stastics.do');
	$("#Form").submit();
	
}


   
function pf_setMap(){
	lat = "${ob.DPP_X_LOCATION}"
	lng = "${ob.DPP_Y_LOCATION}"
	
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
	
	// 카카오맵 API 로드 대기
	if (typeof kakao === 'undefined' || !kakao.maps) {
		setTimeout(function() {
			pf_setMap();
		}, 100);
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

function statics_ajax(){
	$.ajax({
        url: '/dy/moniter/stasticsAjax.do',
        type: 'POST',
        data: {
        	keyno : $("#n_keyno").val(),
        	DaliyType : "${DaliyType}",
        	InverterType : "${InverterType}",
        	searchBeginDate : "${searchBeginDate}",
        	searchEndDate : "${searchEndDate}"
        },
        async: false,  
        success: function(result) {
        	if(result && result.trim() !== '') {
        		$("#statics_ajax").html(result);
        	} else {
        		console.error("통계분석 데이터가 비어있습니다.");
        		$("#statics_ajax").html("<div style='padding: 20px; text-align: center;'>통계 데이터를 불러올 수 없습니다.</div>");
        	}
        },
        error: function(xhr, status, error){
        	console.error("통계분석 AJAX 오류:", status, error);
        	console.error("응답:", xhr.responseText);
        	alert("에러 관리자에 문의해주세요. 오류: " + error);
        }
	});
}


//엑셀 버튼
function pf_excel(url){
	$('#Form').attr('action',url);
	$('#Form').submit();
}


function auto(){
	
	$.ajax({
        url: '/dy/moniter/stasticsAjax.do',
        type: 'POST',
        data: {
        	keyno : $("#n_keyno").val(),
        	DaliyType : "${DaliyType}",
        	InverterType : "${InverterType}",
        	searchBeginDate : "${searchBeginDate}",
        	searchEndDate : "${searchEndDate}"
        },
        async: false,  
        success: function(result) {
        	$("#statics_ajax").html(result);
        },
        error: function(){
        	alert("에러 관리자에 문의해주세요.");
        }
	});
}
</script>