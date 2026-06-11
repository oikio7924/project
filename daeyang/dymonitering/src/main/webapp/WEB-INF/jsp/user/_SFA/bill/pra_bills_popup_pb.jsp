<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<style>

input{ border:0 solid black; width:80%;}
/* tr:focus{outline: 1px solid blue;} */
/* th{outline: 1px solid blue;}    */
/*  td{outline: 1px solid #5b9adf;}  */
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
<body>
<fieldset style="margin-top : 5%;">
<div class="box_wrap sel_btn" style="float: left;">			
					<div style="display: inline-block;float:left">
						<span style="btn_wrap">			
							<a href="#" class="btn_s navy" style="min-width:100px;" onclick="print_p()">PRINT</a>														
						</span>
					</div>
			</div>
</fieldset>
<fieldset id= "field" style="margin-top : 5%;">
<div id="poppop">
				<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0"
					data-widget-editbutton="false" >
					<header>
						<span class="widget-icon"> <i class="fa fa-table"></i>
						</span>
						</header>
<div style="width: 100%">
	 <table style=" border-collapse:collapse; border-right: 3px solid #5b9adf; border-left: 3px solid  #f77573;  border-top: 3px solid  #f77573;  border-bottom: 2px solid #f77573" class="table table-striped table-bordered table-hover dataTable no-footer"> 				 
				 <colgroup>
					<col width="3">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="3">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
				 </colgroup>
				 
                  <tbody>
				
				     <tr style="border-bottom: 3px solid #f77573 ">
							<th colspan="10" class="title" id="title_name"><span style="font-size:22px;"><strong>전 자 세 금 계 산 서</strong></span></th>      
					 </tr>
					 <tr style="width:100%">
						<th rowspan="6" style="background: #ffdbde;color: #de2b3a;font-weight: 700; border-right:2px solid #f77573; border-top:2px solid #f77573;">공<br>급<br>자</th>
						<th style="width:8%;" class="tb_gbla">등록번호</th>
						<td style="width:16%" class="tb_gbla_input">
							<label>
								<input type="text" style="width:83% " class="tb_gbla1 input_type_serch" maxlength="14" title="등록번호" value="${list.dbp_co_num }" name="ir_companyno" id="ir_companyno" readonly="readonly">
							</label>
						</td>
						<th style="width:8%; " class="tb_gbla">종사업장<br>번호</th>
						<td style="width:16%" class="tb_gbla_input">
							<label>
								<input type="text" style="width:95% " class="tb_gbla1 input_type_serch" maxlength="4" title="종사업장번호" value="" name="ir_taxno" id="ir_taxno" readonly="readonly">
							</label>
						</td>
						<th rowspan="6" style="background: #c6dbf7;  border-left: 2px solid  #5b9adf; border-bottom: 2px solid  #5b9adf; border-right: 2px solid  #5b9adf; border-top: 2px solid  #5b9adf; font-weight: 700; color:#3365f3;">공<br>급<br>받<br>는<br>자</th>
						<th style="width:8%" class="tb_gbla2">등록번호*</th>
						<td style="width:16%" class="tb_gbla2_input">
						  <label style="text-align: left; padding-left: 6px;">
								<input type="text" style="width:75% " class="input_type_serch" maxlength="14" title="등록번호" name="ie_companyno" id="ie_companyno" value="${list.dbs_co_num }" readonly="readonly">
						  </label>
						</td>
						<th style="width:8%" class="tb_gbla2">종사업장<br>번호</th>
						<td style="width:16%" class="tb_gbla2_input">
							
						  <label><input type="text" style="width:95%" class="input_type_serch" maxlength="4" title="종사업자번호" name="ie_taxno" id="ie_taxno" value="${list.dbs_taxnum }" readonly="readonly"></label>
						</td>
					 </tr>
					 <tr style="width:100%">
						<th style="" class="tb_gbla">상호<br>(법인명)</th>
						<td class="tb_gbla_input">
						  <label style="text-align: left; padding-left: 6px;">
								<input type="text" style="width:80% " class="tb_gbla1 input_type_serch" title="상호(법인명)" name="ir_companyname" id="ir_companyname" value="${list.dbp_name }" readonly="readonly">
						  </label>
						</td>
						<th style="" class="tb_gbla">성명</th>
						<td class="tb_gbla_input">
							<label style="text-align: left; padding-left: 6px;">
								<input type="text" style="width:80% " class="tb_gbla1 input_type_serch" title="성명(대표자)" name="ir_ceoname" id="ir_ceoname" value="${list.dbp_ceoname }" readonly="readonly">
						    </label>
						</td>
						<th class="tb_gbla2">상호<br>(법인명)*</th>
						<td class="tb_gbla2_input">
						  <label><input type="text" style="width:80%" class="input_type_serch" title="상호(법인명)" name="ie_companyname" id="ie_companyname" value="${list.dbs_name }" readonly="readonly"></label>
						</td>
						<th class="tb_gbla2">성명*</th>
						<td class="tb_gbla2_input">
						  <label><input type="text" style="width:80%" class="input_type_serch" title="성명(대표자)" name="ie_ceoname" id="ie_ceoname" value="${list.dbs_ceoname }" readonly="readonly"></label>
						</td>
					 </tr>					 
					 <tr style="width:100%">
						<th style="" class="tb_gbla">주소</th>
						<td colspan="3" style="text-align:left; " class="tb_gbla_input">
						  <label style="text-align: left; padding-left: 6px;">
								<input type="text" style="width:80% " class="tb_gbla1 input_type_serch" title="주소" name="ir_companyaddress" id="ir_companyaddress" value="${list.dbp_address }" readonly="readonly">
						  </label>
						</td>
						<th class="tb_gbla2">주소</th>
						<td colspan="3" class="tb_gbla2_input">
						  <label><input type="text" style="width:90%; text-align:left;" class="input_type_serch" title="주소" name="ie_companyaddress" id="ie_companyaddress" value="${list.dbs_address }" readonly="readonly"></label>
						</td>
					</tr>
					 <tr style="width:100%">
						<th style="" class="tb_gbla">업태</th>
						<td class="tb_gbla_input">
						  <label style="text-align: left; padding-left: 6px;">
								<input type="text" style="width:95% " class="tb_gbla1 input_type_serch" title="업태" name="ir_biztype" id="ir_biztype" value="${list.dbp_biztype }" readonly="readonly">
						  </label>
						</td>
						<th style="" class="tb_gbla">종목</th>
						<td class="tb_gbla_input">
						  <label style="text-align: left; padding-left: 6px;">
								<input type="text" style="width:85% " class="tb_gbla1 input_type_serch" title="종목" name="ir_bizclass" id="ir_bizclass" value="${list.dbp_bizclassification }" readonly="readonly">
						  </label>
						</td>
						<th class="tb_gbla2" style="">업태</th>
						<td style=" " class="tb_gbla2_input">
						  <label><input type="text" style="width:90%" class="input_type_serch" title="업태" name="ie_biztype" id="ie_biztype" value="${list.dbs_biztype }" readonly="readonly"></label>
						</td>
						<th class="tb_gbla2" style="">종목</th>
						<td style="" class="tb_gbla2_input">
						  <label><input type="text" style="width:95%" class="input_type_serch" title="종목" name="ie_bizclass" id="ie_bizclass" value="${list.dbs_bizclassification }" readonly="readonly"></label>
						</td>
					 </tr>
					  <tr style="width:100%">
						<th style="" class="tb_gbla" rowspan="2">이메일</th>
						<td colspan="3" style="text-align:left; " class="tb_gbla_input" rowspan="2">
						  <label style="text-align: left; padding-left: 6px;">
								<input type="text" style="width:95% " class="tb_gbla1 input_type_serch" title="공급자이메일" name="ir_email" id="ir_email" value="${list.dbp_email }" readonly="readonly">
						  </label>
						</td>
						<th class="tb_gbla2">이메일1</th>
						<td colspan="3" class="tb_gbla2_input">
						  <label><input type="text" style="width:98%; text-align:left;" class="input_type_serch" title="수신자이메일1" name="ie_email1" id="ie_email1" value="${list.dbs_email1 }" readonly="readonly"></label>
						</td>
					</tr>
					 <tr style="width:100%">
					
						<th class="tb_gbla2" style=" border-bottom: 2px solid  #5b9adf;">이메일2</th>
						<td colspan="3" style=" border-bottom: 2px solid  #5b9adf;" class="tb_gbla2_input">
						  <label><input type="text" style="width:98%; text-align:left;" class="input_type_serch" title="수신자이메일" name="ie_email2" id="ie_email2" value="${list.dbs_email2 }" readonly="readonly"></label>
						</td>
					</tr>
				 </tbody>
              </table>
              
              <div class="tb_taxdetail"> <!--작성일자부분-->
		 <table class="tb_taxdetail_ta" style = "border-collapse:collapse;"> 				 
			 <colgroup>
				<col width="10%">
				<col width="20%">
				<col width="20%">
				<col width="20%">
				<col width="30%">
			 </colgroup>
			  <thead>
				<tr style="width:100%;">
					<th class ="tb_gbla3">작성일자</th>
					<th class ="tb_gbla3">공급가격</th>
					<th class ="tb_gbla3">세액</th>
					<th class ="tb_gbla3">수정사유</th>
					<th class ="tb_gbla10">비고</th>
				 </tr>
			  </thead>
			  <tbody>					
				 <tr style="width:100%">
					<td class ="tb_gbla3_2"> 
						<span class="" style="width:120px; ">
								<input type="text" class="input_type_serch" id="issuedate" style="text-align: center;" name="issuedate" value="${list.dbl_issuedate }" readonly="readonly">								
							   <input type="hidden" name="bal_issuedate" id="bal_issuedate" value="2022-05-03">
						</span> 
			
					</td>
					<td class ="tb_gbla3_2"> <label><input type="text" name="chargetotal" id="chargetotal" style="width:95%; " value="${list.dbl_chargetotal }" class="input_type_serch numberInput_g" title="공급가격" readonly="readonly"></label></td>
					<td class ="tb_gbla3_2"> <label><input type="text" name="taxtotal" style="width:95%;" value="${list.dbl_taxtotal }" class="input_type_serch numberInput_g" title="세액" readonly="readonly"></label></td>
					<td class ="tb_gbla3_2"> <label><input type="text" name="modifytype" style="width:95%;" value="" class="input_type_serch " title="수정사유" readonly="readonly"></label></td>
					<td class ="tb_gbla10_11"> <label><input type="text" name="description" style="width:95%" value="${list.dbl_description }" class="input_type_serch" title="비고" readonly="readonly"></label></td>
				 </tr>
			 </tbody>
		  </table>
  </div>
  </div>
  
