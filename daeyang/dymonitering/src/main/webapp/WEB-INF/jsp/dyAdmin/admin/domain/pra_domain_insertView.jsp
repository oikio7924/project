<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<input type="hidden" name="HM_KEYNO" id="HM_KEYNO" value="${resultData.HM_KEYNO }">
<input type="hidden" name="MN_KEYNO" value="${resultData.HM_MN_HOMEDIV_C }">
<input type="hidden" name="HM_FAVICON" value="${resultData.HM_FAVICON }">
<input type="hidden" name="HM_GROUP_NAME" id="HM_GROUP_NAME" value="">
<input type="hidden" name="tilesBefore" id="tilesBefore" value="${resultData.HM_TILES }">
<input type="hidden" id="isPossibleDelete" value="">
<style>
.help-block {color:#468847;}

.except-${formActionType} {display:none;}

<c:if test="${resultData.HM_MN_HOMEDIV_C eq sp:getData('HOMEDIV_ADMIN')}">
.except-admin {display:none;}
</c:if>


</style>
<fieldset>
	<legend>기본정보</legend>
	<div class="form-group except-admin">
		<label class="col-md-2 control-label"><span class="nessSpan">*</span> 사용여부</label>
		<div class="col-md-10">
			<label class="radio radio-inline">
				<input type="radio" class="radiobox" name="HM_USE_YN" value="Y" ${empty resultData || resultData.HM_USE_YN eq 'Y' ? 'checked="checked"':'' }>
				<span>사용</span> 
			</label>
			<label class="radio radio-inline">
				<input type="radio" class="radiobox" name="HM_USE_YN" value="N" ${resultData.HM_USE_YN eq 'N' ? 'checked="checked"':'' }>
				<span>미사용</span> 
			</label>
		</div>
	</div>
	
	<div class="form-group except-admin">
		<label class="col-md-2 control-label">그룹</label>
		<div class="col-md-10">
			<select class="form-control" name="HM_GROUP" id="HM_GROUP" onchange="pf_setGroupName()">
		<c:choose>
			<c:when test="${empty resultData}">
				<option value="">그룹 없음</option>
				<c:forEach items="${sp:getCodeList('BA')}" var="model">
				<option value="${model.SC_KEYNO }">${model.SC_CODENM }</option>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<c:forEach items="${sp:getCodeList('BA')}" var="model">
					<c:if test="${model.SC_KEYNO eq resultData.HM_GROUP }">
				<option value="${model.SC_KEYNO }">${model.SC_CODENM }</option>
					</c:if>
				</c:forEach>
			</c:otherwise>
		</c:choose>
			</select>
		</div>
	</div>
	
	<div class="form-group">
		<label class="col-md-2 control-label"><span class="nessSpan">*</span> 홈페이지명</label>
		<div class="col-md-10">
			<div class="input-group">
				<input type="text" class="form-control" placeholder="입력하세요." 
						name="MN_NAME" id="MN_NAME" maxlength="50" onkeyup="pf_checkLength('MN_NAME',50)"
						value="${resultData.MN_NAME }">
				<span class="input-group-addon length" id="MN_NAME_length">(0/50자)</span>
			</div>
		</div>
	</div>
	<div class="form-group except-admin">
		<label class="col-md-2 control-label"><span class="nessSpan">*</span> 정렬순서</label>
		<div class="col-md-10">
			<input type="number" min="0" max="999" class="form-control" 
					name="MN_ORDER" id="MN_ORDER" maxlength="3"
					onkeydown="return cf_onlyNumAndLimitLength(this,event)" 
					value="${resultData.MN_ORDER }">
		</div>
	</div>
	<div class="form-group except-admin">
		<label class="col-md-2 control-label"><span class="nessSpan">*</span> 언어 선택</label>
		<div class="col-md-10">
			<select class="form-control" name="HM_LANG" id="HM_LANG">
			<c:forEach items="${sp:getCodeList('CP')}" var="model">
			<option value="${model.SC_CODEVAL01 }" ${model.SC_CODEVAL01 eq resultData.HM_LANG ? 'selected':''}>${model.SC_CODENM }</option>
			</c:forEach>
			</select>
			<span class="help-block">HTML 태그 lang 속성에 들어갈 언어를 선택합니다.</span>
		</div>
	</div>
	<div class="form-group">
		<label class="col-md-2 control-label"><span class="nessSpan">*</span> 홈페이지 타이틀명</label>
		<div class="col-md-10">
			<div class="input-group">
				<input type="text" class="form-control" placeholder="입력하세요." 
						name="HM_TITLE" id="HM_TITLE" maxlength="50" onkeyup="pf_checkLength('HM_TITLE',70)"
						value="${resultData.HM_TITLE }">
				<span class="input-group-addon length" id="HM_TITLE_length">(0/50자)</span>
			</div>
			<span class="help-block">TITLE 태그에 들어갈 이름입니다. 브라우저 탭에 표출됩니다.</span>
		</div>
	</div>
	<div class="form-group">
		<label class="col-md-2 control-label"><span class="nessSpan">*</span> 세션 종료시간</label>
		<div class="col-md-10">
			<div class="input-group">
				<input type="number" class="form-control" placeholder="시간(분) 을 입력하세요." 
						name="HM_SESSION" id="HM_SESSION" maxlength="5"
						value="${resultData.HM_SESSION eq null ? '30' : resultData.HM_SESSION}">
			</div>
		</div>
	</div>
	<div class="form-group except-admin">
		<label class="col-md-2 control-label"><span class="nessSpan">*</span> 메뉴 깊이제한</label>
		<div class="col-md-10">
			<select class="form-control" name="HM_MENU_DEPTH" id="HM_MENU_DEPTH">
				<option value="5" ${resultData.HM_MENU_DEPTH eq '5' ? 'selected':'' }>5단</option>
				<c:if test="${formActionType eq 'insert' || ( formActionType eq 'update' && resultData.HM_MENU_DEPTH le '4' ) }">
				<option value="4" ${resultData.HM_MENU_DEPTH eq '4' ? 'selected':'' }>4단</option>
				</c:if>
				<c:if test="${formActionType eq 'insert' || ( formActionType eq 'update' && resultData.HM_MENU_DEPTH le '3' ) }">
				<option value="3" ${resultData.HM_MENU_DEPTH eq '3' ? 'selected':'' }>3단</option>
				</c:if>
				<c:if test="${formActionType eq 'insert' || ( formActionType eq 'update' && resultData.HM_MENU_DEPTH le '2' ) }">
				<option value="2" ${resultData.HM_MENU_DEPTH eq '2' ? 'selected':'' }>2단</option>
				</c:if>
				
			</select>
			<span class="help-block">수정 할 경우 더 적은 뎁스로는 변경 불가능합니다.</span>
		</div>
	</div>
	<div class="form-group except-admin" >
		<label class="col-md-2 control-label"><span class="nessSpan">*</span> 시작 URL</label>
		<div class="col-md-10">
			<div class="input-group">
				<input type="text" class="form-control" placeholder="입력하세요." 
						name="HM_TILES" id="HM_TILES" maxlength="50" onkeyup="pf_checkLength('HM_TILES',10)"
						value="${resultData.HM_TILES }">
				<span class="input-group-addon length" id="HM_TILES_length">(0/10자)</span>
			</div>
			<span class="help-block">영어 소문자와 숫자만 가능합니다.(※ common은 입력불가)</span>
		</div>
	</div>
	<div class="form-group except-admin" >
		<label class="col-md-2 control-label"><span class="nessSpan">*</span> 사이트 경로</label>
		<div class="col-md-10">
		<c:choose>
			<c:when test="${formActionType eq 'insert' }">
				<div class="input-group">
					<input type="text" class="form-control" placeholder="입력하세요." 
							name="HM_SITE_PATH" id="HM_SITE_PATH" maxlength="50" onkeyup="pf_checkLength('HM_SITE_PATH',10)"
							value="${resultData.HM_TILES }">
					<span class="input-group-addon length" id="HM_SITE_PATH_length">(0/10자)</span>
				</div>
				<span class="help-block">_(언더바)로 시작하고 영어 대문자와 숫자만 가능합니다. (※ common은 입력불가)</span>
			</c:when>
			<c:otherwise>
				<div style="padding-top:7px;">${resultData.HM_SITE_PATH }</div>
				<input type="hidden" name="HM_SITE_PATH" id="HM_SITE_PATH" value="${resultData.HM_SITE_PATH }">
			</c:otherwise>
		</c:choose>
		</div>
	</div>
	<div class="form-group except-admin">
		<label class="col-md-2 control-label">대표 이미지</label>
		<div class="col-md-10">
			<div class="row">
				<div class="col-md-6">
					<input type="file" name="homeimg" id="homeimg" accept=".ico" 
		              			 onchange="cf_imgCheckAndPreview('homeimg','ico','1','','/resources/favicon.ico','F')">
				</div>
				<div class="col-md-6">
					<c:choose>
						<c:when test="${formActionType eq 'update' && not empty resultData.HM_FAVICON }">
							<c:set var="favicon" value="${resultData.HM_FAVICON }"/>
						</c:when>
						<c:otherwise>
							<c:set var="favicon" value="/resources/favicon.ico"/>
						</c:otherwise>
					</c:choose>
					<span>아이콘 : <img src="${favicon }" id="homeimg_img" style="max-width: 20px;"></span>
				</div>
			</div>
			<span class="help-block">브라우저 왼쪽 상단에 나타나는 아이콘입니다. 파비콘(favicon)이라고 불리며 .ico 파일만 지원합니다.</span>
		</div>
	</div>
	
	<div class="form-group except-update">
		<label class="col-md-2 control-label">템플릿 설정</label>
		<div class="col-md-10">
			<select class="form-control" name="template">
				<option value="">기본</option>
				<c:forEach items="${homeDivList}" var="model">
				<option value="${model.HM_KEYNO}">${model.MN_NAME }</option>
				</c:forEach>
			</select>
			<span class="help-block">기존 도메인을 선택하시면 해당 도메인의 css,js,레이아웃들을 가져옵니다.</span>
		</div>
	</div>
	
	<div class="form-group except-admin">
		<label class="col-md-2 control-label"><span class="nessSpan">*</span> 로그인 페이지 사용 여부</label>
		<div class="col-md-10">
			<label class="radio radio-inline">
				<input type="radio" class="radiobox" name="HM_LOGIN" value="Y" ${empty resultData || resultData.HM_LOGIN eq 'Y' ? 'checked="checked"':'' }>
				<span>사용</span> 
			</label>
			<label class="radio radio-inline">
				<input type="radio" class="radiobox" name="HM_LOGIN" value="N" ${resultData.HM_LOGIN eq 'N' ? 'checked="checked"':'' }>
				<span>미사용</span> 
			</label>
			<span class="help-block">세션 끊어질 경우 로그인 페이지를 사용한다면 로그인 페이지로 / 아니라면 메인 페이지로 이동합니다.</span>
		</div>
	</div>
	
</fieldset>

<fieldset class="except-admin">
	<legend>메타 관리</legend>

	<div class="form-group">
	    <label class="col-md-2 control-label">설명 내용</label>
	    <div class="col-md-10">
	        <div class="input-group">
				<input type="text" class="form-control" placeholder="설명 내용을 입력하세요." 
						name="HM_META_DESC" id="HM_META_DESC" maxlength="200" onkeyup="pf_checkLength('HM_META_DESC',200)"
						value="${resultData.HM_META_DESC }">
				<span class="input-group-addon length" id="HM_META_DESC_length">(0/200자)</span>
			</div>
	    </div>
	</div>
	
	<div class="form-group">
	    <label class="col-md-2 control-label">키워드 내용</label>
	    <div class="col-md-10">
	    	<div class="input-group">
		        <input type="text" class="form-control" placeholder="키워드 내용을 입력하세요." 
							name="HM_META_KEYWORD" id="HM_META_KEYWORD" maxlength="200" onkeyup="pf_checkLength('HM_META_KEYWORD',200)"
							value="${resultData.HM_META_KEYWORD }">
				<span class="input-group-addon length" id="HM_META_KEYWORD_length">(0/200자)</span>
			</div>
	    </div>
	</div>
	
</fieldset>

<fieldset>
	<legend>스킨 관리</legend>
	<div class="form-group">
		<label class="col-md-2 control-label"></label>
		<div class="col-md-10">
			<span class="help-block">* 미선택시 기본 스킨으로 적용됩니다. </span>
		</div>
	</div>
	
	<div class="form-group">
	    <label class="col-md-2 control-label">페이지평가 스킨</label>
	    <div class="col-md-10">
	        <div class="input-group col-sm-12">
	            <select class="form-control input-sm" name="HM_RESEARCH_SKIN">
	                <option value="basic">기본</option>
	                <c:forEach items="${formDataList_R }" var="model3">
	                    <option value="${model3.PRS_KEYNO }" ${resultData.HM_RESEARCH_SKIN eq model3.PRS_KEYNO ? 'selected' :'' }>${model3.PRS_SUBJECT }</option>
	                </c:forEach>
	            </select>
	        </div>
	    </div>
	</div>
	
	<div class="form-group">
	    <label class="col-md-2 control-label">팝업 스킨 레이아웃형</label>
	    <div class="col-md-10">
	        <div class="input-group col-sm-12">
	            <select class="form-control input-sm" name="HM_POPUP_SKIN_W">
	                <option value="layout_basic">기본</option>
	                <c:forEach items="${formDataList_W }" var="model4">
	                    <option value="${model4.PIS_KEYNO }" ${resultData.HM_POPUP_SKIN_W eq model4.PIS_KEYNO ? 'selected' :'' }>${model4.PIS_SUBJECT }</option>
	                </c:forEach>
	            </select>
	        </div>
	    </div>
	</div>
	
	<div class="form-group">
		<label class="col-md-2 control-label">팝업 스킨 배너형</label>
		<div class="col-md-10">
		    <div class="input-group col-sm-12">
		        <select class="form-control input-sm" name="HM_POPUP_SKIN_B">
		            <option value="banner_basic">기본</option>
		            <c:forEach items="${formDataList_B }" var="model5">
		                <option value="${model5.PIS_KEYNO }" ${resultData.HM_POPUP_SKIN_B eq model5.PIS_KEYNO ? 'selected' :'' }>${model5.PIS_SUBJECT }</option>
		            </c:forEach>
		        </select>
		    </div>
		</div>
	</div>
		
	
</fieldset>

<input type="hidden" id="siteMapFreq" name="MN_CHANGE_FREQ" value="${empty resultData.MN_CHANGE_FREQ ? 'always' : resultData.MN_CHANGE_FREQ }" >
<input type="hidden" id="siteMapPriority" name="MN_PRIORITY" value="${empty resultData.MN_PRIORITY ? '1.0' : resultData.MN_PRIORITY }" >
											

<fieldset>
	<legend>사이트맵 정보</legend>					
						
		<section class="col-xs-12 col-sm-12 col-md-12 col-lg-12 marginTop">
			<div class="form-group">
				<label class="col-xs-2 col-sm-2 col-md-2 col-lg-2 control-label labeltitle">변경 빈도수</label>
				<div class="col-xs-10 col-sm-10 col-md-10 col-lg-10">
					<select class="form-control input-sm" id="MN_CHANGE_FREQ" onchange="pf_checkfreq(this.value)">
					<c:forTokens var="item" items="always,hourly,daily,weekly,monthly,yearly,never" delims=",">
						<option value="${item }" ${item eq resultData.MN_CHANGE_FREQ ? 'selected' : '' }>${item }</option>
					</c:forTokens>																							
					</select>
				</div>
		    </div>
	    </section>
	    
	  <section class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
			<div class="form-group">
				<label class="col-xs-2 col-sm-2 col-md-2 col-lg-2 control-label labeltitle">우선순위</label>
				<div class="col-xs-10 col-sm-10 col-md-10 col-lg-10">
					<select class="form-control input-sm" id="MN_PRIORITY" onchange="pf_checkPriority(this.value)">
					<c:forTokens var="item" items="1.0,0.9,0.8,0.7,0.6,0.5,0.4,0.3,0.2,0.1,0.0" delims=",">
						<option value="${item }" ${item eq resultData.MN_PRIORITY ? 'selected' : '' }>${item }</option>
					</c:forTokens>
					</select>
				</div>
		    </div>
	    </section>
	</fieldset>
					

<fieldset>
	<legend>로그인시 권한별 시작 페이지</legend>
	<div class="form-group">
		<label class="col-md-2 control-label"></label>
		<div class="col-md-10">
			<span class="help-block">* 공백으로 두시면 기본 디폴트 시작 페이지로 설정됩니다.(/시작url(자동등록)/index.do)</span>
		</div>
	</div>
	<c:forEach items="${authorityList }" var="model">
	<input type="hidden" name="UIA_KEYNO" value="${model.UIA_KEYNO }">
	<div class="form-group">
		<label class="col-md-2 control-label">${model.UIA_NAME }</label>
		<div class="col-md-10">
			<div class="input-group">
				<input type="text" class="form-control HAM_DEFAULT_URL" placeholder="입력하세요." 
						name="HAM_DEFAULT_URL" maxlength="100" onkeyup="pf_checkClassLength(this,100)"
						value="${model.HAM_DEFAULT_URL }">
				<span class="input-group-addon length2">(0/100자)</span>
			</div>
		</div>
	</div>
	</c:forEach>
</fieldset>



<script>

$(function(){
	
	formActionType = '${formActionType}';
	
	if(formActionType != 'insert'){
		
		$('.input-group-addon.length').each(function(){
			var id = $(this).attr('id').replace('_length','');
			var maxLength = $('#'+id).attr('maxlength');
			pf_checkLength(id,maxLength);
			
		})
		
		$('.HAM_DEFAULT_URL').each(function(){
			pf_checkClassLength($(this),100);
		})
	}
})


// 사이트맵 빈도수 설정
function pf_checkfreq(value) {
	$('input[id=siteMapFreq]').val(value);
}

//사이트맵 우선순위 설정
function pf_checkPriority(value) {
	$('input[id=siteMapPriority]').val(value);
}


function pf_setGroupName(){
	$('#HM_GROUP_NAME').val($('#HM_GROUP option:selected').text());
}

</script>
