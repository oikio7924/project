<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<div id="content">
	<form:form id="Form" name="Form" method="post" action="">
		<input type="hidden" name="TLM_KEYNO" id="TLM_KEYNO" value="" />
		<input type="hidden" name="TLM_TCGM_KEYNO" id="TLM_TCGM_KEYNO" value="" />
		<input type="hidden" name="TLM_ORDER" id="TLM_ORDER" value="" />
		<input type="hidden" name="TLM_ORDER_BEFORE" id="TLM_ORDER_BEFORE" value="" />
		<input type="hidden" name="TLM_USE_YN" id="TLM_USE_YN" value="" />
		<input type="hidden" name="SHOW_USING_YN" id="SHOW_USING_YN" value="" />
		
		<section id="widget-grid" >
			<div class="row">
				<article class="col-sm-12 col-md-12 col-lg-12">
					<div class="jarviswidget jarviswidget-color-blueDark" id="BOARD_TYPE_LIST_1" data-widget-editbutton="false">
						<header>
							<span class="widget-icon"> <i class="fa fa-table"></i>
							</span>
							<h2>리스트 내역</h2>
						</header>
						<div class="widget-body " >
							<div class="widget-body-toolbar bg-color-white">
								<div class="alert alert-info no-margin fade in">
									<button type="button" class="close" data-dismiss="alert">×</button>
									리스트 목록입니다. 리스트를 생성, 관리 할 수 있습니다.
								</div> 
							</div>
							<div class="widget-body-toolbar bg-color-white">
								<div class="row"> 
									
									<div class="col-sm-2 col-md-2">
										<select class="form-control input-sm" name="category" id="category" style="width: auto;" onchange="pf_LinkPage()">
											<c:forEach items="${categoryList }" var="model">
												<option value="${model.TCGM_KEYNO }" ${category eq model.TCGM_KEYNO ? 'selected' : '' }>${model.FORM_NAME }</option>
											</c:forEach>
										</select>
									</div>
								
									<div class="col-sm-4 col-xs-6 smart-form" style="line-height: 20px; text-align: left;">
										<label class="checkbox" style="padding-top:0">
											<input type="checkbox" class="style-0" name="SHOW_USING_YN" id="SHOW_USING_YN" value="" onchange="pf_ShowUsingPage(this);"><i></i>
											사용중인 리스트만 보기
										</label>
									</div>
									
									<div class="col-sm-6 col-md-2 text-align-right" style="float:right;">
										<div class="btn-group">  
											<button class="btn btn-sm btn-primary" type="button" onclick="pf_listRegist()">
												<i class="fa fa-plus"></i> 리스트 생성
											</button> 
										</div>
									</div>
								</div>
							</div>
							<div class="table-responsive">
								<jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
									<jsp:param value="/dyAdmin/homepage/popupzone/list/pagingAjax.do" name="pagingDataUrl" />
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

//카테고리 수정페이지 이동
function pf_categoryUpdate(key) {
	$("#TLM_KEYNO").val(key);
	$("#Form").attr("action", "/dyAdmin/homepage/popupzone/list/updateView.do");
	$("#Form").submit();
} 

//리스트 등록페이지 이동 
function pf_listRegist() {
	$("#Form").attr("action", "/dyAdmin/homepage/popupzone/list/insertView.do");
	$("#Form").submit();
}

function pf_useList(key, use) {
	$('#TLM_KEYNO').val(key);
	$('#TLM_USE_YN').val(use);
	$('#Form').attr('action','/dyAdmin/homepage/popupzone/list/check.do');
	$('#Form').submit()
}

function pf_DeleteList(key ,tlm_tcgm_keyno, beforeOrder) {
	$('#TLM_KEYNO').val(key);
	$("#TLM_TCGM_KEYNO").val(tlm_tcgm_keyno);
	$("#TLM_ORDER_BEFORE").val(beforeOrder);
	$("#Form").attr("action", "/dyAdmin/homepage/popupzone/list/delete.do?${_csrf.parameterName}=${_csrf.token}");
	$("#Form").submit();
}

function pf_ShowUsingPage(obj) {
	if($(obj).prop('checked')) {
		$('#SHOW_USING_YN').val('Y');
		pf_LinkPage();
	} else {
		$('#SHOW_USING_YN').val('');
		pf_LinkPage();
	}
}

function fn_updateLevel(tlm_keyno, tlm_tcgm_keyno, beforeOrder, order){
	$("#TLM_KEYNO").val(tlm_keyno);
	$("#TLM_TCGM_KEYNO").val(tlm_tcgm_keyno);
	$("#TLM_ORDER_BEFORE").val(beforeOrder);
	$("#TLM_ORDER").val(order);
	$("#Form").attr("action", "/dyAdmin/homepage/popupzone/list/orderUpdate.do");
	$("#Form").submit();
}

</script>
