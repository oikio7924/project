<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<style>
dt{line-height: 34px;}
</style>
<!-- MAIN CONTENT -->
<div id="content">
	<!-- START ROW -->
	<section id="widget-grid" >
		<div class="row">
		<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-green"
					id="subcode_manager_1" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-table"></i></span>
						<h2>메인코드 상세보기</h2>
					</header>
					<form action="" id="Form" name="Form">
						<input type="hidden" name="MC_KEYNO" id="MC_KEYNO" value=""/>
						<input type="hidden" name="MC_CODENM" id="MC_CODENM" value=""/>
						<input type="hidden" name="MC_IN_C" id="MC_IN_C" value=""/>
						<input type="hidden" name="SC_KEYNO" id="SC_KEYNO" value=""/>
					</form>
					<div>
						<div class="jarviswidget-editbox"></div>
							<div class="widget-body-toolbar bg-color-white">
						<div class="alert alert-info no-margin fade in">
									<button type="button" class="close" data-dismiss="alert">×</button>
									선택한 메인 코드의 상세정보를 확인합니다.
								</div> 
							</div>	
						<div class="widget-body">
							<hr />
							<div class="table-responsive">
								<table class="table table-bordered table-hover text-align-center">
									<thead>
										<tr> 
											<th class="text-align-center">코드명칭</th>
											<th class="text-align-center">내부 코드값</th>
											<th class="text-align-center">사용여부</th>
											<th class="text-align-center">등록일자</th>
											<th class="text-align-center">최근수정일자</th>
										</tr>
									</thead>
									<tbody>
											<tr>
												<td>${result.MC_CODENM }</td>
												<td>
													<code class="padding-5">
														${result.MC_IN_C}
													</code>
												</td>
												<td>
												<c:if test="${result.MC_USE_YN=='Y'}">
													사용중
												</c:if>
												<c:if test="${result.MC_USE_YN== 'N'}">
													미사용중
												</c:if> 
												</td>
												<td>${fn:substring(result.MC_REGDT,0,19)}</td>
												<td>
													<c:if test="${empty result.MC_MODDT }">
														변경기록없음
													</c:if>
													<c:if test="${not empty result.MC_MODDT }">
														${fn:substring(result.MC_MODDT,0,19)}
													</c:if>
												</td>
											</tr>
									</tbody>
								</table>
							</div>
							<div class="smart-form bg-color-white" align="right">
								<div class="btn-group">
									<button class="btn btn-sm btn-success" type="button" id="MC_EDIT" name="MC_EDIT" style="margin-right:10px;">
										<i class="fa fa-pencil"></i> 메인코드 수정하기
									</button>
									<button class="btn btn-sm btn-danger" type="button" id="MC_DEL" name="MC_DEL" onclick="pf_mcDelete('${result.MC_KEYNO}', '${result.MC_IN_C }')">
										<i class="fa fa-trash-o"></i> 메인코드 삭제하기
									</button>
								</div>
							</div>
						</div>
						<!-- end widget content -->
					</div>
					<!-- end widget div -->
				</div>
			</article>
		
		
			<!-- 좌측 시작 -->
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-green"
					id="subcode_manager_2" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-table"></i></span>
						<h2>서브코드 보기</h2>
					</header>
					<div>
						<div class="jarviswidget-editbox"></div>
							<div class="widget-body-toolbar bg-color-white">
						<div class="alert alert-info no-margin fade in">
									<button type="button" class="close" data-dismiss="alert">×</button>
									서브 코드 리스트를 등록, 수정, 삭제합니다.
								</div> 
							</div>	
						<div class="widget-body">
							<div class="table-responsive">
								<table class="table table-bordered table-hover text-align-center">
									<thead>
										<tr>
											<th class="text-align-center">상위코드 내부</th>
											<th class="text-align-center">코드</th>
											<th class="text-align-center">서브 코드 명</th>
											<th class="text-align-center">코드정보-1</th>
											<th class="text-align-center">코드정보-2</th>
											<th class="text-align-center">정렬순서</th>
											<th class="text-align-center">코드 사용 여부</th>
											<th class="text-align-center">코드관리</th> 
										</tr>
									</thead>
									<tbody>
									<c:forEach items="${list}" var="list">
										<tr>
											<td>
												<code class="padding-5">
													${list.SC_MC_IN_C }
												</code>
											</td>
											<td>${list.SC_KEYNO}</td>
											<td>${list.SC_CODENM}</td>
											<td>
											${list.SC_CODEVAL01}
											<c:if test="${empty list.SC_CODEVAL01 || list.SC_CODEVAL01 == '' || list.SC_CODEVAL01 == null }">
												정보없음
											</c:if>
											</td>
											<td>
											${list.SC_CODEVAL02}
											<c:if test="${empty list.SC_CODEVAL02 || list.SC_CODEVAL02 == '' || list.SC_CODEVAL02 == null }">
												정보없음
											</c:if>
											</td>
											<td>${list.SC_CODELV}</td>
											<td>
											<c:if test="${list.SC_USE_YN=='Y'}">
												사용중
											</c:if>
											<c:if test="${list.SC_USE_YN== 'N'}">
												미사용중
											</c:if>
											</td>
											<td>
											<button type="button"  class="btn btn-success preview" alt="해당 서브코드를 수정합니다" onclick="pf_subcodeUpdate('${list.SC_KEYNO}','${list.SC_CODENM}','${list.SC_CODEVAL01}','${list.SC_CODEVAL02}','${list.SC_CODELV}','${list.SC_USE_YN}');"><i class="fa fa-pencil "></i> 수정</button>
											<button type="button"  class="btn btn-danger preview" alt="해당 서브코드를 삭제합니다." onclick="pf_subcodeDel('${list.SC_KEYNO}');"><i class="fa fa-trash-o "></i> 삭제</button>
											</td>
										</tr>
									</c:forEach>
									<c:if test="${empty list }">
									<tr>
										<td colspan="8">
											서브코드를 등록하세요
										</td>
									</tr>
									</c:if>
									</tbody>
								</table>
							</div>
							<div class="smart-form bg-color-white" align="right">
								<div class="btn-group">
									<button class="btn btn-sm btn-primary" type="button" id="SC_REGIST" name="SC_REGIST">
										<i class="fa fa-plus"></i> 서브코드 추가
									</button>  
								</div>
								<div class="btn-group">
									<button class="btn btn-sm btn-warning" type="button" id="cf_list">
										<i class="fa fa-times"></i> 목록으로
									</button>  
								</div>
							</div>
						</div>
						<!-- end widget content --> 

					</div>
					<!-- end widget div -->

				</div>
			</article>
		</div>
	</section>
