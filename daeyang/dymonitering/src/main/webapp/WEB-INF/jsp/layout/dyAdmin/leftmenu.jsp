<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>





<!-- User info -->
<div class="login-info">
	<span> 
		<c:if test="${not empty userInfo }">
		<a href="javascript:void(0);" id="show-shortcut" data-action="toggleShortcut" style="color: #fafafa;"> 
			<span> ${userInfo.UI_NAME }님 접속중 </span> 
		</a>
		</c:if>

	</span>
</div>
<!-- end user info -->

<!-- NAVIGATION : This navigation is also responsive-->
<nav>
	<ul>
    <c:forEach items="${adminMenuList }" var="menu">
    	
      <%-- 상위 메인키가 없고 && 소메뉴 형태인 것만 --%>
      <c:if test="${ not empty menu.MN_MAINKEY && menu.MN_LEV eq 1 }">
      	<sec:authorize url="${menu.MN_URL}">
      	<c:if test="${menu.adminAuth eq 'Y'}">	
          <c:set var="aLink" value="${menu.MN_URL }"/>
        <c:if test="${menu.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU')}">
          <c:set var="aLink" value="#"/>
        </c:if>
        <c:if test="${menu.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_LINK')}">
          <c:set var="aLink" value="${menu.MN_FORWARD_URL  }"/>
        </c:if>
        
        <li class="${menu.MN_NAME eq currentMenu.MN_NAME ? 'active':'' }">    
          <a href="${aLink }">
            <i class="fa fa-lg fa-fw ${menu.MN_ICON_CSS}"></i>
            <span class="menu-item-parent">${menu.MN_NAME }</span>
          </a>
          <c:if test="${menu.MN_PAGEDIV_C eq 'SC_QXCFB' }">
            <ul>
              <c:forEach items="${adminMenuList }" var="subMenu">
               <c:if test="${ menu.MN_KEYNO eq subMenu.MN_MAINKEY }">
               <sec:authorize url="${subMenu.MN_URL}">
               <c:if test="${subMenu.adminAuth eq 'Y'}">
                    <c:set var="aLink" value="${subMenu.MN_URL }"/>
                    <c:if test="${subMenu.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU')}">
                     <c:set var="aLink" value="#"/>
                    </c:if>
                    <c:if test="${subMenu.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_LINK') }">
                      <c:set var="aLink" value="${subMenu.MN_FORWARD_URL }"/>
                    </c:if>
                  <li class="${subMenu.MN_NAME eq currentMenu.MN_NAME && fn:contains(currentMenu.MN_MAINKEYS,subMenu.MN_MAINKEY) ? 'active':'' }">    
                    <a href="${aLink }">
                      <i class="fa fa-lg fa-fw ${subMenu.MN_ICON_CSS}"></i>
                      <span class="menu-item-parent">${subMenu.MN_NAME }</span>
                    </a>
                    <c:if test="${subMenu.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU')}">
                      <ul>
                        <c:forEach items="${adminMenuList }" var="subSubMenu">
                         <c:if test="${ subMenu.MN_KEYNO eq subSubMenu.MN_MAINKEY }">
                         <sec:authorize url="${subSubMenu.MN_URL}">
                         <c:if test="${subSubMenu.adminAuth eq 'Y'}">
                            <c:set var="aLink" value="${subSubMenu.MN_URL }"/>
                            <c:if test="${subSubMenu.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU') }">
                              <c:set var="aLink" value="#"/>
                            </c:if>
                            <c:if test="${subSubMenu.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_LINK') }">
                              <c:set var="aLink" value="${subSubMenu.MN_FORWARD_URL }"/>
                            </c:if>
                            <li class="${subSubMenu.MN_NAME eq currentMenu.MN_NAME && fn:contains(currentMenu.MN_MAINKEYS,subSubMenu.MN_MAINKEY) ? 'active':'' }">    
                              <a href="${aLink }">
                                <i class="fa fa-lg fa-fw ${subSubMenu.MN_ICON_CSS}"></i>
                                <span class="menu-item-parent">${subSubMenu.MN_NAME }</span>
                              </a>
                              <c:if test="${subSubMenu.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU')}">
			                      <ul>
			                        <c:forEach items="${adminMenuList }" var="subSubSubMenu">
			                         <c:if test="${ subSubMenu.MN_KEYNO eq subSubSubMenu.MN_MAINKEY }">
			                         <sec:authorize url="${subSubSubMenu.MN_URL}">
			                         <c:if test="${subSubSubMenu.adminAuth eq 'Y'}">
			                            <c:set var="aLink" value="${subSubSubMenu.MN_URL }"/>
			                            <c:if test="${subSubSubMenu.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU') }">
			                              <c:set var="aLink" value="#"/>
			                            </c:if>
			                            <c:if test="${subSubSubMenu.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_LINK') }">
			                              <c:set var="aLink" value="${subSubSubMenu.MN_FORWARD_URL }"/>
			                            </c:if>
			                            <li class="${subSubSubMenu.MN_NAME eq currentMenu.MN_NAME && fn:contains(currentMenu.MN_MAINKEYS,subSubSubMenu.MN_MAINKEY) ? 'active':'' }">    
			                              <a href="${aLink }">
			                                <i class="fa fa-lg fa-fw ${subSubSubMenu.MN_ICON_CSS}"></i>
			                                <span class="menu-item-parent">${subSubSubMenu.MN_NAME }</span>
			                              </a>
			                            </li>
			                            </c:if>
			                         </sec:authorize>
			                         </c:if>
			                        </c:forEach>
			                      </ul>
			                    </c:if>
                            </li>
                            </c:if>
                         </sec:authorize>
                         </c:if>
                        </c:forEach>
                      </ul>
                    </c:if>
                  </li>
               </c:if>
               </sec:authorize>   
               </c:if>
              </c:forEach>
            </ul>
          </c:if>
        </li>
        </c:if>
        </sec:authorize>
      </c:if>
    </c:forEach>  
			
			
	</ul>
</nav>


<span class="minifyme" data-action="minifyMenu"> 
	<i class="fa fa-arrow-circle-left hit"></i>
</span>

