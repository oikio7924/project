<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>
label input[type=checkbox].checkbox+span, label input[type=radio].radiobox+span{z-index: 1}
.control-label {padding-right:10px;text-align:right;line-height: 32px;}
.smart-form .row {margin: 10px -15px;}
.dl-horizontal dt {line-height: 32px;}
#draggableWrap {width:800px;height:500px;border:1px solid red;margin:10px;position:relative;}
.draggable {  padding: 0.5em;position:absolute;top:0;left:0;cursor: pointer;text-align: center; }
.draggable i {float:right;}
.seatTable td {padding: 4px;font-size: 10px;}
.seatTable td p{font-size: 10px !important; padding-top: 4px; padding-bottom : 4px; width: 25px; }
.settingSeatTable {margin:20px auto 0;min-height:400px;overflow: scroll;}
.settingSeatTable td {text-align: center;}
.settingSeatTable input[type=text] {width: 50px;margin: 5px;padding: 5px;height:20px;text-align: center;}
button.deleteRow, button.deleteCol {font-size:10px;padding:5px;}
#addSeatGroup .addRowAndColBtn {display:none;}

</style>
<div id="content">
	<section id="widget-grid" >
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" id="" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-lg fa-desktop"></i> </span>
						<h2>장소관리   ${action eq 'Insert' ? '등록':'수정' } </h2>
					</header> 
					<div class="jarviswidget-editbox"></div>
					
					<div class="widget-body">
						<form:form id="Form" method="post" class="smart-form" enctype="multipart/form-data">
							<input type="hidden" name="PM_KEYNO" value="${resultData.PM_KEYNO }">
							<input type="hidden" name="PM_FS_KEYNO" value="${resultData.PM_FS_KEYNO }">
							<input type="hidden" name="PM_SEAT_FS_KEYNO" value="${resultData.PM_SEAT_FS_KEYNO }">
							<input type="hidden" name="seatGroupData" id="seatGroupData" value="">
							<input type="hidden" name="PM_SEATPLAN_WIDTH" id="PM_SEATPLAN_WIDTH" value="">
							<input type="hidden" name="PM_SEATPLAN_HEIGHT" id="PM_SEATPLAN_HEIGHT" value="">
							<legend>장소관리   ${action eq 'Insert' ? '등록':'수정' }</legend>
							<fieldset>
								<div class="bs-example necessT">
							         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
							    </div>
								<div class="row">
									<label class="col-md-2 control-label"><span class="nessSpan">*</span> 장소명</label>
									<div class="col-md-6 col-lg-6">
							            <label class="input"> 
							            	<i class="icon-append fa fa-question-circle"></i>
											<input class="checkTrim" type="text" name="PM_NAME" id="PM_NAME" placeholder="장소명을 입력하세요" value="${resultData.PM_NAME }" maxlength="100">
											<b class="tooltip tooltip-top-right">
												<i class="fa fa-warning txt-color-teal"></i> 
												장소명을 입력하세요.
											</b> 
										</label>
									</div>
								</div>
								
								<div class="row">
									<label class="col-md-2 control-label">장소명(영문)</label>
									<div class="col-md-6 col-lg-6">
							            <label class="input"> 
							            	<i class="icon-append fa fa-question-circle"></i>
											<input class="checkTrim" type="text" name="PM_NAME_EN" id="PM_NAME_EN" placeholder="장소명(영문)을 입력하세요" value="${resultData.PM_NAME_EN }" maxlength="100">
											<b class="tooltip tooltip-top-right">
												<i class="fa fa-warning txt-color-teal"></i> 
												장소명(영문)을 입력하세요.
											</b> 
										</label>
									</div>
								</div>
								
								<div class="row">
									<label class="col-md-2 control-label">좌석수</label>
									<div class="col-md-6 col-lg-6">
							            <label class="input"> 
							            	<i class="icon-append fa fa-question-circle"></i>
											<input type="number" name="PM_SEAT" id="PM_SEAT" placeholder="좌석수를 입력하세요" value="${resultData.PM_SEAT }" maxlength="100">
											<b class="tooltip tooltip-top-right">
												<i class="fa fa-warning txt-color-teal"></i> 
												좌석수를 입력하세요.
											</b> 
										</label>
									</div>
								</div>
								
								<div class="row">
									<label class="col-md-2 control-label"><span class="nessSpan">*</span> 사용 여부</label>
									<div class="col-md-6 col-lg-6">
							            <div class="inline-group">
											<label class="radio"> <input type="radio" name="PM_USE" value="Y" ${(action eq 'Insert' || resultData.PM_USE eq 'Y') ? 'checked':'' }> <i></i>사용</label> 
											<label class="radio"> <input type="radio" name="PM_USE" value="N" ${resultData.PM_USE eq 'N' ? 'checked':'' }> <i></i>미사용</label>
										</div>
									</div>
								</div>
								
								<div class="row">
									<label class="col-md-2 control-label">장소 이미지</label>
									<div class="col-md-6 col-lg-6">
							            <label class="input input-file">
											<span class="button">
												<input type="file" name="insertPlaceImg" id="insertPlaceImg" onchange="cf_imgCheckAndPreview('insertPlaceImg')">찾기
											</span>
											<input type="text" readonly="" id="insertPlaceImg_text" placeholder="파일을 선택하여주세요." value="${resultData.FS_ORINM1 }">
										</label>
										<div class="imgWrap" style="width:200px;margin:10px auto;">
											<c:if test="${not empty resultData.FS_KEYNO1 }">
												<img id="insertPlaceImg_img" src='${resultData.THUMBNAIL_PUBLIC_PATH}' alt="미리보기" style="max-width:100%;max-height:300px;">
											</c:if>
											<c:if test="${empty resultData.FS_KEYNO1 }">
												<img id="insertPlaceImg_img" alt="미리보기" style="display:none;max-width:100%;max-height:300px;">
											</c:if>
											
										</div>
									</div>
								</div>
								
								<div class="row">
									<label class="col-md-2 control-label"><span class="nessSpan">*</span> 좌석배치도 사용여부</label>
									<div class="col-md-6 col-lg-6">
							            <div class="inline-group">
											<label class="radio"> <input type="radio" name="PM_SEATPLAN_YN" value="Y" ${resultData.PM_SEATPLAN_YN eq 'Y' ? 'checked':'' }> <i></i>사용</label> 
											<label class="radio"> <input type="radio" name="PM_SEATPLAN_YN" value="N" ${(action eq 'Insert' || resultData.PM_SEATPLAN_YN eq 'N') ? 'checked':'' }> <i></i>미사용</label>
										</div>
									</div>
								</div>
								
							</fieldset>
							<fieldset id="seatPlanTable">
								<div class="row">
									<label class="col-md-2 control-label">좌석 이미지</label>
									<div class="col-md-6 col-lg-6">
							            <label class="input input-file">
											<span class="button">
												<input type="file" name="insertPlaceSeatImg" id="insertPlaceSeatImg" onchange="cf_imgCheckAndPreview('insertPlaceSeatImg')">찾기
											</span>
											<input type="text" readonly="" id="insertPlaceSeatImg_text" placeholder="파일을 선택하여주세요." value="${resultData.FS_ORINM2 }">
										</label>
										<div class="imgWrap" style="width:200px;margin:10px auto;">
											<c:if test="${not empty resultData.FS_KEYNO2 }">
												<img id="insertPlaceSeatImg_img" src='${resultData.SEATBACKGROUND_PUBLIC_PATH}' alt="미리보기" style="max-width:100%;max-height:300px;">
											</c:if>
											<c:if test="${empty resultData.FS_KEYNO2 }">
												<img id="insertPlaceSeatImg_img" alt="미리보기" style="display:none;max-width:100%;max-height:300px;">
											</c:if>
											
										</div>
									</div>
								</div>
								
								<div class="row">
									<label class="col-md-2 control-label">좌석배치도</label>
									<div class="col-md-6 col-lg-6">
							            <button class="btn btn-sm btn-primary" 	type="button" onclick="pf_openAddSeatGroup()">	
											<i class="fa fa-floppy-o"></i> 추가
										</button>
										<!-- <button class="btn btn-sm btn-primary" 	type="button" onclick="pf_insert()">	
											<i class="fa fa-floppy-o"></i> 저장
										</button> -->
									</div>
									<div class="col-md-12 col-lg-12">
			  							<div id="draggableWrap">
											
			  							</div>
									</div>
								</div>
							
							</fieldset>
							
							<fieldset class="padding-10 text-right">
								<c:if test="${action eq 'Insert' }">
								<button class="btn btn-sm btn-primary" 	type="button" onclick="pf_insert()">	
									<i class="fa fa-floppy-o"></i> 저장
								</button>
								</c:if>
								<c:if test="${action eq 'Update' }">
								<button class="btn btn-sm btn-primary" 	type="button" onclick="pf_update()">	
									<i class="fa fa-floppy-o"></i> 수정
								</button>
								<button class="btn btn-sm btn-danger" 	type="button" onclick="pf_delete()">	
									<i class="fa fa-floppy-o"></i> 삭제
								</button>
								</c:if> 
								<button class="btn btn-sm btn-default" id="Board_Delete" type="button" onclick="cf_back('/dyAdmin/program/placeList.do')"> 
									<i class="fa fa-times"></i> 목록
								</button> 
							</fieldset>
						</form:form>
					</div>
				</div>
			</article>
		</div>
	</section>
