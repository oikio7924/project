/**
 * 모바일 구분
 */
var isMobile = {
        Android: function () {
                 return navigator.userAgent.match(/Android/i);
        },
        BlackBerry: function () {
                 return navigator.userAgent.match(/BlackBerry/i);
        },
        iOS: function () {
                 return navigator.userAgent.match(/iPhone|iPad|iPod/i);
        },
        Opera: function () {
                 return navigator.userAgent.match(/Opera Mini/i);
        },
        Windows: function () {
                 return navigator.userAgent.match(/IEMobile/i);
        },
        any: function () {
                 return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
        }
};

/**
 * ajax 시작/완료 공통 핸들링 
 **/
Date.prototype.format = function(f) {
    if (!this.valueOf()) return " ";
    
    if(!f){
    	var yyyy = this.getFullYear().toString();
        var mm = (this.getMonth() + 1).toString();
        var dd = this.getDate().toString();
        return yyyy + '-' + mm.zf(2) + '-' + dd.zf(2);
    }
    
    
    var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
    var d = this;
     
    return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {
        switch ($1) {
            case "yyyy": return d.getFullYear();
            case "yy": return (d.getFullYear() % 1000).zf(2);
            case "MM": return (d.getMonth() + 1).zf(2);
            case "dd": return d.getDate().zf(2);
            case "E": return weekName[d.getDay()];
            case "HH": return d.getHours().zf(2);
            case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
            case "mm": return d.getMinutes().zf(2);
            case "ss": return d.getSeconds().zf(2);
            case "a/p": return d.getHours() < 12 ? "오전" : "오후";
            default: return $1;
        }
    });
};
 
String.prototype.string = function(len){var s = '', i = 0; while (i++ < len) { s += this; } return s;};
String.prototype.zf = function(len){return "0".string(len - this.length) + this;};
Number.prototype.zf = function(len){return this.toString().zf(len);};

var browse = navigator.userAgent.toLowerCase(); 
if( (navigator.appName == 'Netscape' && browse.indexOf('trident') != -1) || (browse.indexOf("msie") != -1)) {
     console.log("ie 에서는 ajax cache false");
     $.ajaxSetup({
 		cache:false,
     });
}






/**
 * ajax 로딩
 * 
 * 사용 ->
 *  var personInfo = new Object();
    personInfo.UI_PHONE = UI_PHONE;
    personInfo.UI_NAME = UI_NAME;
	$.ajaxLoding("/${tiles}/member/find/searchID.do",personInfo,resultFn);
	
 */
(function ($) {
	$.ajaxLoding = function (u,d,fn,a,t) {
		t = t || 0;
		a = a || true;
		
    	var timer = setTimeout(function(){
	        cf_loading();
	    },500);
	     
        $.ajax({
		    type: "POST",
		    url: u,
		    data: d,
		    async :a,
		    timeout : t,
		    success: fn, 
		    error: function(jqXHR, textStatus, errorThrown) {
		        alert('에러 관리자에게 문의하세요.');
		        return false;
		    }
		})
		.always(function(){
 			clearTimeout(timer);
 			cf_loading_out();
	 	});
        // 기능 구현 완료
    };
})(jQuery);

/**
 * 언어
 */
var lang = $('html').attr('lang');


/**
 * ie에서 includes 지원 안함
 */ 
if (!String.prototype.includes) {
     String.prototype.includes = function() {
         'use strict';
         return String.prototype.indexOf.apply(this, arguments) !== -1;
     };
 }

/**
 * dialog에서 select2 충돌해결
 */
//$.ui.dialog.prototype._allowInteraction = function(e) {
//	return !!$(e.target).closest('.ui-dialog, .ui-datepicker, .sp-input, .select2-dropdown').length;
//};

/**
 * replaceAll 추가
 */
String.prototype.replaceAll = function(org, dest) {
    return this.split(org).join(dest);
}

function cf_back(url){
	location.href=url;
}

/**
 * 오늘 날짜를 리턴 
 * 2018-01-16 12:20:40
 * type 
 * : date 	--> 2018-01-16
 * : y 		--> 2018
 * : m 		--> 01
 * : d 		--> 16
 * : h 		--> 12
 * : mi 	--> 20
 * : s 		--> 40
 * @returns
 */
function cf_getDate(type){
	var date = new Date();
	
	if(type == 'date'){
		return date.getFullYear() + "-" + cf_setTwoDigit(date.getMonth() + 1) + "-" + cf_setTwoDigit(date.getDate());
	}else if(type == 'y'){
		return date.getFullYear();
	}else if(type == 'm'){
		return cf_setTwoDigit(date.getMonth() + 1);
	}else if(type == 'd'){
		return cf_setTwoDigit(date.getDate());
	}else if(type == 'h'){
		return cf_setTwoDigit(date.getHours());
	}else if(type == 'mi'){
		return cf_setTwoDigit(date.getMinutes());
	}else if(type == 's'){
		return cf_setTwoDigit(date.getSeconds());
	} 
	
}

