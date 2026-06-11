<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script src="/resources/common/js/html2canvas.js"></script>
<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;}
.tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  overflow:hidden;padding:10px 5px;word-break:normal;}
.tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}
.tg .tg-0lax{text-align:left;vertical-align:top}
#sa2_problem{width: 5%}
input{ border:0 solid black; width:80%;}
input:focus {outline:none;}
</style>
<form:form id="Form" name = "Form" action="" method="post">
<div style="text-align: center;">
<div style="text-align: left; margin-left: 300px;">	
	<select class="form-control input-sm" name="su_keyno" id="su_keyno" onchange="changesulbi(this.value)">
	       		<option>선택하세요</option>
	       		<c:forEach items="${safeuserlist}" var="b">
				<option value="${b.SU_KEYNO}">${b.SU_SA_SULBI }</option>
				</c:forEach>		                
	</select>
</div>
<div id="esco" style="margin-left: 300px; margin-top: 20px;">
<table class="tg" style="width: 80%;">
<thead>
  <tr>
    <th class="tg-0lax" colspan="48">
    <label>
	<input type="text" style="width:20%; text-align: center;" class="tb_gbla1 input_type_serch"  value="${list.sa2_title }"  name="sa2_title" id="sa2_title">점검표
	</label></th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-0lax" colspan="48">
    <label>
	<input type="text" style="width:20% " class="tb_gbla1 input_type_serch"  value="${list.sa2_date }"  name="sa2_date" id="sa2_date">
	날씨 :<input type="text" style="width:20% " class="tb_gbla1 input_type_serch"  value="${list.sa2_wether }" name= "sa2_wether" id="sa2_wether">
	점검자 : <input type="text" style="width:20% " class="tb_gbla1 input_type_serch" value="${list.sa2_adminname }" name="sa2_adminname" id="sa2_adminname">
	</label></td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="48" style = "background-color: #99CCFF" >인 버 터 발 전 현 황 </td>

  </tr>
  <tr>
    <td class="tg-0lax" colspan="24">현재 출력 </td>
    <td class="tg-0lax" colspan="24">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_nowpower }"  name="sa2_nowpower" id="sa2_nowpower">
	</label></td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="24">금일 발전량 [KWh]</td>
    <td class="tg-0lax" colspan="24">
	<label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_todaypower }"  name="sa2_todaypower" id="sa2_todaypower">
	</label>
	</td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="24">누적 발전량 <select id="sa2_accpowertype" name="sa2_accpowertype">
    <option value="KWh">KWh</option>
    <option value="MWh">MWh</option>
    </select></td>
    <td class="tg-0lax" colspan="24">
	<label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_accpower }"  name="sa2_accpower" id="sa2_accpower">
	</label>
	</td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="24">기간 발전량<select id="sa2_periodpowertype" name="sa2_periodpowertype">
    <option value="KWh">KWh</option>
    <option value="MWh">MWh</option>
    </select></td>
    <td class="tg-0lax" colspan="24">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_periodpower }"  name="sa2_periodpower" id="sa2_periodpower">
	</label>
    </td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="6" rowspan="3">AC<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;전압<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[V]</td>
    <td class="tg-0lax" colspan="6">L1 - N</td>
    <td class="tg-0lax" colspan="12">
	<label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa2_ACVL1_N }"  name="sa2_ACVL1_N" id="sa2_ACVL1_N">
	</label>
	</td>
    <td class="tg-0lax" colspan="6" rowspan="3">AC<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;전류<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[A]</td>
    <td class="tg-0lax" colspan="6">L1</td>
    <td class="tg-0lax" colspan="12">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_ACAL1 }"  name="sa2_ACAL1" id="sa2_ACAL1">
	</label>
    </td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="6">L2 - N</td>
    <td class="tg-0lax" colspan="12">
	<label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_ACVL2_N }"  name="sa2_ACVL2_N" id="sa2_ACVL2_N">
	</label>
	</td>
    <td class="tg-0lax" colspan="6">L2</td>
    <td class="tg-0lax" colspan="12">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_ACAL2 }"  name="sa2_ACAL2" id="sa2_ACAL2">
	</label>
    </td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="6">L3 - N</td>
    <td class="tg-0lax" colspan="12">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_ACVL3_N }"  name="sa2_ACVL3_N" id="sa2_ACVL3_N">
	</label></td>
    <td class="tg-0lax" colspan="6">L3</td>
    <td class="tg-0lax" colspan="12">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_ACAL3 }"  name="sa2_ACAL3" id="sa2_ACAL3">
	</label></td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="12" style = "background-color: #99CCFF">발전소 용량 [KW]</td>
    <td class="tg-0lax" colspan="12" style = "background-color: #99CCFF">발전전압 [V]</td>
    <td class="tg-0lax" colspan="12" style = "background-color: #99CCFF">CT비 [배]</td>
    <td class="tg-0lax" colspan="12" style = "background-color: #99CCFF">검침일</td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="12">
	<label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_palntKW }"  name="sa2_palntKW" id="sa2_palntKW">
	</label>
	</td>
    <td class="tg-0lax" colspan="12">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"   value="${list.sa2_palntV }"  name="sa2_palntV" id="sa2_palntV">
	</label>
    </td>
    <td class="tg-0lax" colspan="12">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"   value="${list.sa2_palntCT }"  name="sa2_palntCT" id="sa2_palntCT">
	</label>
    </td>
    <td class="tg-0lax" colspan="12">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa2_date2 }"  name="sa2_date2" id="sa2_date2">
	</label>
    </td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="24">전월 누적 송전 유효전력량[KWh]-전체</td>
    <td class="tg-0lax" colspan="6">
    <c:if test="${list.sa2_meternum1 eq '4' }">
		<select id="sa2_meternum1" name="sa2_meternum1" onchange="changenumber(this.value)">
	    <option value="4">계량기#4</option>
	    </select>
		</c:if>
    <c:if test="${list.sa2_meternum1 eq '5' }">
		<select id="sa2_meternum1" name="sa2_meternum1" onchange="changenumber(this.value)">
	    <option value="5">계량기#5</option>
	    </select>
		</c:if>
    </td>
    <td class="tg-0lax" colspan="9">
	<label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_meter1KWh }"   name="sa2_meter1KWh" id="sa2_meter1KWh">
	</label>
	</td>
    <td class="tg-0lax" colspan="9">　&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="24">현재 누적 송전 유효전력량[KWh]-전체</td>
    <td class="tg-0lax" colspan="6">
		<c:if test="${list.sa2_meternum2 eq '3' }">
		<select id="sa2_meternum2" name="sa2_meternum2" >
	    <option value="3">계량기#3</option>
	    </select>
		</c:if>
		<c:if test="${list.sa2_meternum2 eq '7' }">
		<select id="sa2_meternum2" name="sa2_meternum2" >
	    <option value="7">계량기#7</option>
	    </select>
		</c:if>
		<c:if test="${list.sa2_meternum2 eq '9' }">
		<select id="sa2_meternum2" name="sa2_meternum2" >
	    <option value="9">계량기#9</option>
	    </select>
		</c:if>
    
	</td>
    <td class="tg-0lax" colspan="9">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_meter2KWh }"  name="sa2_meter2KWh" id="sa2_meter2KWh">
	</label></td>
    <td class="tg-0lax" colspan="9">　&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="12" style = "background-color: #99CCFF">검침 대상</td>
    <td class="tg-0lax" colspan="12" style = "background-color: #99CCFF"><input type="text" style="width:100%; background-color: #99CCFF " class="tb_gbla1 input_type_serch" readonly="readonly" value="${list.changenum }" name="changenum" id="changenum"></td>
    <td class="tg-0lax" colspan="12" style = "background-color: #99CCFF"><input type="text" style="width:100%; background-color: #99CCFF " class="tb_gbla1 input_type_serch" readonly="readonly" value="${list.changenum2 }" name="changenum2" id="changenum2"></td>
    <td class="tg-0lax" colspan="12" style = "background-color: #99CCFF">검침일</td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="6" rowspan="2" style = "background-color: #99CCFF">검침<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;주기</td>
    <td class="tg-0lax" colspan="6" style = "background-color: #99CCFF">기간</td>
    <td class="tg-0lax" colspan="12">
	<label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_meter1period }"  name="sa2_meter1period" id="sa2_meter1period">
	</label>
	</td>
    <td class="tg-0lax" colspan="12">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_meter2period }"  name="sa2_meter2period" id="sa2_meter2period">
	</label>
    </td>
    <td class="tg-0lax" colspan="12">
	<label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"   value="${list.sa2_inverterperiod }"  name="sa2_inverterperiod" id="sa2_inverterperiod">
	</label>
	</td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="6" style = "background-color: #99CCFF">일</td>
    <td class="tg-0lax" colspan="12">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa2_meter1date }"  name="sa2_meter1date" id="sa2_meter1date">
	</label>
    </td>
    <td class="tg-0lax" colspan="12">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_meter2date }"  name="sa2_meter2date" id="sa2_meter2date">
	</label>
    </td>
    <td class="tg-0lax" colspan="12">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_inverterdate }"  name="sa2_inverterdate" id="sa2_inverterdate">
	</label>
    </td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="12" style = "background-color: #99CCFF">총발전량[KWh]</td>
    <td class="tg-0lax" colspan="12"><label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_meter1allKWh }"  name="sa2_meter1allKWh" id="sa2_meter1allKWh">
	</label></td>
    <td class="tg-0lax" colspan="12"><label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_meter2allKWh }"  name="sa2_meter2allKWh" id="sa2_meter2allKWh">
	</label></td>
    <td class="tg-0lax" colspan="12"><label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_inverterallKWh }"  name="sa2_inverterallKWh" id="sa2_inverterallKWh">
	</label></td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="12" style = "background-color: #99CCFF">1일평균 발전량<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[KWh/day]</td>
    <td class="tg-0lax" colspan="12"><label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_meter1dayKWh }"  name="sa2_meter1dayKWh" id="sa2_meter1dayKWh">
	</label></td>
    <td class="tg-0lax" colspan="12"><label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_meter2dayKWh }"  name="sa2_meter2dayKWh" id="sa2_meter2dayKWh">
	</label></td>
    <td class="tg-0lax" colspan="12"><label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_inverterdayKWh }"  name="sa2_inverterdayKWh" id="sa2_inverterdayKWh">
	</label></td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="12" style = "background-color: #99CCFF">1일평균 발전시간<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[hour/day]</td>
    <td class="tg-0lax" colspan="12"><label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_meter1dayhour }"  name="sa2_meter1dayhour" id="sa2_meter1dayhour">
	</label></td>
    <td class="tg-0lax" colspan="12"><label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"   value="${list.sa2_meter2dayhour }"  name="sa2_meter2dayhour" id="sa2_meter2dayhour">
	</label></td>
    <td class="tg-0lax" colspan="12"><label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_inverterdayhour }"  name="sa2_inverterdayhour" id="sa2_inverterdayhour">
	</label></td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="48"> ※ 점검자 확인사항</td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="48">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_opinion }"  name="sa2_opinion" id="sa2_opinion">
	</label></td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="48">　&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="48">　&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="48">　&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="48">대양에스코 ㈜      TEL  061)332-8086      FAX &nbsp;&nbsp;&nbsp;070)4009-4586</td>
  </tr>
