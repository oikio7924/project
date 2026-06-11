<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<link type="text/css" rel="stylesheet" href="/resources/common/css/paging_table.css">

<% 
String pageIndex =  request.getParameter("pageIndex") != null ? request.getParameter("pageIndex") : "" ;
String orderBy =  request.getParameter("orderBy") != null ? request.getParameter("orderBy") : "";
String sortDirect =  request.getParameter("sortDirect") != null ? request.getParameter("sortDirect") : "";

%>
<input type="hidden" name="pageIndex" id="pageIndex" value="<%=pageIndex%>">
<input type="hidden" name="orderBy" id="orderBy" value="<%=orderBy%>">
<input type="hidden" name="sortDirect" id="sortDirect"  value="<%=sortDirect%>">


<script>

var pageLoadingCheck = true;

var searchParamList = [];

$(function(){
	datepickerOption.onSelect = function(selectedDate) {
		$('#searchEndDate').datepicker('option', 'minDate', selectedDate);
	} 
	$('#searchBeginDate').datepicker(datepickerOption)
	datepickerOption.onSelect = function(selectedDate) {
		$('#searchBeginDate').datepicker('option', 'maxDate', selectedDate);
	}
	$('#searchEndDate').datepicker(datepickerOption);
	
	pf_pageLoadingCheck();
	
})

function pf_pageLoadingCheck(){
	if(pageLoadingCheck){
		pf_LinkPage(getCurrentPageFromURL());
	}else{
		setTimeout(pf_pageLoadingCheck,100);
	}
}

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
		if($(this).hasClass('desc')){
			sortDirect = 'asc'
		}else if($(this).hasClass('asc')){
			sortDirect = 'desc'
		}else{
			sortDirect = 'asc'
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

function pf_addInput(obj){
	
	var search = $(obj).val();
	var searchindex = $(obj).data('searchindex');
	
	var type = $(obj).data('type');
	
	if(type == 'currency'){	//통화 같은경우 콤마를 넣든 안넣든 검색 가능하도록 처리
		search = search.replaceAll(',','');
	}else if(type == 'currency2'){
		if(search == '0' || search == '0원'){
			search = '무료';
		}else{
			var wonCheck = false;
			if(search.indexOf('원') != -1){
				wonCheck = true;
				search = search.replaceAll('원','');
			}
			// 콤마 일괄 적용
			search = search.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
			if(wonCheck){
				search += '원';
			}
			
		}
	}
	
	var form = document.getElementById("Form");
	
	searchParams = {
		'searchKeyword' : search,
		'searchIndex' : searchindex
	}
	
	searchParamList.push(searchParams)
	
	for(var key in searchParams) {
		var hiddenField = document.createElement("input");
		hiddenField.setAttribute("class", "hiddenForm");
		hiddenField.setAttribute("type", "hidden");
		hiddenField.setAttribute("name", key);
		hiddenField.setAttribute("value", searchParams[key]);
		form.appendChild(hiddenField);
	}
	
	
}


// 페이징 처리 유지
function getCurrentPageFromURL() {
    var urlParams = new URLSearchParams(window.location.search);
    var pageParam = urlParams.get('pageIndex');
    return pageParam ? parseInt(pageParam, 10) : 1;
}


//페이지 넘기기
function pf_LinkPage(num){
	num = num || $('#pageIndex').val() || 1;
	
	cf_loading();
	
	searchParamList = [];
	$('.hiddenForm').remove();
	
	$(document).find('.search-control').each(function(){
		if($(this).val()){
			pf_addInput(this);
		}
	})
	
	$('#pageIndex').val(num);
	
	// 페이지 번호를 history스택에 추가(페이징 유지)
    history.pushState(null, null, '?pageIndex=' + num);
	
	setTimeout(pf_getList,200);	
	
}

<% String pagingDataUrl =  request.getParameter("pagingDataUrl");%>

function pf_getList(){
	
	$.ajax({
		type : "POST" ,
		url : "<%=pagingDataUrl%>",
		data :  $('#Form').serialize() ,
		async:false ,
		success : function(data){

			$('#tableWrap').html(data);
			
			if(searchParamList.length > 0){
				for(var i in searchParamList) {
					var searchIndex = searchParamList[i].searchIndex;
					$(document).find('.search-control').each(function(){
						
						var index = $(this).data('searchindex');
						if(searchIndex == index){
							$(this).val(searchParamList[i].searchKeyword)
						}
						
					});
				}
				
			}
			
			$('.search-control').on('keydown',function(key){
				if (key.keyCode == 13 && $(this).val()) {
					pf_LinkPage();
				}
			});
			
			
			
		},
		error : function(xhr, status, error) {
			cf_smallBox('ajax', '알수없는 에러 발생. 관리자한테 문의하세요.', 3000,'gray');
      }

	}).done(function(){
		cf_loading_out();
	})
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
	}else if(value == 11){ //저번 기수
		if(dd > 15){
			stdt = yyyy + "-" + pf_setTwoDigit(mm) + "-01";
			endt = yyyy + "-" + pf_setTwoDigit(mm) + "-15";
		}else{
			date.setMonth(date.getMonth - 1);
			yyyy = date.getFullYear();
			mm = date.getMonth()+1; 
			
			stdt = yyyy + "-" + pf_setTwoDigit(mm) + "-16";
			
			var lastDay = ( new Date( yyyy, mm, 0) ).getDate();
			
			endt = yyyy + "-" + pf_setTwoDigit(mm) + lastDay;
		}
	}else if(value == 12){ //이번 기수
		
		if(dd > 15){
			stdt = yyyy + "-" + pf_setTwoDigit(mm) + "-16";	
		}else{
			stdt = yyyy + "-" + pf_setTwoDigit(mm) + "-01";
		}
	}else if(value == 13){         //1~12월
		stdt = yyyy+"-01"+"-01";
		endt = yyyy+"-01"+"-31";
 	}else if(value == 14){
		stdt = yyyy+"-02"+"-01";
		endt = yyyy+"-02"+"-28";
 	}else if(value == 15){
		stdt = yyyy+"-03"+"-01";
		endt = yyyy+"-03"+"-31";
 	}else if(value == 16){
		stdt = yyyy+"-04"+"-01";
		endt = yyyy+"-04"+"-30";
 	}else if(value == 17){
		stdt = yyyy+"-05"+"-01";
		endt = yyyy+"-05"+"-31";
 	}else if(value == 18){
		stdt = yyyy+"-06"+"-01";
		endt = yyyy+"-06"+"-30";
 	}else if(value == 19){
		stdt = yyyy+"-07"+"-01";
		endt = yyyy+"-07"+"-31";
 	}else if(value == 20){
		stdt = yyyy+"-08"+"-01";
		endt = yyyy+"-08"+"-31";
 	}else if(value == 21){
		stdt = yyyy+"-09"+"-01";
		endt = yyyy+"-09"+"-30";
 	}else if(value == 22){
		stdt = yyyy+"-10"+"-01";
		endt = yyyy+"-10"+"-31";
 	}else if(value == 23){
		stdt = yyyy+"-11"+"-01";
		endt = yyyy+"-11"+"-30";
 	}else if(value == 24){
		stdt = yyyy+"-12"+"-01";
		endt = yyyy+"-12"+"-31";
 	}	
	else{
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


</script>
