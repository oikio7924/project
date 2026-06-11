<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

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
<form:form id="Form" name = "Form" action="" method="post">
<fieldset style="margin-top : 5%;">
<div class="box_wrap sel_btn" style="float: left;">			
					<div style="display: inline-block;float:left">
						<span style="btn_wrap">				 								
							<a href="#" class="btn_s navy" style="min-width:100px;" onclick="print_p()">PRINT</a>														
							<a href="#" class="btn_s navy" style="min-width:100px;" onclick="popup('${list.sa_keyno}')">수정페이지 이동</a>														
						</span>
					</div>
			</div>
</fieldset>
<fieldset id= "field" style="margin-top : 5%;">
<div id="poppop">
<input type="hidden" id="sa_writetype" name="sa_writetype" value="1">
<h1>전기 설비 점검결과 기록표</h1>
<h4>(전기안전관리자용)</h4>
<fieldset>
<div>
<table style="width: 30%">
<tr>
<th style="width:20%; " class="sa_admin">설비명(상호) : </th>
<td style="width:30%" class="sa_admin_input">
<!-- <div>	 -->
<!-- 	<select class="form-control input-sm" name="sa_sulbi" id="sa_sulbi" onchange="changesulbi(this.value);"> -->
<!-- 	       		<option>선택하세요</option> -->
<%-- 	       	<c:forEach items="${safeuserlist}" var="b"> --%>
<%-- 				<option value="${b.SU_KEYNO }">${b.SU_SA_SULBI }</option> --%>
<%-- 			</c:forEach>						                 --%>
<!-- 	</select> -->
<!-- </div> -->
<label style="float: left;">
<input type="text" style="width:95%;" class="tb_gbla1 input_type_serch" maxlength="20" title="종사업장번호" value="${list.sa_sulbi }" name="sa_sulbi" id="sa_sulbi" readonly="readonly">
</label>
</td>
</tr>
</table>

