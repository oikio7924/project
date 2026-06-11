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


<form:form id="Form" name="Form" method="post" action="">
<input type="hidden" name="hometaxbill_id" id="hometaxbill_id">
<input type="hidden" name="spass" id="spass">
<input type="hidden" name="apikey" id="apikey">
<input type="hidden" name="signature" id="signature">
<input type="hidden" name="issueid" id="issueid">
<input type="hidden" name="typecode1" id="typecode1" value = "01">
<input type="hidden" name="typecode2" id="typecode2" value = "01">
<input type="hidden" name="dbl_keyno" id="dbl_keyno">
<input type="hidden" name="dbl_sub_keyno" id="dbl_sub_keyno" value = "3">
<input type="hidden" name="chkvalue" id="chkvalue">
<input type="hidden" name="si_hcnt" id="si_hcnt" value = "0">
<input type="hidden" name="checkYN" id="checkYN" value = "N">
<input type="hidden" name="dbp_subkey3" id="dbp_subkey3">
<input type="hidden" id="dbl_UI_KEYNO" name="dbl_UI_KEYNO" value="${UI_KEYNO }">
<main class="h-full overflow-y-auto ">
            <div class="container grid px-6 mx-auto">
              <div class="relative">
                <div
                  class="w-full rounded-lg bg-indigo-200 text-center p-2 md:p-2 lg:p-4 text-sm md:text-sm lg:text-base md:text-base lg:text-lg font-bold my-4 md:md-4 lg:my-7">
                  세금계산서 리스트</div>
                <div class="w-full rounded-lg bg-white p-5 my-4 md:md-4 lg:my-7">
                  <p class="font-bold text-base md:text-base lg:text-lg flex items-center">
                    <span class="p-1 rounded-full mr-2 p-1 green_spot"></span>
                    세금계산서 작성 리스트를 확인합니다.
                  </p>
                  <div class="w-full rounded-lg bg-white py-5">
                    <jsp:include page="/WEB-INF/jsp/user/_SFA/include/search/pra_search_header_paging.jsp" flush="true">
						<jsp:param value="/sfa/bills/pagingAjaxSFA.do" name="pagingDataUrl" />
					</jsp:include>
					<div id="tableWrap"></div>
                  </div>
                </div>
                
                <!-- ----------------------------------------------   세금계산서 정보  ----------------------------------------------------------->
                <div
                  class="w-full rounded-lg bg-indigo-200 text-center p-2 md:p-2 lg:p-4 text-sm md:text-sm lg:text-base md:text-base lg:text-lg font-bold my-4 md:md-4 lg:my-7">
                  세금계산서 정보</div>
                <div class="w-full rounded-lg bg-white p-5 my-4 md:md-4 lg:my-7">
                    <div class="">
                      <p class="font-bold text-base md:text-base lg:text-lg">공급 받는자 구분</p>
                      <div class="flex items-center text-sm md:text-sm lg:text-base font-semibold my-2">
                        <input type="radio" class="" id="partytypecode" name="partytypecode" value="01" checked>
                        <label for="corporation" class="mx-2">기업</label>
                        <input type="radio" class="ml-2" id="partytypecode" name="partytypecode" value="02">
                        <label for="personal" class="mx-2">개인</label>
                        <input type="radio" class="ml-2" id="partytypecode" name="partytypecode" value="03">
                        <label for="foreigner" class="mx-2">외국인</label>
                      </div>
                    </div>
                    <div class="">
                      <div class="grid grid-cols-4 gap-2.5 mt-4">
                        <div class="flex items-center flex-shrink-0">
                          <label for="red_id"
                            class="text-xs bg-badge-red text-buttonText-red rounded-sm mr-2.5 flex justify-center items-center w-36 py-2 font-semibold">등록
                            번호</label>
                          <input type="text" id="homemunseo_id" name="homemunseo_id" class="w-full rounded-sm"
                            style="border:solid 1px #c3cdd9;border-radius:4px;margin-left:10px;margin-right:10px;font-size:12px;padding:3px 6px"
                            value="">
                        </div>
                        <div class="flex items-center flex-shrink-0">
                          <label for="red_business_registration_number"
                            class="text-xs bg-badge-red text-buttonText-red rounded-sm mr-2.5 flex justify-center items-center w-36 py-2 font-semibold">사업자등록번호</label>
                          <input type="text" id="ir_companynumber"
                            name="ir_companynumber" class="w-full rounded-sm"
                            style="border:solid 1px #c3cdd9;border-radius:4px;margin-left:10px;margin-right:10px;font-size:12px;padding:3px 6px"
                            value="">
                        </div>
                        <div class="flex items-center flex-shrink-0">
                          <label for="red_category"
                            class="text-xs bg-badge-red text-buttonText-red rounded-sm mr-2.5 flex justify-center items-center w-36 py-2 font-semibold">업태</label>
                          <input type="text" id="ir_biztype" name="ir_biztype" class="w-full rounded-sm"
                            style="border:solid 1px #c3cdd9;border-radius:4px;margin-left:10px;margin-right:10px;font-size:12px;padding:3px 6px"
                            value="">
                        </div>
                        <div class="flex items-center flex-shrink-0">
                          <label for="red_provider"
                            class="text-xs bg-badge-red text-buttonText-red rounded-sm mr-2.5 flex justify-center items-center w-36 py-2 font-semibold">공급자선택</label>
                          <select name="dbp_keyno" id="dbp_keyno" onchange="providerSelectMethod(this.value)"
                            style="border:solid 1px #c3cdd9;border-radius:4px;margin-left:10px;margin-right:10px;font-size:12px;padding:3px 6px"
                            class="w-full">
                           		<option value = "">선택하세요</option>
								<c:forEach items="${billList}" var="b">
									<option value="${b.dbp_keyno}">${b.dbp_name}</option>
								</c:forEach>
                          </select>
                        </div>
                        <div class="flex items-center flex-shrink-0">
                          <label for="red_classification"
                            class="text-xs bg-badge-red text-buttonText-red rounded-sm mr-2.5 flex justify-center items-center w-36 py-2 font-semibold">업종</label>
                          <input type="text" id="ir_bizclassification" name="ir_bizclassification" class="w-full rounded-sm"
                            style="border:solid 1px #c3cdd9;border-radius:4px;margin-left:10px;margin-right:10px;font-size:12px;padding:3px 6px"
                            value="">
                        </div>
                        <div class="flex items-center flex-shrink-0">
                          <label for="red_representative_name"
                            class="text-xs bg-badge-red text-buttonText-red rounded-sm mr-2.5 flex justify-center items-center w-36 py-2 font-semibold">대표자명</label>
                          <input type="text" id="ir_bizclassification" name="ir_bizclassification"
                            class="w-full rounded-sm"
                            style="border:solid 1px #c3cdd9;border-radius:4px;margin-left:10px;margin-right:10px;font-size:12px;padding:3px 6px"
                            value="">
                        </div>
                        <div class="flex items-center flex-shrink-0">
                          <label for="red_address"
                            class="text-xs bg-badge-red text-buttonText-red rounded-sm mr-2.5 flex justify-center items-center w-36 py-2 font-semibold">회사
                            주소</label>
                          <input type="text" id="ir_companyaddress" name="ir_companyaddress" class="w-full rounded-sm"
                            style="border:solid 1px #c3cdd9;border-radius:4px;margin-left:10px;margin-right:10px;font-size:12px;padding:3px 6px"
                            value="">
                        </div> 
                        <div class="flex items-center flex-shrink-0">
                          <label for="red_company_name"
                            class="text-xs bg-badge-red text-buttonText-red rounded-sm mr-2.5 flex justify-center items-center w-36 py-2 font-semibold">사업체명</label>
                          <input type="text" id="ir_companyname" name="ir_companyname" class="w-full rounded-sm"
                            style="border:solid 1px #c3cdd9;border-radius:4px;margin-left:10px;margin-right:10px;font-size:12px;padding:3px 6px"
                            value="">
                        </div>
                      </div>
                      
                      <!-- ----------------------------------------------   공급받는자 DIV  ----------------------------------------------------------->
                      
                      <div class="grid grid-cols-4 gap-2.5 mt-8">
                        <div class="flex items-center flex-shrink-0">
                          <label for="blue_business_registration_number"
                            class="text-xs bg-badge-blue text-buttonText-blue rounded-sm mr-2.5 flex justify-center items-center w-36 py-2 font-semibold">사업자등록번호</label>
                          <input type="text" id="ie_companynumber"
                            name="ie_companynumber" class="w-full rounded-sm"
                            style="border:solid 1px #c3cdd9;border-radius:4px;margin-left:10px;margin-right:10px;font-size:12px;padding:3px 6px"
                            value="">
                        </div>
                        <div class="flex items-center flex-shrink-0">
                          <label for="blue_category"
                            class="text-xs bg-badge-blue text-buttonText-blue rounded-sm mr-2.5 flex justify-center items-center w-36 py-2 font-semibold">업태</label>
                          <input type="text" id="ie_biztype" name="ie_biztype" class="w-full rounded-sm"
                            style="border:solid 1px #c3cdd9;border-radius:4px;margin-left:10px;margin-right:10px;font-size:12px;padding:3px 6px"
                            value="">
                        </div>
                        <div class="flex items-center flex-shrink-0">
                          <label for="blue_name"
                            class="text-xs bg-badge-blue text-buttonText-blue rounded-sm mr-2.5 flex justify-center items-center w-36 py-2 font-semibold">사업체명</label>
                          <input type="text" id="ie_companyname" name="ie_companyname" class="w-full rounded-sm"
                            style="border:solid 1px #c3cdd9;border-radius:4px;margin-left:10px;margin-right:10px;font-size:12px;padding:3px 6px"
                            value="">
                        </div>
                        <div class="flex items-center flex-shrink-0">
                          <label for="blue_supplier"
                            class="text-xs bg-badge-blue text-buttonText-blue rounded-sm mr-2.5 flex justify-center items-center w-36 py-2 font-semibold">공급받는자
                            선택</label>
                          <select name="dbs_keyno" id="dbs_keyno" onchange="supliedSelect(this.value)"
                            style="border:solid 1px #c3cdd9;border-radius:4px;margin-left:10px;margin-right:10px;font-size:12px;padding:3px 6px"
                            class="w-full">
                            	<option>선택하세요</option>
								<c:forEach items="${SuppliedList}" var="b">
									<option value="${b.dbs_keyno}">${b.dbs_name}</option>
								</c:forEach>
                          </select>
                        </div>
                        <div class="flex items-center flex-shrink-0">
                          <label for="blue_tax_registration_id"
                            class="text-xs bg-badge-blue text-buttonText-blue rounded-sm mr-2.5 flex justify-center items-center w-36 py-2 font-semibold">종사업자번호</label>
                          <input type="text" id="ie_taxnumber" name="ie_taxnumber"
                            class="w-full rounded-sm"
                            style="border:solid 1px #c3cdd9;border-radius:4px;margin-left:10px;margin-right:10px;font-size:12px;padding:3px 6px"
                            value="">
                        </div>
                        <div class="flex items-center flex-shrink-0">
                          <label for="blue_representative_name"
                            class="text-xs bg-badge-blue text-buttonText-blue rounded-sm mr-2.5 flex justify-center items-center w-36 py-2 font-semibold">대표자명</label>
                          <input type="text" id="ie_ceoname" name="ie_ceoname"
                            class="w-full rounded-sm"
                            style="border:solid 1px #c3cdd9;border-radius:4px;margin-left:10px;margin-right:10px;font-size:12px;padding:3px 6px"
                            value="">
                        </div>
                        <div class="flex items-center flex-shrink-0">
                          <label for="blue_address"
                            class="text-xs bg-badge-blue text-buttonText-blue rounded-sm mr-2.5 flex justify-center items-center w-36 py-2 font-semibold">회사
                            주소</label>
                          <input type="text" id="ie_companyaddress" name="ie_companyaddress" class="w-full rounded-sm"
                            style="border:solid 1px #c3cdd9;border-radius:4px;margin-left:10px;margin-right:10px;font-size:12px;padding:3px 6px"
                            value="">
                        </div>
                        <div class="flex items-center flex-shrink-0">
                          <label for="blue_classification"
                            class="text-xs bg-badge-blue text-buttonText-blue rounded-sm mr-2.5 flex justify-center items-center w-36 py-2 font-semibold">업종</label>
                          <input type="text" id="ie_bizclassification" name="ie_bizclassification"
                            class="w-full rounded-sm"
                            style="border:solid 1px #c3cdd9;border-radius:4px;margin-left:10px;margin-right:10px;font-size:12px;padding:3px 6px"
                            value="">
                        </div>
                      </div>
                    </div>

                    <div class="w-full border my-3 md:my-3 lg:my-5"></div>

				
				<!-- ----------------------------------------------   부가사항 DIV  ----------------------------------------------------------->
				
                    <div class="">
                      <div class="grid grid-cols-8 gap-x-2">
                        <div class="">
                          <label class="text-xs font-semibold" for="">작성일자</label>
                          <input type="text" class="w-full my-2" id="issuedate" name="issuedate" value="${nowDate }"
                            style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px">
                        </div>
                        <div class="">
                          <label class="text-xs font-semibold" for="">공급가격</label>
                          <input type="text" class="w-full my-2" id="chargetotal" name="chargetotal" readonly="readonly" value="0"
                            style="background-color:#e1e6ec;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px">
                        </div>
                        <div class="">
                          <label class="text-xs font-semibold" for="">세액</label>
                          <input type="text" class="w-full my-2" id="taxtotal" name="taxtotal" value="0"
                            style="background-color:#e1e6ec;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px">
                        </div>
                        <div class="">
                          <label class="text-xs font-semibold" for="">비고</label>
                          <input type="text" class="w-full my-2" id="description" name="description"
                            style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px">
                        </div>
                      </div>
                      <div class="grid grid-cols-8 gap-x-2">
                        <div class="">
                          <label class="text-xs font-semibold" for="">월/일</label>
                          <input type="text" class="w-full my-2" id="sub_issuedate" name="sub_issuedate" value="${nowDate }"
                            style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px">
                        </div>
                        <div class="">
                          <label class="text-xs font-semibold" for="">품목</label>
                          <input type="text" class="w-full my-2" id="subject" name="subject" value="${itemName }"
                            style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px">
                        </div>
                        <div class="">
                          <label class="text-xs font-semibold" for="">규격</label>
                          <input type="text" class="w-full my-2" id="unit" name="unit"
                            style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px">
                        </div>
                        <div class="">
                          <label class="text-xs font-semibold" for="">수량</label>
                          <input type="text" class="w-full my-2" id="quantity" name="quantity"
                            style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px">
                        </div>
                        <div class="">
                          <label class="text-xs font-semibold" for="">단가</label>
                          <input type="text" class="w-full my-2" id="unitprice" name="unitprice"
                            style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px">
                        </div>
                        <div class="">
                          <label class="text-xs font-semibold" for="">공급가액</label>
                          <input type="text" class="w-full my-2" id="supplyprice" name="supplyprice" onkeyup="Divison(this)" oninput = "this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
                            style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px">
                        </div>
                        <div class="">
                          <label class="text-xs font-semibold" for="">세액</label>
                          <input type="text" class="w-full my-2" id="tax" name="tax"
                            style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px">
                        </div>
                        <div class="">
                          <label class="text-xs font-semibold" for="">비고</label>
                          <input type="text" class="w-full my-2" id="sub_description" name="sub_description"
                            style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px">
                        </div>
                        <div class="">
                          <label class="text-xs font-semibold" for="">합계금액</label>
                          <input type="text" class="w-full my-2" id="grandtotal" name="grandtotal" onkeyup="inputNumberFormat(this)" value="0"
                            style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px">
                        </div>
                        <div class="">
                          <label class="text-xs font-semibold" for="">현금</label>
                          <input type="text" class="w-full my-2" id="cash" name="cash" onkeyup="inputNumberFormat(this)" value="0"
                            style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px">
                        </div>
                        <div class="">
                          <label class="text-xs font-semibold" for="">수표</label>
                          <input type="text" class="w-full my-2" id="scheck" name="scheck" onkeyup="inputNumberFormat(this)" value="0"
                            style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px">
                        </div>
                        <div class="">
                          <label class="text-xs font-semibold" for="">어음</label>
                          <input type="text" class="w-full my-2" id="draft" name="draft" onkeyup="inputNumberFormat(this)" value="0"
                            style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px">
                        </div>
                        <div class="">
                          <label class="text-xs font-semibold" for="">외상 미수금</label>
                          <input type="text" class="w-full my-2" id="uncollected" name="uncollected" onkeyup="inputNumberFormat(this)" value="0"
                            style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px">
                        </div>
                        <div class="flex items-end text-sm md:text-sm lg:text-base font-semibold pb-2">
                          <div class="my-2 flex flex-wrap">
                            <div class="">
                              <input type="radio" class="" id="purposetype" name="purposetype" value="01">
                              <label for="receipt" class="mx-2 mr-2">영수</label>
                            </div>
                            <div class="">
                              <input type="radio" class="" id="purposetype" name="purposetype" value="02" checked>
                              <label for="bill" class="mx-2">청구</label>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div class="w-full border my-3 md:my-3 lg:my-5"></div>
                    
                    <!-- ----------------------------------------------   발급,수신 담당자 DIV  ----------------------------------------------------------->

                    <table class="text-xs whitespace-nowrap border-separate" style="border-spacing:10px">
                      <thead class="text-xs font-semibold tracking-wide text-left uppercase border-b">
                        <tr class="text-xs font-semibold text-black">
                          <td class=""></td>
                          <td class="">발급담당자</td>
                          <td class="">수신 담당자1</td>
                          <td class="">수신 담당자2</td>
                        </tr>
                      </thead>
                      <tbody class="bg-white divide-y">
                        <tr class="">
                          <td class="">
                            <span class="">담당자 부서명</span>
                          </td>
                          <td class="">
                            <input type="text" id="ir_busename" name="ir_busename"
                              style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px;margin:0">
                          </td>
                          <td class="">
                            <input type="text" id="ie_busename1" name="ie_busename1"
                              style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px;margin:0">
                          </td>
                          <td class="">
                            <input type="text" id="ie_busename2" name="ie_busename2"
                              style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px;margin:0">
                          </td>
                        </tr>
                        <tr class="">
                          <td class="">
                            <span class="">담당자 명</span>
                          </td>
                          <td class="">
                            <input type="text" id="ir_name" name="ir_name"
                              style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px;margin:0">
                          </td>
                          <td class="">
                            <input type="text" id="ie_name1" name="ie_name1"
                              style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px;margin:0">
                          </td>
                          <td class="">
                            <input type="text" id="ie_name1" name="ie_name1"
                              style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px;margin:0">
                          </td>
                        </tr>
                        <tr class="">
                          <td class="">
                            <span class="">이메일 주소</span>
                          </td>
                          <td class="">
                            <input type="text" id="ir_email" name="ir_email"
                              style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px;margin:0">
                          </td>
                          <td class="">
                            <input type="text" id="ie_email1" name="ie_email1"
                              style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px;margin:0">
                          </td>
                          <td class="">
                            <input type="text" id="ie_email2" name="ie_email2"
                              style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px;margin:0">
                          </td>
                        </tr>
                        <tr class="">
                          <td class="">
                            <span class="">연락처</span>
                          </td>
                          <td class="">
                            <input type="text" id="ir_cell" name="ir_cell"
                              style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px;margin:0">
                          </td>
                          <td class="">
                            <input type="text" id="ie_cell1" name="ie_cell1"
                              style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px;margin:0">
                          </td>
                          <td class="">
                            <input type="text" id="ie_cell1" name="ie_cell1"
                              style="background-color:#f0f2f5;border:none;border-radius:4px;margin-right:10px;font-size:12px;padding-top:4px;padding-bottom:4px;margin:0">
                          </td>
                        </tr>
                      </tbody>
                    </table>

                    <div class="w-full border my-3 md:my-3 lg:my-5"></div>

                    <div class="" id="buttondiv">
                      <button type="button" id="loadButton" onclick="loadBillInfo()" 
                        class="text-sm md:text-sm lg:text-base font-bold inline-flex items-center px-4 py-2 md:px-4 md:py-2 lg:px-6 lg:py-3 border border-transparent rounded-lg text-white bg-button-blue">저장</button>
                      <a href="#" onClick="javascript:window.scrollTo(0,0)"
                        class="ml-2.5 text-sm md:text-sm lg:text-base font-bold inline-flex items-center px-4 py-2 md:px-4 md:py-2 lg:px-6 lg:py-3 border border-transparent rounded-lg text-black bg-table-violet">맨위로</a>
                    </div>
                  <div class="w-full border my-3 md:my-3 lg:my-5"></div>
                </div>
              </div>
            </div>
          </main>
		</form:form>
