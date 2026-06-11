<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>



<!-- 회원 정보 등록 레이어창 --> 
<div id="member-insert" title="회원 등록">
	<form:form id="insertForm" action="" method="post">
		<input type="hidden" name="UI_REP_NAME" class="UI_REP_NAME" value="">
		<input type="hidden" name="UI_AUTH_YN" class="UI_AUTH_YN" value="Y">
	<div class="widget-body ">
		<fieldset>
			<div class="form-horizontal">
				<div class="bs-example necessT">
			         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
			    </div>
				<fieldset>
					<div class="form-group">
						<label class="col-md-3 control-label"><span class="nessSpan">*</span> ID</label>
						<div class="col-md-6">
							<input type="text" class="form-control UI_ID" name="UI_ID" value="" maxlength="30">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-3 control-label"><span class="nessSpan">*</span> 비밀번호</label>
						<div class="col-md-6">
							<input type="password" class="form-control UI_PASSWORD" id="UI_PASSWORD" name="UI_PASSWORD"  value="" maxlength="20" onkeyup="noSpaceForm(this);" onchange="noSpaceForm(this);">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-3 control-label"><span class="nessSpan">*</span> 비밀번호 확인</label>
						<div class="col-md-6">
							<input type="password" class="form-control UI_PASSWORD2" name="UI_PASSWORD2"  value="" maxlength="20" onkeyup="noSpaceForm(this);" onchange="noSpaceForm(this);">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-3 control-label"><span class="nessSpan">*</span> 이 름</label>
						<div class="col-md-6">
							<input type="text" class="form-control UI_NAME" name="UI_NAME" value="" maxlength="20">
						</div>
					</div>
					
					<div class="form-group">
						<label class="col-md-3 control-label"><span class="nessSpan">*</span> 이메일</label>
						<div class="col-md-6">
							<input type="email" class="form-control UI_EMAIL" name="UI_EMAIL" value="" maxlength="50">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-3 control-label">전화번호</label>
						<div class="col-md-6">
							<input type="text" class="form-control UI_PHONE" name="UI_PHONE" value="" maxlength="20">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-3 control-label">권한</label>
						<div class="col-md-8">
							<c:forEach items="${authoritylist }" var="model" varStatus="state">
							<label class="radio radio-inline">
								<input type="radio" name="UIA_KEYNO" class="radiobox" value="${model.UIA_KEYNO }">
								<span>${model.UIA_NAME }</span> 
							</label>
							</c:forEach>
						</div>
					</div>
				</fieldset>
			</div>
		</fieldset>
	</div>
	</form:form>
</div>



<script type="text/javascript">

$(document).ready(function() {
	cf_setttingDialog('#member-insert','회원 등록','등록','pf_insertMemberSubmit()');
	
	
	$("#insertForm").validate({

        onfocusout : function (element) {

            $(element).valid();

        },
        
        submitHandler: function(form) {
        	var name = $('#member-insert .UI_NAME').val();
        	$('#member-insert .UI_REP_NAME').val(name);
        	pf_insertMember();
           return false;
        },
        rules : {
        	
        	//UI_ID : {required:true, minlength:4, maxlength:50, loginID:true, dupleCheck:true},
        	
        	//UI_PASSWORD : {minlength:8, maxlength:16, passwordChk:true},

        	//UI_PASSWORD2 : {equalTo:"#UI_PASSWORD"},
        	
        	UI_NAME : {required:true, minlength:2, maxlength:30, notEmpty:true},
        	
        	UI_EMAIL : {required:false,minlength:5, maxlength:50, email:true},
        	
        	UI_PHONE : {phone:true}        	

        },


        invalidHandler : function(form, validator) {

            var errors = validator.numberOfInvalids();

            if( errors ) 

            {
                $("h3 span.ok").html("(유효성 검사 실패)"); 

                alert(validator.errorList[0].message);

                validator.errorList[0].element.focus();

            }

        },
        
        errorPlacement: function(error, element) {
            	if($(element).hasClass('phonesize')){
	              	$(element).parent().find('.errorMessage').html(error)
            	}else{
            		$(element).after(error);
            	}
          }

	});
	
});


function pf_openInsertPopup(){
	$('#member-insert').dialog('open');
	pf_resetMemberData('insertForm');
	
}

function pf_insertMemberSubmit(){
	$('#insertForm').submit();
}

//회원 등록
function pf_insertMember(){
 	var form = $('#insertForm')[0];
		//FormData parameter에 담아줌
		var formData = new FormData(form);

	  $.ajax({
		type: "POST",
		url: "/dyAdmin/person/insertAjax.do",		
 		processData: false,
        contentType: false,
		data: formData, 
		async:false,
		success : function(result){
			if(result.regexBoolean){
				cf_smallBox('success', result.msg, 3000);
				$('#member-insert').dialog('close');
				pf_LinkPage();
			}else{
				cf_smallBox('error', result.msg, 3000,'#d24158');
				return false;
			}
			
		},
		error: function(){
			cf_smallBox('error', '알수없는 에러 발생. 관리자한테 문의하세요.', 3000,'#d24158');
			return false;
		}
	}); 
	
	return true; 
}

</script>
