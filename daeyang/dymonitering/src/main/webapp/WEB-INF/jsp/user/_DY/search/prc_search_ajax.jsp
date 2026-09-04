<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<c:choose>
	<c:when test="${type eq 'menu' }">
		<c:forEach items="${menuSearchList }" var="model"
			varStatus="menuStatus">
			<div class="row">
				<h2>
					<c:forEach items="${fn:split(model.MN_MAINNAMES,',') }" var="name"
						varStatus="nameStatus">
						<c:if test="${!nameStatus.last }">
					${name} &gt;
					</c:if>
						<c:if test="${nameStatus.last }">
							<font class="searchText">${name}</font>
						</c:if>
					</c:forEach>
				</h2>
				<div class="searchContents">${model.MVD_DATA }</div>
				<h3>
					<a href="${model.MN_URL }" target="_blank">${model.MN_URL }</a>
				</h3>
				<p class="word">
					검색된 단어 :: <b>${model.keyword }</b>
				</p>
			</div>
		</c:forEach>
		<div class="pageNumberBox">
			<ul class="pageNumberUl">
				<ui:pagination paginationInfo="${menuPaginationInfo }"
					type="normal_board" jsFunction="pf_linkpage_menu" />
			</ul>
		</div>
	</c:when>
	<c:when test="${type eq 'board' }">
		<c:forEach items="${boardSearchList }" var="model">
			<fmt:parseNumber value="${fn:substring(model.BN_KEYNO, 4, 20)}" var="BN_KEYNO_NUMBERTYPE" />
			<div class="row">
				<h2>
					<a href="${model.readAuth eq 'disallow' ? 'javascript:alert(\'접근 권한이 없습니다. 로그인을 하시거나 접근권한을 확인하세요.\');' : model.BN_URL}"
									${model.readAuth eq 'disallow' ? '' : 'target=\'_blank\'' } title="${model.BN_TITLE }">
					<font class="searchText">${model.BN_TITLE }</font>
					</a> <span class="date">/ ${fn:substring(model.BN_REGDT,0,10) }</span>
				</h2>
				<div class="searchContents">${model.BN_CONTENTS }</div>
				<h4>
					<c:forEach items="${fn:split(model.MN_MAINNAMES,',') }" var="name"
						varStatus="nameStatus">
						<c:if test="${!nameStatus.last }">
					${name} <span class="colorG_666">&gt;</span>
						</c:if>
						<c:if test="${nameStatus.last }">
							<a href="${model.MN_URL }" target="_blank">${name}</a>
						</c:if>
					</c:forEach>
				</h4>
				<p class="word">
					검색된 단어 :: <b>${model.keyword }</b>
				</p>
			</div>
		</c:forEach>
		<div class="clear"></div>
		<div class="pageNumberBox">
			<ul class="pageNumberUl">
				<ui:pagination paginationInfo="${boardPaginationInfo }"
					type="normal_board" jsFunction="pf_linkpage_board" />
			</ul>
		</div>
	</c:when>
	<c:when test="${type eq 'file' }">
		<div class="row">
			<c:forEach items="${fileSearchList }" var="model">
				<fmt:parseNumber value="${fn:substring(model.BN_KEYNO, 4, 20)}"
					var="BN_KEYNO_NUMBERTYPE" />
				<div class="row">
					<h2>
						<a href="${model.readAuth eq 'disallow' ? 'javascript:alert(\'접근 권한이 없습니다. 로그인을 하시거나 접근권한을 확인하세요.\');' : model.BN_URL}"
									${model.readAuth eq 'disallow' ? '' : 'target=\'_blank\''} title="${model.BN_TITLE }">
									${model.BN_TITLE } </a> <span class="date">/ ${fn:substring(model.BN_REGDT,0,10) }</span>
					</h2>
					<div class="clear"></div>
					<h3>
						<img src="/resources/img/icon/icon_attachment_01.png"
							alt="첨부파일 아이콘"> 첨부파일 : <a href="javascript:;"
									onclick="pf_down('${model.downAuth eq 'disallow' ? '' : model.encodeFsKey }')">
									<font class="searchText">${model.FS_ORINM}</font></a> (1.2M)
					</h3>
					<h4>
						<c:forEach items="${fn:split(model.MN_MAINNAMES,',') }" var="name"
							varStatus="nameStatus">
							<c:if test="${!nameStatus.last }">
					${name} <span class="colorG_666">&gt;</span>
							</c:if>
							<c:if test="${nameStatus.last }">
								<a href="${model.MN_URL }" target="_blank">${name}</a>
							</c:if>
						</c:forEach>
					</h4>
					<p class="word">
						검색된 단어 :: <b>${model.keyword }</b>
					</p>
				</div>
			</c:forEach>
			<div class="clear"></div>
			<div class="pageNumberBox">
				<ul class="pageNumberUl">
					<ui:pagination paginationInfo="${filePaginationInfo }"
						type="normal_board" jsFunction="pf_linkpage_file" />
				</ul>
			</div>
		</div>
	</c:when>

	<c:when test="${type eq 'dept' }">
		<div class="contentsBox boardSearchGo dataSearchGo" id="deptSearchGo">
			<div class="table_wrap_mobile02">
				<table class="tbl_03 tbl_borTopBlue tbl_Group_01">
					<caption>조직도</caption>
					<thead>
						<tr>
							<th>직위</th>
							<th>이름</th>
							<th>담당업무</th>
							<th>전화 및 팩스 번호</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${deptSearchList}" var="model2">

							<fmt:parseNumber value="${fn:substring(model2.DU_KEYNO, 4, 20)}"
								var="DU_KEYNO_NUMBERTYPE" />
							<tr id="person${DU_KEYNO_NUMBERTYPE}">
								<td class="conditionC"><font class="searchText">${model2.DU_ROLE }</font></td>
								<td class="conditionA"><font class="searchText">${model2.DU_NAME }</font></td>
								<td class="conditionC"><pre><font class="searchText">${model2.DU_CONTENTS }</font></pre></td>
								<td class="conditionB"><pre><font class="searchText">${model2.DU_TEL }</font></pre></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>

			<div class="clear" ></div>
			<div class="pageNumberBox" style="margin-top: 30px;">
				<ul class="pageNumberUl">
					<ui:pagination paginationInfo="${deptPaginationInfo }"
						type="normal_board" jsFunction="pf_linkpage_dept" />
				</ul>
			</div>
		</div>
	</c:when>

</c:choose>