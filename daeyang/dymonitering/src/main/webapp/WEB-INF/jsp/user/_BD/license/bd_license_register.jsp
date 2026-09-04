<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>

<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
<style>
.plant-input {
  padding: 6px 10px;
  font-size: 15px;
  font-weight: 500;
}
</style>
<main class="h-full overflow-y-auto ">
          <div class="container grid px-6 mx-auto">
            <div class="relative">
              <div
                class="w-full rounded-lg bg-indigo-200 text-center p-2 md:p-2 lg:p-4 text-sm md:text-sm lg:text-base md:text-base lg:text-lg font-bold my-4 md:md-4 lg:my-7">
                발전소 및 인허가 관련 정보 등록</div>
              <form:form id="Form" class="form-horizontal" name="Form"  action="" method="post"  enctype="multipart/form-data">
              <div class="w-full rounded-lg bg-white p-5 my-4 md:md-4 lg:my-7">            	
				
					<!-- 상단 버튼 영역 -->
					<div class="flex justify-between items-center mb-5">
						<div class="flex items-center gap-3" style="flex: 1;">
							<label class="text-lg font-bold" style="color: #374151; min-width: 120px;">발전소 선택</label>
							<select name="user" id="user" onchange="providerSelect(this.value)" style="width: 450px; padding: 14px 20px; font-size: 17px; font-weight: 600; border: 2px solid #d1d5db; border-radius: 10px; background-color: white; box-shadow: 0 2px 4px rgba(0,0,0,0.05); transition: all 0.3s;">
								<option value="0">신규 등록</option>
								<c:forEach items="${plantList }" var="b">
									<option value="${b.bd_plant_keyno }">${b.bd_plant_name }</option>
								</c:forEach>
							</select>
						</div>
						
						<div class="flex gap-2">
							<div class="filebox">
								<input class="upload-name" value="첨부파일" placeholder="첨부파일" style="width: 150px;">
								<label for="excelFile">파일찾기</label> 
								<input type="file" id="excelFile" name="excelFile">
							</div>
							<button class="w3-button w3-green w3-round-large" type="button" onclick="excelInsert();">
								<i class="fa fa-upload"></i> 엑셀 등록
							</button>
						</div>
					</div>
					<style>
					#user:hover {
						border-color: #6366f1 !important;
						box-shadow: 0 4px 6px rgba(99, 102, 241, 0.15) !important;
					}
					#user:focus {
						outline: none;
						border-color: #6366f1 !important;
						box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1) !important;
					}
					</style>
                
                  <div class="flex gap-6 mt-4">
                    <!-- 왼쪽 열 -->
                    <div class="flex-1 flex flex-col gap-3">
                      <div class="flex items-center flex-shrink-0">
                        <label for="id"
                          class="text-base w-44 font-semibold text-black rounded-sm mr-3 flex items-center whitespace-nowrap">발전소 명</label>
                        <input type="text" id="bd_plant_name" name="bd_plant_name"
                          class="flex-1 rounded-sm border_input_style plant-input"/>
                      </div>
                      <div class="flex items-center flex-shrink-0">
                        <label for="password"
                          class="text-base w-44 font-semibold text-black rounded-sm mr-3 flex items-center whitespace-nowrap">사업자 명</label>
                        <input type="text" id="bd_plant_owner" name="bd_plant_owner"
                          class="flex-1 rounded-sm border_input_style plant-input"/>
                      </div>
                      <div class="flex items-center flex-shrink-0">
                        <label for="auth_key"
                          class="text-base w-44 font-semibold text-black rounded-sm mr-3 flex items-center whitespace-nowrap">연락처</label>
                        <input type="text" id="bd_plant_phone" name="bd_plant_phone"
                          class="flex-1 rounded-sm border_input_style plant-input" value="" />
                      </div>
                      <div class="flex items-center flex-shrink-0">
                        <label for="classification"
                          class="text-base w-44 font-semibold text-black rounded-sm mr-3 flex items-center whitespace-nowrap">소재지</label>
                        <input type="text" id="bd_plant_add" name="bd_plant_add"
                          class="flex-1 rounded-sm border_input_style plant-input" value="" />
                      </div>
                      <div class="flex items-center flex-shrink-0">
                        <label for="business_registration_number"
                          class="text-base w-44 font-semibold text-black rounded-sm mr-3 flex items-center whitespace-nowrap">용량</label>
                        <input type="text" id="bd_plant_volum" name="bd_plant_volum"
                          class="flex-1 rounded-sm border_input_style plant-input" value="" />
                      </div>
                      <div class="flex items-center flex-shrink-0">
                        <label for="category"
                          class="text-base w-44 font-semibold text-black rounded-sm mr-3 flex items-center whitespace-nowrap">설치형태</label>
                        <input type="text" id="bd_plant_installtype" name="bd_plant_installtype"
                          class="flex-1 rounded-sm border_input_style plant-input" value="" />
                      </div>
                      
                      <!-- 메모 필드 -->
                      <div class="flex flex-col mt-3" style="flex: 1;">
                        <label for="bd_plant_memo"
                          class="text-base font-semibold text-black mb-2">메모</label>
                        <textarea id="bd_plant_memo" name="bd_plant_memo"
                          class="w-full rounded-sm border_input_style plant-input" 
                          style="resize: none; height: 100%; min-height: 200px; overflow-y: auto;"
                          placeholder="발전소 관련 메모를 입력하세요."></textarea>
                      </div>
                    </div>
                    
                    <!-- 오른쪽 열 -->
                    <div class="flex-1 flex flex-col gap-3">
                      <!-- 발전사업 블록 -->
                      <div class="rounded-lg border-2 border-blue-200 bg-blue-50 p-3" style="background-color: #eff6ff; border-color: #bfdbfe;">
                        <div class="flex items-center flex-shrink-0 mb-3">
                          <label for="category"
                            class="text-base w-44 font-semibold text-black rounded-sm mr-3 flex items-center whitespace-nowrap">발전사업허가예정일</label>
                          <input type="text" id="bd_plant_BusDueDate" name="bd_plant_BusDueDate"
                            class="flex-1 rounded-sm border_input_style plant-input" value="" />
                        </div>
                        <div class="flex items-center flex-shrink-0 mb-3">
                          <label for="category"
                            class="text-base w-44 font-semibold text-black rounded-sm mr-3 flex items-center whitespace-nowrap">발전사업허가일</label>
                          <input type="text" id="bd_plant_BusStart" name="bd_plant_BusStart"
                            class="flex-1 rounded-sm border_input_style plant-input" value="" />
                        </div>
                        <div class="flex items-center flex-shrink-0">
                          <label for="name"
                            class="text-base w-44 font-semibold text-black rounded-sm mr-3 flex items-center whitespace-nowrap">발전사업만료일</label>
                          <input type="text" id="bd_plant_BusEndDate" name="bd_plant_BusEndDate"
                            class="flex-1 rounded-sm border_input_style plant-input" value="" />
                        </div>
                      </div>
                      
                      <!-- 개발행위 블록 -->
                      <div class="rounded-lg border-2 border-green-200 bg-green-50 p-3" style="background-color: #f0fdf4; border-color: #bbf7d0;">
                        <div class="flex items-center flex-shrink-0 mb-3">
                          <label for="classification"
                            class="text-base w-44 font-semibold text-black rounded-sm mr-3 flex items-center whitespace-nowrap">개발행위허가일</label>
                          <input type="text" id="bd_plant_DevStartDate" name="bd_plant_DevStartDate"
                            class="flex-1 rounded-sm border_input_style plant-input" value="" />
                        </div>
                        <div class="flex items-center flex-shrink-0">
                          <label for="tax_registration_id"
                            class="text-base w-44 font-semibold text-black rounded-sm mr-3 flex items-center whitespace-nowrap">개발행위만료일</label>
                          <input type="text" id="bd_plant_DevEndDate" name="bd_plant_DevEndDate"
                            class="flex-1 rounded-sm border_input_style plant-input" value="" />
                        </div>
                      </div>
                      
                      <!-- PPA 블록 -->
                      <div class="rounded-lg border-2 border-purple-200 bg-purple-50 p-3" style="background-color: #faf5ff; border-color: #e9d5ff;">
                        <div class="flex items-center flex-shrink-0 mb-3">
                          <label for="representative_name"
                            class="text-base w-44 font-semibold text-black rounded-sm mr-3 flex items-center whitespace-nowrap">PPA접수일</label>
                          <input type="text" id="bd_plant_PPADate" name="bd_plant_PPADate"
                            class="flex-1 rounded-sm border_input_style plant-input" value="" />
                        </div>
                        <div class="flex items-center flex-shrink-0">
                          <label for="department1"
                            class="text-base w-44 font-semibold text-black rounded-sm mr-3 flex items-center whitespace-nowrap">PPA접수용량</label>
                          <input type="text" id="bd_plant_PPAVolum" name="bd_plant_PPAVolum"
                            class="flex-1 rounded-sm border_input_style plant-input" value="" />
                        </div>
                      </div>
                      
                      <!-- 준공/개시일 블록 -->
                      <div class="rounded-lg border-2 border-orange-200 bg-orange-50 p-3" style="background-color: #fff7ed; border-color: #fed7aa;">
                        <div class="flex items-center flex-shrink-0 mb-3">
                          <label for="bd_plant_DevCompletionDate"
                            class="text-base w-44 font-semibold text-black rounded-sm mr-3 flex items-center whitespace-nowrap">개발행위준공일</label>
                          <input type="text" id="bd_plant_DevCompletionDate" name="bd_plant_DevCompletionDate"
                            class="flex-1 rounded-sm border_input_style plant-input" value="" />
                        </div>
                        <div class="flex items-center flex-shrink-0">
                          <label for="bd_plant_OperationStartDate"
                            class="text-base w-44 font-semibold text-black rounded-sm mr-3 flex items-center whitespace-nowrap">상업운전개시일</label>
                          <input type="text" id="bd_plant_OperationStartDate" name="bd_plant_OperationStartDate"
                            class="flex-1 rounded-sm border_input_style plant-input" value="" />
                        </div>
                      </div>
                    </div>
                  </div>
                  
                  <!-- 구분선 2 -->
                  <div class="w-full border my-3 md:my-3 lg:my-5"></div>
                  
                  <!-- 버튼 영역 (중앙 정렬) -->
                  <div class="flex justify-center items-center gap-3 my-5">
					  <input type="hidden" id="buttionType" name="buttionType" value="insert"> 
					  <input type="hidden" id="bd_plant_keyno" name="bd_plant_keyno" value=""> 
	                  <button type="button" id="ActionType" onclick="providerInsert();"
	                    class="text-sm md:text-sm lg:text-base font-bold inline-flex items-center px-4 py-2 md:px-4 md:py-2 lg:px-6 lg:py-3 border border-transparent rounded-lg text-white bg-button-blue">저장</button>
	                  <div id="buttondiv2"></div>
				  </div>
				</div>
              </form:form>
            </div>
          </div>
        </main>
