<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<style>
#menuIconView {font-size:50px; margin:15px 5px;}
div[id*=LINKBOX] {display:none;}

.label-primary.folder_active {
	background-color: #DF8505;
    border: 1px solid #C67605;
}

.file_list {
	min-height: 400px;
}

#file_data, #file_upload {
	border: dotted 1px #aeaeae;
	padding : 10px;
}
#file_data {
	min-height : 400px;
	margin-top: 20px;
}

input[type=checkbox] {
	display: inline-block;
}

</style>

<!-- 폼 양식 설정 -->


<form:form action="" id="Form" name="Form" method="post" >
  <input type="hidden" id="homePage" name="homePage" value="${homePage }"/>
  <input type="hidden" id="FILE_NAME" name="FILE_NAME" value=""/>
  <input type="hidden" id="mainPath" name="mainPath" value=""/>
  <input type="hidden" id="mainDepth" name="mainDepth" value=""/>  
  <input type="hidden" id="fileNmArr" name="fileNmArr" value=""/>  
  <input type="hidden" id="fileChkArr" name="fileChkArr" value=""/>  
</form:form>

<!-- 내용시작 -->
<div id="content">
	<section id="widget-grid" class="">
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-4">
				<div class="jarviswidget jarviswidget-color-magenta"
				data-widget-editbutton="false" data-widget-togglebutton="false" 
				data-widget-colorbutton="false" data-widget-deletebutton="false" data-widget-fullscreenbutton="false">
  					<header>
    					<span class="widget-icon"> <i class="fa fa-lg fa-th-large"></i> </span>
    					<h2>웹폴더관리</h2>
  					</header> 
	  				<div class="jarviswidget-editbox"></div> 
	  				<div class="widget-body folderList">
	  					<div class="widget-body-toolbar bg-color-white">
	    					<div class="alert alert-info no-margin fade in">
	      						<button type="button" class="close" data-dismiss="alert">×</button>
	      						<br />
								<i class="fa fa-plus" style="color:red; "></i> : 추가하기,
								<i class="fa fa-pencil" style="color:red; "></i> : 수정하기,
								<i class="fa fa-download" style="color:red; "></i> : 폴더 다운로드,
								<i class="fa fa-trash-o" style="color:red; "></i> : 삭제하기
	    					</div> 
	  					</div>
						<div class="tree">
	  						<ul>
	    						<li class="parent_li" data-path="${homePage }"> 
									<span class="label label-primary">
										<i class="fa fa-lg fa-plus-circle">WEBFILE</i>
									</span>
									<button type="button" class="btn btn-primary btn-xs" title="폴더 등록하기" onclick="pf_Set_FolderInsertView('${homePage}','')"><i class="fa fa-plus"></i></button>
									<button type="button" class="btn btn-warning btn-xs" title="폴더 다운로드" onclick="pf_Set_FolderDownload('/${homePage}', '${homePage}')"><i class="fa fa-download"></i></button>
	  								<div class="group">
	  									<ul id="depthGroup"></ul>
									</div>
								</li>
							</ul>
						</div>
					</div>
				</div>
			</article>
			<article class="col-sm-12 col-md-12 col-lg-8">
				<div class="jarviswidget jarviswidget-color-darken" id="wid-id-1"
					data-widget-editbutton="false" data-widget-togglebutton="false" 
					data-widget-colorbutton="false" data-widget-deletebutton="false" data-widget-fullscreenbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-lg fa-th-large"></i></span>
						</span>
						<h2>파일 목록</h2>
					</header>
				
					<div class="jarviswidget-editbox"></div>
					<div class="widget-body folderList">
						<div class="widget-body-toolbar bg-color-white">
	    					<div class="alert alert-info no-margin fade in">
	      						<button type="button" class="close" data-dismiss="alert">×</button>
	      						<br />
								<i class="fa fa-pencil" style="color:red; "></i> : 수정하기,
								<i class="fa fa-check" style="color:red; "></i> : 저장하기,
								<i class="fa fa-times" style="color:red; "></i> : 취소하기,
								<i class="fa fa-download" style="color:red; "></i> : 파일 다운로드,
								<i class="fa fa-trash-o" style="color:red; "></i> : 삭제하기
	    					</div> 
	  					</div>
	  					
	  					<div id="file_upload">
							<%@ include file="/WEB-INF/jsp/dyAdmin/folder/file/pra_file_insertView.jsp"%>
						</div>
	  					
	  					<div class="col-sm-12 col-md-12 text-align-right" style="margin-top: 20px;">
							<div class="btn-group">  
								<button class="btn btn-sm btn-danger" type="button" onclick="pf_selectDelete()">
									<i class="fa fa-trash-o"></i> 선택 삭제
								</button>
							</div>
						</div>
						
						<div style="clear:both;"></div>
						
	  					
						<div class="file_list smart">
							<div id="file_data">
									
							</div>
						</div>
					</div>
				</div>
			</article>
		</div>
	</section>
