<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<%@ include file="/WEB-INF/jsp/dyAdmin/include/CodeMirror_Include.jsp"%>

<div id="content">

	<section id="widget-grid">
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" id="" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-table"></i>
						</span>
					    <h2>공급자 개별 등록</h2>
					</header>

					<div class="widget-body">

						<form:form id="Form" class="form-horizontal" name="Form"  method="post">
							<legend>
								<div class="widget-body-toolbar bg-color-white">
									<div class="alert alert-info no-margin fade in">
										<button type="button" class="close" data-dismiss="alert">×</button>
										세금계산서 공급자 등록 
									</div>
								</div>
							</legend>

							<div id="myTabContent1"
								class="tab-content padding-10 form-horizontal bv-form">
								
								<div class="form-group">
									<label class="col-md-3 control-label"><span class="nessSpan">*</span> 공급자 선택</label>
									
									<div class="col-md-6">
										<select class="form-control input-sm select2" id="user" name="user" onchange="providerSelect(this.value)">
											<option value="0">신규 등록</option>
											<c:forEach items="${billList }" var="b">
												<option value="${b.dbp_keyno }">${b.dbp_name }</option>
											</c:forEach>
										</select>
									</div>
								</div>								
								<div>
									<table id="" class="table table-bordered table-striped">
										<colgroup>
											<col style="width: 10%;">
											<col style="width: 15%;">
											<col style="width: 10%;">
											<col style="width: 15%;">
											<col style="width: 10%;">
											<col style="width: 15%;">
										</colgroup>
										<tbody>
											<tr>
												<td>회사코드(아이디)</td>
												<td><input type="text" class="form-control check" id="hometaxbill_id" name="hometaxbill_id"></td>
												<td>패스워드</td>
												<td><input type="text" class="form-control check" id="spass" name="spass"></td>
												<td>인증키</td>
												<td colspan="3"><input type="text" class="form-control check" id="apikey" name="apikey"></td>
											</tr>
											<tr>
												<td>사업자등록번호</td>
												<td><input type="text" class="form-control check" id="ir_companynumber" name="ir_companynumber"></td>
												<td>업태</td>
												<td><input type="text" class="form-control check" id="ir_biztype" name="ir_biztype" ></td>
												<td>상호</td>
												<td><input type="text" class="form-control check" id="ir_companyname" name="ir_companyname" ></td>
												<td>업종</td>
												<td><input type="text" class="form-control check" id="ir_bizclassification" name="ir_bizclassification" ></td>
											</tr>
											<tr>
												<td>대표자성명</td>
												<td><input type="text" class="form-control check" id="ir_ceoname" name="ir_ceoname"></td>
												<td>담당부서명</td>
												<td><input type="text" class="form-control" id="ir_busename" name="ir_busename"></td>
												<td>담당자명</td>
												<td><input type="text" class="form-control" id="ir_name" name="ir_name"></td>
												<td>담당자전화번호</td>
												<td><input type="text" class="form-control" id="ir_cell" name="ir_cell"></td>
											</tr>
											<tr>
												<td>담당자이메일</td>
												<td colspan="3"><input type="text" class="form-control" id="ir_email" name="ir_email"></td>
												<td>주소</td>
												<td colspan="3"><input type="text" class="form-control" id="ir_companyaddress" name="ir_companyaddress"></td>
											</tr>
											<tr>
												<td colspan="8">
													<fieldset class="padding-10 text-right" id="buttonset">
													<div id = "buttondiv2" style ="float: right;">