</div>

<!-- 좌석그룹 추가 팝업 CONTENT -->
<div id="addSeatGroup" class="seatGroupDialog" title="좌석그룹 추가">
	<div class="widget-body no-padding smart-form">
		<fieldset class="form-horizontal" style="height:600px;overflow: auto;">
			<section class="col col-12">
			<div class="bs-example necessT">
		         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
		    </div>	
				<dl class="dl-horizontal">
					<dt>그룹명</dt>
					<dd>
					  <label class="input"> 
              			<i class="icon-append fa fa-question-circle"></i>
						    <input type="text" class="tableTitle" placeholder="메뉴명을 입력하세요" maxlength="50">
						    <b class="tooltip tooltip-top-right"> <i class="fa fa-warning txt-color-teal"></i> 필요시 입력하세요.</b>
						</label>
					</dd>
				</dl>
			</section>
			<section class="col col-6">	
				<dl class="dl-horizontal">
					<dt><span class="nessSpan">*</span> 행</dt>
					<dd>
					<label class="input"> 
						<i class="icon-append fa fa-question-circle"></i>
						<input type="number" class="form-control tableRow" oninput="cf_maxLengthCheck(this)" max="20" maxlength="2" min="1">
						 <b class="tooltip tooltip-top-right"> <i class="fa fa-warning txt-color-teal"></i> 최대 20까지만 입력하세요.</b>
						</label>
					</dd>
				</dl>
			</section>
			<section class="col col-6">	
				<dl class="dl-horizontal">
					<dt><span class="nessSpan">*</span> 열</dt>
					<dd>
					  <label class="input"> 
              			<i class="icon-append fa fa-question-circle"></i>
						    <input type="number" class="form-control tableCol" oninput="cf_maxLengthCheck(this)" max="20" maxlength="2" min="1">
						    <b class="tooltip tooltip-top-right"> <i class="fa fa-warning txt-color-teal"></i> 최대 20까지만 입력하세요.</b>
						</label>
					</dd>
				</dl>
			</section>
			<section class="col col-12" style="text-align: right;">	
				<button class="btn btn-sm btn-primary" 	type="button" onclick="pf_settingSeatTable('addSeatGroup')">	
					<i class="fa fa-floppy-o"></i> 생성
				</button>
				
			</section>
			<section class="col col-12">
				<hr>	
			</section>
			<section class="col col-12" style="text-align:right;">
				<button class="btn btn-sm btn-primary addRowAndColBtn" 	type="button" onclick="pf_addRow('addSeatGroup')">	
					<i class="fa fa-floppy-o"></i> 행추가
				</button>
				<button class="btn btn-sm btn-primary addRowAndColBtn" 	type="button" onclick="pf_addCol('addSeatGroup')">	
					<i class="fa fa-floppy-o"></i> 열추가
				</button>
				<table class="settingSeatTable">
				  	
			  	</table>
			</section>
		</fieldset>
	</div>
