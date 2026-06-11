<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>



<form:form id="Form" name="Form" method="post" action="">
	<input type="hidden" name="SK_KEYWORD" id="SK_KEYWORD" value="">
	<input type="hidden" name="SK_IP" id="SK_IP" value="">
	<input type="hidden" name="SK_REGDT" id="SK_REGDT" value="">
	<input type="hidden" name="SK_USERID" id="SK_USERID" value="">
	<input type="hidden" name="SK_COUNT" id="SK_COUNT" value="">
	<input type="hidden" name="CASE" id="CASE" value="전체" />
	<section id="widget-grid" >
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" id="BOARD_TYPE_LIST_1" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-table"></i>
						</span>
						<h2>키워드 리스트</h2>
					</header>
					<div>
						<div class="widget-body " >
							<div class="widget-body-toolbar bg-color-white">
								<div class="alert alert-info no-margin fade in">
									<button type="button" class="close" data-dismiss="alert">×</button>
									키워드 리스트를 확인합니다.
								</div> 
							</div>
							<div class="widget-body-toolbar bg-color-white">
								<div class="row"> 
									<div class="col-sm-12 col-md-2 text-align-right" style="float:right;">
										<div class="btn-group">  
											<button class="btn btn-sm btn-primary" type="button" onclick="pf_openUpdatekeyword()">
												<i class="fa fa-plus"></i> 키워드 조작
											</button> 
										</div>
									</div>
								</div>
							</div>
							<div class="widget-body-toolbar bg-color-white smart-form">
							<div class="row" style="margin-top:10px;text-align:left; margin-left: 5px;">
								<section class="col col-2">시작일시
									<label class="input"> <i class="icon-append fa fa-calendar"></i>
										<input type="text" name="searchBeginDate" id="searchBeginDate" placeholder="시작일시" value="${search.searchBeginDate}">
									</label>
								</section>
								<section class="col" style="text-align:center;line-height:32px;padding-top:18px;">
									~
								</section>
								<section class="col col-2">종료일시
									<label class="input"> <i class="icon-append fa fa-calendar"></i>
										<input type="text" name="searchEndDate" id="searchEndDate" placeholder="종료일시" value="${search.searchEndDate}">
									</label>
								</section>
								<section class="col col-2">검색기간
									<label class="select">
										<select class="form-control input-sm" name="orderCondition" id="searchDate" onchange="pf_searchDate(this.value)">
							              	<option value="">선택하세요.</option>
							                <option value="1" ${search.orderCondition eq '1'? 'selected':'' }>오늘</option>
							                <option value="2" ${search.orderCondition eq '2'? 'selected':'' }>이번달</option>
							                <option value="3" ${search.orderCondition eq '3'? 'selected':'' }>일주일</option>
							                <option value="4" ${search.orderCondition eq '4'? 'selected':'' }>보름</option>
							                <option value="5" ${search.orderCondition eq '5'? 'selected':'' }>1개월</option>
							                <option value="6" ${search.orderCondition eq '6'? 'selected':'' }>2개월</option>
							                <option value="7" ${search.orderCondition eq '7'? 'selected':'' }>3개월</option>
							                <option value="8" ${search.orderCondition eq '8'? 'selected':'' }>6개월</option>
							                <option value="9" ${search.orderCondition eq '9'? 'selected':'' }>1년</option>
							                <option value="10" ${search.orderCondition eq '10'? 'selected':'' }>전체</option>
							            </select> <i></i> 
									</label>
								</section>
								
								<section class="col col-2">
									<div class="btn-group" style="width: 100%;padding-top:18px;">  
											<button class="btn btn-sm btn-primary" onclick="pf_LinkPage()" type="button" style="margin-right:10px;">
												<i class="fa fa-floppy-o"></i> 조회
											</button>
									</div>
								</section>
							</div>
						</div>
							
						
		
				
				
				
									
									<div class="tab-content padding-10">
										<div class="table-responsive">
											<jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
												<jsp:param value="/dyAdmin/admin/keyword/pagingAjax.do" name="pagingDataUrl" />
												<jsp:param value="/dyAdmin/admin/keyword/excelAjax.do" name="excelDataUrl" />
											</jsp:include>
											<fieldset id="tableWrap">
											</fieldset>
										</div>
									</div>
					
						</div>
					</div>
				</div>
			</article>
		</div>
	</section>
</form:form>

<!-- 키워드 상세 목록 팝업 CONTENT -->
<div id="keyword_List" title="키워드 상세 목록">
	<div class="widget-body " style="max-height: 500px;">
		<table id="keywordDetailListTable" class="table table-striped table-bordered table-hover table-center">
			<thead>
				<tr>
					<th>회원</th>
					<th>IP</th>
					<th>날짜</th>
					<th>설정</th>				
				</tr>
			</thead>
			<tbody>
			
			</tbody>
		
		</table>
			
	</div>
</div>


<!-- 키워드 조작 팝업 CONTENT -->
<div id="keyword_update" title="키워드 조작">
	<div class="widget-body ">
		<fieldset>
			<div class="form-horizontal">
				<fieldset>
					<div class="bs-example necessT">
				         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
				    </div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span class="nessSpan">*</span> 키워드</label>
						<div class="col-md-10">
							<input type="text" class="form-control" name="M_KEYWORD" id="M_KEYWORD" maxlength="50">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span class="nessSpan">*</span> 카운트</label>
						<div class="col-md-10">
							<input name="M_COUNT" id="M_COUNT" type="number" class="form-control" max="9999" maxlength="4" oninput="maxLengthCheck(this)" >
						</div>
					</div>
					
				</fieldset>
			</div>
		</fieldset>
	</div>
