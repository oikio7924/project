<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<div id="content">
	<section id="widget-grid" >
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" id="" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-lg fa-desktop"></i> </span>
						<h2>게시물 삭제하기 </h2>
					</header> 
					<div class="jarviswidget-editbox"></div>
					
					<div class="widget-body">
						<form:form id="Form" class="form-horizontal" name="Form" method="post" action="/dyAdmin/homepage/board/data/state.do">
					<input type="hidden" name="BN_KEYNO" value="${BoardNotice.BN_KEYNO }">
					<input type="hidden" name="BN_MN_KEYNO" value="${BoardNotice.BN_MN_KEYNO }">
					<input type="hidden" name="BN_FM_KEYNO" id="BN_FM_KEYNO" value="${BoardNotice.BN_FM_KEYNO }">
					<input type="hidden" name="BN_THUMBNAIL" id="BN_THUMBNAIL" value="${BoardNotice.BN_THUMBNAIL }">
					<input type="hidden" name="BN_DEL_YN" value="Y">
							<fieldset>
								<div class="row">
									<div class="form-group has-feedback">
										<label class="col-md-2 control-label">제목</label>
										<div class="col-md-6" style="padding-top:7px;">
											${BoardNotice.BN_TITLE }
										</div>
									</div>
								</div>
								<div class="row">
									<div class="form-group has-feedback">
										<label class="col-md-2 control-label">게시판 타입</label>
										<div class="col-md-6" style="padding-top:7px;">
											${BoardType.BT_TYPE_NAME }
										</div>
									</div>
								</div>

								<div class="row">
									<div class="form-group has-feedback">
										<label class="col-md-2 control-label">삭제 사유</label>
										<div class="col-md-6">
											<textarea class="form-control" id="BN_DEL_MEMO" name="BN_DEL_MEMO" placeholder="삭제 사유를 입력하세요." rows="4" maxlength="1000">${BoardNotice.BN_DEL_MEMO }</textarea>
										</div>
									</div>
								</div>

							</fieldset>
							<div class="form-actions">
								<div class="row">
									<div class="col-md-12">
										<button type="submit" class="btn btn-sm btn-primary" onclick="return pf_boardDelete()">삭제</button>
										<button type="button" class="btn btn-sm btn-default" onclick="pf_back()">취소</button>
									</div>
								</div>
							</div>
							<div class="btnBox textC">
								
							</div>
						</form:form>
					</div>
				</div>
			</article>
		</div>
	</section>
</div>
<script>

function pf_boardDelete(){
	
	if(!$('#BN_DEL_MEMO').val()){
		alert('삭제 사유를 입력하여주세요.');
		$('#BN_DEL_MEMO').focus();
		return false;
	}
	return true;
}
function pf_back(){
	$("#Form").attr("action", "/dyAdmin/homepage/board/data/detailView.do");
	$('#Form').submit();
}
</script>


