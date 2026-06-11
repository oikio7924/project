<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<style>
.checksize {
	width: 20% !important;
	margin-bottom: 5px !important;
}

#dt_basic tbody tr {
	cursor: pointer;
}

form .error {
	color: red
}

.checkbox-inline+.checkbox-inline, .radio-inline+.radio-inline {
	margin-left: 0;
}

.checkbox-inline, .radio-inline {
	margin-right: 10px;
}
</style>


<form:form id="Form" name="Form" method="post" action="">
	<input type="hidden" name="PASSWORD_REGEX" id="PASSWORD_REGEX"
		value="${userInfoSetting.SC_CODEVAL01}">
	<input type="hidden" id="MN_HOMEDIV_C" name="MN_HOMEDIV_C" value="${HOMEDIV_C }"/>
	<input type="hidden" name="id" value="${id }">
	<section id="widget-grid" class="">
		<div class="row">
			<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0"
					data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-table"></i>
						</span>
						<h2>사원 리스트</h2>
					</header>
					<div class="widget-body ">
						<div class="widget-body-toolbar bg-color-white">
							<div class="alert alert-info no-margin fade in">
								<button type="button" class="close" data-dismiss="alert">×</button>
								사원 리스트를 확인합니다.
							</div>
						</div>
						<div class="widget-body-toolbar bg-color-white">
							<div class="row">
								<div class="col-sm-12 col-md-2 text-align-right"
									style="float: right;">
									<div class="btn-group">
										<button class="btn btn-sm btn-primary" type="button"
											onclick="pf_openInsertPopup()">
											<i class="fa fa-plus"></i> 사원 등록
										</button>
									</div>
								</div>
							</div>
						</div>
						<div class="table-responsive">
							<jsp:include
								page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp"
								flush="true">
								<jsp:param value="/dyAdmin/person/view/organPagingAjax.do"
									name="pagingDataUrl" />
								<jsp:param value="/dyAdmin/operation/empl/excelAjax.do"
									name="excelDataUrl" />
							</jsp:include>
							<fieldset id="tableWrap"></fieldset>
						</div>
					</div>
				</div>
			</article>
		</div>
	</section>
</form:form>


<script type="text/javascript">


	function pf_resetMemberData(obj) {
		$form = $('#' + obj);
		$form.find('.form-control').val('');
		$form.find('label.error').remove();
		$form.find('.error').removeClass('error');
	}

</script>