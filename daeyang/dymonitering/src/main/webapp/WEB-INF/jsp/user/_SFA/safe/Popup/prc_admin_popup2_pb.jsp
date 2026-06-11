<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<script src="/resources/common/js/html2canvas.js"></script>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">

    <title>대양 안전관리 시스템</title>
    <meta name="description" content="DAEYANG DASHBOARD">
    <meta property="og:title" content="대양 안전관리 시스템">
    <meta property="og:description" content="DAEYANG DASHBOARD">
    <meta property="og:locale" content="kr">
    <meta property="og:site_name" content="DAEYANG">

    <link rel="stylesheet" type="text/css" href="/resources/publish/_SFA/css/common.css">
<!--     <script src="https://code.jquery.com/jquery-3.5.0.js"></script> -->
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
	
    
<script type="text/javascript" src="/resources/publish/_SFA/js/common.js"></script>
</head>
<body>

<form:form id="Form" name="Form" method="post">
<main id="esco" class="h-full overflow-y-auto ">
  <div class="container grid px-6 mx-auto">
    <div class="relative">
      <div class="px-3 py-1 md:px-3 md:py-1 lg:px-5 lg:py-2 w-full rounded-lg bg-white my-4 md:md-4 lg:my-7">
      </div>
        <div class="w-full rounded-lg bg-white my-4 md:md-4 lg:my-7">
          <div class="w-full">
