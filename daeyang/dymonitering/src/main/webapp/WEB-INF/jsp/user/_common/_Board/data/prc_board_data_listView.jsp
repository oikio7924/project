<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<jsp:useBean id="toDay" class="java.util.Date" scope="page"/>
<fmt:formatDate value="${toDay}" pattern="yyyy-MM-dd" var="nowDate" />


<div id="container" class="heightAuto">
	<div class="auto_wrapper"> <!-- auto_wrapper -->
        <div class="inner"> <!-- inner -->
				
			<div class="board_title center">
                   <h2>게시판</h2>
               </div>
			<%-- <c:if test="${BoardHtml.BIH_DIV_LOCATION eq 'T' }">
				<div id="html_contents">${BoardHtml.BIH_CONTENTS }</div>
			</c:if> --%>

			<form:form id="Form" name="Form" method="post">
					<input type="hidden" name="BT_KEYNO" id="BT_KEYNO" value="${BoardType.BT_KEYNO }">
					<input type="hidden" name="BD_BT_KEYNO" id="BD_BT_KEYNO" value="${BoardType.BT_KEYNO }">
					<input type="hidden" name="MN_KEYNO" id="MN_KEYNO" value="${Menu.MN_KEYNO }">
					<input type="hidden" name="BN_MN_KEYNO" id="BN_MN_KEYNO" value="${Menu.MN_KEYNO }">
					<input type="hidden" name="BN_FM_KEYNO" id="BN_FM_KEYNO" value="">
					<input type="hidden" name="BN_THUMBNAIL" id="BN_THUMBNAIL" value="">
					<input type="hidden" name="BN_KEYNO" id="BN_KEYNO" value="">
					<input type="hidden" name="actionView" id="actionView" value="insertView">
					<input type="hidden" name="BN_PWD" id="BN_PWD">


				<div class="search_wrapper">
			    	<select name="searchCondition" id="searchCondition" class="b_sel_search" title="검색 할 내용 선택">
			        	<c:forEach items="${BoardColumnList }" var="model">
							<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_TITLE') }">
								<c:set var="colTitle" value="${model.BL_COLUMN_NAME }"/>
								<option value="title" selected>${model.BL_COLUMN_NAME }</option>
							</c:if>
							<c:if test="${model.BL_TYPE ne sp:getData('BOARD_COLUMN_TYPE_TITLE') }">
								<option value="${model.BL_KEYNO }">${model.BL_COLUMN_NAME }</option>
							</c:if>
						</c:forEach>
						<option value="contents">${colTitle}+내용</option>
						<option value="writer">작성자</option>
						<option value="all">모두</option>
						<option value="file">첨부파일</option>
			        </select>
			        <input type="text" class="b_txt_search" placeholder="검색어를 입력하세요" title="검색어를 입력하세요" name="searchKeyword" id="searchKeyword" onkeydown="if(event.keyCode == 13) pf_boardSearch();">
			        <button type="button" class="b_btn_search" onclick="pf_boardSearch()">검색</button>
				</div>
				
				<c:if test="${'Y'eq BoardType.BT_CATEGORY_YN }">
					<input type="hidden" name="BN_CATEGORY_YN" id="BN_CATEGORY_YN" value="Y">
					<div class="sub_tab_wrap">
						<c:set var="index" value="0" />
						<c:forEach var="categoryname" items="${ fn:split(BoardType.BT_CATEGORY_INPUT,',') }" varStatus="status">
							<c:if test="${status.first }">
								<c:set var="index" value="${index + 1}" />
								<c:if test="${index mod 4 eq 1 }">
									<ul class="sub_tab_02">
								</c:if>
								<li class="${BoardNotice.BN_CATEGORY_NAME == null || empty BoardNotice.BN_CATEGORY_NAME ? 'active' : ''}"><a href="javascript:;" onclick="pf_moveCategory()" title="전체" >전체</a></li>
							</c:if>
							<c:set var="index" value="${index + 1}"/>
							<c:if test="${index mod 4 eq 1 }">
							<ul class="boardCategoryRow">
							</c:if>
								<li class="${categoryname eq BoardNotice.BN_CATEGORY_NAME ? 'active' : ''}">
									<a href="javascript:;" onclick="pf_moveCategory('${status.count}')">${categoryname }</a>
								</li>
							<c:if test="${ status.last || index mod 4 eq 0 }">
							</ul>
							</c:if>
						</c:forEach>
					</div>
				</c:if>
                
				<c:import url="/common/board/UserViewAjax.do?type=list&key=${BoardType.BT_LIST_KEYNO }"/>
			</form:form>
		
			<c:if test="${BoardHtml.BIH_DIV_LOCATION eq 'B' }">
				<div id="html_contents">${BoardHtml.BIH_CONTENTS }</div>
			</c:if>
		</div>
	</div>
</div>

<%@ include file="/WEB-INF/jsp/user/_common/_Script/board/script_listView.jsp"%>

