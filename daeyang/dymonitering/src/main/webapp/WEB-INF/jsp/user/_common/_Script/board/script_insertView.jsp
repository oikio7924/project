<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script type="text/javascript">
//전역변수선언
var plus = '<c:out value = "${BoardType.BT_HTMLMAKER_PLUS_YN}"/>';
var boardDetailCk = false;
var personalY = '${BoardType.BT_PERSONAL_YN }';
var webEditUseYn = true; 
var action = '${action}';
var isAdmin = '${userInfo.isAdmin}'; 

$(function(){

	if(plus != 'Y') webEditUseYn = false;
	
	if('${BoardType.BT_DETAIL_KEYNO}' != 'no' ) boardDetailCk = true;
	
	$('.BD_DATA_CALENDAR,#BN_IMPORTANT_DATE,.BD_DATA_CALENDAR_START,.BD_DATA_CALENDAR_END').datepicker(datepickerOption);
	
	if($('.BD_DATA_CALENDAR_START').length > 0){
		if($('.BD_DATA_CALENDAR_END').length > 0){
			$('.BD_DATA_CALENDAR_START').on('change', function(){
				$('.BD_DATA_CALENDAR_END').datepicker('option', 'minDate', $(this).val());
			});
		}
	}
	
	if($('.BD_DATA_CALENDAR_END').length > 0){
		if($('.BD_DATA_CALENDAR_START').length > 0){
			$('.BD_DATA_CALENDAR_END').on('change', function(){
				$('.BD_DATA_CALENDAR_START').datepicker('option', 'maxDate', $(this).val());
			});
		}
	}
	
	if(action == 'insert'){
		$('#BN_IMPORTANT_DATE').datepicker('option','minDate',cf_getToday());
	}
	
    if(action == 'update' || "${BoardType.BT_KEYNO}" == "${PreBoardType.BT_KEYNO}" ){
    	pf_initColumnData("${BoardNotice.BN_KEYNO }")
    	cf_radio_checked("BN_SECRET_YN", "${BoardNotice.BN_SECRET_YN }");
    	if(isAdmin == 'Y'){
    		cf_radio_checked("BN_IMPORTANT", "${BoardNotice.BN_IMPORTANT }");
    	}
    }
    
});


function pf_checkOption(obj){
	var checkval = "";
	var $checked = $(obj).parent().parent().find("input[type=checkbox]:checked");
	$checked.each(function(i){
		if(i < $checked.length-1){
			checkval += $(this).val() + "|";
		}else{
			checkval += $(this).val();
		}
	})
	$(obj).parent().parent().find("input[name='BD_DATA']").val(checkval)
}

function pf_radioOption(obj){
	$(obj).parent().parent().find("input[name='BD_DATA']").val($(obj).val())
}