</div>


<script type="text/javascript">

var refreshParentKey = '';

$(document).ready(function() {
	
 	//폴더 등록 레이어 창 화면 생성
	pf_create_layerDialog("Folder-insert", "insert", "폴더 생성","pf_Mainmenu_insert()");
	//폴더 수정 레이어 창 화면 생성
	pf_create_layerDialog("Folder-update", "update", "폴더 관리","pf_Mainmenu_update()");
	
  	// 폴더 트리 선택 이벤트 show/hide 처리
	$(document).on('click','.parent_li > span.label', function(e) {
		var children = $(this).parent('li.parent_li').find(' > ul > li');
		
		$('.parent_li > span.label').removeClass('folder_active');
		$(this).addClass('folder_active');
		
		
		$("#file_data").html(pf_getFileList($(this).parents('li.parent_li:first').data('path'),$(this).parents('li.parent_li:first').data('depth')));
		
		if (children.is(':visible')) {
			children.hide('fast');
			$(this).attr('title', 'Expand this branch').find(' > i').removeClass().addClass('fa fa-lg fa-plus-circle');
		} else {
			$(this).parent('li.parent_li').find('ul').hide().html(pf_getSubList($(this).parents('li.parent_li:first').data('path'), $(this).parents('li.parent_li:first').data('depth'))).show('fast');
		    $(this).attr('title', 'Collapse this branch').find(' > i').removeClass().addClass('fa fa-lg fa-minus-circle');
		}
		e.stopPropagation();
	});
	$('.folderList .tree > ul > li > span').trigger('click');	
});

//sub 폴더 리스트 가져오기
function pf_getSubList(path, depth){
	//처음 들어왔을 때 depth 값 지정
	if(typeof depth == "undefined" || !depth) depth = 1;
	var temp= '';
	 $.ajax({
		type: "POST",
		url: "/dyAdmin/homepage/webFolder/listAjax.do",
		async: false,
		 data: {
			"filePath"	: path,
			"fileDepth"	: depth
		}, 
		success : function(data){
		  	temp = data;
		}, error: function(){
			cf_smallBox('error', "폴더 리스트 가져오기 에러", 3000,'#d24158');
			return false;
		}
	}); 
	return temp;
}

//파일 리스트 가져오기
function pf_getFileList(key, depth){
	$('#mainPath').val(key);
	//처음 들어왔을 때 depth 값 지정
	if(typeof depth == "undefined" || !depth) depth = 1;
	var temp= '';
	 $.ajax({
		type: "POST",
		url: "/dyAdmin/homepage/webFolder/FilelistAjax.do",
		async: false,
		 data: {
			"mainPath"	: key,
			"mainDepth"	: depth
		}, 
		success : function(data){
		  	temp = data;
		}, error: function(request,error){
			cf_smallBox('error', "파일 리스트 가져오기 에러", 3000,'#d24158');
			return false;
		}
	}); 
	return temp;
}
  
      
// 등록, 수정 완료 후 처리
// 해당 폴더 다시 불러옴
function pf_CallBack_Success(parentKey, depth){
	if(typeof parentKey == "undefined" || !parentKey) parentKey = $('#homePage').val();
	$parentLi = $('li.parent_li[data-path="' + parentKey +'"]');
	$parentLi.find('ul').html(pf_getSubList(parentKey, depth));
}

// 레이어창 다이얼로그 생성하기 
function pf_create_layerDialog(a,b,c,d){
	var btn_name = "";
	if(b == 'update'){
		btn_name = "변경하기";
	}else if(b == 'insert'){
		btn_name = "저장하기";
	}
	$('#' + a).dialog({
		autoOpen : false, width : 800,  resizable : true, modal : true, title : c,
		buttons : [{ 
			html : "<i class='fa fa-floppy-o'></i>&nbsp;" + btn_name, "class" : "btn btn-primary", 
	        click : function() {
				if(eval(d)){
					$(this).dialog("close");  
				}
	        }
	  	}, { 
	  		html : "<i class='fa fa-times'></i>&nbsp; 취소하기", "class" : "btn btn-default", 
	        click : function() {
	          $(this).dialog("close");
			}
	  	}]
	});
}
  
