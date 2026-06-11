<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>
.table-bordered th {
	text-align: center;
}

.SettingBox {width:450px !important;}
.settingUl li {margin-bottom:5px; width:100%;}
.settingUl li:after { visibility: hidden;display:block;font-size: 0;content:".";clear: both;height: 0;}
.settingUl li label {display:block; float:left; width:80px;}
.settingUl li input {display:block; float:left; width: calc(100% - 120px);}

#imgsettingbutton {
	width: 75.89px;
	height: 24px;
	margin: 5px;
}

img.tempImg {
width : 20%;
height: 130px;
padding: 5px;
}
img.questionIcon{
	width: 5%;
    margin-right: 15px;
    margin-bottom: 8px;
    float: left;
}
span.subtext{
    float: left;
    font-size: 12px;
    margin-left: 80px;
    color: #888;
}

 @media all and (max-width:900px){ 
 	.SettingBox {width:100% !important;
 				left: 23px;}
	
	img.tempImg {
	height: 65px;
	}
 } 

</style>

<!-- 회원 정보 등록 레이어창 --> 
<div id="img_settingwindow" class="imgsettingWindow" title="이미지 셋팅">
	<div class="widget-body">
		<ul class="settingUl">
			<li class="settingli">
				<label>Width</label>
<!-- 				<img class="questionIcon" src="/resources/img/sub/question.png"> -->
				<input type="text" id="img_width">
				<span class="subtext">이미지의 넓이를 설정합니다. 기본 단위는 PX입니다.</span>
			</li>
			<li class="settingli">
				<label>Height</label>
				<input type="text" id="img_heigh" >
				<span class="subtext">이미지의 높이를 설정합니다. 기본 단위는 PX입니다.</span>
			</li>
			<li class="settingli">
				<label>Link </label>
				<input type="text" id="img_link" >
				<span class="subtext">http:// 또는 https:// 부터 시작합니다.</span>
			</li>
			<li class="settingli">
				<label>Title</label>
				<input type="text" id="img_title">
				<span class="subtext">이미지 title을 설정합니다.</span>
			</li>
			<li class="settingli">
				<label>Alt</label>
				<input type="text" id="img_alt">
				<span class="subtext">이미지 대체 텍스트를 설정합니다.</span>
			</li>
		</ul>
	</div>
</div>

<script type="text/javascript">
var nTotalSize = 0;
var nMaxTotalImageSize = 50*1024*1024;
var nImageInfoCnt = 0;
var aResult = [];
var imgarray = new Array();
var htImageInfo = []
var nImageFileCount = 0;

$(document).ready(function() {
	cf_setttingDialog('#img_settingwindow','이미지 셋팅','등록','setPhotoToEditor()');

	$("#img_settingwindow").parent().addClass('SettingBox');
	
	$("#editorbox").hide();
});


function imgSetting(){
	if($("#selectedImg").val() == "") {
		alert("이미지를 먼저 등록해주세요.");
		return false;
	}
	$('#img_settingwindow').dialog('open');	
	$('#img_settingwindow').css("max-height", "400px");
}

function selectFiles(obj,id){
	
	$("#smartimg_img").css({
		"background" : "#fff",
		"border": "1px solid #cfcfcf"
	});
	
	if (nImageFileCount >= 20){
		alert("최대 20장까지만 등록할 수 있습니다.");
		return;
	}
	//변수 선언
	var wel,
		files,
		nCount,
		sListTag = '';
	
	//초기화	
	files = obj.files;
	nCount = files.length;
	
	if (!!files && nCount === 0){
		//파일이 아닌, 웹페이지에서 이미지를 드래서 놓는 경우.
		return ;
	}
	
	var rFilter = /^(image\/bmp|image\/gif|image\/jpg|image\/jpeg|image\/png)$/i;  
	var nMaxImageSize = 20*1024*1024;
	var nMaxImageCount = 20;
	
	for (var i = 0, j = nImageFileCount ; i < nCount ; i++){
		if (!rFilter.test(files[i].type)) {
			alert("이미지파일 (jpg,gif,png,bmp)만 업로드 가능합니다.");
		} else if(files[i].size > nMaxImageSize){
			alert("이미지 용량이 20MB를 초과하여 등록할 수 없습니다.");
		} else {
			//제한된 수만 업로드 가능.
			if ( j < nMaxImageCount ){
				//이미지 저장
				addImage(files[i]);
				//다음 사진을위한 셋팅
				j = j+1;
				nImageFileCount = nImageFileCount+1;
				
				html5Upload();
			} else {
				alert("최대 20장까지만 등록할 수 있습니다.");
				break;			
			}
		}
	}
}

