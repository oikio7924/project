<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<script src="/resources/common/js/html2canvas.js"></script>
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
	<main id="esco" class="h-full overflow-y-auto ">
		<div class="container grid px-6 mx-auto">
			<div class="relative">
				<div
					class="px-3 py-1 md:px-3 md:py-1 lg:px-5 lg:py-2 w-full rounded-lg bg-white my-4 md:md-4 lg:my-7">
					<div class="flex">
						<div class="" data-html2canvas-ignore="true">
						</div>
						<div class="flex items-center">
							<div class="flex items-center ">
								<select name="su_area" onchange="AreaChange(this.value)"
								class="default_input_style input_margin_x_10px input_padding_y_4px mb-2">
								<option value="all">전체</option>
								<c:forEach items="${arialist}" var="b">
										<option value="${b.SU_SA_AREA}">${b.SU_SA_AREA }</option>
									</c:forEach>
								</select>
								<select name="su_name" id="su_name"
									onchange="changesulbi(this.value)"
									class="default_input_style input_margin_x_10px input_padding_y_4px mb-2">
									<option value="">발전소 선택</option>
<%-- 									<c:forEach items="${safeuserlist}" var="b"> --%>
<%-- 										<option value="${b.SU_KEYNO}">${b.SU_SA_SULBI }</option> --%>
<%-- 									</c:forEach> --%>
								</select> 
								<div class="flex flex-wrap items-center">
									<p
										class="imagePixel flex items-center rounded-full px-2 py-1 text-xs bg-badge-green text-active-green mr-3 mb-2">
										<span class="p-1 rounded-full mr-2 p-1 green_spot"></span> <input
											type="hidden" name="sa2_count"">
										<span2 id="sa2_count"></span2>
										번 중
									</p>
									<p
										class="imagePixel flex items-center rounded-full px-2 py-1 text-xs bg-badge-red text-buttonText-red mr-6 mb-2">
										<span class="p-1 rounded-full mr-2 p-1 red_spot"></span>
										<span2 id="sa2_count2"></span2>
										번 점검
									</p>
								</div>
							</div>
						</div>
					</div>
					<div> 
<!-- 						<span class="flex mr-3">발전소 명:</span>  -->
						<span class="flex text-active-blue">
							<input type="text" name="sa2_title" id="sa2_title"
							class="w-full border-none text-4xl" style="text-align: center; flex-wrap: wrap;"
							readonly="readonly">
						</span>
					</div>
				</div>
				<div class="w-full rounded-lg bg-white my-4 md:md-4 lg:my-7">
					<div class="px-5 my-4 text-bold text-base md:text-base lg:text-lg">
						<div class="flex items-center pt-5" data-html2canvas-ignore="true">
							<span>*양식 전체 캡쳐</span> <input type="checkbox" id="allcheck"
								class="ml-2 w-6 h-6" style="border-radius: 4px;">
						</div>
					</div>
					<div class="w-full border"></div>
					<div class="px-5 text-bold text-sm md:text-sm lg:text-base my-2.5">

<!-- 						<div class="flex flex-wrap items-center" -->
<!-- 							data-html2canvas-ignore="true"> -->
<!-- 							<span> 이전 인버터 데이터 비교 : </span> <select name="Year" id="Year" -->
<!-- 								class="default_input_style input_margin_x_10px input_padding_y_4px mb-2"> -->
<!-- 								<option value="">연도 선택</option> -->
<!-- 							</select> <select name="Month" id="Month" onchange="datanumselect()" -->
<!-- 								class="default_input_style input_margin_x_10px input_padding_y_4px mb-2"> -->
<!-- 								<option value="">월 선택</option> -->
<!-- 							</select> <select name="selectgroup" id="selectgroup" -->
<!-- 								class="default_input_style input_margin_x_10px input_padding_y_4px mb-2"> -->
<!-- 								<option value="">일 선택</option> -->
<!-- 							</select> -->
<!-- 							<button type="button" id="autoInsert" onclick="view()" -->
<!-- 								class="mx-3 text-xs font-semibold items-center w-16 py-2 border border-transparent rounded text-white bg-black flex-shrink-0 mb-2">조회</button> -->
<!-- 						</div> -->
						<div class="flex flex-wrap items-center"
							data-html2canvas-ignore="true">
