<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<script src="/resources/api/mask/jquery.mask.js"></script>
<link rel="stylesheet" type="text/css" href="/resources/api/FrontMArte/css/ticket_2.css"/>
<link href="/resources/common/css/calendar/TronixCalendar2.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="/resources/common/css/program.css">
<style>
/* 수강대상자 팝업 */
.tableWrap {width: 95%; margin: 0 auto; }
.UserTable{width: 100%; }
#tour_contents_pop_box{width: 450px; height: 380px;	}
.contents_pop_title{line-height: 40px;}
</style>

<section id="widget-grid" class="">
	<!-- row -->
	<div class="subRightContentsBottomWrap">
	<div class="subRealTitleBox">
		<h1>예매내역</h1>
	</div>
		<div class="subRealContentsBox">
			<iframe id="applyFrame" class="programApplyList iFrame" src="/dy/mypage/applycheck/program/iframe.do?type=A" scrolling=no ></iframe>  
		</div>
	</div>
	
	<!-- row -->
	<div class="subRightContentsBottomWrap">
	<div class="subRealTitleBox">
		<h1>수강신청내역</h1>
	</div>
		<div class="subRealContentsBox">
			<iframe id="leactureFrame" class="programLectureList iFrame" src="/dy/mypage/applycheck/program/iframe.do?type=L" scrolling=no ></iframe>  
		</div>
	</div>
	
	<!-- row -->
	<div class="subRightContentsBottomWrap">
	<div class="subRealTitleBox">
		<h1>예약 /신청 내역</h1>
	</div>
		<div class="subRealContentsBox">
			<iframe id="tuorFrame" class="TourApplyList iFrame" src="/dy/mypage/applycheck/tour/iframe.do" scrolling=no ></iframe>  
		</div>
	</div>
</section>

<!-- end widget grid -->
<form:form id="Form" method="post">
	<input type="hidden" id="GP_KEYNO" name="GP_KEYNO">
	<input type="hidden" name="tourPageInfo" id="tourPageInfo" value="${Groupsearch.pageIndex}">
</form:form>

 <!-- 수강대상자 폼 -->
<form:form id="UserForm" method="post">
	<input type="hidden" name="APU_UI_KEYNO" id="APU_UI_KEYNO" value="${userInfo.UI_KEYNO }">
	<input type="hidden" name="APU_NAME" id="APU_NAME" value="">
	<input type="hidden" name="APU_KEYNO" id="APU_KEYNO" value="">
	<input type="hidden" name="APU_RELATION" id="APU_RELATION"  value="">
	<input type="hidden" name="APU_PHONE" id="APU_PHONE"  value="">
	<input type="hidden" name="APU_BIRTH" id="APU_BIRTH"  value="">
	<input type="hidden" name="APU_GENDER" id="APU_GENDER"  value="">
</form:form>
      
