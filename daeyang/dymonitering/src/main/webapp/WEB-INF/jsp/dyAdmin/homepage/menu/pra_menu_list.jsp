<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>

<style>
#menuIconView {font-size:50px; margin:15px 5px;}
div[id*=LINKBOX] {display:none;}

.popup_dl {
	margin-right: 12px;
}

.popup_select {
	padding-left:10px;
}

</style>

<!-- 내용시작 -->
<div id="content">
	<div class="row">
		<article class="col-sm-12 col-md-12 col-lg-12" id="menu-article-1">
			<div class="jarviswidget jarviswidget-color-magenta" id="menu_master_1" data-widget-editbutton="false">
 					<header>
   					<span class="widget-icon"> <i class="fa fa-lg fa-th-large"></i> </span>
   					<h2>메뉴관리</h2>
 					</header> 
 				<div> 
 				<div class="jarviswidget-editbox"></div>
 				<div class="widget-body menuList">
 					<div class="widget-body-toolbar bg-color-white">
   					<div class="alert alert-info no-margin fade in">
     						<button type="button" class="close" data-dismiss="alert">×</button>
     						추가/변경 하고싶은 홈페이지 선택 <i class="fa-fw fa fa-caret-right"></i>
     						아이콘을 사용해서 원하는 기능을 시작
     						<br />
						<i class="fa fa-pencil" style="color:red; "></i> : 관리하기,
						<i class="fa fa-plus" style="color:red; "></i> : 추가하기,
						<i class="fa fa-check-square-o" style="color:red; "></i> : 사용중,
						<i class="fa fa-square-o" style="color:red; "></i> : 사용안함, 
						<i class="fa fa-trash-o" style="color:red; "></i> : 삭제하기,
						<i class="fa fa-retweet" style="color:red; "></i> : 페이지만들기,
						<i class="fa fa-lock" style="color:red; "></i> : 메뉴 감추기,
						<i class="fa fa-unlock" style="color:red; "></i> : 메뉴 보이기,
						<i class="fa fa-sign-in" style="color:red; "></i> : 권한 관리 ,
