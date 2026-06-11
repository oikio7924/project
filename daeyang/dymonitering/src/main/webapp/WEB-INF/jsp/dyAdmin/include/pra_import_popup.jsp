<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<style>
.paddingthin{padding: 2px 6px;}
.padding0{padding: 0;}
</style>

<div id="import-popup" title="import 등록">
	<form:form id="insertForm" action="" method="post" style="height: 300px;">
	<div class="widget-body">
		<div class="form-horizontal">
			<div class="form-group">
				<label class="col-md-3 control-label"><span class="nessSpan">*</span> import 목록</label>
				<div class="col-md-6">
					<select class="form-control input-sm select2" id="importSelect" name="importSelect">
						<option value="">선택하세요.</option> 
					</select>
				</div>
			</div>
		</div>
	</div>
	</form:form>
</div>


<script src="/resources/smartadmin/js/plugin/select2/select2.min.js"></script>
<script type="text/javascript">

$(document).ready(function() {
	$('#importSelect').select2();
	cf_setttingDialog('#import-popup','import 등록','등록','pf_ImportInsert()');
});

var ourside;
function pf_openPopup(){
	ourside = editor.getCursor().outside;
	$('#import-popup').dialog('open');
	$('#importSelect').val('');
	$('#importSelect').select2({
		dropdownParent : $('#import-popup')
	});
	pf_getImportList();
}

function pf_getImportList(){
	$.ajax({
	    type   : "post",
	    url    : "/dyAdmin/homepage/layout/importListAjax.do",
	    async : false,
	    success:function(data){
	    	if(data.length > 0){
	    		var temp = '<option value="">선택하세요.</option>';
	    		$.each(data,function(i){
	    			temp += '<option value="'+data[i].KEYNO+'" data-path="'+data[i].PATH+'">'+data[i].TYPE+' - '+data[i].TITLE+'</option>';
	    		});
    			$('#importSelect').html(temp);
	    	}
	    },
	    error: function() {
	    	cf_smallBox('error', '에러!! 관리자한테 문의하세요', 3000,'#d24158'); 
	    }
    });
}

function pf_ImportInsert(){
	var key = $('select[name="importSelect"]').val();
	if(key){
		var path = $('select[name="importSelect"] option:checked').data('path');
		var content = '&lt;c:import url="/common'+path+'UserViewAjax.do?key='+key+'"/&gt;';
			content = content.unescapeHtml();
		var cursor;
		if(ourside == 'true'){
			cursor = editor.setCursor(0,0);
		}else{
			cursor = editor.getCursor();
		}
		editor.replaceRange(content,cursor);
		editor.focus();
		editor.setCursor(cursor);
		$('#import-popup').dialog("close");
	}else{
		cf_smallBox('form', 'import값을 선택하세요.', 3000,'#d24158'); 
		$('#importSelect').focus();
		return false;
	}
}

</script>
