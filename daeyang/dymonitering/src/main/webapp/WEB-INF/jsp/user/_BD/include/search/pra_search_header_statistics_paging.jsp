<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<link type="text/css" rel="stylesheet" href="/resources/common/css/paging_table.css">
<% 
String orderBy =  request.getParameter("orderBy") != null ? request.getParameter("orderBy") : "";
String sortDirect =  request.getParameter("sortDirect") != null ? request.getParameter("sortDirect") : "desc";
%>
<input type="hidden" name="orderBy" id="orderBy" value="<%=orderBy%>">
<input type="hidden" name="sortDirect" id="sortDirect"  value="<%=sortDirect%>">


<script>
var searchParamList = [];

$(function(){
	
// 	datepickerOption.onSelect = function(selectedDate) {
// 		$('#searchEndDate').datepicker('option', 'minDate', selectedDate);
// 	} 
// 	$('#searchBeginDate').datepicker(datepickerOption)
// 	datepickerOption.onSelect = function(selectedDate) {
// 		$('#searchBeginDate').datepicker('option', 'maxDate', selectedDate);
// 	}
// 	$('#searchEndDate').datepicker(datepickerOption);

// 	pf_getHtml();
})

//페이징 관련 기본 셋팅
function pf_defaultPagingSetting(searchOrderBy, searchSortDirect){
	if(searchOrderBy){
		$('a.arrow').each(function(){
			var index = $(this).data('index');
			if(searchOrderBy == index){
				$(this).addClass(searchSortDirect);
			} 
			
		})
	}
	
	$('a.arrow').on('click',function(){
		var sortDirect = '';
		var orderBy = $(this).data('index');
		if($(this).hasClass('asc')){
			sortDirect = 'desc'
		}else if($(this).hasClass('desc')){
			sortDirect = 'asc'
		}else{
			sortDirect = 'desc'
		}
		
		$('#orderBy').val(orderBy);
		$('#sortDirect').val(sortDirect);
		
		pf_LinkPage();
		
	})
	
}
<% String excelDataUrl =  request.getParameter("excelDataUrl");%>

//엑셀 버튼
function pf_excel(url,formId){
	url = url || '<%=excelDataUrl%>';
	formId = formId || '#Form';
	
	cf_checkExcelDownload();
	
	$(formId).attr('action',url);
	$(formId).submit();
	
}

//관리자 게시판 날짜검색 관련 함수
function pf_settingSearchDate(value){
	
	var date = new Date();
	var yyyy = date.getFullYear();
	var mm = date.getMonth()+1; 
	var dd = date.getDate();
	
	var stdt = yyyy + "-" + pf_setTwoDigit(mm) + "-" + pf_setTwoDigit(dd);
	var endt = stdt;
	
	if(value == 1){ // 오늘
		
	}else if(value == 2){ //이번달
		stdt = yyyy + "-" + pf_setTwoDigit(mm) + "-01";
		
	}else if(value == 3){ //일주일
		stdt = pf_getNewDate('d',-7);
		
	}else if(value == 4){ //보름
		stdt = pf_getNewDate('d',-15);
		
	}else if(value == 5){ //1개월
		stdt = pf_getNewDate('m',-1);
		
	}else if(value == 6){ //2개월
		stdt = pf_getNewDate('m',-2);
		
	}else if(value == 7){ //3개월
		stdt = pf_getNewDate('m',-3);
		
	}else if(value == 8){ //6개월
		stdt = pf_getNewDate('m',-6);
	}else if(value == 9){ //1년
		stdt = pf_getNewDate('y',-1);
	}else if(value == 10){ //전체
		stdt = '';
		endt = '';
	}else{
		return false;
	}
	
	$('#searchBeginDate').val(stdt);
	$('#searchEndDate').val(endt);
	
	
	function pf_getNewDate(type,num){
		if(type == 'd'){
			date.setDate(date.getDate() + num);
		}else if(type == 'm'){
			date.setMonth(date.getMonth() + num);
		}else if(type == 'y'){
			date.setFullYear(date.getFullYear() + num);
		}
		
		yyyy = date.getFullYear();
		mm = date.getMonth()+1; 
		dd = date.getDate();
		
		return yyyy + "-" + pf_setTwoDigit(mm) + "-" + pf_setTwoDigit(dd);
	}
}

function pf_setTwoDigit(value){
	value = value + "";
	if( value.length == 1) {
		return value = '0' + value;
	}else{
		return value;
	}
}


//비동기로 ajax 조회
function pf_getHtml() {
	$.ajax({
		type : "post",
		data : $('#Form').serialize(),
		url : "/dyAdmin/statistics/board/pagingAjax.do",
		async : false,
		success : function(data) {
			$("#tableWrap").html(data);
		},
		error : function(xhr, status, error) {
			cf_smallBox('error', '에러발생', 3000,'#d24158'); 
		}
	});
}

//메뉴조회
function pf_selectMenu(value, type, id){
	$.ajax({
		type : "post",
		data : {
			"KEY" : value,
			"type" : type
		},
		url : "/dyAdmin/statistics/getmenuAjax.do",
		async : false,
		success : function(data) {
			var temp = '<option value="">메뉴 전체</option>';
			if(data != null && data.length > 0){
				$.each(data,function(i){
					var name = data[i].MENU_NAME;
					var key = data[i].MENU_KEY;
					temp += '<option value="'+key+'">'+name+'</option>';
				});
			}else{
				if(type == 'menu'){
					$('#BOARD_DIV').html(temp);
				}	
			}
			$('#'+id).html(temp);
		},
		error : function(xhr, status, error) {
			cf_smallBox('error', '에러발생', 3000,'#d24158'); 
		}
	});
}
</script>
