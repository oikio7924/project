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
           		<th colspan="4" style="background: gray; color: white;">접수내역</th>
           	</tr>
           <tbody>
           	<tr class="tr1">
           		<th class="th_name1">허가용량</td>
           		<td><input type="text" class="txt_nor sm2 w100" name="dls_app_vol1" id="dls_app_vol1"></td>
           		<th class="th_name2">접수용량</td>
           		<td><input type="text" class="txt_nor sm2 w100" name="dls_app_vol2" id="dls_app_vol2"></td>
           		<th class="alarm"></th>
           	</tr>
           	<tr>
           		
           		<th class="th_name1">고객번호</td>
           		<td><input type="text" class="txt_nor sm2 w100" name="dls_app_cusNum" id="dls_app_cusNum"></td>
           		<th class="th_name2">접수번호</td>
           		<td><input type="text" class="txt_nor sm2 w100" name="dls_app_appNum" id="dls_app_appNum"></td>
           		<th class="alarm"></th>
           	</tr>
           	<tr>
           		<th class="th_name1">접수일</td>
           		<td><input type="date" class="txt_nor sm2 w100" name="dls_app_appDate" id="dls_app_appDate" onchange="updateDueDate('dls_app_appDate','dls_app_appDate')"></td>
           	</tr>
           	<tr>
           		<th colspan="4" style="background: gray; color: white;">실무담당자</th>
           	</tr>
           	<tr>
   			   	<th>담당자명</th>
                <td><input type="text" class="txt_nor sm2 w100" name="dls_man_daeName" id="dls_man_daeName"></td>
                <th>부서</th>
                <td><input type="text" class="txt_nor sm2 w100" name=dls_man_daeDepart id="dls_man_daeDepart"></td>
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
           </tbody>
       </table>
</div>