<!--   -------- -->

<div>
  <div class="tb_taxdetail">
	  <table id="tab_tax_subitem" style="border-collapse:collapse;";> 				 
		 <colgroup>
			<col width="5%">
			<col width="5%">
			<col width="30%">
			<col width="5%">
			<col width="5%">
			<col width=10%>
			<col width="10%">
			<col width="10%" class="tc_code1">
			<col width="10%">
		 </colgroup>
		  <thead>
			<tr style="width:100%">
				<th class ="tb_gbla4">월</th>
				<th class ="tb_gbla4">일</th>
				<th class ="tb_gbla4">품목</th>
				<th class ="tb_gbla4">규격</th>
				<th class ="tb_gbla4">수량</th>
				<th class ="tb_gbla4">단가</th>
				<th class ="tb_gbla4">공급가액</th>
				<th class ="tb_gbla4">세액</th>
				<th class ="tb_gbla10">비고</th>
				
			 </tr>
		  </thead>
		  <tbody class="rowlist">	
		         <tr style="width:100%">
					<td class ="tb_gbla4_2">
					   <label> 
						 <input type="hidden" name="yy[]" style="width:30%; text-align: center;" value="2022" class="input_type_serch" title="년" readonly="readonly">
						 <input type="text" name="mm[]" style="width:30%; text-align: center;" value="${month }" class="input_type_serch" title="월" readonly="readonly">
					   </label>
					</td>
					<td class ="tb_gbla4_2">
					   <label> 
						 <input type="text" name="dd[]" style="width:30%; text-align: center;" value="${date }" class="input_type_serch" title="일" readonly="readonly">
					   </label>
					</td>
					<td class ="tb_gbla4_2"><label><input type="text" name="dsubject[]" style="width:95%" value="${list.dbl_subject }" class="input_type_serch" title="품목" readonly="readonly"></label></td>
					<td class ="tb_gbla4_2"><label><input type="text" name="dunit[]" style="width:95%" value="${list.dbl_unit }" class="input_type_serch" title="규격" readonly="readonly"></label></td>
					<td class ="tb_gbla4_2"><label><input type="text" name="dquantity[]" style="width:95%" value="${list.dbl_quantity }" class="input_type_serch checkVal numberInput_g" title="수량" readonly="readonly"></label></td>
					<td class ="tb_gbla4_2"><label><input type="text" name="dunitprice[]" style="width:95%" value="${list.dbl_unitprice }" class="input_type_serch checkVal numberInput_g" title="단가" readonly="readonly"></label></td>
					<td class ="tb_gbla4_2"><label><input type="text" name="dsupplyprice[]" style="width:95%" value="${list.dbl_supplyprice }" class="input_type_serch checkVal1 numberInput_g" title="공급가액" readonly="readonly"></label></td>
					<td class ="tb_gbla4_2"><label><input type="text" name="dtax[]" style="width:95%" value="${list.dbl_tax }" class="input_type_serch numberInput_g" title="세액" readonly="readonly"></label></td>
					<td class ="tb_gbla10_10"><label><input type="text" name="ddescription[]" style="width:95%" value="${list.dbl_sub_description }" class="input_type_serch" title="비고" readonly="readonly"></label></td>
				 </tr>
				 <tr style="width:100%">
					<td class ="tb_gbla4_2">
					   <label> 
						 <input type="hidden" name="yy[]" style="width:30%; text-align: center;" value="" class="input_type_serch" title="년" readonly="readonly">
						 <input type="text" name="mm[]" style="width:30%; text-align: center;" value="" class="input_type_serch" title="월" readonly="readonly">
					   </label>
					</td>
					<td class ="tb_gbla4_2">
					   <label> 
						 <input type="text" name="dd[]" style="width:30%; text-align: center;" value="" class="input_type_serch" title="일" readonly="readonly">
					   </label>
					</td>
					<td class ="tb_gbla4_2"><label><input type="text" name="dsubject[]" style="width:95%" value="" class="input_type_serch" title="품목" readonly="readonly"></label></td>
					<td class ="tb_gbla4_2"><label><input type="text" name="dunit[]" style="width:95%" value="" class="input_type_serch" title="규격" readonly="readonly"></label></td>
					<td class ="tb_gbla4_2"><label><input type="text" name="dquantity[]" style="width:95%" value="" class="input_type_serch checkVal numberInput_g" title="수량" readonly="readonly"></label></td>
					<td class ="tb_gbla4_2"><label><input type="text" name="dunitprice[]" style="width:95%" value="" class="input_type_serch checkVal numberInput_g" title="단가" readonly="readonly"></label></td>
					<td class ="tb_gbla4_2"><label><input type="text" name="dsupplyprice[]" style="width:95%" value="" class="input_type_serch checkVal1 numberInput_g" title="공급가액" readonly="readonly"></label></td>
					<td class ="tb_gbla4_2"><label><input type="text" name="dtax[]" style="width:95%" value="" class="input_type_serch numberInput_g" title="세액" readonly="readonly"></label></td>
					<td class ="tb_gbla10_10"><label><input type="text" name="ddescription[]" style="width:95%" value="" class="input_type_serch" title="비고" readonly="readonly"></label></td>
				 </tr>
				 <tr style="width:100%">
					<td class ="tb_gbla4_2">
					   <label> 
						 <input type="hidden" name="yy[]" style="width:30%; text-align: center;" value="" class="input_type_serch" title="년" readonly="readonly">
						 <input type="text" name="mm[]" style="width:30%; text-align: center;" value="" class="input_type_serch" title="월" readonly="readonly">
					   </label>
					</td>
					<td class ="tb_gbla4_2">
					   <label> 
						 <input type="text" name="dd[]" style="width:30%; text-align: center;" value="" class="input_type_serch" title="일" readonly="readonly">
					   </label>
					</td>
					<td class ="tb_gbla4_2"><label><input type="text" name="dsubject[]" style="width:95%" value="" class="input_type_serch" title="품목" readonly="readonly"></label></td>
					<td class ="tb_gbla4_2"><label><input type="text" name="dunit[]" style="width:95%" value="" class="input_type_serch" title="규격" readonly="readonly"></label></td>
					<td class ="tb_gbla4_2"><label><input type="text" name="dquantity[]" style="width:95%" value="" class="input_type_serch checkVal numberInput_g" title="수량" readonly="readonly"></label></td>
					<td class ="tb_gbla4_2"><label><input type="text" name="dunitprice[]" style="width:95%" value="" class="input_type_serch checkVal numberInput_g" title="단가" readonly="readonly"></label></td>
					<td class ="tb_gbla4_2"><label><input type="text" name="dsupplyprice[]" style="width:95%" value="" class="input_type_serch checkVal1 numberInput_g" title="공급가액" readonly="readonly"></label></td>
					<td class ="tb_gbla4_2"><label><input type="text" name="dtax[]" style="width:95%" value="" class="input_type_serch numberInput_g" title="세액" readonly="readonly"></label></td>
					<td class ="tb_gbla10_10"><label><input type="text" name="ddescription[]" style="width:95%" value="" class="input_type_serch" title="비고" readonly="readonly"></label></td>
				 </tr>
				 <tr style="width:100%">
					<td class ="tb_gbla4_3">
					   <label> 
						 <input type="hidden" name="yy[]" style="width:30%; text-align: center;" value="" class="input_type_serch" title="년" readonly="readonly">
						 <input type="text" name="mm[]" style="width:30%; text-align: center;" value="" class="input_type_serch" title="월" readonly="readonly">
					   </label>
					</td>
					<td class ="tb_gbla4_3">
					   <label> 
						 <input type="text" name="dd[]" style="width:30%; text-align: center;" value="" class="input_type_serch" title="일" readonly="readonly">
					   </label>
					</td>
					<td class ="tb_gbla4_3"><label><input type="text" name="dsubject[]" style="width:95%" value="" class="input_type_serch" title="품목" readonly="readonly"></label></td>
					<td class ="tb_gbla4_3"><label><input type="text" name="dunit[]" style="width:95%" value="" class="input_type_serch" title="규격" readonly="readonly"></label></td>
					<td class ="tb_gbla4_3"><label><input type="text" name="dquantity[]" style="width:95%" value="" class="input_type_serch checkVal numberInput_g" title="수량" readonly="readonly"></label></td>
					<td class ="tb_gbla4_3"><label><input type="text" name="dunitprice[]" style="width:95%" value="" class="input_type_serch checkVal numberInput_g" title="단가" readonly="readonly"></label></td>
					<td class ="tb_gbla4_3"><label><input type="text" name="dsupplyprice[]" style="width:95%" value="" class="input_type_serch checkVal1 numberInput_g" title="공급가액" readonly="readonly"></label></td>
					<td class ="tb_gbla4_3"><label><input type="text" name="dtax[]" style="width:95%" value="" class="input_type_serch numberInput_g" title="세액" readonly="readonly"></label></td>
					<td class ="tb_gbla10_11"><label><input type="text" name="ddescription[]" style="width:95%" value="" class="input_type_serch" title="비고" readonly="readonly"></label></td>
				 </tr>
			
				
		 </tbody>
	  </table>
  </div> <!--taxdetail-->
  <div class="tb_taxdetail" style="border-bottom: 2px solid #5b9adf;">
	 <table style="border-collapse:collapse;"> 				 
		 <colgroup>
			<col width="18%">
			<col width="18%">
			<col width="18%">
			<col width="18%">
			<col width="18%">
			<col width="45%">
		 </colgroup>				  
		  <tbody>		
			<tr style="width:100%">
				<th class ="tb_gbla5">합계금액</th>
				<th class ="tb_gbla5">현금</th>
				<th class ="tb_gbla5">수표</th>
				<th class ="tb_gbla5">어음</th>
				<th class ="tb_gbla5">외상미수금</th>
				<td rowspan="2" style="text-align: center!important;" class ="tb_gbla10_12">
					<div style="overflow: hidden; display: inline-block;">
						<span style="float: left; margin: 10px 10px 0 0">이 금액을&nbsp;<strong>청구</strong> 함</span>
					</div>

				</td>						
			 </tr>				 			
			 <tr style="width:100%">
				<td class ="tb_gbla5_2"><label><input type="text" name="grandtotal" style="width:95%;" class="input_type_serch numberInput_g" title="합계금액" value="${list.dbl_grandtotal }" readonly="readonly"></label></td>
				<td class ="tb_gbla5_2"><label><input type="text" name="cash" style="width:95%" class="input_type_serch numberInput_g" value="${list.dbl_cash }" title="현금" readonly="readonly"></label></td>
				<td class ="tb_gbla5_2"><label><input type="text" name="scheck" style="width:95%" class="input_type_serch numberInput_g" value="${list.dbl_scheck }" title="수표" readonly="readonly"></label></td>
				<td class ="tb_gbla5_2"><label><input type="text" name="draft" style="width:95%" class="input_type_serch numberInput_g" value="${list.dbl_draft }" title="어음" readonly="readonly"></label></td>
				<td class ="tb_gbla5_2"><label><input type="text" name="uncollected" style="width:95%" class="input_type_serch numberInput_g" value="${list.dbl_uncollected }" title="외상 미수금" readonly="readonly"></label></td>
			 </tr>
			 
			 
			 
		 </tbody>
	  </table>
  </div>
