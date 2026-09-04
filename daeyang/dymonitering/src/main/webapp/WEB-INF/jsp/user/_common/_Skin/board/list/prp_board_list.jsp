<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>
/* 페이지 넘버 */
.pageNumberBox {
		text-align:center;
		background:#fff;
		border:none;
		width:auto;
		padding-bottom: 13px; 
		font-size: 13px; 
		position: relative;
	    font-weight: 700;
	    font-style: italic;
	    color: #969696;
}
.pageNumberUl {display:inline-block; margin: 0;}
.pageNumberUl:after { visibility: hidden; display:block;font-size: 0;content:".";clear: both;height: 0;*zoom:1;}
.pageNumberUl li { float:left; margin:0 2px; padding:3px; border:1px solid #e5e6e5; vertical-align:middle;min-width:30px;}
.pageNumberUl li a { font-size:13px; color:#58595b; display:inline-block; width:100%; height:100%; padding:2px 5px 3px; text-align:center;}
.pageNumberUl li.active {background-color:#58595b;}
.pageNumberUl li.active a {color:#fff;}
.pagetext{font-size: 15px;}
#textAlign th {cursor:pointer;}
@media all and (max-width:850px){	
	.pageNumberUl {margin-top:10px;}
}
/* @media all and (min-width:800px){	
	.smart-form .inline-group .checkbox, .smart-form .inline-group .radio {margin-right:10px;}
	.smart-form .checkbox, .smart-form .radio {padding-left:5px;}
} */


.tblBoardBox {overflow-x: scroll;}
.tblBoardBox th {min-width:200px;}
.tblBoardBox td.boardSubject {min-width:350px;}

</style>
<p class="board_count">총 게시물<span class="colorR"><fmt:formatNumber value="${paginationInfo.totalRecordCount }" pattern="#,###" /> 건</span> ${paginationInfo.currentPageNo } 페이지</p>    

<div class="tblBoardBox">
	<table class="tbl_Board_01 tbl_Board_notice">
        <caption></caption>
        <thead>
        	<tr>
            	<th class="number"><span>번호</span></th>
            	 <c:if test="${'Y'eq BoardType.BT_CATEGORY_YN }">
					<th class = "category"><span>카테고리 구분</span></th>
				</c:if> 
            	<c:forEach items="${BoardColumnList }" var="model">
					<th class="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_TITLE') ? 'boardSubject':'' }">
						<span>${model.BL_COLUMN_NAME }</span>
					</th>
				</c:forEach>
				
            	<th class="name"><span>작성자</span></th>
            	<th class="date"><span>작성일</span></th>
            	<th class="count"><span>조회</span></th>
            </tr>
        </thead>
        <tbody>
        	<c:set var="noticeCount" value="0"/>
			<c:forEach items="${BoardNoticeDataList }" var="model" varStatus="status">
				<c:choose>
					<c:when test="${model.BN_DEL_YN eq 'Y' }">
						<c:set var="detailFunction" value="alert('삭제된 게시물입니다.')"/>
					</c:when>
					<c:when test="${BoardType.BT_SECRET_YN eq 'Y' && model.BN_SECRET_YN eq 'Y'}">
						<c:choose>
							<c:when test="${userInfo.isAdmin eq 'Y' || model.BN_REGNM eq userInfo.UI_KEYNO  || model.WRITE_ID eq userInfo.UI_KEYNO and not empty userInfo.UI_KEYNO}">
								<c:set var="detailFunction" value="pf_DetailMove('${model.BN_KEYNO }')"/>
							</c:when>
							<c:when test="${not empty model.BN_PWD}">
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
					<td class="number">
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
					<c:forEach items="${BoardColumnList }" var="column">
					<c:set var="tempName">BD_DATA_${column.KEYNO}</c:set>
					<c:choose>
						<c:when test="${column.BL_TYPE eq  sp:getData('BOARD_COLUMN_TYPE_TITLE')}">
					<td class="boardSubject">
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
					<td class="tbl_board_nodata" colspan="5" style="color: #777; text-align: center;">내용없음</td>
				</tr>
				<script>
				$(function(){
					$('.tbl_board_nodata').attr('colspan',$('.tbl_Board_01 th').length);
				})
				</script>
			</c:if>
        </tbody>
    </table>
</div>
<div class="textR pdT15 ">
	<button type="button" class="btn btnSmall_write btn-default" onclick="pf_RegistMove()">글쓰기</button>
</div>
<div class="pageNumberBox">
	<ul class="pageNumberUl">
		<ui:pagination paginationInfo="${paginationInfo }" type="normal_board" jsFunction="pf_LinkPage" />
    </ul>
</div>










