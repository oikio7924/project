<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<div id="content">
	<form:form id="Form" name="Form" method="post" action="">
		<input type="hidden" name="TCGM_KEYNO" id="TCGM_KEYNO" value=""/>
		<input type="hidden" name="homeKey" id="homeKey" value="${homeKey}"/>
		
		<section id="widget-grid" >
			<div class="row">
				<article class="col-sm-12 col-md-12 col-lg-12">
					<div class="jarviswidget jarviswidget-color-blueDark" id="BOARD_TYPE_LIST_1" data-widget-editbutton="false">
						<header>
							<span class="widget-icon"> <i class="fa fa-table"></i>
							</span>
							<h2>카테고리 내역</h2>
						</header>
						<div class="widget-body " >
							<div class="widget-body-toolbar bg-color-white">
								<div class="alert alert-info no-margin fade in">
									<button type="button" class="close" data-dismiss="alert">×</button>
									카테고리 목록입니다. 카테고리를 생성, 관리 할 수 있습니다.
								</div> 
							</div>
							<div class="widget-body-toolbar bg-color-white">
								<div class="row"> 
									<div class="col-sm-12 col-md-4 text-align-right" style="float:right;">
										<div class="btn-group">  
											<button class="btn btn-sm btn-primary" type="button" onclick="pf_CreateFile()">
												<i class="fa fa-file"></i> 전체 배포
											</button> 
										</div>
										<div class="btn-group">  
											<button class="btn btn-sm btn-primary" type="button" onclick="pf_categoryRegist()">
												<i class="fa fa-plus"></i> 카테고리 생성
											</button> 
										</div>
									</div>
								</div>
							</div>
							<div class="table-responsive">
								<jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
									<jsp:param value="/dyAdmin/homepage/popupzone/pagingAjax.do" name="pagingDataUrl" />
									<jsp:param value="/dyAdmin/homepage/board/typeView/excelAjax.do" name="excelDataUrl" />
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




//카테고리 수정페이지 이동
function pf_categoryUpdate(key) {
	$("#TCGM_KEYNO").val(key);
	$("#Form").attr("action", "/dyAdmin/homepage/popupzone/updateView.do");
	$("#Form").submit();
} 

//카테고리 등록페이지 이동 
function pf_categoryRegist() {
	$("#Form").attr("action", "/dyAdmin/homepage/popupzone/insertView.do");
	$("#Form").submit();
}

function pf_CreateFile(key){
		key = key || "";

		if(confirm("파일을 배포하시겠습니까?")) {
		cf_loading();
		
		$.ajax({
		    type   : "post",
		    url    : "/dyAdmin/homepage/popupzone/createFileAjax.do",
		    data   : {"TCGM_KEYNO" : key},
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
				pf_LinkPage();
			})
	}
}

function pf_Copy(key){
	var content = '&lt;c:import url="/common/operation/popupzone/UserViewAjax.do?key='+key+'"/&gt;';
	var temp = content;
	content = content.unescapeHtml();
	if(cf_copyToClipboard(content)){
		cf_smallBox('success', temp+" 복사되었습니다.", 3000);
	}else{
		cf_smallBox('error', "복사하기 기능을 지원하지 않는 브라우저 입니다.", 3000,'#d24158');
	}
	
}


</script>