// 레이어창 입력박스 체크 하기
function pf_Input_Check(){
	//폴더의 이름 입력 여부를 판단한다.
	if(!$("#FILE_NAME").val().trim()){
		cf_smallBox('form', "폴더명을 입력해주세요.", 3000,'#d24158');
		return false;
	}
	return true;
}
  
//기능 Ajax 처리 공통
function pf_Access_Ajax(url,msg,parentKey, depth, update){
	$.ajax({
		type: "POST",
		url: url,
		data: $("#Form").serialize(),
		success : function(data){
			if(msg){ 
				cf_smallBox('success', msg, 3000);
			}
				pf_CallBack_Success(parentKey, depth);
		}, error: function(){
			cf_smallBox('error', "작업중 에러가 발생했습니다. 관리자에게 문의하세요.", 3000,'#d24158');
			return false;
		}
	});
}

 //레이어창 값 정리 취득
function pf_getFolderAccess_val(a){
	$("#FILE_NAME").val($("#" + a + "-NAME").val().trim()); // 폴더명
}
  

//폴더 등록폼  
function pf_Set_FolderInsertView(key, depth){
	//폼 초기화
   	pf_resetForm();
   	$('#mainPath').val(key); //비동기 폴더갱신할 때 사용
   	$('#mainDepth').val(depth);
   	$('#Folder-insert').dialog('open');
   	//^=특정값으로 시작하는 객체 찾기
   	$('input[id^=Folder-insert]').val('');
   	
}

//폴더 수정폼
function pf_Set_FolderUpdateView(key,name,depth){
    pf_resetForm();
   	$('#mainPath').val(key); //비동기 폴더갱신할 때 사용
   	$('#mainDepth').val(depth);
	$("#Folder-update-NAME").val(name);
	$('#Folder-update').dialog('open');
}
  
//폴더 등록 처리
function pf_Mainmenu_insert(){
	pf_getFolderAccess_val("Folder-insert");
	
	if(!pf_Input_Check()){
		return false;
	}
	pf_Access_Ajax("/dyAdmin/homepage/webFolder/folderInsertAjax.do","저장이 완료 되었습니다.", $('#mainPath').val(),$('#mainDepth').val() );
	
	return true;
}

//폴더 수정 처리
function pf_Mainmenu_update(){
	pf_getFolderAccess_val("Folder-update");
	
	if(!pf_Input_Check()){
		return false;
	}
	var oldPath = $('#mainPath').val();
	var newPath = oldPath.substring(0,oldPath.lastIndexOf("/"));
	pf_Access_Ajax("/dyAdmin/homepage/webFolder/folderUpdateAjax.do","변경이 완료 되었습니다.",newPath,$('#mainDepth').val());
	
	return true;
}

/* 폴더 삭제 */
function pf_FolderDelete(a,b){
	cf_confirm("폴더를 삭제하시겠습니까?","pf_FolderDeleteAccess('"+a+"','"+b+"')");
}   

// 폴더 삭제 콜백 처리 
function pf_FolderDeleteAccess(path,depth){
	depth = depth || $('#mainDepth').val();
	
	$("#mainPath").val(path);
	var newPath = path.substring(0,path.lastIndexOf("/"));
	pf_Access_Ajax("/dyAdmin/homepage/webFolder/folderDeleteAjax.do","삭제 처리가 완료 되었습니다.",newPath, depth);
	
	//삭제 후 파일리스트 가져오기
	$("#file_data").html(pf_getFileList(newPath, depth));
}
  
//세팅된 값들을 초기화 시킴 - form 1개만 컨트롤하기 위해 사용
function pf_resetForm(){
	$('#Form + input').val('');
}

//폴더 zip 다운로드
function pf_Set_FolderDownload(path, fileName){
	cf_loading();

	setTimeout(function(){
		pf_FolderDownload(path, fileName);
	},200);	
}

function pf_FolderDownload(path, fileName){
	$.ajax({
		type: "POST",
		url: "/dyAdmin/homepage/webFolder/folderDownAjax.do",
		data: {
			"mainPath" : path,
			"FILE_NAME" : fileName},
   		success : function(mainPath){
   			cf_loading_out();
			if(mainPath != null){
				pf_download_webFile(mainPath, "zip");			
			}	
	   	}, error: function(){
	   		cf_smallBox('error', "작업중 에러가 발생했습니다. 관리자에게 문의하세요.", 3000,'#d24158');
	   		cf_loading_out();
	     	return false;
	   	}
 	});
}

