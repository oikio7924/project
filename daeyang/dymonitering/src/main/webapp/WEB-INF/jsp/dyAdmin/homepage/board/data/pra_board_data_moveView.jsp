<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<div id="content">
	<section id="widget-grid" >
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" id="" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-lg fa-desktop"></i> </span>
						<h2>게시물 이동하기 </h2>
					</header> 
					<div class="jarviswidget-editbox"></div>
					
					<div class="widget-body">
						<form:form id="Form" class="form-horizontal" name="Form" method="post" action="/dyAdmin/homepage/board/moveView2.do">
							<input type="hidden" name="BN_KEYNO" value="${BoardNotice.BN_KEYNO }">
							<input type="hidden" name="BT_KEYNO" value="${BoardType.BT_KEYNO }">
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
										<label class="col-md-2 control-label">게시판 타입</label>
										<div class="col-md-6">
											<select name="MN_KEYNO" id="MN_KEYNO" class="form-control">
												<option value="">선택하세요</option>
												<c:forEach items="${boardList }" var="model">
													<c:if test="${model.MN_KEYNO ne BoardNotice.BN_MN_KEYNO }">
													<option value="${model.MN_KEYNO }">${model.MN_NAME }(${model.BT_TYPE_NAME })</option>
													</c:if>
												</c:forEach>
											</select>
											<p class="note">
												괄호() 안은 게시판 타입 이름<br>
												게시판 타입이 다를 경우 게시물 이동을 권장하지 않습니다.<br>
												제목, 본문, 첨부파일을 제외한 데이터는 사라질 위험이 있습니다.<br>
												그리고 게시판 디자인에 따라 제목, 본문, 첨부파일도 표시되지 않을 수 있습니다.
											</p>
										</div>
									</div>
								</div>
								<!-- 글쓴이이면 이동 사유 보이기 -->
								<c:if test="${userInfo.UI_KEYNO eq BoardNotice.BN_REGNM}">
								<div class="row">
									<div class="form-group has-feedback">
										<label class="col-md-2 control-label">이동 사유</label>
										<div class="col-md-6">
											<textarea class="form-control" name="BN_MOVE_MEMO" placeholder="이동 사유를 입력하세요." rows="4" maxlength="1000">${BoardNotice.BN_MOVE_MEMO }</textarea>
										</div>
									</div>
								</div>
								</c:if>
							</fieldset>
							<div class="form-actions">
								<div class="row">
									<div class="col-md-12">
										<button type="submit" class="btn btn-sm btn-primary" onclick="return pf_boardMove()">이동</button>
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

function pf_boardMove(){
	
	if(!$('#MN_KEYNO').val()){
		alert('이동할 게시판을 선택하여주세요.');
		$('#MN_KEYNO').focus();
		return false;
	}
	return true;
}
function pf_back(){
	$("#Form").attr("action", "/dyAdmin/homepage/board/data/detailView.do");
	$('#Form').submit();
}
</script>


