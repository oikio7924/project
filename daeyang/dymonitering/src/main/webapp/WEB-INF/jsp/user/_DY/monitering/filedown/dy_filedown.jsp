<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<style>
input { font-size: 14x; }

.arrow-buttons {
   	display: inline-block;
    vertical-align: middle; /* 화살표 버튼 컨테이너 가운데 정렬 */
    margin-left: 5px; /* 입력 필드와 버튼 사이 간격 */
}

.arrow-button {
    background-color: #f0f0f0; /* 버튼 배경색 */
    border: 1px solid #ccc; /* 테두리 */
    color: #333; /* 텍스트 색상 */
    padding: 0; /* 패딩 제거 */
    text-align: center; /* 텍스트 가운데 정렬 */
    text-decoration: none; /* 밑줄 제거 */
    display: inline-block;; /* 블록 디스플레이 */
    font-size: 12px; /* 폰트 크기 설정 */
    cursor: pointer; /* 포인터/손가락 아이콘 */
    width: 20px; /* 버튼 너비 */
    height: 15px; /* 버튼 높이 */
    box-sizing: border-box; /* 패딩과 테두리를 포함하여 너비를 계산 */
}

.arrow-button i {
    margin: 0; /* 아이콘과 텍스트 사이의 간격 제거 */
}

.arrow-button:active {
    background-color: #e0e0e0; /* 클릭 시 배경색 */
}

.thClass{ width: 50%;}
.buttonClass{ 
    padding: 17px 50px 17px 50px;
    font-size: 16px;
    border-radius: 30px;
	background-color: #709bdb;
    color: #fff;
    }
.file-chosen{
   padding-left: 65px;
}
.downClass{
	float: right;
}
.a_box_line{
	padding-top: 45.5px;
	padding-bottom: 30.5px;
	border-radius: 50%;  /* 완전한 원형을 만들기 위해 50%로 설정 */	
	width: 136px;        /* 버튼의 너비 */
   	height: 136px;       /* 버튼의 높이 */
	text-align: center;  /* 텍스트 가운데 정렬 */
}

 .date-picker-container {
      display: flex;
      align-items: center;
      gap: 8px;
      font-family: sans-serif;
      margin: 20px;
    }

    .date-picker-container input[type="date"] {
      padding: 8px;
      font-size: 16px;
      border-radius: 6px;
      border: 1px solid #ccc;
    }

    .fa-calendar-days {
      color: #666;
      font-size: 18px;
    }


@media screen and (max-width: 900px) {
	.buttonClass{
		padding : 15px;		
	    font-size: 14px;
	    margin : -15px;
	    float: left;
	}
	.file-chosen{
		padding : 0px 0px 0px 45px;
		width : 220px;
		display: block;
		float : left;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}
	.tbl_private_se td{
		padding: 20px;
		height: 60px;
	}
}

.setting_one_wf{
		max-width: 1500px; 
		margin: 0 auto;
		width: 100%;
	}
</style>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" integrity="sha512-KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0g==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/css/select2.min.css"/>

<form:form action="/dy/moniter/DownAction.do?${_csrf.parameterName}=${_csrf.token}" method="POST" id="Form" enctype="multipart/form-data">

<input type="hidden" name="UI_KEYNO" value="${UI_KEYNO }">
<input type="hidden" name="DPP_NAME" value="${ob.DPP_NAME }">
<input type="hidden" name="DPP_FM_KEYNO" id="DPP_FM_KEYNO" value="${ob.DPP_FM_KEYNO }">
<input type="hidden" name="DPP_DLS_KEYNO" id="DPP_DLS_KEYNO" value="${ob.DPP_DLS_KEYNO }">
<input type="hidden" name="isAdmin" id="isAdmin" value="${userInfo.isAdmin}">
<input type="hidden" name="action" id="action" value="">


