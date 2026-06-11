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
#esco{float: right;}
.border{
	border-bottom :2px solid black;
}
input[type="text"] { border:0 solid black; width:80%; height: 30px;  /* 높이 초기화 */line-height: normal;  /* line-height 초기화 */font-size: 20px;}

input:focus {outline:none;}
select{ height: 30px; }

</style>
<form:form id="Form" name="Form" method="post">
	<div style="text-align: center;" id="esco">
		<div>
			<input type="text" style="width: 5%; text-align: center;"
				class="tb_gbla1 input_type_serch" readonly="readonly"
				name="sa2_count" id="sa2_count">번 중 <input type="text"
				style="width: 5%; text-align: center;"
				class="tb_gbla1 input_type_serch" readonly="readonly"
				name="sa2_count2" id="sa2_count2">번 점검 <select
				style="margin-left: 50px;" class="form-control input-sm"
				name="su_keyno" id="su_keyno" onchange="changesulbi(this.value)">
				<option value="">선택하세요</option>
				<c:forEach items="${safeuserlist}" var="b">
					<option value="${b.SU_KEYNO}">${b.SU_SA_SULBI }</option>
				</c:forEach>
			</select> <select class="form-control input-sm" name="Year" id="Year"></select>
			<select class="form-control input-sm" name="Month" id="Month"
				onchange="datanumselect()"><option value="">선택하세요</option></select>
				 <select class="form-control input-sm" name="selectgroup" id="selectgroup"></select>
			<button id ="autoInsert" type="button" onclick="view()">조회</button>
		</div>
		<div style="margin-left: 300px; margin-top: 20px;">
			<table class="tg" style="width: 80%; border: 3px solid black;">
				<thead>
				  	<tr data-html2canvas-ignore="true">
					  	<th class="tg-0lax" colspan="100%" style="text-align: center;">양식 전체 캡쳐<input type="checkbox" id="allcheck"></th>
					</tr>
					<tr>
						<th class="tg-0lax" colspan="60" style="text-align: center;">
							<label> <input type="text"
								style="width: 20%; text-align: center;"
								class="tb_gbla1 input_type_serch" title="" name="sa2_title"
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
						
						
						
<!-- 						히든 tr -->

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
						type="text" style="width: 100%;"
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
						type="text" style="width: 100%;"
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
			<input type="hidden" id="sa2_inverternumtype" name="sa2_inverternumtype" value="">
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
	$(".hiddenTr").hide();
	///data-html2canvas-ignore="true
// 	if(localStorage.getItem("su_keyno") != null){	
		
// 		var sukey = localStorage.getItem("su_keyno");
		
// 		changesulbi(sukey)
// 	}
	

	// 키로 부터 데이터 읽기
// 	localStorage.getItem("key");

	// 키의 데이터 삭제
// 	localStorage.removeItem("key");

	// 모든 키의 데이터 삭제
// 	localStorage.clear();

	// 저장된 키/값 쌍의 개수
// 	localStorage.length;
	
	
	
	///data-html2canvas-ignore="true"(체크안된 div 캡쳐 안함)
	$(document).on('click','#allcheck',function(){
		if($('#allcheck').is(':checked')){
			$('.check').prop('checked',true);
			$('.esco').removeAttr('data-html2canvas-ignore');
		}else{     
			$('.check').prop('checked',false); 
			$('.esco').attr('data-html2canvas-ignore','true')
		} 
	});
	
	
	$(document).on('click','.check',function(){
	    if($('input[class=check]:checked').length==$('.check').length){  
			 $('#allcheck').prop('checked',true);    
		}else{       
			 $('#allcheck').prop('checked',false);     
		}
	});

	yearselect();
	monselect();
	
	
	//사진등록
  	  document.querySelector("#sendButton").addEventListener('click',()=>{

      let selectFile = document.querySelector("#inputImage").files[0];

      const file = URL.createObjectURL(selectFile);

      document.querySelector(".uploadImage").src = file;
      

    })
    
	/** 계량기 번호 변경 */
		var t = document.getElementById('sa2_meternum2');
		 
		t.addEventListener('change', function(event){
		 
		changetext(event.target.value);
      });
 		
//     window.setTimeout('loadInfo()',6000);

});

function checkboxEvent(obj){
	if($(obj).is(':checked')){
		$(obj).closest("tbody").removeAttr('data-html2canvas-ignore')
	}else{
		$(obj).closest("tbody").attr('data-html2canvas-ignore','true')
	}
}

