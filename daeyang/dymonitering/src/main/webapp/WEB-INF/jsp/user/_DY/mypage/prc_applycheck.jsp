<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<script src="/resources/api/mask/jquery.mask.js"></script>
<link rel="stylesheet" type="text/css" href="/resources/api/FrontMArte/css/ticket_2.css"/>
<link href="/resources/common/css/calendar/TronixCalendar2.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="/resources/common/css/program.css">
<style>
/* 수강자 리스트쪽 버튼 */
.userList, .userDelete , .userUpdate{ border: 1px solid;   border-radius: 5px;   padding: 3px 15px;  font-size: 13px;}
.userList{ background: #353333; 	color: #ffffff;}
a.userUpdate{cursor:pointer;text-decoration:none;   background: #e22931; 	color: #ffffff;}
a.userDelete{ cursor:pointer;    text-decoration:none;    background: #ffffff; 	color: #000; 	margin-left: 5px;}
#userAdd{display: none;}
.usertitle{margin: 10px 0 5px;  font-size: 18px;  color: #e22931;   background-size: auto;}

/* 수강대상자 팝업 */
#UserTableList .apuName, #UserTableList .apuRelation, #UserTableList .bracket{ width: auto; float: left;}
#UserTableList .bracket,  #UserTableList .apuRelation{padding: 0;}
</style>

	<form:form id="Form" method="post">
	<input type="hidden" name="pageIndex" id="pageIndex" value="1">
	<input type="hidden" name="type" value=""/>
	<input type="hidden" name="searchCondition" id="searchCondition" value="F">
	</form:form>
	
<section id="widget-grid" class="">
	<!-- row -->
	<div class="subRightContentsBottomWrap">
	<div class="subRealTitleBox">
		<h1>예매내역</h1>
	</div>
		<div class="subRealContentsBox">
			<div class="subRealContentsBox">
				<div class="left mgB15">
					<div class="myApplyListBtn">
						<a href="javascript:;" onclick="pf_linkpage_apply(1, 'B');" class="default_btn mgT10 left APDapply" id="applyBefore">
							관람 전
						</a>
						<a href="javascript:;" onclick="pf_linkpage_apply(1, 'F');" class="default_btn mgT10 APDapply" id="applyAfter">
							관람 후
						</a>
						<a href="javascript:;" onclick="pf_linkpage_apply(1, 'R');" class="default_btn mgT10 right APDapply" id="applyRefund">
							취소 / 환불
						</a>
					</div>
				</div>
				<div class="clear"></div>
				<div id="tableWrap">
				</div>
		</div>
		</div>
	</div>
	
	<!-- row -->
	<div class="subRightContentsBottomWrap">
		<div class="subRealTitleBox">
			<h1>수강신청내역</h1>
		</div>
		<div class="subRealContentsBox">
			<div style="width:100%">
				<div id="tempDel" class="left mgB15" style="float:left">
					<div class="myApplyListBtn">
						<a href="javascript:;" onclick="pf_linkpage_lecture(1, 'B');" class="default_btn mgT10 left APDlecture" id="lectureBefore">
							관람 전
						</a>
						<a href="javascript:;" onclick="pf_linkpage_lecture(1, 'F');" class="default_btn mgT10 APDlecture" id="lectureAfter">
							관람 후
						</a>
						<a href="javascript:;" onclick="pf_linkpage_lecture(1, 'R');" class="default_btn mgT10 right APDlecture" id="lectureRefund">
							취소 / 환불
						</a>
					</div>
				</div>
				<div style="float:right">
					<button class="userList" id="userList" onclick="pf_lectureUserList();">수강대상자 목록</button>
					<button class="userList" id="userAdd" onclick="pf_lectureUserAdd('N');">수강대상자 추가등록 +</button>
				</div>
				<div class="clear"></div>
				</div>
				<div id="tableWrap2">
				</div>
		</div>
	</div>
	
	<!-- row -->
	<div class="subRightContentsBottomWrap">
		<div class="subRealTitleBox">
			<h1>단체 예약 내역</h1>
		</div>
		<div class="subRealContentsBox">
			<div id="tableWrap3">
			</div>
		</div>
	</div>
</section>

<!-- end widget grid -->
<form:form id="GpForm" method="post">
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
<div id="lecture_contents_pop_box" tabindex="0">
	<div class="pop-container"> 
		<div class="pop-conts">
			<div class="contents_pop_header"> 
				<div class="contents_pop_title">수강대상자 등록</div>
				<a href="javascript:;" class="contents_pop_cbtn" onclick="pf_close('lecture_contents_pop_box')" style="text-align: right;">
					<img src="/resources/img/calendar/close_btn.gif" alt="닫기" style="max-width: 70%;">
				</a>
			</div>
			<div>
				<h2 class="dis-h5" style="margin: 15px 0 0 10px;"><span class="line-h5"></span>수강생 정보를 입력 해 주세요</h2>
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
										<input class="userAdd" id="APUPHONE" type="text" placeholder="ex) 000-0000-0000" onkeyup="cf_autoHypenPhone(this,this.value)" maxlength="13"/>
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
			            <button type="button" class="btn-popup-sav focusPoint" onclick="javascript:family_regist('${userInfo.UI_KEYNO }');">저장</button>
			        </div>
				</div>
			</div>
			<div class="contents_pop_footer"></div>   
		</div>
	</div>
</div> 
<%@ include file="/WEB-INF/jsp/user/_DY/mypage/prc_applycheck_detail.jsp"%>

<script type="text/javascript">

//화면 호출시 가장 먼저 호출되는 부분
var UIKEY = '${userInfo.UI_KEYNO}'
var div = '${type}'
var type = '${search.searchCondition}'
	
$(function(){
	
	
	
	$("#APUBIRTH").mask('0000-00-00');
	pf_linkpage_apply(1, 'B');
	pf_linkpage_lecture(1, 'B');
	pf_linkpage_group(1);
});

//수강신청자 다이얼로그 오픈
function AllWrap(){	
 	if($("#APU_KEYNO").val()){
		$('.contents_pop_title').text('수강대상자 수정');
	}else{
	$('.contents_pop_title').text('수강대상자 등록');
	}
	$("#lecture_contents_pop_box").show();
	var temp = $("#lecture_contents_pop_box");
	
// 	// 화면의 중앙에 레이어를 띄운다.  
	if (temp.outerHeight() < $(document).height() ) temp.css('margin-top', '-'+temp.outerHeight()/2+'px');
	else temp.css('top', '0px');
	if (temp.outerWidth() < $(document).width() ) temp.css('margin-left', '-'+temp.outerWidth()/2+'px');
	else temp.css('left', '0px');
	
	$("#lecture_contents_pop_box").focus();
}

function pf_reset(){
	$("#APU_KEYNO").val("");
	$(".userAdd").val("");
	$("input[name=RELATION]").prop("checked", false);
	$("input[name=GENDER]").prop("checked", false);		
}

//수강생 추가
function family_regist(key){
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
			$("#lecture_contents_pop_box").hide();  
			var apukey = data.APU_KEYNO;
			var temp =  '<tr>';
    			temp += '<th><span class="apuName">'+data.APU_NAME+'</span><span class="bracket">(</span><span class="apuRelation">'+data.APU_RELATION+'</span><span class="bracket">)</span></th>';
    			temp += '<td><span class="apuPhone">'+data.APU_PHONE+'</span> <span style="margin-left: 20px;" class="apuBirth">'+data.APU_BIRTH+'</span></td>';
    			temp += '<td>';
    			if(data.APU_SELFYN == 'N'){
    				temp += '<a class="userUpdate" title="수정하기" id="'+apukey+'" onclick="pf_lectureUserUpdate(this, \''+apukey+'\', \''+data.APU_GENDER+'\');">수정하기</a><a class="userDelete"  title="삭제하기" onclick="pf_lectureUserDelete(this, \''+apukey+'\');">삭제하기</a>';
    			}
    			temp += '</td></tr>';
			$("#UserTableList").append(temp);
	    },
	    error: function() {
	    	alert("에러, 관리자에게 문의하세요.");
	    }
	});
	}else {
		var key = $("#APU_KEYNO").val();
		$.ajax({
		    type   : "POST",
		    url    : "/dy/function/userUpdateAjax.do",
		    data   : $("#UserForm").serialize(),
		    async:false,
		    success:function(data){
		    	$("html").css("overflow-y", "");
				$("body").css("overflow-y", ""); 
				$("#pop_bg_opacity").fadeOut(); 
				$("#lecture_contents_pop_box").hide();
				
				//수정사항 반영처리
				$tr = $(parent.document).find("#"+key+"").closest("tr");
				$tr.find(".apuName").text($("#APUNAME").val());
				$tr.find(".apuRelation").text(relation);
				$tr.find(".apuPhone").text($("#APUPHONE").val());
				$tr.find(".apuBirth").text($("#APUBIRTH").val());
				pf_lectureUserList();
		    },
		    error: function() {
		    	alert("에러, 관리자에게 문의하세요.");
		    }
		});
	}
}

