<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<div id="content">
	<form:form id="Form" name="Form" method="post" action="">
		<input type="hidden" name="SMT_KEYNO" id="SMT_KEYNO" value="" />
		<input type="hidden" name ="action" id="action" value="" />
		<section id="widget-grid" >
			<div class="row">
				<article class="col-sm-12 col-md-12 col-lg-12">
					<div class="jarviswidget jarviswidget-color-blueDark" id="BOARD_TYPE_LIST_1" data-widget-editbutton="false">
						<header>
							<span class="widget-icon"> <i class="fa fa-table"></i>
							</span>
							<h2>메뉴 스킨 내역</h2>
						</header>
						<div class="widget-body " >
							<div class="widget-body-toolbar bg-color-white">
								<div class="alert alert-info no-margin fade in">
									<button type="button" class="close" data-dismiss="alert">×</button>
									메뉴 스킨 목록입니다. 메인 페이지 목록 형태의 메뉴 스킨을 생성, 관리 할 수 있습니다.
								</div> 
							</div>
							<div class="widget-body-toolbar bg-color-white">
								<div class="row"> 
									<div class="col-sm-12 col-md-4 text-align-right" style="float:right;">
										<div class="btn-group">  
											<button class="btn btn-sm btn-primary" type="button" onclick="pf_PublishFile()">
												<i class="fa fa-file"></i> 전체 배포
											</button> 
										</div>
										<div class="btn-group">  
											<button class="btn btn-sm btn-primary" type="button" onclick="pf_MenuTemplateRegist()">
												<i class="fa fa-plus"></i> 메뉴 스킨 생성
											</button> 
										</div>
									</div>
								</div>
							</div>
							<div class="table-responsive">
								<jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
									<jsp:param value="/dyAdmin/homepage/menumanage/template/pagingAjax.do" name="pagingDataUrl" />
						
								</jsp:include>
								<fieldset id="tableWrap">
								</fieldset>
							</div>
						</div>
					</div>
				</article>
			</div>
		</section>
	</form:form>
</div>

<script type="text/javascript">




//미니게시판 수정페이지 이동
function pf_menuTemplateUpdate(key) {
	$("#SMT_KEYNO").val(key);
	$("#action").val('update');
	$("#Form").attr("action", "/dyAdmin/homepage/menumanage/template/actionView.do");
	$("#Form").submit();
} 

//미니게시판 등록페이지 이동 
function pf_MenuTemplateRegist() {
	
	$("#action").val('insert');
	$("#Form").attr("action", "/dyAdmin/homepage/menumanage/template/actionView.do");
	$("#Form").submit();
}

function pf_PublishFile(key){
	var msg = "";
	if(key){
		msg = "파일을 배포 하시겠습니까?";
	}else{
		msg = "전체 배포 하시겠습니까?";
		key = "";
	}
	
	if(confirm(msg)) {
		cf_loading();
		
		$.ajax({
		    type   : "post",
		    url    : "/dyAdmin/homepage/menumanage/template/publishAjax.do",
		    data   : {"SMT_KEYNO" : key},
		    async  : false ,
		    success:function(data){
		    	if(data) {
		    		cf_smallBox('ajax', "파일을 배포하였습니다.", 3000);
		    	} else {
		    		cf_smallBox('error', "파일 배포 실패", 3000,'#d24158');
		    	}
		    },
		    error: function(jqXHR, textStatus, exception) {
		    	cf_smallBox('error', "알수없는 에러, 관리자에게 문의하세요.", 3000,'#d24158');
		    }
		  }).done(function(){
				cf_loading_out();
			})
	}
}

function pf_Copy(key){
	var content = '&lt;c:import url="/common/Menu/MenuHeaderTemplate/UserViewAjax.do?key='+key+'"/&gt;';
	var copy = content;
	content = content.unescapeHtml();
	
	if(cf_copyToClipboard(content)){
		cf_smallBox('success', copy, 3000);
	}else{
		cf_smallBox('error', "복사하기 기능을 지원하지 않는 브라우저 입니다.", 3000,'#d24158');
	}
	
}


</script>