<%-- 	    	<button type="button" onclick="popup('${list.sa2_keyno}')" style="width:120px;" class="mx-3 text-xs font-semibold items-center w-16 py-2 border border-transparent rounded text-white bg-black flex-shrink-0 mb-2">수정페이지 이동</button> --%>
	    	<button type="button" onclick="ClosePopup()" style="width:120px;" class="mx-3 text-xs font-semibold items-center w-16 py-2 border border-transparent rounded text-white bg-black flex-shrink-0 mb-2">닫기</button>
          </div>
          <div class="px-5 text-bold text-sm md:text-sm lg:text-base my-2.5">
            <div class="flex items-center ">
              <span class="mr-3">점검표:</span>
              <span class="text-active-blue">
              <input type="text"  name="sa2_title" id="sa2_title" value="${list.sa2_title }" class="w-full border-none text-xs" style="text-align: center;" readonly="readonly">
              </span>
            </div>
          </div>
          <div class="w-full border">

          </div>
          <div class="px-3 py-1 md:px-3 md:py-1 lg:px-5 lg:py-2.5 text-bold text-xs">
            <div class="flex items-center ">
              <div class="w-60">
                <p class="py-1 px-2 justify-center rounded-full text-white bg-active-green flex items-center" style="max-width: fit-content;">
                  <span class="p-1 rounded-full mr-2 p-1 bg-white" style="font-size: 0px;">
                  </span>
                  	<input type="text" name="sa2_date" id="sa2_date" value="${list.sa2_date }" class="w-full border-none text-xs bg-active-green" readonly="readonly">
                </p>
              </div>
              <div class="mx-3">
                <label for="">날씨:</label>
                	<input type="text" name="sa2_wether" id="sa2_wether" value="${list.sa2_wether }" class="w-full border-none text-xs" readonly="readonly">
              </div>
              <div class="">
                <label for="">점검자:</label>
                <input type="text" name="sa2_adminname" id="sa2_adminname" value="${list.sa2_adminname }" class="w-full border-none text-xs" readonly="readonly">
              </div>
            </div>
          </div>
          <div class="w-full border">
          </div>
          <div class="w-full overflow-hidden rounded-lg ring-1 ring-black ring-opacity-5 border-b border-black" style="border-radius: 0px;">
            <div class="w-full overflow-x-auto">
              <table class="w-full whitespace-nowrap">
                <thead class="text-xs font-semibold tracking-wide text-left text-gray-500 uppercase border-b bg-gray-50">
                </thead>
                
                <!-- ----------------------------------------인버터 정보 tbody ------------------------------------------------ -->
                
                <tbody class="esco bg-white divide-y text-gray-700 text-xs">
                  <tr class="">
                    <td class="tg-0lax px-4 py-3 text-black text-center bg-table-violet text-sm md:text-sm lg:text-base font-bold" colspan="100%">*인버터발전현황</td>
                  </tr>
                  <tr id = "inputplus0" class="">
                    <td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width: 19rem; max-width: 25rem; width: 20rem; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      인버터 번호</td>
                    <td class="tg-0lax px-4 py-3" style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" name="inverternumber" id="inverternumber" value="" class="w-full border-none text-xs">
                    </td>
                  </tr>
                  <tr id = "inputplus1" class="">
                    <td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width: 19rem; max-width: 25rem; width: 20rem; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      현재 출력</td>
                    <td class="la2 px-4 py-3" style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" value="" name="sa2_nowpower" id="sa2_nowpower" class="w-full border-none text-xs">
                      <input type="hidden" value="" name="sa2_nowpower1" id="sa2_nowpower1" class="w-full border-none text-xs">
                    </td>
                  </tr>
                  <tr id = "inputplus2" class="">
                    <td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width: 19rem; max-width: 25rem; width: 20rem; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      금일 발전량[kwh]</td>
                    <td class="la3 px-4 py-3" style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" value="" name="sa2_todaypower" id="sa2_todaypower" class="w-full border-none text-xs">
                      <input type="hidden" value="" name="sa2_todaypower1" id="sa2_todaypower1" class="w-full border-none text-xs">
                    </td>
                  </tr>
                  <tr id = "inputplus3" class="">
                    <td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width: 19rem; max-width: 25rem; width: 20rem; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding-top: 0.5rem; padding-bottom: 0.5rem;">
                      누적 발전량<select name="sa2_accpowertype" id="sa2_accpowertype" style="padding-top: 0px; padding-bottom: 0px; background-color: rgb(240, 242, 245); border: none; border-radius: 4px; margin-left: 10px; margin-right: 10px; font-size: 12px;">
                        <option value="KWh">kwh</option>
                        <option value="MWh">Mwh</option>
                      </select>
                    </td>
                    <td class="la4 px-4 py-3" style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" name="sa2_accpower" id="sa2_accpower" class="w-full border-none text-xs">
                      <input type="hidden" name="sa2_accpower1" id="sa2_accpower1" class="w-full border-none text-xs">
                    </td>
                  </tr>
                  <tr id = "inputplus4" class="">
                    <td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width: 19rem; max-width: 25rem; width: 20rem; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding-top: 0.5rem; padding-bottom: 0.5rem;">
                      기간 발전량<select name="sa2_periodpowertype" id="sa2_periodpowertype" style="padding-top: 0px; padding-bottom: 0px; background-color: rgb(240, 242, 245); border: none; border-radius: 4px; margin-left: 10px; margin-right: 10px; font-size: 12px;">
                        <option value="KWh">kwh</option>
                        <option value="MWh">kwh</option>
                      </select>
                    </td>
                    <td class="la5 px-4 py-3" style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" name="sa2_periodpower" id="sa2_periodpower" class="w-full border-none text-xs">
                      <input type="hidden" name="sa2_periodpower1" id="sa2_periodpower1" class="w-full border-none text-xs">
                    </td>
                  </tr>
                  
		 <!-- ----------------------------------------인버터대수 10대이상 부터 tbody 추가------------------------------------------------ -->
                  
                  <tr id = "inputplus5" class="hiddenTr">
                    <td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width: 19rem; max-width: 25rem; width: 20rem; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      인버터 번호</td>
                    <td class="tg-0lax px-4 py-3" style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" name="inverternumber" id="inverternumber" value="" class="w-full border-none text-xs">
                    </td>
                  </tr>
                  <tr id = "inputplus6" class="hiddenTr">
                    <td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width: 19rem; max-width: 25rem; width: 20rem; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      현재 출력</td>
                    <td class="tg-0lax px-4 py-3" style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" value="" name="sa2_nowpower" id="sa2_nowpower" class="w-full border-none text-xs">
                      <input type="hidden" value="" name="sa2_nowpower1" id="sa2_nowpower1" class="w-full border-none text-xs">
                    </td>
                  </tr>
                  <tr id = "inputplus7" class="hiddenTr">
                    <td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width: 19rem; max-width: 25rem; width: 20rem; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      금일 발전량[kwh]</td>
                    <td class="tg-0lax px-4 py-3" style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" value="" name="sa2_todaypower" id="sa2_todaypower" class="w-full border-none text-xs">
                      <input type="hidden" value="" name="sa2_todaypower1" id="sa2_todaypower1" class="w-full border-none text-xs">
                    </td>
                  </tr>
                  <tr id = "inputplus8" class="hiddenTr">
                    <td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width: 19rem; max-width: 25rem; width: 20rem; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding-top: 0.5rem; padding-bottom: 0.5rem;">
                      누적 발전량<select name="sa2_accpowertype" id="sa2_accpowertype" style="padding-top: 0px; padding-bottom: 0px; background-color: rgb(240, 242, 245); border: none; border-radius: 4px; margin-left: 10px; margin-right: 10px; font-size: 12px;">
                        <option value="KWh">kwh</option>
                        <option value="MWh">Mwh</option>
                      </select>
                    </td>
                    <td class="tg-0lax px-4 py-3" style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" name="sa2_accpower" id="sa2_accpower" class="w-full border-none text-xs">
                      <input type="hidden" name="sa2_accpower1" id="sa2_accpower1" class="w-full border-none text-xs">
                    </td>
                  </tr>
                  <tr id = "inputplus9" class="hiddenTr">
                    <td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width: 19rem; max-width: 25rem; width: 20rem; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding-top: 0.5rem; padding-bottom: 0.5rem;">
                      기간 발전량<select name="sa2_periodpowertype" id="sa2_periodpowertype" style="padding-top: 0px; padding-bottom: 0px; background-color: rgb(240, 242, 245); border: none; border-radius: 4px; margin-left: 10px; margin-right: 10px; font-size: 12px;">
                        <option value="KWh">kwh</option>
                        <option value="MWh">kwh</option>
                      </select>
                    </td>
                    <td class="tg-0lax px-4 py-3" style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" name="sa2_periodpower" id="sa2_periodpower" class="w-full border-none text-xs">
                      <input type="hidden" name="sa2_periodpower1" id="sa2_periodpower1" class="w-full border-none text-xs">
                    </td>
                  </tr>      
               <!-- ---------------------------------------- tbody 추가 끝 ------------------------------------------------ -->                            
                </tbody>
              </table>
            </div>
          </div>
          <div class="w-full overflow-hidden rounded-lg ring-1 ring-black ring-opacity-5 border-b border-t border-black" style="border-radius: 0px;">
            <div class="w-full overflow-x-auto">
              <table class="w-full whitespace-nowrap">
                <tbody class="esco bg-white divide-y text-gray-700 text-xs font-semibold" data-html2canvas-ignore="true">
                  <tr class="etcTr" data-html2canvas-ignore="true">
                    <td class="tg-0lax px-4 py-3" colspan="1" rowspan="3" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      AC전압 [V]</td>
            		<c:if test="${list.sa2_AC_Change eq '02' }">
                    	<td class="SunAC1 tg-0lax px-4 py-3" colspan="1" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      	L1 - N</td>
                     </c:if>
            		<c:if test="${list.sa2_AC_Change eq '01' }">
                    	<td class="SunAC1 tg-0lax px-4 py-3" colspan="1" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      	L1 - L2</td>
                     </c:if>
                    <td class="tg-0lax px-4 py-3  " colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                    <label id="sa2_label5">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
                      		value="${list.sa2_ACVL1_N }" readonly="readonly"
							name="sa2_ACVL1_N" id="sa2_ACVL1_N" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </label>
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="1" rowspan="3" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      AC전류 [A]</td>
                    <td class="tg-0lax px-4 py-3" colspan="1" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      L1</td>
                    <td class="tg-0lax px-4 py-3  " colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                     <label id="sa2_label6">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							value="${list.sa2_ACAL1 }" readonly="readonly"
							name="sa2_ACAL1" id="sa2_ACAL1" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                     </label>
                    </td>
                  </tr>
                  <tr class="etcTr">
                  <c:if test="${list.sa2_AC_Change eq '02' }">
                   	 <td class="SunAC2 tg-0lax px-4 py-3" colspan="1" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      L2 - N</td>
                  </c:if>
                  <c:if test="${list.sa2_AC_Change eq '01' }">
                   	 <td class="SunAC2 tg-0lax px-4 py-3" colspan="1" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      L2 - L3</td>
                  </c:if>
                    <td class="tg-0lax px-4 py-3  " colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                     <label id="sa2_label7">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							value="${list.sa2_ACVL2_N }" readonly="readonly"
							name="sa2_ACVL2_N" id="sa2_ACVL2_N" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
					 </label>                  
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="1" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      L2</td>
                    <td class="tg-0lax px-4 py-3  " colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <label id="sa2_label8">
                       <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							value="${list.sa2_ACAL2 }" readonly="readonly"
							name="sa2_ACAL2" id="sa2_ACAL2" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                      </label>
                    </td>
                  </tr>
                  <tr class="etcTr">
                  <c:if test="${list.sa2_AC_Change eq '02' }">
                    <td class="SunAC3 tg-0lax px-4 py-3" colspan="1" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      L3 - N</td>
				  </c:if>
                  <c:if test="${list.sa2_AC_Change eq '01' }">
                    <td class="SunAC3 tg-0lax px-4 py-3" colspan="1" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      L3 - L1</td>
				  </c:if>
                    <td class="tg-0lax px-4 py-3  " colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                     <label id="sa2_label9">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							value="${list.sa2_ACVL3_N }" readonly="readonly"
							name="sa2_ACVL3_N" id="sa2_ACVL3_N" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                     </label>
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="1" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      L3</td>
                    <td class="tg-0lax px-4 py-3  " colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <label id="sa2_label10">
                       <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							value="${list.sa2_ACAL3 }" readonly="readonly"
							name="sa2_ACAL3" id="sa2_ACAL3" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                      </label>
                    </td>
                  </tr>
                  <tr class="">
                    <td class="px-4 py-3 bg-table-violet" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      발전소 용량 [KW]</td>
                    <td class="px-4 py-3 bg-table-violet" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      발전전압 [KW]</td>
                    <td class="px-4 py-3 bg-table-violet" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      CT비 [배]</td>
                    <td class="px-4 py-3 bg-table-violet" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      검침일</td>
                  </tr>
                  <tr class="">
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							value="${list.sa2_palntKW }" readonly="readonly" name="sa2_palntKW" id="sa2_palntKW" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							value="${list.sa2_palntV }" readonly="readonly" name="sa2_palntV" id="sa2_palntV" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							value="${list.sa2_palntCT }" readonly="readonly" name="sa2_palntCT" id="sa2_palntCT" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" value="${list.sa2_date2 }" readonly="readonly" name="sa2_date2" id="sa2_date2" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                  </tr>
                  <tr class="">
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      전월 누적 송전 유효전력량[kwh] - 전체</td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" readonly="readonly" value="${list.sa2_meternum1 }"
						name="sa2_meternum1" id="sa2_meternum1" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="1" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" class="w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3  " colspan="3" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							onkeyup="Divison(this.value)"
							value="${list.sa2_meter1KWh }"
							name="sa2_meter1KWh" id="sa2_meter1KWh" readonly="readonly" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                  </tr>
                  <tr class="">
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      현재 누적 송전 유효전력량[kwh] - 전체</td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" readonly="readonly" value="${list.sa2_meternum2 }"
						name="sa2_meternum2" id="sa2_meternum2" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="1" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3  " colspan="3" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							value="${list.sa2_meter2KWh }" readonly="readonly"
							name="sa2_meter2KWh" id="sa2_meter2KWh" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                  </tr>
                  <tr class="">
                    <td class="tg-0lax px-4 py-3 bg-table-violet" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      검침 대상</td>
                    <td class="tg-0lax px-4 py-3 bg-table-violet" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" readonly="readonly" value="${list.changenum }"
						name="changenum" id="changenum" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3 bg-table-violet" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" readonly="readonly" value="${list.changenum2 }"
						name="changenum2" id="changenum2" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3 bg-table-violet" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      인버터 데이터</td>
                  </tr>
                  <tr class="">
                    <td class="tg-0lax px-4 py-3 bg-table-violet" colspan="1" rowspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      *검침 주기</td>
                    <td class="tg-0lax px-4 py-3 bg-table-violet" colspan="1" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      기간</td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" readonly="readonly" value="${list.sa2_meter1period }" name="sa2_meter1period" id="sa2_meter1period" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" readonly="readonly" value="${list.sa2_meter2period }" name="sa2_meter2period" id="sa2_meter2period" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" readonly="readonly" value="${list.sa2_inverterperiod }" name="sa2_inverterperiod" id="sa2_inverterperiod" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                  </tr>
                  <tr class="">
                    <td class="tg-0lax px-4 py-3 bg-table-violet" colspan="1" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      일</td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" readonly="readonly" value="${list.sa2_meter1date }" name="sa2_meter1date" id="sa2_meter1date" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" readonly="readonly" value="${list.sa2_meter2date }" name="sa2_meter2date" id="sa2_meter2date" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" readonly="readonly" value="${list.sa2_inverterdate }" name="sa2_inverterdate" id="sa2_inverterdate" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                  </tr>
                  <tr class="">
                    <td class="tg-0lax px-4 py-3 bg-table-violet" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      총발전량[kwh]</td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							readonly="readonly" value="${list.sa2_meter1allKWh }" name="sa2_meter1allKWh" id="sa2_meter1allKWh" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0laxpx-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							readonly="readonly" value="${list.sa2_meter2allKWh }" name="sa2_meter2allKWh" id="sa2_meter2allKWh" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							readonly="readonly" value="${list.sa2_inverterallKWh }" name="sa2_inverterallKWh" id="sa2_inverterallKWh" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                  </tr>
                  <tr class="">
                    <td class="tg-0lax px-4 py-3 bg-table-violet" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      1일평균 발전량[kwh/day]</td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							readonly="readonly" value="${list.sa2_meter1dayKWh }" name="sa2_meter1dayKWh" id="sa2_meter1dayKWh" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							readonly="readonly" value="${list.sa2_meter2dayKWh }" name="sa2_meter2dayKWh" id="sa2_meter2dayKWh" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							readonly="readonly" value="${list.sa2_inverterdayKWh }" name="sa2_inverterdayKWh" id="sa2_inverterdayKWh" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                  </tr>
                  <tr class="">
                    <td class="tg-0lax px-4 py-3 bg-table-violet" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      1일평균 발전시간[hour/day]</td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							readonly="readonly" value="${list.sa2_meter1dayhour }" name="sa2_meter1dayhour" id="sa2_meter1dayhour" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							readonly="readonly" value="${list.sa2_meter2dayhour }" name="sa2_meter2dayhour" id="sa2_meter2dayhour" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							readonly="readonly" value="${list.sa2_inverterdayhour }" name="sa2_inverterdayhour" id="sa2_inverterdayhour" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
          <div class="w-full border">

          </div>
          <div class="flex items-center px-4 py-5 text-xs">
            <span class="tg-0laxfont-medium">• 점검자 확인사항</span>           
          </div>
          <div class="w-full border">
			<tr class="esco">
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <textarea rows="5" readonly="readonly" name="sa2_opinion" id="sa2_opinion" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">${list.sa2_opinion }</textarea>
                    </td> 
                  </tr>
          </div>
        </div>
        <div class="w-full rounded-lg bg-white my-4 md:md-4 lg:my-7 px-6 py-2">
          <div class="flex">
            <span class="py-4">*발전소 이상 유무 선택</span>
            <div class="border-r border-gray-300 mx-5">
            </div>
           	<c:if test="${list.sa2_problem eq '1'}">
            <span class="py-4">
              <label class="text-active-green" for="problem">이상 있음</label>
              <input type="radio" name="sa2_problem" id="sa2_problem" value="1" class="ml-3 mr-5" checked>
              <label class="text-gray-400" for="safe">이상 없음</label>
              <input type="radio" name="sa2_problem" id="sa2_problem" value="2" class="ml-3 mr-5" disabled>
              </span>
             </c:if>
             <c:if test="${list.sa2_problem eq '2'}">
             <span class="py-4">
              <label class="text-buttonText-red" for="problem">이상 있음</label>
              <input type="radio" name="sa2_problem" id="sa2_problem" value="1" class="ml-3 mr-5" disabled>
              <label class="text-active-green" for="safe">이상 없음</label>
              <input type="radio" name="sa2_problem" id="sa2_problem" value="2" class="ml-3 mr-5" checked>
             </span>
             </c:if>
            
          </div>
        </div>
        <input type="hidden" id="buttionType" name="buttionType" value="insert">
		<input type="hidden" id="sa2_keyno" name="sa2_keyno" value="">
		<input type="hidden" id="sa2_inverternumtype" name="sa2_inverternumtype" value="${num}">
		<input type="hidden" id="sa2_todaypowertype" name="sa2_todaypowertype" value="${list.sa2_todaypowertype}">
		<input type="hidden" id="sa2_accpowertype" name="sa2_accpowertype" value="${list.sa2_accpowertype}">
		<input type="hidden" id="sa2_periodpowertype" name="sa2_periodpowertype" value="${list.sa2_periodpowertype}">
		<input type="hidden" id="sa_writetype" name="sa_writetype" value="2">
		<input type="hidden" id="SU_KEYNO" name="SU_KEYNO" value="">
		<input type="hidden" id="imgSrc" name="imgSrc" value="">
		<input type="hidden" id="predataMeter1" name="predataMeter1" value="">
		<input type="hidden" id="predataMeter2" name="predataMeter2" value="">
		<input type="hidden" id="prewatt" name="prewatt" value="">
		<input type="hidden" id="sa2_LR" name="sa2_LR" value="${list.sa2_LR}">
    </div>
  </div>
