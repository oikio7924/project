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

input{ border:0 solid black; width:80%;}
input:focus {outline:none;}
</style>
<div id="esco">
<table class="tg">
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
	<input type="text" style="width:20% " class="tb_gbla1 input_type_serch"  value="${list.sa2_date }"  name="sa2_date" id="sa2_date" readonly="readonly">
	날씨 :<input type="text" style="width:20% " class="tb_gbla1 input_type_serch"  value="${list.sa2_wether }"  name="sa2_wether" id="sa2_wether" readonly="readonly">
	점검자 : <input type="text" style="width:20% " class="tb_gbla1 input_type_serch" value="${list.sa2_adminname }" name="sa2_adminname" id="sa2_adminname" readonly="readonly">
	</label></td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="48" style = "background-color: #99CCFF" >인 버 터 발 전 현 황
    </td>

  </tr>
  <tr>
    <td class="tg-0lax" colspan="24">현재 출력 </td>
    <td class="tg-0lax" colspan="24">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_nowpower }"  name="sa2_nowpower" id="sa2_nowpower" readonly="readonly">
	</label></td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="24">금일 발전량 [KWh]</td>
    <td class="tg-0lax" colspan="24">
	<label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_todaypower }"  name="sa2_todaypower" id="sa2_todaypower" readonly="readonly">
	</label>
	</td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="24">누적 발전량 [KWh]</td>
    <td class="tg-0lax" colspan="24">
	<label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_accpower }"  name="sa2_accpower" id="sa2_accpower" readonly="readonly">
	</label>
	</td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="24">기간 발전량 [MWh]</td>
    <td class="tg-0lax" colspan="24">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_periodpower }"  name="sa2_periodpower" id="sa2_periodpower" readonly="readonly">
	</label>
    </td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="6" rowspan="3">AC<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;전압<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[V]</td>
    <td class="tg-0lax" colspan="6">L1 - N</td>
    <td class="tg-0lax" colspan="12">
	<label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_ACVL1_N }"  name="sa2_ACVL1_N" id="sa2_ACVL1_N" readonly="readonly">
	</label>
	</td>
    <td class="tg-0lax" colspan="6" rowspan="3">AC<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;전류<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[A]</td>
    <td class="tg-0lax" colspan="6">L1</td>
    <td class="tg-0lax" colspan="12">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_ACAL1 }"  name="sa2_ACAL1" id="sa2_ACAL1" readonly="readonly"> 
	</label>
    </td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="6">L2 - N</td>
    <td class="tg-0lax" colspan="12">
	<label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa2_ACVL2_N }"  name="sa2_ACVL2_N" id="sa2_ACVL2_N" readonly="readonly">
	</label>
	</td>
    <td class="tg-0lax" colspan="6">L2</td>
    <td class="tg-0lax" colspan="12">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_ACAL2 }"  name="sa2_ACAL2" id="sa2_ACAL2" readonly="readonly">
	</label>
    </td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="6">L3 - N</td>
    <td class="tg-0lax" colspan="12">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_ACVL3_N }"  name="sa2_ACVL3_N" id="sa2_ACVL3_N" readonly="readonly">
	</label></td>
    <td class="tg-0lax" colspan="6">L3</td>
    <td class="tg-0lax" colspan="12">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_ACAL3 }"  name="sa2_ACAL3" id="sa2_ACAL3" readonly="readonly">
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
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_palntKW }"  name="sa2_palntKW" id="sa2_palntKW" readonly="readonly">
	</label>
	</td>
    <td class="tg-0lax" colspan="12">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_palntV }"  name="sa2_palntV" id="sa2_palntV" readonly="readonly">
	</label>
    </td>
    <td class="tg-0lax" colspan="12">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_palntCT }"  name="sa2_palntCT" id="sa2_palntCT" readonly="readonly">
	</label>
    </td>
    <td class="tg-0lax" colspan="12">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_date2 }"  name="sa2_date2" id="sa2_date2" readonly="readonly">
	</label>
    </td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="24">전월 누적 송전 유효전력량[KWh]-전체</td>
    <td class="tg-0lax" colspan="6">
    <input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_meternum1 }"  name="sa2_meternum1" id="sa2_meternum1" readonly="readonly">
    </td>
    <td class="tg-0lax" colspan="9">
	<label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_meter1KWh }"  name="sa2_meter1KWh" id="sa2_meter1KWh" readonly="readonly">
	</label>
	</td>
    <td class="tg-0lax" colspan="9">　&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="24">현재 누적 송전 유효전력량[KWh]-전체</td>
    <td class="tg-0lax" colspan="6">
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_meternum2 }"  name="sa2_meternum2" id="sa2_meternum2" readonly="readonly">
	</td>
    <td class="tg-0lax" colspan="9">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_meter2KWh }"  name="sa2_meter2KWh" id="sa2_meter2KWh" readonly="readonly">
	</label></td>
    <td class="tg-0lax" colspan="9">　&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="12" style = "background-color: #99CCFF">검침 대상</td>
    <td class="tg-0lax" colspan="12" style = "background-color: #99CCFF">계량기#5</td>
    <td class="tg-0lax" colspan="12" style = "background-color: #99CCFF">계량기#9</td>
    <td class="tg-0lax" colspan="12" style = "background-color: #99CCFF">인버터 데이터</td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="6" rowspan="2" style = "background-color: #99CCFF">검침<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;주기</td>
    <td class="tg-0lax" colspan="6" style = "background-color: #99CCFF">기간</td>
    <td class="tg-0lax" colspan="12">
	<label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_meter1period }"  name="sa2_meter1period" id="sa2_meter1period" readonly="readonly">
	</label>
	</td>
    <td class="tg-0lax" colspan="12">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_meter2period }"  name="sa2_meter2period" id="sa2_meter2period" readonly="readonly">
	</label>
    </td>
    <td class="tg-0lax" colspan="12">
	<label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_inverterperiod }"  name="sa2_inverterperiod" id="sa2_inverterperiod" readonly="readonly">
	</label>
	</td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="6" style = "background-color: #99CCFF">일</td>
    <td class="tg-0lax" colspan="12">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_meter1date }"  name="sa2_meter1date" id="sa2_meter1date" readonly="readonly">
	</label>
    </td>
    <td class="tg-0lax" colspan="12">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_meter2date }"  name="sa2_meter2date" id="sa2_meter2date" readonly="readonly">
	</label>
    </td>
    <td class="tg-0lax" colspan="12">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_inverterdate }"  name="sa2_inverterdate" id="sa2_inverterdate" readonly="readonly">
	</label>
    </td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="12" style = "background-color: #99CCFF">총발전량[KWh]</td>
    <td class="tg-0lax" colspan="12"><label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_meter1allKWh }"  name="sa2_meter1allKWh" id="sa2_meter1allKWh" readonly="readonly">
	</label></td>
    <td class="tg-0lax" colspan="12"><label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_meter2allKWh }"  name="sa2_meter2allKWh" id="sa2_meter2allKWh" readonly="readonly">
	</label></td>
    <td class="tg-0lax" colspan="12"><label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_inverterallKWh }"  name="sa2_inverterallKWh" id="sa2_inverterallKWh" readonly="readonly">
	</label></td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="12" style = "background-color: #99CCFF">1일평균 발전량<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[KWh/day]</td>
    <td class="tg-0lax" colspan="12"><label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_meter1dayKWh }"  name="sa2_meter1dayKWh" id="sa2_meter1dayKWh" readonly="readonly">
	</label></td>
    <td class="tg-0lax" colspan="12"><label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_meter2dayKWh }"  name="sa2_meter2dayKWh" id="sa2_meter2dayKWh" readonly="readonly">
	</label></td>
    <td class="tg-0lax" colspan="12"><label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_inverterdayKWh }"  name="sa2_inverterdayKWh" id="sa2_inverterdayKWh" readonly="readonly">
	</label></td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="12" style = "background-color: #99CCFF">1일평균 발전시간<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[hour/day]</td>
    <td class="tg-0lax" colspan="12"><label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_meter1dayhour }"  name="sa2_meter1dayhour" id="sa2_meter1dayhour" readonly="readonly">
	</label></td>
    <td class="tg-0lax" colspan="12"><label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_meter2dayhour }"  name="sa2_meter2dayhour" id="sa2_meter2dayhour" readonly="readonly">
	</label></td>
    <td class="tg-0lax" colspan="12"><label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_inverterdayhour }"  name="sa2_inverterdayhour" id="sa2_inverterdayhour" readonly="readonly">
	</label></td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="48"> ※ 점검자 확인사항</td>
  </tr>
  <tr>
    <td class="tg-0lax" colspan="48">
    <label>
	<input type="text" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa2_opinion }"  name="sa2_opinion" id="sa2_opinion" readonly="readonly">
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
<div>
<input type="hidden" id="buttionType" name="buttionType" value="insert"> 
<input type="hidden" id="sa2_keyno" name="sa2_keyno">
<input type="hidden" id="sa_writetype" name="sa_writetype" value="2">
<input type="hidden" id="SU_KEYNO" name="SU_KEYNO" value="">
<input type="hidden" id="imgSrc" name="imgSrc" value="">
</div>
<script type="text/javascript">



</script>