</div>

<!-- 좌석그룹 수정 팝업 CONTENT -->
<div id="updateSeatGroup" class="seatGroupDialog" title="좌석그룹 수정">
	<div class="widget-body no-padding smart-form">
		<input type="hidden" name="groupCount" value="">
		<fieldset class="form-horizontal" style="height:600px;overflow: auto;">
			<section class="col col-12">
			<div class="bs-example necessT">
		         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
		    </div>
				
				<dl class="dl-horizontal">
					<dt><span class="nessSpan">*</span> 그룹명</dt>
					<dd>
					  <label class="input"> 
              			<i class="icon-append fa fa-question-circle"></i>
						    <input type="text" class="tableTitle" placeholder="메뉴명을 입력하세요" maxlength="50">
						    <b class="tooltip tooltip-top-right"> <i class="fa fa-warning txt-color-teal"></i> 필요시 입력하세요.</b>
						</label>
					</dd>
				</dl>
			</section>
			<section class="col col-6">	
				<dl class="dl-horizontal">
					<dt><span class="nessSpan">*</span> 행</dt>
					<dd>
					<label class="input"> 
						<i class="icon-append fa fa-question-circle"></i>
						<input type="number" class="form-control tableRow" oninput="cf_maxLengthCheck(this)" max="20" maxlength="2" min="1">
						 <b class="tooltip tooltip-top-right"> <i class="fa fa-warning txt-color-teal"></i> 최대 20까지만 입력하세요.</b>
						</label>
					</dd>
				</dl>
			</section>
			<section class="col col-6">	
				<dl class="dl-horizontal">
					<dt><span class="nessSpan">*</span> 열</dt>
					<dd>
					  <label class="input"> 
              			<i class="icon-append fa fa-question-circle"></i>
						    <input type="number" class="form-control tableCol" oninput="cf_maxLengthCheck(this)" max="20" maxlength="2" min="1">
						    <b class="tooltip tooltip-top-right"> <i class="fa fa-warning txt-color-teal"></i> 최대 20까지만 입력하세요.</b>
						</label>
					</dd>
				</dl>
			</section>
			<section class="col col-12" style="text-align: right;">	
				<button class="btn btn-sm btn-primary" 	type="button" onclick="pf_settingSeatTable('addSeatGroup')">	
					<i class="fa fa-floppy-o"></i> 생성
				</button>
			</section>
			<section class="col col-12">
				<hr>	
			</section>
			<section class="col col-12" style="text-align: right;">
				<button class="btn btn-sm btn-primary addRowAndColBtn" 	type="button" onclick="pf_addRow('updateSeatGroup')">	
					<i class="fa fa-floppy-o"></i> 행추가
				</button>
				<button class="btn btn-sm btn-primary addRowAndColBtn" 	type="button" onclick="pf_addCol('updateSeatGroup')">	
					<i class="fa fa-floppy-o"></i> 열추가
				</button>	
				<table class="settingSeatTable">
				  	
			  	</table>
			</section>
		</fieldset>
	</div>
