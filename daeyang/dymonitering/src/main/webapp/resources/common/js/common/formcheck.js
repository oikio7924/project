
/**
 * 폼 체크
 	해당 폼 안에 잇는 모든 input,select 를 체크해서 
 	data-name 값이 있을 경우 설정된 폼체크를 실행함
 	
 	data-name 이 없을경우 널체크만함
 	
 	data-type 값으로 분기처리
 	
 	text : 일반 텍스트 처리 null만 체크함
 	
 	pwd : 기존 비밀번호 확인용 newPwd 가 잇을경우만  null 체크함
 	
 	newPwd : 새로운 비밀번호   pwd 가 있을경우 pwd도 같이 null 체크하고 newPwd2와 값 비교도 함.
 			그리고 정해진 비밀번호 정규식과 비교 // cf_formCheckPwd() 함수를 오버라이딩 해서 재정의 가능하도록 셋팅
 			
	newPwd2 : 새로운 비밀번호 확인용
	
	email : 이메일
	
	tel : 숫자와 - 허용
	
	number : 숫자만 허용
	
	유저타입 : 새로 추가하고싶을때 data-type 에 원하는 이름을 넣고
			function cf_formCheck_원하는이름()을 정의하면됨
			
			ex) data-type = 'userType'
			
			function cf_formCehck_userType();
 	
	checkbox, radio : data-type 이 없으면 기본적인 널체크만하고 다른 조건을 주고싶으면 data-type을 새로 정의해주면됨
 	
 */
var resultFormCheck = true;

$.fn.formCheck = function (options){
	
	
	if(options == undefined){
		options = new Object();
	}
	
	
	
	// 옵션 디퐅트
	options.excludeClass = options.excludeClass || 'exclude-form';  // 예외처리할 클래스 이름
	options.errorAction = options.errorAction || 'alert';  // 잘못된 폼에 대한 액션  alert , text 가능 
	options.errorClass = options.errorClass || 'formCheck-error'; // 잘못된 폼에 대한 span tag class
	options.errorClassPosition = options.errorClassPosition || function(obj,text){
		formCheckSetErrorText(obj,text,options.errorClass);
	} // 잘못된 폼에 대한 표현 방법
	
	
	// 정규식 Rules
	var rules = new Object();
	rules.password = options.passwordRule || /^(?=.*[a-zA-Z])((?=.*\d)|(?=.*\W)).{6,20}$/;
	rules.passwordText = options.passwordRuleText || '비밀번호는 최소 1개의 숫자 혹은 특수 문자를 포함해야 하고, 6~20자리를 사용해야 합니다.';
	
	$this = $(this);
	
	
	
	var inputTypeText;
		
	$this.find('input,select').each(function(){
	
		
	// _csrf 와 exclude-form 클래스는 제외
	if($(this).attr('name') == '_csrf' || $(this).hasClass(options.excludeClass)){
		return true;
	}
	
	var inputType = $(this).attr('type');
	
	
	inputTypeText = this.tagName == 'input' ? '입력' : '선택';
	
	
	var name = $(this).data('name');
	var type = $(this).data('type');
	
	
	if(inputType != 'checkbox' && inputType != 'radio'){
		
		
		
		if(!$(this).val() && type != 'pwd'){
			return formCheckErrorAction(options.errorAction,'required',$(this));
		}
		if(name != undefined){
			
			if(type == 'text' || type == 'pwd' || type == 'newPwd2'){
				
			}else if(type == 'newPwd'){
				//정규식 체크
				return ;
				if(!options.passwordRule.test($(obj).val())){
					return formCheckErrorAction(options.errorAction,'pwd',$(this)); 
				}
				
				//newPwd2와 일치 여부
				var newPwd2 = $('input[data-type=newPwd2]').val();
				if(newPwd2 != undefined && $(this).val() != newPwd2){
					alert('입력하신 비밀번호가 일치하지 않습니다.');
					$(this).focus();
					resultFormCheck = false;
					return false;
				}
				
				//기존 비밀번호 체크
				var pwd = $('input[data-type=pwd]').val();
				var encPwd = $('input[data-type=pwd]').data('encPwd');
				if(pwd != undefined){
					var pwdConfirm = true;
					$.ajax({
						type: "POST",
						url: "/dyAdmin/user/pwdCheckAjax.do",
						data: "pwd="+pwd+"&encPwd="+encPwd,
						async:false,
						success : function(data){
							if(data == false){
								alert('기존 비밀번호가 잘못입력되었습니다.');
								$('input[data-type=pwd]').focus();
								pwdConfirm =false;
							}
						},
						error: function(){
							alert('알수없는 에러 발생. 관리자한테 문의하세요.')
							pwdConfirm =false;
						}
					});
					if(!pwdConfirm){
						resultFormCheck = false;
						return false;
					}
				}
			}else if(type == 'email'){
				var emailRules = /^[a-z0-9_+.-]+@([a-z0-9-]+\.)+[a-z0-9]{2,4}$/;
				if(!emailRules.test($(this).val())){
					alert(name +"이(가) 이메일 형식에 맞지 않습니다.");
					$(this).focus();
					resultFormCheck = false;
					return false;
				}
			}else if(type == 'tel'){
				var telRules = /^[0-9-]+$/;
				if(!telRules.test($(this).val())){
					alert(name +"는  숫자와 - 만 입력할수있습니다.");
					$(this).focus();
					resultFormCheck = false;
					return false;
				}
			}else if(type == 'number'){
				var numberRules = /^[0-9]+$/;
				if(!numberRules.test($(this).val())){
					alert(name +"는  숫자만 입력할수있습니다.");
					$(this).focus();
					resultFormCheck = false;
					return false;
				}
			}else{
				var functionName = 'cf_formCheck_'+type;
				if(!window[functionName]($(this))){
					resultFormCheck = false;
					return false;					
				}
				
			}
		}
	}else{
		
		inputTypeText = '선택';
		
		var inputName = $(this).attr('name');
		
		var index = $this.find('input[name='+inputName+']').index($(this));
		if(index != 0){
			return true;
		}
		
		if(type == undefined){
			var checkValue = $this.find('input[name='+inputName+']:checked').val();
			if(checkValue == undefined){
				alert(name +"을 선택하여주세요.");
				$(this).focus();
				resultFormCheck = false;
				return false;
			}
		}else{
			var functionName = 'cf_formCheck_'+type;
				if(!window[functionName]($(this))){
					resultFormCheck = false;
					return false;					
				}
			}
		}
		
		
	});
	function formCheckErrorAction(errorAction, type , obj){
		if(type == 'required'){
			var name = $(obj).data('name');
			var tempName = name == undefined ? $(obj).attr('name') : name ;
			if(errorAction == 'alert'){
				alert(tempName +"을(를) "+inputTypeText+"하여주세요.");
				$(obj).focus();
				resultFormCheck = false;
				return false;
			}else if(errorAction == 'text'){
				var text = tempName +'을(를) '+inputTypeText+'하여주세요.';
				options.errorClassPosition(obj,text)
				resultFormCheck = false;
				return true;
			}
			
		}else if(type == 'pwd'){
			if(errorAction == 'alert'){
				alert(options.passwordRuleText);
				$(obj).focus();
				resultFormCheck = false;
				return false;
			}else if(errorAction == 'text'){
				options.errorClassPosition(obj,options.passwordRuleText)
				resultFormCheck = false;
				return true;
			}
		}
		return true;
	}
	
	function formCheckSetErrorText(obj,text,className){
		$(obj).after('<span class="'+className+'">'+text+'</span>');
	}
	
	
	return resultFormCheck;
}




