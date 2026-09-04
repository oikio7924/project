<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<%@ include file="/WEB-INF/jsp/user/_common/_Script/survey/script_survey.jsp"%>

<style>
.sq_row{margin-bottom: 25px;}
.sqo_row{margin: 5px 0px 0px 15px;}
.sqo_row textarea{width:100%}
.sq_main {margin-top:30px;}
.typeO {display: none;}
</style>

<form:form id="Form" name="Form" method="post" action="">
	<input type="hidden" id="SM_KEYNO" name="SM_KEYNO" value="${SmDTO.SM_KEYNO }"/>
	<input type="hidden" id="SM_IDYN" name="SM_IDYN" value="${SmDTO.SM_IDYN }"/>

	<c:import url="/common/survey/UserViewAjax.do?key=${SmDTO.SM_SS_KEYNO}"/>

</form:form>