</div>

<script>

var draggableOption;
var seatGroups = new Array();
var seatGroupCount = 0;

var action = '${action}';
$( function() {
	
	///////////////////////좌석배치도 사용여부////////////////////////////////
	var widthzero = $("#PM_SEATPLAN_WIDTH").val("0");
	if(widthzero){
		$(".col-lg-12 #draggableWrap").css("display", "hidden");
	}
	
	/* 좌석그룹 추가 팝업 */
	cf_setttingDialog('#addSeatGroup','좌석그룹 추가','추가','pf_addSeatGroup(\'I\')');
	
	/* 좌석그룹 수정 팝업 */
	cf_setttingDialog2('#updateSeatGroup','좌석그룹 수정','수정','pf_addSeatGroup(\'U\')','삭제','pf_deleteSeatGroup()');
	  
	$( "#draggableWrap" ).resizable({
		minWidth: 500,
		minHeight : 300
	});
	  
	draggableOption = {
    	containment: "parent",
    	stop: function( event, ui ) {
    		
    	},
    	create: function( event, ui ) {
    		//alert('1')
    		
    	}
    }
	  
    $( ".draggable" ).draggable(draggableOption);
    
	
	if($('input[name=PM_SEATPLAN_YN]:checked').val() == 'N'){
		$('#seatPlanTable').hide();
	}
    
	$('input[name=PM_SEATPLAN_YN]').on('change',function(){
		if($(this).val() == 'Y'){
			$('#seatPlanTable').show();
		}else{
			$('#seatPlanTable').hide();
		}
	})
	
	
	if(action == 'Update'){
		var group = '${seatGroups}';
		if(group){
			pf_settingSeatGroupsData(group);
			
		}
		var seatPlanWidth = '${resultData.PM_SEATPLAN_WIDTH}';
		var seatPlanHeight = '${resultData.PM_SEATPLAN_HEIGHT}';
		if(seatPlanWidth != '0'){
			$('#draggableWrap').css({
				'width':seatPlanWidth,
				'height':seatPlanHeight
			})
		}else if(seatPlanWidth == '0'){
			$('#draggableWrap').css({
				'width':'800px',
				'height':'500px'
			})
		}
		
	}
	
});


