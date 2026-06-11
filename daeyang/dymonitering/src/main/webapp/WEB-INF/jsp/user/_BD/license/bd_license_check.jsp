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
<main class="h-full overflow-y-auto">
   <div class="container grid px-6 mx-auto">
     <div class="relative">
       <div
         class="w-full rounded-lg bg-indigo-200 text-center p-2 md:p-2 lg:p-4 text-sm md:text-sm lg:text-base md:text-base lg:text-lg font-bold my-4 md:md-4 lg:my-7">
         인허가 진행 현황</div>
       <div class="w-full rounded-lg bg-white p-5 my-4 md:md-4 lg:my-7">
       <div class="flex flex-wrap text-xs">
       		<section> 만료일 선택
				<div class="flex items-center flex-shrink-0 mb-2.5">
				  <select name="AH_HOMEDIV_C" id="AH_HOMEDIV_C" class="default_input_style input_margin_x_10px input_padding_y_4px">
				    <option value="">전체</option>
				    <option value="bd_plant_BusEndDate">발전사업만료일</option>
				    <option value="bd_plant_DevEndDate">개발행위만료일</option>
				  </select>
				  <input name="AH_HOMEDIV_C_Excel" type="hidden" id="AH_HOMEDIV_C_Excel" value="" class="default_input_style input_margin_x_10px input_padding_y_4px">
				</div>
			</section>
			<section>검색기간
				<div class="flex items-center flex-shrink-0 mb-2.5">
				  <button type = "button" onclick = "DateSetting('month')" class="w3-button w3-black w3-border">1개월</button>
				  <button type = "button" onclick = "DateSetting('sixMonth')" class="w3-button w3-black w3-border">6개월</button>
				  <button type = "button" onclick = "DateSetting('year')"class="w3-button w3-black w3-border">1년</button>
				</div>
			</section>
			<section>시작일시
				<div class="flex items-center flex-shrink-0 mb-2.5">				 
				  <input name="searchBeginDate" type="date" id="searchBeginDate" value="" class="default_input_style input_margin_x_10px input_padding_y_4px">
				  <input name="searchBeginDate_Excel" type="hidden" id="searchBeginDate_Excel" value="" class="default_input_style input_margin_x_10px input_padding_y_4px">
				</div>
			</section>
			<section style="text-align: center;">
				~
			</section>
			<section>종료일시
				<div class="flex items-center flex-shrink-0 mb-2.5">
				  <input name="searchEndDate" type="date" id="searchEndDate" value="" class="default_input_style input_margin_x_10px input_padding_y_4px">
				  <input name="searchEndDate_Excel" type="hidden" id="searchEndDate_Excel" value="" class="default_input_style input_margin_x_10px input_padding_y_4px">
				</div>
			</section>
			<button type="button" onclick = "pf_LinkPage()" class="w3-button w3-black w3-round-large">조회</button>
		</div>
<!--         <div class="mt-5 mb-3 flex flex-wrap"> -->
<!-- 	   		<label for="area_0" class="text-black bg-badge-green py-2 px-3 rounded-full mx-2 mb-2 text-xs cursor-pointer flex-shrink-0">지역 전체</label> -->
<%-- 	     	 	<input type="checkbox" name="area_Select" id="area_0" value =""  ${search.orderCondition eq '10'? 'selected':'' }  onclick = "get_areaList(this.value)" class="hidden area_btn" checked> --%>
<%--      			<c:forEach items="${map }" varStatus="status" var="area"> --%>
<%-- 	      		<label for="area_${status.count }" class="text-black bg-badge-green py-2 px-3 rounded-full mx-2 mb-2 text-xs cursor-pointer flex-shrink-0">${map[status.index].SU_SA_AREA}</label> --%>
<%--     			<input type="checkbox" name="area_Select" id="area_${status.count}" value ="${map[status.index].SU_SA_AREA}"  onclick = "get_areaList(this.value)" class="hidden area_btn"> --%>
<%--            		</c:forEach> --%>
<!--         </div> -->
       </div>
       <div class="w-full rounded-lg bg-white p-5 my-4 md:md-4 lg:my-7">
			<jsp:include page="/WEB-INF/jsp/user/_BD/include/search/pra_search_header_paging.jsp" flush="true">
				<jsp:param value="/bd/license/situationPagingAjax.do" name="pagingDataUrl" />
				<jsp:param value="/bd/license/situationExcelAjax.do" name="excelDataUrl" />
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
		url : "${_csrf.parameterName}=${_csrf.token}",
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

function DateSetting(value){
	
	var now = new Date();
    var preDate = "";
    var currentDate  = now.toISOString().slice(0, 10);
    
    if(value == 'month'){
    	now = new Date(now.getFullYear(), now.getMonth() - 1, now.getDate());
    }else if(value == 'sixMonth'){
    	now = new Date(now.getFullYear(), now.getMonth() - 6, now.getDate());  	
    }else if(value == 'year'){
    	now = new Date(now.getFullYear()-1, now.getMonth(), now.getDate());
    }
    preDate = now.toISOString().slice(0, 10);
	
    $('#searchBeginDate').val(preDate);
    $('#searchEndDate').val(currentDate);
}

function seletAll(){
	
	if($("#cbx_chkAll").is(":checked")) $("input[name=chk]").prop("checked", true);
	else $("input[name=chk]").prop("checked", false);
}

function Delete_plant(){
	
	var array = new Array(); 
	$('input:checkbox[name=chk]:checked').each(function() { // 체크된 체크박스의 value 값을 가지고 온다.
	    array.push(this.value);
	});
	
	$("#chkvalue").val(array);
	
	if(array.length > 0){
		if(confirm("양식을 삭제하시겠습니까?")){
			$.ajax({
					type: "POST",
					url: "/bd/license/deletePlant.do?${_csrf.parameterName}=${_csrf.token}",
					data: $('#Form').serializeArray(),
					async: false,
					success : function(data){
						alert("삭제가 완료되었습니다.");
						location.reload();
					}, 
					error: function(){
						
					}
			});
		}else{

		}
	}else{
		alert("삭제할 양식을 선택해주세요.")
	}
return false;
}

</script>