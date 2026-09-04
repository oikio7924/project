<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<div>
	<ul>
  	<c:forEach items="${resultList }" var="model">
		<li>
			<a href="${model.TLM_URL}" target="_blank" ">
				<img src="/resources/img/upload/${model.FS_FOLDER}/${model.FS_CHANGENM}.${model.FS_EXT}" 
					alt="${model.TLM_ALT}"> aaaa
			</a>
		</li>
    </c:forEach>
	</ul>
</div>