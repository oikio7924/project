<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link href="/resources/api/uploadfile/uploadfile.css" rel="stylesheet">
<script src="/resources/api/uploadfile/jquery.uploadfile.js"></script>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<style>

#uploadFileDiv .row {border: 1px solid black;margin: 0;padding: 15px; }
.txtDefault {
    min-height: 32px;
    padding: 3px 5px;
    font-size: 14px;
}
.width100Per {
    width: 90%;
}

.width80Per {
	width: 80%;
}

.width10PerSpan {
	display:inline-block;
	width: 13%;
}

.ajax-upload-dragdrop{
	width : 90% !important;
}

input[type=text], input[type=number], input[type=password] {
    vertical-align: middle;
    border: 1px solid #cfcfcf;
    padding: 3px 10px;
}

.ajax-file-upload-statusbar {position:relative;}
.iconBox {position: absolute;top: 5px;right: 5px;}
.iconBox .material-icons {color: #999;border: 1px solid;font-size: 19px;}
.iconBox .material-icons:hover {color: #333;}
.fileCounter {color: #0ba1b5;font-size: 20px;}

</style>

<fieldset class="smart-form" >
	<div id="uploadFileDiv">
	    <div class="row">
			<section class="col col-12" style="margin-bottom:0px;">
				<div id="AM_UPLOAD"> 
					<div id="previewupload">Upload</div>
				</div>
	       </section>
		</div>	 
	</div>
</fieldset>

<script>

var fileUpload;
var isLoaded = false;
var deleteFileKeys = new Array();
var chkArr;
var nameArr;
$(function(){
	pf_fileUpload()
});

function pf_fileUpload(){
	fileUpload = $("#previewupload").uploadFile({
		 url:"/async/file/MultiFile/uploadAjax.do",
		 autoSubmit:false,
		 async:false,
		 fileName:"myfile",
		 showDelete: true,
		 showStatusAfterSuccess: false,
		 showFileCounter: true,
		 dynamicFormData: function()
		 {
		 	var data =  { 
		 		homePage : $("#homePage").val(),
		 		mainPath : $('#mainPath').val(),
		 		fileNmArr : $('#fileNmArr').val(),
		 		fileChkArr : $('#fileChkArr').val()
		 	};
		 	return data;
		 },
		 onSelect:function(data)
		 {
			 chkArr = new Array();
			 nameArr = new Array();
			 var nmArray = [];
				$('.file_original').each(function(){
					nmArray.push($(this).text().trim());
				})
			
			 for(var i=0; i<data.length; i++) {
				var originNm = data[i].name;
				nameArr.push(originNm);
					if(nmArray.indexOf(originNm) >= 0) {
						if(confirm('중복된 파일 이름('+originNm+')이 존재합니다. 겹쳐 쓰시겠습니까?')){
							chkArr.push("Y");
						}else{
							chkArr.push("N");
						}
					}else{
						chkArr.push("D");
					}
					
					newInsert();
			}
		 },
		 onSuccess:function(files,data,xhr,pd)
		 {
			$("#file_data").html(pf_getFileList($("#mainPath").val(),$("#mainDepth").val()));
		 },
		 onSubmit:function(data)
		 {   
		 },
		 afterUploadAll:function(obj)
		 {
		 }
		 ,
		 onError:function(files,data,xhr){
			 cf_loading_out();
		 }
		 ,
		 onLoad:function(obj)
	   	 {
		 },
		 deleteCallback: function (data, pd) 
		 {
			var thisKey = $(pd.statusbar).find('input[name=FS_KEYNO]').val()
			deleteFileKeys.push(thisKey);
		 }
	 }); 
}


function newInsert(){
	
	$('#fileNmArr').val(nameArr);
	$('#fileChkArr').val(chkArr);
	setTimeout(function(){
		fileUpload.startUpload();
	},500)
}


function pf_settingFileOrder(obj,action){
	
	$statusbar = $('.ajax-file-upload-statusbar');
	var length = $statusbar.length;
	
	if(obj){
		
		$thisObj = $(obj).parents('.ajax-file-upload-statusbar');
		
		var index = $statusbar.index($thisObj);
		if(action == 'up'){
			if(index == 0){
				return false;
			}else{
				$statusbar.eq(index-1).before($statusbar.eq(index))
			}
		}else if(action == 'down'){
			if(index == length - 1){
				return false;
			}else{
				$statusbar.eq(index + 1).after($statusbar.eq(index))
			}
		} 
	}
	
	$('.fileCounter').each(function(i){
		$(this).text((length - i)+').');
	})
	
}


</script>