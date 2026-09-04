<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>
#insert-article {display:none;}
</style>

<form:form id="Form" name="Form" method="post" action="">
	<input type="hidden" name="SM_KEYNO" id="SM_KEYNO" value="" />
	<input type="hidden" name="action" id="action" value="" />
	<section id="widget-grid" >
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12" id="list-article">
				<div class="jarviswidget jarviswidget-color-blueDark" id="BOARD_TYPE_LIST_1" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-table"></i>
						</span>
						<h2>설문지 내역</h2>
					</header>
					<div class="widget-body " >
						<div class="widget-body-toolbar bg-color-white">
							<div class="alert alert-info no-margin fade in">
								<button type="button" class="close" data-dismiss="alert">×</button>
								설문지 정보 목록 입니다. 설문지를 확인하거나 새롭게 등록 할 수 있습니다.
							</div> 
						</div>
						<div class="widget-body-toolbar bg-color-white">
							<div class="row"> 
								<div class="col-sm-12 col-md-2 text-align-right" style="float:right;">
									<div class="btn-group">  
										<button class="btn btn-sm btn-primary" type="button" onclick="pf_surveyActionView('Insert')">
											<i class="fa fa-plus"></i> 설문지 등록
										</button> 
									</div>
								</div>
							</div>
						</div>
						<div class="table-responsive">
							<jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
								<jsp:param value="/dyAdmin/operation/survey/pagingAjax.do" name="pagingDataUrl" />
								<jsp:param value="/dyAdmin/operation/survey/excelAjax.do" name="excelDataUrl" />
							</jsp:include>
							<fieldset id="tableWrap">
							</fieldset>
						</div>												
					</div>
				</div>
			</article>		
</form:form>


<script type="text/javascript">

function pf_surveyRegist(){
	
	location.href='/dyAdmin/operation/survey/insertView.do';
}

function pf_surveyActionView(type, sm_keyno){
	$("#action").val(type);
	$("#SM_KEYNO").val(sm_keyno);
	$("#Form").attr("action","/dyAdmin/operation/survey/actionView.do");
	$("#Form").submit();
}

function pf_resultDetailView(sm_keyno){
	$("#SM_KEYNO").val(sm_keyno);
	$("#Form").attr("action","/dyAdmin/operation/survey/result/detailView.do");
	$("#Form").submit();
}

function pf_questionDetailView(sm_keyno) {
	$("#SM_KEYNO").val(sm_keyno);
	$("#Form").attr("action","/dyAdmin/operation/survey/questionListView.do");
	$("#Form").submit();
}
</script>