<!-- 														<button class="btn btn-sm btn-danger" type="button" onclick="" style="margin-right:10px;"><i class="glyphicon glyphicon-trash"></i> 삭제 -->
<!-- 														</button> -->
													</div>
													<div id = "buttondiv1" style ="float: right;">
														<input type="hidden" id="buttionType" name="buttionType" value="insert"> 
														<input type="hidden" id="dbp_keyno" name="dbp_keyno" value=""> 
														<button type="button" id="ActionType" onclick="providerInsert();" class="btn btn-sm btn-primary"><i class="fa fa-floppy-o"></i> 저장
														</button>
													</div>
													</fieldset>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</form:form>
					</div>
				</div>
			</article>
		</div>
	</section>
	
	
		<section id="widget-grid">
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" id="" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-table"></i>
						</span>
					    <h2>공급받는자 등록</h2>
					</header>

					<div class="widget-body">

						<form:form id="Form2" class="form-horizontal" name="Form2"  method="post">
							<legend>
								<div class="widget-body-toolbar bg-color-white">
									<div class="alert alert-info no-margin fade in">
										<button type="button" class="close" data-dismiss="alert">×</button>
										세금계산서 공급받는자 개별 등록 
									</div>
								</div>
							</legend>


							<div class="form-group">
									<label class="col-md-3 control-label"><span class="nessSpan">*</span> 공급받는자 선택</label>
									
									<div class="col-md-6">
										<select class="form-control input-sm select2" id="user" name="user" onchange="providerSelect2(this.value)">
											<option value="0">신규 등록</option>
											<c:forEach items="${billList_sub }" var="b">
												<option value="${b.dbs_keyno }">${b.dbs_name }</option>
											</c:forEach>
										</select>
									</div>
								</div>


							<div id="myTabContent1"
								class="tab-content padding-10 form-horizontal bv-form">
								<div>
									<table id="" class="table table-bordered table-striped">
										<colgroup>
											<col style="width: 10%;">
											<col style="width: 15%;">
											<col style="width: 10%;">
											<col style="width: 15%;">
											<col style="width: 10%;">
											<col style="width: 15%;">
										</colgroup>
										<tbody>
											<tr>
												<td>사업자등록번호</td>
												<td><input type="text" class="form-control check2" id="ie_companynumber" name="ie_companynumber"  required oninvalid="this.setCustomValidity('Please select the item.')"  oninput="this.setCustomValidity('')"></td>
												<td>업태</td>
												<td><input type="text" class="form-control check2" id="ie_biztype" name="ie_biztype" ></td>
												<td>사업체명</td>
												<td><input type="text" class="form-control check2" id="ie_companyname" name="ie_companyname" ></td>
												<td>업종</td>
												<td><input type="text" class="form-control check2" id="ie_bizclassification" name="ie_bizclassification" ></td>
											</tr>
											<tr>
												<td>종사업장번호</td>
												<td><input type="text" class="form-control check2" id="ie_taxnumber" name="ie_taxnumber"></td>
												<td>대표자명</td>
												<td><input type="text" class="form-control check2" id="ie_ceoname" name="ie_ceoname"></td>
												<td>담당부서1</td>
												<td><input type="text" class="form-control" id="ie_busename1" name="ie_busename1"></td>
												<td>담당자명1</td>
												<td><input type="text" class="form-control" id="ie_name1" name="ie_name1"></td>
											</tr>
											<tr>
												<td>담당자연락처1</td>
												<td><input type="text" class="form-control" id="ie_cell1" name="ie_cell1"></td>
												<td>담당자이메일1</td>
												<td><input type="text" class="form-control" id="ie_email1" name="ie_email1"></td>
												<td>담당부서2</td>
												<td><input type="text" class="form-control" id="ie_busename2" name="ie_busename2"></td>
												<td>담당자명2</td>
												<td><input type="text" class="form-control" id="ie_name2" name="ie_name2"></td>
											</tr>
											<tr>
												<td>담당자연락처2</td>
												<td><input type="text" class="form-control" id="ie_cell2" name="ie_cell2"></td>
												<td>담당자이메일2</td>
												<td><input type="text" class="form-control" id="ie_email2" name="ie_email2"></td>
												<td>회사주소</td>
												<td colspan="3"><input type="text" class="form-control" id="ie_companyaddress" name="ie_companyaddress"></td>
											</tr>
											<tr>
												<td colspan="8">
													<fieldset class="padding-10 text-right" id = "buttonset2"> 
													<div id ="buttondiv2-2" style ="float: right">
