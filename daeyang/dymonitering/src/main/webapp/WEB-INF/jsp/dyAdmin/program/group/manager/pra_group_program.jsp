<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

	<div class="widget-body-toolbar bg-color-white">
	 <div class="alert alert-info fade in" style="margin-bottom: 10px;">
			<button type="button" class="close" data-dismiss="alert">×</button>
			<c:if test="${action eq 'insert' }">
				<p>
					새로운 프로그램 정보를 생성합니다.
				</p>
			</c:if>
			<c:if test="${action eq 'update' }">
				<p>
					등록된 프로그램을 수정합니다.
				</p>
			</c:if>
		</div> 
	</div>	
	<c:if test="${action eq 'update' }">
		<div class="alert alert-info"  style="margin-bottom: 0;">
			<a class="close" data-dismiss="alert">×</a>
			<p style="text-align: center; font-size: 15px; color: red;">
				※ 신청자가 있는 프로그램일 경우 스케줄을 수정 할 수 없습니다.
			</p>
		</div>
	</c:if>
<div class="widget-body no-padding">
	<div class="bs-example necessT">
         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
    </div>
	<fieldset class="no-padding">
		<div class="row smart-form">
			<section class="col col-3">
				<label class="label"><span class="nessSpan">*</span> 프로그램 구분</label> 
				<label class="select">
					<select id="GM_DIVISION" name="GM_DIVISION" >  
						<option value="">프로그램 구분</option>
						<option value="C" ${DetailData.GM_DIVISION_TEMP eq "일반" ? 'selected' : '' }>일반</option> 
						<option value="S"  ${DetailData.GM_DIVISION_TEMP eq "특별" ? 'selected' : '' }>특별</option>
					</select><i></i> 
				</label>
			</section>
			<section class="col col-3">
				<label class="label"><span class="nessSpan">*</span> 프로그램 장소 선택${place.PM_KEYNO }</label> 
				<select class="form-control input-sm" id="GM_PLACE" name="GM_PLACE">
					<option value="">장소 선택</option>
					<c:forEach items="${placeList }" var="model">
		                <option value="${model.PM_KEYNO }" ${model.PM_KEYNO eq DetailData.GM_PLACE ? 'selected' : ''}><c:out value="${model.PM_NAME }"/></option>
		              </c:forEach>
				</select>
			</section>
			<section class="col col-3">
				<label class="label"><span class="nessSpan">*</span> 휴일 관리</label> 
				<label class="select">
					<select name="GM_HOLIDAY" id="GM_HOLIDAY">  
					<option value="A"  ${DetailData.GM_HOLIDAY eq "A" ? 'selected' : '' }>휴일 모두 적용</option> 
					<option value="O"  ${DetailData.GM_HOLIDAY eq "O" ? 'selected' : '' }>공휴일만 적용</option>
					<option value="H"  ${DetailData.GM_HOLIDAY eq "H" ? 'selected' : '' }>휴관일만 적용</option>
					<option value="N"  ${DetailData.GM_HOLIDAY eq "N" ? 'selected' : '' }>휴일 적용 안함</option>
					</select><i></i> 
				</label>
			</section>
			<section class="col col-3">
				<label class="label"><span class="nessSpan">*</span> 사용 여부</label>
				<div class="inline-group">
					<label class="radio"> <input type="radio" name="GM_USE" value="Y" ${(action eq 'insert' || DetailData.GM_USE_TEMP eq '사용함') ? 'checked':'' }> <i></i>사용</label> 
					<label class="radio"> <input type="radio" name="GM_USE" value="N" ${DetailData.GM_USE_TEMP eq '사용안함' ? 'checked':'' }> <i></i>미사용</label>
				</div>
			</section>
		</div>
		<div class="row smart-form">
			<section class="col col-6">
				<label class="label"><span class="nessSpan">*</span> 최소 인원수</label> 
				<label class="input"> 
				<i class="icon-append fa fa-check-square-o"></i> 
					<input type="text" name="GM_MINIMUM" id="GM_MINIMUM" placeholder="최소 인원수를 입력하세요." maxlength="4" class="NumberOnly" onKeyDown="return cf_only_Num(event);" onfocusout="pf_mixNum('min');"  value="${DetailData.GM_MINIMUM }"/>
				</label> 
			</section>
			<section class="col col-6">
				<label class="label"><span class="nessSpan">*</span> 최대 인원수</label> 
				<label class="input"> 
				<i class="icon-append fa fa-check-square-o"></i> 
					<input type="text" name="GM_MAXIMUM" id="GM_MAXIMUM" placeholder="허용가능한 최대 인원수를 입력하세요." maxlength="4" class="NumberOnly" onKeyDown="return cf_only_Num(event);" onfocusout="pf_mixNum('max');" value="${DetailData.GM_MAXIMUM }"/>
				</label> 
			</section>
		</div>
		<div class="row smart-form">
			<section class="col col-6">
				<label class="label"><span class="nessSpan">*</span> 프로그램 이름</label> 
				<label class="input">
					<i class="icon-append fa fa-check-square-o"></i>
						<input class="checkTrim" type="text" name="GM_NAME" id="GM_NAME" placeholder="프로그램명을 입력하세요." maxlength="50" value="${DetailData.GM_NAME }"/>
				</label>
			</section>
			<section class="col col-6">
				<label class="label"><span class="nessSpan">*</span> 프로그램 일시</label> 
				<label class="input"> 
				<i class="icon-append fa fa-check-square-o"></i> 
					<input class="checkTrim" type="text" name="GM_DATE" id="GM_DATE" placeholder="프로그램 일시를 입력하세요." value="${DetailData.GM_DATE }" maxlength="50"/>
				</label> 
			</section>
		</div>
		<div class="row smart-form">
			<section style="padding:0 15px;">  
				<label class="label"><span class="nessSpan">*</span> 프로그램 소개</label> 
				<label class="textarea"> 										
					<textarea class="checkTrim"  rows="3" class="custom-scroll" placeholder="프로그램을 소개하세요." id="GM_INTRODUCE" name="GM_INTRODUCE" maxlength="500">${DetailData.GM_INTRODUCE }</textarea> 
				</label> 
			</section>
		</div> 
		<div class="row smart-form">
			<section style="padding:0 15px;">  
				<label class="label"><span class="nessSpan">*</span> 프로그램 내용</label> 
				<label class="textarea"> 										
					<textarea class="checkTrim" rows="3" class="custom-scroll" placeholder="프로그램 내용을 입력하세요." id="GM_SUMMARY" name="GM_SUMMARY" maxlength="1000">${DetailData.GM_SUMMARY }</textarea> 
				</label> 
			</section>
		</div> 
	</fieldset>
</div>