function SendAlim(){
	
	var array = new Array(); 
	var target = $("#esco");
    var radioVal = $('input[name="sa2_problem"]:checked').val();
   	array.push(radioVal);
   	
   	if(!validationCheck()) return false
		if(array[0] == "1" || array[0] == "2"){
			if(confirm("저장 후 즉시 알림 전송하시겠습니까?")){
				
				localStorage.clear();
				

				if (target != null && target.length > 0) {
					
					var t = target[0];

					html2canvas(t).then(function(canvas) {
						var myImg = canvas.toDataURL("image/png");
						myImg = myImg.replace("data:image/png;base64,", "");
						
						
						$("#imgSrc").val(myImg);
 						$.ajax({
 							type : "POST",
 							data : $("#Form").serialize(),
 							dataType : "text",
 							url : "/sfa/Admin/sendAilmaAjax.do?${_csrf.parameterName}=${_csrf.token}",
 							success : function(data) {
 								alert(data);
 							},
 							error : function(a, b, c) {
 								alert("error");
 							}
 						});
					});
				}
			}else{
				
		 	}		
		}else{
			alert("발전소 이상유무를 선택해주세요");
		}
}
	
function loadInfo(){
	
	var array = new Array(); 
    var radioVal = $('input[name="sa2_problem"]:checked').val();
   	array.push(radioVal);
   	
   	if(!validationCheck()) return false
		if(array[0] == "1" || array[0] == "2"){
			if(confirm("저장하시겠습니까?")){
				
				localStorage.clear();
				
				 $.ajax({
			        url: '/sfa/safe/safepaper2Insert.do?${_csrf.parameterName}=${_csrf.token}',
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
		 	}else{
		 		
		 	}		
		}else{
			alert("발전소 이상유무를 선택해주세요");
		}
		
	
}

//연월 셋팅
function yearselect(){
	
	var dt = new Date();
	var comyear = dt.getFullYear();
	years = "";
		
// 	for(var i = (comyear-5); i <= (comyear); i++){
		years += $("#Year").append("<option value="+comyear+">"+comyear+"년"+"</option>");
// 	}
}

function monselect(){
	
	var dt = new Date();
	var commonth = dt.getMonth();
	
	month = "";
	for(var i = 1; i <= 12; i++){
		month += $("#Month").append("<option value="+i+">"+i+"월"+"</option>");
	}
}


function datanumselect(){
	
	var a = $("#su_keyno").val();
	var b = $("#Year").val();
	var c = $("#Month").val();
	
	//append 초기화
	$("#selectgroup").empty();
	
	
	if(a != ''){
		$.ajax({
	        url: '/sfa/sfaAdmin/previewAjax.do?${_csrf.parameterName}=${_csrf.token}',
	        type: 'POST',
	        data: $("#Form").serialize(),
	        async: false,  
	        success: function(data) {
	        
	        	if(data == null || data == ""){
	        		alert("해당 연월에 작성한 양식이 없습니다");
	        	}else{		
					for(var i=0; i<data.length; i++){
						$("#selectgroup").append("<option value = "+data[i].sa2_keyno+">"+data[i].datenum+"</option>"); // <option>값 넣어줌
				 }  		
		        	
		//         	if(data == "null"){        		
		//         		alert("해당 연월에 작성한 양식이 없습니다.")	
		//         	}else{
		// 	        	var left = Math.ceil((window.screen.width - 1000)/2);
		// 	        	var top = Math.ceil((window.screen.height - 820)/2);
		// 	        	var popOpen	= window.open("/sfa/sfaAdmin/preview.do?su_keyno="+a+"&Year="+b+"&Month="+c+"&type="+d, "Taxpopup","width=1200px,height=900px,top="+top+",left="+left+",status=0,toolbar=0,menubar=0,location=false,scrollbars=yes");
		// 	        	popOpen.focus();
		//         	}	
	        	}
	        	
	        },
	        error: function(){
	        	alert("월을 선택하세요");
	        }
		});
	}else{
		alert("발전소를 선택해주세요")
	}
	
}

//이전 양식 조회
function view(){
	
	$.ajax({
        url: '/sfa/sfaAdmin/previewplaceholder.do?${_csrf.parameterName}=${_csrf.token}',
        type: 'POST',
        data: $("#Form").serialize(),
        async: false,  
        success: function(data) {
        	
        	var num = Number($("#sa2_inverternumtype").val())
        	var count = 1;
        	
//         	$("#sa2_label0").html("<input type='text' style='width:100%; background-color: #99CCFF;' class='tb_gbla1 input_type_serch' readonly='readonly' value="+result2+" name='' id=''>")
//         	$("#sa2_label1").html("<input type='text' style='width:40%' class='tb_gbla1 input_type_serch' readonly='readonly' value="+data.sa2_nowpower+" name='sa2_nowpower3' id='sa2_nowpower3'>")
//         	$("#sa2_label2").html("<input type='text' style='width:40%' class='tb_gbla1 input_type_serch' readonly='readonly' value="+data.sa2_todaypower+" name='sa2_todaypower3' id='sa2_todaypower3'>")
//         	$("#sa2_label3").html("<input type='text' style='width:40%' class='tb_gbla1 input_type_serch' readonly='readonly' value="+data.sa2_accpower+" name='sa2_accpower3' id='sa2_accpower3'>")
//         	$("#sa2_label4").html("<input type='text' style='width:40%' class='tb_gbla1 input_type_serch' readonly='readonly' value="+data.sa2_periodpower+" name='sa2_periodpower3' id='sa2_periodpower3'>")
//         	$("#sa2_label5").html("<input type='text' style='width:100%' class='tb_gbla1 input_type_serch' value='' placeholder ="+data.sa2_ACVL1_N+" name='sa2_ACVL1_N' id='sa2_ACVL1_N'>")
//         	$("#sa2_label6").html("<input type='text' style='width:100%' class='tb_gbla1 input_type_serch' value='' placeholder ="+data.sa2_ACAL1+" name='sa2_ACAL1' id='sa2_ACAL1'>")
//         	$("#sa2_label7").html("<input type='text' style='width:100%' class='tb_gbla1 input_type_serch' value='' placeholder ="+data.sa2_ACVL2_N+" name='sa2_ACVL2_N' id='sa2_ACVL2_N'>")
//         	$("#sa2_label8").html("<input type='text' style='width:100%' class='tb_gbla1 input_type_serch' value='' placeholder ="+data.sa2_ACAL2+" name='sa2_ACAL2' id='sa2_ACAL2'>")
//         	$("#sa2_label9").html("<input type='text' style='width:100%' class='tb_gbla1 input_type_serch' value='' placeholder ="+data.sa2_ACVL3_N+" name='sa2_ACVL3_N' id='sa2_ACVL3_N'>")
//         	$("#sa2_label10").html("<input type='text' style='width:100%' class='tb_gbla1 input_type_serch' value='' placeholder ="+data.sa2_ACAL3+" name='sa2_ACAL3' id='sa2_ACAL3'>")
//         	$("#sa2_meternum1").val(data.sa2_meternum1)
//         	$("#sa2_meternum2").val(data.sa2_meternum2)
//         	$("#changenum").val(data.changenum)
//         	$("#changenum2").val(data.changenum2)
//         	$("#sa2_inverterperiod").val(data.sa2_inverterperiod)
//         	$("#sa2_inverterdate").val(data.sa2_inverterdate)
//          $("#predataMeter1").val(data.sa2_meter1KWh)
//          $("#predataMeter2").val(data.sa2_meter2KWh)
// 			console.log($("#predataMeter1").val());
// 			console.log($("#predataMeter2").val());

        	var nowpower = data.preData.sa2_nowpower
    		var todaypower = data.preData.sa2_todaypower
    		var accpower = data.preData.sa2_accpower
    		var periodpower = data.preData.sa2_periodpower

    		var nowpowerlist = []
    		var todaypowerlist = []
    		var accpowerlist = []
    		var periodpowerlist = []

    		if(nowpower != null | todaypower != null | accpower != null){
    			
    			nowpowerlist = nowpower.split(",")	
    			todaypowerlist = todaypower.split(",")	
    			accpowerlist = accpower.split(",")	
    			periodpowerlist = periodpower.split(",")	
    			
    			for(var i = 0; i <= num-1; i++ ){
    				if(accpowerlist[i] == ''){
						accpowerlist[i] = 0									
    				}else{
						accpowerlist[i] =  accpowerlist[i]			
    				}
    			}
    			
    			console.log(nowpowerlist)
    	    }
    		
    		
    		
        	$(".qwe1").remove();
			$(".qwe2").remove();
			$(".qwe3").remove();
			$(".qwe4").remove();
			
			$(".la2").append('<input type="text" style="width: 43px; color: gray; text-align: center;" class="qwe1" value=/'+nowpowerlist[0]+' name="qwe1" id="qwe1" readonly="readonly">')
  			$(".la3").append('<input type="text" style="width: 43px; color: gray; text-align: center;" class="qwe2" value=/'+todaypowerlist[0]+' name="qwe2" id="qwe1" readonly="readonly">')
  			$(".la4").append('<input type="text" style="width: 43px; color: gray; background-color : #edde5a; text-align: center;" class="qwe3" value=/'+accpowerlist[0]+' name="qwe3" id="qwe1" readonly="readonly">')
  			$(".la5").append('<input type="text" style="width: 43px; color: gray; text-align: center;" class="qwe4" value=/'+periodpowerlist[0]+' name="qwe4" id="qwe1" readonly="readonly">')
			
			for(var i = 0; i <= num-1; i++ ){
				
				//lanum을 다르게 해줘야 전회차정보 td어펜드시 인버터 번호에 맞는 정보가 들어감
				var lanum = count + 9;
				var lanum2 = count + 19;
				var lanum3 = count + 29;
				var lanum4 = count + 39;
				count += 1;
				
	  			$(".la"+lanum+"").append('<input type="text" style="width: 43px; color: gray; text-align: center;" class="qwe1" value=/'+nowpowerlist[i+1]+' name="qwe1" id="qwe1" readonly="readonly">')
	  			$(".la"+lanum2+"").append('<input type="text" style="width: 43px; color: gray; text-align: center;" class="qwe2" value=/'+todaypowerlist[i+1]+' name="qwe2" id="qwe1" readonly="readonly">')
	  			$(".la"+lanum3+"").append('<input type="text" style="width: 43px; color: gray; background-color : #edde5a; text-align: center;" class="qwe3" value=/'+accpowerlist[i+1]+' name="qwe3" id="qwe1" readonly="readonly">')
	  			$(".la"+lanum4+"").append('<input type="text" style="width: 43px; color: gray; text-align: center;" class="qwe4" value=/'+periodpowerlist[i+1]+' name="qwe4" id="qwe1" readonly="readonly">')
			
			}
//   			$(".la1").attr('colspan','2')
//   			
//   			$(".la2").append('<td>'+nowpowerlist[0]+'</td>')
//   			$(".la3").append('<td>'+todaypowerlist[0]+'</td>')
//   			$(".la4").append('<td >'+accpowerlist[0]+'</td>')
//   			$(".la5").append('<td>'+periodpowerlist[0]+'</td>')
  						       			
       		
			
        },
        error: function(){
        	alert("발전소,월,일을 선택해주세요");
        }
	}); 
	
// 	$.ajax({
//         url: '/sfa/sfaAdmin/prepaperview.do?${_csrf.parameterName}=${_csrf.token}',
//         type: 'POST',
//         data: $("#Form").serialize(),
//         async: false,  
//         success: function(data) {
        	
//         	$("#prepaper").html(data)
        	
//         },
//         error: function(){
//         	alert("저장 에러");
//         }
// 	}); 
	
}

function changesulbi(keyno) {
	
	$("#SU_KEYNO").val(keyno);
	$("#Month").val("");
	$("#selectgroup").empty();
	

	var date = new Date();
	var now = date.getMonth()+1+"/"+date.getDate();
	var premonth = date.getMonth();
	
	
	$.ajax({
        url: '/sfa/safe/safeuserselect.do',
        type: 'POST',
        data: {
			SU_KEYNO : keyno
		},
        async: false,  
        success: function(result) {

        	alert("1233")
        	
        	var predate = result.predate.predate.substring(0,5);
        	var premonth2 = result.data.SU_SA_ADMINDATE;
        	var lastday = Number(result.lastday);
        	var diff = Number(result.datediff.diff);
        	
        	
        	$("#sa2_count2").val(result.count.count)
        	$("#sa2_count").val(result.data.SU_SA_RG)
        	$("#sa2_title").val(result.data.SU_SA_SULBI)
        	$("#sa2_palntKW").val(result.data.SU_SA_VOLUM)
        	$("#sa2_palntV").val(result.data.SU_SA_VOLT)
        	$("#sa2_palntCT").val(result.data.SU_SA_CT)
        	$("#sa2_date2").val(premonth2)
        	$("#sa2_inverternumtype").val(result.data.SU_SA_INVERTERNUM)
			$("#sa2_meternum1").val(result.data.SU_SA_METER1)
        	$("#sa2_meternum2").val(result.data.SU_SA_METER2)
        	$("#changenum").val(result.data.SU_SA_METER1)
        	$("#changenum2").val(result.data.SU_SA_METER2)
        	$("#sa2_inverterperiod").val(predate+"~"+now)
        	$("#sa2_inverterdate").val(result.datediff.diff)
        	$("#sa2_meter1period").val(premonth+"월 검침일 : "+ premonth2+"일")
        	$("#sa2_meter2period").val(predate+"~"+now)
        	$("#sa2_meter1date").val(lastday)
        	$("#sa2_meter2date").val(diff)
        	$("#prewatt").val(result.prewatt)
        	
        	
        	
        	if(result.preData == null | result.preData == ""){
        		$("#sa2_meter1KWh").val(0);
        		$("#predataMeter1").val(0);
        		$("#predataMeter2").val(0);
        	}else{
        		$("#sa2_meter1KWh").val(result.preData.sa2_meter1KWh)
        		$("#predataMeter1").val(result.preData.sa2_meter1KWh)
        		$("#predataMeter2").val(result.preData.sa2_meter2KWh)
        	}
        	
        	
        	
        	
        	//인버터 대수에 따른 <td> append
         	var num = Number($("#sa2_inverternumtype").val())
         	console.log(num);
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
        		
        		var annacc = result.preData.sa2_annacc
        		var preannacc = result.preData.sa2_preannacc
        		var peridev = result.preData.sa2_peridev
        		
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
        				}else{
        					annacclist[i] =  annacclist[i]				
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
		    			$("#inputplus1").append('<td class="tgsfa1" style="background-color : #edde5a;"><label id = ""><input type="text" style="width: 70%; background-color : #edde5a; text-align:center;" class="tb_gbla1 input_type_serch" value="" name="sa2_annacc"  onkeyup="method_1(\'inputplus1\',\'inputplus2\',\'inputplus3\',\''+conutt+'\');"  ></label></td>')
		    			$("#inputplus2").append('<td class="tgsfa2"><label id = ""><input type="text" style="width: 70%; text-align:center;" class="tb_gbla1 input_type_serch" value='+annacclist[i-1]+' name="sa2_preannacc" oninput="inputNumberFormat(this)"></label></td>')
		    			$("#inputplus3").append('<td class="tgsfa3"><label id = ""><input type="text" style="width: 70%; text-align:center;" class="tb_gbla1 input_type_serch" value="" name="sa2_peridev" oninput="inputNumberFormat(this)"></label></td>')	
		       			
	       			}else{
	       				
	       				var conutt = count - 9
	       				$("#inputplus5").append('<td class="tgsfa5"><label id = "">'+count+'</label></td>')
		    			$("#inputplus6").append('<td class="tgsfa6" style="background-color : #edde5a;"><label id = ""><input type="text" style="width: 70%; background-color : #edde5a; text-align:center;" class="tb_gbla1 input_type_serch" value="" name="sa2_annacc" onkeyup="method_1(\'inputplus6\',\'inputplus7\',\'inputplus8\',\''+conutt+'\'); inputNumberFormat(this)" ></label></td>')
		    			$("#inputplus7").append('<td class="tgsfa7"><label id = ""><input type="text" style="width: 70%; text-align:center;" class="tb_gbla1 input_type_serch" value='+annacclist[i-1]+' name="sa2_preannacc" oninput="inputNumberFormat(this)"></label></td>')
		    			$("#inputplus8").append('<td class="tgsfa8"><label id = ""><input type="text" style="width: 70%; text-align:center;" class="tb_gbla1 input_type_serch" value="" name="sa2_peridev" oninput="inputNumberFormat(this)"></label></td>')
	
	       			}
	       			count += 1;
	       			
	       		}
	       		
	       		console.log($("input[name=sa2_peridev]").val());	
	       			
	       		
	       			
        	}else{
        		
        		var nowpower = result.preData.sa2_nowpower
        		var todaypower = result.preData.sa2_todaypower
        		var accpower = result.preData.sa2_accpower

        		var nowpowerlist = []
        		var todaypowerlist = []
        		var accpowerlist = []

        		if(nowpower != null | todaypower != null | accpower != null){
        			
        			nowpowerlist = nowpower.split(",")	
        			todaypowerlist = todaypower.split(",")	
        			accpowerlist = accpower.split(",")	
        			
        			for(var i = 0; i <= num-1; i++ ){
        				if(accpowerlist[i] == ''){
        					accpowerlist[i] = 0    					
        				}else{
        					accpowerlist[i] =  accpowerlist[i]				
        				}
        			}
        	    }
        		
        		var conutt = count + 1
        		console.log(accpowerlist)
        		
        		$(".hiddenTr").hide();
        		$(".etcTr").show();
        		$("#inputplus4").show();
        		
        		
	        	$("#inputplus0").html('<td class="tg-0lax" colspan="">인버터 번호</td><td class="tg-0lax" style="text-align:center;"><label>1</label></td>');
				$("#inputplus1").html('<td class="tg-0lax" colspan="">현재 출력 <select id="sa2_nowpowertype" name="sa2_nowpowertype"><option value="KWh">KWh</option><option value="MWh">MWh</option></select></td><td class="la2" ><label><input type="text" style="width: 40%" class="tb_gbla1 input_type_serch" value="" name="sa2_nowpower" id="sa2_nowpower"><input type="hidden" value="" name="sa2_nowpower1"></label></td>');
				$("#inputplus2").html('<td class="tg-0lax" colspan="">금일 발전량<select id="sa2_todaypowertype" name="sa2_todaypowertype"><option value="KWh">KWh</option><option value="MWh">MWh</option></select></td><td class="la3" ><label> <input type="text" style="width: 40%" class="tb_gbla1 input_type_serch" value="" name="sa2_todaypower" id="sa2_todaypower"></label><input type="hidden" value="" name="sa2_todaypower1"></td>');
				$("#inputplus3").html('<td class="tg-0lax" colspan="">누적 발전량 <select id="sa2_accpowertype" name="sa2_accpowertype"><option value="KWh">KWh</option><option value="MWh">MWh</option></select></td><td class="la4" style="background-color : #edde5a;"><label> <input type="text" style="width: 40%; background-color : #edde5a;" class="tb_gbla1 input_type_serch" value="" name="sa2_accpower" onkeyup="method_2(\'inputplus3\',\'inputplus4\',\''+conutt+'\');" ><input type="hidden" value='+accpowerlist[0]+' name="sa2_accpower1"></label></td>');
				$("#inputplus4").html('<td class="tg-0lax" colspan="">기간 발전량<select id="sa2_periodpowertype" name="sa2_periodpowertype"><option value="KWh">KWh</option><option value="MWh">MWh</option></select></td><td class="la5" ><label> <input type="text" style="width: 40%" class="tb_gbla1 input_type_serch"	name="sa2_periodpower"><input type="hidden" value="" id ="sa2_periodpower1" name="sa2_periodpower1"></label></td>');
				
			
        		for(var i=1; i<=num-1; i++){	
        			
        			//lanum을 다르게 해줘야 전회차정보 td어펜드시 인버터 번호에 맞는 정보가 들어감
        			var lanum = count + 9;
        			var lanum2 = count + 19;
    				var lanum3 = count + 29;
    				var lanum4 = count + 39;
        			var conuttt = count + 2
        			count += 1;
	   				$("#inputplus0").append('<td class="la1"><label id = "">'+count+'</label></td>')
	    			$("#inputplus1").append('<td class="la'+lanum+'"><label id = ""><input type="text" style="width: 40%" class="tb_gbla1 input_type_serch" value="" name="sa2_nowpower"><input type="hidden" value="" name="sa2_nowpower1"></label></td>')
	    			$("#inputplus2").append('<td class="la'+lanum2+'"><label id = ""><input type="text" style="width: 40%" class="tb_gbla1 input_type_serch" value="" name="sa2_todaypower"><input type="hidden" value="" name="sa2_todaypower1"></label></td>')
	    			$("#inputplus3").append('<td class="la'+lanum3+'" style="background-color : #edde5a;"><label id = ""><input type="text" style="width: 40%; background-color : #edde5a;" class="tb_gbla1 input_type_serch" value="" name="sa2_accpower" onkeyup="method_2(\'inputplus3\',\'inputplus4\',\''+conuttt+'\')" ><input type="hidden" value='+accpowerlist[i]+' name="sa2_accpower1"></label></td>')
	    			$("#inputplus4").append('<td class="la'+lanum4+'"><label id = ""><input type="text" style="width: 40%;" class="tb_gbla1 input_type_serch" value="" name="sa2_periodpower"><input type="hidden" value="" name="sa2_periodpower1"></label></td>')	
		       					       			
	       		
	       			}	
        			
//         		$("#sa2_nowpower").val(result.preData.sa2_nowpower)
//             	$("#sa2_todaypower").val(result.preData.sa2_todaypower)
//             	$("#sa2_accpower").val(result.preData.sa2_accpower)
//             	$("#sa2_periodpower").val(result.preData.sa2_periodpower)
        	}
        	
        	
        	
        	//division 함수 데이터처리(Division의 인수 값 넣어줌)
        	var meter1KWh = $("#sa2_meter1KWh").val()
        		
        	Divison(meter1KWh);
        	Divison3();
        },
        error: function(){
        	console.log("error");
        }
	}); 
}

