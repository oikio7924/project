<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>


<script type="text/javascript">
	
	function pf_boardTypeRegist() {
		
		if(!$("#MC_CODENM").val().trim()){
			cf_alert("메인코드 명을 입력해주세요");
			return false;
		} else {
			cf_confirm("메인 코드를 등록하시겠습니까?","success()","exit()");
		}
	}

	//성공 콜백 함수   
	function success() {
		cf_replaceTrim($("#Form"));
		$("#Form").attr("action", "/dyAdmin/admin/code/main/insert.do");
		$("#Form").submit();
	}
	//실패 콜백 함수   
	function exit() {
		return false;
	}
	
</script>


<!-- MAIN CONTENT -->
<div id="content">
	<form:form id="Form" name="Form" method="post" action="">
		<section id="widget-grid" >
			<!-- START ROW -->
			<div class="row">
				<!-- NEW COL START -->
				<article class="col-sm-12 col-md-12 col-lg-12">
					<!-- Widget ID (each widget will need unique ID)-->
					<div class="jarviswidget jarviswidget-color-blueDark" id="BOARD_CODE_REGIST_1"
						data-widget-editbutton="false">
						<!-- widget options:
					usage: <div class="jarviswidget" id="wid-id-0" data-widget-editbutton="false">
	
					data-widget-colorbutton="false"
					data-widget-editbutton="false"
					data-widget-togglebutton="false"
					data-widget-deletebutton="false"
					data-widget-fullscreenbutton="false"
					data-widget-custombutton="false"
					data-widget-collapsed="true"
					data-widget-sortable="false"
	
					-->
						<header>
							<span class="widget-icon"> <i class="fa fa-cog"></i>
							</span>
							<h2>메인 코드 등록</h2>

						</header>

						<!-- widget div-->
						<div>
							<!-- widget edit box -->
							<div class="jarviswidget-editbox">
								<!-- This area used as dropdown edit box -->
							</div>
							<!-- end widget edit box -->
							<div class="widget-body-toolbar bg-color-white">
						<div class="alert alert-info no-margin fade in">
									<button type="button" class="close" data-dismiss="alert">×</button>
									새로운 메인 코드를 등록합니다.
								</div> 
							</div>	
							<!-- widget content -->
							<div class="widget-body no-padding smart-form">
								<fieldset>
									<div class="row">
										<section class="col col-5">
											<span class="nessSpan">*표시는 필수 입력 항목입니다.</span> 
											<label class="input"><i class="icon-prepend fa fa-edit"></i> 
												<input class="checkTrim" type="text" id="MC_CODENM" name="MC_CODENM" placeholder="메인코드명" value="${boardType.BT_TYPE_NAME }"  maxlength="20">
											</label>
										</section>
									</div>
								</fieldset>
								
								<fieldset class="padding-10 text-right"> 
									<button class="btn btn-sm btn-primary" id="Board_Edit"
										type="button" onclick="pf_boardTypeRegist()">
										<i class="fa fa-floppy-o"></i> 저장
									</button>
									<button class="btn btn-sm btn-default" id="Board_Delete"
										type="button" onclick="cf_back('/dyAdmin/admin/code.do')"> 
										 <i class="fa fa-times"></i>취소
									</button> 
								</fieldset>
								
							</div>
							<!-- end widget content -->
						</div>
						<!-- end widget div -->
					</div>
					<!-- end widget -->
				</article>
				<!-- END COL -->
			</div>
		</section>
	</form:form>
</div>
<!-- END MAIN CONTENT -->
