<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<c:set value="0" var="menuCount"/>

<c:forEach items="${sitemap }" var="model" varStatus="status">
<c:if test="${model.MN_LEV eq 1 && model.MN_NAME ne '임시 뷰' && model.MN_NAME ne '이메일 임시 뷰' && model.MN_NAME ne '이벤트'}">
	<c:set value="${menuCount + 1 }" var="menuCount"/>
	<c:if test="${menuCount % 3 eq 1 }">
	<c:set value="true" var="divOpen"/>
	<div class="siteMapWrap">	
	</c:if>	
	<c:if test="${not empty model.MN_COLOR }">
		<c:set var="MN_COLOR" value="style='background-color:${model.MN_COLOR }'"/>
	</c:if>
	<c:if test="${empty model.MN_COLOR }">
		<c:set var="MN_COLOR" value=""/>
	</c:if>
	<div class="col">
    	<h1  ${MN_COLOR}>${model.MN_NAME }</h1>
        <ul class="siteMapSubMenu">
        <c:forEach items="${sitemap }" var="model2">
        	<c:if test="${model2.MN_MAINKEY eq model.MN_KEYNO && model2.MN_LEV eq 2 }">
        	<li><a class="${current}" href="${model.href }" target="${model.target }" title="${model.MN_NAME }">${model.MN_NAME }</a></li>
        	</c:if>
        </c:forEach>
        </ul>
    </div>
    <c:if test="${menuCount % 3 eq 0 }">
    <c:set value="false" var="divOpen"/>
    <div class="clear"></div>
    </div>
    </c:if>
</c:if>
<c:if test="${status.last && divOpen eq 'false' }">
<div class="clear"></div>
</div>
</c:if>
</c:forEach>
</div>  
                                      