function validationCheck(){
	
	if($("#sa2_title").val() == ''){
		alert("발전소를 선택해주세요");
		return false
	}
	
	return true
}


// function changenumber(value){
	
// 	if(value == 4){
		
// 		$("#sa2_meternum2").html("<select id='sa2_meternum2' name='sa2_meternum2'><option value='7'>계량기#7</option>")
// 		$("#changenum").val("계량기#4")
// 		$("#changenum2").val("계량기#7")
		
// 	}else if(value == 5){
		
// 		$("#sa2_meternum2").html("<select id='sa2_meternum2' name='sa2_meternum2'><option value='3'>계량기#3</option><option value='9'>계량기#9</option></select>")
// 		$("#changenum").val("계량기#5")
// 		$("#changenum2").val("계량기#3")
		
		
// 	}
	
// }



function changetext(value){
	
	
	if(value == 3){

		$("#changenum2").val("계량기#3")
		
	}else if(value == 9){

		$("#changenum2").val("계량기#9")
		
	}
	
}


function Divison(obj){

	var ctb = $("#sa2_palntCT").val()
	var day = $("#sa2_meter1date").val()
	var vol = $("#sa2_palntKW").val()
	//전월 마지막 점검데이터의 전월 누적 송전 유효 전력량
	var prev = $("#prewatt").val()
	
	
	if(day == 0){
		day = 1
	}else{
		day = $("#sa2_meter1date").val()
	}
	
	if(prev == null| prev == ''){
		prev = 0;
	}else{
		prev = $("#prewatt").val()
	}
	
	
	var ctb1 = Number(ctb);
	var day1 = Number(day);
	var vol1 = Number(vol);
	var obj1 = Number.parseFloat(obj);
	var prev1 = Number.parseFloat(prev);
	
	var num = (obj1-prev1)*ctb1
	var num2 = num/day1
	var num3 = num2/vol1

	
	$("#sa2_meter1allKWh").val(num.toFixed(3))
	$("#sa2_meter1dayKWh").val(num2.toFixed(3))
	$("#sa2_meter1dayhour").val(num3.toFixed(3))
	
}

