<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<style>

.checksize{
 width: 20% !important;
 margin-bottom: 5px !important;
}
form .error {color:red}

.checkbox-inline+.checkbox-inline, .radio-inline+.radio-inline {margin-left:0;}
.checkbox-inline, .radio-inline {margin-right:10px;}

#insert-article {display:none;}
#tableWrap.mini th.display,
#tableWrap.mini td.display {display:none;}

.fixed-btns {position: fixed;bottom: 10px;right: 30px;z-index: 100;}

.fixed-btns > li {display: inline-block;margin-bottom: 7px;}

</style>

<section id="widget-grid" class="">
	<div class="row">
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12" id="list-article">
			<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>서브도메인 리스트</h2>
				</header>
				<div class="widget-body " >
					<div class="widget-body-toolbar bg-color-white">
						<div class="alert alert-info no-margin fade in">
							<button type="button" class="close" data-dismiss="alert">×</button>
							서브도메인 리스트를 확인합니다.
						</div> 
					</div>
					<div class="widget-body-toolbar bg-color-white">
						<div class="row"> 
							<div class="col-sm-12 col-md-12 text-align-right" style="float:right;">
								<div class="btn-group">  
									<button class="btn btn-sm btn-primary" type="button" onclick="pf_insertDomain()">
										<i class="fa fa-plus"></i> 서브도메인 등록
									</button> 
								</div>
							</div>
						</div>
					</div>
					<form:form id="Form" name="Form" method="post" action="">
						<div class="table-responsive">
							<jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
								<jsp:param value="/dyAdmin/admin/domain/pagingAjax.do" name="pagingDataUrl" />
								<jsp:param value="/dyAdmin/admin/domain/excelAjax.do" name="excelDataUrl" />
							</jsp:include>
							<fieldset id="tableWrap">
							</fieldset>
						</div>
					</form:form>
				</div>
			</div>
		</article>
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-8" id="insert-article">
			<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>서브도메인 등록/수정</h2>
				</header>
				<div class="widget-body " >
					<form:form id="insertForm" class="form-horizontal" name="Form" method="post" action="">
						<div id="inputFormBox">
						</div>
					</form:form>
					<ul class="fixed-btns">
						<li>
							<a href="javascript:;" onclick="pf_save()" class="btn btn-primary btn-circle btn-lg" title="저장하기"><i class="fa fa-save"></i></a>
						</li>
						<li id="deleteBtn">
							<a href="javascript:;" onclick="pf_delete()" class="btn btn-danger btn-circle btn-lg" title="삭제하기"><i class="fa fa-trash-o"></i></a>
						</li>
						<li>
							<a href="javascript:;" onclick="pf_togleArticle('N')" class="btn btn-default btn-circle btn-lg" title="목록가기"><i class="fa fa-arrow-right"></i></a>
						</li>
					</ul>
				</div>
			</div>
		</article>
	</div>
</section>




<script type="text/javascript">

var formActionType;

function pf_insertDomain(key,isPossibleDelete){
	key = key || '';
	
	pf_togleArticle('Y');
	
	$.ajax({
		type: "POST",
		url: "/dyAdmin/admin/domain/dataAajx.do",
		data: {
			"HM_KEYNO" : key
		},
		async :false,
		success : function(data){
			$('#inputFormBox').html(data);
            $('#isPossibleDelete').val(isPossibleDelete);
            
			if(isPossibleDelete == 'N'){
				$('#deleteBtn').hide();
			}else{
				$('#deleteBtn').show();
			}
		},
		error: function(jqXHR, textStatus, errorThrown){
			cf_smallBox('ajax', '알수없는 에러 발생. 관리자한테 문의하세요.', 3000,'gray');
		}
   }).done(function(){
	   cf_loading_out();
   });
	
	
	
}

function pf_togleArticle(action){
	if(action == 'Y'){
		$('#list-article').removeClass('col-lg-12').addClass('col-lg-4');
		$('#insert-article').show();
		$('#tableWrap').addClass('mini')
	}else{
		$('#list-article').removeClass('col-lg-4').addClass('col-lg-12');
		$('#insert-article').hide();
		$('#tableWrap').removeClass('mini')
	}
	
	
}

function pf_checkLength(id,maxLength){
	var letterLength = $('#'+id).val().length;
	if(letterLength > maxLength){
		letterLength = maxLength;
	}
	var text = '(' + letterLength + '/' + maxLength +'자)'
		
	$('#'+id+"_length").text(text);
}

function pf_checkClassLength(obj,maxLength){
	var letterLength = $(obj).val().length;
	if(letterLength > maxLength){
		letterLength = maxLength;
	}
	var text = '(' + letterLength + '/' + maxLength +'자)'
		
	$(obj).next().text(text);
}

function pf_save(){
	if(!pf_checkVal()){
		return false;
	}
	
	var form = $('#insertForm')[0];
	var formData = new FormData(form);

	cf_loading();
	
	setTimeout(function(){
		$.ajax({
			type: "POST",
			url: "/dyAdmin/admin/domain/" + formActionType + "Ajax.do",
			processData: false,
            contentType: false,
			data: formData,
			async :false,
			success : function(key){
				cf_smallBox('ajax', '성공적으로 저장되었습니다.', 3000);
				pf_LinkPage();
                pf_insertDomain(key,$('#isPossibleDelete').val())
			},
			error: function(jqXHR, textStatus, errorThrown){
				cf_smallBox('ajax', '알수없는 에러 발생. 관리자한테 문의하세요.', 3000,'gray');
				cf_loading_out();
			}
	   }).done(function(){
		   cf_loading_out();
	   });
	},100)
	
}

