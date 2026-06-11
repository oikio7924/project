<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<style>
    
 .visitor_bar{
	position: relative;
	height: 20px;
}
.visitor_bar span {
    position: absolute;
  	top:6px;
    left: 0;
    height: 15px;
    background: #ddd;
}
.commentStyle, .Menu_name{
	padding: 1%;
} 

.commentStyle pre { padding: 0;} 
.commentStyle:before {content: "*"; position:absolute;left:4px;color:red;}

   
.btnComment{
	w2idth: 100%;
}  
#dt_basic tr, #dt_basic thead tr th{
	text-align: center;
}  
</style>


<form:form id="Form" name="Form" method="post" action="">
	<input type="hidden" name="SM_KEYNO" id="SM_KEYNO" value="" />
	<input type="hidden" name="MN_HOMEDIV_C" id="MN_HOMEDIV_C" value="${MN_HOMEDIV_C}"/>
	<section id="widget-grid" >
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" id="BOARD_TYPE_LIST_1" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-table"></i>
						</span>
						<h2>페이지 평가 내역</h2>
					</header>
					<div class="widget-body " >
						<div class="widget-body-toolbar bg-color-white">
							<div class="alert alert-info no-margin fade in">
								<button type="button" class="close" data-dismiss="alert">×</button>
								페이지 평가 내역
							</div> 
						</div>
						<div class="widget-body-toolbar bg-color-white">
							<div class="row">
								<div class="col-sm-12 col-md-2 text-align-right"
									style="float: right;">
									<div class="btn-group">
									</div>
								</div>
							</div>
						</div>
						<div class="table-responsive">
							<jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
								<jsp:param value="/dyAdmin/operation/pageResearch/pagingAjax.do" name="pagingDataUrl" />
								<jsp:param value="/dyAdmin/operation/pageResearch/excelAjax.do" name="excelDataUrl" />
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

<!-- 팝업 CONTENT -->
<div id="page_comment" title="페이지 평가 결과">
	<div class="widget-body ">
		<fieldset>
			<div class="form-horizontal">
				<fieldset>
					<div class="form-group">
						<label class="col-md-2 control-label">페이지 이름</label>
						<div class="col-md-10 Menu_name">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">코멘트</label>
						<div class="col-md-10 tps_comment">
							
						</div>
					</div>
				</fieldset>
			</div>
		</fieldset>
	</div>
</div>


<script>
$(function(){
	/* 팝업 */
	cf_setttingDialog('#page_comment','결과보기');
	
});

//홈페이지 변경 처리
function pf_changeHomeDiv(value){
	pf_getList();
}

/* 권한 추가 모달창 오픈 */
function pf_viewComment(key){
	$("#page_comment").find(".tps_comment").empty();		
	$.ajax({
		type: "POST",
		url: "/dyAdmin/operation/pageDetail.do",
		data: {
			"key": key
		},
		async:false,
		success : function(data){
			var name = data.MenuName;
			$("#page_comment").find(".Menu_name").text(name);
			var dataList = data.resultList;
			$.each(dataList, function(i){
				var TPS_data = dataList[i];
				var comment = TPS_data.TPS_COMMENT;
				if(comment != ''){
					var temp = "<div class='commentStyle'><div style='width:300px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;'>"+comment+"</div></div>";
				}
				$("#page_comment").find(".tps_comment").append(temp);					
			});
			

			$('#page_comment').dialog('open');
			$('#page_comment input[type=text]').val('');
			$('#page_comment input[type=radio]').prop('checked',false);
		},
		error: function(){
			cf_smallBox('error', '에러발생', 3000,'#d24158');
			return false;
		}
	});
	
}
</script>


