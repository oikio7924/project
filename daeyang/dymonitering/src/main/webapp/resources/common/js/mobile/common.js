var token = $("meta[name='_csrf']").attr("content");

$.ajaxSetup({
	  headers: {
	    'X-CSRF-Token': token,
	    'AJAX': true
	  },
	  statusCode :{
		  401 : function() {
			  alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
              location.href = "/user/member/login.do?tiles=mobile"; 
		  },
		  403 : function() {
			  alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
              location.href = "/user/member/login.do?tiles=mobile";  
		  }
	  }
	});

$(function(){
	
	
	
});

