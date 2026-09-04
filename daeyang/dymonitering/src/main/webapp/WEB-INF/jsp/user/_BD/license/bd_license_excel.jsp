<%@ page language="java" contentType="application/vnd.ms-excel;charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page import="java.net.URLEncoder,com.tx.common.dto.Common" %>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=Content-Type content="text/html; charset=UTF-8"> 
<%

String now = (String)request.getAttribute("now");

String fileName = "사업개발부 발전소별 인허가 정보_"+ now +".xls";

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
	text-align:center;
}

.thsize{
	border: 1px solid #000;
	font-family:돋움;
	font-size:11pt;
	font-weight:bold;
}
.tdNum, .tdName, .xl24, .tdsize, .tdsizeSlim, .tdsize2, .tdsizetext{
	border-top: 0.5pt dotted #000;
	border-bottom: 0.5pt dotted #000;
	border-right: 1pt solid #000;
	border-left: 1pt solid #000;
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
.background{
	 background-color : #c6e0b4;
	 mso-height-source:userset;
	 height:37.5pt;
	 font-size:50pt;
	 font-weight:bold;
}
.background2{
 	background-color : #e2efda;
 	height:18pt;
 	text-align:center;
}
.background3{
 	height:18pt;
 	text-align:center;
 	 border: 1pt solid black;
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

<c:set var="colspan" value="14"/>

<table>
	<thead>
		<tr></tr>
		<tr class="background">
			<th colspan="${colspan}" class="title">사업개발부 발전소별 인허가 정보 리스트</th>
		</tr>
		<tr>
			<th colspan="${colspan}" class="Subdate" style="text-align:center;">
				발전소 정보 : ${fn:length(resultList4)}건
			</th>
			
		</tr>
	</thead>
</table>		
<table id="dt_basic">
	<thead>
		<tr class="background2">
			<th class="thsize">번호</th>
			<th class="thsize">발전소 명</th>
			<th class="thsize">주소</th>
			<th class="thsize">사업주</th>
			<th class="thsize">연락처</th>
			<th class="thsize">용량</th>
			<th class="thsize">설치형태</th>
			<th class="thsize">발전사업허가예정일</th>
			<th class="thsize">발전사업허가일</th>
			<th class="thsize">발전사업만료일</th>
			<th class="thsize">개발행위허가일</th>
			<th class="thsize">개발행위만료일</th>
			<th class="thsize">PPA 접수일</th>
			<th class="thsize">PPA 접수용량</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${resultList4 }" var="b">
			<tr class="background3">
				<td>${b.COUNT}</td>
				<td>${b.bd_plant_name}</td>
				<td>${b.bd_plant_add}</td>
				<td>${b.bd_plant_owner}</td>
				<td>${b.bd_plant_phone}</td>
				<td>${b.bd_plant_volum}</td>
				<td>${b.bd_plant_installtype}</td>
				<td>${b.bd_plant_BusDueDate}</td>
				<td>${b.bd_plant_BusStart}</td>
				<td>${b.bd_plant_BusEndDate}</td>
				<td>${b.bd_plant_DevStartDate}</td>
				<td>${b.bd_plant_DevEndDate}</td>
				<td>${b.bd_plant_PPADate}</td>
				<td>${b.bd_plant_PPAVolum}</td>
			</tr>
		</c:forEach>
	</tbody>
</table>
