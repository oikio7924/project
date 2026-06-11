<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<div class="flex justify-between">
 <div class="flex">
    <input type="text" class="search-control" name="field_search" data-searchindex="all" placeholder="모든필드 검색"
      style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px">
    <button type="button"  onclick="pf_LinkPage()"
      class="w3-button w3-black w3-round-large">검색</button>
  </div>
  <div class="flex">
  <button type="button" onclick="pf_excel()" class="w3-button w3-green w3-round-large">엑셀다운로드</button>
    <select name="pageUnit" id="pageUnit" onchange="pf_LinkPage();" class="default_input_style input_margin_x_10px input_padding_y_4px">
      	<option value="10" ${10 eq search.pageUnit ? 'selected' : '' }>10</option>
      	<option value="25" ${25 eq search.pageUnit ? 'selected' : '' }>25</option>
    	<option value="50" ${50 eq search.pageUnit ? 'selected' : '' }>50</option>
    	<option value="100" ${100 eq search.pageUnit ? 'selected' : '' }>100</option>
    	<option value="200" ${200 eq search.pageUnit ? 'selected' : '' }>200</option>
    	<option value="300" ${300 eq search.pageUnit ? 'selected' : '' }>300</option>
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
            <td class="px-4 py-3 text-center text-xs">
              <div class="text-center mt-2">
                <a>
                 	발전소명
                </a>
              </div>
            </td>
            <td class="px-4 py-3 text-center text-xs">
              <div class="text-center mt-2">
                <a>
                 	주소
                </a>
              </div>
            </td>
            <td class="px-4 py-3 text-center text-xs">
              <div class="text-center mt-2">
                <a class="arrow" data-index="1" style="cursor: pointer;">
                 	 발전사업만료일
	               	 <svg stroke="currentColor" fill="currentColor" stroke-width="0"
	                    viewBox="0 0 320 512" class="inline-flex" height="1em" width="1em"
	                    xmlns="http://www.w3.org/2000/svg">
	               	</svg>
				 <path
				  d="M41 288h238c21.4 0 32.1 25.9 17 41L177 448c-9.4 9.4-24.6 9.4-33.9 0L24 329c-15.1-15.1-4.4-41 17-41zm255-105L177 64c-9.4-9.4-24.6-9.4-33.9 0L24 183c-15.1 15.1-4.4 41 17 41h238c21.4 0 32.1-25.9 17-41z">
				</path>
                </a>
              </div>
            </td>
            <td class="px-4 py-3 text-center text-xs">
              <div class="text-center mt-2">
                <a class="arrow" data-index="2" style="cursor: pointer;">
                  	개발행위만료일
                  <svg stroke="currentColor" fill="currentColor" stroke-width="0"
                    viewBox="0 0 320 512" class="inline-flex" height="1em" width="1em"
                    xmlns="http://www.w3.org/2000/svg">                    
                  </svg>
                  <path
				  d="M41 288h238c21.4 0 32.1 25.9 17 41L177 448c-9.4 9.4-24.6 9.4-33.9 0L24 329c-15.1-15.1-4.4-41 17-41zm255-105L177 64c-9.4-9.4-24.6-9.4-33.9 0L24 183c-15.1 15.1-4.4 41 17 41h238c21.4 0 32.1-25.9 17-41z">
				</path>
                </a>
              </div>
            </td>
          </tr>

        </thead>
        <tbody class="bg-white divide-y text-gray-700">
        	<c:if test="${empty resultList4 }">
	        	<tr>
					<td class="px-4 py-3 text-center" colspan="100%">검색된 데이터가 없습니다.</td>
				</tr>
			</c:if>
			<c:forEach items="${resultList4 }" var="b"  varStatus="status">
	          <tr class="">
	          	<td class="px-4 py-3">	          	
	         		<input type="checkbox" name="chk" id ="chk" value = "${b.bd_plant_keyno}">
	          	</td>
	            <td class="py-3 text-left" style="white-space: nowrap; text-align: center; !important;">
	             	<span class="text-sm">${b.bd_plant_name }</span>
	            </td>
	        	<td class="py-3 text-left" style="white-space: nowrap;">
	             	<span class="text-sm">${b.bd_plant_add}</span>
	            </td>
	            <td class="py-3 text-left" style="white-space: nowrap; text-align: center; !important;">
	             	<span class="text-sm">${b.bd_plant_BusEndDate}</span>
	            </td>
	            <td class="py-3 text-left" style="white-space: nowrap; text-align: center; !important;">
	             	<span class="text-sm">${b.bd_plant_DevEndDate}</span>
	            </td>
	          </tr>
	         </c:forEach>
        </tbody>
      </table>
    </form>
  </div>
  <c:if test="${not empty resultList4 }">
  	<div><button class="text-sm md:text-sm lg:text-base font-bold inline-flex items-center px-4 py-2 md:px-4 md:py-2 lg:px-6 lg:py-3 border border-transparent rounded-lg text-white bg-button-blue" id="deleteButton"
			type="button" onclick="Delete_plant()" style="background-color: #E53935; margin-top: 1%;">삭제</button></div>
      <span class="pagetext flex items-center font-semibold tracking-wide uppercase">총 ${paginationInfo.totalRecordCount }건  / 총 ${paginationInfo.totalPageCount} 페이지 중 ${paginationInfo.currentPageNo} 페이지</span>
      <div class="flex mt-2 sm:mt-auto sm:justify-end">
        <nav aria-label="페이지">
          <ul class="pageNumberUl inline-flex items-center">
                <ui:pagination paginationInfo="${paginationInfo }" type="Manager" jsFunction="pf_LinkPage"/>
          </ul>
        </nav>
      </div>
    </c:if>
</div>
<input type="hidden" name ="areaSelect" id="hidden_Area" value="${areaSelect}">
<script type="text/javascript">
$(function(){

	pf_defaultPagingSetting('${search.orderBy}','${search.sortDirect}');

})

function copyText(vlaue) {
    var textElement = document.getElementById(vlaue);
	
    // 텍스트 선택 및 복사
    var range = document.createRange();
    range.selectNode(textElement);
    window.getSelection().removeAllRanges();
    window.getSelection().addRange(range);
    document.execCommand('copy');
    window.getSelection().removeAllRanges();
   
    console.log(textElement)

    alert("클립보드에 복사되었습니다.");
}

</script>
