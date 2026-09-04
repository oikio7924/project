<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%> 

<link rel="stylesheet" href="/resources/api/jOrgChart/jquery.jOrgChart.css"/>
<script src="/resources/api/jOrgChart/jquery.jOrgChart.js"></script>

<style>
.orgInfo, .person, .personTable {display:none;}
#chart {overflow-x: scroll}

</style>

<form:form id="menuForm">
	<input type="hidden" id="MN_HOMEDIV_C" name="MN_HOMEDIV_C" value="${menu.MN_HOMEDIV_C }"/>
	<input type="hidden" id="MN_MAINKEY" name="MN_MAINKEY" value=""/>
</form:form>

<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
	<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0"
		data-widget-editbutton="false">
		<header>
			<span class="widget-icon"> <i class="fa fa-table"></i>
			</span>
			<h2>조직도</h2>
			<!-- <div class="widget-toolbar" role="menu">
				
			</div> -->
		</header>
		<div>
			<div class="widget-body">
				<div class="widget-body-toolbar bg-color-white">
   					<div class="alert alert-info no-margin fade in">
     						<button type="button" class="close" data-dismiss="alert">×</button>
     						<span style="color: red;">조직을 일괄 등록하실 경우 샘플 파일을 다운받아 업로드하셔야 합니다.</span>
   					</div> 
 					</div>  
				<form:form id="ExcelForm" method="post">
				<input type="hidden" id="organHomeKey" name="organHomeKey" value="${menu.MN_HOMEDIV_C }"/>
				<div class="widget-body-toolbar bg-color-white">
					<div class="row">
						<div class="col-sm-12 col-md-12 text-align-right">
							<div class="btn-group">  
								<input type="file" class="form-control" id="ExcelFile" name="ExcelFile" accept=".xls,.xlsx">
							</div>
							<div class="btn-group">  
								<button class="btn btn-sm btn-success" type="button" onclick="pf_excelInert()">
									<i class="fa fa-plus"></i> 일괄 등록
								</button> 
							</div>
							<div class="btn-group">  
								<button class="btn btn-sm btn-success" type="button" onclick="location.href='/dyAdmin/homepage/org/excelDownload.do'">
									<i class="fa fa-file-excel-o"></i> 샘플 파일 다운받기
								</button> 
							</div>
							<div class="btn-group">
								<a href="javascript:;" onclick="pf_openInsertOrgInfo()" class="btn btn-primary"><i class="fa fa-plus"></i> 조직추가</a>
							</div>
							<div class="btn-group">
								<a href="javascript:;" onclick="pf_excel()" class="btn btn-primary"><i class="fa fa-file-excel-o"></i> 엑셀다운</a>
							</div>
						</div>
					</div>
				</div>
				</form:form>
				<div class="orgDataDiv">
					${orgData }
				</div> 
				<div id="chart" class="orgChart"></div>
			</div>
		</div>
	</div>
</article>
<article class="col-xs-12 col-sm-12 col-md-6 col-lg-6">
	<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0"
		data-widget-editbutton="false">
		<header>
			<span class="widget-icon"> <i class="fa fa-table"></i>
			</span>
			<h2>조직정보</h2>

		</header>
		<div>
			<div class="widget-body">
				<p class="orgInfoNolist">조직을 선택하여주세요</p>
				<div class="table-responsive orgInfo">
					<table class="table table-bordered table-hover orgInfoTable">
						<tr style="display:none;">
					 		<td class="code"></td>
					 		<td class="mainCode"></td>
					 	</tr>
					 	<tr>
					 		<td>순서</td>
					 		<td class="order"></td>
					 	</tr>
					 	<tr>
					 		<td>부서명</td>
					 		<td class="title"></td>
					 	</tr>
					 	<tr>
					 		<td>상위부서</td>
					 		<td class="superTitle"></td>
					 	</tr>
					 	<tr>
					 		<td colspan="2">업무내용</td>
					 		
					 	</tr>
					 	<tr>
					 		<td colspan="2"><pre class="contents"></pre></td>
					 	</tr>
					 	<tr>
					 		<td>부서원수</td>
					 		<td class="count"></td>
					 	</tr>
					 	<tr>
					 		<td>임시부서 여부</td>
					 		<td class="tempDep"></td>
					 	</tr>
					</table>
					<div style="float:right;margin:10px 0">
						<button type="button" class="btn btn-sm btn-primary" onclick="pf_openInsertOrgInfo(this)">하위조직 추가</button>
						<button type="button" class="btn btn-sm btn-primary" onclick="pf_openUpdateOrgInfo()">수정</button>
						<button type="button" class="btn btn-sm btn-danger" onclick="pf_deleteOrgInfo();">삭제</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</article>
