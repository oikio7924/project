<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.min.css">

<style>

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
<input type="hidden" name="hometaxbill_id" id="hometaxbill_id">
<input type="hidden" name="spass" id="spass">
<input type="hidden" name="apikey" id="apikey">
<input type="hidden" name="signature" id="signature">
<input type="hidden" name="issueid" id="issueid">
<input type="hidden" name="typecode1" id="typecode1" value = "01">
<input type="hidden" name="typecode2" id="typecode2" value = "01">
<input type="hidden" name="dbl_keyno" id="dbl_keyno">
<input type="hidden" name="dbl_sub_keyno" id="dbl_sub_keyno" value = "2">
<input type="hidden" name="chkvalue" id="chkvalue">
<input type="hidden" name="si_hcnt" id="si_hcnt" value = "0">
<input type="hidden" name="checkYN" id="checkYN" value = "N">
<input type="hidden" name="dbp_subkey2" id="dbp_subkey2">
<section id="widget-grid" class="">
	<div class="row">
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-6" id="menu_1" style="width: 100%;">
			<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>세금계산서 리스트</h2>
				</header>
				<div class="widget-body " >
						<div class="widget-body-toolbar bg-color-white">
							<div class="alert alert-info no-margin fade in">
								<button type="button" class="close" data-dismiss="alert">×</button>
								세금계산서 작성 리스트를 확인합니다.
							</div>
							<div class="table-responsive">
							<jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
								<jsp:param value="/dyAdmin/bills/pagingAjax2.do" name="pagingDataUrl" />
							</jsp:include>
							<fieldset id="tableWrap">
							</fieldset>
						</div>
						</div>
			</article>
			<!-- ----------------------------------------------   세금계산서 정보  ----------------------------------------------------------->
			
			<article class="col-xs-12 col-sm-12 col-md-12 col-lg-6" id="menu_2" style="width: 100%; left:0px;" >
				<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0"
					data-widget-editbutton="false" >
					<header>
						<span class="widget-icon"> <i class="fa fa-table"></i>
						</span>
						<h2>세금계산서 정보</h2>
					</header>
					<div>
					<h1 style="float: left; margin-top: 0px; font-size: 15px">공급 받는자 구분</h1>
					<label style="float: left;">
					<input type = "radio" style="margin-left: 13px; margin-top: 5px;" name = "partytypecode" value = "01" title = "기업" checked>
					<span>기업</span> 
					</label>
					<label style="float: left;">
					<input type = "radio" style="margin-left: 13px; margin-top: 5px;" name = "partytypecode" value = "02" title = "개인" >
					<span>개인</span> 
					</label>
					<label style="float: left;">
					<input type = "radio" style="margin-left: 13px; margin-top: 5px;" name = "partytypecode" value = "03" title = "외국인">
					<span>외국인</span> 
					</label>
					</div>
					<div class="widget-body ">
								<div class="form-group">
									<label class="col-md-3"  style ="height: 30px; background-color: #f7b1b1; padding: 7px; margin-left: 11px;">공급자 선택</label>
									
									<div class="col-md-6" style="padding-bottom: 20px;">
									<select class="form-control input-sm select2 ir_keyno" id="dbp_keyno" name="dbp_keyno" onchange="providerSelectMethod(this.value)">
										<option value = "">선택하세요</option>
										<c:forEach items="${billList}" var="b">
											<option value="${b.dbp_keyno}">${b.dbp_name}</option>
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
											<col style="width: 10%;">
											<col style="width: 10%;">
											<col style="width: 10%;">
											<col style="width: 10%;">
											<col style="width: 15%;">
										</colgroup>
										<tbody>
											<tr>
												<td style="background-color: #f7b1b1;">등록 번호</td>
												<td><input type="text" class="form-control check2" id="homemunseo_id" name="homemunseo_id" value="" readonly="readonly"></td>
												<td style="background-color: #f7b1b1;">사업자등록번호</td>
												<td><input type="text" class="form-control check2" id="ir_companynumber" name="ir_companynumber" readonly="readonly"></td>											
												<td style="background-color: #f7b1b1;">업태</td>
												<td><input type="text" class="form-control check2" id="ir_biztype" name="ir_biztype" readonly="readonly"></td>
												<td style="background-color: #f7b1b1;">사업체명</td>
												<td><input type="text" class="form-control check2" id="ir_companyname" name="ir_companyname" readonly="readonly"></td>
											</tr>
											<tr>
												<td style="background-color: #f7b1b1;">업종</td>
												<td><input type="text" class="form-control check2" id="ir_bizclassification" name="ir_bizclassification" readonly="readonly"></td>
												<td style="background-color: #f7b1b1;">대표자명</td>
												<td><input type="text" class="form-control check2" id="ir_ceoname" name="ir_ceoname" readonly="readonly"></td>
												<td style="background-color: #f7b1b1;">회사주소</td>
												<td colspan="3"><input type="text" class="form-control" id="ir_companyaddress" name="ir_companyaddress" readonly="readonly"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
                     <!-- ----------------------------------------------   공급받는자 DIV  ----------------------------------------------------------->
						<div class="form-group">
									<label class="col-md-3" style= "height: 30px; background-color: #b0ccfe; padding: 7px; margin-left: 11px;">공급받는자 선택</label>
									
									<div class="col-md-6" style="padding-bottom: 20px;">
								<select class="form-control input-sm select2 ir_keyno" id="dbs_keyno" name="dbs_keyno" onchange="supliedSelect(this.value)">
									<option>선택하세요</option>
									<c:forEach items="${SuppliedList}" var="b">
										<option value="${b.dbs_keyno}">${b.dbs_name}</option>
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
											<col style="width: 10%;">
											<col style="width: 10%;">
											<col style="width: 10%;">
											<col style="width: 10%;">
											<col style="width: 15%;">
										</colgroup>
										<tbody>
											<tr>
												<td style="background-color: #b0ccfe;">사업자등록번호</td>
												<td><input type="text" class="form-control check2" id="ie_companynumber" name="ie_companynumber" readonly="readonly"></td>
												<td style="background-color: #b0ccfe;">업태</td>
												<td><input type="text" class="form-control check2" id="ie_biztype" name="ie_biztype" readonly="readonly"></td>
												<td style="background-color: #b0ccfe;">사업체명</td>
												<td><input type="text" class="form-control check2" id="ie_companyname" name="ie_companyname" readonly="readonly"></td>
												<td style="background-color: #b0ccfe;">업종</td>
												<td><input type="text" class="form-control check2" id="ie_bizclassification" name="ie_bizclassification" readonly="readonly"></td>
											</tr>
											<tr>
												<td style="background-color: #b0ccfe;">종사업장번호</td>
												<td><input type="text" class="form-control check2" id="ie_taxnumber" name="ie_taxnumber" readonly="readonly"></td>
												<td style="background-color: #b0ccfe;">대표자명</td>
												<td><input type="text" class="form-control check2" id="ie_ceoname" name="ie_ceoname" readonly="readonly"></td>
												<td style="background-color: #b0ccfe;">회사주소</td>
												<td colspan="3"><input type="text" class="form-control" id="ie_companyaddress" name="ie_companyaddress" readonly="readonly"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>	
						 <!-- ----------------------------------------------   부가사항 DIV  ----------------------------------------------------------->
						 	<div id="myTabContent1" class="tab-content padding-10 form-horizontal bv-form" style="margin-top: -40px; text-align: center;">
								<div>
									<table id="" class="table table-bordered table-striped">
										<colgroup>
											<col style="width: 25%;">
											<col style="width: 25%;">
											<col style="width: 25%;">
											<col style="width: 25%;">
											<col style="width: 10%;">
											<col style="width: 15%;">
										</colgroup>
										<tbody>
											<tr>
												<td>작성일자</td>
												<td>공급가격</td>				
												<td>세액</td>			
												<td>비고</td>		
											</tr>
											<tr>	
												<td><input type="text" class="form-control check2" id="issuedate" name="issuedate" value="${nowDate }"></td>
												<td><input type="text" class="form-control check2" id="chargetotal" name="chargetotal" style = "background-color:#e8e8e8" value="0" readonly="readonly"></td>	
												<td><input type="text" class="form-control" id="taxtotal" name="taxtotal" style = "background-color:#e8e8e8" value="0" readonly="readonly"></td>
												<td><input type="text" class="form-control" id="description" name="description"></td>
											</tr>
										</tbody>
									</table>
									<table id="" class="table table-bordered table-striped" style="margin-top: -20px; text-align: center;">
										<colgroup>
											<col style="width: 10%;">
											<col style="width: 10%;">
											<col style="width: 10%;">
											<col style="width: 10%;">
											<col style="width: 10%;">
											<col style="width: 10%;">
											<col style="width: 10%;">
											<col style="width: 20%;">
											
										</colgroup>
										<tbody>
											<tr>
												<td>월/일</td>
												<td>품목</td>				
												<td>규격</td>			
												<td>수량</td>		
												<td>단가</td>		
												<td>공급가액</td>		
												<td>세액</td>		
												<td>비고</td>		
													
											</tr>
											<tr>	
