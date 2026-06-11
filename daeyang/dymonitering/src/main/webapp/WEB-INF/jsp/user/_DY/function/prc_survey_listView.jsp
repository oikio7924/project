<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<script type="text/javascript">

function pf_surveyDetailView(sm_keyno,idyn){
	if(idyn == 'Y' && !cf_checkLogin()){
		return false;
	}
	
	$("#SM_KEYNO").val(sm_keyno);
	$("#Form").attr("action","/dy/function/survey/detailView.do");
	$("#Form").submit();
}

</script>
<form:form id="Form" method="post">
	<input type="hidden" name="SM_KEYNO" id="SM_KEYNO">
	<input type="hidden" name="tiles" id="tiles" value="${tiles}">
</form:form>

<div class="table_wrap_mobile mgT10">
	<table class="tbl_02">
    	<caption>설문조사</caption>    	
    	<thead>
    		<tr>
    			<th style="width:10%;">상태</th>
    			<th>제목</th>
    			<th>시작일</th>
    			<th>종료일</th>
    			<th>참여방식</th>
    			<th>참가인원</th>
    			<th>참여</th>
    		</tr>
    	</thead>
        <tbody>
        <c:forEach items="${SmDTOList }" var="model" varStatus="status">
        	<tr>
        		<td>${model.SM_STATE }</td>
        		<td>${model.SM_TITLE }</td>
        		<td>${model.SM_STARTDT }</td>
        		<td>${model.SM_ENDDT }</td>
        		<td>${model.SM_IDYN eq 'Y' ? '실명' : '무기명' }</td>
        		<td>${model.SM_PANEL_CNT }</td>
        		<td>
        			<c:if test="${model.SM_STATE eq '진행중' }">
        				<a href="javascript:pf_surveyDetailView('${model.SM_KEYNO }','${model.SM_IDYN}')">참여</a>
        			</c:if> 
        		</td>
        	</tr>
        	<tr style="background:#fdfdff">
        		<td></td>
        		<td colspan="6" style="padding-left:20px;">${model.SM_EXP }</td>
        	</tr>
		</c:forEach>
        </tbody>
    </table>
</div>

