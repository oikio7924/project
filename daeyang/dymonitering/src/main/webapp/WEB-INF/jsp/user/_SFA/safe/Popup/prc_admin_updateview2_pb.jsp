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
          <div class="w-full border">
<%-- 	    	<button type="button" onclick="popup('${list.sa_keyno }')" class="mx-3 text-xs font-semibold items-center w-16 py-2 border border-transparent rounded text-white bg-black flex-shrink-0 mb-2">수정페이지 이동</button> --%>
          </div>
          <div class="px-5 text-bold text-sm md:text-sm lg:text-base my-2.5">
            <div class="flex items-center ">
              <span class="mr-3">점검표:</span>
              <span class="text-active-blue">
              <input type="text"  name="sa2_title" id="sa2_title" value="${list.sa2_title }" class="w-full border-none text-xs" style="text-align: center;">
              </span>
            </div>
          </div>
          <div class="w-full border">

          </div>
          <div class="px-3 py-1 md:px-3 md:py-1 lg:px-5 lg:py-2.5 text-bold text-xs">
            <div class="flex items-center ">
              <div class="w-90">
                <p class="py-1 px-2 justify-center rounded-full text-white bg-active-green flex items-center" style="max-width: fit-content;">
                  <span class="p-1 rounded-full mr-2 p-1 bg-white" style="font-size: 0px;">
                  </span>
                  	<input type="hidden"
										name="sa2_date" id="sa2_date" value=""
										class="w-full border-none text-xs bg-active-green text-center"
										>
										<input type="text" oninput="changeDate()"
										name="sa2_dateY" id="sa2_dateY" value="${year}"
										class="w-full border-none text-xs bg-active-green text-center"
										>년
										<input type="text" oninput="changeDate()"
										name="sa2_dateM" id="sa2_dateM" value="${mon}"
										class="w-full border-none text-xs bg-active-green text-center"
										>월
										<input type="text" oninput="changeDate()"
										name="sa2_dateD" id="sa2_dateD" value="${day}"
										class="w-full border-none text-xs bg-active-green text-center"
										>일
										<input type="text"
										name="sa2_dateT" id="sa2_dateT" value="${time}"
										class="w-full border-none text-xs bg-active-green text-center"
										>시
										<input type="text"
										name="sa2_dateDow" id="sa2_dateDow" value="${dayOfWeek}"
										class="w-full border-none text-xs bg-active-green text-center"
										>요일
                </p>
              </div>
              <div class="mx-3">
                <label for="">날씨:</label>
                	<input type="text" name="sa2_wether" id="sa2_wether" value="${list.sa2_wether }" class="w-full border-none text-xs"  >
              </div>
              <div class="">
                <label for="">점검자:</label>
                <select name="sa2_adminname" id="sa2_adminname" class="default_input_style input_margin_x_10px input_padding_y_4px">
                  <option value="">관리자 선택</option>
                  <option value="이민환">이민환</option>
                  <option value="김용인">김용인</option>
                </select>
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
                      누적 발전량[kwh]</td>
                    <td class="la4 px-4 py-3" style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" name="sa2_accpower" id="sa2_accpower" class="w-full border-none text-xs">
                      <input type="hidden" name="sa2_accpower1" id="sa2_accpower1" class="w-full border-none text-xs">
                    </td>
                  </tr>
                  <tr id = "inputplus4" class="">
                    <td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width: 19rem; max-width: 25rem; width: 20rem; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding-top: 0.5rem; padding-bottom: 0.5rem;">
                      기간 발전량[kwh]</td>
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
                      누적 발전량[kwh]
                    </td>
                    <td class="tg-0lax px-4 py-3" style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" name="sa2_accpower" id="sa2_accpower" class="w-full border-none text-xs">
                      <input type="hidden" name="sa2_accpower1" id="sa2_accpower1" class="w-full border-none text-xs">
                    </td>
                  </tr>
                  <tr id = "inputplus9" class="hiddenTr">
                    <td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width: 19rem; max-width: 25rem; width: 20rem; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding-top: 0.5rem; padding-bottom: 0.5rem;">
                      기간 발전량[kwh]
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
                     <td rowspan="3" style="text-align: center;">
						<label class="AC_value" style="display: block;">선간전압<input type="radio" id="AC_sangsun" name="AC_sangsun"
							value="01" onchange="AC_Change(this.value)" checked></label>
						<label class="AC_value" style="display: block; margin-top: 20px;">상전압 <input type="radio" id="AC_sangsun" name="AC_sangsun"
							value="02" onchange="AC_Change(this.value)"></label>
					</td>
                    <td class="AC_cl1 tg-0lax px-4 py-3" colspan="1" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      L1 - N</td>
                    <td class="tg-0lax px-4 py-3  " colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                    <label id="sa2_label5">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
                      		value="${list.sa2_ACVL1_N }"  
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
							value="${list.sa2_ACAL1 }"  
							name="sa2_ACAL1" id="sa2_ACAL1" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                     </label>
                    </td>
                  </tr>
                  <tr class="etcTr">
                    <td class="AC_cl2 tg-0lax px-4 py-3" colspan="1" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      L2 - N</td>
                    <td class="tg-0lax px-4 py-3  " colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                     <label id="sa2_label7">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							value="${list.sa2_ACVL2_N }"  
							name="sa2_ACVL2_N" id="sa2_ACVL2_N" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
					 </label>                  
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="1" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      L2</td>
                    <td class="tg-0lax px-4 py-3  " colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <label id="sa2_label8">
                       <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							value="${list.sa2_ACAL2 }"  
							name="sa2_ACAL2" id="sa2_ACAL2" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                      </label>
                    </td>
                  </tr>
                  <tr class="etcTr">
                    <td class="AC_cl3 tg-0lax px-4 py-3" colspan="1" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      L3 - N</td>
                    <td class="tg-0lax px-4 py-3  " colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                     <label id="sa2_label9">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							value="${list.sa2_ACVL3_N }"  
							name="sa2_ACVL3_N" id="sa2_ACVL3_N" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                     </label>
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="1" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      L3</td>
                    <td class="tg-0lax px-4 py-3  " colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <label id="sa2_label10">
                       <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							value="${list.sa2_ACAL3 }"  
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
							value="${list.sa2_palntKW }"   name="sa2_palntKW" id="sa2_palntKW" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							value="${list.sa2_palntV }"   name="sa2_palntV" id="sa2_palntV" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							value="${list.sa2_palntCT }"   name="sa2_palntCT" id="sa2_palntCT" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" value="${list.sa2_date2 }"   name="sa2_date2" id="sa2_date2" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                  </tr>
                  <tr class="">
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      전월 누적 송전 유효전력량[kwh] - 전체</td>
                    <td class="tg-0lax px-4 py-3" colspan="3" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text"   value="${list.sa2_meternum1 }"
						name="sa2_meternum1" id="sa2_meternum1" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3  " colspan="3" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							onkeyup="Divison(this.value)" inputmode="numeric"
							value="${list.sa2_meter1KWh }"
							name="sa2_meter1KWh" id="sa2_meter1KWh"   class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                  </tr>
                  <tr class="">
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      현재 누적 송전 유효전력량[kwh] - 전체</td>
                    <td class="tg-0lax px-4 py-3" colspan="3" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text"   value="${list.sa2_meternum2 }" 
						name="sa2_meternum2" id="sa2_meternum2" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3  " colspan="3" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							onkeyup="Divison2(this.value)" inputmode="numeric"
							value="${list.sa2_meter2KWh }"  
							name="sa2_meter2KWh" id="sa2_meter2KWh" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                  </tr>
                  <tr class="">
                    <td class="tg-0lax px-4 py-3 bg-table-violet" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      검침 대상</td>
                    <td class="tg-0lax px-4 py-3 bg-table-violet" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text"   value="${list.changenum }"
						name="changenum" id="changenum" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3 bg-table-violet" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text"   value="${list.changenum2 }"
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
                      <input type="text"   value="${list.sa2_meter1period }" name="sa2_meter1period" id="sa2_meter1period" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text"   value="${list.sa2_meter2period }" name="sa2_meter2period" id="sa2_meter2period" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text"   value="${list.sa2_inverterperiod }" name="sa2_inverterperiod" id="sa2_inverterperiod" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                  </tr>
                  <tr class="">
                    <td class="tg-0lax px-4 py-3 bg-table-violet" colspan="1" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      일</td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text"   value="${list.sa2_meter1date }" name="sa2_meter1date" id="sa2_meter1date" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text"   value="${list.sa2_meter2date }" name="sa2_meter2date" id="sa2_meter2date" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text"   value="${list.sa2_inverterdate }" name="sa2_inverterdate" id="sa2_inverterdate" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                  </tr>
                  <tr class="">
                    <td class="tg-0lax px-4 py-3 bg-table-violet" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      총발전량[kwh]</td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							  value="${list.sa2_meter1allKWh }" name="sa2_meter1allKWh" id="sa2_meter1allKWh" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0laxpx-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							  value="${list.sa2_meter2allKWh }" name="sa2_meter2allKWh" id="sa2_meter2allKWh" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							  value="${list.sa2_inverterallKWh }" name="sa2_inverterallKWh" id="sa2_inverterallKWh" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                  </tr>
                  <tr class="">
                    <td class="tg-0lax px-4 py-3 bg-table-violet" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      1일평균 발전량[kwh/day]</td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							  value="${list.sa2_meter1dayKWh }" name="sa2_meter1dayKWh" id="sa2_meter1dayKWh" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							  value="${list.sa2_meter2dayKWh }" name="sa2_meter2dayKWh" id="sa2_meter2dayKWh" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							  value="${list.sa2_inverterdayKWh }" name="sa2_inverterdayKWh" id="sa2_inverterdayKWh" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                  </tr>
                  <tr class="">
                    <td class="tg-0lax px-4 py-3 bg-table-violet" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
                      1일평균 발전시간[hour/day]</td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							  value="${list.sa2_meter1dayhour }" name="sa2_meter1dayhour" id="sa2_meter1dayhour" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							  value="${list.sa2_meter2dayhour }" name="sa2_meter2dayhour" id="sa2_meter2dayhour" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
                    </td>
                    <td class="tg-0lax px-4 py-3" colspan="2" style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
                      <input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							  value="${list.sa2_inverterdayhour }" name="sa2_inverterdayhour" id="sa2_inverterdayhour" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">
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
                      <textarea rows="5" name="sa2_opinion" id="sa2_opinion" class="tb_gbla1 w-full border-none text-xs focus:outline-none" style="background-color: rgba(255, 255, 255, 0);">${list.sa2_opinion }</textarea>
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
              <input type="radio" name="sa2_problem" id="sa2_problem" value="2" class="ml-3 mr-5" >
              </span>
             </c:if>
             <c:if test="${list.sa2_problem eq '2'}">
             <span class="py-4">
              <label class="text-buttonText-red" for="problem">이상 있음</label>
              <input type="radio" name="sa2_problem" id="sa2_problem" value="1" class="ml-3 mr-5" >
              <label class="text-active-green" for="safe">이상 없음</label>
              <input type="radio" name="sa2_problem" id="sa2_problem" value="2" class="ml-3 mr-5" checked>
             </span>
             </c:if>
          </div>
          <div style="text-align: center;"><button type ="button" style="width: 120px;" onclick="UpdateInfo()" class="mx-3 text-xs font-semibold items-center w-16 py-2 border border-transparent rounded text-white bg-black flex-shrink-0 mb-2"> 수정 </button></div>
        </div>
        <input type="hidden" id="buttionType" name="buttionType" value="insert"> 
		<input type="hidden" id="sa2_keyno" name="sa2_keyno" value="${list.sa2_keyno }"> 
		<input type="hidden" id="sa2_inverternumtype" name="sa2_inverternumtype" value="${num }">
		<input type="hidden" id="sa_writetype" name="sa_writetype" value="2">
		<input type="hidden" id="SU_KEYNO" name="SU_KEYNO" value="">
		<input type="hidden" id="imgSrc" name="imgSrc" value="">
		<input type="hidden" id="predataMeter1" name="predataMeter1" value="">
		<input type="hidden" id="predataMeter2" name="predataMeter2" value="">
		<input type="hidden" id="prewatt" name="prewatt" value="">
		<input type="hidden" id="sang_AC" value="${list.sa2_AC_Change }">
		<input type="hidden" id="lrChange" value="${list.sa2_LR }">
		<input type="hidden" id="sa2_dateMI" name="sa2_dateMI" value="${min}">
		<input type="hidden" id="sa2_dateS" name="sa2_dateS" value="${sec}">
		<input type="hidden" id="sa2_date3" name="sa2_date3" value="">
		<input type="hidden" id="Current_Conn_date" name="Current_Conn_date" value="${Conn_date}">
		<input type="hidden" id="Pre_Conn_date" name="Pre_Conn_date" value="">
		<input type="hidden" id="perioddata" name="perioddata" value="${perioddata}">
    </div>
  </div>
