<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<%@ include file="/WEB-INF/jsp/dyAdmin/include/CodeMirror_Include.jsp" %>

<script type="text/javascript">

var editor = null;
var action = '${action}';

$(function() {
 	editor = codeMirror("htmlmixed", "BST_FORM");
 	if(action == 'insert') pf_select_change('list'); 
 	pf_getFormData('${BST.BST_KEYNO}','${BST.BST_TYPE}');
});

function pf_boardTemplateAction(){
	var msg = '게시판 스킨을 생성하시겠습니까?'
	
	if(action == 'update') msg = '게시판 스킨을  수정하시겠습니까?';
	if(!pf_checkForm()) return false;

	if(confirm(msg)){
		cf_replaceTrim($("#Form"));
		$("#Form").attr("action", "/dyAdmin/homepage/board/skin/boardSkin_Action.do");
		$("#Form").submit();
	}
}

function pf_checkForm(){
	if(!$("#BST_TITLE").val()){
		cf_smallBox('form', "게시판 스킨 제목을 입력하세요.", 3000);
		$("#BST_TITLE").focus();
		return false;
	}
	return true;
}


function pf_boardTemplateDelete(){
	if(confirm("게시판 스킨을  삭제하시겠습니까?")){
		cf_replaceTrim($("#Form"));
		$('#action').val('delete');
		$("#Form").attr("action", "/dyAdmin/homepage/board/skin/boardSkin_Action.do");
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
	
function pf_select_change(obj){
	$('#BST_FORM_SELECT').find('.detail, .insert, .list').hide();
	$('#BST_FORM_SELECT option.'+obj).show();
	$("#BST_FORM_SELECT option:eq(0)").prop("selected", true);
}


function pf_form_change(){
	var value = $('#BST_FORM_SELECT option:selected').val();
	var type = $('#BST_FORM_SELECT option:selected').data('type');

	pf_getFormData(value,type);
	
}

function pf_getFormData(value,type){
	if(value && type){
		$.ajax({
	        type: "POST",
	        url: "/dyAdmin/homepage/board/skin/boardSkin/getSkinAjax.do",
	        async:false,
	        data : {
	        	"value":value,
	        	"type":type
	        },
	        success : function(data){
	        	editor.setValue(data);
	        },
	        error : function(){    
	        }
	   });
	}
}

</script>


<div id="content2">
	<section id="widget-grid">
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" id="" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-table"></i>
						</span>
						<h2>게시판 스킨  ${action eq 'insert' ? '등록' : '수정'}</h2>
					</header>

					<div class="widget-body">

						<form:form id="Form" class="form-horizontal" name="Form" method="post">
							<input type="hidden" name="BST_REGNM" value="${userInfo.UI_ID }" />
							<input type="hidden" name="BST_FORM_BEFORE" value="<c:out value='${BST.BST_FORM }'/>" />
							<input type="hidden" id="action" name="action" value="${action}" />
							
							<c:if test="${action eq 'update' }">
							<input type="hidden" name="BST_KEYNO" value="${BST.BST_KEYNO }" />
							</c:if>
							<legend>
								<h2>게시판 스킨  ${action eq 'insert' ? '등록' : '수정'}하기 </h2>
							</legend>
							
							<fieldset>
								<div class="bs-example necessT">
									<span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
								</div>
								
								
								<div class="form-group has-feedback">
									<label class="col-md-1 control-label"><span class="nessSpan">*</span> 게시판 스킨 제목</label>
									<div class="col-md-3">
										<label class="input-group"> 
											<input type="text" class="form-control checkTrim" id="BST_TITLE" name="BST_TITLE" value="${BST.BST_TITLE }" maxlength="100">
											<span class="input-group-addon"><i class="fa fa-bold"></i></span>
										</label>
									</div>
								</div>
						
								
								<div class="form-group has-feedback">
				
									<label class="col-md-1 control-label"></label>
									<div class="col-md-2">
										<select class="form-control input-sm" id="BST_TYPE" name="BST_TYPE" onchange="pf_select_change(this.value)" >
							              <option value="list" ${BST.BST_TYPE eq 'list' || empty BST.BST_TYPE  ? 'selected' : '' }>리스트</option>
							              <option value="detail" ${BST.BST_TYPE eq 'detail' ? 'selected' : '' }>상세페이지</option>
							              <option value="insert" ${BST.BST_TYPE eq 'insert' ? 'selected' : '' }>등록 및 수정</option>
							            </select>
									</div>
									<label class="col-md-2 control-label"></label>
									<div class="col-md-2">
										<select class="form-control input-sm" id="BST_FORM_SELECT" onchange="pf_form_change()">
							              <option value="">선택하세요.</option>
							              <option class="list" value="list" data-type="list">list 기본폼</option>
							              <option class="list" value="no_detail" data-type="list">no_detail 기본폼</option>
							              <option class="list" value="gallery" data-type="list">gallery 기본폼</option>
							              <option class="list" value="calendar" data-type="list">calendar 기본폼</option>
							              <option class="insert" value="normal" data-type="insert">normal 기본폼</option>
							              <option class="detail" value="no" data-type="detail">no 기본폼</option>
							              <option class="detail" value="normal" data-type="detail">normal 기본폼</option>
							              <c:forEach items="${FormList}" var="forms" varStatus="status">							              
							              	<option class="${forms.BST_TYPE}" value="${forms.BST_KEYNO}" data-type="${forms.BST_TYPE}" ${BST.BST_KEYNO eq forms.BST_KEYNO ? 'selected' : '' }>${forms.BST_TITLE }</option>
							              </c:forEach>
							            </select>
									</div>
									
								</div>
								
								<div class="form-group has-feedback">
									<label class="col-md-1 control-label">HTML 소스</label>
									<div class="col-md-6">
										<textarea name="BST_FORM" id="BST_FORM" rows="5" style="width:100%;height:400px;min-width:260px;"></textarea>
									</div>
								</div>
								
								<div class="form-actions">
									<div class="row">
										<div class="col-md-12">
											<button class="btn btn-sm btn-primary" type="button" onclick="pf_boardTemplateAction()">${action eq 'insert' ? '저장' : '수정'}</button>
											<c:if test="${action eq 'update' }">
												<button class="btn btn-sm btn-danger" type="button" onclick="pf_boardTemplateDelete()">삭제</button>
											</c:if>
											<button class="btn btn-sm btn-default" id="Board_Delete" type="button" onclick="cf_back('/dyAdmin/homepage/board/skin/boardSkin.do');">취소</button> 
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

