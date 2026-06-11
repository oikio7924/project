<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script type="text/javascript">
var editor = null;
var img_yn = "";
var width = 0;
var height = 0;
var status = true;
var action = '${type}'

$(function() {
	// 날짜 지정 여부 초기값
// 	$("#DATE_YN").prop("checked", false);
	if(action == 'insert') {
		$("#date_value, .input-img-info").hide();
	}else if(action == 'update'){
		if($("#TLM_DATE_YN").val() == 'Y') {
			$("#DATE_YN").prop("checked", true);
			$("#date_value").show();
		} else {
			$("#DATE_YN").prop("checked", false);
			$("#date_value").hide();
		}
	}
	
});

function pf_listInsert(type){
	if(!pf_checkForm()) { return false; }
	
	if(img_yn == "Y") {
        if(!$("#file_text").val()){
			cf_smallBox('error', '이미지를 선택해주세요.', 3000,'#d24158');
			status = false;
			return status;
		}
	}
	var msg = '';
	
	if(type == 'insert'){
		msg = '리스트를 생성하시겠습니까?';
	}else{
		msg = '리스트를 수정하시겠습니까?';		
	}
	
	if(status){
		if(confirm(msg)){
			cf_replaceTrim($("#Form"));
			$("#Form").attr("action", "/dyAdmin/homepage/popupzone/list/"+type+".do?${_csrf.parameterName}=${_csrf.token}");
			$("#Form").submit();
		}
	}
}


function pf_checkForm(){
	if(!pf_nullCheck(document.getElementById("TLM_TCGM_KEYNO") , "카테고리"  , "select")) return;
	if(!pf_nullCheck(document.getElementById("TLM_COMMENT") , "코멘트"  , "text")) return;
	var data_check = $("#DATE_YN").prop("checked");
	if(data_check == true){
		$("#TLM_DATE_YN").val('Y');
		if(!pf_nullCheck(document.getElementById("TLM_STARTDT") , "시작날짜"  , "text")) return;
		if(!pf_nullCheck(document.getElementById("TLM_ENDT") , "종료날짜"  , "text")) return;
	}else{
		$("#TLM_DATE_YN").val('N');
	}
	// 공백제외하고 링크가 입력되있으면 http || https로 시작하는지 확인
// 	if($('#TLM_URL').val().trim() != "") {
// 		if( !( $('#TLM_URL').val().startsWith('http://') || $('#TLM_URL').val().startsWith('https://') ) ){
// 			cf_smallBox('error', '링크는 http:// 나 https:// 로 시작되어야됩니다.', 3000,'#d24158');
// 			$('#TLM_URL').focus();
// 			return false;
// 		}
// 	}
	
	status = true;
	return true;
}

function pf_nullCheck(obj, name, inputType){
	
	var str = "";
	
	if(inputType == "text")	
		str = "입력";
	else if(inputType == "select")	
		str = "선택";
	
	if($.trim(obj.value) == ""){
		cf_smallBox('Form', name + "을(를) "+ str +"해주세요.", 3000,'#d24158');
		obj.value = "";
		obj.focus();
		
		return false;
	}else{
		return true;
	}
}

function pf_getCategoryInfo() {
	
	$.ajax({
	    type   : "post",
	    url    : "/dyAdmin/homepage/popupzone/list/categoryInfoAjax.do",
	    data   : {"TCGM_KEYNO" : $("#TLM_TCGM_KEYNO").val()},
	    async  : false ,
	    success:function(data){
			if(data.TCGM_IMG_YN == 'Y') {
				img_yn = "Y"
				var resizeBoolean;
				if(data.TCGM_IMG_RESIZE_YN == 'Y') {
					width = data.TCGM_IMG_WIDTH;
					height = data.TCGM_IMG_HEIGHT;
					resizeBoolean = true;
					$('.resizeY').show();	
				} else {
					resizeBoolean = false;
					$('.resizeY').hide();					
				}
				$('#resize').val(resizeBoolean);					
				$('#span_width').text(width);					
				$('#span_height').text(height);
				$('#WIDTH').val(width);
				$('#HEIGHT').val(height);
				$('.input-img-info').show();
			} else {
				img_yn = "N"
				$('.input-img-info').hide();
			}
			
			if(action == 'insert') {
				//정렬 순서 부분
				var endOrder = Number(data.LENGTH) + 1;
				
				$('#TLM_ORDER').html('');	// select 초기화
			 	for(var i = 1; i <= endOrder; i++) {
			 		var option = $('<option value='+i+'>'+i+'</option>');
					$('#TLM_ORDER').append(option);
			 	}
				$('#TLM_ORDER option:last').prop("selected", true);	// 마지막 번호 선택
			}
	    },
	    error: function(jqXHR, textStatus, exception) {
	    	alert('error: '+textStatus+": "+exception);
	    }
	});
	
}