</main>
</form:form>
<script type="text/javascript">
var list = [];
$(function() {
	
	inverterNumber()
	seletbox_value()
	var AC_value = $("#sang_AC").val();
	var LefLigt = $("#lrChange").val();
	$("#sa2_LR").val(LefLigt)
	AC_Change(AC_value)
	
	
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
		$("#inputplus1").html('<td class="tg-0lax px-4 py-3 text-center font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">연간 현재 누적<select id="sa2_accpowertype" name="sa2_accpowertype" onchange = "MwhCal_ten();  kwchange(this.value);" style="padding-top:0;padding-bottom:0;background-color:#f0f2f5;border:none;border-radius:4px;margin-left:10px;margin-right:10px;font-size:12px"><option value="KWh">KWh</option><option value="MWh">MWh</option></select></td>')
		$("#inputplus2").html('<td class="tg-0lax px-4 py-3 text-center font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">전회 누적[<input class="w-2\/12 font-semibold text-center" id="sa2_preacctype" name = "sa2_preacctype" value = "" readonly="readonly">]</td>')
		$("#inputplus3").html('<td class="tg-0lax px-4 py-3 text-center font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">기간 발전[KWh]</td>')
		$("#inputplus4").hide();
		$("#inputplus5").html('<td class="tg-0lax px-4 py-3 text-center font-semibold bg-table-violet" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">인버터 번호</td>')
		$("#inputplus6").html('<td class="tg-0lax px-4 py-3 text-center font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">연간 현재 누적[<input class="w-2\/12 font-semibold text-center" id="sa2_accpowertype2" name = "sa2_accpowertype2" value = "" readonly="readonly">]</td>')
		$("#inputplus7").html('<td class="tg-0lax px-4 py-3 text-center font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">전회 누적[<input class="w-2\/12 font-semibold text-center" id="sa2_preacctype2" name = "sa2_preacctype2" value = "" readonly="readonly">]</td>')
		$("#inputplus8").html('<td class="tg-0lax px-4 py-3 text-center font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">기간 발전[KWh]</td>')
		$("#inputplus9").hide();
		
		
		
   		for(var i=1; i<=num; i++){
   			
   			
   			if(count < 11){	
   				
   				if(count == "1"){
	   				var conutt = count + 1
	   				$("#inputplus0").append('<td class="tg-0lax px-4 py-3 text-center bg-table-violet" style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;"><select id="sa2_LR" name ="sa2_LR" class="default_input_style input_margin_x_10px input_padding_y_4px"><option value = "L">좌</option><option value = "R">우</option></select>'+count+'</td>')
	    			$("#inputplus1").append('<td class="tgsfa1 px-4 py-3 text-center  " style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" class="w-full border-none text-xs text-center focus:outline-none" value='+annacclist[i-1]+' name="sa2_annacc"  oninput="method_1(\'inputplus1\',\'inputplus2\',\'inputplus3\',\''+conutt+'\');" style="background-color:rgba( 255, 255, 255, 0 )"></td>')
	    			$("#inputplus2").append('<td class="tgsfa2 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" class="w-full border-none text-xs text-center focus:outline-none" value='+preannacclist[i-1]+' name="sa2_preannacc" oninput="inputNumberFormat(this) style="background-color:rgba( 255, 255, 255, 0 )"  readonly="readonly"></td>')
	    			$("#inputplus3").append('<td class="tgsfa3 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" class="w-full border-none text-xs text-center focus:outline-none" value='+peridevlist[i-1]+' name="sa2_peridev" style="background-color:rgba( 255, 255, 255, 0 )"  readonly="readonly"></td>')		
   				}else{
   					var conutt = count + 1
	   				$("#inputplus0").append('<td class="tg-0lax px-4 py-3 text-center bg-table-violet" style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">'+count+'</td>')
	    			$("#inputplus1").append('<td class="tgsfa1 px-4 py-3 text-center  " style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" class="w-full border-none text-xs text-center focus:outline-none" value='+annacclist[i-1]+' name="sa2_annacc"  oninput="method_1(\'inputplus1\',\'inputplus2\',\'inputplus3\',\''+conutt+'\');" style="background-color:rgba( 255, 255, 255, 0 )"></td>')
	    			$("#inputplus2").append('<td class="tgsfa2 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" class="w-full border-none text-xs text-center focus:outline-none" value='+preannacclist[i-1]+' name="sa2_preannacc" oninput="inputNumberFormat(this) style="background-color:rgba( 255, 255, 255, 0 )"  readonly="readonly"></td>')
	    			$("#inputplus3").append('<td class="tgsfa3 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" class="w-full border-none text-xs text-center focus:outline-none" value='+peridevlist[i-1]+' name="sa2_peridev" style="background-color:rgba( 255, 255, 255, 0 )"  readonly="readonly"></td>')		
   				}
       			
   			}else{
   				
   				var conutt = count + 1
   				$("#inputplus5").append('<td class="tg-0lax px-4 py-3 text-center bg-table-violet" style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">'+count+'</td>')
    			$("#inputplus6").append('<td class="tgsfa6 px-4 py-3 text-center  " style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" class="w-full border-none text-xs text-center focus:outline-none" value='+annacclist[i-1]+' name="sa2_annacc" oninput="method_1(\'inputplus6\',\'inputplus7\',\'inputplus8\',\''+conutt+'\');" style="background-color:rgba( 255, 255, 255, 0 )"></td>')
    			$("#inputplus7").append('<td class="tgsfa7 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" class="w-full border-none text-xs text-center focus:outline-none" value='+preannacclist[i-1]+' name="sa2_preannacc" oninput="inputNumberFormat(this)" style="background-color:rgba( 255, 255, 255, 0 )"  readonly="readonly"></td>')
    			$("#inputplus8").append('<td class="tgsfa8 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" class="w-full border-none text-xs text-center focus:outline-none" value='+peridevlist[i-1]+' name="sa2_peridev" style="background-color:rgba( 255, 255, 255, 0 )"  readonly="readonly"></td>')

   			}
   			count += 1;
   			
   		}
   		
   		var periodPowerInputs = document.getElementsByName("sa2_peridev");

		// 배열 초기화
		var periodPowerList = [];
		
		// NodeList를 배열로 변환하여 각 input 요소의 값을 배열에 추가
		for (var i = 0; i < periodPowerInputs.length; i++) {
		    var value = periodPowerInputs[i].value.trim();
		
		    // 값이 빈 문자열인 경우 0으로 초기화
		    periodPowerList.push(value === '' ? 0 : parseFloat(value));
		}

		
		list = periodPowerList;
	
   		
   		//td 어펜드 후에 kwh, mwh넣어주고 "MWh" 일때만 수식 function 실행
		$("#sa2_accpowertype").val(accpowertype);
       	$("#sa2_preacctype").val(preacctype);
       	$("#sa2_preacctype2").val(preacctype2);
      	var acctypeVal = $("#sa2_accpowertype").val();
      	
	    //11번 인버터부터 kw/mw표시 function
	    kwchange(acctypeVal)
      
		if(acctypeVal == "MWh"){
			MwhCal_ten()
		}
   		
   			
	}else{
		
		var nowpower = "${list.sa2_nowpower}";
		var todaypower = "${list.sa2_todaypower}";
		var accpower = "${list.sa2_accpower}";
		var periodpower = "${list.sa2_periodpower}";
		
		var accpower2 = "${list2.sa2_accpower}";
		var pretype_one = "${list2.sa2_accpowertype}";
		
		//첫 작성 시
		if(!pretype_one){
			pretype_one = "KWh"
		}

		var nowpowerlist = []
		var todaypowerlist = []
		var accpowerlist = []
		var periodpowerlist = []
		
		var accpowerlist2 = []

		nowpowerlist = nowpower.split(",")
		todaypowerlist = todaypower.split(",")
		accpowerlist = accpower.split(",")	
		periodpowerlist = periodpower.split(",")
		
		
		if(!accpower2){
			accpowerlist2 = new Array(num).fill(0);
		}else{
			accpowerlist2 = accpower2.split(",")	
		}
		

		
		function EmptyValue(value) { 
			return value.map(function(item) {
				return typeof item === 'string' ? item.trim() !== "" ? item.trim() : 0 : item;
			});
		}
		
		accpowerlist2 = EmptyValue(accpowerlist2)
		
		nowpowerlist = EmptyValue(nowpowerlist);
		todaypowerlist = EmptyValue(todaypowerlist);
		accpowerlist = EmptyValue(accpowerlist);
		periodpowerlist = EmptyValue(periodpowerlist);
		
		if(pretype_one == "MWh"){
			accpowerlist2 = EmptyValue(accpowerlist2).map(item => item * 1000);
		}

		
		var conutt = count + 1
		
		
		$(".hiddenTr").hide();
		$(".etcTr").show();
		$("#inputplus4").show();
		
		if(num == "1"){
			$("#inputplus0").html('<td class="tg-0lax px-4 py-3 text-left font-semibold bg-table-violet" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">인버터 번호</td><td class="tg-0lax px-4 py-3 text-center bg-table-violet" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0">1</td>');
			$("#inputplus1").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">현재 출력 [KWh]</td><td class="la2 px-4 py-3 text-center  " style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+nowpowerlist[0]+' name="sa2_nowpower" id="sa2_nowpower"></td>');
			$("#inputplus2").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">금일 발전량 [KWh]</td><td class="la3 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+todaypowerlist[0]+' name="sa2_todaypower" id="sa2_todaypower"></td>');
			$("#inputplus3").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">누적 발전량<select id="sa2_accpowertype" name="sa2_accpowertype" onchange = "MwhCal_one()" style="padding-top:0;padding-bottom:0;background-color:#f0f2f5;border:none;border-radius:4px;margin-left:10px;margin-right:10px;font-size:12px"><option value="KWh">KWh</option><option value="MWh">MWh</option></select></td><td class="la4 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+accpowerlist[0]+' name="sa2_accpower" id="sa2_accpower" oninput="method_2(\'inputplus3\',\'inputplus4\',\''+conutt+'\')"><input type="hidden" value='+accpowerlist2[0]+' name="sa2_accpower1"></td>');
			$("#inputplus4").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">기간 발전량 [KWh]</td><td class="la5 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+periodpowerlist[0]+' name="sa2_periodpower" readonly="readonly"></td>');
		}else{
			$("#inputplus0").html('<td class="tg-0lax px-4 py-3 text-left font-semibold bg-table-violet" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">인버터 번호</td><td class="tg-0lax px-4 py-3 text-center bg-table-violet" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><select id="sa2_LR" name ="sa2_LR" class="default_input_style input_margin_x_10px input_padding_y_4px"><option value = "L">좌</option><option value = "R">우</option></select>1</td>');
			$("#inputplus1").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">현재 출력 [KWh]</td><td class="la2 px-4 py-3 text-center  " style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+nowpowerlist[0]+' name="sa2_nowpower" id="sa2_nowpower"></td>');
			$("#inputplus2").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">금일 발전량 [KWh]</td><td class="la3 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+todaypowerlist[0]+' name="sa2_todaypower" id="sa2_todaypower"></td>');
			$("#inputplus3").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">누적 발전량<select id="sa2_accpowertype" name="sa2_accpowertype" onchange = "MwhCal_one()" style="padding-top:0;padding-bottom:0;background-color:#f0f2f5;border:none;border-radius:4px;margin-left:10px;margin-right:10px;font-size:12px"><option value="KWh">KWh</option><option value="MWh">MWh</option></select></td><td class="la4 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+accpowerlist[0]+' name="sa2_accpower" id="sa2_accpower" oninput="method_2(\'inputplus3\',\'inputplus4\',\''+conutt+'\')"><input type="hidden" value='+accpowerlist2[0]+' name="sa2_accpower1"></td>');
			$("#inputplus4").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">기간 발전량 [KWh]</td><td class="la5 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+periodpowerlist[0]+' name="sa2_periodpower" readonly="readonly"></td>');
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
			$("#inputplus1").append('<td class="la'+lanum+' px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+nowpowerlist[i]+' name="sa2_nowpower"></td>')
			$("#inputplus2").append('<td class="la'+lanum2+' px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+todaypowerlist[i]+' name="sa2_todaypower"></td>')
			$("#inputplus3").append('<td class="la'+lanum3+' px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+accpowerlist[i]+' name="sa2_accpower" id="sa2_accpower" oninput="method_2(\'inputplus3\',\'inputplus4\',\''+conuttt+'\')"><input type="hidden" value='+accpowerlist2[i]+' name="sa2_accpower1"></td>')
			$("#inputplus4").append('<td class="la'+lanum4+' px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+periodpowerlist[i]+' name="sa2_periodpower" readonly="readonly"></td>')
   			
			
		}	
		
		var periodPowerInputs = document.getElementsByName("sa2_periodpower");

		// 배열 초기화
		var periodPowerList = [];
		
		// NodeList를 배열로 변환하여 각 input 요소의 값을 배열에 추가
		for (var i = 0; i < periodPowerInputs.length; i++) {
		    var value = periodPowerInputs[i].value.trim();
		
		    // 값이 빈 문자열인 경우 0으로 초기화
		    periodPowerList.push(value === '' ? 0 : parseFloat(value));
		}

		
		list = periodPowerList;
		
			
		//td 어펜드 후에 kwh, mwh넣어주고 수식 function 실행
       	$("#sa2_accpowertype").val(accpowertype);
		var acctypeVal = $("#sa2_accpowertype").val();
		if(acctypeVal == "MWh"){
			MwhCal_one()	
		}
	}
	
}


function UpdateInfo(){
	
	dateReplace();
	
	 $.ajax({
      url: '/sfa/safeAdmin/safeAdminUpdate2.do?${_csrf.parameterName}=${_csrf.token}',
      type: 'POST',
      data: $('#Form').serializeArray(),
      async: false,  
      success: function(result) {
      	alert(result);
      	location.reload();
      },
      error: function(){
      	alert("수정 에러");
      }
	}); 
}


function seletbox_value(){
	
	var adminname = "${list.sa2_adminname}";
	$("#sa2_adminname").val(adminname);
	
}

//상전압 선간전압 변경
function AC_Change(value){

	if(value == "01"){
		$(".AC_cl1").text('L1-L2')
		$(".AC_cl2").text('L2-L3')
		$(".AC_cl3").text('L3-L1')
	}else{
		$(".AC_cl1").text('L1-N')
		$(".AC_cl2").text('L2-N')
		$(".AC_cl3").text('L3-N')
	}
}

function MwhCal_one(){
	
	var num = Number($("#sa2_inverternumtype").val())
	
	for(var i = 2; i<=num+1; i++){
		method_2('inputplus3', 'inputplus4', i)
	}
}

function MwhCal_ten(){
	
	var num = Number($("#sa2_inverternumtype").val())
	
	for(var i = 2; i<=num+1; i++){
		if(i > 11){
			method_1('inputplus6', 'inputplus7','inputplus8', i)			
		}else{
			method_1('inputplus1', 'inputplus2','inputplus3', i)		
		}
	}
}

function changeDate(){
	
	var Year = $("#sa2_dateY").val();
	var Mon = $("#sa2_dateM").val();
	var Day = $("#sa2_dateD").val();
	var pre_Year = "${list2.sa2_date}";
	if(pre_Year){
		pre_Year = pre_Year
	}else{ 
		pre_Year = Year
	}
	
	pre_Year = pre_Year.substring(0,4);
	
	//첫작성시 작성 날짜로 넣기위한 포맷팅
	var formattedDate = Mon + '/' + Day;
	
	
	
	var perioddata = $("#perioddata").val();
	if(!perioddata){
		perioddata = formattedDate;
		console.log(perioddata)
	}else{
		perioddata = $("#perioddata").val();
	}
	
	
	var idx = perioddata.indexOf('/');
	var perioddata2 = perioddata.substring(0,idx);
	var perioddata3 = perioddata.substring(idx+1);
	var perioddata4 = pre_Year+"-"+perioddata2+"-"+perioddata3;
	console.log(perioddata4)
	
	var date3 = new Date(perioddata4);
	date3.setHours(0, 0, 0, 0);
	
	
	//DayDiff => 작성 주기 계산
	var Now_Conn_date = Year+"-"+Mon+"-"+Day;
	var date1 = new Date(Now_Conn_date);
	console.log(date1)
	date1.setHours(0, 0, 0, 0);
	
	var Current_Conn_date = $("#Current_Conn_date").val();
	var date2 = new Date(Current_Conn_date);
	date2.setHours(0, 0, 0, 0);
	
	var timeDiff = date1 - date3;
	var dayDiff = timeDiff / (1000 * 60 * 60 * 24);
	console.log(dayDiff)
	
	//첫작성 시
	if(dayDiff == 0){
		dayDiff = 1;
	}
	
	
	$("#sa2_inverterdate").val(dayDiff)
	$("#sa2_meter2date").val(dayDiff)
	
	
	// 기간 표시 00/00 ~ 00/00 변경(날짜수정 시)
	var date1_month = date1.getMonth() + 1;
	var date1_day = date1.getDate();
	var date1_period = date1_month+"/"+date1_day;
	
	var date3_month = date3.getMonth() + 1;
	var date3_day = date3.getDate();
	var date3_period = date3_month+"/"+date3_day;
	
	var Pre_Conn_date1 = Current_Conn_date.substring(5,10);
	var Pre_Conn_date2 = Pre_Conn_date1.replace("-","/");
	

	$("#sa2_meter2period").val(date3_period+"~"+date1_period)
	$("#sa2_inverterperiod").val(date3_period+"~"+date1_period)
	
	
	//1. 데이터 입력 후 날짜 변경 시(인버터데이터 부분)
	
		//총발전량, 용량, CT비
		var allKWh = Number($("#sa2_inverterallKWh").val());
		var palntKW = Number($("#sa2_palntKW").val());
		var palntCT = Number($("#sa2_palntCT").val());
		
		
		var daykwh = allKWh/dayDiff
		var dayhour = daykwh/palntKW
		$("#sa2_inverterdayKWh").val(daykwh.toFixed(2))
		$("#sa2_inverterdayhour").val(dayhour.toFixed(2))
	
	//2. 데이터 입력 후 날짜 변경 시(계량기 데이터 부분)
	
		//계량기 총발전량, 전회차 현재 누적 계량기 데이터
		var meter_data = Number($("#sa2_meter2KWh").val());
		var Prev_data = Number($("#predataMeter2").val());
		
		
		var meter_allKWh = (meter_data-Prev_data)*palntCT
		var meter_dayKWh = meter_allKWh/dayDiff
		var meter_dayhour = meter_dayKWh/palntKW
		
		$("#sa2_meter2allKWh").val(meter_allKWh.toFixed(2))
		$("#sa2_meter2dayKWh").val(meter_dayKWh.toFixed(2))
		$("#sa2_meter2dayhour").val(meter_dayhour.toFixed(2))
}

function method_1(a,b,c,d){
	
	var acctype =  $("#sa2_accpowertype").val();
	var acctype2 =  $("#sa2_preacctype").val();
	var periodtype =  $("#sa2_periodpowertype").val();
	
	var num = d;
	if(d > 11){
		num = d - 10
	}
	
	var aa = $("#"+ a +">  td:nth-child("+  num + ")  > input").val();
	console.log(aa+"ok");
	var bb = $("#"+ b +">  td:nth-child("+  num + ")  > input").val();
	
	if(bb == null | bb == ''){
		bb = 0;
	}
	
	if(acctype == "MWh"){
		aa = aa * 1000;
	}else{
		aa = aa;
	}
	
	if(acctype2 == "MWh"){
		bb = bb * 1000;
	}else{
		bb = bb;
	}
	
	//한번씩 문자들어갔을 경우에 문자를 지우고 숫자를 쓰면 method_1 펑션이 안먹힘;; 그래서 한번 더 값 넣어줌 그냥
	if(typeof aa ==='string' || typeof bb ==='string'){
		aa = aa;
		bb = bb;
	}
	
	$("#"+ c +">  td:nth-child("+  num + ")  > input").val((aa-bb).toFixed(2));
			

	
	var periodpower = aa-bb
	var sum = 0;
		
	list[d-2] = aa-bb;
	
		
	for(var i=0;i<list.length;i++){
			sum += list[i]
	}
		
	$("#sa2_inverterallKWh").val(sum.toFixed(3));
	
	
	
	var vv = $("#sa2_inverterdate").val()
	var vvv = $("#sa2_palntKW").val()
	
	if(vv == 0){
		vv = 1
	}else{
		vv = $("#sa2_inverterdate").val()
	}
	
	var v1 = Number(sum)
	var vv1 = Number(vv)
	var vvv1 = Number(vvv)
	
	var num2 = v1/vv1
	var num3 = num2/vvv1

	$("#sa2_inverterdayKWh").val(num2.toFixed(3))
	$("#sa2_inverterdayhour").val(num3.toFixed(3))
}


function method_2(a,b,c){
	
	var inverterdate = $("#sa2_inverterdate").val()
	var palntKW = $("#sa2_palntKW").val()
	var palntCT = $("#sa2_palntCT").val()
	var acctype =  $("#sa2_accpowertype").val();
	
	//현재 누적= aa, 전회차 누적 = bb, aa-bb
	var aa = $("#"+ a +" > td:nth-child("+ c +") > input").val();
	var bb = $("#"+ a +" > td:nth-child("+ c +") > input[type=hidden]:nth-child(2)").val();

	if(acctype == "MWh"){
		aa = aa * 1000;
	}else{
		aa = aa;
	}
	
	
	//한번씩 문자들어갔을 경우에 문자를 지우고 숫자를 쓰면 method_1 펑션이 안먹힘;; 그래서 한번 더 값 넣어줌 그냥
	if(typeof aa ==='string' || typeof bb ==='string'){
		aa = aa;
		bb = bb;
	}
	
	var periodpower = aa-bb
	$("#"+ b +" > td:nth-child("+ c +") > input.tb_gbla1").val(periodpower.toFixed(2));			

	
	var sum = 0;
	
	list[c-2] = aa-bb;
	
	
	//기간발전량 합처리
	for(var i=0;i<list.length;i++){
		sum += list[i]	
	}
	
	
	
	var acctype =  $("#sa2_accpowertype").val();
	var periodtype =  $("#sa2_periodpowertype").val();
	

	
	//소수점 2번째 자리까지 자름
	var sumfix = sum.toFixed(2)
	
	if(inverterdate == 0){
		inverterdate = 1
	}else{
		inverterdate = $("#sa2_inverterdate").val()
	}
	
	
	var v1 = Number(sumfix)
	var vv1 = Number(inverterdate)
	var vvv1 = Number(palntKW)
	var palntCTnum = Number(palntCT)
	

	var num2 = v1/vv1
	var num3 = num2/vvv1

	
	$("#sa2_inverterallKWh").val(sumfix)
	$("#sa2_inverterdayKWh").val(num2.toFixed(2))
	$("#sa2_inverterdayhour").val(num3.toFixed(2))
	
}

function dateReplace(){
	
	
	var Year = $("#sa2_dateY").val();
	var Mon = $("#sa2_dateM").val();
	var Day = $("#sa2_dateD").val();
	var Hour = $("#sa2_dateT").val();
	var Min = $("#sa2_dateMI").val();
	var Sec = $("#sa2_dateS").val();
	var Dow = $("#sa2_dateDow").val();
	
	$("#sa2_date").val(Year+"-"+Mon+"-"+Day+" "+Hour+":"+Min+":"+Sec);
	console.log($("#sa2_date").val());
	$("#sa2_date3").val(Year+"년 "+Mon+"월 "+Day+"일 "+Hour+"시 "+Dow+"요일");
	
	
}


function Divison2(obj){

	var ctb = $("#sa2_palntCT").val()
	var day = $("#sa2_meter2date").val()
	var vol = $("#sa2_palntKW").val()
	//전회차 현재 누적 송전 유효전력량
	var prev = $("#predataMeter2").val()
	
	
	if(day == 0){
		day = 1
	}else{
		day = $("#sa2_meter2date").val()
	}
	
	if(prev == null| prev == ''){
		prev = 0;
	}else{
		prev = $("#predataMeter2").val()
	}
	
	
	var ctb1 = Number(ctb);
	var day1 = Number(day);
	var vol1 = Number(vol);
	var obj1 = Number(obj);
	var prev1 = Number(prev);
	
	var num = (obj1-prev1)*ctb1
	var num2 = num/day1
	var num3 = num2/vol1
	
	$("#sa2_meter2allKWh").val(num.toFixed(3))
	$("#sa2_meter2dayKWh").val(num2.toFixed(3))
	$("#sa2_meter2dayhour").val(num3.toFixed(3))
}

function Divison3(){

	var v = $("#sa2_palntCT").val()
	var vv = $("#sa2_inverterdate").val()
	var vvv = $("#sa2_palntKW").val()
	var v2 = $("#sa2_periodpower").val()
	
	
	if(vv == 0){
		vv = 1
	}else{
		vv = $("#sa2_inverterdate").val()
	}
	
	var v1 = Number(v);
	var vv1 = Number(vv);
	var vvv1 = Number(vvv);
	
	
	
// 	var num = v2*1000
	var num2 = num/vv1
	var num3 = num2/vvv1
	
// 	$("#sa2_inverterallKWh").val(num.toFixed(3))
	$("#sa2_inverterdayKWh").val(num2.toFixed(3))
	$("#sa2_inverterdayhour").val(num3.toFixed(3))
}

function kwchange(value){
	
	$("#sa2_accpowertype2").val(value);
	
}

</script>
