<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<style>
form .error {color:red}
.fixed-btns {position: fixed;bottom: 10px;right: 30px;z-index: 100;}
.fixed-btns > li {display: inline-block;margin-bottom: 7px;}
</style>
<div class="row">
<section id="widget-grid" class="">
	<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
		<div class="jarviswidget jarviswidget-color-darken" data-widget-editbutton="false">
			<header>
					<span class="widget-icon"> <i class="fa fa-lg fa-th-large"></i> </span>
					<h2>사이트 관리</h2>
			</header> 
		<div class="jarviswidget-editbox"></div>
		
			<div class="widget-body">
				<button class="btn btn-sm btn-success" type="button" onclick="pf_Distribute();" style="float: right;">	
					<i class="fa fa-plus"></i> 모두배포
				</button>
				<div style="clear: both;"></div>
				<form:form class="form-horizontal" id="Form">
					<fieldset>
						<legend>기본 설정</legend>
						<div class="form-group">	
							<label class="col-md-2 control-label">사이트 이름</label>
							<div class="col-md-6">
								<input class="form-control" type="text" name="HOMEPAGE_NAME" id="HOMEPAGE_NAME" maxlength="90" value="${siteManager.HOMEPAGE_NAME }">
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">대표 도메인</label>
							<div class="col-md-6">
								<select class="form-control" id="HOMEPAGE_REP" name="HOMEPAGE_REP">
									<c:forEach items="${homeDivList }" var="homeDiv">
									<option value="${homeDiv.MN_KEYNO }" ${siteManager.HOMEPAGE_REP eq homeDiv.MN_KEYNO ? 'selected':'' }>${homeDiv.MN_NAME }</option>
									</c:forEach>
								</select>
							</div>
						</div>
					</fieldset>
					
					<fieldset>
						<legend>파일 및 경로</legend>
						<div class="form-group">	
							<label class="col-md-2 control-label">파일 확장자</label>
							<div class="col-md-6">
								<input class="form-control" type="text" name="FILE_EXT" id="FILE_EXT" maxlength="200" value="${siteManager.FILE_EXT }">
							</div>
						</div>
						<div class="form-group">	
							<label class="col-md-2 control-label">upload 파일 경로</label>
							<div class="col-md-6">
								<input class="form-control checkTrim" type="text" name="FILE_PATH" id="FILE_PATH" maxlength="200" value="${siteManager.FILE_PATH }">
							</div>
						</div>
						<div class="form-group">	
							<label class="col-md-2 control-label">resource 경로</label>
							<div class="col-md-6">
								<input class="form-control checkTrim" type="text" name="RESOURCE_PATH" id="RESOURCE_PATH" maxlength="200" value="${siteManager.RESOURCE_PATH }">
							</div>
						</div>
						<div class="form-group">	
							<label class="col-md-2 control-label">jsp 경로</label>
							<div class="col-md-6">
								<input class="form-control checkTrim" type="text" name="JSP_PATH" id="JSP_PATH" maxlength="200" value="${siteManager.JSP_PATH }">
							</div>
						</div>
					</fieldset>
					<fieldset>
						<legend>맵 키</legend>
						<div class="form-group">	
							<label class="col-md-2 control-label">구글 맵 키</label>
							<div class="col-md-6">
								<input class="form-control" type="text" name="GOOGLE_APPKEY" id="GOOGLE_APPKEY" maxlength="90" value="${siteManager.GOOGLE_APPKEY }">
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">네이버 맵 키</label>
							<div class="col-md-6">
								<input class="form-control" type="text" name="NAVER_APPKEY" id="NAVER_APPKEY" maxlength="90" value="${siteManager.NAVER_APPKEY }">
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">다음 맵 키</label>
							<div class="col-md-6">
								<input class="form-control" type="text" name="DAUM_APPKEY" id="DAUM_APPKEY" maxlength="90" value="${siteManager.DAUM_APPKEY }">
							</div>
						</div>
					</fieldset>
					<%-- <fieldset>
						<legend>SNS 공유</legend>
						<div class="form-group">	
							<label class="col-md-2 control-label">default 설명</label>
							<div class="col-md-6">
								<input class="form-control" type="text" name="SNS_DESCRIPTION" id="SNS_DESCRIPTION" maxlength="500" value="${siteManager.SNS_DESCRIPTION }">
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">default 이미지</label>
							<div class="col-md-6">
								<input class="form-control" type="text" name="SNS_IMAGE" id="SNS_IMAGE" placeholder="http:// or https://" maxlength="200" value="${siteManager.SNS_IMAGE }">
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">이미지 width</label>
							<div class="col-md-6">
								<input class="form-control" type="number" name="SNS_IMAGE_WIDTH" id="SNS_IMAGE_WIDTH" oninput="cf_maxLengthCheck(this)" max="9999" maxlength="4" value="${siteManager.SNS_IMAGE_WIDTH }">
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">이미지 hieght</label>
							<div class="col-md-6">
								<input class="form-control" type="number" name="SNS_IMAGE_HEIGHT" id="SNS_IMAGE_HEIGHT" oninput="cf_maxLengthCheck(this)" max="9999" maxlength="4" value="${siteManager.SNS_IMAGE_HEIGHT }">
							</div>
						</div>
					</fieldset> --%>
					<fieldset>
						<legend>이메일</legend>
						<div class="form-group">	
							<label class="col-md-2 control-label">보내는 사람 이메일주소</label>
							<div class="col-md-6">
								<input class="form-control" type="text" name="EMAIL_SENDER" id="EMAIL_SENDER" maxlength="90" value="${siteManager.EMAIL_SENDER }">
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">보내는 사람 이름</label>
							<div class="col-md-6">
								<input class="form-control" type="text" name="EMAIL_SENDER_NAME" id="EMAIL_SENDER_NAME" maxlength="90" value="${siteManager.EMAIL_SENDER_NAME }">
							</div>
						</div>
					</fieldset>
					<fieldset>
						<legend>페이징</legend>
						<div class="form-group">	
							<label class="col-md-2 control-label">페이징 unit</label>
							<div class="col-md-6">
								<input class="form-control" type="number" name="PAGE_UNIT" id="PAGE_UNIT" oninput="cf_maxLengthCheck(this)" max="99" maxlength="2" value="${siteManager.PAGE_UNIT }">
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">페이징 size</label>
							<div class="col-md-6">
								<input class="form-control" type="number" name="PAGE_SIZE" id="PAGE_SIZE" oninput="cf_maxLengthCheck(this)" max="99" maxlength="2" value="${siteManager.PAGE_SIZE }">
							</div>
						</div>
					</fieldset>
					<fieldset>
						<legend>회원관리</legend>
						<div class="row" style="margin-bottom: 15px;">
							<label class="col-md-2 control-label">회원 삭제 정책</label>
							<input type="hidden" name="USER_DEL_POLICY" id="USER_DEL_POLICY"/>
							<div class="col-md-1">
								<span class="input-group-addon" style="background: #fff; border: none;">
									<span class="onoffswitch" style="width: 70px;">
										<input type="checkbox" name="DEL_POLICY" value="" 
												class="onoffswitch-checkbox" id="DEL_POLICY" >
										<label class="onoffswitch-label" for="DEL_POLICY"> 
											<span class="onoffswitch-inner" data-swchon-text="논리삭제" data-swchoff-text="물리삭제"></span> 
											<span class="onoffswitch-switch onoffswitch-switch2"></span> 
										</label> 
									</span>
								</span>
							</div>
						</div>
						<div class="form-group">	
							<label class="col-md-2 control-label">비번 변경주기(일 단위)</label>
							<div class="col-md-6">
								<input class="form-control" type="number" name="PASSWORD_CYCLE" id="PASSWORD_CYCLE" oninput="cf_maxLengthCheck(this)" max="999" maxlength="3" value="${siteManager.PASSWORD_CYCLE }">
							</div>
						</div>	
						<div class="form-group">	
							<label class="col-md-2 control-label">비밀번호 정규식</label>
							<div class="col-md-6">
								<select class="form-control" id="PASSWORD_REGEX" name="PASSWORD_REGEX">
									<option value="">선택하세요.</option>
									<c:forEach items="${PasswordRegex}" var="model">
										<option value="${model.SC_KEYNO}" ${model.SC_KEYNO eq siteManager.PASSWORD_REGEX ? 'selected' : ''}><c:out value="${model.SC_CODENM }"/></option>
									</c:forEach>
								</select>
							</div>
						</div>	
					</fieldset>
					
					<fieldset>
						<legend> SNS로그인 연동 </legend>
						<div class="form-group">	
							<label class="col-md-2 control-label">네이버 클라이언트 아이디</label>
							<div class="col-md-6">
								<input class="form-control" type="text" name="SNSLOGIN_NAVER_CLIENT_ID" id="SNSLOGIN_NAVER_CLIENT_ID" maxlength="100" value="${siteManager.SNSLOGIN_NAVER_CLIENT_ID }">
							</div>
						</div>
						<div class="form-group">	
							<label class="col-md-2 control-label">네이버 클라이언트 시크릿</label>
							<div class="col-md-6">
								<input class="form-control" type="text" name="SNSLOGIN_NAVER_CLIENT_SECRET" id="SNSLOGIN_NAVER_CLIENT_SECRET" maxlength="100" value="${siteManager.SNSLOGIN_NAVER_CLIENT_SECRET }">
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">카카오 자바스크립트 키</label>
							<div class="col-md-6">
								<input class="form-control" type="text" name="SNSLOGIN_KAKAO_JSKEY" id="SNSLOGIN_KAKAO_JSKEY" maxlength="100" value="${siteManager.SNSLOGIN_KAKAO_JSKEY }">
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">페이스북 앱 아이디</label>
							<div class="col-md-6">
								<input class="form-control" type="text" name="SNSLOGIN_FACEBOOK_APPID" id="SNSLOGIN_FACEBOOK_APPID" maxlength="100" value="${siteManager.SNSLOGIN_FACEBOOK_APPID }">
							</div>
						</div>
					</fieldset>
					
					
					<fieldset style="display:none;">
						<legend>서버 이름</legend>
						<div class="form-group">	
							<label class="col-md-2 control-label">이름</label>
							<div class="col-md-6">
								<input class="form-control" type="text" name="USERID" id="USERID" maxlength="90" value="${siteManager.USERID }">
							</div>
						</div>
					</fieldset>
				</form:form>
				<ul class="fixed-btns">
					<li>
						<a href="javascript:;" onclick="pf_save()" class="btn btn-primary btn-circle btn-lg" title="저장하기"><i class="fa fa-save"></i></a>
					</li>
					<li id="deleteBtn">
						<a href="javascript:;" onclick="pf_Distribute()" class="btn btn-success btn-circle btn-lg" title="배포하기"><i class="fa fa-folder-open"></i></a>
					</li>
					<li id="deleteBtn">
						<a href="javascript:;" onclick="cf_top()" class="btn btn-default btn-circle btn-lg" title="위로가기"><i class="fa fa-arrow-up"></i></a>
					</li>
				</ul>
			</div>
		</div> 
	</article>
