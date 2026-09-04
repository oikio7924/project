<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>

<!-- Link to Google CDN's jQuery + jQueryUI; fall back to local -->
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
<script>
	if (!window.jQuery) {
		document.write('<script src="${ctx}/resources/smartadmin/js/libs/jquery-2.1.1.min.js"><\/script>');
	}
</script>

<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js"></script>
<script>
	if (!window.jQuery.ui) {
		document.write('<script src="${ctx}/resources/smartadmin/js/libs/jquery-ui-1.10.3.min.js"><\/script>');
	}
</script>

<!-- 클립보드 복사 -->
<script type="text/javascript" src="${ctx}/resources/api/clipboard/clipboard.min.js"></script>

<!-- validation -->
<script type="text/javascript" src="${ctx}/resources/common/js/validation/jquery.validate.js"></script>
<script type="text/javascript" src="${ctx}/resources/common/js/common/html5shiv-printshiv.js"></script>
<!-- <script type="text/javascript" src="${ctx}/resources/common/js/common/slick.js"></script> -->
<script type="text/javascript" src="${ctx}/resources/common/js/common/respond.min.js"></script>
<script type="text/javascript" src="${ctx}/resources/common/js/common/cf_function.js"></script>
<script type="text/javascript" src="${ctx}/resources/common/js/common/common.js"></script>

<script type="text/javascript" src="${ctx}/resources/api/bxslider/jquery.bxslider.js"></script>
<script type="text/javascript" src="${ctx}/resources/common/js/common/swiper.js"></script>
<script type="text/javascript" src="${ctx}/resources/publish/_DY/js/echarts.min.js"></script>

<!-- JS적용 (contextPath 적용, 선행 슬래시 보장으로 ERR_UNKNOWN_URL_SCHEME 방지) -->
<c:forEach items="${ResourcesList }" var="jsCommon">
	<c:if test="${jsCommon.RM_TYPE eq 'js' }">
		<c:set var="jsPath" value="${jsCommon.RM_PATH}"/>
		<c:if test="${fn:length(jsPath) > 0 && !fn:startsWith(jsPath, '/') && !fn:startsWith(jsPath, 'http')}"><c:set var="jsPath" value="/${jsPath}"/></c:if>
		<script src="${pageContext.request.contextPath}${jsPath}?${jsCommon.VERSION}"></script>
	</c:if>
</c:forEach>

<c:if test="${not empty currentPath }">
	<jsp:include page="/WEB-INF/jsp/publish/${currentPath}/include/script.jsp"/>
</c:if>



<script>

var token = $("meta[name='_csrf']").attr("content");


<c:choose>
	<c:when test="${homeData.HM_LOGIN eq 'Y'}">
var sessionFailUrl = '/user/member/login.do?tiles=${tilesNm }'	
	</c:when>
	<c:otherwise>
var sessionFailUrl = '/${tilesNm }/index.do'	
	</c:otherwise>
</c:choose>



$.ajaxSetup({
  headers: {
    'X-CSRF-Token': token,
    'AJAX': true
  },
  statusCode :{
	  401 : function() {
          location.href = sessionFailUrl; 
	  },
	  403 : function() {
		  location.href = sessionFailUrl;  
	  }
  }
});


var keywordList = new Array();
<c:forEach items="${keywordList}" var="model">
keywordList.push('${model.SK_KEYWORD}')
</c:forEach>

$(function(){
	
	$('#searchHeaderId').autocomplete({
		source: keywordList,
		focus: function( event, ui ) {
			return false; 
		}
	});
	
});

function pf_search(id){
    var search = cf_regExp($('#'+id).val().trim());
	
    if (!search) {
        alert('검색어를 입력하여주세요.');
        $('#'+id).val('');
        $('#'+id).focus();
        return false;
    }else if(search == ' '){
        alert('특수문자는 사용하실 수 없습니다.');
        $('#'+id).val('');
		$('#'+id).focus();
		return false;
	}
	location.href="/${tilesNm}/use/search.do?searchKeyword="+encodeURI($('#'+id).val());
}


function pf_moveMenu(URL,PAGEDIV,NEWLINK_YN,status){
	var prepare = "${sp:getData('MENU_TYPE_PREPARING')}";
	var sumbmenu = "${sp:getData('MENU_TYPE_SUBMENU')}";

	if(status == 'noLogin'){
		if(confirm('로그인이 필요합니다. 로그인 하시겠습니까?')){
			cf_login();
		}
		return false;
	}
	
	 if(status == 'noAuth'){
		alert('접근 권한이 없습니다. ');
		return false;
	} 
	
	
	if(PAGEDIV == sumbmenu){ // 소메뉴
		$.ajax({
			type: "GET",
			url: "/${tilesNm}/user/firstChildUrlAjax.do",
			data: "MN_URL="+URL,
			async:false,
			success : function(data){
				
				if(data){
					if(data.type == 'default'){
						location.href=data.url;
						return false;
					}else if(data.type == 'window'){
						window.open(data.url)
						return false;
					}else if(data.type == 'preparing'){
						alert('준비중입니다.');
						return false;
					}
					
				}
				alert("접근가능한 하위 메뉴가 없습니다.");
			},
			error: function(){
				alert('알수없는 링크. 관리자한테 문의하세요.')
				return false;
			}
		});
	}else if(PAGEDIV == prepare){ // 준비중
		alert('준비중입니다.');
	}else if(NEWLINK_YN == 'Y'){ 
		window.open(URL);
	}else{
		location.href=URL;
	}
}

/**
 * 로그인 체크
 * @returns
 */
function cf_checkLogin(){
	
	var check = false;
	
	$.ajax({
		type   	: "post",   
		url    	: "/common/member/checkLogin.do",
		async  : false,
		success : function(data){
			if(data == 'N'){
				if(confirm('로그인이 필요합니다. 로그인 하시겠습니까?')){
					cf_login();
				}
			}else{
				check = true;
			}
		},
		error: function(jqXHR, exception) {
	       	alert('error')
		}
	});
	
	return check;
}

function cf_confirmLogin(){
	if(confirm('로그인이 필요합니다. 로그인 하시겠습니까?')){
		cf_login();
	}
	return false;
}


/**
 * 로그인
 */

function cf_login(url){
	var loginUrl = '/user/member/login.do?tiles=${tilesNm}'
	if(url){ // url이 있으면 url값으로 보냄
		loginUrl += '&returnPage=' + url;
	}
	
	location.href = loginUrl;
}

</script>