<!-- 							<i class="fa fa-edit" style="color:red; "></i> : 페이지 상세보기  or 페이지 등록, -->
						<i class="fa fa-book" style="color:red; "></i> : 게시물 관리,
						<i class="fa fa-exchange" style="color:red; "></i> : 메뉴뎁스이동,
						<i class="fa fa-repeat" style="color:red; "></i> : QR초기화
   					</div> 
 					</div>  
 					<div class="widget-body-toolbar bg-color-white">
   					<form:form class="form-inline" role="form">
     						<div class="row">
	       						<div class="col-sm-12 col-md-12">
									<button type="button" class="btn btn-default" onclick="pf_excelDownHome()">
										<i class="fa fa-table"></i> 홈페이지 엑셀
									</button>
									<button type="button" class="btn btn-default" onclick="pf_qrchangeAll()">
										<i class="fa fa-repeat"></i> 전체 QR 초기화
									</button>
									<button type="button" class="btn btn-default" onclick="pf_xmlHistory()">
										<i class="fa fa-save"></i> 홈페이지 백업
									</button> 
								</div>
							</div>
					</form:form>
				</div>
				<!-- tree 시작 -->
				<div class="tree">
					<ul>
						<li class="parent_li" data-key="${menu.MN_KEYNO }" id="homeName"> 
							<span class="label label-primary">
								<i class="fa fa-lg fa-plus-circle">${menu.MN_NAME }</i>
							</span>
							<button type="button" class="btn bg-color-blueDark txt-color-white btn-xs " onclick="pf_Set_MenuManagerView('Insert','${menu.MN_HOMEDIV_C}', '${menu.MN_KEYNO}','${menu.MN_LEV}','${menu.MN_URL }')" data-toggle="tooltip" data-placement="top" title="추가하기"><i class="fa fa-plus"></i></button>
							
							<!-- depth1Group 시작 -->
 								<ul id="depth1Group">
								</ul>
							<!-- depth1Group 끝 -->
						</li>
					</ul>
				</div>
				<!-- tree 끝 -->
			</div>
		</article>
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-6">
			<form:form id="Form" method="post">
				  <input type="hidden" id="MN_KEYNO" name="MN_KEYNO" value=""/>
				  <input type="hidden" id="MN_NAME" name="MN_NAME" value=""/>
				  <input type="hidden" id="MN_HOMEDIV_C" name="MN_HOMEDIV_C" value="${menu.MN_HOMEDIV_C }"/>
				  <input type="hidden" id="MN_PAGEDIV_C" name="MN_PAGEDIV_C" value=""/>
				  <input type="hidden" id="MN_BT_KEYNO" name="MN_BT_KEYNO" value=""/>
				  <input type="hidden" id="MN_MAINKEY" name="MN_MAINKEY" value=""/>
				  <input type="hidden" id="MN_ORDER" name="MN_ORDER" value=""/>
				  <input type="hidden" id="MN_ORDER_BEFORE" name="MN_ORDER_BEFORE" value=""/>
				  <input type="hidden" id="MN_LEV" name="MN_LEV" value=""/>
				  <input type="hidden" id="MN_USE_YN" name="MN_USE_YN" value=""/>
				  <input type="hidden" id="MN_SHOW_YN" name="MN_SHOW_YN" value=""/>
				  <input type="hidden" id="MN_EMAIL" name="MN_EMAIL" value=""/>
				  
				  <input type="hidden" id="processType" name="processType" value=""/>
				  
				  <input type="hidden" id="MN_beforeURL" name="MN_beforeURL" value=""/>
				  <input type="hidden" id="MN_URL" name="MN_URL" value=""/>
				  <input type="hidden" id="MN_FORWARD_URL" name="MN_FORWARD_URL" value=""/>
				  
				  <input type="hidden" id="depthURL" value=""/>
				  <input type="hidden" id="depthIntroURL" value=""/>
				  
				  <input type="hidden" id="MN_DEP" name="MN_DEP" value="" />
				  <input type="hidden" id="MN_COLOR" name="MN_COLOR" value="" />
				  <input type="hidden" id="MN_DATA1" name="MN_DATA1" value="" />
				  <input type="hidden" id="MN_DATA2" name="MN_DATA2" value="" />
				  <input type="hidden" id="MN_DATA3" name="MN_DATA3" value="" />
				  <input type="hidden" id="MN_ENG_NAME" name="MN_ENG_NAME" value="" />
				  <input type="hidden" id="MN_ICON_CSS" name="MN_ICON_CSS" value="" />
				  <input type="hidden" id="MN_ICON_URL1" name="MN_ICON_URL1" value="" />
				  <input type="hidden" id="MN_ICON_URL2" name="MN_ICON_URL2" value="" />
				  <input type="hidden" id="MN_AUTHORITY" name="MN_AUTHORITY" value="" />
				  <input type="hidden" id="MN_AUTHORITY_KEY" name="MN_AUTHORITY_KEY" value="" />
				  
				  <input type="hidden" id="MN_RESEARCH" name="MN_RESEARCH" value="${menu.MN_HOMEDIV_C eq sp:getData('HOMEDIV_ADMIN') ? 'N' : ''}" />
				  <input type="hidden" id="MN_QRCODE" name="MN_QRCODE" value="${menu.MN_HOMEDIV_C eq sp:getData('HOMEDIV_ADMIN') ? 'N' : ''}" />
				  <input type="hidden" id="MN_MANAGER" name="MN_MANAGER" value="" />
				  <input type="hidden" id="MN_MANAGER_DEP" name="MN_MANAGER_DEP" value="" />
				  <input type="hidden" id="MN_MANAGER_TEL" name="MN_MANAGER_TEL" value="" />
				  <input type="hidden" id="MN_DU_KEYNO" name="MN_DU_KEYNO" value="" />
				  <input type="hidden" id="MN_TOURKEY" name="MN_TOURKEY" value="" />
				  
				  <input type="hidden" id="MN_GONGNULI_YN" name="MN_GONGNULI_YN" value="" />
				  <input type="hidden" id="MN_GONGNULI_TYPE" name="MN_GONGNULI_TYPE" value="" />
				  
				  <input type="hidden" id="XH_FS_KEYNO" name="XH_FS_KEYNO" value="" />
				  <input type="hidden" id="MN_QR_KEYNO" name="MN_QR_KEYNO" value="" />
				  <input type="hidden" id="MN_NEWLINK" name="MN_NEWLINK" value="" />
				  
				  <input type="hidden" id="MN_META_DESC" name="MN_META_DESC" value="" />
				  <input type="hidden" id="MN_META_KEYWORD" name="MN_META_KEYWORD" value="" />
				  
				  
				<div id="menuListWrap"></div>
			</form:form>
		</article>
	</div>