/**
 * 이미지를 추가하기 위해서 file을 저장하고, 목록에 보여주기 위해서 string을 만드는 함수.
 * @param ofile 한개의 이미지 파일
 * @return
 */
function addImage(ofile){
	//파일 사이즈
	var ofile = ofile,
		sFileSize = 0,
		sFileName = "",
		sLiTag = "",
		bExceedLimitTotalSize = false,
		aFileList = [];
	
	sFileSize = setUnitString(ofile.size);
	sFileName = cuttingNameByLength(ofile.name, 15);
	bExceedLimitTotalSize = checkTotalImageSize(ofile.size);

	if( !!bExceedLimitTotalSize ){
		alert("전체 이미지 용량이 50MB를 초과하여 등록할 수 없습니다. \n\n (파일명 : "+sFileName+", 사이즈 : "+sFileSize+")");
	} else {
		//이미지 정보 저장							
		htImageInfo['img'] = ofile;
	}
}


function setUnitString (nByte) {
		var nImageSize;
		var sUnit;
		
		if(nByte < 0 ){
			nByte = 0;
		}
		
		if( nByte < 1024) {
			nImageSize = Number(nByte);
			sUnit = 'B';
			return nImageSize + sUnit;
		} else if( nByte > (1024*1024)) {
			nImageSize = Number(parseInt((nByte || 0), 10) / (1024*1024));
			sUnit = 'MB';
			return nImageSize.toFixed(2) + sUnit;
		} else {
			nImageSize = Number(parseInt((nByte || 0), 10) / 1024);
			sUnit = 'KB';
			return nImageSize.toFixed(0) + sUnit;
		}
 }
	
	function cuttingNameByLength (sName, nMaxLng) {
 		var sTemp, nIndex;
 		if(sName.length > nMaxLng){
 			nIndex = sName.indexOf(".");
 			sTemp = sName.substring(0,nMaxLng) + "..." + sName.substring(nIndex,sName.length) ;
 		} else {
 			sTemp = sName;
 		}
 		return sTemp;
 	}
 	
 	function checkTotalImageSize(nByte){
 		if( nTotalSize + nByte < nMaxTotalImageSize){
 			nTotalSize = nTotalSize + nByte;
 			return false;
 		} else {
 			return true;
 		}
 	}

 	
function html5Upload() {	
	var tempFile,
		sUploadURL;
	sUploadURL= '/async/file_uploader_html5/insertAjax.do'; 	//upload URL
	//파일을 하나씩 보내고, 결과를 받음.
	tempFile = htImageInfo['img'];
		try{
    		if(!!tempFile){
    			callAjax(tempFile,sUploadURL);
    		}
    	}catch(e){
    		console.log(e);	
    	}
		tempFile = null;
}


function callAjax(tempFile, sUploadURL){
	
	var form = $("#Form")[0];
	var formData = new FormData(form);
	formData.append("EditorImg",tempFile);
	
	$.ajax({
		type: "post",
		url : sUploadURL,
		data : formData,
		enctype: 'multipart/form-data',
		contentType : false,
        processData : false, 
        cache: false,
		beforeSend : function(request){
			request.setRequestHeader("file-name",encodeURIComponent(tempFile.name));
			request.setRequestHeader("file-size",tempFile.size);
			request.setRequestHeader("file-Type",tempFile.type);
			request.setRequestHeader("menuName",'${currentMenu.MN_KEYNO}');
	        },
		success : function(data){
			if(data.indexOf("NOTALLOW_") > -1){
// 				var sFileName = sResString.replace("NOTALLOW_", "");
				alert("이미지 파일(jpg,gif,png,bmp)만 업로드 하실 수 있습니다.");
			}else{
				imgarray.push(makeArrayFromString(data));
				aResult = [];
				var miricnt = imgarray.length;
				fileMiribogi(miricnt-1);
			}
		},
		error : function(e){
			console.log(e);
		}
	});
}

function makeArrayFromString(sResString){
	var	aTemp = [],
		aSubTemp = [],
		htTemp = {}
		aResultleng = 0;
	
		try{
			if(!sResString || sResString.indexOf("sFileURL") < 0){
	    		return ;
	    	}
			aTemp = sResString.split("&");
	    	for (var i = 0; i < aTemp.length ; i++){
	    		if( !!aTemp[i] && aTemp[i] != "" && aTemp[i].indexOf("▶") > 0){
	    			aSubTemp = aTemp[i].split("▶");
	    			htTemp[aSubTemp[0]] = aSubTemp[1];
	    		}
	 		}
		}catch(e){
			alert(e);
		}
		aResultleng = aResult.length;
		aResult[aResultleng] = htTemp;
       	return aResult[0].sFileURL;
}