<script type="text/javascript">


$(document).ready(function(){
	
	$('#issuedate').datepicker()
	$('#conn_date').datepicker()

}); 

function providerSelectMethod(value){
	console.log(value)
	if(value == "선택하세요" ||value == "0" || value == ""){
		clear();
		
	}else{
		providerSelect();
	}
}

function clear(){
	
	$("#homemunseo_id").val("")
	$("#ir_companynumber").val("")
	$("#ir_biztype").val("")
	$("#ir_companyname").val("")
	$("#ir_bizclassification").val("")
	$("#ir_ceoname").val("")
	$("#ir_companyaddress").val("")

}


function providerSelect(){
	 $.ajax({
       url: '/dyAdmin/bills/proAndSupSelect2.do?${_csrf.parameterName}=${_csrf.token}',
       type: 'POST',
       data: $("#Form").serialize(),
       async: false,
       success: function(result) {
    	   
    	   
       	$("#hometaxbill_id").val(result.dbp_id)
       	$("#spass").val(result.dbp_pass)
       	$("#apikey").val(result.dbp_apikey)
       	$("#issueid").val()
	    $("#dbp_keyno").val(result.dbp_keyno)
       	$("#ir_companynumber").val(result.dbp_co_num) 	
       	$("#homemunseo_id").val(result.dbl_homeid)
       	$("#ir_companyname").val(result.dbp_name)
       	$("#ir_ceoname").val(result.dbp_ceoname)
       	$("#ir_companyaddress").val(result.dbp_address)
       	$("#ir_biztype").val(result.dbp_biztype)
       	$("#ir_bizclassification").val(result.dbp_bizclassification)
       	$("#ir_email").val(result.dbp_email)
       	$("#ir_busename").val(result.dbp_busename)
       	$("#ir_name").val(result.dbp_name)
       	$("#ir_email").val(result.dbp_email)
       	$("#ir_cell").val(result.dbp_ir_cell)
       	$("#dbp_sub_keyno").val(result.dbp_sub_keyno) //발행 종류 구분
       	
       	
       	/* 이전 달 공급받는자 따라옴 */
       	$("#dbs_keyno").val(result.dbs_keyno)
       	$("#ie_companynumber").val(result.dbs_co_num)
     	$("#ie_taxnumber").val(result.dbs_taxnum) //종 사업장 번호
       	$("#ie_companyname").val(result.dbs_name)
       	$("#ie_ceoname").val(result.dbs_ceoname)
       	$("#ie_companyaddress").val(result.dbs_address)
       	$("#ie_biztype").val(result.dbs_biztype)
       	$("#ie_bizclassification").val(result.dbs_bizclassification)
       	$("#ie_email").val(result.dbs_email1)
       	$("#ie_busename1").val(result.dbs_busename1)
       	$("#ie_name1").val(result.dbs_name1)
       	$("#ie_email1").val(result.dbs_email1)
       	$("#ie_cell1").val(result.dbs_cell1)
       },
       error: function(){
       	alert("공급자 정보 불러오기 에러");
       }
	}); 
}