<!-- 							<span> 이전 양식 조회 : </span> -->
							<button type="button" id="autoInsert" onclick = "Recent_popup();"
								class="mx-3 text-xs font-semibold items-center w-24 py-2 border border-transparent rounded text-white bg-black flex-shrink-0 mb-2">이전 양식 조회</button>
							<button type="button" id="autoInsert" onclick = "pre_select();"
								class="mx-3 text-xs font-semibold items-center w-24 py-2 border border-transparent rounded text-white bg-black flex-shrink-0 mb-2">이전 발전소</button>
							<button type="button" id="autoInsert" onclick = "next_select();"
								class="mx-3 text-xs font-semibold items-center w-24 py-2 border border-transparent rounded text-white bg-black flex-shrink-0 mb-2">다음 발전소</button>
						</div>
					</div>
					<div class="w-full border"></div>
					<div
						class="px-3 py-1 md:px-3 md:py-1 lg:px-5 lg:py-2.5 text-bold text-xs">
						<div class="flex items-center ">
							<div class="w-90 nowtimeAlim">
								<p
									class="py-1 px-2 justify-center rounded-full text-white bg-active-green flex items-center"
									style="max-width: fit-content;">
									<span class="p-1 rounded-full mr-2 p-1 bg-white"
										style="font-size: 0px;"> </span>
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
							<div class="mx-3" data-html2canvas-ignore="true">
								<label for="">날씨:</label> <select name="sa2_wether"
									id="sa2_wether"
									class="default_input_style input_margin_x_10px input_padding_y_4px">
									<option value="">날씨 선택</option>
									<option value="맑음">맑음</option>
									<option value="흐림">흐림</option>
									<option value="비">비</option>
									<option value="눈">눈</option>
									<option value="구름">구름</option>
								</select>
							</div>
							<div class="" data-html2canvas-ignore="true">
								<label for="">관리자:</label> <select name="sa2_adminname"
									id="sa2_adminname"
									class="default_input_style input_margin_x_10px input_padding_y_4px">
									<option value="">관리자 선택</option>
									<option value="이민환">이민환</option>
									<option value="김용인">김용인</option>
								</select>
							</div>
						</div>
					</div>
					<div class="w-full border"></div>
					<div class="esco">
						<div class="px-5 my-4 text-bold text-base md:text-base lg:text-lg">
							<div class="flex items-center" data-html2canvas-ignore="true">
								<span>*인버터발전현황 부분 캡쳐</span> <input type="checkbox"
									onclick="checkboxEvent(this)" class="check ml-2 w-6 h-6"
									checked="checked" value="false" style="border-radius: 4px;">
							</div>
						</div>
						<div
							class="w-full overflow-hidden rounded-lg ring-1 ring-black ring-opacity-5 border-b border-black"
							style="border-radius: 0px;">
							<div class="w-full overflow-x-auto">
								<table class="w-full whitespace-nowrap">
									
									<thead
										class="text-xs font-semibold tracking-wide text-left text-gray-500 uppercase border-b bg-gray-50">
									</thead>

									<!-- ----------------------------------------인버터 정보 tbody ------------------------------------------------ -->

									<tbody class="bg-white divide-y text-gray-700 text-xs">
										<tr class="">
											<td
												class="tg-0lax px-4 py-3 text-black text-center bg-table-violet text-sm md:text-sm lg:text-base font-bold"
												colspan="100%">*인버터발전현황</td>
										</tr>
										<tr id="inputplus0" class="">
											<td
												class="width-o tg-0lax px-4 py-3 text-left font-semibold bg-table-violet"
												style="min-width: 19rem; max-width: 25rem; width: 20rem; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												인버터 번호</td>
											<td class="tg-0lax px-4 py-3 bg-table-violet"
												style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text" name="inverternumber" id="inverternumber"
												value="1" class="w-full border-none text-xs bg-table-violet"
												readonly="readonly">
											</td>
										</tr>
										<tr id="inputplus1" class="">
											<td class="width-o tg-0lax px-4 py-3 text-left font-semibold"
												style="min-width: 19rem; max-width: 25rem; width: 20rem; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												현재 출력</td>
											<td class="la2 px-4 py-3"
												style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text" value="" name="sa2_nowpower"
												id="sa2_nowpower"
												oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
												class="w-full border-none text-xs"> <input
												type="hidden" value="" name="sa2_nowpower1"
												id="sa2_nowpower1" class="w-full border-none text-xs">
											</td>
										</tr>
										<tr id="inputplus2" class="">
											<td class="width-o tg-0lax px-4 py-3 text-left font-semibold"
												style="min-width: 19rem; max-width: 25rem; width: 20rem; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												금일 발전량[kwh]</td>
											<td class="la3 px-4 py-3"
												style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text" value="" name="sa2_todaypower"
												id="sa2_todaypower" class="w-full border-none text-xs">
												<input type="hidden" value="" name="sa2_todaypower1"
												id="sa2_todaypower1" class="w-full border-none text-xs">
											</td>
										</tr>
										<tr id="inputplus3" class="">
											<td class="width-o tg-0lax px-4 py-3 text-left font-semibold"
												style="min-width: 19rem; max-width: 25rem; width: 20rem; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding-top: 0.5rem; padding-bottom: 0.5rem;">
												누적 발전량[kwh]</td>
											<td class="la4 px-4 py-3"
												style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text" name="sa2_accpower" id="sa2_accpower"
												class="w-full border-none text-xs"> <input
												type="hidden" name="sa2_accpower1" id="sa2_accpower1"
												class="w-full border-none text-xs">
											</td>
										</tr>
										<tr id="inputplus4" class="">
											<td class="width-o tg-0lax px-4 py-3 text-left font-semibold"
												style="min-width: 19rem; max-width: 25rem; width: 20rem; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding-top: 0.5rem; padding-bottom: 0.5rem;">
												기간 발전량[kwh]</td>
											<td class="la5 px-4 py-3"
												style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text" name="sa2_periodpower"
												id="sa2_periodpower" class="w-full border-none text-xs">
												<input type="hidden" name="sa2_periodpower1"
												id="sa2_periodpower1" class="w-full border-none text-xs">
											</td>
										</tr>

										<!-- ----------------------------------------인버터대수 10대이상 부터 tbody 추가-------------------------------------------------->

										<tr id="inputplus5" class="hiddenTr">
											<td
												class="tg-0lax px-4 py-3 text-left font-semibold bg-table-violet"
												style="min-width: 19rem; max-width: 25rem; width: 20rem; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												인버터 번호</td>
											<td class="tg-0lax px-4 py-3 bg-table-violet"
												style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text" name="inverternumber" id="inverternumber"
												value="" class="w-full border-none text-xs">
											</td>
										</tr>
										<tr id="inputplus6" class="hiddenTr">
											<td class="tg-0lax px-4 py-3 text-left font-semibold"
												style="min-width: 19rem; max-width: 25rem; width: 20rem; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												현재 출력</td>
											<td class="tg-0lax px-4 py-3"
												style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text" value="" name="sa2_nowpower"
												id="sa2_nowpower" class="w-full border-none text-xs">
												<input type="hidden" value="" name="sa2_nowpower1"
												id="sa2_nowpower1" class="w-full border-none text-xs">
											</td>
										</tr>
										<tr id="inputplus7" class="hiddenTr">
											<td class="tg-0lax px-4 py-3 text-left font-semibold"
												style="min-width: 19rem; max-width: 25rem; width: 20rem; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												금일 발전량[kwh]</td>
											<td class="tg-0lax px-4 py-3"
												style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text" value="" name="sa2_todaypower"
												id="sa2_todaypower" class="w-full border-none text-xs">
												<input type="hidden" value="" name="sa2_todaypower1"
												id="sa2_todaypower1" class="w-full border-none text-xs">
											</td>
										</tr>
										<tr id="inputplus8" class="hiddenTr">
											<td class="tg-0lax px-4 py-3 text-left font-semibold"
												style="min-width: 19rem; max-width: 25rem; width: 20rem; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding-top: 0.5rem; padding-bottom: 0.5rem;">
												누적 발전량[kwh]</td>
											<td class="tg-0lax px-4 py-3"
												style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text" name="sa2_accpower" id="sa2_accpower"
												class="w-full border-none text-xs"> <input
												type="hidden" name="sa2_accpower1" id="sa2_accpower1"
												class="w-full border-none text-xs">
											</td>
										</tr>
										<tr id="inputplus9" class="hiddenTr">
											<td class="tg-0lax px-4 py-3 text-left font-semibold"
												style="min-width: 19rem; max-width: 25rem; width: 20rem; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding-top: 0.5rem; padding-bottom: 0.5rem;">
												기간 발전량[kwh]</td>
											<td class="tg-0lax px-4 py-3"
												style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text" name="sa2_periodpower"
												id="sa2_periodpower" class="w-full border-none text-xs">
												<input type="hidden" name="sa2_periodpower1"
												id="sa2_periodpower1" class="w-full border-none text-xs">
											</td>
										</tr>
										<!-- ---------------------------------------- tbody 추가 끝 ------------------------------------------------ -->
									</tbody>
								</table>
							</div>
						</div>
					</div>
					<div class="esco" data-html2canvas-ignore="true">
						<div class="px-5 my-4 text-bold text-base md:text-base lg:text-lg">
							<div class="flex items-center" data-html2canvas-ignore="true">
								<rspan>*기타 데이터 부분 캡쳐</span> <input type="checkbox"
									class="check ml-2 w-6 h-6" onclick="checkboxEvent(this)"
									style="border-radius: 4px;">
							</div>
						</div>
						<div
							class="w-full overflow-hidden rounded-lg ring-1 ring-black ring-opacity-5 border-b border-t border-black ignore"
							style="border-radius: 0px;">
							<div class="w-full overflow-x-auto">
								<table class="w-full whitespace-nowrap">
									<tbody
										class="esco bg-white divide-y text-gray-700 text-xs font-semibold">
										<tr class="etcTr">
											<td class="tg-0lax px-4 py-3" colspan="1" rowspan="3"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												AC전압 [V]
											</td>
											<td rowspan="3" style="text-align: center;">
												<label style="display: block;">선간전압<input type="radio" id="AC_sangsun" name="AC_sangsun"
													value="01" onchange="AC_Change(this.value)" checked></label>
												<label style="display: block; margin-top: 20px;">상전압 <input type="radio" id="AC_sangsun" name="AC_sangsun"
													value="02" onchange="AC_Change(this.value)"></label>
											</td>
											<td class="AC_cl1 tg-0lax px-4 py-3" colspan="1"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												L1 - N</td>
											<td class=" aaw-width tg-0lax px-4 py-3  " colspan="2"
												style=" min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<label id="sa2_label5"> <input type="text" inputmode="numeric"
													oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
													name="sa2_ACVL1_N" id="sa2_ACVL1_N"
													class="tb_gbla1 w-full border-none text-xs focus:outline-none"
													style="background-color: rgba(255, 255, 255, 0);">
											</label>
											</td>
											<td class="tg-0lax px-4 py-3" colspan="1" rowspan="3"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												AC전류 [A]</td>
											<td class="tg-0lax px-4 py-3" colspan="1"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												L1</td>
											<td class="aaw-width tg-0lax px-4 py-3  " colspan="2"
												style=" min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<label id="sa2_label6"> <input type="text"
													oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
													name="sa2_ACAL1" id="sa2_ACAL1" inputmode="numeric"
													class="tb_gbla1 w-full border-none text-xs focus:outline-none"
													style="background-color: rgba(255, 255, 255, 0);">
											</label>
											</td>
										</tr>
										<tr class="etcTr">
											<td class="AC_cl2 tg-0lax px-4 py-3" colspan="1"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												L2 - N</td>
											<td class="tg-0lax px-4 py-3  " colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<label id="sa2_label7"> <input type="text" inputmode="numeric"
													oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
													name="sa2_ACVL2_N" id="sa2_ACVL2_N"
													class="tb_gbla1 w-full border-none text-xs focus:outline-none"
													style="background-color: rgba(255, 255, 255, 0);">
											</label>
											</td>
											<td class="tg-0lax px-4 py-3" colspan="1"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												L2</td>
											<td class="tg-0lax px-4 py-3  " colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<label id="sa2_label8"> <input type="text" inputmode="numeric"
													oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
													name="sa2_ACAL2" id="sa2_ACAL2"
													class="tb_gbla1 w-full border-none text-xs focus:outline-none"
													style="background-color: rgba(255, 255, 255, 0);">
											</label>
											</td>
										</tr>
										<tr class="etcTr">
											<td class="AC_cl3 tg-0lax px-4 py-3" colspan="1"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												L3 - N</td>
											<td class="tg-0lax px-4 py-3  " colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<label id="sa2_label9"> <input type="text" inputmode="numeric"
													oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" 
													name="sa2_ACVL3_N" id="sa2_ACVL3_N"
													class="tb_gbla1 w-full border-none text-xs focus:outline-none"
													style="background-color: rgba(255, 255, 255, 0);">
											</label>
											</td>
											<td class="tg-0lax px-4 py-3" colspan="1"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												L3</td>
											<td class="tg-0lax px-4 py-3  " colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<label id="sa2_label10"> <input type="text" inputmode="numeric"
													oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
													name="sa2_ACAL3" id="sa2_ACAL3"
													class="tb_gbla1 w-full border-none text-xs focus:outline-none"
													style="background-color: rgba(255, 255, 255, 0);">
											</label>
											</td>
										</tr>
										<tr class="">
											<td class="px-4 py-3 bg-table-violet" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												발전소 용량 [KW]</td>
											<td class="px-4 py-3 bg-table-violet" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												발전전압 [KW]</td>
											<td class="px-4 py-3 bg-table-violet" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												CT비 [배]</td>
											<td class="px-4 py-3 bg-table-violet" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												검침일</td>
										</tr>
										<tr class="">
											<td class="tg-0lax px-4 py-3" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text" inputmode="numeric"
												oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
												name="sa2_palntKW" id="sa2_palntKW" readonly="readonly"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
											<td class="tg-0lax px-4 py-3" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text" inputmode="numeric"
												oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
												name="sa2_palntV" id="sa2_palntV" readonly="readonly"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
											<td class="tg-0lax px-4 py-3" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text" inputmode="numeric"
												oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
												name="sa2_palntCT" id="sa2_palntCT" readonly="readonly"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
											<td class="tg-0lax px-4 py-3" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text" value="" name="sa2_date2" id="sa2_date2"
												readonly="readonly" inputmode="numeric"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
										</tr>
										<tr class="">
											<td class="tg-0lax px-4 py-3" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												전월 누적 송전 유효전력량[kwh] - 전체</td>
											<td class="tg-0lax px-4 py-3" colspan="3"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text" readonly="readonly" value=""
												name="sa2_meternum1" id="sa2_meternum1"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
											<td class="tg-0lax px-4 py-3  " colspan="3"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text"
												oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
												onkeyup="Divison(this.value);" name="sa2_meter1KWh"
												id="sa2_meter1KWh" inputmode="numeric"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
										</tr>
										<tr class="">
											<td class="tg-0lax px-4 py-3" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												현재 누적 송전 유효전력량[kwh] - 전체</td>
											<td class="tg-0lax px-4 py-3" colspan="3"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text" readonly="readonly" value=""
												name="sa2_meternum2" id="sa2_meternum2"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
											<td class="tg-0lax px-4 py-3  " colspan="3"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text"
												oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
												onkeyup="Divison2(this.value)" name="sa2_meter2KWh"
												id="sa2_meter2KWh" inputmode="numeric"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
										</tr>
										<tr class="">
											<td class="tg-0lax px-4 py-3 bg-table-violet" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												검침 대상</td>
											<td class="tg-0lax px-4 py-3 bg-table-violet" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text" readonly="readonly" value=""
												name="changenum" id="changenum"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
											<td class="tg-0lax px-4 py-3 bg-table-violet" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text" readonly="readonly" value=""
												name="changenum2" id="changenum2"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
											<td class="tg-0lax px-4 py-3 bg-table-violet" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												인버터 데이터</td>
										</tr>
										<tr class="">
											<td class="tg-0lax px-4 py-3 bg-table-violet" colspan="1"
												rowspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												*검침 주기</td>
											<td class="tg-0lax px-4 py-3 bg-table-violet" colspan="1"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												기간</td>
											<td class="tg-0lax px-4 py-3" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text" name="sa2_meter1period"
												id="sa2_meter1period" readonly="readonly"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
											<td class="tg-0lax px-4 py-3" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text" name="sa2_meter2period"
												id="sa2_meter2period" readonly="readonly"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
											<td class="tg-0lax px-4 py-3" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text" name="sa2_inverterperiod"
												id="sa2_inverterperiod" readonly="readonly"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
										</tr>
										<tr class="">
											<td class="tg-0lax px-4 py-3 bg-table-violet" colspan="1"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												일</td>
											<td class="tg-0lax px-4 py-3" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text" name="sa2_meter1date" id="sa2_meter1date"
												readonly="readonly"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
											<td class="tg-0lax px-4 py-3" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text" name="sa2_meter2date" id="sa2_meter2date"
												readonly="readonly"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
											<td class="tg-0lax px-4 py-3" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text" name="sa2_inverterdate"
												id="sa2_inverterdate" readonly="readonly"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
										</tr>
										<tr class="">
											<td class="tg-0lax px-4 py-3 bg-table-violet" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												총발전량[kwh]</td>
											<td class="tg-0lax px-4 py-3" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text"
												oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
												name="sa2_meter1allKWh" id="sa2_meter1allKWh" inputmode="numeric"
												readonly="readonly"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
											<td class="tg-0laxpx-4 py-3" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text"
												oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
												name="sa2_meter2allKWh" id="sa2_meter2allKWh" inputmode="numeric"
												readonly="readonly"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
											<td class="tg-0lax px-4 py-3" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text"
												oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
												name="sa2_inverterallKWh" id="sa2_inverterallKWh" inputmode="numeric"
												readonly="readonly"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
										</tr>
										<tr class="">
											<td class="tg-0lax px-4 py-3 bg-table-violet" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												1일평균 발전량[kwh/day]</td>
											<td class="tg-0lax px-4 py-3" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text"
												oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
												name="sa2_meter1dayKWh" id="sa2_meter1dayKWh" inputmode="numeric"
												readonly="readonly"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
											<td class="tg-0lax px-4 py-3" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text"
												oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
												name="sa2_meter2dayKWh" id="sa2_meter2dayKWh" inputmode="numeric"
												readonly="readonly"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
											<td class="tg-0lax px-4 py-3" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text"
												oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
												name="sa2_inverterdayKWh" id="sa2_inverterdayKWh" inputmode="numeric"
												readonly="readonly"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
										</tr>
										<tr class="">
											<td class="tg-0lax px-4 py-3 bg-table-violet" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235);">
												1일평균 발전시간[hour/day]</td>
											<td class="tg-0lax px-4 py-3" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text"
												oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
												name="sa2_meter1dayhour" id="sa2_meter1dayhour" inputmode="numeric"
												readonly="readonly"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
											<td class="tg-0lax px-4 py-3" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text"
												oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
												name="sa2_meter2dayhour" id="sa2_meter2dayhour" inputmode="numeric"
												readonly="readonly"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
											<td class="tg-0lax px-4 py-3" colspan="2"
												style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
												<input type="text"
												oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
												name="sa2_inverterdayhour" id="sa2_inverterdayhour" inputmode="numeric"
												readonly="readonly"
												class="tb_gbla1 w-full border-none text-xs focus:outline-none"
												style="background-color: rgba(255, 255, 255, 0);">
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
					<div class="esco">
						<div class="px-5 my-4 text-bold text-base md:text-base lg:text-lg">
							<div class="flex items-center" data-html2canvas-ignore="true">
								<span>*종합의견 부분 캡쳐</span> <input type="checkbox"
									class="check ml-2 w-6 h-6" checked="checked"
									onclick="checkboxEvent(this)" style="border-radius: 4px;">
							</div>
						</div>
						<div class="w-full border" data-html2canvas-ignore="true"></div>
						<div class="esco flex items-center px-4 py-5 text-xs">
							<span class="imagePixel tg-0laxfont-medium">• 점검자 확인사항</span>
							<!--             <label for="checkList" class="mx-3 inline-flex justify-center font-semibold items-center w-16 py-1 border border-transparent rounded text-white bg-black flex-shrink-0">파일선택</label> -->
							<div data-html2canvas-ignore="true" class="disnonetarget">
								<input type="file" onchange="img_insert()"
									class="mx-3 font-semibold items-center w-16 py-1 border border-transparent rounded text-white flex-shrink-0"
									id="inputImage">
								<span class="filename"></span>
								<button type="button" onclick="img_delete()" style="background-color: #E53935;"
									class="imgdelete mx-3 font-semibold items-center w-16 py-1 border border-transparent rounded text-white bg-black flex-shrink-0">삭제</button>