function pf_settingSeatGroupsData(group){
	seatGroups = JSON.parse(group);
	seatGroupCount = seatGroups.length;
	$.each(seatGroups,function(count){
		seatGroup = seatGroups[count]
		var temp = '';
		temp += '<div class="draggable ui-widget-content" id="draggable'+count+'" data-count="'+count+'" style="top:'+seatGroup.top+'px;left:'+seatGroup.left+'px">';
		temp    += '<i class="fa fa-cog" onclick="pf_openUpdateSeatGroup(\''+count+'\')"></i>';
		temp    += '<span class="seatGroupTitle">'+ seatGroup.title +'</span><br>';
		temp    += '<table class="seatTable">';
		var table = seatGroup.table;
		for(var i=0;i<table.length;i++){
			temp    += '<tr>';
			var colList = table[i];
			for(var j=0;j<colList.length;j++){
				temp    += '<td><p>'+ colList[j] +'</p></td>';		
				
			}
			temp    += '</tr>';
		}
		
		temp    += '</table>';
		temp    += '</div>'
		
		$('#draggableWrap').append(temp);
		$('.draggable').draggable(draggableOption);
	})
}


function pf_openAddSeatGroup(){
	$('#addSeatGroup').dialog('open');
	
	$('#addSeatGroup input').val('');
	var count = seatGroupCount + 1;
	$('#addSeatGroup .tableTitle').val('그룹' + count);
	$('#addSeatGroup table').html('')
	$('#addSeatGroup .addRowAndColBtn').hide();
}




function pf_insert(){
	
	if(!formCheck()){
		return false;
	}
	
	var width = $('#PM_SEATPLAN_WIDTH').val();			
	var height = $('#PM_SEATPLAN_HEIGHT').val();
	
	if(width == ''){
		$('#PM_SEATPLAN_WIDTH').val("0");
	}
	if(height == ''){
		$('#PM_SEATPLAN_HEIGHT').val("0");
	}
	
	if(confirm('저장하시겠습니까?')){
		cf_replaceTrim($("#Form"));
		$('#Form').attr('action','/dyAdmin/program/placeList/insert.do?${_csrf.parameterName}=${_csrf.token}')
		$('#Form').submit();	
	}
	
	
}

function pf_update(){
	if(!formCheck()){
		return false;
	}
	
	var width = $('#PM_SEATPLAN_WIDTH').val();			
	var height = $('#PM_SEATPLAN_HEIGHT').val();
	
	if(width == ''){
		$('#PM_SEATPLAN_WIDTH').val("0");
	}
	if(height == ''){
		$('#PM_SEATPLAN_HEIGHT').val("0");
	}
	
	if(confirm('수정하시겠습니까?')){
		cf_replaceTrim($("#Form"));
		$('#Form').attr('action','/dyAdmin/program/placeList/update.do?${_csrf.parameterName}=${_csrf.token}')
		$('#Form').submit();
	}
}