<article class="col-xs-12 col-sm-12 col-md-6 col-lg-6">
	<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0"
		data-widget-editbutton="false">
		<header>
			<span class="widget-icon"> <i class="fa fa-table"></i>
			</span>
			<h2>사원리스트</h2>
		</header>
		<div>
			<div class="widget-body">
				<p class="personNolist">조직을 선택하여주세요</p>
				<form:form id="FormPersonLev" class="smart-form">
				<div class="table-responsive person">
					<table class="table table-bordered table-hover personTable">
						<thead>
							<tr>
								<th>순서</th>
						 		<th>이름</th>
						 		<th>직책</th>
						 		<th style="width:40%;">설정</th>
						 	</tr>
						</thead>
					 	<tbody>
					 	
					 	</tbody>
					 	
					</table>
					<div style="float:right;margin:10px">
						<button type="button" class="btn btn-sm btn-primary" onclick="pf_openInsertPersonInfo();">추가</button>
					</div>
				</div>
				</form:form>
			</div>
		</div>
	</div>
</article>


<div class="clear"></div>

<form:form id="orgInfoForm">
	<input type="hidden" name="DN_KEYNO" id="DN_KEYNO" value="">
	<input type="hidden" name="DN_NAME" id="DN_NAME" value="">
	<input type="hidden" name="DN_MAINKEY" id="DN_MAINKEY" value="">
	<input type="hidden" name="DN_MAINKEY_BEFORE" id="DN_MAINKEY_BEFORE" value="">
	<input type="hidden" name="DN_CONTENTS" id="DN_CONTENTS" value="">
	<input type="hidden" name="DN_TEMP" id="DN_TEMP" value="">
	<input type="hidden" name="DN_LEV" id="DN_LEV" value="">
	<input type="hidden" name="DN_HOMEDIV_C" id="DN_HOMEDIV_C" value="">
</form:form>

<form:form id="orgPersonForm">
	<input type="hidden" name="DU_KEYNO" id="DU_KEYNO" value="">
	<input type="hidden" name="DU_NAME" id="DU_NAME" value="">
	<input type="hidden" name="DU_DN_KEYNO" id="DU_DN_KEYNO" value="">
	<input type="hidden" name="DU_ROLE" id="DU_ROLE" value="">
	<input type="hidden" name="DU_LEV" id="DU_LEV" value="">
	<input type="hidden" name="DU_CONTENTS" id="DU_CONTENTS" value="">
	<input type="hidden" name="DU_TEL" id="DU_TEL" value="">
	<input type="hidden" name="DU_HOMEDIV_C" id="DU_HOMEDIV_C" value="">
</form:form>

