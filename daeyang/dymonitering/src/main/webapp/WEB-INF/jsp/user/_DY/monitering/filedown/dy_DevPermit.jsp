<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<div class="div_2">
		<div class="table_wrapper con_h">
	        <table class="tbl_private_se" id="addTable">
	            <colgroup>
	                <col width="13%">
	                <col width="13%">
	                <col width="13%">
	                <col width="13%">
	                <col width="13%">
	                <col width="13%">
	                <col width="13%">
	            </colgroup>
	            <thead>
	            </thead>
	            <tbody>
	            	<tr>
		           		<th colspan="7" style="background: gray; color: white;">허가 신청 내역</th>
		           	</tr>
	            	<tr>
	            		<th>신청구분</td>
	            		<td colspan="6" style="text-align: center;">
	            			<span>
	            				<input type="radio" value="0" title="공작물설치(건물 위)" name="dlm_type" id="dlm_type1">
	            				<label for="dlm_type1">공작물설치(건물 위)</label>
	            			</span>
	            			<span style="padding: 0px 0px 0px 100px;">
	            				<input type="radio" value="1" title="토지형질변경(나대지)" name="dlm_type" id="dlm_type2">
	            				<label for="dlm_type2">토지형질변경(나대지)</label>
	            			</span>
	            		</td>
	            	</tr>
	            	<tr>
	            		<th style="border: 1px solid #ddd;">신청목적</th>
	            		<td colspan="6"><input type="text" class="txt_nor sm2 w100" name="dlm_purpose" id="dlm_purpose" value=""></td>
	            	</tr>
	            	<tr>
	                    <th rowspan="3" id="locationRowSpan" style="border: 1px solid #ddd;">신청위치</th>
	                    <th>주소</th>
	                    <td colspan="5"><input type="text" class="txt_nor sm2 w100" name="dlm_trueAddress" id="dlm_trueAddress" value=""></td>
	                </tr>
	                <tr style="text-align: center;">
	                    <th style="border: 1px solid #ddd;">지번<button type="button" class="arrow-button" onclick="addInput()"><i class="fas fa-plus"></i></button><button type="button" class="arrow-button" onclick="deleteInput()"><i class="fas fa-minus"></i></button></th>
	                    <th style="border: 1px solid #ddd;">신청지번</th>
	                    <th style="border: 1px solid #ddd;">필지면적(m2)</th>
	                    <th style="border: 1px solid #ddd;">지목</th>
	                    <th style="border: 1px solid #ddd;">용도지역</th>
	                    <th style="border: 1px solid #ddd;">용도지구</th>
	                </tr>
	                <tr>
	                	<td style="padding: 0px;"><input type="text" class="txt_nor sm2 w100" style="width: 93%" name="dlm_address" id="dlm_address" value=""></td>
	                    <td style="padding: 0px;"><input type="text" class="txt_nor sm2 w100" style="width: 93%" name="dlm_street" id="dlm_street" value=""></td>
	                    <td style="padding: 0px;"><input type="text" class="txt_nor sm2 w100" style="width: 93%" name="dlm_area" id="dlm_area" value=""></td>
	                    <td style="padding: 0px;"><input type="text" class="txt_nor sm2 w100" style="width: 93%" name="dlm_land" id="dlm_land" value=""></td>
	                    <td style="padding: 0px;"><input type="text" class="txt_nor sm2 w100" style="width: 93%" name="dlm_usage" id="dlm_usage" value=""></td>
	                    <td style="padding: 0px;"><input type="text" class="txt_nor sm2 w100" style="width: 93%" name="dlm_use" id="dlm_use" value=""></td>
	            	</tr>
	            	<tr>
	            		<th style="border: 1px solid #ddd;">허가 접수일</th>
	            		<td colspan="3"><input type="date" class="txt_nor sm2 w100" name="dlm_connDate" id="dlm_connDate" onchange="updateDueDate('dlm_connDate','dlm_endDate')"></td>
	            		<th style="border: 1px solid #ddd;">허가 처리 예정일</th>
	            		<td colspan="2"><input type="text" class="txt_nor sm2 w100" name="dlm_endDate" id="dlm_endDate"></td>
	            	</tr>
	            </tbody>
	        </table>
		</div>
	<br>
	
	<!-- 관리자만 -->
<%-- 	<c:if test="${userInfo.isAdmin eq 'Y'}">
		<div class="table_wrapper con_h">
			<button type="button" id="MainsaveButton" class="btn_nor md2 g_line" style="float: right; font-size: 12px; height: 22px; padding: 1px;" title="저장" onclick="MainSubInsert()">저장</button>
		</div>
	</c:if> --%>
</div>

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
           		<th colspan="4" style="background: gray; color: white;">실무담당자</th>
           	</tr>
           <tbody>
           	<tr class="tr1">
           		<th class="th_name1">담당자명</td>
           		<td><input type="text" class="txt_nor sm2 w100" name="dls_man_daeName" id="dls_man_daeName"></td>
           		<th class="th_name2">부서</td>
           		<td><input type="text" class="txt_nor sm2 w100" name="dls_man_daeDepart" id="dls_man_daeDepart"></td>
           		<th class="alarm"></th>
           	</tr>
           	<tr>
           		<th class="th_name1">직책</td>
           		<td><input type="text" class="txt_nor sm2 w100" name="dls_man_daePostion" id="dls_man_daePostion"></td>
           		<th class="th_name2">연락처</td>
           		<td><input type="text" class="txt_nor sm2 w100" name="dls_man_daePhone" id="dls_man_daePhone"></td>
           		<th class="alarm"></th>
           	</tr>
           	<tr>
           		<th class="th_name1">이메일</td>
           		<td><input type="text" class="txt_nor sm2 w100" name="dls_man_daeEmail" id="dls_man_daeEmail"></td>
           		<th class="alarm"></th>
           	</tr>
           	<tr>
           		<th colspan="4" style="background: gray; color: white;">용역사 정보</th>
           	</tr>
           	<tr>
   			   	<th>용역사</th>
                <td><input type="text" class="txt_nor sm2 w100" name="dls_man_serCoName" id="dls_man_serCoName"></td>
                <th>담당자명</th>
                <td><input type="text" class="txt_nor sm2 w100" name=dls_man_serName id="dls_man_serName"></td>
            </tr>
            <tr>
               	<th>직책</th>
                <td><input type="text" class="txt_nor sm2 w100" name="dls_man_serDepart" id="dls_man_serDepart"></td>
                <th>연락처</th>
                <td><input type="text" class="txt_nor sm2 w100" name="dls_man_serPhone" id="dls_man_serPhone"></td>
            </tr>
            <tr>
               	<th>이메일</th>
                <td><input type="text" class="txt_nor sm2 w100" name="dls_man_serEmail" id="dls_man_serEmail"></td>
            </tr>
            <tr>
           		<th colspan="4" style="background: gray; color: white;">처리 기관</th>
           	</tr>
           	<tr>
               	<th>지자체명</th>
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