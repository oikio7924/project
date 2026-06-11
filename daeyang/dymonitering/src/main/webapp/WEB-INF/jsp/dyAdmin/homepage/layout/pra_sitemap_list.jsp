<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<%@ include file="/WEB-INF/jsp/dyAdmin/include/CodeMirror_Include.jsp"%>
<script type="text/javascript" src="/resources/common/js/common/diff_match_patch.js"></script>
<style>
.customTitle{
    border: none;
    cursor: pointer;
    display: inline;
    float: left;
    height: 27px;
}
.closeBtn{float: right;}
.form-control[disabled], .form-control[readonly], fieldset[disabled] .form-control{background-color: inherit;}
</style>

<section id="widget-grid" class="">

	<div class="row">

		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">

			<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>사이트맵 설정</h2>
				</header>
				<div>
					<div class="jarviswidget-editbox"></div>
					<div class="widget-body">
						<div class="widget-body-toolbar bg-color-white">
							<div class="alert alert-info no-margin fade in">
								<button type="button" class="close" data-dismiss="alert">×</button>
								홈페이지를 선택하면 해당하는 홈페이지의 메뉴 사이트맵을 생성하거나 수정하실 수 있습니다. <br>
								<span class="nessSpan">* 사이트맵 태그 밖에서 작성한 내용은 입력되지 않습니다.</span> 
							</div>
						</div> 

						<form:form id="Form" method="post" action="/dyAdmin/homepage/layout/sitemap.do">
							<input type="hidden" id="MN_HOMEDIV_C" name="MN_HOMEDIV_C" value="${MN_HOMEDIV_C }" />
							<input type="hidden" id="RM_MN_HOMEDIV_C" name="RM_MN_HOMEDIV_C" value="${MN_HOMEDIV_C }" />							
							<input type="hidden" name="DISTRIBUTE_TYPE" id="DISTRIBUTE_TYPE" value="false">
							<input type="hidden" name="actionType" id="actionType" value="${actionType}">
							<input type="hidden" name="homeName" id="homeName" value="">							
							
							<div id="myTabContent1" class="tab-content padding-10 form-horizontal bv-form">
								<div id="resourcesForm">
									<table class="table table-bordered table-striped">
										<colgroup>
											<col style="width: 20%;">
											<col style="width: 30%;">
											<col style="width: 20%;">
											<col style="width: 30%;">
										</colgroup>
										<tbody>										
											<tr>
												<td>파일명</td>
												<td colspan="3">
												<input type="text" class="form-control" name="RM_FILE_NAME" id="RM_FILE_NAME" maxlength="50" onkeyup="fn_press_han(this);" value="${fileName}" readonly="readonly">
												</td>
											</tr>											
											<c:if test="${actionType eq 'update'}">
											<tr>
												<td colspan="4"><span class="nessSpan">* </span>내용</td>
											</tr>										
											<tr>
												<td colspan="4">
													<textarea class="form-control ckWebEditor" name="RM_DATA" id="RM_DATA"  style="width:100%;height:500px;min-width:260px;" data-bv-field="content"></textarea>
												</td>
											</tr>						
											</c:if>	
											<c:if test="${actionType eq 'insert'}">
												<input type="hidden" name="RM_DATA" id="RM_DATA">											
											</c:if>
											<tr>
												<td colspan="4">
													<fieldset class="padding-10 text-right"> 										
														<button class="btn btn-sm btn-success" type="button" onclick="pf_Distribute()">
															<i class="fa fa-plus"></i> ${actionType eq 'insert' ? '생성' : '재생성'}
														</button>			
														<c:if test="${actionType eq 'update'}">										
														<button class="btn btn-sm btn-danger" type="button" onclick="pf_fileDelete()">
                                                            <i class="fa fa-floppy-o"></i> 삭제
                                                        </button>
                                                        </c:if>
													</fieldset>
												</td>
											</tr>
										</tbody>
									</table>
								</div>	
							</div>
						</div>
						</form:form>						
					</div>
				</div>
			</div>
		</article>
	</div>
</section>

<div id="form_data" style="display: none;">
	<ul>
		<li id="form_li_data">&lt;&#63;xml version="1.0" encoding="UTF-8"&#63;&gt;
&lt;urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"&gt;<c:forEach items="${MenuInfoList }" var="model"> 
	&lt;url&gt;
		&lt;loc&gt;${model.loc }&lt;/loc&gt;			
		&lt;lastmon&gt;${model.lastmon }&lt;/lastmon&gt;							
		&lt;changefreq&gt;${model.changefreq }&lt;/changefreq&gt;	
		&lt;priority&gt;${model.priority }&lt;/priority&gt;	
	&lt;/url&gt;</c:forEach>
&lt;/urlset&gt;
		</li>
	</ul>
</div>


<%@ include file="/WEB-INF/jsp/dyAdmin/include/_layout/pra_common_script.jsp"%>
<script type="text/javascript">
var editor = null;
var actionType = "${actionType}";

$(function(){
				
	pf_setHomeName();
	
 	if(actionType == 'update'){
		editor = codeMirror('htmlmixed','RM_DATA');
 		pf_form_change();
	}
});


//배포
function pf_Distribute(){ 
	
	var temp = $("#form_data ul").children("li");
	var form_data = $(temp[0]).text();
	
	// 초기값(파일이 없을떄) 설정
 	if(actionType == 'insert'){
		$("#RM_DATA").val(form_data); 
 	}
 		
	var url = '/dyAdmin/homepage/common/sitemap/distributeAjax.do'
	cf_smallBoxConfirm('Ding Dong!', '배포 하시겠습니까?','pf_submit(\''+url+'\')');
} 

function pf_submit(url){
	cf_loading();
	setTimeout(function(){
		$('#Form').attr('action',url);
		$('#Form').submit();
	},100)
}

// xml 데이터 호출
function pf_form_change() {
	var temp = $("#form_data ul").children("li");
	var form_data = $(temp[0]).text();

	editor.setValue(form_data);
}

// 파일 삭제

function pf_fileDelete() {
	var url = '/dyAdmin/homepage/common/sitemap/fileDelete.do'
	cf_smallBoxConfirm('Ding Dong!', '삭제 하시겠습니까?','pf_submit(\''+url+'\')');
	
}


</script>