<!-- 조직정보 추가 -->
<div id="orgInfoInsert" title="조직 추가">
	<div class="widget-body ">
		<fieldset>
			<div class="form-horizontal">
				<fieldset>
					<div class="bs-example necessT">
				         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
				     </div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span class="nessSpan">*</span> 부서명</label>
						<div class="col-md-10">
							<input type="text" class="form-control orgInfoTitle" maxlength="50">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">상위부서</label>
						<div class="col-md-10">
							<div class="note" style="color: red;">* 최상위 부서는 한개만 등록가능합니다.</div>
							<select class="form-control input-sm orgInfoSuperTitle">
								<option value="">선택하세요.</option>
								<c:forEach items="${orgList }" var="model">
								<option value="${model.DN_KEYNO }">${model.DN_NAME }</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">업무내용</label>
						<div class="col-md-10">
							<textarea class="form-control orgInfoContents" placeholder="Textarea" rows="6"  maxlength="1000"></textarea>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">임시부서 여부</label>
						<div class="col-md-10">
							<label class="radio radio-inline">
								<input type="radio" class="radiobox" name="orgInfoTemp" value="Y">
								<span>O</span> 
							</label>
							<label class="radio radio-inline">
								<input type="radio" class="radiobox" name="orgInfoTemp" value="N">
								<span>X</span> 
							</label>
							<div class="note">임시부서는 홈페이지 조직도 차트에는 표시되지 않음</div>
						</div>
					</div>
				</fieldset>
			</div>
		</fieldset>
	</div>
</div>


<!-- 조직정보 수정 -->
<div id="orgInfoUpdate" title="조직정보 수정">
	
	<div class="widget-body ">
		<fieldset>
			<div class="form-horizontal">
				<fieldset>
					<div class="bs-example necessT">
				         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
				     </div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span class="nessSpan">*</span> 부서명</label>
						<div class="col-md-10">
							<input type="text" class="form-control orgInfoTitle" maxlength="50">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">상위부서</label>
						<div class="col-md-10">
							<select class="form-control input-sm orgInfoSuperTitle">
								<option value="">선택하세요.</option>
								<c:forEach items="${orgList }" var="model">
								<option value="${model.DN_KEYNO }">${model.DN_NAME }</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span class="nessSpan">*</span> 업무내용</label>
						<div class="col-md-10">
							<textarea class="form-control orgInfoContents" placeholder="Textarea" rows="6" maxlength="1000"></textarea>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">임시부서 여부</label>
						<div class="col-md-10">
							<label class="radio radio-inline">
								<input type="radio" class="radiobox" name="orgInfoTemp" value="Y">
								<span>O</span> 
							</label>
							<label class="radio radio-inline">
								<input type="radio" class="radiobox" name="orgInfoTemp" value="N">
								<span>X</span> 
							</label>
							<div class="note">임시부서는 홈페이지 조직도 차트에는 표시되지 않음</div>
						</div>
					</div>
				</fieldset>
			</div>
		</fieldset>
	</div>
</div>


<!-- 조직원 추가 -->
<div id="orgPersonInsert" title="조직원 추가">
	<div class="widget-body ">
		<fieldset>
			<div class="form-horizontal">
				<fieldset>
					<div class="bs-example necessT">
				         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
				     </div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span class="nessSpan">*</span> 사원명</label>
						<div class="col-md-10">
							<input type="text" class="form-control orgPersonName" maxlength="50">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">직책</label>
						<div class="col-md-10">
							<input type="text" class="form-control orgPersonRole" maxlength="15">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">전화번호</label>
						<div class="col-md-10">
							<textarea class="form-control orgPersonTel" rows="3" maxlength="1000"></textarea>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">업무내용</label>
						<div class="col-md-10">
							<textarea class="form-control orgPersonContents" rows="6" maxlength="1000"></textarea>
						</div>
					</div>
				</fieldset>
			</div>
		</fieldset>
	</div>
</div>

