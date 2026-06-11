<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script src="/resources/common/js/common/page_research.js"></script>
 
<form:form id="PageForm">
	<fmt:parseNumber value="${fn:substring(currentMenu.MN_KEYNO,4,20)}" var="menuKey"/>
	<input type="hidden" name="TPS_MN_KEYNO" id="TPS_MN_KEYNO" value="${menuKey}"/>
	<input type="hidden" name="TPS_SCORE_NAME" id="TPS_SCORE_NAME"/>
	<c:set value="${(not empty currentMenu.MN_DU_KEYNO && currentMenu.MN_DU_KEYNO eq 'DU_0000000000') ? currentMenu.MN_MANAGER_DEP : currentMenu.PAGE_DEPARTMENT}" var="MANAGER_DEP"/>
	<c:set value="${(not empty currentMenu.MN_DU_KEYNO && currentMenu.MN_DU_KEYNO eq 'DU_0000000000') ? currentMenu.MN_MANAGER : currentMenu.PAGE_NAME }" var="MANAGER"/>
	<c:set value="${(not empty currentMenu.MN_DU_KEYNO && currentMenu.MN_DU_KEYNO eq 'DU_0000000000') ? currentMenu.MN_MANAGER_TEL : currentMenu.PAGE_TEL }" var="MANAGER_TEL"/> 
	
	<c:import url="/common/research/UserViewAjax.do?key=${homeData.HM_RESEARCH_SKIN }"/>
	
</form:form>