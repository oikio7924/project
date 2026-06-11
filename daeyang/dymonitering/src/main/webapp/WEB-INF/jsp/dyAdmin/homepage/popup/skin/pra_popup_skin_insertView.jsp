<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<%@ include file="/WEB-INF/jsp/dyAdmin/include/CodeMirror_Include.jsp"%>
<script type="text/javascript" src="/resources/common/js/common/diff_match_patch.js"></script>

<style>
.columnTitle {
	text-align: center;
	word-break: keep-all;
	border-top: 1px solid #ddd;
	border-bottom: 1px solid #ccc;
	padding: 5px 0
}

.columnTitle section {
	margin-bottom: 0
}

.option_dp, .selectCodeWrap, .column_size_dp {
	display: none;
}

.column_ul .column_li label {
	width: 20%;
}

.column_ul .column_li input {
	padding-left: 10px;
	width: 50%;
}

.column_ul .column_li div {
	margin-left: 20px;
}
</style>

<script type="text/javascript">

var editor = null;
var type = '${type}';
var default_form = 

$(function() {
	editor = codeMirror("htmlmixed", "PIS_FORM");
	
	if(type == 'insert'){	
		pf_popType('W');
		pf_getSkinFormData("layout_basic","popup");
	}else{
		pf_getSkinFormData("${PIS_DATA.PIS_KEYNO}","popup");
// 		editor.setValue(${PIS_FORM});
		pf_data();
	}
		
});


function pf_popType(type_P){
	if(type_P == "B"){
		$('.W').css('display','none');		
		$('.B').css('display','block');
		if(type == 'insert'){
			$("#PIS_FORM_SELECT option:eq(0)").prop("selected", true);
			pf_getSkinFormData("banner_basic","popup");
		}
	}else{
		$('.B').css('display','none');		
		$('.W').css('display','block');
		if(type == 'insert'){
			$("#PIS_FORM_SELECT option:eq(0)").prop("selected", true);
			pf_getSkinFormData("layout_basic","popup");
		}
	}
}


function pf_form_change(value){
	
	var popType = $('input[name="PIS_DIVISION"]:checked').val();
	
	if(!value){
		if(popType == 'W'){
			pf_getSkinFormData("layout_basic","popup");
		}else{
			pf_getSkinFormData("banner_basic","popup");
		}
	}else {
		pf_getSkinFormData(value,"popup");
	}
}

function pf_popupSkinInsert(){

	if(!pf_checkForm()){
		return false;
	}

	if(confirm("팝업 스킨을 생성하시겠습니까?")){
		cf_replaceTrim($("#Form"));
		$("#Form").attr("action", "/dyAdmin/homepage/popupSkin/insert.do");
		$("#Form").submit();
	}
	
}

function pf_checkForm(){
	
	if(!$("#PIS_SUBJECT").val()){
		cf_smallBox('error', '스킨제목을 입력해주세요.', 3000,'#d24158');
		$("#PIS_SUBJECT").focus();
		return false;
	}
	
	if(!$("#PISH_COMMENT").val()){
		  cf_smallBox('error', '코멘트를 입력해주세요.', 3000,'#d24158');
		  $("#PISH_COMMENT").focus();
		  return false;
		 }
	
	return true;
}

function pf_popupSkinUpdate(){

	if(!pf_checkForm()){
		return false;
	}

	if(confirm("팝업 스킨을  수정하시겠습니까?")){
		cf_replaceTrim($("#Form"));
		$("#Form").attr("action", "/dyAdmin/homepage/popupSkin/update.do");
		$("#Form").submit();
	}
	
}

//삭제하기(유효성 검사)
function pf_skinDelete() {
	var keyno = '${PIS_DATA.PIS_KEYNO }';

 	$.ajax({
		type: "POST",
		url: "/dyAdmin/homepage/popupSkin/useSkinAjax.do",
		data : {
			 "PIS_KEYNO" : keyno
		},
		success : function(data){
			if(data > 0){
				cf_smallBox('error', '사용중인 스킨은 삭제하실 수 없습니다.', 3000,'#d24158');
		  		return false;
		  	} else {
		  		cf_smallBoxConfirm('Ding Dong!', '삭제 하시겠습니까?','pf_popupSkinDelete()');		  		
		  	}			
		},
		error : function(){	
			cf_smallBox('error', '스킨 사용여부 판단 에러발생', 3000,'#d24158');
		}
	});   	
}

