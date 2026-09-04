<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>

<section id="top-sec-info">

	<div class="info-sec-box">
		<ul>
			 <c:forEach items="${fn:split(currentMenu.MN_MAINNAMES,',') }" var="model" varStatus="status">
			 <li>
				<div class="in-con">
					<span class="sm-tx"><c:out value="${model}"/></span>
                </div>
			</li>
           	</c:forEach>
		</ul>
	</div>

	<div class="info-select-box">
		<form>
		<section class="selc-festi">
			<select class="form-control input-sm select2" id="headerHomeDiv" name="SITE_KEYNO" onchange="selectSite();">
              	<option value="">선택하세요.</option>
              	<c:forEach items="${headerHomeDivList}" var="homeDiv">
				<option value="${homeDiv.MN_KEYNO}" ${homeDiv.MN_KEYNO eq SITE_KEYNO ? 'selected' : ''}>
					<c:out value="${homeDiv.MN_NAME}"/>
				</option>
				</c:forEach>
            </select>
		</section>
		</form>
	</div>
</section>

<script src="/resources/smartadmin/js/plugin/select2/select2.min.js"></script>
<script type="text/javascript">

$(function(){
	$('#headerHomeDiv').select2();
	var siteKey = '${SITE_KEYNO}';
	if(siteKey){
		$("select[name=SITE_KEYNO] > option[value="+siteKey+"]").attr("selected", "selected");
	}
});

function selectSite(){
	var category_keyno = $('select[name="SITE_KEYNO"]').val();
	var category_name = $('select[name="SITE_KEYNO"] option:checked').text();
	var sessionKey = '${SITE_KEYNO}';
	
	if(!category_keyno){
		category_name = '';
	}

	if(sessionKey != category_keyno){
		$.ajax({
	         url: '/dyAdmin/setSiteAjax.do',
	         type: 'POST',
	         data: {
	        	 "SITE_KEYNO":category_keyno,
	        	 "SITE_NAME":category_name
	         },
	         async: false,  
	         success: function() {
	        	 var url = location.pathname;
	        	 if(url != '/dyAdmin/index.do' && !category_keyno){
	        		 url = '/dyAdmin/index.do';
	        	 }
	        	 location.href=url;
	        },
	        error :function(){
	        	cf_smallBox('error', '관리자에게 문의하세요.', 3000,'#d24158');
	        	return false;
	        }
	   });
	}
	return false;
}

</script>