// ---------------------------- 공급 받는자 --------------------------------------------------------

function supliedSelect(value){
	 $.ajax({
       url: '/sfa/bills/supliedSelectAjax.do?${_csrf.parameterName}=${_csrf.token}',
       type: 'POST',
       data: {
       	"dbs_keyno":value
       },
       async: false,
       success: function(result) {
    	   
    	console.log(result);
       	$("#dbs_keyno").val(result.dbs_keyno)
       	$("#ie_companynumber").val(result.dbs_co_num)
     	$("#ie_taxnumber").val(result.dbs_taxnum) //종 사업장 번호
       	$("#ie_companyname").val(result.dbs_name)
       	$("#ie_ceoname").val(result.dbs_ceoname)
       	$("#ie_companyaddress").val(result.dbs_address)
       	$("#ie_biztype").val(result.dbs_biztype)
       	$("#ie_bizclassification").val(result.dbs_bizclassification)
       	$("#ie_email").val(result.dbs_email1)
       	$("#ie_busename1").val(result.dbs_busename1)
       	$("#ie_name1").val(result.dbs_name1)
       	$("#ie_email1").val(result.dbs_email1)
       	$("#ie_cell1").val(result.dbs_cell1)

       	
       },
       error: function(){
       	alert("공급받는자 정보 불러오기 에러");
       }
	}); 
}