<!-- 조직원 수정 -->
<div id="orgPersonUpdate" title="조직원 수정">
	<div class="widget-body ">
		<fieldset>
			<div class="form-horizontal">
				<fieldset>
					<div class="bs-example necessT">
				         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
				     </div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span class="nessSpan">*</span> 사원명</label>
						<div class="col-md-10">
							<input type="text" class="form-control orgPersonName" maxlength="50">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">직책</label>
						<div class="col-md-10">
							<input type="text" class="form-control orgPersonRole" maxlength="15">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">전화번호</label>
						<div class="col-md-10">
							<textarea class="form-control orgPersonTel" rows="3" maxlength="1000"></textarea>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">업무내용</label>
						<div class="col-md-10">
							<textarea class="form-control orgPersonContents" rows="6" maxlength="1000"></textarea>
						</div>
					</div>
				</fieldset>
			</div>
		</fieldset>
	</div>
</div>



<script>
$(function(){
	
	var click='${click}';
	if(click){
		pf_detailOrg(click)
	}
	
	var msg = '${msg}';
	if(msg){
		cf_smallBox('alert', msg, 3000,'grey');
	}
	
	/* 조직 추가 */
	cf_setttingDialog('#orgInfoInsert','조직 추가','저장','pf_insertOrgInfo()');
	
	/* 조직정보 수정 */
	cf_setttingDialog('#orgInfoUpdate','조직정보 수정','수정','pf_updateOrgInfo()');
	
	/* 조직원 추가 */
	cf_setttingDialog('#orgPersonInsert','조직원 추가','저장','pf_insertPersonInfo()');
	
	/* 조직원 수정 */
	cf_setttingDialog('#orgPersonUpdate','조직원 수정','수정','pf_updatePersonInfo()');
	
	
	$("#org").jOrgChart({
        chartElement : '#chart'
    });
	
})


//조직원 수정
function pf_updatePersonInfo(){
	
	if(!$('#orgPersonUpdate .orgPersonName').val().trim()){
		cf_smallBox('form', '이름을 입력하여주세요.', 3000,'grey');
		$('#orgPersonName .orgPersonName').focus();
		return false;
	}
	
	if(!confirm('수정하시겠습니까?')){
		return false;
	}
	
	
	$('#DU_NAME').val($('#orgPersonUpdate .orgPersonName').val().trim())
	$('#DU_ROLE').val($('#orgPersonUpdate .orgPersonRole').val().trim())
	$('#DU_TEL').val($('#orgPersonUpdate .orgPersonTel').val())
	$('#DU_CONTENTS').val($('#orgPersonUpdate .orgPersonContents').val())
	$('#DU_HOMEDIV_C').val($('#MN_HOMEDIV_C').val())
	
	
	$('#orgPersonForm').attr('action','/dyAdmin/homepage/org/person/update.do');
	$('#orgPersonForm').submit();
	
	
}

//조직원 수정 modal창 오픈
function pf_openUpdatePersonInfo(obj){
	
	$tr= $(obj).parents('tr');
	
	$('#orgPersonUpdate').dialog('open');
	
	$('#DU_KEYNO').val($tr.find('.duKeyno').val())
	$('#orgPersonUpdate .orgPersonName').val($tr.find('.duName').text())
	$('#orgPersonUpdate .orgPersonRole').val($tr.find('.duRole').text())
	$('#orgPersonUpdate .orgPersonTel').val($tr.find('.duTel').text())
	$('#orgPersonUpdate .orgPersonContents').val($tr.find('.duContents').val())
	
}


//조직원 추가
function pf_insertPersonInfo(){
	if(!$('#orgPersonInsert .orgPersonName').val().trim()){
		cf_smallBox('form', '이름을 입력하여주세요.', 3000,'grey');
		$('#orgPersonInsert .orgPersonName').focus();
		return false;
	}
	
	if(!confirm('저장하시겠습니까?')){
		return false;
	}
	
	$('#DU_NAME').val($('#orgPersonInsert .orgPersonName').val().trim())
	$('#DU_ROLE').val($('#orgPersonInsert .orgPersonRole').val().trim())
	$('#DU_CONTENTS').val($('#orgPersonInsert .orgPersonContents').val())
	$('#DU_TEL').val($('#orgPersonInsert .orgPersonTel').val())
	$('#DU_HOMEDIV_C').val($('#MN_HOMEDIV_C').val())
	
	$('#orgPersonForm').attr('action','/dyAdmin/homepage/org/person/insert.do');
	$('#orgPersonForm').submit();
	
	
}

