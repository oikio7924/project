<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<span class="btn-group categorySelect">
	<a href="#" data-toggle="dropdown" class="btn btn-default btn-xs dropdown-toggle" aria-expanded="false"><span class="caret single"></span></a>
	<ul class="dropdown-menu">
	<sec:authorize url="/dyAdmin/homepage/board/dataView.do"  >
		<li><a href="javascript:;" onclick="getCategoryListAjax('board',this);">최근 게시물</a></li>
	</sec:authorize>
	<sec:authorize url="/dyAdmin/person/view.do">	
		<li><a href="javascript:;" onclick="getCategoryListAjax('member',this);">회원 목록</a></li>
	</sec:authorize>	
	<sec:authorize url="/dyAdmin/admin/keyword.do">	
		<li><a href="javascript:;" onclick="getCategoryListAjax('keyword',this);">키워드 리스트</a></li>
	</sec:authorize>		
	<sec:authorize url="/dyAdmin/homepage/research/pageComment.do">	
		<li><a href="javascript:;" onclick="getCategoryListAjax('satisfaction',this);">페이지 최근 코멘트 내역</a></li>
	</sec:authorize>		
	<sec:authorize url="/dyAdmin/statistics/menucount.do">	
		<li><a href="javascript:;" onclick="getCategoryListAjax('menuCount',this);">메뉴 페이지 통계</a></li>
	</sec:authorize>		
	<sec:authorize url="/dyAdmin/statistics/visitor.do">	
		<li><a href="javascript:;" onclick="getCategoryListAjax('visitorCount',this);">방문자 현황</a></li>
	</sec:authorize>	
	</ul>
</span>