function validationCheck(){
	
	if($("#supplyprice").val() == ''){
		alert("공급가액을 입력해주세요");
		return false
	}else if($("#dbs_keyno").val() == '' || $("#dbs_keyno").val() == null ){
		alert("공급받는자를 선택 해주세요");
		return false
	}else if($("#dbp_keyno").val() == '' || $("#dbp_keyno").val() == null ){
		alert("공급자를 선택 해주세요");
		return false
	}
	
	return true
}


function loadBillInfo(){
 	if(!validationCheck()) return false
	 $.ajax({
        url: '/dyAdmin/bills/billsInfoInsert3sfa.do?${_csrf.parameterName}=${_csrf.token}',
        type: 'POST',
        data: $("#Form").serialize(),
        async: false,  
        success: function(result) {
       		if(result == "1"){
       			alert("전송이 완료된 세금계산서는 등록/수정을 할 수 없습니다.")
       		}else if(result != "1" && result != "저장 완료"){
        		if(confirm("동일한 공급자와 공급받는자가 이미 등록되어 있습니다."+ "\n" +"작성한 내용으로 수정하시겠습니까?")){
        			$("#dbl_keyno").val(result)
        			 $.ajax({
        					type: "POST",
        					url: "/dyAdmin/bills/billsInfoUpdate.do?${_csrf.parameterName}=${_csrf.token}",
        					async: false,
        					data: $("#Form").serialize(),
        					success : function(data){
        						alert(data);
        						location.reload();
        					}, 
        					error: function(){
        						
        					}
        			}); 
        		}else false;
        		
        	}else {
        		alert("세금계산서 정보 저장 완료")
        		location.reload();
        	}
        },
        error: function(){
        	alert("저장 실패");
        }
	}); 
}