</div>


<script type="text/javascript">

$(document).ready(function() {
	//xml 히스토리
	pf_create_layerDialog("Xml-history", "backup", "XML히스토리", "pf_Xml_backup()");
	
	pf_homeMenuList($("#MN_HOMEDIV_C").val());
  
	$('.menuList .tree > ul').attr('role', 'tree').find('ul').attr('role', 'group');
	$('.menuList .tree li.parent_li > ul > li').hide();
	$('.menuList .tree').find('.parent_li').attr('role', 'treeitem').find(' > span').attr('title', 'Collapse this branch').on('click', function(e) {
		var children = $(this).parent('li.parent_li').find(' > ul > li');
		if (children.is(':visible')) {
			children.hide('fast');
			$(this).attr('title', 'Expand this branch').find(' > i').removeClass().addClass('fa fa-lg fa-plus-circle');
		} else {
			children.show('fast');
			$(this).attr('title', 'Collapse this branch').find(' > i').removeClass().addClass('fa fa-lg fa-minus-circle');
		}
		e.stopPropagation();
	});	
	$('.menuList .tree > ul > li > span').trigger('click');	
});

function pf_homeMenuList(key){
	$.ajax({
		type: "POST",
		url: "/dyAdmin/homepage/menuListAjax.do",
		data: {"HM_MN_HOMEDIV_C":key},
		async: false,
		success : function(data){
			$('#depth1Group').html(data)
		}, error: function(){
			cf_smallBox('error', "알수없는 에러, 관리자에게 문의하세요.", 3000,'#d24158');
			return false;
		}
	});
}

//홈페이지 변경 처리
function pf_changeHomeDiv(value){
	$("#MN_HOMEDIV_C").val(value);
    $("#Form").attr("action","/dyAdmin/homepage/menumanage/menu.do");
    cf_loading();
    $("#Form").submit();
}


//홈페이지 엑셀다운
function pf_excelDownHome(){
	cf_checkExcelDownload();
	
	$("#Form").attr('action','/dyAdmin/homepage/menu/excelAjax.do');
	$("#Form").submit();
	
}

//xml 리스트
function pf_xmlHistory(){
	$.ajax({
		type: "POST",
		url: "/dyAdmin/homepage/menu/xmlList/listAjax.do",
		async: false,
		data: {
			"MN_HOMEDIV_C"	: $('#MN_HOMEDIV_C').val()
		},
		success : function(data){
		  	temp = "";
		  	if(data.length > 0){
		  		$.each(data,function(i){
			  		temp += '<tr>';
				  	temp += '<td>'+data[i].FS_ORINM+'</td>';
				  	temp += '<td>'+data[i].REGDT+'</td>';
				  	temp += '<td><a href="javascript:;" class="btn btn-labeled btn-success" type="button" onclick="cf_download(\''+data[i].encodeFsKey+'\')" style="padding:3%; margin-right: 15px;"><i class="fa fa-check"></i> 파일다운</a>';
				  	temp += '<a href="javascript:;" class="btn btn-info" type="button" onclick="pf_Xml_Refresh(\''+data[i].encodeFsKey+'\')" style="padding:3%;"><i class="glyphicon glyphicon-refresh"></i> 복원하기</a></td>';
				  	temp += '<td><a href="javascript:;" class="btn btn-danger" type="button" onclick="pf_Xml_Delete(\''+data[i].encodeFsKey+'\')" style="padding:5%;"><i class="fa fa-remove"></i> 삭제하기</a></td>'
				  	temp += '</tr>';
			  	});
		  	}else{
		  		temp += '<tr><td colspan="4">백업파일이 없습니다.</td></tr>';
		  	}
		  	$("#XmlListTable tbody").html(temp);
		  	$('#Xml-history').dialog('open');
		}, error: function(){
	        cf_smallBox('error', 'xml 히스토리 가져오기 에러', 3000,'#d24158');
			return false;
		}
	});
	
}