function formCheck(){
	if(!cf_checkVal('#PM_NAME','장소명을 입력하여주세요.')){
		return false;
	}
	if($('input[name=PM_SEATPLAN_YN]:checked').val() == 'Y'){
		var width = parseInt($('#draggableWrap').width());
		var height = parseInt($('#draggableWrap').height());
		
		$('#PM_SEATPLAN_WIDTH').val(width);			
		$('#PM_SEATPLAN_HEIGHT').val(height);	

		var wrap_top = $('#draggableWrap').offset().top;
    	var wrap_left = $('#draggableWrap').offset().left;
		$('.draggable').each(function(){
    		var top = $(this).offset().top - wrap_top;
    		var left = $(this).offset().left - wrap_left;
    		var count = $(this).data('count')

    		seatGroups[count].top = top;
    		seatGroups[count].left = left;
    	})
		
		$('#seatGroupData').val(JSON.stringify(seatGroups));
		
	}

	return true;

}

//좌석그룹 추가 테이블 셋팅
function pf_settingSeatTable(id){
	
	var title = $('.tableTitle','#'+id).val();
	var row = $('.tableRow','#'+id).val() || 0;
	var col = $('.tableCol','#'+id).val() || 0;
	
	if(!row){
		alert('행을 입력하여주세요.');
		$('.tableRow','#'+id).focus();
		return false;
	}else if(row > 20){
		$('.tableRow','#'+id).val(20);
		row = 20;
	}else if(row < 1){
		$('.tableRow','#'+id).val(1);
		row = 1;
	}
	
	if(!col){
		alert('열을 입력하여주세요.');
		$('.tableCol','#'+id).focus();
		return false;
	}else if(col > 20){
		$('.tableCol','#'+id).val(20);
		col = 20;
	}else if(col < 1){
		$('.tableCol','#'+id).val(1);
		col = 1;
	}
	
	
	var temp = '';
	
	temp += '<tr>';
	for(var j=0;j<=col;j++){
		if(j == 0){
			temp += '<td></td>';		
		}else{
			temp += '<td><button class="btn btn-sm btn-danger deleteCol" 	type="button" onclick="pf_deleteCol(this)">열삭제</button></td>'
		}
	}
	temp += '</tr>';
	
	for(var i=0;i<row;i++){
		temp += '<tr>';
		temp += '<td><button class="btn btn-sm btn-danger deleteRow" 	type="button" onclick="pf_deleteRow(this)">행삭제</button></td>'
		for(var j=0;j<col;j++){
			temp += '<td><input type="text" value="'+ pf_getAutoSeatNumber(i,j) +'" class="form-control"></td>'
		}
		temp += '</tr>';
	}
	
	$('.settingSeatTable','#'+id).html(temp)
	$('#addSeatGroup .addRowAndColBtn').show();
	
}

function pf_deleteRow(obj){
	$(obj).parents('tr').remove();
}

function pf_deleteCol(obj){
	
	$td = $(obj).parents('td');
	
	var index = $(obj).parents('tr').find('td').index($td);
	
	$(obj).parents('table').find('tr').each(function(){
		$(this).find('td').eq(index).remove();
	});
	
	
}

function pf_getAutoSeatNumber(i,j){
	var alphabet = String.fromCharCode(65+i);
	var number = (j+1) +"";
	if(number.length == 1){
		number = '0'+ number;
	}
	return alphabet + number
}

function pf_deleteSeatGroup(){
	
	if(confirm('정말 삭제하시겠습니까?')){
		var count = $('#updateSeatGroup input[name=groupCount]').val();
		seatGroups[count] = null;
		$('#draggable'+count).remove();
		$('#updateSeatGroup').dialog('close');
	}	
}


