<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<form:form id="Form2" method="post" action="">
	<input type="hidden" name="pageIndex" value="${search.pageIndex}">
	<input type="hidden" name="orderBy"  value="${search.orderBy }">
	<input type="hidden" name="sortDirect" value="${search.sortDirect }">
	<input type="hidden" name="pagingUrl" value="/dyAdmin/homepage/popup/pagingAjax.do">
	<input type="hidden" name="excelUrl" value="/dyAdmin/homepage/popup/excelAjax.do">
	<input type="hidden" name="PI_CHECK" value="N">
	<section id="widget-grid2" >
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-table"></i>
						</span>
						<h2>미사용 팝업 리스트</h2>
					</header>
					<div>
						<div class="widget-body " >
							<div class="table-responsive">
								<fieldset class="tableWrap">
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


$(document).ready(function() {
	
	pf_LinkPage(1,'Form2');
	
});

</script>