function Divison2(obj){

	var ctb = $("#sa2_palntCT").val()
	var day = $("#sa2_meter2date").val()
	var vol = $("#sa2_palntKW").val()
	//전회차 현재 누적 송전 유효전력량
	var prev = $("#predataMeter2").val()
	
	
	if(day == 0){
		day = 1
	}else{
		day = $("#sa2_meter2date").val()
	}
	
	if(prev == null| prev == ''){
		prev = 0;
	}else{
		prev = $("#predataMeter2").val()
	}
	
	
	var ctb1 = Number(ctb);
	var day1 = Number(day);
	var vol1 = Number(vol);
	var obj1 = Number(obj);
	var prev1 = Number(prev);
	
	var num = (obj1-prev1)*ctb1
	var num2 = num/day1
	var num3 = num2/vol1
	
	$("#sa2_meter2allKWh").val(num.toFixed(3))
	$("#sa2_meter2dayKWh").val(num2.toFixed(3))
	$("#sa2_meter2dayhour").val(num3.toFixed(3))
}

function Divison3(){

	var v = $("#sa2_palntCT").val()
	var vv = $("#sa2_inverterdate").val()
	var vvv = $("#sa2_palntKW").val()
	var v2 = $("#sa2_periodpower").val()
	
	
	if(vv == 0){
		vv = 1
	}else{
		vv = $("#sa2_inverterdate").val()
	}
	
	var v1 = Number(v);
	var vv1 = Number(vv);
	var vvv1 = Number(vvv);
	
	
	
	var num = v2*1000
	var num2 = num/vv1
	var num3 = num2/vvv1
	
	$("#sa2_inverterallKWh").val(num.toFixed(3))
	$("#sa2_inverterdayKWh").val(num2.toFixed(3))
	$("#sa2_inverterdayhour").val(num3.toFixed(3))

	
}

