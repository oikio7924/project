<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<style>
	.dataEmpty{text-align: center;font-size: 30px;font-weight: 500;color: red;margin-top: 70px;}
</style>
<link rel="stylesheet" type="text/css" media="all" href="/resources/common/css/dyAdmin/layout.css">
<script type="text/javascript" src="/resources/common/js/dyAdmin/jquery.easing.1.3.js"></script>
<script type="text/javascript" src="/resources/common/js/dyAdmin/common.js"></script>
<script type="text/javascript" src="/resources/common/js/dyAdmin/Chart.min.js"></script>
<script type="text/javascript" src="/resources/common/js/dyAdmin/utils.js"></script>
<script>
var msg = '${msg}'
var homeKey = '${homeKey}'
var visitorHorizontalBarList = [];
var menuHorizontalBarList = [];

$(document).ready(function(){
	if(msg){
		setTimeout(function(){
			cf_smallBox('success', msg, 3000);
			$('#headerHomeDiv').select2('open');
		},100)
	}
	<c:if test="${not empty cookieList}">
		<c:forEach items="${cookieList}" var="model">
			getCategoryListAjax('${model.mainCategory}','${model.id}');
		</c:forEach>
	</c:if>
	<c:if test="${empty cookieList}">
		getCategoryListAjax('board',1);
		getCategoryListAjax('member',2);
		getCategoryListAjax('keyword',3);
		getCategoryListAjax('menuCount',4);
		getCategoryListAjax('visitorCount',5);
	</c:if>
});

function getCategoryListAjax(mainCategory,obj){
	
	var id;
	
	if(typeof obj === 'number'){
		id = 'categoryWrap' + obj;
	}else if(typeof obj === 'string'){
		id = obj;
	}else{
		id = $(obj).closest('.categoryWrap').attr('id');
	}
	
	$.ajax({
		type : "post",
		url  : "/dyAdmin/main/DataList/DataAjax.do", 
		data : {"homeKey":homeKey,
				"mainCategory" : mainCategory,
				"id" : id
			    },
		success : function(data) {
			$("#"+id).html(data);
		},
		beforeSend:function(){
			$("#"+id).html('<div class="dataEmpty">로딩중입니다.</div>'); 
	    },
		error : function(XMLHttpRequest, textStatus, errorThrown) {
		}
	});
	
}
</script>

<section id="dash-in-box">
 	<sec:authorize url="/dyAdmin/homepage/board/dataView.do">
		<div class="one co-2 n01 r03 categoryWrap" id="categoryWrap1"></div>
	</sec:authorize>
	<sec:authorize url="/dyAdmin/person/view.do">
		<div class="one co-2 n01 r03 categoryWrap" id="categoryWrap2"></div>
	</sec:authorize>
	<sec:authorize url="/dyAdmin/admin/keyword.do">
		<div class="one co-2 n01 r03 categoryWrap" id="categoryWrap3"></div>
	</sec:authorize>
	<sec:authorize url="/dyAdmin/homepage/research/pageComment.do">
		<div class="one co-2 n01 r03 categoryWrap" id="categoryWrap4"></div>
	</sec:authorize>
	<sec:authorize url="/dyAdmin/statistics/menucount.do">
		<div class="one co-2 n01 r03 categoryWrap" id="categoryWrap5"></div>
	</sec:authorize>
	<sec:authorize url="/dyAdmin/statistics/visitor.do">
		<div class="one co-2 n01 r03 categoryWrap" id="categoryWrap6"></div>
		
	</sec:authorize>
</section>
