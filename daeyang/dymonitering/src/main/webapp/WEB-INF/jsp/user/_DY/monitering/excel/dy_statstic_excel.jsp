<%@ page language="java" contentType="application/vnd.ms-excel;charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page import="java.net.URLEncoder,com.tx.common.dto.Common" %>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=Content-Type content="text/html; charset=UTF-8"> 
<%


String now = (String)request.getAttribute("now");
String ob = (String)request.getAttribute("DPP_NAME");

String fileName = now +" "+ ob + " 발전 통계.xls";

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
       response.setHeader("Content-Disposition", "attachment; filename=" + docName + ";");
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

<c:set var="colspan" value="5"/>


<table>
	<thead>
		<tr></tr>
		<tr class="background">
			<th colspan="${colspan}" class="title">${searchBeginDate} ~  ${searchEndDate}  ${DPP_NAME}  발전소 발전 통계</th>
		</tr>
		<tr></tr>
	</thead>
</table>		

<table id="dt_basic">
	<thead>
		<tr class="background2">
		 <c:choose>
         	<c:when test="${DaliyType eq '1' }">
			 <th>일시</th>
             <th>발전소명</th>
             <th>이름</th>
             <th>발전량(kWh)</th>
             <th>누적발전량(KW)</th>
             <th>발전시간(h)</th>
             <th>현재 출력(W)</th>
             <th>Vpv1</th>
             <th>Ipv1</th>
             <th>Vpv2</th>
             <th>Ipv2</th>
             <th>Vpv3</th>
             <th>Ipv3</th>
             <th>Vpv4</th>
             <th>Ipv4</th>
             <th>Vpv5</th>
             <th>Ipv5</th>
             <th>Vpv6</th>
             <th>Ipv6</th>
             <th>Vpv7</th>
             <th>Ipv7</th>
             <th>Vpv8</th>
             <th>Ipv8</th>
             <th>Vpv9</th>
             <th>Ipv9</th>
             <th>Vpv10</th>
             <th>Ipv10</th>
             <th>Vpv11</th>
             <th>Ipv11</th>
             <th>Vpv12</th>
             <th>Ipv12</th>
             <th>Vpv13</th>
             <th>Ipv13</th>
             <th>Vpv14</th>
             <th>Ipv14</th>
             <th>Vpv15</th>
             <th>Ipv15</th>
             <th>Vpv16</th>
             <th>Ipv16</th>
             <th>Vpv17</th>
             <th>Ipv17</th>
             <th>Vpv18</th>
             <th>Ipv18</th>
             <th>Vpv19</th>
             <th>Ipv19</th>
             <th>Vpv20</th>
             <th>Ipv20</th>
             <th>Vpv21</th>
             <th>Ipv21</th>
             <th>Vpv22</th>
             <th>Ipv22</th>
             <th>Vpv23</th>
             <th>Ipv23</th>
             <th>Vpv24</th>
             <th>Ipv24</th>
             <th>Voltage_Of_Phase_A to B</th>
             <th>Voltage_Of_Phase_B to C</th>
             <th>Voltage_Of_Phase_C to A</th>
             <th>Phase Voltage of phase A</th>
             <th>Phase Voltage of phase B</th>
             <th>Phase Voltage of phase C</th>
             <th>Current of phase A</th>
             <th>Current of phase B</th>
             <th>Current of phase C</th>
             <th>Internal Temperature</th>
             </c:when>
             <c:otherwise>
             <th>일시</th>
             <th>이름</th>
             <th>발전량(kWh)</th>
             <th>누적발전량(KWh)</th>
             </c:otherwise>
         </c:choose>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${result }" var="result">
			<c:choose>
	         	<c:when test="${DaliyType eq '1' }">
	         	<tr>
	              <td class="tdName">${result.Conn_date }</td>
	              <td class="tdName">${ob.DPP_NAME }</td>
	              <td class="tdName">${result.DI_NAME }</td>
	              <td class="tdName">${result.Daily_Generation }</td>
	              <td class="tdName">${result.Cumulative_Generation }</td>
	              <td class="tdName" style="mso-number-format:'0\.00';">${result.Daily_Generation/(ob.DPP_VOLUM/ob.DPP_INVER_COUNT)  }</td>
	              <td class="tdName">${result.Active_Power }</td>
	              <td class="tdName">${result.Vpv1}</td>
	              <td class="tdName">${result.Ipv1}</td>
	              <td class="tdName">${result.Vpv2}</td>
	              <td class="tdName">${result.Ipv2}</td>
	              <td class="tdName">${result.Vpv3}</td>
	              <td class="tdName">${result.Ipv3}</td>
	              <td class="tdName">${result.Vpv4}</td>
	              <td class="tdName">${result.Ipv4}</td>
	              <td class="tdName">${result.Vpv5}</td>
	              <td class="tdName">${result.Ipv5}</td>
	              <td class="tdName">${result.Vpv6}</td>
	              <td class="tdName">${result.Ipv6}</td>
	              <td class="tdName">${result.Vpv7}</td>
	              <td class="tdName">${result.Ipv7}</td>
	              <td class="tdName">${result.Vpv8}</td>
	              <td class="tdName">${result.Ipv8}</td>
	              <td class="tdName">${result.Vpv9}</td>
	              <td class="tdName">${result.Ipv9}</td>
	              <td class="tdName">${result.Vpv10}</td>
	              <td class="tdName">${result.Ipv10}</td>
	              <td class="tdName">${result.Vpv11}</td>
	              <td class="tdName">${result.Ipv11}</td>
	              <td class="tdName">${result.Vpv12}</td>
	              <td class="tdName">${result.Ipv12}</td>
	              <td class="tdName">${result.Vpv13}</td>
	              <td class="tdName">${result.Ipv13}</td>
	              <td class="tdName">${result.Vpv14}</td>
	              <td class="tdName">${result.Ipv14}</td>
	              <td class="tdName">${result.Vpv15}</td>
	              <td class="tdName">${result.Ipv15}</td>
	              <td class="tdName">${result.Vpv16}</td>
	              <td class="tdName">${result.Ipv16}</td>
	              <td class="tdName">${result.Vpv17}</td>
	              <td class="tdName">${result.Ipv17}</td>
	              <td class="tdName">${result.Vpv18}</td>
	              <td class="tdName">${result.Ipv18}</td>
	              <td class="tdName">${result.Vpv19}</td>
	              <td class="tdName">${result.Ipv19}</td>
	              <td class="tdName">${result.Vpv20}</td>
	              <td class="tdName">${result.Ipv20}</td>
	              <td class="tdName">${result.Vpv21}</td>
	              <td class="tdName">${result.Ipv21}</td>
	              <td class="tdName">${result.Vpv22}</td>
	              <td class="tdName">${result.Ipv22}</td>
	              <td class="tdName">${result.Vpv23}</td>
	              <td class="tdName">${result.Ipv23}</td>
	              <td class="tdName">${result.Vpv24}</td>
	              <td class="tdName">${result.Ipv24}</td>
	              <td class="tdName">${result.voltage_of_phase_A_to_B}</td>
	              <td class="tdName">${result.voltage_of_phase_B_to_C}</td>
	              <td class="tdName">${result.voltage_of_phase_C_to_A}</td>
	              <td class="tdName">${result.Phase_voltage_of_phase_A}</td>
	              <td class="tdName">${result.Phase_voltage_of_phase_B}</td>
	              <td class="tdName">${result.Phase_voltage_of_phase_C}</td>
	              <td class="tdName">${result.Current_of_phase_A}</td>
	              <td class="tdName">${result.Current_of_phase_B}</td>
	              <td class="tdName">${result.Current_of_phase_C}</td>
	              <td class="tdName">${result.Internal_temperature}</td>
	            </tr>
	         	</c:when>
	         	<%-- <c:when test="${excelType eq '2'}">
	         	<tr>
	         	  <td class="tdName">${result.ddtt }</td>
	              <td class="tdName">${result.DPP_NAME }</td>
	              <td class="tdName"><fmt:formatNumber value="${result.sdata }" pattern="0.00"/></td>
	              <td class="tdName"><fmt:formatNumber value="${result.DDM_CUL_DATA }" pattern="0.00"/></td>
	            </tr>
	         	</c:when> --%>
	         	<c:otherwise>
	         	<tr>
	         	  <td class="tdName">${result.ddtt }</td>
	              <td class="tdName">${ob.DPP_NAME }</td>
	              <td class="tdName" style="mso-number-format:'0\.00';">${result.sdata }</td>
	              <td class="tdName" style="mso-number-format:'0\.00';">${result.DDM_CUL_DATA }</td>
	            </tr>
	         	</c:otherwise>
	         </c:choose>
		</c:forEach>
	</tbody>
</table>