//조직원 추가 modal창 오픈
function pf_openInsertPersonInfo(obj){
	$('#orgPersonInsert').dialog('open');
	$('#orgPersonInsert input, #orgPersonInsert textarea').val('');
	
}

//조직원 삭제
function pf_deletePersonInfo(obj){
	if(!confirm('정말 삭제하시겠습니까?')){
		return false;
	}
	
	$tr= $(obj).parents('tr');
	$('#DU_KEYNO').val($tr.find('.duKeyno').val())
	$('#DU_LEV').val($tr.find('.duLev').val())
	$('#DU_HOMEDIV_C').val($('#MN_HOMEDIV_C').val())
	var code = $('.orgInfoTable .code').text();
	$('#orgPersonForm').attr('action','/dyAdmin/homepage/org/person/delete.do');
	$('#orgPersonForm').submit();
}

//조직 추가 modal창 오픈
function pf_openInsertOrgInfo(obj){
	if($('#MN_HOMEDIV_C').val() == ''){
		cf_smallBox('form', '홈페이지를 선택해주세요.', 3000,'grey');
	}else{
		$('#orgInfoInsert').dialog('open');
		if(obj){
			$('#orgInfoInsert .orgInfoSuperTitle').val($('.orgInfoTable .code').text())
		}else{
			$('#orgInfoInsert .orgInfoSuperTitle').val('')
		}
		$('#orgInfoInsert input[name=orgInfoTemp][value=N]').next().trigger('click')
	}
}

//조직정보 추가
function pf_insertOrgInfo(){
	
	if(!$('#orgInfoInsert .orgInfoTitle').val().trim()){
		cf_smallBox('form', '부서명을 입력하여주세요.', 3000,'grey');
		$('#orgInfoInsert .orgInfoTitle').focus();
		return false;
	}
	
	if(!confirm('저장하시겠습니까?')){
		return false;
	}
		
	
	
	$('#DN_NAME').val($('#orgInfoInsert .orgInfoTitle').val().trim())
	$('#DN_MAINKEY').val($('#orgInfoInsert .orgInfoSuperTitle').val())
	$('#DN_CONTENTS').val($('#orgInfoInsert .orgInfoContents').val())
	$('#DN_TEMP').val($('#orgInfoInsert input[name=orgInfoTemp]:checked').val())
	$('#DN_HOMEDIV_C').val($('#MN_HOMEDIV_C').val())
	
	$('#orgInfoForm').attr('action','/dyAdmin/homepage/org/insert.do');
	$('#orgInfoForm').submit();
	
	
}


//조직정보 수정 modal창 오픈
function pf_openUpdateOrgInfo(){
	
	$('#orgInfoUpdate').dialog('open');
	
	var code = $('.orgInfoTable .code').text();
	$('#DN_KEYNO').val(code)
	
	$('#orgInfoUpdate .orgInfoTitle').val($('.orgInfoTable .title').text())
	
	$('#orgInfoUpdate .orgInfoSuperTitle').val($('.orgInfoTable .mainCode').text())
	
	$('#orgInfoUpdate .orgInfoSuperTitle option').show();
	$('#orgInfoUpdate .orgInfoSuperTitle option[value='+code+']').hide();
	
	$('#orgInfoUpdate .orgInfoContents').val($('.orgInfoTable .contents').text())
	
	$('#orgInfoUpdate input[name=orgInfoTemp][value='+$('.orgInfoTable .tempDep').text()+']').next().trigger('click')
	
	
	
	
}