function jun(){
	
	
	//로컬스토리지
	localStorage.setItem("su_keyno", String($("#su_keyno").val()));
	localStorage.setItem("sa2_count", String($("#sa2_count").val()));
	localStorage.setItem("sa2_count2", String($("#sa2_count2").val()));
	localStorage.setItem("sa2_keyno", String($("#sa2_keyno").val()));
	localStorage.setItem("sa2_title", String($("#sa2_title").val()));
	localStorage.setItem("sa2_wether", String($("#sa2_wether").val()));
	localStorage.setItem("sa2_adminname", String($("#sa2_adminname").val()));
	localStorage.setItem("sa2_inverternumtype", String($("#sa2_inverternumtype").val()));
// 	localStorage.setItem("sa2_nowpower", String($("#sa2_nowpower").val()));
// 	localStorage.setItem("sa2_todaypower", String($("#sa2_todaypower").val()));
// 	localStorage.setItem("sa2_accpower", String($("#sa2_accpower").val()));
// 	localStorage.setItem("sa2_periodpower", String($("#sa2_periodpower").val()));
	localStorage.setItem("sa2_ACVL1_N", String($("#sa2_ACVL1_N").val()));
	localStorage.setItem("sa2_ACVL2_N", String($("#sa2_ACVL2_N").val()));
	localStorage.setItem("sa2_ACVL3_N", String($("#sa2_ACVL3_N").val()));
	localStorage.setItem("sa2_ACAL1", String($("#sa2_ACAL1").val()));
	localStorage.setItem("sa2_ACAL2", String($("#sa2_ACAL2").val()));
	localStorage.setItem("sa2_ACAL3", String($("#sa2_ACAL3").val()));
	localStorage.setItem("sa2_ACBV", String($("#sa2_ACBV").val()));
	localStorage.setItem("sa2_ACBA", String($("#sa2_ACBA").val()));
	localStorage.setItem("sa2_VCBKV", String($("#sa2_VCBKV").val()));
	localStorage.setItem("sa2_VCBA", String($("#sa2_VCBA").val()));
	localStorage.setItem("sa2_palntKW", String($("#sa2_palntKW").val()));
	localStorage.setItem("sa2_palntV", String($("#sa2_palntV").val()));
	localStorage.setItem("sa2_palntCT", String($("#sa2_palntCT").val()));
	localStorage.setItem("sa2_date2", String($("#sa2_date2").val()));
	localStorage.setItem("sa2_meternum1", String($("#sa2_meternum1").val()));
	localStorage.setItem("sa2_meternum2", String($("#sa2_meternum2").val()));
	localStorage.setItem("sa2_meter1KWh", String($("#sa2_meter1KWh").val()));
	localStorage.setItem("sa2_meter2KWh", String($("#sa2_meter2KWh").val()));
	localStorage.setItem("sa2_meter1period", String($("#sa2_meter1period").val()));
	localStorage.setItem("sa2_meter2period", String($("#sa2_meter2period").val()));
	localStorage.setItem("sa2_inverterperiod", String($("#sa2_inverterperiod").val()));
	localStorage.setItem("sa2_meter1date", String($("#sa2_meter1date").val()));
	localStorage.setItem("sa2_meter2date", String($("#sa2_meter2date").val()));
	localStorage.setItem("sa2_inverterdate", String($("#sa2_inverterdate").val()));
	localStorage.setItem("sa2_meter1allKWh", String($("#sa2_meter1allKWh").val()));
	localStorage.setItem("sa2_meter2allKWh", String($("#sa2_meter2allKWh").val()));
	localStorage.setItem("sa2_inverterallKWh", String($("#sa2_inverterallKWh").val()));
	localStorage.setItem("sa2_meter1dayKWh", String($("#sa2_meter1dayKWh").val()));
	localStorage.setItem("sa2_meter2dayKWh", String($("#sa2_meter2dayKWh").val()));
	localStorage.setItem("sa2_inverterdayKWh", String($("#sa2_inverterdayKWh").val()));
	localStorage.setItem("sa2_meter1dayhour", String($("#sa2_meter1dayhour").val()));
	localStorage.setItem("sa2_meter2dayhour", String($("#sa2_meter2dayhour").val()));
	localStorage.setItem("sa2_inverterdayhour", String($("#sa2_inverterdayhour").val()));
	localStorage.setItem("sa2_opinion", String($("#sa2_opinion").val()));
// 	localStorage.setItem("sa2_problem", String($("#sa2_problem").val()));
	localStorage.setItem("sa2_annacc", JSON.stringify($("input[name=sa2_annacc]").val()));
	localStorage.setItem("sa2_preannacc", String($("input[name=sa2_preannacc]").val()));
	localStorage.setItem("sa2_peridev", String($("input[name=sa2_peridev]").val()));
	
	
// 	localStorage.setItem("sa2_annacc"+d+", $("#"+ a +">  td:nth-child("+  d + ") > label > input").val());
// 	 $("#"+ b +">  td:nth-child("+  d + ") > label > input").val();
// 	 $("#"+ c +">  td:nth-child("+  d + ") > label > input").val(comma(aa-bb));	

}

