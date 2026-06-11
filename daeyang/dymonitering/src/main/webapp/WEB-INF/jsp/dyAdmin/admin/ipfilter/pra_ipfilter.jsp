<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<style>
.table-center * {text-align:center !important;vertical-align: middle !important;}
.table-tr-selected {background:#ecf3f8 !important;}

.inline-group label {width:100px;}
pre {background:none;border:none;}
.IPList {display:none;}
.addIP {width:20% !important;}
.form-group-wrap > * {display:inline-block;}
.form-group-wrap * {text-align:center;}
.form-group-wrap > button {width:15%;}
.form-group-wrap > .form-group-custom:nth-of-type(2n) {width:5%;} 
.form-group-wrap > .form-group-custom:nth-of-type(2n+1) {width:15%;}
</style>
<form:form id="form" method="post" action="">
	<input type="hidden" name="IPM_KEYNO" id="IPM_KEYNO" value="" />
	<input type="hidden" name="IPM_URL" id="IPM_URL" value="" />
	<input type="hidden" name="IPM_TYPE" id="IPM_TYPE" value="" />
	<input type="hidden" name="IPM_USEYN" id="IPM_USEYN" value="" />
	
	<input type="hidden" name="IPS_TYPE" id="IPS_TYPE" value="" />
	<input type="hidden" name="IPS_IPM_KEYNO" id="IPS_IPM_KEYNO" value="" />
	<input type="hidden" name="IPS_IPADDRESS" id="IPS_IPADDRESS" value="" />
	<input type="hidden" name="IPS_IPADDRESS_BEFORE" id="IPS_IPADDRESS_BEFORE" value="" />
	<input type="hidden" name="IPS_KEYNO" id="IPS_KEYNO" value="" />
</form:form>
<!-- widget grid -->
<section id="widget-grid" class="">
	<div class="row">
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
		<p class="alert alert-info">
			<i class="fa fa-info"></i> <br>
			1. URL 입력시 여러개 가능함 엔터로 구분<br>
			2. URL 마지막에 /*으로 이하 모든것 매칭 가능함<br>
			3. IP 마지막은 * 허용 ex) 1.2.3.* 
		</p>
		</article>
	</div>
	<div class="row">
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
			<!-- Widget ID (each widget will need unique ID)-->
			<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>적용 URL</h2>

				</header>
				<!-- widget div-->
				<div>
					<!-- widget edit box -->
					<div class="jarviswidget-editbox">
						<!-- This area used as dropdown edit box -->

					</div>
					<!-- end widget edit box -->
					
					<!-- widget content -->
					<div class="widget-body ">
						<div class="table-responsive" id="urlList">
							<table class="table table-bordered table-hover table-center">
								<thead>
									<tr>
										<th>INDEX</th>
										<th style="width:50%;">URL</th>
										<th>적용방식</th>
										<th>사용여부</th>
										<th>비고</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${urlList }" var="model" varStatus="status">
										<tr class="pointer" onclick="getIPList(this,'${model.IPM_KEYNO}','${model.IPM_TYPE_NAME}')">
											<td>${status.count }</td>
											<td class="ipmurl"><pre>${model.IPM_URL}</pre></td>
											<td class="ipmtype">${model.IPM_TYPE_NAME}</td>
											<td class="ipmuseyn">
												${model.IPM_USEYN eq 'Y' ? 'O' : 'X' }
											</td>
											<td>
												<button class="btn btn-info btn-sm btn-updateURL" data-keyno="${model.IPM_KEYNO}" data-url="${model.IPM_URL}" data-type="${model.IPM_TYPE}" data-useyn="${model.IPM_USEYN}"
													onclick="pf_openUpdateURL(this)">수정</button>
												<button class="btn btn-danger btn-sm"
													onclick="pf_removeURL(this,'${model.IPM_KEYNO}')">삭제</button>
											</td>
										</tr>
									</c:forEach>
								</tbody>
								<tfoot>
									<tr>
										<td colspan="5">
											<button class="btn btn-primary btn-default" type="button" onclick="pf_openAddURL()">추가</button>
										</td>
									</tr>
								</tfoot>
							</table>
						</div>
					</div>
					<!-- end widget content -->
				</div>
				<!-- end widget div -->
			</div>
			<!-- end widget -->
		</article>
	</div>

	<div class="row">
		<article class="col-xs-12 col-sm-12 col-md-6 col-lg-6 IPList IPList-white">
			<!-- Widget ID (each widget will need unique ID)-->
			<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>IP 화이트 리스트</h2>

				</header>
				<!-- widget div-->
				<div>
					<!-- widget edit box -->
					<div class="jarviswidget-editbox">
						<!-- This area used as dropdown edit box -->

					</div>
					<!-- end widget edit box -->
					
					<!-- widget content -->
					<div class="widget-body ">
						<div class="table-responsive" id="ipWhite">
							<table class="table table-bordered table-striped table-hover table-center">
								<thead>
									<tr>
										<th>INDEX</th>
										<th style="width:50%;">IP</th>
										<th>비고</th>
									</tr>
								</thead>
								<tbody>
								
								</tbody>
								<tfoot>
									<tr>
										<td colspan="3">
											<fieldset class="form-group-wrap">
												<div class="form-group-custom">
													<input type="text" class="form-control" maxlength="3" name="addIP" onkeydown="return cf_only_Num(event);">
												</div>
												<div class="form-group-custom">
													.
												</div>
												<div class="form-group-custom">
													<input type="text" class="form-control" maxlength="3" name="addIP" onkeydown="return cf_only_Num(event);">
												</div>
												<div class="form-group-custom">
													.
												</div>
												<div class="form-group-custom">
													<input type="text" class="form-control" maxlength="3" name="addIP" onkeydown="return cf_only_Num2(event);">
												</div>
												<div class="form-group-custom">
													.
												</div>
												<div class="form-group-custom">
													<input type="text" class="form-control" maxlength="3" name="addIP">
												</div>
												<button type="button" class="btn btn-primary" onclick="pf_addAddress('W','ipWhite')">
													추가
												</button>
											</fieldset>
										</td>
									</tr>
								</tfoot>
							</table>
						</div>
					</div>
					<!-- end widget content -->
				</div>
				<!-- end widget div -->
			</div>
			<!-- end widget -->
		</article>
		
		<article class="col-xs-12 col-sm-12 col-md-6 col-lg-6 IPList IPList-black">
			<!-- Widget ID (each widget will need unique ID)-->
			<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>IP 블랙 리스트</h2>

				</header>
				<!-- widget div-->
				<div>
					<!-- widget edit box -->
					<div class="jarviswidget-editbox">
						<!-- This area used as dropdown edit box -->

					</div>
					<!-- end widget edit box -->
					
					<!-- widget content -->
					<div class="widget-body ">
						<div class="table-responsive" id="ipBlack">
							<table class="table table-bordered table-striped table-hover table-center">
								<thead>
									<tr>
										<th>INDEX</th>
										<th style="width:50%;">IP</th>
										<th>비고</th>
									</tr>
								</thead>
								<tbody>
								
								</tbody>
								<tfoot>
									<tr>
										<td colspan="3">
											<fieldset class="form-group-wrap">
												<div class="form-group-custom">
													<input type="text" class="form-control" maxlength="3" name="addIP" onkeydown="return cf_only_Num(event);">
												</div>
												<div class="form-group-custom">
													.
												</div>
												<div class="form-group-custom">
													<input type="text" class="form-control" maxlength="3" name="addIP" onkeydown="return cf_only_Num(event);">
												</div>
												<div class="form-group-custom">
													.
												</div>
												<div class="form-group-custom">
													<input type="text" class="form-control" maxlength="3" name="addIP" onkeydown="return cf_only_Num2(event);">
												</div>
												<div class="form-group-custom">
													.
												</div>
												<div class="form-group-custom">
													<input type="text" class="form-control" maxlength="3" name="addIP">
												</div>
												<button type="button" class="btn btn-primary" onclick="pf_addAddress('B','ipBlack')">
													추가
												</button>
											</fieldset>
										</td>
									</tr>
								</tfoot>
							</table>
						</div>
					</div>
					<!-- end widget content -->
				</div>
				<!-- end widget div -->
			</div>
			<!-- end widget -->
		</article>
		<div class="clear"></div>
	</div>
	<!-- end row -->
	
</section>
<!-- end widget grid -->


<!-- IP 수정 팝업 CONTENT -->
<div id="ip_setting" title="IP 수정">
	<div class="widget-body no-padding smart-form">
		<fieldset>
			<section class="col col-12">	
			<div class="bs-example">
				<dl class="dl-horizontal">
					<dt style="line-height:32px;">IP</dt>
					<!-- <dd>
						<input type="text" id="UPDATE_IP" name="UPDATE_IP" value="">
					</dd>
					 -->
					 <dd class="form-group-wrap">
						<div class="form-group-custom">
							<input type="text" class="form-control" maxlength="3" name="addIP" onkeydown="return cf_only_Num(event);">
						</div>
						<div class="form-group-custom">
							.
						</div>
						<div class="form-group-custom">
							<input type="text" class="form-control" maxlength="3" name="addIP" onkeydown="return cf_only_Num(event);">
						</div>
						<div class="form-group-custom">
							.
						</div>
						<div class="form-group-custom">
							<input type="text" class="form-control" maxlength="3" name="addIP" onkeydown="return cf_only_Num2(event);">
						</div>
						<div class="form-group-custom">
							.
						</div>
						<div class="form-group-custom">
							<input type="text" class="form-control" maxlength="3" name="addIP">
						</div>
					</dd>
				</dl>
				</div>
			</section>
		</fieldset>

	</div>
</div>

<!-- URL 추가 팝업 CONTENT -->
<div id="url_addSetting" title="URL 추가">
	<div class="widget-body ">
		<fieldset>
			<div class="bs-example necessT">
		         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
		     </div>
			<div class="form-horizontal">
				<fieldset>
					<div class="form-group">
						<label class="col-md-2 control-label"><span class="nessSpan">*</span> URL</label>
						<div class="col-md-10">
							<textarea class="form-control" placeholder="" name="M_URL" rows="4" maxlength="200"></textarea>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span class="nessSpan">*</span> 적용방식</label>
						<div class="col-md-10">
							<c:forEach items="${codeList}" var="model">
							<label class="radio radio-inline">
								<input type="radio" class="radiobox style-0" name="M_TYPE" value="${model.SC_KEYNO}">
								<span>${model.SC_CODENM }</span> 
							</label>
							</c:forEach>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span class="nessSpan">*</span> 사용여부</label>
						<div class="col-md-10">
							<label class="radio radio-inline">
								<input type="radio" class="radiobox style-0" name="M_USEYN" value="Y">
								<span>사용</span> 
								
							</label>
							<label class="radio radio-inline">
								<input type="radio" class="radiobox style-0" name="M_USEYN" value="N">
								<span>미사용</span>  
							</label>
						</div>
					</div>
				</fieldset>
			</div>
		</fieldset>
	</div>
</div>

<!-- URL 수정 팝업 CONTENT -->
<div id="url_updateSetting" title="URL 수정">
	<div class="widget-body ">
		<fieldset>
			<div class="form-horizontal">
				<fieldset>
					<div class="bs-example necessT">
				         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
				     </div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span class="nessSpan">*</span> URL</label>
						<div class="col-md-10">
							<textarea class="form-control" placeholder="" name="M_URL2" rows="4" maxlength="200"></textarea>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span class="nessSpan">*</span> 적용방식</label>
						<div class="col-md-10">
							<c:forEach items="${codeList}" var="model">
							<label class="radio radio-inline">
								<input type="radio" class="radiobox style-0" name="M_TYPE2" value="${model.SC_KEYNO}">
								<span>${model.SC_CODENM }</span> 
							</label>
							</c:forEach>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span class="nessSpan">*</span> 사용여부</label>
						<div class="col-md-10">
							<label class="radio radio-inline">
								<input type="radio" class="radiobox style-0" name="M_USEYN2" value="Y">
								<span>사용</span> 
								
							</label>
							<label class="radio radio-inline">
								<input type="radio" class="radiobox style-0" name="M_USEYN2" value="N">
								<span>미사용</span>  
							</label>
						</div>
					</div>
				</fieldset>
			</div>
		</fieldset>
	</div>
</div>


<script>
	var objTemp;

	$(function(){
		
		/* IP 수정 팝업 */
		cf_setttingDialog('#ip_setting','IP 수정','수정','pf_UpdateAddress()');
		/* URL 추가  팝업 */
		cf_setttingDialog('#url_addSetting','URL 추가','저장','pf_addURL()');
		/* URL 수정  팝업 */
		cf_setttingDialog('#url_updateSetting','URL 수정','수정','pf_UpdateURL()');
		
		$('.btn-updateURL').each(function(){
			if($(this).data('keyno') == '${IPM_KEYNO}'){
				$(this).parents('tr').click();
			}
		});
		
		
	})
	
	//URL 추가 모달창 open
	function pf_openAddURL(){
		$('#url_addSetting').dialog('open');
	}
	
	//URL 추가
	function pf_addURL(){
		
		if(!$('textarea[name=M_URL]').val().trim()){
			alert('URL을 입력하여주세요');
			return false;
		}
		if(!cf_radio_check_val('M_TYPE')){
			alert('적용방식을 선택하여주세요');
			return false;
		}
		if(!cf_radio_check_val('M_USEYN')){
			alert('사용여부를 선택하여주세요');
			return false;
		}
		
		$('#IPM_URL').val($('textarea[name=M_URL]').val().trim());
		$('#IPM_TYPE').val(cf_radio_check_val('M_TYPE'));
		$('#IPM_USEYN').val(cf_radio_check_val('M_USEYN'));
		$('#form').attr('action', '/dyAdmin/admin/ipfilter/main/insert.do');
		$('#form').submit();
	}
	
	//URL 제거
	function pf_removeURL(obj, KEYNO){
		event.stopPropagation();
		if(confirm('정말 삭제하시겠습니까?')){
			$('#IPM_KEYNO').val(KEYNO);
			$.ajax({
				type: "POST",
				url: "/dyAdmin/admin/ipfilter/main/deleteAjax.do",
				data: $('#form').serializeArray(),
				success : function(){
					 alert('정상적으로 삭제되었습니다.')
					 $(obj).parents('tr').remove();
				},
				error: function(){
					alert('삭제할수없습니다. 관리자한테 문의하세요.')
					return false;
				}
			});
			
		}
	}
	
	//URL 수정 모달창 open
	function pf_openUpdateURL(obj) {
		event.stopPropagation();
		$('#IPM_KEYNO').val($(obj).data('keyno'));
		
		$('#url_updateSetting').dialog('open');
		
		$('textarea[name=M_URL2]').val($(obj).data('url'));
		cf_radio_checked('M_TYPE2', $(obj).data('type'));
		cf_radio_checked('M_USEYN2', $(obj).data('useyn'));
		
	}
	
	//URL 수정
	function pf_UpdateURL(){
		event.stopPropagation();
		
		if(!$('textarea[name=M_URL2]').val().trim()){
			alert('URL을 입력하여주세요');
			return false;
		}
		
		$('#IPS_IPADDRESS').val($('#UPDATE_IP').val());
		
		$('#IPM_URL').val($('textarea[name=M_URL2]').val().trim());
		$('#IPM_TYPE').val(cf_radio_check_val('M_TYPE2'));
		$('#IPM_USEYN').val(cf_radio_check_val('M_USEYN2'));
		
		$.ajax({
			type: "POST",
			url: "/dyAdmin/admin/ipfilter/main/updateAjax.do",
			data: $('#form').serializeArray(),
			async:false,
			success : function(){
				alert('정상적으로 수정되었습니다.');
				location.reload();
			},
			error: function(){
				alert('수정할수없습니다. 관리자한테 문의하세요.')
				return false;
			}
		});
	}
	
	//IP 리스트
	function getIPList(obj, KEYNO,TYPE_NAME){
		
		
		$('#urlList').find('tr').removeClass('table-tr-selected');
		$(obj).addClass('table-tr-selected');
		
		$('.IPList').hide();
		var container;
		var TYPE;
		if(TYPE_NAME == '화이트리스트'){
			container = $('.IPList-white');
			TYPE = 'W';
		}else{
			container = $('.IPList-black');
			TYPE = 'B';
		}
		$(container).show();
		
		$('#IPS_IPM_KEYNO').val(KEYNO);
		
		$.ajax({
			type: "POST",
			url: "/dyAdmin/admin/ipfilter/subList/listAjax.do?KEYNO="+KEYNO+"&TYPE="+TYPE,
			data: $('#form').serializeArray(),
			async:false,
			success : function(data){
				var temp ='';
				$.each(data,function(i){
					temp += '<tr><td>'+(i+1)+'</td>';
					temp += '<td class="ipaddress">'+data[i].IPS_IPADDRESS+'</td>';
					temp += '<td><button class="btn btn-info btn-sm" onclick="pf_openUpdateAddress(\''+TYPE+'\',this,\''+data[i].IPS_KEYNO+'\')">수정</button>';
					temp += '<button class="btn btn-danger btn-sm" onclick="pf_removeAddress(\''+TYPE+'\',this,\''+data[i].IPS_KEYNO+'\')">삭제</button></td></tr>';
				})
				
				$(container).find('tbody').html(temp);
				pageSetUp();
			},
			error: function(){
				alert('데이터를 가져올수없습니다. 관리자한테 문의하세요.')
				return false;
			}
		});
		
	}
	//IP 체크
	function pf_checkIP(obj){
		var ip = '';
		var state = false;
		$(obj).each(function(i){
			
			var num = $(this).val();
			if(!num){
				alert('IP를 입력하여주세요');
				state= true;
				return false;
			}else if(i != 3 && !Number(num) && num != '0' ){
				alert('숫자만 입력하여주세요');
				$(this).val('');
				state= true;
				return false;
			}else if(i == 3 &&  !(Number(num) ||  num == '*') && num != '0' ){
				alert('숫자나 * 만 입력하여주세요');
				$(this).val('');
				state= true;
				return false;
			}
			
			if(i != 0){
				ip += '.';
			}
			ip += num;
		});
		
		if(state){
			return '';
		}
		return ip;
	}
	//IP 추가
	function pf_addAddress(type, id) {
		var ip = pf_checkIP('#'+id+' input[name=addIP]');
		
		if(!ip){
			return false;
		}
		$('#IPS_TYPE').val(type);
		$('#IPS_IPADDRESS').val(ip);
		$('#form').attr('action', '/dyAdmin/admin/ipfilter/sub/insert.do');
		$('#form').submit();

	}
	
	//IP 제거
	function pf_removeAddress(type, obj, IPS_KEYNO) {
		var address = $(obj).parents('tr').find('.ipaddress').text();
		
		$('#IPS_TYPE').val(type);
		$('#IPS_IPADDRESS').val(address);
		$('#IPS_KEYNO').val(IPS_KEYNO);
		$.ajax({
			type: "POST",
			url: "/dyAdmin/admin/ipfilter/sub/deleteAjax.do",
			data: $('#form').serializeArray(),
			success : function(){
				 alert('정상적으로 삭제되었습니다.')
				 $(obj).parents('tr').remove();
			},
			error: function(){
				alert('삭제할수없습니다. 관리자한테 문의하세요.')
				return false;
			}
		});

	}
	
	//IP 수정 모달창 open
	function pf_openUpdateAddress(type, obj, IPS_KEYNO) {
		var address = $(obj).parents('tr').find('.ipaddress').text();
		
		$('#IPS_TYPE').val(type);
		$('#IPS_IPADDRESS_BEFORE').val(address);
		$('#IPS_KEYNO').val(IPS_KEYNO);
		
		$('#ip_setting').dialog('open');
		
		var temp = address.split('.');
		
		$.each(temp,function(i){
			$('#ip_setting input[name=addIP]').eq(i).val(temp[i]);
		})
		objTemp = obj
		
	}
	
	//IP 수정
	function pf_UpdateAddress(){
		
		var ip = pf_checkIP('#ip_setting input[name=addIP]');
		if(!ip){
			return false;
		}
		
		
		$('#IPS_IPADDRESS').val(ip);
		
		$.ajax({
			type: "POST",
			url: "/dyAdmin/admin/ipfilter/sub/updateAjax.do",
			data: $('#form').serializeArray(),
			async:false,
			success : function(){
				alert('정상적으로 수정되었습니다.')
				$(objTemp).parents('tr').find('.ipaddress').text(ip);
				$('#ip_setting').dialog('close');
			},
			error: function(){
				alert('수정할수없습니다. 관리자한테 문의하세요.')
				return false;
			}
		});
	}
	
	/**
	 * 숫자와 * 만 입력을 받는 함수 
	 * @param e 
	 * @returns {Boolean}
	 * @Event onkeydown 
	 */  
	function cf_only_Num2(e) { 
	    var KeyCode = e.which?e.which:event.keyCode;
	    if((Number(KeyCode) == 8) ||(Number(KeyCode) == 9) || (Number(KeyCode) == 46)|| (Number(KeyCode) == 42) ||  
	    		((Number(KeyCode) >= 48 && Number(KeyCode) <= 57)) ||
	    		((Number(KeyCode) >= 96 && Number(KeyCode) <= 105))
	    		){
	    	return true; 
	    }else{     
	    	return false; 
	    } 
	}

	
</script>
