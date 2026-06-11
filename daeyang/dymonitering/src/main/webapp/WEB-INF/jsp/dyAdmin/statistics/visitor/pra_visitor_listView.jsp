<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>
.btn_margin {
	margin: 10px;
}

.visitor li, .visitorM li {
	margin: 3px;
	background-color: blue;
	color: #333;
	float: left;
}

.visitor li.active button, .visitorM li.active button {
	background-color: #d24158;
}

.visitor li, .visitorM li {
	text-decoration: none;
}

.visitor_bar {
	position: relative;
	height: 20px;
	margin: 0;
}

.visitor_bar span {
	position: absolute;
	top: 6px;
	left: 0;
	height: 15px;
	background: #ddd;
}
#footercolumn{
	background-color: #3a3a3a78;
    color: #fff;
}
#pctable td, th {
	padding-left: 10px;
}

.lasttr {
	text-align: center;
}

.mytab li a, .mytabM li a {
	background-color: #ddd;
}
/* .nav-tabs li a {
  
} */
</style>


<form:form id="Form" name="Form" method="post">
	<input type="hidden" name="CASE" id="CASE" value="접속자" />
	<input type="hidden" name="searchbot" value="${searchbot }" />
	<section id="widget-grid" >
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-table"></i>
						</span>
						<h2>방문자 보기</h2>
					</header>
					<div class="widget-body" >
						<div class="widget-body-toolbar bg-color-white smart-form">
							<div class="row" style="margin-top:10px;text-align:left;">
								<section class="col col-2">홈페이지
									<label class="select">
										<select class="form-control input-sm" name="AH_HOMEDIV_C" id="AH_HOMEDIV_C" onchange="pf_search()">
							              	<option value="">선택하세요.</option>
									<c:forEach items="${homeDivList }" var="model">
										<option value="${model.MN_KEYNO }" ${MN_HOMEDIV_C eq model.MN_KEYNO ? 'selected' : '' }>${model.MN_NAME }</option>
									</c:forEach>								                
							            </select> <i></i> 
									</label>
								</section>
								<section class="col col-2">시작일시
									<label class="input"> <i class="icon-append fa fa-calendar"></i>
										<input type="text" name="searchBeginDate" id="searchBeginDate" placeholder="시작일시" value="${search.searchBeginDate}">
									</label>
								</section>
								<section class="col" style="text-align:center;line-height:32px;padding-top:18px;">
									~
								</section>
								<section class="col col-2">종료일시
									<label class="input"> <i class="icon-append fa fa-calendar"></i>
										<input type="text" name="searchEndDate" id="searchEndDate" placeholder="종료일시" value="${search.searchEndDate}">
									</label>
								</section>
								<section class="col col-2">검색기간
									<label class="select">
										<select class="form-control input-sm" name="orderCondition" id="searchDate" onchange="pf_searchDate(this.value)">
							              	<option value="">선택하세요.</option>
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
								<section class="col col-1">접속 단말기
									<label class="select">
										<select class="form-control input-sm" name="AH_DEVICE" id="AH_DEVICE" onchange="pf_search()">
							              	<option value="">선택하세요.</option>
							              	<option value="PC" ${search.AH_DEVICE eq 'PC'? 'selected':'' }>PC</option>
							              	<option value="모바일" ${search.AH_DEVICE eq '모바일'? 'selected':'' }>모바일</option>
							            </select> <i></i> 
									</label>
								</section>
								<section class="col col-2">
									<div class="btn-group" style="width: 100%;padding-top:18px;">  
											<button class="btn btn-sm btn-primary" onclick="pf_search()" type="button" style="margin-right:10px;">
												<i class="fa fa-floppy-o"></i> 조회
											</button>
									</div>
								</section>
							</div>
						</div>
						<div class="tab-content">
							<div class="tab-pane fade in active" id="hr1">
								<ul class="mytab nav nav-tabs">
									<li class="active"><a href="javascript:;">접속자</a></li>
									<li><a href="javascript:;">도메인</a></li>
									<li><a href="javascript:;">브라우저</a></li>
									<li><a href="javascript:;">운영체제</a></li>
									<li><a href="javascript:;">시간</a></li>
									<li><a href="javascript:;">요일</a></li>
									<li><a href="javascript:;">일</a></li>
									<li><a href="javascript:;">월</a></li>
									<li><a href="javascript:;">년</a></li>
								</ul>
								<div class="tab-content padding-10">
									<div class="table-responsive">
										<jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
											<jsp:param value="/dyAdmin/statistics/visitor/pagingAjax.do" name="pagingDataUrl" />
											<jsp:param value="/dyAdmin/statistics/visitor/excelAjax.do" name="excelDataUrl" />
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
		$('#CASE').val($(this).html());
		pf_search();
		$('.mytab li').removeClass('active');
		$(this).parent().addClass('active')
	});
						
});

function pf_search() {
	if ($('#CASE').val() != '접속자') {
        cf_loading();
		pf_getHtml();
	} else {
		pf_LinkPage();
	}
}

function pf_getHtml() {
	$.ajax({
		type : "post",
		data : $('#Form').serialize(),
		url : "/dyAdmin/statistics/visitor/dataAjax.do",
		complete : function(XMLHttpRequest, statusText, response, data) {
		},
		success : function(data, textStatus, xhr) {
			$("#tableWrap").html(data);

		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			alert('에러 발생. 관리자에게 문의하세요.')
		}
    }).done(function(){
        cf_loading_out();
	});
}

function pf_searchDate(object){
	pf_settingSearchDate(object);
	pf_search();
}

</script>