/**
 * 숫자 포멧 두자리로 
 * 1 -> 01
 * @param number
 * @returns
 */
function cf_setTwoDigit(number){
	// 넘어온 숫자를 문자열타입으로 변환
	number += ""; 
	
	if(number.length == 1){
		return "0" + number;
	}else{
		return number;
	}
}



/**
 * 파일 다운로드 처리 
 * @param filekey
 */
function cf_download(file){
    location.href="/async/MultiFile/download.do?file=" + file;
}
/**
 * 파일 다운로드 처리 
 * @param filekey
 */
function cf_download_zip(filekey){
	location.href="/async/MultiFile/download.do?FM_KEYNO=" + filekey;
}
 /**
 * alert
 * @param Msg
 */
function cf_alert(Msg) {    
	alert(Msg)
}

/**
 * alert창 오픈 Callback 함수사용 
 * @param Msg
 * @param evt
 */
function cf_alert_cb(Msg, evt){
	alert(Msg)
	eval(evt)
} 


/**
 * Confirm창 오픈
 * @param Msg
 * @param true_evt
 * @param false_evt
 */
function cf_confirm(Msg, true_evt,false_evt) {    
	if(confirm(Msg)){
		eval(true_evt);
	} else{
		eval(false_evt);
	}
}

/**
 * 특정 체크박스 버튼 선택 처리 Name, value
 * @param Name
 * @param value
 */ 
function cf_checkbox_checked(Name, value){
	for(var i in value){
		$("input:checkbox[name='" + Name + "']:checkbox[value='" + value[i] + "']").attr("checked",true);
	}
}

/**
 * 특정 체크박스 버튼 선택 처리 Name, value
 * @param Name
 * @param value
 */ 
function cf_checkbox_checked_prop(Name, value){
	for(var i in value){
		$("input:checkbox[name='" + Name + "']:checkbox[value='" + value[i] + "']").prop("checked",true);
	}
}

/**
 * 특정 체크박스 버튼 선택 처리 Name, value
 * @param Name
 * @param value
 */ 
function cf_checkbox_checked_val(Name, value){
	var ckStatus = true;
	if(value == 'N' || value == 'R' || value == 'P'){ckStatus = false}
	$("input:checkbox[name='" + Name + "']").prop("checked",ckStatus);
}

/**
 * 특정 라디오 버튼 선택 처리 Name, value
 * @param Name
 * @param value
 */ 
function cf_radio_checked(Name, value){ 
	$("input:radio[name='" + Name + "']:radio[value='" + value + "']").attr("checked",true);
}  

/**
 * 라디오 버튼 선택 값 리턴 Name
 * @param Name
 */ 
function cf_radio_check_val(Name){
	return $(':radio[name="'+ Name +'"]:checked').val();
}

/**
 * 선택상자 특정값 선택 처리
 * @param ID
 * @param Value
 */ 
function cf_select_check(ID, Value){
	$("#" + ID).val(Value);
}
/**
 * 선택상자 박스 내용 삭제 처리
 * @param ID
 * @param Value
 */ 
function cf_select_alldel(ID){
	$("#" + ID).empty();
}
/**
 * 선택상자 박스 내용 change 실행
 * @param ID
 * @param Value
 */
function cf_select_trigger(ID){
$("#" + ID).trigger("change");
}

/**
 * 선택상자 박스 옵션 추가
 * @param ID
 * @param Value
 * @param Text
 */
function cf_select_append(ID, Value, Text){
	$("#" + ID).append("<option value='" + Value +"' >" + Text + "</option>"); 
} 

//공백체크
function isNoSpace(str){
	if ( str.search(/\s/) == -1 ) {
		return true;
	} else {
		return false;
	}
}

/**
 * 숫자 체크
 * Param 값이 숫자일경우 true return 
 * 숫자가 아닐경우 false return
 * @param s
 * @returns {Boolean}
 */
function isNumberic(s){
	var isNum = /\d/;
	if( isNum.test(+s) ){
		return true;
	}else{
		return false;	
	}
}

/**
 * 숫자만 입력을 받는 함수 
 * @param e 
 * @returns {Boolean}
 * @Event onkeydown 
 */  
function cf_only_Num(e) { 
    var KeyCode = e.which?e.which:event.keyCode; 
    if((Number(KeyCode) == 8) ||(Number(KeyCode) == 9) || (Number(KeyCode) == 46)|| 
    		((Number(KeyCode) >= 48 && Number(KeyCode) <= 57)) ||
    		((Number(KeyCode) >= 96 && Number(KeyCode) <= 105))
    		){
    	return true; 
    }else{     
    	return false; 
    } 
}



/**
 * input type="number" maxlength 체크
 * @param object
 * @returns
 */
function cf_maxLengthCheck(object){
 if (object.value.length > object.maxLength){
  object.value = object.value.slice(0, object.maxLength);
 }    
}


