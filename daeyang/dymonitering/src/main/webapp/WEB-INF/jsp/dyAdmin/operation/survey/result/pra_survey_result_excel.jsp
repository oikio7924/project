<%@page import="com.tx.common.file.dto.FileSub"%>
<%@ page language="java" contentType="application/vnd.ms-excel;charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page import="java.net.URLEncoder,com.tx.common.dto.Common" %>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=Content-Type content="text/html; charset=UTF-8"> 
<%
	String title = request.getAttribute("title").toString();
	String fileName = title + "_설문조사 결과.xls";

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

.headTr{
	border-right:0.5pt solid #000;
	border-left:0.5pt solid #000;
	border-bottom: 0.5pt solid #000;
}

.footTr{
	background-color : #ddd;
	border-right:0.5pt solid #000;
	border-left:0.5pt solid #000;
	border-top: 1pt solid #000;
 	text-align:center; 
 	font-weight:bold;
}

#dt_basic .topTr{
	border-top: 0.5pt dotted #000;
	border-bottom: 0.5pt dotted #000;
	border-right: 0.5pt solid #000;
	border-left: 0.5pt solid #000;
}

#dt_basic .dataTr{
    border-top: 0.5pt dotted #000;
	border-bottom: 0.5pt dotted #000;
	border-right: 0.5pt solid #000;
	border-left: 0.5pt solid #000;
	font-size:9pt;
	font-weight:bold;
    mso-pattern:auto none; 
    white-space:normal;
    text-align:center; 
}
.nameTh{
    text-align: center;
    border-bottom: 3pt solid #000;
}

.Subdate{
    height: 18.75pt;
    text-align: right;
    height: 30pt;
}

br  {mso-data-placement:same-cell;}   

.title{
    background-color : #c6e0b4;
    font-weight: bold;
    border: 3pt solid black;
    height: 37pt;
    font-family: 맑은 고딕;
}

.background{
	 background-color : #c6e0b4;
	 mso-height-source:userset;
	 height:37pt;
	 font-size:16pt;
	 font-weight:bold;
}
</style>
</head>
<body>
<table>
	<thead>
		<c:set value="${fn:length(sq_list)}" var="col"/>
		<tr></tr>
		<tr class="background">
			<th colspan=${col+2} class="title">
			 ${SmDTO.SM_TITLE}
			</th>
		</tr>
		<tr></tr>
		<tr>
			<th colspan="2" class="Subdate" style="text-align:left;">
				총 참여인원 : ${SmDTO.SM_PANEL_CNT}명
			</th>
			<th colspan=${col} class="Subdate">
				${SmDTO.SM_STARTDT} ~ ${SmDTO.SM_ENDDT}
			</th>
		</tr>
	</thead>
</table>		


<table id="dt_basic">
	<thead>
		<tr class='headTr'>
			<th class="nameTh" width="15%">&nbsp;&nbsp;IP&nbsp;&nbsp;</th>
			<th class="nameTh" width="15%">&nbsp;&nbsp;등록일&nbsp;&nbsp;</th>
			<c:forEach items="${sq_list }" var="sq">
				<th class="nameTh" width="10%">&nbsp;&nbsp;${sq.SQ_NUM}.${sq.SQ_QUESTION}&nbsp;&nbsp;</th>
			</c:forEach>
		</tr>
	</thead>
	<tbody>
		${resultData}
	</tbody>
</table>


