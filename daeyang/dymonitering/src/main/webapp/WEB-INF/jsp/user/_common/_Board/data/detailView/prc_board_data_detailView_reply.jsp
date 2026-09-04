<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>
.best{color: red;}
.likeSelect{color: rgb(195, 9, 9); border: 1px solid;}
.bestColor{background: #ff626259;}
</style>

<%@ include file="/WEB-INF/jsp/user/_common/_Script/board/script_detailView_reply.jsp"%>
<input type="hidden" name="replyPageIndex" id="replyPageIndex" value="${not empty newCommentIndex ? newCommentIndex : '1'}">
<div class="detailViewReplyWriteBox">
	<span class=" block mgB10">댓글입력(500Byte 제한)
		<span class="right">(<span id="BC_CONTENTS_length">0</span>/500)</span>
	</span>
    <div class="writeBox">
    	<textarea title="댓글을 입력해주세요" name="BC_CONTENTS" id="BC_CONTENTS" class="commentTextarea"  onkeyup="javascript:cf_TextAreaInputLimit('BC_CONTENTS',500);" maxlength="1000"></textarea>
    </div>
   <c:if test="${BoardType.BT_SECRET_COMMENT_YN eq 'Y'}">
    <div class="writeBox">
        <label class="col col-xs-6 col-sm-6 col-md-6 col-lg-6 control-label">비밀글 사용</label>
           <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 inline-group">
               <label class="col"> 
               	<span class="input-group-addon">
                       <span class="onoffswitch">
                        <input type="checkbox" name="BC_SECRET_YN" value="Y" class="onoffswitch-checkbox" id="BC_SECRET_YN">
                        </span>
               	</span>
                   </label>
           </div>
       </div>
    </c:if>
    
</div>
<div class="detailViewBtnBox">
	<button type="button" class="btn btnBig_01 btn-default" onclick="pf_commentInsert()">댓글달기</button>
</div>

<div class="realComment"></div> 

<div class="detailViewBtnBox reflashDiv">
	<button type="button" class="btn btnBig_01 btn-default reflash" onclick="pf_getNextReplyList();">새 댓글<span class="reflashNum"></span></button>
</div>
 <script>	
function pf_LinkPage(num) {
	$('#replyPageIndex').val(num);
	pf_getNextReplyList('page');
}
</script>
							