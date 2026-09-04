<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<!-- 사원 등록 레이어창 -->
<div id="orgPersonInsert" title="사원 등록">
	<form:form id="insertForm" action="" method="post">
		<input type="hidden" name="UI_REP_NAME" class="UI_REP_NAME" value="">
		<input type="hidden" name="UI_AUTH_YN" class="UI_AUTH_YN" value="Y">
		<div class="widget-body ">
			<fieldset>
				<div class="form-horizontal">
					<fieldset>
						<div class="bs-example necessT">
							<span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label"><span
								class="nessSpan">*</span> 사원명</label>
							<div class="col-md-10">
								<input type="text" class="form-control orgPersonName"
									maxlength="50">
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label"><span
								class="nessSpan">*</span> 부서</label>
							<div class="col-md-10">
								<select class="form-control input-sm select2"
									id="insert_select" name="SITE_KEYNO">
									<c:forEach items="${orgList}" var="homeDiv">
										<option value="${homeDiv.DN_KEYNO}"><c:out
												value="${homeDiv.DN_NAME}" /></option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">직책</label>
							<div class="col-md-10">
								<input type="text" class="form-control orgPersonRole"
									maxlength="15">
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">전화번호</label>
							<div class="col-md-10">
								<textarea class="form-control orgPersonTel" rows="3"
									maxlength="1000"></textarea>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">업무내용</label>
							<div class="col-md-10">
								<textarea class="form-control orgPersonContents" rows="6"
									maxlength="1000"></textarea>
							</div>
						</div>
					</fieldset>
				</div>
			</fieldset>
		</div>
	</form:form>
</div>

 <form:form id="orgPersonForm">
	<input type="hidden" name="DU_KEYNO" id="DU_KEYNO" value="">
	<input type="hidden" name="DU_NAME" id="DU_NAME" value="">
	<input type="hidden" name="DU_DN_KEYNO" id="DU_DN_KEYNO" value="">
	<input type="hidden" name="DU_ROLE" id="DU_ROLE" value="">
	<input type="hidden" name="DU_LEV" id="DU_LEV" value="">
	<input type="hidden" name="DU_CONTENTS" id="DU_CONTENTS" value="">
	<input type="hidden" name="DU_TEL" id="DU_TEL" value="">
	<input type="hidden" name="DU_HOMEDIV_C" id="DU_HOMEDIV_C" value="">
	<input type="hidden" name="PAGE_DIV_C" id="PAGE_DIV_C" value="11">
</form:form> 

<script src="/resources/smartadmin/js/plugin/select2/select2.min.js"></script>
<script type="text/javascript">
	$(document).ready(
			function() {
			
				/* 조직원 추가 */
				cf_setttingDialog('#orgPersonInsert', '조직원 추가', '저장',
						'pf_insertPersonInfo()');

			});

	function pf_openInsertPopup() {
		$('#orgPersonInsert').dialog('open');
		$('#orgPersonInsert input, #orgPersonInsert textarea').val('');
		$('#insert_select').select2({
			dropdownParent : $('#orgPersonInsert')
		});
		pf_resetMemberData('insertForm');

	}

	function pf_insertMemberSubmit() {
		$('#insertForm').submit();
	}

	//조직원 추가
	function pf_insertPersonInfo() {
		if (!$('#orgPersonInsert .orgPersonName').val().trim()) {
			alert('이름을 입력하여주세요.')
			$('#orgPersonInsert .orgPersonName').focus();
			return false;
		}
		
		if(!$('#insert_select').val()){
			alert('부서를 선택해주세요.')
			$('#orgPersonInsert .select2').focus();
			return false;
		}

		if (!confirm('저장하시겠습니까?')) {
			return false;
		}

		$('#DU_NAME').val($('#orgPersonInsert .orgPersonName').val().trim())
		$('#DU_ROLE').val($('#orgPersonInsert .orgPersonRole').val().trim())
		$('#DU_CONTENTS').val($('#orgPersonInsert .orgPersonContents').val())
		$('#DU_TEL').val($('#orgPersonInsert .orgPersonTel').val())
		$('#DU_DN_KEYNO').val($('#orgPersonInsert .select2').val())
		$('#DU_HOMEDIV_C').val($('#MN_HOMEDIV_C').val())

		$('#orgPersonForm').attr('action',
				'/dyAdmin/homepage/org/person/insert.do');
		$('#orgPersonForm').submit();

	}
</script>
