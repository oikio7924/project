<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<c:if test="${not empty currentMenu }">	
<script>
$(function(){
	startTimer();
})

// function to start the timer
function startTimer()
{
	if (typeof(Worker)!=="undefined"){
		// common.js에 선언
    	if (sesssionWorker==null){
    		sesssionWorker = new Worker("/resources/common/js/dyAdmin/sessionTimer.js");
    		sesssionWorker.postMessage('');
      	}
    	sesssionWorker.onmessage = function (event) {
    		$('#remainTime').text(event.data)
      	};
   } else {
	   $('#remainTime').text("Sorry, your browser does not support Web Workers ...");
   }
}

</script>
</c:if>


<div class="row">
	<div class="col-xs-6 col-sm-6">
		<span class="txt-color-white"><spring:eval expression="@config.getProperty('cms.version')" /> <span
			class="hidden-xs"> - Content management system</span> © 2017
		</span>
	</div>
	<c:if test="${not empty currentMenu }">	
	<div class="col-xs-6 col-sm-6 text-right">
		<div class="txt-color-white inline-block">
			<i class="remainTimeWrap">현재 페이지 머문시간 <i class="fa fa-clock-o"></i> 
				<strong id="remainTime">0초</strong>&nbsp;
			</i>
		</div>
	</div> 
	</c:if>
</div>
