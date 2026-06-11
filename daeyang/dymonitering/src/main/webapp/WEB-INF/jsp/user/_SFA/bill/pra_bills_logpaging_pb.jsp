<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<div class="flex justify-between">
<div class="flex">
    <input type="text" class="search-control" name="field_search" data-searchindex="all" placeholder="모든필드 검색"
      style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px">
    <button type="button"  onclick="pf_LinkPage();"
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
        <table class="pagingTable whitespace-nowrap">
          <thead class="text-xs font-semibold tracking-wide text-left text-gray-500 uppercase border-b bg-gray-50">
            <tr class="font-bold text-black">
              <td class="px-4 py-3 text-center">
                <input type="checkbox" id="cbx_chkAll" onclick="seletAll()" class="mt-2">
              </td>
              <td class="px-4 py-3 text-center">
                <input type="text" data-searchindex="1"
                  class="default_input_style input_margin_x_10px input_padding_y_4px search-control" 
                  placeholder="번호(으)로 검색">
                <div class="text-center mt-2">
                <a class="arrow" href="#" data-index="1" style="cursor: pointer;">
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
                <input type="text" data-searchindex="2"
                  class="search-control default_input_style input_margin_x_10px input_padding_y_4px"
                  placeholder="공급자명(으)로 검색" >
                <div class="text-center mt-2">
                  <div class="text-center mt-2">
                    <a>공급자명
                    </a>
                  </div>
                </div>
              </td>
              <td class="px-4 py-3 text-center text-xs">
                <input type="text" data-searchindex="3"
                  class="search-control default_input_style input_margin_x_10px input_padding_y_4px"
                  placeholder="공급받는자명(으)로 검색" >
                <div class="text-center mt-2">
                  <a>공급받는자명
                  </a>
                </div>
              </td>
              <td class="px-4 py-3 text-center text-xs">
                <input type="text" data-searchindex="4"
                  class="search-control default_input_style input_margin_x_10px input_padding_y_4px"
                  placeholder="품목명(으)로 검색" >
                <div class="text-center mt-2">
                  <a>품목명
                  </a>
                </div>
              </td>
              <td class="px-4 py-3 text-center text-xs">
                <input type="text" data-searchindex="5"
                  class="default_input_style input_margin_x_10px input_padding_y_4px search-control"
                  placeholder="합계금액(으)로 검색" value="">
                <div class="text-center mt-2">
                  <a>합계금액
                  </a>
                </div>
              </td>
              <td class="px-4 py-3 text-center text-xs">
                <input type="date" data-searchindex="6"
                  class="default_input_style input_margin_x_10px input_padding_y_4px search-control"
                  value="Invalid date">
                <div class="text-center mt-2">
                  <a class="arrow" data-index="6" style="cursor: pointer;">등록날짜
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
                <select name="status_eq" onchange="pf_LinkPage();"
                  class="default_input_style input_margin_x_10px input_padding_y_4px search-control">
                  <option value="all">전체</option>
                  <option value="yes">전송 완료</option>
                  <option value="no">전송 실패</option>
                </select>
                <div class="text-center mt-2">
                  <a href="#">전송상태</a>
                </div>
              </td>
            </tr>

          </thead>
          <tbody class="bg-white divide-y text-gray-700">
          	<c:if test="${empty resultList4 }">
				<tr>
					<td colspan="100%">검색된 데이터가 없습니다.</td>
				</tr>
			</c:if>
			<c:forEach items="${resultList4 }" var="b">
	            <tr class="">
	              	<c:if test="${b.dbl_checkYN eq 'N' }">
					<td class="px-4 py-3 text-center"><input type="checkbox" name="chk" id ="chk" value = "${b.dbl_keyno}"></td>
					</c:if>
					<c:if test="${b.dbl_checkYN eq 'W' }">
					<td class="px-4 py-3 text-center"><input type="checkbox" name="" id ="" value = "${b.dbl_keyno}" disabled></td>
					</c:if>                         						
					<c:if test="${b.dbl_checkYN eq 'Y' }">
					<td class="px-4 py-3 text-center"><input type="checkbox" name="" id ="" value = "${b.dbl_keyno}" disabled></td>
					</c:if>
					<td class="px-4 py-3 text-center"><span class="text-sm">${b.COUNT}</span></td>
					<td class="px-4 py-3 text-center"><a href="javascript:;" onclick="taxpopup('${b.dbl_keyno}');" id="listtable" name ="listtable" style="cursor: pointer;""><span class="text-sm">${b.dbl_p_name}</span></a></td>
					<td class="px-4 py-3 text-center"><span class="text-sm">${b.dbl_s_name}</span></td>
					<td class="px-4 py-3 text-center"><span class="text-sm">${b.dbl_subject}</span></td>
					<td class="px-4 py-3 text-center"><span class="text-sm">${b.dbl_grandtotal}</span></td>
					<td class="px-4 py-3 text-center"><span class="text-sm">${b.dbl_issuedate}</span></td>
					<c:if test="${b.dbl_status eq '1' }">
					<td class="px-4 py-3 text-center">
					<span class="text-sm">전송준비</span></td>
					</c:if>
					<c:if test="${b.dbl_status eq '2' }">
					<td class="px-4 py-3 text-center" style="color: #3333FF">
					<span class="text-sm">전송대기</span></td>
					</c:if>                      						
					<c:if test="${b.dbl_status eq '0' }">
					<td  class="px-4 py-3 text-center"style="color: #00CC66">
					<span class="text-sm">전송완료</span></td>
					</c:if>
					<c:if test="${b.dbl_status eq '-1' }">
						<td class="px-4 py-3 text-center"><a href="javascript:;" onclick="logAlarm('${b.dbl_keyno}');" style="color: #FF0000">
						<span class="text-sm">전송실패</span></a></td>
					</c:if>
	            </tr>
      		</c:forEach>
          </tbody>
        </table>
      </form>
    </div>
  <div class="px-4 py-3 border-t bg-gray-50 text-gray-500">
    <div class="flex flex-col justify-between text-xs sm:flex-row text-gray-600">
  	<c:if test="${not empty resultList4 }">
      <span class="pagetext flex items-center font-semibold tracking-wide uppercase">총 ${paginationInfo.totalRecordCount }건  / 총 ${paginationInfo.totalPageCount} 페이지 중 ${paginationInfo.currentPageNo} 페이지</span>
      <div class="flex mt-2 sm:mt-auto sm:justify-end">
        <nav aria-label="페이지">
          <ul class="pageNumberUl inline-flex items-center">