function pf_formCheck(){
	
	//상세내용 사용하고 웹에디터 사용시 내용 textarea로 복사
	if(boardDetailCk && webEditUseYn){
		editor_object.getById["BN_CONTENTS"].exec("UPDATE_CONTENTS_FIELD", []);
	}
	
	var userInfo = '${userInfo.UI_ID}';
	if(action == 'insert'){
		if(!userInfo){ // 비회원일시
			if(!$("#BN_NAME").val()){
				alert('작성자를 입력하여주세요.');
				$("#BN_NAME").focus();
				return false;
			}else{
				$('#BN_REGNM').val($("#BN_NAME").val());
			}
			if(!$("#BN_PWD").val()){
				alert('비밀번호를 입력하여주세요.');
				$("#BN_PWD").focus();
				return false;
			}
		}
	}
	if(isAdmin == 'Y'){
		/* if(!cf_radio_check_val("BN_IMPORTANT")){
			alert("공지사용을 선택해주세요");
			return false;
		} */
	}
	
		if($("select#BN_CATEGORY_NAME").val()=="전체"){
			$("#BN_CATEGORY_NAME").focus()
			alert("카테고리를 선택해주세요");
			   return false;
		}
	
	var state = false;
	$('.BD_TYPE_VALIDATE').each(function(){ //필수 항목들 널체크
		if(!state){
			if($(this).data('type') == 'check' || $(this).data('type') == 'radio'){
				var length = $(this).parent().find('input[name^=BD_DATA]:checked').length;
				if(length < 1){
					alert($(this).data('title')+'을 선택하여주세요.');
					$(window).scrollTop($(this).parent().find('input[name^=BD_DATA]').eq(0).next().offset().top - 100)
					state = true;
				}
			}else if(!$(this).val().trim()){
				alert($(this).data('title')+'을 입력하여주세요.');
				$(this).focus();
				state = true;
			}
		}
	});
	
	if(state){
		return false;
	}
	
	$('.BD_DATA_EMAIL').each(function(){ //이메일 형식 체크
		var value = $(this).val();
		
		if(!state && value && !/^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i.test( value )){
			alert($(this).data('title')+'의 이메일 형식이 올바르지 않습니다.');
			$(this).focus();
			state = true;
		}
	});
	
	if(state){
		return false;
	}
	
	$('.BD_DATA_CALENDAR, .BD_DATA_CALENDAR_END, .BD_DATA_CALENDAR_START').each(function(){
		var value = $(this).val();
		if(!state && value && !/^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/.test( value )){
			alert($(this).data('title')+'의 날짜 형식이 올바르지 않습니다.(YYYY-MM-DD)');
			$(this).focus();
			state = true;
		}
	})
	
	if(state){
		return false;
	}
	
	if("${BoardType.BT_THUMBNAIL_YN}" == "Y"){
		if( action == 'insert' || ((action == 'update' || action == 'move' ) && !$('#BN_THUMBNAIL').val()) ){
			//갤러리형
			if("${BoardType.BT_THUMBNAIL_INSERT}" == "N"){
				if(!$("#thumbnail").val()){
					alert("썸네일 이미지를 선택해주세요");
					return false;
				}	
			}
		}
	}

	if("${BoardType.BT_SECRET_YN }" == "Y"){
		if(!cf_radio_check_val("BN_SECRET_YN")){
			alert("비밀글 사용여부를 선택해주세요");
			return false;
		}		
	}
	
	
	if(boardDetailCk){	//상세내용사용시
		var BN_CONTENTS = $("#BN_CONTENTS").val();
		if( BN_CONTENTS == ""  || BN_CONTENTS == null || BN_CONTENTS == '&nbsp;' || BN_CONTENTS == '<p>&nbsp;</p>')  {
	         alert("내용을 입력하세요.");
	         if(webEditUseYn) editor_object.getById["BN_CONTENTS"].exec("FOCUS"); //에디터 포커싱
	         else  $("#BN_CONTENTS").focus();	//textarea 포커싱
	         return false;
	    }
		
		//금지어 설정 시
		if ("${BoardType.BT_FORBIDDEN_YN}" == "Y"){
			if(!pf_chkForbidden(BN_CONTENTS)) return false;
		}
		
	}
	
	if('${currentMenu.MN_GONGNULI_YN}' == 'Y'){
		$('#BN_GONGNULI_TYPE').val($('input[name="rgt_type_code"]:checked').val())
	}
	
	
	return true;
}

function pf_chkForbidden(contents){
	var chk = false;
		$.ajax({
			type   	: "post",   
			url    	: "/user/Board/forbiddenAjax.do",
			data:  {
				"BN_CONTENTS" : contents,
				"BT_KEYNO" : '${BoardType.BT_KEYNO}'
			},
			async  : false,
			success : function(data){
				if(data.length > 0){
					var forb_word_list = [];
					$.each(data,function(i){
						forb_word_list.push('"'+data[i]+'"');
					})
					alert(forb_word_list.join(", ") + "은(는) 금지어입니다. 등록할 수 없습니다.");
				}else{
					chk = true;
				}
			},
			error: function(jqXHR, exception) {
		       	alert('error')
			}
		});
	return chk;
}

