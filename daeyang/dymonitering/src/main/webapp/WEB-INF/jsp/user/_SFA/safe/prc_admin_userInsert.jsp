<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<div id="content">
	<section id="widget-grid">
		<div class="row">
				<form:form id="Form"  action="" method="post">
				<input type="hidden" name="chkvalue" id="chkvalue">
				<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12" id="menu_1">
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
						<%-- <jsp:include page="/WEB-INF/jsp/user/_SFA/include/search/pra_search_header_paging.jsp" flush="true"> --%>
						<jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
							<jsp:param value="/sfa/sfaAdmin/USerpagingAjax.do" name="pagingDataUrl" />
						</jsp:include>
						<fieldset id="tableWrap">
						</fieldset>
					</div>
				</div>
			</div>
		</article>
		</form:form>
		
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" id="" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-table"></i>
						</span>
					    <h2>발전소 등록</h2>
					</header>

					<div class="widget-body">

						<form:form id="Form2" class="form-horizontal" name="Form2"  method="post" action="" enctype="multipart/form-data">
							<legend>
								<div class="widget-body-toolbar bg-color-white">
									<div class="alert alert-info no-margin fade in">
										<button type="button" class="close" data-dismiss="alert">×</button>
										안전관리 발전소 등록
									</div>
								</div>
							</legend>
							
							<div class="widget-body-toolbar bg-color-white">
								<div class="row">
									
									<div class="col-sm-6 col-md-2 text-align-right" style="float:right;">
										<div class="btn-group">  
											<button class="btn btn-sm btn" type="button" onclick="excelInsert();" >
												<i class="fa fa-plus"></i>엑셀 등록
											</button>
										</div>
									</div>
									
									<div class="col-sm-6 col-md-2 text-align-right" style="float:right;">
										<div class="btn-group">  
											<input type="file" id="excelFile" name="excelFile">
										</div>
									</div> 
								</div>
							</div>

							<div class="form-group">
									<label class="col-md-3 control-label"><span class="nessSpan">*</span> 발전소 선택</label>
									
									<div class="col-md-6">
										<select class="form-control input-sm select2" id="user" name="user" onchange="providerSelect2(this.value)">
											<option value="0">신규 등록</option>
											<c:forEach items="${safeuserlist }" var="b">
												<option value="${b.SU_KEYNO }">${b.SU_SA_SULBI }</option>
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
												<td>발전소 명</td>
												<td><input type="text" class="form-control check" id="SU_SA_SULBI" name="SU_SA_SULBI"></td>
												<td>발전소 지역</td>
												<td><input type="text" class="form-control check2" id="SU_SA_AREA" name="SU_SA_AREA" ></td>
												<td>발전소 주소</td>
												<td><input type="text" class="form-control check" id="SU_SA_AD" name="SU_SA_AD"></td>
											</tr>
											<tr>
												<td>발전소 용량</td>
												<td><input type="text" class="form-control check2" id="SU_SA_VOLUM" name="SU_SA_VOLUM" ></td>
												<td>발전 전압</td>
												<td><input type="text" class="form-control check2" id="SU_SA_VOLT" name="SU_SA_VOLT"></td>
												<td>CT비</td>
												<td><input type="text" class="form-control check2" id="SU_SA_CT" name="SU_SA_CT"></td>
											</tr>
											<tr>
												<td>인버터 대수</td>
												<td><input type="text" class="form-control check2" id="SU_SA_INVERTERNUM" name="SU_SA_INVERTERNUM"></td>
												<td>계량기 검침일</td>
												<td><input type="text" class="form-control check2" id="SU_SA_ADMINDATE" name="SU_SA_ADMINDATE"></td>
												<td>계량기 번호1</td>
												<td><input type="text" class="form-control check2" id="SU_SA_METER1" name="SU_SA_METER1" value="계량기#"></td>
											</tr>
											<tr>
												<td>계량기 번호2</td>
												<td><input type="text" class="form-control check2" id="SU_SA_METER2" name="SU_SA_METER2" value="계량기#"></td>
												<td>사업주 전화번호 1</td>
												<td><input type="text" class="form-control check2" id="SU_SA_PHONE1" name="SU_SA_PHONE1"></td>
												<td>사업주 전화번호 2</td>
												<td><input type="text" class="form-control check2" id="SU_SA_PHONE2" name="SU_SA_PHONE1"></td>
											</tr>
											<tr>	
												<td>시공사 전화번호</td>
												<td><input type="text" class="form-control check2" id="SU_SA_PHONE3" name="SU_SA_PHONE1"></td>
												<td>판넬사 전화번호</td>
												<td><input type="text" class="form-control check2" id="SU_SA_PHONE4" name="SU_SA_PHONE1"></td>
												<td>관리업체 전화번호</td>
												<td><input type="text" class="form-control check2" id="SU_SA_PHONE5" name="SU_SA_PHONE1"></td>
											</tr>
											<tr>
												<td>모니터링 연동</td>
												<td><select id="SU_DPP_KEYNO" name="SU_DPP_KEYNO"  onchange="inverternum(this.value)" class="form-control input-sm select2">
													<option value="">선택하세요</option>
													<c:forEach items="${monitering }" var="b">
													<option value="${b.DPP_KEYNO }">${b.DPP_NAME }</option>
													</c:forEach>
												</select></td>
												<td>월별 점검 횟수</td>
												<td><input type="text" class="form-control check2" id="SU_SA_RG" name="SU_SA_RG" ></td>
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
														<input type="hidden" id="SU_KEYNO" name="SU_KEYNO" value="">
														<input type="hidden" id="SA_UI_KEYNO" name="SA_UI_KEYNO" value="${UI_KEYNO }">
														<button class="btn btn-sm btn-default" type="button" onclick="window.scrollTo(0,0);" ><i class="glyphicon glyphicon-chevron-up"></i>Top</button>
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
	
