<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<form:form id="Form" name="Form" method="post" action="">
	<input type="hidden" name="THM_KEYNO" id="THM_KEYNO" value="">
	<input type="hidden" name="THM_NAME" id="THM_NAME" value="">
	<input type="hidden" name="THM_LUNAR" id="THM_LUNAR" value="">
	<input type="hidden" name="THM_DATE" id="THM_DATE" value="">
	<input type="hidden" name="THM_TYPE" id="THM_TYPE" value="">
	<input type="hidden" name="THM_NATIONAL" id="THM_NATIONAL" value="">
	<section id="widget-grid" >
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" id="BOARD_TYPE_LIST_1" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-table"></i>
						</span>
						<h2>휴일 리스트</h2>
					</header>
					<div class="widget-body " >
						<div class="widget-body-toolbar bg-color-white">
							<div class="alert alert-info no-margin fade in">
								<button type="button" class="close" data-dismiss="alert">×</button>
								휴일 리스트를 확인합니다.
							</div> 
						</div>
						<div class="widget-body-toolbar bg-color-white">
							<div class="row"> 
								<div class="col-sm-12 col-md-2 text-align-right" style="float:right;">
									<div class="btn-group">  
										<button class="btn btn-sm btn-primary" type="button" onclick="pf_openAddHoliday()">
											<i class="fa fa-plus"></i> 추가
										</button> 
									</div>
								</div>
							</div>
						</div>
						<div class="table-responsive">
							<jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
								<jsp:param value="/dyAdmin/operation/holiday/pagingAjax.do" name="pagingDataUrl" />
								<jsp:param value="/dyAdmin/operation/holiday/excelAjax.do" name="excelDataUrl" />
							</jsp:include>
							<fieldset id="tableWrap">
							</fieldset>
						</div>
					</div>
				</div>
			</article>
		</div>
	</section>
</form:form>




<!-- 휴일 추가 팝업 CONTENT -->
<div id="holiday_add" title="휴일 추가">
	<div class="widget-body ">
		<fieldset>
			<div class="form-horizontal">
				<fieldset>
					<div class="bs-example necessT">
						<span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span class="nessSpan">*</span> 휴일 이름</label>
						<div class="col-md-10">
							<input type="text" class="form-control" name="M_NAME"
								maxlength="50">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span class="nessSpan">*</span> 날짜</label>
						<div class="col-md-10">
							<input name="M_DATE" type="text" class="form-control datepicker"
								data-dateformat="yy-mm-dd" readonly="readonly">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span class="nessSpan">*</span> 공휴일</label>
						<div class="col-md-10">
							<label class="radio radio-inline"> <input type="radio"
								class="radiobox style-0" name="M_NATIONAL" value="Y" /> <span>공휴일</span>
							</label> <label class="radio radio-inline"> <input type="radio"
								class="radiobox style-0" name="M_NATIONAL" value="N" /> <span>일반휴일</span>
							</label>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span class="nessSpan">*</span> 반복</label>
						<div class="col-md-10">
							<label class="radio radio-inline"> <input type="radio"
								class="radiobox style-0" name="M_TYPE" value="N" /> <span>없음</span>
							</label> <label class="radio radio-inline"> <input type="radio"
								class="radiobox style-0" name="M_TYPE" value="Y" /> <span>매년</span>
							</label> <label class="radio radio-inline"> <input type="radio"
								class="radiobox style-0" name="M_TYPE" value="M" /> <span>매월</span>
							</label> <label class="radio radio-inline"> <input type="radio"
								class="radiobox style-0" name="M_TYPE" value="D" /> <span>매주</span>
							</label>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span class="nessSpan">*</span> 양력/음력</label>
						<div class="col-md-10">
							<label class="radio radio-inline"> <input type="radio"
								class="radiobox style-0" name="M_LUNAR" value="N" /> <span>양력</span>
							</label> <label class="radio radio-inline"> <input type="radio"
								class="radiobox style-0" name="M_LUNAR" value="Y" /> <span>음력</span>
							</label>
						</div>
					</div>
				</fieldset>
			</div>
		</fieldset>
	</div>
