<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<script type="text/javascript">
var addOptionCnt = ${fn:length(SQ)};
var columnCnt = ${fn:length(SQ)};
var ParticipationCnt = '${SmDTO.CNT}'
var action = '${action}'

$(function(){
	
//	pf_getQuestionList('${SmDTO.SM_KEYNO}',action)
	
//	pf_bogiShowHide('${SmDTO.SM_CNT_TYPE}')
	
	$('#SM_STARTDT').on('change',function(){
		$('#SM_ENDDT').datepicker('option', 'minDate', $(this).val());
	});
	$('#SM_ENDDT').on('change',function(){
		$('#SM_STARTDT').datepicker('option', 'maxDate', $(this).val());
	});
	
	$("#AddColumn").sortable({
		beforeStop: function( event, ui ) {
			resetColumnCnt();
		}
	});
})
/* 
function pf_getQuestionList(key,type){
	
	$.ajax({
	    type   : "post",
	    url    : "/dyAdmin/operation/survey/insertView/questionListAjax.do",
	    async : false,
	    data   : {
	    			"SM_KEYNO"  : key,
					"action"	: type	    		
	    		},
	    success:function(data){
	    	$('#AddColumn').html(data)
	    },
	    error: function() {
	    	cf_smallBox('error', '에러!! 관리자한테 문의하세요', 3000,'#d24158'); 
	    }
    });
}

//보기배점방식 체크
function pf_bogiShowHide(type){
	if(type == 'S'){
		$(".bogiscore").show();
	}else{
		$(".bogiscore").hide();
	}
}
 */
 
//게시판 타입 등록 처리 및 입력 폼 체크
function pf_smAction(type) {
	var state = false;
	
	if(ParticipationCnt > 0){
		cf_smallBox('Form', '설문조사 참여자가 존재합니다.', 3000,'#d24158');
		return state;
	}else{
		
		if(!pf_FormCheck(state, "SM_TITLE", "제목을 입력해 주세요.")){return state};
		if(!pf_FormCheck(state, "SM_MN_KEYNO", "홈페이지를 선택해 주세요.")){return state};
		if(!pf_FormCheck(state, "SM_STARTDT", "시작일을 입력해 주세요.")){return state};
		if(!pf_FormCheck(state, "SM_ENDDT", "종료일을 입력해 주세요.")){return state};
		if(!pf_FormCheck(state, "SM_EXP", "설명을 입력해 주세요.")){return state};
		
/* 		if($("#AddColumn").find(".sq-column-row").length < 1){
			cf_smallBox('Form', '컬럼을 추가해주세요', 3000,'#d24158');
			return state;
		}
		
		$('.sq-column-row').each(function(){
			var divID = $(this).attr('id').replace('SQ','');
				pf_optionAppend(divID)
		})
 */		
//		if(valcheck()){
		if(confirm("저장 하시겠습니까?")){
			success();
		}else{
			exit();
		}
//		}
	}
		
}

//성공 콜백 함수   
function success() {
    cf_replaceTrim($("#Form"));
// 	$("#Form").attr("action", "/dyAdmin/operation/survey/update.do");
	$("#Form").attr("action", "/dyAdmin/operation/survey/insert.do");
	$("#Form").submit();
}

/* 
//보기 문항 하나로 묶기
function pf_optionAppend(divID){
	
	var data = "";
	var lang = $("#SQO"+divID).find(".option").length;
	var type = $("input[type=radio][name=SM_CNT_TYPE]:checked").val();
	
	$("#SQO"+divID).find(".option").each(function(i){
		data += $(this).find(".sqo_option").val();
		data += "_";
		if(type == 'S'){
			data += $(this).find(".sqo_value").val();
		}else{
			data += 1;
		}
		if(i+1 < lang){
			data += "/";
		}
	});
	
	$("#SQ_OPTION_DATA"+divID).val(data)
	
	var sq_num = $('#SQ'+divID).find('.sq_num').val();
	$('#SQ_NUM').val(sq_num)
}
 */
 
//실패 콜백 함수   
function exit() {
	cf_smallBox('Form', '취소되었습니다.', 3000,'#d24158');
	return false;
}

// 신규 문항 등록하기
// function pf_columnInsert(divID){
	
// 		pf_optionAppend(divID)
		
