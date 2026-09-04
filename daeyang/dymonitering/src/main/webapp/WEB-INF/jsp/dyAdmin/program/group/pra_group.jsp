<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<!-- widget grid -->
<form:form id="Form" name="Form" method="post" action="" class="form-inline" role="form">
<input type="hidden" name="GM_KEYNO" id="GM_KEYNO">
<input type="hidden" name="GM_MN_HOMEDIV_C" id="GM_MN_HOMEDIV_C">
<input type="hidden" name="key" id="key">
<section id="widget-grid" class="">
	<div class="row">
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
			<div class="jarviswidget jarviswidget-color-blueDark" id="wid-id-0"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>단체예약프로그램 목록 조회</h2>

				</header>
					<div class="widget-body">
						<div class="widget-body-toolbar bg-color-white">
							<div class="alert alert-info no-margin fade in">
								<button type="button" class="close" data-dismiss="alert">×</button>
								단체프로그램 리스트를 확인합니다.
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
										<button class="btn btn-sm btn-primary" type="button" onclick="pf_openAddGroup();" >
											<i class="fa fa-plus"></i>프로그램 등록
										</button>
									</div>
								</div>
							</div>
						</div>
						<div class="table-responsive">
							<jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
								<jsp:param value="/dyAdmin/program/group/program/pagingAjax.do" name="pagingDataUrl" />
								<jsp:param value="/dyAdmin/program/group/program/excelAjax.do" name="excelDataUrl" />
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

<script>
//신청프로그램 추가
function pf_openAddGroup(key){
	$('#GM_MN_HOMEDIV_C').val($('#MN_HOMEDIV_C').val());
	if(key != null && key != ""){
		$('#GM_KEYNO').val(key);
	}
	$("#Form").attr("action", "/dyAdmin/program/group/actionView.do");
	$("#Form").submit();
}

//홈페이지 변경 처리
function pf_changeHomeDiv(value){
	pf_getList();
}

</script>
