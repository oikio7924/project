<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>

section {text-align:left;}

</style>

<form:form id="Form" name="Form" method="post" action="">
	<section id="widget-grid" >
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" id="BOARD_TYPE_LIST_1" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-table"></i>
						</span>
						<h2>활동 기록 리스트</h2>
					</header>
					<div class="widget-body" >
						<div class="widget-body-toolbar bg-color-white smart-form">
							<div class="row">
								<section class="col col-2">홈페이지 
									<label class="select">
										<select class="form-control input-sm" name="AH_HOMEDIV_C" id="AH_HOMEDIV_C" onchange="pf_getList()">
							              	<option value="">선택하세요.</option>
												<c:forEach items="${homeDivList }" var="model">
												<option value="${model.MN_KEYNO }" ${AH_HOMEDIV_C eq model.MN_KEYNO ? 'selected' : '' }>${model.MN_NAME }</option>
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
								<section class="col col-1">아이디
									<label class="input">
										<input type="text" name="UI_ID" id="UI_ID" placeholder="아이디" value="${search.UI_ID}">
									</label>
								</section>
								<section class="col col-2">
									<div class="btn-group" style="width: 100%;padding-top:18px;">  
											<button class="btn btn-sm btn-primary" onclick="pf_LinkPage()" type="button" style="margin-right:10px;">
												<i class="fa fa-floppy-o"></i> 조회
											</button>
									</div>
								</section>								
							</div>
						</div>
						<div class="table-responsive">
							<jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
								<jsp:param value="/dyAdmin/statistics/log/pagingAjax.do" name="pagingDataUrl" />
								<jsp:param value="/dyAdmin/statistics/log/excelAjax.do" name="excelDataUrl" />
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

<script type="text/javascript">
function pf_searchDate(object){
	pf_settingSearchDate(object);
	pf_LinkPage();
}
</script>