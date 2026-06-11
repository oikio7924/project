<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script>
var action = '${action}'
var name 	= '${name}'
$(function(){
	if(name){
		$('#'+name+'Link').trigger('click');
		var offset = $('#wid-id-1').offset();
        $('html, body').animate({scrollTop : offset.top}, 400);
	}
	$('#Mainmenu-COLOR').colorpicker();
 
 	var pageDivC = ''; 	
 	var level; 	
 	var thisUrl = '${resultData.MN_URL}'
	var EndOrder = Number('${length}');
 	
	if(action == 'Insert'){
	 	$('#Mainmenu-NAME').focus();
		$('#menuList-tab-content-1 .url-input span').text('${mainUrl}'+'/')
	 	pf_setUrlInputWidth();
		
		pageDivC = '${sp:getData("MENU_TYPE_SUBMENU")}'
		level	 = '${lev+1}'
		EndOrder = '${length+1}';
	}else{
		pageDivC = '${resultData.MN_PAGEDIV_C}'
		level	 = '${lev}'
		EndOrder = '${length}';
		
		$('#MN_KEYNO').val('${resultData.MN_KEYNO}')
		$("#MN_beforeURL").val(thisUrl);
		
		/* URL,preURL 가공&삽입 부분  */
		var url = thisUrl.split('/');
		if(url.length == 2){ //최상위 홈메뉴일 경우
			$('#Mainmenu-preURL').text('');
		   	$('#Mainmenu-URL').val(thisUrl);
		}else{
		   	var lastIndex = thisUrl.lastIndexOf('/')+1;
		   	$('#Mainmenu-preURL').text(thisUrl.substring(0,lastIndex));
		   	$('#Mainmenu-URL').val(thisUrl.substring(lastIndex));
		}
		pf_setUrlInputWidth('update');
		
		if(pageDivC == '${sp:getData("MENU_TYPE_SUBMENU")}'){ //소메뉴형
		   	var introUrl = '${resultData.MN_FORWARD_URL}';
		   	if(introUrl){
		   		introUrl = introUrl.substring(introUrl.lastIndexOf('/')+1)
		   	}
		   	$('#Mainmenu-INTRO_URL').val(introUrl);
		}
		
		if(pageDivC == '${sp:getData("MENU_TYPE_LINK")}'){ // 링크형
		   	$('#Mainmenu-LINKURL').val('${resultData.MN_FORWARD_URL}');
		}
		
			
		<c:if test="${Menu.MN_HOMEDIV_C eq sp:getData('HOMEDIV_ADMIN') }">
		pf_refreshIcon_updateForm('${resultData.MN_ICON_CSS}'); // CSS icon리스트 선택하기
		</c:if>
		
		var gonggondCK= '${resultData.MN_GONGNULI_YN}';
		if(typeof gonggondCK == 'undefined'){gonggondCK = 'N'}
		gonggnognuliShowHide(gonggondCK)
		if(gonggondCK == 'Y'){
			if('${resultData.MN_GONGNULI_TYPE}'){
				$("input[name=Mainmenu-GONGNULI_TYPE][value="+'${resultData.MN_GONGNULI_TYPE}'+"]").prop('checked',true);
			}
		}	
			
		if('${resultData.MN_DU_KEYNO}' == 'DU_0000000000'){
			$('.Mainmenu-DirectSelect').prop('checked',true);
			$("#Mainmenu-MANAGER").val('${resultData.MN_MANAGER}');
			$("#Mainmenu-MANAGERDEP").val('${resultData.MN_MANAGER_DEP}');
			$("#Mainmenu-MANAGERTEL").val('${resultData.MN_MANAGER_TEL}');
		}else{
			$('.Mainmenu-DirectSelect').prop('checked',false);
			$('#Mainmenu-DEPARTMENT').val('${resultData.DN_HOMEDIV_C}');
			pf_chageDepartMentCategory('${resultData.DN_HOMEDIV_C}','load','${resultData.DU_KEYNO}')
		}
	}
 	
	
	//메타 테그 사용 유무 변경 이벤트
	$('input[name=Mainmenu-METADESCYN]').on('change', function(){
        var value = $(this).val();
        
        if(value == 'Y'){
            $("#Mainmenu-METADESC").val('');
            $("#Mainmenu-METADESC").attr('readonly', true);
        }else if(value == 'N'){
        	$("#Mainmenu-METADESC").attr('readonly', false);
        }
    });
	
	$('input[name=Mainmenu-METAKEYWORDYN]').on('change', function(){
        var value = $(this).val();
        
        if(value == 'Y'){
            $("#Mainmenu-METAKEYWORD").val('');
            $("#Mainmenu-METAKEYWORD").attr('readonly', true);
        }else if(value == 'N'){
        	$("#Mainmenu-METAKEYWORD").attr('readonly', false);
        }
    });
	
	
	//정렬 순서 부분
 	for(var i = 1; i <= EndOrder; i++){
 		var option = $('<option>'+i+'</option>');
		$('#Mainmenu-ORDER').append(option);
 	}
	
 	if(action == 'Insert'){
 		$('#Mainmenu-ORDER option:last').prop("selected", true);
 	}else{
 		$("#Mainmenu-ORDER").val('${resultData.MN_ORDER}').prop("selected", true);
 	}
 
	//관리자페이지에서 메뉴타입 - 단일페이지, 관광 페이지형 숨김처리
	<c:if test="${Menu.MN_HOMEDIV_C eq sp:getData('HOMEDIV_ADMIN') }">
	$('select[id$=-PAGEDIV_C] option[value=${sp:getData("MENU_TYPE_PAGE")}]').hide();
	</c:if>

	$("#Mainmenu-LEV").val(level);
	$("#Mainmenu-MAINKEY").val('${Menu.MN_MAINKEY}');
	$("#Mainmenu-PAGEDIV_C").val(pageDivC);
	pf_setUrlInputWidth();
	pageRatingShowHide('${resultData.MN_RESEARCH}')
	pf_checkShowAndHide(pageDivC,0);
	
	$subMenu = $('#Mainmenu-PAGEDIV_C').find('option[value=${sp:getData("MENU_TYPE_SUBMENU")}]');
	if(Number('${lev}') >= Number('${homeData.HM_MENU_DEPTH }')-1){
		$subMenu.hide();
		pageDivC = '${sp:getData("MENU_TYPE_PAGE")}';
	}else{
		$subMenu.show();
	}
	
})