</div>
<!-- END MAIN CONTENT -->

<!-- 메인코드 수정 팝업 CONTENT -->
<div id="maincode_setting" title="메인코드 수정">
	<div class="widget-body no-padding smart-form">
		<fieldset>
			<div class="bs-example necessT">
		         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
		    </div>
			<section class="col col-12">	
			<div class="bs-example">
				<dl class="dl-horizontal">
					<dt><span class="nessSpan">*</span> 코드명칭</dt>
					<dd>
						<input class="form-control valid" type="text" id="UPDATE_MC_CODENM" name="UPDATE_MC_CODENM" value="">
					</dd>
				</dl>
				</div>
			</section>
		</fieldset>

	</div>
</div>

<!-- 서브코드 수정 팝업 CONTENT -->
<div id="subcode_setting" title="서브코드 수정">
	<div class="widget-body no-padding smart-form">
		<fieldset>
			<div class="bs-example necessT">
		         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
		    </div>
			<section class="col col-12">	
			<div class="bs-example">
				<dl class="dl-horizontal">
					<dt><span class="nessSpan">*</span> 서브코드명칭</dt>
					<dd>
						<input class="form-control valid" type="text" id="UPDATE_SC_CODENM" name="UPDATE_SC_CODENM" value="" maxlength="50">
					</dd>
				</dl>
				</div>
			</section>
		</fieldset>
		<fieldset>
			<section class="col col-12">	
			<div class="bs-example">
				<dl class="dl-horizontal">
					<dt>코드값_01</dt>
					<dd>
						<input class="form-control valid" type="text" id="UPDATE_SC_CODEVAL01" name="UPDATE_SC_CODEVAL01" value="" maxlength="100">
					</dd>
				</dl>
				</div>
			</section>
			<section class="col col-6">	
			<div class="bs-example">
				<dl class="dl-horizontal">
					<dt>코드값_02</dt>
					<dd>
						<input class="form-control valid" type="text" id="UPDATE_SC_CODEVAL02" name="UPDATE_SC_CODEVAL02" value="" maxlength="100">
					</dd>
				</dl>
				</div>
			</section>
		</fieldset>
		<fieldset>
			<section class="col col-12">	
			<div class="bs-example">
				<dl class="dl-horizontal">
					<dt><span class="nessSpan">*</span> 정렬순서</dt>
					<dd>
						<input class="form-control valid" type="number" id="UPDATE_SC_CODELV" name="UPDATE_SC_CODELV" value="">
					</dd>
				</dl>
				</div>
			</section>
			<section class="col col-6">	
			<div class="bs-example">
				<dl class="dl-horizontal">
					<dt><span class="nessSpan">*</span> 사용여부</dt>
					<dd>
						<div class="inline-group">
							<label class="radio"> <input type="radio"
								name="UPDATE_SC_USE_YN" value="Y"> <i></i>사용
							</label> <label class="radio"> <input type="radio"
								name="UPDATE_SC_USE_YN" value="N"> <i></i>미사용
							</label>
						</div>
					</dd>
				</dl>
				</div>
			</section>
		</fieldset>

	</div>