function detailView(keyno){
	$.ajax({
		url: '/dyAdmin/bills/selectAllView2.do?${_csrf.parameterName}=${_csrf.token}',
		type: 'POST',
		data: {
			dbl_keyno : keyno
		},
		async: false,
		success : function(data){
			
			
			
			$("#dbl_keyno").val(data.dbl_keyno)
			$("#dbp_keyno").val(data.dbp_keyno)
			$("#homemunseo_id").val(data.dbl_homeid)
			$("#ir_companynumber").val(data.dbp_co_num)
			$("#ir_biztype").val(data.dbp_biztype)
			$("#ir_companyname").val(data.dbp_name)
			$("#ir_bizclassification").val(data.dbp_bizclassification)
			$("#ir_ceoname").val(data.dbp_ceoname)
			$("#ir_companyaddress").val(data.dbp_address)
			
			
			$("#dbs_keyno").val(data.dbs_keyno)
			$("#ie_companynumber").val(data.dbs_co_num)
			$("#ie_biztype").val(data.dbs_biztype)
			$("#ie_companyname").val(data.dbs_name)
			$("#ie_taxnumber").val(data.dbs_taxnum)
			$("#ie_bizclassification").val(data.dbs_bizclassification)
			$("#ie_ceoname").val(data.dbs_ceoname)
			$("#ie_companyaddress").val(data.dbs_address)
			
			
			$("#partytypecode").val(data.dbl_partytypecode)
			$("#purposetype").val(data.dbl_purposetype)
			$("#issuedate").val(data.dbl_issuedate)
			$("#chargetotal").val(data.dbl_chargetotal)
			$("#taxtotal").val(data.dbl_taxtotal)
			$("#description").val(data.dbl_description)
			$("#conn_date").val(data.dbl_date)
			$("#subject").val(data.dbl_subject)
			$("#unit").val(data.dbl_unit)
			$("#quantity").val(data.dbl_quantity)
			$("#unitprice").val(data.dbl_unitprice)
			$("#supplyprice").val(data.dbl_supplyprice)
			$("#tax").val(data.dbl_tax)
			$("#sub_description").val(data.dbl_description)
			$("#sub_issuedate").val(data.dbl_sub_issuedate)
			$("#si_hcnt").val(data.dbl_si_hcnt)
			$("#checkYN").val(data.dbl_checkYN)
			
			
			$("#grandtotal").val(data.dbl_grandtotal)
			$("#cash").val(data.dbl_cash)
			$("#scheck").val(data.dbl_scheck)
			$("#draft").val(data.dbl_draft)
			$("#uncollected").val(data.dbl_uncollected)
			
			
			$("#ir_busename").val(data.dbp_busename)
			$("#ie_busename1").val(data.dbs_busename1)
			$("#ie_busename2").val(data.dbs_busename2)
			$("#ir_name").val(data.dbp_ir_name)
			$("#ie_name1").val(data.dbs_name1)
			$("#ie_name2").val(data.dbs_name2)
			$("#ir_email").val(data.dbp_email)
			$("#ie_email1").val(data.dbs_email1)
			$("#ie_email2").val(data.dbs_email2)
			$("#ir_cell").val(data.dbp_ir_cell)
			$("#ie_cell1").val(data.dbs_cell1)
			$("#ie_cell2").val(data.dbs_cell2)
			
			
			if(data.dbl_checkYN == "N" || data.dbl_checkYN == "W"){
				
				$("#buttondiv").html("<button type='button' class='text-sm md:text-sm lg:text-base font-bold inline-flex items-center px-4 py-2 md:px-4 md:py-2 lg:px-6 lg:py-3 border border-transparent rounded-lg text-white bg-button-blue' onclick='window.location.reload()'>초기화</button>")
				$("#buttondiv").append("<button class='text-sm md:text-sm lg:text-base font-bold inline-flex items-center px-4 py-2 md:px-4 md:py-2 lg:px-6 lg:py-3 border border-transparent rounded-lg text-white bg-button-blue' id='loadButton' type='button' onclick='loadBillInfo()' style='margin-left: 1%;'>저장</button>")
				$("#buttondiv").append("<button class='text-sm md:text-sm lg:text-base font-bold inline-flex items-center px-4 py-2 md:px-4 md:py-2 lg:px-6 lg:py-3 border border-transparent rounded-lg text-white bg-button-blue' type='button' onclick='window.scrollTo(0,0);' style='margin-left: 1%;'>Top</button>")
				$("#loadButton").text("수정");
				$("#loadButton").attr("onclick","detailViewUpdate()");
						
				}else{
					$("#loadButton").remove();
					$("#buttondiv").html("<button type='button' class='text-sm md:text-sm lg:text-base font-bold inline-flex items-center px-4 py-2 md:px-4 md:py-2 lg:px-6 lg:py-3 border border-transparent rounded-lg text-white bg-button-blue' onclick='window.location.reload()'>새로고침</button>")
					$("#buttondiv").append("<button class='text-sm md:text-sm lg:text-base font-bold inline-flex items-center px-4 py-2 md:px-4 md:py-2 lg:px-6 lg:py-3 border border-transparent rounded-lg text-white bg-button-blue' type='button' onclick='window.scrollTo(0,0);' style ='margin-left: 1%;'>Top</button>")
				}
		}, 
		error: function(){
// 			cf_smallBox('error', "저장에러", 3000,'#d24158');
		}
	}); 
}

