<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<script type="text/javascript" src="/resources/api/se2/js/HuskyEZCreator.js" charset="utf-8"></script>


<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js"></script>
<script>
	if (!window.jQuery.ui) {
		document.write('<script src="/resources/smartadmin/js/libs/jquery-ui-1.10.3.min.js"><\/script>');
	}
</script>


<%@ include file="/WEB-INF/jsp/user/_common/_Script/board/script_insertView.jsp"%>
<%@ include file="/WEB-INF/jsp/user/_common/_Script/board/script_insertView_nomal.jsp"%>

<c:if test="${BoardType.BT_HTMLMAKER_PLUS_YN eq 'S'}">
	<%@ include file="/WEB-INF/jsp/user/_common/_Script/board/include/prc_codeBlock_setting.jsp" %>  
</c:if>

<c:if test="${BoardType.BT_HTMLMAKER_PLUS_YN eq 'Y'}">
	<%@ include file="/WEB-INF/jsp/user/_common/_Script/board/include/prc_img_setting.jsp" %>      
</c:if>


<c:import url="/common/board/UserViewAjax.do?type=insert&key=${BoardType.BT_INSERT_KEYNO }"/>

<script>

//링크확인
function pf_link(id){
	window.open($('#'+id).val())
}

</script>