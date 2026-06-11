<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<%@ include file="/WEB-INF/jsp/dyAdmin/include/CodeMirror_Include.jsp" %>

<style>
.columnTitle {
	text-align: center;
	word-break: keep-all;
	border-top: 1px solid #ddd;
	border-bottom: 1px solid #ccc;
	padding: 5px 0
}

.columnTitle section {
	margin-bottom: 0
}

.option_dp, .selectCodeWrap, .column_size_dp {
	display: none;
}

.column_ul .column_li label{
	width: 25%;
}

.column_ul .column_li input{
	padding-left:10px;
	width: 50%;
}

.column_ul .column_li a{
	margin-left: 20px;
}
</style>

<script type="text/javascript">

var editor = null;

$(function() {
	
	editor = codeMirror("htmlmixed", "TCGM_FORM");
	pf_columList();
	
	cf_checkbox_checked_val("TCGM_IMG_YN", "N");
	cf_checkbox_checked_val("TCGM_IMG_RESIZE_YN", "N");
	$('.imgResizeYN').hide();
	$('.imgResizeValue').hide();
	if('update' === '${type}') {
		if($('#TCGM_IMG_YN').val() == 'Y') {
			$('.imgResizeYN').show();
			
			if($('#TCGM_IMG_RESIZE_YN').val() == 'Y') {
				$('.imgResizeValue').show();
			}
		}
	}
	
	
	$('#IMG_YN').on('click',function() {
		if ($(this).is(':checked')) {
			$('.imgResizeYN').show();
		} else {
			$('.imgResizeYN').hide();
			$('#IMG_RESIZE_YN').prop('checked', false);
			$('.imgResizeValue').hide();
			$('#TCGM_IMG_WIDTH').val("");
			$('#TCGM_IMG_HEIGHT').val("");
		}
	});
	
	$('#IMG_RESIZE_YN').on('click',function() {
		if ($(this).is(':checked')) {
			$('.imgResizeValue').show();
		} else {
			$('.imgResizeValue').hide();
			$('#TCGM_IMG_WIDTH').val("");
			$('#TCGM_IMG_HEIGHT').val("");
		}
	});
	
	if("${type}" == "update"){
		
	}else {
		pf_getSkinFormData("basic","popupZone");
	}
	
});

function pf_form_change(value){
	pf_getSkinFormData(value,"popupZone");
}

function pf_columList(){
	
	$("#BT_COLUME").empty();
	
	var html = "<ul class='column_ul'>";
	
	var defalut_option = [];
	defalut_option.push({comment : "기본키", dataset : "TLM_KEYNO"});
	defalut_option.push({comment : "부연설명(ALT)", dataset : "TLM_ALT"});
	defalut_option.push({comment : "코멘트", dataset : "TLM_COMMENT"});
	defalut_option.push({comment : "링크URL", dataset : "TLM_URL"});
	defalut_option.push({comment : "이미지기본키", dataset : "THUMBNAIL_PATH"});
	defalut_option.push({comment : "시작날짜", dataset : "TLM_STARTDT"});
	defalut_option.push({comment : "종료날짜", dataset : "TLM_ENDT"});
	defalut_option.push({comment : "작성자", dataset : "TLM_REGNM"});
	defalut_option.push({comment : "등록일", dataset : "TLM_REGDT"});
	defalut_option.push({comment : "사용유무", dataset : "TLM_USE_YN"});
	defalut_option.push({comment : "삭제유무", dataset : "TLM_DEL_YN"});
	defalut_option.push({comment : "카테고리기본키", dataset : "TLM_TCM_KYENO"});

	for(var i in defalut_option){
		html += "<li class='column_li'><label>"+defalut_option[i].comment+"</label><input type='text' value='" + defalut_option[i].dataset + "' readonly>";
		html += "<div class='btn btn btn-default btn-xs'  onclick='pf_Copy(\"" + defalut_option[i].dataset  + "\")'><i class='fa fa-copy'></i></div></li>";
	}
	
	html += "</ul>";
	$("#BT_COLUME").html(html);
	
}