<div id="container" class="heightAuto">
            
	<section class="setting_one_wf">
	
		<div class="power_select">
		    <select class="select_nor select2 sm3 w100" id="DPP_KEYNO" name="DPP_KEYNO" value="${DPP_KEYNO }" onchange="DPPKey_Change(this.value)">
		        <c:forEach items="${list }" var="list">
		        	<option value="${list.DPP_KEYNO }" ${list.DPP_KEYNO eq DPP_KEYNO ? 'selected' : '' } >${list.DPP_NAME }</option>
		        </c:forEach>
		    </select>
		</div>
	  	
	    <h2 class="circle">발전소 : ${ob.DPP_NAME }</h2>
		<br>
		<article class="artBoard top">
			<h2 class="circle">민원처리 현황</h2>
		
		    <span class="state_b pos">
		    </span>
		    
		    <input type="hidden" value="${dls_now }" name="dls_now" id="dls_now">
		    
		    <div class="table_wrapper con_h" style="text-align: center;">
				<a class="a_box_line active" href="javascript:;" onclick="subView('1')">발전사업<br>허가</a>
				▷
				<a class="a_box_line" href="javascript:;" onclick="subView('2')">개발행위<br>허가</a>
				▷
				<a class="a_box_line" href="javascript:;" onclick="subView('3')">PPA<br>(전력수급계약)</a>
				▷
				<a class="a_box_line" href="javascript:;" onclick="subView('4')">공사계획<br>신고</a>
				▷
				<a class="a_box_line" href="javascript:;" onclick="subView('5')">사용전검사<br>(준공검사)</a>
				▷
				<a class="a_box_line" href="javascript:;" onclick="subView('6')">설비<br>확인</a>
			</div>
			<br><br>
		 <!-- 절차별 모듈 div  -->
		 <div id="jspModule"></div>
		 <br>
		 <!-- 관리자만 -->
			<c:if test="${userInfo.isAdmin eq 'Y'}">
				<div class="table_wrapper con_h">
					<button type="button" id="saveButton" class="btn_nor md2 g_line" style="float: right; font-size: 12px; height: 22px; padding: 1px;" title="저장" onclick="MainSubInsert()">저장</button>
					<input type="hidden" id="savetype" name="savetype" value="">
				</div>
			</c:if>
		</article>
	</section>
	
	<br><br>
    <c:if test="${userInfo.isAdmin eq 'Y'}"> 
    <section class="setting_one_w">
        <article class="artBoard top">
    		
            <div class="private_setting_wrap">
                <table class="tbl_private_se">
                    <colgroup>
                        <col style="width: 20%;">
                        <col style="width: 80%;">
                    </colgroup>
                    <caption>파일 등록</caption>
                    <tbody>
	                        <tr>
	                            <th class="thClass" style="background-color: #709bdb;">파일전체등록</th>
	                            <td class="tdClass">
	                            	<label class="buttonClass" for="fileAll"><i class="fa-solid fa-download" style="padding-right: 10px;"></i>등록</label>
		                            <input class="fileclass" type="file" id="fileAll" name="fileAll" style="display: none;">
		                            <span class="file-chosen" id="spans">
			                            ${RList[status.index].FS_FILE_SIZE != null ? fn:substring(RList[status.index].FS_ORINM,0,13) : '파일없음'}. ${RList[status.index].FS_EXT }
		                            </span>
		                            <button type="button" class="downClass" onclick="cf_download('${KeynoList[status.index]}')" style="display: ${RList[status.index].FS_FILE_SIZE != null ? 'block':'none'}">다운로드</button>
	                            </td>
	                        </tr>
                        <c:forEach var="item" items="${DocuList}" varStatus="status">
	                        <tr id="trRemove${status.index}">
	                            <th class="thClass">${item}</th>
	                            <td class="tdClass">
	                            	<label class="buttonClass" for="file${status.index}"><i class="fa-solid fa-download" style="padding-right: 10px;"></i>등록</label>
		                            <input class="fileclass" type="file" id="file${status.index}" name="file" style="display: none;">
		                            <span class="file-chosen" id="spans">
			                            ${RList[status.index].FS_FILE_SIZE != null ? fn:substring(RList[status.index].FS_ORINM,0,13) : '파일없음'}. ${RList[status.index].FS_EXT }
		                            </span>
		                            <button type="button" class="downClass" onclick="cf_download('${KeynoList[status.index]}')" style="display: ${RList[status.index].FS_FILE_SIZE != null ? 'block':'none'}">다운로드</button>
	                            </td>
	                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="btn_private">
                <button type="submit" class="btn_nor lg2 round2 blue" id="subbutton">저장</button>
                <button type="button" class="btn_nor lg2 round2 blue" id="alldown" onclick="cf_download_zip('${ob.DPP_FM_KEYNO}')">전체다운로드</button>
            </div>
        </article>
    </section>
    </c:if>