//조직정보 수정
function pf_updateOrgInfo(){
	
	if(!$('#orgInfoUpdate .orgInfoTitle').val().trim()){
		cf_smallBox('alert', '부서명을 입력하여주세요.', 3000,'grey');
		$('#orgInfoUpdate .orgInfoTitle').focus();
		return false;
	}
	
	if(!confirm('수정하시겠습니까?')){
		return false;
	}
	
	
	$('#DN_NAME').val($('#orgInfoUpdate .orgInfoTitle').val().trim())
	$('#DN_MAINKEY').val($('#orgInfoUpdate .orgInfoSuperTitle').val())
	$('#DN_CONTENTS').val($('#orgInfoUpdate .orgInfoContents').val())
	$('#DN_TEMP').val($('#orgInfoUpdate input[name=orgInfoTemp]:checked').val())
	$('#DN_HOMEDIV_C').val($('#MN_HOMEDIV_C').val())
	$('#orgInfoForm').attr('action','/dyAdmin/homepage/org/update.do');
	
	$('#orgInfoForm').submit();
	
	
}

//조직 삭제
function pf_deleteOrgInfo(){
	if(!confirm('정말 삭제하시겠습니까?')){
		return false;
	}
	var code = $('.orgInfoTable .code').text();
	var lev = $('.orgInfoTable .dnLev').val();
	var maincode = $('.orgInfoTable .dnMainKey').val();
	$('#DN_LEV').val(lev);
	$('#DN_MAINKEY').val(maincode);
	$('#DN_KEYNO').val(code);
	$('#DN_HOMEDIV_C').val($('#MN_HOMEDIV_C').val())
	$('#orgInfoForm').attr('action','/dyAdmin/homepage/org/delete.do');
	$('#orgInfoForm').submit();
}

