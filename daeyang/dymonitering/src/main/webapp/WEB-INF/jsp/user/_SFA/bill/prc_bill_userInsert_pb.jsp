<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>

<main class="h-full overflow-y-auto ">
          <div class="container grid px-6 mx-auto">
            <div class="relative">
              <div
                class="w-full rounded-lg bg-indigo-200 text-center p-2 md:p-2 lg:p-4 text-sm md:text-sm lg:text-base md:text-base lg:text-lg font-bold my-4 md:md-4 lg:my-7">
                공급자 개별 등록</div>
              <form:form id="Form" class="form-horizontal" name="Form"  method="post">
              <div class="w-full rounded-lg bg-white p-5 my-4 md:md-4 lg:my-7">
                <p class="font-bold text-base md:text-base lg:text-lg flex items-center">
                  <span class="p-1 rounded-full mr-2 p-1 green_spot"></span>
                  세금계산서 공급자 등록
                </p>
                <p class="font-semibold text-sm md:text-sm lg:text-base my-3 md:my-3 lg:my-5">*공급자 선택</p>
                
                  <select name="user" id="user" onchange="providerSelect(this.value)" class="default_input_style input_padding_y_4px">
                    <option value="0">신규등록</option>
                    <c:forEach items="${billList }" var="b">
					<option value="${b.dbp_keyno }">${b.dbp_name }</option>
					</c:forEach>
                  </select>
                  <div class="grid grid-cols-4 gap-y-2 gap-x-6 mt-4">
                    <div class="flex items-center flex-shrink-0">
                      <label for="id"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">회사코드(ID)</label>
                      <input type="text" id="hometaxbill_id" name="hometaxbill_id"
                        class="w-full rounded-sm border_input_style input_padding_y_4px"/>
                    </div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="password"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">패스워드</label>
                      <input type="text" id="spass" name="spass"
                        class="w-full rounded-sm border_input_style input_padding_y_4px"/>
                    </div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="auth_key"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">인증키</label>
                      <input type="text" id="apikey" name="apikey"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="classification"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">업종명</label>
                      <input type="text" id="ir_bizclassification" name="ir_bizclassification"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="business_registration_number"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">사업자등록번호</label>
                      <input type="text" id="ir_companynumber" name="ir_companynumber"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="category"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">업태명</label>
                      <input type="text" id="ir_biztype" name="ir_biztype"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="company_name"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">상호명</label>
                      <input type="text" id="ir_companyname" name="ir_companyname"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="phone"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">담당자
                        전화번호</label>
                      <input type="text" id="ir_cell" name="ir_cell"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="1"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">대표자
                        성명</label>
                      <input type="text" id="ir_ceoname" name="ir_ceoname"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="department"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">담당부서명</label>
                      <input type="text" id="ir_busename" name="ir_busename"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="name_of_person_in_charge."
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">담당자명</label>
                      <input type="text" id="ir_name" name="ir_name"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                    <div class="flex items-center flex-shrink-0"></div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="email"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">담당자
                        이메일</label>
                      <input type="text" id="ir_email" name="ir_email"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                    <div class="flex items-center flex-shrink-0"></div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="address"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">주소</label>
                      <input type="text" id="ir_companyaddress" name="ir_companyaddress"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                  </div>
                  <div class="w-full border my-3 md:my-3 lg:my-5"></div>
                  <div id ="buttondiv2" style="float:right;">
