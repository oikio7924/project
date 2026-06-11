<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<section id="widget-grid" class="">

	<!-- row -->
	<div class="row">

		<!-- NEW WIDGET START -->
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">

			<!-- Widget ID (each widget will need unique ID)-->
			<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>문자메시지 전송</h2>
				</header>
				<!-- widget div-->
				<div>
					
					<!-- widget edit box -->
					<div class="jarviswidget-editbox">
						<!-- This area used as dropdown edit box -->

					</div>
					<!-- end widget edit box -->

					<!-- widget content -->
					<div class="widget-body">
						<form:form id="Form" method="post" action="#">
<%-- 						<input type="hidden" name="UI_PHONE" id="UI_PHONE" value="${kakao.UI_PHONE}"> --%>
						<input type="hidden" name="UI_NAME" id="UI_NAME"/>
						<div id="myTabContent1" class="tab-content padding-10 form-horizontal bv-form">
								<fieldset>
								<div class="form-group" style = "width : 50%; float: left;">
										<label class="col-md-2 control-label" for="select-1">그룹 선택</label>
										<div class="col-md-8" items="${authList}" var="authList">
										<select class="form-control input-sm select2" id="UIA_KEYNO" name ="UIA_KEYNO" onchange="change()">
												<option>선택하세요.</option>
												<option value = "">전체 선택</option>
											<c:forEach items="${authList}" var="authList">
												<option value="${authList.UIA_KEYNO}">${authList.UIA_NAME}</option>
											</c:forEach>
										</select>
										</div>
									</div>
									<div class="form-group" style = "width:50%;  height:50px; float: left;">
										<label class="col-md-2 control-label" for="select-1">회원 선택</label>
										<div class="col-md-8" id ="UI_NAME">
										<select style = "height : 100px;" class="form-control input-sm select2" id="UI_KEYNO" name ="UI_KEYNO" placeholder = "발전소를 선택하세요" multiple>
<!-- 											<option>선택하세요</option> -->
<%-- 											<c:forEach items="${kakao}" var="list"> --%>
<%-- 												<option value="${kakao.UI_KEYNO}">${kakao.UI_NAME}</option> --%>
<%-- 											</c:forEach> --%>
										</select>
										</div>
										<button type="button" onclick = "selectDelete()" class="btn btn-sm btn-primary" style = "padding-left : 10px;">
										<i class="fa fa-floppy"></i>삭제
										</button>
									</div>
									<div class="form-group">
										<label class="col-md-2 control-label">내용 입력</label>
										<div class="col-md-8">
											<textarea class="form-control" name="content" placeholder="입력하세요" rows="30"></textarea>
										</div>
									</div>
								</fieldset>	
							<fieldset class="padding-10 text-right"> 
								<button type="button" onclick = "sendkakao()" class="btn btn-sm btn-primary">	
									<i class="fa fa-floppy"></i> 전송
								</button>
							</fieldset>
						</div>
						</form:form>
					</div>
					<!-- end widget content -->

				</div>
				<!-- end widget div -->

			</div>
			<!-- end widget -->
		</article>
		<!-- WIDGET END -->

	</div>

	<!-- end row -->
</section>
<<script type="text/javascript">

function sendkakao() {
	
	$.ajax({
		type : "post",
		url : "/sendMessage.do",
		data: $('#Form').serializeArray(),
		success: function(data){
// 			alert(data)
// 			location.reload();
			cf_smallBox('전송완료', '전송되었습니다', 3000);
			
		},
		error: function(){
			alert("전송 에러! 관리자에 문의해주세요.");
		}
	});
	
}

// select 값 여러개 css

 $( ".select2-multiple" ).select2({
	  	theme: "bootstrap",
		placeholder: "발전소를 선택하세요",
// 	  containerCssClass: ':all:'
	});
	


 function change() {
	 
	var selectgroup = $("#UI_KEYNO");
	 
	 
	 $.ajax({
		 type : 'post',
		 url : '/userkakakoselectAjax.do',
		 data : $('#Form').serializeArray(),
		 success : function(data){
			 
			var userlist = [];
			 
			for(var i=0; i<data.length; i++){
				userlist[i] = data[i].UI_KEYNO;
			}

			$(selectgroup).children().remove(); // UI_KEYNO 부분의 selectBox 부분 데이터 삭제
			
				$(selectgroup).append("<option value = "+userlist+">"+"전체 선택"+"</option>"); // 전체 선택 옵션 값 넣어줌
			for(var i=0; i<data.length; i++){
				$(selectgroup).append("<option value = "+data[i].UI_KEYNO+">"+data[i].UI_NAME+"</option>"); // <option>값 넣어줌
		 	}  			 
		 }
	 })	
 }


function selectDelete() {

// 	    $('#UI_KEYNO').val('');  // 그냥 selectbox일 경우 value값 삭제
	    $("#UI_KEYNO").val('').select2(); //select2 일 경우 value값 삭제
// 	    $('#UI_KEYNO').select2('val',null);  //select2 일 경우 value값 삭제 2
	}



// function change(e) {
// 			 var user = ["frer","drrf","fwefwe"];
// 		     var admin = ["석환 발전소", "정미 발전소", "해송 발전소"];
// 		     var target = document.getElementById("UI_KEYNO");
		
// 		     if(e.value == "UIA_AGKGE") var d = user;
// 		     else if(e.value == "UIA_JIPHJ") var d = admin;
		
// 		     target.options.length = 0;
		
// 		     for (x in d) {
// 		         var opt = document.createElement("option");
// 		         opt.value = d[x];
// 		         opt.innerHTML = d[x];
// 		         target.appendChild(opt);
// 		     }   
			 
// 		 }
 
 
</script>