</div>

<div id="subcode_registsetting" title="서브코드 등록">
	<div class="widget-body no-padding smart-form">
		<fieldset>
			<div class="bs-example necessT">
		         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
		    </div>
			<section class="col col-12">	
			<div class="bs-example">
				<dl class="dl-horizontal">
					<dt><span class="nessSpan">*</span> 서브코드명칭</dt>
					<dd>
						<input class="form-control valid" type="text" id="INSERT_SC_CODENM" name="INSERT_SC_CODENM" value="" maxlength="50">
					</dd>
				</dl>
				</div>
			</section>
		</fieldset>
		<fieldset>
			<section class="col col-12">	
			<div class="bs-example">
				<dl class="dl-horizontal">
					<dt>코드값_01</dt>
					<dd>
						<input class="form-control valid" type="text" id="INSERT_SC_CODEVAL01" name="INSERT_SC_CODEVAL01" value="" maxlength="100">
					</dd>
				</dl>
				</div>
			</section>
			<section class="col col-6">	
			<div class="bs-example">
				<dl class="dl-horizontal">
					<dt>코드값_02</dt>
					<dd>
						<input class="form-control valid" type="text" id="INSERT_SC_CODEVAL02" name="INSERT_SC_CODEVAL02" value="" maxlength="100">
					</dd>
				</dl>
				</div>
			</section>
		</fieldset>
		<fieldset>
			<section class="col col-12">	
			<div class="bs-example">
				<dl class="dl-horizontal">
					<dt><span class="nessSpan">*</span> 정렬순서</dt>
					<dd>
						<input class="form-control valid" type="number" id="INSERT_SC_CODELV" name="INSERT_SC_CODELV" value="${fn:length(list) + 1}">
					</dd>
				</dl>
				</div>
			</section>
			<section class="col col-6">	
			<div class="bs-example">
				<dl class="dl-horizontal">
					<dt><span class="nessSpan">*</span> 사용여부</dt>
					<dd>
						<div class="inline-group">
							<label class="radio"> <input type="radio"
								name="INSERT_SC_USE_YN" value="Y" checked="checked"> <i></i>사용
							</label> <label class="radio"> <input type="radio"
								name="INSERT_SC_USE_YN" value="N"> <i></i>미사용
							</label>
						</div>
					</dd>
				</dl>
				</div>
			</section>
		</fieldset>

	</div>
</div>