function pf_categoryInsert(){
	
	if(!pf_checkForm()){
		return false;
	}

	pf_checkBox();
	
// 	return false;
	if(confirm("카테고리를 생성하시겠습니까?")){
		cf_replaceTrim($("#Form"));
		$("#Form").attr("action", "/dyAdmin/homepage/popupzone/insert.do");
		$("#Form").submit();
	}
	
}

function pf_checkForm(){
	
	if(!$("#TCGM_TITLE").val()){
		alert("제목을 입력하세요.");
		$("#TCGM_TITLE").focus();
		return false;
	}
	
	if(!editor.getValue()){
		alert("소스코드를 입력하세요.");
		$("#TCGM_FORM").focus();
		return false;
	}
	
	if ($('#IMG_RESIZE_YN').is(':checked')) {
		if (!$("#TCGM_IMG_WIDTH").val() || $("#TCGM_IMG_WIDTH").val() == 0) {
			alert("이미지 리사이즈 width 값을 설정하여주세요.");
			$("#TCGM_IMG_WIDTH").focus();
			return false;
		}
		if (!$("#TCGM_IMG_HEIGHT").val() || $("#TCGM_IMG_HEIGHT").val() == 0) {
			alert("이미지 리사이즈 height 값을 설정하여주세요.");
			$("#TCGM_IMG_HEIGHT").focus();
			return false;
		}
	}
	
	return true;
}

function pf_checkBox() {
	$('input[type=checkbox]').each(function(i){
		var checkVal = 'Y'
		var checkID = $(this).attr("id");

		if($(this).is(":checked")){
			checkVal = 'Y';
		}else{
			checkVal = 'N';
		}
		$('#TCGM_'+checkID).val(checkVal);
	});
}

function pf_categoryUpdate(){
	
	if(!pf_checkForm()){
		return false;
	}

	pf_checkBox();
	
	if(confirm("카테고리를  수정하시겠습니까?")){
		cf_replaceTrim($("#Form"));
		$("#Form").attr("action", "/dyAdmin/homepage/popupzone/update.do");
		$("#Form").submit();
	}
	
}

function pf_categoryDelete(){
	if(confirm("카테고리를 삭제하시겠습니까?")){
		cf_replaceTrim($("#Form"));
		$("#Form").attr("action", "/dyAdmin/homepage/popupzone/delete.do");
		$("#Form").submit();
	}
}


function pf_back(){
	history.go(-1);
}