function pf_popupSkinDelete(){
		cf_replaceTrim($("#Form"));
		$("#Form").attr("action", "/dyAdmin/homepage/popupSkin/delete.do");
		$("#Form").submit();
}


function pf_back(){
	history.go(-1);
}

function pf_Copy(content){
	if(cf_copyToClipboard(content)){
		cf_smallBox('success', "값이 복사되었습니다.", 2000);
	}else{
		cf_smallBox('error', "복사하기 기능을 지원하지 않는 브라우저 입니다.", 3000,'#d24158');
	}
}

//히스토리 설정
function pf_data(){	
	var keyno = '${PIS_DATA.PIS_KEYNO }';

	$.ajax({
		type: "POST",
		url: "/dyAdmin/homepage/popupSkin/skindataAjax.do",
		data : {
				"PIS_KEYNO" : keyno
				},
		success : function(result){
			var data = result.SkinData;
			var historyList = result.SkinDataHistory;
			
			//초기화
			$("#intro-history").empty();
			$("#compareData").empty();
			
			var keyno = '';
			var REGNM = '작성자 없음';
			var REGDT = '작성일 없음';
			var MODNM = '최근 게시물 수정자 없음';
			var MODDT = '게시물 수정이력 없음';
			var PIS_DATA = '';
			var PIS_SUBJECT = "";
			
			if(data){
				keyno	 		= data.PIS_KEYNO;
				REGNM 			= data.PIS_REGNM;   
				REGDT 			= data.PIS_REGDT;
				if(typeof data.PIS_MODNM != 'undefined'){
					MODNM 			= data.PIS_MODNM;
				}
				if(typeof data.PIS_MODDT != 'undefined'){
					MODDT 			= data.PIS_MODDT;
				}
				PIS_FORM 		= data.PIS_FORM;	
				PIS_SUBJECT 	= data.PIS_SUBJECT;					
			}

			$("#REGNM").text(REGNM)
			$("#REGDT").text(REGDT)
			$("#MODNM").text(MODNM)
			$("#MODDT").text(MODDT)
			
			
			var temp = '';
			if(historyList.length > 0){
				$.each(historyList, function(i){
					var history = historyList[i]
					temp += '<tr>';
			    	temp += '	<td class="text-align-center">'+history.PISH_VERSION+'</td>';
			    	temp += '	<td class="text-align-center">'+history.PISH_MODNM+'</td>';
			    	temp += '	<td class="text-align-center">'+history.PISH_COMMENT+'</td>';
			    	temp += '	<td class="text-align-center">'+history.PISH_STDT_B+' ~ '+history.PISH_ENDT_B+'</td>';
			    	temp += '	<td class="text-align-center">';
			    	temp += '	<a class="btn btn-default btn-xs" href="#" onclick="pf_introUse(\''+history.PISH_KEYNO+'\');"><i class="fa fa-repeat"></i> 복원</a>';
			    	if(i != 0){
			    		temp += '	<a class="btn btn-default btn-xs" href="javascript:;" onclick="pf_compareData(\''+history.PISH_KEYNO+'\',\''+history.PISH_PIS_KEYNO+'\');"><i class="fa fa-repeat"></i> 최신 데이터와 비교</a>';
			    	}
		    		temp += '	<a class="btn btn-default btn-xs" href="javascript:;" onclick="pf_compareData(\''+history.PISH_KEYNO+'\');"><i class="fa fa-repeat"></i> 변경사항</a>';
			    	temp += '	</td>';
		    		temp += '</tr>';
				})
			$("#intro-history").html(temp)
			}
		},
		error : function(){	
			cf_smallBox('error', '에러발생', 3000,'#d24158');
		}
	});
}

//복원
function pf_introUse(PISH_KEYNO){
	cf_loading();
	
	setTimeout(function(){
		$.ajax({
			type: "POST",
			url: "/dyAdmin/homepage/popupSkin/returnPageAjax.do",
			data : {"PISH_KEYNO":PISH_KEYNO},
			success : function(data){
				editor.setValue(data)
			},
			error : function(){	
			}
		 }).done(function(){
			cf_loading_out();
		});
	},100)
}

