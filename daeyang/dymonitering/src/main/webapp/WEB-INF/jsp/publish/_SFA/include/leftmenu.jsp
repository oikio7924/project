<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>



<aside class="z-30 flex-shrink-0 w-64 overflow-y-auto bg-white block hidden lg:block">
  <div class="py-4 text-gray-500">
    <a class="flex ml-6 text-base md:text-base lg:text-lg md:text-base font-bold text-gray-800" href="/sfa/index.do">DAEYANG</a>
	  <ul class="mt-6 px-6">
		<c:set var = "str" value = "${currentMenu.MN_NAME}"/>
		<c:if test="${fn:contains(str,'안전') || fn:contains(str,'점검') }">
		 <li class="relative py-3">
	        <a class="text-black bg-button-gray py-3.5 px-3 inline-flex items-center w-full text-sm font-semibold transition-colors duration-150 rounded-lg" 
	        href="/sfa/safe/checkingStatus.do">
	          <img src="/resources/img/icon/checking.svg" class="fill-red w-5 h-5" alt="점검 현황 아이콘">
	          <span class="ml-4">점검일지현황(현월)</span>
	        </a>
	      </li>
	      <li class="relative py-3">
	        <a class="text-black bg-button-gray py-3.5 px-3 inline-flex items-center w-full text-sm font-semibold transition-colors duration-150 rounded-lg" 
	        href="/sfa/safe/safeAdminLog.do">
	          <img src="/resources/img/icon/shieldKeyholeFillBlack.svg" class="fill-red w-5 h-5" alt="안전관리 현황 아이콘">
	          <span class="ml-4">점검일지현황(전체)</span>
	        </a>
	      </li>
	      <li class="relative py-3">
	        <a class="text-black bg-button-gray py-3.5 px-3 inline-flex items-center w-full text-sm font-semibold transition-colors duration-150 rounded-lg" 
	        href="/sfa/safe/safeAdmin.do">
	          <img src="/resources/img/icon/exclamationMarkBlack.svg" class="fill-red w-5 h-5" alt="안전관리 아이콘">
	          <span class="ml-4">점검일지등록</span>
	        </a>
	      </li>
	      <li class="relative py-3">
	        <a class="text-black bg-button-gray py-3.5 px-3 inline-flex items-center w-full text-sm font-semibold transition-colors duration-150 rounded-lg" 
	        href="/dyAdmin/safe/user.do">
	          <img src="/resources/img/icon/exclamationMarkBlack.svg" class="fill-red w-5 h-5" alt="안전관리 아이콘">
	          <span class="ml-4">발전소등록</span>
	        </a>
	      </li>
		</c:if>
		<c:if test="${fn:contains(str,'세금') }">
			<li class="relative py-3">
			   <a class="text-black bg-button-gray py-3.5 px-3 inline-flex items-center w-full text-sm font-semibold transition-colors duration-150 rounded-lg"
			     href="/sfa/safe/billsUser.do">
			     <span class="absolute inset-y-0 left-0 w-1 rounded-tr-lg rounded-br-lg" aria-hidden="true"></span>
			     <img src="/resources/img/icon/folderIconBlack.svg" class="fill-red-100 w-5 h-5" alt="공급자,공급받는자 등록 아이콘" />
			     <span class="ml-4">공급자,공급받는자 등록</span>
			   </a>
			</li>
			<li class="relative py-3">
			   <a class="text-black bg-button-gray py-3.5 px-3 inline-flex items-center w-full text-sm font-semibold transition-colors duration-150 rounded-lg"
			     href="/sfa/safe/billsAdmin.do">
			     <img src="/resources/img/icon/newspaperFillBlack.svg" class="fill-red-100 w-5 h-5" alt="세금계산서 작성 아이콘" />
			     <span class="ml-4">세금계산서 작성</span>
			   </a>
			</li>
			<li class="relative py-3">
			   <a class="text-black bg-button-gray py-3.5 px-3 inline-flex items-center w-full text-sm font-semibold transition-colors duration-150 rounded-lg"
			     href="/sfa/safe/billsAdminLog.do">
			     <img src="/resources/img/icon/taxStatusSidebarIconBlack.svg" class="fill-red-100 w-5 h-5"
			       alt="세금계산서 전송현황 아이콘" />
			     <span class="ml-4">세금계산서 전송현황</span>
			   </a>
			</li>
    	 </c:if>	
			<li class="relative py-3 border-t">
			   <a class="text-active-violet py-3.5 px-3 bg-button-violet inline-flex items-center w-full text-sm font-semibold transition-colors duration-150 rounded-lg" 
			   href="/sfa/index.do">
			     <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" class="w-5 h-5" aria-hidden="true">
			       <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z">
			       </path>
			     </svg>
			     <span class="ml-4">홈으로 돌아가기</span>
			   </a>
			</li>
    	</ul>
  </div>
</aside>


