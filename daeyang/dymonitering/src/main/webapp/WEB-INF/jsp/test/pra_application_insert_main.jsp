<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<div class="alert alert-info"  style="margin-bottom: 10px;">
	<a class="close" data-dismiss="alert">×</a>
	<!-- <h4 class="alert-heading"><i class="fa fa-check-square-o"></i> Check validation!</h4> -->
	<c:if test="${action eq 'Insert' }">
		<p>
			새로운 프로그램 정보를 생성합니다.
		</p>
	</c:if>
	<c:if test="${action eq 'Update' }">
		<p>
			등록된 프로그램을 수정합니다.
		</p>
	</c:if>
</div>
<c:if test="${action eq 'Update' }">
	<div class="alert alert-info"  style="margin-bottom: 0;">
		<a class="close" data-dismiss="alert">×</a>
		<p style="text-align: center; font-size: 15px; color: red;">
			※ 신청자가 있는 프로그램일 경우 스케줄을 수정 할 수 없습니다.
		</p>
	</div>
</c:if>
<legend><h6>기본정보</h6></legend> 
<fieldset>
	<div class="bs-example necessT">
         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
    </div>
	<div class="row"> 
		<section class="col col-6">
			<label class="label"><span class="nessSpan">*</span> 프로그램 이름</label> 
			<label class="input"><i class="icon-prepend fa fa-edit"></i> 
				<input class="checkTrim" type="text" id="AP_NAME" name="AP_NAME" placeholder="프로그램 이름명"  maxlength="50" value="${resultData.AP_NAME }"/>
			</label>
		</section>
		<section class="col col-3">
			<label class="label"><span class="nessSpan">*</span> 프로그램 일시</label> 
			<label class="input"><i class="icon-prepend fa fa-edit"></i> 
				<input class="checkTrim" type="text" id="AP_DATE_COMMENT" name="AP_DATE_COMMENT" placeholder="프로그램 일시"  maxlength="100" value="${resultData.AP_DATE_COMMENT }"/>
			</label>
		</section>
		<section class="col col-3">
			<label class="label"><span class="nessSpan">*</span> 사용 여부</label>
			<div class="inline-group">
				<label class="radio"> <input type="radio" name="AP_USE" value="Y" ${(action eq 'Insert' || resultData.AP_USE_NM eq '사용함') ? 'checked':'' }> <i></i>사용</label> 
				<label class="radio"> <input type="radio" name="AP_USE" value="N" ${resultData.AP_USE_NM eq '사용안함' ? 'checked':'' }> <i></i>미사용</label>
			</div>
		</section>
	</div>
	<div class="row"> 
		<section class="col col-3">
			<label class="label"><span class="nessSpan">*</span> 프로그램 유형</label> 
			<select class="form-control input-sm" id="AP_TYPE" name="AP_TYPE" onchange="pf_programType();">
				<c:forEach items="${sp:getCodeList('CB') }" var="model">
					<option value="${model.SC_KEYNO }" ${resultData.AP_TYPE eq model.SC_KEYNO ? 'selected' : '' }>${model.SC_CODENM }</option>
				</c:forEach>
			</select>
		</section>
		<section class="col col-3">
			<label class="label"><span class="nessSpan">*</span> 휴일 관리</label> 
			<label class="select">
				<select name="AP_HOILDAY" id="AP_HOILDAY">  
					<option value="A"  ${resultData.AP_HOILDAY eq "A" ? 'selected' : '' }>휴일 모두 적용</option> 
					<option value="O"  ${resultData.AP_HOILDAY eq "O" ? 'selected' : '' }>공휴일만 적용</option>
					<option value="H"  ${resultData.AP_HOILDAY eq "H" ? 'selected' : '' }>휴관일만 적용</option>
					<option value="N"  ${resultData.AP_HOILDAY eq "N" ? 'selected' : '' }>휴일 적용 안함</option>
				</select><i></i> 
			</label>
		</section>
		<section class="col col-3">
			<label class="label"><span class="nessSpan">*</span> 프로그램 장소 선택</label> 
			<select class="form-control input-sm" id="AP_PLACE" name="AP_PLACE">
				<option value="">장소 선택</option>
				<c:forEach items="${placeList }" var="place">
	                <option value="${place.PM_KEYNO }" data-seatplan="${place.PM_SEATPLAN_YN }" ${resultData.AP_PLACE eq place.PM_KEYNO ? 'selected' : ''}><c:out value="${place.PM_NAME }"/></option>
	              </c:forEach>
			</select>
		</section>
		<section class="col col-3">
			<label class="label"><span class="nessSpan">*</span> 프로그램 제한인원</label> 
			<label class="input"><i class="icon-prepend fa fa-edit"></i> 
				<input type="number" id="AP_LIMIT_PERSON" name="AP_LIMIT_PERSON" placeholder="프로그램 제한인원"  value="${resultData.AP_LIMIT_PERSON }"  oninput="cf_maxLengthCheck(this)" max="9999" maxlength="4" onkeypress="return pf_isNumberKey(event)" min="0"/>
			</label>
		</section>
	</div>
	<div class="row">
		<section class="col col-12">
			<label class="label"><span class="nessSpan">*</span> 프로그램 설명</label> 
			<label class="textarea">				
				<textarea class="checkTrim" rows="3" name="AP_SUMMARY" id="AP_SUMMARY" placeholder="프로그램 설명" maxlength="1000">${resultData.AP_SUMMARY }</textarea> 
			</label>
		</section>
	</div>
	<div class="row" id="AgeLimit">
		<section class="col col-3">
			<label class="label"><span class="nessSpan">*</span> 나이제한 적용 여부</label>
			<div class="inline-group">
				<label class="radio"> <input type="radio" name="AP_LIMIT_AGE_YN" value="Y" ${resultData.AP_LIMIT_AGE_YN eq 'Y' ? 'checked':'' }> <i></i>사용</label> 
				<label class="radio"> <input type="radio" name="AP_LIMIT_AGE_YN" value="N" ${(action eq 'Insert' || resultData.AP_LIMIT_AGE_YN eq 'N') ? 'checked':'' }> <i></i>미사용</label>
			</div>
		</section> 
		<section class="col col-3 limitage">
			<label class="label"><span class="nessSpan">*</span> 나이 제한 MIN</label>
			<label class="input"> 
				<input type="number" id="AP_LIMIT_AGE_MIN" name="AP_LIMIT_AGE_MIN"  value="${empty resultData.AP_LIMIT_AGE_MIN ? '0': resultData.AP_LIMIT_AGE_MIN}"min="0"  oninput="cf_maxLengthCheck(this)" onkeypress="return pf_isNumberKey(event)" max="99" maxlength="2"/>
			</label>
		</section>
		<section class="col col-3 limitage">
			<label class="label"><span class="nessSpan">*</span> 나이 제한 MAX</label>
			<label class="input">
				<input type="number" id="AP_LIMIT_AGE_MAX" name="AP_LIMIT_AGE_MAX"  value="${empty resultData.AP_LIMIT_AGE_MAX ? '0': resultData.AP_LIMIT_AGE_MAX}" min="0"  oninput="cf_maxLengthCheck(this)" onkeypress="return pf_isNumberKey(event)"  max="99" maxlength="2"/>
			</label>
		</section>
		<%-- <section class="col col-3">
			<label class="label">좌석 선택 여부</label>
			<div class="inline-group">
				<label class="radio"> <input type="radio" name="AP_SEAT_YN" value="Y" ${resultData.AP_SEAT_YN eq 'Y' ? 'checked':'' }> <i></i>적용</label> 
				<label class="radio"> <input type="radio" name="AP_SEAT_YN" value="N" ${(action eq 'Insert' || resultData.AP_SEAT_YN eq 'N') ? 'checked':'' }> <i></i>미적용</label>
			</div>
		</section> --%>
	</div>