<!-- 											<td><input type="text" class="form-control" id="ie_companyaddress" name="ie_companyaddress" style = "width: 30%; float: left;" >/<input type="text" class="form-control" id="ie_companyaddress" name="ie_companyaddress" style = "width: 30%;"></td> -->
												<td><input type="text" class="form-control check2" id="sub_issuedate" name="sub_issuedate" value="${nowDate }"></td>
												<td><input type="text" class="form-control check2" id="subject" name="subject" value="${itemName }"></td>	
												<td><input type="text" class="form-control" id="unit" name="unit"></td>
												<td><input type="text" class="form-control" id="quantity" name="quantity"></td>
												<td><input type="text" class="form-control" id="unitprice" name="unitprice"></td>
												<td><input type="text" class="form-control" id="supplyprice" name="supplyprice" onkeyup="Divison(this)" oninput = "this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"></td>
												<td><input type="text" class="form-control" id="tax" name="tax" readonly="readonly"></td>
												<td><input type="text" class="form-control" id="sub_description" name="sub_description"></td>
												
											</tr>
										</tbody>
									</table>
									<table id="" class="table table-bordered table-striped" style="margin-top: -20px; text-align: center!important;">
										<colgroup>
											<col style="width: 10%;">
											<col style="width: 10%;">
											<col style="width: 10%;">
											<col style="width: 10%;">
											<col style="width: 10%;">
											<col style="width: 10%;">
										</colgroup>
										<tbody>
											<tr>
												<td>합계금액</td>
												<td>현금</td>				
												<td>수표</td>			
												<td>어음</td>		
												<td>외상미수금</td>	
												<td rowspan = "2" style="text-align: center;">
												<span>
												<label>
													<input type="radio" class="form-control" name="purposetype" title = "영수" value = "01" >영수
												</label>
												<br>
												<label>
													<input type="radio" class="form-control" name="purposetype" title = "청구" value = "02" checked>청구
												</label>
												</span>
												</td>
											</tr>
											<tr>	
												<td><input type="text" class="form-control check2" id="grandtotal" name="grandtotal" onkeyup="inputNumberFormat(this)" value="0"></td>
												<td><input type="text" class="form-control check2" id="cash" name="cash" onkeyup="inputNumberFormat(this)" value="0"></td>	
												<td><input type="text" class="form-control" id="scheck" name="scheck" onkeyup="inputNumberFormat(this)" value="0"></td>
												<td><input type="text" class="form-control" id="draft" name="draft" onkeyup="inputNumberFormat(this)" value="0"></td>
												<td><input type="text" class="form-control" id="uncollected" name="uncollected" onkeyup="inputNumberFormat(this)" value="0"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>	
						     <!-- ----------------------------------------------   발급,수신 담당자 DIV  ----------------------------------------------------------->
						     <div style = "margin-top: 30px">
						     <table id="" class="table table-bordered table-striped" style="text-align: center;">
										<colgroup>
											<col style="width: 10%;">
											<col style="width: 25%;">
											<col style="width: 25%;">
											<col style="width: 25%;">
										</colgroup>
										<tbody>
											<tr>
												<td></td>
												<td>발급 담당자</td>				
												<td>수신 담당자1</td>			
												<td>수신 담당자2</td>		
											</tr>
											<tr>	
												<td>담당자 부서명</td>
												<td><input type="text" class="form-control check2" id="ir_busename" name="ir_busename"></td>	
												<td><input type="text" class="form-control" id="ie_busename1" name="ie_busename1"></td>
												<td><input type="text" class="form-control" id="ie_busename2" name="ie_busename2"></td>
											</tr>
											<tr style = "background-color: #FFFFFF;">
												<td>담당자 명</td>
												<td><input type="text" class="form-control check2" id="ir_name" name="ir_name"></td>	
												<td><input type="text" class="form-control" id="ie_name1" name="ie_name1"></td>
												<td><input type="text" class="form-control" id="ie_name2" name="ie_name2"></td>
											</tr>
											<tr>	
												<td>이메일 주소</td>
												<td><input type="text" class="form-control check2" id="ir_email" name="ir_email"></td>	
												<td><input type="text" class="form-control" id="ie_email1" name="ie_email1"></td>
												<td><input type="text" class="form-control" id="ie_email2" name="ie_email2"></td>
											</tr>
											<tr style = "background-color: #FFFFFF;">
												<td>연락처</td>
												<td><input type="text" class="form-control check2" id="ir_cell" name="ir_cell"></td>
												<td><input type="text" class="form-control" id="ie_cell1" name="ie_cell1"></td>
												<td><input type="text" class="form-control" id="ie_cell2" name="ie_cell2"></td>
											</tr>
										</tbody>
									</table>
									</div>
						<div id="buttondiv">
							<button  class="btn btn-sm btn-primary" id="loadButton"													
								type="button" onclick="loadBillInfo()" style="width: 100px;">저장</button>
							<button class="btn btn-sm btn-default" type="button" onclick="window.scrollTo(0,0);" ><i class="glyphicon glyphicon-chevron-up"></i>Top</button>
						</div>
						</fieldset>
								</div>
							</div>
							<!-- endInsert -->

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


