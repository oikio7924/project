<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
	<div class="detailViewTilteBox">
    	<div class="topBox clearfix">
        	<p class="left_1">
            	<span>제목</span><font class="contents"><c:out value="${BoardNotice.BN_TITLE}" escapeXml="true"/></font>
            </p>
            <c:if test="${currentMenu.MN_MAINKEY ne 'MN_0000000278' }"> <!-- 경영공시쪽 게시판은 작성일 X -->
            <p class="right_1">
            	<span>작성일</span>${fn:substring(BoardNotice.BN_REGDT,0,10) }
            </p>
            </c:if>
        </div>
        <c:forEach items="${BoardColumnList }" var="bcl">
        <c:if test="${bcl.BL_TYPE ne BOARD_COLUMN_TYPE_TITLE}">
	        <c:forEach items="${BoardColumnDataList }" var="model">
	        <c:if test="${not empty model.BD_DATA && bcl.BL_KEYNO eq model.BD_BL_KEYNO}">
			<div class="middleBox clearfix">
				<p>
					<span>${model.COLUMN_NAME }</span>
					<font class="contents">
					<c:choose>
						<c:when test="${model.BD_BL_TYPE eq BOARD_COLUMN_TYPE_CHECK }">${fn:replace(model.BD_DATA,'|',',' ) }</c:when>
						<c:when test="${model.BD_BL_TYPE eq BOARD_COLUMN_TYPE_CHECK_CODE }">${fn:replace(model.BD_DATA,'|',',' ) }</c:when>
						<c:when test="${model.BD_BL_TYPE eq BOARD_COLUMN_TYPE_LINK}">
	           				<a href="${model.BD_DATA }" target="_blank"><c:out value="${model.BD_DATA }" escapeXml="true"/></a>
	           			</c:when>
						<c:otherwise><c:out value="${model.BD_DATA }" escapeXml="true"/></c:otherwise>
					</c:choose>
					</font>
				</p>
			</div>
			</c:if>
			</c:forEach>
		</c:if>
		</c:forEach>
        <div class="bottomBox clearfix">
        	<div class="row clearfix ">
            	<p class="left_1">
                	<span>작성자</span> ${BoardNotice.BN_UI_NAME }
                </p>
                <p class="right_1">
                	<span>조회</span> ${BoardNotice.BN_HITS }
                </p>
            </div>
            <c:if test="${BoardType.BT_UPLOAD_YN eq 'Y' && fn:length(FileSub) gt 0 }">
            <div class="row clearfix mgT10">
            	<span>첨부</span>
            	
				<p class="inputBox">
				<c:forEach items="${FileSub}" var="fs">
				<a href="javascript:;" onclick="cf_download('${fs.FS_KEYNO }')"> 
					<img src="/resources/img/icon/icon_attachment_01.png" alt="${language_alt_5 }"> ${fs.FS_ORINM }
					<c:if test="${fs.FS_FILE_SIZE / 1024  gt 1000}">
					(<fmt:formatNumber value="${fs.FS_FILE_SIZE / 1024 / 1024 }" pattern=".0"/>M)
					</c:if>
					<c:if test="${fs.FS_FILE_SIZE / 1000  le 1000}">
					(<fmt:formatNumber value="${fs.FS_FILE_SIZE / 1024 }" pattern=".0"/>K)
					</c:if> 
					
				</a>
				</c:forEach>
				</p>
            </div>
			</c:if>
        </div>
    </div>
    <div class="detailViewContentsBox">
    	${BoardNotice.BN_CONTENTS }
    </div>

