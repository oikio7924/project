<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script type="text/javascript">

var editor_object = [];
var fskey = '${popupData.PI_FS_KEYNO}';
var fsname = '${popupData.FS_ORINM}';
var popupCheckedDataMap = null;

//텍스트 관련 에디터 생성
$(function(){
	popupCheckedDataMap = new Map();
	
	<c:forEach items="${popupSubListData}" var="model" varStatus="status">
		popupCheckedDataMap.set('${model.MENUKEY}','${model.SUB_NAME}');
	</c:forEach>
		
	var data_check = $("input[type=radio][name=date_select]:checked").val()
	
	//메뉴리스트
	pf_getMenuList();
	
	$('#PI_STARTDAY').datepicker(datepickerOption);
	$('#PI_ENDDAY').datepicker(datepickerOption);
	//시작값을 현재 시간으로
	$('#PI_STARTDAY').datepicker({
		minDate : 0,
		dateFormat: "yy-mm-dd"
	});
	
	
	var msg = '${msg}';
	if(msg == '1'){
		cf_smallBox('Form', '성공적으로 등록되었습니다.', 3000);
	}
	
	nhn.husky.EZCreator.createInIFrame({
        oAppRef: editor_object,
        elPlaceHolder: "PI_CONTENTS",
        sSkinURI: "/resources/api/se2/se2Skin.html",
        htParams : {
            // 툴바 사용 여부 (true:사용/ false:사용하지 않음)
            bUseToolbar : true,            
            // 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
            bUseVerticalResizer : true,    
            // 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
            bUseModeChanger : true,
        },
        menuName : '팝업관리' //본문에 이미지 저장시 사용되는 캡션
    });
	
	
	$('#PI_STARTDAY').on('change',function(){
		$('#PI_ENDDAY').datepicker('option', 'minDate', $(this).val());
	});
	$('#PI_ENDDAY').on('change',function(){
		$('#PI_STARTDAY').datepicker('option', 'maxDate', $(this).val());
	});
	
	pf_date_use(data_check);	
	
	$('.popupType').hide();
	$('input[name=PI_TYPE]').on('change',function(){
		var type = $(this).val();
		changeType(type);
	});
	
	var piDiv = '${popupData.PI_DIVISION}'|| 'W'
	pf_popType(piDiv)
	if(piDiv == 'B'){
		var piType = '${popupData.PI_TYPE}' || 'A';
		if(piType == 'B'){
			pf_changeText($('#PI_COMMENT').val(),'C');
		}
		changeType(piType)
	}
	
	$('input[name=PI_BACKGROUND_COLOR]').on('change',function(){
		var type = $(this).val();
		if(type == 'N'){
			$('#view_background').css('background-image','');
		}else{
			var background = 'url("/resources/img/popup/background0'+type+'.jpg")';
			$('#view_background').css('background-image',background);
		}
	})
	
	$('#PI_TITLE_COLOR').colorpicker().on('changeColor',
            function(ev) {
		$('#view_title').css('color',ev.color.toHex());
    });
	$('#PI_COMMENT_COLOR').colorpicker().on('changeColor',
            function(ev) {
		$('#view_comment').css('color',ev.color.toHex());
    });
})

function pf_changeText(value,type){
	if(type == 'T'){
		$('#view_title').text(value);
	}else if(type == 'C'){
		value = value.replace(/(?:\r\n|\r|\n)/g, '<br>');
		$('#view_comment').html(value);
	}
}

function pf_popType(type){
	if(type == 'B'){
		$('.homePoptype').show();
		changeType('A');
	}else{
		$('.homePoptype').hide();
		changeType('W');
		$('#PI_CONTENTS-iframe').height($('#PI_CONTENTS').height() + 56);  	//에디터 높이 주기
	}
}

function changeType(type){
	$('.popupType').hide();
	$('.popupType'+type).show();
}

var status = false;
//팝업 시작날짜와 종료날짜 예외처리
function Popup_Save(){
	
	//팝업적용 메뉴 세팅
	pf_setSubDataArry();
	
	var type = $("input[name=PI_DIVISION]:checked").val();
	var data_check = $("input[type=radio][name=date_select]:checked").val()
	
	if(!Popup_CommonCheck()){return false;}
	if(type == 'W'){
		if(!Popup_checkFormW()){return false;}
	}else{
		if(!Popup_checkFormB('fileA')){return false;}
	}
	
	$("#PI_DIVISION").val(type)
	var data_check = $("input[type=radio][name=date_select]:checked").val()
	if(data_check == "N"){
		$("#PI_STARTDAY").attr("value","");
		$("#PI_ENDDAY").attr("value","기간없음");
	}
	if(status){
		cf_replaceTrim($("#frm"));
		$("#frm").submit();
	}
	return false;
} 


//팝업 시작날짜와 종료날짜 예외처리
function Popup_Update(){
	
	//팝업적용 메뉴 세팅
	pf_setSubDataArry();
	
	var type = $("input[name=PI_DIVISION]").val();
	
	if(!Popup_CommonCheck()){return false;}
	if(type == 'W'){
		if(!Popup_checkFormW()){return false;}
	}else{
		if(!Popup_checkFormB('fileA_text')){return false;}
	}
	
	cf_replaceTrim($("#frm"));
	var data_check = $("input[type=radio][name=date_select]:checked").val()
	
	if(data_check =="Y"){
		if(!pf_nullCheck(document.getElementById("PI_STARTDAY") , "시작날짜"  , "text")) return;
		if(!pf_nullCheck(document.getElementById("PI_ENDDAY") , "종료날짜"  , "text")) return;
	}
	if(data_check == "N"){
		$("#PI_STARTDAY").attr("value","")
		$("#PI_ENDDAY").attr("value","기간없음")
	}
	$("#frm").submit();
} 