<!-- 								<button type="button" id="sendButton" onclick="img_insert()" -->
<!-- 									class="mx-3 font-semibold items-center w-16 py-1 border border-transparent rounded text-white bg-black flex-shrink-0">등록</button> -->
							</div>
						</div>
						<div class="esco w-full border">
							<tr class="">
								<td class="tg-0lax px-4 py-3" colspan="2"
									style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
									<img src="" class="uploadImage" id="sa2_image">
								</td>
								<td class="tg-0lax px-4 py-3" colspan="2"
									style="min-height: 41px; height: 41px; border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">
									<textarea rows="5" name="sa2_opinion" id="sa2_opinion"
										class="tb_gbla1 w-full border-none text-xs focus:outline-none"
										style="background-color: rgba(255, 255, 255, 0);"></textarea>
								</td>
							</tr>
						</div>
					</div>
				</div>
				<div
					class="w-full rounded-lg bg-white my-4 md:md-4 lg:my-7 px-6 py-2">
					<div class="flex">
						<span class="imagePixel2 py-4">*발전소 이상 유무 선택</span>
						<div class="border-r border-gray-300 mx-5"></div>
						<span class="imagePixel3 py-4"> <label
							class="text-buttonText-red" for="problem">이상 있음</label> <input
							type="radio" name="sa2_problem" id="sa2_problem" value="1"
							class="ml-3 mr-5"> <label class="text-active-green"
							for="safe">이상 없음</label> <input type="radio" name="sa2_problem"
							id="sa2_problem" value="2" class="ml-3 mr-5" checked>
						</span>
					</div>
				</div>
				<div data-html2canvas-ignore="true"
					class="flex items-center justify-center text-sm md:text-sm lg:text-base font-bold my-4 md:md-4 lg:my-7">
					<button type="button" onclick="qwe()"
						class=" text-sm md:text-sm lg:text-base font-bold inline-flex mx-3 items-center py-3 px-6 border border-transparent rounded-lg text-black bg-table-violet flex-shrink-0">
						<img src="/resources/img/icon/rollbackIconBlack.svg" alt="초기화 아이콘"
							class="mr-1">초기화
					</button>
					<button type="button" onclick="SendAlim()"
						class="KAKAOMSG text-sm md:text-sm lg:text-base font-bold mx-3 items-center py-3 px-6 border border-transparent rounded-lg text-white bg-button-blue flex-shrink-0">알림전송
						후 저장</button>
					<button type="button" onclick="loadInfo()"
						class="text-sm md:text-sm lg:text-base font-bold mx-3 items-center py-3 px-6 border border-transparent rounded-lg text-white bg-button-blue flex-shrink-0">저장</button>
					
				</div>
				<input type="hidden" id="buttionType" name="buttionType" value="insert">
				<input type="hidden" id="sa2_keyno" name="sa2_keyno" value="">
				<input type="hidden" id="SU_DPP_KEYNO" name="SU_DPP_KEYNO" value=""> 
				<input type="hidden" id="sa2_inverternumtype" name="sa2_inverternumtype" value="">
				<input type="hidden" id="sa_writetype" name="sa_writetype" value="2">
				<input type="hidden" id="SU_KEYNO" name="SU_KEYNO" value="">
				<input type="hidden" id="imgSrc" name="imgSrc" value="">
				<input type="hidden" id="predataMeter1" name="predataMeter1" value="">
				<input type="hidden" id="predataMeter2" name="predataMeter2" value="">
				<input type="hidden" id="prewatt" name="prewatt" value="">
				<input type="hidden" id="sa2_dateMI" name="sa2_dateMI" value="${min}">
				<input type="hidden" id="sa2_dateS" name="sa2_dateS" value="${sec}">
				<input type="hidden" id="sa2_date3" name="sa2_date3" value="">
				<input type="hidden" id="Current_Conn_date" name="Current_Conn_date" value="">
				<input type="hidden" id="Pre_Conn_date" name="Pre_Conn_date" value="">
				<input type="hidden" id="SA_UI_KEYNO" name="SA_UI_KEYNO" value="${UI_KEYNO }">
				<input type="hidden" id="accpowerList" name="accpowerList" value="">
				<input type="hidden" id="pre_keyno" name="pre_keyno" value="">
				<input type="hidden" id="next_keyno" name="next_keyno" value="">
			</div>
		</div>
	</main>
</form:form>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script type="text/javascript">
var list = [];
$(function() {
	
	
	$(".hiddenTr").hide();
	$(".imgdelete").hide();
	
	//현황페이지에서 발전소 클릭 시 
	var chksu_keyno = "${chk_su_keyno}";
	
	if(chksu_keyno){
		changesulbi(chksu_keyno)
	}
	
	
	
	var change = "all";
	AreaChange(change);
	
	//선간전압Change 실행
	AC_Change(01);
	
	
	///(체크안된 div 캡쳐 안함)
	$(document).on('click','#allcheck',function(){
		if($('#allcheck').is(':checked')){
			$('.check').prop('checked',true);
			$('.esco').removeAttr('data-html2canvas-ignore');
		}else{     
			$('.check').prop('checked',false); 
			$('.esco').attr('data-html2canvas-ignore','true')
		} 
	});
	
	
	$(document).on('click','.check',function(){
	    if($('input[class=check]:checked').length==$('.check').length){  
			 $('#allcheck').prop('checked',true);    
		}else{       
			 $('#allcheck').prop('checked',false);     
		}
	});

	yearselect();
	monselect();
	
		var t = document.getElementById('sa2_meternum2');
		 
		t.addEventListener('change', function(event){
		 
      });
});