function qwe() {
	
	localStorage.clear()
	alert("초기화 되었습니다")
	location.reload()
}

var list = [];


function method_1(a,b,c,d){
	
	var aa = $("#"+ a +">  td:nth-child("+  d + ") > label > input").val();
	var bb = $("#"+ b +">  td:nth-child("+  d + ") > label > input").val();
	
	if(bb == null | bb == ''){
		bb = 0;
	}
	
	$("#"+ c +">  td:nth-child("+  d + ") > label > input").val(aa-bb);	
	
	var sum = 0;
		
	list[d-2] = aa-bb;
	console.log(list)
		
	for(var i=0;i<list.length;i++){
		sum += list[i]
	}
	$("#sa2_inverterallKWh").val(sum.toFixed(3));
	
	
	
	var vv = $("#sa2_inverterdate").val()
	var vvv = $("#sa2_palntKW").val()
	
	if(vv == 0){
		vv = 1
	}else{
		vv = $("#sa2_inverterdate").val()
	}
	
	var v1 = Number(sum)
	var vv1 = Number(vv)
	var vvv1 = Number(vvv)
	
	var num2 = v1/vv1
	var num3 = num2/vvv1

	$("#sa2_inverterdayKWh").val(num2.toFixed(3))
	$("#sa2_inverterdayhour").val(num3.toFixed(3))
	
}