function setPhotoToEditor(){
		var count = $("#selectedImg").val();
		var imgwidth = $("#img_width").val();
		var imgheight = $("#img_heigh").val();
		var link = $("#img_link").val();
		var title = $("#img_title").val();
		var alt = $("#img_alt").val();
		var src = imgarray[count];
		
		//넓이 높이 기본 설정
		if(imgwidth.indexOf("px") == -1 && imgwidth.indexOf("%") == -1){
			imgwidth = imgwidth + "px"; 
		}
		if(imgheight.indexOf("px") == -1 && imgheight.indexOf("%") == -1){
			imgheight = imgheight + "px"; 
		}
		var imgnumber = $("#selectedImg").val();
		
		
		var tempImgs = '<figure>';
		if(link != ""){
			tempImgs += '<a href="'+link+'"><img id="tempimg'+imgnumber+'"  class="tempImgs" src="' + src + '" title="'+title+'"alt="'+alt+'" style="width:'+imgwidth+';height:'+imgheight+';"/></a>';
		}else{
			tempImgs += '<img id="tempimg'+imgnumber+'" class="tempImgs" src="' + src + '" title="'+title+'"alt="'+alt+'" style="width:'+imgwidth+';height:'+imgheight+';"/>'; 
		}
		tempImgs += '</figure>';
		
		editor_object.getById["BN_CONTENTS"].exec("PASTE_HTML", [tempImgs]);		
		$("#img_width").val("");
		$("#img_heigh").val("");
		$("#img_link").val("");
		 $("#img_title").val("");
		 $("#img_alt").val("");
		$('#img_settingwindow').dialog('close');	
}


function fileMiribogi(cnt){
	var mirisrc = imgarray[cnt];	
	var temp = "<img class='tempImg' onclick='showImg(this,"+cnt+");' src="+mirisrc+">";
 	$('#smartimg_img').append(temp);
}

function showImg(obj,j){
	$('.tempImg').css("border","");
	$(obj).css({
		"border" : "solid 2px #aaaaaa"
	});
	$("#selectedImg").val(j);
}