//qwer4321
function checkboxEvent(obj){
	if($(obj).is(':checked')){
		$(obj).closest(".esco").removeAttr('data-html2canvas-ignore')
	}else{
		$(obj).closest(".esco").attr('data-html2canvas-ignore','true')
	}
}

function SendAlim(){
	
	var array = new Array(); 
	var target = $("#esco");
    var radioVal = $('input[name="sa2_problem"]:checked').val();
   	array.push(radioVal);
   	
   	if(!validationCheck()) return false
		if(array[0] == "1" || array[0] == "2"){
			if(confirm("저장 후 즉시 알림 전송하시겠습니까?")){
				
				//전회차 정보 조회 초기화
				$(".qwe1").remove();
				$(".qwe2").remove();
				$(".qwe3").remove();
				$(".qwe4").remove();
				
				$("input").attr('style','font-size:24px;height:40px;')
				$("td").attr('style','font-size:24px;height:40px;')
				$("span2").attr('style','font-size:24px;')
				$("#sa2_wether").attr('style','font-size:22px;height:40px;')
				$("#sa2_adminname").attr('style','font-size:22px;height:40px;')
				$(".imagePixel").attr('style','font-size:24px;height:40px;')
				$(".imagePixel2").attr('style','font-size:24px;height:40px;')
				$(".imagePixel2").text('발전소 이상 유무')
				$(".nowtimeAlim").attr('style','width:100%;')
				
				if(radioVal == 1){
					$(".imagePixel3").html('<label class="text-buttonText-red" for="problem">이상 있음</label><input type="hidden" name="sa2_problem" value="1">')
					$(".imagePixel3").attr('style','font-size:24px;height:40px;')
				}else{
					$(".imagePixel3").html('<label class="text-active-green" for="safe">이상 없음</label><input type="hidden" name="sa2_problem" value="2">')
					$(".imagePixel3").attr('style','font-size:24px;height:40px;')
				}
				

				if (target != null && target.length > 0) {
					
					var t = target[0];

					html2canvas(t).then(function(canvas) {
						var myImg = canvas.toDataURL("image/jpeg", 'image/octet-stream');
						
						myImg = myImg.replace("data:image/jpeg;base64,", "");
						$("#imgSrc").val(myImg);
						
						
 						$.ajax({
 							type : "POST",
 							data : $("#Form").serialize(),
 							dataType : "text",
 							url : "/sfa/Admin/sendAilmaAjax.do?${_csrf.parameterName}=${_csrf.token}",
 							success : function(data) {
 								alert(data);
 								location.reload();
 							},
 							error : function(a, b, c) {
 								alert("error");
 							}
 						});
					});
				}
			}else{
				
		 	}		
		}else{
			alert("발전소 이상유무를 선택해주세요");
		}
}
	