<!-- 						<button class="btn btn-sm btn-danger" type="button" onclick="clear()" style="margin-right:10px;"><i class="glyphicon glyphicon-trash"></i> 삭제 -->
<!-- 						</button> -->
				  </div>
                  <div id = "buttondiv1">
					  <input type="hidden" id="buttionType" name="buttionType" value="insert"> 
					  <input type="hidden" id="dbp_keyno" name="dbp_keyno" value=""> 
					  <input type="hidden" id="dbp_UI_KEYNO" name="dbp_UI_KEYNO" value="${UI_KEYNO }"> 
	                  <button type="button" id="ActionType" onclick="providerInsert();"
	                    class=" text-sm md:text-sm lg:text-base font-bold inline-flex items-center px-4 py-2 md:px-4 md:py-2 lg:px-6 lg:py-3 border border-transparent rounded-lg text-white bg-button-blue">저장</button>
				  </div>                
              </div>
              </form:form>
              <div
                class="w-full rounded-lg bg-indigo-200 text-center p-2 md:p-2 lg:p-4 text-sm md:text-sm lg:text-base md:text-base lg:text-lg font-bold my-4 md:md-4 lg:my-7">
                공급받는자 등록</div>
              <form:form id="Form2" class="form-horizontal" name="Form2"  method="post">
              <div class="w-full rounded-lg bg-white p-5 my-4 md:md-4 lg:my-7">
                <p class="font-bold text-base md:text-base lg:text-lg flex items-center">
                  <span class="p-1 rounded-full mr-2 p-1 green_spot"></span>
                  세금계산서 공급받는자 등록
                </p>
                <p class="font-semibold text-sm md:text-sm lg:text-base my-3 md:my-3 lg:my-5">*공급받는자 선택</p>
                  <select id="dbs_keyno" name="dbs_keyno" onchange="providerSelect2(this.value)" class="default_input_style input_padding_y_4px">
	                   	<option value="0">신규 등록</option>
						<c:forEach items="${billList_sub }" var="b">
							<option value="${b.dbs_keyno }">${b.dbs_name }</option>
						</c:forEach>
                  </select>
                  <div class="grid grid-cols-4 gap-y-2 gap-x-6 mt-4">
                    <div class="flex items-center flex-shrink-0">
                      <label for="business_registration_number"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">사업자등록번호</label>
                      <input type="text" id="ie_companynumber" name="ie_companynumber"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="category"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">업태명</label>
                      <input type="text" id="ie_biztype" name="ie_biztype"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="name"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">사업체명</label>
                      <input type="text" id="ie_companyname" name="ie_companyname"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="classification"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">업종명</label>
                      <input type="text" id="ie_bizclassification" name="ie_bizclassification"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="tax_registration_id"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">종사업자번호</label>
                      <input type="text" id="ie_taxnumber" name="ie_taxnumber"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="representative_name"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">대표자명</label>
                      <input type="text" id="ie_ceoname" name="ie_ceoname"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="department1"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">담당부서1</label>
                      <input type="text" id="ie_busename1" name="ie_busename1"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="name_of_person_in_charge1"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">담당자명1</label>
                      <input type="text" id="ie_name1" name="ie_name1"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="phone1"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">담당자연락처1</label>
                      <input type="text" id="ie_cell1" name="ie_cell1"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="email1"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">담당자이메일1</label>
                      <input type="text" id="ie_email1" name="ie_email1"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="department2"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">담당부서2</label>
                      <input type="text" id="ie_busename2" name="ie_busename2"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="name_of_person_in_charge2"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">담당자명2</label>
                      <input type="text" id="ie_name2" name="ie_name2"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="phone2"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">담당자연락처2</label>
                      <input type="text" id="ie_cell2" name="ie_cell2"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                    <div class="flex items-center flex-shrink-0"></div>
                    <div class="flex items-center flex-shrink-0">
                      <label for="address"
                        class="text-xs w-28 font-semibold text-black rounded-sm mr-2.5 flex items-center">회사주소</label>
                      <input type="text" id="ie_companyaddress" name="ie_companyaddress"
                        class="w-full rounded-sm border_input_style input_padding_y_4px" value="" />
                    </div>
                  </div>

                  <div class="w-full border my-3 md:my-3 lg:my-5"></div>
                  <div id ="buttondiv2-2" style ="float: right">
