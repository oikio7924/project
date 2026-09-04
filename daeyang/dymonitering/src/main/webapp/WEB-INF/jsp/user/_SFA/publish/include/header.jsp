<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>




<!------------------------------------------------------------------------
    		 HEADER START   헤더1
	------------------------------------------------------------------------->
    <header id="headerWrap">
    	<div class="headerTopWrap">
        	<div class="inner">
        		<a href="#contents_start" class="skip" title="본문 바로가기">본문 바로가기</a>
            	<ul class="rightMenu clearfix">
                	<li><a href="/">홈</a></li>
                	<sec:authorize access="isAnonymous()">
					<li><a href="/dy/member/regist.do" title="회원가입">회원가입</a></li>
                	<li><a href="javascript:;" onclick="cf_login()" title="로그인">로그인</a></li>
					</sec:authorize>
					<sec:authorize access="isAuthenticated()">
					<c:if test="${userInfo.isAdmin eq 'Y' }">
					<li><a href="/dyAdmin/index.do" target="_blank" title="관리자페이지">관리자페이지</a></li>
					</c:if>
					<li><a href="/dy/mypage/info.do" title="마이페이지">마이페이지</a></li>
					<li><a href="/user/logout.do" title="로그아웃">로그아웃</a></li>
					</sec:authorize>
                	<!-- <li><a href="#">사이트맵</a></li> -->
                	<li><a href="/dy/use/sitemap.do" title="사이트맵">사이트맵</a></li>
                </ul>
            </div>
        </div>
        
        <div class="headerLogoWrap">
        	<div class="inner clearfix">
                <div class="logoBox">
                    <a href="/"><img src="/resources/img/logo/logo.png" alt="트로닉스 로고"></a>
                </div>
                <div class="mobileMenuBtnBox viewMobile">
                  <div class="hamburger hamburger--slider-r">
                    <div class="hamburger-box">
                      <div class="hamburger-inner"></div>
                    </div>
                  </div>
                </div>
            </div>
        </div>
    </header>
    
	<!------------------------------------------------------------------------
    		 HEADER END           
	------------------------------------------------------------------------->
    
    
    <!------------------------------------------------------------------------
    		 ViewAll   한눈에 보기
	------------------------------------------------------------------------->
    <div id="viewAllWrap">
    	<div class="closeBtn">
            <button type="button"><img src="/resources/img/icon/icon_close_btn_01.png" alt="닫기"></button>
        </div>
        <div class="allMenuBox">  
            <div class="allMenuContentsBox">
            	<c:forEach items="${menuList}" var="model">
            	<c:if test="${model.MN_LEV eq '1' }">
            	<div class="row">
            		<c:if test="${not empty model.MN_COLOR }">
						<c:set var="MN_COLOR" value="style='background-color:${model.MN_COLOR }'"/>
					</c:if>
					<c:if test="${empty model.MN_COLOR }">
						<c:set var="MN_COLOR" value=""/>
					</c:if>
                	<div class="titleAllBox" ${MN_COLOR }>
                    	<h1>${model.MN_NAME }</h1>
                    </div>
                    <div class="menuAllBox">
                    	<ul class="menuAllBoxMain">
                    		<c:forEach items="${menuList}" var="model2">
            				<c:if test="${model.MN_KEYNO eq model2.MN_MAINKEY && model2.MN_LEV eq '2' }">
                        	<li>
                        		<a href="javascript:;" onclick="pf_moveMenu('${model2.MN_REAL_URL}','${model2.MN_PAGEDIV_C }','${model2.MN_NEWLINK}','${model2.authStatus}')" title="${model2.MN_NAME }">${model2.MN_NAME }</a>
                        		<c:if test="${model2.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU') }">
                        		<ul class="menuAllBoxSub">
                        			<c:forEach items="${menuList}" var="model3">
            						<c:if test="${model2.MN_KEYNO eq model3.MN_MAINKEY && model3.MN_LEV eq '3' }">
                                	<li>
                                		<a href="javascript:;" onclick="pf_moveMenu('${model3.MN_REAL_URL}','${model3.MN_PAGEDIV_C }','${model3.MN_NEWLINK}','${model3.authStatus}')" title="${model3.MN_NAME }">${model3.MN_NAME }</a>
                                	</li>
                                	</c:if>
                                	</c:forEach>
                                </ul>
                        		</c:if>
                        	
                        	</li>
                        	
                        	</c:if>
                        	</c:forEach>
                        </ul>
                    </div>
                </div>
                </c:if>
                </c:forEach>
            </div>
        </div>
        <div class="blackBox_02"></div>
    </div>
    <!------------------------------------------------------------------------
    		 ViewAll   한눈에 보기 끝
	------------------------------------------------------------------------->
    
    
    
    
    <!------------------------------------------------------------------------
    		 NAV START   메뉴
	------------------------------------------------------------------------->
    <nav id="mobileMenu" class="viewMobile">
    	<div class="mobileMainMenuBox clearfix">
        	
        	<c:import url="/common/Menu/MenuHeaderTemplate/UserViewAjax.do?key=5"/> 
        	
            <ul class="mobileBottomMenu clearfix flexible">
            	<sec:authorize access="isAnonymous()">
               	<li><a href="javascript:;" onclick="cf_login()" title="로그인">로그인</a></li>
				<li><a href="/dy/member/regist.do" title="회원가입">회원가입</a></li>
				</sec:authorize>
				<sec:authorize access="isAuthenticated()">
				<li><a href="/user/logout.do" title="로그아웃">로그아웃</a></li>
				<c:if test="${userInfo.isAdmin eq 'Y' }">
				<li><a href="/dyAdmin/index.do" title="관리자페이지">관리자페이지</a></li>
				</c:if>
				<li><a href="/dy/mypage/info.do" title="마이페이지">마이페이지</a></li>
				</sec:authorize>
				
            </ul>
        </div>
        <div class="blackBox"></div>
    </nav>
    
    <nav id="navWrap"> <!-- 윈도우메뉴 스킨 -->
    	
    	<c:import url="/common/Menu/MenuHeaderTemplate/UserViewAjax.do?key=4"/> 
    	
    	
    </nav>    
	<!------------------------------------------------------------------------
    		 NAV END           
	------------------------------------------------------------------------->

