<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<div class="subLeftMenuWrap">
	<div class="nameTagBox viewPc">
    	<div class="wrap">
    		<c:set var="MAINNAME" value="${fn:split(currentMenu.MN_MAINNAMES,',')[0] }"/>
			 <h1>${MAINNAME}</h1>
            <h2>
            <c:out value="${currentMenu.MN_ENG_NAME }"/>
            </h2>
        </div>
    </div>
    
    <ul class="leftMenuSub">
    	<c:if test="${currentMenu.MN_LEV eq '2' }">
    		<c:set var="currentKey" value="${currentMenu.MN_KEYNO }"/>
    	</c:if>
    	<c:if test="${currentMenu.MN_LEV eq '3' }">
    		<c:set var="currentKey" value="${currentMenu.MN_MAINKEY }"/>
    	</c:if>
    	
		 <c:forEach items="${ menuList}" var="model">
			<c:if test="${model.MN_LEV eq '2' && fn:contains(currentMenu.MN_MAINKEYS,model.MN_MAINKEY) }">
			<sec:authorize url="${model.MN_URL}">
				<li class="${model.MN_KEYNO eq currentKey ? 'active':'' }"><a href="javascript:;" onclick="pf_moveMenu('${model.MN_REAL_URL}','${model.MN_PAGEDIV_C }','${model.MN_NEWLINK}')">${model.MN_NAME }</a></li>
			</sec:authorize>
			</c:if>
		</c:forEach> 
    </ul>
</div>