function sendNTS(){
	
	var array = new Array(); 
	$('input:checkbox[name=chk]:checked').each(function() { // 체크된 체크박스의 value 값을 가지고 온다.
	    array.push(this.value);
	});
	
	$("#chkvalue").val(array);
	$("#checkYN").val("Y");
	
	
	if(array.length > 0){
		if(confirm("전송하시겠습니까?")){
			$.ajax({
					type: "POST",
					url: "/dyAdmin/bills/sendNTS2.do?${_csrf.parameterName}=${_csrf.token}",
					data: $('#Form').serializeArray(),
					async: false,
					success : function(data){
						
						alert("전송 완료");
						location.reload();
					}, 
					error: function(){
						
					}
			});
		}else{
// 			cf_smallBox('error', "취소되었습니다.", 3000,'#d24158');
		}
	}else{
		alert("전송할 세금계산서를 선택해주세요.")
	}

return false;
}


function delaysend(){
	
	var array = new Array(); 
	$('input:checkbox[name=chk]:checked').each(function() { // 체크된 체크박스의 value 값을 가지고 온다.
	    array.push(this.value);
	});
	
	$("#chkvalue").val(array);
	$("#checkYN").val("Y");
	
	
	if(array.length > 0){
		if(confirm("전송하시겠습니까?")){
			$.ajax({
					type: "POST",
					url: "/dyAdmin/bills/senddelay.do?${_csrf.parameterName}=${_csrf.token}",
					data: $('#Form').serializeArray(),
					async: false,
					success : function(data){
						alert("전송대기상태로 변경되었습니다. 19시 00분에 일괄전송됩니다.");
						location.reload();
					}, 
					error: function(){
						
					}
			});
		}else{
// 			cf_smallBox('error', "취소되었습니다.", 3000,'#d24158');
		}
	}else{
		alert("전송할 세금계산서를 선택해주세요.")
	}

return false;
}