$(document).ready(function(){
	
	$('#issuedate').datepicker()
	$('#conn_date').datepicker()

}); 

function providerSelectMethod(value){
	console.log(value)
	if(value == "선택하세요" ||value == "0"|| value == ""){
		clear();
		
	}else{
		providerSelect();
	}
}

function clear(){
	
	$("#homemunseo_id").val("")
	$("#ir_companynumber").val("")
	$("#ir_biztype").val("")
	$("#ir_companyname").val("")
	$("#ir_bizclassification").val("")
	$("#ir_ceoname").val("")
	$("#ir_companyaddress").val("")

}

function providerSelect(){
	 $.ajax({
       url: '/dyAdmin/bills/proAndSupSelect.do',
       type: 'POST',
       data: $("#Form").serialize(),
       async: false,
       success: function(result) {
    	   
    	   
       	$("#hometaxbill_id").val(result.dbp_id)
       	$("#spass").val(result.dbp_pass)
       	$("#apikey").val(result.dbp_apikey)
       	$("#issueid").val()
	    $("#dbp_keyno").val(result.dbp_keyno)
       	$("#ir_companynumber").val(result.dbp_co_num) 	
       	$("#homemunseo_id").val(result.dbl_homeid)
       	$("#ir_companyname").val(result.dbp_name)
       	$("#ir_ceoname").val(result.dbp_ceoname)
       	$("#ir_companyaddress").val(result.dbp_address)
       	$("#ir_biztype").val(result.dbp_biztype)
       	$("#ir_bizclassification").val(result.dbp_bizclassification)
       	$("#ir_email").val(result.dbp_email)
       	$("#ir_busename").val(result.dbp_busename)
       	$("#ir_name").val(result.dbp_name)
       	$("#ir_email").val(result.dbp_email)
       	$("#ir_cell").val(result.dbp_ir_cell)
       	$("#dbp_sub_keyno").val(result.dbp_sub_keyno) //발행 종류 구분
       	
       	/* 이전 달 공급받는자 따라옴 */
       	$("#dbs_keyno").val(result.dbs_keyno)
       	$("#ie_companynumber").val(result.dbs_co_num)
     	$("#ie_taxnumber").val(result.dbs_taxnum) //종 사업장 번호
       	$("#ie_companyname").val(result.dbs_name)
       	$("#ie_ceoname").val(result.dbs_ceoname)
       	$("#ie_companyaddress").val(result.dbs_address)
       	$("#ie_biztype").val(result.dbs_biztype)
       	$("#ie_bizclassification").val(result.dbs_bizclassification)
       	$("#ie_email").val(result.dbs_email1)
       	$("#ie_busename1").val(result.dbs_busename1)
       	$("#ie_name1").val(result.dbs_name1)
       	$("#ie_email1").val(result.dbs_email1)
       	$("#ie_cell1").val(result.dbs_cell1)
       	$("#ie_name2").val(result.dbs_name2)
       	$("#ie_email2").val(result.dbs_email2)
       	$("#ie_cell2").val(result.dbs_cell2)
       	
       },
       error: function(){
       	alert("공급자 정보 불러오기 에러");
       }
	}); 
}