function pf_checkVal(){
	
	if(!$('input[name=HM_USE_YN]:checked').val()){
		cf_smallBox('validate', '사용여부를 선택하여주세요.', 3000,'#d24158');
		$('input[name=HM_USE_YN]').focus();
		return false;
	}
	
	if(!$('#MN_NAME').val()){
		cf_smallBox('validate', '홈페이지명을 선택하여주세요.', 3000,'#d24158');
		$('#MN_NAME').focus();
		return false;
	}
	
	if(!$('#MN_ORDER').val()){
		cf_smallBox('validate', '정렬순서를 입력하여주세요.', 3000,'#d24158');
		$('#MN_ORDER').focus();
		return false;
	}
	
	if(!$('#HM_TITLE').val()){
		cf_smallBox('validate', '홈페이지 타이틀명을 입력하여주세요.', 3000,'#d24158');
		$('#HM_TITLE').focus();
		return false;
	}
	
	var formCheck = false;
	
	if(formActionType == 'insert'){
		if(!pf_checkPathUrl('HM_TILES','시작 URL','U',/^[a-z0-9_+]*$/)){
			formCheck = true;
			return false;
		}
		if(!pf_checkPathUrl('HM_SITE_PATH','사이트 경로','P',/^([_]{1}[A-Z0-9\d_]+)$/)){
			formCheck = true;
			return false;
		}
	}else{
		if(!pf_checkPathUrl('HM_TILES','시작 URL','U',/^[a-z0-9_+]*$/)){
			formCheck = true;
			return false;
		}
	}
	
	$('.HAM_DEFAULT_URL').each(function(){
		if(!formCheck){
			var defaultUrl = $(this).val();
			if(defaultUrl){
				if(!defaultUrl.startsWith('/')){
					formCheck = true;
					cf_smallBox('validate', '/로 시작되어야됩니다.', 3000,'#d24158');
					$(this).focus();
				}else{
					var regType = /^([/]{1}[A-Za-z0-9\d_]+)+\.do$/
					if(!regType.test(defaultUrl)){
						cf_smallBox('validate', 'url이 규칙에 맞지 않습니다.', 3000,'#d24158');
						$(this).focus();
						formCheck = true;
					}
				}
			}
		}
	});
	
	if(formCheck){
		return false;
	}
	
	return true;
}


function pf_checkPathUrl(id,msg,type,urlRegType){
	var formSubCheck = true;
	var valueName = $('#'+id).val();
	var errorMsg = msg+'은 영어 소문자와 숫자만 가능합니다.';
	var ckValue = 'common'; 
	
	if(type == 'P'){
		errorMsg = msg+'는 _(언더바)로 시작하고 영어 대문자와 숫자만 가능합니다.';
		ckValue = '_COMMON';
	}
	
	if(!valueName){
		cf_smallBox('validate', msg+'을/를 입력하여주세요.', 3000,'#d24158');
		$('#'+id).focus();
		formSubCheck = false;
	}
	
	if(formSubCheck && !urlRegType.test(valueName)){
		cf_smallBox('validate', errorMsg, 3000,'#d24158');
		$('#'+id).focus();
		formSubCheck = false;
	}
	
	if(formSubCheck && valueName == ckValue){
		cf_smallBox('validate', 'common 외의 값을 등록하세요.', 3000,'#d24158');
		$('#'+id).val('');
		$('#'+id).focus();
		formSubCheck = false;
	}
	
	if(formSubCheck){
		if(type == 'U' && $('#tilesBefore').val() == valueName){
			return true;
		}
		$.ajax({
	     	type: "POST",
	        url: "/dyAdmin/admin/domain/checkTilesNameAjax.do",
	        data: {
	        	"value":valueName,
				"type" : type	        	
	        },
		    async:false,
	        success : function(result){
	          if(result == 'F'){
	        	  formSubCheck = false;
	          }
	        }, 
	        error: function(){
	        	formSubCheck = false;
	        }
	    });
		
		if(!formSubCheck){
			cf_smallBox('validate', '중복되거나 사용할수없는 '+msg+'입니다.', 3000,'#d24158');
			$('#'+id).focus();
			formSubCheck = false;
		}
	}

	return formSubCheck;
}

function pf_delete(){
	
	if(confirm('정말 삭제하시겠습니까?')){
		cf_loading();
		
		setTimeout(function(){
			$.ajax({
				type: "POST",
				url: "/dyAdmin/admin/domain/deleteAjax.do",
				data: {
					"HM_KEYNO" : $('#HM_KEYNO').val()
				},
				async :false,
				success : function(data){
					cf_smallBox('ajax', '성공적으로 삭제되었습니다.', 3000);
					pf_togleArticle('N');
					pf_LinkPage();
				},
				error: function(jqXHR, textStatus, errorThrown){
					cf_smallBox('ajax', '알수없는 에러 발생. 관리자한테 문의하세요.', 3000,'gray');
				}
		   }).done(function(){
			   cf_loading_out();
		   });
		},100)
	}
}


</script>