<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<style>
#dt_basic tbody tr{cursor: pointer;}
</style>
<input type="hidden" name="seqbo" id="seqbo"/>
<div id="content">
	<form:form id="Form" name="Form" method="post" action="/dyAdmin/homepage/board/dataView.do" class="form-inline">
		<input type="hidden" name="BT_KEYNO" id="BT_KEYNO" value="">
		<input type="hidden" name="BN_KEYNO" id="BN_KEYNO" value="">
		<input type="hidden" name="MN_NAME" id="MN_NAME" value="">
		<input type="hidden" id="MN_HOMEDIV_C" name="MN_HOMEDIV_C" value="${HOMEDIV_C }"/>
		<section id="widget-grid" >
			<div class="row">
				<article class="col-sm-12 col-md-12 col-lg-12">
					<div class="jarviswidget jarviswidget-color-blueDark" id="board_notice_list_1" data-widget-editbutton="false">
						<header>
							<span class="widget-icon"> <i class="fa fa-lg fa-desktop"></i> </span>
							<h2>게시물 삭제 대장 </h2>
						</header> 
						<div>
							<div class="jarviswidget-editbox"></div>
							<div class="widget-body">
								<div class="widget-body-toolbar bg-color-white">
									<div class="alert alert-info no-margin fade in">
										<button type="button" class="close" data-dismiss="alert">×</button>
										홈페이지를 선택하면 삭제된 게시글만 출력됩니다.
									</div>
								</div> 
								<div class="table-responsive">
									<jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
										<jsp:param value="/dyAdmin/homepage/board/deleteView/pagingAjax.do" name="pagingDataUrl" />
										<jsp:param value="/dyAdmin/homepage/board/deleteView/excelAjax.do" name="excelDataUrl" />
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
</div>
<script type="text/javascript">

pageLoadingCheck = false;

$(function(){
	pageLoadingCheck = true;	
	//홈페이지 구분 변경시에, 아래 화면의 메뉴트리가 변경되는 처리
	$("#MN_NAME").val($("#HOMEDIV option:checked").text());
	$("#HOMEDIV").change(function(e){
		$("#MN_HOMEDIV_C").val($(this).val());
		$("#MN_NAME").val($("#HOMEDIV option:checked").text());
		pf_getList()
	});
	
});


function pf_DetailMove(keyno){
	$('#BN_KEYNO').val(keyno);
	$("#Form").attr("action", "/dyAdmin/homepage/board/data/detailView.do");
	$("#Form").submit();
}


</script>