</tbody>
</table>
</div>
</div>
<div style="margin-top: 20px; margin-left: 300px;">
<table style="border: 2px solid black;">
<tr>
<td style="border-right: 2px solid black;">발전소 이상유무 선택</td>
<td style="width:250px; ">
  <c:if test="${list.sa2_problem eq '1' }">
	<label>
	<span>이상있음</span> 
	<input type = "radio" style="width : 10%;" margin-top: 5px;" name = "sa2_problem" id="sa2_problem" value = "1" checked="checked">
	</label>
	<label>
	<span>이상없음</span> 
	<input type = "radio" style="width : 10%;" margin-top: 5px;" name = "sa2_problem" id="sa2_problem" value = "2">
	</label>
  </c:if>
  <c:if test="${list.sa2_problem eq '2' }">
	<label>
	<span>이상있음</span> 
	<input type = "radio" style="width : 10%;" margin-top: 5px;" name = "sa2_problem" id="sa2_problem" value = "1" >
	</label>
	<label>
	<span>이상없음</span> 
	<input type = "radio" style="width : 10%;" margin-top: 5px;" name = "sa2_problem" id="sa2_problem" value = "2" checked="checked">
	</label>
  </c:if>
</td>
</tr>
</table>
</div>
<div style="text-align: center;">
<button type ="button" style="width: 120px;" onclick="UpdateInfo()"> 수정 </button>
</div>
<div style="text-align: center;" id = "buttondiv1">
<input type="hidden" id="buttionType" name="buttionType" value="insert"> 
<input type="hidden" id="sa2_inverternumtype" name="sa2_inverternumtype" value="">
<input type="hidden" id="sa2_keyno" name="sa2_keyno" value="${list.sa2_keyno }">
</div>
</form:form>
<script type="text/javascript">