function Popup_CommonCheck(){
	
	if(!pf_nullCheck(document.getElementById("PI_TITLE") , "제목"  , "text"))
	{
		return;
	}
// 	if(!pf_nullCheck(document.getElementById("PI_LINK") , "팝업 링크"  , "text")) return;
	/* if( !( $('#PI_LINK').val().startsWith('http://') || $('#PI_LINK').val().startsWith('https://') ) ){
		cf_smallBox('error', '링크는 http:// 나 https:// 로 시작되어야됩니다.', 3000,'#d24158');
		$('#PI_LINK').focus();
		return false;
	} */
	var data_check = $("input[type=radio][name=date_select]:checked").val()
	if(data_check =="Y"){
		if(!pf_nullCheck(document.getElementById("PI_STARTDAY") , "시작날짜"  , "text")) return;
		if(!pf_nullCheck(document.getElementById("PI_ENDDAY") , "종료날짜"  , "text")) return;
	}
	status = true;
	return true;
}


function Popup_checkFormW(){
	//웹에디터 내용 textarea로 복사
	editor_object.getById["PI_CONTENTS"].exec("UPDATE_CONTENTS_FIELD", []);
	
	if(!pf_nullCheck(document.getElementById("PI_TOP_LOC") , "상단"  , "text")) return;
	if(!pf_nullCheck(document.getElementById("PI_LEFT_LOC") , "왼쪽"  , "text")) return;
	if(!pf_nullCheck(document.getElementById("PI_WIDTH") , "넓이"  , "text")) return;
	if(!pf_nullCheck(document.getElementById("PI_HEIGHT") , "높이"  , "text")) return;
	
    if($('.popupTypeW').find('input[name=file_resize]').is(':checked')) $('#resize').val('Y');
	
	status = true;
	return true;
}

function Popup_checkFormB(id){
	
	var type = $('input[name=PI_TYPE]:checked').val();
	if(type == 'A'){
		var file = $('.popupType'+type).find('input[type=file][name=file]').val();
		if(!$("#"+id).val()){
			cf_smallBox('error', '팝업 이미지를 선택해주세요.', 3000,'#d24158');
			return;
		}
	}else if(type == 'B'){
		if(!pf_nullCheck(document.getElementById("PI_TITLE2") , "제목 문구"  , "text")) return;
		if(!pf_nullCheck(document.getElementById("PI_COMMENT") , "내용 문구"  , "text")) return;
		if(!$('#PI_TITLE_COLOR').val()){
			$('#PI_TITLE_COLOR').val('#8CC63E')
		}
		if(!$('#PI_COMMENT_COLOR').val()){
			$('#PI_COMMENT_COLOR').val('#ffffgf')
		}
	}
	
    if($('.popupTypeA').find('input[name=file_resize]').is(':checked')) $('#resize').val('Y');
	status = true;
	return true;
}

function Popup_Delete(){
	if(confirm('정말 삭제하시겠습니까?')){
		$.ajax({
			type: "POST",
			url: "/dyAdmin/homepage/popup/deleteAjax.do",
			data: "PI_KEYNO="+$('#PI_KEYNO').val(),
			async:false,
			success : function(data){
				cf_smallBox('Form', '성공적으로 등록되었습니다.', 3000);
				location.href='/dyAdmin/homepage/popup/popup.do';
			},
			error: function(){
				cf_smallBox('ajax', '알수없는 에러 발생. 관리자한테 문의하세요.', 3000,'gray');
				return false;
			}
		});
	}
}

//null check
function pf_nullCheck(obj, name, inputType){
	
	var str = "";
	
	if     (inputType == "text")	str = "입력";
	else if(inputType == "select")	str = "선택";
	if($.trim(obj.value) == ""){
		cf_smallBox('Form', name + "을(를) "+ str +"해주세요.", 3000,'#d24158');
		obj.value = "";
		obj.focus();
		
		return false;
	}else{
		return true;
	}
}
function pf_date_use(use){
	
	if(use == "Y"){
		$("#date_1").show();
		$("#date_2").show();
	}else{
		$("#date_1").hide();
		$("#date_2").hide();
		$("#PI_STARTDAY").attr("value","")
 		$("#PI_ENDDAY").attr("value","")
	}
}

function pf_getMenuList(){
	$.ajax({
		type: "POST",
		url: "/dyAdmin/homepage/popup/popup_menuListAjax.do",
		data: {
			"MN_HOMEDIV_C": $('#MN_HOMEDIV_C').val(),
			"pageName" : 'pra_popup_menuList'
		},
		success : function(data){
		  	$('#menuListWrap').html(data);
		}, error: function(){
			cf_smallBox('ajax', '메뉴 팝업 테이블 에러 발생. 관리자한테 문의하세요.', 3000,'gray');
		}
	});
}

</script>