<jsp:include page="/WEB-INF/jsp/user/_BD/license/JS/datePickerSetting.jsp" flush="true"></jsp:include> 
<script type="text/javascript" src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
<script type="text/javascript">


$(function() {
	
	datePickerSetting();
	$('#user').select2(); //검색 select
	
	// URL 파라미터에서 plantKeyno 확인 (캘린더에서 넘어온 경우)
	var urlParams = new URLSearchParams(window.location.search);
	var plantKeyno = urlParams.get('plantKeyno');
	
	if(plantKeyno) {
		// 발전소 자동 선택
		$('#user').val(plantKeyno).trigger('change');
	}
	
});


function providerSelect(value){
	if(value == "0"){
		clear();		
		$("#buttondiv2").empty();
		$("#ActionType").html('<i class="fa fa-floppy-o"></i> 저장')
		$("#buttionType").val("insert");
	}else{
		providerSelectmethod(value);
	}
}

function clear(){
	$("#bd_plant_name").val("")
	$("#bd_plant_owner").val("")
	$("#bd_plant_phone").val("")
	$("#bd_plant_add").val("")
	$("#bd_plant_volum").val("")
	$("#bd_plant_installtype").val("")
	$("#bd_plant_BusDueDate").val("")
	$("#bd_plant_BusStart").val("")
	$("#bd_plant_BusEndDate").val("")
	$("#bd_plant_DevStartDate").val("")
	$("#bd_plant_DevEndDate").val("")
	$("#bd_plant_DevCompletionDate").val("")
	$("#bd_plant_OperationStartDate").val("")
	$("#bd_plant_PPADate").val("")
	$("#bd_plant_PPAVolum").val("")
	$("#bd_plant_keyno").val("")
	$("#bd_plant_memo").val("")
}