<div id="transitionBg" class="fixed inset-0 z-40 flex items-end bg-black bg-opacity-50 sm:items-center sm:justify-center" style="display: none">
</div>


<aside id="transition-sidebar" class="fixed inset-y-0 flex-shrink-0 w-64 mt-16 overflow-y-auto bg-white" style="display:none;">
  <div class="py-4 text-gray-500">
  <a class="flex ml-6 text-lg font-bold text-gray-800" href="/sfa/index.do">DAEYANG</a>
	<ul class="mt-3 md:mt-3 lg:mt-6 px-6">
	<c:set var = "str" value = "${currentMenu.MN_NAME}"/>
	<c:if test="${fn:contains(str,'안전') }">
		<li class="relative py-3">
	        <a class="text-black bg-button-gray py-3.5 px-3 inline-flex items-center w-full text-sm font-semibold transition-colors duration-150 rounded-lg" 
	        href="/sfa/safe/checkingStatus.do">
	          <img src="/resources/img/icon/checking.svg" class="fill-red w-5 h-5" alt="점검 현황 아이콘">
	          <span class="ml-4">점검일지현황(현월)</span>
	        </a>
	      </li>
	      <li class="relative py-3">
	        <a class="text-black bg-button-gray py-3.5 px-3 inline-flex items-center w-full text-sm font-semibold transition-colors duration-150 rounded-lg" 
	        href="/sfa/safe/safeAdminLog.do">
	          <img src="/resources/img/icon/shieldKeyholeFillBlack.svg" class="fill-red w-5 h-5" alt="안전관리 현황 아이콘">
	          <span class="ml-4">점검일지현황(전체)</span>
	        </a>
	      </li>
	      <li class="relative py-3">
	        <a class="text-black bg-button-gray py-3.5 px-3 inline-flex items-center w-full text-sm font-semibold transition-colors duration-150 rounded-lg" 
	        href="/sfa/safe/safeAdmin.do">
	          <img src="/resources/img/icon/exclamationMarkBlack.svg" class="fill-red w-5 h-5" alt="안전관리 아이콘">
	          <span class="ml-4">점검일지등록</span>
	        </a>
	      </li>
	      <li class="relative py-3">
	        <a class="text-black bg-button-gray py-3.5 px-3 inline-flex items-center w-full text-sm font-semibold transition-colors duration-150 rounded-lg" 
	        href="/dyAdmin/safe/user.do">
	          <img src="/resources/img/icon/exclamationMarkBlack.svg" class="fill-red w-5 h-5" alt="안전관리 아이콘">
	          <span class="ml-4">발전소등록</span>
	        </a>
	      </li>
	</c:if>
	<c:if test="${fn:contains(str,'세금') }">
		<li class="relative py-3">
		  <a class="text-black bg-button-gray py-3.5 px-3 inline-flex items-center w-full text-sm font-semibold transition-colors duration-150 rounded-lg"
		    href="/sfa/safe/billsUser.do">
		    <span class="absolute inset-y-0 left-0 w-1 rounded-tr-lg rounded-br-lg" aria-hidden="true"></span>
		    <img src="/resources/img/icon/folderIconBlack.svg" class="fill-red-100 w-5 h-5" alt="공급자,공급받는자 등록 아이콘" />
		    <span class="ml-4">공급자,공급받는자 등록</span>
		  </a>
		</li>
		<li class="relative py-3">
		  <a class="text-black bg-button-gray py-3.5 px-3 inline-flex items-center w-full text-sm font-semibold transition-colors duration-150 rounded-lg"
		    href="/sfa/safe/billsAdmin.do">
		    <img src="/resources/img/icon/newspaperFillBlack.svg" class="fill-red-100 w-5 h-5" alt="세금계산서 작성 아이콘" />
		    <span class="ml-4">세금계산서 작성</span>
		  </a>
		</li>
		<li class="relative py-3">
		  <a class="text-black bg-button-gray py-3.5 px-3 inline-flex items-center w-full text-sm font-semibold transition-colors duration-150 rounded-lg"
		    href="/sfa/safe/billsAdminLog.do">
		    <img src="/resources/img/icon/taxStatusSidebarIconBlack.svg" class="fill-red-100 w-5 h-5"
		      alt="세금계산서 전송현황 아이콘" />
		    <span class="ml-4">세금계산서 전송현황</span>
		  </a>
		</li>
	</c:if>
		<li class="relative py-3 border-t">
		  <a class="text-active-violet py-3.5 px-3 bg-button-violet inline-flex items-center w-full text-sm font-semibold transition-colors duration-150 rounded-lg" 
		  href="/sfa/index.do">
		    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" class="w-5 h-5" aria-hidden="true">
		      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z">
		      </path>
		    </svg>
		    <span class="ml-4">홈으로 돌아가기</span>
		  </a>
		</li>
    </ul>
  </div>
</aside>