//비교하기
function pf_compareData(PISH_KEY, PIS_KEY){
	cf_loading();
	
	setTimeout(function(){
	$.ajax({
		type: "POST",
		url: "/dyAdmin/homepage/popupSkin/compareAjax.do",
		data: "PISH_KEYNO=" + PISH_KEY + "&PIS_KEYNO=" + PIS_KEY,
		async: false,
		success : function(obj){
			var dmp = new diff_match_patch();
			var diff;
			
			if(PIS_KEY == undefined){
				diff = dmp.diff_main(obj.length == 1 ? "": obj[1].PIS_FORM, obj[0].PIS_FORM);
			}else{
				diff = dmp.diff_main(obj[0].PIS_FORM, obj[1].PIS_FORM);
			}
		    dmp.diff_cleanupSemantic(diff)
		    
		    var ds = dmp.diff_prettyHtml(diff);
	    	$('#compareData').html(ds)
		},
		error: function(){
			cf_smallBox('error', '데이터를 가져올 수 없습니다. 관리자한테 문의하세요.', 3000,'#d24158');
			return false;
		}
		}).done(function(){
			cf_loading_out();
			});
	},100)
}
	
</script>

<div id="content">

	<section id="widget-grid">
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" id="" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-table"></i>
						</span>
						<c:if test="${type eq 'insert' }">
							<h2>팝업 스킨 등록</h2>
						</c:if>
						<c:if test="${type eq 'update' }">
							<h2>팝업 스킨 수정</h2>
						</c:if>
					</header>

					<div class="widget-body">

						<form:form id="Form" class="form-horizontal" name="Form"  method="post">
							<input type="hidden" name="PIS_REGNM" value="${userInfo.UI_ID }" />
							<c:if test="${type eq 'update' }">
								<input type="hidden" name="PIS_KEYNO" value="${PIS_DATA.PIS_KEYNO }" />
								<input type="hidden" name="PIS_DEL_YN" value="N" />
							</c:if>
							<legend>
								<div class="widget-body-toolbar bg-color-white">
									<div class="alert alert-info no-margin fade in">
										<button type="button" class="close" data-dismiss="alert">×</button>
										팝업 스킨을 등록 / 수정하실 수 있습니다.<br> <span style="color: red;">*
											현재 적용되고 있는 스킨은 삭제하실 수 없습니다.</span>
									</div>
								</div>
							</legend>

							<div id="myTabContent1"
								class="tab-content padding-10 form-horizontal bv-form">
								<div>
									<table id="" class="table table-bordered table-striped">
										<colgroup>
											<col style="width: 20%;">
											<col style="width: 30%;">
											<col style="width: 20%;">
											<col style="width: 30%;">
										</colgroup>
										<tbody>
											<c:if test="${type eq 'update' }">
												<tr>
													<td>작성자</td>
													<td id="REGNM"></td>
													<td>작성일</td>
													<td id="REGDT"></td>
												</tr>
												<tr>
													<td>최근 게시물 수정자</td>
													<td id="MODNM"></td>
													<td>최근 게시물 수정일자</td>
													<td id="MODDT"></td>
												</tr>
											</c:if>
											<c:if test="${not empty PIS_HP}">
											<tr>
												<td>사용중인 홈페이지</td>
												<td colspan="3">${PIS_HP.PIS_HP}</td>
											</tr>
											</c:if>
											<tr>
												<td><span class="nessSpan">*</span>스킨 이름</td>
												<td colspan="3"><input type="text" 	class="form-control checkTrim" id="PIS_SUBJECT" name="PIS_SUBJECT" value="${PIS_DATA.PIS_SUBJECT }" maxlength="100">
											</tr>
											<tr>
												<td><span class="nessSpan">*</span>코멘트</td>
												<td colspan="3"><input type="text" class="form-control" name="PISH_COMMENT" id="PISH_COMMENT" data-bv-field="fullName" maxlength="500" placeholder="no message"></td>
											</tr>										
											<tr>
												<td>레이아웃 유형</td>
												<td><c:if test="${empty PIS_DATA.PIS_KEYNO}">
														<div class="smart-form">
															<div class="inline-group">
																<label class="radio"> <input type="radio" name="PIS_DIVISION" value="W" onclick="pf_popType('W')" ${(empty PIS_DATA || PIS_DATA.PIS_DIVISION eq 'W') ? 'checked':'' }>
																	<i style="margin-top: 7px;"></i>레이아웃
																</label> <label class="radio"> <input type="radio" name="PIS_DIVISION" value="B" onclick="pf_popType('B')" ${PIS_DATA.PIS_DIVISION eq 'B' ? 'checked':'' }>
																	<i style="margin-top: 7px;"></i>배너
																</label>
															</div>
														</div>
													</c:if> <c:if test="${not empty PIS_DATA.PIS_KEYNO}">
														<input class="form-control" name="PIS_DIVISION" type="text" value="${PIS_DATA.PIS_DIVISION eq 'W' ? '레이아웃':'배너'  }" readonly="readonly">
													</c:if></td>
											</tr>
											<tr>
												<td>내용</td>
												<td colspan="3">
													<div class="form-group has-feedback">
														<label class="col-md-5 control-label"></label>
														<div class="col-md-12">
															<select class="form-control input-sm" id="PIS_FORM_SELECT" onchange="pf_form_change(this.value);">
																<option value="banner_basic">기본폼</option>
																<option value="layout_basic">기본폼2</option>
																<c:forEach items="${formDataList }" var="model3">
																	<option value="${model3.PIS_KEYNO }" class="${model3.PIS_DIVISION}" ${PIS_DATA.PIS_KEYNO eq model3.PIS_KEYNO ? 'selected' : '' }>${model3.PIS_SUBJECT }</option>
																</c:forEach>
															</select>
														</div>

													</div>
												</td>
											</tr>
											<tr>
												<td colspan="4">
													<textarea name="PIS_FORM" id="PIS_FORM" rows="5" style="width: 100%; height: 400px; min-width: 260px;"></textarea>
												</td>
											</tr>
											<tr>
												<td colspan="4">
													<fieldset class="padding-10 text-right">
														<c:if test="${type eq 'insert' }">
															<button class="btn btn-sm btn-primary" type="button" onclick="pf_popupSkinInsert()">저장</button>
														</c:if>
														<c:if test="${type eq 'update' }">
															<button class="btn btn-sm btn-primary" type="button" onclick="pf_popupSkinUpdate()">수정</button>
															<button class="btn btn-sm btn-danger" type="button" onclick="pf_skinDelete()">삭제</button>
														</c:if>
														<button class="btn btn-sm btn-default" id="Board_Delete" type="button" onclick="pf_back()">취소</button>
													</fieldset>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</form:form>
						<c:if test="${type eq 'update' }">

							<div class="row">
								<article class="col-sm-12 col-md-12 col-lg-12">
									<div class="jarviswidget jarviswidget-color-green" id="" data-widget-editbutton="false" data-widget-custombutton="false">
										<header>
											<span class="widget-icon"> <i class="fa fa-edit"></i></span>
											<h2>히스토리</h2>
										</header>
										<div>
											<div class="jarviswidget-editbox"></div>
											<div class="widget-body">
												<div class="table-responsive">
													<table id="datatable_fixed_column"
														class="table table-bordered table-hover" width="100%">
														<colgroup>
															<col width="5%">
															<col width="10%">
															<col width="">
															<col width="20%">
															<col width="25%">
														</colgroup>
														<thead>
															<tr>
																<th class="text-align-center">버전</th>
																<th class="text-align-center">작성자</th>
																<th class="text-align-center">코멘트</th>
																<th class="text-align-center">게시기간</th>
																<th class="text-align-center">기능</th>
															</tr>
														</thead>
														<tbody id="intro-history">
														</tbody>
													</table>
												</div>
											</div>
										</div>
									</div>
								</article>
							</div>

							<div class="row">
								<article class="col-sm-12 col-md-12 col-lg-12">
									<div class="jarviswidget jarviswidget-color-green"
										id="compareData_wrap" data-widget-editbutton="false" data-widget-custombutton="false">
										<header>
											<span class="widget-icon"> <i class="fa fa-edit"></i></span>
											<h2>소스 비교</h2>
										</header>
										<div>
											<div class="jarviswidget-editbox"></div>
											<div class="widget-body">
												<div id="compareData"></div>
											</div>
										</div>
									</div>
								</article>
							</div>

						</c:if>

					</div>
				</div>
			</article>
		</div>
	</section>
</div>