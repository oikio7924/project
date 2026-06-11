<%@ page language="java" contentType="application/vnd.ms-excel;charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page import="java.net.URLEncoder,com.tx.common.dto.Common" %>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=Content-Type content="text/html; charset=UTF-8"> 
<%
String name = request.getAttribute("WEBNAME").toString();
String fileName = name+" 홈페이지 조직도 현황.xls";

String header = request.getHeader("User-Agent");
   if (header.contains("Trident")) {
   	header = "MSIE";
   } else if(header.contains("Chrome")) {
   	header = "Chrome";
   } else if(header.contains("Opera")) {
   	header = "Opera";
   }else{
   	header = "Firefox"; 
   }

if (header.contains("MSIE")) {
       String docName = URLEncoder.encode(fileName,"UTF-8").replaceAll("\\+", "%20"); 
       response.setHeader("Content-Disposition", "attachment;filename=" + docName + ";");
} else if (header.contains("Firefox")) {
       String docName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
       response.setHeader("Content-Disposition", "attachment; filename=\"" + docName + "\"");
} else if (header.contains("Opera")) {
       String docName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
       response.setHeader("Content-Disposition", "attachment; filename=\"" + docName + "\"");
} else if (header.contains("Chrome")) {
       String docName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
       response.setHeader("Content-Disposition", "attachment; filename=\"" + docName + "\"");
}

response.setHeader("Content-Description", "JSP Generated Data");


%>

<style>
#dt_basic {
	border:3pt solid #000;
	border-bottom:3pt solid #000;
	border-right:3pt solid #000;
	border-left:3pt solid #000;
}

.thsize{
	border: 1px solid #000;
	font-family:돋움;
	font-size:11pt;
	font-weight:bold;
}
.tdNum, .tdName, .xl24, .tdsize, .tdsizeSlim, .tdsize2, .tdsizetext{
	border-top: 0.5pt solid #000;
	border-bottom: 0.5pt solid #000;
	border-right: 0.5pt dotted #000;
	border-left: 0.5pt dotted #000;
	font-family:돋움;
	font-size:9pt;
	font-weight:bold;
    mso-pattern:auto none; 
    white-space:normal;
}
.tdsizeSlim{
	border-right: 0.5pt solid #000;
	border-left: 0.5pt solid #000;
}
.tdsize2{
	border-left: 0.5pt solid #000;
}

.tdNum, .tdName, .xl24, .tdsizetext{
	text-align:center;
	mso-number-format: "@";
}

.tdsizeSlim, .tdsize2, .tdsize{
 	mso-number-format:"\#\,\#\#0\ "; 
    text-align:right; 
}

.title{
    background-color : #c6e0b4;
    font-size: 22px;
    font-weight: bold;
    border: 3pt solid black;
    height: 37.5pt;
    font-family: 맑은 고딕;
}

.title2{
    font-size: 18px;
    font-weight: bold;
    height: 25.5pt;
    font-family: 맑은 고딕;
    text-align:left;
}

.background{
	 background-color : #c6e0b4;
	 mso-height-source:userset;
	 height:37.5pt;
	 font-size:50pt;
	 font-weight:bold;
}
.background2{
 	background-color : #e2efda;
}
.Subdate{
    height: 18.75pt;
    text-align: right;
    height: 30pt;
}
.xl24   {mso-number-format:"\@";}   
br      {mso-data-placement:same-cell;}   
.plus {
	color : #2278e2;
}
.foot {
	background-color:#8c8b94; 
	color:#ffffff;
	font-weight: bold;
	border:1px solid #ddd;
	border-top:1px solid #000;
	mso-number-format:"\#\,\#\#0\ "; 
    text-align:right; 
    mso-pattern:auto none; 
    white-space:normal;
}

</style>
</head>
<body>

<c:set var="colspan" value="${depth}"/>

<table>
	<thead>
		<tr></tr>
		<tr class="background">
			<th colspan="${colspan+1}" class="title">${WEBNAME} 조직도 현황</th>
		</tr>
		<tr></tr>
		<tr>
			<th colspan="${colspan+1}" class="Subdate" style="text-align:right;">
				총 ${fn:length(resultList)}개 부서
			</th>
			
		</tr>
	</thead>
</table>		


<table id="dt_basic">
	<thead>
		<tr>
			<th colspan="${depth}" class="thsize">부서명</th>
			<th class="thsize">임시부서 여부</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${resultList }" var="model" varStatus="status" >
		<tr>
			<c:forEach begin="2" end="${model.DN_DEPTH}" step="1">
			<td class="tdNum"></td>
			</c:forEach>
			<td class="tdNum">${model.DN_NAME}</td>
			<c:forEach begin="${model.DN_DEPTH}" end="${depth-1}" step="1">
			<td class="tdNum"></td>
			</c:forEach>
			<td class="tdNum">${model.DN_TEMP}</td>
		</tr>
		</c:forEach>
	</tbody>
	
</table>


<c:forEach items="${memberResult}" var="model">
<table>
	<thead>
		<tr></tr>
		<tr></tr>
		<tr>
			<th colspan="4" class="title2">${model.DepartmentName}</th>
		</tr>
	</thead>
</table>

<table id="dt_basic">
	<thead>
		<tr>
			<th class="thsize">직위</th>
			<th class="thsize">성명</th>
			<th class="thsize">담당업무</th>
			<th class="thsize">연락처</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${model.Members}" var="model2">
		<tr>
			<td class="tdNum">${model2.DU_ROLE}</td>
			<td class="tdNum">${model2.DU_NAME}</td>
			<td class="tdNum">${model2.CONTENTS_BR}</td>
			<td class="tdNum">${model2.TEL_BR}</td>
		</tr>
		</c:forEach>
	</tbody>
</table>
</c:forEach>