//페이지 구분에 따른 입력상자 Show/Hide
function pf_checkShowAndHide(value,childCnt){
	//하위메뉴가 있는경우 소메뉴 변경 불가
	if(parseInt(childCnt) > 0){
		cf_smallBox('error', '하위메뉴가 존재합니다.', 3000,'#d24158');
		$("#Mainmenu-PAGEDIV_C").val('${sp:getData("MENU_TYPE_SUBMENU")}').prop("selected", true);
		return false;
	}
	//URL 변경 처리
	if(value == '${sp:getData("MENU_TYPE_LINK")}'){ //링크형
  		$('#Mainmenu-LINKBOX').show();
  	}else{
  		$('#Mainmenu-LINKBOX').hide();
  	}
	
	<c:if test="${Menu.MN_HOMEDIV_C ne sp:getData('HOMEDIV_ADMIN') }">
	//페이지평가 제공 여부 - 소메뉴형과 링크형  제외 
	if(value != '${sp:getData("MENU_TYPE_SUBMENU")}' && value != '${sp:getData("MENU_TYPE_LINK")}'){
		$('.pageFiledset').show();
	}else{
		$('.pageFiledset').hide();
	}
	</c:if>
	
	<c:if test="${Menu.MN_HOMEDIV_C ne sp:getData('HOMEDIV_ADMIN') }">
	//메타 테그  여부 - 링크형 빼고 전부 다
	if(value != '${sp:getData("MENU_TYPE_LINK")}'){
		$('.metaInfo').show();
	}else{
		$('.metaInfo').hide();
	}
	</c:if>
	
	//소메뉴 타입 show/hide
  	if(value == '${sp:getData("MENU_TYPE_SUBMENU")}'){
  		$('.Mainmenu-SUBMENUBOX').show();
	}else{
		$('.Mainmenu-SUBMENUBOX').hide();
	}
	
	//게시판 타입 show/hide
  	if(value == '${sp:getData("MENU_TYPE_BOARD")}'){
  		$('#Mainmenu-BOARDTYPEBOX, #Mainmenu-EMAILBOX, #menuList-tab-content-2 .boardDiv').show();
  		$('input[name=accessRole], .noAccess').addClass('board');
  		$('input[name=accessRole].board, span.board').each(function(){
  			pf_changeBoardAuth($(this))
  		})
	}else{
		$('#Mainmenu-BOARDTYPEBOX, #Mainmenu-EMAILBOX, #menuList-tab-content-2 .boardDiv').hide();
		$('input[name=accessRole]').removeClass('board');
	}
	
}