<!-- 수강대상자 등록 -->
<div id="tour_contents_pop_box" tabindex="0" style="display: none;">
	<div id="tour_contents_bg_box"></div>
	<div class="pop-container"> 
		<div class="pop-conts">
			<div class="contents_pop_header"> 
				<div class="contents_pop_title">수강대상자 등록</div>
				<a href="javascript:;" class="contents_pop_cbtn" style="text-align: right;">
					<img src="/resources/img/calendar/close_btn.gif" alt="닫기" style="max-width: 80%;">
				</a>
			</div>
			<div>
				<h2 class="dis-h5" style="margin: 15px 0 0 10px; float: none;"><span class="line-h5"></span>수강생 정보를 입력 해 주세요</h2>
				<div class="tableWrap">
					<table class="UserTable">
						<caption>수강생등록 테이블</caption>
						<colgroup>
							<col width="40%">
							<col width="60%">
						</colgroup>
							<tbody>
								<tr>
									<th>이름</th>
									<td><input type="text" id="APUNAME" class="userAdd" maxlength="25"/></td>
								</tr>	
								<tr>
									<th>성별</th>
									<td>
										<label for="GENDER_M">
											<input type="radio" id="GENDER_M" name="GENDER" value="M"/>남자
										</label>
										<label for="GENDER_W">
											<input type="radio" id="GENDER_W" name="GENDER" value="W"/>여자
										</label>
									</td>
								</tr>	
								<tr>
									<th>관계</th>
									<td>
										<label for="RELATION_C">
											<input type="radio" id="RELATION_C"  name="RELATION" value="자녀"/>자녀
										</label>
										<label for="RELATION_P">
											<input type="radio" id="RELATION_P"  name="RELATION" value="배우자"/>배우자
										</label>
										<label for="RELATION_E">
											<input type="radio" id="RELATION_E"  name="RELATION" value="기타"/>기타
										</label>
									</td>
								</tr>	
								<tr>
									<th>휴대폰 번호</th>
									<td>
										<input class="userAdd" id="APUPHONE" type="text" placeholder="ex) 000-0000-0000" onkeyup="pf_autoHypenPhone(this,this.value)" maxlength="13"/>
									</td>
								</tr>	
								<tr>
									<th>생년월일</th>
									<td>
										<input class="userAdd" id="APUBIRTH" type="text" placeholder="ex) 1999-01-01" onblur="pf_birth();"/>
									</td>
								</tr>	
							</tbody>
					</table>
					<div class="popup-bottom-btn mt20">
			            <button type="button" class="btn-popup-sav focusPoint" onclick="pf_family_regist('${userInfo.UI_KEYNO }');">저장</button>
			            <button type="button" class="btn-popup-cancel">닫기</button>
			        </div>
				</div>
			</div>
			<div class="contents_pop_footer"></div>   
		</div>
	</div>
</div>


<div id="pop_bg_opacity"></div>  
<div class="clear"></div>    
<script type="text/javascript">

//화면 호출시 가장 먼저 호출되는 부분
$(function(){
	$("#APUBIRTH").mask('0000-00-00');
});

//수강신청자 다이얼로그 오픈
function AllWrap(){
	$("#pop_bg_opacity").fadeIn();
	//투명막씌우기
	$(".contents_pop_footer").show();
	$("#tour_contents_pop_box").show(); 
	$("html").css("overflow-y", "hidden");
	$("body").css("overflow-y", "hidden");
	var temp = $("#tour_contents_pop_box");
	
	// 화면의 중앙에 레이어를 띄운다.  
// 	if (temp.outerHeight() < $(document).height() ) temp.css('margin-top', '-'+temp.outerHeight()/2+'px');
// 	else temp.css('top', '0px');
// 	if (temp.outerWidth() < $(document).width() ) temp.css('margin-left', '-'+temp.outerWidth()/2+'px');
// 	else temp.css('left', '0px'); 

	var windowWidth = $(window).width() / 2;
	var windowHeight = $(window).height() / 2;
	var width =$("#tour_contents_pop_box").width() /2; 
	var height = $("#tour_contents_pop_box").height() /2;
	temp.css({
		top : windowHeight - height,
		left : windowWidth - width
	});
	// 레이어팝업 닫기 처리
	temp.find('a.contents_pop_cbtn, .btn-popup-cancel').click(function(e){ 
		$("html").css("overflow-y", "");
		$("body").css("overflow-y", ""); 
		$("#pop_bg_opacity").fadeOut(); 
		$("#tour_contents_pop_box").hide();   
	}); 
	$("#tour_contents_pop_box").focus();
}

function pf_reset(){
	$(".userAdd").val("");
	$("input[name=RELATION]").prop("checked", false);
	$("input[name=GENDER]").prop("checked", false);		
}

//휴대폰번호
function pf_autoHypenPhone(obj,str){
 str = str.replace(/[^0-9]/g, '');
 var tmp = '';
 if(str.length < 4){
     tmp += str;
 }else if(str.length < 7){
     tmp += str.substr(0, 3);
     tmp += '-';
     tmp += str.substr(3);
 }else if(str.length < 11){
     tmp += str.substr(0, 3);
     tmp += '-';
     tmp += str.substr(3, 3);
     tmp += '-';
     tmp += str.substr(6);
 }else{              
     tmp += str.substr(0, 3);
     tmp += '-';
     tmp += str.substr(3, 4);
     tmp += '-';
     tmp += str.substr(7);
 }
 $(obj).val(tmp)
}

