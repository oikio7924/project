<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
response.setStatus(301);
response.setHeader( "Location", "/user/member/login.do" );
response.setHeader( "Connection", "close" );
%>