//메뉴 등록,수정
function pf_Mainmenu_action(type){
	var url = '';
	var msg = '';
	var oriMain = '';
	var key = '${resultData.MN_KEYNO}';
	if(type == 'Insert'){
		url = '/dyAdmin/homepage/menu/insertAjax.do'
		msg = '저장이 완료 되었습니다.'
		key = '${Menu.MN_MAINKEY}'
	}else{
		url = '/dyAdmin/homepage/menu/updateAjax.do'
		msg = '변경이 완료 되었습니다.'
		key = '${resultData.MN_MAINKEY}'
	}
	
	pf_getMenuAccess_val("Mainmenu");
	
	if($('#dethCHANGEYN').val() == 'true'){ 		//뎁스 변경 됐을 경우
		if(!pf_deth_Input_Check()){
			return false;
		}else{
			oriMain = $('#dethOriMAIN').val(); 		//뎁스 변경 후 기존 메뉴 안보임 처리하기 위함
		}
	}
	
	if(!pf_Input_Check()){
		return false;
	}
	pf_Access_Ajax(url, msg, 'manager', key, type, oriMain);
}

//input 값 정리 취득
function pf_getMenuAccess_val(a){
	$("#MN_PAGEDIV_C").val($("#" + a + "-PAGEDIV_C").val()); //페이지구분
	
	var depthURL = $("#" + a + "-URL").val().trim();
	
	var url = $("#" + a + "-preURL").text() + depthURL;
	$("#MN_URL").val(url); //URL
	$('#depthURL').val(depthURL);
		
	$("#MN_DATA1").val($("#" +  a+ "-DATA1").val().trim());
	$("#MN_DATA2").val($("#" +  a+ "-DATA2").val().trim());
	$("#MN_DATA3").val($("#" +  a+ "-DATA3").val().trim());
	$("#MN_COLOR").val($("#" +  a+ "-COLOR").val().trim());
	$("#MN_ENG_NAME").val($("#" +  a+ "-ENG-NAME").val().trim());
	$("#MN_DEP").val($("#" + a + "-DEP").val());
	
	if($("#MN_PAGEDIV_C").val() == '${sp:getData("MENU_TYPE_SUBMENU")}'){
		var depthIntroURL = $("#" +  a+ "-INTRO_URL").val().trim();
		if(depthIntroURL){
			$("#MN_FORWARD_URL").val(url + "/" + depthIntroURL); // 소개 페이지 url
			$('#depthIntroURL').val(depthIntroURL);	
		}else{
			$("#MN_FORWARD_URL").val('');
		}
	}else if($("#MN_PAGEDIV_C").val() == '${sp:getData("MENU_TYPE_LINK")}'){
		$("#MN_FORWARD_URL").val($("#" + a + "-LINKURL").val().trim());
	}else{
		$("#MN_FORWARD_URL").val('');
	}
	
	$("#MN_USE_YN").val($('input[name='+a + "-USE_YN"+']:checked').val()); 
	$("#MN_SHOW_YN").val($('input[name='+a + "-SHOW_YN"+']:checked').val());
	$("#MN_MAINKEY").val($("#" + a + "-MAINKEY").val()); // 메인키
	$("#MN_NAME").val($("#" + a + "-NAME").val().trim()); // 메뉴명
	$("#MN_ORDER").val($("#" + a + "-ORDER").val()); //메뉴 정렬순서
	$("#MN_ORDER_BEFORE").val($("#" + a + "-BEFORE").val()); //메뉴 정렬순서
	$("#MN_BT_KEYNO").val($("#" + a + "-BOARDTYPE").val()); //게시판 타입
	$("#MN_EMAIL").val($("#" + a + "-EMAIL").val()); //이메일
	$("#MN_ICON_CSS").val($("#" + a + "-ICONBOX").val()); //CSS icon
	$("#MN_QR_KEYNO").val("${resultData.MN_QR_KEYNO}"); //QR_KEYNO
	$("#MN_NEWLINK").val($('input[name='+a + "-NEWLINK"+']:checked').val()); // 메뉴 새창여부 
	
	<c:if test="${Menu.MN_HOMEDIV_C ne sp:getData('HOMEDIV_ADMIN') }">
		$("#MN_RESEARCH").val($('input[name='+a + "-RESEARCH"+']:checked').val()); //페이지 평가 사용여부
		$("#MN_QRCODE").val($('input[name='+a + "-QRCODE"+']:checked').val()); //페이지평가 - 큐알코드 사용여부
		$("#MN_GONGNULI_YN").val($('input[name='+a + "-GONGNULI_YN"+']:checked').val()); //공공누리 사용여부
		$("#MN_GONGNULI_TYPE").val($('input[name='+a + "-GONGNULI_TYPE"+']:checked').val()); //공공누리타입
	</c:if>
	
	if($('.'+a+'-DirectSelect').is(':checked')){
		$("#MN_MANAGER").val($("#" + a + "-MANAGER").val()); //페이지 평가 - 콘텐츠 담당자
		$("#MN_MANAGER_DEP").val($("#" + a + "-MANAGERDEP").val()); //페이지 평가 - 담당 부서
		$("#MN_MANAGER_TEL").val($("#" + a + "-MANAGERTEL").val()); //페이지 평가 - 담당자 연락처
		$("#MN_DU_KEYNO").val($('.'+a+'-DirectSelect').val())
	}else{
		$("#MN_DU_KEYNO").val($('#'+a+'-DEPARTMENTUSER').val())
	}
	
	if($("#" + a + "-MAINKEY").val() == ""){
		$("#MN_LEV").val("1");
	}else{
		$("#MN_LEV").val($("#" + a + "-LEV").val()); // 뎁스
	}
	
	$("#MN_META_DESC").val($("#" + a + "-METADESC").val());
	$("#MN_META_KEYWORD").val($("#" + a + "-METAKEYWORD").val());
	
}