// 		$.ajax({
// 		    type   : "post",
// 		    url    : "/dyAdmin/operation/survey/sq/insertAjax.do",
// 		    data   : {	
// 		    			 "SQ_SM_KEYNO" 		: $("#SM_KEYNO").val() 
// 	    				,"SQ_NUM"			: $("#SQ_NUM"+divID).val()
// 						,"SQ_ST_TYPE"		: $("#SQ_ST_TYPE"+divID).val()
// 						,"SQ_QUESTION"		: $("#SQ_QUESTION"+divID).val()
// 						,"SQ_OPTION_DATA"	: $("#SQ_OPTION_DATA").val()
// 		    		 },
//     		async : false,
// 		    success:function(data){
		    	
// 		    },
// 		    error: function(jqXHR, textStatus, exception) {
// 		    	cf_smallBox('error', '에러!! 관리자한테 문의하세요', 3000,'#d24158'); 
// // 		    	alert('error: '+textStatus+": "+exception);
// 		    }
// 		  });
	
// }

//문항 수정
// function pf_columnUpdate(divID){
	
// 	pf_optionAppend(divID);
// 	$.ajax({
// 	    type   : "post",
// 	    url    : "/dyAdmin/operation/survey/sq/updataAjax.do",
// 	    data   : {	
// 	    			 "SQ_KEYNO" 		: $("#SQ_KEYNO"+divID).val() 
// 	    			,"SQ_QUESTION" 		: $("#SQ_QUESTION"+divID).val()
// 	    			,"SQ_ST_TYPE" 		: $("#SQ_ST_TYPE"+divID).val()
// 	    			,"SQ_OPTION_DATA"	: $("#SQ_OPTION_DATA").val()
// 	    			,"SQ_NUM"			: $("#SQ_NUM"+divID).val()
// 	    		 },
//    		async : false,
// 	    success:function(data){
	    	
// 	    },
// 	    error: function(jqXHR, textStatus, exception) {
// 	    	cf_smallBox('error', '에러!! 관리자한테 문의하세요', 3000,'#d24158'); 
// // 	    	alert('error: '+textStatus+": "+exception);
// 	    }
// 	  });
// }
/* 
//문항 순서 리셋
function resetColumnCnt(){
	$row = $('.sq-column-row').not('.ui-sortable-placeholder');
	$row.each(function(i){
		$(this).find('.sq_num').val(i+1)
	})
	columnCnt = $row.length; 
}
 */
 
function pf_FormCheck(state, id, msg){
	if(!$("#"+id).val().trim()){
		cf_smallBox('Form', msg, 3000,'#d24158');
		$("#"+id).focus();
		return state;
	}
	return true;
}
/* 
// 보기 문항 체크
function valcheck(){
	var bool = true;
	$("#AddColumn").find(".sq-column-row").each(function(){
		
		if($(this).find("select[name='SQ_ST_TYPE']").val()==""){
			cf_smallBox('Form', '문제 타입을 입력해주세요.', 3000,'#d24158');
			$(this).find("select[name='SQ_ST_TYPE']").focus();
			bool = false;
			return bool;
		}
			
		if(!$(this).find("input[name='SQ_QUESTION']").val().trim()){
			cf_smallBox('Form', '질문을 작성해 주세요.', 3000,'#d24158');
			$(this).find("input[name='SQ_QUESTION']").focus();
			bool = false;
			return bool;
		}		
		
		if( $(this).find("select[name='SQ_ST_TYPE']").val() == 'R' || $(this).find("select[name='SQ_ST_TYPE']").val() == 'C' ){
			if($(this).find(".option").length < 1){
				cf_smallBox('Form', '보기는 최소 한개 이상 존재해야합니다.', 3000,'#d24158');
				bool = false;
				return bool;
			}else{
				$(this).find(".optiondialog_append_row .option").each(function(){
					if($(this).find("input[name='sqo_option']").val()==""){
						cf_smallBox('Form', '보기를 작성해 주세요.', 3000,'#d24158');
						$(this).find("input[name='sqo_option']").focus();
						bool = false;
						return bool;
					}
					
					var type = $("input[type=radio][name=SM_CNT_TYPE]:checked").val();
					
					// S : 점수, H : 인원수
					if(type == 'S'){
						if($(this).find("input[name='sqo_value']").val()==""){
							cf_smallBox('Form', '배점을 작성해 주세요.', 3000,'#d24158');
							$(this).find("input[name='sqo_value']").focus();
							bool = false;
							return bool;
						}
					}
				})
			}
		}
	});
	return bool;
}
 */
 
// 설문삭제
function pf_smDelete(){
	if(confirm("설문을 삭제하시겠습니까?")){
		$("#Form").attr("action", "/dyAdmin/operation/survey/sm/delete.do");
		$("#Form").submit();
	}
}

</script>