var PersonalFilterArr = new Array();

function pf_getNewBoardKey(){
	if(!$('#BN_KEYNO').val()){
		$.ajax({
			type   	: "post",   
			url    	: "/commn/boardKey/selectAjax.do",
			async  : false,
			success : function(result){
				$('#BN_KEYNO').val(result);
			},
			error: function(jqXHR, exception) {
		       	alert('error')
			}
		});
	}
}

function pf_boardDataAction(){
	
	PersonalFilterArr = new Array();
	
	var psCk = false;
	
	$("#BN_UPLOAD .ajax-file-upload-statusbar").each(function(i){
		if($(this).find('input[name=personalCk]').val() == 'Y') psCk = true;
	});
	
	var msg = "";
	
	if(action == "move"){
		msg = "게시물을 이동하시겠습니까?";
	}else if(action == "insert"){
		msg = "게시물을 생성하시겠습니까?";
	}else {
		msg = "게시물을 수정하시겠습니까?";
	}
	
	if(!pf_formCheck()){
		return false;
	}
	
	
 	if(boardDetailCk && personalY == 'Y'){
 		if(!pf_PersonalCheck()) {
 			$('#page_comment').dialog('open');  //개인정보필터 체크창
			 return false;
		}
	}  
 
	if(confirm(msg)){
		
		if(psCk){
			$('#PersonalConfirm_attachment').dialog('open');
			return false;
		}
		
		cf_loading();

		if(action == "insert") pf_getNewBoardKey();

		if($('#BN_KEYNO').val()){
			
			if( typeof fn_fileSubDelete == 'function' && !fn_fileSubDelete() ){ // 첨부파일 삭제 있으면 삭제처리
				return false;
			} 

			var fCnt = $("#BN_UPLOAD .cancle_hidden").length; //저장되기 전 파일 갯수
		
			if($('#BN_FM_KEYNO').val()) {	//BN에 FM키값 있을 경우 키값 넣어줌
				$('#FM_KEYNO').val($('#BN_FM_KEYNO').val());
			}
			if(fCnt > 0){
				successNewFile();
			}else{
				pf_checkFile();
			}
		}
		
	}else{
		exit();
	}
}

function pf_checkFile(){
	var saveFileCnt = $("#BN_UPLOAD .ajax-file-upload-statusbar").length;	//저장된 파일 갯수
	//첨부파일이 없다면 FM키 삭제
	if(saveFileCnt < 1) $('#FM_KEYNO').val('');	
	
	if( typeof updateFileInfo == 'function' ) {
		updateFileInfo(success);
	}else{
		success();
	}
}


function success(){
	if(action == 'insert'){
		$("#Form").attr("action", "${tilesUrl }/BoardData/action.do?${_csrf.parameterName}=${_csrf.token}");
	}else if(action == 'update'){
		$("#Form").attr("action", "${tilesUrl }/BoardData/action.do?${_csrf.parameterName}=${_csrf.token}");
	}else if(action == 'move'){
		$("#Form").attr("action", "${tilesUrl }/Board/data/move.do?${_csrf.parameterName}=${_csrf.token}");
	}else{
		alert('오류발생 : action값 없음');
		return false;
	}
	$("#Form").submit();
}
function exit(){
	alert("취소되었습니다.");
	return false;
}