</div>
</form:form>

<script src="/resources/smartadmin/js/plugin/select2/select2.min.js"></script>
 <script>
	 $(function(){
		 
		 
		 $('.select2').select2({
			    closeOnSelect: true
			});
		 
 		 subView('${dls_now}');
 		 displayFlash('${dls_now}');
 		 
 		 //절차별 모듈화
		 //pf_PowerGenBusPermit('${dls_now}');
 		 
		 
		 if($("#DPP_FM_KEYNO").val() == "" || $("#DPP_FM_KEYNO").val() == null )
		 	{   
		 		$("#action").val("insert");
		 	}else {
		 		$("#action").val("update"); $("#subbutton").text("수정")
		 	}
		 	
		 	 
			$('.fileclass').on('change',function(obj){
				var fileValue = $(this).val().split("\\");
				var fileName = fileValue[fileValue.length-1]; // 파일명
				
				var id = $(this).attr("id")
				$("#"+id).next().text(fileName.substring(0,13) + "...")		
			})
	 })
 
	function DPPKey_Change(key){
		
		$("#DPP_KEYNO").val(key)
		$("#Form").attr("action", "/dy/moniter/filedown.do?${_csrf.parameterName}=${_csrf.token}");
		$("#Form").submit();
				
	}
	
	 function trinit(){
		 
		 //신청내역(append)
		 $("#dlm_address").val('');
		 $("#dlm_street").val('');
		 $("#dlm_area").val('');
		 $("#dlm_land").val('');
		 $("#dlm_use").val('');
		 $("#dlm_usage").val('');
		 $("#dlm_type").val('');
		 $("#dlm_purpose").val('');
		 $("#dlm_trueAddress").val('');
		 $("#dlm_connDate").val('');
		 $("#dlm_endDate").val('');
		 
		 //신청내역
		 $("#dls_app_plant").val('');
		 $("#dls_app_vol1").val('');
		 $("#dls_app_vol2").val('');
		 $("#dls_app_address").val('');
		 $("#dls_app_form").val('');
		 $("#dls_app_appDate").val('');
		 $("#dls_app_dueDate").val('');
		 $("#dls_app_appNum").val('');
		 $("#dls_app_cusNum").val('');
		 $("#dls_app_appPeriod").val('');
		 $("#dls_app_module").val('');
		 $("#dls_app_inverter").val('');
		 $("#dls_app_appModule").val('');
		 $("#dls_app_weight").val('');
		 $("#dls_app_jsgDate").val('');
		 $("#dls_app_swgDate").val('');
		 $("#dls_app_jgjDate").val('');
		 $("#dls_app_jgpDate").val('');
		 
		 //담당자정보
		 $("#dls_man_ceoName").val('');
		 $("#dls_man_ceoAddress").val('');
		 $("#dls_man_ceoPhone").val('');
		 $("#dls_man_ceoEmail").val('');
		 $("#dls_man_daeName").val('');
		 $("#dls_man_daeDepart").val('');
		 $("#dls_man_daePostion").val('');
		 $("#dls_man_daePhone").val('');
		 $("#dls_man_daeEmail").val('');
		 $("#dls_man_govName").val('');
		 $("#dls_man_govDepart").val('');
		 $("#dls_man_govPhone").val('');
		 $("#dls_man_serCoName").val('');
		 $("#dls_man_serName").val('');
		 $("#dls_man_serDepart").val('');
		 $("#dls_man_serPhone").val('');
		 $("#dls_man_serEmail").val('');
		 $("#dls_man_gamName").val('');
		 $("#dls_man_gamPeriod").val('');
		 
		 //설비구성
		 $("#dls_com_moName").val('');
		 $("#dls_com_moVolum").val('');
		 $("#dls_com_moQuantity").val('');
		 $("#dls_com_moEtc").val('');
		 $("#dls_com_inName").val('');
		 $("#dls_com_invVolum").val('');
		 $("#dls_com_inQuantity").val('');
		 $("#dls_com_inEtc").val('');
		 $("#dls_com_connName").val('');
		 $("#dls_com_connVolum").val('');
		 $("#dls_com_connQuantity").val('');
		 $("#dls_com_connEtc").val('');
		 
	 }
	 
	function subView(value){
		
		$("#dls_now").val(value);
		var isAdmin = $("#isAdmin").val();
		var DPP_DLS_KEYNO = $("#DPP_DLS_KEYNO").val();
		
		
		//파일등록 모듈화
		fileModule(value);
		
		if(isAdmin == 'N'){
			if(value > DPP_DLS_KEYNO){
				alert("절차 진행 전입니다.");
				return false;
			}
		}
		
		//html 랜더링 이후에 데이터가져와서 뿌려주기위한 콜백함수
		pf_PowerGenBusPermit(value, function(){
		
			//init
			trinit();
			
			
			$.ajax({
			    type   : "post",
			    url    : "/dy/moniter/SubdataView.do",
			    data   : {
				    "dls_dpp_keyno":$("#DPP_KEYNO").val(),
				    "dls_now": value
			    },
			    async:false,
			    success:function(data){
			    	
			    	//실무책임자 연동
		    		if(data.licenseManLink){
		    			$("#dls_man_daeName").val(data.licenseManLink.dls_man_daeName);
			    	    $("#dls_man_daeDepart").val(data.licenseManLink.dls_man_daeDepart);
			    	    $("#dls_man_daePostion").val(data.licenseManLink.dls_man_daePostion);
			    	    $("#dls_man_daePhone").val(data.licenseManLink.dls_man_daePhone);
			    	    $("#dls_man_daeEmail").val(data.licenseManLink.dls_man_daeEmail);
		    		}
			    	
			    	if (data.licenseMain?.dlm_address){
			    		var addresslist = data.licenseMain.dlm_address.split(",");
			    		var streetlist = data.licenseMain.dlm_street.split(",");
			    		var arealist = data.licenseMain.dlm_area.split(",");
			    		var landlist = data.licenseMain.dlm_land.split(",");
			    		var uselist = data.licenseMain.dlm_use.split(",");
			    		var useagelist = data.licenseMain.dlm_usage.split(",");
			    		var combinedList = [addresslist,streetlist,arealist,landlist,useagelist,uselist];
			    		
			    		var listlength = streetlist.length;
			    		addInput(listlength, combinedList)
			    		
				    	
				    	if (data.licenseMain.dlm_type == '0'){
				    		$("#dlm_type1").prop("checked", true);
				    		$("#dlm_type2").prop("checked", false);
				    	}else{
				    		$("#dlm_type1").prop("checked", false);
				    		$("#dlm_type2").prop("checked", true);
				    	}
	
			    	    $("#dlm_purpose").val(data.licenseMain.dlm_purpose);
			    	    $("#dlm_trueAddress").val(data.licenseMain.dlm_trueAddress);
			    	    $("#dlm_connDate").val(data.licenseMain.dlm_connDate);
			    	    $("#dlm_endDate").val(data.licenseMain.dlm_endDate);
			    	}
			    	
	
			    	if (data.licenseApp != null){
			    	    $("#dls_app_plant").val(data.licenseApp.dls_app_plant);
			    	    $("#dls_app_vol1").val(data.licenseApp.dls_app_vol1);
			    	    $("#dls_app_vol2").val(data.licenseApp.dls_app_vol2);
			    	    $("#dls_app_address").val(data.licenseApp.dls_app_address);
			    	    $("#dls_app_form").val(data.licenseApp.dls_app_form);
			    	    $("#dls_app_appDate").val(data.licenseApp.dls_app_appDate);
			    	    $("#dls_app_dueDate").val(data.licenseApp.dls_app_dueDate);
			    	    $("#dls_app_appNum").val(data.licenseApp.dls_app_appNum);
			    	    $("#dls_app_cusNum").val(data.licenseApp.dls_app_cusNum);
			    	    $("#dls_app_appPeriod").val(data.licenseApp.dls_app_appPeriod);
			    	    $("#dls_app_module").val(data.licenseApp.dls_app_module);
			    	    $("#dls_app_inverter").val(data.licenseApp.dls_app_inverter);
			    	    $("#dls_app_appModule").val(data.licenseApp.dls_app_appModule);
			    	    $("#dls_app_weight").val(data.licenseApp.dls_app_weight);
			    	    $("#dls_app_jsgDate").val(data.licenseApp.dls_app_jsgDate);
			    	    $("#dls_app_swgDate").val(data.licenseApp.dls_app_swgDate);
			    	    $("#dls_app_jgjDate").val(data.licenseApp.dls_app_jgjDate);
			    	    $("#dls_app_jgpDate").val(data.licenseApp.dls_app_jgpDate);
			    	}
	
			    	if (data.licenseMan != null){
			    		
			    		if(data.licenseMan?.dls_man_type){
				    		if (data.licenseMan.dls_man_type == '0'){
					    		$("#dls_man_type1").prop("checked", true);
					    		$("#dls_man_type2").prop("checked", false);
					    		$("#dls_man_type3").prop("checked", false);
					    	}else if(data.licenseMan.dls_man_type == '1'){
					    		$("#dls_man_type1").prop("checked", false);
					    		$("#dls_man_type2").prop("checked", true);
					    		$("#dls_man_type3").prop("checked", false);
					    	}else{
					    		$("#dls_man_type1").prop("checked", false);
					    		$("#dls_man_type2").prop("checked", false);
					    		$("#dls_man_type3").prop("checked", true);
					    	}
			    		}
			    		
			    	    $("#dls_man_ceoName").val(data.licenseMan.dls_man_ceoName);
			    	    $("#dls_man_ceoAddress").val(data.licenseMan.dls_man_ceoAddress);
			    	    $("#dls_man_ceoPhone").val(data.licenseMan.dls_man_ceoPhone);
			    	    $("#dls_man_ceoEmail").val(data.licenseMan.dls_man_ceoEmail);
			    	    $("#dls_man_daeName").val(data.licenseMan.dls_man_daeName);
			    	    $("#dls_man_daeDepart").val(data.licenseMan.dls_man_daeDepart);
			    	    $("#dls_man_daePostion").val(data.licenseMan.dls_man_daePostion);
			    	    $("#dls_man_daePhone").val(data.licenseMan.dls_man_daePhone);
			    	    $("#dls_man_daeEmail").val(data.licenseMan.dls_man_daeEmail);
			    	    $("#dls_man_govName").val(data.licenseMan.dls_man_govName);
			    	    $("#dls_man_govDepart").val(data.licenseMan.dls_man_govDepart);
			    	    $("#dls_man_govPhone").val(data.licenseMan.dls_man_govPhone);
			    	    $("#dls_man_serCoName").val(data.licenseMan.dls_man_serCoName);
			    	    $("#dls_man_serName").val(data.licenseMan.dls_man_serName);
			    	    $("#dls_man_serDepart").val(data.licenseMan.dls_man_serDepart);
			    	    $("#dls_man_serPhone").val(data.licenseMan.dls_man_serPhone);
			    	    $("#dls_man_serEmail").val(data.licenseMan.dls_man_serEmail);
			    	    $("#dls_man_gamName").val(data.licenseMan.dls_man_gamName);
			    	    $("#dls_man_gamPeriod").val(data.licenseMan.dls_man_gamPeriod);
			    	}
	
			    	if (data.licenseCom != null){
			    	    $("#dls_com_moName").val(data.licenseCom.dls_com_moName);
			    	    $("#dls_com_moVolum").val(data.licenseCom.dls_com_moVolum);
			    	    $("#dls_com_moQuantity").val(data.licenseCom.dls_com_moQuantity);
			    	    $("#dls_com_moEtc").val(data.licenseCom.dls_com_moEtc);
			    	    $("#dls_com_inName").val(data.licenseCom.dls_com_inName);
			    	    $("#dls_com_invVolum").val(data.licenseCom.dls_com_invVolum);
			    	    $("#dls_com_inQuantity").val(data.licenseCom.dls_com_inQuantity);
			    	    $("#dls_com_inEtc").val(data.licenseCom.dls_com_inEtc);
			    	    $("#dls_com_connName").val(data.licenseCom.dls_com_connName);
			    	    $("#dls_com_connVolum").val(data.licenseCom.dls_com_connVolum);
			    	    $("#dls_com_connQuantity").val(data.licenseCom.dls_com_connQuantity);
			    	    $("#dls_com_connEtc").val(data.licenseCom.dls_com_connEtc);
			    	}
			    	
			    	
			    	//관리자아닌사람들 수정 선택불가 처리
			    	guestNone();
			    	
			    	if(!data.licenseMan && !data.licenseMain && !data.licenseApp && !data.licenseCom){
						$("#saveButton").text("저장")
						$("#saveButton").attr("onclick","MainSubInsert('1')")
			    	}else{
			    		$("#saveButton").text("수정")
			    		$("#saveButton").attr("onclick","MainSubInsert('2')")
			    	}
			    	
			    },
			    error: function() {
			    	alert("에러, 관리자에게 문의하세요.");
			    }
			});
	  	});
	}
	
	function reload(){
		
		$.ajax({
		    type   : "post",
		    url    : "/dy/moniter/SubdataView.do",
		    data   : {
			    "dls_dpp_keyno":$("#DPP_KEYNO").val(),
			    "dls_now": "1"
		    },
		    async:false,
		    success:function(data){
		    	
		    	if (data.license2 != null){
		    		
		    		var streetlist = data.license2.dlm_street.split(",");
		    		var arealist = data.license2.dlm_area.split(",");
		    		var landlist = data.license2.dlm_land.split(",");
		    		var uselist = data.license2.dlm_use.split(",");
		    		var combinedList = [streetlist,arealist,landlist,uselist];
		    		
		    		var listlength = streetlist.length;
		    		
		    		$("#dlm_address").val(data.license2.dlm_address);
		    		addInput(listlength, combinedList)
// 			    	$("#dlm_street").val(data.license2.dlm_street);
// 			    	$("#dlm_area").val(data.license2.dlm_area);
// 			    	$("#dlm_land").val(data.license2.dlm_land);
// 			    	$("#dlm_use").val(data.license2.dlm_use);
			    	$("#dlm_usage").val(data.license2.dlm_usage);
			    	
			    	if (data.license2.dlm_type == '1'){
			    		$("#dlm_type").prop("checked", true);
			    		$("#dlm_type2").prop("checked", false);
			    	}else{
			    		$("#dlm_type").prop("checked", false);
			    		$("#dlm_type2").prop("checked", true);
			    	}
		    	}
		    },
		    error: function() {
		    	alert("에러, 관리자에게 문의하세요.");
		    }
		});
	}
	
	function MainSubInsert(type){
		
		$("#savetype").val(type)
		var type2 = $("input[name='dlm_type']:checked").val()
		
		$.ajax({
		    type   : "post",
		    url    : "/dy/moniter/Subdatainsert.do",
		    data   : $('#Form').serializeArray(),
		    async:false,
		    success:function(data){
		    	alert(data);
		    	
		    	if(type == 1 ){
		    		$("#saveButton").text("수정")
		    		$("#saveButton").attr("onclick","MainSubInsert('2')")
		    	}else if(type == 2){
		    		$("#MainsaveButton").text("수정")
					$("#MainsaveButton").attr("onclick","MainSubInsert('4')")
		    	}
		    },
		    error: function() {
		    	alert("에러, 관리자에게 문의하세요.");
		    }
		});
	}
	
	
