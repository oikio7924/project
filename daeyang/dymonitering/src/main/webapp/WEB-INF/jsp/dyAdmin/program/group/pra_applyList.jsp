<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<form:form id="Form" name="Form" method="post" action="" class="form-inline" role="form">
<input type="hidden" name="key" id="key">
<input type="hidden" name="GM_KEYNO" id="GM_KEYNO">
<section id="widget-grid" class="">
	<div class="row">
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
			<div class="jarviswidget jarviswidget-color-blueDark" id="wid-id-0"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>단체예약프로그램 신청자 조회</h2>
				</header>
				<div class="widget-body">
					<div class="widget-body-toolbar bg-color-white">
						<div class="alert alert-info no-margin fade in">
							<button type="button" class="close" data-dismiss="alert">×</button>
							단체프로그램 신청자 리스트를 확인합니다.
						</div> 
					</div>
					<div class="col-sm-12 col-md-8">
						<div style="float:left;">
							<select class="form-control input-sm" id="MN_HOMEDIV_C" name="MN_HOMEDIV_C" style="width: auto;" onchange="pf_changeHomeDiv(this.value)">
								<c:forEach items="${homeDivList }" var="model">
									<option value="${model.MN_KEYNO }" ${MN_HOMEDIV_C eq model.MN_KEYNO ? 'selected' : '' }>${model.MN_NAME }</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="widget-body-toolbar bg-color-white">
						<div class="row"> 
							<div class="col-sm-12 col-md-2 text-align-right" style="float:right;">
								<div class="btn-group">  
								</div>
							</div>
						</div>
					</div>
					<div class="table-responsive">
						<jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
							<jsp:param value="/dyAdmin/program/group/apply/pagingAjax.do" name="pagingDataUrl" />
							<jsp:param value="/dyAdmin/program/group/apply/excelAjax.do" name="excelDataUrl" />
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

<script>
//프로그램 상세보기
function pf_detail(key, type){
	$("#key").val(key);
	
	if(type == 'P'){
		$("#Form").attr("action", "/dyAdmin/program/group/applyDetail.do");
	}else if(type == 'M'){
		$('#GM_KEYNO').val(key);
		$("#Form").attr("action", "/dyAdmin/program/group/actionView.do");
	}
	$("#Form").submit();
}

//홈페이지 변경 처리
function pf_changeHomeDiv(value){
	pf_getList();
}


</script>