function providerSelectmethod(value){
	 $.ajax({
        url: '/bd/license/PlantSelectAjax.do?${_csrf.parameterName}=${_csrf.token}',
        type: 'POST',
        data: {
        	"bd_plant_keyno":value
        },
        async: false,  
        success: function(result) {
       	$("#bd_plant_name").val(result.bd_plant_name)
       	$("#bd_plant_owner").val(result.bd_plant_owner)
       	$("#bd_plant_phone").val(result.bd_plant_phone)
       	$("#bd_plant_add").val(result.bd_plant_add)
       	$("#bd_plant_volum").val(result.bd_plant_volum)
       	$("#bd_plant_installtype").val(result.bd_plant_installtype)
       	// 모든 날짜 필드를 동일한 방식으로 처리 (서버에서 YYYY-MM-DD 형식으로 반환)
       	var datePickerFields = {
       		"bd_plant_BusDueDate": result.bd_plant_BusDueDate,
       		"bd_plant_BusStart": result.bd_plant_BusStart,
       		"bd_plant_BusEndDate": result.bd_plant_BusEndDate,
       		"bd_plant_DevStartDate": result.bd_plant_DevStartDate,
       		"bd_plant_DevEndDate": result.bd_plant_DevEndDate,
       		"bd_plant_DevCompletionDate": result.bd_plant_DevCompletionDate,
       		"bd_plant_OperationStartDate": result.bd_plant_OperationStartDate,
       		"bd_plant_PPADate": result.bd_plant_PPADate
       	};
       	
       	// 각 날짜 필드 처리
       	Object.keys(datePickerFields).forEach(function(fieldId) {
       		var dateValue = datePickerFields[fieldId];
       		var $field = $("#" + fieldId);
       		
       		if(dateValue) {
       			var datePicker = $field.data('daterangepicker');
       			
       			if(datePicker) {
       				// daterangepicker가 있으면 setStartDate 사용
       				try {
       					datePicker.setStartDate(moment(dateValue));
       				} catch(e) {
       					console.error(fieldId + " setStartDate 실패:", e);
       					$field.val(dateValue);
       				}
       			} else {
       				// daterangepicker가 없으면 직접 값 설정
       				$field.val(dateValue);
       			}
       		} else {
       			$field.val("");
       		}
       	});
       	
       	$("#bd_plant_PPAVolum").val(result.bd_plant_PPAVolum)
       	$("#bd_plant_keyno").val(result.bd_plant_keyno)
       	$("#bd_plant_memo").val(result.bd_plant_memo || "")
        	
        		
        	$("#buttondiv2").html('<button class="text-sm md:text-sm lg:text-base font-bold inline-flex items-center px-4 py-2 md:px-4 md:py-2 lg:px-6 lg:py-3 border border-transparent rounded-lg text-white bg-button-red" type="button" onclick="prodeleteInfo();"><i class="glyphicon glyphicon-trash"></i> 삭제</button>')
        	$("#ActionType").html('<i class="glyphicon glyphicon-refresh"></i> 수정')
        	$("#buttionType").val("update");
        	
        },
        error: function(){
        	alert("발전소 선택 에러");
        }
	}); 
}