function addInput(num, list){

	var table = document.getElementById('addTable');
	
	
	//var randRowSpan = $("#randRowSpan").attr("rowspan");
	var locationRowSpan = $("#locationRowSpan").attr("rowspan");
	//var randRowSpanNum = Number(randRowSpan);
	var locationRowSpanNum = Number(locationRowSpan);
	
	if(num != null){
	//	$("#randRowSpan").attr("rowspan",randRowSpanNum+(num-1));
		$("#locationRowSpan").attr("rowspan",locationRowSpanNum+(num-1));	
	}else{
	//	$("#randRowSpan").attr("rowspan",randRowSpanNum+1);
		$("#locationRowSpan").attr("rowspan",locationRowSpanNum+1); //rowspan값 +1
	}
	
	locationRowSpan = $("#locationRowSpan").attr("rowspan");
	locationRowSpanNum = Number(locationRowSpan);

	
	
	if(list != null){
		
		$("#dlm_address").val(list[0][0]);
	    $("#dlm_street").val(list[1][0]);
	    $("#dlm_area").val(list[2][0]);
	    $("#dlm_land").val(list[3][0]);
	    $("#dlm_usage").val(list[4][0]);
	    $("#dlm_use").val(list[5][0]);
		
		for(i=1; i<num; i++){
			var Rowfor = table.insertRow(i+5);
			CellInput(Rowfor, 0, 'dlm_address', list[0][i]);
			CellInput(Rowfor, 1, 'dlm_street', list[1][i]);
			CellInput(Rowfor, 2, 'dlm_area', list[2][i]);
			CellInput(Rowfor, 3, 'dlm_land', list[3][i]);
			CellInput(Rowfor, 4, 'dlm_usage', list[4][i]);
			CellInput(Rowfor, 5, 'dlm_use', list[5][i]);
		}
	}else{
		var Row = table.insertRow(locationRowSpanNum+2);
		CellInput(Row, 0, 'dlm_address', '');
		CellInput(Row, 1, 'dlm_street', '');
		CellInput(Row, 2, 'dlm_area', '');
		CellInput(Row, 3, 'dlm_land', '');
		CellInput(Row, 4, 'dlm_usage', '');
		CellInput(Row, 5, 'dlm_use', '');
	}
	
}
	