<!--             <li> -->
<!--               <button -->
<!--                 class="align-bottom inline-flex items-center justify-center cursor-pointer leading-5 transition-colors duration-150 font-medium focus:outline-none p-2 rounded-md text-gray-600 focus:outline-none border border-transparent opacity-50 cursor-not-allowed" -->
<!--                 disabled="" type="button" aria-label="Previous"> -->
<!--                 <svg class="h-3 w-3" aria-hidden="true" fill="currentColor" viewBox="0 0 20 20"> -->
<!--                   <path -->
<!--                     d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" -->
<!--                     clip-rule="evenodd" fill-rule="evenodd"></path> -->
<!--                 </svg> -->
<!--               </button> -->
<!--             </li> -->
            <button class="align-bottom inline-flex items-center justify-center cursor-pointer leading-5 transition-colors duration-150 font-medium focus:outline-none px-3 py-1 rounded-md text-xs text-white bg-indigo-600 border border-transparent active:bg-indigo-600 hover:bg-indigo-700 focus:ring focus:ring-gray-300" type="button">
                <ui:pagination paginationInfo="${paginationInfo }" type="normal_board" jsFunction="pf_LinkPage"/>
            </button>
<!--             <li> -->
<!--               <button -->
<!--                 class="align-bottom inline-flex items-center justify-center cursor-pointer leading-5 transition-colors duration-150 font-medium focus:outline-none p-2 rounded-md text-gray-600 focus:outline-none border border-transparent opacity-50 cursor-not-allowed" -->
<!--                 disabled="" type="button" aria-label="Next"> -->
<!--                 <svg class="h-3 w-3" aria-hidden="true" fill="currentColor" viewBox="0 0 20 20"> -->
<!--                   <path -->
<!--                     d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" -->
<!--                     clip-rule="evenodd" fill-rule="evenodd"></path> -->
<!--                 </svg> -->
<!--               </button> -->
<!--             </li> -->
          </ul>
        </nav>
      </div>
    </c:if>
    <c:if test="${empty resultList4 }">
    	<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
		<span class="font-semibold text-sm md:text-sm lg:text-base my-5">0건 중 0~0번째 결과(총  ${paginationInfo.totalRecordCount }건중 매칭된 데이터)</span>
		</div>
    </c:if>
    </div>
  </div>
</div>
  

<script type="text/javascript">

$(function(){

	pf_defaultPagingSetting('${search.orderBy}','${search.sortDirect}');

})


function taxpopup(value){

	var left = Math.ceil((window.screen.width - 1000)/2);
	var top = Math.ceil((window.screen.height - 820)/2);
	var popOpen	= window.open("/dyAdmin/bills/log/controller2.do?listtable="+value, "Taxpopup","width=1200px,height=900px,top="+top+",left="+left+",status=0,toolbar=0,menubar=0,location=false,scrollbars=yes");
	popOpen.focus();
}

function logAlarm(keyno){
	$.ajax({
		url: '/dyAdmin/bills/sendingAjax2.do?${_csrf.parameterName}=${_csrf.token}',
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

</script>
