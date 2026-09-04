<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<style>
.table-authorityInfo tr {font-size:13px;}
.table-authorityInfo tr td {padding:10px 0;line-height:20px;}
.table-authorityInfo tr td:nth-of-type(1) {width:20%;text-align:right;padding-right:10px;}
.table-authorityInfo tr td:nth-of-type(2) {padding-left:10px;}

</style>

<form:form id="Form1" method="post" action="">
	<input type="hidden" name="pageIndex" value="${search.pageIndex}">
	<input type="hidden" name="orderBy"  value="${search.orderBy }">
	<input type="hidden" name="sortDirect" value="${search.sortDirect }">
	<input type="hidden" name="pagingUrl" value="/dyAdmin/homepage/popup/pagingAjax.do">
	<input type="hidden" name="excelUrl" value="/dyAdmin/homepage/popup/excelAjax.do">
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