</section>
</div>


<script>
$(document).ready(function() {
	
	var del_policy = "${siteManager.USER_DEL_POLICY}" || "Y";
	
	//체크박스 초기화
	cf_checkbox_checked_val("DEL_POLICY", del_policy);
	
	$("#Form").validate({

        onfocusout : function (element) {

            $(element).valid();

        },
        
        submitHandler: function(form) {
            pf_checkBoxVal();
        	pf_updateData();
        	return false;
        },
        rules : {
        	
        	HOMEPAGE_NAME : {required:true,maxlength:100},
        	
        	HOMEPAGE_REP : {required:true},
        	
        	GOOGLE_APPKEY : {maxlength:100},
        	
        	NAVER_APPKEY : {maxlength:100},
        	
        	DAUM_APPKEY : {maxlength:100},
        	
        	FILE_EXT : {required:true,maxlength:200},
        	
        	FILE_PATH : {required:true,maxlength:200},
        	
        	RESOURCE_PATH : {required:true,maxlength:200},
        	
        	JSP_PATH : {required:true,maxlength:200},

        	PAGE_UNIT : {required:true,number:true},
        	
        	PAGE_SIZE : {required:true,number:true},
        	
        	EMAIL_SENDER_NAME : {required:true,maxlength:100},
        	
        	EMAIL_SENDER : {required:true,email:true,maxlength:100},
        	
        	SNS_DESCRIPTION : {maxlength:500},
        	
        	SNS_IMAGE : {maxlength:200},
        	
        	SNS_IMAGE_WIDTH : {number:true},
        	
        	SNS_IMAGE_HEIGHT : {number:true},
        	
        	TOUR_START_LNG : {number:true},
        	
        	TOUR_START_LAT : {number:true}
        	
        },


        invalidHandler : function(form, validator) {

            var errors = validator.numberOfInvalids();

            if( errors ) 

            {
                $("h3 span.ok").html("(유효성 검사 실패)"); 

                alert(validator.errorList[0].message);

                validator.errorList[0].element.focus();

            }

        },
        
        errorPlacement: function(error, element) {
            	if($(element).hasClass('phonesize')){
	              	$(element).parent().find('.errorMessage').html(error)
            	}else{
            		$(element).after(error);
            	}
          }

	});
	
});