</div>


<script>

var deleteState = false;


$(function(){
	/* 키워드 상세 목록 팝업 */
	pf_setttingDialog('#keyword_List','검색 회원 목록');
	
	/* 키워드 조작 팝업 */
	cf_setttingDialog('#keyword_update','키워드 조작','실행','pf_updatekeyword()');

	
})

//다이얼로그 커스텀
function pf_setttingDialog(obj,title){
	var data = {
			autoOpen : false,
			width : 800,
			resizable : false,
			modal : true,
			title : title,
			buttons : [{
				html : "<i class='fa fa-times'></i>&nbsp; 확인",
				"class" : "btn btn-primary",
				click : function() {
					if(deleteState){
						window.location.reload();
						deleteState = true;
						pf_LinkPage();
					}else{
						$(this).dialog("close");
					}
				}
			}]
		}
	$(obj).dialog(data);
}


/* 검색 회원 목록 모달창 오픈 */
function pf_openKeywordList(obj){
	cf_loading();
	
	var keyword = $(obj).parents('tr').find('.keywordData').html();
	
	$.ajax({
		type: "POST",
		url: "/dyAdmin/admin/keyword/detailListAjax.do",
		data: "SK_KEYWORD=" + encodeURI(keyword),
		async:false,
		success : function(data){
			var temp = "";
			$.each(data,function(i){
				
				temp += "<tr>";
				temp += "<td>"+data[i].UI_ID+"</td>";
				temp += "<td>"+data[i].SK_IP+"</td>";
				temp += "<td>"+data[i].SK_REGDT+"</td>";
				temp += '<td><button class="btn btn-primary btn-danger" type="button" onclick="pf_deleteKeywordDetail(\''+data[i].SK_KEYWORD+'\',\''+data[i].SK_IP+'\',\''+data[i].SK_REGDT+'\',\''+data[i].SK_USERID+'\',this)">삭제</button></td>';
				temp += "</tr>";
			})
			$('#keywordDetailListTable tbody').html(temp);
		},
		error: function(){
			alert('에러. 관리자한테 문의하세요.')
			return false;
		}
	}).done(function(){
		cf_loading_out();
	});
	
	
	$('#keyword_List').dialog('open');
	
}

//삭제
function pf_deleteKeywordDetail(keyword,ip,date,id,obj){
	cf_loading();
	$('#SK_KEYWORD').val(keyword);
	$('#SK_IP').val(ip);
	$('#SK_REGDT').val(date);
	$('#SK_USERID').val(id);
	
	$.ajax({
		type: "POST",
		url: "/dyAdmin/admin/keyword/deleteAjax.do",
		data: $('#Form').serializeArray(),
		async:false,
		success : function(){
			
			$(obj).parents('tr').remove();
			deleteState = true;
			alert('정상적으로 삭제되었습니다.');
		},
		error: function(){
			alert('에러. 관리자한테 문의하세요.')
			return false;
		}
	}).done(function(){
		cf_loading_out();
	});
	
}

/* 키워드 삭제 */
function pf_deletekeyword(obj){
	event.stopPropagation();
	
	var KEYWORD = $(obj).parents('tr').find('.keywordData').html();
	
	if(!confirm( '키워드 ['+KEYWORD + ']를 삭제하시겠습니까?')){
		return false;
	}
	cf_loading();
	$.ajax({
		type: "POST",
		url: "/dyAdmin/admin/keyword/deleteKeywordAjax.do",
		data: "SK_KEYWORD="+encodeURI(KEYWORD),
		async:false,
		success : function(){
			alert('정상적으로 삭제되었습니다.');
			pf_LinkPage();
		},
		error: function(){
			
			alert('삭제 할수없습니다. 관리자한테 문의하세요.')
			return false;
		}
	}).done(function(){
		cf_loading_out();
	});
}



/* 키워드 조작 모달창 오픈 */
function pf_openUpdatekeyword(obj){
	event.stopPropagation();
	$('#keyword_update').dialog('open');
}

//키워드 조작
function pf_updatekeyword(){
	
	if(!$('#M_KEYWORD').val().trim()){
		alert('키워드를 입력하세요')
		$('#M_KEYWORD').focus();
		return false;
	}
	
	if(!$('#M_COUNT').val()){
		alert('카운트를 입력하세요')
		$('#M_COUNT').focus();
		return false;
	}
	
	$('#SK_KEYWORD').val($('#M_KEYWORD').val().trim());
	$('#SK_COUNT').val($('#M_COUNT').val());
	$('#Form').attr('action','/dyAdmin/admin/keyword/update.do');
	$('#Form').submit();
	
}

//maxlength 체크
function maxLengthCheck(object){
 if (object.value.length > object.maxLength){
  object.value = object.value.slice(0, object.maxLength);
 }    
}

function pf_searchDate(object){
	pf_settingSearchDate(object);
	pf_LinkPage();
}

</script>
