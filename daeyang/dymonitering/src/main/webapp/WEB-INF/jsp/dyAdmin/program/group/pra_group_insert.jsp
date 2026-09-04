<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>

.jarviswidget-color-blueDark .nav-tabs li:not(.active) a {color:#333 !important;}
.popover {
z-index: 1052;
}
</style>
<script>
var GroupCnt = '${GroupCnt}'
function pf_applyLimit(){
	if(GroupCnt != null && GroupCnt != 0){
		alert("신청자가 있는 프로그램은 스케줄을 변경 하실 수 없습니다.");
		return false;
	}else{
		return true;
	}
}

function pf_programAction(type){
	$('#action').val(type);
	if(type != 'delete'){
		 if(!$("#GM_DIVISION").val()){
			 alert("프로그램 구분을 선택해주세요.");
			 $("#GM_DIVISION").focus();
			 return false;
		 }
		 
		 if(!$("#GM_PLACE").val()){
			 alert("장소를 선택해주세요.");
			 $("#GM_PLACE").focus()
			 return false;
		 }
		
		 if(!$("#GM_HOLIDAY").val()){
			 alert("휴일관리를 선택해주세요.");
			 $("#GM_HOILDAY").focus();
			 return false;
		 }
		 
		 if(!$("#GM_MINIMUM").val()){
			 alert("최소 인원수를 입력해주세요.");
			 $("#GM_MINIMUM").focus()
			 return false;
		 }
		 
		 if(!$("#GM_MAXIMUM").val()){
			 alert("최대 인원수를 입력해주세요.");
			 $("#GM_MAXIMUM").focus()
			 return false;
		 }
		
		 if(!$("#GM_NAME").val().trim()){
			 alert("프로그램 명을 입력해주세요.");
			 $("#GM_NAME").focus();
			 return false;
		 }
		 
		 if(!$("#GM_DATE").val().trim()){
			 alert("프로그램 일시를 입력해주세요.");
			 $("#GM_DATE").focus();
			 return false;
		 }
		 
		 if(!$("#GM_INTRODUCE").val().trim()){
			 alert("프로그램 소개를 입력해주세요.");
			 $("#GM_INTRODUCE").focus();
			 return false;
		 }
		 
		 if(!$("#GM_SUMMARY").val().trim()){
			 alert("프로그램 내용을 입력해주세요.");
			 $("#GM_SUMMARY").focus();
			 return false;
		 }
		 if(scheduleList.length < 1){
			alert('스케줄을 등록하여주세요.');
			$('.nav-tabs li a').eq(1).trigger('click');
			return false;
		}
		 $('#schduleGroupData').val(JSON.stringify(scheduleList));	//배열을 스트링 형태로 저장하기
	}
	
	if(type == 'insert'){
		type = '등록';
	}else if(type == 'update'){
		type = '수정';
	}else{
		type = '삭제';
	}
	
	if(confirm(type+'하시겠습니까?')){
		if(type == '삭제' && GroupCnt != null && GroupCnt != 0){
	        cf_smallBox('error', '신청자가 있는 프로그램은 삭제하실 수 없습니다.', 3000,'#d24158');
	      }else{
		cf_replaceTrim($("#Form"));
 		$("#Form").attr("action", "/dyAdmin/program/group/action.do");
		$("#Form").submit();
	     }
	}
}

function pf_mixNum(type){
	 var min = $("#GM_MINIMUM");
	 var max = $("#GM_MAXIMUM");
	 
	 
	 if(!min.val() && type == 'max'){
		 alert('최소인원수를 먼저 입력하여주세요.');
		 max.val("");
		 min.focus();
		 return false;
	 }
	 
	 if(min.val() && parseInt(min.val()) < 10){
		 alert("기본 최소인원은 10명입니다.");
		 min.val("");
		 min.focus();
		 return false;
	 }else{
		 if(parseInt(max.val()) < parseInt(min.val())){
			 alert("최대 인원수가 최소 인원수보다 더 적습니다.");
			 $("#GM_MAXIMUM").val("");
			 $("#GM_MAXIMUM").focus();
			 return false;
		 }		 
	 }
}	
function pf_mixNum2(obj){
	 var min = $("#GM_MINIMUM");
	 var cnt = $(obj).val();
	 if(parseInt(cnt) < parseInt(min.val())){
		 alert('최소인원수보다 더 적습니다.');
		 $(obj).val('');
		 return false;
	 }
}	
</script>

<form:form id="Form" action="/dyAdmin/program/group/action.do">
	<input type="hidden" name="schduleGroupData" id="schduleGroupData" value="">
	<input type="hidden" name="GM_KEYNO" id="GM_KEYNO" value="${DetailData.GM_KEYNO }">
	<input type="hidden" name="GM_MN_HOMEDIV_C" id="GM_MN_HOMEDIV_C" value="${GM_MN_HOMEDIV_C}">
	<input type="hidden" id="action" name="action" value="${action}" />
<!-- widget grid -->
<section id="widget-grid" class="">
	<div class="row">
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
			<!-- Widget ID (each widget will need unique ID)-->
			<div class="jarviswidget jarviswidget-color-blueDark" id="wid-id-0"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<c:if test="${action eq 'insert' }">
						<h2>단체예약프로그램 생성하기</h2>
					</c:if>
					<c:if test="${action eq 'update' }">
						<h2>단체예약프로그램 수정하기</h2>
					</c:if>

				</header>
				<!-- widget div-->
				<div  class="smart-form">
					<!-- widget edit box -->
					<div class="jarviswidget-editbox">
						<!-- This area used as dropdown edit box -->

					</div>
					<!-- end widget edit box -->
					
					<!-- widget content -->
					<div class="widget-body">

						<div class="tab-content">
							<div class="tab-pane active">

								<ul class="nav nav-tabs" style="position: relative;">
									<li class="active">
										<a href="#iss1" data-toggle="tab" aria-expanded="false">프로그램 관리</a>
									</li>
									<li class="">
										<a href="#iss2" data-toggle="tab" aria-expanded="false">스케줄 관리</a>
									</li>
								</ul>
								<div class="tab-content padding-10" style="padding: 0;">
									<div class="tab-pane fade active in" id="iss1">
										<%@ include file="manager/pra_group_program.jsp" %>
									</div>
									<div class="tab-pane fade" id="iss2">
										<%@ include file="manager/pra_group_schedule.jsp" %>	
									</div>
								</div>
							</div>
						</div>
					</div>
					<footer class="padding-10 text-right"> 
						<button class="btn btn-sm btn-default" id="Insert_Cencle" type="button" onclick="cf_back('/dyAdmin/program/group/program.do');"> 
							<i class="fa fa-times"></i> 목록
						</button> 
						<c:if test="${action eq 'insert'}" >
							<button class="btn btn-sm btn-primary" id="programInsert"	type="button" onclick="pf_programAction('${action}')">	
								<i class="fa fa-floppy-o"></i> 저장
							</button>
						</c:if>
						
						<c:if test="${action eq 'update'}" >
							<button class="btn btn-sm btn-danger" type="button" onclick="pf_programAction('delete')">	
								<i class="fa fa-floppy-o"></i> 삭제
							</button>
							<button class="btn btn-sm btn-primary" id="programInsert"	type="button" onclick="pf_programAction('${action}')">	
								<i class="fa fa-floppy-o"></i> 수정
							</button>
						</c:if>
					</footer>			
					<!-- end widget content -->
				</div>
				<!-- end widget div -->
			</div>
			
			<!-- end widget -->
		</article>
	</div>
</section>
<!-- end widget grid -->
</form:form>