<script type="text/javascript">
	// DO NOT REMOVE : GLOBAL FUNCTIONS!
	$(document).ready(function() {
		//목록으로 이동하기
		$("#cf_list").on("click", function(){
			location.href="/dyAdmin/admin/code.do";
		});
		
		
		/* 수정하기 버튼 클릭시 실행되는 함수 */
	$('#MC_EDIT').click(function() {
		$('#maincode_setting').dialog('open');
		
		$("#UPDATE_MC_CODENM").val("${result.MC_CODENM}");
		cf_radio_checked("UPDATE_MC_USE_YN", "${result.MC_USE_YN}");
		
		return false;

	});
		
		/* 메인코드 수정하기 팝업 */
		$('#maincode_setting').dialog({
			autoOpen : false,
			width : 800,
			resizable : false,
			modal : true,
			title : " 메인코드 수정하기",
			buttons : [{
				html : "<i class='fa fa-floppy-o'></i>&nbsp; 저장",
				"class" : "btn btn-primary",
				click : function() {
					if(pf_maincodeedit()){
						$(this).dialog("close");
					}
				}
			}, {
				html : "<i class='fa fa-times'></i>&nbsp; 취소",
				"class" : "btn btn-default",
				click : function() {
					$(this).dialog("close");
				}
			}]
		});
		
		

		$('#SC_REGIST').click(function() {
			$('#subcode_registsetting').dialog('open');
			
			return false;

		});	
		
		/* 서브코드 등록하기 팝업 */
		$('#subcode_registsetting').dialog({
			autoOpen : false,
			width : 800,
			resizable : false,
			modal : true,
			title : " 서브코드 등록하기",
			buttons : [{
				html : "<i class='fa fa-floppy-o'></i>&nbsp; 저장",
				"class" : "btn btn-primary",
				click : function() {
					if(pf_subcodeInsert()){
						$(this).dialog("close");
					}
				}
			}, {
				html : "<i class='fa fa-times'></i>&nbsp; 취소",
				"class" : "btn btn-default",
				click : function() {
					$(this).dialog("close");
				}
			}]
		});
		
		
	
		/* 서브코드 수정하기 팝업 */
		$('#subcode_setting').dialog({
			autoOpen : false,
			width : 800,
			resizable : false,
			modal : true,
			title : " 서브코드 수정하기",
			buttons : [{
				html : "<i class='fa fa-floppy-o'></i>&nbsp; 저장",
				"class" : "btn btn-primary",
				click : function() {
					if(pf_subcodeEdit()){
						$(this).dialog("close");
					}
				}
			}, {
				html : "<i class='fa fa-times'></i>&nbsp; 취소",
				"class" : "btn btn-default",
				click : function() {
					$(this).dialog("close");
				}
			}]
		});
		
	});
	
	function pf_subcodeInsert(){
		if(!$('input[name=INSERT_SC_CODENM]').val().trim()){
			alert('서브코드  이름을 입력하세요.');
			return false;
		}
		
		if(!$('input[name=INSERT_SC_CODELV]').val()){
			alert('정렬 순서를 입력하세요.');
			return false;
		}
		
		cf_confirm("등록하시겠습니까?", "pf_insertSuccess()");
	}
	
	
	function pf_insertSuccess(){

		var data = "${result.MC_IN_C}";

		cf_loading(); 
		$.ajax({
			type: "POST",
			url: "/dyAdmin/admin/code/sub/insertAjax.do",
			data: {
				"SC_CODENM" : $("#INSERT_SC_CODENM").val().trim(),
				"SC_CODEVAL01" : $("#INSERT_SC_CODEVAL01").val(),
				"SC_CODEVAL02" : $("#INSERT_SC_CODEVAL02").val(),
				"SC_CODELV" : $("#INSERT_SC_CODELV").val(),
				"SC_USE_YN" : cf_radio_check_val("INSERT_SC_USE_YN"),
				"SC_MC_IN_C" : data
			},
			success : function(){
				 callBack(data);
			},
			error: function(){
				cf_loading_out();
				cf_alert("예상치못한 오류가 발생했습니다.");
				return false;
			}
		});
	}
	
	
	// 서브코드 수정 팝업 세팅 및 팝업을 띄워주는 함수 
	function pf_subcodeUpdate(a,b,c,d,e,f){
			
		$('#subcode_setting').dialog('open');
		
		$("#SC_KEYNO").val(a);
		$("#UPDATE_SC_CODENM").val(b);
		$("#UPDATE_SC_CODEVAL01").val(c);
		$("#UPDATE_SC_CODEVAL02").val(d);
		$("#UPDATE_SC_CODELV").val(e);
		cf_radio_checked("UPDATE_SC_USE_YN",f);
		
	}
	
	// 서브코드 수정 팝업에서 수정 버튼을 눌렀을대 실행되는 함수
	function pf_subcodeEdit(){
		if(!$('input[name=UPDATE_SC_CODENM]').val().trim()){
			alert('서브코드  이름을 입력하세요.');
			return false;
		}
		
		if(!$('input[name=UPDATE_SC_CODELV]').val()){
			alert('정렬 순서를 입력하세요.');
			return false;
		}
		
		cf_confirm("저장하시겠습니까?", "pf_updateSuccess()");
	}
	
	function pf_updateSuccess(){
		
		var data = "${result.MC_IN_C}";
		var SC_KEYNO = $("#SC_KEYNO").val();
		
		$.ajax({
			type: "POST",
			url: "/dyAdmin/admin/code/sub/updateAjax.do",
			data: {
				"SC_KEYNO" : SC_KEYNO,
				"SC_CODENM" : $("#UPDATE_SC_CODENM").val().trim(),
				"SC_CODEVAL01" : $("#UPDATE_SC_CODEVAL01").val(),
				"SC_CODEVAL02" : $("#UPDATE_SC_CODEVAL02").val(),
				"SC_CODELV" : $("#UPDATE_SC_CODELV").val(),
				"SC_USE_YN" : cf_radio_check_val("UPDATE_SC_USE_YN"),
				"SC_MC_IN_C" : data
			},
			success : function(){
				 callBack(data);
			},
			error: function(){
				return false;
			}
		});
	}
	
	//서브 코드 삭제 버튼 클릭시 실행되는 함수
	function pf_subcodeDel(a){
		cf_confirm("삭제하시겠습니까?", "pf_delSuccess(\'"+a+"\')");
	}
	
	// 서브코드 삭제 실행 함수
	function pf_delSuccess(a){
		
		var MC_KEYNO = a;

		var formData = "SC_KEYNO="+a;
		 
		data = "${result.MC_IN_C}";
		$.ajax({
			type: "POST",
			url: "/dyAdmin/admin/code/sub/deleteAjax.do",
			data: formData,
			success : function(){
				 callBack(data);
			},
			error: function(){
				return false;
			}
		});
		
	}
	
	//페이지를 재호출 해주는 callBack 함수
	function callBack(data){
		$("#MC_IN_C").val(data);
		$("#Form").attr("action","/dyAdmin/func/sub/code.do");
		$("#Form").submit();
	}
	
	
	// 메인코드 수정 팝업에서 저장버튼 클릭시 실행되는 함수
	function pf_maincodeedit(){
		
		if(!$('input[name=UPDATE_MC_CODENM]').val().trim()){
			alert('코드 이름을 입력하세요.');
			return false;
		}
		
		var MC_KEYNO = "${result.MC_KEYNO }";

		var formData = "MC_KEYNO="+MC_KEYNO+"&MC_CODENM="+$("#UPDATE_MC_CODENM").val().trim();
		 
		data = "${result.MC_IN_C}";
		$.ajax({
			type: "POST",
			url: "/dyAdmin/admin/code/main/update.do",
			data: formData,
			success : function(){
				 cf_alert_cb("저장되었습니다.","callBack('"+data+"')");
			},
			error: function(){
				return false;
			}
		});
		
	}
	
	// 메인코드 삭제 처리
	function pf_mcDelete(mc_keyno, mc_ic_c){
		if(confirm("메인코드를 삭제하시겠습니까?")){
			$("#MC_KEYNO").val(mc_keyno);
			$("#MC_IN_C").val(mc_ic_c);
			$("#Form").attr("action","/dyAdmin/admin/code/main/delete.do");
			$("#Form").submit();
		}
	}

	
</script>