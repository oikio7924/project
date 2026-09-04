<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<div class="detailViewReplyBox">
<c:forEach items="${BoardCommentList }" var="bcl" varStatus="c">
<fmt:parseNumber value="${fn:substring(bcl.BC_KEYNO, 4, 20)}" var="BC_KEYNO_NUMBERTYPE" />
<fmt:parseNumber value="${fn:substring(bcl.BC_ROOTKEY, 4, 20)}" var="BC_ROOTKEY_NUMBERTYPE" />
	<ul class="${bcl.BC_KEYNO eq bcl.BC_MAINKEY ? 'detailReply':'detailReplyReply' }">
    	<!-- <li class="img"><div class="imgBox"></div></li> -->
        <li class="content">
        	<p class="title">${bcl.UI_NAME }</p>
        	<c:if test="${bcl.BC_DEL_YN eq 'N' }">
            <pre class="contents"><c:if test="${not empty bcl.UI_MAIN_NAME }"><span class="mainName">${bcl.UI_MAIN_NAME}</span></c:if> <c:out value="${bcl.BC_CONTENTS }" escapeXml="true"/></pre>
        	</c:if>
        	<c:if test="${bcl.BC_DEL_YN eq 'Y' }">
        	<p class="contents" style="color:gray;">삭제된 댓글입니다.</p>
        	</c:if>
            <p class="date">
            	${fn:substring(bcl.BC_REGDT,0,19) }
            </p>
            <div class="btnBox clearfix">
	             	<p class="leftBox">
	                     <button type="button" class="btn btn-default btnSmall_02 bgWhiteLine fs12 pdR10" onclick="pf_commentReply('${c.count }');">답글달기</button> 
		            	 <button type="button" class="btn btn-default btnSmall_02 bgWhiteLine fs12 pdR10" onclick="pf_likeUP('${BC_KEYNO_NUMBERTYPE }')">
		            		<img src="/resources/img/icon/icon_reply_like_01.png" alt="좋아요"> ${bcl.BC_UP_CNT }
		            	 </button> 
		            	 <button type="button" class="btn btn-default btnSmall_02 bgWhiteLine fs12 pdR10" onclick="pf_likeDown('${BC_KEYNO_NUMBERTYPE }')">
		            		<img src="/resources/img/icon/icon_reply_dilike_01.png" alt="싫어요"> ${bcl.BC_DOWN_CNT }
		            	 </button>
	                 </p>
	                 <c:if test="${bcl.BC_REGNM eq userInfo.UI_KEYNO && bcl.BC_DEL_YN eq 'N' }">
	                 <p class="rightBox">
	                     <button type="button" onclick="pf_commentModify('${c.count }');" class="btn btn-default btnSmall_02 fs12 bgWhiteLine ">수정</button> 
	                     <button type="button" onclick="pf_commentDelete('${BC_KEYNO_NUMBERTYPE }');" class="btn btn-default btnSmall_02 fs12 bgWhiteLine ">삭제</button>
	                 </p>
	                 </c:if>
	         </div>
        </li>
    </ul>
    <div  id="commentModify_${c.count }" class="commentModify detailViewReplyModifyBox clearfix" style="display: none">
    	<div class="writeBox">
			<textarea name="BC_CONTENTS_Modify" id="BC_CONTENTS_Modify_${c.count }" class="commentTextarea" rows="2"  onkeyup="javascript:cf_TextAreaInputLimit('BC_CONTENTS_Modify_${c.count }',500);" maxlength="1000">${bcl.BC_CONTENTS }</textarea>
		</div>
		<div class="btn rightF">
			<span style="display: inline-block;line-height: 25px;margin: 0;">(<span id="BC_CONTENTS_Modify_${c.count }_length">0</span>/500)</span>
			<button class="btn btnSmall_02 bgColorG_999" type="button" onclick="pf_commentUpdate('${BC_KEYNO_NUMBERTYPE }','${c.count }')">수정</button>
			<button class="btn btnSmall_02 bgColorG_999" type="button" onclick="pf_commentModifyCandle('${c.count }')">취소</button>
		</div>
	</div>
	<div  id="commentReply_${c.count }" class="commentModify detailViewReplyModifyBox clearfix" style="display: none">
    	<div class="writeBox">
			<textarea name="BC_CONTENTS_Modify" id="BC_CONTENTS_reply_${c.count }" class="commentTextarea" rows="2" onkeyup="javascript:cf_TextAreaInputLimit('BC_CONTENTS_reply_${c.count }',500);" maxlength="1000"></textarea>
		</div>
		<div class="btn rightF">
			<span style="display: inline-block;line-height: 25px;margin: 0;">(<span id="BC_CONTENTS_reply_${c.count }_length">0</span>/500)</span>
			<button class="btn btn-default btnSmall_02 bgColorG_999" type="button" onclick="pf_commentReplyWrite('${BC_KEYNO_NUMBERTYPE }','${BC_ROOTKEY_NUMBERTYPE}','${c.count }')">저장</button>
			<button class="btn btn-default btnSmall_02 bgColorG_999" type="button" onclick="pf_commentReplyCandle('${c.count }')">취소</button>
		</div>
	</div>
</c:forEach>
</div>

<script>
$(function(){
	var isEnd = '${paginationInfo.totalPageCount eq paginationInfo.currentPageNo}';
	if(isEnd == 'true'){
		$('.moreComment').hide();		
	}else{
		$('#replyPageIndex').val('${paginationInfo.currentPageNo + 1}')	
	}
})
</script>										
							