function pf_listDelete(){
	if(confirm("리스트를 삭제하시겠습니까?")){
		cf_replaceTrim($("#Form"));
		$("#Form").attr("action", "/dyAdmin/homepage/popupzone/list/delete.do?${_csrf.parameterName}=${_csrf.token}");
		$("#Form").submit();
	}
}

function pf_date_use(obj){
	$obj = $(obj);
	if($obj.prop("checked")){
		$("#date_value").show();
	}else{
		$("#date_value").hide();
		$("#TLM_STARTDT").attr("value", "");
 		$("#TLM_ENDT").attr("value", "");
	}
}

</script>

<div id="content">

	<section id="widget-grid">
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" id="" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-table"></i>
						</span>
						<h2>리스트 ${type eq 'insert' ? '등록' : '수정' }</h2>
					</header>

					<div class="widget-body">

						<form:form id="Form" class="form-horizontal" name="Form" method="post" enctype="multipart/form-data">
							<input type="hidden" name="TLM_REGNM" value="${userInfo.UI_ID }" />
							<input type="hidden" name="TLM_KEYNO" value="${TLM_DATA.TLM_KEYNO }" />
							<input type="hidden" name="TLM_FS_KEYNO" value="${TLM_DATA.TLM_FS_KEYNO }" />
							<input type="hidden" name="WIDTH" id="WIDTH" value="${empty TLM_DATA.TCGM_IMG_WIDTH ? '0' : TLM_DATA.TCGM_IMG_WIDTH}" />
							<input type="hidden" name="HEIGHT" id="HEIGHT" value="${empty TLM_DATA.TCGM_IMG_HEIGHT ? '0' : TLM_DATA.TCGM_IMG_HEIGHT}" />
							<input type="hidden" name="TLM_DATE_YN" id="TLM_DATE_YN" value="${TLM_DATA.TLM_DATE_YN }" />
							<input type="hidden" name="TLM_ORDER_BEFORE" id="TLM_ORDER_BEFORE" value="${TLM_DATA.TLM_ORDER }" />
							<input type="hidden" name="resize" id="resize" value="${TLM_DATA.TCGM_IMG_RESIZE_YN eq 'Y' ? true : false}" />
							
							<legend>
								<h2>리스트 ${type eq 'insert' ? '등록' : '수정' }하기 </h2>
							</legend>
							
							<fieldset>
								<div class="bs-example necessT">
									<span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
								</div>
								
								<div class="form-group has-feedback">
									<label class="col-md-1 control-label"><span class="nessSpan">*</span> 카테고리</label>
									<div class="col-md-3">
										<select class="form-control input-sm" id="TLM_TCGM_KEYNO" name="TLM_TCGM_KEYNO" onchange="pf_getCategoryInfo();">
							              <option value="">카테고리 선택</option>
							              <c:forEach items="${categoryList }" var="model">
							                <option value="${model.TCGM_KEYNO }" ${TLM_DATA.TLM_TCGM_KEYNO eq model.TCGM_KEYNO ? 'selected' : '' } >${model.FORM_NAME }</option>
							              </c:forEach>	
							            </select>
									</div>
									
									<label class="col-md-1 control-label"><span class="nessSpan">*</span> 정렬순서</label>
									<div class="col-md-2">
										<select class="form-control input-sm" id="TLM_ORDER" name="TLM_ORDER">
										<c:forEach begin="1" end="${TLM_DATA.LENGTH }" var="len">
							            	<option value="${len }" ${TLM_DATA.TLM_ORDER eq len ? 'selected' : '' } >${len }</option>
							            </c:forEach>
							            </select>
									</div>
								</div>
								
								<div class="form-group has-feedback">
									<label class="col-md-1 control-label"><span class="nessSpan">*</span> 코멘트</label>
									<div class="col-md-6">
										<input type="text" class="form-control" id="TLM_COMMENT" name="TLM_COMMENT" value="${TLM_DATA.TLM_COMMENT }">
									</div>
								</div>
								
								<div class="form-group has-feedback">
									<label class="col-md-1 control-label"><span class="nessSpan">*</span> 날짜 지정 여부</label>
									<div class="col-md-10">
										<div class="checkbox">
											<label>
												<input type="checkbox" class="ckeckbox style-0" id="DATE_YN" name="DATE_YN" value="" onclick="pf_date_use(this)" ${(not empty TLM_DATA.TLM_STARTDT) ? 'checked':'' }>
												<span></span>
											</label>
										</div>
									</div>
								</div>
								
								<div class="form-group has-feedback" id="date_value">
									<label class="col-md-1 control-label">시작날짜 </label>
									<section class="col-md-2">
										<input type="text" name="TLM_STARTDT" id="TLM_STARTDT" placeholder="시작날짜" data-dateformat="yy-mm-dd" class="form-control datepicker " value="${TLM_DATA.TLM_STARTDT }">
									</section>
									<label class="col-md-1 control-label">종료날짜 </label>
									<section class="col-md-2">
										<input type="text" name="TLM_ENDT" id="TLM_ENDT" placeholder="종료날짜" data-dateformat="yy-mm-dd" class="form-control datepicker " value="${TLM_DATA.TLM_ENDT }">
									</section>
								</div>
								
								
								<div class="form-group has-feedback">
									<label class="col-md-1 control-label"> 링크</label>
									<div class="col-md-6">
										<input type="text" class="form-control" id="TLM_URL" name="TLM_URL" value="${TLM_DATA.TLM_URL }">
									</div>
								</div>
								
								<fieldset class="input-img-info">
									<div class="form-group has-feedback">
										<label class="col-md-1 control-label"><span class="nessSpan">*</span> 리스트 이미지</label>
										<div class="col-md-6 smart-form">
											<div class="input input-file">
												<span class="button"><input type="file" name="file" id="file" accept="image/*" onchange="cf_imgCheckAndPreview('file')">
												파일선택</span>
												<input type="text" name="file_text" id="file_text" placeholder="이미지 파일을 선택하세요" readonly="" value="${TLM_DATA.FS_ORINM }">
											</div>
											<div class="note resizeY">이미지 사이즈는 <span id="span_width">${TLM_DATA.TCGM_IMG_WIDTH }</span> X <span id="span_height">${TLM_DATA.TCGM_IMG_HEIGHT }</span> 입니다 사이즈가 다를경우 이미지가 깨질 수 있습니다. </div>
										</div>
									</div>
									
									<div class="form-group has-feedback">
										<label class="col-md-1 control-label"> 부연설명(ALT)</label>
										<div class="col-md-6">
											<input type="text" class="form-control" id="TLM_ALT" name="TLM_ALT" value="${TLM_DATA.TLM_ALT }">
										</div>
									</div>
								</fieldset>
								
								<div class="form-actions">
									<div class="row">
										<div class="col-md-12">
											<button class="btn btn-sm btn-primary" type="button" onclick="pf_listInsert('${type}')">${type eq 'insert' ? '저장' : '수정' }</button>
											<c:if test="${type eq 'update' }">
												<button class="btn btn-sm btn-danger" type="button" onclick="pf_listDelete()">삭제</button>
											</c:if>
											<c:choose>
												<c:when test="${empty category}">
													<button class="btn btn-sm btn-default" id="Board_Delete" type="button" onclick="cf_back('/dyAdmin/homepage/popupzone/list.do')">목록으로 </button> 
												</c:when>
												<c:otherwise>
													<button class="btn btn-sm btn-default" id="Board_Delete" type="button" onclick="cf_back('/dyAdmin/homepage/popupzone/list.do?category=${category}');">목록으로 </button> 
												</c:otherwise>
											</c:choose>
										</div>
									</div>
								</div>
							</fieldset>
						</form:form>
					</div>
				</div>
			</article>
		</div>
	</section>
</div>

<script>

$(function() {
	var category = '${category}';
	if(category){
		$('#TLM_TCGM_KEYNO').val(category).prop("selected", true);
		pf_getCategoryInfo();
	}	
})
</script>
