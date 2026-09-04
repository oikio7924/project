<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<!--[if lt IE 9]>
<script>
//IE8 이하 브라우저 업그레이드 권고
alert("브라우저의 버전이 너무 낮습니다.\n보안을 위해 브라우저의 버전을 업그레이드 해야합니다.");
location.href="/no_IELess9.jsp";
</script>
<![endif]-->

<!-- PACE LOADER - turn this on if you want ajax loading to show (caution: uses lots of memory on iDevices)-->
<script data-pace-options='{ "restartOnRequestAfter": true }' src="/resources/smartadmin/js/plugin/pace/pace.min.js"></script>

<!-- IMPORTANT: APP CONFIG -->
<script src="/resources/smartadmin/js/app.config.js"></script>

<!-- JS TOUCH : include this plugin for mobile drag / drop touch events-->
<script src="/resources/smartadmin/js/plugin/jquery-touch/jquery.ui.touch-punch.min.js"></script> 

<!-- BOOTSTRAP JS -->
<script src="/resources/smartadmin/js/bootstrap/bootstrap.min.js"></script>

<!-- CUSTOM NOTIFICATION -->
<script src="/resources/smartadmin/js/notification/SmartNotification.min.js"></script>

<!-- JARVIS WIDGETS -->
<script src="/resources/smartadmin/js/smartwidgets/jarvis.widget.min.js"></script>
<!-- <script src="/resources/smartadmin/js/smartwidgets/jarvis.widget.js"></script> -->

<!-- EASY PIE CHARTS -->
<script src="/resources/smartadmin/js/plugin/easy-pie-chart/jquery.easy-pie-chart.min.js"></script>

<!-- SPARKLINES -->
<script src="/resources/smartadmin/js/plugin/sparkline/jquery.sparkline.min.js"></script>


<!-- JQUERY MASKED INPUT -->
<script src="/resources/smartadmin/js/plugin/masked-input/jquery.maskedinput.min.js"></script>

<!-- JQUERY SELECT2 INPUT -->
<script src="/resources/smartadmin/js/plugin/select2/select2.min.js"></script>

<!-- JQUERY UI + Bootstrap Slider -->
<script src="/resources/smartadmin/js/plugin/bootstrap-slider/bootstrap-slider.min.js"></script>

<!-- browser msie issue fix -->
<script src="/resources/smartadmin/js/plugin/msie-fix/jquery.mb.browser.min.js"></script>

<!-- FastClick: For mobile devices -->
<script src="/resources/smartadmin/js/plugin/fastclick/fastclick.min.js"></script>

<!-- validation -->
<script src="/resources/common/js/validation/jquery.validate.js"></script>


<script src="/resources/smartadmin/js/plugin/colorpicker/bootstrap-colorpicker.min.js"></script>

<!-- MAIN APP JS FILE -->
<script src="/resources/smartadmin/js/app.min.js"></script>

<!-- Flot Chart Plugin: Flot Engine, Flot Resizer, Flot Tooltip -->
<script src="/resources/smartadmin/js/plugin/flot/jquery.flot.cust.min.js"></script>
<script src="/resources/smartadmin/js/plugin/flot/jquery.flot.resize.min.js"></script>
<script src="/resources/smartadmin/js/plugin/flot/jquery.flot.time.min.js"></script>
<script src="/resources/smartadmin/js/plugin/flot/jquery.flot.tooltip.min.js"></script>

<!-- <script src="/resources/smartadmin/js/plugin/jquery-nestable/jquery.nestable.min.js"></script> -->

<script src="/resources/common/js/common/common.js"></script>

<script src="/resources/common/js/dyAdmin/dyAdmin_function.js"></script>

<script>

/**
 * 로그인 체크
 * @returns
 */
function cf_checkLogin(){
	
	var check = false;
	
	$.ajax({
		type   	: "post",   
		url    	: "/common/member/checkLogin.do",
		async  : false,
		success : function(data){
			if(data == 'N'){
				if(confirm('로그인이 필요합니다. 로그인 하시겠습니까?')){
					cf_login();
				}
			}else{
				check = true;
			}
		},
		error: function(jqXHR, exception) {
	       	alert('error')
		}
	});
	
	return check;
}

/**
 * 로그인
 */

function cf_login(url){
	var loginUrl = '/dyAdmin/user/login.do'
	if(url){ // url이 있으면 url값으로 보냄
		loginUrl += '&returnPage=' + url;
	}
	
	location.href = loginUrl;
}

</script>