//xml 파일 백업하기
function pf_Xml_backup(){
	cf_checkExcelDownload();
	var url = '/dyAdmin/homepage/menu/xmlList/backupAjax.do';
	$.ajax({
		type: "POST",
		url: url,
		data: $("#Form").serialize(),
		success : function(){
			pf_xmlHistory();
			cf_smallBox('ajax', "백업을 완료하였습니다.", 3000);
			cf_loading_out();
		}, error: function(){
			cf_smallBox('error', "알수없는 에러, 관리자에게 문의하세요.", 3000,'#d24158');
			return false;
		}
	});
}

//xml 복원하기
function pf_Xml_Refresh(key){
	$("#XH_FS_KEYNO").val(key);
	$.ajax({
		type: "POST",
		url: '/dyAdmin/homepage/menu/xmlList/refreshAjax.do',
		data: $("#Form").serialize(),
		success : function(data){
			cf_smallBox('ajax', "복원을 완료하였습니다.", 3000);
			pf_changeHomeDiv(data);
		}, error: function(){
			cf_smallBox('error', "알수없는 에러, 관리자에게 문의하세요.", 3000,'#d24158');
			return false;
		}
	});
}

//xml 삭제하기
function pf_Xml_Delete(key){
	$.ajax({
		type: "POST",
		url: '/dyAdmin/homepage/menu/xmlList/deleteAjax.do',
		data: {"XH_KEYNO":key},
		success : function(data){
			cf_smallBox('ajax', "삭제완료", 3000);
			pf_xmlHistory();
		}, error: function(){
			cf_smallBox('error', "알수없는 에러, 관리자에게 문의하세요.", 3000,'#d24158');
			return false;
		}
	});
}


//게시판 관리로가기
function pf_boardmanagement(key){
	location.href="/dyAdmin/homepage/board/dataView.do?MN_KEYNO="+key;
}


//기능 Ajax 처리 공통
function pf_Access_Ajax(url, msg, type, key, processType, oriMain){

	$.ajax({
		type: "POST",
		url: url,
		async: false,
		data: $("#Form").serialize(),
		success : function(data){
			var DataType = '';
			if(msg){ 
				cf_smallBox('Form', msg, 3000);
			}
			if(type == 'manager'){
				if(processType == 'Update'){
					DataType = 'Y'
				}
				pf_Set_MenuManagerView('Update',data.MN_HOMEDIV_C,data.MN_MAINKEY,data.MN_LEV,data.MN_KEYNO,'menu'); //오른쪽 데이터 나오게 처리
			}else if(type == 'show'){
				DataType = data.MN_SHOW_YN;
			}else if(type == 'use'){
				DataType = data.MN_USE_YN;
			}
			
			if(oriMain != null && oriMain != ""){
				pf_CallBack_Success(data.MN_KEYNO, oriMain, data.MN_HOMEDIV_C);			//메뉴 뎁스 변경시 기존꺼 안보이게 처리
			}
			pf_CallBack_Success(data.MN_KEYNO, data.MN_MAINKEY, data.MN_HOMEDIV_C, DataType);
		}, error: function(){
			cf_smallBox('error', '에러발생, 관리자에게 문의하세요.', 3000,'#d24158');
		}
	});
	$('[data-toggle="tooltip"]').tooltip();
}