function CellInput(row, cellIndex, inputName, inputValue) {
	
       var cell = row.insertCell(cellIndex);
       cell.style.padding = '0px';
       cell.innerHTML = '<input type="text" class="txt_nor sm2 w100" style="width: 93%" name="'+inputName+'" value="'+inputValue+'">';
   }
	
function deleteInput(){
	
	var table = document.getElementById('addTable');
	
	//var randRowSpan = $("#randRowSpan").attr("rowspan");
	var locationRowSpan = $("#locationRowSpan").attr("rowspan");
	//var randRowSpanNum = Number(randRowSpan);
	var locationRowSpanNum = Number(locationRowSpan);
	
	if(locationRowSpan != 3){
		//$("#randRowSpan").attr("rowspan",randRowSpanNum-1);
		$("#locationRowSpan").attr("rowspan",locationRowSpanNum-1);	
		table.deleteRow(locationRowSpanNum+2);
	}
}
	
	
function pf_PowerGenBusPermit(value, callback){
		
	$.ajax({
	    type   : "post",
	    url    : "/dy/moniter/fileDownAjax.do",
	    data   : {
	    	"page" : value
	    	},
	    async:true,
	    success:function(data){
	    	$("#jspModule").html(data);
	    	setTimeout(callback, 10);
	    },
	    error: function() {
	    	alert("에러, 관리자에게 문의하세요.");
	    }
	});
}
	
	
function fileModule(value){
	
	var bshList = [0,1,2,3,4,5,6];
	var ghhList = [7,3,8,9,10,11,12,5,13];
	var ppaList = [14,15,16,17,18,3,4,19,20,21]; 
	var ggsList = [22,23,19,20,5,24]; 
	var sjgList = [25,23,26,19,20,10,11,27,28,29,5]; 
	var sbhList = [30,16,17,18,31,32,33,34,35,36,10,11,5,37,38]; 
	
	for(i=0; i<=38; i++){
		$("#trRemove"+i).hide();
	}
	if(value == "1"){
		bshList.forEach(function(bsh){
			$("#trRemove"+bsh).show();
		});
	}else if(value == "2"){
		ghhList.forEach(function(ghh){
			$("#trRemove"+ghh).show();
		});
	}else if(value == "3"){
		ppaList.forEach(function(ppa){
			$("#trRemove"+ppa).show();
		});
	}else if(value == "4"){
		ggsList.forEach(function(ggs){
			$("#trRemove"+ggs).show();
		});
	}else if(value == "5"){
		sjgList.forEach(function(sjg){
			$("#trRemove"+sjg).show();
		});
	}else if(value == "6"){
		sbhList.forEach(function(sbh){
			$("#trRemove"+sbh).show();
		});
	}
}