function providerInsert(){
	// 디버깅: 전송되는 데이터 확인
	console.log("개발행위준공일:", $("#bd_plant_DevCompletionDate").val());
	console.log("사업개시일:", $("#bd_plant_OperationStartDate").val());
	console.log("전송 데이터:", $("#Form").serialize());
	
	 $.ajax({
        url: '/bd/license/PlantInsertAjax.do?${_csrf.parameterName}=${_csrf.token}',
        type: 'POST',
        data: $("#Form").serialize(),
        async: false,  
        success: function(result) {
        	alert(result);
        	location.reload();
        },
        error: function(){
        	alert("발전소 저장 에러(연구소에 문의바랍니다.)");
        }
	}); 
}

function prodeleteInfo(){
	
	if(confirm("현재 발전소를 삭제하시겠습니까?")){
		$.ajax({
			type: "POST",
			url: "/bd/license/PlantDeleteAjax.do?${_csrf.parameterName}=${_csrf.token}",
			async: false,
			data: $('#Form').serializeArray(),
			success : function(data){
				alert(data);
				location.reload();
			}, 
			error: function(){			
			}
		}); 	
	}else
		return false;
}


function excelInsert(){
	var fileInput = document.getElementById("excelFile");
    var file = fileInput.files[0];
    
    console.log(file)
	
    if(!file) {
		alert("파일을 선택해 주세요");
	}else{
		var formData = new FormData();
		formData.append("excelFile", file);
		
		 $.ajax({
		        url: '/bd/license/insertExcel.do?${_csrf.parameterName}=${_csrf.token}',
		        type: 'POST',
		        enctype:'multipart/form-data',
		        contentType : false,
		        processData : false,
		        cache:false,
		        data: formData,
		        success: function(result) {
		        	alert("발전소 등록이 완료되었습니다");
		        	location.reload();
		        }
		        ,beforeSend:function(){
		            $('.wrap-loading').removeClass('display-none');
		        }
		        ,complete:function(){
		            $('.wrap-loading').addClass('display-none');
		        }
		        ,error: function(){
		        	alert("공급자 선택 에러");
		        }
			}); 
	}
}

