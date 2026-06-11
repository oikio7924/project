<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>
label input[type=checkbox].checkbox+span, label input[type=radio].radiobox+span{z-index: 1}
.checkbox-inline, .radio-inline {margin-left:10px;}
.input-group-addon {background:#fff;}
.fa-lock {width:14px;}
</style>

<c:choose>
	<c:when test="${BoardType.BT_CODEKEY eq sp:getData('BOARD_TYPE_LIST_NO_DETAIL') }">
		<%@ include file="insertType/pra_board_data_insertView_noDetail.jsp"%>
	</c:when>
	<c:otherwise>
		<%@ include file="insertType/pra_board_data_insertView_normal.jsp"%>
	</c:otherwise>
</c:choose>