// ---------------------------- 공급 받는자 --------------------------------------------------------

function supliedSelect(value){
	 $.ajax({
       url: '/dyAdmin/bills/supliedSelectAjax.do',
       type: 'POST',
       data: {
       	"dbs_keyno":value
       },
       async: false,
       success: function(result) {
    	   
    	console.log(result);
       	$("#dbs_keyno").val(result.dbs_keyno)
       	$("#ie_companynumber").val(result.dbs_co_num)
     	$("#ie_taxnumber").val(result.dbs_taxnum) //종 사업장 번호
       	$("#ie_companyname").val(result.dbs_name)
       	$("#ie_ceoname").val(result.dbs_ceoname)
       	$("#ie_companyaddress").val(result.dbs_address)
       	$("#ie_biztype").val(result.dbs_biztype)
       	$("#ie_bizclassification").val(result.dbs_bizclassification)
       	$("#ie_email").val(result.dbs_email1)
       	$("#ie_busename1").val(result.dbs_busename1)
       	$("#ie_name1").val(result.dbs_name1)
       	$("#ie_email1").val(result.dbs_email1)
       	$("#ie_cell1").val(result.dbs_cell1)
       	$("#ie_name2").val(result.dbs_name2)
       	$("#ie_email2").val(result.dbs_email2)
       	$("#ie_cell2").val(result.dbs_cell2)

       	
       },
       error: function(){
       	alert("공급받는자 정보 불러오기 에러");
       }
	}); 
}


