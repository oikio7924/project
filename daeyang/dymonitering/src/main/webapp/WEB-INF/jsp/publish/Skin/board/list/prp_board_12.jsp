<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<div class="board_wrap">
   <div class="top">
	   	<select name="BN_PLANT_NAME" id="BN_PLANT_NAME" onchange="selectBoardList(this.value);" style="float:right;height: 30px;width: 12%;text-align: center;margin-bottom: 6px;width: 21%;font-size: 13px;">
			<option value="">전체</option>
			<c:forEach items="${plantKey }" var="list">
				<option value="${list.DPP_KEYNO }" ${list.DPP_KEYNO eq BN_PLANT_NAME? 'selected':'' }>${list.DPP_NAME }</option>
			</c:forEach>
		</select>
		
       <p class="lb">총 게시물 <fmt:formatNumber value="${paginationInfo.totalRecordCount }" pattern="#,###" /> / ${paginationInfo.currentPageNo } 페이지</p>
   </div>
	
	
	
   <div class="board_tbl_box">
       <table class="tbl_board notice">
           <caption>공지사항</caption>
           <colgroup>
               <col style="width: 10%">
               <col style="width: 10%">
               <col style="width: 15%">
               <col style="width: 40%">
               <col style="width: 10%">
               <col style="width: 10%">
               <col style="width: 10%">
            </colgroup>
            <thead>
                <tr>
		          <th class="num"><span>번호</span></th>
		          <c:if test="${'Y'eq BoardType.BT_CATEGORY_YN }">
		      		  <th class = "category"><span>카테고리 구분</span></th>
		    	  </c:if> 
				  <th class="names"><span>발전소 명칭</span></th>
		          <c:forEach items="${BoardColumnList }" var="model">
				     <th class="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_TITLE') ? 'sbj txtL':'' }">
				       <span>${model.BL_COLUMN_NAME }</span>
				     </th>
				  </c:forEach>
		          <th class="name"><span>작성자</span></th>
		          <th class="date"><span>작성일</span></th>
		          <th class="count"><span>조회</span></th>
		        </tr>
            </thead>
            <tbody>
                <c:forEach items="${BoardNoticeDataList }" var="model" varStatus="status">
				    <c:choose>
				      <c:when test="${model.BN_DEL_YN eq 'Y' }">
				        <c:set var="detailFunction" value="alert('삭제된 게시물입니다.')"/>
				      </c:when>
				      <c:when test="${BoardType.BT_SECRET_YN eq 'Y' && model.BN_SECRET_YN eq 'Y'}">
				        <c:choose>
				          <c:when test="${userInfo.isAdmin eq 'Y' || model.BN_REGNM eq userInfo.UI_KEYNO  || model.WRITE_ID  eq userInfo.UI_KEYNO}">
				            <c:set var="detailFunction" value="pf_DetailMove('${model.BN_KEYNO }')"/>
				          </c:when>
				          <c:when test="${not empty model.BN_PWD }">
				            <c:set var="detailFunction" value="pf_openPWD('${model.BN_KEYNO}')"/>
				          </c:when>
				          <c:otherwise>
				            <c:set var="detailFunction" value="pf_NotMyContents()"/>
				          </c:otherwise>
				        </c:choose>								 
				      </c:when>
				      <c:otherwise>
				        <c:set var="detailFunction" value="pf_DetailMove('${model.BN_KEYNO }')"/>
				      </c:otherwise>
				    </c:choose>
				    
				    <tr class="${model.BOARD_TYPE eq 'NOTICE' ? 'boardNotice_Row':''}">
				      <td class="num">
				        <c:choose>
				          <c:when test="${model.BOARD_TYPE eq 'NOTICE'}">
				            	공지
				          <c:set var="noticeCount" value="${noticeCount + 1 }"/>
				          </c:when>
				          <c:otherwise>
				            ${model.NUM }
				          </c:otherwise>
				        </c:choose>
				      </td>
				      <c:if test="${'Y'eq BoardType.BT_CATEGORY_YN }">
				      	<td class = "category"><span>${model.BN_CATEGORY_NAME }</span></td>
				      </c:if> 
				      <td class="names"><c:out value="${model.DPP_NAME}"></c:out></td>
				      
				      <c:forEach items="${BoardColumnList }" var="column">
				      <c:set var="tempName">BD_DATA_${column.KEYNO}</c:set>
					      <c:choose>
					        <c:when test="${column.BL_TYPE eq  sp:getData('BOARD_COLUMN_TYPE_TITLE')}">
					      		<td class="sbj txtL">
					                <a href="javascript:;" onclick="${detailFunction}">
					          			<c:forEach begin="1" end="${model.BN_DEPTH }"></c:forEach>
				          				<c:if test="${BoardType.BT_SECRET_YN eq 'Y' && model.BN_SECRET_YN eq 'Y' }">
				            				<img src="/resources/img/icon/icon_lock.gif" alt="비밀글입니다.">
				          				</c:if>
				          				<c:if test="${model.BN_DEPTH gt 0 }">
				            				<span class="reply">답변</span>
				          				</c:if>
				          
				          				<c:if test="${model.BN_DEL_YN eq 'N' }">
				          					<c:out value="${model[tempName]}"/>
				          				</c:if>
				          				<c:if test="${model.BN_DEL_YN eq 'Y' }">
				          					<span style="color: #c8c8c8;font-size: 13px;">삭제된 게시물입니다.</span>
				          				</c:if>
				          				<c:if test="${BoardType.BT_COMMENT_YN eq 'Y' }">
				            				(${model.BN_BC_COUNT})
				          				</c:if>
				          				<c:if test="${model.BN_NEW eq '1' }">
				            				<img src="/resources/img/icon/icon_new.gif" alt="새글 이미지">
				          				</c:if>
				          				<c:if test="${model.BN_LINK gt 0 }">
				            				<img src="/resources/img/icon/icon_link.gif" alt="링크입니다.">
				          				</c:if>
				          				<c:if test="${BoardType.BT_UPLOAD_YN eq 'Y' && not empty model.BN_FM_KEYNO}">
				            				<img src="/resources/img/icon/icon_file.gif" alt="첨부파일 이미지">
				          				</c:if>
					        		</a>
					      		</td>	
					        </c:when>
					        <c:when test="${column.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_LINK')}">
					              <td><a href="${model[tempName] }" target="_blank"><c:out value="${model[tempName] }" escapeXml="true"/></a></td>
					        </c:when>
					        <c:otherwise>
					    		<td><c:out value="${model[tempName]}"/></td>					
					        </c:otherwise>
					      </c:choose>
				      </c:forEach>
				      <td class="name"><c:out value="${model.BN_UI_NAME}"></c:out></td>
				      <td class="date"><c:out value="${fn:substring(model.BN_REGDT,0,10) }"></c:out></td>
				      <td class="count"><c:out value="${model.BN_HITS}"></c:out></td>
				    </tr>
				 </c:forEach>
				 <c:if test="${paginationInfo.totalRecordCount eq 0}">
				    <tr>
				      <td class="tbl_board_nodata" colspan="6" style="color: #777; text-align: center;">내용없음</td>
				    </tr>
				    <script>
				    $(function(){
				      $('.tbl_board_nodata').attr('colspan',$('.tbl_board.notice th').length);
				    })
				    </script>
				 </c:if>
            </tbody>
        </table>
    </div>
</div>

<c:if test="${userInfo.isAdmin eq 'Y' || userInfo.UIA_NAME eq '안전관리자' || userInfo.UIA_NAME eq '유지관리자' || userInfo.UIA_NAME eq '경영관리자' }">
<div class="board_btn_b rb">
    <button type="button" class="btn_nor md2 g_line" id="btn_wr" onclick="pf_RegistMove()" title="글쓰기">글쓰기</button>
</div>
</c:if>

<div class="pagination">
	<ui:pagination paginationInfo="${paginationInfo }" type="normal" jsFunction="pf_LinkPage" />
</div>