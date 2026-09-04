<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<div>
  	아임퍽 구라쟁이!!!!!!
	<ul>
  	<c:forEach items="${resultList }" var="model">
		<li>
			<a href="${tilesUrl}/Board/${model.BN_KEYNO}/detailView.do"  title="${model.COLUMN1}">
              ${model.COLUMN1}
			</a>
		</li>
    </c:forEach>
	</ul>
</div>