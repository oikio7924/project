<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>

<div id="content">
	<section id="widget-grid" >
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-green" id="" data-widget-editbutton="false">
					<div class="widget-body">
						<form:form id="Form" name="Form" method="post">
							<div class="widget-body-toolbar bg-color-white">
								<div class="alert alert-info no-margin fade in">
									<button type="button" class="close" data-dismiss="alert">×</button>
									 엔터 없앨때 사용
								</div>
							</div>
							<table id="" class="table table-bordered table-striped" style="clear: both">
								<colgroup>
									<col style="width: 20%;">
									<col style="width: 80%;">
								</colgroup>
								<tbody>
									<tr>
										<td>사용여부</td>
										<td>
										  <textarea rows="20" cols="100" name="contents" id="contents">${contents }</textarea>
										</td>
									</tr>
								</tbody>
							</table>
							
							<div class="form-actions">
								<div class="row">
									<div class="col-md-12">
				                     	<button class="btn btn-success" type="button" onclick="pf_submit()">
				                       	<i class=" fa fa-circle-thin"></i> 확인
				                     	</button>
									</div>
								</div>
							</div>
						</form:form>
					</div>
					
				</div>
			</article>
		</div>
	</section>
</div>

<script>

function pf_submit(){
// 	var content = $("#contents").val();
// 	content = content.replace(/</g,"");
// 	content = content.replace(/>/g,"");
// 	content = content.replace(/\"/g,"");
// 	content = content.replace(/\'/g,"");
// 	content = content.replace(/\n/g,"");
	$("#Form").attr("action", "/dyAdmin/pressure/check.do");
	$("#Form").submit();
}
</script>