function pf_Copy(content){
	if(cf_copyToClipboard(content)){
		cf_smallBox('success', "값이 복사되었습니다.", 2000);
	}else{
		cf_smallBox('error', "복사하기 기능을 지원하지 않는 브라우저 입니다.", 3000,'#d24158');
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
						<h2>카테고리 ${type eq 'insert' ? '등록' : '수정'}</h2>
					</header>

					<div class="widget-body">

						<form:form id="Form" class="form-horizontal" name="Form" method="post">
							<input type="hidden" name="TCGM_REGNM" value="${userInfo.UI_ID }" />
							<input type="hidden" name="TCGM_MN_HOMEDIV_C" value="${not empty TCGM_DATA.TCGM_MN_HOMEDIV_C ? TCGM_DATA.TCGM_MN_HOMEDIV_C : homeKey}" />
							<c:if test="${type eq 'update' }">
							<input type="hidden" name="TCGM_KEYNO" value="${TCGM_DATA.TCGM_KEYNO }" />
							</c:if>
							<input type="hidden" name="TCGM_IMG_YN" id="TCGM_IMG_YN" value="${TCGM_DATA.TCGM_IMG_YN }" />
							<input type="hidden" name="TCGM_IMG_RESIZE_YN" id="TCGM_IMG_RESIZE_YN" value="${TCGM_DATA.TCGM_IMG_RESIZE_YN }" />
							<legend>
								<h2>카테고리  ${type eq 'insert' ? '등록' : '수정'}하기 </h2>
							</legend>
							
							<fieldset>
								<div class="bs-example necessT">
									<span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
								</div>
								
								<div class="form-group has-feedback">
									<label class="col-md-1 control-label"><span class="nessSpan">*</span> 제목</label>
									<div class="col-md-6">
										<input type="text" class="form-control" id="TCGM_TITLE" name="TCGM_TITLE" value="${TCGM_DATA.TCGM_TITLE }">
									</div>
								</div>
								
								<div class="form-group has-feedback col-sm-6">
									<label class="col-md-2 control-label">이미지 사용 여부</label>
									<div class="col-md-10">
										
										<div class="checkbox">
											<label>
											  <input type="checkbox" class="checkbox style-0" name="IMG_YN" id="IMG_YN" value="" ${TCGM_DATA.TCGM_IMG_YN eq 'Y' ? 'checked' : ''}>
											  <span></span>
											</label>
										</div>
										
									</div>
								</div>
								
								<div class="form-group has-feedback col-sm-6 imgResizeYN">
									<label class="col-md-2 control-label">리사이즈 여부</label>
									<div class="col-md-10">
										
										<div class="checkbox">
											<label>
											  <input type="checkbox" class="checkbox style-0" name="IMG_RESIZE_YN" id="IMG_RESIZE_YN" value="" ${TCGM_DATA.TCGM_IMG_RESIZE_YN eq 'Y' ? 'checked' : ''}>
											  <span></span>
											</label>
										</div>
										
									</div>
								</div>
								<div style="clear: both;"></div>
								
								<div class="form-group has-feedback imgResizeValue">
									<label class="col-md-1 control-label">width 값(단위 px) </label>
									<section class="col-md-6">
										<input type="number" id="TCGM_IMG_WIDTH" class="form-control" name="TCGM_IMG_WIDTH" value="${TCGM_DATA.TCGM_IMG_WIDTH }"
											oninput="cf_maxLengthCheck(this)" max="9999" maxlength="4" />
									</section>
								</div>
								
								<div class="form-group has-feedback imgResizeValue">
									<label class="col-md-1 control-label">height 값(단위 px) </label>
									<section class="col-md-6">
										<input type="number" id="TCGM_IMG_HEIGHT" class="form-control" name="TCGM_IMG_HEIGHT" value="${TCGM_DATA.TCGM_IMG_HEIGHT }"
											oninput="cf_maxLengthCheck(this)" max="9999" maxlength="4" />
									</section>
								</div>
								
								<div class="form-group has-feedback">
									<label class="col-md-9 control-label"></label>
									<div class="col-md-2">
										<select class="form-control input-sm" id="BMM_FORM_SELECT" onchange="pf_form_change(this.value);">
							              <option value="basic">기본폼</option>
							              <c:forEach items="${formDataList }" var="model3" varStatus="status">
							              <option value="${model3.TCGM_KEYNO}" ${TCGM_DATA.TCGM_KEYNO eq model3.TCGM_KEYNO ? 'selected' : '' }>${model3.FORM_NAME }</option>
							              </c:forEach>
							            </select>
									</div>
									
								</div>
								
								<div class="form-group has-feedback">
									<label class="col-md-1 control-label">컬럼 목록</label>
									<div class="col-md-3" id="BT_COLUME" style="height: 400px; border: solid 1px gray; overflow-y: scroll; padding: 10px; margin: 0 12px 0 12px;">
									
									</div>
											
									<label class="col-md-1 control-label"><span class="nessSpan">*</span> HTML 소스</label>
									<div class="col-md-6">
										<textarea name="TCGM_FORM" id="TCGM_FORM" rows="5" style="width:100%; height:400px; min-width:260px;">${TCGM_DATA.TCGM_FORM}</textarea>
									</div>
								</div>
								
								<div class="form-actions">
									<div class="row">
										<div class="col-md-12">
											<c:if test="${type eq 'insert' }">
												<button class="btn btn-sm btn-primary" type="button" onclick="pf_categoryInsert()">저장</button>
											</c:if>
											<c:if test="${type eq 'update' }">
												<button class="btn btn-sm btn-primary" type="button" onclick="pf_categoryUpdate()">수정</button>
												<button class="btn btn-sm btn-danger" type="button" onclick="pf_categoryDelete()">삭제</button>
											</c:if>
											<button class="btn btn-sm btn-default" id="Board_Delete" type="button" onclick="pf_back();">취소</button> 
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