</fieldset>
<legend><h6>요금제</h6></legend>
<fieldset>	
	<div class="row">
		<!-- <section class="col col-3">
			<label class="label">요금제 유형</label> 
			<select class="form-control input-sm" id="AP_PRICE_TYPE" name="AP_PRICE_TYPE">
				<option value="">유형 선택</option>
				<option value="A">전좌석 동일 요금</option>
				<option value="B">좌석별 차등 요금</option>
				<option value="C">무료</option>
			</select>
		</section> -->
		<section class="col col-3">
			<label class="label"><span class="nessSpan">*</span> 요금</label>
			<label class="input"> 
				<input type="number" id="AP_PRICE" name="AP_PRICE" onblur="pf_exriedYN();"  value="${empty resultData.AP_PRICE ? '0': resultData.AP_PRICE}" min="0"  oninput="cf_maxLengthCheck(this)" onkeypress="return pf_isNumberKey(event)" max="999999" maxlength="6"/>
			</label>
		</section>
		<section class="col col-3 chargeExpired">
			<label class="label"><span class="nessSpan">*</span> 결제 만료까지 일수</label>
			<label class="input"> 
				<input type="number" id="AP_EXPIRED" name="AP_EXPIRED"  value="${empty resultData.AP_EXPIRED ? '0': resultData.AP_EXPIRED}" min="0"  oninput="cf_maxLengthCheck(this)" onkeypress="return pf_isNumberKey(event)" max="99" maxlength="2"/>
			</label>
		</section>
	</div>
