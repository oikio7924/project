<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script src="/resources/common/js/html2canvas.js"></script>
<style>
#poppop > h1, h4{text-align: center; margin-top: 0px;}
.sa_admin{border:0px solid black;}
.sa_admin_input2 {border:2px solid black;}
.sa_admin3{border:1px solid black; font-size: 1em; height: 40px;}
.sa_admin_input3 {border:1px solid black; text-align: right; height: 40px;}
.sa_admin_text{text-align: right;}
.sa_admin_input4 {border:1px solid black; height: 40px; text-align: center;}
.sa_admin_input5 {border:1px solid black; height: 40px; text-align: center;}
.sa_admin6{border:1px solid black; height: 40px; text-align: center;}
.sa_admin_text56{border-bottom:1px solid black; border-left:1px solid black; border-right:1px solid black; height: 41px;}
.sa_admin8 {border:1px solid black; height: 40px; text-align: center;}
.sa_admin_input8 {border:1px solid black; height: 40px; text-align: center;}
fieldset {border:0 solid black;}

input{ border:0 solid black; width:80%;}
input:focus {outline:none;}
.tb_gbla{border-top: 2px solid #f77573; }
.tb_gbla_input{border-top: 2px solid #f77573;}
.tb_gbla{border-right: 2px solid #f77573; background-color: #fff6f7; }
.tb_gbla_input{border-right: 2px solid #f77573;}
.tb_gbla2{border-top: 2px solid #5b9adf; background-color: #f7f7ff; }
.tb_gbla2_input{border-top: 2px solid #5b9adf;}
.tb_gbla2{border-right: 2px solid #5b9adf; }
.tb_gbla2_input{border-right: 2px solid #5b9adf ;}
.tb_gbla3{border-right: 1px solid #5b9adf; border-bottom: 1px solid #5b9adf; background-color: #f7f7ff; }
.tb_gbla3_2{border-right: 1px solid #5b9adf; border-bottom: 3px solid #5b9adf; }
.tb_gbla4{border-right: 1px solid #5b9adf; border-bottom: 1px solid #5b9adf; background-color: #f7f7ff; }
.tb_gbla4_2{border-right: 1px solid #5b9adf; border-bottom: 1px solid #5b9adf; }
.tb_gbla4_3{border-right: 1px solid #5b9adf; border-bottom: 3px solid #5b9adf; }
.tb_gbla5{border-right: 1px solid #5b9adf; border-bottom: 1px solid #5b9adf; background-color: #f7f7ff; }
.tb_gbla5_2{border-right: 1px solid #5b9adf; }
.tb_gbla10 {border-bottom: 1px solid #5b9adf; background-color: #f7f7ff;}
.tb_gbla10_10 {border-bottom: 1px solid #5b9adf;}
.tb_gbla10_11 {border-bottom: 3px solid #5b9adf;}
.tb_taxdetail{  
    border-right: 3px solid #5b9adf;
    border-left: 3px solid #5b9adf;}
}
#poppop {display: table-cell;  vertical-align: middle; }
.btn_s {
    height: 24px;
    line-height: 22px;
    padding: 0 10px;
}
a{ text-decoration: none;}
.navy {
    background: #384c67;
    border: 0;
    color: #fff;
}
a[class^="btn_"] {
    display: inline-block;
    text-align: center;
    box-sizing: border-box;
    vertical-align: middle;
    font-size: 12px;
}
</style>
<div id="poppop">
<h1>전기 설비 점검결과 기록표</h1>
<h4>(전기안전관리자용)</h4>
<fieldset>
<div>
<table style="width: 30%">
<tr>
<div>	
	<select class="form-control input-sm" name="su_keyno" id="su_keyno" onchange="changesulbi(this.value);">
	       		<option>선택하세요</option>
	       	<c:forEach items="${safeuserlist}" var="b">
				<option value="${b.SU_KEYNO }">${b.SU_SA_SULBI }</option>
			</c:forEach>						                
	</select>
	<select class="form-control input-sm" name="Year" id="Year"></select>
	<select class="form-control input-sm" name="Month" id="Month"></select>
	<button type="button" onclick="view()">조회</button>
</div>
<th style="width:20%; " class="sa_admin">설비명(상호) : </th>
<td style="width:30%" class="sa_admin_input">
<input type="text" style="width:95%;" class="tb_gbla1 input_type_serch" maxlength="20" title="종사업장번호"  name="sa_sulbi" id="sa_sulbi">
</td>
</tr>
</table>

<table style="width: 30%; float: left;">
<tr>
<th style="width:20%; " class="sa_admin">점 검 일 자 : </th>
<td style="width:30%" class="sa_admin_input">
<label style="float: left;">
<input type="text" style="width:95%;" class="tb_gbla1 input_type_serch" maxlength="20" title="종사업장번호" value="${now }" name="sa_date" id="sa_date">
</label>
<!-- <label> -->
<!-- <input type="text" style="width:95%;" class="tb_gbla1 input_type_serch" maxlength="2" title="종사업장번호"  name="sa_date" id="sa_date">월 -->
<!-- </label> -->
<!-- <label> -->
<!-- <input type="text" style="width:95%;" class="tb_gbla1 input_type_serch" maxlength="2" title="종사업장번호"  name="sa_date" id="sa_date">일 -->
<!-- </label > -->
</td>
</tr>
</table>
<table style=" border-collapse:collapse; float: right; width: 20%;" >
		<colgroup>
				<col width="5%">
				<col width="15%">
				<col width="15%">
				<col width="15%">
		</colgroup>
		<tbody>
			<tr>
				<th rowspan="2" style="font-weight: 700; width:5%; border:2px solid #000000;">결<br>재</th>
				<td style="width:5%" class="sa_admin_input2">
				<label>
					<input type="text" style="width:80% " class="tb_gbla1 input_type_serch"  title="등록번호" name="sa_gyuljae1" id="sa_gyuljae1" >
				</label>
				</td>
				<td style="width:6%" class="sa_admin_input2">
				<label>
					<input type="text" style="width:80% " class="tb_gbla1 input_type_serch"  title="등록번호" name="sa_gyuljae2" id="sa_gyuljae2" >
				</label>
				</td>
				<td style="width:6%" class="sa_admin_input2">
				<label>
					<input type="text" style="width:80% " class="tb_gbla1 input_type_serch"  title="등록번호" name="sa_gyuljae3" id="sa_gyuljae3" >
				</label>
				</td>
			</tr>
			<tr>
				<td style="width:5%; height: 60px;" class="sa_admin_input2">
				<label>
					<input type="text" style="width:5% " class="tb_gbla1 input_type_serch"  title="등록번호" name="" id="" >
				</label>
				</td>
				<td style="width:6%; height: 60px;" class="sa_admin_input2">
				<label>
					<input type="text" style="width:5% " class="tb_gbla1 input_type_serch"  title="등록번호" name="" id="" >
				</label>
				</td>
				<td style="width:6%; height: 60px;" class="sa_admin_input2">
				<label>
					<input type="text" style="width:5% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="" id="" >
				</label>
				</td>	
			</tr>
		</tbody>
</table>
</div>
</fieldset>
<strong style="font-weight: 700px; margin-top: 10px;">1. 기본사항</strong>
<div style="width: 100%">
	 <table style=" border-collapse:collapse; border:2px solid black; width: 100%;" class="table table-striped table-bordered table-hover dataTable no-footer"> 				 
				 <colgroup>
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
				 </colgroup>
				 
                  <tbody>
				
					 <tr>
						<th  class="sa_admin3">수전전압/용량</th>
						<td  class="sa_admin_input3">
							<label>
								<input type="text" style="width:83% " class="sa_admin_text" maxlength="10" title="등록번호"  name="sa_sujeonv" id="sa_sujeonv" >
							</label>
						</td>
						<td  class="sa_admin_input3">
							<label>
								<input type="text" style="width:83% " class="sa_admin_text" maxlength="10" title="등록번호"  name="sa_sujeonkw" id="sa_sujeonkw" >
							</label>
						</td>
						<th  class="sa_admin3">발전전압/용량</th>
						<td  class="sa_admin_input3" >
							<label>
								<input type="text" style="width:95% " class="sa_admin_text" maxlength="10" title="종사업장번호"  name="sa_balv" id="sa_balv" >
							</label>
						</td>
						<td  class="sa_admin_input3" >
							<label>
								<input type="text" style="width:95% " class="sa_admin_text" maxlength="10" title="종사업장번호"  name="sa_balkw" id="sa_balkw" >
							</label>
						</td>
						<th  class="sa_admin3">태 양 광</th>
						<td  class="sa_admin_input3" >
						  <label style="text-align: left; padding-left: 6px;">
								<input type="text" style="width:75% " class="sa_admin_text" maxlength="10" title="등록번호" name="sa_solarv" id="sa_solarv"  >
						  </label>
						</td>
						<td  class="sa_admin_input3" >
						  <label style="text-align: left; padding-left: 6px;">
								<input type="text" style="width:75% " class="sa_admin_text" maxlength="10" title="등록번호" name="sa_solarkw" id="sa_solarkw"  >
						  </label>
						</td>
					 </tr>
					 <tr>
						<th  class="sa_admin3">계약용량</th>
						<td class="sa_admin_input3" colspan="2">
						  <label>
						 		<input type="text" style="width:80%" class="sa_admin_text" title="상호(법인명)" name="sa_transvolum" id="sa_transvolum"  >
						 </label>
						</td>
						<th style="" class="sa_admin3">점 검 종 별</th>
						<td class="sa_admin_input3" colspan="2">
						  <label>
						 		<input type="text" style="width:80%" class="sa_admin_text" title="상호(법인명)" name="sa_admintype" id="sa_admintype"  >
						 </label>
						</td> </label>
						</td>
						<th class="sa_admin3">점 검 횟 수</th>
						<td class="sa_admin_input3" colspan="2">
						  <label>
						 		<input type="text" style="width:80%" class="sa_admin_text" title="상호(법인명)" name="sa_admincount" id="sa_admincount"  >
						 </label>
						</td>
					 </tr>
				 </tbody>
              </table>
            <strong style="font-weight: 700px;">2. 점검내역</strong>  
              
              <div class="tb_taxdetail0"> <!--작성일자부분-->
		 <table style="border-collapse:collapse; border:2px solid black; width:100%;">
		<colgroup>
				<col width="6%">
				<col width="5%">
				<col width="5%">
				<col width="5%">
				<col width="5%">
				<col width="5%">
				<col width="5%">
				<col width="5%">
				<col width="5%">
				<col width="5%">
				<col width="5%">
				<col width="5%">
				<col width="5%">
				<col width="5%">
				<col width="5%">

		</colgroup>
		<tbody>
			<tr>
				<th rowspan="2" style="font-weight: 700; border:2px solid #000000;">특 고<br>(고압)<br>설 비</th>
				<td style="width:5%" class="sa_admin_input4">
				가  공<br>전선로
				</td>
				<td style="width:5%" class="sa_admin_input4">
				지  중<br>전선로
				</td>
				<td style="width:5%" class="sa_admin_input4">
				수배전용<br>개폐기
				</td>
				<td style="width:5%" class="sa_admin_input4">
				배  선<br>(모 선)
				</td>
				<td style="width:5%" class="sa_admin_input4">
				피  뢰  기
				</td>
				<td style="width:5%" class="sa_admin_input4">
				변  성  기
				</td>
				<td style="width:5%" class="sa_admin_input4">
				전  력<br>퓨  즈
				</td>
				<td style="width:5%" class="sa_admin_input4">
				변  압  기
				</td>
				<td style="width:5%" class="sa_admin_input4">
				수  배<br>전  반
				</td>
				<td style="width:5%" class="sa_admin_input4">
				계  전<br>기  류
				</td>
				<td style="width:5%" class="sa_admin_input4">
				차  단<br>기  류
				</td>
				<td style="width:5%" class="sa_admin_input4">
				전 력 용<br>콘 덴 서
				</td>
				<td style="width:5%" class="sa_admin_input4">
				보  호<br>설  비
				</td>
				<td style="width:5%" class="sa_admin_input4">
				부  하<br>설  비
				</td>
				<td style="width:5%" class="sa_admin_input4">
				접  지<br>설  비
				</td>
			</tr>
			<tr>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck1" id="sa_admincheck1">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck2" id="sa_admincheck2">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck3" id="sa_admincheck3">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck4" id="sa_admincheck4">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck5" id="sa_admincheck5">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck6" id="sa_admincheck6">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck7" id="sa_admincheck7">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck8" id="sa_admincheck8">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck9" id="sa_admincheck9">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck10" id="sa_admincheck10">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck11" id="sa_admincheck11">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck12" id="sa_admincheck12">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck13" id="sa_admincheck13">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck14" id="sa_admincheck14">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck15" id="sa_admincheck15">
				</label>
				</td>
			</tr>
			<tr>
				<th rowspan="2" style="font-weight: 700; border:2px solid #000000;">저 압<br>설 비</th>
								<td style="width:5%" class="sa_admin_input4">
				인 입 구<br>배  선
				</td>
				<td style="width:5%" class="sa_admin_input4">
				배 *<br>분 전 반
				</td>
				<td style="width:5%" class="sa_admin_input4">
				배 선 용<br>차 단 기
				</td>
				<td style="width:5%" class="sa_admin_input4">
				누  전<br>차 단 기
				</td>
				<td style="width:5%" class="sa_admin_input4">
				개  폐  기
				</td>
				<td style="width:5%" class="sa_admin_input4">
				배   선
				</td>
				<td style="width:5%" class="sa_admin_input4">
				전  동  기
				</td>
				<td style="width:5%" class="sa_admin_input4">
				전  열<br>설  비
				</td>
				<td style="width:5%" class="sa_admin_input4">
				용  접  기
				</td>
				<td style="width:5%" class="sa_admin_input4">
				콘  덴  서
				</td>
				<td style="width:5%" class="sa_admin_input4">
				조  명<br>설  비
				</td>
				<td style="width:5%" class="sa_admin_input4">
				접  지<br>설  비
				</td>
				<td style="width:5%" class="sa_admin_input4">
				구  내<br>전 선 로
				</td>
				<td style="width:5%" class="sa_admin_input4">
				기  타<br>설  비
				</td>
				<td style="width:5%" class="sa_admin_input4">
				발  전<br>설  비
				</td>
			</tr>
			<tr>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck16" id="sa_admincheck16">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck17" id="sa_admincheck17">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck18" id="sa_admincheck18">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck19" id="sa_admincheck19">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck20" id="sa_admincheck20">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck21" id="sa_admincheck21">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck22" id="sa_admincheck22">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck23" id="sa_admincheck23">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck24" id="sa_admincheck24">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck25" id="sa_admincheck25">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck26" id="sa_admincheck26">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck27" id="sa_admincheck27">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck28" id="sa_admincheck28">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck29" id="sa_admincheck29">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_admincheck30" id="sa_admincheck30">
				</label>
				</td>
			</tr>
		</tbody>
</table>
  </div>
  </div>
  
  
<p>점검결과는 세가지로</p>

<div>
  <div class="tb_taxdetail1">
	  <table id="tab_tax_subitem" style="border-collapse:collapse; border:2px solid black; width:100%;">			 
		 <colgroup>
				<col width="5%">
				<col width="5%">
				<col width="5%">
				<col width="5%">
				<col width="5%">
				<col width="5%">
				<col width="5%">
				<col width="5%">
				<col width="5%">
				<col width="5%">
				<col width="5%">
				<col width="5%">
		 </colgroup>
		  <tbody class="rowlist">	
		         <tr>
				<td class="sa_admin_input5" colspan="2" style="font-weight: 700;">구 분</td>
				<td style="width:5%" class="sa_admin_input5">
				전 압<br>(V)
				</td>
				<td style="width:5%" class="sa_admin_input5">
				전 류<br>(A)
				</td>
				<td style="width:5%" class="sa_admin_input5">
				온 도<br>(C)
				</td>
				<td class="sa_admin_input5" colspan="2" style="font-weight: 700;">구 분</td>
				<td style="width:5%" class="sa_admin_input5">
				전 압<br>(V)
				</td>
				<td style="width:5%" class="sa_admin_input5">
				전 류<br>(A)
				</td>
				<td style="width:5%" class="sa_admin_input5">
				온 도<br>(C)
				</td>
				<td class="sa_admin_input5" colspan="2" style="font-weight: 700;">구 분</td>
				<td style="width:5%" class="sa_admin_input5">
				전 압<br>(V)
				</td>
				<td style="width:5%" class="sa_admin_input5">
				전 류<br>(A)
				</td>
				<td style="width:5%" class="sa_admin_input5">
				온 도<br>(C)
				</td>
			</tr>
			<tr>
				<td rowspan="4" style="width:5%" class="sa_admin_input5">
				측<br>정<br>개<br>소
				</td>
				<td style="width:5%" class="sa_admin_input5">
				A -
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureAV1" id="sa_measureAV1" >
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureAA1" id="sa_measureAA1" >
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureAC1" id="sa_measureAC1" >
				</label>
				</td>
				<td rowspan="4" style="width:5%" class="sa_admin_input5">
				측<br>정<br>개<br>소
				</td>
				<td style="width:5%" class="sa_admin_input5">
				A -
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureAV2" id="sa_measureAV2" >
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureAA2" id="sa_measureAA2" >
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureAC2" id="sa_measureAC2" >
				</label>
				</td><td rowspan="4" style="width:5%" class="sa_admin_input5">
				측<br>정<br>개<br>소
				</td>
				<td style="width:5%" class="sa_admin_input5">
				A -
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureAV3" id="sa_measureAV3" >
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureAA3" id="sa_measureAA3" >
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureAC3" id="sa_measureAC3" >
				</label>
				</td>
			</tr>
			<tr>
			<td style="width:5%" class="sa_admin_input5">
				B -
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureBV1" id="sa_measureBV1" >
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureBA1" id="sa_measureBA1" >
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureBC1" id="sa_measureBC1" >
				</label>
				</td><td style="width:5%" class="sa_admin_input5">
				B -
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureBV2" id="sa_measureBV2" >
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureBA2" id="sa_measureBA2" >
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureBC2" id="sa_measureBC2" >
				</label>
				</td><td style="width:5%" class="sa_admin_input5">
				B -
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureBV3" id="sa_measureBV3" >
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureBA3" id="sa_measureBA3">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureBC3" id="sa_measureBC3" >
				</label>
				</td>
			</tr>
						<tr>
			<td style="width:5%" class="sa_admin_input5">
				C -
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureCV1" id="sa_measureCV1" >
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureCA1" id="sa_measureCA1" >
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureCC1" id="sa_measureCC1" >
				</label>
				</td><td style="width:5%" class="sa_admin_input5">
				C -
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureCV2" id="sa_measureCV2" >
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureCA2" id="sa_measureCA2" >
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureCC2" id="sa_measureCC2" >
				</label>
				</td><td style="width:5%" class="sa_admin_input5">
				C -
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureCV3" id="sa_measureCV3" >
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureCA3" id="sa_measureCA3" >
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureCC3" id="sa_measureCC3" >
				</label>
				</td>
			</tr>
						<tr>
			<td style="width:5%" class="sa_admin_input5">
				N -
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureNV1" id="sa_measureNV1" >
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureNA1" id="sa_measureNA1" >
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureNC1" id="sa_measureNC1" >
				</label>
				</td><td style="width:5%" class="sa_admin_input5">
				N -
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureNV2" id="sa_measureNV2" >
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureNA2" id="sa_measureNA2" >
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureNC2" id="sa_measureNC2" >
				</label>
				</td><td style="width:5%" class="sa_admin_input5">
				N -
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureNV3" id="sa_measureNV3" >
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureNA3" id="sa_measureNA3" >
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch"  title="등록번호"  name="sa_measureNC3" id="sa_measureNC3" >
				</label>
				</td>
			</tr>
		 </tbody>
	  </table>
  </div>
  <strong>3. 안전교육 및 종합의견</strong>
  <div class="tb_taxdetail2">
		<table style=" border-collapse:collapse; border:2px solid black; width: 100%;" class="table table-striped table-bordered table-hover dataTable no-footer"> 				 
				 <colgroup>
					<col width="5%">
					<col width="95%">
				 </colgroup>
				 
                  <tbody>				
					 <tr>
						<th rowspan="7" class="sa_admin6">전<br>기<br>안<br>전<br>교<br>육</th>
						<td rowspan="7" class="sa_admin_input6">
							 1. 물기에 젖은 손발일 경우 전기기계 기구류의 조작을 금하십시오.<br>
							 2. 각 기기의 접지선 탈락 여부를 수시로 확인하여 전기감전 사고를 예방하십시오.<br>
							 3. 전기담당자 외 임의로 전기기기 조작이나 보수를 금하십시오.<br>
							 4. 금속제 외함을 갖는 전기기계, 기구 등에는 반드시 누전 차단기로 보호하여 주십시오.<br>
							 5. 일과 종료 후 사용하지 않는 전원 차단기는 개방하십시오.<br>
							 6. 수/변전실 충립문에 잠금장치를 하고 전기 담당자 이외 출입을 금하도록 하십시오.<br>
							 7. 전기설비의 개/보수 작업은 반드시 정전상태에서 시행하시기 바랍니다.
						</td>
					 </tr>
				 </tbody>
              </table>
              <table style=" border-collapse:collapse; border:2px solid black; width: 100%;" class="table table-striped table-bordered table-hover dataTable no-footer"> 				 
				 <colgroup>
					<col width="5%">
					<col width="95%">
				 </colgroup>				 
                  <tbody>				
					 <tr>
						<th rowspan="6" class="sa_admin7">종<br><br>합<br><br>의<br><br>견</th>
						<td rowspan="6" class="sa_admin_input7">
								<label>
								<input type="text" style="width:99.7%; height: 400px; " class="sa_admin_text56"  title="등록번호"  name="sa_opinion" id="sa_opinion" >
								</label>
<!-- 								<label> -->
<!-- 								<input type="text" style="width:99.7% " class="sa_admin_text2"  title="등록번호"  name="ir_companyno" id="ir_companyno" > -->
<!-- 								</label> -->
<!-- 								<label> -->
<!-- 								<input type="text" style="width:99.7% " class="sa_admin_text2"  title="등록번호"  name="ir_companyno" id="ir_companyno" > -->
<!-- 								</label> -->
<!-- 								<label> -->
<!-- 								<input type="text" style="width:99.7% " class="sa_admin_text2"  title="등록번호"  name="ir_companyno" id="ir_companyno" > -->
<!-- 								</label> -->
<!-- 								<label> -->
<!-- 								<input type="text" style="width:99.7%" class="sa_admin_text2"  title="등록번호"  name="ir_companyno" id="ir_companyno" > -->
<!-- 								</label> -->
<!-- 								<label> -->
<!-- 								<input type="text" style="width:99.7%; border-bottom: none; " class="sa_admin_text2"  title="등록번호"  name="ir_companyno" id="ir_companyno" > -->
<!-- 								</label> -->
						</td>
					 </tr>
				 </tbody>
              </table>
  </div>
  <div class="tb_taxdetail3" style="margin-top: 5px;">
  <table style=" border-collapse:collapse; border:2px solid black; width: 50%;" class="table table-striped table-bordered table-hover dataTable no-footer">
  		<colgroup>
			<col width="10%">
			<col width="30%">
			<col width="35%">
			<col width="25%">
		 </colgroup>
		  <tbody>				
				<tr>
					<th rowspan="2" class="sa_admin8">확<br>인</th>
					<td class="sa_admin_input8">
					점검입회자
					</td>
					<td class="sa_admin_input8">
						<label>
						<input type="text" style="width:95% " class="sa_admin_text3"  title="등록번호"  name="sa_ceoname" id="sa_ceoname" >
						</label>
					</td>
					<td class="sa_admin_input8">
					서명
					</td>
				</tr>
				<tr>
					<td class="sa_admin_input8">
					안전관리자
					</td>
					<td class="sa_admin_input8">
						<label>
						<input type="text" style="width:95% " class="sa_admin_text3"  title="등록번호"  name="sa_adminname" id="sa_adminname" >
						</label>
					</td>
					<td class="sa_admin_input8">
					서명
					</td>				
				 </tr>
			</tbody>
				<label style="float: right; width: 50%;">
						<input type="text" style="width:100%; height: 60px; text-align: center; vertical-align: middle; font-size: 30px;" class="sa_admin_text3"  title="등록번호" value='"전기사고 예방으로 인명과 재산을 보호하자"' name="ir_companyno" id="ir_companyno" >
				</label>
  </table>
</div>
<div style="text-align: center; margin-top: 10px;">
<strong style="text-align: center;">부적합 전기설비를 방치하면 감전, 전기화재 및 정전, 전력손실 등의 원인이 될 수 있으니 조속히 개수하시기 바랍니다.</strong>
</div>
<div style="text-align: center; margin-top: 30px;">
<strong style="text-align: center; font-size: 30px">대양에스코(주)</strong>
</div>
<div style="text-align: right;">
<strong>전화 061-332-8086<br>팩스 070-4009-4586</strong>
</div>
</div>
</div>
<div style="text-align: center;" id = "buttondiv1">
<input type="hidden" id="buttionType" name="buttionType" value="insert"> 
<input type="hidden" id="sa_keyno" name="sa_keyno">
<input type="hidden" id="sa_writetype" name="sa_writetype" value="1">
<input type="hidden" id="SU_KEYNO" name="SU_KEYNO" value="">
<input type="hidden" id="imgSrc" name="imgSrc" value="">
<button style="width: 100px;" type="button" onclick="loadInfo()"> 저장 </button>
</div>
<script type="text/javascript">

$(function() {
	yearselect();
	monselect();
});


function loadInfo(){
	
	var target = $("#poppop");
	
	if(confirm("저장 후 즉시 전송하시겠습니까? 취소를 누르면 저장만 됩니다.")){
		
		if (target != null && target.length > 0) {
			var t = target[0];
			console.log(t);
			html2canvas(t).then(function(canvas) {
				var myImg = canvas.toDataURL("image/png");
				myImg = myImg.replace("data:image/png;base64,", "");
				
				$("#imgSrc").val(myImg);
				$.ajax({
					type : "POST",
					data : $("#Form").serialize(),
					dataType : "text",
					url : "/sfa/Admin/sendAilmaAjax.do",
					success : function(data) {
						console.log(data);
						alert("전송이 완료되었습니다.");
					},
					error : function(a, b, c) {
						alert("error");
					}
				});
			});
		}
	}else{
		
		 $.ajax({
	        url: '/sfa/safe/safepaperInsert.do',
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
}

function changesulbi(keyno) {
	
	$("#SU_KEYNO").val(keyno);
	
	$.ajax({
        url: '/sfa/safe/safeuserselect.do',
        type: 'POST',
        data: {
			SU_KEYNO : keyno
		},
        async: false,  
        success: function(result) {

        	
        	$("#sa_sulbi").val(result.SU_SA_SULBI)
        	$("#sa_sujeonv").val(result.SU_SA_SUJEONV)
        	$("#sa_sujeonkw").val(result.SU_SA_SUJEONKW)
        	$("#sa_balv").val(result.SU_SA_BALV)
        	$("#sa_balkw").val(result.SU_SA_BALKW)
        	$("#sa_solarv").val(result.SU_SA_SOLARV)
        	$("#sa_solarkw").val(result.SU_SA_SOLARKW)
        	$("#sa_transvolum").val(result.SU_SA_TRANSVOLUM)
        	$("#sa_admintype").val(result.SU_SA_ADMINTYPE)
        	$("#sa_admincount").val(result.SU_SA_ADMINCOUNT)
        	
        	var date = result.Conn_date;
//         	var year = date.substr(0,4);
        	console.log(date);
//         	var month = result.Conn_date.substr(5,7);
//         	 $("#Year").html("<option value'"result.Conn_date"'>"+i+"년"+"</option>");
        },
        error: function(){
        	alert("저장 에러");
        }
	}); 
}

//연월 셋팅
function yearselect(){
	
	var dt = new Date();
	var comyear = dt.getFullYear();
	
	years = "";
	for(var i = (comyear-5); i <= (comyear); i++){
		years += $("#Year").append("<option value="+i+">"+i+"년"+"</option>");
	}
}

function monselect(){
	
	var dt = new Date();
	var commonth = dt.getMonth();
	
	month = "";
	for(var i = 1; i <= 12; i++){
		month += $("#Month").append("<option value="+i+">"+i+"월"+"</option>");
	}
}

function view(){
	
	var a = $("#su_keyno").val();
	var b = $("#Year").val();
	var c = $("#Month").val();
	var d = $("#sa_writetype").val();
	
	$.ajax({
        url: '/sfa/sfaAdmin/previewAjax.do',
        type: 'POST',
        data: $("#Form").serialize(),
        async: false,  
        success: function(data) {
        	
        	if(data == "null"){        		
        		alert("해당 연월에 작성한 양식이 없습니다.")	
        	}else{
	        	var left = Math.ceil((window.screen.width - 1000)/2);
	        	var top = Math.ceil((window.screen.height - 820)/2);
	        	var popOpen	= window.open("/sfa/sfaAdmin/preview.do?su_keyno="+a+"&Year="+b+"&Month="+c+"&type="+d, "Taxpopup","width=1200px,height=900px,top="+top+",left="+left+",status=0,toolbar=0,menubar=0,location=false,scrollbars=yes");
	        	popOpen.focus();
        	}
        },
        error: function(){
        	alert("저장 에러");
        }
	}); 
	
}
</script>