function validationCheck(){
	
	if($("#supplyprice").val() == ''){
		alert("공급가액을 입력해주세요");
		return false
	}else if($("#dbs_keyno").val() == '' || $("#dbs_keyno").val() == null ){
		alert("공급받는자를 선택 해주세요");
		return false
	}else if($("#dbp_keyno").val() == '' || $("#dbp_keyno").val() == null ){
		alert("공급자를 선택 해주세요");
		return false
	}
	
	return true
}

function loadBillInfo(){
 	if(!validationCheck()) return false
	 $.ajax({
        url: '/dyAdmin/bills/billsInfoInsert2.do',
        type: 'POST',
        data: $("#Form").serialize(),
        async: false,  
        success: function(result) {
       		if(result == "1"){
       			alert("전송이 완료된 세금계산서는 등록/수정을 할 수 없습니다.")
       		}else if(result != "1" && result != "저장 완료"){
        		if(confirm("동일한 공급자와 공급받는자가 이미 등록되어 있습니다."+ "\n" +"작성한 내용으로 수정하시겠습니까?")){
        			$("#dbl_keyno").val(result)
        			 $.ajax({
        					type: "POST",
        					url: "/dyAdmin/bills/billsInfoUpdate.do",
        					async: false,
        					data: $("#Form").serialize(),
        					success : function(data){
        						alert(data);
        						location.reload();
        					}, 
        					error: function(){
        						
        					}
        			}); 
        		}else false;
        		
        	}else {
        		alert("세금계산서 정보 저장 완료")
        		location.reload();
        	}
        },
        error: function(){
        	alert("저장 실패");
        }
	}); 
}