</main>
</form:form>
<script type="text/javascript">

$(function() {
	
	inverterNumber()
	
});

function loadInfo(){
	
	 $.ajax({
        url: '/sfa/safe/safepaperInsert.do?${_csrf.parameterName}=${_csrf.token}',
        type: 'POST',
        data: $("#Form").serialize(),
        async: false,  
        success: function(result) {
        	location.reload();
        	alert(result);
        },
        error: function(){
        	alert("저장 에러");
        }
	}); 
}

function changesulbi(keyno) {
	
	$.ajax({
        url: '/sfa/safe/safeuserselect.do?${_csrf.parameterName}=${_csrf.token}',
        type: 'POST',
        data: {
			SU_KEYNO : keyno
		},
        async: false,  
        success: function(result) {
        	console.log(result.SU_SA_SUJEONV);
        	$("#sa_sujeonv").val(result.SU_SA_SUJEONV)
        	$("#sa_sujeonkw").val(result.SU_SA_SUJEONKW)
        	$("#sa_balv").val(result.SU_SA_BALV)
        	$("#sa_balkw").val(result.SU_SA_BALKW)
        	$("#sa_solarv").val(result.SU_SA_SOLARV)
        	$("#sa_solarkw").val(result.SU_SA_SOLARKW)
        	$("#sa_transvolum").val(result.SU_SA_TRANSVOLUM)
        	$("#sa_admintype").val(result.SU_SA_ADMINTYPE)
        	$("#sa_admincount").val(result.SU_SA_ADMINCOUNT)
        },
        error: function(){
        	alert("저장 에러");
        }
	}); 
}

