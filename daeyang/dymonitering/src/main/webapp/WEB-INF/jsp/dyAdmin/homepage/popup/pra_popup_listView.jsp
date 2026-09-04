<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<link type="text/css" rel="stylesheet" href="/resources/common/css/paging_table.css">

<style>
.tree .settings {display:inline-block;font-size: 0.5em;}
.tree .settings .checkbox {display:inline-block;margin:0;}
#popup_menu_list{text-align: left;}
</style>


<form:form  id="actionForm" method="post">
	<input type="hidden" name="PI_KEYNO" id="PI_KEYNO" value="">
	<input type="hidden" name="PI_CHECK" id="PI_CHECK" value="">
	<input type="hidden" id="PI_LEVEL" name="PI_LEVEL" value="">
	<input type="hidden" id="PI_LEVEL_AFTER" name="PI_LEVEL_AFTER" value="">
</form:form>


<form:form id="Form" method="post" action="">
	<input type="hidden" name="PI_CHECK" value="Y">
	<section id="widget-grid1" >
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-table"></i>
						</span>
						<h2>사용중인 팝업 리스트</h2>
					</header>
					<div>
						<div class="widget-body " >
							<div class="widget-body-toolbar bg-color-white">
								<div class="alert alert-info no-margin fade in">
									<button type="button" class="close" data-dismiss="alert">×</button>
									팝업 목록입니다. 팝업을 생성 할 수 있습니다.
								</div> 
							</div>
							<div class="widget-body-toolbar bg-color-white">
								<div class="row"> 
									<div class="col-sm-12 col-md-2 text-align-right" style="float:right;">
										<div class="btn-group">  
											<button class="btn btn-sm btn-primary" type="button" onclick="pf_popupRegist()">
												<i class="fa fa-plus"></i> 추가
											</button> 
										</div>
									</div>
								</div>
							</div>
							<div class="table-responsive">
								<jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
									<jsp:param value="/dyAdmin/homepage/popup/pagingAjax.do" name="pagingDataUrl" />
									<jsp:param value="/dyAdmin/homepage/popup/excelAjax.do" name="excelDataUrl" />
								</jsp:include>
								<fieldset id="tableWrap">
								</fieldset>
							</div>
						</div>
					</div>
				</div>
			</article>
		</div>
	</section>
</form:form>

<script type="text/javascript">

var searchParamList = [];

$(function(){
	
	var msg = '${msg}';
	if(msg != null && msg != ""){
		setTimeout(function(){
		cf_smallBox('Form', msg, 3000);
		},200);	
	}
});


function pf_popupMain(key){
	location.href="/dyAdmin/homepage/popup/insertView.do?PI_KEYNO=" + key;
}

//팝업 메인 등록 // 팝업 삭제 관련 체크박스 확인
function pf_usePopup(key,use,level){
	$('#PI_KEYNO').val(key);
	$('#PI_CHECK').val(use);
	$("#PI_LEVEL").val(level);
	$('#actionForm').attr('action','/dyAdmin/homepage/popup/check.do');
	$('#actionForm').submit()
}

function pf_DeletePopup(key){
	$('#PI_KEYNO').val(key);
	$('#actionForm').attr('action','/dyAdmin/homepage/popup/deleteAjax.do');
	$('#actionForm').submit()
}

function pf_popupRegist(){
	$("#actionForm").attr("action", "/dyAdmin/homepage/popup/insertView.do");
	$("#actionForm").submit();
}
</script>