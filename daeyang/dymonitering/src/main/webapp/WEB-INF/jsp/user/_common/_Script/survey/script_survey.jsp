<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script type="text/javascript">

var survey_sum = 0;

//게시판 타입 등록 처리 및 입력 폼 체크
function pf_surveyInsert(){
	
	if(valcheck()){
		if(confirm("설문결과를  등록하시겠습니까?")){
			success();
		}else{
			exit();
		}
	}
}

//성공 콜백 함수   
function success() {
	$("#Form").attr("action", "/dy/function/survey/insert.do");
	$("#Form").submit();
}

//실패 콜백 함수
function exit() {
	alert("취소되었습니다.");
	return false;
}

//주관식 결과 데이터 담기
function pf_dataInput(sqID){
 var data = $("#SQ_DATA_"+sqID).val();
 $("#SQ_OPTION_DATA_"+sqID).val(data)
}

function pf_typeOdataInput(sqID){
 var data = $("#SRD_IN_DATA_"+sqID).val();
 $("#SQ_OPTION_DATA3_"+sqID).val(data)
}

//객관식 라디오 보기 결과 데이터 담기
function pf_optionRadioClick(sqID,sqo_keyno,sqo_value,order){
	if(order == 'Y') {
		$(".typeO_"+sqID).show();	
		$(".userSetOrder_"+sqID).val("Y");
	} else {
		$(".typeO_"+sqID).hide();			
		$(".userSetOrder_"+sqID).val("N");
	}
	
 var data = sqo_keyno+":"+sqo_value;
 $("#SQ_OPTION_DATA2_"+sqID).val(data)
}

//객관식 라디오 기타의견 데이터 담기
function pf_RadiodataInput(sqID,sqo_keyno,sqo_value){
var data = $("#SQ_DATA_"+sqID).val();
$("#SQ_OPTION_RADIO_DATA_"+sqID).val(data)
}

//객관식 체크박스 보기 결과 데이터 담기
function pf_optionCheckBoxClick(sqID,sqo_keyno,sqo_value){
var arr = [];
var data= "";
$.each($('input[type="checkbox"][name=SQO_OPTION_'+sqID+']'),function(k,v){
   if($(this).prop("checked")){
      arr[arr.length] = $(v).val();
   }
})

var arrStr = arr.join("/");

$("#SQ_OPTION_DATA_"+sqID).val(arrStr);

}

//보기 문항 선택 체크
function valcheck(){
var bool = true;
var lang = ${fn:length(sq_list)};
for(var i = 1; i<=lang; i++){
var type = $("#SQ_ST_TYPE_"+i).val();
  if(type == 'T'){
     if($("#SQ_DATA_"+i).val().trim() == ""){
        alert("주관식 내용을 모두 작성해 주세요");
        $("#SQ_DATA_"+i).val('');
        $("#SQ_DATA_"+i).focus();
         bool = false;
         return bool;
     }
  }else if(type == 'R' || type == 'O'){
     if(!$("input[name='SQO_OPTION_"+i+"']").is(':checked')){
        alert("객관식 내용을 모두 작성해 주세요");
        $("input[name='SQO_OPTION_"+i+"']").eq(0).focus();
         bool = false;
         return bool;
     }
     if(type == 'O') {
  	   var userSetOrder = $(".userSetOrder_"+i).val();
  	   if(userSetOrder == 'Y') {
  	       if($("#SRD_IN_DATA_"+i).val().trim() == ""){
  	           alert("기타의견 내용을 모두 작성해 주세요");
  	           $("#SRD_IN_DATA_"+i).val('');
  	           $("#SRD_IN_DATA_"+i).focus();
		    	   	bool = false;
 				    return bool;
  	       }
  	   }
     }
  }else if(type == 'C'){
     var min = $('.SQ_CK_MIN' + i).text();
     var max = $('.SQ_CK_MAX' + i).text();
     var number = $("input:checkbox[name=SQO_OPTION_"+i+"]:checked").length;

     if(min != '0'){
        if(!$("input[name='SQO_OPTION_"+i+"']").is(':checked')){
           alert("객관식 내용을 모두 작성해 주세요");
           $("input[name='SQO_OPTION_"+i+"']").eq(0).focus();
            bool = false;
            return bool;
        }
     }

     if(number > max || number < min) {
        alert(i + "번 문항에서 선택하실 수 있는 체크박스 범위를 벗어나셨습니다.");
         bool = false;
         return bool;
     }

     var data = $("#SQ_OPTION_DATA_"+i).val();
     if(data == "") {
        $("#SQ_OPTION_DATA_"+i).val(" ");
     }
  }
}
return true;
}

</script>