<!-- 														<button class="btn btn-sm btn-danger" type="button" onclick="clear()" style="margin-right:10px;"><i class="glyphicon glyphicon-trash"></i> 삭제 -->
<!-- 														</button> -->
													</div>
													<div id = "buttondiv1-2" style ="float: right">
														<input type="hidden" id="buttionType2" name="buttionType2" value="insert">
														<input type="hidden" id="dbs_keyno" name="dbs_keyno" value=""> 
														<input type="hidden" id="dbp_keyno2" name="dbp_keyno2" value=""> 
														<button type="button" onclick="providerInsert2();" class="btn btn-sm btn-primary" id="ActionType2"><i class="fa fa-floppy-o"></i> 저장
														</button>
													</div>
													</fieldset>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</form:form>
					</div>
				</div>
			</article>
		</div>
	</section>
	
	<section id="widget-grid">
		 <div class="row">
				<article class="col-sm-12 col-md-12 col-lg-12">
					<div class="jarviswidget jarviswidget-color-blueDark" id="" data-widget-editbutton="false">
						<header>
							<span class="widget-icon"> <i class="fa fa-table"></i>
							</span>
						    <h2>팝빌 회원가입</h2>
						</header>
						<div class="widget-body-toolbar bg-color-white">
						<legend>
								<div class="widget-body-toolbar bg-color-white">
									<div class="alert alert-info no-margin fade in">
										<button type="button" class="close" data-dismiss="alert">×</button>
										양식에 맞는 엑셀 파일을 등록한 후 회원가입 버튼을 눌러주세요
									</div>
								</div>
							</legend>
							<div class="row">
								<div class="col-sm-6 col-md-2 text-align-right" style="float:right;">
									<div class="btn-group">  
										<button class="btn btn-sm btn" type="button" onclick="popbillexcelInsert();" >
											<i class="fa fa-plus"></i>회원 가입
										</button>
									</div>
								</div>
								
								<div class="col-sm-6 col-md-2 text-align-right" style="float:right;">
									<div class="btn-group">  
										<input type="file" id="excelFile2" name="excelFile2">
									</div>
								</div> 
							</div>
					</div>
				</div>
			</article>
		</div>
	</section>
</div>


<script type="text/javascript">

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
        url: '/dyAdmin/bills/providerSelectAjax.do',
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
        	
        	
        		
        	$("#buttondiv2").html('<button class="btn btn-sm btn-danger" type="button" onclick="prodeleteInfo();" style="margin-right:10px;"><i class="glyphicon glyphicon-trash"></i> 삭제</button>')
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
        url: '/dyAdmin/bills/billsActionAjax.do',
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
		url: "/dyAdmin/bills/prodelete.do",
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
        url: '/dyAdmin/bills/supliedSelectAjax.do',
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
        	
        
        	
        	$("#buttondiv2-2").html('<button class="btn btn-sm btn-danger" type="button" onclick="supdeleteInfo();" style="margin-right:10px;"><i class="glyphicon glyphicon-trash"></i> 삭제</button>')
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
        url: '/dyAdmin/bills/billsActionAjax2.do',
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
		url: '/dyAdmin/bills/supdelete.do',
		async: false,
		data: $('#Form2').serializeArray(),
		success : function(data){
			location.reload();
			alert(data);
		}, 
		error: function(){
			
		}
	}); 
	
	}else
		return false;
	
}

function popbillexcelInsert(){
	
	var formData = new FormData();
    formData.append('excelFile2', $('#excelFile2')[0].files[0]);

    $.ajax({
        type: "POST",
        url: '/popBillInsertExcel.do?${_csrf.parameterName}=${_csrf.token}',
        data: formData,
        processData: false,
        contentType: false,
        success: function(data) {
            alert(data);
            location.reload();
        },
        error: function() {
            // Handle error
        }
    });
	
// 	var formData = new FormData();
//     formData.append('excelFile2', $('#excelFile2')[0].files[0]);
	
	
// 	$.ajax({
// 		type: "POST",
// 		url: '/popBillInsertExcel.do?${_csrf.parameterName}=${_csrf.token}',
// 		data: {
// 			'excelFile2' : formData
// 		},
// 		success : function(data){
// 			alert(data);
// 			location.reload();
// 		}, 
// 		error: function(){
			
// 		}
// 	}); 
	
// 	$("#Form").attr("action","/popBillInsertExcel.do?${_csrf.parameterName}=${_csrf.token}");
// 	$("#Form").submit();

}



</script>