function detailView(keyno){
	$.ajax({
		url: '/dyAdmin/bills/selectAllView.do',
		type: 'POST',
		data: {
			"dbl_keyno" : keyno
		},
		async: false,
		success : function(data){
			
			
			
			$("#dbl_keyno").val(data.dbl_keyno)
			$("#dbp_keyno").val(data.dbp_keyno)
			$("#homemunseo_id").val(data.dbl_homeid)
			$("#ir_companynumber").val(data.dbp_co_num)
			$("#ir_biztype").val(data.dbp_biztype)
			$("#ir_companyname").val(data.dbp_name)
			$("#ir_bizclassification").val(data.dbp_bizclassification)
			$("#ir_ceoname").val(data.dbp_ceoname)
			$("#ir_companyaddress").val(data.dbp_address)
			
			
			$("#dbs_keyno").val(data.dbs_keyno)
			$("#ie_companynumber").val(data.dbs_co_num)
			$("#ie_biztype").val(data.dbs_biztype)
			$("#ie_companyname").val(data.dbs_name)
			$("#ie_taxnumber").val(data.dbs_taxnum)
			$("#ie_bizclassification").val(data.dbs_bizclassification)
			$("#ie_ceoname").val(data.dbs_ceoname)
			$("#ie_companyaddress").val(data.dbs_address)
			
			
			$("#partytypecode").val(data.dbl_partytypecode)
			$("#purposetype").val(data.dbl_purposetype)
			$("#issuedate").val(data.dbl_issuedate)
			$("#chargetotal").val(data.dbl_chargetotal)
			$("#taxtotal").val(data.dbl_taxtotal)
			$("#description").val(data.dbl_description)
			$("#sub_issuedate").val(data.dbl_sub_issuedate)
			$("#subject").val(data.dbl_subject)
			$("#unit").val(data.dbl_unit)
			$("#quantity").val(data.dbl_quantity)
			$("#unitprice").val(data.dbl_unitprice)
			$("#supplyprice").val(data.dbl_supplyprice)
			$("#tax").val(data.dbl_tax)
			$("#sub_description").val(data.dbl_description)
			$("#si_hcnt").val(data.dbl_si_hcnt)
			
			
			$("#grandtotal").val(data.dbl_grandtotal)
			$("#cash").val(data.dbl_cash)
			$("#scheck").val(data.dbl_scheck)
			$("#draft").val(data.dbl_draft)
			$("#uncollected").val(data.dbl_uncollected)
			
			
			$("#ir_busename").val(data.dbp_busename)
			$("#ie_busename1").val(data.dbs_busename1)
			$("#ie_busename2").val(data.dbs_busename2)
			$("#ir_name").val(data.dbp_ir_name)
			$("#ie_name1").val(data.dbs_name1)
			$("#ie_name2").val(data.dbs_name2)
			$("#ir_email").val(data.dbp_email)
			$("#ie_email1").val(data.dbs_email1)
			$("#ie_email2").val(data.dbs_email2)
			$("#ir_cell").val(data.dbp_ir_cell)
			$("#ie_cell1").val(data.dbs_cell1)
			$("#ie_cell2").val(data.dbs_cell2)
			
			
			
			if(data.dbl_checkYN == "N" || data.dbl_checkYN == "W"){
				
				$("#buttondiv").html("<button type='button' class='btn btn-default' onclick='window.location.reload()'><i class='fa fa-repeat'></i> 새로고침</button>")
				$("#buttondiv").append("<button class='btn btn-sm btn-primary'  style='margin-left: 3%; width: 100px;'id='loadButton' type='button' onclick='loadBillInfo()' >저장</button>")
				$("#buttondiv").append("<button class='btn btn-sm btn-default' type='button' onclick='window.scrollTo(0,0);' style='margin-left: 3%;'><i class='glyphicon glyphicon-chevron-up'></i>Top</button>")
				$("#loadButton").text("수정");
				$("#loadButton").attr("onclick","detailViewUpdate()");
						
				}else{
					$("#loadButton").remove();
					$("#buttondiv").html("<button type='button' class='btn btn-default' onclick='window.location.reload()'><i class='fa fa-repeat'></i> 새로고침</button>")
					$("#buttondiv").append("<button class='btn btn-sm btn-default' type='button' onclick='window.scrollTo(0,0);' style ='margin-left: 2%;'><i class='glyphicon glyphicon-chevron-up'></i>Top</button>")
				}
		}, 
		error: function(){
			cf_smallBox('error', "저장에러", 3000,'#d24158');
		}
	});
}

