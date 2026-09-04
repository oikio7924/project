<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<div class="table_wrapper con_h">
       <table class="tbl_private_se">
           <colgroup>
               <col width="25%">
               <col width="25%">
               <col width="25%">
               <col width="25%">
           </colgroup>
           <thead>
           </thead>
           	<tr>
           		<th colspan="4" style="background: gray; color: white;">신청내역</th>
           	</tr>
           <tbody>
           	<tr class="tr1">
           		<th class="th_name1">발전소명</th>
           		<td><input type="text" class="txt_nor sm2 w100" name="dls_app_plant" id="dls_app_plant"></td>
           		<th class="th_name2">허가용량</th>
           		<td><input type="text" class="txt_nor sm2 w100" name="dls_app_vol1" id="dls_app_vol1"></td>
           		<th class="alarm"></th>
           	</tr>
           	<tr>
           		<th class="th_name1">설치용량</td>
           		<td><input type="text" class="txt_nor sm2 w100" name="dls_app_vol2" id="dls_app_vol2"></td>
           		<th class="th_name2">발전소 소재지</td>
           		<td><input type="text" class="txt_nor sm2 w100" name="dls_app_address" id="dls_app_address"></td>
           		<th class="alarm"></th>
           	</tr>
           	<tr>
           		<th class="th_name1">설치형식</td>
           		<td><input type="text" class="txt_nor sm2 w100" name="dls_app_form" id="dls_app_form"></td>
           		<th class="th_name1">가중치</td>
           		<td><input type="text" class="txt_nor sm2 w100" name="dls_app_weight" id="dls_app_weight"></td>
           	</tr>
           	<tr>
           		<th class="th_name1">전력수급계약체결일</td>
           		<td><input type="date" class="txt_nor sm2 w100" name="dls_app_jsgDate" id="dls_app_jsgDate"></td>
           		<th class="th_name1">상업운전개시일</td>
           		<td><input type="date" class="txt_nor sm2 w100" name="dls_app_swgDate" id="dls_app_swgDate"></td>
           	</tr>
           	<tr>
           		<th class="th_name1">준공검사접수일</td>
           		<td><input type="date" class="txt_nor sm2 w100" name="dls_app_jgjDate" id="dls_app_jgjDate"></td>
           		<th class="th_name1">준공검사필증교부일</td>
           		<td><input type="date" class="txt_nor sm2 w100" name="dls_app_jgpDate" id="dls_app_jgpDate"></td>
           	</tr>
           	<tr>
   			   	<th class="th_name1">감리업체명</th>
                <td><input type="text" class="txt_nor sm2 w100" name="dls_man_gamName" id="dls_man_gamName"></td>
                <th class="th_name1">감리기간</th>
                <td><input type="text" class="txt_nor sm2 w100" name=dls_man_gamPeriod id="dls_man_gamPeriod"></td>
            </tr>
            <tr>
               	<th colspan="4" style="background: gray; color: white;">실무담당자</th>
            </tr>
            <tr>
               	<th>담당자명</th>
                <td><input type="text" class="txt_nor sm2 w100" name="dls_man_daeName" id="dls_man_daeName"></td>
               	<th>부서</th>
                <td><input type="text" class="txt_nor sm2 w100" name="dls_man_daeDepart" id="dls_man_daeDepart"></td>
            </tr>
            <tr>
               	<th>직책</th>
                <td><input type="text" class="txt_nor sm2 w100" name="dls_man_daePostion" id="dls_man_daePostion"></td>
               	<th>연락처</th>
                <td><input type="text" class="txt_nor sm2 w100" name="dls_man_daePhone" id="dls_man_daePhone"></td>
            </tr>
            <tr>
               	<th>이메일</th>
                <td><input type="text" class="txt_nor sm2 w100" name="dls_man_daeEmail" id="dls_man_daeEmail"></td>
            </tr>
            <tr>
           		<th colspan="4" style="background: gray; color: white;">처리 기관</th>
           	</tr>
           	<tr>
               	<th>기관명</th>
                <td><input type="text" class="txt_nor sm2 w100" name="dls_man_govName" id="dls_man_govName"></td>
                <th>부서</th>
                <td><input type="text" class="txt_nor sm2 w100" name="dls_man_govDepart" id="dls_man_govDepart"></td>
            </tr>
          	<tr>
               	<th>연락처</th>
                <td><input type="text" class="txt_nor sm2 w100" name="dls_man_govPhone" id="dls_man_govPhone"></td>
            </tr>
           <tr>
           		<table class="tbl_private_se">
	           		<colgroup>
	           			<col width="20%">
	           			<col width="20%">
	           			<col width="20%">
	           			<col width="20%">
	           			<col width="20%">
	           		</colgroup>
	           		<thead>
		            </thead>
	           		<tr>
	           		<th colspan="5" style="background: gray; color: white;">설비구성</th>
	           		</tr>
		            <tbody>
		            	<tr style="text-align: center;">
		                    <th style="border: 1px solid #ddd;">구분</th>
		                    <th style="border: 1px solid #ddd;">모델명</th>
		                    <th style="border: 1px solid #ddd;">용량</th>
		                    <th style="border: 1px solid #ddd;">수량</th>
		                    <th style="border: 1px solid #ddd;">비고</th>
		                </tr>
		                <tr>
		                	<td style="text-align: center; padding: 0px;" class="th_name1">모듈</td>
		                    <td style="padding: 0px;"><input type="text" class="txt_nor sm2 w100" style="width: 93%" name="dls_com_moName" id="dls_com_moName" value=""></td>
		                    <td style="padding: 0px;"><input type="text" class="txt_nor sm2 w100" style="width: 93%" name="dls_com_moVolum" id="dls_com_moVolum" value=""></td>
		                    <td style="padding: 0px;"><input type="text" class="txt_nor sm2 w100" style="width: 93%" name="dls_com_moQuantity" id="dls_com_moQuantity" value=""></td>
		                    <td style="padding: 0px;"><input type="text" class="txt_nor sm2 w100" style="width: 93%" name="dls_com_moEtc" id="dls_com_moEtc" value=""></td>
		            	</tr>
		                <tr>
		                	<td style="text-align: center; padding: 0px;" class="th_name1">인버터</td>
		                    <td style="padding: 0px;"><input type="text" class="txt_nor sm2 w100" style="width: 93%" name="dls_com_inName" id="dls_com_inName" value=""></td>
		                    <td style="padding: 0px;"><input type="text" class="txt_nor sm2 w100" style="width: 93%" name="dls_com_invVolum" id="dls_com_invVolum" value=""></td>
		                    <td style="padding: 0px;"><input type="text" class="txt_nor sm2 w100" style="width: 93%" name="dls_com_inQuantity" id="dls_com_inQuantity" value=""></td>
		                    <td style="padding: 0px;"><input type="text" class="txt_nor sm2 w100" style="width: 93%" name="dls_com_inEtc" id="dls_com_inEtc" value=""></td>
		            	</tr>
		                <tr>
		                	<td style="text-align: center; padding: 0px;" class="th_name1">접속함</td>
		                    <td style="padding: 0px;"><input type="text" class="txt_nor sm2 w100" style="width: 93%" name="dls_com_connName" id="dls_com_connName" value=""></td>
		                    <td style="padding: 0px;"><input type="text" class="txt_nor sm2 w100" style="width: 93%" name="dls_com_connVolum" id="dls_com_connVolum" value=""></td>
		                    <td style="padding: 0px;"><input type="text" class="txt_nor sm2 w100" style="width: 93%" name="dls_com_connQuantity" id="dls_com_connQuantity" value=""></td>
		                    <td style="padding: 0px;"><input type="text" class="txt_nor sm2 w100" style="width: 93%" name="dls_com_connEtc" id="dls_com_connEtc" value=""></td>
		            	</tr>
		            </tbody>
           		</table>
           	</tr>
           </tbody>
       </table>
</div>
