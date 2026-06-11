<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<div class="flex justify-between">
 <div class="flex">
    <input type="text" class="search-control" name="field_search" data-searchindex="all" placeholder="모든필드 검색"
      style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px">
    <button type="button"  onclick="pf_LinkPage()"
      class="text-xs inline-flex items-center px-3 py-1 md:px-3 md:py-1 lg:px-5 lg:py-2 border border-transparent rounded-lg text-white bg-black">검색</button>
  </div>
  <div class="flex">
    <select name="pageUnit" id="pageUnit" onchange="pf_LinkPage();" class="default_input_style input_margin_x_10px input_padding_y_4px">
      	<option value="10" ${10 eq search.pageUnit ? 'selected' : '' }>10</option>
    	<option value="25" ${25 eq search.pageUnit ? 'selected' : '' }>25</option>
    	<option value="50" ${50 eq search.pageUnit ? 'selected' : '' }>50</option>
    	<option value="75" ${75 eq search.pageUnit ? 'selected' : '' }>75</option>
    	<option value="100" ${100 eq search.pageUnit ? 'selected' : '' }>100</option>
    </select>
  </div>
</div>

<div class="w-full border my-3 md:my-3 lg:my-5"></div>

<div class="w-full overflow-hidden rounded-lg ring-1 ring-black ring-opacity-5">
  <div class="w-full overflow-x-auto">
    <form action="" class="form-max-width">
      <table class="pagingTable w-full whitespace-nowrap">
        <thead class="text-xs font-semibold tracking-wide text-left text-gray-500 uppercase border-b bg-gray-50">
          <tr class="font-bold text-black">
             <td class="px-4 py-3 text-center">
              <input type="checkbox" id="cbx_chkAll" onclick="seletAll()" class="mt-2">
            </td>
            <td class="px-4 py-3 text-center">
              <input name="id_cont" type="text" data-searchindex="1" 
                class="default_input_style input_margin_x_10px input_padding_y_4px search-control"
                placeholder="번호 검색">
              <div class="text-center mt-2">
               <a class="arrow" data-index="1" style="cursor: pointer;">
                 번호
                  <svg stroke="currentColor" fill="currentColor" stroke-width="0"
                    viewBox="0 0 320 512" class="inline-flex" height="1em" width="1em"
                    xmlns="http://www.w3.org/2000/svg">
                    <path
                      d="M41 288h238c21.4 0 32.1 25.9 17 41L177 448c-9.4 9.4-24.6 9.4-33.9 0L24 329c-15.1-15.1-4.4-41 17-41zm255-105L177 64c-9.4-9.4-24.6-9.4-33.9 0L24 183c-15.1 15.1-4.4 41 17 41h238c21.4 0 32.1-25.9 17-41z">
                    </path>
                  </svg>
               </a>
              </div>
            </td>
            <td class="px-4 py-3 text-center text-xs">
              <select name="issue_check_eq" data-searchindex="2" onchange="pf_LinkPage()"
                class="default_input_style input_margin_x_10px input_padding_y_4px search-control">
                <option value="">전체</option>
                <option value="1">이상 있음</option>
                <option value="2">이상 없음</option>
              </select>
              <div class="text-center mt-2">
                <a>
                 	 이상 유/무
                </a>
              </div>
            </td>
            <td class="px-4 py-3 text-center text-xs">
              <input name="title_cont" type="text" data-searchindex="3"
                class="default_input_style input_margin_x_10px input_padding_y_4px search-control"
                placeholder="발전소명(으)로 검색">
              <div class="text-center mt-2">
                <a>
                 	 발전소명
                </a>
              </div>
            </td>
            <td class="px-4 py-3 text-center text-xs">
              <input name="created_at_gteq" type="date" data-searchindex="4"
                class="default_input_style input_margin_x_10px input_padding_y_4px search-control"
                value="Invalid date">
              <div class="text-center mt-2">
                <a class="arrow" data-index="4" style="cursor: pointer;">
                  	작성일
                  <svg stroke="currentColor" fill="currentColor" stroke-width="0"
                    viewBox="0 0 320 512" class="inline-flex" height="1em" width="1em"
                    xmlns="http://www.w3.org/2000/svg">
                    <path
                      d="M41 288h238c21.4 0 32.1 25.9 17 41L177 448c-9.4 9.4-24.6 9.4-33.9 0L24 329c-15.1-15.1-4.4-41 17-41zm255-105L177 64c-9.4-9.4-24.6-9.4-33.9 0L24 183c-15.1 15.1-4.4 41 17 41h238c21.4 0 32.1-25.9 17-41z">
                    </path>
                  </svg>
                </a>
              </div>
            </td>
            <td class="px-4 py-3 text-center text-xs">
              <input name="notice_cont" type="text" data-searchindex="5"
                class="default_input_style input_margin_x_10px input_padding_y_4px search-control"
                placeholder="종합의견(으)로 검색" value="">
              <div class="text-center mt-2">
                <a>
                  	종합의견
                </a>
              </div>
            </td>
            <td class="px-4 py-3"></td>
            <td class="px-4 py-3"></td>
          </tr>

        </thead>
        <tbody class="bg-white divide-y text-gray-700">
        	<c:if test="${empty resultList4 }">
	        	<tr>
					<td class="px-4 py-3 text-center" colspan="100%">검색된 데이터가 없습니다.</td>
				</tr>
			</c:if>
			<c:forEach items="${resultList4 }" var="b">
	          <tr class="">
	          	<td class="px-4 py-3">	          	
	         		<input type="checkbox" name="chk" id ="chk" value = "${b.sa2_keyno}">
	          	</td>
	            <td class="px-4 py-3 text-center" style="white-space: nowrap;">
	              <span class="text-sm">${b.COUNT}</span>
	            </td>
	            <c:if test="${b.sa2_problem eq '1' }">
		            <td class="px-4 py-3 text-center" style="white-space: nowrap;">
		              <span class="text-sm">
		                <span class="inline-flex px-2 text-xs font-medium leading-5 rounded-full text-red-700 bg-red-100">이상있음</span>
		              </span>
		            </td>
	            </c:if>
	            <c:if test="${b.sa2_problem eq '2' }">
	            	<td class="px-4 py-3 text-center">
                       <span class="text-sm">
                         <span
                           class="inline-flex px-2 text-xs font-medium leading-5 rounded-full text-green-700 bg-green-100">이상없음</span>
                       </span>
                     </td>
	            </c:if>
	            <td class="px-4 py-3 text-center" style="white-space: nowrap;">
	             	<span class="text-sm">${b.sa2_title}</span>
	            </td>
	            <td class="px-4 py-3 text-center" style="white-space: nowrap;">
	              <span class="text-sm">${b.sa2_date}</span>
	            </td>
	            <td class="px-4 py-3 text-center" style="white-space: nowrap;">
	              <span class="text-sm">${b.sa2_opinion}</span>
	            </td>
	            <td class="px-4 py-3 text-center" >
	              <button type="button" onclick = "taxpopup('${b.sa2_keyno}');" id="listtable" name ="listtable" value ="${b.sa2_keyno}"
	                class="text-xs inline-flex items-center px-3 py-1 border border-transparent rounded-md text-white bg-black">더보기</button>
	            </td>
	          </tr>
	         </c:forEach>
        </tbody>
      </table>
    </form>
  </div>
  <div class="px-4 py-3 border-t bg-gray-50 text-gray-500">
  	<div><button class="text-sm md:text-sm lg:text-base font-bold inline-flex items-center px-4 py-2 md:px-4 md:py-2 lg:px-6 lg:py-3 border border-transparent rounded-lg text-white bg-button-blue" id="deleteButton"
			type="button" onclick="Delete_paper()" style="background-color: #E53935;">삭제</button></div>
    <div class="flex flex-col justify-between text-xs sm:flex-row text-gray-600">
  	<c:if test="${not empty resultList4 }">
      <span class="pagetext flex items-center font-semibold tracking-wide uppercase">총 ${paginationInfo.totalRecordCount }건  / 총 ${paginationInfo.totalPageCount} 페이지 중 ${paginationInfo.currentPageNo} 페이지</span>
      <div class="flex mt-2 sm:mt-auto sm:justify-end">
        <nav aria-label="페이지">
          <ul class="pageNumberUl inline-flex items-center">
                <ui:pagination paginationInfo="${paginationInfo }" type="Manager" jsFunction="pf_LinkPage"/>
          </ul>
        </nav>
      </div>
    </c:if>
    <c:if test="${empty resultList4 }">
    	<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
		<span class="pagetext flex items-center font-semibold tracking-wide uppercase">0건 중 0~0번째 결과(총  ${paginationInfo.totalRecordCount }건중 매칭된 데이터)</span>
		</div>
    </c:if>
    </div>
  </div>
