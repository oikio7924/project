<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<style>

.checksize{
 width: 20% !important;
 margin-bottom: 5px !important;
}
#dt_basic tbody tr {cursor:pointer;}
form .error {color:red}

.checkbox-inline+.checkbox-inline, .radio-inline+.radio-inline {margin-left:0;}
.checkbox-inline, .radio-inline {margin-right:10px;}

</style>

<form:form id="Form" name="Form" method="post" action="">
<input type="hidden" name="PASSWORD_REGEX" id="PASSWORD_REGEX" value="${userInfoSetting.SC_CODEVAL01}">
<input type="hidden" name="id" value="${id }">
<input type="hidden" name="chkvalue" id="chkvalue">
<section id="widget-grid" class="">
	<div class="row">
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
			<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>회원 리스트</h2>
				</header>
				<div class="widget-body " >
					<div class="widget-body-toolbar bg-color-white">
						<div class="alert alert-info no-margin fade in">
							<button type="button" class="close" data-dismiss="alert">×</button>
							회원 리스트를 확인합니다.
						</div> 
					</div>
					<div class="widget-body-toolbar bg-color-white">
						<div class="row"> 
							<div class="col-sm-12 col-md-2 text-align-right" style="float:right;">
								<div class="btn-group">
									<button class="btn btn-sm btn-primary" type="button" onclick="pf_openWithdrawPopup()" style="margin-right: 10px;">
										<i class="fa fa-plus"></i> 탈퇴 목록
									</button>  
									<button class="btn btn-sm btn-primary" type="button" onclick="pf_openInsertPopup()">
										<i class="fa fa-plus"></i> 회원 등록
									</button> 
<!-- 									<button class="btn btn-sm btn-primary" type="button" onclick="AlimTalkSend()" style = "margin-right: 10px; margin-top: 10px;"> -->
<!-- 										 카카오톡 전송 -->
<!-- 									</button> -->
<!-- 									<button class="btn btn-sm btn-primary" id="deleteButton" -->
<!-- 								type="button" onclick="deleteAlim()" style="background-color: #E53935; margin-top: 10px;">예약 취소</button> -->
							</div>
								</div>
							</div>
						</div>
					</div>
					<div class="table-responsive">
						<jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
							<jsp:param value="/dyAdmin/person/view/pagingAjax.do" name="pagingDataUrl" />
							<jsp:param value="/dyAdmin/person/view/excelAjax.do" name="excelDataUrl" />
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
<%@ include file="pra_member_list_insert.jsp"%>
<%@ include file="pra_member_list_update.jsp"%>
<%@ include file="pra_member_list_withdraw.jsp"%>



<script type="text/javascript">

function pf_resetMemberData(obj){
	$form = $('#'+obj);
	$form.find('.form-control').val('');
	$form.find('label.error').remove();
	$form.find('.error').removeClass('error');
	$form.find('input[name^=UIA_KEYNO]').prop('checked',false)
	
}

function noSpaceForm(obj) { // 공백사용못하게
    var str_space = /\s/;  // 공백체크
    if(str_space.exec(obj.value)) { //공백 체크
        alert("비밀 번호에는 공백을 사용할수 없습니다.\n\n공백은 자동적으로 제거 됩니다.");
        obj.focus();
        obj.value = obj.value.replace(' ',''); // 공백제거
        return false;
    }
}
function checkcheck(value){
	$.ajax({
		url: '/dyAdmin/person/AlimSelect.do',
		type: 'POST',
		data: {
        	"UI_KEYNO": value
        },
		async: false,
		success : function(data){
			
			console.log(data[0].UI_ALIMYN);
			
			if(data[0].UI_ALIMYN == "Y"){
				$.ajax({
					url: '/dyAdmin/person/ailimcancle.do',
					type: 'POST',
					data: {
			        	"UI_KEYNO": value
			        },
					async: false,
					success : function(data){
					}
				});
			}else if(data[0].UI_ALIMYN == "N"){
				$.ajax({
					url: '/dyAdmin/person/sendchk.do',
					type: 'POST',
					data: {
			        	"UI_KEYNO": value
			        },
					async: false,
					success : function(data){
					}
				});	
			}
		}
	});
}


function seletAll(){
	
	if($("#cbx_chkAll").is(":checked")) $("input[name=chk]").prop("checked", true);
	else $("input[name=chk]").prop("checked", false);
}

function AlimTalkSend() {
	
	var array = new Array(); 
	$('input:checkbox[name=chk]:checked').each(function() { // 체크된 체크박스의 value 값을 가지고 온다.
	    array.push(this.value);
	});
	
	$("#chkvalue").val(array);
	
	if(array.length > 0){
		if(confirm("전송예약 하시겠습니까?")){
			$.ajax({
				url: '/dyAdmin/person/ailim.do',
				type: 'POST',
				data: $('#Form').serialize(),
				async: false,
				success : function(data){
					alert("카카오톡 알림은 매일 15시에 전송됩니다.");
					location.reload();
				}
			});
		}else{
			cf_smallBox('error', "취소되었습니다.", 3000,'#d24158');
		}
	}else{
		alert("전송할 발전소를 선택해주세요.")
	}
return false;
}


function deleteAlim() {
	
	var array = new Array(); 
	$('input:checkbox[name=chk]:checked').each(function() { // 체크된 체크박스의 value 값을 가지고 온다.
	    array.push(this.value);
	});
	
	$("#chkvalue").val(array);
	
	if(array.length > 0){
		if(confirm("예약취소 하시겠습니까?")){
			$.ajax({
				url: '/dyAdmin/person/ailimcancle.do',
				type: 'POST',
				data: $('#Form').serialize(),
				async: false,
				success : function(data){
					alert(data);
					location.reload();
				}
			});
		}else{
			cf_smallBox('error', "취소되었습니다.", 3000,'#d24158');
		}
	}else{
		alert("취소할 발전소를 선택해주세요.")
	}
	return false;
}
</script>