<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script src="/resources/common/js/html2canvas.js"></script>


<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css"
	integrity="sha512-KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0g=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />

<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;}
.tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:20px;
  overflow:hidden;padding:10px 5px;word-break:normal;}
.tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:20px;
  font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}
.tg .tg-0lax{text-align:left;vertical-align:middle}
#sa2_problem{width: 5%}
.border{
	border-bottom :2px solid black;
}
input[type="text"] { border:0 solid black; width:80%; height: 30px;  /* 높이 초기화 */line-height: normal;  /* line-height 초기화 */font-size: 20px;}

input:focus {outline:none;}
select{ height: 30px; }

</style>
<form:form id="Form" name="Form" method="post">
	<div style="text-align: center;" id="esco">
<!-- 		<div> -->
<!-- 			<input type="text" style="width: 5%; text-align: center;" -->
<!-- 				class="tb_gbla1 input_type_serch" readonly="readonly" -->
<!-- 				name="sa2_count" id="sa2_count">번 중 <input type="text" -->
<!-- 				style="width: 5%; text-align: center;" -->
<!-- 				class="tb_gbla1 input_type_serch" readonly="readonly" -->
<!-- 				name="sa2_count2" id="sa2_count2">번 점검 <select -->
<!-- 				style="margin-left: 50px;" class="form-control input-sm" -->
<!-- 				name="su_keyno" id="su_keyno"> -->
<!-- 			</select> <select class="form-control input-sm" name="Year" id="Year"></select> -->
<!-- 			<select class="form-control input-sm" name="Month" id="Month" -->
<!-- 				onchange="datanumselect()"><option value="">선택하세요</option></select> -->
<!-- 				 <select class="form-control input-sm" name="selectgroup" id="selectgroup"></select> -->
<!-- 			<button id ="autoInsert" type="button" onclick="view()">조회</button> -->
<!-- 		</div> -->
		<div style="margin-left: 400px; margin-top: 20px;">
			<table class="tg" style="width: 80%; border: 3px solid black;">
				<thead>
<!-- 				  	<tr data-html2canvas-ignore="true"> -->
<!-- 					  	<th class="tg-0lax" colspan="100%" style="text-align: center;">양식 전체 캡쳐<input type="checkbox" id="allcheck"></th> -->
<!-- 					</tr> -->
					<tr>
						<th class="tg-0lax" colspan="60" style="text-align: center;">
							<label> <input type="text"
								style="width: 20%; text-align: center;"
								class="tb_gbla1 input_type_serch" title=""  value = "${list.sa2_title }"name="sa2_title"
								id="sa2_title">점검표
						</label>
						</th>
					</tr>
				</thead>
