<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>


<style>
.errorPageWrap {width:100%; height:calc(100vh - 240px); text-align:center;  background:radial-gradient(100% 100%, white, #eee);}
.errorPageWrap .inner { vertical-align:middle; display:inline-block;}
.errorPageWrap .iconBox {margin-bottom:10px;}
.errorPageWrap .iconBox img {width:50%;}

.errorLetterBox {margin-bottom:20px;}
.errorLetterBox h1 {font-size:2em; font-weight:bold; margin-bottom:5px;}
.errorLetterBox h2 {font-size:1.5em; font-weight:500; color:#777; margin-bottom:10px;}
.spanPurple {color:#474d84;}
.errorLetterBox h5 {font-size:1.1em; line-height:1.2; letter-spacing:-0.7px; color:#6d6e70;}

.errorBtn {padding:7px 10px; font-size:1em;}
.bgGray02 {background-color:#6d6e70; color:#fff;}



</style>

<%-- 
   	<div class="subWrap">
        <div class="sub_contentBox">
            	<div class="errorBox_wrap">
                	<div class="errorBox">
                        <div class="letterBox">
                        	<h1>죄송합니다.<br>요청하신 페이지를 찾을 수 없습니다.</h1>
                            <h2>페이지의 URL이나 이름이 변경되었거나 일시적으로 사용할 수 없습니다.</h2>
                            <p>주소가 정확하다면 브라우저의 '새로 고침(reload)'버튼을 눌러 확인하시거나, 잠시후에 다시 접속을 시도해 주십시오.</p>
                        </div>
                        <div class="btnBox">
                        	<c:if test="${tiles eq 'Mobile' }">
                        	<a href="javascript:;" class="btn btnBlack btnErrorBack" onclick="location.href='/Mobile/index.do'">메인화면</a>
                        	</c:if>
                        	<c:if test="${tiles eq 'report' }">
                        	<a href="javascript:;" class="btn btnBlack btnErrorBack" onclick="location.href='/report/home.do'">메인화면</a>
                        	</c:if>
                        </div>
                    </div>
                </div>
        </div> 
    </div> --%>

<div class="contentsub_01">
	<div class="subConTitle_01">
    	<h2></h2>
    </div>
    <!----- 서브 타이틀 끝 ----->
	<div class="innerSubCon pdSubInner">
    	<div class="inner">
            <div class="errorPageWrap">
            	<div class="inner">
                    <div class="iconBox">
                        <img src="/resources/img/error/errorIcon_mobile-02.png" alt="에러페이지 아이콘">
                    </div>
                    <div class="errorLetterBox">
                        <h1>Page Not Found</h1>
                        <h2>요청하신 페이지를 <span class="spanPurple">찾을 수 없습니다</span></h2>
                        <h5>
                            서비스 이용에 불편을 드려 죄송합니다.<br>
                            메인 페이지로 이동 후 원하시는 정보에 대한<br>
                            페이지로 연결해 주시기 바랍니다.
                        </h5>
                    </div>
                    <div class="btnBox">
                        <button type="button" class="errorBtn bgPurple" onclick="history.back()">이전페이지로 가기</button>
                        <c:if test="${tiles eq 'Mobile' }">
                        <button type="button" class="errorBtn bgGray02" onclick="location.href='/Mobile/index.do'">메인페이지로 가기</button>
                       	</c:if>
                       	<c:if test="${tiles eq 'report' }">
                       	<button type="button" class="errorBtn bgGray02" onclick="location.href='/report/home.do'">메인페이지로 가기</button>
                       	</c:if>
                        
                    </div>
                </div>
                <span class="blank"></span>
            </div>
        </div>
    </div><!----- 서브 콘텐츠 끝 ----->
    

</div>
    
