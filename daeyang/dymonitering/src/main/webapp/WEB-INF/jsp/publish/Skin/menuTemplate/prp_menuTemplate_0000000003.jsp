<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<div class="navWrapSubMenu">
    <div class="inner clearfix">
            <ul class="subMenu clearfix">
            <c:forEach items="${ menuList}" var="model">
                    <sec:authorize url="${model.MN_URL}">
                        <c:set var="current" value=""/>
                        <c:if test="${model.MN_LEV eq '1' }">
                        <li>
                            <ul class="subMenu_Sub">
                            <c:forEach items="${ menuList}" var="model2">
                            <c:if test="${model2.MN_MAINKEY eq model.MN_KEYNO}">
                            <sec:authorize url="${model2.MN_URL}">
                                <li>
                                 <a class="${current}" href="${model.href }" target="${model.target }" title="${model.MN_NAME }">${model.MN_NAME }</a>
                                    <c:if test="${model2.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU') }">
                                    <div class="subMoreBtn">
                                        <a href="javascript:;" title="서브메뉴 더보기">
                                            <img src="/resources/img/icon/icon_subMenu_plus.jpg" alt="서브메뉴">
                                        </a>
                                        <ul class="subMenu_SubInner">
                                        <c:forEach items="${ menuList}" var="model3">
                                        <c:if test="${model3.MN_MAINKEY eq model2.MN_KEYNO}">
                                        <sec:authorize url="${model3.MN_URL}">
                                            <li><a class="${current}" href="${model.href }" target="${model.target }" title="${model.MN_NAME }">${model.MN_NAME }</a></li>
                                        </sec:authorize>
                                        </c:if>
                                        </c:forEach>
                                        </ul>
                                        </div>
                                    </c:if>
                                </li>
                            </sec:authorize>
                            </c:if>
                            </c:forEach>  
                             </ul>
                        </li>
                        </c:if>
                    </sec:authorize>
                    </c:forEach>
                </ul>
            </div>
        </div>