function validationCheck(){
	if($("#hometaxbill_id").val() == ''){
		alert("아이디를 입력해주세요");
		return false
	}else if($("#spass").val() == ''){
		alert("패스워드를 입력해주세요");
		return false
	}else if($("#apikey").val() == ''){
		alert("인증키를 입력해주세요");
		return false
	}else if($("#ir_companynumber").val() == ''){
		alert("사업자등록번호를 입력해주세요");
		return false
	}else if($("#ir_biztype").val() == ''){
		alert("업태를 입력해주세요");
		return false
	}else if($("#ir_companyname").val() == ''){
		alert("상호를 입력해주세요");
		return false
	}else if($("#ir_ceoname").val() == ''){
		alert("대표자이름을 입력해주세요");
		return false
	}
	return true	
}



//----------------------------------인허가 관련 script---------------------------------------------------------


function providerSelect2(value){
	
	if(value == "0"){
		clear2();
		$("#buttondiv2-2").empty();
		$("#ActionType2").html('<i class="fa fa-floppy-o"></i> 저장')
		$("#buttionType2").val("insert");
	}else{
		providerSelectmethod2(value);
	}
}

function clear2(){
	$("#ie_companynumber").val("")
	$("#ie_biztype").val("")
	$("#ie_companyname").val("")
	$("#ie_bizclassification").val("")
	$("#ie_taxnumber").val("")
	$("#ie_ceoname").val("")
	$("#ie_busename1").val("")
	$("#ie_name1").val("")
	$("#ie_cell1").val("")
	$("#ie_email1").val("")
	$("#ie_busename2").val("")
	$("#ie_name2").val("")
	$("#ie_cell2").val("")
	$("#ie_email2").val("")
	$("#ie_companyaddress").val("")
}

function providerSelectmethod2(value){
	 $.ajax({
        url: '/sfa/bills/supliedSelectAjax.do?${_csrf.parameterName}=${_csrf.token}',
        type: 'POST',
        data: {
        	"dbs_keyno":value
        },
        async: false,  
        success: function(result) {
        	$("#dbs_keyno").val(result.dbs_keyno)
        	$("#ie_companynumber").val(result.dbs_co_num)
        	$("#ie_biztype").val(result.dbs_biztype)
        	$("#ie_companyname").val(result.dbs_name)
        	$("#ie_bizclassification").val(result.dbs_bizclassification)
        	$("#ie_taxnumber").val(result.dbs_taxnum)
        	$("#ie_ceoname").val(result.dbs_ceoname)
        	$("#ie_busename1").val(result.dbs_busename1)
        	$("#ie_name1").val(result.dbs_name1)
        	$("#ie_cell1").val(result.dbs_cell1)
        	$("#ie_email1").val(result.dbs_email1)
        	$("#ie_busename2").val(result.dbs_busename2)
        	$("#ie_name2").val(result.dbs_name2)
        	$("#ie_cell2").val(result.dbs_cell2)
        	$("#ie_email2").val(result.dbs_email2)
        	$("#ie_companyaddress").val(result.dbs_address)
        	
        
        	
        	$("#buttondiv2-2").html('<button class="text-sm md:text-sm lg:text-base font-bold inline-flex items-center px-4 py-2 md:px-4 md:py-2 lg:px-6 lg:py-3 border border-transparent rounded-lg text-white bg-button-blue" type="button" onclick="supdeleteInfo();" style="margin-right:10px;"><i class="glyphicon glyphicon-trash"></i> 삭제</button>')
        	$("#ActionType2").html('<i class="glyphicon glyphicon-refresh"></i> 수정')
        	$("#buttionType2").val("update");
        	
        },
        error: function(){
        	alert("공급자 선택 에러");
        }
	}); 
}

function providerInsert2(){
	 $.ajax({
        url: '/sfa/bills/billsActionAjax2.do?${_csrf.parameterName}=${_csrf.token}',
        type: 'POST',
        data: $("#Form2").serialize(),
        async: false,  
        success: function(result) {
        	alert(result);
        	location.reload();
        },
        error: function(){
        	alert("공급자 선택 에러");
        }
	}); 
}

function supdeleteInfo(){
	if(confirm("현재 공급받는자를 삭제하시겠습니까?")){
		$.ajax({
			type: "POST",
			url: '/sfa/bills/supdelete.do?${_csrf.parameterName}=${_csrf.token}',
			async: false,
			data: $('#Form2').serialize(),
			success : function(data){
				alert(data);
				location.reload();
			}, 
			error: function(){		
				alert("공급자 선택 에러");
			}
		}); 
	}else
		return false;
}
</script>