<!-- 					<colgroup> -->
<!-- 						<col style="width: 10%;"> -->
<!-- 						<col style="width: 15%;"> -->
<!-- 						<col style="width: 10%;"> -->
<!-- 						<col style="width: 15%;"> -->
<!-- 						<col style="width: 10%;"> -->
<!-- 						<col style="width: 15%;"> -->
<!-- 						<col style="width: 15%;"> -->
<!-- 						<col style="width: 15%;"> -->
<!-- 					</colgroup> -->
				<tbody>
					<tr>
						<td class="tg-0lax" colspan="60" style="text-align: center;">
							<label> <input type="text" style="width: 20%"
								class="tb_gbla1 input_type_serch" value="${now }"
								name="sa2_date" id="sa2_date"> 날씨 :<select
								id="sa2_wether" name="sa2_wether" style="width: 10%">
									<option value="">날씨 선택</option>
									<option value="맑음">맑음</option>
									<option value="흐림">흐림</option>
									<option value="비">비</option>
									<option value="눈">눈</option>
							</select> 점검자 : <select id="sa2_adminname" name="sa2_adminname"
								style="width: 10%">
									<option value="">관리자 선택</option>
									<option value="이민환">이민환</option>
									<option value="김용인">김용인</option>
							</select>
						</label>
						</td>
					</tr>
				</tbody>
			</table>
			<table class="tg" style="width: 80%; border: 3px solid black; text-align: center;">
					<thead></thead>
					<tbody class="esco">
						  	<tr data-html2canvas-ignore="true">
						  		<td colspan="100%">인버터발전현황 부분 캡쳐<input type="checkbox" class="check" checked="checked" onclick="checkboxEvent(this)"></td> 
						  	</tr>
							<tr>
								<td class="tg-0lax" colspan="100%" style="background-color: #99CCFF; text-align: center;">인
									버 터 발 전 현 황</td>
		<!-- 						<td class="tg-0lax" colspan="10" style="background-color: #99CCFF"><label id="sa2_label0"></label> -->
		<!-- 						</td> -->
							</tr>
							<tr id = "inputplus0">
								<td class="tg-0lax" colspan="">인버터 번호</td>
								<td class="tg-0lax" ><label> <input
										type="text" style="width: 40%; text-align: right;" class="tb_gbla1 input_type_serch"
										value="1" name="inverternumber" id="inverternumber">
								</label></td>
		<!-- 						<td class="tg-0lax" colspan="10"><label id="sa2_label0"></label> -->
		<!-- 						</td> -->
							</tr>
							<tr id = "inputplus1">
								<td class="tg-0lax" colspan="">현재 출력</td>
								<td class="la2" ><label> <input
										type="text" style="width: 40%" class="tb_gbla1 input_type_serch"
										value="" name="sa2_nowpower" id="sa2_nowpower">
										<input type="hidden" value="" id="sa2_nowpower1" name="sa2_nowpower1">
								</label></td>
		<!-- 						<td class="tg-0lax" colspan="10"><label id="sa2_label1"></label> -->
		<!-- 						</td> -->
							</tr>
							<tr id = "inputplus2">
								<td class="tg-0lax" colspan="">금일 발전량 [KWh]</td>
								<td class="la3" ><label> <input
										type="text" style="width: 40%" class="tb_gbla1 input_type_serch"
										value="" name="sa2_todaypower" id="sa2_todaypower">
										<input type="hidden" value="" id="sa2_todaypower1" name="sa2_todaypower1">
										
								</label></td>
		<!-- 						<td class="tg-0lax" colspan="10"><label id="sa2_label2"></label> -->
		<!-- 						</td> -->
							</tr>
							<tr id = "inputplus3">
								<td class="tg-0lax" colspan="">누적 발전량 <select
									id="sa2_accpowertype" name="sa2_accpowertype">
										<option value="KWh">KWh</option>
										<option value="MWh">MWh</option>
								</select></td>
								<td class="la4">
								<label> <input
										type="text" style="width: 40%" class="tb_gbla1 input_type_serch"
										value="" name="sa2_accpower" id="sa2_accpower">
										<input type="hidden" value="" id ="sa2_accpower1" name="sa2_accpower1">
								</label></td>
		<!-- 						<td class="tg-0lax" colspan="10"><label id="sa2_label3"></label> -->
		<!-- 						</td> -->
							</tr>
							<tr class="border" id = "inputplus4">
								<td class="tg-0lax" colspan="">기간 발전량<select
									id="sa2_periodpowertype" name="sa2_periodpowertype">
										<option value="KWh">KWh</option>
										<option value="MWh">MWh</option>
								</select></td>
								<td class="la5" ><label> <input
										type="text" style="width: 40%" class="tb_gbla1 input_type_serch"
										
										name="sa2_periodpower">
										<input type="hidden" value="" id ="sa2_periodpower1" name="sa2_periodpower1">
								</label></td>
		<!-- 						<td class="tg-0lax" colspan="10"><label id="sa2_label4"></label> -->
	<!-- 						</td> -->
						</tr>
						
							<tr id = "inputplus5" class="hiddenTr">
								<td class="tg-0lax" colspan="">인버터 번호</td>
								<td class="tg-0lax" ><label> <input
										type="text" style="width: 40%" class="tb_gbla1 input_type_serch"
										value="1" name="inverternumber" id="inverternumber">
										
								</label></td>
		<!-- 						<td class="tg-0lax" colspan="10"><label id="sa2_label0"></label> -->
		<!-- 						</td> -->
							</tr>
							<tr id = "inputplus6" class="hiddenTr">
								<td class="tg-0lax" colspan="">현재 출력</td>
								<td class="tg-0lax" ><label> <input
										type="text" style="width: 40%" class="tb_gbla1 input_type_serch"
										value="" name="sa2_nowpower" id="sa2_nowpower">
								
								</label></td>
		<!-- 						<td class="tg-0lax" colspan="10"><label id="sa2_label1"></label> -->
		<!-- 						</td> -->
							</tr>
							<tr id = "inputplus7" class="hiddenTr">
								<td class="tg-0lax" colspan="">금일 발전량 [KWh]</td>
								<td class="tg-0lax" ><label> <input
										type="text" style="width: 40%" class="tb_gbla1 input_type_serch"
										value="" name="sa2_todaypower" id="sa2_todaypower">
										
								</label></td>
		<!-- 						<td class="tg-0lax" colspan="10"><label id="sa2_label2"></label> -->
		<!-- 						</td> -->
							</tr>
							<tr id = "inputplus8" class="hiddenTr">
								<td class="tg-0lax" colspan="">누적 발전량 <select
									id="sa2_accpowertype" name="sa2_accpowertype">
										<option value="KWh">KWh</option>
										<option value="MWh">MWh</option>
								</select></td>
								<td class="tg-0lax" >
								<label> <input
										type="text" style="width: 40%" class="tb_gbla1 input_type_serch"
										value="" name="sa2_accpower" id="sa2_accpower">
										
								</label></td>
		<!-- 						<td class="tg-0lax" colspan="10"><label id="sa2_label3"></label> -->
		<!-- 						</td> -->
							</tr>
							<tr id = "inputplus9" class="hiddenTr">
								<td class="tg-0lax" colspan="">기간 발전량<select
									id="sa2_periodpowertype" name="sa2_periodpowertype">
										<option value="KWh">KWh</option>
										<option value="MWh">MWh</option>
								</select></td>
								<td class="tg-0lax" ><label> <input
										type="text" style="width: 40%" class="tb_gbla1 input_type_serch"
										oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
										name="sa2_periodpower" id="sa2_periodpower">
										
								</label></td>
		<!-- 						<td class="tg-0lax" colspan="10"><label id="sa2_label4"></label> -->
	<!-- 						</td> -->
						</tr>
						
					</tbody>
				</table>
				
				
				
				<!-- <tbody id="plustr"></tbody> -->
				
				
				<table class="tg" style="width: 80%; border: 3px solid black; text-align: center;" >
				
				<tbody class="esco" data-html2canvas-ignore="true">
				<tr data-html2canvas-ignore="true">
			  		<td colspan="60">기타 데이터 부분 캡쳐<input type="checkbox" class="check" onclick="checkboxEvent(this)"></td> 
			  	</tr>
				<tr class = "etcTr">
					<td class="tg-0lax" colspan="6" rowspan="3">AC전압&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[V]</td>
					</td>
					<td class="tg-0lax" colspan="6">L1 - N</td>
					<td class="tg-0lax" colspan="12" style="background-color : #edde5a;"><label id="sa2_label5">
							<input type="text" style="width: 100%; background-color : #edde5a;"
							class="tb_gbla1 input_type_serch"
							oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							onclick="jun()"
							name="sa2_ACVL1_N" id="sa2_ACVL1_N">
					</label></td>
					<td class="tg-0lax" colspan="6" rowspan="3">AC전류&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[A]</td>
					</td>
					<td class="tg-0lax" colspan="6">L1</td>
					<td class="tg-0lax" colspan="12" style="background-color : #edde5a;"><label id="sa2_label6">
							<input type="text" style="width: 100%; background-color : #edde5a;"
							class="tb_gbla1 input_type_serch"
							oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							onclick="jun()"
							name="sa2_ACAL1" id="sa2_ACAL1">
					</label></td>
				</tr>
				<tr class = "etcTr">
					<td class="tg-0lax" colspan="6">L2 - N</td>
					<td class="tg-0lax" colspan="12" style="background-color : #edde5a;"><label id="sa2_label7">
							<input type="text" style="width: 100%; background-color : #edde5a;"
							class="tb_gbla1 input_type_serch"
							oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							onclick="jun()"
							name="sa2_ACVL2_N" id="sa2_ACVL2_N">
					</label></td>
					<td class="tg-0lax" colspan="6">L2</td>
					<td class="tg-0lax" colspan="12" style="background-color : #edde5a;"><label id="sa2_label8">
							<input type="text" style="width: 100%; background-color : #edde5a;"
							class="tb_gbla1 input_type_serch"
							oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							onclick="jun()"
							name="sa2_ACAL2" id="sa2_ACAL2">
					</label></td>
				</tr>
				<tr class = "etcTr">
					<td class="tg-0lax" colspan="6">L3 - N</td>
					<td class="tg-0lax" colspan="12" style="background-color : #edde5a;"><label id="sa2_label9">
							<input type="text" style="width: 100%; background-color : #edde5a;"
							class="tb_gbla1 input_type_serch"
							oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							onclick="jun()"
							name="sa2_ACVL3_N" id="sa2_ACVL3_N">
					</label></td>
					<td class="tg-0lax" colspan="6">L3</td>
					<td class="tg-0lax" colspan="12" style="background-color : #edde5a;"><label id="sa2_label10">
							<input type="text" style="width: 100%; background-color : #edde5a;"
							class="tb_gbla1 input_type_serch"
							oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							onclick="jun()"
							name="sa2_ACAL3" id="sa2_ACAL3">
					</label></td>
				</tr>
				<tr>
					<td class="tg-0lax" colspan="12" style="background-color: #99CCFF">발전소
						용량 [KW]</td>
					<td class="tg-0lax" colspan="12" style="background-color: #99CCFF">발전전압
						[V]</td>
					<td class="tg-0lax" colspan="12" style="background-color: #99CCFF">CT비
						[배]</td>
					<td class="tg-0lax" colspan="12" style="background-color: #99CCFF">검침일</td>
				</tr>
				<tr>
					<td class="tg-0lax" colspan="12"><label> <input
							type="text" style="width: 100%" class="tb_gbla1 input_type_serch"
							oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							name="sa2_palntKW" id="sa2_palntKW">
					</label></td>
					<td class="tg-0lax" colspan="12"><label> <input
							type="text" style="width: 100%" class="tb_gbla1 input_type_serch"
							oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							name="sa2_palntV" id="sa2_palntV">
					</label></td>
					<td class="tg-0lax" colspan="12"><label> <input
							type="text" style="width: 100%" class="tb_gbla1 input_type_serch"
							oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							name="sa2_palntCT" id="sa2_palntCT">
					</label></td>
					<td class="tg-0lax" colspan="12"><label> <input
							type="text" style="width: 100%" class="tb_gbla1 input_type_serch"
							value="" name="sa2_date2" id="sa2_date2">
					</label></td>
				</tr>
				<tr>
					<td class="tg-0lax" colspan="24">전월 누적 송전 유효전력량[KWh]-전체</td>
					<td class="tg-0lax" colspan="6"><input
						type="text" style="width: 100%;
						class="tb_gbla1 input_type_serch" readonly="readonly" value=""
						name="sa2_meternum1" id="sa2_meternum1"></td>
					<td class="tg-0lax" colspan="9" style="background-color:#edde5a;"><label> <input
							type="text" style="width: 100%; background-color:#edde5a;" class="tb_gbla1 input_type_serch"
							oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							onkeyup="Divison(this.value)"
							onclick="jun()"
							name="sa2_meter1KWh" id="sa2_meter1KWh">
					</label></td>
					<!--     <td class="tg-0lax" colspan="9">　&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td> -->
				</tr>
				<tr class="border">
					<td class="tg-0lax" colspan="24" >현재 누적 송전 유효전력량[KWh]-전체</td>
					<td class="tg-0lax" colspan="6" ><input
						type="text" style="width: 100%;
						class="tb_gbla1 input_type_serch" readonly="readonly" value=""
						name="sa2_meternum2" id="sa2_meternum2"></td>
					<td class="tg-0lax" colspan="9" style="background-color:#edde5a;"><label> <input
							type="text" style="width: 100%; background-color:#edde5a;" class="tb_gbla1 input_type_serch"
							oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							onkeyup="Divison2(this.value)"
							onclick="jun()"
							name="sa2_meter2KWh" id="sa2_meter2KWh">
					</label></td>
					<!--     <td class="tg-0lax" colspan="9">　&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td> -->
				</tr>
				<tr>
					<td class="tg-0lax" colspan="12" style="background-color: #99CCFF">검침
						대상</td>
					<td class="tg-0lax" colspan="12" style="background-color: #99CCFF"><input
						type="text" style="width: 100%; background-color: #99CCFF"
						class="tb_gbla1 input_type_serch" readonly="readonly" value=""
						name="changenum" id="changenum"></td>
					<td class="tg-0lax" colspan="12" style="background-color: #99CCFF"><input
						type="text" style="width: 100%; background-color: #99CCFF"
						class="tb_gbla1 input_type_serch" readonly="readonly" value=""
						name="changenum2" id="changenum2"></td>
					<td class="tg-0lax" colspan="12" style="background-color: #99CCFF">인버터 데이터</td>
				</tr>
				<tr>
					<td class="tg-0lax" colspan="6" rowspan="2"
						style="background-color: #99CCFF">검침<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;주기
					</td>
					<td class="tg-0lax" colspan="6" style="background-color: #99CCFF">기간</td>
					<td class="tg-0lax" colspan="12"><label><input
							type="text" style="width: 100%" class="tb_gbla1 input_type_serch"
							name="sa2_meter1period" id="sa2_meter1period">
					</label></td>
					<td class="tg-0lax" colspan="12"><label> <input
							type="text" style="width: 100%" class="tb_gbla1 input_type_serch"	
							name="sa2_meter2period" id="sa2_meter2period">
					</label></td>
					<td class="tg-0lax" colspan="12"><label> <input
							type="text" style="width: 100%" class="tb_gbla1 input_type_serch"
							name="sa2_inverterperiod" id="sa2_inverterperiod">
					</label></td>
				</tr>
				<tr>
					<td class="tg-0lax" colspan="6" style="background-color: #99CCFF">일</td>
					<td class="tg-0lax" colspan="12"><label> <input
							type="text" style="width: 100%" class="tb_gbla1 input_type_serch"
							name="sa2_meter1date" id="sa2_meter1date">
					</label></td>
					<td class="tg-0lax" colspan="12"><label> <input
							type="text" style="width: 100%" class="tb_gbla1 input_type_serch"
							name="sa2_meter2date" id="sa2_meter2date">
					</label></td>
					<td class="tg-0lax" colspan="12"><label> <input
							type="text" style="width: 100%" class="tb_gbla1 input_type_serch"
							name="sa2_inverterdate" id="sa2_inverterdate">
					</label></td>
				</tr>
				<tr>
					<td class="tg-0lax" colspan="12" style="background-color: #99CCFF">총발전량[KWh]</td>
					<td class="tg-0lax" colspan="12"><label> <input
							type="text" style="width: 100%" class="tb_gbla1 input_type_serch"
							oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							name="sa2_meter1allKWh" id="sa2_meter1allKWh">
					</label></td>
					<td class="tg-0lax" colspan="12"><label> <input
							type="text" style="width: 100%" class="tb_gbla1 input_type_serch"
							oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							name="sa2_meter2allKWh" id="sa2_meter2allKWh">
					</label></td>
					<td class="tg-0lax" colspan="12"><label> <input
							type="text" style="width: 100%" class="tb_gbla1 input_type_serch"
							oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							name="sa2_inverterallKWh" id="sa2_inverterallKWh">
					</label></td>
				</tr>
				<tr>
					<td class="tg-0lax" colspan="12" style="background-color: #99CCFF">1일평균
						발전량<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[KWh/day]
					</td>
					<td class="tg-0lax" colspan="12"><label> <input
							type="text" style="width: 100%" class="tb_gbla1 input_type_serch"
							oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							name="sa2_meter1dayKWh" id="sa2_meter1dayKWh">
					</label></td>
					<td class="tg-0lax" colspan="12"><label> <input
							type="text" style="width: 100%" class="tb_gbla1 input_type_serch"
							oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							name="sa2_meter2dayKWh" id="sa2_meter2dayKWh">
					</label></td>
					<td class="tg-0lax" colspan="12"><label> <input
							type="text" style="width: 100%" class="tb_gbla1 input_type_serch"
							oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							name="sa2_inverterdayKWh" id="sa2_inverterdayKWh">
					</label></td>
				</tr>
				<tr class="border">
					<td class="tg-0lax" colspan="12" style="background-color: #99CCFF">1일평균
						발전시간<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[hour/day]
					</td>
					<td class="tg-0lax" colspan="12"><label> <input
							type="text" style="width: 100%" class="tb_gbla1 input_type_serch"
							oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							name="sa2_meter1dayhour" id="sa2_meter1dayhour">
					</label></td>
					<td class="tg-0lax" colspan="12"><label> <input
							type="text" style="width: 100%" class="tb_gbla1 input_type_serch"
							oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							name="sa2_meter2dayhour" id="sa2_meter2dayhour">
					</label></td>
					<td class="tg-0lax" colspan="12"><label> <input
							type="text" style="width: 100%" class="tb_gbla1 input_type_serch"
							oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							name="sa2_inverterdayhour" id="sa2_inverterdayhour">
					</label></td>
				</tr>
				</tbody>
				<tbody class="esco">
					<tr class="border" data-html2canvas-ignore="true">
					  	<td colspan="48">종합의견 부분 캡쳐<input type="checkbox" class="check" checked="checked"  onclick="checkboxEvent(this)"></td> 
					</tr> 
					<tr class="border">
						<td class="tg-0lax" colspan="48">※ 점검자 확인사항 <input
							type="file" id="inputImage">
							<button type="button" id="sendButton">등록</button>
						</td>
					</tr>
					<tr>
						<td class="tg-0lax" colspan="48"><img src=""
							class="uploadImage" id="sa2_image"></td>
					</tr>
					<tr>
						<td class="tg-0lax" colspan="48"><input type="text"
							style="width: 100%" class="tb_gbla1 input_type_serch"
							onclick="jun()"
							name="sa2_opinion" id="sa2_opinion"></td>
					</tr>
					<tr>
						<td class="tg-0lax" colspan="48">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td class="tg-0lax" colspan="48">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td class="tg-0lax" colspan="48">대양에스코 ㈜ TEL 061)332-8086 FAX
							&nbsp;&nbsp;&nbsp;070)4009-4586</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<div style="border: 0 solid black;">
		<div style="margin-top: 20px; margin-left: 400px;">
			<table style="border: 2px solid black;">
				<tr>
					<td style="border-right: 2px solid black;">발전소 이상유무 선택</td>
					<td style="width: 250px;"><label> <span>이상있음</span> <input
							type="radio" style="width: 10%;"
							margin-top: 5px;" name="sa2_problem" id="sa2_problem" value="1">
					</label> <label> <span>이상없음</span> <input type="radio"
							style="width: 10%;" margin-top: 5px;" name="sa2_problem"
							id="sa2_problem" value="2">
					</label></td>
				</tr>
			</table>
		</div>
		<div style="text-align: center;">
			<input type="hidden" id="buttionType" name="buttionType" value="insert"> 
			<input type="hidden" id="sa2_keyno" name="sa2_keyno" value=""> 
			<input type="hidden" id="sa2_inverternumtype" name="sa2_inverternumtype" value="${num }">
			<input type="hidden" id="sa_writetype" name="sa_writetype" value="2">
			<input type="hidden" id="SU_KEYNO" name="SU_KEYNO" value="">
			<input type="hidden" id="imgSrc" name="imgSrc" value="">
			<input type="hidden" id="predataMeter1" name="predataMeter1" value="">
			<input type="hidden" id="predataMeter2" name="predataMeter2" value="">
			<input type="hidden" id="prewatt" name="prewatt" value="">
			<button style="width: 150px; margin-top: 20px;" type="button"
				onclick="SendAlim()">알림 전송 후 저장</button>
			<button style="width: 100px; margin-top: 20px;" type="button"
				onclick="loadInfo()">저장</button>
			<button style="width: 100px; margin-top: 20px;" type="button" onclick="qwe()"> 초기화 </button>
		</div>
	</div>
	<div id="prepaper"></div>
