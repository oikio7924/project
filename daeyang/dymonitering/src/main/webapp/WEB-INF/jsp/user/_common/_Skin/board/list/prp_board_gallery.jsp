<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<p class="board_count">총 게시물 <span class="colorR"><fmt:formatNumber value="${paginationInfo.totalRecordCount }" pattern="#,###" /> 건</span> ${paginationInfo.currentPageNo } 페이지</p>    

<ul class="subPicListBox">
<c:forEach items="${BoardNoticeDataList }" var="model" varStatus="status">
	<c:choose>
		<c:when test="${model.BN_DEL_YN eq 'Y' }">
			<c:set var="detailFunction" value="alert('삭제된 게시물입니다.')"/>
		</c:when>
		<c:when test="${BoardType.BT_SECRET_YN eq 'Y' && model.BN_SECRET_YN eq 'Y'}">
			<c:choose>
				<c:when test="${userInfo.isAdmin eq 'Y' || model.BN_REGNM eq userInfo.UI_KEYNO }">
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
	<li>
		<a href="javascript:;" onclick="${detailFunction}" class="imgBox">
			<c:if test="${not empty model.THUMBNAIL_PATH }">
   				<img src="${model.THUMBNAIL_PATH}" alt="<c:out value="${model.BN_TITLE }" escapeXml="false"></c:out>">
       		</c:if>
       		<c:if test="${empty model.THUMBNAIL_PATH }">
     			<img src="/resources/img/board/no_img.gif" alt="<c:out value="${model.BN_TITLE }" escapeXml="false"></c:out>">
       		</c:if>
		</a>
	    <h1>
	    	<a href="javascript:;" onclick="${detailFunction}">
	    	<c:if test="${BoardType.BT_SECRET_YN eq 'Y' && model.BN_SECRET_YN eq 'Y' }">
				<img src="/resources/img/icon/icon_lock.gif" alt="비밀글 아이콘">
			</c:if>
	    	<c:out value="${model.BN_TITLE}" escapeXml="true"/>
	    	<c:if test="${BoardType.BT_COMMENT_YN eq 'Y' }">
				(${model.BN_BC_COUNT})
			</c:if>
			<c:if test="${model.BN_NEW eq '1' }">
				<img src="/resources/img/icon/icon_new.gif" alt="새글 아이콘">
			</c:if>
			</a>
	    </h1>
	    <p class="date">등록일 : <c:out value="${fn:substring(model.BN_REGDT,0,19) }"/></p>
	    <p class="write">등록자 : <c:out value="${model.BN_UI_NAME}"/></p>
    </li>
</c:forEach>
</ul>


<div class="textR pdT15">
	<button type="button" class="btn btnSmall_write" onclick="pf_RegistMove()">글쓰기</button>
</div>
<div class="pageNumberBox">
	<ul class="pageNumberUl">
		<ui:pagination paginationInfo="${paginationInfo }" type="normal_board" jsFunction="pf_LinkPage" />
    </ul>
</div>




