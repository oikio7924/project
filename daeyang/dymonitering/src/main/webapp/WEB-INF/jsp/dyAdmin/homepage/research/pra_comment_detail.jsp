<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>

pre {background-color: inherit !important;}

</style>

<form:form id="Form" name="Form" method="post" action="">
	<input type="hidden" name="MN_HOMEDIV_C" id="MN_HOMEDIV_C" value="${MN_HOMEDIV_C}"/>
	<section id="widget-grid" >
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" id="BOARD_TYPE_LIST_1" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-table"></i>
						</span>
						<h2>코멘트 관리</h2>
					</header>
					<div class="widget-body " >
						<div class="widget-body-toolbar bg-color-white">
							<div class="alert alert-info no-margin fade in">
								<button type="button" class="close" data-dismiss="alert">×</button>
								페이지 평가 코멘트 내역
							</div> 
						</div>
						<div class="widget-body-toolbar bg-color-white">
							<div class="row">
								<div class="col-sm-12 col-md-2 text-align-right"
									style="float: right;">
									<div class="btn-group">
									</div>
								</div>
							</div>
						</div>
						<div class="table-responsive">
							<jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
								<jsp:param value="/dyAdmin/operation/pageResearch/commentDetail/pagingAjax.do" name="pagingDataUrl" />
								<jsp:param value="/dyAdmin/operation/pageResearch/commentDetail/excelAjax.do" name="excelDataUrl" />
							</jsp:include>
							<fieldset id="tableWrap">
							</fieldset>
							<div class="form-actions" style="margin: 25px 0 0 0;">
							<div class="row">
								<div class="col-md-12">
								</div>
							</div>
						</div>
						</div>
					</div>
				</div>
			</article>
		</div>
	</section>
</form:form>

<!-- 팝업 CONTENT -->
<div id="page_comment2" title="페이지 평가 결과">
	<div class="widget-body ">
		<fieldset>
			<div class="form-horizontal">
				<fieldset>
					<div class="form-group">
						<label class="col-md-2 control-label">코멘트</label>
						<div class="col-md-10 tps_comment">				
						</div>
					</div>
				</fieldset>
			</div>
		</fieldset>
	</div>
</div>

<script type="text/javascript">

$(function(){
	
	/* 팝업 */
	cf_setttingDialog('#page_comment2','코멘트 상세보기');
});

//홈페이지 변경 처리
function pf_changeHomeDiv(value){
	pf_getList();
}


/* 권한 추가 모달창 오픈 */
function pf_viewComment(obj){
	$('#page_comment2').dialog('open');
	$("#page_comment2").find(".tps_comment").empty();	
	
	var string = $(obj).closest('tr').find('.comment').text();
	
	var temp = "<div class='commentStyle'><div style='overflow-y:scroll; height:200px;'>"+string+"</div></div>";
	$("#page_comment2").find(".tps_comment").append(temp);		
	
}


</script>