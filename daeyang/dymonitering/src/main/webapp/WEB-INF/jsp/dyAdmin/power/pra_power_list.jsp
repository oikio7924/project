<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/bootstrap-select.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/i18n/defaults-*.min.js"></script>

<style>

datalist{

display : none;
}



.checksize{
 width: 20% !important;
 margin-bottom: 5px !important;
}
#dt_basic tbody tr {cursor:pointer;}
form .error {color:red}

.checkbox-inline+.checkbox-inline, .radio-inline+.radio-inline {margin-left:0;}
.checkbox-inline, .radio-inline {margin-right:10px;}

.map {position:relative; width:100%;height:400px;border:1px solid #eee;padding:5px;}
.map #moveMapBtnBox {position:absolute;right:5px;top:5px;z-index: 10 }

</style>

<form:form id="Form" name="Form" method="post" action="">
<input type="hidden" name="DPP_KEYNO" id="DPP_KEYNO">
<section id="widget-grid" class="">
	<div class="row">
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-6" id="menu_1">
			<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>발전소 리스트</h2>
				</header>
				<div class="widget-body " >
					<div class="widget-body-toolbar bg-color-white">
						<div class="alert alert-info no-margin fade in">
							<button type="button" class="close" data-dismiss="alert">×</button>
							발전소 리스트를 확인합니다.
						</div> 
					</div>
					<!-- <div class="widget-body-toolbar bg-color-white">
						<div class="row"> 
							<div class="col-sm-12 col-md-2 text-align-right" style="float:right;">
								<div class="btn-group">
									<button class="btn btn-sm btn-primary" type="button" onclick="pf_openInsertPopup();">
										<i class="fa fa-plus"></i> 발전소 등록
									</button> 
								</div>
							</div>
						</div>
					</div> -->
					<div class="table-responsive">
						<jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
							<jsp:param value="/dyAdmin/powerPlant/pagingAjax.do" name="pagingDataUrl" />
							<jsp:param value="/dyAdmin/powerPlant/excelAjax.do" name="excelDataUrl" />
						</jsp:include>
						<fieldset id="tableWrap">
						</fieldset>
					</div>
				</div>
			</div>
		</article>
		
		
		
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-6" id="menu_2">
			<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>발전소 등록</h2>
				</header>
				<div class="widget-body " >
					<div class="widget-body-toolbar bg-color-white">
						<div class="row"> 
							<div class="col-sm-6 col-md-6 text-align-right" style="float:right;">
								<div class="btn-group">
									<button class="btn btn-sm btn-primary" id="insertButton" type="button" onclick="Inver_Insert();">
										저장
									</button> 
									<button class="btn btn-sm btn-danger" type="button" onclick="cancle()">
										취소
									</button> 
								</div>
							</div>
						</div>
					</div>
					<div class="table-responsive">
							<!-- insert -->
							<!-- 발전소 리스트 --> 
							<div id="power-insert" title="발전소 등록" style="width: 98%;">
									<div class="widget-body ">
										<fieldset>
											<div class="form-horizontal">
												<div class="bs-example necessT">
											         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
											    </div>
												<fieldset>
													<div class="form-group">
														<label class="col-md-3 control-label"><span class="nessSpan">*</span> 발전소 명</label>
														<div class="col-md-6">
															<input type="text" class="form-control DPP_NAME" name="DPP_NAME" id="DPP_NAME" value="" maxlength="30">
														</div>
													</div>
													<div class="form-group">
														<label class="col-md-3 control-label"><span class="nessSpan">*</span> 설치용량</label>
														<div class="col-md-6">
															<input type="text" class="form-control DPP_VOLUM" id="DPP_VOLUM" name="DPP_VOLUM"  value="">
														</div>
													</div>
													
													<div class="form-group">
														<label class="col-md-3 control-label"><span class="nessSpan">*</span> 유저선택</label>
														<div class="col-md-6">
															<select class="form-control DPP_USER" id="DPP_USER" name="DPP_USER">
																<c:forEach items="${member }" var="member">
																	<option value="${member.UI_KEYNO }">${member.UI_ID }</option>
																</c:forEach>
															</select>
														</div>
													</div>
													
													<div class="form-group">
														<label class="col-md-3 control-label"><span class="nessSpan">*</span> 상태</label>
														<div class="col-md-6">
															<select class="form-control DPP_STATUS" id="DPP_STATUS" name="DPP_STATUS">
																<option value="N">미개통</option>
																<option value="Y">개통</option>
																<option value="E">예외발전소(공사진행중 or 테스트용 발전소)</option>
															</select>
														</div>
													</div>
													<div class="form-group">
														<label class="col-md-3 control-label"><span class="nessSpan">*</span> 지역</label>
														<div class="col-md-6">
															<input type="text" class="form-control DPP_AREA" id="DPP_AREA" name="DPP_AREA"  value="">
														</div>
													</div>
													
													<div class="form-group">
														<label class="col-md-3 control-label"><span class="nessSpan">*</span> 발전소 주소</label>
														<div class="col-md-6">
															<input type="text" class="form-control DPP_LOCATION" id="DPP_LOCATION" name="DPP_LOCATION"  value="">
														</div>
														<div class="col-md-2">
															<button class="btn btn-primary" type="button" onclick="pf_execDaumPostcode()"><i class="fa fa-search"></i>검색</button>
														</div>
													</div>
							
													<div class="form-group">
														<label class="col-md-3 control-label"><span class="nessSpan">*</span> 주소 좌표</label>
														
														<div class="col-md-3">
															<input type="text" class="form-control" name="DPP_X_LOCATION" id="DPP_X_LOCATION" placeholder="X좌표" >
														</div>
														<div class="col-md-3">
															<input type="text" class="form-control" name="DPP_Y_LOCATION" id="DPP_Y_LOCATION" placeholder="Y좌표" >
														</div>
													</div>
							
													
													
													<div class="form-group">
														<label class="col-md-3 control-label"><span class="nessSpan">*</span> 발전소 주소</label>
														<div class="col-md-6">
															<!-- 주소위치로 이동 -->
															<div class="map">
																<div id="moveMapBtnBox">
																	<button id="moveMapBtn" class="btn btn-primary" type="button" onclick="pf_moveMap();">주소 위치로 이동</button>
																</div>
																
																<div id="DDP_Map" style="width:100%;height:400px;"></div>
															</div>
														</div>
													</div>
													
													<div class="form-group">
														<label class="col-md-3 control-label"><span class="nessSpan">*</span> 인버터</label>
														<div class="col-md-6">
															<input type="text" class="form-control DPP_INVER" id="DPP_INVER" name="DPP_INVER"  value="">
														</div>
													</div>
													<div class="form-group">
														<label class="col-md-3 control-label"><span class="nessSpan">*</span> 인버터 갯수</label>
														<div class="col-md-6">
															<input type="number" class="form-control DPP_INVER_COUNT" id="DPP_INVER_COUNT" name="DPP_INVER_COUNT"  value="1" onchange="ALL(this.value)" min="1" max="10">
														</div>
													</div>
													
													<div class="form-group">
														<label class="col-md-3 control-label"><span class="nessSpan">*</span> S/N</label>
														<div class="col-md-6" id="sn_insert">
														</div>
													</div>
													
													<div class="form-group">
														<label class="col-md-3 control-label"><span class="nessSpan">*</span> 개별 용량</label>
														<div class="col-md-6" id="other_volum">
														</div>
													</div>
													
													<!-- <div class="form-group">
														<label class="col-md-3 control-label"><span class="nessSpan">*</span> 발전소 이미지</label>
														<div class="col-md-6">
															<input type="text" class="form-control " id="" name=""  value="">
														</div>
													</div> -->
												</fieldset>
											</div>
										</fieldset>
									</div>
							</div>
							<!-- endInsert -->
						<fieldset id="tableWrap">
						</fieldset>
					</div>
				</div>
			</div>
		</article>
		
	</div>
</section>
</form:form>

<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${sp:getString('DAUM_APPKEY')}&libraries=services"></script>

<script type="text/javascript">
var map;

$(document).ready(function() {
	pf_setMap('${resultData.DDP_X_LOCATION}','${resultData.DDP_Y_LOCATION}');
	SerialNumber("1");
	VolumNumber("1");
});

function validation(){
	if($("#DPP_NAME").val() == ''){alert("발전소 이름을 입력하세요!"); return false}
	if($("#DPP_STATUS").val() == ''){alert("발전소 개통 상태를 확인하세요!"); return false}
	if($("#DPP_USER").val() == ''){alert("유저를 등록해주세요!"); return false}
	if($("#DPP_VOLUM").val() == ''){alert("발전소 용량을 입력하세요!"); return false}
	if($("#DPP_AREA").val() == ''){alert("발전소 지역을 입력하세요!"); return false}
	if($("#DPP_LOCATION").val() == ''){alert("발전소 주소를 검색해주세요!"); return false}
	if($("#DPP_X_LOCATION").val() == ''){alert("지도에서 주소 위로 이동을 클릭해주세요!"); return false}
	if($("#INVER_COUNTN").val() == ''){alert("인버터 갯수를 입력하세요!"); return false}
	if($("input[name='DPP_SN']").val() == ''){alert("인버터 s/n를 입력하세요!"); return false}
	
	return true;
	}


function noSpaceForm(obj) { // 공백사용못하게
    var str_space = /\s/;  // 공백체크
    if(str_space.exec(obj.value)) { //공백 체크
        alert("비밀 번호에는 공백을 사용할수 없습니다.\n\n공백은 자동적으로 제거 됩니다.");
        obj.focus();
        obj.value = obj.value.replace(' ',''); // 공백제거
        return false;
    }
}

//주소 찾기
function pf_execDaumPostcode() {
  new daum.Postcode({
      oncomplete: function(data) {
          // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
          // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
          var roadAddr = data.roadAddress || data.jibunAddress; // 도로명 주소 변수
          // 우편번호와 주소 정보를 해당 필드에 넣는다.
          document.getElementById('DPP_LOCATION').value = data.zonecode +'//'+roadAddr;
//           document.getElementById("TC_ADDR").value = roadAddr;
      }
  }).open();
}


//발전소 등록
function Inver_Insert(){
	 if(validation()){
		 $.ajax({
				type: "POST",
				url: "/dyAdmin/powerPlant/Inverter_insert.do",
				async: false,
				data: $('#Form').serializeArray(),
				success : function(){
 					cf_smallBox('수정 완료', "발전소 등록 완료", 3000,);
				}, 
				error: function(){
					cf_smallBox('error', "발전소 등록 에러", 3000,'#d24158');
				}
		}); 
	 }
}
//발전소 수정
function Inver_Update(){
	 if(validation()){
		 $.ajax({
				type: "POST",
				url: "/dyAdmin/powerPlant/Inverter_update.do",
				async: false,
				data: $('#Form').serializeArray(),
				success : function(){
					cf_smallBox('수정 완료', "발전소 수정 완료", 3000,);
				}, 
				error: function(){
					cf_smallBox('error', "발전소 등록 에러", 3000,'#d24158');
				}
		}); 
	 }
}

function pf_setMap(lat,lng){
	$("#DDP_Map").html("")
	var isDefault = !(lat && lng);
	
	lat = lat || "${sp:getData('defaultX_Location')}";
	lng = lng || "${sp:getData('defaultY_Location')}";
	
	var container = document.getElementById("DDP_Map");
	var options = {
		center: new kakao.maps.LatLng(lat, lng),
		level: 3
	};

	map = new daum.maps.Map(container, options);
	
	map.setMapTypeId(kakao.maps.MapTypeId.HYBRID); 
	
	marker = new daum.maps.Marker({ 
	    // 지도 중심좌표에 마커를 생성합니다 
	    position: map.getCenter() 
	}); 
	
	
	if(!isDefault){
		marker.setMap(map);
	}
	
	daum.maps.event.addListener(map, 'click', function(mouseEvent) {        
	    
	    // 클릭한 위도, 경도 정보를 가져옵니다 
	    var latlng = mouseEvent.latLng; 
	    pf_setMarker(latlng);
	});
}


function pf_setMarker(latLng){
	
	marker.setMap(map);
	// 마커 위치를 클릭한 위치로 옮깁니다
  	marker.setPosition(latLng);
  
  $('#DPP_X_LOCATION').val(latLng.getLat());
  $('#DPP_Y_LOCATION').val(latLng.getLng());
}


function pf_moveMap(){
	var address = $('#DPP_LOCATION').val();
	arr = address.split("//")
	address = arr[1].trim();
	
	var geocoder = new daum.maps.services.Geocoder();
	// 주소로 좌표를 검색합니다
	geocoder.addressSearch(address, function(result, status) {

	    // 정상적으로 검색이 완료됐으면 
	     if (status === daum.maps.services.Status.OK) {

	        var coords = new daum.maps.LatLng(result[0].y, result[0].x);

	        // 결과값으로 받은 위치를 마커로 표시합니다
	       	pf_setMarker(coords);
	        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
	        map.setCenter(coords);
	    }else{
	    	cf_smallBox('지도', '주소값이 없거나 주소로 해당 위치를 찾을 수 없습니다.', 3000,'gray');
	    }
	}); 
	
}

function detailData(keyno){
	$.ajax({
		type: "POST",
		url: "/dyAdmin/powerPlant/Inverter_data.do",
		async: false,
		data: {
			DPP_KEYNO : keyno
		},
		success : function(data){
			
			SN_Detail(data.DPP_INVER_COUNT,data.DPP_SN);
			Volum_Detail(data.DPP_INVER_COUNT,data.DPP_OTHER_VOLUM);
			
			$("#DPP_KEYNO").val(data.DPP_KEYNO)
			$("#DPP_NAME").val(data.DPP_NAME)
			$("#DPP_AREA").val(data.DPP_AREA)
			$("#DPP_STATUS").val(data.DPP_STATUS)
			$("#DPP_USER").val(data.DPP_USER)
			$("#DPP_VOLUM").val(data.DPP_VOLUM)
			$("#DPP_LOCATION").val(data.DPP_LOCATION)
			$("#DPP_X_LOCATION").val(data.DPP_X_LOCATION)
			$("#DPP_Y_LOCATION").val(data.DPP_Y_LOCATION)
			$("#DPP_INVER").val(data.DPP_INVER)
			$("#DPP_INVER_COUNT").val(data.DPP_INVER_COUNT)
			
						
// 			var coords = new daum.maps.LatLng(data.DPP_Y_LOCATION, data.DPP_X_LOCATION);
			pf_setMap(data.DPP_X_LOCATION,data.DPP_Y_LOCATION );
			
			$("#insertButton").text("수정");
			$("#insertButton").attr("onclick","Inver_Update()");
		}, 
		error: function(){
			cf_smallBox('error', "발전소 등록 에러", 3000,'#d24158');
		}
	}); 
}

function cancle(){
	$("#DPP_NAME").val('')
	$("#DPP_AREA").val('')
	$("#DPP_STATUS").val('')
	$("#DPP_USER").val('')
	$("#DPP_VOLUM").val('')
	$("#DPP_LOCATION").val('')
	$("#DPP_X_LOCATION").val('')
	$("#DPP_Y_LOCATION").val('')
	$("#DPP_INVER").val('')
	$("#DPP_INVER_COUNT").val('')
	$("input[name='DPP_SN']").val('')
	$("input[name='DPP_OTHER_VOLUM']").val('')
}


// 인버터 개수 넣을때 s/n , 개별용량 추가
function ALL(number,snlist){
	SerialNumber(number,snlist);
	VolumNumber(number,snlist);
}

//s/n 기입부분
function SerialNumber(number,snlist){
	var num = Number(number)
	input = ''
	if(num > 0){
		for(var i=1;i<=num;i++){
			if(snlist !=null ){
				input += '<input type="text" class="form-control Serial_num" name="DPP_SN"  value="'+snlist[i-1]+'" placeholder="'+i+'호" style="margin-bottom: 5px;">'
			}else{
				input += '<input type="text" class="form-control Serial_num" name="DPP_SN"  value="" placeholder="'+i+'호" style="margin-bottom: 5px;">'
			}
		}	
	}
	
	$("#sn_insert").html(input)
}


//개별 s/n 불러오기
function SN_Detail(num,list){
	var snlist = []
	if(list != null){
    	snlist = list.split(",")	
    }
    SerialNumber(num,snlist)
}

//개별용량 추가 기입
function VolumNumber(number,snlist){
	var num = Number(number)
	input = ''
	if(num > 0){
		for(var i=1;i<=num;i++){
			if(snlist !=null ){
				input += '<input type="text" class="form-control other_volum" name="DPP_OTHER_VOLUM"  value="'+snlist[i-1]+'" placeholder="'+i+'호" style="margin-bottom: 5px;">'
			}else{
				input += '<input type="text" class="form-control other_volum" name="DPP_OTHER_VOLUM"  value="" placeholder="'+i+'호" style="margin-bottom: 5px;">'
			}
		}	
	}
	
	$("#other_volum").html(input)
}


//개별 용량 불러오기
function Volum_Detail(num,list){
	var snlist = []
	if(list != null){
  	snlist = list.split(",")	
  }
	VolumNumber(num,snlist)
}

</script>