function cf_onlyNumAndLimitLength(object,e){
	
	var KeyCode = e.which?e.which:event.keyCode; 
    if((Number(KeyCode) == 8) ||(Number(KeyCode) == 9) || (Number(KeyCode) == 46)|| 
    		((Number(KeyCode) >= 48 && Number(KeyCode) <= 57)) ||
    		((Number(KeyCode) >= 96 && Number(KeyCode) <= 105))
    		){
    	
    	var check = true;
    	
    	if(object.maxLength && object.value.length > object.maxLength){
    		object.value = object.value.slice(0, object.maxLength);
    		check = false;
		}
    	
    	if(object.max && object.value > object.max){
    		object.value = object.max;
    		check = false;
    	}
    	
    	return check; 
    }else{     
    	return false; 
    }
}


/**
 * 휴대폰 번호 입력 받는 함수
 * @param e 
 * @returns {Boolean}
 * @Event onkeydown 
 */ 
function cf_phone_Num(e) {  
    var KeyCode = e.which?e.which:event.keyCode;  
    if((Number(KeyCode) == 8) || (Number(KeyCode) == 46) || Number(KeyCode) == 109 || Number(KeyCode) == 189 || 
		(Number(KeyCode) == 9) ||	((Number(KeyCode) >= 48 && Number(KeyCode) <= 57)) ||
    		((Number(KeyCode) >= 96 && Number(KeyCode) <= 105))
    		){
    	return true;  
    }else{     
    	return false; 
    } 
}

/**
 * 다이얼로그 셋팅
 * @param obj
 * @param title
 * @param successText
 * @param successFnc
 * @param cancelText
 * @returns
 */
function cf_setttingDialog(obj,title,successText,successFnc,cancelText){
	var cancelText = cancelText || '취소';
	var data = {
			autoOpen : false,
			width : "800",
			resizable : false,
			modal : true,
			title : title
		}
	if(successText){
		data.buttons = [{
			html : "<i class='fa fa-floppy-o'></i>&nbsp; "+successText,
			"class" : "btn btn-primary",
			click : function() {
				if(eval(successFnc)){
					$(this).dialog("close");
				}
			}
		}, {
			html : "<i class='fa fa-times'></i>&nbsp; "+cancelText,
			"class" : "btn btn-default",
			click : function() {
				$(this).dialog("close");
			}
		}]
	}else{
		data.buttons = [{
			html : "<i class='fa fa-times'></i>&nbsp; 확인",
			"class" : "btn btn-primary",
			click : function() {
				$(this).dialog("close");
			}
		}]
	}
	$(obj).dialog(data);
}


//로딩중 처리
function cf_loading(){
	$(".loading_box").css("display","block");
	$("html").css("overflow-y","hidden");
}

//로딩중 처리 닫기
function cf_loading_out(){
	$(".loading_box").css("display","none");
	$("html").css("overflow-y","");
}

// 다이얼로그 버튼을 저장,취소 외에 더 추가하고 싶을때
function cf_setttingDialog2(obj,title,successText1,successFnc1,successText2,successFnc2,cancelText){
	
	var cancelText = cancelText || '취소';
	var data = {
			autoOpen : false,
			width : 800,
			resizable : false,
			modal : true,
			title : title
		}
	if(successText1){
		data.buttons = [{
			html : "<i class='fa fa-floppy-o'></i>&nbsp; "+successText1,
			"class" : "btn btn-primary",
			click : function() {
				if(eval(successFnc1)){
					$(this).dialog("close");
				}
			}
		},
		{
			html : "<i class='fa fa-floppy-o'></i>&nbsp; "+successText2,
			"class" : "btn btn-danger",
			click : function() {
				if(eval(successFnc2)){
					$(this).dialog("close");
				}
			}
		},
		{
			html : "<i class='fa fa-times'></i>&nbsp; "+cancelText,
			"class" : "btn btn-default",
			click : function() {
				$(this).dialog("close");
			}
		}]
	}else{
		data.buttons = [{
			html : "<i class='fa fa-times'></i>&nbsp; 확인",
			"class" : "btn btn-primary",
			click : function() {
				$(this).dialog("close");
			}
		}]
	}
	$(obj).dialog(data);

}