function loadInfo(){
	
	var array = new Array();
	var array2 = new Array();
    var radioVal = $('input[name="sa2_problem"]:checked').val();
    var adminNameval = $('#sa2_problem').val();
    array.push(radioVal);
    
    dateReplace();
    
   	if(!validationCheck()) return false
		if(array[0] == "1" || array[0] == "2"){
			if(confirm("저장하시겠습니까?")){
				
				 $.ajax({
			        url: '/sfa/safe/safepaper2Insert.do?${_csrf.parameterName}=${_csrf.token}',
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
		 	}else{
		 		
		 	}		
		}else{
			alert("발전소 이상유무를 선택해주세요");
		}
		
	
}

//연월 셋팅
function yearselect(){
	
	var dt = new Date();
	var comyear = dt.getFullYear();
	years = "";
		
// 	for(var i = (comyear-5); i <= (comyear); i++){
		years += $("#Year").append("<option value="+comyear+">"+comyear+"년"+"</option>");
// 	}
}

function monselect(){
	
	var dt = new Date();
	var commonth = dt.getMonth();
	
	month = "";
	for(var i = 1; i <= 12; i++){
		month += $("#Month").append("<option value="+i+">"+i+"월"+"</option>");
	}
}


function datanumselect(){
	
	var a = $("#su_keyno").val();
	var b = $("#Year").val();
	var c = $("#Month").val();
	
	//append 초기화
	$("#selectgroup").empty();
	
	
	if(a != ''){
		$.ajax({
	        url: '/sfa/sfaAdmin/previewAjax.do?${_csrf.parameterName}=${_csrf.token}',
	        type: 'POST',
	        data: $("#Form").serialize(),
	        async: false,  
	        success: function(data) {
	        
	        	if(data == null || data == ""){
	        		alert("해당 연월에 작성한 양식이 없습니다");
	        	}else{		
					for(var i=0; i<data.length; i++){
						$("#selectgroup").append("<option value = "+data[i].sa2_keyno+">"+data[i].datenum+"</option>"); // <option>값 넣어줌
					 }  		
	        	}
	        	
	        },
	        error: function(){
	        	alert("월을 선택하세요");
	        }
		});
	}else{
		alert("발전소를 선택해주세요")
	}
	
}

//이전 양식 조회
function view(){
	
	$.ajax({
        url: '/sfa/sfaAdmin/previewplaceholder.do?${_csrf.parameterName}=${_csrf.token}',
        type: 'POST',
        data: $("#Form").serialize(),
        async: false,  
        success: function(data) {
        	
        	var num = Number($("#sa2_inverternumtype").val())
        	var count = 1;
        	

        	var nowpower = data.preData.sa2_nowpower
    		var todaypower = data.preData.sa2_todaypower
    		var accpower = data.preData.sa2_accpower
    		var periodpower = data.preData.sa2_periodpower

    		var nowpowerlist = []
    		var todaypowerlist = []
    		var accpowerlist = []
    		var periodpowerlist = []

    		if(nowpower != null | todaypower != null | accpower != null){
    			
    			nowpowerlist = nowpower.split(",")	
    			todaypowerlist = todaypower.split(",")	
    			accpowerlist = accpower.split(",")	
    			periodpowerlist = periodpower.split(",")	
    			
    			for(var i = 0; i <= num-1; i++ ){
    				if(accpowerlist[i] == ''){
						accpowerlist[i] = 0									
    				}else{
						accpowerlist[i] =  accpowerlist[i]			
    				}
    			}
    			
    			
    	    }
    		
        	$(".qwe1").remove();
			$(".qwe2").remove();
			$(".qwe3").remove();
			$(".qwe4").remove();
			
  			$("#sa2_nowpower").attr("style","width:50%; background-color:rgba( 255, 255, 255, 0 )");
			$("#sa2_todaypower").attr("style","width:50%");
			$("#sa2_accpower").attr("style","width:50%");
			$("#sa2_periodpower").attr("style","width:50%");
	
			$(".la2").append('<input type="text" style="background-color:rgba( 255, 255, 255, 0 ); color: gray; text-align: left; width:50%;" class="qwe1 w-full border-none text-xs focus:outline-none" value=/'+nowpowerlist[0]+' name="qwe1" id="qwe1" readonly="readonly">')
  			$(".la3").append('<input type="text" style="background-color:rgba( 255, 255, 255, 0 ); color: gray; text-align: left; width:50%;" class="qwe2 w-full border-none text-xs focus:outline-none" value=/'+todaypowerlist[0]+' name="qwe2" id="qwe1" readonly="readonly">')
  			$(".la4").append('<input type="text" style="background-color:rgba( 255, 255, 255, 0 ); color: gray; text-align: left; width:50%;" class="qwe3 w-full border-none text-xs focus:outline-none" value=/'+accpowerlist[0]+' name="qwe3" id="qwe1" readonly="readonly">')
  			$(".la5").append('<input type="text" style="background-color:rgba( 255, 255, 255, 0 ); color: gray; text-align: left; width:50%;" class="qwe4 w-full border-none text-xs focus:outline-none" value=/'+periodpowerlist[0]+' name="qwe4" id="qwe1" readonly="readonly">')
  			
			
			for(var i = 0; i <= num-1; i++ ){
				
				//lanum을 다르게 해줘야 전회차정보 td어펜드시 인버터 번호에 맞는 정보가 들어감
				var lanum = count + 9;
				var lanum2 = count + 19;
				var lanum3 = count + 29;
				var lanum4 = count + 39;
				count += 1;
				
				//하나의 td에 전회차 정보 input을 append하므로 원래 input의 width를 절반으로 줄여줌 
				$(".la"+lanum+" > #sa2_nowpower").attr("style","width:50%; background-color:rgba( 255, 255, 255, 0 )");
				$(".la"+lanum2+" > #sa2_todaypower").attr("style","width:50%");
				$(".la"+lanum3+" > #sa2_accpower").attr("style","width:50%");
				$(".la"+lanum4+" > #sa2_periodpower").attr("style","width:50%");
				
	  			$(".la"+lanum+"").append('<input type="text" style=" background-color:rgba( 255, 255, 255, 0 ); color: gray; text-align: left; width:50%;" class="qwe1 w-full border-none text-xs focus:outline-none" value=/'+nowpowerlist[i+1]+' name="qwe1" id="qwe1" readonly="readonly">')
	  			$(".la"+lanum2+"").append('<input type="text" style="background-color:rgba( 255, 255, 255, 0 ); color: gray; text-align: left; width:50%;" class="qwe2 w-full border-none text-xs focus:outline-none" value=/'+todaypowerlist[i+1]+' name="qwe2" id="qwe1" readonly="readonly">')
	  			$(".la"+lanum3+"").append('<input type="text" style="background-color:rgba( 255, 255, 255, 0 ); color: gray; text-align: left; width:50%;" class="qwe3 w-full border-none text-xs focus:outline-none" value=/'+accpowerlist[i+1]+' name="qwe3" id="qwe1" readonly="readonly">')
	  			$(".la"+lanum4+"").append('<input type="text" style="background-color:rgba( 255, 255, 255, 0 ); color: gray; text-align: left; width:50%;" class="qwe4 w-full border-none text-xs focus:outline-none" value=/'+periodpowerlist[i+1]+' name="qwe4" id="qwe1" readonly="readonly">')

			}
			
        },
        error: function(){
        	alert("발전소,월,일을 선택해주세요");
        }
	}); 
}

function changesulbi(keyno) {
	
	$("#SU_KEYNO").val(keyno);
	$("#Month").val("");
	$("#selectgroup").empty();
	var UIKEYNO = $("#SA_UI_KEYNO").val();

	//일자변경
	dateReplace()
	var formatt = $("#sa2_date").val();
	var formatDate = formatt.substring(0,7);
	
	var date = new Date();
	var dateMonth = date.getMonth() + 1;
	var Mon = $("#sa2_dateM").val();
	var Day = $("#sa2_dateD").val();
	
	var now = Mon+"/"+Day;
	var premonth = (dateMonth === 1) ? 12 : (dateMonth - 1);
	
	$.ajax({
        url: '/sfa/safe/safeuserselect.do?${_csrf.parameterName}=${_csrf.token}',
        type: 'POST',
        data: {
			SU_KEYNO : keyno,
			UIKEYNO : UIKEYNO,
			formatDate : formatDate
		},
        async: false,  
        success: function(result) {
			
        	// 첫작성 시 오늘날짜를 위한 날짜 포맷팅--------------------------------------------------------
        	var currentDate = new Date();
        	var formattedDate = currentDate.getFullYear() + '-' +
        	    ('0' + (currentDate.getMonth() + 1)).slice(-2) + '-' +
        	    ('0' + currentDate.getDate()).slice(-2);

       	    var month = ('0' + (currentDate.getMonth() + 1)).slice(-2);
       		var day = ('0' + currentDate.getDate()).slice(-2);
       		var formattedDate2 = month + '/' + day;    
        	    
        	// ------------------------------------------------------------------------
        	 
        	
        	var predate = result.predate.predate.substring(0,5);
        	if(result.predate.predate.length == 0) {
        		predate = formattedDate2;
        	}
        	var premonth2 = result.data.SU_SA_ADMINDATE;
        	var lastday = Number(result.lastday);
        	var diff = Number(result.datediff.diff);
        	var admincount = result.count.count;
        	var preacctype =  result.preData.sa2_accpowertype;
        	
        	//첫작성 시 preacctype 없을때
        	if(!preacctype){
        		preacctype = "KWh"
        	}
        	
        	if(result.CurrentData.length == 0) {
        		$("#Current_Conn_date").val(formattedDate)
        	}else{
        		$("#Current_Conn_date").val(result.CurrentData[0].max_conn_date)
        	}

        	
        	
        	
        	$("#sa2_count2").text(result.count.count)
        	$("#sa2_count").text(result.data.SU_SA_RG);
        	$("#SU_DPP_KEYNO").val(result.data.SU_DPP_KEYNO)
        	$("#sa2_title").val(result.data.SU_SA_SULBI)
        	$("#sa2_palntKW").val(result.data.SU_SA_VOLUM)
        	$("#sa2_palntV").val(result.data.SU_SA_VOLT)
        	$("#sa2_palntCT").val(result.data.SU_SA_CT)
        	$("#sa2_date2").val(premonth2)
        	$("#sa2_inverternumtype").val(result.data.SU_SA_INVERTERNUM)
			$("#sa2_meternum1").val(result.data.SU_SA_METER1)
        	$("#sa2_meternum2").val(result.data.SU_SA_METER2)
        	$("#changenum").val(result.data.SU_SA_METER1)
        	$("#changenum2").val(result.data.SU_SA_METER2)
        	$("#sa2_inverterperiod").val(predate+"~"+now)
        	$("#sa2_inverterdate").val(result.datediff.diff)
        	$("#sa2_meter1period").val(premonth+"월 검침일 : "+ premonth2+"일")
        	$("#sa2_meter2period").val(predate+"~"+now)
        	$("#sa2_meter1date").val(lastday)
        	$("#sa2_meter2date").val(diff)
        	$("#prewatt").val(result.prewatt)
        	$("#Pre_Conn_date").val(predate)
        	$("#pre_keyno").val(result.data.su_keyno_pre)
        	$("#next_keyno").val(result.data.su_keyno_next)
        	
        	
        	
        	
        	
        	
        	
        	
        	if(result.preData == null || result.preData == "" || result.preData == "undefined" ){
       
        		//다른 발전소의 값이 들어가지 않게 값 비워줌
        		$("#sa2_meter1KWh").val('');
        		$("#predataMeter1").val('');
        		$("#predataMeter2").val('');
        		
        		//다시 값 넣어줌
        		$("#sa2_meter1KWh").attr("placeholder","매달 첫 점검은 직접 작성해주세요");
        		$("#predataMeter1").val(0);
        		$("#predataMeter2").val(0);
        	}else{
        		if(admincount == "0"){
	        		$("#sa2_meter1KWh").attr("placeholder","매달 첫 점검은 직접 작성해주세요");
        		}else{
	        		$("#sa2_meter1KWh").val(result.preData.sa2_meter1KWh)        			        			
        		}
        		$("#predataMeter1").val(result.preData.sa2_meter1KWh)
        		$("#predataMeter2").val(result.preData.sa2_meter2KWh)
        	}
        	
        	
        	
        	//인버터 대수에 따른 <td> append
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
			
			$("#Year").removeAttr("style","display:none;");
    		$("#Month").removeAttr("style","display:none;");
    		$("#selectgroup").removeAttr("style","display:none;");
    		$("#autoInsert").removeAttr("style","display:none;");
			
        	if(num > 10){        		
        		//10대 이상은 전회차 데이터 보기 none
        		$("#Year").attr("style","display:none;");
        		$("#Month").attr("style","display:none;");
        		$("#selectgroup").attr("style","display:none;");
        		
        		
        		if(Object.keys(result.preData).length === 0){
	        		var annacc = 0
	        		var preannacc = 0
	        		var peridev = 0		
        		}else{
        			var annacc = result.preData.sa2_annacc
            		var preannacc = result.preData.sa2_preannacc
            		var peridev = result.preData.sa2_peridev
        		}
        		
        		
        		
        		var annacclist = []
        		var preannacclist = []
        		var peridevlist = []

        		if(annacc == 0 && preannacc == 0 && peridev == 0){
        			
        			for(var i = 0; i <= num-1; i++ ){	
        					annacclist[i] = 0				
        				}     			
        	    }else{     	    	
        	    	annacclist = annacc.split(",")	
        			preannacclist = preannacc.split(",")	
        			peridevlist = peridev.split(",")	
        			
        			for(var i = 0; i <= num-1; i++ ){
        				if(annacclist[i] == ''){
        					annacclist[i] = 0    					
        				}else{
	        				annacclist[i] =  annacclist[i]
        				}
        			}
 					     	    
        	    }
        		
        		
        		
        		
        		$(".etcTr").hide();
        		$(".hiddenTr").show();
        		$("#inputplus0").html('<td class="tg-0lax px-4 py-3 text-center font-semibold bg-table-violet" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">인버터 번호</td>')
    			$("#inputplus1").html('<td class="tg-0lax px-4 py-3 text-center font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">연간 현재 누적<select id="sa2_accpowertype" name="sa2_accpowertype" onchange = "MwhCal_ten(); kwchange(this.value);" style="padding-top:0;padding-bottom:0;background-color:#f0f2f5;border:none;border-radius:4px;margin-left:10px;margin-right:10px;font-size:12px"><option value="KWh">KWh</option><option value="MWh">MWh</option></select></td>')
    			$("#inputplus2").html('<td class="tg-0lax px-4 py-3 text-center font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">전회 누적[<input class="w-2\/12 font-semibold text-center" id="sa2_preacctype" name = "sa2_preacctype" value = "" readonly="readonly">]</td>')
    			$("#inputplus3").html('<td class="tg-0lax px-4 py-3 text-center font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">기간 발전[KWh]</td>')
    			$("#inputplus4").hide();
        		$("#inputplus5").html('<td class="tg-0lax px-4 py-3 text-center font-semibold bg-table-violet" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">인버터 번호</td>')
    			$("#inputplus6").html('<td class="tg-0lax px-4 py-3 text-center font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">연간 현재 누적[<input class="w-2\/12 font-semibold text-center" id="sa2_accpowertype2" name = "sa2_accpowertype2" value = "" readonly="readonly">]</td>')
    			$("#inputplus7").html('<td class="tg-0lax px-4 py-3 text-center font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">전회 누적[<input class="w-2\/12 font-semibold text-center" id="sa2_preacctype2" name = "sa2_preacctype2" value = "" readonly="readonly">]</td>')
    			$("#inputplus8").html('<td class="tg-0lax px-4 py-3 text-center font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">기간 발전[KWh]</td>')
    			$("#inputplus9").hide();
        		
        		
        		
	       		for(var i=1; i<=num; i++){
		   			
	       			//데이터 연동 안할 시
	       			if(result.InverterData == null || result.InverterData == "" || result.InverterData == "undefined"){
	            		
		       			if(count < 11){	
		       				
		       				if(count == "1"){
			       				var conutt = count + 1
				   				$("#inputplus0").append('<td class="tg-0lax px-4 py-3 text-center font-semibold bg-table-violet" style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;"><select id="sa2_LR" name ="sa2_LR" class="default_input_style input_margin_x_10px input_padding_y_4px"><option value = "L">좌</option><option value = "R">우</option></select>'+count+'</td>')
				    			$("#inputplus1").append('<td class="tgsfa1 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" class="w-full border-none text-xs text-center focus:outline-none" value="" name="sa2_annacc"  oninput="method_1(\'inputplus1\',\'inputplus2\',\'inputplus3\',\''+conutt+'\');" oninput="this.value = this.value.replace(/[^0-9.]/g, "").replace(/(\..*)\./g, "$1");" style="background-color:rgba( 255, 255, 255, 0 )"></td>')
				    			$("#inputplus2").append('<td class="tgsfa2 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" class="w-full border-none text-xs text-center focus:outline-none" value='+annacclist[i-1]+' name="sa2_preannacc" oninput="inputNumberFormat(this) style="background-color:rgba( 255, 255, 255, 0 )" readonly="readonly"></td>')
				    			$("#inputplus3").append('<td class="tgsfa3 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" class="w-full border-none text-xs text-center focus:outline-none" value="" name="sa2_peridev" oninput="inputNumberFormat(this)" style="background-color:rgba( 255, 255, 255, 0 )" readonly="readonly"></td>')	
		       				}else{
		       					var conutt = count + 1
				   				$("#inputplus0").append('<td class="tg-0lax px-4 py-3 text-center font-semibold bg-table-violet" style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">'+count+'</td>')
				    			$("#inputplus1").append('<td class="tgsfa1 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" class="w-full border-none text-xs text-center focus:outline-none" value="" name="sa2_annacc"  oninput="method_1(\'inputplus1\',\'inputplus2\',\'inputplus3\',\''+conutt+'\');" oninput="this.value = this.value.replace(/[^0-9.]/g, "").replace(/(\..*)\./g, "$1");" style="background-color:rgba( 255, 255, 255, 0 )"></td>')
				    			$("#inputplus2").append('<td class="tgsfa2 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" class="w-full border-none text-xs text-center focus:outline-none" value='+annacclist[i-1]+' name="sa2_preannacc" oninput="inputNumberFormat(this) style="background-color:rgba( 255, 255, 255, 0 )" readonly="readonly"></td>')
				    			$("#inputplus3").append('<td class="tgsfa3 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" class="w-full border-none text-xs text-center focus:outline-none" value="" name="sa2_peridev" oninput="inputNumberFormat(this)" style="background-color:rgba( 255, 255, 255, 0 )" readonly="readonly"></td>')	
		       					
		       				}      		
		       				
		       			}else{
			       				var conutt = count + 1
			       				$("#inputplus5").append('<td class="tg-0lax px-4 py-3 text-center font-semibold bg-table-violet" style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">'+count+'</td>')
				    			$("#inputplus6").append('<td class="tgsfa6 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" class="w-full border-none text-xs text-center focus:outline-none" value="" name="sa2_annacc" oninput="method_1(\'inputplus6\',\'inputplus7\',\'inputplus8\',\''+conutt+'\');" oninput="this.value = this.value.replace(/[^0-9.]/g, "").replace(/(\..*)\./g, "$1");" style="background-color:rgba( 255, 255, 255, 0 )"></td>')
				    			$("#inputplus7").append('<td class="tgsfa7 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" class="w-full border-none text-xs text-center focus:outline-none" value='+annacclist[i-1]+' name="sa2_preannacc" oninput="inputNumberFormat(this)" style="background-color:rgba( 255, 255, 255, 0 )" readonly="readonly"></td>')
				    			$("#inputplus8").append('<td class="tgsfa8 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" class="w-full border-none text-xs text-center focus:outline-none" value="" name="sa2_peridev" oninput="inputNumberFormat(this)" style="background-color:rgba( 255, 255, 255, 0 )" readonly="readonly"></td>')
		
		       			}
		       			count += 1;
		       		
		       			
		       		//데이터 연동 시
	            	}else{
		       			if(count < 11){	
		       				if(count == "1"){
		       					var conutt = count + 1
				   				$("#inputplus0").append('<td class="tg-0lax px-4 py-3 text-center font-semibold" style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;"><select id="sa2_LR" name ="sa2_LR" class="default_input_style input_margin_x_10px input_padding_y_4px"><option value = "L">좌</option><option value = "R">우</option></select>'+count+'</td>')
				    			$("#inputplus1").append('<td class="tgsfa1 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" class="w-full border-none text-xs text-center focus:outline-none" value='+result.InverterData[i-1].Cumulative_Generation+' name="sa2_annacc"  oninput="method_1(\'inputplus1\',\'inputplus2\',\'inputplus3\',\''+conutt+'\');" style="background-color:rgba( 255, 255, 255, 0 )"></td>')
				    			$("#inputplus2").append('<td class="tgsfa2 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" class="w-full border-none text-xs text-center focus:outline-none" value='+annacclist[i-1]+' name="sa2_preannacc" oninput="inputNumberFormat(this) style="background-color:rgba( 255, 255, 255, 0 )" readonly="readonly"></td>')
				    			$("#inputplus3").append('<td class="tgsfa3 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" class="w-full border-none text-xs text-center focus:outline-none" value="" name="sa2_peridev" oninput="inputNumberFormat(this)" style="background-color:rgba( 255, 255, 255, 0 )" readonly="readonly"></td>')	
		       				}else{
			       				var conutt = count + 1
				   				$("#inputplus0").append('<td class="tg-0lax px-4 py-3 text-center font-semibold" style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">'+count+'</td>')
				    			$("#inputplus1").append('<td class="tgsfa1 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" class="w-full border-none text-xs text-center focus:outline-none" value='+result.InverterData[i-1].Cumulative_Generation+' name="sa2_annacc"  oninput="method_1(\'inputplus1\',\'inputplus2\',\'inputplus3\',\''+conutt+'\');" style="background-color:rgba( 255, 255, 255, 0 )"></td>')
				    			$("#inputplus2").append('<td class="tgsfa2 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" class="w-full border-none text-xs text-center focus:outline-none" value='+annacclist[i-1]+' name="sa2_preannacc" oninput="inputNumberFormat(this) style="background-color:rgba( 255, 255, 255, 0 )" readonly="readonly"></td>')
				    			$("#inputplus3").append('<td class="tgsfa3 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" class="w-full border-none text-xs text-center focus:outline-none" value="" name="sa2_peridev" oninput="inputNumberFormat(this)" style="background-color:rgba( 255, 255, 255, 0 )" readonly="readonly"></td>')	
		       				}
			       			
		       			}else{
			       				var conutt = count + 1
			       				$("#inputplus5").append('<td class="tg-0lax px-4 py-3 text-center font-semibold" style="border-right: 1px solid rgb(229, 231, 235); border-left: 1px solid rgb(229, 231, 235); padding: 0px;">'+count+'</td>')
				    			$("#inputplus6").append('<td class="tgsfa6 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" class="w-full border-none text-xs text-center focus:outline-none" value='+result.InverterData[i].Cumulative_Generation+' name="sa2_annacc" oninput="method_1(\'inputplus6\',\'inputplus7\',\'inputplus8\',\''+conutt+'\');" style="background-color:rgba( 255, 255, 255, 0 )"></td>')
				    			$("#inputplus7").append('<td class="tgsfa7 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" class="w-full border-none text-xs text-center focus:outline-none" value='+annacclist[i-1]+' name="sa2_preannacc" oninput="inputNumberFormat(this)" style="background-color:rgba( 255, 255, 255, 0 )" readonly="readonly"></td>')
				    			$("#inputplus8").append('<td class="tgsfa8 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" class="w-full border-none text-xs text-center focus:outline-none" value="" name="sa2_peridev" oninput="inputNumberFormat(this)" style="background-color:rgba( 255, 255, 255, 0 )" readonly="readonly"></td>')
		       				
		
		       			}
		       			count += 1;
	            		
	            	}
	       			
	       		}
	       		list.length = 0;
	       		
	 
	       		//자동계산(전월 누적으로 총발전량, 1일평균 계산 및 첫 작성일때 분기처리)
        		if(result.preData == null || result.preData == 'undefined'){
        			Divison(0)
        		}else{
        			Divison(result.preData.sa2_meter1KWh)
        		}
	       		
		       
	       		//td 어펜드 후에 kwh, mwh넣어주고 "MWh" 일때만 수식 function 실행
  		       	$("#sa2_accpowertype").val(preacctype);
  		       	$("#sa2_preacctype").val(preacctype);
  		       	$("#sa2_preacctype2").val(preacctype);
  		      	var preacctypeVal = $("#sa2_accpowertype").val();
  		      	
  		      	//11번 인버터부터 kw/mw표시 function
  		      	kwchange(preacctypeVal)
  		      	
 				if(preacctypeVal == "MWh"){
 					MwhCal_ten()
 				}
	       		
	       		
        	}else{
      
        		if(Object.keys(result.preData).length === 0){
        			
	        		var nowpower = 0
	        		var todaypower = 0
	        		var accpower = 0
        		}else{
	        		var nowpower = result.preData.sa2_nowpower
	        		var todaypower = result.preData.sa2_todaypower
	        		var accpower = result.preData.sa2_accpower   			
        		}

        		var nowpowerlist = []
        		var todaypowerlist = []
        		var accpowerlist = []
		
        		if(nowpower == 0 && todaypower == 0 && accpower == 0){
        			for(var i = 0; i <= num-1; i++ ){
        				accpowerlist[i] = 0	
        			}
        	    }else{ 	
        			nowpowerlist = nowpower.split(",")	
        			todaypowerlist = todaypower.split(",")	
        			accpowerlist = accpower.split(",")
        			
        			
        			for(var i = 0; i <= num-1; i++ ){
        				if(accpowerlist[i] == ''){
        					accpowerlist[i] = 0    					
        				}else{
        					//이전데이터 Mwh로 적었으면 *1000 아니면 그대로 넣기(점검때마다 kw로도 적고 mw로도 적기때문에)
        					if(preacctype == "MWh"){
        						accpowerlist[i] =  accpowerlist[i]*1000
        	 				}else{
        						accpowerlist[i] =  accpowerlist[i]				
        	 					
        	 				}
        				}
        			}
        	    }
        		
        		
        		var conutt = count + 1
        		var put = "inputplus3";
        		var put2 = "inputplus4";
        		
        		$(".hiddenTr").hide();
        		$(".etcTr").show();
        		$("#inputplus4").show();
        		
        		if(result.InverterData == null || result.InverterData == "" || result.InverterData == "undefined"){
        			if(num == "1"){
        				$("#inputplus0").html('<td class="tg-0lax px-4 py-3 text-left font-semibold bg-table-violet" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">인버터 번호</td><td class="tg-0lax px-4 py-3 text-center bg-table-violet font-semibold" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0">1</td>');
    					$("#inputplus1").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">현재 출력 [Kwh]</td><td class="la2 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value="" name="sa2_nowpower" id="sa2_nowpower"><input type="hidden" value="" name="sa2_nowpower1"></td>');
    					$("#inputplus2").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">금일 발전량[Kwh]</td><td class="la3 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value="" name="sa2_todaypower" id="sa2_todaypower"><input type="hidden" value="" name="sa2_todaypower1"></td>');
    					$("#inputplus3").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">누적 발전량<select id="sa2_accpowertype" name="sa2_accpowertype" onchange = "MwhCal_one()" style="padding-top:0;padding-bottom:0;background-color:#f0f2f5;border:none;border-radius:4px;margin-left:10px;margin-right:10px;font-size:12px"><option value="KWh">KWh</option><option value="MWh">MWh</option></select></td><td class="la4 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value="" name="sa2_accpower" id="sa2_accpower" oninput="method_2(\'inputplus3\',\'inputplus4\',\''+conutt+'\');" ><input type="hidden" value='+accpowerlist[0]+' name="sa2_accpower1"></td>');
    					$("#inputplus4").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">기간 발전량[Kwh]</td><td class="la5 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value="" name="sa2_periodpower" id="sa2_periodpower" readonly="readonly"><input type="hidden" value="" id ="sa2_periodpower1" name="sa2_periodpower1"></td>');
        			}else{
        				$("#inputplus0").html('<td class="tg-0lax px-4 py-3 text-left font-semibold bg-table-violet" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">인버터 번호</td><td class="tg-0lax px-4 py-3 text-center bg-table-violet font-semibold" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><select id="sa2_LR" name ="sa2_LR" class="default_input_style input_margin_x_10px input_padding_y_4px"><option value = "L">좌</option><option value = "R">우</option></select>1</td>');
    					$("#inputplus1").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">현재 출력 [Kwh]</td><td class="la2 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value="" name="sa2_nowpower" id="sa2_nowpower"><input type="hidden" value="" name="sa2_nowpower1"></td>');
    					$("#inputplus2").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">금일 발전량[Kwh]</td><td class="la3 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value="" name="sa2_todaypower" id="sa2_todaypower"><input type="hidden" value="" name="sa2_todaypower1"></td>');
    					$("#inputplus3").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">누적 발전량<select id="sa2_accpowertype" name="sa2_accpowertype" onchange = "MwhCal_one()" style="padding-top:0;padding-bottom:0;background-color:#f0f2f5;border:none;border-radius:4px;margin-left:10px;margin-right:10px;font-size:12px"><option value="KWh">KWh</option><option value="MWh">MWh</option></select></td><td class="la4 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value="" name="sa2_accpower" id="sa2_accpower" oninput="method_2(\'inputplus3\',\'inputplus4\',\''+conutt+'\');" ><input type="hidden" value='+accpowerlist[0]+' name="sa2_accpower1"></td>');
    					$("#inputplus4").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">기간 발전량 [kwh]</td><td class="la5 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value="" name="sa2_periodpower" id="sa2_periodpower" readonly="readonly"><input type="hidden" value="" id ="sa2_periodpower1" name="sa2_periodpower1"></td>');
        			}	
        			
        		}else{     			
        			if(num == "1"){
        				$("#inputplus0").html('<td class="tg-0lax px-4 py-3 text-left font-semibold bg-table-violet" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">인버터 번호</td><td class="tg-0lax px-4 py-3 text-center bg-table-violet font-semibold" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0">1</td>');
    					$("#inputplus1").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">현재 출력 [Kwh]</td><td class="la2 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+result.InverterData[0].Active_Power+' name="sa2_nowpower" id="sa2_nowpower"><input type="hidden" value="" name="sa2_nowpower1"></td>');
    					$("#inputplus2").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">금일 발전량[Kwh]</td><td class="la3 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+result.InverterData[0].Daily_Generation+' name="sa2_todaypower" id="sa2_todaypower"><input type="hidden" value="" name="sa2_todaypower1"></td>');
    					$("#inputplus3").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">누적 발전량<select id="sa2_accpowertype" name="sa2_accpowertype" onchange = "MwhCal_one()" style="padding-top:0;padding-bottom:0;background-color:#f0f2f5;border:none;border-radius:4px;margin-left:10px;margin-right:10px;font-size:12px"><option value="KWh">KWh</option><option value="MWh">MWh</option></select></td><td class="la4 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+result.InverterData[0].Cumulative_Generation+' name="sa2_accpower" id="sa2_accpower" oninput="method_2(\'inputplus3\',\'inputplus4\',\''+conutt+'\');" ><input type="hidden" value='+accpowerlist[0]+' name="sa2_accpower1"></td>');
    					$("#inputplus4").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">기간 발전량[Kwh]</td><td class="la5 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value="" name="sa2_periodpower" id="sa2_periodpower" readonly="readonly"><input type="hidden" value="" id ="sa2_periodpower1" name="sa2_periodpower1"></td>');
        			}else{
        				$("#inputplus0").html('<td class="tg-0lax px-4 py-3 text-left font-semibold bg-table-violet" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235)">인버터 번호</td><td class="tg-0lax px-4 py-3 text-center bg-table-violet font-semibold" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><select id="sa2_LR" name ="sa2_LR" class="default_input_style input_margin_x_10px input_padding_y_4px"><option value = "L">좌</option><option value = "R">우</option></select>1</td>');
    					$("#inputplus1").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">현재 출력 [Kwh]</td><td class="la2 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+result.InverterData[0].Active_Power+' name="sa2_nowpower" id="sa2_nowpower"><input type="hidden" value="" name="sa2_nowpower1"></td>');
    					$("#inputplus2").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">금일 발전량[Kwh]</td><td class="la3 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+result.InverterData[0].Daily_Generation+' name="sa2_todaypower" id="sa2_todaypower"><input type="hidden" value="" name="sa2_todaypower1"></td>');
    					$("#inputplus3").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">누적 발전량<select id="sa2_accpowertype" name="sa2_accpowertype" onchange = "MwhCal_one()" style="padding-top:0;padding-bottom:0;background-color:#f0f2f5;border:none;border-radius:4px;margin-left:10px;margin-right:10px;font-size:12px"><option value="KWh">KWh</option><option value="MWh">MWh</option></select></td><td class="la4 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+result.InverterData[0].Cumulative_Generation+' name="sa2_accpower" id="sa2_accpower" oninput="method_2(\'inputplus3\',\'inputplus4\',\''+conutt+'\');" ><input type="hidden" value='+accpowerlist[0]+' name="sa2_accpower1"></td>');
    					$("#inputplus4").html('<td class="tg-0lax px-4 py-3 text-left font-semibold" style="min-width:15rem;max-width:20rem;width:15rem;border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding-top:0.5rem;padding-bottom:0.5rem">기간 발전량[Kwh]</td><td class="la5 px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value="" name="sa2_periodpower" id="sa2_periodpower" readonly="readonly"><input type="hidden" value="" id ="sa2_periodpower1" name="sa2_periodpower1"></td>');
        			}
		        	
        		}
        		
        		//자동계산(기간발전량 총합, 전월누적 계산) 
        		method_2(put,put2,conutt)
        		
				
        		//자동계산(전월 누적으로 총발전량, 1일평균 계산 및 첫 작성일때 분기처리)
        		if(result.preData == null || result.preData == 'undefined'){
        			Divison(0)
        		}else{
        			Divison(result.preData.sa2_meter1KWh)
        		}
        		
	       		
        			
        		
        		for(var i=1; i<=num-1; i++){	

        			//lanum을 다르게 해줘야 전회차정보 td어펜드시 인버터 번호에 맞는 정보가 들어감
        			var lanum = count + 9;
        			var lanum2 = count + 19;
    				var lanum3 = count + 29;
    				var lanum4 = count + 39;
        			var conuttt = count + 2
        			count += 1;
        			
        			//데이터 연동 안했을 때(인버터 10대 미만)
        			if(result.InverterData == null || result.InverterData == "" || result.InverterData == "undefined"){
        				
//         					//인버터 마지막 번호에 좌우 select추가
        					$("#inputplus0").append('<td class="la1 px-4 py-3 text-center bg-table-violet font-semibold" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0">'+count+'</td>')
			    			$("#inputplus1").append('<td class="la'+lanum+' px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value="" name="sa2_nowpower" id="sa2_nowpower"><input type="hidden" value="" name="sa2_nowpower1"></td>')
			    			$("#inputplus2").append('<td class="la'+lanum2+' px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value="" name="sa2_todaypower" id="sa2_todaypower"><input type="hidden" value="" name="sa2_todaypower1"></td>')
			    			$("#inputplus3").append('<td class="la'+lanum3+' px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value="" name="sa2_accpower" id="sa2_accpower" oninput="method_2(\'inputplus3\',\'inputplus4\',\''+conuttt+'\')" ><input type="hidden" value='+accpowerlist[i]+' name="sa2_accpower1"></td>')
			    			$("#inputplus4").append('<td class="la'+lanum4+' px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value="" name="sa2_periodpower" id="sa2_periodpower" readonly="readonly"><input type="hidden" value="" name="sa2_periodpower1"></td>')
					
        				
        			// 데이터 연동 했을 떄(인버터 10대 미만) 
        			}else{
        					//인버터 마지막 번호에 좌우 select 추가
        					$("#inputplus0").append('<td class="la1 px-4 py-3 text-center bg-table-violet font-semibold" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0">'+count+'</td>')
			    			$("#inputplus1").append('<td class="la'+lanum+' px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+result.InverterData[i].Active_Power+' name="sa2_nowpower" id="sa2_nowpower"><input type="hidden" value="" name="sa2_nowpower1"></td>')
			    			$("#inputplus2").append('<td class="la'+lanum2+' px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+result.InverterData[i].Daily_Generation+' name="sa2_todaypower" id="sa2_todaypower"><input type="hidden" value="" name="sa2_todaypower1"></td>')
			    			$("#inputplus3").append('<td class="la'+lanum3+' px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value='+result.InverterData[i].Cumulative_Generation+' name="sa2_accpower" id="sa2_accpower" oninput="method_2(\'inputplus3\',\'inputplus4\',\''+conuttt+'\')" ><input type="hidden" value='+accpowerlist[i]+' name="sa2_accpower1"></td>')
			    			$("#inputplus4").append('<td class="la'+lanum4+' px-4 py-3 text-center" style="border-right:solid 1px rgba(229, 231, 235);border-left:solid 1px rgba(229, 231, 235);padding:0"><input type="text" inputmode="numeric" style="background-color:rgba( 255, 255, 255, 0 )" class="tb_gbla1 w-full border-none text-xs focus:outline-none" value="" name="sa2_periodpower" id="sa2_periodpower" readonly="readonly"><input type="hidden" value="" name="sa2_periodpower1"></td>')
        			}
        			
		       			//자동계산	       			
	            	method_2(put,put2,conuttt)

	       		}
        			list.length = 0;
        			
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
       		       	$("#sa2_accpowertype").val(preacctype);
       				var preacctypeVal = $("#sa2_accpowertype").val(preacctype);
       				if(preacctypeVal == "MWh"){
       					MwhCal_one()	
       				}
       		    	
        	}
        	
        	
        	
        	//division 함수 데이터처리(Division의 인수 값 넣어줌)
        	var meter1KWh = $("#sa2_meter1KWh").val()
        	
        	
        	//카카오, 메시지 체크안할시 알림 후 저장 버튼 hide
        	if(result.data.SU_SA_KAKAOYN == "N" && result.data.SU_SA_MSGYN == "N"){
        		$(".KAKAOMSG").hide();
        	}
        	
        	
        	
        },
        error: function(){
        	console.log("error");
        }
	}); 
}

