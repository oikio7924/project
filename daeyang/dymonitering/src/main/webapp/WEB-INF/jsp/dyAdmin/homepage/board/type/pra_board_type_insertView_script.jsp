<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script type="text/javascript">

	var addOptionCnt = 1;
	var modifybool = true;
	var modifytextobj;
	var actionVal = '${action}';
	var bt_personal = "${BoardType.BT_PERSONAL}";
	var BOARD_COLUMN_TYPE_TITLE = "${sp:getData('BOARD_COLUMN_TYPE_TITLE')}";
	var BOARD_COLUMN_TYPE_CHECK = "${sp:getData('BOARD_COLUMN_TYPE_CHECK')}";
	var BOARD_COLUMN_TYPE_RADIO = "${sp:getData('BOARD_COLUMN_TYPE_RADIO')}";
	var BOARD_COLUMN_TYPE_SELECT = "${sp:getData('BOARD_COLUMN_TYPE_SELECT')}";
	var BOARD_COLUMN_TYPE_CHECK_CODE = "${sp:getData('BOARD_COLUMN_TYPE_CHECK_CODE')}";
	var BOARD_COLUMN_TYPE_RADIO_CODE = "${sp:getData('BOARD_COLUMN_TYPE_RADIO_CODE')}";
	var BOARD_COLUMN_TYPE_SELECT_CODE = "${sp:getData('BOARD_COLUMN_TYPE_SELECT_CODE')}";
	var BOARD_COLUMN_TYPE_CALENDAR_START = "${sp:getData('BOARD_COLUMN_TYPE_CALENDAR_START')}";
	var BOARD_COLUMN_TYPE_CALENDAR_END = "${sp:getData('BOARD_COLUMN_TYPE_CALENDAR_END')}";

	$(function() {
		var size = $("input[name='BT_PERSONAL']").length;
		if(bt_personal){
			for (var i = 1; i <=size; i++){
				var bt_id = $("#BT_PERSONAL"+i).val().trim();
				if(bt_personal.indexOf(bt_id) != -1) {
					$("#BT_PERSONAL"+i).attr("checked",true);
					
				}
			}
		}
		if(actionVal == 'insertView'){
			cf_checkbox_checked_val("COMMENT_YN", "N");
			cf_checkbox_checked_val("SECRET_YN", "N");
			cf_checkbox_checked_val("UPLOAD_YN", "N");
			cf_checkbox_checked_val("REPLY_YN", "N");
			cf_checkbox_checked_val("HTML_YN", "N");
			cf_checkbox_checked_val("THUMBNAIL_YN", "N");
			cf_checkbox_checked_val("EMAIL_YN", "N");
			cf_checkbox_checked_val("DEL_LISTVIEW_YN", "Y");
			cf_checkbox_checked_val("DEL_COMMENT_YN", "Y");
			cf_checkbox_checked_val("SHOW_MINE_YN", "N");
			cf_checkbox_checked_val("PERSONAL_YN", "N");
			cf_checkbox_checked_val("DEL_POLICY", "L");
			cf_checkbox_checked_val("XSS_YN", "N");
			cf_checkbox_checked_val("HTMLMAKER_PLUS_YN", "N");
			cf_checkbox_checked_val("NUMBERING_TYPE", "V");
			cf_checkbox_checked_val("ZIP_YN", "N");
			cf_checkbox_checked_val("MOVIE_THUMBNAIL_YN", "N");
			cf_checkbox_checked_val("CATEGORY_YN", "N");
			cf_checkbox_checked_val("SECRET_COMMENT_YN", "N");
			cf_checkbox_checked_val("CALENDAR_YN", "N");
			cf_checkbox_checked_val("PREVIEW_YN", "N");
			cf_checkbox_checked_val("DEL_MANAGE_YN", "N");
			cf_checkbox_checked_val("FORBIDDEN_YN", "N");
			pf_defaultColumn();
		}else if(actionVal == 'updateView'){
			cf_checkbox_checked_val("COMMENT_YN", "${BoardType.BT_COMMENT_YN }");
			cf_checkbox_checked_val("SECRET_YN", "${BoardType.BT_SECRET_YN }");
			cf_checkbox_checked_val("UPLOAD_YN", "${BoardType.BT_UPLOAD_YN }");
			cf_checkbox_checked_val("REPLY_YN", "${BoardType.BT_REPLY_YN }");
			cf_checkbox_checked_val("HTML_YN", "${BoardType.BT_HTML_YN }");
			cf_checkbox_checked_val("THUMBNAIL_YN", "${BoardType.BT_THUMBNAIL_YN }");
			cf_checkbox_checked_val("EMAIL_YN", "${BoardType.BT_EMAIL_YN }");
			cf_checkbox_checked_val("DEL_LISTVIEW_YN","${BoardType.BT_DEL_LISTVIEW_YN }");
			cf_checkbox_checked_val("DEL_COMMENT_YN", "${BoardType.BT_DEL_COMMENT_YN }");
			cf_checkbox_checked_val("SHOW_MINE_YN", "${BoardType.BT_SHOW_MINE_YN }");
			cf_checkbox_checked_val("PERSONAL_YN", "${BoardType.BT_PERSONAL_YN }");
			cf_checkbox_checked_val("DEL_POLICY", "${BoardType.BT_DEL_POLICY }");
			cf_checkbox_checked_val("XSS_YN", "${BoardType.BT_XSS_YN}");
			cf_checkbox_checked_val("HTMLMAKER_PLUS_YN", "${BoardType.BT_HTMLMAKER_PLUS_YN }");
			cf_checkbox_checked_val("NUMBERING_TYPE", "${BoardType.BT_NUMBERING_TYPE}");
			cf_checkbox_checked_val("ZIP_YN", "${BoardType.BT_ZIP_YN }");
			cf_checkbox_checked_val("MOVIE_THUMBNAIL_YN", "${BoardType.BT_MOVIE_THUMBNAIL_YN }");
			cf_checkbox_checked_val("CATEGORY_YN", "${BoardType.BT_CATEGORY_YN}");
			cf_select_check("BT_CODEKEY", "${BoardType.BT_CODEKEY }");
			cf_checkbox_checked_val("SECRET_COMMENT_YN", "${BoardType.BT_SECRET_COMMENT_YN}");
			cf_checkbox_checked_val("CALENDAR_YN", "${BoardType.BT_CALENDAR_YN}");
			cf_checkbox_checked_val("PREVIEW_YN", "${BoardType.BT_PREVIEW_YN}");
			cf_checkbox_checked_val("DEL_MANAGE_YN", "${BoardType.BT_DEL_MANAGE_YN}");
			cf_checkbox_checked_val("FORBIDDEN_YN", "${BoardType.BT_FORBIDDEN_YN}");
			
			/* 업로드 확장자 선택 */
			var extCk = false;
			$('input[name=FILE_EXT]').each(function(){
				if($(this).val() == '${BoardType.BT_FILE_EXT }'){
					extCk = true;
				}
			});
			if(!extCk){
				cf_radio_checked("FILE_EXT", "blank");
				$("#FILE_EXT").val('${BoardType.BT_FILE_EXT }');
				$("#FILE_EXT").show();
			}else{
				cf_radio_checked("FILE_EXT", "${BoardType.BT_FILE_EXT }");
			}

			pf_initColumn('${BoardType.BT_KEYNO }');
		}

		/* 컬럼 순서 변경 */
		$("#AddColumn").sortable(
				{
					beforeStop : function(event, ui) {
						$("#AddColumn .column-row").find(
								"input[name='BL_COLUMN_LEVEL']").each(
								function(i) {
									$(this).val(i + 1);
								})
					}
				});
		$("#AddColumn").disableSelection();
		
		pf_onSelected('THUMBNAIL_YN','thumnailResize',false);
		pf_onSelected('EMAIL_YN','emailAddress',false);
		pf_onSelected('PERSONAL_YN','personalCheck',false);
		pf_onSelected('UPLOAD_YN','uploadRow',false);
		pf_onSelected('CATEGORY_YN','categoryInput',false);
		pf_onSelected('COMMENT_YN','secretCommentCheck',false);
		pf_onSelected('DEL_POLICY','deleteContentsChk',false);
		pf_onSelected('FORBIDDEN_YN','forbiddenChk',false);
		
		pf_onClick('THUMBNAIL_YN','thumnailResize',false);
		pf_onClick('EMAIL_YN','emailAddress',false);
		pf_onClick('PERSONAL_YN','personalCheck',false);
		pf_onClick('UPLOAD_YN','uploadRow',true);
		pf_onClick('CATEGORY_YN','categoryInput',false);
		pf_onClick('COMMENT_YN','secretCommentCheck',false);
		pf_onClick('DEL_POLICY','deleteContentsChk',false);
		pf_onClick('FORBIDDEN_YN','forbiddenChk',false);

	});
	
	/* 체크여부에 따라 show/hide */
	function pf_onSelected(inputName, className, isLimit){
		if ($('input[name='+inputName+']').is(':checked')) {
			$('.'+className).show();
		} else {
			$('.'+className).hide();
			if(isLimit){
				$("#BT_FILE_SIZE_LIMIT").val("0");
				$("#BT_FILE_CNT_LIMIT").val("0");
			}
		}
	}
	
	/* 체크 함에 따라 show/hide */
	function pf_onClick(inputName, className, isLimit){
		$('input[name='+inputName+']').on('click',function() {
			if ($(this).is(':checked')) {
				$("."+className).show();
			} else {
				$("."+className).hide();
				if(isLimit){
					$("#BT_FILE_SIZE_LIMIT").val("0");
					$("#BT_FILE_CNT_LIMIT").val("0");
				}
			}
		});
	}
	
	function pf_fileExt(type){
		if(type == 'Y'){
			$("#FILE_EXT").show();
		}else{
			$("#FILE_EXT").hide();			
		}
	}

	//카테고리 입력할때 중복 안되게 설정
	function pf_repeat_delCategory(){
		var categoryVal = $('input[name=BT_CATEGORY_INPUT').val();
		var cateArr = categoryVal.split(",");
		for (var i = 0 ; i < cateArr.length; i++){
			for (var j = i+1; j < cateArr.length; j++){
				if(cateArr[i] == cateArr[j]){
					alert(cateArr[i]+"라는 중복카테고리가 존재합니다.")
					return false;
					
				}
			}
		}
	}
	
	
	//게시판 타입 등록 처리 및 입력 폼 체크
	function pf_boardTypeAction() {
		pf_checkBox();
		var fileExtCkVal = $('input[name=FILE_EXT]:checked').val();
		if(fileExtCkVal == 'blank'){
			$("#BT_FILE_EXT").val($("#FILE_EXT").val());
		}else{
			$("#BT_FILE_EXT").val(fileExtCkVal);			
		}
		if(!pf_validate('BT_TYPE_NAME','게시판 타입명을 입력해주세요.',false)){return false};
// 		if(!pf_validate('BT_CODEKEY','게시판 형태를 선택해주세요.',false)){return false};
		if(!pf_validate('BT_PAGEUNIT','한 페이지당 게시되는 게시물 건 수를 확인하여주세요.',true)){return false};
		if(!pf_validate('BT_PAGESIZE','페이지 리스트에 게시되는 페이지 건수를 확인하여주세요.',true)){return false};
		if(!pf_validate('BT_SUBJECT_NUM','게시물 제목 노출 글자 수를 확인하여주세요.',true,true)){return false};
		if ($('input[name=FORBIDDEN_YN]').is(':checked')) {
			if(!pf_validate('BT_FORBIDDEN','게시물 금지어를 확인하여주세요.',false)){return false};
		}
		if ($('input[name=PERSONAL_YN]').is(':checked')) {
			var size = $("input[name='BT_PERSONAL']").length+1;
			var count = 0;
			for (var i = 1; i <size; i++){
				if(!$("input:checkbox[id='BT_PERSONAL"+i+"']").is(":checked")) {
					count++;	
				}
			}if(count == 2){
				cf_smallBox('error', '개인정보보안 여부를 하나 이상 체크해 주세요.', 3000,'#d24158'); 
				$("#BT_PERSONAL1").focus();
				return false;
			}
		}
		if ($('input[name=CATEGORY_YN]').is(':checked')) {
			if(!pf_validate('BT_CATEGORY_INPUT','등록할 카테고리를 설정하여주세요.',false)){return false};
			if(pf_repeat_delCategory() == false){return false};
			
		}
		
		
		if ($('input[name=EMAIL_YN]').is(':checked')) {
			if(!pf_validate('BT_EMAIL_ADDRESS','이메일 주소를 설정하여주세요.',false)){return false};
		}
		if ($('input[name=THUMBNAIL_YN]').is(':checked')) {
			if(!pf_validate('BT_THUMBNAIL_WIDTH','썸네일 리사이즈 width 값을 설정하여주세요.',true)){return false};
			if(!pf_validate('BT_THUMBNAIL_HEIGHT','썸네일 리사이즈 height 값을 설정하여주세요.',true)){return false};
		}
		if ($('input[name=UPLOAD_YN]').is(':checked')) {
			if(!pf_validate('BT_FILE_CNT_LIMIT','업로드 파일 수를 확인해주세요.',true)){return false};
			if(!pf_validate('BT_FILE_SIZE_LIMIT','업로드 파일크기를 확인해주세요.',true)){return false};
			
			/* 문서 파일 확장자 아닐경우 썸네일 크기 선택 */		
// 			if($('input:radio[name=FILE_EXT]:checked').val() != 'hwp,txt,pdf,xls,xlsx,doc,docx,ppt,pptx'){
// 				if(!pf_validate('BT_FILE_IMAGE_WIDTH','썸네일 리사이즈 width 값을 설정하여주세요.',true)){return false};
// 				if(!pf_validate('BT_FILE_IMAGE_HEIGHT','썸네일 리사이즈 height 값을 설정하여주세요.',true)){return false};
// 			}
			
			if(!pf_validate('BT_FILE_EXT','업로드 확장자를 입력해 주세요.',false)){return false};
		}
		if ($("#AddColumn").find(".column-row").length < 1) {
			cf_smallBox('error', '컬럼을 추가해주세요.', 3000,'#d24158'); 
			return false;
		}
		if ($('input[name=COMMENT_YN]').is(':checked')) {
			if(!pf_validate('BT_PAGEUNIT_C','한 페이지당 게시되는 댓글 건 수를 확인하여주세요.',true)){return false};
			if(!pf_validate('BT_PAGESIZE_C','댓글 리스트에 게시되는 페이지 건수를 확인하여주세요.',true)){return false};
		}
		
		if (valcheck()) {
			if (confirm("게시판 타입을 생성하시겠습니까?")) {
				success();
			} else {
				exit();
			}
		}
	}
	
	//타입 삭제
	function pf_boardTypeDelete() {
		if (confirm("게시판 타입을 삭제하시겠습니까?")) {
			$("#Form").attr("action", "/dyAdmin/homepage/board/type/delete.do");
			$("#Form").submit();
		}
	}
	
	function valcheck() {
		var bool = true;
		$("#AddColumn").find(".column-row").each(function() {
			if (!$(this).find("input[name='BL_COLUMN_NAME']").val().trim()) {
				cf_smallBox('error', '컬럼명를 입력해주세요.', 3000,'#d24158'); 
				$(this).find("input[name='BL_COLUMN_NAME']").focus();
				bool = false;
				return false;
			} else if (!$(this).find("select[name='BL_TYPE']").val()) {
				cf_smallBox('error', '컬럼 타입을 선택해주세요.', 3000,'#d24158'); 
				$(this).find("select[name='BL_TYPE']").focus();
				bool = false;
				return false;
// 			} else if ($(this).find("select[name='BL_LISTVIEW_YN']").val() == "Y" && $(this).find("select[name='BL_COLUMN_SIZE']").val() == "") {
// 				cf_smallBox('error', '컬럼 가로크기를 선택해주세요.', 3000,'#d24158'); 
// 				bool = false;
// 				return false;
			} else if (!$(this).find("select[name='BL_VALIDATE']").val()) {
				cf_smallBox('error', '필수입력 여부를 선택해주세요.', 3000,'#d24158'); 
				$(this).find("select[name='BL_VALIDATE']").focus();
				bool = false;
				return false;
			} else if (!$(this).find("select[name='BL_LISTVIEW_YN']").val()) {
				cf_smallBox('error', '리스트 노출 여부를 선택해주세요.', 3000,'#d24158'); 
				$(this).find("select[name='BL_LISTVIEW_YN']").focus();
				bool = false;
				return false;
			}
	
			var BL_TYPE = $(this).find('select[name=BL_TYPE]')
					.val();
			if (BL_TYPE == "${sp:getData('BOARD_COLUMN_TYPE_RADIO')}"
					|| BL_TYPE == "${sp:getData('BOARD_COLUMN_TYPE_SELECT')}"
					|| BL_TYPE == "${sp:getData('BOARD_COLUMN_TYPE_CHECK')}") {
				var length = $(
						"#Addoption_dialog_"
								+ $(this).attr('id')).find(
						'span.label').length;
				if (length < 1) {
					var name = $(this).find(
							'input[name=BL_COLUMN_NAME]').val();
					cf_smallBox('error', name + '의 옵션이 설정되지 않았습니다. 확인하여주세요.', 3000,'#d24158'); 
					bool = false;
					return false;
				}
			} else if (BL_TYPE == "${sp:getData('BOARD_COLUMN_TYPE_RADIO_CODE')}"
					|| BL_TYPE == "${sp:getData('BOARD_COLUMN_TYPE_SELECT_CODE')}"
					|| BL_TYPE == "${sp:getData('BOARD_COLUMN_TYPE_CHECK_CODE')}") {
				if (!$(this).find('select[name=BL_CODE]').val()) {
					var name = $(this).find(
							'input[name=BL_COLUMN_NAME]').val();
					cf_smallBox('error', name + '의 코드가 설정되지 않았습니다. 확인하여주세요.', 3000,'#d24158'); 
					bool = false;
					return false;
				}
			}
	
		})
		return bool;
	}
	
	function pf_validate(id,msg,isNumber,isZero){
		var condition;
		if(isNumber){
			condition = !isNumberic($("#"+id).val()) || $("#"+id).val() <= 0
			if(isZero) condition = !isNumberic($("#"+id).val()) || $("#"+id).val() < 0
		}else{
			condition = !$("#"+id).val().trim()
		}
		if (condition) {
			cf_smallBox('error', msg, 3000,'#d24158'); 
			if(id == 'BT_FILE_EXT'){
				$("#FILE_EXT").focus();
			}else{
				$("#"+id).focus();
			}
			return false;
		}
		return true;
	}
	
	//성공 콜백 함수   
	function success() {
		cf_replaceTrim($("#Form"));
		$("#Form").submit();
	}

	//실패 콜백 함수   
	function exit() {
		cf_smallBox('error', '취소되었습니다.', 3000,'#d24158'); 
		return false;
	}
	function pf_AddColumn() {
		var divID = "column-row" + addOptionCnt;
		var html = "";
		html += "<div id='"+divID+"' class='column-row'>";
		html += "<div class='row'>";
		html += "<input type='hidden' name='BL_KEYNO' value=''>";
		html += "<input type='hidden' id='BL_OPTION_DATA"+divID+"' name='BL_OPTION_DATA' value=''>";
		html += "<section class='col col-1'>";
		html += "<label class='input'> <i class='icon-prepend fa fa-edit'></i> ";
		html += "<input type='text' id='BL_COLUMN_LEVEL"
				+ divID
				+ "' name='BL_COLUMN_LEVEL' placeholder='정렬순서'  maxlength='2' onkeydown='return cf_only_Num(event);' readonly='readonly'/>";
		html += "</label>";
		html += "</section>";
		html += "<section class='col col-3'>";
		html += "<label class='input'> <i class='icon-prepend fa fa-edit'></i>";
		html += "<input type='text' class='checkTrim' name='BL_COLUMN_NAME' placeholder='컬럼명'  maxlength='50' />";
		html += "</label>";
		html += "</section>";
		html += "<section class='col col-1'>";
		html += "<label class='select'>";
		html += "<select name='BL_TYPE' id='BL_TYPE" + divID
				+ "' onchange=pf_ColumnTypeChange('" + divID + "')>";
		html += "<option value=''>컬럼 타입</option>";

		<c:forEach items="${sp:getCodeList('AJ') }" var="model">
		html += "<option value='${model.SC_KEYNO}'>${model.SC_CODENM}</option>";
		</c:forEach>

		html += "</select>";
		html += "<i></i>";
		html += "</label>";
		html += "</section>";

		html += "<section class='col col-1'>";
		html += "<label class='select'>";
		html += "<select name='BL_VALIDATE' id='BL_VALIDATE"+divID+"'>";
		html += "<option value=''>필수입력 여부</option>";
		html += "<option value='Y'>Y</option>";
		html += "<option value='N'>N</option>";
		html += "</select>";
		html += "<i></i>";
		html += "</label>";
		html += "</section>";

		html += "<section class='col col-1'>";
		html += "<label class='select'>";
		html += "<select name='BL_LISTVIEW_YN' id='BL_LISTVIEW_YN" + divID
				+ "' onchange=pf_ColumnViewYN('" + divID + "')>";
		html += "<option value=''>리스트 노출여부</option>";
		html += "<option value='Y'>Y</option>";
		html += "<option value='N'>N</option>";
		html += "</select>";
		html += "<i></i>";
		html += "</label>";
		html += "</section>";

		html += "<section class='col col-1 selectCodeWrap'>";
		html += "<label class='select'>";
		html += "<select name='BL_CODE' id='BL_CODE" + divID
				+ "' onchange=pf_SettingCode('" + divID + "',this)>";
		html += "<option value=''>코드선택</option>";
		<c:forEach items="${MainCodeList}" var="model">
		html += "<option value='${model.MC_KEYNO}'>${model.MC_CODENM}</option>";
		</c:forEach>
		html += "</select>";
		html += "<i></i>";
		html += "</label>";
		html += "</section>";

		html += "<section class='col col-2' style='height: 32px; line-height: 32px; vertical-align: middle;'>";
		html += "<section class='col-12 text-center' style='height: 32px; line-height: 32px; vertical-align: middle;'>";
		html += "<a href='javascript:;' onclick=pf_columnDelete('" + divID
				+ "')>";
		html += "삭제하기";
		html += "</a>";
		html += "<span class='option_dp'>"
		html += "|  ";
		html += "<a href='javascript:;' onclick=pf_optiondialog_open('" + divID
				+ "')>";
		html += "옵션관리";
		html += "</a> ";
		html += "</span>";
		html += "</section>";
		html += "</section>";
		html += "</div>";
		html += "</div>";
		$("#AddColumn").append(html);

		//제목타입은 삭제
		$('#BL_TYPE' + divID + ' option[value=' + BOARD_COLUMN_TYPE_TITLE + ']')
				.remove();

		optionhtml(divID);
		addOptionCnt++;
		
		$("#AddColumn .column-row").find("input[name='BL_COLUMN_LEVEL']").each(
				function(i) {
					$(this).val(i + 1);
				})

	}

	//코드타입 코드 셋팅
	function pf_SettingCode(divID, obj) {
		$('#BL_OPTION_DATA' + divID).val($(obj).val())
	}

	function pf_optiondialog_open(divID) {
		$("#Addoption_dialog_" + divID).dialog("open");
	}
	function pf_columnDelete(obj) {
		if(actionVal == 'updateView'){
			if ($("#" + obj).find("#BL_KEYNO").val() != "") {
				var delhtml = "<input type='hidden' name='delete_bl_keyno' value='"+ $("#" + obj).find("input[name=BL_KEYNO]").val() + "' />";
				$("#Form").append(delhtml);
			}
		}
		$("#" + obj).remove();
		$("#Addoption_dialog_" + obj).remove();
		$("#AddColumn .column-row").find("input[name='BL_COLUMN_LEVEL']").each(
				function(i) {
					$(this).val(i + 1);
				})
	}

	function optionhtml(divID) {
		var html = "";
		html += "<div id='Addoption_dialog_"+divID+"' title='옵션관리'>";
		html += "<fieldset>";
		html += "<div class='form-group'>";
		html += "<input class='form-control' placeholder='옵션이름 입력' type='text' id='option_data_"+divID+"'/>";
		html += "</div>";
		html += "<div class='form-group no-margin' >";
		html += "<label id='option_Msg_"+divID+"'></label>";
		html += "</div>";
		html += "<div class='form-group text-right'>";
		html += "<button class='btn btn-success' onclick=pf_option_action('"
				+ divID + "')>";
		html += "<i class='fa fa-save'></i>&nbsp; 저장";
		html += "</button>";
		html += "</div>";
		html += "<div class='form-group'>";
		html += "<label><i class='fa fa-th-list'></i> 옵션 내역</label> <br/>";
		html += "<label id='Addoption_dialog_ContentsBox_"+divID+"'>";
		html += "</label>";
		html += "</div>";
		html += "</fieldset>";
		html += "</div>";
		$("#optiondialog_append").append(html);
		$("#Addoption_dialog_" + divID).dialog(
				{
					autoOpen : false,
					width : 600,
					resizable : true,
					modal : true,
					close : function(event, ui) {
						var data = "";
						leng = $("#Addoption_dialog_ContentsBox_" + divID)
								.find('.atext').length;
						$("#Addoption_dialog_ContentsBox_" + divID).find(
								'.atext').each(
								function(i) {
									data += $(this).html();
									if (i + 1 < leng) {
										data += "|";
									}
									$("#" + divID).find(
											'#BL_OPTION_DATA' + divID)
											.val(data)
								})
						modifybool = true;
						modifytextobj = null;
						$("#option_data_" + divID).val("");
					}
				});
	}

	function pf_ColumnTypeChange(divID) {

		$("#" + divID).find('.option_dp').hide();
		$("#" + divID).find('.selectCodeWrap').hide();

		var ChangeSelectBox = $("#BL_TYPE" + divID).val();
		if (ChangeSelectBox == BOARD_COLUMN_TYPE_CHECK
				|| ChangeSelectBox == BOARD_COLUMN_TYPE_RADIO
				|| ChangeSelectBox == BOARD_COLUMN_TYPE_SELECT) {
			$("#" + divID).find('.option_dp').show();
		} else if (ChangeSelectBox == BOARD_COLUMN_TYPE_CHECK_CODE
				|| ChangeSelectBox == BOARD_COLUMN_TYPE_RADIO_CODE
				|| ChangeSelectBox == BOARD_COLUMN_TYPE_SELECT_CODE) {
			$("#" + divID).find('.selectCodeWrap').show();
		} else if (ChangeSelectBox == BOARD_COLUMN_TYPE_CALENDAR_START) {
			var count = 0;
			$("select[name=BL_TYPE]").each(function() {

				if ($(this).val() == BOARD_COLUMN_TYPE_CALENDAR_START) {
					count++;
				}

				if (count > 1) {
					cf_smallBox('error', '달력(시작날짜) 컬럼은 한개만 등록 가능합니다.', 3000,'#d24158'); 
					$(this).val("");
					return false;
				}
			});
		} else if (ChangeSelectBox == BOARD_COLUMN_TYPE_CALENDAR_END) {
			var count = 0;
			$("select[name=BL_TYPE]").each(function() {

				if ($(this).val() == BOARD_COLUMN_TYPE_CALENDAR_END) {
					count++;
				}

				if (count > 1) {
					cf_smallBox('error', '달력(종료날짜) 컬럼은 한개만 등록 가능합니다.', 3000,'#d24158'); 
					$(this).val("");
					return false;
				}
			});
		}
	}

	//옵션 정보 등록/수정 처리
	function pf_option_action(divID) {
		if (modifybool) {
			//입력 정보 검사
			if ($("#option_data_" + divID).val() == '') {
				cf_smallBox('error', '옵션이름을 입력하세요.', 3000,'#d24158'); 
				$("#option_data_" + divID).focus();
				return false;
			}
			var HtmlContents = "";
			// 등록할 옵션 정보 삽입
			HtmlContents += "<span class=\"label bg-color-blue\" style=\"margin-right:10px;\">"
					+ "<a href=\"javascript:;\" class=\"label atext\" "
					+ "onclick=\"pf_modify_view(this,'"
					+ divID
					+ "')\" >"
					+ $("#option_data_" + divID).val()
					+ "</a><a class=\"label\" href=\"javascript:;\">"
					+ "<i class=\"fa fa-trash-o\" onclick=pf_option_delete(this) ></i></a></span>";
			$("#Addoption_dialog_ContentsBox_" + divID).html(
					$("#Addoption_dialog_ContentsBox_" + divID).html()
							+ HtmlContents);
		} else {
			$(modifytextobj).html($("#option_data_" + divID).val())
			modifybool = true;
		}
		$("#option_data_" + divID).val("");
	}
	function pf_modify_view(obj, divID) {
		$("#option_data_" + divID).val($(obj).html());
		modifybool = false;
		modifytextobj = obj;
	}

	function pf_ColumnViewYN(divID) {
		var ChangeSelectBox = $("#BL_LISTVIEW_YN" + divID).val();
		if (ChangeSelectBox == 'Y') {
			$("#" + divID).find('.column_size_dp').show();
		} else {
			$("#" + divID).find('.column_size_dp').hide();
		}
	}

	function pf_option_delete(obj) {
		$(obj).parent().parent().remove();
	}

	function pf_defaultColumn() {
		var divID = "column-row" + addOptionCnt;
		var html = "";
		html += "<div id='"+divID+"' class='column-row'>";
		html += "<div class='row'>";
		html += "<input type='hidden' name='BL_KEYNO' value=''>";
		html += "<input type='hidden' id='BL_OPTION_DATA"+divID+"' name='BL_OPTION_DATA' value=''>";
		html += "<section class='col col-1'>";
		html += "<label class='input'> <i class='icon-prepend fa fa-edit'></i> ";
		html += "<input type='text' id='BL_COLUMN_LEVEL"
				+ divID
				+ "' name='BL_COLUMN_LEVEL' placeholder='정렬순서'  maxlength='2' onkeydown='return cf_only_Num(event);' value='1' readonly='readonly'/>";
		html += "</label>";
		html += "</section>";
		html += "<section class='col col-3'>";
		html += "<label class='input'> <i class='icon-prepend fa fa-edit'></i>";
		html += "<input type='text' class='checkTrim' name='BL_COLUMN_NAME' placeholder='컬럼명'  maxlength='50' value='제목'/>";
		html += "</label>";
		html += "</section>";
		html += "<section class='col col-1'>";
		html += "<label class='select'>";
		html += "<select name='BL_TYPE' id='BL_TYPE" + divID
				+ "' onchange=pf_ColumnTypeChange('" + divID + "')>";
		html += "<option value='"+BOARD_COLUMN_TYPE_TITLE+"'>제목</option>";
		html += "</select>";
		html += "<i></i>";
		html += "</label>";
		html += "</section>";

		html += "<section class='col col-1'>";
		html += "<label class='select'>";
		html += "<select name='BL_VALIDATE' id='BL_VALIDATE"+divID+"'>";
		html += "<option value=''>필수 여부</option>";
		html += "<option value='Y' selected>Y</option>";
		html += "</select>";
		html += "<i></i>";
		html += "</label>";
		html += "</section>";

		html += "<section class='col col-1'>";
		html += "<label class='select'>";
		html += "<select name='BL_LISTVIEW_YN' id='BL_LISTVIEW_YN" + divID
				+ "' onchange=pf_ColumnViewYN('" + divID + "')>";
		html += "<option value=''>리스트 노출여부</option>";
		html += "<option value='Y' selected>Y</option>";
		html += "</select>";
		html += "<i></i>";
		html += "</label>";
		html += "</section>";

		html += "</div>";
		html += "</div>";

		$("#AddColumn").append(html);
		optionhtml(divID);
		addOptionCnt++;
	}
	
	//체크박스 값 넣기
	function pf_checkBox(){
		$('input[type=checkbox]').each(function(i){
			var checkVal = 'Y'
			var checkID = $(this).attr("id");
			if(!$(this).is(":checked")){
				if(checkID == 'NUMBERING_TYPE'){	//번호 넘버링 값
					checkVal = 'R';
				}else{
					checkVal = 'N'
				}
			}else{
				if(checkID == 'NUMBERING_TYPE'){	//번호 넘버링 값
					checkVal = 'V';
				}
			}
			if(!$(this).is(":checked")){
				if(checkID == 'DEL_POLICY'){	//게시물 삭제 정책 값
					checkVal = 	'P';
				}
			}else{
				if(checkID == 'DEL_POLICY'){	//번호 넘버링 값
					checkVal = 'L';
				}
			}
			$('#BT_'+checkID).val(checkVal);
		})
	}
	
	function pf_initColumn(BT_KEYNO) {
		$.ajax({
			type : "POST",
			url : "/dyAdmin/homepage/board/type/updateView/listAjax.do",
			data : "BL_BT_KEYNO=" + BT_KEYNO,
			success : function(result) {
				for (var i = 0; i < result.length; i++) {
					pf_ajaxData(result[i])
				}
			},
			error : function() {
				cf_smallBox('error', '예상치못한 오류가 발생했습니다.', 3000,'#d24158'); 
				return false;
			}
		});
	}
	function pf_ajaxData(result) {
		
			
		var divID = "column-row" + addOptionCnt;
		var html = "";
		html += "<div id='"+divID+"' class='column-row'>";
		html += "<div class='row'>";
		html += "<input type='hidden' name='BL_KEYNO' value='"+result.BL_KEYNO+"'>";
		html += "<input type='hidden' id='BL_OPTION_DATA"+divID+"' name='BL_OPTION_DATA' value='"+result.BL_OPTION_DATA+"'>";
		html += "<section class='col col-1'>";
		html += "<label class='input'> <i class='icon-prepend fa fa-edit'></i> ";
		html += "<input type='text' id='BL_COLUMN_LEVEL"
				+ divID
				+ "' name='BL_COLUMN_LEVEL' placeholder='정렬순서'  maxlength='50' value='"
				+ result.BL_COLUMN_LEVEL
				+ "' readonly='readonly' onkeydown='return cf_only_Num(event);'/>";
		html += "</label>";
		html += "</section>";
		html += "<section class='col col-3'>";
		html += "<label class='input'> <i class='icon-prepend fa fa-edit'></i>";
		html += "<input class='checkTrim' type='text' name='BL_COLUMN_NAME' placeholder='컬럼명'  maxlength='50' value='"+result.BL_COLUMN_NAME+"'/>";
		html += "</label>";
		html += "</section>";
		html += "<section class='col col-1'>";
		html += "<label class='select'>";
		html += "<select name='BL_TYPE' id='BL_TYPE" + divID
				+ "' onchange=pf_ColumnTypeChange('" + divID + "')>";
		if (result.BL_TYPE == BOARD_COLUMN_TYPE_TITLE) {
			html += "<option value='"+BOARD_COLUMN_TYPE_TITLE+"'>제목</option>";
		} else {
			<c:forEach items="${sp:getCodeList('AJ') }" var="model">
			<c:if test="${model.SC_KEYNO ne sp:getData('BOARD_COLUMN_TYPE_TITLE')}">
			html += "<option value='${model.SC_KEYNO}'>${model.SC_CODENM}</option>";
			</c:if>
			</c:forEach>
		}
		html += "</select>";
		html += "<i></i>";
		html += "</label>";
		html += "</section>";

		html += "<section class='col col-1'>";
		html += "<label class='select'>";
		html += "<select name='BL_VALIDATE' id='BL_VALIDATE"+divID+"'>";
		if (result.BL_TYPE == BOARD_COLUMN_TYPE_TITLE) {
			html += "<option value='Y'>Y</option>";
		} else {
			html += "<option value=''>필수입력 여부</option>";
			html += "<option value='Y'>Y</option>";
			html += "<option value='N'>N</option>";
		}

		html += "</select>";
		html += "<i></i>";
		html += "</label>";
		html += "</section>";

		html += "<section class='col col-1'>";
		html += "<label class='select'>";
		html += "<select name='BL_LISTVIEW_YN' id='BL_LISTVIEW_YN" + divID
				+ "' onchange=pf_ColumnViewYN('" + divID + "')>";
		if (result.BL_TYPE == BOARD_COLUMN_TYPE_TITLE) {
			html += "<option value='Y'>Y</option>";
		} else {
			html += "<option value=''>리스트 노출여부</option>";
			html += "<option value='Y'>Y</option>";
			html += "<option value='N'>N</option>";
		}
		html += "</select>";
		html += "<i></i>";
		html += "</label>";
		html += "</section>";

		html += "<section class='col col-1 selectCodeWrap'>";
		html += "<label class='select'>";
		html += "<select name='BL_CODE' id='BL_CODE" + divID
				+ "' onchange=pf_SettingCode('" + divID + "',this)>";
		html += "<option value=''>코드선택</option>";
		<c:forEach items="${MainCodeList}" var="model">
		html += "<option value='${model.MC_KEYNO}'>${model.MC_CODENM}</option>";
		</c:forEach>
		html += "</select>";
		html += "<i></i>";
		html += "</label>";
		html += "</section>";

		if (result.BL_TYPE != BOARD_COLUMN_TYPE_TITLE) {
			html += "<section class='col col-2' style='height: 32px; line-height: 32px; vertical-align: middle;'>";
			html += "<section class='col-12 text-center' style='height: 32px; line-height: 32px; vertical-align: middle;'>";
			html += "<a href='javascript:;' onclick=pf_columnDelete('" + divID
					+ "')>";
			html += "삭제하기";
			html += "</a>";
			html += "<span class='option_dp'>"
			html += "|  ";
			html += "<a href='javascript:;' onclick=pf_optiondialog_open('"
					+ divID + "')>";
			html += "옵션관리";
			html += "</a> ";
			html += "</span>"
			html += "</section>";
			html += "</section>";
		}
		html += "</div>";
		html += "</div>";
		$("#AddColumn").append(html);
		optionhtml(divID);

		cf_select_check("BL_TYPE" + divID, result.BL_TYPE);
		cf_select_check("BL_VALIDATE" + divID, result.BL_VALIDATE);
		cf_select_check("BL_LISTVIEW_YN" + divID, result.BL_LISTVIEW_YN);
		cf_select_check("BL_COLUMN_SIZE" + divID, result.BL_COLUMN_SIZE);
		var optiondata = $("#BL_OPTION_DATA" + divID).val();
		var optionVal = optiondata.split("|");

		var BL_TYPE = $("#BL_TYPE" + divID).val();

		if (BL_TYPE == BOARD_COLUMN_TYPE_CHECK
				|| BL_TYPE == BOARD_COLUMN_TYPE_RADIO
				|| BL_TYPE == BOARD_COLUMN_TYPE_SELECT) {
			if (optiondata != null && optiondata != "") {
				for (var c = 0; c < optionVal.length; c++) {
					var HtmlContents = "";
					//등록할 옵션 정보 삽입
					HtmlContents += "<span class=\"label bg-color-blue\" style=\"margin-right:10px;\">"
							+ "<a href=\"javascript:;\" class=\"label atext\" "
							+ "onclick=\"pf_modify_view(this,'"
							+ divID
							+ "')\" >"
							+ optionVal[c]
							+ "</a><a class=\"label\" href=\"javascript:;\">"
							+ "<i class=\"fa fa-trash-o\" onclick=pf_option_delete(this) ></i></a></span>";
					$("#Addoption_dialog_ContentsBox_" + divID).html(
							$("#Addoption_dialog_ContentsBox_" + divID).html()
									+ HtmlContents);

				}
			}
		} else if (BL_TYPE == BOARD_COLUMN_TYPE_CHECK_CODE
				|| BL_TYPE == BOARD_COLUMN_TYPE_RADIO_CODE
				|| BL_TYPE == BOARD_COLUMN_TYPE_SELECT_CODE) {
			cf_select_check("BL_CODE" + divID, result.BL_OPTION_DATA);

		}

		pf_ColumnViewYN(divID)
		pf_ColumnTypeChange(divID)

		addOptionCnt++;
	}
	
	
	function SkinChange(key){
		if(key != -1){
			$.ajax({
				type: "post",
				url : "/dyAdmin/homepage/board/type/SkinDataSearch.do",
				data : {
					BSP_KEYNO : key
				},
				success: function(data){
					$("#BT_LIST_KEYNO").val(data.BSP_LIST_KEYNO);
					$("#BT_DETAIL_KEYNO").val(data.BSP_DETAIL_KEYNO);
					$("#BT_INSERT_KEYNO").val(data.BSP_INSERT_KEYNO);
				},
				error: function(){
					alert("에러");
				}
			});
		}
	}
	
	function PackageChange(){
		$("#Package").val("-1");
	}
</script>

