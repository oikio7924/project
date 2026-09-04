<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<div class="hometax-side">
  <a href="${pageContext.request.contextPath}/bill.do" id="menu-main">홈</a>
  <a href="${pageContext.request.contextPath}/bill/supplier.do" id="menu-supplier">공급자</a>
  <a href="${pageContext.request.contextPath}/bill/recipient.do" id="menu-recipient">공급받는자</a>
  <a href="${pageContext.request.contextPath}/bill/contractor.do" id="menu-contractor">계약자 관리</a>
  <a href="${pageContext.request.contextPath}/bill/history.do" id="menu-history">발행내역</a>
  <a href="${pageContext.request.contextPath}/bill/account.do" id="menu-account">내 계정 설정</a>
  <a href="${pageContext.request.contextPath}/bill/logout.do" class="logout">로그아웃</a>
</div>
