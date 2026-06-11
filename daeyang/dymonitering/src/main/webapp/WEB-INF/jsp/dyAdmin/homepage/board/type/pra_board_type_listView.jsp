<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<div id="content">
	<form:form id="Form" name="Form" method="post" action="/dyAdmin/homepage/board/type/actionView.do">
		<input type="hidden" name="BT_KEYNO" id="BT_KEYNO" value="" />
		<input type="hidden" name="action" id="action" value="" />
		<section id="widget-grid" >
			<div class="row">
				<article class="col-sm-12 col-md-12 col-lg-12">
					<div class="jarviswidget jarviswidget-color-blueDark" id="BOARD_TYPE_LIST_1" data-widget-editbutton="false">
						<header>
							<span class="widget-icon"> <i class="fa fa-table"></i>
							</span>
							<h2>게시판 타입 내역</h2>
						</header>
						<div class="widget-body " >
							<div class="widget-body-toolbar bg-color-white">
								<div class="alert alert-info no-margin fade in">
									<button type="button" class="close" data-dismiss="alert">×</button>
									게시판 타입 정보 목록입니다. 게시판 권한을 변경하거나 새로운 권한을 가진 게시판 타입을 생성 할 수 있습니다.
								</div> 
							</div>
							<div class="widget-body-toolbar bg-color-white">
								<div class="row"> 
									<div class="col-sm-12 col-md-2 text-align-right" style="float:right;">
										<div class="btn-group">  
											<button class="btn btn-sm btn-primary" type="button" onclick="pf_boardTypeAction('insertView')">
												<i class="fa fa-plus"></i> 게시판타입생성
											</button> 
										</div>
									</div>
								</div>
							</div>
							<div class="table-responsive">
								<jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
									<jsp:param value="/dyAdmin/homepage/board/typeView/pagingAjax.do" name="pagingDataUrl" />
									<jsp:param value="/dyAdmin/homepage/board/typeView/excelAjax.do" name="excelDataUrl" />
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
</div>
<script type="text/javascript">

function pf_boardTypeAction(type, key) {
	$("#Form").attr("action","/dyAdmin/homepage/board/type/actionView.do");
	if(key){
		$("#BT_KEYNO").val(key);
	}
	$("#action").val(type);
	$("#Form").submit();
} 

</script>