//현황 active class 추가 및 현재 현황 깜빡거림
function displayFlash(value){
	
	$("#container > section:nth-child(1) > article > div:nth-child(4) > a").removeClass("active");
	
	for(i=1; i<=value-1; i++){
		$("#container > section:nth-child(1) > article > div:nth-child(4) > a:nth-child("+i+")").addClass("active");
	}
	
	 setInterval(function() {
	    let $target = $("#container > section:nth-child(1) > article > div:nth-child(4) > a:nth-child("+value+")");
	    
	    if ($target.hasClass("active")) {
	        $target.removeClass("active"); 
	    } else {
	        $target.addClass("active");
	    }
	}, 500);
}

//예정일 계산
function updateDueDate(appDateId, dueDateId){
	
	var appDateInput = document.getElementById(appDateId);
	var dueDateInput = document.getElementById(dueDateId);
	if (!appDateInput || !dueDateInput) return;
	
	var appDateValue = appDateInput.value;
    if (!appDateValue) return;

    var appDate = new Date(appDateValue);
    var startDate = new Date(appDate); // 시작일 따로 저장
    
    appDate.setDate(appDate.getDate() + 90);
	
    var startYear = startDate.getFullYear();
    var startMonth = String(startDate.getMonth() + 1).padStart(2, "0");
    var startDay = String(startDate.getDate()).padStart(2, "0");
    var startDateStr = startYear+"-"+startMonth+"-"+startDay;
    
    var year = appDate.getFullYear();
    var month = String(appDate.getMonth() + 1).padStart(2, "0");
    var day = String(appDate.getDate()).padStart(2, "0");
    var dueDateStr = year+"-"+month+"-"+day;
    
    if(dueDateId == "dls_app_appPeriod"){
    	dueDateStr = startDateStr+" ~ "+dueDateStr;
    }

    dueDateInput.value = dueDateStr;

}