</div>
<input type="hidden" id="UIKEYNO" name="UIKEYNO" value="${SU_UI_KEYNO}">

<script type="text/javascript">

$(function(){

	pf_defaultPagingSetting('${search.orderBy}','${search.sortDirect}');

})


function taxpopup(value){
    
	var UIKEYNO = $("#UIKEYNO").val();
	
	$.ajax({
		url: '/sfa/safeAdmin/log/inverterNum.do?${_csrf.parameterName}=${_csrf.token}',
		type: 'POST',
		data: {
			"keyno" : value,
			"UIKEYNO" : UIKEYNO
		},
		async: false,
		success : function(data){
			
			console.log(data)
			
			var left = Math.ceil((window.screen.width - 2000)/2);
			var top = Math.ceil((window.screen.height - 820)/2);
			var popOpen	= window.open("/sfa/sfaAdmin/log/controller.do?listtable="+value+"&num="+data, "Taxpopup","width=1200px,height=900px,top="+top+",left="+left+",status=0,toolbar=0,menubar=0,location=false,scrollbars=yes");
			popOpen.focus();
		}
	});
	
}

function logAlarm(keyno){
	
	$.ajax({
		url: '/dyAdmin/bills/sendingAjax.do?${_csrf.parameterName}=${_csrf.token}',
		type: 'POST',
		data: {
			"keyno" : keyno
		},
		async: false,
		success : function(data){
			alert(data)
		}
	});
	
}

function Delete_paper(){
	
	var array = new Array(); 
	$('input:checkbox[name=chk]:checked').each(function() { // 체크된 체크박스의 value 값을 가지고 온다.
	    array.push(this.value);
	});
	
	$("#chkvalue").val(array);
	
	if(array.length > 0){
		if(confirm("양식을 삭제하시겠습니까?")){
			$.ajax({
					type: "POST",
					url: "/sfa/safeAdmin/log/Deletepaper.do?${_csrf.parameterName}=${_csrf.token}",
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


function seletAll(){
	if($("#cbx_chkAll").is(":checked")) $("input[name=chk]").prop("checked", true);
	else $("input[name=chk]").prop("checked", false);
}
// function senddata(){
	
// 	$.ajax({
// 		type: "POST",
// 		url: "/dyAdmin/bills/log/controller.do",
// 		async: false,
// 		data: $('#Form').serializeArray(),
// 		success : function(data){
// 			alert(data);
			
// 		}, 
// 		error: function(){
			
// 		}
// }); 
	
// }

</script>