</form:form>
<script type="text/javascript">
$(function() {
	
	inverterNumber()
	
});

function loadInfo(){
	
	 $.ajax({
        url: '/sfa/safe/safepaperInsert.do?${_csrf.parameterName}=${_csrf.token}',
        type: 'POST',
        data: $("#Form").serialize(),
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
	
	$.ajax({
        url: '/sfa/safe/safeuserselect.do?${_csrf.parameterName}=${_csrf.token}',
        type: 'POST',
        data: {
			SU_KEYNO : keyno
		},
        async: false,  
        success: function(result) {
        	console.log(result.SU_SA_SUJEONV);
        	$("#sa_sujeonv").val(result.SU_SA_SUJEONV)
        	$("#sa_sujeonkw").val(result.SU_SA_SUJEONKW)
        	$("#sa_balv").val(result.SU_SA_BALV)
        	$("#sa_balkw").val(result.SU_SA_BALKW)
        	$("#sa_solarv").val(result.SU_SA_SOLARV)
        	$("#sa_solarkw").val(result.SU_SA_SOLARKW)
        	$("#sa_transvolum").val(result.SU_SA_TRANSVOLUM)
        	$("#sa_admintype").val(result.SU_SA_ADMINTYPE)
        	$("#sa_admincount").val(result.SU_SA_ADMINCOUNT)
        },
        error: function(){
        	alert("저장 에러");
        }
	}); 
}

function print_p(){
	
    var initBody = document.body.innerHTML;
    window.onbeforeprint = function(){
        document.body.innerHTML = document.getElementById('field').innerHTML;
    }  
    window.onafterprint = function(){
        document.body.innerHTML = initBody;
    }
    window.print();
}

function popup(value){
	var left = Math.ceil((window.screen.width - 1000)/2);
	var top = Math.ceil((window.screen.height - 820)/2);
	var popOpen	= window.open("/sfa/safeAdmin/safeAdminUpdate.do?listtable="+value, "Taxpopup","width=1200px,height=900px,top="+top+",left="+left+",status=0,toolbar=0,menubar=0,location=false,scrollbars=yes");
	popOpen.focus();
}


function inverterNumber(){
	
	var num = Number($("#sa2_inverternumtype").val())
	
	
	
	var count = 1;

	//append 초기화
	$(".tgsfa0").remove();
	$(".tgsfa1").remove();
	$(".tgsfa2").remove();
	$(".tgsfa3").remove();
	$(".tgsfa4").remove();
	$(".tgsfa5").remove();
	$(".tgsfa6").remove();
	$(".tgsfa7").remove();
	$(".tgsfa8").remove();
	$(".tgsfa9").remove();

	
	if(num > 10){
		
		var annacc = "${list.sa2_annacc}";
		var preannacc = "${list.sa2_preannacc}";
		var peridev = "${list.sa2_peridev}";
		
		var annacclist = []
		var preannacclist = []
		var peridevlist = []

		if(annacc != null | preannacc != null | peridev != null){
			
			annacclist = annacc.split(",")	
			preannacclist = preannacc.split(",")	
			peridevlist = peridev.split(",")	
			
			for(var i = 0; i <= num-1; i++ ){
				if(annacclist[i] == ''){
					annacclist[i] = 0
				}else if(preannacclist[i] == ''){
					preannacclist[i] = 0
				}else if(peridevlist[i] == ''){
					peridevlist[i] = 0
				}else{
					annacclist[i] =  annacclist[i]
					preannacclist[i] =  preannacclist[i]
					peridevlist[i] =  peridevlist[i]
				}
			}
	    }
		
		
		
		$(".etcTr").hide();
		$(".hiddenTr").show();
		$("#inputplus0").html('<td class="tg-0lax" colspan="15" style="font-size:15px">인버터 번호</td>')
		$("#inputplus1").html('<td class="tg-0lax" colspan="15" style="text-align:center;">연간 현재 <br> 누적[KWh]</td>')
		$("#inputplus2").html('<td class="tg-0lax" colspan="15" style="text-align:center;">전회 누적[KWh]</td>')
		$("#inputplus3").html('<td class="tg-0lax" colspan="15" style="text-align:center;">기간 발전[KWh]</td>')
		$("#inputplus4").hide();
		$("#inputplus5").html('<td class="tg-0lax" colspan="15" style="font-size:15px">인버터 번호</td>')
		$("#inputplus6").html('<td class="tg-0lax" colspan="15" style="text-align:center;">연간 현재 <br> 누적[KWh]</td>')
		$("#inputplus7").html('<td class="tg-0lax" colspan="15" style="text-align:center;">전회 누적[KWh]</td>')
		$("#inputplus8").html('<td class="tg-0lax" colspan="15" style="text-align:center;">기간 발전[KWh]</td>')
		$("#inputplus9").hide();
		
		
		
   		for(var i=1; i<=num; i++){
   			
   			
   			if(count < 11){	
   				
   				var conutt = count + 1
   				$("#inputplus0").append('<td class="tgsfa0"><label id = "">'+count+'</label></td>')
    			$("#inputplus1").append('<td class="tgsfa1" style="background-color : #edde5a;"><label id = ""><input type="text" style="width: 70%; background-color : #edde5a; text-align:center;" class="tb_gbla1 input_type_serch" value='+annacclist[i-1]+' name="sa2_annacc"></label></td>')
    			$("#inputplus2").append('<td class="tgsfa2"><label id = ""><input type="text" style="width: 70%; text-align:center;" class="tb_gbla1 input_type_serch" value='+preannacclist[i-1]+' name="sa2_preannacc"></label></td>')
    			$("#inputplus3").append('<td class="tgsfa3"><label id = ""><input type="text" style="width: 70%; text-align:center;" class="tb_gbla1 input_type_serch" value='+peridevlist[i-1]+' name="sa2_peridev"></label></td>')	
       			
   			}else{
   				
   				var conutt = count - 9
   				$("#inputplus5").append('<td class="tgsfa5"><label id = "">'+count+'</label></td>')
    			$("#inputplus6").append('<td class="tgsfa6" style="background-color : #edde5a;"><label id = ""><input type="text" style="width: 70%; background-color : #edde5a; text-align:center;" class="tb_gbla1 input_type_serch" value='+annacclist[i-1]+' name="sa2_annacc"></label></td>')
    			$("#inputplus7").append('<td class="tgsfa7"><label id = ""><input type="text" style="width: 70%; text-align:center;" class="tb_gbla1 input_type_serch" value='+preannacclist[i-1]+' name="sa2_preannacc" ></label></td>')
    			$("#inputplus8").append('<td class="tgsfa8"><label id = ""><input type="text" style="width: 70%; text-align:center;" class="tb_gbla1 input_type_serch" value='+peridevlist[i-1]+' name="sa2_peridev"></label></td>')

   			}
   			count += 1;
   			
   		}
   		
   			
   		
   			
	}else{
		
		var nowpower = "${list.sa2_nowpower}";
		var todaypower = "${list.sa2_todaypower}";
		var accpower = "${list.sa2_accpower}";

		var nowpowerlist = []
		var todaypowerlist = []
		var accpowerlist = []

		if(nowpower != null | todaypower != null | accpower != null){
			
			nowpowerlist = nowpower.split(",")	
			todaypowerlist = todaypower.split(",")	
			accpowerlist = accpower.split(",")	
			
			for(var i = 0; i <= num-1; i++ ){
				if(nowpowerlist[i] == ''){
					nowpowerlist[i] = 0		
				}else if(todaypowerlist == ''){
					todaypowerlist[i] = 0									
				}else if(accpowerlist == ''){
					accpowerlist[i] = 0
				}else{
					nowpowerlist[i] =  nowpowerlist[i]		
					todaypowerlist[i] =  todaypowerlist[i]
					accpowerlist[i] =  accpowerlist[i]				
				}
			}
	    }
		
		var conutt = count + 1
		
		
		$(".hiddenTr").hide();
		$(".etcTr").show();
		$("#inputplus4").show();
		
		
    	$("#inputplus0").html('<td class="tg-0lax" colspan="">인버터 번호</td><td class="tg-0lax" style="text-align:center;"><label>1</label></td>');
		$("#inputplus1").html('<td class="tg-0lax" colspan="">현재 출력 <select id="sa2_nowpowertype" name="sa2_accpowertype"><option value="KWh">KWh</option><option value="MWh">MWh</option></select></td><td class="la2" ><label><input type="text" style="width: 40%" class="tb_gbla1 input_type_serch" value="" name="sa2_nowpower" id="sa2_nowpower"><input type="hidden" value="" name="sa2_nowpower1"></label></td>');
		$("#inputplus2").html('<td class="tg-0lax" colspan="">금일 발전량<select id="sa2_todaypowertype" name="sa2_accpowertype"><option value="KWh">KWh</option><option value="MWh">MWh</option></select></td><td class="la3" ><label> <input type="text" style="width: 40%" class="tb_gbla1 input_type_serch" value="" name="sa2_todaypower" id="sa2_todaypower"></label><input type="hidden" value="" name="sa2_todaypower1"></td>');
		$("#inputplus3").html('<td class="tg-0lax" colspan="">누적 발전량 <select id="sa2_accpowertype" name="sa2_accpowertype"><option value="KWh">KWh</option><option value="MWh">MWh</option></select></td><td class="la4" style="background-color : #edde5a;"><label> <input type="text" style="width: 40%; background-color : #edde5a;" class="tb_gbla1 input_type_serch" value="" name="sa2_accpower"><input type="hidden" value="" name="sa2_accpower1"></label></td>');
		$("#inputplus4").html('<td class="tg-0lax" colspan="">기간 발전량<select id="sa2_periodpowertype" name="sa2_periodpowertype"><option value="KWh">KWh</option><option value="MWh">MWh</option></select></td><td class="la5" ><label> <input type="text" style="width: 40%" class="tb_gbla1 input_type_serch"	name="sa2_periodpower"><input type="hidden" value="" id ="sa2_periodpower1" name="sa2_periodpower1"></label></td>');
		
	
		for(var i=1; i<=num-1; i++){	
			
			var conuttt = count + 2
			count += 1;
			$("#inputplus0").append('<td class="la1"><label id = "">'+count+'</label></td>')
			$("#inputplus1").append('<td class="la2"><label id = ""><input type="text" style="width: 40%" class="tb_gbla1 input_type_serch" value="" name="sa2_nowpower"><input type="hidden" value="" name="sa2_nowpower1"></label></td>')
			$("#inputplus2").append('<td class="la3"><label id = ""><input type="text" style="width: 40%" class="tb_gbla1 input_type_serch" value="" name="sa2_todaypower"><input type="hidden" value="" name="sa2_todaypower1"></label></td>')
			$("#inputplus3").append('<td class="la4" style="background-color : #edde5a;"><label id = ""><input type="text" style="width: 40%; background-color : #edde5a;" class="tb_gbla1 input_type_serch" value="" name="sa2_accpower"><input type="hidden" value="" name="sa2_accpower1"></label></td>')
			$("#inputplus4").append('<td class="la5"><label id = ""><input type="text" style="width: 40%;" class="tb_gbla1 input_type_serch" value="" name="sa2_periodpower"><input type="hidden" value="" name="sa2_periodpower1"></label></td>')	
       					       			
   		
   			}	
			
// 		$("#sa2_nowpower").val(result.preData.sa2_nowpower)
//     	$("#sa2_todaypower").val(result.preData.sa2_todaypower)
//     	$("#sa2_accpower").val(result.preData.sa2_accpower)
//     	$("#sa2_periodpower").val(result.preData.sa2_periodpower)
	}
	
}



</script>