function pf_initColumnData(BN_KEYNO){
	cf_loading();
	$.ajax({
		type: "POST",
		url: "${tilesUrl }/BoardData/updateView/listAjax.do",
		data: "BD_BN_KEYNO="+BN_KEYNO,
		success : function(result){
			cf_loading_out();
			for(var i = 0; i < result.length; i++){
				$("#BD_KEYNO"+result[i].BD_BL_KEYNO).val(result[i].BD_KEYNO);
				if(result[i].BD_BL_TYPE == '${sp:getData("BOARD_COLUMN_TYPE_CHECK")}' || result[i].BD_BL_TYPE == '${sp:getData("BOARD_COLUMN_TYPE_CHECK_CODE")}'){
					cf_checkbox_checked("BD_DATA"+result[i].BD_BL_KEYNO, result[i].BD_DATA.split('|'))
				}else if(result[i].BD_BL_TYPE == '${sp:getData("BOARD_COLUMN_TYPE_RADIO")}' || result[i].BD_BL_TYPE == '${sp:getData("BOARD_COLUMN_TYPE_RADIO_CODE")}'){
					cf_radio_checked("BD_DATA"+result[i].BD_BL_KEYNO, result[i].BD_DATA)
				}else if(result[i].BD_BL_TYPE == '${sp:getData("BOARD_COLUMN_TYPE_CHECK_CODE")}'){
					cf_radio_checked("BD_DATA"+result[i].BD_BL_KEYNO, result[i].BD_DATA)
				}
				$("#BD_DATA"+result[i].BD_BL_KEYNO).val(result[i].BD_DATA)
			}
		},
		error: function(){
			cf_loading_out();
			cf_alert("예상치못한 오류가 발생했습니다.");
			return false;
		}
	});
}

function pf_back(){
	if($('#category').val() != ''){
		location.href="${mirrorPage }?category=${category}";
	}else{
		location.href="${mirrorPage }"
	}
}

function pf_ClipBoard(obj){
	var select_input = $(obj).parent().parent().find(".column_data");
	
	if(cf_copyToClipboard(select_input.val())){
		alert("값이 복사되었습니다.")
	}else{
		alert("복사하기 기능을 지원하지 않는 브라우저 입니다.")
	}
}

function pf_adjust(id, bl_type, data){
	var bl_keyno = $('#'+id).val();
	
	if(bl_keyno){
		var select_bool = true;
	
		if(bl_type == '${sp:getData("BOARD_COLUMN_TYPE_CHECK")}' || bl_type == '${sp:getData("BOARD_COLUMN_TYPE_CHECK_CODE")}'){
			cf_checkbox_checked_prop("BD_DATA"+bl_keyno, data.split('|'))
		}else if(bl_type == '${sp:getData("BOARD_COLUMN_TYPE_RADIO")}' || bl_type == '${sp:getData("BOARD_COLUMN_TYPE_RADIO_CODE")}'){
			cf_radio_checked("BD_DATA"+bl_keyno, data)
		}else if(bl_type == '${sp:getData("BOARD_COLUMN_TYPE_SELECT")}' || bl_type == '${sp:getData("BOARD_COLUMN_TYPE_SELECT_CODE")}'){
			//셀렉트 박스 해당 값 있는지 없는지 체크
			select_bool = 0 != $('#BD_DATA' + bl_keyno + ' option[value='+data+']').length;
		}
		
		if(select_bool){
			$("#BD_DATA"+bl_keyno).val(data);
		}
		
	}else{
		alert("선택된 데이터가 없습니다.");
	}
}

//썸네일 삭제
function thumnail_delete(key){
	if(key){
		$.ajax({
			type : "post",
			url : "/user/Board/delectAjax.do",
			data: {
				"BN_KEYNO" : key
			},
			success: function(data){
				$('#thumbnail_img').attr('src','');
				$('#BN_THUMBNAIL').val('');
			},
			error: function(){
				alert("삭제 중 에러");
			}
		});
	}else{
		$('#thumbnail').val('');
		cf_imgCheckAndPreview('thumbnail');
	}
	
}

/* function allimtalk(){
	$.ajax({
		type : "post",
		url : "/allimTalkAjax.do",
		data: {
			"" : key
		},
		success: function(data){
			$('#thumbnail_img').attr('src','');
			$('#BN_THUMBNAIL').val('');
		},
		error: function(){
			alert("삭제 중 에러");
		}
	});
}
 */
</script>
