<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<style>
#maintable thead th{text-align: center;}   
    
</style>
<div id="content">
	<section id="widget-grid" >
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" id="board_notice_list_1" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-lg fa-desktop"></i> </span>
						<h2>게시판 조회수 관리</h2>
					</header> 
					<div>
						<div class="jarviswidget-editbox"></div>
						<div class="widget-body">
							<div class="widget-body-toolbar bg-color-white">
								<div class="alert alert-info no-margin">
									일별 첨부파일 다운로드 카운트를 확인합니다.
								</div>
							</div> 
							<form:form id="Form" name="Form" method="post" action="/dyAdmin/operation/serchpageview.do?${_csrf.parameterName}=${_csrf.token}" class="smart-form" role="form">
								<input type="hidden" id="key" name="key" value="${key }">
								<div class="widget-body-toolbar bg-color-white smart-form" style="margin-top: 0px;">
									<section class="col col-2">
										<label class="select">
											<select class="form-control input-sm" id="YEARDIV" name="YEAR_DIV">
												<option value="">연도전체</option>
												<c:forEach items="${fileYear }" var="model">
													<option value="${model.YEAR_DIV }">${model.YEAR_DIV}</option>
												</c:forEach>
										</select> <i></i> 
										</label>
									</section>
									<section class="col col-2">
										<div class="btn-group" style="width: 100%;">  
											<button class="btn btn-sm btn-primary smallBtn" type="button" onclick="search_date()" style="margin-right:10px;">
												<i class="fa fa-plus"></i> 검색
											</button>
										</div>
									</section>
								</div> 
							</form:form>
							
							<fieldset id="tableWrap">
								<div class="tab-content">
									<div class="tab-pane fade in active" id="hr1">
										<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
											<div class="jarviswidget" id="pc" data-widget-colorbutton="false" data-widget-fullscreenbutton="false" data-widget-editbutton="false" data-widget-sortable="false" style="margin-bottom: 10px;">
												<header>
													<h2>${boardMN.MN_NAME } - ${fileNM }</h2>
												</header>
												<div>
													<div class="jarviswidget-editbox">
														<input class="form-control" type="text">
													</div>
													<div class="widget-body">
														<table class="table table-striped table-bordered table-hover" id="maintable" style="width:100%;">
															<thead>
																<tr>
																	<th colspan="33">
																		<div style="float:right;">
																			<button type="button" class="btn btn-sm btn-default" onclick="pf_excel('/dyAdmin/func/AttachDetailExcel.do')">엑셀</button>
																	    </div>
																	</th>
																</tr>
																<tr>
																	<th width="3%">월</th>
																	<c:forEach var="i" begin="1" end="31" step="1" >
																	<th width="2.5%">
												                        <fmt:formatNumber value="${i}" minIntegerDigits="2"/>
																	</th>
												                    </c:forEach>
																	<th width="4%">총합</th>
																</tr>
															</thead>
															<tbody style="text-align: center;">
															</tbody>
														</table>
													</div>
												</div>
											</div>
											<!-- end widget -->
											<fieldset class="text-right" style="padding: 10px 0 15px;"> 
												<button type="submit" onclick="pf_back()" class="btn btn-default">	
													<i class="fa fa-times"></i> 목록으로
												</button>
											</fieldset>
										</article>
									</div>
									<!-- 그래프끝 -->
								</div>
							</fieldset>
						</div>
					</div>
				</div>
				
			</article>
		</div>
	</section>
</div>

<script type="text/javascript">
var applicationTable = null;
$(function(){
	getHtml();
});

function search_date() {
	getHtml();
}

//비동기로 ajax 조회
function getHtml() {
	$.ajax({
		type : "post",
		data : $('#Form').serialize(),
		url : "/dyAdmin/func/AjaxattachDetailView.do",
		async : false,
		success : function(data, textStatus, xhr) {
			if(applicationTable){
				applicationTable.destroy();
			}
			$("#YEARDIV").val(data.year).prop("selected", true);
			$("#maintable tbody").empty().html(data.resultData);
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
		}
	});
}

function pf_back(){
	location.href="/dyAdmin/func/attachments.do";
}

//엑셀 버튼
function pf_excel(url){
	$('#Form').attr('action',url);
	$('#Form').submit();
}

</script>