// 리사이징 로직(같은 로직을 pra_editor_imgSetting.jsp(관리자페이지) 에도 적용해야 함)
/*
function selectFiles(obj,id){
	
	$("#smartimg_img").css({
		"background" : "#fff",
		"border": "1px solid #cfcfcf"
	});
	
	if (nImageFileCount >= 20){
		alert("최대 20장까지만 등록할 수 있습니다.");
		return;
	}
	//변수 선언
	var wel,
		files,
		nCount,
		sListTag = '';
	
	//초기화	
	files = obj.files;
	nCount = files.length;
	
	if (!!files && nCount === 0){
		//파일이 아닌, 웹페이지에서 이미지를 드래서 놓는 경우.
		return ;
	}
	
	var rFilter = /^(image\/bmp|image\/gif|image\/jpg|image\/jpeg|image\/png)$/i;  
	var nMaxImageSize = 20*1024*1024;
	var nMaxImageCount = 20;
	
	for (var i = 0, j = nImageFileCount ; i < nCount ; i++){
		if (!rFilter.test(files[i].type)) {
			alert("이미지파일 (jpg,gif,png,bmp)만 업로드 가능합니다.");
		} else if(files[i].size > nMaxImageSize){
			alert("이미지 용량이 20MB를 초과하여 등록할 수 없습니다.");
		} else {
			//제한된 수만 업로드 가능.
			if ( j < nMaxImageCount ){
				//이미지 저장
				var resizedImgFile = ResizeImage(files[i]);
				//다음 사진을위한 셋팅
				j = j+1;
				nImageFileCount = nImageFileCount+1;
				
			} else {
				alert("최대 20장까지만 등록할 수 있습니다.");
				break;			
			}
		}
	}
}

function ResizeImage(file) {

	var imgFile;
	var reader = new FileReader();
	var fileName = cuttingNameByLength(file.name, 15);
	
	reader.onload = function (e) {
		var img = new Image;
		img.src = e.target.result;
		img.alt = fileName;
		
		img.onload = function() {
			tmpObj = getImgFile(img); // 여기서 이미지 객체 img를 활용하여 썸네일 처리를 할 수 있음
			//이미지 저장
			addImage(tmpObj);
			
			html5Upload();
// 			return imgFile;
		};
		img.onerror = function() {
		  // 에러가 나는 경우 처리를 할 수 있음
			  
		};
		
		img.src = reader.result;
	};
	
	reader.readAsDataURL(file); // 파일객체를 넣어줌

}


function getImgFile(_IMG) {
	// canvas에 이미지 객체를 리사이징해서 담는 과정
	var canvas = document.createElement("canvas");

	var maxSize = 1280; // 최대px 400px 기준
	var width = _IMG.width; 
	var height = _IMG.height; 
	
	if (width > height) { 
	    if (width > maxSize) {
	        height *= maxSize / width;
	        width = maxSize;
	    }
	} else {
	    if (height > maxSize) {
	        width *= maxSize / height;
	        height = maxSize;
	     }
	}
	canvas.width = width;	// 리사이징하여 그릴 가로 길이
	canvas.height = height;	// 리사이징하여 그릴 세로 길이
	canvas.getContext("2d").drawImage(_IMG, 0, 0, width, height);
	
	// canvas의 dataurl를 blob(file)화 하는 과정
	var dataURL = canvas.toDataURL("image/jpeg"); // png, jpg 등으로 변환 가능
	var byteString = atob(dataURL.split(',')[1]);
	var mimeString = dataURL.split(',')[0].split(':')[1].split(';')[0];
	var dataName = _IMG.alt;
	var ab = new ArrayBuffer(byteString.length);
	var ia = new Uint8Array(ab);
	for (var i = 0; i < byteString.length; i++) {
		ia[i] = byteString.charCodeAt(i);
	}
	
	// 리사이징된 file 객체
	var tmpImgFile = new Blob([ab], {type: mimeString});
	var tmpObj = {};
	tmpObj['file'] = tmpImgFile;
	tmpObj['name'] = dataName;
	
	return tmpObj;
}

function addImage(tmpObj){
	//파일 사이즈
    var ofile = tmpObj['file'],
		sFileSize = 0,
		sFileName = "",
		sLiTag = "",
		bExceedLimitTotalSize = false,
		aFileList = [];
	
	sFileSize = setUnitString(ofile.size);
    sFileName = tmpObj['name'];
	bExceedLimitTotalSize = checkTotalImageSize(ofile.size);

	if( !!bExceedLimitTotalSize ){
		alert("전체 이미지 용량이 50MB를 초과하여 등록할 수 없습니다. \n\n (파일명 : "+sFileName+", 사이즈 : "+sFileSize+")");
	} else {
		//이미지 정보 저장							
        htImageInfo['img'] = tmpObj;
	}
}

function html5Upload() {	
	var tempFile,
		sUploadURL;
	sUploadURL= '/async/file_uploader_html5/insertAjax.do'; 	//upload URL
	//파일을 하나씩 보내고, 결과를 받음.
	tempFileMap = htImageInfo['img'];
		try{
    		if(!!tempFileMap){
    			callAjax(tempFileMap,sUploadURL);
    		}
    	}catch(e){
    		console.log(e);	
    	}
		tempFile = null;
}
	
function callAjax(tempFileMap, sUploadURL){
	
	var form = $("#Form")[0];
	var formData = new FormData(form);
	formData.append("EditorImg", tempFileMap['file']);

	$.ajax({
		type: "post",
		url : sUploadURL,
		data : formData,
		enctype: 'multipart/form-data',
		contentType : false,
        processData : false, 
        cache: false,
		beforeSend : function(request){
            request.setRequestHeader("file-name",encodeURIComponent(tempFileMap['name']));
			request.setRequestHeader("file-size",tempFileMap['file'].size);
			request.setRequestHeader("file-Type",tempFileMap['file'].type);
			request.setRequestHeader("menuName",'${currentMenu.MN_KEYNO}');
	        },
		success : function(data){
			if(data.indexOf("NOTALLOW_") > -1){
// 				var sFileName = sResString.replace("NOTALLOW_", "");
				alert("이미지 파일(jpg,gif,png,bmp)만 업로드 하실 수 있습니다.");
			}else{
				imgarray.push(makeArrayFromString(data));
				aResult = [];
				var miricnt = imgarray.length;
				fileMiribogi(miricnt-1);
			}
		},
		error : function(e){
			console.log(e);
		}
	});
}

*/

</script>