</fieldset>

<legend><h6>할인정책</h6></legend>
<fieldset>	
	<div class="row">
		<section class="col col-12">
			<p style="font-weight:bold;">※ 적용할 할인 정책을 체크하세요.</p>
		</section>
		<c:forEach items="${discountList }" var="model">
		<c:set var="discountCheck" value=""/>
		<c:if test="${action eq 'Insert' && model.AD_DEFAULT_YN eq 'Y' }">
			<c:set var="discountCheck" value="checked"/>
		</c:if>
		<c:if test="${action eq 'Update' && fn:contains(resultData.AD_KEYNO,model.AD_KEYNO)}">
			<c:set var="discountCheck" value="checked"/>
		</c:if>
		<section class="col col-12">
			<label class="checkbox">
				<input type="checkbox" name="AD_KEYNO" value="${model.AD_KEYNO }" ${discountCheck}>
				<i></i>${model.AD_NAME } - ${model.AD_MONEY }${model.AD_TYPE eq 'A' ? '%':'원' } 할인</label>
		</section>
		</c:forEach>
				<input type="hidden" name="AD_KEYNO" value="AD_0000000000">
	</div>
</fieldset>
<legend><h6>예매기간</h6></legend>
<fieldset>	
	<div class="row">
		<section class="col col-3">
			<label class="label">예매 시작일</label>
			<label class="input"> 
				<section  style="margin: 10px 0;">  
					<label class="input"> <i class="icon-prepend fa fa-edit"></i>    
						<input type="text" class="apply_start" id="apply_start" placeholder="시작일자를 선택하세요." name="AP_APPLY_ST_DATE" readonly="readonly" value="${resultData.AP_APPLY_ST_DATE }"/>
					</label>  
				</section>  
		</section>
		<section class="col col-3">
			<label class="label">예매 종료일</label>	
				<section  style="margin: 10px 0;"> 
					<label class="input"> <i class="icon-prepend fa fa-edit"></i>
							<input type="text" class="apply_end" id="apply_end"  placeholder="종료일자를 선택하세요." name="AP_APPLY_EN_DATE" readonly="readonly" value="${resultData.AP_APPLY_EN_DATE }"/>
					</label>    
				</section>
			</label>
		</section>
		<section class="col col-3" id="Ticket_max">
			<label class="label"><span class="nessSpan">*</span> 최대 예매 가능 수</label>	
				<section  style="margin: 10px 0;"> 
						<label class="input"><i class="icon-prepend fa fa-edit"></i>    
							<input type="number" id="AP_TICKET_CNT" name="AP_TICKET_CNT" value="${resultData.AP_TICKET_CNT}" placeholder="한번에 예매가능한 갯수를 입력하세요." oninput="cf_maxLengthCheck(this)" max="9999" min="0" maxlength="4" onkeydown="pf_numberMinus();" onkeypress="return pf_isNumberKey(event)"/>
						</label>  
				</section>
			</label>
		</section>
		<section class="col col-3">
			<label class="label">대기자 적용</label>
			<div class="inline-group">
				<label class="radio"> <input type="radio" name="AP_WAITING_YN" value="Y" ${ resultData.AP_WAITING_YN eq 'Y' ? 'checked':'' }> <i></i>사용</label> 
				<label class="radio"> <input type="radio" name="AP_WAITING_YN" value="N" ${ (action eq 'Insert' ||resultData.AP_WAITING_YN eq 'N') ? 'checked':'' }> <i></i>미사용</label>
			</div>
		</section>
	</div>
	<div class="row">
		<section class="col col-3">
			<label class="label">예매전 버튼 문구</label>
			<label class="input"> 
			<section  style="margin: 10px 0;">  
				<label class="input"><i class="icon-prepend fa fa-edit"></i>    
					<input type="text" id="AP_BUTTON_TEXT1" name="AP_BUTTON_TEXT1" value="${resultData.AP_BUTTON_TEXT1 }" maxlength="50" placeholder="예매 전 문구"/>
				</label>  
			</section>  
		</section>
		<section class="col col-3">
			<label class="label">예매중 버튼 문구</label>
			<label class="input"> 
			<section  style="margin: 10px 0;">  
				<label class="input"><i class="icon-prepend fa fa-edit"></i>    
					<input type="text" id="AP_BUTTON_TEXT2" name="AP_BUTTON_TEXT2" value="${resultData.AP_BUTTON_TEXT2 }" maxlength="50" placeholder="예매 중 문구"/>
				</label>  
			</section>  
		</section>
		<section class="col col-3">
			<label class="label">마감 버튼 문구</label>
			<label class="input"> 
			<section  style="margin: 10px 0;">  
				<label class="input"><i class="icon-prepend fa fa-edit"></i>    
					<input type="text" id="AP_BUTTON_TEXT3" name="AP_BUTTON_TEXT3" value="${resultData.AP_BUTTON_TEXT3 }" maxlength="50" placeholder="예매 후 문구"/>
				</label>  
			</section>  
		</section>
		<section class="col col-3">
			<label class="label">대기자 문구</label>
			<label class="input"> 
			<section  style="margin: 10px 0;">  
				<label class="input"><i class="icon-prepend fa fa-edit"></i>    
					<input type="text" id="AP_WAITING_TEXT" name="AP_WAITING_TEXT" value="${resultData.AP_WAITING_TEXT }" maxlength="50" placeholder="대기자 문구"/>
				</label>  
			</section>  
		</section>
	</div>
