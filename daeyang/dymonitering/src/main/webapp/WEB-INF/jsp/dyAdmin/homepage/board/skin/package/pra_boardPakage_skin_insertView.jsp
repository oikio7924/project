<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<%@ include file="/WEB-INF/jsp/dyAdmin/include/CodeMirror_Include.jsp" %>

<script type="text/javascript">

function pf_boardTemplatePackageAction(){
	var msg = '스킨 페키지를 생성하시겠습니까?'
	var action = $('#action').val();
	
	if(action == 'update') msg = '스킨 패키지를 수정하시겠습니까?';
	if(!pf_checkForm()) return false;

	if(confirm(msg)){
		cf_replaceTrim($("#Form"));
		$("#Form").attr("action", "/dyAdmin/homepage/board/skin/boardSkinPackage_Action.do");
		$("#Form").submit();
	}
}

function pf_checkForm(){
	if(!$("#BSP_TITLE").val()){
		alert("패키지 제목을 입력하세요.");
		$("#BSP_TITLE").focus();
		return false;
	}
	return true;
}

function pf_boardTemplatePackageDelete(){
	if(confirm("스킨 패키지를  삭제하시겠습니까?")){
		cf_replaceTrim($("#Form"));
		$('#action').val('delete');
		$("#Form").attr("action", "/dyAdmin/homepage/board/skin/boardSkinPackage_Action.do");
		$("#Form").submit();
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
						<h2>스킨 패키지  ${action eq 'insert' ? '등록' : '수정'}</h2>
					</header>

					<div class="widget-body">

						<form:form id="Form" class="form-horizontal" name="Form" method="post">
							<input type="hidden" name="BSP_REGNM" value="${userInfo.UI_ID }" />
							
							<input type="hidden" id="action" name="action" value="${action }" />
							
							<c:if test="${action eq 'update' }">
							<input type="hidden" name="BSP_KEYNO" value="${BSP.BSP_KEYNO }" />
							</c:if>
							<legend>
								<h2>스킨 패키지  ${action eq 'insert' ? '등록' : '수정'}하기 </h2>
							</legend>
							
							<fieldset>
								<div class="bs-example necessT">
									<span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
								</div>
								
								
								<div class="form-group has-feedback">
									<label class="col-md-1 control-label"><span class="nessSpan">*</span> 패키지 제목</label>
									<div class="col-md-3">
										<label class="input-group"> 
											<input type="text" class="form-control checkTrim" id="BSP_TITLE" name="BSP_TITLE" value="${BSP.BSP_TITLE }" maxlength="100">
											<span class="input-group-addon"><i class="fa fa-bold"></i></span>
										</label>
									</div>
								</div>
						
								
								<div class="form-group has-feedback">
				
									<label class="col-md-1 control-label">리스트</label>
									<div class="col-md-2">
										<select class="form-control input-sm" id="BSP_LIST_KEYNO" name="BSP_LIST_KEYNO">
							               		<option value="list" ${BSP.BSP_LIST_KEYNO eq 'list' ? 'selected' : '' }>리스트 기본 폼(기본)</option>
												<option value="no_detail" ${BSP.BSP_LIST_KEYNO eq 'no_detail' ? 'selected' : '' }>상세페이지 없는 폼(기본)</option>
												<option value="gallery" ${BSP.BSP_LIST_KEYNO eq 'gallery' ? 'selected' : '' }>갤러리 폼(기본)</option>
												<option value="calendar" ${BSP.BSP_LIST_KEYNO eq 'calendar' ? 'selected' : '' }>캘린더 폼(기본)</option>
							              		<c:forEach items="${FormList }" var="form_list" varStatus="status">
									              	<c:if test="${form_list.BST_TYPE eq 'list' }">
									              		<option value="${form_list.BST_KEYNO }"  ${BSP.BSP_LIST_KEYNO eq form_list.BST_KEYNO ? 'selected' : '' }>${form_list.BST_TITLE }</option>
									              	</c:if>
									              </c:forEach>
							            </select>
									</div>
									<label class="col-md-1 control-label">상세페이지</label>
									<div class="col-md-2">
										<select class="form-control input-sm" id="BSP_DETAIL_KEYNO" name="BSP_DETAIL_KEYNO">
												<option value="no" ${BSP.BSP_DETAIL_KEYNO eq 'no' ? 'selected' : '' }> 사용안함(기본)</option>
												<option value="normal" ${BSP.BSP_DETAIL_KEYNO eq 'normal' ? 'selected' : '' }>상세페이지 기본 폼(기본)</option>
								                <c:forEach items="${FormList }" var="form_detail" varStatus="status">
								              	<c:if test="${form_detail.BST_TYPE eq 'detail' }">
								              		<option value="${form_detail.BST_KEYNO }"  ${BSP.BSP_LIST_KEYNO eq form_detail.BST_KEYNO ? 'selected' : '' }>${form_detail.BST_TITLE }</option>
								              	</c:if>
								                </c:forEach>
							            </select>
									</div>
									<label class="col-md-1 control-label">등록 및 수정 페이지</label>
									<div class="col-md-2">
										<select class="form-control input-sm" id="BSP_INSERT_KEYNO" name="BSP_INSERT_KEYNO">
											<option value="normal" ${BSP.BSP_INSERT_KEYNO eq 'normal' ? 'selected' : '' }>등록 기본 폼(기본)</option>
							              <c:forEach items="${FormList }" var="form_insert" varStatus="status">
							              	<c:if test="${form_insert.BST_TYPE eq 'insert' }">
							              		<option value="${form_insert.BST_KEYNO}"  ${BSP.BSP_LIST_KEYNO eq form_insert.BST_KEYNO ? 'selected' : '' }>${form_insert.BST_TITLE }</option>
							              	</c:if>
							              </c:forEach>
							            </select>
									</div>
								</div>
								
								<div class="form-actions">
									<div class="row">
										<div class="col-md-12">
											<button class="btn btn-sm btn-primary" type="button" onclick="pf_boardTemplatePackageAction()">${action eq 'insert' ? '저장' : '수정'}</button>
											<c:if test="${action eq 'update' }">
												<button class="btn btn-sm btn-danger" type="button" onclick="pf_boardTemplatePackageDelete()">삭제</button>
											</c:if>
											<button class="btn btn-sm btn-default" id="Board_Delete" type="button" onclick="cf_back('/dyAdmin/homepage/board/skin/boardSkinPackage.do');">취소</button> 
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

