<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<!-- 회원 정보 수정 레이어창 --> 
<div id="member-update" title="회원 관리">
	<form:form id="updateForm" action="" method="post" enctype="multipart/form-data">
		<input type="hidden" name="UI_KEYNO" class="UI_KEYNO" value="">
        <input type="hidden" name="UI_ID" value="">
		<input type="hidden" name="UI_REP_NAME" class="UI_REP_NAME" value="">
		<input type="hidden" name="UIA_KEYNO_BEFORE" class="UIA_KEYNO_BEFORE" value="">
		<input type="hidden" name="UIA_DIVISION" class="UIA_DIVISION" value="">
	<div class="widget-body ">
		<fieldset>
			<div class="form-horizontal">
				<fieldset>
					<div class="bs-example necessT">
				         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
				    </div>
					<div class="form-group">
						<label class="col-md-3 control-label"><span class="nessSpan">*</span> ID</label>
						<label class="col-md-6 control-label textL UI_ID" id="updateFormId"></label>
					</div>
					<div class="form-group">
						<label class="col-md-3 control-label"><span class="nessSpan">*</span> 관리자 비밀번호</label>
						<div class="col-md-6">
							<input type="password" class="form-control UI_PASSWORD" name="UI_PASSWORD" id="updateFormPwd"  value="" maxlength="20" onkeyup="noSpaceForm(this);" onchange="noSpaceForm(this);">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-3 control-label">변경할 비밀번호</label>
						<div class="col-md-6">
							<input type="password" class="form-control UI_PASSWORD2" id="UI_PASSWORD2" name="UI_PASSWORD2"  value="" maxlength="20" onkeyup="noSpaceForm(this);" onchange="noSpaceForm(this);">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-3 control-label">변경할 비밀번호 확인</label>
						<div class="col-md-6">
							<input type="password" class="form-control UI_PASSWORD3"  name="UI_PASSWORD3"  value="" maxlength="20" onkeyup="noSpaceForm(this);" onchange="noSpaceForm(this);">
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
							<input type="text" class="form-control UI_PHONE" name="UI_PHONE" value="" maxlength="20" placeholder="000-0000-0000">
						</div>
					</div>
					<div class="form-group form-group-authority">
						<label class="col-md-3 control-label"><span class="nessSpan">*</span> 인증여부</label>
						<div class="col-md-6">
							<label class="radio radio-inline">
								<input type="radio" name="UI_AUTH_YN" class="radiobox" value="Y">
								<span>인증</span> 
							</label>
							<label class="radio radio-inline">
								<input type="radio" name="UI_AUTH_YN" class="radiobox" value="N">
								<span>미인증</span>  
							</label>
						</div>
					</div>
					<div class="form-group form-group-authority">
						<label class="col-md-3 control-label"><span class="nessSpan">*</span> 휴면계정상태</label>
						<div class="col-md-6">
							<label class="radio radio-inline">
								<input type="radio" name="UI_DORMANCY" class="radiobox" value="Y">
								<span>휴면</span> 
							</label>
							<label class="radio radio-inline">
								<input type="radio" name="UI_DORMANCY" class="radiobox" value="N">
								<span>일반</span>  
							</label>
						</div>
					</div>
					<div class="form-group form-group-authority">
						<label class="col-md-3 control-label">권한</label>
						<div class="col-md-8">
							<c:forEach items="${authoritylist }" var="model" varStatus="state">
							<label class="radio radio-inline">
								<input type="radio" name="UIA_KEYNO" class="radiobox" value="${model.UIA_KEYNO }">
								<span>${model.UIA_NAME }</span>
							</label>
							</c:forEach>
							<label class="radio radio-inline radio-authority">
								<input type="radio" name="UIA_KEYNO" class="radiobox" value="">
								<span></span>
							</label>
						</div>
					</div>
				</fieldset>
			</div>
		</fieldset>
	</div>
	</form:form>
</div>

<script type="text/javascript">

var selectedId;