//sub 메뉴 리스트 가져오기
function pf_getSubList(key, homekey){
	
	homekey = homekey || $('#MN_HOMEDIV_C').val();
	
	var temp= '';
	$.ajax({
		type: "POST",
		url: "/dyAdmin/homepage/menu/subList/listAjax.do",
		async: false,
		data: {
			"MN_HOMEDIV_C"	: homekey,
			"MN_MAINKEY"	: key
		},
		success : function(data){
		  	temp = data;
		}, error: function(){
			cf_smallBox('error', '메뉴 리스트 가져오기 에러', 3000,'#d24158');
			return false;
		}
	});
	return temp;
}
  
// 등록, 수정 완료 후 처리
// 해당 메뉴 다시 불러옴
function pf_CallBack_Success(key, parentKey, homekey, DataType){
// 	pf_CallBack_Success(data.MN_KEYNO, data.MN_MAINKEY, data.MN_HOMEDIV_C, DataType)

	$parentLi = $('li.parent_li[data-key="' + parentKey +'"]');
	$parentLi.find('ul').html(pf_getSubList(parentKey,homekey));

	$parentLi.find('ul').find('li.parent_li > ul > li').hide();
	$parentLi.find('ul').find('.parent_li').attr('role', 'treeitem').find(' > span').attr('title', 'Collapse this branch').on('click', function(e) {
		var children = $(this).parent('li.parent_li').find(' > ul > li');
		if (children.is(':visible')) {
			children.hide('fast');
			$(this).attr('title', 'Expand this branch').find(' > i').removeClass().addClass('fa fa-lg fa-plus-circle');
		} else {
			children.show('fast');
			$(this).attr('title', 'Collapse this branch').find(' > i').removeClass().addClass('fa fa-lg fa-minus-circle');
		}
		e.stopPropagation();
	});	
	
	if(DataType == 'Y'){
		$parentLi.find('li.parent_li').each(function(){
			var dataKey = $(this).data('key');
			if(dataKey == key){
				$(this).find('> span').trigger('click');
			}
		})	
	}
}