function print_p(){
	
    var initBody = document.body.innerHTML;
    window.onbeforeprint = function(){
        document.body.innerHTML = document.getElementById('field').innerHTML;
    }  
    window.onafterprint = function(){
        document.body.innerHTML = initBody;
    }
    window.print();
}

function popup(value){
	
	var num = Number($("#sa2_inverternumtype").val())
	
	var left = Math.ceil((window.screen.width - 1000)/2);
	var top = Math.ceil((window.screen.height - 820)/2);
	var popOpen	= window.open("/sfa/safeAdmin/safeAdminUpdate.do?listtable="+value+"&num="+num, "Taxpopup","width=1200px,height=900px,top="+top+",left="+left+",status=0,toolbar=0,menubar=0,location=false,scrollbars=yes");
	popOpen.focus();
}

function ClosePopup(){
	window.close();
}


function inverterNumber(){
	
	
	var todaypowertype = "${list.sa2_todaypowertype}";
	var accpowertype = "${list.sa2_accpowertype}";
	var periodpowertype = "${list.sa2_periodpowertype}";
	var accpowertype2 = "${list.sa2_accpowertype2}";
	var preacctype = "${list.sa2_preacctype}";
	var preacctype2 = "${list.sa2_preacctype2}";
	
	if(!accpowertype2){
		accpowertype2 = "KWh";
	}
	if(!preacctype){		
		preacctype = "KWh";
	}
	if(!preacctype2){
		preacctype2 = "KWh";
		
	}
	
	var num = Number($("#sa2_inverternumtype").val())
	var LefLigt = $("#sa2_LR").val()
	
	if(LefLigt == "L"){
		LefLigt = "좌";
	}else if(LefLigt == "R"){
		LefLigt = "우";
	}
	
	
	var count = 1;

	//append 초기화
	$(".tgsfa0").remove();
	$(".tgsfa1").remove();
	$(".tgsfa2").remove();
	$(".tgsfa3").remove();
	$(".tgsfa4").remove();
	$(".tgsfa5").remove();
	$(".tgsfa6").remove();
	$(".tgsfa7").remove();
	$(".tgsfa8").remove();
	$(".tgsfa9").remove();

	
	if(num > 10){
		
		var annacc = "${list.sa2_annacc}";
		var preannacc = "${list.sa2_preannacc}";
		var peridev = "${list.sa2_peridev}";
		
		var annacclist = []
		var preannacclist = []
		var peridevlist = []

		annacclist = annacc ? annacc.split(",") : [0];
		preannacclist = preannacc ? preannacc.split(",") : [0];	
		peridevlist = peridev ? peridev.split(",") : [0];
		
		
		
		$(".etcTr").hide();
		$(".hiddenTr").show();
		$("#inputplus0").html('<td class="tg-0lax px-4 py-3 text-center font-semibold bg-table-violet" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">인버터 번호</td>')
		$("#inputplus1").html('<td class="tg-0lax px-4 py-3 text-center font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">연간 현재 누적[<input class="w-2\/12 font-semibold text-center" id="sa2_accpowertype" name = "sa2_accpowertype" value = '+accpowertype+' readonly="readonly">]</td>')
		$("#inputplus2").html('<td class="tg-0lax px-4 py-3 text-center font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">전회 누적[<input class="w-2\/12 font-semibold text-center" id="sa2_preacctype" name = "sa2_preacctype" value = '+preacctype+' readonly="readonly">]</td>')
		$("#inputplus3").html('<td class="tg-0lax px-4 py-3 text-center font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">기간 발전[KWh]</td>')
		$("#inputplus4").hide();
		$("#inputplus5").html('<td class="tg-0lax px-4 py-3 text-center font-semibold bg-table-violet" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">인버터 번호</td>')
		$("#inputplus6").html('<td class="tg-0lax px-4 py-3 text-center font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">연간 현재 누적[<input class="w-2\/12 font-semibold text-center" id="sa2_accpowertype2" name = "sa2_accpowertype2" value = '+accpowertype2+' readonly="readonly">]</td>')
		$("#inputplus7").html('<td class="tg-0lax px-4 py-3 text-center font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">전회 누적[<input class="w-2\/12 font-semibold text-center" id="sa2_preacctype2" name = "sa2_preacctype2" value = '+preacctype2+' readonly="readonly">]</td>')
		$("#inputplus8").html('<td class="tg-0lax px-4 py-3 text-center font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">기간 발전[KWh]</td>')
		$("#inputplus9").hide();
		
		
		
   		for(var i=1; i<=num; i++){
   			
   			
   			if(count < 11){	
   				if(count == "1"){
	   				var conutt = count + 1
	   				$("#inputplus0").append('<td class="tg-0lax px-4 py-3 text-center bg-table-violet" style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">('+LefLigt+')'+count+'</td>')
	    			$("#inputplus1").append('<td class="tgsfa1 px-4 py-3 text-center  " style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" class="w-full border-none text-xs text-center focus:outline-none" value='+annacclist[i-1]+' name="sa2_annacc"  onkeyup="method_1(\'inputplus1\',\'inputplus2\',\'inputplus3\',\''+conutt+'\');" style="background-color:rgba( 255, 255, 255, 0 )"></td>')
	    			$("#inputplus2").append('<td class="tgsfa2 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" class="w-full border-none text-xs text-center focus:outline-none" value='+preannacclist[i-1]+' name="sa2_preannacc" oninput="inputNumberFormat(this) style="background-color:rgba( 255, 255, 255, 0 )" readonly="readonly"></td>')
	    			$("#inputplus3").append('<td class="tgsfa3 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" class="w-full border-none text-xs text-center focus:outline-none" value='+peridevlist[i-1]+' name="sa2_peridev" style="background-color:rgba( 255, 255, 255, 0 )" readonly="readonly"></td>')	
   				}else{
   					var conutt = count + 1
	   				$("#inputplus0").append('<td class="tg-0lax px-4 py-3 text-center bg-table-violet" style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">'+count+'</td>')
	    			$("#inputplus1").append('<td class="tgsfa1 px-4 py-3 text-center  " style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" class="w-full border-none text-xs text-center focus:outline-none" value='+annacclist[i-1]+' name="sa2_annacc"  onkeyup="method_1(\'inputplus1\',\'inputplus2\',\'inputplus3\',\''+conutt+'\');" style="background-color:rgba( 255, 255, 255, 0 )"></td>')
	    			$("#inputplus2").append('<td class="tgsfa2 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" class="w-full border-none text-xs text-center focus:outline-none" value='+preannacclist[i-1]+' name="sa2_preannacc" oninput="inputNumberFormat(this) style="background-color:rgba( 255, 255, 255, 0 )" readonly="readonly"></td>')
	    			$("#inputplus3").append('<td class="tgsfa3 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" class="w-full border-none text-xs text-center focus:outline-none" value='+peridevlist[i-1]+' name="sa2_peridev" style="background-color:rgba( 255, 255, 255, 0 )" readonly="readonly"></td>')	
   				}
       			
   			}else{
   				var conutt = count - 9
   				$("#inputplus5").append('<td class="tg-0lax px-4 py-3 text-center bg-table-violet" style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">'+count+'</td>')
    			$("#inputplus6").append('<td class="tgsfa6 px-4 py-3 text-center  " style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" class="w-full border-none text-xs text-center focus:outline-none" value='+annacclist[i-1]+' name="sa2_annacc" onkeyup="method_1(\'inputplus6\',\'inputplus7\',\'inputplus8\',\''+conutt+'\');" style="background-color:rgba( 255, 255, 255, 0 )"></td>')
    			$("#inputplus7").append('<td class="tgsfa7 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" class="w-full border-none text-xs text-center focus:outline-none" value='+preannacclist[i-1]+' name="sa2_preannacc" oninput="inputNumberFormat(this)" style="background-color:rgba( 255, 255, 255, 0 )" readonly="readonly"></td>')
    			$("#inputplus8").append('<td class="tgsfa8 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" class="w-full border-none text-xs text-center focus:outline-none" value='+peridevlist[i-1]+' name="sa2_peridev" style="background-color:rgba( 255, 255, 255, 0 )" readonly="readonly"></td>')

   			}
   			count += 1;
   			
   		}
   		
   			
   		
   			
	}else{
		
		var nowpower = "${list.sa2_nowpower}";
		var todaypower = "${list.sa2_todaypower}";
		var accpower = "${list.sa2_accpower}";
		var periodpower = "${list.sa2_periodpower}";

		var nowpowerlist = []
		var todaypowerlist = []
		var accpowerlist = []
		var periodpowerlist = []
		
		nowpowerlist = nowpower.split(",");
		todaypowerlist = todaypower.split(",");
		accpowerlist = accpower.split(",");
		periodpowerlist = periodpower.split(",")
		
		
		function EmptyValue(value) { 
			return value = value.map(function(item) {
	  			return item.trim() !== "" ? item : 0;
			});
		}
		
		nowpowerlist = EmptyValue(nowpowerlist);
		todaypowerlist = EmptyValue(todaypowerlist);
		accpowerlist = EmptyValue(accpowerlist);
		periodpowerlist = EmptyValue(periodpowerlist);	

		
		var conutt = count + 1
		
		
		$(".hiddenTr").hide();
		$(".etcTr").show();
		$("#inputplus4").show();
		
		if(num == "1"){
			$("#inputplus0").html('<td class="tg-0lax px-4 py-3 text-left font-semibold bg-table-violet" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">인버터 번호</td><td class="tg-0lax px-4 py-3 text-center bg-table-violet" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0">1</td>');
			$("#inputplus1").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">현재 출력[KWh]</td><td class="la2 px-4 py-3 text-center  " style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+nowpowerlist[0]+' name="sa2_nowpower" id="sa2_nowpower" readonly="readonly"></td>');
			$("#inputplus2").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">금일 발전량[KWh]</td><td class="la3 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+todaypowerlist[0]+' name="sa2_todaypower" id="sa2_todaypower" readonly="readonly"></td>');
			$("#inputplus3").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">누적 발전량[<input id="sa2_accpowertype" name="sa2_accpowertype" value="'+accpowertype+'" readonly="readonly" class="w-2\/12 font-semibold text-center">]</td><td class="la4 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+accpowerlist[0]+' name="sa2_accpower" readonly="readonly"></td>');
			$("#inputplus4").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">기간 발전량[KWh]</td><td class="la5 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+periodpowerlist[0]+' name="sa2_periodpower" readonly="readonly"></td>');
		}else{			
			$("#inputplus0").html('<td class="tg-0lax px-4 py-3 text-left font-semibold bg-table-violet" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">인버터 번호</td><td class="tg-0lax px-4 py-3 text-center bg-table-violet" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0">('+LefLigt+')1</td>');
			$("#inputplus1").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">현재 출력[KWh]</td><td class="la2 px-4 py-3 text-center  " style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+nowpowerlist[0]+' name="sa2_nowpower" id="sa2_nowpower" readonly="readonly"></td>');
			$("#inputplus2").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">금일 발전량[KWh]</td><td class="la3 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+todaypowerlist[0]+' name="sa2_todaypower" id="sa2_todaypower" readonly="readonly"></td>');
			$("#inputplus3").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">누적 발전량[<input id="sa2_accpowertype" name="sa2_accpowertype" value="'+accpowertype+'" readonly="readonly" class="w-2\/12 font-semibold text-center">]</td><td class="la4 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+accpowerlist[0]+' name="sa2_accpower" readonly="readonly"></td>');
			$("#inputplus4").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">기간 발전량[KWh]</td><td class="la5 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+periodpowerlist[0]+' name="sa2_periodpower" readonly="readonly"></td>');
		}
		
	
		for(var i=1; i<=num-1; i++){	
			
			//lanum을 다르게 해줘야 전회차정보 td어펜드시 인버터 번호에 맞는 정보가 들어감
			var lanum = count + 9;
			var lanum2 = count + 19;
			var lanum3 = count + 29;
			var lanum4 = count + 39;
			var conuttt = count + 2
			count += 1;
			$("#inputplus0").append('<td class="la1 px-4 py-3 text-center bg-table-violet" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0">'+count+'</td>')
			$("#inputplus1").append('<td class="la'+lanum+' px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+nowpowerlist[i]+' name="sa2_nowpower" readonly="readonly"></td>')
			$("#inputplus2").append('<td class="la'+lanum2+' px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+todaypowerlist[i]+' name="sa2_todaypower" readonly="readonly"></td>')
			$("#inputplus3").append('<td class="la'+lanum3+' px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+accpowerlist[i]+' name="sa2_accpower" readonly="readonly"></td>')
			$("#inputplus4").append('<td class="la'+lanum4+' px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+periodpowerlist[i]+' name="sa2_periodpower" readonly="readonly"></td>')
       					       			
   		
   			}	
			
// 		$("#sa2_nowpower").val(result.preData.sa2_nowpower)
//     	$("#sa2_todaypower").val(result.preData.sa2_todaypower)
//     	$("#sa2_accpower").val(result.preData.sa2_accpower)
//     	$("#sa2_periodpower").val(result.preData.sa2_periodpower)
	}
	
}

</script>