//24시간 기준 쿠키 설정하기  
//expiredays 후의 클릭한 시간까지 쿠키 설정
function cf_setCookie(cName, cValue, cDay){
	var cDay = cDay || 365;
    var expire = new Date();
    expire.setDate(expire.getDate() + cDay);
    cookies = cName + '=' + escape(cValue) + '; path=/ '; // 한글 깨짐을 막기위해 escape(cValue)를 합니다.
    if(typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
    document.cookie = cookies;
}

//00:00 시 기준 쿠키 설정하기  
//expiredays 의 새벽  00:00:00 까지 쿠키 설정
function cf_setCookieAt00(cName, cValue, cDay){
	
    var expire = new Date();
    
    expire = new Date(parseInt(expire.getTime() / 86400000) * 86400000 + 54000000);  
    if( expire > new Date() ){  
    	cDay = cDay - 1;  
    }  
    expire.setDate(expire.getDate() + cDay);
    cookies = cName + '=' + escape(cValue) + '; path=/ '; // 한글 깨짐을 막기위해 escape(cValue)를 합니다.
    if(typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
    document.cookie = cookies;
}


// 쿠키 가져오기
function cf_getCookie(cName) {
    cName = cName + '=';
    var cookieData = document.cookie;
    var start = cookieData.indexOf(cName);
    var cValue = '';
    if(start != -1){
        start += cName.length;
        var end = cookieData.indexOf(';', start);
        if(end == -1)end = cookieData.length;
        cValue = cookieData.substring(start, end);
    }
    return unescape(cValue);
}

function cf_clearCookie(cName){
	
	var expireDate = new Date();
	  
    //어제 날짜를 쿠키 소멸 날짜로 설정한다.
    expireDate.setDate( expireDate.getDate() - 1 );
    document.cookie = cName+"= " + "; expires=" + expireDate.toGMTString() + "; path=/";
}
var datepickerOption = {
        "dateFormat": 'yy-mm-dd',
        "prevText": '<i class="fa fa-chevron-left"></i>',
        "nextText": '<i class="fa fa-chevron-right"></i>',
        "monthNames": ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
        "monthNamesShort": ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
        "dayNames": ['일', '월', '화', '수', '목', '금', '토'],
        "dayNamesShort": ['일', '월', '화', '수', '목', '금', '토'],
        "dayNamesMin": ['일', '월', '화', '수', '목', '금', '토'],
        "showMonthAfterYear": true,
        "changeYear": true,
        "cleanText": '지우기',
        "showButtonPanel": true,
        "closeText": '취소',
        "onClose": function (dateText, inst) {
            if ($(window.event.srcElement).hasClass('ui-datepicker-close'))
            {
                document.getElementById(this.id).value = '';
            }
        }
        
    };


/**
 * id = 파일 id
 * 텍스트 엘리먼트  : id_text
 * 이미지 엘리먼트 : id_img
 * ext : 확장자 없을시 기본 셋팅 gif,jpeg,jpg,png
 * defaultText : id_text 에 들어갈 기본 텍스트
 * defaultSrc : id_img 에 들어갈 기본 이미지
 * isHide : 미리보기 이미지 숨길지 여부 
 * ei9 지원안됨
 * @param id
 * @param img
 * @param ext
 * @returns
 */
function cf_imgCheckAndPreview(id,ext,maxSize,defaultText,defaultSrc,isHide){
	var MB = 1048576;
	
	//값이 없으면 30MB 셋팅
	maxSize = maxSize || 30;
	defaultText = defaultText || '';
	defaultSrc = defaultSrc || '';
	
	isHide = isHide || 'T';
	
	ext = ext || 'gif,jpeg,jpg,png';
	var isIE9 = (navigator.userAgent.indexOf('MSIE 9.0') != -1);  
	var path =$('#'+id).val();
	if(!path){ // 파일 선택 취소 처리
		$('#'+id+'_img').attr('src',defaultSrc);
		if(isHide == 'T'){
			$('#'+id+'_img').hide();
		}
		$('#'+id+'_text').val(defaultText);
		return false;
	}
	
	
	var thisExt = path.substring(path.lastIndexOf('.') + 1).toLowerCase();  
	 if(ext.indexOf(thisExt) != -1)  
	 { 
		 $('#'+id+'_text').val($('#'+id).val());
		 var f = document.getElementById(id).files[0];
		 var size = f.size;
		 if(size > maxSize * MB){
			 cf_smallBox('error', '파일이 너무 큽니다.('+maxSize+'MB 제한)', 3000,'#d24158');
//			 alert('파일이 너무 큽니다.('+maxSize+'MB 제한)' );
		 }
	    if(isIE9) {  
	      // $('#'+id+'_img').attr('src', path);  
	    }else{  
	    	
	        var reader = new FileReader();
	        reader.onload = (function(evt) {  //evt get all value
	        	$('#'+id+'_img').attr('src',evt.target.result).show();
	        	
	        });
	        reader.readAsDataURL(f);
	    }  

	 }else{  
		  cf_smallBox('error', '파일 형식이 잘못되었습니다.', 3000,'#d24158'); 
//		  alert('파일 형식이 잘못되었습니다.');
		  $('#'+id).val('');
		  $('#'+id+'_text').val(defaultText);
		  $('#'+id+'_img').attr('src',defaultSrc);
		  if(isHide == 'T'){
			  $('#'+id+'_img').hide();
		  }
	 }   
	
}

function cf_imgCheckAndPreview2(id,ext,maxSize){
	var MB = 1048576;
	//값이 없으면 30MB 셋팅
	maxSize = maxSize || 30;
	
	ext = ext || 'ico';
	var isIE9 = (navigator.userAgent.indexOf('MSIE 9.0') != -1);  
	var path =$('#'+id).val();
	if(!path){ // 파일 선택 취소 처리
		$('#'+id+'_img').attr('src','');
	}
	
	
	var thisExt = path.substring(path.lastIndexOf('.') + 1).toLowerCase();  
	if(ext.indexOf(thisExt) != -1)  
	{ 
		$('#'+id+'_text').val($('#'+id).val());
		var f = document.getElementById(id).files[0];
		var size = f.size;
		if(size > maxSize * MB){
			alert('파일이 너무 큽니다.('+maxSize+'MB 제한)' );
		}
		if(isIE9) {  
			// $('#'+id+'_img').attr('src', path);  
		}else{  
			
			var reader = new FileReader();
			reader.onload = (function(evt) {  //evt get all value
				$('#'+id+'_img').attr('src',evt.target.result).show();
				
			});
			reader.readAsDataURL(f);
		}  
		
	}else{  
		alert('파일 형식이 잘못되었습니다.');
		$('#'+id).val('');
	}   
	
}


function cf_fileCheck(id,ext,maxSize){
	var MB = 1048576;
	
	//값이 없으면 30MB 셋팅
	maxSize = maxSize || 30;
	
	var state = true;
	
	var path =$('#'+id).val();
	if(!path){ // 파일 선택 취소 처리
		state = false;
	}else{
		var thisExt = path.substring(path.lastIndexOf('.') + 1).toLowerCase();  
		if(!ext || ext.indexOf(thisExt) != -1)  
		{ 
			var f = document.getElementById(id).files[0];
			var size = f.size;
			if(size > maxSize * MB){
				alert('파일이 너무 큽니다.('+maxSize+'MB 제한)' );
				state = false;
			}
			
			
		}else{  
			alert('파일 형식이 잘못되었습니다.' + ext + ' 만 가능합니다.');
			state = false;
		}   
		
	}
	
	 if(!state){
		 $('#'+id).val('');
		 $('#'+id+"_text").val('');
	 }else{
		 var text = $('#'+id).val();
		 if(text.lastIndexOf('\\') != -1){
			 text = text.substring(text.lastIndexOf('\\')+1)
		 }
		 $('#'+id+'_text').val(text);
	 }
	 
	 return state;
}

/**
* path : 전송 URL
* params : 전송 데이터 {‘q’:’a’,’s’:’b’,’c’:’d’…}으로 묶어서 배열 입력
*/
function cf_postSend(path, params) {
	var form = document.createElement("form");
	form.setAttribute("method", "post");
	form.setAttribute("action", path);
	for(var key in params) {
		var hiddenField = document.createElement("input");
		hiddenField.setAttribute("type", "hidden");
		hiddenField.setAttribute("name", key);
		hiddenField.setAttribute("value", params[key]);
		form.appendChild(hiddenField);
	}
	document.body.appendChild(form);
	form.submit();
}

/**
 * 스크롤 위치 이동
 * @param top
 * @returns
 */
function cf_movePosition(top){
	$(window).scrollTop(top)
}

/**
 * 폼에 현재 스크롤 위치 추가
 * @param form
 * @returns
 */
function cf_addCurrentPosition(form){
	var form = document.getElementById(form);
	var hiddenField = document.createElement("input");
	hiddenField.setAttribute("type", "hidden");
	hiddenField.setAttribute("name", "currentPosition");
	hiddenField.setAttribute("value", $(window).scrollTop());
	form.appendChild(hiddenField);
}

/**
 * 인쇄 ie 미리보기 추가
 * @returns
 */
function cf_print(){
	 
    var browser = navigator.userAgent.toLowerCase();
    if ( -1 != browser.indexOf('chrome') ){
               window.print();
    }else if ( -1 != browser.indexOf('trident') ){
       try{
            //참고로 IE 5.5 이상에서만 동작함

            //웹 브라우저 컨트롤 생성
            var webBrowser = '<OBJECT ID="previewWeb" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';

            //웹 페이지에 객체 삽입
            document.body.insertAdjacentHTML('beforeEnd', webBrowser);

            //ExexWB 메쏘드 실행 (7 : 미리보기 , 8 : 페이지 설정 , 6 : 인쇄하기(대화상자))
            previewWeb.ExecWB(7, 1);

            //객체 해제
            previewWeb.outerHTML = "";
       }catch (e) {
            alert("- 도구 > 인터넷 옵션 > 보안 탭 > 신뢰할 수 있는 사이트 선택\n   1. 사이트 버튼 클릭 > 사이트 추가\n   2. 사용자 지정 수준 클릭 > 스크립팅하기 안전하지 않은 것으로 표시된 ActiveX 컨트롤 (사용)으로 체크\n\n※ 위 설정은 프린트 미리보기 기능을 사용하기 위함임");
            window.print();
       }
    }else{
    	 window.print();
    }
}


//TEXTAREA 최대값 체크
function cf_TextAreaInputLimit(obj,maxSize) {
	
    var tempText = $('#'+obj);
    var tempChar = "";                                        // TextArea의 문자를 한글자씩 담는다
    var tempChar2 = "";                                        // 절삭된 문자들을 담기 위한 변수
    var countChar = 0;                                        // 한글자씩 담긴 문자를 카운트 한다
    var tempHangul = 0;                                        // 한글을 카운트 한다
    
    // 글자수 바이트 체크를 위한 반복
    for(var i = 0 ; i < tempText.val().length; i++) {
        tempChar = tempText.val().charAt(i);

        // 한글일 경우 2 추가, 영문일 경우 1 추가
        if(escape(tempChar).length > 4) {
            countChar += 2;
            tempHangul++;
        } else {
            countChar++;
        }
    }
    
    // 카운트된 문자수가 MAX 값을 초과하게 되면 절삭 수치까지만 출력을 한다.(한글 입력 체크)
    // 내용에 한글이 입력되어 있는 경우 한글에 해당하는 카운트 만큼을 전체 카운트에서 뺀 숫자가 maxSize보다 크면 수행
    if(countChar > maxSize) {
        alert("최대 글자수를 초과하였습니다.");
        
        tempChar2 = tempText.val().substr(0, maxSize-1);
        tempText.val(tempChar2);
        $('#'+obj+'_length').text(maxSize-1)
    }else{
    	$('#'+obj+'_length').text(countChar)
    }
}


/**
 * 테이블 키값을 숫자에서 테이블 규칙에 맞도록 리턴
 * ex) 111 , TM - > TM_0000000111
 * @param number
 * @param tableName
 * @returns
 */
function cf_getKeyno(number,tableName){
	
	//숫자가 아닐 경우 그대로 return
	if( !$.isNumeric(number) ){
		return number;
	}
	number = number + '';
	for(var i=number.length;i<10;i++){
		number = '0' + number;
	}
	
	return tableName + '_' + number
}

/**
 * 테이블 키값을 숫자로 변경
 * ex) TM_0000000111 -> 111
 * @param key
 * @returns
 */
function cf_setKeyno(key){
	key = key.substring(key.indexOf('_')+1);
	return Number(key);
}


function cf_checkVal(obj,text){
	if(!$(obj).val().trim()){
		alert(text);
		$(obj).focus();
		return false;
	}
	return true;
}

//콤마 찍기
function numberFormat(num) {
	num = num+"";
	var pattern = /(-?[0-9]+)([0-9]{3})/;
	while(pattern.test(num)) {
	num = num.replace(pattern,"$1,$2");
	}
	return num;
}

// 콤마 제거
function unNumberFormat(num) {
	return (num.replace(/\,/g,""));
}


function cf_getToday(date){
	var d;
	if(!date){
		d = new Date();
	}else if(date instanceof Date){
		d = date
	}else{
		d = new Date(date);
	}
	
	return d.getFullYear()+"-"+cf_setDigit((d.getMonth() + 1),2)+"-"+cf_setDigit(d.getDate(),2);
}

function cf_setDigit(num,length){
	num = num + ""
	var str=""
	for(var i=0;i<length-num.length;i++){
	  str += '0';
	}
	str += num;
	
	return str;
}


function cf_replaceTrim(obj){
	$(obj).find(".checkTrim").each(
	function (index, element){
		$(element).val($(this).val().trim());
	});
}

function cf_checkExcelDownload(){
	
	cf_setCookie('fileDownload','false');
	cf_loading();
  	cf_checkDownload();
  	
	
    
}

function cf_checkDownload(){
	if (document.cookie.indexOf("fileDownload=true") != -1) {
        var date = new Date(1000);
        document.cookie = "fileDownload=; expires=" + date.toUTCString() + "; path=/";
        //프로그래스바 OFF 
        cf_loading_out();
        return;
    }
   	setTimeout(cf_checkDownload , 100);
}

/**
 * js 클립보드 복사
 * @param val
 * 매개변수 val값을 클립보드로 복사한다.
 */
function cf_copyToClipboard(val) {
  var t = document.createElement("textarea");
  document.body.appendChild(t);
  t.value = val;
  t.select();
  document.execCommand('copy');
  document.body.removeChild(t);
}

/**
 * jquery smallBox를 엽니다.
 * @param title
 * @param content
 * @returns
 * @색상샘플 
 * .default(grey) : #999
 * .success(green-light) : #739e73
 * .primary(blue-light) : #3276b1
 * .info(cyan-light) : #57889c
 * .warning(orange) : #c79121
 * .danger(red) : #a90329
 */
function cf_smallBox(title, content, timeout, bgColor, iconSmall){
	bgColor = bgColor || '#739e73'; //success(green-light)
	iconSmall = iconSmall || "fa fa-check fa-2x fadeInRight animated"
	var options = {
			'title' : title
			,'content' : content
			,'color' : bgColor
			,'timeout' : timeout
			,'iconSmall' : iconSmall
			//,'icon' : "fa fa-bell fadeInRight animated"
		};
	timeout || delete options['timeout'];
	$.smallBox(options);
}

function cf_bigBox(title, content, timeout, bgColor, icon, number){
	bgColor = bgColor || '#739e73'; //success(green-light)
	icon = icon || "fa fa-warning shake animated"
	number = number || "1"
	var options = {
			'title' : title
			,'content' : content
			,'color' : bgColor
			,'icon' : icon
			,'number' : number
			,'timeout' : timeout
		}
	timeout || delete options['timeout'];
	$.bigBox(options);
}


/**
 * jquery smallBox를 엽니다.
 * @param title
 * @param content
 * @returns
 * @색상샘플 
 * .default(blue-dark) : #296191
 */
function cf_smallBoxConfirm(title, content, func, bgColor, icon){
	bgColor = bgColor || '#296191';
	icon = icon || "fa fa-bell swing animated"
	content = content + " <p class='text-align-right'><a href='javascript:;' onclick=\"" + func + "\" class='btn btn-primary btn-sm'>Yes</a> <a href='javascript:void(0);' class='btn btn-danger btn-sm'>No</a></p>";
	var options = {
		title : title,
		content : content,
		color : bgColor,
		icon : icon
	}
	$.smallBox(options);
}

/* HTML 비동기 찍어내기 함수 1.0 */
/* 대상 class객체에 비동기 호출된 HTML을 추가로 삽입하거나 기존 내용을 교체 */
/* ajaxUrl : 비동기 호출할 url */
/* targetClass : 호출결과를 삽입할 HTML class명 혹은 jQuery object */
/* param : 비동기 호출 url로 전송할 파라미터 (serialize 형태) */
/* optionNo : 삽입 옵션 - 하단 소스 참조. */
/* isAnimate : boolean - fadeIn fadeOut 효과 ON/OFF */
/* callbackFunc : 완료 후 실행할 callback 함수 */
/* callbackParam2 : callback 함수에 들어갈 2번째 파라미터. 1번 파라미터는 서블릿 요청의 return 값 
/* isAsync : 비동기 boolean. 기본값 true
 * 
 * 사용예시 ) htmlAppend('/dyAdmin/update.do', '.target_'+key, param, 'outer-change', true, success, '완료되었습니다', false );
 */
function htmlAppend(ajaxUrl, $targetClass, param, optionNo, isAnimate, callbackFunc, callbackParam2, isAsync ){
	if( typeof isAsync == 'undefined' || typeof isAsync != 'boolean' ){ isAsync = true }
	if( typeof isAnimate == 'undefined' || typeof isAnimate != 'boolean' ){ isAnimate = true }
	
  jQuery.ajax({
     type : "POST",
     async : isAsync,
     url : ajaxUrl,
     data : param,
     dataType : "HTML",
     success : function(data) {
     },
     error : function(xhr, status, error) {
       if( xhr.status == '8080' ){
         alert('로그인 세션이 만료되었습니다.\n해당 기능은 로그인이 필수입니다.');
         //location.href = '/dyAdmin/user/login.do';
       }else{
         alert("사용자 요청 처리에러\n해당 문제가 계속 발생시 관리자에게 문의해 주십시오.");
       }
     }
   }).done(function(result){
     if( typeof result != 'undefined' ){
       //jquery선택자가 아닐 경우 변환
       if( jQuery.type($targetClass) != 'object' ){
         $targetClass = $($targetClass);
       }
       
       var $target = $targetClass.eq(0);
        /*
        * optionNo : 삽입 옵션
        */
       if( optionNo == 'inner-append' ){ //선택자 내부에 추가로 삽입 
    	   if( isAnimate ){
	    	   $(result).hide().appendTo($target).show(1500);
	    	   moveScroll( $target.offset().top + $target.height(), 500);
    	   }else{
    		   $target.append(result);
    	   }
       }else if( optionNo == 'inner-change' ){ //선택자 내부를 지우고 삽입 
    	   if( isAnimate ){
	         $target.hide(1000).html(result).show(1000);
	         moveScroll( $target.offset().top, 500);
    	   }else{
    		   $target.html(result);
    	   }
       }else if( optionNo == 'outer-before' ){ //선택자의 이전에 삽입 
    	   if( isAnimate ){
	         moveScroll( $target.offset().top, 500);
	         $(result).hide().insertBefore($target).show(1500);
    	   }else{
	         $target.before(result);
    	   }
       }else if( optionNo == 'outer-after' ){ //선택자의 다음에 삽입
    	   if( isAnimate ){
	         $(result).hide().insertAfter($target).show(1500);
	         moveScroll( $target.offset().top + $target.height(), 500);
         }else{
	         $target.after(result);
         }
       }else if( optionNo == 'outer-change' ){ //선택자를 지우고 그 자리에 삽입 
    	   if( isAnimate ){
	         $target.hide(1000);
	         $(result).hide().insertAfter($target).show(1500);
	         moveScroll( $target.offset().top, 500);
	         $target.remove();
         }else{
	         $target.after(result).remove();
         }
       }else{
         alert('부적절한 삽입 옵션입니다 : "'+optionNo+'"')
       }
       
       if( typeof callbackFunc != 'undefined' ){
         callbackFunc(result, callbackParam2);
       }
     }else{
       alert('사용자 요청 처리 에러 : 결과값이 없습니다.')
     }
   });
  
  function moveScroll(pos, msec){
	  $('html, body').stop().animate({scrollTop : pos }, msec)
  }
  
}


// 복사하기 기능
// 리턴값 있는걸로 체크
function cf_copyToClipboard(val) {
	  var t = document.createElement("textarea");
	  document.body.appendChild(t);
	  t.value = val;
	  t.select();
	  var result = document.execCommand('copy');
	  document.body.removeChild(t);
	  
	  return result;
}

//String 이스케이프 처리 기능
String.prototype.escapeHtml = function(){
  return this.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/\"/g, "&quot;");
};

//사용법 문자열.unescapeHtml(); 
String.prototype.unescapeHtml = function(){
  return this.replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&quot;/g, "\"");
};


//Code Mirror
//사용법 var editor = codeMirror(type, id);
function codeMirror(as_type, as_id, as_multi, as_line) {
	if(as_line == null){as_line = true}
	if (as_multi != 'Y') $('.CodeMirror').remove();

	CodeMirror.commands.autocomplete = function(cm) {
		var doc = cm.getDoc();
		var POS = doc.getCursor();
		var mode = CodeMirror.innerMode(cm.getMode(), cm.getTokenAt(POS).state).mode.name;
		if (mode == 'xml') {
			CodeMirror.showHint(cm, CodeMirror.hint.html);
		} else if (mode == 'javascript') {
			CodeMirror.showHint(cm, CodeMirror.hint.javascript);
		} else if (mode == 'css') {
			CodeMirror.showHint(cm, CodeMirror.hint.css);
		}
	};

	var languageMode = '';
	if (as_type == 'htmlmixed') {
		languageMode = {
			name: 'htmlmixed',
			scriptTypes: [
				{matches: /\/x-handlebars-template|\/x-mustache/i, mode: null},
				{matches: /(text|application)\/(x-)?vb(a|script)/i, mode: 'vbscript'}
			]
		};
	} else {
		languageMode = as_type;
	}

	
	var codeEditor = CodeMirror.fromTextArea(document.getElementById(as_id), {
		lineNumbers: as_line,
		lineWrapping: true,
		styleActiveLine: true,
		highlightSelectionMatches: {showToken: /\w/},
		mode: languageMode,
		matchBrackets: true,
		matchTags: {bothTags: true},
		autoCloseTags: true,
		autoCloseBrackets: true,
		value: document.documentElement.innerHTML,
		scrollbarStyle: 'simple',
		extraKeys: {
			'Ctrl-Space': 'autocomplete',
			'Alt-Space': 'autocomplete',
			'Ctrl-J': 'toMatchingTag',
			'Alt-F': 'findPersistent'
		}			
	});

	return codeEditor;
	
}


//탭 기능 추가(textarea)
function useTab(obj){
	if(event.keyCode===9){
		// get caret position/selection
	     var start = obj.selectionStart;
	     var end = obj.selectionEnd;

	     var $this = $(obj);
	     var value = $this.val();

	     // set textarea value to: text before caret + tab + text after caret
	     $this.val(value.substring(0, start)
	                    + "\t"
	                    + value.substring(end));

	     // put caret at right position again (add one for the tab)
	     this.selectionStart = this.selectionEnd = start + 1;

	     // prevent the focus lose
	     event.preventDefault();
	};
}

//휴대폰번호
function cf_autoHypenPhone(obj,str){
 str = str.replace(/[^0-9]/g, '');
 var tmp = '';
 if(str.length < 4){
     tmp += str;
 }else if(str.length < 7){
     tmp += str.substr(0, 3);
     tmp += '-';
     tmp += str.substr(3);
 }else if(str.length < 11){
     tmp += str.substr(0, 3);
     tmp += '-';
     tmp += str.substr(3, 3);
     tmp += '-';
     tmp += str.substr(6);
 }else{              
     tmp += str.substr(0, 3);
     tmp += '-';
     tmp += str.substr(3, 4);
     tmp += '-';
     tmp += str.substr(7);
 }
 $(obj).val(tmp)
}


function cf_top(){
	$("html, body").stop().animate({scrollTop:0},500,"easeInOutCubic")
}



function cf_scroll(id){
	var offset = $("#"+id).offset();
    $('html, body').animate({scrollTop : offset.top}, 400);
}