<!-- 						<button class="btn btn-sm btn-danger" type="button" onclick="clear()" style="margin-right:10px;"><i class="glyphicon glyphicon-trash"></i> 삭제 -->
<!-- 						</button> -->
				  </div>
				  <div id = "buttondiv1-2">
					  <input type="hidden" id="buttionType" name="buttionType" value="insert"> 
					  <input type="hidden" id="dbp_keyno" name="dbp_keyno" value=""> 
					  <input type="hidden" id="dbp_keyno2" name="dbp_keyno2" value=""> 
					  <input type="hidden" id="dbs_UI_KEYNO" name="dbs_UI_KEYNO" value="${UI_KEYNO }">
	                  <button type="button" id="ActionType2" onclick="providerInsert2();"
	                    class="text-sm md:text-sm lg:text-base font-bold inline-flex items-center px-4 py-2 md:px-4 md:py-2 lg:px-6 lg:py-3 border border-transparent rounded-lg text-white bg-button-blue">저장</button>
				  </div>
              </div>
              </form:form>
            </div>
          </div>
        </main>
        
<script type="text/javascript">

$(function() {

	
});


function providerSelect(value){
	console.log(value)
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
	$("#hometaxbill_id").val("")
	$("#spass").val("")
	$("#apikey").val("")
	$("#ir_companynumber").val("")
	$("#ir_biztype").val("")
	$("#ir_companyname").val("")
	$("#ir_ceoname").val("")
	$("#ir_busename").val("")
	$("#ir_name").val("")
	$("#ir_cell").val("")
	$("#ir_email").val("")
	$("#ir_companyaddress").val("")
	$("#ir_bizclassification").val("")
}

function providerSelectmethod(value){
	 $.ajax({
        url: '/bills/providerSelectAjax.do?${_csrf.parameterName}=${_csrf.token}',
        type: 'POST',
        data: {
        	"dbp_keyno":value
        },
        async: false,  
        success: function(result) {
        	$("#dbp_keyno").val(result.dbp_keyno)
        	$("#hometaxbill_id").val(result.dbp_id)
        	$("#spass").val(result.dbp_pass)
        	$("#apikey").val(result.dbp_apikey)
        	$("#ir_companynumber").val(result.dbp_co_num)
        	$("#ir_biztype").val(result.dbp_biztype)
        	$("#ir_companyname").val(result.dbp_name)
        	$("#ir_bizclassification").val(result.dbp_bizclassification)
        	$("#ir_ceoname").val(result.dbp_ceoname)
        	$("#ir_busename").val(result.dbp_busename)
        	$("#ir_name").val(result.dbp_ir_name)
        	$("#ir_cell").val(result.dbp_ir_cell)
        	$("#ir_email").val(result.dbp_email)
        	$("#ir_companyaddress").val(result.dbp_address)
        	
        	
        		
        	$("#buttondiv2").html('<button class="text-sm md:text-sm lg:text-base font-bold inline-flex items-center px-4 py-2 md:px-4 md:py-2 lg:px-6 lg:py-3 border border-transparent rounded-lg text-white bg-button-blue" type="button" onclick="prodeleteInfo();" style="margin-right:10px;"><i class="glyphicon glyphicon-trash"></i> 삭제</button>')
        	$("#ActionType").html('<i class="glyphicon glyphicon-refresh"></i> 수정')
        	$("#buttionType").val("update");
        	
        },
        error: function(){
        	alert("공급자 선택 에러");
        }
	}); 
}

function providerInsert(){
	
	if(!validationCheck()) return false
	
	 $.ajax({
        url: '/sfa/bills/billsActionAjax.do?${_csrf.parameterName}=${_csrf.token}',
        type: 'POST',
        data: $("#Form").serialize(),
        async: false,  
        success: function(result) {
        	location.reload();
        	alert(result);
        },
        error: function(){
        	alert("공급자 선택 에러");
        }
	}); 
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

function prodeleteInfo(){
	
	if(confirm("현재 공급자를 삭제하시겠습니까?")){
	
		$.ajax({
			type: "POST",
			url: "/sfa/bills/prodelete.do?${_csrf.parameterName}=${_csrf.token}",
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



//----------------------------------공급받는자 script---------------------------------------------------------


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
	
	//if(!validationCheck2()) return false
	
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