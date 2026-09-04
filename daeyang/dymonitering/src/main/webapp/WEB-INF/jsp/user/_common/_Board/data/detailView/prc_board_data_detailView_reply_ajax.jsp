<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<div class="detailViewReplyBox">
<c:forEach items="${BoardCommentList }" var="bcl" varStatus="c">
	<ul class="${bcl.BC_KEYNO eq bcl.BC_MAINKEY ? 'detailReply':'detailReplyReply' } ${bcl.COMMENTTYPE eq 'BEST'  ? 'bestColor' : ''}">
        <li class="content">
        	<p class="title"><span class="best">${bcl.BESTUP}</span> ${bcl.UI_NAME }</p>
       	<c:if test="${BT_SECRET_COMMENT_YN eq 'N'}">
        	<c:if test="${bcl.BC_DEL_YN eq 'N' }">
            <pre class="contents"><c:if test="${not empty bcl.UI_MAIN_NAME }"><span class="mainName">${bcl.UI_MAIN_NAME}</span></c:if> <c:out value="${bcl.BC_CONTENTS }" escapeXml="true"/></pre>
        	</c:if>
        </c:if>	
        
        <c:if test="${BT_SECRET_COMMENT_YN eq 'Y'}">
        
  
          <c:if test="${bcl.BC_SECRET_YN eq 'Y' }">
              <c:if test="${bcl.BC_REGNM eq userInfo.UI_KEYNO || isAdmin eq 'Y' }">
                  <c:out value="${bcl.BC_CONTENTS }"  />
              </c:if>
            
      
              <c:if test="${bcl.BC_REGNM ne userInfo.UI_KEYNO && isAdmin ne 'Y'}">
                  <span style="color: red">
           				<img src="/resources/img/icon/icon_lock.gif" alt="비밀글 아이콘" style="margin-top: 6px;">
   							작성자와 관리자에게만 보이는 댓글입니다.</span>
              </c:if>
              
          </c:if>
          <c:if test="${bcl.BC_SECRET_YN eq 'N' }">
              <c:out value="${bcl.BC_CONTENTS }"  />
          </c:if>
      </c:if> 
        	<c:if test="${bcl.BC_DEL_YN eq 'Y' }">
        	<p class="contents" style="color:gray;">삭제된 댓글입니다.</p>
        	</c:if>
            <p class="date">
            	${fn:substring(bcl.BC_REGDT,0,19) }
            </p>
            <div class="btnBox clearfix">
	             	<p class="leftBox">
	             		 <c:if test="${bcl.COMMENTTYPE eq 'COMMON' }">
	                     <button type="button" class="btn btn-default btnSmall_02 bgWhiteLine fs12 pdR10" onclick="pf_commentReply('${c.count }');">답글달기</button> 
	             		 </c:if>
		            	 <button type="button" class="btn btn-default btnSmall_02 bgWhiteLine fs12 pdR10 ${bcl.SELETED eq 'SELETED' && bcl.BCS_TYPE eq 'Y' ? 'likeSelect' : '' }" onclick="pf_likeUpDown(this, '${bcl.BC_KEYNO }', 'Y')">
		            		<img src="/resources/img/icon/icon_reply_like_01.png" alt="좋아요"> <span class="likeCnt">${bcl.UP_CNT }</span>
		            	 </button> 
		            	 <button type="button" class="btn btn-default btnSmall_02 bgWhiteLine fs12 pdR10 ${bcl.SELETED eq 'SELETED' && bcl.BCS_TYPE eq 'N' ? 'likeSelect' : '' }" onclick="pf_likeUpDown(this, '${bcl.BC_KEYNO }', 'N')">
		            		<img src="/resources/img/icon/icon_reply_dilike_01.png" alt="싫어요"> <span class="likeCnt">${bcl.DOWN_CNT }</span>
		            	 </button>
	                 </p>
	                 <c:if test="${bcl.BC_REGNM eq userInfo.UI_KEYNO && bcl.BC_DEL_YN eq 'N' && bcl.COMMENTTYPE eq 'COMMON'}">
	                 <p class="rightBox">
	                     <button type="button" onclick="pf_commentModify('${c.count }');" class="btn btn-default btnSmall_02 fs12 bgWhiteLine ">수정</button> 
	                     <button type="button" onclick="pf_commentDelete('${bcl.BC_KEYNO }');" class="btn btn-default btnSmall_02 fs12 bgWhiteLine">삭제</button>
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
		     <c:if test="${BT_SECRET_COMMENT_YN eq 'Y'}">
            <input type="checkbox" name ="BC_SECRET_YN_Modify_${c.count }" id="BC_SECRET_YN_Modify_${c.count }" value="${bcl.BC_SECRET_YN }" > 비밀글 사용
            </c:if>
		
			<span style="display: inline-block;line-height: 25px;margin: 0;">(<span id="BC_CONTENTS_Modify_${c.count }_length">0</span>/500)</span>
			<button class="btn btnSmall_02 bgColorG_999" type="button" onclick="pf_commentUpdate('${bcl.BC_KEYNO }','${c.count }')">수정</button>
			<button class="btn btnSmall_02 bgColorG_999" type="button" onclick="pf_commentModifyCandle('${c.count }')">취소</button>
		</div>
	</div>
	<div  id="commentReply_${c.count }" class="commentModify detailViewReplyModifyBox clearfix" style="display: none">
    	<div class="writeBox">
			<textarea name="BC_CONTENTS_Modify" id="BC_CONTENTS_reply_${c.count }" class="commentTextarea" rows="2" onkeyup="javascript:cf_TextAreaInputLimit('BC_CONTENTS_reply_${c.count }',500);" maxlength="1000"></textarea>
		</div>
		<div class="btn rightF">
			 <c:if test="${BT_SECRET_COMMENT_YN eq 'Y'}">
            	<input type="checkbox" name ="BC_SECRET_YN_reply_${c.count }" id="BC_SECRET_YN_reply_${c.count }" value="N"> 비밀글 사용
            </c:if>
			
			<span style="display: inline-block;line-height: 25px;margin: 0;">(<span id="BC_CONTENTS_reply_${c.count }_length">0</span>/500)</span>
			<button class="btn btn-default btnSmall_02 bgColorG_999" type="button" onclick="pf_commentReplyWrite('${bcl.BC_KEYNO }','${bcl.BC_ROOTKEY}','${c.count }')">저장</button>
			<button class="btn btn-default btnSmall_02 bgColorG_999" type="button" onclick="pf_commentReplyCandle('${c.count }')">취소</button>
		</div>
	</div>
</c:forEach>
</div>

<div class="pageNumberBox">
	<ul class="pageNumberUl">
		<ui:pagination paginationInfo="${paginationInfo }" type="normal_board" jsFunction="pf_LinkPage" />
    </ul>
</div>

<script>
$(function(){
	$('.reflashDiv').hide();
	totalReply = '${paginationInfo.totalRecordCount}';
// 	isReplyPagingEnd = '${paginationInfo.totalPageCount eq paginationInfo.currentPageNo}';
})
</script>										
							