function pf_save(){
 	$("#Form").submit();
}

function pf_updateData(){

	cf_replaceTrim($("#Form"));

	 $.ajax({
		type: "POST",
		url: "/dyAdmin/admin/site/updateAjax.do",		
		data: $('#Form').serializeArray(), 
		async:false,
		success : function(){
			cf_smallBox('사이트관리', "저장되었습니다.", 3000);
		},
		error: function(){
			cf_smallBox('사이트관리', '알수없는 에러 발생. 관리자한테 문의하세요.', 3000,'gray');
			return false;
		}
	}); 
}

//모두 배포하기
function pf_Distribute() {

	if(confirm("정말 모두 배포를 하시겠습니까?")) {
		cf_loading();
		
		setTimeout(function(){
			$.ajax({
			    type   : "post",
			    url    : "/dyAdmin/admin/site/distributeAjax.do",
			    async  : false,
			    success:function(data){
			    	if(data) {
			    		cf_smallBox('success', '배포되었습니다', 3000);
			    	} else {
			    		cf_smallBox('error', '배포실패', 3000,'#d24158');
			    	}
			    },
			    error: function(jqXHR, textStatus, exception) {
			    	cf_smallBox('error', '에러발생', 3000,'#d24158');
			    }
			  }).done(function(){
				cf_loading_out();
			})
		},100)
	}
}

function pf_checkBoxVal(){
    $("#Form").find("input[type=checkbox]").each(function(){
        var checkID = $(this).attr("id");
        
        if(checkID == "DEL_POLICY"){
            if($(this).is(":checked")){
                $("#USER_" + checkID).val("Y");
            }else{
                $("#USER_" + checkID).val("N");
            }
        }
    })
}

</script>
