<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script>
$(function(){
	pf_changeDethMenu();
});

function pf_changeDethMenu(){
	$('#dethSubMenuKey').select2({ width: '100%' });
	var val = $('#dethSubMenuKey option:selected').val();
	var url = $('#dethSubMenuKey option:selected').data('url');
	$('#dethCHANGEYN').val(val != '${resultData.MN_MAINKEY}');
	$('#dethpreURL').text(url+'/');
}

function pf_deth_Input_Check(){
	if(!$('#dethchangeURL').val()){
		cf_smallBox('Form', '변경 URL을 입력해주세요.', 3000,'#d24158');
		$('#dethchangeURL').focus();
		return false; 
	}else{
		var regType;
		  if($('#dethPageDiv').val() == '${sp:getData("MENU_TYPE_SUBMENU")}'){ //소메뉴형
		  	regType = /^[A-Za-z0-9+]{1,50}$/; 
		  }else{
		  	regType = /^[A-Za-z0-9+]{1,50}\.do$/;
		  }
		if(!regType.test($('#dethchangeURL').val())){
		  cf_smallBox('Form', 'url이 규칙에 맞지 않습니다.', 3000,'#d24158');
		  $("#dethchangeURL").focus();
		  return false;
		}
		
		var changeUrl = $('#dethpreURL').text();
		changeUrl = changeUrl + $("#dethchangeURL").val();
		if(!pf_urlCheck(changeUrl, '${resultData.MN_KEYNO}')){
	    	cf_smallBox('Form', 'URL이 중복됩니다.  다른 URL을 입력 해 주세요.', 3000,'#d24158');
			$("#dethchangeURL").focus();
	    	return false;
	    }else{
	    	$('#dethChUrl').val(changeUrl);
	    }
	}
	return true;
}
</script>