function method_2(a,b,c){
	
	var aa = $("#"+ a +" > td:nth-child("+ c +") > label > input.tb_gbla1.input_type_serch").val();
	var bb = $("#"+ a +" > td:nth-child("+ c +") > label > input[type=hidden]:nth-child(2)").val();

	$("#"+ b +" > td:nth-child("+ c +") > input").val(aa-bb);
	
	console.log(list);
	
	var sum = 0;
	
	list[c-2] = aa-bb;
	
	for(var i=0;i<list.length;i++){
		sum += list[i]
	}
	
	$("#sa2_inverterallKWh").val(sum.toFixed(3))
	
	
	var vv = $("#sa2_inverterdate").val()
	var vvv = $("#sa2_palntKW").val()
	
	if(vv == 0){
		vv = 1
	}else{
		vv = $("#sa2_inverterdate").val()
	}
	
	var v1 = Number(sum)
	var vv1 = Number(vv)
	var vvv1 = Number(vvv)
	
	var num2 = v1/vv1
	var num3 = num2/vvv1

	$("#sa2_inverterdayKWh").val(num2.toFixed(3))
	$("#sa2_inverterdayhour").val(num3.toFixed(3))
	
}


function inputNumberFormat(obj) {
    obj.value = comma(uncomma(obj.value));
}

function comma(str) {
    str = String(str);

    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}

function uncomma(str) {
    str = String(str);
    return str.replace(/[^\d]+/g, '');
}

function asdf(){
	
	$("#lal1").remove();
	$("#lal2").remove();
	$("#lal3").remove();
	$("#lal4").remove();
	
}



</script>