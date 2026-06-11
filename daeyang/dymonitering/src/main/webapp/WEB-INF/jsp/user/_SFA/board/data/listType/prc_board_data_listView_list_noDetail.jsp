<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<p class="board_count">총 게시물 <span class="colorR"><fmt:formatNumber value="${paginationInfo.totalRecordCount }" pattern="#,###" /> 건</span> ${paginationInfo.currentPageNo } 페이지</p>    
<div class="tblBoardBox table_wrap_mobile">
	<table class="tbl_Board_01 tbl_Board_info">
        <caption>게시판</caption>
        <thead>
        	<tr>
            	<th class="number"><span>번호</span></th>
            	<c:forEach items="${BoardColumnList }" var="model">
            		<c:if test="${model.BL_LISTVIEW_YN eq 'Y'}">
						<th class="${model.BL_TYPE eq BOARD_COLUMN_TYPE_TITLE ? 'boardSubject':'' }">
							<span>${model.BL_COLUMN_NAME }</span>
						</th>
					</c:if>	
				</c:forEach>
				<c:if test="${boardAuthList.write }">
				<th><span>설정</span></th>
				</c:if>
            </tr>
        </thead>
        <tbody>
        	<c:set var="noticeCount" value="0"/>
			<c:forEach items="${BoardNoticeDataList }" var="model" varStatus="status">
			<c:if test="${model.BN_DEL_YN eq 'N' }">
				<fmt:parseNumber value="${fn:substring(model.BN_KEYNO, 4, 20)}"
					var="BN_KEYNO_NUMBERTYPE" />
				
				
				<tr class="${model.BOARD_TYPE eq 'NOTICE' ? 'boardNotice_Row':''}">
					<td class="number">
						<c:choose>
							<c:when test="${model.BOARD_TYPE eq 'NOTICE'}">
								공지
								<c:set var="noticeCount" value="${noticeCount + 1 }"/>
							</c:when>
							<c:otherwise>
								${model.NUM }
								<%-- ${paginationInfo.totalRecordCount - ((paginationInfo.currentPageNo-1) * paginationInfo.recordCountPerPage  + status.index - noticeCount) } --%>
							</c:otherwise>
						</c:choose>
					</td>
					
					<c:forEach items="${BoardColumnList }" var="bcl">
					<c:if test="${bcl.BL_LISTVIEW_YN eq 'Y'}">
						<c:set var="columnView" value="false"/>
						<c:forEach items="${BoardColumnDataList }" var="bcdl">
		            		<c:if test="${model.BN_KEYNO eq bcdl.BD_BN_KEYNO && bcdl.BD_BL_KEYNO eq bcl.BL_KEYNO}">
		            		<c:set var="columnView" value="true"/>
		            		<c:choose>
		            			<c:when test="${bcdl.BD_BL_TYPE eq BOARD_COLUMN_TYPE_TITLE}">
		            				<!-- 제목일 경우 -->
		            				<td class="boardSubject">
									<c:forEach begin="1" end="${model.BN_DEPTH }">&nbsp;&nbsp;&nbsp;&nbsp;</c:forEach>
									<c:if test="${BoardType.BT_SECRET_YN eq 'Y' && model.BN_SECRET_YN eq 'Y' }">
										<img src="/resources/img/icon/icon_lock.gif" alt="비밀글 아이콘">
									</c:if>
									<c:if test="${model.BN_DEPTH gt 0 }">
										<img src="/resources/img/icon/icon_reply.gif" alt="답글 아이콘">
									</c:if>
									
									<c:out value="${model.BN_TITLE}" escapeXml="true"/>
									
									<c:if test="${BoardType.BT_COMMENT_YN eq 'Y' }">
										(${model.BN_BC_COUNT})
									</c:if>
									<c:if test="${model.BN_NEW eq '1' }">
										<img src="/resources/img/icon/icon_new.gif" alt="새글 아이콘">
									</c:if>
									<c:if test="${BoardType.BT_UPLOAD_YN eq 'Y' && not empty model.BN_FM_KEYNO}">
										<img src="/resources/img/icon/icon_file.gif" alt="첨부파일 아이콘">
									</c:if>
									</td>
		            			</c:when>
		            			<c:when test="${bcdl.BD_BL_TYPE eq BOARD_COLUMN_TYPE_CHECK || bcdl.BD_BL_TYPE eq BOARD_COLUMN_TYPE_CHECK_CODE }">
		            				<td>${fn:replace(bcdl.BD_DATA,'|',',' ) }</td>
		            			</c:when>
		            			<c:when test="${bcdl.BD_BL_TYPE eq BOARD_COLUMN_TYPE_LINK}">
		            				<td class="boardLink"><a href="${bcdl.BD_DATA }" target="_blank"><c:out value="${bcdl.BD_DATA }" escapeXml="true"/></a></td>
		            			</c:when>
		            			<c:otherwise>
		            				<td><c:out value="${bcdl.BD_DATA }" escapeXml="true"/></td>
		            			</c:otherwise>
		            		</c:choose>
							</c:if>	
						</c:forEach>
						<c:if test="${columnView eq 'false' }">
	            				<!-- 데이터가 없을경우 공백 뿌려줌 -->
	            				<td></td>
						</c:if>
					</c:if>
					</c:forEach>
					<c:if test="${boardAuthList.write }">
					<td>
						<c:if test="${model.BN_REGNM eq userInfo.UI_KEYNO || userInfo.isAdmin eq 'Y' }">
						<button type="button" class="btn btnSmall_01" style="padding: 3px 10px;" onclick="pf_UpdateMove('${BN_KEYNO_NUMBERTYPE}')">수정</button>
						<button type="button" class="btn btnSmall_01" style="padding: 3px 10px;" onclick="pf_moveBoardData('${BN_KEYNO_NUMBERTYPE}')">이동</button>
						<button type="button" class="btn btnSmall_01" style="padding: 3px 10px;" onclick="pf_deleteMove('${BN_KEYNO_NUMBERTYPE}')">삭제</button>
						</c:if>
					</td>
					</c:if>
				</tr>
			</c:if>
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
<div class="textR pdT15">
	<button type="button" class="btn btnSmall_write" onclick="pf_RegistMove()">글쓰기</button>
</div>
<div class="pageNumberBox">
	<ul class="pageNumberUl">
		<ui:pagination paginationInfo="${paginationInfo }" type="normal_board" jsFunction="pf_LinkPage" />
    </ul>
</div>










