<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>
.marginTop {margin-top: 10px;}
.visitor li, .visitorM li {margin: 3px;background-color: blue;color: #333;float: left;}
.visitor li.active button, .visitorM li.active button {background-color: #d24158;}
.visitor li, .visitorM li {text-decoration: none;}
.visitor_bar {position: relative;height: 20px;margin: 0;}
.visitor_bar span {position: absolute;top: 6px;left: 0;height: 15px;background: #ddd;}
#footercolumn{background-color: #3a3a3a78;color: #fff;}
#pctable td, th {padding-left: 10px;}
.lasttr {text-align: center;}
.mytab li a, .mytabM li a {background-color: #ddd;}
</style>


<form:form id="Form" name="Form" method="post">
	<input type="hidden" name="STM_CASE" id="STM_CASE" value="일자" />
	<input type="hidden" name="STM_TYPE" id="STM_TYPE" value="B" />
	<input type="hidden" name="MENU_MAIN_NAME" id="MENU_MAIN_NAME" value="" />
	<input type="hidden" name="MAIN_NAME" id="MAIN_NAME" value="" />
	<input type="hidden" name="SUB_NAME" id="SUB_NAME" value="" />
	<section id="widget-grid" >
		<div class="row">
			<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-table"></i>
						</span>
						<h2>게시글 조회 카운터 보기</h2>
					</header>
					<div class="jarviswidget-editbox"></div>
					<div class="widget-body">
						<div class="widget-body-toolbar bg-color-white">
							<div class="alert alert-info no-margin">
								게시글 조회 카운터를 확인합니다.
							</div>
						</div>
						<div class="smart-form">
							<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 marginTop">
							
								<section class="col col-lg-2">
									<label class="select">
										<select class="form-control input-sm" id="MENU_DIV" name="MENU_DIV" onchange="pf_selectMenu(this.value, 'board', 'BOARD_DIV');">
											<option value="">메뉴 전체</option>
											<c:forEach items="${boardMN }" var="model">
												<option value="${model.MN_KEYNO }">${model.MN_NAME }</option>
											</c:forEach>
									</select> <i></i> 
									</label>
								</section>
								
								<section class="col" >
								</section>
								
								<section class="col col-lg-5" style="margin-left: 6px;">
									<label class="select">
										<select class="form-control input-sm" id="BOARD_DIV" name="BOARD_DIV">
											<option value="">목록 전체</option>
									</select> <i></i> 
									</label>
								</section>
							</div>
							<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
								<section class="col col-lg-2">
									<label class="input"> <i class="icon-append fa fa-calendar"></i>
										<input type="text" name="searchBeginDate" id="searchBeginDate" placeholder="시작일시" value="${search.searchBeginDate}">
									</label>
								</section>
								<section class="col" style="line-height:32px;">
									~
								</section>
								<section class="col col-lg-2">
									<label class="input"> <i class="icon-append fa fa-calendar"></i>
										<input type="text" name="searchEndDate" id="searchEndDate" placeholder="종료일시" value="${search.searchEndDate}">
									</label>
								</section>
								<section class="col col-xs-12 col-sm-5 col-md-5 col-lg-2">
									<label class="select">
										<select class="form-control input-sm" name="orderCondition" id="searchDate" onchange="pf_settingSearchDate(this.value)">
							              	<option value="">검색기간 선택</option>
							                <option value="1" ${search.orderCondition eq '1'? 'selected':'' }>오늘</option>
							                <option value="2" ${search.orderCondition eq '2'? 'selected':'' }>이번달</option>
							                <option value="3" ${search.orderCondition eq '3'? 'selected':'' }>일주일</option>
							                <option value="4" ${search.orderCondition eq '4'? 'selected':'' }>보름</option>
							                <option value="5" ${search.orderCondition eq '5'? 'selected':'' }>1개월</option>
							                <option value="6" ${search.orderCondition eq '6'? 'selected':'' }>2개월</option>
							                <option value="7" ${search.orderCondition eq '7'? 'selected':'' }>3개월</option>
							                <option value="8" ${search.orderCondition eq '8'? 'selected':'' }>6개월</option>
							                <option value="9" ${search.orderCondition eq '9'? 'selected':'' }>1년</option>
							                <option value="10" ${search.orderCondition eq '10'? 'selected':'' }>전체</option>
							            </select> <i></i> 
									</label>
								</section>
								<section class="col col-xs-12 col-sm-5 col-md-5 col-lg-2">
									<div class="btn-group" style="width: 100%;">  
										<button class="btn btn-sm btn-primary" type="button" onclick="pf_search();">
											<i class="fa fa-plus"></i> 검색
										</button>
									</div>
								</section>
							</div>
						</div>
						<div class="tab-content">
							<div class="tab-pane fade in active" id="hr1">
								<ul class="mytab nav nav-tabs">
									<li><a href="javascript:;">시간</a></li>
									<li><a href="javascript:;">요일</a></li>
									<li class="active"><a href="javascript:;">일자</a></li>
									<li><a href="javascript:;">월</a></li>
									<li><a href="javascript:;">년</a></li>
								</ul>
								<div class="tab-content padding-10">
									<div class="table-responsive">
										<jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_statistics_paging.jsp" flush="true">
											<jsp:param value="excelAjax.do" name="excelDataUrl" />
										</jsp:include>
										<fieldset id="tableWrap">
										</fieldset>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</article>
		</div>
	</section>
</form:form>

<script type="text/javascript">

$(document).ready(function() {
	//조회탭 
	$('.mytab li a').click(function() {
		$('#STM_CASE').val($(this).html());
		pf_search();
		$('.mytab li').removeClass('active');
		$(this).parent().addClass('active')
	});
						
});

function pf_search() {
	pf_getHtml();
}

function pf_selectMenu(value, type, id){
	var title = '';
	if(type == 'menu'){
		title = '메뉴 전체';
	}else if(type == 'board'){
		title = '게시글 전체';
	}
	
	$.ajax({
		type : "post",
		data : {
			"KEY" : value,
			"type" : type
		},
		url : "/dyAdmin/statistics/getmenuAjax.do",
		async : false,
		success : function(data) {
			var temp = '<option value="">'+title+' 전체</option>';
			if(data != null && data.length > 0){
				$.each(data,function(i){
					var name = data[i].MENU_NAME;
					var key = data[i].MENU_KEY;
					temp += '<option value="'+key+'">'+name+'</option>';
				});
			}else{
				if(type == 'menu'){
					$('#BOARD_DIV').html(temp);
				}	
			}
			$('#'+id).html(temp);
		},
		error : function(xhr, status, error) {
			cf_smallBox('error', '에러발생', 3000,'#d24158'); 
		}
	});
}
</script>