function validationCheck(){		
	if($("#sa2_title").val() == ''){
// 		cf_smallBox('error', "발전소를", 3000,'#d24158');
		alert("발전소를 선택해주세요");
		document.getElementById("su_name").focus();
		return false
	}else if($("#sa2_wether").val() == ''){
// 		cf_smallBox('error', "날씨를 선택해주세요", 3000,'#d24158');
		alert("날씨를 선택해주세요");
		document.getElementById("sa2_wether").focus();
		return false
	}else if($("#sa2_adminname").val() == ''){
		alert("관리자를 선택해주세요");
		document.getElementById("sa2_adminname").focus();
		return false
	}
	return true
}



function changetext(value){	
	if(value == 3){
		$("#changenum2").val("계량기#3")
	}else if(value == 9){
		$("#changenum2").val("계량기#9")
	}
}


function Divison(obj){
	
	var ctb = $("#sa2_palntCT").val()
	var day = $("#sa2_meter1date").val()
	var vol = $("#sa2_palntKW").val()
	//전월 마지막 점검데이터의 전월 누적 송전 유효 전력량
	var prev = $("#prewatt").val()	
	
	if(day == 0){
		day = 1
	}else{
		day = $("#sa2_meter1date").val()
	}
	
	if(prev == null| prev == ''){
		prev = 0;
	}else{
		prev = $("#prewatt").val()
	}
	
	
	var ctb1 = Number(ctb);
	var day1 = Number(day);
	var vol1 = Number(vol);
	var obj1 = Number.parseFloat(obj);
	var prev1 = Number.parseFloat(prev);
	
	var num = (obj1-prev1)*ctb1
	var num2 = num/day1
	var num3 = num2/vol1

	//첫작성시 전월누적 없어서 NaN뜰 때  분기처리
	if(isNaN(num)){
		
		$("#sa2_meter1allKWh").val(0)
		$("#sa2_meter1dayKWh").val(0)
		$("#sa2_meter1dayhour").val(0)
	}else{
		$("#sa2_meter1allKWh").val(num.toFixed(3))
		$("#sa2_meter1dayKWh").val(num2.toFixed(3))
		$("#sa2_meter1dayhour").val(num3.toFixed(3))
	}
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


function qwe() {
	if(confirm("작성한 양식을 초기화 하시겠습니까?")){
		alert("초기화 되었습니다")
		location.reload()
	}else{
		
	}
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
	
	
	
	//안전관리 첫 작성시 기간발전 0으로 만들어줌
	if(aa-bb == aa){
		$("#"+ c +">  td:nth-child("+  num + ")  > input").val(0);
	}else{
		$("#"+ c +">  td:nth-child("+  num + ")  > input").val((aa-bb).toFixed(2));			
	}
	
	
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

	
	var periodpower = aa-bb
	
	//인버터 10대이하 기간발전량 계산
	if(periodpower == aa){
		//bb = 누적 발전량 = 0, 맨처음 작성하는 발전소일 경우
		$("#"+ b +" > td:nth-child("+ c +") > input.tb_gbla1").val(0);
	}else{
		//아닐경우 뺌
		$("#"+ b +" > td:nth-child("+ c +") > input.tb_gbla1").val(periodpower.toFixed(2));			
	}

	
	var sum = 0;
	
	list[c-2] = periodpower;
	
	
	
	//기간발전량 합처리
	for(var i=0;i<list.length;i++){
		sum += list[i]			
	}
	
	//MWh 일때 *1000 해줌
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


function inputNumberFormat(obj) {
    obj.value = comma(uncomma(obj.value));
}

function comma(str) {
    str = String(str);

    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}

function uncomma(str) {
    str = String(str);
    return str.replace(/[^\d]+/g, '');
}

function asdf(){
	
	$("#lal1").remove();
	$("#lal2").remove();
	$("#lal3").remove();
	$("#lal4").remove();
	
}

//상전압 선간전압 변경
function AC_Change(value){

	if(value == "01"){
		$(".AC_cl1").text('L1-L2')
		$(".AC_cl2").text('L2-L3')
		$(".AC_cl3").text('L3-L4')
	}else{
		$(".AC_cl1").text('L1-N')
		$(".AC_cl2").text('L2-N')
		$(".AC_cl3").text('L3-N')
	}
}

//사진 등록
function img_insert(){

	const selectFile = document.querySelector("#inputImage").files[0];
	
	$(".filename").text(selectFile.name)
	
    const file = URL.createObjectURL(selectFile);

    document.querySelector(".uploadImage").src = file;
    
    $(".imgdelete").show();
   
}

//사진 삭제
function img_delete(){
	
	const selectFile = document.querySelector("#inputImage").files[0];
	
	
	document.querySelector(".uploadImage").src = "";
	$("#inputImage").empty();
	$(".imgdelete").hide();
	$(".filename").empty();
	
}

function Recent_popup(){
	
	
	var SU_KEYNO = $("#SU_KEYNO").val();
	
	if(SU_KEYNO!=''){
		var left = Math.ceil((window.screen.width - 2000)/2);
		var top = Math.ceil((window.screen.height - 820)/2);
		var popOpen	= window.open("/sfa/sfaAdmin/log/RecentViewController.do?SUKEYNO="+SU_KEYNO, "Taxpopup","width=1200px,height=900px,top="+top+",left="+left+",status=0,toolbar=0,menubar=0,location=false,scrollbars=yes");
		popOpen.focus();
	}else{
		alert("발전소를 먼저 선택해주세요");
	}
}

function AreaChange(value){
	

	$.ajax({
        url: '/sfa/safe/AreaChangeList.do?${_csrf.parameterName}=${_csrf.token}',
        type: 'POST',
        data: {
			"area" : value,
		},
        async: false,  
        success: function(data) {
        	
        	$("#su_name").empty();
        	$("#su_name").append("<option value=''>발전소 선택</option>");
        	
			for(var i=0; i<data.length; i++){
				$("#su_name").append("<option value = "+data[i].SU_KEYNO+">"+data[i].SU_SA_SULBI+"</option>");
	      	}
        	
        },
        error: function(){
        
        }
	});
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
	$("#sa2_date3").val(Year+"년 "+Mon+"월 "+Day+"일 "+Hour+"시 "+Dow+"요일");
	
	
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
	
	//첫작성시 현재 날짜 포맷팅
	var currentDate = new Date();
	var formattedDate = currentDate.getFullYear() + '-' +
	    ('0' + (currentDate.getMonth() + 1)).slice(-2) + '-' +
	    ('0' + currentDate.getDate()).slice(-2);
    	    
	

	var Year = $("#sa2_dateY").val();
	var Mon = $("#sa2_dateM").val();
	var Day = $("#sa2_dateD").val();
	var formattedDate2 = Mon + '/' + Day;
	

	var Pre_Conn_date = $("#Pre_Conn_date").val()
	if(!Pre_Conn_date){
		Pre_Conn_date = formattedDate2;
	}else{
		Pre_Conn_date = $("#Pre_Conn_date").val()
	}
	

	
	//DayDiff => 작성 주기 계산
	var Now_Conn_date = Year+"-"+Mon+"-"+Day;
	var date1 = new Date(Now_Conn_date);
	date1.setHours(0, 0, 0, 0);
	
	
	var Current_Conn_date = $("#Current_Conn_date").val();  //2023-09-26
	
	//첫작성 시 현재 설정한 날짜로 포맷팅
	if(Current_Conn_date == formattedDate){
		Current_Conn_date = Year+"-"+Mon+"-"+Day;
	}else{
		Current_Conn_date = $("#Current_Conn_date").val();
	}
	var date2 = new Date(Current_Conn_date);
	date2.setHours(0, 0, 0, 0);
	
	var timeDiff = date1 - date2;
	var dayDiff = timeDiff / (1000 * 60 * 60 * 24);
	
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
	
	var date2_month = date2.getMonth() + 1;
	var date2_day = date2.getDate();
	var date2_period = date2_month+"/"+date2_day;
	
	
	$("#sa2_inverterperiod").val(date2_period+"~"+date1_period)
	$("#sa2_meter2period").val(date2_period+"~"+date1_period)
	
	
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
		
		/* //시간 변경에 따른 전월계량기 데이터 뽑아오기 위한 ajax
		//처음엔 12월이었다가 11월로 변경했을 경우 전월 계량기 데이터는 11월데이터 -> 10월로 바뀌어서 들어가야함
		var keyno = $("#SU_KEYNO").val();
		var UIKEYNO = $("#SA_UI_KEYNO").val();
		
		//일자 포맷 변경
		dateReplace()
		var Date = $("#sa2_date").val();
		var formatDate = Date.substring(0,7);
		
		$.ajax({
	        url: '/sfa/safe/safeuserselect.do?${_csrf.parameterName}=${_csrf.token}',
	        type: 'POST',
	        data: {
				SU_KEYNO : keyno,
				UIKEYNO : UIKEYNO,
				formatDate : formatDate
			},
	        async: false,  
	        success: function(result) {
	        	$("#prewatt").val(result.prewatt)
	        }
		}) */
}

function kwchange(value){
	
	$("#sa2_accpowertype2").val(value);
	
}

function pre_select(){
	
	var pre_keyno = $("#pre_keyno").val();
	
	
	if(pre_keyno){
		window.location.href = "/sfa/safe/safeAdmin.do?SU_KEYNO="+pre_keyno
	}else{
		alert("현재 발전소가 첫번째 발전소 입니다.")
	}
	
	
	
	
}

function next_select(){
	
	var next_keyno = $("#next_keyno").val();
	
	if(next_keyno){
		window.location.href = "/sfa/safe/safeAdmin.do?SU_KEYNO="+next_keyno
// 		changesulbi(next_keyno)	
	}else{
		alert("현재 발전소가 마지막 발전소 입니다.")
	}
	
	
	
}

</script>