//조직 정보보기
function pf_detailOrg(key){
	event.stopPropagation();
	cf_loading();
	$.ajax({
		type: "POST",
		url: "/dyAdmin/homepage/org/dataAjax.do",
		data: {"key":key,
				"DN_HOMEDIV_C":$('#MN_HOMEDIV_C').val()
				},
		success : function(result){
			var data = result.data;
			$('.orgInfoNolist').hide();
			$('.orgInfo').show();
			
			$('.orgInfoTable .code').text(data.DN_KEYNO);
			$('.orgInfoTable .mainCode').text(data.DN_MAINKEY);
			$('#DN_MAINKEY_BEFORE').val(data.DN_MAINKEY);
			$('.orgInfoTable .title').text(data.DN_NAME);
			$('.orgInfoTable .superTitle').text(data.DN_MAINNAME);
			if(data.DN_CONTENTS == undefined) data.DN_CONTENTS = '';
			$('.orgInfoTable .contents').text(data.DN_CONTENTS);
			$('.orgInfoTable .count').text(data.DN_COUNT);
			$('.orgInfoTable .tempDep').text(data.DN_TEMP);
			
			var order = result.LevelCnt;
			if(order.length > 0){
				var temp = '';
				$.each(order,function(i){
					
/* 					if(data.DN_KEYNO == order[i].DN_KEYNO){
						temp += '<label class="select"><select name="DN_LEV_AFTER" style="width:100px; padding:2%;">';
						for(var c=1 ; c <= order.length ; c++){
							var selected = ( c == (order[i].DN_LEV) ) ? 'selected':'';
							temp += '<option value="'+c+'" '+selected+'>'+c+'</option>';
						}
						temp += '</select><i></i></label>'; 
						temp += '<input type="hidden" class="dnKeyno" value='+order[i].DN_KEYNO+'>';
						temp += '<input type="hidden" class="dnLev" value='+order[i].DN_LEV+'>';
						temp += '<input type="hidden" class="dnMainKey" value='+order[i].DN_MAINKEY+'>';
					} */
					
					if(data.DN_KEYNO == order[i].DN_KEYNO){
						if(data.DN_MAINKEY == null){
							temp += '<label class="select"><select name="DN_LEV_AFTER" style="width:100px; padding:2%;">';
							temp += '<option value="'+order[i].DN_LEV+'" '+'select="selected">'+order[i].DN_LEV+'</option>';
							
							temp += '</select><i></i></label>'; 
							temp += '<input type="hidden" class="dnKeyno" value='+order[i].DN_KEYNO+'>';
							temp += '<input type="hidden" class="dnLev" value='+order[i].DN_LEV+'>';
							temp += '<input type="hidden" class="dnMainKey" value='+order[i].DN_MAINKEY+'>';
						}else{
						temp += '<label class="select"><select name="DN_LEV_AFTER" style="width:100px; padding:2%;">';
						for(var c=1 ; c <= order.length ; c++){
							var selected = ( c == (order[i].DN_LEV) ) ? 'selected':'';
							temp += '<option value="'+c+'" '+selected+'>'+c+'</option>';
						}
						temp += '</select><i></i></label>'; 
						temp += '<input type="hidden" class="dnKeyno" value='+order[i].DN_KEYNO+'>';
						temp += '<input type="hidden" class="dnLev" value='+order[i].DN_LEV+'>';
						temp += '<input type="hidden" class="dnMainKey" value='+order[i].DN_MAINKEY+'>';
					}
					}
					
				});
			$('.orgInfoTable .order').html(temp);
			
			$(".orgInfoTable tbody .order").find("select[name='DN_LEV_AFTER']").on('change',function(){
				var dnlevAfter = $(this).val();
				var dnlev = $(this).parents('tr').find('.dnLev').val()
				var dnkey = $(this).parents('tr').find('.dnKeyno').val()
				var dnMainKey = $(this).parents('tr').find('.dnMainKey').val()
				
				$.ajax({
					type: "POST",
					url: "/dyAdmin/homepage/org/person/chageLev2.do",
					data: {
						"DN_KEYNO":dnkey,
						"DN_MAINKEY":dnMainKey,
						"DN_LEV":Number(dnlev),
						"DN_LEV_AFTER":Number(dnlevAfter),
						"type":"N",
						"DN_HOMEDIV_C":$('#MN_HOMEDIV_C').val()
					},
					async:false,
					success : function(data){
						location.href="/dyAdmin/homepage/org/org.do?key="+key+"&MN_HOMEDIV_C="+$('#MN_HOMEDIV_C').val();
					},
					error: function(){
						cf_smallBox('error', '데이터를 가져올수없습니다. 관리자한테 문의하세요.', 3000,'#d24158');
						return false;
					}
				});
				
				
			});
			
			}
			
			$('#DU_DN_KEYNO').val(data.DN_KEYNO);
			$('.person').show();
			
			var list = result.list;
			if(list.length > 0){
				$('.personNolist').hide();
				$('.personTable').show();
				
				var temp = '';
				$.each(list,function(i){
					temp += '<tr>';
					temp += '<td>';
					temp += '<label class="select"><select name="DU_LEV_AFTER">';
					for(var c=1 ; c <= list.length ; c++){
						var selected = ( c == (i+1) ) ? 'selected':'';
						temp += '<option value="'+c+'" '+selected+'>'+c+'</option>';
					}
					temp += '</select><i></i></label></td>';
					temp += '<td class="duName">'+list[i].DU_NAME+'</td>';
					temp += '<td class="duRole">'+list[i].DU_ROLE+'</td>';
					temp += '<td style="text-align:center;"><button type="button" class="btn btn-sm btn-primary" style="margin-right:5px;" onclick="pf_openUpdatePersonInfo(this);">더보기</button>';
					temp += '<button type="button" class="btn btn-sm btn-danger" onclick="pf_deletePersonInfo(this);">삭제</button>';
					temp += '<div class="duMoreInfo" style="display:none;"><input type="text" name="DU_KEYNO" class="duKeyno" value="'+list[i].DU_KEYNO+'"><input type="text" name="DU_LEV" class="duLev" value="'+list[i].DU_LEV+'"><textarea class="duContents">'+list[i].DU_CONTENTS+'</textarea>';
					temp += '<textarea class="duTel">'+list[i].DU_TEL+'</textarea>';
					temp += '</td>';
					
					temp += '</tr>';
				})
				$('.personTable tbody').html(temp)
				
				$(".personTable tbody").sortable({
					beforeStop: function( event, ui ) {
						$(".personTable tbody").find("select[name='DU_LEV_AFTER']").each(function(i){
							$(this).val(i+1);
						})
						pf_changeLev();
					}
				});
				
				$(".personTable tbody").find("select[name='DU_LEV_AFTER']").on('change',function(){
					var dulevAfter = $(this).val();
					var dulev = $(this).parents('tr').find('.duLev').val()
					var dukey = $(this).parents('tr').find('.duKeyno').val()
					$.ajax({
						type: "POST",
						url: "/dyAdmin/homepage/org/person/chageLev2.do",
						data: {
							"DU_KEYNO":dukey,
							"DU_LEV":Number(dulev),
							"DU_LEV_AFTER":Number(dulevAfter),
							"DU_DN_KEYNO":key,
							"type":"U"
						},
						async:false,
						success : function(data){
							pf_detailOrg(key)
						},
						error: function(){
							cf_smallBox('error', '데이터를 가져올수없습니다. 관리자한테 문의하세요.', 3000,'#d24158');
							return false;
						}
					});
					
					
				})
				$(".personTable tbody").disableSelection();
				
			}else{
				$('.personTable').hide();
				$('.personNolist').text(data.DN_NAME + '에 사원이 배정되지 않았습니다.').show();
			}
			
			
		},
		error: function(){
			cf_smallBox('error', '예상치못한 오류가 발생했습니다.', 3000,'#d24158');
			return false;
		}
	}).done(function(){
		cf_loading_out();
	});
	
	
}