$(document).ready(function() {
	/* 권한 추가 팝업 */
	pf_setttingDialog('#member-update','회원 관리','수정','pf_updateMemberSubmit();','삭제','pf_deleteMember()','활동기록','pf_activeMember()');
	
	$("#updateForm").validate({

        onfocusout : function (element) {

            $(element).valid();

        },
        
        submitHandler: function(form) {
        	var name = $('#member-update .UI_NAME').val();
        	$('#member-update .UI_REP_NAME').val(name);
        	$('#updateFormPwd').val('');
        	pf_updateMember();
           return false;
        },
        rules : {
        	
        	UI_PASSWORD : {required:true, maxlength:16, adminPasswordMatch:true},
        	
        	UI_PASSWORD2 : {minlength:8, maxlength:16, passwordChk:true},

        	UI_PASSWORD3 : {equalTo:"#UI_PASSWORD2"},
        	
        	UI_NAME : {required:true, minlength:2, maxlength:30, notEmpty:true},
        	
        	//UI_EMAIL : {required:true, minlength:5, maxlength:50, email:true},
        	
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


function pf_openMemberInfoPopup(id){
	
	selectedId = id;
	pf_resetMemberData('updateForm');
	$('#member-update').dialog('open');
	$.ajax({
		type: "POST",
		url: "/dyAdmin/person/dataAjax.do",
		data: "UI_ID="+id,
		async:false,
		success : function(data){
			$('#updateForm .UI_KEYNO').val(data.UI_KEYNO);
			$('#updateForm input[name=UI_ID]').val(data.UI_ID);
			$('#updateForm .UI_ID').text(data.UI_ID);
			$('#updateForm .UI_NAME').val(data.UI_NAME);
			$('#updateForm .UI_EMAIL').val(data.UI_EMAIL);
			$('#updateForm .UI_PHONE').val(data.UI_PHONE);
			$('#updateForm input[name=UI_AUTH_YN][value='+data.UI_AUTH_YN+']').prop('checked',true);
			$('#updateForm input[name=UI_DORMANCY][value='+data.UI_DORMANCY+']').prop('checked',true);
			$('#updateForm .UIA_KEYNO_BEFORE').val(data.UIA_KEYNO);
			$('#updateForm .UIA_DIVISION').val(data.UIA_DIVISION);
			if(data.UIA_KEYNO != null){
				if(data.UIA_KEYNO == "${sp:getData('AUTHORITY_ADMIN')}"){
					$('.form-group-authority').hide();
				}else{
					if(data.UIA_DIVISION == 'U'){
						$('.radio-authority').show();
						$('.radio-authority input[name=UIA_KEYNO]').val(data.UIA_KEYNO)
						$('.radio-authority span').text(data.UIA_NAME)
					}else{
						$('.radio-authority').hide();	
					}
					$('.form-group-authority').show();
					$('input[name=UIA_KEYNO][value='+data.UIA_KEYNO+']').prop('checked',true)
					
				}
			}else{
				$('.radio-authority').hide();
			}
		},
		error: function(){
			alert('데이터를 불러올수없습니다. 관리자에게 문의하세요.')
			return false;
		}
	});
}

//회원별 활동기록
function pf_activeMember(){
	location.href= "/dyAdmin/statistics/log.do?id="+selectedId;		
}

//다이얼로그 버튼
function pf_setttingDialog(obj,title,successText1,successFnc1,successText2,successFnc2,successText3,successFnc3,cancelText){
	
	var cancelText = cancelText || '취소';
	var data = {
			autoOpen : false,
			width : 800,
			resizable : false,
			modal : true,
			title : title
	}
	if(successText1){
		data.buttons = [{
			html : "<i class='fa fa-floppy-o'></i>&nbsp; "+successText1,
			"class" : "btn btn-primary",
			click : function() {
				if(eval(successFnc1)){
					$(this).dialog("close");
				}
			}
		},
		{
			html : "<i class='fa fa-floppy-o'></i>&nbsp; "+successText2,
			"class" : "btn btn-danger",
			click : function() {
				if(eval(successFnc2)){
					$(this).dialog("close");
				}
			}
		},
		{
			html : "<i class='fa fa-floppy-o'></i>&nbsp; "+successText3,
			"class" : "btn btn-primary",
			click : function() {
				if(eval(successFnc3)){
					$(this).dialog("close");
				}
			}
		},
		{
			html : "<i class='fa fa-times'></i>&nbsp; "+cancelText,
			"class" : "btn btn-default",
			click : function() {
				$(this).dialog("close");
			}
		}]
	}else{
		data.buttons = [{
			html : "<i class='fa fa-times'></i>&nbsp; 확인",
			"class" : "btn btn-primary",
			click : function() {
				$(this).dialog("close");
			}
		}]
	}
	$(obj).dialog(data);
	
}

//회원 삭제
function pf_deleteMember(){
	
	
	if(!confirm('정말 삭제하시겠습니까?')){
		return false;
	}
	
	$.ajax({
		type: "POST",
		url: "/dyAdmin/person/deleteAjax.do",
		data: $('#updateForm').serializeArray(),
		async:false,
		success : function(data){
			alert('회원 정보가 삭제되었습니다.');
			$('#member-update').dialog('close');
			pf_LinkPage($('#pageIndex').val());
		},
		error: function(){
			alert('알수없는 에러 발생. 관리자에게 문의하세요.')
			return false;
		}
	});

	return true;
}


function pf_updateMemberSubmit(){
	$('#updateForm').submit();
}

//회원 정보 수정
function pf_updateMember(){
 	var form = $('#updateForm')[0];
		//FormData parameter에 담아줌
		var formData = new FormData(form);

	  $.ajax({
		type: "POST",
		url: "/dyAdmin/person/updateAjax.do",		
 		processData: false,
        contentType: false,
		data: formData, 
		async:false,
		success : function(result){
			alert('성공적으로 변경 되었습니다.');
			$('#member-update').dialog('close');
			pf_LinkPage($('#pageIndex').val());
			
		},
		error: function(){
			alert('알수없는 에러 발생. 관리자한테 문의하세요.')
			return false;
		}
	}); 
	
	return true; 
}

</script>