</div>


<script type="text/javascript">

function providerSelect2(value){
	if(value == "0"){
		clear2();
		$("#buttondiv2-2").empty();
		$("#ActionType2").html('<i class="fa fa-floppy-o"></i> 저장')
		
		$("#buttionType2").val("insert");
	}else{
		$("#user").val(value)
		var target = document.getElementById("user");
		//console.log(userText)
		$("#select2-user-container").text(target.options[target.selectedIndex].text);
		$("#select2-SU_DPP_KEYNO-container").text(target.options[target.selectedIndex].text);
		providerSelectmethod2(value);
	}
}

function clear2(){
	$("#SU_SA_SULBI").val("")
	$("#SU_DPP_KEYNO").val("")
	$("#SU_SA_AD").val("")
	$("#SU_SA_RG").val("")
	$("#SU_SA_VOLUM").val("")
	$("#SU_SA_VOLT").val("")
	$("#SU_SA_CT").val("")
	$("#SU_SA_INVERTERNUM").val("")
	$("#SU_SA_PHONE1").val("")
	$("#SU_SA_PHONE2").val("")
	$("#SU_SA_AREA").val("")
}

function providerSelectmethod2(value){
	 $.ajax({
        url: '/sfa/safe/UserSelectAjax.do?${_csrf.parameterName}=${_csrf.token}',
        type: 'POST',
        data: {
        	"SU_KEYNO":value
        },
        async: false,  
        success: function(result) {
        	
        	var phonelist = []
        	phonelist = result.SU_SA_PHONE1.split(",");
        	
        	
        	
        	
        	$("#SU_KEYNO").val(result.SU_KEYNO)
        	$("#SU_DPP_KEYNO").val(result.SU_DPP_KEYNO)
        	$("#SU_SA_SULBI").val(result.SU_SA_SULBI)
        	$("#SU_SA_AD").val(result.SU_SA_AD)
        	$("#SU_SA_AREA").val(result.SU_SA_AREA)
        	$("#SU_SA_RG").val(result.SU_SA_RG)
        	$("#SU_SA_VOLUM").val(result.SU_SA_VOLUM)
        	$("#SU_SA_VOLT").val(result.SU_SA_VOLT)
        	$("#SU_SA_CT").val(result.SU_SA_CT)
        	$("#SU_SA_INVERTERNUM").val(result.SU_SA_INVERTERNUM)
        	$("#SU_SA_ADMINDATE").val(result.SU_SA_ADMINDATE)
        	$("#SU_SA_METER1").val(result.SU_SA_METER1)
        	$("#SU_SA_METER2").val(result.SU_SA_METER2)
        	$("#SU_SA_PHONE1").val(phonelist[0])
        	$("#SU_SA_PHONE2").val(phonelist[1])
        	$("#SU_SA_PHONE3").val(phonelist[2])
        	$("#SU_SA_PHONE4").val(phonelist[3])
        	$("#SU_SA_PHONE5").val(phonelist[4])
        
        	console.log($("#SU_DPP_KEYNO").val());
        	
        	$("#buttondiv2-2").html('<button class="btn btn-sm btn-danger" type="button" onclick="supdeleteInfo();" style="margin-right:10px;"><i class="glyphicon glyphicon-trash"></i> 삭제</button>')
        	$("#ActionType2").html('<i class="glyphicon glyphicon-refresh"></i> 수정')
        	$("#buttionType2").val("update");
        	
        },
        error: function(){
        	alert("발전소 선택 에러");
        }
	}); 
}

function providerInsert2(){
	
	//if(!validationCheck2()) return false
	
	 $.ajax({
        url: '/sfa/safe/UserActionAjax.do?${_csrf.parameterName}=${_csrf.token}',
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
	
	if(confirm("현재 발전소를 삭제하시겠습니까?")){
	
	$.ajax({
		type: "POST",
		url: '/sfa/safe/UserDelete.do?${_csrf.parameterName}=${_csrf.token}',
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

function excelInsert(){
	alert("발전소 등록이 완료되었습니다");
	$("#Form2").attr("action","/sfa/safe/insertExcel.do?${_csrf.parameterName}=${_csrf.token}");
	$("#Form2").submit();

}

function inverternum(keyno){
	
	$.ajax({
		type: "POST",
		url: '/sfa/safe/Inverternum.do?${_csrf.parameterName}=${_csrf.token}',
		async: false,
		data: {
        	"DPP_KEYNO": keyno
        },
		success : function(data){
			 console.log(data);
			$("#SU_SA_INVERTERNUM").val(data.DPP_INVER_COUNT);
			$("#SU_SA_AD").val(data.DPP_LOCATION);
				
		}, 
		error: function(){
			
		}
	}); 
	
}
</script>