</fieldset>


<script>

var action = '${action}';

$(function(){
	pf_programType();
	pf_exriedYN();
	datepickerOption.onSelect = function(selectedDate) {
      	$('#apply_end').datepicker('option', 'minDate', selectedDate);			
   	} 
   	$('#apply_start').datepicker(datepickerOption)
   	
   	
   	datepickerOption.onSelect = function(selectedDate) {
    	$('#apply_start').datepicker('option', 'maxDate', selectedDate);
   	}
   	$('#apply_end').datepicker(datepickerOption);
	
   	
	if($('input[name=AP_LIMIT_AGE_YN]:checked').val() == 'N'){
		$('.limitage').hide();
	}
	
	if($('input[name=AP_SEAT_YN]:checked').val() == 'Y'){
		
		var seatYn = $(this).val();
		pf_settingPlaceList(seatYn);
		
		
	}
	
	
	
	$('input[name=AP_LIMIT_AGE_YN]').change(function(){
		if($(this).val() == 'Y'){
			$('.limitage').show();
		}else{
			$('.limitage').hide();
		}
	});
	
	$('input[name=AP_SEAT_YN]').change(function(){
		
		var seatYn = $(this).val();
		pf_settingPlaceList(seatYn);
		
	});
	
	
	
});

//장소 리스트 셋팅
function pf_settingPlaceList(seatYn){
	$('#AP_PLACE option').each(function(){
		var seatplan = $(this).data('seatplan');
		if(seatplan == 'N'){
			if(seatYn == 'N'){
				$(this).show();
			}else{
				$(this).hide();
				if($(this).is(':checked')){
					$('#AP_PLACE').val('');
				}
			}		
		}
	})
}

//프로그램 유형
function pf_programType(){
	var type = $("#AP_TYPE").val();
	
	if(type == typeApply){
		$("#AgeLimit").hide();
		$("#Ticket_max").show();
	}else if(type == typeLecture){
		$("#AgeLimit").show();
		$("#Ticket_max").hide();
		$("#AP_TICKET_CNT").val(0);
	}
}

//결제 만료일 css
function pf_exriedYN(){
	var charge = parseInt($("#AP_PRICE").val());
	if(charge == 0){
		$(".chargeExpired").hide();
	}else if(charge != 0){
		$(".chargeExpired").show();
	}
}
//음수 막기
function pf_isNumberKey(evt){
    var charCode = (evt.which) ? evt.which : event.keyCode;
    return !(charCode > 31 && (charCode < 48 || charCode > 57));
}
</script>
