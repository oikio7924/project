<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>

<link
  href="https://code.jquery.com/ui/1.12.1/themes/ui-lightness/jquery-ui.css"
  rel="stylesheet"
/>

<!-- ✅ load jQuery ✅ -->
<script
  src="https://code.jquery.com/jquery-3.6.0.min.js"
  integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
  crossorigin="anonymous"
></script>

<!-- ✅ load jquery UI ✅ -->
<script
  src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"
  integrity="sha512-uto9mlQzrs59VwILcLiRYeLKPPbS/bT71da/OEBYEwcdNUk8jYIy+D176RYoop1Da+f9mvkYrmj5MCLZWEtQuA=="
  crossorigin="anonymous"
  referrerpolicy="no-referrer"></script>


<form:form id="Form" name="Form" method="post">
<input type="hidden" name="chkvalue" id="chkvalue">
<main class="h-full overflow-y-auto ">
   <div class="container grid px-6 mx-auto">
     <div class="relative">
       <div
         class="w-full rounded-lg bg-indigo-200 text-center p-2 md:p-2 lg:p-4 text-sm md:text-sm lg:text-base md:text-base lg:text-lg font-bold my-4 md:md-4 lg:my-7">
         발전소 점검 현황</div>
       <div class="w-full rounded-lg bg-white p-5 my-4 md:md-4 lg:my-7">
           <div class="mt-5 mb-3 flex flex-wrap">
           		 <label for="area_0" class="text-black bg-badge-green py-2 px-3 rounded-full mx-2 mb-2 text-xs cursor-pointer flex-shrink-0">지역 전체</label>
             	 <input type="checkbox" name="area_Select" id="area_0" value =""  ${search.orderCondition eq '10'? 'selected':'' }  onclick = "get_areaList(this.value)" class="hidden area_btn" checked>
	             <c:forEach items="${map }" varStatus="status" var="area">
	             		<label for="area_${status.count }" class="text-black bg-badge-green py-2 px-3 rounded-full mx-2 mb-2 text-xs cursor-pointer flex-shrink-0">${map[status.index].SU_SA_AREA}</label>
             			<input type="checkbox" name="area_Select" id="area_${status.count}" value ="${map[status.index].SU_SA_AREA}"  onclick = "get_areaList(this.value)" class="hidden area_btn">
	             </c:forEach>
           </div>
       </div>
       <div class="w-full rounded-lg bg-white p-5 my-4 md:md-4 lg:my-7">
			<jsp:include page="/WEB-INF/jsp/user/_SFA/include/search/pra_search_header_paging.jsp" flush="true">
				<jsp:param value="/sfa/sfaAdmin/checkingAjaxAdmin.do" name="pagingDataUrl" />
			</jsp:include>
			 <div id="tableWrap"></div>
       </div>
     </div>
   </div>
</main>
</form:form>
<script type="text/javascript">
$(function() {
	
});
function pf_searchDate(object){
	pf_settingSearchDate(object);
	pf_LinkPage();
}

//이전달로 이동 
$('.go-prev').on('click', function() { thisMonth = new Date(currentYear-1, currentMonth, 1); 
renderCalender(thisMonth); }); 

// 다음달로 이동 
$('.go-next').on('click', function() { thisMonth = new Date(currentYear+1, currentMonth, 1); 
renderCalender(thisMonth); });


function get_areaList(value){
	
	$.ajax({
		url : "/sfa/sfaAdmin/checkingAjaxAdmin.do?${_csrf.parameterName}=${_csrf.token}",
		type : "POST" ,
		data : {
			"areaSelect" : value
		},
		success : function(data){
			$('#tableWrap').html(data);
		},
		error : function(xhr, status, error) {
			cf_smallBox('ajax', '알수없는 에러 발생. 관리자한테 문의하세요.', 3000,'gray');
      }

	})
}
</script>