</div>
</div>
</div>
<div id="myModal" class="modal" style="width: 1200px; display: none;" aria-hidden="true">
     <div class="modal-dialog" style="padding-top: 200px; width : 800px">
          <div class="modal-content">
               <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h3 class="tit_big">수정사유</h3>
               </div>
				  <div class="u_modifytype">
					<div>
						<li style="padding-top: 10px; padding-left: 10px;"><strong>기재 사항의 착오 변동</strong></li>	
						<li>필요적 기재사항, 세율 등을 착오 또는 착오 외의 사유로 잘못 발급 한 경우</li>		
						<li style="color:#0501ff;">※당초 취소분 1장(자동발급),수정분 1장(직접입력) 총 2장 발급</li>	
						<li><strong class="btn tit_sub btn_modifytype" id="modifytype01" value="01" style="float: right; " onclick="f_send('01')">바로가기</strong></li>
					</div>
					<div>
						<li style="padding-top: 10px; padding-left: 10px;"><strong>착오에 의한 이중발급등</strong></li>	
						<li>착오로 이중 발급한 경우, 면세 등 발급대상이 아닌 거래 등에 대하여 발급한 경우</li>		
						<li style="color:#0501ff;">※당초 발급한 세금계산서의 내용대로 부(-)의 수정세금계산서 1장 발급</li>	
						<li><strong class="btn tit_sub btn_modifytype" id="modifytype02" value="06" style="float: right;" onclick="f_send('06')">바로가기</strong></li>
					</div>
					<div>
						<li style="padding-top: 10px; padding-left: 10px;"><strong>공급가액변동</strong></li>	
						<li>공급가액에 추가 또는 차감되는 금액이 발생한 경우</li>		
						<li style="color:#0501ff;">※증감시킴 금액에 대해 정(+) 또는 부(-)의 수정세금계산서 1장 발급</li>
						<li><strong class="btn tit_sub btn_modifytype" id="modifytype03" value="02" style="float: right;" onclick="f_send('02')">바로가기</strong></li>
					</div>
					<div>
						<li style="padding-top: 10px; padding-left: 10px;"><strong>계약의해제</strong></li>	
						<li>계약의 해제로 재화 또는 용역이 공급되지 않는 경우</li>		
						<li style="color:#0501ff;">※당초 발급한 세금계산서의 내용대로 부(-)의 수정세금계산서 1장 발급</li>
						<li><strong class="btn tit_sub btn_modifytype" id="modifytype04" value="04" style="float: right;" onclick="f_send('04')">바로가기</strong></li>
					</div>
					<div>
						<li style="padding-top: 10px; padding-left: 10px;"><strong>환입</strong></li>	
						<li>당초 공급한 재화가 환입(반품)된 경우</li>		
						<li style="color:#0501ff;">※환입(반품)된 금액만큼만 부(-)의 수정세금계산서 1장 발급</li>
						<li><strong class="btn tit_sub btn_modifytype" id="modifytype05" value="03" style="float: right;" onclick="f_send('03')">바로가기</strong></li>
					</div>
					<div>
						<li style="padding-top: 10px; padding-left: 10px;"><strong>내국신용장 등 사후 개설</strong></li>	
						<li>내국신용장 등이 사후 개설된 경우</li>		
						<li style="color:#0501ff;">※개설된 금액만큼 부(-)로 1장, 영세율로 1장 총 2장 수정세금계산서 발급</li>
						<li><strong class="btn tit_sub btn_modifytype" id="modifytype06" value="05" style="float: right;" onclick="f_send('05')">바로가기</strong></li>
						
					</div>
				</div>

               <!--div class="modal-footer">
                    <button type="button" class="btn btn-primary">확인</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
               </div-->
          </div>
     </div>
</div>
</fieldset>

</body>
</html>
<script type="text/javascript">

//프린트 출력
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

function p_upinsert_p(){    
	alert("3333");
    $('#myModal').modal('show');
}

</script>