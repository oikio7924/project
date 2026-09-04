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
<main class="h-full overflow-y-auto ">
	<div class="container grid px-6 mx-auto">
       <div class="relative">
         <div
           class="w-full rounded-lg bg-indigo-200 text-center p-2 md:p-2 lg:p-4 text-sm md:text-sm lg:text-base md:text-base lg:text-lg font-bold my-4 md:md-4 lg:my-7">
           세금계산서 전송현황</div>
         	<div class="w-full rounded-lg bg-white p-5 my-4 md:md-4 lg:my-7">
             <div class="flex flex-wrap items-center text-xs">
<!--                <div class="flex items-center flex-shrink-0 mb-2.5"> -->
<!--                  <label for="inspection_check">발행종류:</label> -->
<!--                  <select name="" id="AH_HOMEDIV_C" name="AH_HOMEDIV_C" onchange="pf_getList()" -->
<!--                    class="default_input_style input_margin_x_10px input_padding_y_4px w-130px"> -->
<!--                    	<option value="">선택하세요.</option> -->
<!-- 		          	<option value="">전체</option> -->
<!-- 		          	<option value="1">한전발행</option> -->
<!-- 		          	<option value="2">거래처 발행</option> -->
<!-- 		          	<option value="3">안전관리 발행</option> -->
<!--                  </select> -->
<!--                </div> -->
               <div class="flex items-center flex-shrink-0 mb-2.5">
                 <label for="startAt">시작일시:</label>
                 <input name="startAt" type="date" id="searchBeginDate" value="${search.searchBeginDate}"
                   class="default_input_style input_margin_x_10px input_padding_y_4px w-130px">
               </div>
               <div class="flex items-center flex-shrink-0 mb-2.5">
                 <label for="endAt">종료일시:</label>
                 <input name="endAt" type="date" id="searchEndDate" value="${search.searchEndDate}"
                   class="default_input_style input_margin_x_10px input_padding_y_4px w-130px">
               </div>
               <div class="flex items-center flex-shrink-0 mb-2.5">
                 <label for="searchPeriod">검색기간:</label>
                  <select name="orderCondition" id="searchDate" onchange="pf_searchDate(this.value)"
            class="default_input_style input_margin_x_10px input_padding_y_4px">
					<option value="">선택하세요.</option>
					<option value="1" ${search.orderCondition eq '1'? 'selected':'' }>오늘</option>
					<option value="2" ${search.orderCondition eq '2'? 'selected':'' }>이번달</option>
					<option value="3" ${search.orderCondition eq '3'? 'selected':'' }>일주일</option>
					<option value="4" ${search.orderCondition eq '4'? 'selected':'' }>15일</option>
					<option value="5" ${search.orderCondition eq '5'? 'selected':'' }>1개월</option>
					<option value="6" ${search.orderCondition eq '6'? 'selected':'' }>2개월</option>
					<option value="7" ${search.orderCondition eq '7'? 'selected':'' }>3개월</option>
					<option value="8" ${search.orderCondition eq '8'? 'selected':'' }>6개월</option>
					<option value="9" ${search.orderCondition eq '9'? 'selected':'' }>1년</option>
					<option value="10" ${search.orderCondition eq '10'? 'selected':'' }>전체</option>
         		 </select>
               </div>
               <div class="flex items-center flex-shrink-0 mb-2.5">
                 <label for="provider">공급자명:</label>
                 <input type="text" name="UI_ID" id="UI_ID" value="${search.UI_ID}"
                   class="default_input_style input_margin_x_10px input_padding_y_4px w-130px">
               </div>
               <button type="button"
        			onclick="pf_LinkPage()" class="text-xs inline-flex items-center px-3 py-1 md:px-3 md:py-1 lg:px-5 lg:py-2 border border-transparent rounded-lg text-white bg-black flex-shrink-0 mb-2.5">조회</button>
    			</div>
               <div class="mt-5 mb-3 flex flex-wrap">
	             <label for="month_all"
	               class="text-black bg-badge-green py-2 px-3 rounded-full mx-2 mb-2 text-xs cursor-pointer flex-shrink-0">전체</label>
	             <input type="checkbox" name="month_all" id="month_all" value ="10"  ${search.orderCondition eq '10'? 'selected':'' }  onclick = "pf_searchDate(this.value)" class="hidden month_btn" >
	             <label for="month_1"
	               class="text-black bg-badge-green py-2 px-3 rounded-full mx-2 mb-2 text-xs cursor-pointer flex-shrink-0">1월</label>
	             <input type="checkbox" name="month_1" id="month_1" value ="13"  ${search.orderCondition eq '13'? 'selected':'' }  onclick = "pf_searchDate(this.value)" class="hidden month_btn">
	             <label for="month_2"
	               class="text-black bg-badge-green py-2 px-3 rounded-full mx-2 mb-2 text-xs cursor-pointer flex-shrink-0">2월</label>
	             <input type="checkbox" name="month_2" id="month_2" value ="14"  ${search.orderCondition eq '14'? 'selected':'' }  onclick = "pf_searchDate(this.value)" class="hidden month_btn">
	             <label for="month_3"
	               class="text-black bg-badge-green py-2 px-3 rounded-full mx-2 mb-2 text-xs cursor-pointer flex-shrink-0">3월</label>
	             <input type="checkbox" name="month_3" id="month_3" value ="15"  ${search.orderCondition eq '15'? 'selected':'' }  onclick = "pf_searchDate(this.value)" class="hidden month_btn">
	             <label for="month_4"
	               class="text-black bg-badge-green py-2 px-3 rounded-full mx-2 mb-2 text-xs cursor-pointer flex-shrink-0">4월</label>
	             <input type="checkbox" name="month_4" id="month_4" value ="16"  ${search.orderCondition eq '16'? 'selected':'' }  onclick = "pf_searchDate(this.value)" class="hidden month_btn">
	             <label for="month_5"
	               class="text-black bg-badge-green py-2 px-3 rounded-full mx-2 mb-2 text-xs cursor-pointer flex-shrink-0">5월</label>
	             <input type="checkbox" name="month_5" id="month_5" value ="17"  ${search.orderCondition eq '17'? 'selected':'' }  onclick = "pf_searchDate(this.value)" class="hidden month_btn">
	             <label for="month_6"
	               class="text-black bg-badge-green py-2 px-3 rounded-full mx-2 mb-2 text-xs cursor-pointer flex-shrink-0">6월</label>
	             <input type="checkbox" name="month_6" id="month_6" value ="18"  ${search.orderCondition eq '18'? 'selected':'' }  onclick = "pf_searchDate(this.value)" class="hidden month_btn">
	             <label for="month_7"
	               class="text-black bg-badge-green py-2 px-3 rounded-full mx-2 mb-2 text-xs cursor-pointer flex-shrink-0">7월</label>
	             <input type="checkbox" name="month_7" id="month_7" value ="19"  ${search.orderCondition eq '19'? 'selected':'' }  onclick = "pf_searchDate(this.value)" class="hidden month_btn">
	             <label for="month_8"
	               class="text-black bg-badge-green py-2 px-3 rounded-full mx-2 mb-2 text-xs cursor-pointer flex-shrink-0">8월</label>
	             <input type="checkbox" name="month_8" id="month_8" value ="20"  ${search.orderCondition eq '20'? 'selected':'' }  onclick = "pf_searchDate(this.value)" class="hidden month_btn">
	             <label for="month_9"
	               class="text-black bg-badge-green py-2 px-3 rounded-full mx-2 mb-2 text-xs cursor-pointer flex-shrink-0">9월</label>
	             <input type="checkbox" name="month_9" id="month_9" value ="21"  ${search.orderCondition eq '21'? 'selected':'' }  onclick = "pf_searchDate(this.value)" class="hidden month_btn">
	             <label for="month_10"
	               class="text-black bg-badge-green py-2 px-3 rounded-full mx-2 mb-2 text-xs cursor-pointer flex-shrink-0">10월</label>
	             <input type="checkbox" name="month_10" id="month_10" value ="22"  ${search.orderCondition eq '22'? 'selected':'' }  onclick = "pf_searchDate(this.value)" class="hidden month_btn">
	             <label for="month_11"
	               class="text-black bg-badge-green py-2 px-3 rounded-full mx-2 mb-2 text-xs cursor-pointer flex-shrink-0">11월</label>
	             <input type="checkbox" name="month_11" id="month_11" value ="23"  ${search.orderCondition eq '23'? 'selected':'' }  onclick = "pf_searchDate(this.value)" class="hidden month_btn">
	             <label for="month_12"
	               class="text-black bg-badge-green py-2 px-3 rounded-full mx-2 mb-2 text-xs cursor-pointer flex-shrink-0">12월</label>
	             <input type="checkbox" name="month_12" id="month_12" value ="24"  ${search.orderCondition eq '24'? 'selected':'' }  onclick = "pf_searchDate(this.value)" class="hidden month_btn">
				 <button type="button" class="py-2 px-3 bg-badge-gray rounded-full mx-2 mb-2 text-xs cursor-pointer flex-shrink-0" name="mon01" id="mon01" value =""    onclick = "sendstatus()">전송 상태 확인</button>           		
           		</div>
          </div>
      </div>
      <div class="w-full rounded-lg bg-white p-5 my-4 md:md-4 lg:my-7">
			<jsp:include page="/WEB-INF/jsp/user/_SFA/include/search/pra_search_header_paging.jsp" flush="true">
				<jsp:param value="/dyAdmin/bills/pagingAjax4sfa.do" name="pagingDataUrl" />
			</jsp:include>
			 <div id="tableWrap"></div>
       </div>
    </div>
  </div>
</main>
</form:form>

<script type="text/javascript">
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

function sendstatus() {
	 $.ajax({
			type: "POST",
			url: "/billsResultTest2.do?${_csrf.parameterName}=${_csrf.token}",
			async: false,
			data: $('#Form').serializeArray(),
			success : function(data){
				location.reload();
				alert(data)
			}, 
			error: function(){
				
			}
	}); 
}

</script>