//수강생 추가
function pf_family_regist(key){
	var gender = $(':input[name=GENDER]:radio:checked').val();
	var relation = $(':input[name=RELATION]:radio:checked').val();
	if(!$("#APUNAME").val()){
		alert("이름을 입력해주세요.");
		$("#APUNAME").focus();
		return false;
	}
	if(!gender){
		alert("성별을 선택해주세요.");
		return false;
	}
	if(!relation){
		alert("관계를 선택해주세요.");
		return false;
	}
	if(!$("#APUPHONE").val()){
		alert("휴대폰 번호를 입력해주세요.");
		$("#APUPHONE").focus();
		return false;
	}
	if(!$("#APUBIRTH").val()){
		alert("생년월일을 입력해주세요.");
		$("#APUBIRTH").focus();
		return false;
	}
	$("#APU_NAME").val($("#APUNAME").val());
	$("#APU_RELATION").val(relation);
	$("#APU_PHONE").val($("#APUPHONE").val());
	$("#APU_BIRTH").val($("#APUBIRTH").val());
	$("#APU_GENDER").val(gender);
	
	if(!$("#APU_KEYNO").val()){
		$.ajax({
		    type   : "POST",
		    url    : "/dy/function/userInsertAjax.do",
		    data   : $("#UserForm").serialize(),
		    async:false,
		    success:function(data){
		    	$("html").css("overflow-y", "");
				$("body").css("overflow-y", ""); 
				$("#pop_bg_opacity").fadeOut(); 
				$("#tour_contents_pop_box").hide();  
				var apukey = cf_setKeyno(data.APU_KEYNO);
				var temp =  '<tr>';
	    			temp += '<th><span class="apuName">'+data.APU_NAME+'</span><span class="bracket">(</span><span class="apuRelation">'+data.APU_RELATION+'</span><span class="bracket">)</span></th>';
	    			temp += '<td><span class="apuPhone">'+data.APU_PHONE+'</span> <span style="margin-left: 20px;" class="apuBirth">'+data.APU_BIRTH+'</span></td>';
	    			temp += '<td>';
	    			if(data.APU_SELFYN == 'N'){
	    				temp += '<a class="userUpdate" title="수정하기" onclick="pf_lectureUserUpdate(this, \''+apukey+'\', \''+data.APU_GENDER+'\');">수정하기</a><a class="userDelete"  title="삭제하기" onclick="pf_lectureUserDelete(this, \''+apukey+'\');">삭제하기</a>';
	    			}
	    			temp += '</td></tr>';
	    			
				$("#leactureFrame").contents().find("#UserTableList").append(temp);
				$('#leactureFrame').attr('src', '/dy/mypage/applycheck/program/iframe.do?type=L');
		    },
		    error: function() {
		    	alert("에러, 관리자에게 문의하세요.");
		    }
		});
	}else {
		$.ajax({
		    type   : "POST",
		    url    : "/dy/function/userUpdateAjax.do",
		    data   : $("#UserForm").serialize(),
		    async:false,
		    success:function(data){
		    	$("html").css("overflow-y", "");
				$("body").css("overflow-y", ""); 
				$("#pop_bg_opacity").fadeOut(); 
				$("#tour_contents_pop_box").hide();  
				$('#leactureFrame').attr('src', '/dy/mypage/applycheck/program/iframe.do?type=L');
		    },
		    error: function() {
		    	alert("에러, 관리자에게 문의하세요.");
		    }
		});
	}
}


function pf_birth(){
	var birth = $("#APUBIRTH").val();
	var format = /^(19[3-9][0-9]|20\d{2})-(0[0-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/;
    if(birth && !format.test(birth)){
     alert("유효하지 않습니다. \n생년월일은 1930-01-01부터 2099-12-31까지 입력 가능합니다.");
   	 $("#APUBIRTH").val('');
   	 $("#APUBIRTH").focus();
     return false;
    }
}

</script>