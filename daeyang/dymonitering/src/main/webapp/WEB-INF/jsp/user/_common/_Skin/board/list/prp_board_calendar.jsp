<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<script src="/resources/smartadmin/js/plugin/moment/moment.min.js"></script>
<script src="/resources/api/fullcalendar/js/fullcalendar.js"></script>
<script src="/resources/api/fullcalendar/js/ko.js"></script>
<link rel="stylesheet" type="text/css" media="screen" href="/resources/api/fullcalendar/css/fullcalendar.css">

<style>
.box_date_pick {width:100%; padding:15px 0; text-align:center;}
.box_date_pick ul {display:inline-block;}
.box_date_pick ul:after { visibility: hidden;display:block;font-size: 0;content:".";clear: both;height: 0;*zoom:1;}
.box_date_pick ul li {float:left; padding:10px; border:1px solid #ddd; border-right:none; color:#65a132; font-size:1em; cursor:pointer;}
.box_date_pick ul li:last-of-type {border-right:1px solid #ddd;}
.box_date_pick ul li img {vertical-align:middle;}
.box_date_pick ul li.date_box { cursor:auto;}


.box_date_pick ul li:not(.date_box):hover {background:#eee}

</style>



<div class="box_date_pick">
	<ul>
    	<li id="prevYear"><img src="/resources/img/icon/icon_arrow_left_2_calendar.png" alt="이전날짜"></li>
    	<li id="prevMonth"><img src="/resources/img/icon/icon_arrow_left_calendar.png" alt="이전달"></li>
    	<li class="date_box"></li>
    	<li id="nextMonth"><img src="/resources/img/icon/icon_arrow_right_calendar.png" alt="다음날짜"></li>
    	<li id="nextYear"><img src="/resources/img/icon/icon_arrow_right_2_calendar.png" alt="다음달"></li>
    </ul>                        
</div> 
<div id="calendar"></div>


<%-- <!-- 게시판 리스트형 -->
 <c:import url="/common/board/UserViewAjax.do?key=list"/> --%>