function guestNone(){
	
	var isAdmin = $("#isAdmin").val();
	
	if (isAdmin != 'Y') {
		$("#guestNoneView").hide();
		
		var tds = document.getElementsByTagName("td");
		
		for(var i=0; i<tds.length; i++){
			
			var td = tds[i];
			var inputs = td.getElementsByTagName("input");
		
			for(j=0; j<inputs.length; j++){
				var el = inputs[j];
				if (el.tagName === "INPUT" && el.type !== "checkbox" && el.type !== "radio") {
				      el.readOnly = true;
				    } else {
				      el.disabled = true;
				    }
			}
		}
    }
}

function onRadioChange(value) {
	  var name = '', depart = '', postion = '', phone = '', email = '';

	  if (value == 0) {
	    name = '김형민';
	    depart = '사업개발부';
	    postion = '부장';
	    phone = '010-2024-8086';
	    email = 'daeyang0715@naver.com';
	  } else if (value == 1) {
	    name = '김정묵';
	    depart = '사업개발부';
	    postion = '부장';
	    phone = '010-3193-6003';
	    email = 'daeyang0715@naver.com';
	  } else if (value == 2) {
	    name = '황재현';
	    depart = '사업개발부';
	    postion = '주임';
	    phone = '010-2609-9322';
	    email = 'daeyang0715@naver.com';
	  }

	  $("#dls_man_daeName").val(name);
	  $("#dls_man_daeDepart").val(depart);
	  $("#dls_man_daePostion").val(postion);
	  $("#dls_man_daePhone").val(phone);
	  $("#dls_man_daeEmail").val(email);
	}


function validationCheck(){
	if($("#dlm_address").val() == ''){
		alert("지번 입력해주세요");
		return false
	}else if($("#dlm_street").val() == ''){
		alert("신청지번을 입력해주세요");
		return false
	}else if($("#dlm_area").val() == ''){
		alert("필지면적을 입력해주세요");
		return false
	}else if($("#dlm_land").val() == ''){
		alert("지목 입력해주세요");
		return false
	}else if($("#dlm_usage").val() == ''){
		alert("용도지역를 입력해주세요");
		return false
	}else if($("#dlm_use").val() == ''){
		alert("용도지구를 입력해주세요");
		return false
	}else if($("#dlm_type").val() == ''){
		alert("신청구분을 선택해주세요");
		return false
	}else if($("#dlm_trueAddress").val() == ''){
		alert("주소를 입력해주세요");
		return false
	}else if($("#dlm_connDate").val() == ''){
		alert("허가접수일을 입력해주세요");
		return false
	}else if($("#dlm_endDate").val() == ''){
		alert("허가처리예정일을 입력해주세요");
		return false
	}
	return true	
}

</script>
 
 
                

