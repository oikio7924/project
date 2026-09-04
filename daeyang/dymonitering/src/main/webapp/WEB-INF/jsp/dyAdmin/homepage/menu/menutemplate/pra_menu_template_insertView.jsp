<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<%@ include file="/WEB-INF/jsp/dyAdmin/include/CodeMirror_Include.jsp" %>
<style>
.columnTitle {
	text-align: center;
	word-break: keep-all;
	border-top: 1px solid #ddd;
	border-bottom: 1px solid #ccc;
	padding: 5px 0
}

.columnTitle section {
	margin-bottom: 0
}

.option_dp, .selectCodeWrap, .column_size_dp {
	display: none;
}

.column_ul .column_li label{
	width: 20%;
}

.column_ul .column_li input{
	padding-left:10px;
	width: 50%;
}

.column_ul .column_li div{
	margin-left: 20px;
}

</style>

<script type="text/javascript">

var editor = null;
var type = '${type}';


$(function() {
	editor = codeMirror("htmlmixed", "SMT_FORM");
	if(type == 'insert') pf_getSkinFormData("basic","menuTemplate");
});

function pf_form_change(value){
	pf_getSkinFormData(value,"menuTemplate");
}


function pf_menuTemplateInsert(){
	if(!pf_checkForm()){
		return false;
	}

	if(confirm("메뉴 스킨을 생성하시겠습니까?")){
		cf_replaceTrim($("#Form"));
		$("#action").val('insert');
		$("#Form").attr("action", "/dyAdmin/homepage/menumanage/template/action.do");
		$("#Form").submit();
	}
	
}

function pf_checkForm(){
	if(!$("#SMT_SUBJECT").val()){
		alert("메뉴 스킨 제목을 입력하세요.");
		$("#SMT_SUBJECT").focus();
		return false;
	}
	return true;
}

function pf_menuTemplateUpdate(){
	if(!pf_checkForm()){
		return false;
	}
	if(confirm("메뉴 스킨을  수정하시겠습니까?")){
		cf_replaceTrim($("#Form"));
		$("#action").val('update');
		$("#Form").attr("action", "/dyAdmin/homepage/menumanage/template/action.do");
		$("#Form").submit();
	}
	
}

function pf_menuTemplateDelete(){
	if(confirm("메뉴 스킨을  삭제하시겠습니까?")){
		cf_replaceTrim($("#Form"));
		$("#Form").attr("action", "/dyAdmin/homepage/menumanage/template/delete.do");
		$("#Form").submit();
	}
}

function pf_Copy(content){
	if(cf_copyToClipboard(content)){
		cf_smallBox('success', "값이 복사되었습니다.", 2000);
	}else{
		cf_smallBox('error', "복사하기 기능을 지원하지 않는 브라우저 입니다.", 3000,'#d24158');
	}
}

</script>

<div id="content">

	<section id="widget-grid">
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" id="" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-table"></i>
						</span>
						<c:if test="${type eq 'insert' }">
						<h2>메뉴 헤더템플렛  등록</h2>
						</c:if>
						<c:if test="${type eq 'update' }">
						<h2>메뉴 헤더템플렛  수정</h2>
						</c:if>
					</header>

					<div class="widget-body">

						<form:form id="Form" class="form-horizontal" name="Form" method="post">
							<input type="hidden" name="SMT_REGNM" value="${userInfo.UI_ID }" />
							<input type="hidden" id="action" name="action" value="" />
							
							<c:if test="${type eq 'update' }">
							<input type="hidden" name="SMT_KEYNO" value="${SMT_DATA.SMT_KEYNO }" />
							</c:if>
							<legend>
								<c:if test="${type eq 'insert' }">
								<h2>메뉴 스킨 등록하기 </h2>
								</c:if>
								<c:if test="${type eq 'update' }">
								<h2>메뉴 스킨 수정하기 </h2>
								</c:if>
							</legend>
							
							<fieldset>
								<div class="bs-example necessT">
									<span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
								</div>
								
								
							
								
								<div class="form-group has-feedback">
									<label class="col-md-1 control-label"><span class="nessSpan">*</span> 메뉴 스킨 제목</label>
									<div class="col-md-3">
										<label class="input-group"> 
											<input type="text" class="form-control checkTrim" id="SMT_SUBJECT" name="SMT_SUBJECT" value="${SMT_DATA.SMT_SUBJECT }" maxlength="100">
											<span class="input-group-addon"><i class="fa fa-bold"></i></span>
										</label>
									</div>
								</div>
								
						
								
								<div class="form-group has-feedback">
				
									<label class="col-md-5 control-label"></label>
									<div class="col-md-2">
										<select class="form-control input-sm" id="SMT_FORM_SELECT" onchange="pf_form_change(this.value);">
							              <option value="basic">기본폼</option>
							              <c:forEach items="${formDataList }" var="model3" varStatus="status">
							              <option value="${model3.SMT_KEYNO}" ${SMT_DATA.SMT_KEYNO eq model3.SMT_KEYNO ? 'selected' : '' }>${model3.SMT_SUBJECT }</option>
							              </c:forEach>
							            </select>
									</div>
									
								</div>
								
								<div class="form-group has-feedback">
									
											
									<label class="col-md-1 control-label">HTML 소스</label>
									<div class="col-md-6">
										<textarea name="SMT_FORM" id="SMT_FORM" rows="5" style="width:100%;height:400px;min-width:260px;">${SMT_DATA.SMT_FORM}</textarea>
										
									</div>
								</div>
								
								<div class="form-actions">
									<div class="row">
										<div class="col-md-12">
											<c:if test="${type eq 'insert' }">
												<button class="btn btn-sm btn-primary" type="button" onclick="pf_menuTemplateInsert()">저장</button>
											</c:if>
											<c:if test="${type eq 'update' }">
												<button class="btn btn-sm btn-primary" type="button" onclick="pf_menuTemplateUpdate()">수정</button>
												<button class="btn btn-sm btn-danger" type="button" onclick="pf_menuTemplateDelete()">삭제</button>
											</c:if>
											<button class="btn btn-sm btn-default" id="Board_Delete" type="button" onclick="cf_back('/dyAdmin/homepage/menumanage/template.do');">취소</button> 
										</div>
									</div>
								</div>
							</fieldset>
						</form:form>
					</div>
				</div>
			</article>
		</div>
	</section>
</div>

