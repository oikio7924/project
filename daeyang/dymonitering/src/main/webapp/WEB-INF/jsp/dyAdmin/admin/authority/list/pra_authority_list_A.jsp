<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>

.dd:after {clear:both;}
.dd3-handle {width:5px;padding: 9px 15px;background:none;}
.dd3-handle-group:before {color: #564f4f;content: 'G';font-weight: bold;}
.dd3-handle-authority:before {color: #f36565;content: 'A';font-weight: bold;font-size:14px;}

.dd3-content {padding: 6px 10px 6px 50px;}
.dd-nodrag .dd-handle:hover {cursor: auto;}
i.fa-gear {color:#b13266;}
.dd+.dd {margin-left:0 !important;}
.dd-input-readonly {background: inherit;border: 2px solid #fbfbfb;}
.dd3-title-input {padding:0;}
.checkbox, .radio {margin:0;}

</style>

<div class="pull-left" style="height:31px;">
	<label class="radio radio-inline">
		<input type="radio" class="radiobox style-3" name="authorityMode" value="setting" checked="checked">
		<span>권한 설정 모드</span> 
		
	</label>
	<label class="radio radio-inline">
		<input type="radio" class="radiobox style-3" name="authorityMode" value="modify">
		<span>수정 모드</span>  
	</label>
</div>

<div class="text-align-right pull-right authorityModifyBtn" style="display:none;">
	<div class="btn-group">  
		<button class="btn btn-sm btn-primary" type="button" onclick="pf_addAuthority('G')">
			<i class="fa fa-plus"></i> 그룹
		</button>
		<button style="margin-left:5px;" class="btn btn-sm btn-primary" type="button" onclick="pf_addAuthority('A')">
			<i class="fa fa-plus"></i> 권한
		</button> 
	</div>
</div>


<div style="clear:both;"></div>
<form:form id="authorityListForm">

<div class="dd">
	<ol class="dd-list" id="dd-list-root-system">
		
	</ol>
</div>
<div class="dd" id="nestable3">
	<ol class="dd-list" id="dd-list-root">
		
	</ol>
</div>
<div style="clear:both;"></div>
</form:form>

<script src="/resources/api/nestable2/1.6.0/jquery.nestable.js"></script>

<!-- <script src="/resources/smartadmin/js/plugin/jquery-nestable/jquery.nestable.min.js"></script> -->
<script>

var nestableCount = 0;

//슈퍼관리자는  항상 어디든 접근가능하다.
//고로 여기서는 불러오지 않는다
//메뉴별 권한 처리할때 슈퍼관리자는 항상 추가해준다. 

var authorityMode = '';

$(function(){
	
	$('input[name=authorityMode]').on('change',function(){
		pf_authorityModeChange($(this).val());
		
	}).eq(0).trigger('change');
})


function pf_authorityModeChange(mode){
	
	authorityMode = mode;
	
	$('.dd > .dd-list').html('');
	
	pf_netstable();
	
	if(mode == 'setting'){
		$('.authorityModifyBtn').hide();
	}else{
		$('.authorityModifyBtn').show();
	}
	
	pf_getMenuList();
	
}



function pf_netstable(){
	
	var checkSuccess = true;
	$.ajax({
		type: "POST",
		url: "/dyAdmin/admin/authority/dataAjax.do",
		async: false,
		success : function(data){
		  	$.each(data,function(i){
		  		var param = {
		  				'UIA_KEYNO'		:	data[i].UIA_KEYNO,	
		  				'UIA_NAME'		:	data[i].UIA_NAME,
		  				'UIA_SYSTEM'	:	data[i].UIA_SYSTEM,
		  				'UIA_MAINKEY'	:	data[i].UIA_MAINKEY,
		  				'UIA_DEPTH'		:	data[i].UIA_DEPTH,	
		  				'UIA_ORDER'		:	data[i].UIA_ORDER,	
		  				'UIA_DIVISION'	:	data[i].UIA_DIVISION,	
		  				'title'			:	data[i].UIA_NAME
	  			}
		  		
		  		pf_addAuthority(data[i].UIA_DIVISION,'',param)
		  	})
		}, error: function(){
	        cf_smallBox('error', '리스트 가져오기 에러', 3000,'#d24158');
	        checkSuccess = false;
		}
	});
	
	if(!checkSuccess){
		return;
	}
	
	<c:forEach items="${systemAuthorityList }" var="model">
	<c:if test="${model.UIA_KEYNO eq sp:getData('AUTHORITY_ANONYMOUS')}">
	//비회원 추가
	var param_anonymous = {
		'UIA_KEYNO'		:	'${model.UIA_KEYNO}',	
		'UIA_NAME'		:	'${model.UIA_NAME}',
		'UIA_SYSTEM'	:	'${model.UIA_SYSTEM}',
		'UIA_MAINKEY'	:	'${model.UIA_MAINKEY}',	
		'UIA_DEPTH'		:	'${model.UIA_DEPTH}',	
		'UIA_ORDER'		:	'${model.UIA_ORDER}',	
		'UIA_DIVISION'	:	'${model.UIA_DIVISION}',	
		'title'	:	'비회원'
	}
	pf_addAuthority('A','',param_anonymous);
	</c:if>
	</c:forEach>
	
	
	if(authorityMode == 'modify'){
		$('#nestable3').nestable();	
	}else{
		$('#nestable3').nestable('destroy')
	}
	
	
}
	
function pf_addAuthority(type,obj,param){
	
	var showMsg = true;
	if(param){
		showMsg = false;
	}	
	param = param || {};
	param.UIA_KEYNO = param.UIA_KEYNO || (++nestableCount);
	param.UIA_NAME = param.UIA_NAME || '';
	param.UIA_SYSTEM = param.UIA_SYSTEM || 'N';
	param.UIA_MAINKEY = param.UIA_MAINKEY || '';
	param.UIA_DEPTH = param.UIA_DEPTH || '';
	param.UIA_ORDER = param.UIA_ORDER || '';
	param.UIA_DIVISION = param.UIA_DIVISION || type;
	param.title = param.title || '제목 없음' 
	
	
	var ol;
	if(obj){
		var item = $(obj).closest('.dd-item');
		if(item.find(' > ol').length == 0 ){
			item.append('<ol class="dd-list"></ol>');
			item.prepend('<button class="dd-expand" data-action="expand" type="button" style="display:none;">Expand</button>');
			item.prepend('<button class="dd-collapse" data-action="collapse" type="button">Collapse</button>');
		}
		ol = item.find(' > ol');
	}else if(param.UIA_MAINKEY){
		
		var item = '';
		
		$('.dd-item').each(function(){
			if(!item){
				var id = $(this).data('id');
				if(id == param.UIA_MAINKEY){
					item = $(this);
				}
			}
		})
		
		if(item){
			if(item.find(' > ol').length == 0 ){
				item.append('<ol class="dd-list"></ol>');
				item.prepend('<button class="dd-expand" data-action="expand" type="button" style="display:none;">Expand</button>');
				item.prepend('<button class="dd-collapse" data-action="collapse" type="button">Collapse</button>');
			}
			ol = item.find(' > ol');
		}else{
			ol = $('#dd-list-root');
		}
	}else{
		ol = $('#dd-list-root');
	}
	
	var addCount;
	var noDrag ='';
	var titleReadOnly = '';
	var titleREadOnlyClass= '';
	var systemClass = '';
	if(param.UIA_SYSTEM == 'Y' || param.UIA_SYSTEM == 'P' || authorityMode == 'setting'){
		noDrag = 'dd-nodrag';
		titleReadOnly = 'readonly';
		titleREadOnlyClass= 'dd-input-readonly readonly';
	}
	
	if(param.UIA_SYSTEM == 'Y'){
		ol = $('#dd-list-root-system');
	}
	
	if(param.UIA_SYSTEM == 'P' || param.UIA_SYSTEM == 'Y'){
		systemClass = 'dd3-content-system';
	}
	
	var handleClass='';
	var noChildren = '';
	if(type == 'G'){
		handleClass = 'dd3-handle-group';
	}else{
		handleClass = 'dd3-handle-authority';
		noChildren = 'dd-nochildren';
	}
	
	var temp = 
		'<li class="dd-item dd3-item '+noChildren+' '+noDrag+'" data-id="'+param.UIA_KEYNO+'" data-type="'+type+'">' +
		'	<div class="dd-handle dd3-handle ' + handleClass + '">&nbsp;</div>' +
		'	<div class="dd3-content '+systemClass+'">' + 
		'		<input class="dd3-title-input '+titleREadOnlyClass+'" type="text" name="title" value="'+param.title+'" '+titleReadOnly+'>'; 
	if(authorityMode == 'setting'){		
		temp +=
		'		<div class="pull-right">' +
		'		<a href="javascript:;" onclick="pf_getMenuList(\''+param.UIA_KEYNO+'\',this);" class="showMenuList" title="메뉴 리스트 불러오기"><i class="fa fa-fw fa-lg fa-th-list"></i></a>' +
		'		</div>';
	}else{
		temp +=
		'		<div class="pull-right dropdown">' + 
		'			<a href="#" class="dropdown-toggle" data-toggle="dropdown" aria-expanded="false"><i class="fa fa-fw fa-lg fa-gear"></i></a>' + 
		'			<ul class="dropdown-menu" role="menu">'; 
		if(type == 'G'){
		temp +=
		'				<li><a href="javascript:;" onclick="pf_addAuthority(\'G\',this)">하위 그룹 추가</a></li>' + 
		'				<li><a href="javascript:;" onclick="pf_addAuthority(\'A\',this)">하위 권한 추가</a></li>';
		}
		if(param.UIA_SYSTEM == 'N'){
		temp +=
		'				<li class="divider"></li>' + 
		'				<li><a href="javascript:;" onclick="pf_removeAuthority(this)">삭제</a></li>'; 
		}
		temp +=
		'			</ul>' +
		'			<div class="dd-inputBox">' +			
		'				<input type="hidden" name="UIA_KEYNO" value="'+param.UIA_KEYNO+'">' +
		'				<input type="hidden" name="UIA_NAME" value="'+param.UIA_NAME+'">' +
		'				<input type="hidden" name="UIA_SYSTEM" value="'+param.UIA_SYSTEM+'">' +
		'				<input type="hidden" name="UIA_MAINKEY" value="'+param.UIA_MAINKEY+'">' +
		'				<input type="hidden" name="UIA_DEPTH" value="'+param.UIA_DEPTH+'">' +
		'				<input type="hidden" name="UIA_ORDER" value="'+param.UIA_ORDER+'">' +
		'				<input type="hidden" name="UIA_DIVISION" value="'+param.UIA_DIVISION+'">' +
		'			</div>' +
		'		</div>' +
		'	</div>' +
		'</li>';
		
	}
		
	ol.append(temp);
	
	
}


function pf_removeAuthority(obj){
	
	var type = $(obj).closest('.dd-item').data('type');
	//var name = $(obj).closest('.dd-item').find('input[name=title]').val();
	//var msg = type == 'G' ? '그룹('+name+')과 하위 그룹이 삭제되었습니다.' : '권한('+name+')이 삭제되었습니다.';
	
	//그룹일 경우 하위 권한은 삭제하지 않는다.
	if(type == 'G'){
		var thisItem = $(obj).closest('.dd-item');
		thisItem.find('.dd-item').each(function(){
			if($(this).data('type') == 'A'){
				thisItem.before($(this));
			}
		})
	}
	
	var length = $(obj).closest('.dd-list').children('li').length;
	if(length == 1){
		$ddList = $(obj).closest('.dd-list'); 
		$ddList.closest('.dd-item').children('button').remove();
		$ddList.remove();
	}else{
		$(obj).closest('.dd-item').remove();	
	}
	
	//cf_smallBox('권한', msg, 3000,'#739e73');
	
}

function pf_saveAuthority(){
	
	if(!pf_checkAuthorityTitle()){
		return false;
	}
	
	cf_loading();
	
	setTimeout(function(){
		pf_settingAuthorityData($('#dd-list-root'),1,'');
		
		$.ajax({
			type: "POST",
			url: "/dyAdmin/admin/authority/saveAjax.do",
			async: false,
			data : $('#authorityListForm').serializeArray(),
			success : function(data){
				cf_smallBox('권한', '변경된 권한 및 그룹이 저장되었습니다.', 3000,'#739e73');
				pf_listview('A');
			}, error: function(){
		        cf_smallBox('error', '리스트 가져오기 에러', 3000,'#d24158');
		        cf_loading_out();
			}
		});
	},100)
	
	
}

//권한,그룹 이름 중복 체크
function pf_checkAuthorityTitle(){
	var titleList = new Array();
	titleList.push('비회원');
	<c:forEach items="${systemAuthorityList }" var="model">
	titleList.push('${model.UIA_NAME}');
	</c:forEach>
	
	var checkDuplTitle = true;
	$('#dd-list-root input[name=title]').each(function(){
		if(checkDuplTitle){
			var title = $(this).val();
			if(titleList.includes(title)){
				cf_smallBox('이름 중복', '['+title+'] 중복됩니다. 확인하여주세요.', 3000,'#d24158');
				$(this).focus();
				checkDuplTitle = false;
			}else{
				titleList.push(title);
			}
		}
	})
	
	return checkDuplTitle;
	
}

//권한,그룹 값 셋팅
function pf_settingAuthorityData(obj,depth,mainkey){
	
	$(obj).children('li').each(function(i){
		var inputBox = $(this).children('.dd3-content').children('.dropdown').children('.dd-inputBox');
		var title = $(this).children('.dd3-content').children('input[name=title]').val() 
		inputBox.children('input[name=UIA_NAME]').val(title);
		inputBox.children('input[name=UIA_MAINKEY]').val(mainkey);
		inputBox.children('input[name=UIA_DEPTH]').val(depth);
		inputBox.children('input[name=UIA_ORDER]').val(i+1);
		if($(this).children('ol').length > 0){
			var key = inputBox.children('input[name=UIA_KEYNO]').val();
			pf_settingAuthorityData($(this).children('ol'),depth+1,key);
		}
		
	})
}

</script>
