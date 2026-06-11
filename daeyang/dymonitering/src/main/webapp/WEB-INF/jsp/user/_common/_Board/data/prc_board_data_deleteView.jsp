<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<article id="container" class="container_sub clearfix">
	<div class="inner">
		<div class="conSub01_bottomBox">
			<div class="innerContainer clearfix">
				<form:form id="Form" name="Form" method="post" action="/${tiles}/Board/delete.do">
					<input type="hidden" name="BN_KEYNO" value="${BoardNotice.BN_KEYNO }">
					<input type="hidden" name="BN_MN_KEYNO" value="${BoardNotice.BN_MN_KEYNO }">
					<input type="hidden" name="BN_FM_KEYNO" id="BN_FM_KEYNO" value="${BoardNotice.BN_FM_KEYNO }">
					<input type="hidden" name="BN_THUMBNAIL" id="BN_THUMBNAIL" value="${BoardNotice.BN_THUMBNAIL }">
					<div class="boardUploadWrap">
					   	<div class="row lineheightBox">
					    	<p class="titleBox">
					        	<label>제목</label>
					        </p>
					        <p class="formBox">
					        	${BoardNotice.BN_TITLE }
					        </p>
					    </div>
					    <div class="row lineheightBox">
					    	<p class="titleBox">
					        	<label>게시판 타입</label>
					        </p>
					        <p class="formBox">
					        	${BoardType.BT_TYPE_NAME }
					        </p>
					    </div>
					    
						<div class="row">
							<p class="titleBox">
					        	<label for="BN_DEL_MEMO">삭제 사유</label>
					        </p>
							<div class="formBox">
								<div class="col-md-6">
									<textarea class="txtDefault width100Per" name="BN_DEL_MEMO" id="BN_DEL_MEMO" placeholder="삭제 사유를 입력하세요." rows="4" maxlength="1000">${BoardNotice.BN_DEL_MEMO }</textarea>
								</div>
							</div>
						</div>
					</div>
					
					<div class="btnBox textC">
						<button type="submit" class="btn btnBig_02" onclick="return pf_boardDelete()">삭제</button>
						<button type="button" class="btn btnBig_02" onclick="location.href='/${tiles}/Board/${BoardNotice.BN_KEYNO}/detailView.do'">취소</button>
					</div>
				</form:form>
			</div>
		</div>
	</div>
</article>

<script>

function pf_boardDelete(){
	
	if(!$('#BN_DEL_MEMO').val()){
		alert('삭제 사유를 입력하여주세요.');
		$('#BN_DEL_MEMO').focus();
		return false;
	}
	return true;
}

</script>