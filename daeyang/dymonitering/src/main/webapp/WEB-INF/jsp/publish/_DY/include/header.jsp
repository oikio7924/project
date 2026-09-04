<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>

<header>
        <h1><a href="" title="대양기업 로고"><img src="${pageContext.request.contextPath}/resources/img/sub/logo.png" alt="DAEYANG"></a></h1>
        
        <nav id="gnb">
            <ul>
              	<c:if test="${userInfo.isAdmin eq 'Y' || userInfo.UI_ID eq 'samwhan' }">
                	<li class="${currentMenu.MN_NAME  eq '종합 현황' ? 'on':''}"><a href="/dy/moniter/overAll.do">종합현황</a></li>
              	</c:if>
                <li class="${currentMenu.MN_NAME eq '발전 현황' ? 'on':''}"><a href="/dy/moniter/general.do">발전현황</a></li>
                <li class="${currentMenu.MN_NAME eq '통계 분석' ? 'on':''}"><a href="/dy/moniter/stastics.do">통계분석</a></li>
                <li  class="${currentMenu.MN_NAME eq '안전 관리' ? 'on':''}"><a href="/dy/moniter/safe.do">게시판</a></li>
                <li class="${currentMenu.MN_NAME eq '공사현황' ? 'on':''}"><a href="/dy/moniter/filedown.do">공사현황</a></li>
                <li class="${currentMenu.MN_NAME eq '설정' ? 'on':''}"><a href="/dy/moniter/setting.do">설정</a></li>
                <li class="mobile"><a href="javascript:;" class="logout">Logout</a></li>
            </ul>
        </nav>
        
        <div class="rb">
            <sec:authorize access="isAuthenticated()">
              <dl>
                	<dd class="user"><b>${userInfo.isAdmin eq 'Y'? '관리자':userInfo.UI_NAME }</b>님</dd>
              </dl>
              <c:if test="${userInfo.isAdmin eq 'Y' }">
                	<button type="button" onclick="location.href='/dyAdmin/index.do'" target="_blank" class="btn_logout">관리자페이지</button>
              </c:if>
              <button type="button" onclick="location.href='/user/logout.do'" class="btn_logout" style="display: block;">로그아웃</button>
          	</sec:authorize>
        </div>
        
        <span class="menu_bar" style="width: 554px;"></span>

        <!--
			<button type="button" class="mo_menu" title="모바일메뉴">
            <span class="hamber"><i class="xi-bars"></i></span>
            <span class="close"><i class="xi-close"></i></span>
        </button>
		-->
    </header>
 <section class="mobile_title">
     <button type="button" class="btn_moArr prev" onclick="location.href='/dy/mobile.do'" title="이전"></button>
     <button type="button" class="btn_moArr reload" onclick="window.location.reload()" title="새로고침"></button>
     <button type="button" class="btn_moArr next" onclick="location.href='/dy/moniter/safe.do'" title="다음"></button>
     <c:if test="${userInfo.isAdmin eq 'Y' }">
     	<button type="button" class="btn_moArr next" onclick="location.href='/dy/moniter/stastics.do'" title="다음"></button>
     </c:if>
     
     
   <p class="tit">${currentMenu.MN_NAME}</p>
  </section>