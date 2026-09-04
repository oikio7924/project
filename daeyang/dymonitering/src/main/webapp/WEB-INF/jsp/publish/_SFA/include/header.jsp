<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>



<header class="z-50 py-4 bg-white">
  <div class="container flex items-center justify-between h-full px-6 mx-auto">
    <button id="sidebar-menu" class="p-1 mr-5 -ml-1 rounded-md lg:hidden focus:outline-none focus:shadow-outline-purple" aria-label="Menu">
      <svg stroke="currentColor" fill="currentColor" stroke-width="0" viewBox="0 0 1024 1024" class="w-6 h-6" aria-hidden="true" height="1em" width="1em" xmlns="http://www.w3.org/2000/svg">
        <path d="M904 160H120c-4.4 0-8 3.6-8 8v64c0 4.4 3.6 8 8 8h784c4.4 0 8-3.6 8-8v-64c0-4.4-3.6-8-8-8zm0 624H120c-4.4 0-8 3.6-8 8v64c0 4.4 3.6 8 8 8h784c4.4 0 8-3.6 8-8v-64c0-4.4-3.6-8-8-8zm0-312H120c-4.4 0-8 3.6-8 8v64c0 4.4 3.6 8 8 8h784c4.4 0 8-3.6 8-8v-64c0-4.4-3.6-8-8-8z">
        </path>
      </svg>
    </button>
    <c:set var = "str" value = "${currentMenu.MN_NAME}"/>
	<c:if test="${fn:contains(str,'안전') || fn:contains(str,'점검') }">
    <div class="relative w-full max-w-xl text-base md:text-base lg:text-lg text-left hidden lg:block"><b>${userInfo.UI_NAME }</b> 님</div>
    </c:if>
    <c:set var = "str" value = "${currentMenu.MN_NAME}"/>
	<c:if test="${fn:contains(str,'세금') }">
	<div class="relative w-full max-w-xl text-base md:text-base lg:text-lg text-left hidden lg:block"><b>${userInfo.UI_NAME }</b> 님</div>
	</c:if>
    <ul class="flex items-center flex-shrink-0 space-x-6">
      <li class="relative">
        <a href="/dyAdmin/index.do" class="text-base md:text-base lg:text-lg align-bottom inline-flex items-center justify-center cursor-pointer leading-5 transition-colors duration-150 font-bold focus:outline-none px-5 py-3 rounded-lg border border-transparent active:bg-gray-200 hover:bg-gray-200 focus:ring relative bg-button-gray">관리자
          페이지</a>
      </li>
      <li class="relative">
        <a href="/user/logout.do" class="text-base md:text-base lg:text-lg align-bottom inline-flex items-center justify-center cursor-pointer leading-5 transition-colors duration-150 font-bold focus:outline-none px-5 py-3 rounded-lg border border-transparent active:bg-gray-200 hover:bg-gray-200 focus:ring relative bg-button-gray">로그아웃</a>
      </li>
    </ul>
  </div>
</header>