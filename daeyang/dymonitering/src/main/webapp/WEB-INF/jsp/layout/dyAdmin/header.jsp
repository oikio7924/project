<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>




<div id="logo-group" style="line-height:49px;padding-left:10px;cursor: pointer;background-color: #3a3f51;">
    <div class="btn-group-vertical" style="background-color: #3a3f51; width: 100%">
        <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-expanded="false" style="background-color: #3a3f51; border: 0px; box-shadow: none; color: white; width: 80%; text-align: left;">
            홈페이지 이동
            <i class="fa fa-caret-down"></i>
        </button>
        <ul class="dropdown-menu" style="width: 80%; padding: 6px 12px;">
            <c:forEach items="${headerHomeDivList }" var="model">
	            <c:if test="${model.MN_URL ne '/dyAdmin' }">
	            <li>
	                <a href="${model.MN_FORWARD_URL }" target="_blank">${model.MN_NAME }</a>
	            </li>
	            </c:if>
            </c:forEach>
        </ul>
    </div>
</div>

<a href="javascript:;" id="cms_HomeName"><c:out value="${SITE_NAME}"/></a>
<a href="/dyAdmin/index.do" id="cms_title">관리자페이지</a>
<style>
	#cms_title, #cms_HomeName{display:inline-block;color:#555;font-size:1.2em;line-height:49px;padding-left:20px;}
	#cms_HomeName{font-size: 2.2em; color: #3a3f51;}
	@media all and (max-width:979px){
		#cms_title, #cms_HomeName{color:#fff;}
	}
	@media all and (max-width:500px){
		#cms_title {display:none;}
		#cms_HomeName{font-size: 1.2em; padding-left: 0;}
	}
</style>
<div class="pull-right">
	<!-- 최근 접속 페이지 -->
	<div class="project-context hidden-xs">

		<span class="label"></span> <span
			class="project-selector dropdown-toggle" data-toggle="dropdown">최근 
			접속페이지 <i class="fa fa-angle-down"></i>
		</span>
	
		<ul class="dropdown-menu">
			<li class="dontRemove divider"></li>
			<li class="dontRemove"><a href="javascript:pf_clearPageListCookie();"><i class="fa fa-power-off"></i> 리스트 삭제</a></li>
		</ul>
	</div>
	<!-- 메뉴 감추기 -->
	<div id="hide-menu" class="btn-header pull-right">
		<span> <a href="javascript:void(0);" data-action="toggleMenu"
			title="Collapse Menu"><i class="fa fa-reorder"></i></a>
		</span>
	</div>
	
	<c:if test="${not empty userInfo }">
	<!-- 로그아웃 -->
	<div id="logout" class="btn-header transparent pull-right">
		<span> 
			<a href="/dyAdmin/logout.do" title="로그아웃" data-action="userLogout" data-logout-msg="로그아웃 이후에 이 열린 브라우저를 닫아 보안을 강화할 수 있습니다.">
			<i class="fa fa-sign-out"></i></a>
		</span>
	</div>
	</c:if>

	<!-- fullscreen  -->
	<div id="fullscreen" class="btn-header transparent pull-right">
		<span> <a href="javascript:void(0);"
			data-action="launchFullscreen" title="Full Screen"><i
				class="fa fa-arrows-alt"></i></a>
		</span>
	</div>
	
	<!-- 도움말  -->
	<!-- cf_download2 만들어야됨  -->
	 <div id="manual" class="btn-header transparent pull-right">
		<span> <a href="javascript:;" onclick="downloadManual('/resources/manual/CT_CMS_manual.hwp')" title="manual"><i
				class="fa fa-info"></i></a>
		</span>
	</div> 

</div>


<script>

/* 최근 접속페이지 쿠키에 저장해서 불러오는 처리 */
$(function(){
	
	var getPageData = cf_getCookie('pageList');
	var pageList;
	if(getPageData != ''){
		pageList = JSON.parse(getPageData);
		var count = 0;
		$.each(pageList,function(i){
			count++
		})
		//10개 이상 쌓이지 않도록 10개 넘어가면 기존 데이터 삭제처리
		$.each(pageList,function(i){
			if(count > 10){
				delete pageList[i];
				count--
			}else{
				$('.project-context ul').prepend('<li><a href="'+pageList[i].menuUrl+'">'+pageList[i].menuName+'    - '+pageList[i].nowTime+'</a></li>')	
			}
		})
	}else{
		pageList = new Object();
	}
	
	
	var currentMenu = '${currentMenu.MN_NAME}';
	var currentMentUrl = '${currentMenu.MN_URL}';
	if(currentMenu != ''){
		var page = new Object();
		
		var d = new Date();
		var nowTime = d.getFullYear()+"."+(d.getMonth()+1)+"."+d.getDate()+". "+d.getHours()+":"+d.getMinutes()+":"+d.getSeconds();
		
		
		page.menuName = '${currentMenu.MN_NAME}';
		if(currentMentUrl == '/dyAdmin'){			
			page.menuUrl = '${currentMenu.MN_FORWARD_URL}';
		} else {			
			page.menuUrl = '${currentMenu.MN_URL}';
		}
		page.nowTime = nowTime;
		pageList[nowTime]=page;
		page = new Object();
		cf_setCookie('pageList',JSON.stringify(pageList));
	} 
	
})



function pf_clearPageListCookie(){
	
	$('.project-context ul li:not(.dontRemove)').remove();
	
	var expireDate = new Date();
	  
    //어제 날짜를 쿠키 소멸 날짜로 설정한다.
    expireDate.setDate( expireDate.getDate() - 1 );
    document.cookie = "pageList= " + "; expires=" + expireDate.toGMTString() + "; path=/";
}

function downloadManual(url) {
    $.post(url, {
            param: "value"
        }, // 요청할 변수들
        function(data) { // 성공콜백
            var BOM = "\uFEFF"; // 엑셀바이트 순서표시
            if (navigator.msSaveBlob) { // 익스플로러면
                var blobObject = new Blob([BOM + data], {
                    type: ' type: "text/plain; charset=utf-8"'
                });
                window.navigator.msSaveOrOpenBlob(blobObject, "CT_CMS_manual.hwp");
            } else { // 익스 아니면
                var link = document.createElement('a');
                link.href = url;
                link.download = url.substr(url.lastIndexOf('/') + 1);
                link.click();
            }
        }).fail(function() {
        console.log('post error')
    });
}

</script>