function pf_changeLev(){
	
	$.ajax({
		type: "POST",
		url: "/dyAdmin/homepage/org/person/chageLev.do",
		data: $('#FormPersonLev').serializeArray(),
		async:false,
		success : function(data){
			
		},
		error: function(){
			cf_smallBox('error', '데이터를 가져올수없습니다. 관리자한테 문의하세요.', 3000,'#d24158');
			return false;
		}
	});
	
}

function pf_excel(){
	if($("#MN_HOMEDIV_C").val() == ''){
		cf_smallBox('alert', '홈페이지를 선택해주세요.', 3000,'gray');
		return false;
	}
	$("#menuForm").attr("action", "/dyAdmin/homepage/org/excelAjax.do");
	$("#menuForm").submit();
}


function pf_excelInert(){
	var file = $("#ExcelFile").val();
	var ext = file.substring(file.indexOf(".")+1)
	if(file == ""){
		cf_smallBox('alert', '파일을 등록해주세요.', 3000,'gray');
		return false;
	}
    if("xlsx".indexOf(ext) != -1){
       if(confirm('조직도를 일괄등록 하시겠습니까?\n모든 데이터가 초기화됩니다.')){
            var form = $('#ExcelForm')[0];
            var formData = new FormData(form);

            cf_loading();
            
            setTimeout(function () {
                $.ajax({
                    type: "POST",
                    url: '/dyAdmin/homepage/org/excelInsertAjax.do',
                    async: false,
                    processData: false,
                    contentType: false,
                    enctype: "multipart/form-data",
                    data: formData,
                    success : function(data){
                        cf_smallBox('ajax', "복원을 완료하였습니다.", 3000);
                        location.href='/dyAdmin/homepage/org/org.do';
                    }, 
                    error: function(){
                        cf_smallBox('error', "알수없는 에러, 관리자에게 문의하세요.", 3000,'#d24158');
                        cf_loading_out();
                        return false;
                    }
                });
            }, 1000);
        }
    }else{
        cf_smallBox('alert', '엑셀파일만 등록 가능합니다.', 3000,'gray');
    }
}


</script>
