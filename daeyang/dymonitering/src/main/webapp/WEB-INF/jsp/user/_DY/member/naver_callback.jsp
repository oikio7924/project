<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>

<script type="text/javascript" src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.0.js" charset="utf-8"></script>

<!--sns폼  -->
<form action="/{tiles}/member/regist/result.do" method="post" id="sns_form" class="smart-form client-form">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	<input type="hidden" name="uniqId" id="uniqId" />
	<input type="hidden" name="name" id="name" />
	<input type="hidden" name="email" id="email" />
	<input type="hidden" name="type" id="type" />
</form>

<script>
	var naver_clientid = '${SiteManager.SNSLOGIN_NAVER_CLIENT_ID}'
	var kakao_jskey = '${SiteManager.SNSLOGIN_KAKAO_JSKEY}'
	var facebook_appid = '${SiteManager.SNSLOGIN_FACEBOOK_APPID}'
	var location_origin = location.origin;
	var naverLogin = new naver.LoginWithNaverId(
		{
			clientId : naver_clientid,  /* 개발자센터에 등록한 ClientID  local*/
			callbackUrl : location_origin+"/${currentTiles}/naver/callback.do", // 네이버 콜백 유알엘
			isPopup: false,
			callbackHandle: true
			/* callback 페이지가 분리되었을 경우에 callback 페이지에서는 callback처리를 해줄수 있도록 설정합니다. */
		}
	);

	/* (3) 네아로 로그인 정보를 초기화하기 위하여 init을 호출 */
	naverLogin.init();

	/* (4) Callback의 처리. 정상적으로 Callback 처리가 완료될 경우 main page로 redirect(또는 Popup close) */
	window.addEventListener('load', function () {
		naverLogin.getLoginStatus(function (status) {
			if (status) {
				/* (5) 필수적으로 받아야하는 프로필 정보가 있다면 callback처리 시점에 체크 */
				var uniqId = naverLogin.user.getId();
				var name = naverLogin.user.getName();
				var email = naverLogin.user.getEmail();
			 	/*  alert(naverLogin.accessToken);  */
				
				
				if( name == undefined || name == null) {
					alert("이름은 필수정보입니다. 정보제공을 동의해주세요.");
					/* (5-1) 사용자 정보 재동의를 위하여 다시 네아로 동의페이지로 이동함 */
					naverLogin.reprompt();
					return;
				}
				

				snsLogin(uniqId, name, 'naver');
				
			} else {
				console.log("callback 처리에 실패하였습니다.");
			}
		});
	});
	
	/* function checkSnsMember(uniqId, name,  type) {
		$.ajax({
			type : "post",
			url : "/dy/reward/checkSnsMemberAjax.do",
			data :  {
				"uniqId" : uniqId,	
				"type" : type
			},
			async : false,
			success : function(data) {
				if(data) {
					// 기존회원 로그인 처리
					snsLogin(uniqId, type);
				}else {
					// 신규회원 아이디, 비밀번호 입력창으로 보내기
					//window.location.replace("http://"+location.host+"/dy/reward/snsJoinView.do");
					joinSns(uniqId, name, email, type);
				}
			},
			error : function(xhr, status, error) {
	            alert('SNS로그인 에러발생');
	      }

		})
	} */
	
 function snsLogin(uniqId, name, type) {
		$.ajax({
			type : "post",
			url : "/${currentTiles}/reward/snsLoginAjax.do",
			data :  {
				"uniqId" : uniqId,	
				"name" : name,	
				"type" : type
			},
			async : false,
			success : function(data) {
				if(data) {
					window.close();
					opener.location.href='/${currentTiles}/index.do'
				}else {
					alert("sns로그인 실패");
				}
			},
			error : function(xhr, status, error) {
	            alert('SNS로그인 에러발생');
	      }

		})
		
	}; 
	
/* 	function snsLogin(uniqId, name,  type) {
		$("#uniqId").val(uniqId);
		$("#name").val(name);
		$("#email").val(email);
		$("#type").val(type);
		$("#sns_form").submit();
	
	} */
	
	/* function joinSns(uniqId, name, email, type) {
		document.getElementById('sns_id').value = uniqId;
		document.getElementById('sns_name').value = name;
		document.getElementById('sns_email').value = email;
		document.getElementById('sns_type').value = type;
		document.sns_form.submit();
	}; */
</script>