function pf_addSeatGroup(action){
	var id,count;
	if(action == 'I'){
		id = '#addSeatGroup';
		count = ++seatGroupCount;
	}else if(action == 'U'){
		id = '#updateSeatGroup'
		count = $('#updateSeatGroup input[name=groupCount]').val();
	}else{
		alert('오류!')
		return false;
	}
	
	
	var row = $('.settingSeatTable tr',id).length;
	var col = $('.settingSeatTable tr',id).eq(0).find('td').length;
	
	
	
	
	if(row < 2 || col < 2){
		alert('좌석 테이블을 생성하여주세요.');
		return false;
	}
	
	var checkSeatNumber = true;
	$('table input',id).each(function(){
		if(checkSeatNumber && !$(this).val()){
			alert('좌석 번호를 입력하여주세요.');
			$(this).focus();
			checkSeatNumber = false;
		}
	})
	if(!checkSeatNumber){
		return false;
	}
	
	var seatGroup = new Object();
	seatGroup.title = $('.tableTitle',id).val();
	seatGroup.row = row-1;
	seatGroup.col = col-1;
	var table = [];
	
	
	var temp = '';
	if(action == 'I'){
		temp += '<div class="draggable ui-widget-content" id="draggable'+count+'" data-count="'+count+'">';
	}
	temp    += '<i class="fa fa-cog" onclick="pf_openUpdateSeatGroup(\''+count+'\')"></i>';
	temp    += '<span class="seatGroupTitle">'+ seatGroup.title +'</span><br>';
	temp    += '<table class="seatTable">';
	
	for(var i=1;i<row;i++){
		temp    += '<tr>';
		var data = [];
		for(var j=0;j<col-1;j++){
			var seatNumber = $('.settingSeatTable tr',id).eq(i).find('input').eq(j).val();
			data[j] = seatNumber;
			temp    += '<td>'+ seatNumber +'</td>';		
			
		}
		table[i-1] = data;
		temp    += '</tr>';
	}
	
	seatGroup.table = table;
	seatGroups[count] = seatGroup;
	
	temp    += '</table>';
	if(action == 'I'){
		temp    += '</div>'
	}
	
	
	if(action == 'I'){
		$('#draggableWrap').append(temp);
		$('.draggable').draggable(draggableOption);
	}else if(action == 'U'){
		$('#draggable'+count).html(temp);
	}
	
	$(id).dialog('close');
}


function pf_openUpdateSeatGroup(count){
	$('#updateSeatGroup').dialog('open');
	
	
	
	var seatGroup = seatGroups[count];
	var row = seatGroup.row;
	var col = seatGroup.col;
	
	$('#updateSeatGroup input[name=groupCount]').val(count);
	$('#updateSeatGroup .tableTitle').val(seatGroup.title);
	$('#updateSeatGroup .tableRow').val(row);
	$('#updateSeatGroup .tableCol').val(col);
	
	
	var temp = '';
	
	temp += '<tr>';
	for(var j=0;j<=col;j++){
		if(j == 0){
			temp += '<td></td>';		
		}else{
			temp += '<td><button class="btn btn-sm btn-danger deleteCol" 	type="button" onclick="pf_deleteCol(this)">열삭제</button></td>'
		}
	}
	temp += '</tr>';
	
	for(var i=0;i<row;i++){
		var rowData = seatGroup.table[i];	
		temp += '<tr>';
		temp += '<td><button class="btn btn-sm btn-danger deleteRow" 	type="button" onclick="pf_deleteRow(this)">행삭제</button></td>'
		for(var j=0;j<col;j++){
			temp += '<td><input type="text" value="'+ rowData[j] +'" class="form-control"></td>'
		}
		temp += '</tr>';
	}
	
	$('#updateSeatGroup .settingSeatTable').html(temp)
	
	
	
	
}

function pf_addRow(id){
	var col = $('#'+id+' table tr').eq(0).find('td').length;
	
	var temp  = '<tr>'
	for(var i=0;i<col;i++){
		if(i == 0){
			temp += '<td><button class="btn btn-sm btn-danger deleteRow" 	type="button" onclick="pf_deleteRow(this)">행삭제</button></td>'
		}else{
			temp += '<td><input type="text" value="" class="form-control"></td>'
		}
	}
	temp += '</tr>';
	$('#'+id+' table').append(temp);
}

function pf_addCol(id){
	
	$('#'+id+' table tr').each(function(i){
		var temp = '';
		if(i == 0){
			temp += '<td><button class="btn btn-sm btn-danger deleteCol" 	type="button" onclick="pf_deleteCol(this)">열삭제</button></td>'
		}else{
			temp += '<td><input type="text" value="" class="form-control"></td>'
		}
		$(this).append(temp)
	})
	
}

function pf_delete(){
	if(confirm('정말 삭제하시겠습니까?')){
		location.href='/dyAdmin/program/placeList/delete.do?PM_KEYNO=${resultData.PM_KEYNO}';
	}
}

</script>