function pf_file_update(obj){
	var parent = $(obj).parent('li');
	
	parent.find('.file_original').hide();
	parent.find('.update_btn').hide();
	parent.find('.down_btn').hide();
	parent.find('.drop_btn').hide();
	parent.find('.copy_btn').hide();
	parent.find('.file_update').show();
	parent.find('.save_btn').show();
	parent.find('.cancel_btn').show();
}

function pf_file_ok(obj, path){
	var parent = $(obj).parent('li');
	
	$("#mainPath").val(path);
	$("#FILE_NAME").val(parent.find('.NEW_FILE_NAME').val());
	
	pf_File_Ajax("/dyAdmin/file/webFile/fileUpdateAjax.do","수정 처리가 완료 되었습니다.");
}

function pf_file_cancel(obj){
	var parent = $(obj).parent('li');
	
	parent.find('.file_original').show();
	parent.find('.update_btn').show();
	parent.find('.down_btn').show();
	parent.find('.drop_btn').show();
	parent.find('.copy_btn').show();
	parent.find('.file_update').hide();
	parent.find('.save_btn').hide();
	parent.find('.cancel_btn').hide();
}

function pf_file_copy(path){
		$.ajax({
		type: "POST",
		data: {"path" : path},
		url: "/dyAdmin/file/webFile/getWebfilePath.do",
		success : function(data){
			var copy = data;
			data = data.unescapeHtml();
			
			if(cf_copyToClipboard(data)){
				cf_smallBox('success', copy, 3000);
			}else{
				cf_smallBox('error', "복사하기 기능을 지원하지 않는 브라우저 입니다.", 3000,'#d24158');
			}
		}, error: function(){
			cf_smallBox('error', "작업중 에러가 발생했습니다. 관리자에게 문의하세요.", 3000,'#d24158');
			return false;
		}
	});
		
}

function pf_file_delete(path){

	cf_confirm("파일을 삭제하시겠습니까?","pf_FileDeleteAccess('"+path+"')");
}

//파일 삭제 콜백 처리 
function pf_FileDeleteAccess(path){
	
	$("#mainPath").val(path);
	pf_File_Ajax("/dyAdmin/file/webFile/fileDeleteAjax.do","삭제 처리가 완료 되었습니다.");
}

//기능 Ajax 처리 공통
function pf_File_Ajax(url,msg){
	$.ajax({
		type: "POST",
		url: url,
		data: $("#Form").serialize(),
		success : function(result){
			if(result == "duplicate"){
				cf_smallBox('form', "파일 이름명이 중복됩니다.", 3000,'#d24158');
				return false;
			}
			if(msg){ 
				cf_smallBox('success', msg, 3000);
			}
			// 변경된 파일이름 리스트 불러오기
			var oldPath = $('#mainPath').val();
			var newPath = oldPath.substring(0,oldPath.lastIndexOf("/"));
			$("#file_data").html(pf_getFileList(newPath,$("#mainDepth").val()));
			
		}, error: function(){
			cf_smallBox('error', "작업중 에러가 발생했습니다. 관리자에게 문의하세요.", 3000,'#d24158');
			return false;
		}
	});
}

function pf_selectDelete(){
	var Paths = [];
	$('input[name=FILE_PATH]:checked').each(function(){
		var path = $(this).val();
		
		Paths.push(path);
	})
	var length = Paths.length; 
	if(length == 0){
		cf_smallBox('form', "선택된 데이터가 없습니다.", 3000,'#d24158');
		return false;
	}
	
	if(confirm("선택한 파일들을 삭제하시겠습니까?")){
		$.ajax({
			type: "POST",
			url: "/dyAdmin/file/webFile/filesDeleteAjax.do",
			data: {
				'Paths' : Paths.join(',')
			},
			async:false,
			success : function(data){
				cf_smallBox('success', '삭제 처리가 완료 되었습니다.', 3000);
				$("#file_data").html(pf_getFileList($("#mainPath").val(),$("#mainDepth").val()));
			},
			error: function(){
				cf_smallBox('error', "작업중 에러가 발생했습니다. 관리자에게 문의하세요.", 3000,'#d24158');
				return false;
			}
		});
	}
}

function pf_download_webFile(path,zip){
	if(typeof zip == "undefined" || !zip) zip = "none";
	location.href="/async/file/MultiFile/download.do?mainPath=" + path + "&&zip=" + zip;
}
 
</script>

<%@ include file="/WEB-INF/jsp/dyAdmin/folder/pra_folder_pop.jsp" %>