</div>


<!-- 휴일 수정 팝업 CONTENT -->
<div id="holiday_update" title="휴일 수정">
	<div class="widget-body ">
		<fieldset>
			<div class="form-horizontal">
				<fieldset>
					<div class="bs-example necessT">
						<span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span
							class="nessSpan">*</span> 휴일 이름</label>
						<div class="col-md-10">
							<input type="text" class="form-control" name="M_NAME"
								maxlength="50">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span
							class="nessSpan">*</span> 날짜</label>
						<div class="col-md-10">
							<input name="M_DATE" type="text" class="form-control datepicker"
								data-dateformat="yy-mm-dd" readonly="readonly">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span
							class="nessSpan">*</span> 공휴일</label>
						<div class="col-md-10">
							<label class="radio radio-inline"> <input type="radio"
								class="radiobox style-0" name="M_NATIONAL" value="Y" /> <span>공휴일</span>
							</label> <label class="radio radio-inline"> <input type="radio"
								class="radiobox style-0" name="M_NATIONAL" value="N" /> <span>일반휴일</span>
							</label>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span
							class="nessSpan">*</span> 반복</label>
						<div class="col-md-10">
							<label class="radio radio-inline"> <input type="radio"
								class="radiobox style-0" name="M_TYPE" value="N" /> <span>없음</span>
							</label> <label class="radio radio-inline"> <input type="radio"
								class="radiobox style-0" name="M_TYPE" value="Y" /> <span>매년</span>
							</label> <label class="radio radio-inline"> <input type="radio"
								class="radiobox style-0" name="M_TYPE" value="M" /> <span>매월</span>
							</label> <label class="radio radio-inline"> <input type="radio"
								class="radiobox style-0" name="M_TYPE" value="D" /> <span>매주</span>
							</label>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span
							class="nessSpan">*</span> 양력/음력</label>
						<div class="col-md-10">
							<label class="radio radio-inline"> <input type="radio"
								class="radiobox style-0" name="M_LUNAR" value="N" /> <span>양력</span>
							</label> <label class="radio radio-inline"> <input type="radio"
								class="radiobox style-0" name="M_LUNAR" value="Y" /> <span>음력</span>
							</label>
						</div>
					</div>
				</fieldset>
			</div>
		</fieldset>
	</div>
</div>


<script>

$(function() {
	/* 휴일 추가 팝업 */
	cf_setttingDialog('#holiday_add', '휴일 추가', '추가', 'pf_addHoliday()');

	/* 휴일 추가 팝업 */
	cf_setttingDialog('#holiday_update', '휴일 수정', '수정','pf_updateHoliday()');


})

/* 휴일 추가 모달창 오픈 */
function pf_openAddHoliday() {
	$('#holiday_add').dialog('open');
	$('#holiday_add input[type=text]').val('');

	$('#holiday_add input[name=M_NATIONAL][value=N]').prop('checked', true);
	$('#holiday_add input[name=M_LUNAR][value=N]').prop('checked', true);
	$('#holiday_add input[name=M_TYPE][value=N]').prop('checked', true);
}

/* 휴일 추가 */
function pf_addHoliday() {

	if (!checkForm('holiday_add')) {
		return false;
	}
	$.ajax({
		type : "POST",
		url : "/dyAdmin/operation/holiday/insertAjax.do",
		data : $('#Form').serializeArray(),
		async : false,
		success : function(data) {
			alert('정상적으로 추가되었습니다.')
			$('#holiday_add').dialog('close');
			pf_LinkPage()
		},
		error : function() {
			cf_loading_out();
			alert('추가 할수없습니다. 관리자한테 문의하세요.')
			return false;
		}
	});
}