function deleteInfo(){
	
	var array = new Array(); 
	$('input:checkbox[name=chk]:checked').each(function() { // 체크된 체크박스의 value 값을 가지고 온다.
	    array.push(this.value);
	});
	
	$("#chkvalue").val(array);
	$("#checkYN").val("Y");
	
	
	if(array.length > 0){
		if(confirm("삭제하시겠습니까?")){
			$.ajax({
					type: "POST",
					url: "/dyAdmin/bills/deleteInfo2.do?${_csrf.parameterName}=${_csrf.token}",
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
// 			cf_smallBox('error', "취소되었습니다.", 3000,'#d24158');
		}
	}else{
		alert("삭제할 세금계산서를 선택해주세요.")
	}

return false;
}

function detailViewUpdate(){
	 
	if(!validationCheck()) return false
	
		 $.ajax({
				type: "POST",
				url: "/dyAdmin/bills/billsInfoUpdate2.do?${_csrf.parameterName}=${_csrf.token}",
				async: false,
				data: $('#Form').serializeArray(),
				success : function(data){
					alert(data);
					location.reload();
				}, 
				error: function(){
					
				}
		}); 
	 }


function seletAll(){
	
	if($("#cbx_chkAll").is(":checked")) $("input[name=chk]").prop("checked", true);
	else $("input[name=chk]").prop("checked", false);
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


function Divison(obj){

	var v = obj.value.replace(",","");
	
	var tax = Math.floor(v*0.1)
	var v1 = Number(v)
	var tax1 = Number(tax)
	var total = v1+tax1
//	var tax1 = (v/1.1).toFixed(0)
//	var tax2 = (tax1*0.1).toFixed(0)
	
//	$("#unitprice").val(comma(v))
	$("#supplyprice").val(comma(v))
	$("#unitprice").val(comma(v))
	$("#grandtotal").val(comma(total))
	$("#chargetotal").val(comma(v))
	
	if (tax > 0) {
		$("#tax").val(comma(tax))
		$("#taxtotal").val(comma(tax))
	}else{
		$("#tax").val(tax)
		$("#taxtotal").val(tax)
	}
	
}

function focus_p(){
	document.getElementById("supplyprice").focus();
}
</script>