// 레이어창 다이얼로그 생성하기 
function pf_create_layerDialog(a,b,c,d){
	var btn_name = "";
	if(b == 'update'){
		btn_name = "변경하기";
	}else if(b == 'insert'){
		btn_name = "저장하기";
	}else if(b == 'backup'){
		btn_name = "백업하기";
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
  

function pf_urlSetting(obj){
	var value = $(obj).val();
	value = value.toLowerCase();
	$(obj).val(value);
	$('#form_newHome input[name=MN_URL]').val("/" + value);
}
  
/* 폼 갯수 많을 때 입력 체크 - 미입력 폼으로 포커싱까지  */
function allInputCheck_notNull($form){
	var trueFalse = true;
	$($form + ' input').not('[type=hidden], [name=_csrf], .exceptForm').each(function(){
		if( !$(this).val().trim() ){
			cf_smallBox('error', '해당 값을 입력해주세요.', 3000,'#d24158');
			$(this).focus();
			trueFalse = false;
			return false;
		}
	})
	return trueFalse;
}
  
/* 선택메뉴 보이기/감추기 처리 */
function pf_ShowUseChecking(key,val,type){
	var id;
	var msg = '';
	if(type == 'show'){
		id = 'MN_SHOW_YN'
		if(val == 'N'){
			msg = '숨기기 처리가 완료되었습니다.';
		}else{
			msg = '보이기 처리가 완료되었습니다.';
		}
	}else{
		id = 'MN_USE_YN'
		if(val == 'N'){
	 		msg = '비활성화 처리가 완료되었습니다.';
	 	}else{
	 		msg = '활성화처 리가 완료되었습니다.';
	 	}
	}
	
	$("#MN_KEYNO").val(key);
	$("#processType").val(type);
	$("#"+id).val(val); 
	pf_Access_Ajax("/dyAdmin/homepage/menu/show/updateAjax.do",msg,type);
}
    
/* 메뉴 논리 삭제 */
function pf_MenuDelete(a,b){
	cf_confirm("삭제하시겠습니까?","pf_MenuDeleteAccess('"+a+"','"+b+"')");
} 
  
// 메뉴 삭제 콜백 처리 
function pf_MenuDeleteAccess(key,mainkey){
	
	mainkey = mainkey || $('#MN_MAINKEY').val();
	
	$("#MN_KEYNO").val(key);
	pf_Access_Ajax("/dyAdmin/homepage/menu/deleteAjax.do","삭제처리가 완료 되었습니다.",'delete');
}
  

/* 메뉴 생성 , 수정 */
function pf_Set_MenuManagerView(type,homekey,mainkey,lev,tVal,name){
	
	// 메뉴 생성 시 기존 KEYNO 값을 지워준다.
	if(type == 'Insert'){
		$("#MN_KEYNO").val('');
	}
	
	
	pf_checkArticleSize();
	
	/* tVal
	   type = Insert 일 경우 main메뉴의 url, 
	   type = Update 일 경우 해당 메뉴의 key  */
   $.ajax({
		type: "POST",
		url: "/dyAdmin/homepage/menu/menuManagerAjax.do",
		data: {
			"MN_HOMEDIV_C":homekey,
			"MN_MAINKEY":mainkey,
			"action":type,
			"name":name,
			"lev":lev,
			"tVal":tVal
		},
		async:false,
	   		success : function(result){
	   			$("#menuListWrap").html(result);	
	   	}, error: function(){
	     	return false;
	   	}
	});
}
 

//URL 중복 검사 처리
function pf_urlCheck(url,key){
	var urlCheck = true;
	$.ajax({
		type: "POST",
		url: "/dyAdmin/homepage/menu/urlCheckAjax.do",
		async: false,
		data: {
			"MN_URL"	: url,
			"MN_KEYNO"	: key || ''
		},
		success : function(data){
		  	if(data > 0){
		  		urlCheck = false;
		  	}
		}, error: function(){
			cf_smallBox('Form', 'URL 중복검사 에러', 3000,'#d24158');
			return false;
		}
	});
	
	return urlCheck;
} 

function pf_moveTop(){
	$( 'html, body' ).animate( { scrollTop : 0 }, 400 );
}

//세팅된 값들을 초기화 시킴 - form 1개만 컨트롤하기 위해 사용
function pf_resetForm(){
	var MN_HOMEDIV_C_bak = '${homeKey}';
	$('#Form + input').val('');
	$('#MN_HOMEDIV_C').val(MN_HOMEDIV_C_bak);
}


function pf_checkArticleSize(){
	if($('#menu-article-1').hasClass('col-lg-12')){
		$('#menu-article-1').removeClass('col-lg-12').addClass('col-lg-6');
	}
}

//QR코드 초기화
function pf_qrchange(key,url){
	
	$.ajax({
		type:"post",
		url : "/dyAdmin/user/QRcodeAjax.do",
		data : {"MN_KEYNO":key,"MN_URL":url},
		success:function(){
			cf_smallBox('ajax', "QR코드 초기화를 완료하였습니다.", 3000);
		},
		error:function(){
			alert("에러 발생");
		}
	});
}

//QR전체 초기화
function pf_qrchangeAll(){
	var home_keyno = $(".input-sm").val();
	
	$.ajax({
		type:"post",
		url : "/dyAdmin/user/AllQRcodeAjax.do",
		data : {"MN_HOMEDIV_C":home_keyno},
		success:function(){
			cf_smallBox('ajax', "전체 QR코드 초기화를 완료하였습니다.", 3000);
		},
		error:function(){
			alert("에러 발생");
		}
	});
}

function pf_menuDethMoveOpen(){
	$('#menuDethMove').dialog('open');
}

function pf_menuDethMoveChange(){
	
}
</script>

<%@ include file="/WEB-INF/jsp/dyAdmin/homepage/menu/script/pra_menu_list_authority_script.jsp" %>
<%@ include file="/WEB-INF/jsp/dyAdmin/homepage/menu/pra_menu_xml_pop.jsp" %>