/* 휴일 수정 모달창 오픈 */
function pf_openUpdateHoliday(key) {
	event.stopPropagation();
	
	$.ajax({
		type : "POST",
		url : "/dyAdmin/operation/holiday/dataAjax.do",
		data : 'THM_KEYNO='+key,
		async : false,
		success : function(data) {
			$this = $('#holiday_update');
			$this.dialog('open');
			$('#THM_KEYNO').val(data.THM_KEYNO)
			$this.find('input[name=M_NAME]').val(data.THM_NAME);
			$this.find('input[name=M_DATE]').val(data.THM_DATE);
			$this.find('input[name=M_TYPE][value=' + data.THM_TYPE + ']')
					.prop('checked', true);
			$this.find('input[name=M_LUNAR][value=' + data.THM_LUNAR + ']')
					.prop('checked', true);
			$this.find('input[name=M_NATIONAL][value='+ data.THM_NATIONAL + ']').prop('checked', true);
		},
		error : function() {
			cf_loading_out();
			alert('수정 할수없습니다. 관리자한테 문의하세요.')
			return false;
		}
	});
	

}
/* 권한 수정 */
function pf_updateHoliday() {
	if (!checkForm('holiday_update')) {
		return false;
	}
	cf_loading();
	$.ajax({
		type : "POST",
		url : "/dyAdmin/operation/holiday/updateAjax.do",
		data : $('#Form').serializeArray(),
		async : false,
		success : function(data) {
			cf_loading_out();
			alert('정상적으로 수정되었습니다.');
			$('#holiday_update').dialog('close');
			pf_LinkPage($('#pageIndex').val())
		},
		error : function() {
			cf_loading_out();
			alert('수정 할수없습니다. 관리자한테 문의하세요.')
			return false;
		}
	});
}

/* 휴일 삭제 */
function pf_deleteHoliday(KEYNO,obj) {
	event.stopPropagation();
	
	var NAME = $(obj).parents('tr').find('.name').html();
	
	if (!confirm(NAME + '을 삭제하시겠습니까?')) {
		return false;
	}
	cf_loading();
	$.ajax({
		type : "POST",
		url : "/dyAdmin/operation/holiday/deleteAjax.do",
		data : "THM_KEYNO=" + KEYNO,
		async : false,
		success : function() {
			cf_loading_out();
			alert('정상적으로 삭제되었습니다.');
			pf_LinkPage();
		},
		error : function() {
			cf_loading_out();
			alert('삭제 할수없습니다. 관리자한테 문의하세요.')
			return false;
		}
	});
}

function checkForm(obj) {
	$this = $('#' + obj);
	if (!$this.find('input[name=M_NAME]').val().trim()) {
		alert('이름을 입력하세요.');
		$this.find('input[name=M_NAME]').focus();
		return false;
	}
	if (!$this.find('input[name=M_DATE]').val()) {
		alert('날짜를 입력하세요.');
		$this.find('input[name=M_DATE]').focus();
		return false;
	}
	if (!$this.find(':radio[name=M_TYPE]:checked').val()) {
		alert('반복를 입력하세요.');
		$this.find(':radio[name=M_TYPE]').focus();
		return false;
	}
	if (!$this.find(':radio[name=M_LUNAR]:checked').val()) {
		alert('양력/음력를 입력하세요.');
		$this.find(':radio[name=M_LUNAR]').focus();
		return false;
	}

	$('#THM_NAME').val($this.find('input[name=M_NAME]').val().trim());
	$('#THM_DATE').val($this.find('input[name=M_DATE]').val());
	$('#THM_TYPE').val($this.find(':radio[name=M_TYPE]:checked').val());
	$('#THM_LUNAR').val($this.find(':radio[name=M_LUNAR]:checked').val());
	$('#THM_NATIONAL').val(
			$this.find(':radio[name=M_NATIONAL]:checked').val());

	return true;
}
</script>
