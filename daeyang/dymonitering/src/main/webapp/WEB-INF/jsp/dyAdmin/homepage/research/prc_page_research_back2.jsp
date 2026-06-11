<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<form:form id="PageForm">
	<fmt:parseNumber value="${fn:substring(currentMenu.MN_KEYNO,4,20)}" var="menuKey"/>
	<input type="hidden" name="TPS_MN_KEYNO" id="TPS_MN_KEYNO" value="${menuKey}"/>
	<input type="hidden" name="TPS_SCORE_NAME" id="TPS_SCORE_NAME"/>
	<c:set value="${(not empty currentMenu.MN_DU_KEYNO && currentMenu.MN_DU_KEYNO eq 'DU_0000000000') ? currentMenu.MN_MANAGER_DEP : currentMenu.PAGE_DEPARTMENT}" var="MANAGER_DEP"/>
	<c:set value="${(not empty currentMenu.MN_DU_KEYNO && currentMenu.MN_DU_KEYNO eq 'DU_0000000000') ? currentMenu.MN_MANAGER : currentMenu.PAGE_NAME }" var="MANAGER"/>
	<c:set value="${(not empty currentMenu.MN_DU_KEYNO && currentMenu.MN_DU_KEYNO eq 'DU_0000000000') ? currentMenu.MN_MANAGER_TEL : currentMenu.PAGE_TEL }" var="MANAGER_TEL"/>
	<article class="sub-survey-wrap">
         <div class="sub-survey-box">
             <div class="detail-info-b clearfix">
                 <div class="letter-b left">
                     <span class="icon icon1"></span>
                     <span class="txt">담당부서 : ${MANAGER_DEP}</span>
                 </div>
                 <div class="letter-b left">
                     <span class="icon icon2"></span>
                     <span class="txt">담당자 : ${MANAGER }</span>
                 </div>
                 <div class="letter-b left">
                     <span class="icon icon3"></span>
                     <span class="txt">연락처 : ${MANAGER_TEL}</span>
                 </div>
                 <div class="letter-b right">
                     <span class="icon icon4"></span>
                     <span class="txt">최종수정일 : ${currentMenu.MN_MODDT == null || empty currentMenu.MN_MODDT ? fn:substring(currentMenu.MN_REGDT,0,10) : fn:substring(currentMenu.MN_MODDT,0,10) }</span>
                 </div>
             </div>

             <div class="survey-content-box">
                 <div class="icon-box">
                     <img src="/resources/tour/img/icon/icon_bottom_survey_02.png" alt="아이콘">
                 </div>
                 <div class="content-b">
                     <h3>이 페이지에서 제공하는 정보에 만족하시나요?</h3>
                     <div class="radio-box">
                         <label><input type="radio" name="TPS_SCORE"  value="5" checked="true"> <span>매우만족</span></label>
                         <label><input type="radio" name="TPS_SCORE"  value="4"> <span>만족</span></label>
                         <label><input type="radio" name="TPS_SCORE"  value="3"> <span>보통</span></label>
                         <label><input type="radio" name="TPS_SCORE"  value="2"> <span>불만족</span></label>
                         <label><input type="radio" name="TPS_SCORE"  value="1"> <span>매우불만족</span></label>
                     </div>
                     <div class="input-box">
                         <div class="text-b">
                             <textarea class="textAreaHealing" name="TPS_COMMENT" maxlength="2000"></textarea>
                         </div>
                         <div class="btn-b">
                             <button type="button" onclick="pf_insert()">등록하기</button>
                         </div>
                     </div>
                 </div>
             </div>
         </div>
	 </article>
</form:form>
<script>
function pf_insert(){
	var checkval = $("input[type=radio][name=TPS_SCORE]:checked").val()
	if(checkval == "5")
		$("#TPS_SCORE_NAME").val("매우만족");
	if(checkval == "4")
		$("#TPS_SCORE_NAME").val("만족");
	if(checkval == "3")
		$("#TPS_SCORE_NAME").val("보통");
	if(checkval == "2")
		$("#TPS_SCORE_NAME").val("불만족");
	if(checkval == "1")
		$("#TPS_SCORE_NAME").val("매우불만족");
	
	var menu = $("#TPS_MN_KEYNO").val();
	var satisfaction = $("input[name=TPS_SCORE]:radio:checked").val();
	if(!satisfaction){
		alert("만족도를 선택하세요.");
		return false;
	}

	$.ajax({
	    type   : "POST",
	    url    : "/common/page/satisfaction/satisfactionInsert.do",
	    data   : $("#PageForm").serialize(),
	    async:false,
	    success:function(result){
// 	    	$("input:radio[name='TPS_SCORE']").removeAttr('checked');
	    	$(".textAreaHealing").val("");
	    	if(result == 1){
	    		alert("평가가 완료되었습니다.");
// 	    		$("input[type=radio][name=TPS_SCORE][value='5']").prop('checked',true);
	    	}else if(result == 0){
	    		alert("평가는 하루에 한번씩만 가능합니다.");
	    	}
	    },
	    error: function() {
	    	alert("에러, 관리자에게 문의하세요.");
	    }
	});

}
</script>