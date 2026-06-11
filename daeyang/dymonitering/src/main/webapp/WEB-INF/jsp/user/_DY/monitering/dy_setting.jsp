<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<form:form action="/dy/moniter/settingAction.do" method="POST" id="Form" commandName="ModReqUserDTO">
<input type="hidden" name="UI_KEYNO" id="UI_KEYNO" value="${user.UI_KEYNO }">
<input type="hidden" name="UI_NAME" id="UI_NAME" value="${user.UI_NAME }">
<input type="hidden" name="UI_MAILLING" id="UI_MAILLING" value="${userInfo.UI_MAILLING }">
<input type="hidden" name="PASSWORD_REGEX" id="PASSWORD_REGEX" value="${userInfoSetting.SC_CODEVAL01}">
<div id="container" class="heightAuto">

    <section class="setting_one_w">

        <article class="artBoard top">
            <h2 class="circle">개인정보 설정</h2>
            
            <div class="private_setting_wrap">
                <table class="tbl_private_se">
                    <colgroup>
                        <col style="width: 20%;">
                        <col style="width: 80%;">
                    </colgroup>
                    <caption>개인정보 설정</caption>
                    <tbody>
                        <tr>
                            <th><label>아이디</label></th>
                            <td>${userInfo.UI_ID }</td>
                        </tr>
                        <tr>
                            <th><label>비밀번호</label></th>
                            <td><input type="password" class="txt_nor sm2 w50" name="UI_PASSWORD" id="UI_PASSWORD" ></td>
                        </tr>
                        <tr>
                            <th><label>비밀번호 확인</label></th>
                            <td><input type="password" class="txt_nor sm2 w50" name="UI_PASSWORD2" id="UI_PASSWORD2"></td>
                        </tr>
                        <tr>
                            <th><label>휴대전화</label></th>
                            <td><input type="text" class="txt_nor sm2 w50" name="UI_PHONE" id="UI_PHONE" value="${user.UI_PHONE }" onkeyup="pf_autoHypenPhone(this,this.value)" maxlength="13"></td>
                        </tr>
                        <tr>
                            <th><label>이메일</label></th>
                            <td>
                                <input type="text" class="txt_nor sm2 w50" id="UI_EMAIL" name="UI_EMAIL" value="${user.UI_EMAIL }" > 
                            </td>
                        </tr>
                        <tr>
                            <th><label>담당자</label></th>
                            <td>대양기업 (기술연구소) : 오인경</td>
                        </tr>
                        <tr>
                            <th><label>담당자 연락처</label></th>
                            <td>061-332-8086</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="btn_private">
                <button type="submit" class="btn_nor lg2 round2 blue">설정저장</button>
            </div>
        </article>
    </section>
</div>


</form:form>



 <script>
 
//화면 호출시 가장 먼저 호출되는 부분 
/*  $(document).ready(function() {
 	
 	$("#Form").validate({

         onfocusout : function (element) {

             $(element).valid();

         },
         
         submitHandler: function(form) {   
        	
            return true;
           }, 

         rules : {

         	UI_ID : {required:true, minlength:4, maxlength:16, loginID:true, dupleCheck:true},
         	
			UI_PASSWORD : {required:true, passwordChk:true},

         	UI_PASSWORD2 : {required:true, equalTo:"#UI_PASSWORD"},

         	UI_NAME : {required:true, minlength:2, maxlength:20,forbiddenWordCheck:true},

         	UI_EMAIL : {required:false, minlength:5, maxlength:50, email:true}
         	
         },

         messages : {

         	UI_ID : {required:"필수정보를 적어주세요.", minlength:jQuery.validator.format("최소 {0}자 이상"), maxlength:jQuery.validator.format("최대 {0}자 이하"), loginID:"아이디 형식이 잘못되었습니다.", dupleCheck:"이미 존재하거나 사용할 수 없는 아이디 입니다."},

         	UI_PASSWORD : {required:"필수정보를 적어주세요.", passwordChk:"비밀번호 형식이 잘못되었습니다."},

         	UI_PASSWORD2 : {required:"필수정보를 적어주세요.", equalTo:"입력한 비밀번호가 서로 일치하지 않습니다."},

         	UI_NAME : { minlength:jQuery.validator.format("최소 {0}자 이상"), maxlength:jQuery.validator.format("최대 {0}자 이하"),forbiddenWordCheck:"사용할 수 없는 이름입니다."},
         
         	UI_EMAIL : { minlength:jQuery.validator.format("최소 {0}자 이상"), maxlength:jQuery.validator.format("최대 {0}자 이하"), email:"이메일 형식이 잘못되었습니다."}
         	
         }, 

         invalidHandler : function(form, validator) {

             var errors = validator.numberOfInvalids();

             if( errors ) 
             {
                 $("h3 span.ok").html("(유효성 검사 실패)"); 
                 console.log(validator.errorList[0].message)
                 alert(validator.errorList[0].message);
                 
                 validator.errorList[0].element.focus();

             }

         },
         
         errorPlacement: function(error, element) {
           		$(element).after(error);
           }

     });
 	
 }); */
 

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



</script>
 
 
                