//수강생 수정
function pf_lectureUserUpdate(obj, key, MF){
	$tr = $(obj).closest("tr");
	var name = $tr.find(".apuName").text();
	var relation = $tr.find(".apuRelation").text();
	var phone = $tr.find(".apuPhone").text();
	var birth = $tr.find(".apuBirth").text();
	var gender = MF;
	
 	$(parent.document).find("#APU_KEYNO").val(key);
	$(parent.document).find("#APUNAME").val(name);
	$(parent.document).find("#APUPHONE").val(phone);
	$(parent.document).find("#APUBIRTH").val(birth);
	$(parent.document).find("input:radio[name=GENDER][value="+gender+"]").prop("checked", true);
	$(parent.document).find("input:radio[name=RELATION][value="+relation+"]").prop("checked", true);
	$(parent.document).find("input[name=GENDER]");
	
	pf_lectureUserAdd('U');
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
 
//예매내역 - 페이징
function pf_linkpage_apply(num, type){
	pf_linkpage(num,'/${tiles}/mypage/apply/dataAjax.do','#tableWrap', type);
}

//수강신청 - 페이징
function pf_linkpage_lecture(num, type){
	//수강신청 내역 탭 클릭시 - 수강대상자목록 보이고, 신청자 추가 버튼은 숨김
	$('#userAdd').hide();
	$('#userList').show();
	pf_linkpage(num,'/${tiles}/mypage/lecture/dataAjax.do','#tableWrap2', type);
}

//단체예약 - 페이징
function pf_linkpage_group(num){
	pf_linkpage(num,'/${tiles}/mypage/group/dataAjax.do','#tableWrap3', '');
}

//페이징
function pf_linkpage(num, url, obj, type){
	$('#pageIndex').val(num);
	if(type){
		$('#searchCondition').val(type);	
	}
	$(obj).load(url,$('#Form').serializeArray(),function(){
	})
}

//수강대상자 목록
function pf_lectureUserList(){
	
	$.ajax({
		url: '/dy/mypage/ApplyUserListAjax.do',
        type: 'POST',
        data:  {
        	'key' : UIKEY
        },
        async: false,  
        success: function(data) {
        	var userList = [];
        	var userList = data.UserList;
        	var temp =  '';
        	$.each(userList, function(i){
        		users = userList[i];
        		var key = users.APU_KEYNO;
        			temp +=  '<tr>';
        			temp += '<th><span class="apuName">'+users.APU_NAME+'</span><span class="bracket">(</span><span class="apuRelation">'+users.APU_RELATION+'</span><span class="bracket">)</span></th>';
        			temp += '<td><span class="apuPhone">'+users.APU_PHONE+'</span> <span style="margin-left: 20px;" class="apuBirth">'+users.APU_BIRTH+'</span></td>';
        			temp += '<td>';
        			if(users.APU_SELFYN == 'N'){
        				temp += '<a class="userUpdate" title="수정하기" id="'+key+'" onclick="pf_lectureUserUpdate(this, \''+key+'\', \''+users.APU_GENDER+'\');">수정하기</a><a class="userDelete"  title="삭제하기" onclick="pf_lectureUserDelete(this, \''+key+'\');">삭제하기</a>';
        			}
        			temp += '</td></tr>';
        	});
       		$("#UserTableList").html(temp);	
        	
        	$(".APD"+div).removeClass("fs16");
        	$("#LectureTableWrap, #userList").hide();
        	$("#tempDel").find('a').removeClass('fs16');
        	$("#UserTableWrap, #userAdd").show();
        },
        error: function(){
        	alert("에러, 관리자에게 문의하세요.");
        }
	});
	
	//자동 길이 조절
// 	document.body.scrollIntoView(true);
// 	parent.document.all.leactureFrame.height = document.body.scrollHeight; 
}

//수강대상자 등록 팝업
function pf_lectureUserAdd(type){
	if(type == 'N'){
		parent.pf_reset();
	}
	parent.AllWrap();
}

function pf_close(id){
	$("#"+id).hide();   
	if(id == 'program_contents_pop_box'){
		$("#pop_bg_opacity").fadeOut(); 
	}	
}

//수강생 삭제
function pf_lectureUserDelete(obj, key){
	$tr = $(obj).closest("tr");
	
	if(confirm("수강대상자를 삭제하시겠습니까?")){
		$.ajax({
		    type   : "POST",
		    url    : "/dy/function/userDeleteAjax.do",
		    data   : {
		    	"APU_KEYNO": key
		    },
		    async:false,
		    success:function(data){
		    	$tr.remove();
		    	alert("삭제되었습니다.")
		    },
		    error: function() {
		    	alert("에러, 관리자에게 문의하세요.");
		    }
		});
	}
}

//신청프로그램 환불하기
function pf_ProgramApply(type, key, Num, apkey, price){
	if(type == 'C'){
		if(confirm("취소하시겠습니까?")){
			$.ajax({
				url: '/dy/mypage/programApplyAjax.do',
		        type: 'POST',
		        data:  {
		        	'APP_KEYNO'  : key,
		        	'APPtype' 	 : type,
		        	'ApplyCont'  : Num,
		        	'AP_KEYNO'	 : apkey,
		        	'price'		 : price
		        },
		        async: false,  
		        success: function() {
		        	alert("취소되었습니다.");
		        	location.reload();
		        },
		        error: function(){
		        	alert("에러, 관리자에게 문의하세요.");
		        }
			});
		}
	}else if(type == 'P'){
		$.ajax({
			url: '/dy/mypage/programApplyAjax.do',
	        type: 'POST',
	        data:  {
	        	'APP_KEYNO' : key,
	        	'APPtype' : type
	        },
	        async: false,  
	        success: function() {
	        	alert("결제되었습니다.");
	        	location.reload();
	        },
	        error: function(){
	        	alert("에러, 관리자에게 문의하세요.");
	        }
		});
	}
	
}

</script>