function sendNTS(){
	
	
	var array = new Array(); 
	$('input:checkbox[name=chk]:checked').each(function() { // 체크된 체크박스의 value 값을 가지고 온다.
	    array.push(this.value);
	});
	
	$("#chkvalue").val(array);
	$("#checkYN").val("Y");
	
	
	if(array.length > 0){
		if(confirm("전송하시겠습니까?")){
			alert("전송 완료");
			location.reload();
			$.ajax({
					type: "POST",
					url: "/dyAdmin/bills/sendNTS.do",
					data: $('#Form').serializeArray(),
					async: false,
					success : function(data){
						
					}, 
					error: function(){
						
					}
			});
		}else{
			cf_smallBox('error', "취소되었습니다.", 3000,'#d24158');
		}
	}else{
		alert("전송할 세금계산서를 선택해주세요.")
	}

return false;
}


function delaysend(){
	
	var array = new Array(); 
	$('input:checkbox[name=chk]:checked').each(function() { // 체크된 체크박스의 value 값을 가지고 온다.
	    array.push(this.value);
	});
	
	$("#chkvalue").val(array);
	$("#checkYN").val("Y");
	
	
	if(array.length > 0){
		if(confirm("전송하시겠습니까?")){
			$.ajax({
					type: "POST",
					url: "/dyAdmin/bills/senddelay.do",
					data: $('#Form').serializeArray(),
					async: false,
					success : function(data){
						alert("전송대기상태로 변경되었습니다. 19시 00분에 일괄전송됩니다.");
						location.reload();
					}, 
					error: function(){
						
					}
			});
		}else{
			cf_smallBox('error', "취소되었습니다.", 3000,'#d24158');
		}
	}else{
		alert("전송할 세금계산서를 선택해주세요.")
	}

return false;
}


function deleteInfo(){
	
	var array = new Array(); 
	$('input:checkbox[name=chk]:checked').each(function() { // 체크된 체크박스의 value 값을 가지고 온다.
	    array.push(this.value);
	});
	
	$("#chkvalue").val(array);
	$("#checkYN").val("Y");
	
	
	if(array.length > 0){
		if(confirm("삭제하시겠습니까?")){
			$.ajax({
					type: "POST",
					url: "/dyAdmin/bills/deleteInfo.do",
					data: $('#Form').serializeArray(),
					async: false,
					success : function(data){
						alert("삭제가 완료되었습니다.");
						location.reload();
					}, 
					error: function(){
						
					}
			});
		}else{
			cf_smallBox('error', "취소되었습니다.", 3000,'#d24158');
		}
	}else{
		alert("삭제할 세금계산서를 선택해주세요.")
	}

return false;
}

function detailViewUpdate(){
	 
	if(!validationCheck()) return false
		 $.ajax({
				type: "POST",
				url: "/dyAdmin/bills/billsInfoUpdate.do",
				async: false,
				data: $('#Form').serializeArray(),
				success : function(data){
					alert(data);
					location.reload();
				}, 
				error: function(){
					
				}
		}); 
	 }


function seletAll(){
	
	if($("#cbx_chkAll").is(":checked")) $("input[name=chk]").prop("checked", true);
	else $("input[name=chk]").prop("checked", false);
}


function inputNumberFormat(obj) {
    obj.value = comma(uncomma(obj.value));
}

function comma(str) {
    str = String(str);

    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}

function uncomma(str) {
    str = String(str);
    return str.replace(/[^\d]+/g, '');
}


function Divison(obj){
	
	var v = obj.value.replace(",","");
	
	var tax = Math.floor(v*0.1)
	var v1 = Number(v)
	var tax1 = Number(tax)
	var total = v1+tax1
//	var tax1 = (v/1.1).toFixed(0)
//	var tax2 = (tax1*0.1).toFixed(0)
	
//	$("#unitprice").val(comma(v))
	$("#supplyprice").val(comma(v))
	$("#unitprice").val(comma(v))
	$("#grandtotal").val(comma(total))
	$("#chargetotal").val(comma(v))
	
	if (tax > 0) {
		$("#tax").val(comma(tax))
		$("#taxtotal").val(comma(tax))
	}else{
		$("#tax").val(tax)
		$("#taxtotal").val(tax)
	}

}

function focus_p(){
	document.getElementById("supplyprice").focus();
}
</script>