$(function() {
    
   		 var t = document.getElementById('sa2_meternum2');
      
   		 t.addEventListener('change', function(event){
    	  
   			changetext(event.target.value);
     	 });

});

function UpdateInfo(){
	
	 $.ajax({
       url: '/sfa/safeAdmin/safeAdminUpdate2.do?${_csrf.parameterName}=${_csrf.token}',
       type: 'POST',
       data: $('#Form').serializeArray(),
       async: false,  
       success: function(result) {
       	location.reload();
       	alert(result);
       },
       error: function(){
       	alert("저장 에러");
       }
	}); 
}


function changesulbi(keyno) {
	
	$("#SU_KEYNO").val(keyno);
	
	$.ajax({
        url: '/sfa/safe/safeuserselect.do?${_csrf.parameterName}=${_csrf.token}',
        type: 'POST',
        data: {
			SU_KEYNO : keyno
		},
        async: false,  
        success: function(result) {

        	
        	$("#sa2_title").val(result.SU_SA_SULBI)
//         	$("#sa_sujeonv").val(result.SU_SA_SUJEONV)
//         	$("#sa_sujeonkw").val(result.SU_SA_SUJEONKW)
//         	$("#sa_balv").val(result.SU_SA_BALV)
//         	$("#sa_balkw").val(result.SU_SA_BALKW)
//         	$("#sa_solarv").val(result.SU_SA_SOLARV)
//         	$("#sa_solarkw").val(result.SU_SA_SOLARKW)
//         	$("#sa_transvolum").val(result.SU_SA_TRANSVOLUM)
//         	$("#sa_admintype").val(result.SU_SA_ADMINTYPE)
//         	$("#sa_admincount").val(result.SU_SA_ADMINCOUNT)
        	
        	var date = result.CONN_DATE;
        	console.log(date);
//         	var month = result.Conn_date.substr(5,7);
//         	 $("#Year").html("<option value'"result.Conn_date"'>"+i+"년"+"</option>");
        },
        error: function(){
        	alert("저장 에러");
        }
	}); 
}


function changenumber(value){
	
	if(value == 4){
		
		$("#sa2_meternum2").html("<select id='sa2_meternum2' name='sa2_meternum2'><option value='7'>계량기#7</option>")
		$("#changenum").val("계량기#4")
		$("#changenum2").val("계량기#7")
		
	}else if(value == 5){
		
		$("#sa2_meternum2").html("<select id='sa2_meternum2' name='sa2_meternum2'><option value='3'>계량기#3</option><option value='9'>계량기#9</option></select>")
		$("#changenum").val("계량기#5")
		$("#changenum2").val("계량기#3")
		
		
	}
	
}

function changetext(value){
	
	
	if(value == 3){

		$("#changenum2").val("계량기#3")
		
	}else if(value == 9){

		$("#changenum2").val("계량기#9")
		
	}
	
}
</script>