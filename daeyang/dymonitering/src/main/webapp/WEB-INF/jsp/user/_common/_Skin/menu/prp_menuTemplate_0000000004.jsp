<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<div class="navWrapMain">
            <div class="inner clearfix">
                <ul class="mainMenu clearfix">
                    <c:forEach items="${ menuList}" var="model">
                    
                        <c:set var="current" value=""/>
                        <c:if test="${model.MN_LEV eq '1' }">
                            <c:if test="${fn:contains(currentMenu.MN_MAINKEYS,model.MN_KEYNO) }">
                                <c:set var="current" value="current"/>
                            </c:if>
                            <li><a class="${current}" href="javascript:;" onclick="pf_moveMenu('${model.MN_REAL_URL}','${model.MN_PAGEDIV_C }','${model.MN_NEWLINK}','${model.authStatus}')" title="${model.MN_NAME }">${model.MN_NAME }</a></li>
                        </c:if>
                    
                    </c:forEach>
                </ul>
<!--                 <div class="viewAllBox pointer"> -->
<!--                     <div class="imgBox"> -->
<!--                         <img src="/resources/img/icon/icon_eye_01.png" alt="한눈에보기 아이콘" class="mgB5"> -->
<!--                     </div> -->
<!--                     <p> -->
<!--                         	한눈에 보기 -->
<!--                     </p> -->
<!--                 </div> -->
            </div>
        </div>
        <div class="navWrapSubMenu">
            <div class="inner clearfix">
                <ul class="subMenu clearfix">
                    <c:forEach items="${ menuList}" var="model">
                    
                        <c:set var="current" value=""/>
                        <c:if test="${model.MN_LEV eq '1' }">
                        <li>
                            <ul class="subMenu_Sub">
                            <c:forEach items="${ menuList}" var="model2">
                            <c:if test="${model2.MN_MAINKEY eq model.MN_KEYNO}">
                            
                                <li>
                                    <a href="javascript:;" onclick="pf_moveMenu('${model2.MN_REAL_URL}','${model2.MN_PAGEDIV_C }','${model2.MN_NEWLINK}','${model2.authStatus}')" title="${model2.MN_NAME }">${model2.MN_NAME }</a>
                                    <c:if test="${model2.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU') }">
                                    <div class="subMoreBtn">
                                        <a href="javascript:;" title="서브메뉴 더보기">
                                            <img src="/resources/img/icon/icon_subMenu_plus.jpg" alt="서브메뉴">
                                        </a>
                                        <ul class="subMenu_SubInner">
                                        <c:forEach items="${ menuList}" var="model3">
                                        <c:if test="${model3.MN_MAINKEY eq model2.MN_KEYNO}">
                                            <li><a href="javascript:;" onclick="pf_moveMenu('${model3.MN_REAL_URL}','${model3.MN_PAGEDIV_C }','${model3.MN_NEWLINK}','${model3.authStatus}')" title="${model3.MN_NAME }">${model3.MN_NAME }</a></li>
                                        </c:if>
                                        </c:forEach>
                                        </ul>
                                    </div>
                                    </c:if>
                                </li>
                            
                            </c:if>
                            </c:forEach>    
                            </ul>
                        </li>
                        </c:if>
                    
                    </c:forEach>
                </ul>
            </div>
        </div>