<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<div style="margin: 0 auto; width: 80%;">
	<ul id="sample">
	  	<c:forEach items="${resultList }" var="model">
			<li>
				<a href="${model.TLM_URL}" target="_blank">
					<img src="/common/file.do?file=${model.Path }" 
						alt="${model.TLM_ALT}" title="${model.TLM_COMMENT}">
				</a>
			</li>
	    </c:forEach>
	</ul>
</div>

<script type="text/javascript">
	$(function() {
		$('#sample').bxSlider({
			auto: true,
			speed: 1000,
			pause: 4000,
			mode: 'fade',
			autoControls: true,
			pager: true,
			touchEnabled : (navigator.maxTouchPoints > 0),
			captions: true
		});
	});
</script>