//레이어창 입력박스 체크 하기
function pf_Input_Check(){
	//메뉴의 이름 입력 여부를 판단한다.
	if(!$("#MN_NAME").val().trim()){
		cf_smallBox('Form', '메뉴명을 입력해주세요.', 3000,'#d24158');
		$("#Mainmenu-NAME").focus();
		return false;
	}
	//정렬기준의 입력 여부를 판단한다.
	if($("#MN_ORDER").val()==""){
		cf_smallBox('Form', '정렬기준을 입력해주세요.', 3000,'#d24158');
		$("#Mainmenu-ORDER").focus();
		return false;
	}
	
	//URL 입력 여부를 판단한다.
    if(!$('#depthURL').val()){
    	cf_smallBox('Form', 'URL을 입력해주세요.', 3000,'#d24158');
		$("#Mainmenu-URL").focus();
		return false;
    }
    var regType;
    if($('#MN_PAGEDIV_C').val() == '${sp:getData("MENU_TYPE_SUBMENU")}'){ //소메뉴형
    	regType = /^[a-zA-Z0-9_+]{1,50}$/; 
    }else{
    	regType = /^[a-zA-Z0-9_+]{1,50}\.do$/;
    }
	if(!regType.test($('#depthURL').val())){
		cf_smallBox('Form', 'url이 규칙에 맞지 않습니다.', 3000,'#d24158');
		$("#Mainmenu-URL").focus();
		return false;
	}
  	//URL 중복 체크 처리
    if(!pf_urlCheck($("#MN_URL").val(), $("#MN_KEYNO").val())){
    	cf_smallBox('Form', 'URL이 중복됩니다.  다른 URL을 입력 해 주세요.', 3000,'#d24158');
		$("#Mainmenu-URL").focus();
    	return false;
    }
  	//URL과 forwardURL 중복 체크 - 현재 forwardUrl 안쓰고있음
    /* if(!pf_forwardUrlCheck()){
		return false;
    } */
    
    if($('#depthIntroURL').val()){
    	var introUrlRegType = /^[a-zA-Z0-9_+]{1,50}.do$/;
	    
	    if(!introUrlRegType.test($('#depthIntroURL').val())){
	    	cf_smallBox('Form', '소개페이지 url이 규칙에 맞지 않습니다.', 3000,'#d24158');
			$("#Mainmenu-INTRO_URL").focus();
			return false;
		}
	    
	  	if(!pf_urlCheck($("#MN_FORWARD_URL").val(), $("#MN_KEYNO").val())){
	  		cf_smallBox('Form', '소개페이지 url이 중복됩니다. 다른 URL을 입력 해 주세요.', 3000,'#d24158');
			$("#Mainmenu-INTRO_URL").focus();
	  		return false;
	  	}
    }
    
  	var boardCk = true;
  	if($('#MN_PAGEDIV_C').val() == '${sp:getData("MENU_TYPE_BOARD")}'){	//게시판형
  		
  		if(!$('#MN_BT_KEYNO').val()){
	  		cf_smallBox('Form', '게시판 형태를 선택하여주세요.', 3000,'#d24158');
			$("#Mainmenu-BOARDTYPE").focus();
			boardCk = false;
			return false;
  		}
  	
  		/*if($('#Mainmenu-EMAIL').val()){
			var regex = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
  			if(!regex.test( $('#Mainmenu-EMAIL').val())){
		  		cf_smallBox('Form', '이메일 형식이 올바르지 않습니다.', 3000,'#d24158');
				$("#Mainmenu-EMAIL").focus();
				boardCk = false;
				return false;
			}
  		}*/
  	}
  	
  	if(!boardCk){
  		return false;
  	}
  	
	return true;
}


