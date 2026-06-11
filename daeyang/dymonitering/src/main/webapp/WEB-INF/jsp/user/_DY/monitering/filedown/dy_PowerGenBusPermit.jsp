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
           		<th colspan="4" style="background: gray; color: white;">발전사업자</th>
           	</tr>
           <tbody>
           	<tr class="tr1">
           		<th class="th_name1">상호(대표자 명)</td>
           		<td><input type="text" class="txt_nor sm2 w100" name="dls_man_ceoName" id="dls_man_ceoName"></td>
           		<th class="th_name2">주소</td>
           		<td><input type="text" class="txt_nor sm2 w100" name="dls_man_ceoAddress" id="dls_man_ceoAddress"></td>
           		<th class="alarm"></th>
           	</tr>
           	<tr>
           		<th class="th_name1">연락처</td>
           		<td><input type="text" class="txt_nor sm2 w100" name="dls_man_ceoPhone" id="dls_man_ceoPhone"></td>
           		<th class="th_name2">이메일</td>
           		<td><input type="text" class="txt_nor sm2 w100" name="dls_man_ceoEmail" id="dls_man_ceoEmail"></td>
           		<th class="alarm"></th>
           	</tr>
           	<tr>
           		<th colspan="4" style="background: gray; color: white;">허가신청내역</th>
           	</tr>
           	<tr>
   			   	<th>발전소명</th>
                <td><input type="text" class="txt_nor sm2 w100" name="dls_app_plant" id="dls_app_plant"></td>
                <th>허가용량</th>
                <td><input type="text" class="txt_nor sm2 w100" name=dls_app_vol1 id="dls_app_vol1"></td>
            </tr>
            <tr>
               	<th>발전소 소재지</th>
                <td><input type="text" class="txt_nor sm2 w100" name="dls_app_address" id="dls_app_address"></td>
                <th>설치 형식</th>
                <td><input type="text" class="txt_nor sm2 w100" name="dls_app_form" id="dls_app_form"></td>
            </tr>
            <tr>
               	<th>허가 접수일</th>
                <td><input type="date" class="txt_nor sm2 w100"name="dls_app_appDate" id="dls_app_appDate" onchange="updateDueDate('dls_app_appDate','dls_app_dueDate')"></td>
                <th>허가 처리예정일</th>
                <td><input type="text" class="txt_nor sm2 w100" name="dls_app_dueDate" id="dls_app_dueDate"></td>
            </tr>
           	<tr>
           		<th colspan="4" style="background: gray; color: white;">실무담당자</th>
           	</tr>
           	<tr id="guestNoneView">
           		<td colspan="4" style="text-align: center;">
           		<span>
     				<input type="radio" value="0" title="김형민" name="dls_man_type" id="dls_man_type1" onchange="onRadioChange(this.value);">
     				<label for="dls_man_type1">김형민</label>
     			</span>
     			<span style="padding: 0px 0px 0px 100px;">
     				<input type="radio" value="1" title="김정묵" name="dls_man_type" id="dls_man_type2" onchange="onRadioChange(this.value);">
     				<label for="dls_man_type2">김정묵</label>
     			</span>
     			<span style="padding: 0px 0px 0px 100px;">
     				<input type="radio" value="2" title="황재현" name="dls_man_type" id="dls_man_type3" onchange="onRadioChange(this.value);">
     				<label for="dls_man_type3">황재현</label>
     			</span>
     			</td>
           	</tr>
           	<tr>
                <th>담당자</th>
                <td><input type="text" class="txt_nor sm2 w100" name="dls_man_daeName" id="dls_man_daeName"></td>
                <th>담당부서</th>
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
               	<th>지자체명</th>
                <td><input type="text" class="txt_nor sm2 w100" name="dls_man_govName" id="dls_man_govName"></td>
                <th>부서</th>
                <td><input type="text" class="txt_nor sm2 w100" name="dls_man_govDepart" id="dls_man_govDepart"></td>
              </tr>
          	  <tr>
               	<th>연락처</th>
                <td><input type="text" class="txt_nor sm2 w100" name="dls_man_govPhone" id="dls_man_govPhone"></td>
              </tr>
              <tr>
           </tbody>
       </table>
</div>