<table style="width: 30%; float: left;">
<tr>
<th style="width:20%; " class="sa_admin">점 검 일 자 : </th>
<td style="width:30%" class="sa_admin_input">
<label style="float: left;">
<input type="text" style="width:95%;" class="tb_gbla1 input_type_serch" maxlength="20" title="종사업장번호" value="${list.sa_date }" name="sa_date" id="sa_date" readonly="readonly">
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
					<input type="text" style="width:80% " class="tb_gbla1 input_type_serch"  value="${list.sa_gyuljae1 }" title="등록번호" name="sa_gyuljae1" id="sa_gyuljae1" readonly="readonly">
				</label>
				</td>
				<td style="width:6%" class="sa_admin_input2">
				<label>
					<input type="text" style="width:80% " class="tb_gbla1 input_type_serch"  value="${list.sa_gyuljae2 }" title="등록번호" name="sa_gyuljae2" id="sa_gyuljae2" readonly="readonly">
				</label>
				</td>
				<td style="width:6%" class="sa_admin_input2">
				<label>
					<input type="text" style="width:80% " class="tb_gbla1 input_type_serch"  value="${list.sa_gyuljae3 }" title="등록번호" name="sa_gyuljae3" id="sa_gyuljae3" readonly="readonly">
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
								<input type="text" style="width:83% " class="sa_admin_text" value="${list.sa_sujeonv }" maxlength="10" title="등록번호"  name="sa_sujeonv" id="sa_sujeonv" readonly="readonly">
							</label>
						</td>
						<td  class="sa_admin_input3">
							<label>
								<input type="text" style="width:83% " class="sa_admin_text" value="${list.sa_sujeonkw }" maxlength="10" title="등록번호"  name="sa_sujeonkw" id="sa_sujeonkw" readonly="readonly">
							</label>
						</td>
						<th  class="sa_admin3">발전전압/용량</th>
						<td  class="sa_admin_input3" >
							<label>
								<input type="text" style="width:95% " class="sa_admin_text"  value="${list.sa_balv }" maxlength="10" title="종사업장번호"  name="sa_balv" id="sa_balv" readonly="readonly">
							</label>
						</td>
						<td  class="sa_admin_input3" >
							<label>
								<input type="text" style="width:95% " class="sa_admin_text" value="${list.sa_balkw }" maxlength="10" title="종사업장번호"  name="sa_balkw" id="sa_balkw" readonly="readonly">
							</label>
						</td>
						<th  class="sa_admin3">태 양 광</th>
						<td  class="sa_admin_input3" >
						  <label style="text-align: left; padding-left: 6px;">
								<input type="text" style="width:75% " class="sa_admin_text" value="${list.sa_solarv }" maxlength="10" title="등록번호" name="sa_solarv" id="sa_solarv"  readonly="readonly">
						  </label>
						</td>
						<td  class="sa_admin_input3" >
						  <label style="text-align: left; padding-left: 6px;">
								<input type="text" style="width:75% " class="sa_admin_text" value="${list.sa_solarkw }" maxlength="10" title="등록번호" name="sa_solarkw" id="sa_solarkw"  readonly="readonly">
						  </label>
						</td>
					 </tr>
					 <tr>
						<th  class="sa_admin3">계약용량</th>
						<td class="sa_admin_input3" colspan="2">
						  <label>
						 		<input type="text" style="width:80%" class="sa_admin_text" value="${list.sa_transvolum }" title="상호(법인명)" name="sa_transvolum" id="sa_transvolum"  readonly="readonly">
						 </label>
						</td>
						<th style="" class="sa_admin3">점 검 종 별</th>
						<td class="sa_admin_input3" colspan="2">
						  <label>
						 		<input type="text" style="width:80%" class="sa_admin_text" value="${list.sa_admintype }" title="상호(법인명)" name="sa_admintype" id="sa_admintype"  readonly="readonly">
						 </label>
						</td> </label>
						</td>
						<th class="sa_admin3">점 검 횟 수</th>
						<td class="sa_admin_input3" colspan="2">
						  <label>
						 		<input type="text" style="width:80%" class="sa_admin_text" value="${list.sa_admincount }"  title="상호(법인명)" name="sa_admincount" id="sa_admincount"  readonly="readonly">
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
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck1 }" title="등록번호"  name="sa_admincheck1" id="sa_admincheck1" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck2 }" title="등록번호"  name="sa_admincheck2" id="sa_admincheck2" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck3 }" title="등록번호"  name="sa_admincheck3" id="sa_admincheck3" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck4 }" title="등록번호"  name="sa_admincheck4" id="sa_admincheck4" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck5 }" title="등록번호"  name="sa_admincheck5" id="sa_admincheck5" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck6 }" title="등록번호"  name="sa_admincheck6" id="sa_admincheck6" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck7 }" title="등록번호"  name="sa_admincheck7" id="sa_admincheck7" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck8 }" title="등록번호"  name="sa_admincheck8" id="sa_admincheck8" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck9 }" title="등록번호"  name="sa_admincheck9" id="sa_admincheck9" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck10 }" title="등록번호"  name="sa_admincheck10" id="sa_admincheck10" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck11 }" title="등록번호"  name="sa_admincheck11" id="sa_admincheck11" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck12 }" title="등록번호"  name="sa_admincheck12" id="sa_admincheck12" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck13 }" title="등록번호"  name="sa_admincheck13" id="sa_admincheck13" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck14 }" title="등록번호"  name="sa_admincheck14" id="sa_admincheck14" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck15 }" title="등록번호"  name="sa_admincheck15" id="sa_admincheck15" readonly="readonly">
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
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch"  value="${list.sa_admincheck16 }" title="등록번호"  name="sa_admincheck16" id="sa_admincheck16" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck17 }" title="등록번호"  name="sa_admincheck17" id="sa_admincheck17" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck18 }" title="등록번호"  name="sa_admincheck18" id="sa_admincheck18" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck19 }" title="등록번호"  name="sa_admincheck19" id="sa_admincheck19" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck20 }" title="등록번호"  name="sa_admincheck20" id="sa_admincheck20" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck21 }" title="등록번호"  name="sa_admincheck21" id="sa_admincheck21" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck22 }" title="등록번호"  name="sa_admincheck22" id="sa_admincheck22" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck23 }" title="등록번호"  name="sa_admincheck23" id="sa_admincheck23" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck24 }" title="등록번호"  name="sa_admincheck24" id="sa_admincheck24" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck25 }" title="등록번호"  name="sa_admincheck25" id="sa_admincheck25" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck26 }" title="등록번호"  name="sa_admincheck26" id="sa_admincheck26" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck27 }" title="등록번호"  name="sa_admincheck27" id="sa_admincheck27" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck28 }" title="등록번호"  name="sa_admincheck28" id="sa_admincheck28" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck29 }" title="등록번호"  name="sa_admincheck29" id="sa_admincheck29" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input4">
				<label>
					<input type="checkbox" style="width:100% " class="tb_gbla1 input_type_serch" value="${list.sa_admincheck30 }" title="등록번호"  name="sa_admincheck30" id="sa_admincheck30" readonly="readonly">
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
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureAV1 }" title="등록번호"  name="sa_measureAV1" id="sa_measureAV1" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureAA1 }" title="등록번호"  name="sa_measureAA1" id="sa_measureAA1" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureAC1 }" title="등록번호"  name="sa_measureAC1" id="sa_measureAC1" readonly="readonly">
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
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureAV2 }" title="등록번호"  name="sa_measureAV2" id="sa_measureAV2" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureAA2 }" title="등록번호"  name="sa_measureAA2" id="sa_measureAA2" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureAC2 }" title="등록번호"  name="sa_measureAC2" id="sa_measureAC2" readonly="readonly">
				</label>
				</td><td rowspan="4" style="width:5%" class="sa_admin_input5">
				측<br>정<br>개<br>소
				</td>
				<td style="width:5%" class="sa_admin_input5">
				A -
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureAV3 }" title="등록번호"  name="sa_measureAV3" id="sa_measureAV3" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureAA3 }" title="등록번호"  name="sa_measureAA3" id="sa_measureAA3" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureAC3 }" title="등록번호"  name="sa_measureAC3" id="sa_measureAC3" readonly="readonly">
				</label>
				</td>
			</tr>
			<tr>
			<td style="width:5%" class="sa_admin_input5">
				B -
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureBV1 }" title="등록번호"  name="sa_measureBV1" id="sa_measureBV1" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureBA1 }" title="등록번호"  name="sa_measureBA1" id="sa_measureBA1" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureBC1 }" title="등록번호"  name="sa_measureBC1" id="sa_measureBC1" readonly="readonly">
				</label>
				</td><td style="width:5%" class="sa_admin_input5">
				B -
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureBV2 }" title="등록번호"  name="sa_measureBV2" id="sa_measureBV2" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureBA2 }" title="등록번호"  name="sa_measureBA2" id="sa_measureBA2" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureBC2 }" title="등록번호"  name="sa_measureBC2" id="sa_measureBC2" readonly="readonly">
				</label>
				</td><td style="width:5%" class="sa_admin_input5">
				B -
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureBV3 }" title="등록번호"  name="sa_measureBV3" id="sa_measureBV3" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureBA3 }" title="등록번호"  name="sa_measureBA3" id="sa_measureBA3" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureBC3 }" title="등록번호"  name="sa_measureBC3" id="sa_measureBC3" readonly="readonly">
				</label>
				</td>
			</tr>
						<tr>
			<td style="width:5%" class="sa_admin_input5">
				C -
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureCV1 }" title="등록번호"  name="sa_measureCV1" id="sa_measureCV1" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureCA1 }" title="등록번호"  name="sa_measureCA1" id="sa_measureCA1" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureCC1 }" title="등록번호"  name="sa_measureCC1" id="sa_measureCC1" readonly="readonly">
				</label>
				</td><td style="width:5%" class="sa_admin_input5">
				C -
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureCV2 }" title="등록번호"  name="sa_measureCV2" id="sa_measureCV2" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureCA2 }" title="등록번호"  name="sa_measureCA2" id="sa_measureCA2" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureCC2 }" title="등록번호"  name="sa_measureCC2" id="sa_measureCC2" readonly="readonly">
				</label>
				</td><td style="width:5%" class="sa_admin_input5">
				C -
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureCV3 }" title="등록번호"  name="sa_measureCV3" id="sa_measureCV3" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureCA3 }" title="등록번호"  name="sa_measureCA3" id="sa_measureCA3" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureCC3 }" title="등록번호"  name="sa_measureCC3" id="sa_measureCC3" readonly="readonly">
				</label>
				</td>
			</tr>
						<tr>
			<td style="width:5%" class="sa_admin_input5">
				N -
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureNV1 }" title="등록번호"  name="sa_measureNV1" id="sa_measureNV1" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureNA1 }" title="등록번호"  name="sa_measureNA1" id="sa_measureNA1" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureNC1 }" title="등록번호"  name="sa_measureNC1" id="sa_measureNC1" readonly="readonly">
				</label>
				</td><td style="width:5%" class="sa_admin_input5">
				N -
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureNV2 }" title="등록번호"  name="sa_measureNV2" id="sa_measureNV2" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureNA2 }" title="등록번호"  name="sa_measureNA2" id="sa_measureNA2" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureNC2 }" title="등록번호"  name="sa_measureNC2" id="sa_measureNC2" readonly="readonly">
				</label>
				</td><td style="width:5%" class="sa_admin_input5">
				N -
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureNV3 }" title="등록번호"  name="sa_measureNV3" id="sa_measureNV3" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureNA3 }" title="등록번호"  name="sa_measureNA3" id="sa_measureNA3" readonly="readonly">
				</label>
				</td>
				<td style="width:5%;" class="sa_admin_input5">
				<label>
					<input type="text" style="width:30% " class="tb_gbla1 input_type_serch" value="${list.sa_measureNC3 }" title="등록번호"  name="sa_measureNC3" id="sa_measureNC3" readonly="readonly">
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
								<input type="text" style="width:99.7%; height: 400px; " class="sa_admin_text56" value="${list.sa_opinion }" title="등록번호"  name="sa_opinion" id="sa_opinion" readonly="readonly">
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
						<input type="text" style="width:95% " class="sa_admin_text3"  title="등록번호" value="${list.sa_ceoname }" name="sa_ceoname" id="sa_ceoname" readonly="readonly">
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
						<input type="text" style="width:95% " class="sa_admin_text3"  title="등록번호" value="${list.sa_adminname }" name="sa_adminname" id="sa_adminname" readonly="readonly">
						</label>
					</td>
					<td class="sa_admin_input8">
					서명
					</td>				
				 </tr>
			</tbody>
				<label style="float: right; width: 50%;">
						<input type="text" style="width:100%; height: 60px; text-align: center; vertical-align: middle; font-size: 30px;" class="sa_admin_text3"  title="등록번호" value='"전기사고 예방으로 인명과 재산을 보호하자"' name="" id="" >
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
<div style="text-align: center;" id = "buttondiv1">
<input type="hidden" id="buttionType" name="buttionType" value="insert"> 
<input type="hidden" id="sa_keyno" name="sa_keyno" >
</div>
</div>
</div>
</fieldset>
<!-- <div style="text-align: center;"> -->
<!-- <button style="width: 120px;" onclick="loadInfo()"> 수정페이지 이동 </button> -->
<!-- </div> -->
</form:form>
<script type="text/javascript">

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



</script>