//아이콘 업데이트
function pf_refreshIcon_updateForm($iconClassNm){
	$('#menuIconBox .demo-icon-font').removeClass('selectedIcon');
	$('#menuIconView').attr('class','');
	if($iconClassNm){
	  	var classNm = $iconClassNm.replace('fa ', '');
	  	$('#menuIconBox .' + classNm).parents('.demo-icon-font:first').trigger('click');
	}
}

/**
* URL박스 width 값 셋팅
*/
function pf_setUrlInputWidth(){
	var spanWidth =$('#menuList-tab-content-1 .url-input').find('span').width();
   	var divWidth = $('#menuList-tab-content-1 .url-input').width();
   	$('#menuList-tab-content-1 .url-input').find('input').width(divWidth - 120 - spanWidth);	
}


//페이지 평가 show/hide
function pageRatingShowHide(value){
	if(value == 'Y'){
		$('.pageRating').show();
	}else{
		$('.Mainmenu-DirectSelect').prop('checked',false);
		$('#Mainmenu-DEPARTMENT').val('');
		pf_chageDepartMentCategory($('#Mainmenu-DEPARTMENT').val())
		$('.pageRating, .pageRatingInfo').hide()
	}
	pf_directSelectForm()
}

//페이지평가 직접 입력 선택시
function pf_directSelectForm(){
	if($('.Mainmenu-DirectSelect').is(':checked')){
		$('#Mainmenu-DEPARTMENT').val('')
		pf_chageDepartMentCategory($('#Mainmenu-DEPARTMENT').val())
		$('#Mainmenu-DEPARTMENT').attr('disabled', true);
		$('#Mainmenu-DEPARTMENTUSER').attr('disabled', true);
		$('.pageRatingInfo').show()
	}else{
		$('.pageRatingInfo').hide();
		$('#Mainmenu-DEPARTMENT').attr('disabled', false);
		$('#Mainmenu-DEPARTMENTUSER').attr('disabled', false);
		$('#Mainmenu-MANAGERDEP').val('');
		$('#Mainmenu-MANAGER').val('');
		$('#Mainmenu-MANAGERTEL').val('');
	}
}


function pf_chageDepartMentCategory(value,type2,key){
	var temp = '<option value="">선택하세요.</option>'
	if(value){
		$.ajax({
			type: "POST",
			url: "/dyAdmin/homepage/org/data2Ajax.do",
			async: false,
			data: {
				"DN_HOMEDIV_C"	: value
			},
			success : function(data){
			  	var DU_data = data.list;
				if(DU_data.length > 0){
					$.each(DU_data,function(i){
						temp += '<option value="'+DU_data[i].DU_KEYNO+'">'+DU_data[i].DU_NAME+' ('+DU_data[i].DU_TEL+')</option>'
					})
				}else{
					temp = '<option value="">데이터 없음</option>'
				}
			}, error: function(){
				cf_smallBox('error', '조직원 가져오기 에러', 3000,'#d24158');
			}
		});
	}
 	$('#Mainmenu-DEPARTMENTUSER').html(temp).select2({ width: '100%' });
	if(type2 == 'load'){
		$('#Mainmenu-DEPARTMENTUSER').val(key).trigger('change');
	}
}

//공공누리
function gonggnognuliShowHide(value){
	if(value == 'Y'){
		$('.gonggnogType').show();
	}else{
		$('.gonggnogType').hide()
	}
}

// 사이트맵 빈도수 설정
function pf_checkfreq(value) {
	$('input[id=siteMapFreq]').val(value);
}

//사이트맵 우선순위 설정
function pf_checkPriority(value) {
	$('input[id=siteMapPriority]').val(value);
}

</script>
